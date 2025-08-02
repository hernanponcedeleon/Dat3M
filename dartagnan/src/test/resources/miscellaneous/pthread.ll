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
@cond_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !140
@cond = dso_local global %union.pthread_cond_t zeroinitializer, align 8, !dbg !175
@__func__.cond_test = private unnamed_addr constant [10 x i8] c"cond_test\00", align 1, !dbg !92
@.str.4 = private unnamed_addr constant [18 x i8] c"result == message\00", align 1, !dbg !94
@__func__.rwlock_init = private unnamed_addr constant [12 x i8] c"rwlock_init\00", align 1, !dbg !99
@__func__.rwlock_destroy = private unnamed_addr constant [15 x i8] c"rwlock_destroy\00", align 1, !dbg !101
@__func__.rwlock_wrlock = private unnamed_addr constant [14 x i8] c"rwlock_wrlock\00", align 1, !dbg !103
@__func__.rwlock_rdlock = private unnamed_addr constant [14 x i8] c"rwlock_rdlock\00", align 1, !dbg !105
@__func__.rwlock_unlock = private unnamed_addr constant [14 x i8] c"rwlock_unlock\00", align 1, !dbg !107
@__func__.rwlock_test = private unnamed_addr constant [12 x i8] c"rwlock_test\00", align 1, !dbg !109
@latest_thread = dso_local global i64 0, align 8, !dbg !209
@local_data = dso_local global i32 0, align 4, !dbg !213
@__func__.key_worker = private unnamed_addr constant [11 x i8] c"key_worker\00", align 1, !dbg !111
@.str.5 = private unnamed_addr constant [28 x i8] c"my_local_data == &my_secret\00", align 1, !dbg !113
@__func__.key_test = private unnamed_addr constant [9 x i8] c"key_test\00", align 1, !dbg !118
@__func__.detach_test_detach = private unnamed_addr constant [19 x i8] c"detach_test_detach\00", align 1, !dbg !121
@.str.6 = private unnamed_addr constant [12 x i8] c"status != 0\00", align 1, !dbg !126
@__func__.detach_test_attr = private unnamed_addr constant [17 x i8] c"detach_test_attr\00", align 1, !dbg !128
@.str.7 = private unnamed_addr constant [54 x i8] c"status == 0 && detachstate == PTHREAD_CREATE_JOINABLE\00", align 1, !dbg !133
@.str.8 = private unnamed_addr constant [54 x i8] c"status == 0 && detachstate == PTHREAD_CREATE_DETACHED\00", align 1, !dbg !138

; Function Attrs: noinline nounwind uwtable
define dso_local i64 @thread_create(ptr noundef %0, ptr noundef %1) #0 !dbg !224 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i64, align 8
  %6 = alloca %union.pthread_attr_t, align 8
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !231, !DIExpression(), !232)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !233, !DIExpression(), !234)
    #dbg_declare(ptr %5, !235, !DIExpression(), !236)
    #dbg_declare(ptr %6, !237, !DIExpression(), !246)
  %8 = call i32 @pthread_attr_init(ptr noundef %6) #6, !dbg !247
    #dbg_declare(ptr %7, !248, !DIExpression(), !249)
  %9 = load ptr, ptr %3, align 8, !dbg !250
  %10 = load ptr, ptr %4, align 8, !dbg !251
  %11 = call i32 @pthread_create(ptr noundef %5, ptr noundef %6, ptr noundef %9, ptr noundef %10) #7, !dbg !252
  store i32 %11, ptr %7, align 4, !dbg !249
  %12 = load i32, ptr %7, align 4, !dbg !253
  %13 = icmp eq i32 %12, 0, !dbg !253
  %14 = xor i1 %13, true, !dbg !253
  %15 = zext i1 %14 to i32, !dbg !253
  %16 = sext i32 %15 to i64, !dbg !253
  %17 = icmp ne i64 %16, 0, !dbg !253
  br i1 %17, label %18, label %20, !dbg !253

18:                                               ; preds = %2
  call void @__assert_rtn(ptr noundef @__func__.thread_create, ptr noundef @.str, i32 noundef 18, ptr noundef @.str.1) #8, !dbg !253
  unreachable, !dbg !253

19:                                               ; No predecessors!
  br label %21, !dbg !253

20:                                               ; preds = %2
  br label %21, !dbg !253

21:                                               ; preds = %20, %19
  %22 = call i32 @pthread_attr_destroy(ptr noundef %6) #6, !dbg !254
  %23 = load i64, ptr %5, align 8, !dbg !255
  ret i64 %23, !dbg !256
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
define dso_local ptr @thread_join(i64 noundef %0) #0 !dbg !257 {
  %2 = alloca i64, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store i64 %0, ptr %2, align 8
    #dbg_declare(ptr %2, !260, !DIExpression(), !261)
    #dbg_declare(ptr %3, !262, !DIExpression(), !263)
    #dbg_declare(ptr %4, !264, !DIExpression(), !265)
  %5 = load i64, ptr %2, align 8, !dbg !266
  %6 = call i32 @pthread_join(i64 noundef %5, ptr noundef %3), !dbg !267
  store i32 %6, ptr %4, align 4, !dbg !265
  %7 = load i32, ptr %4, align 4, !dbg !268
  %8 = icmp eq i32 %7, 0, !dbg !268
  %9 = xor i1 %8, true, !dbg !268
  %10 = zext i1 %9 to i32, !dbg !268
  %11 = sext i32 %10 to i64, !dbg !268
  %12 = icmp ne i64 %11, 0, !dbg !268
  br i1 %12, label %13, label %15, !dbg !268

13:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.thread_join, ptr noundef @.str, i32 noundef 27, ptr noundef @.str.1) #8, !dbg !268
  unreachable, !dbg !268

14:                                               ; No predecessors!
  br label %16, !dbg !268

15:                                               ; preds = %1
  br label %16, !dbg !268

16:                                               ; preds = %15, %14
  %17 = load ptr, ptr %3, align 8, !dbg !269
  ret ptr %17, !dbg !270
}

declare i32 @pthread_join(i64 noundef, ptr noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_init(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) #0 !dbg !271 {
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca %union.pthread_mutexattr_t, align 4
  store ptr %0, ptr %5, align 8
    #dbg_declare(ptr %5, !275, !DIExpression(), !276)
  store i32 %1, ptr %6, align 4
    #dbg_declare(ptr %6, !277, !DIExpression(), !278)
  store i32 %2, ptr %7, align 4
    #dbg_declare(ptr %7, !279, !DIExpression(), !280)
  store i32 %3, ptr %8, align 4
    #dbg_declare(ptr %8, !281, !DIExpression(), !282)
    #dbg_declare(ptr %9, !283, !DIExpression(), !284)
    #dbg_declare(ptr %10, !285, !DIExpression(), !286)
    #dbg_declare(ptr %11, !287, !DIExpression(), !296)
  %12 = call i32 @pthread_mutexattr_init(ptr noundef %11) #6, !dbg !297
  store i32 %12, ptr %9, align 4, !dbg !298
  %13 = load i32, ptr %9, align 4, !dbg !299
  %14 = icmp eq i32 %13, 0, !dbg !299
  %15 = xor i1 %14, true, !dbg !299
  %16 = zext i1 %15 to i32, !dbg !299
  %17 = sext i32 %16 to i64, !dbg !299
  %18 = icmp ne i64 %17, 0, !dbg !299
  br i1 %18, label %19, label %21, !dbg !299

19:                                               ; preds = %4
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 47, ptr noundef @.str.1) #8, !dbg !299
  unreachable, !dbg !299

20:                                               ; No predecessors!
  br label %22, !dbg !299

21:                                               ; preds = %4
  br label %22, !dbg !299

22:                                               ; preds = %21, %20
  %23 = load i32, ptr %6, align 4, !dbg !300
  %24 = call i32 @pthread_mutexattr_settype(ptr noundef %11, i32 noundef %23) #6, !dbg !301
  store i32 %24, ptr %9, align 4, !dbg !302
  %25 = load i32, ptr %9, align 4, !dbg !303
  %26 = icmp eq i32 %25, 0, !dbg !303
  %27 = xor i1 %26, true, !dbg !303
  %28 = zext i1 %27 to i32, !dbg !303
  %29 = sext i32 %28 to i64, !dbg !303
  %30 = icmp ne i64 %29, 0, !dbg !303
  br i1 %30, label %31, label %33, !dbg !303

31:                                               ; preds = %22
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 50, ptr noundef @.str.1) #8, !dbg !303
  unreachable, !dbg !303

32:                                               ; No predecessors!
  br label %34, !dbg !303

33:                                               ; preds = %22
  br label %34, !dbg !303

34:                                               ; preds = %33, %32
  %35 = call i32 @pthread_mutexattr_gettype(ptr noundef %11, ptr noundef %10) #6, !dbg !304
  store i32 %35, ptr %9, align 4, !dbg !305
  %36 = load i32, ptr %9, align 4, !dbg !306
  %37 = icmp eq i32 %36, 0, !dbg !306
  %38 = xor i1 %37, true, !dbg !306
  %39 = zext i1 %38 to i32, !dbg !306
  %40 = sext i32 %39 to i64, !dbg !306
  %41 = icmp ne i64 %40, 0, !dbg !306
  br i1 %41, label %42, label %44, !dbg !306

42:                                               ; preds = %34
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 52, ptr noundef @.str.1) #8, !dbg !306
  unreachable, !dbg !306

43:                                               ; No predecessors!
  br label %45, !dbg !306

44:                                               ; preds = %34
  br label %45, !dbg !306

45:                                               ; preds = %44, %43
  %46 = load i32, ptr %7, align 4, !dbg !307
  %47 = call i32 @pthread_mutexattr_setprotocol(ptr noundef %11, i32 noundef %46) #6, !dbg !308
  store i32 %47, ptr %9, align 4, !dbg !309
  %48 = load i32, ptr %9, align 4, !dbg !310
  %49 = icmp eq i32 %48, 0, !dbg !310
  %50 = xor i1 %49, true, !dbg !310
  %51 = zext i1 %50 to i32, !dbg !310
  %52 = sext i32 %51 to i64, !dbg !310
  %53 = icmp ne i64 %52, 0, !dbg !310
  br i1 %53, label %54, label %56, !dbg !310

54:                                               ; preds = %45
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 55, ptr noundef @.str.1) #8, !dbg !310
  unreachable, !dbg !310

55:                                               ; No predecessors!
  br label %57, !dbg !310

56:                                               ; preds = %45
  br label %57, !dbg !310

57:                                               ; preds = %56, %55
  %58 = call i32 @pthread_mutexattr_getprotocol(ptr noundef %11, ptr noundef %10) #6, !dbg !311
  store i32 %58, ptr %9, align 4, !dbg !312
  %59 = load i32, ptr %9, align 4, !dbg !313
  %60 = icmp eq i32 %59, 0, !dbg !313
  %61 = xor i1 %60, true, !dbg !313
  %62 = zext i1 %61 to i32, !dbg !313
  %63 = sext i32 %62 to i64, !dbg !313
  %64 = icmp ne i64 %63, 0, !dbg !313
  br i1 %64, label %65, label %67, !dbg !313

65:                                               ; preds = %57
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 57, ptr noundef @.str.1) #8, !dbg !313
  unreachable, !dbg !313

66:                                               ; No predecessors!
  br label %68, !dbg !313

67:                                               ; preds = %57
  br label %68, !dbg !313

68:                                               ; preds = %67, %66
  %69 = load i32, ptr %8, align 4, !dbg !314
  %70 = call i32 @pthread_mutexattr_setprioceiling(ptr noundef %11, i32 noundef %69) #6, !dbg !315
  store i32 %70, ptr %9, align 4, !dbg !316
  %71 = load i32, ptr %9, align 4, !dbg !317
  %72 = icmp eq i32 %71, 0, !dbg !317
  %73 = xor i1 %72, true, !dbg !317
  %74 = zext i1 %73 to i32, !dbg !317
  %75 = sext i32 %74 to i64, !dbg !317
  %76 = icmp ne i64 %75, 0, !dbg !317
  br i1 %76, label %77, label %79, !dbg !317

77:                                               ; preds = %68
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 60, ptr noundef @.str.1) #8, !dbg !317
  unreachable, !dbg !317

78:                                               ; No predecessors!
  br label %80, !dbg !317

79:                                               ; preds = %68
  br label %80, !dbg !317

80:                                               ; preds = %79, %78
  %81 = call i32 @pthread_mutexattr_getprioceiling(ptr noundef %11, ptr noundef %10) #6, !dbg !318
  store i32 %81, ptr %9, align 4, !dbg !319
  %82 = load i32, ptr %9, align 4, !dbg !320
  %83 = icmp eq i32 %82, 0, !dbg !320
  %84 = xor i1 %83, true, !dbg !320
  %85 = zext i1 %84 to i32, !dbg !320
  %86 = sext i32 %85 to i64, !dbg !320
  %87 = icmp ne i64 %86, 0, !dbg !320
  br i1 %87, label %88, label %90, !dbg !320

88:                                               ; preds = %80
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 62, ptr noundef @.str.1) #8, !dbg !320
  unreachable, !dbg !320

89:                                               ; No predecessors!
  br label %91, !dbg !320

90:                                               ; preds = %80
  br label %91, !dbg !320

91:                                               ; preds = %90, %89
  %92 = load ptr, ptr %5, align 8, !dbg !321
  %93 = call i32 @pthread_mutex_init(ptr noundef %92, ptr noundef %11) #6, !dbg !322
  store i32 %93, ptr %9, align 4, !dbg !323
  %94 = load i32, ptr %9, align 4, !dbg !324
  %95 = icmp eq i32 %94, 0, !dbg !324
  %96 = xor i1 %95, true, !dbg !324
  %97 = zext i1 %96 to i32, !dbg !324
  %98 = sext i32 %97 to i64, !dbg !324
  %99 = icmp ne i64 %98, 0, !dbg !324
  br i1 %99, label %100, label %102, !dbg !324

100:                                              ; preds = %91
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 65, ptr noundef @.str.1) #8, !dbg !324
  unreachable, !dbg !324

101:                                              ; No predecessors!
  br label %103, !dbg !324

102:                                              ; preds = %91
  br label %103, !dbg !324

103:                                              ; preds = %102, %101
  %104 = call i32 @pthread_mutexattr_destroy(ptr noundef %11) #6, !dbg !325
  store i32 %104, ptr %9, align 4, !dbg !326
  %105 = load i32, ptr %9, align 4, !dbg !327
  %106 = icmp eq i32 %105, 0, !dbg !327
  %107 = xor i1 %106, true, !dbg !327
  %108 = zext i1 %107 to i32, !dbg !327
  %109 = sext i32 %108 to i64, !dbg !327
  %110 = icmp ne i64 %109, 0, !dbg !327
  br i1 %110, label %111, label %113, !dbg !327

111:                                              ; preds = %103
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 67, ptr noundef @.str.1) #8, !dbg !327
  unreachable, !dbg !327

112:                                              ; No predecessors!
  br label %114, !dbg !327

113:                                              ; preds = %103
  br label %114, !dbg !327

114:                                              ; preds = %113, %112
  ret void, !dbg !328
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
define dso_local void @mutex_destroy(ptr noundef %0) #0 !dbg !329 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !332, !DIExpression(), !333)
    #dbg_declare(ptr %3, !334, !DIExpression(), !335)
  %4 = load ptr, ptr %2, align 8, !dbg !336
  %5 = call i32 @pthread_mutex_destroy(ptr noundef %4) #6, !dbg !337
  store i32 %5, ptr %3, align 4, !dbg !335
  %6 = load i32, ptr %3, align 4, !dbg !338
  %7 = icmp eq i32 %6, 0, !dbg !338
  %8 = xor i1 %7, true, !dbg !338
  %9 = zext i1 %8 to i32, !dbg !338
  %10 = sext i32 %9 to i64, !dbg !338
  %11 = icmp ne i64 %10, 0, !dbg !338
  br i1 %11, label %12, label %14, !dbg !338

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_destroy, ptr noundef @.str, i32 noundef 73, ptr noundef @.str.1) #8, !dbg !338
  unreachable, !dbg !338

13:                                               ; No predecessors!
  br label %15, !dbg !338

14:                                               ; preds = %1
  br label %15, !dbg !338

15:                                               ; preds = %14, %13
  ret void, !dbg !339
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_lock(ptr noundef %0) #0 !dbg !340 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !341, !DIExpression(), !342)
    #dbg_declare(ptr %3, !343, !DIExpression(), !344)
  %4 = load ptr, ptr %2, align 8, !dbg !345
  %5 = call i32 @pthread_mutex_lock(ptr noundef %4) #7, !dbg !346
  store i32 %5, ptr %3, align 4, !dbg !344
  %6 = load i32, ptr %3, align 4, !dbg !347
  %7 = icmp eq i32 %6, 0, !dbg !347
  %8 = xor i1 %7, true, !dbg !347
  %9 = zext i1 %8 to i32, !dbg !347
  %10 = sext i32 %9 to i64, !dbg !347
  %11 = icmp ne i64 %10, 0, !dbg !347
  br i1 %11, label %12, label %14, !dbg !347

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_lock, ptr noundef @.str, i32 noundef 79, ptr noundef @.str.1) #8, !dbg !347
  unreachable, !dbg !347

13:                                               ; No predecessors!
  br label %15, !dbg !347

14:                                               ; preds = %1
  br label %15, !dbg !347

15:                                               ; preds = %14, %13
  ret void, !dbg !348
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @mutex_trylock(ptr noundef %0) #0 !dbg !349 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !353, !DIExpression(), !354)
    #dbg_declare(ptr %3, !355, !DIExpression(), !356)
  %4 = load ptr, ptr %2, align 8, !dbg !357
  %5 = call i32 @pthread_mutex_trylock(ptr noundef %4) #7, !dbg !358
  store i32 %5, ptr %3, align 4, !dbg !356
  %6 = load i32, ptr %3, align 4, !dbg !359
  %7 = icmp eq i32 %6, 0, !dbg !360
  ret i1 %7, !dbg !361
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_trylock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_unlock(ptr noundef %0) #0 !dbg !362 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !363, !DIExpression(), !364)
    #dbg_declare(ptr %3, !365, !DIExpression(), !366)
  %4 = load ptr, ptr %2, align 8, !dbg !367
  %5 = call i32 @pthread_mutex_unlock(ptr noundef %4) #7, !dbg !368
  store i32 %5, ptr %3, align 4, !dbg !366
  %6 = load i32, ptr %3, align 4, !dbg !369
  %7 = icmp eq i32 %6, 0, !dbg !369
  %8 = xor i1 %7, true, !dbg !369
  %9 = zext i1 %8 to i32, !dbg !369
  %10 = sext i32 %9 to i64, !dbg !369
  %11 = icmp ne i64 %10, 0, !dbg !369
  br i1 %11, label %12, label %14, !dbg !369

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_unlock, ptr noundef @.str, i32 noundef 92, ptr noundef @.str.1) #8, !dbg !369
  unreachable, !dbg !369

13:                                               ; No predecessors!
  br label %15, !dbg !369

14:                                               ; preds = %1
  br label %15, !dbg !369

15:                                               ; preds = %14, %13
  ret void, !dbg !370
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_test() #0 !dbg !371 {
  %1 = alloca %union.pthread_mutex_t, align 8
  %2 = alloca %union.pthread_mutex_t, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  %5 = alloca i8, align 1
    #dbg_declare(ptr %1, !374, !DIExpression(), !375)
    #dbg_declare(ptr %2, !376, !DIExpression(), !377)
  call void @mutex_init(ptr noundef %1, i32 noundef 2, i32 noundef 1, i32 noundef 1), !dbg !378
  call void @mutex_init(ptr noundef %2, i32 noundef 1, i32 noundef 2, i32 noundef 2), !dbg !379
  call void @mutex_lock(ptr noundef %1), !dbg !380
    #dbg_declare(ptr %3, !382, !DIExpression(), !383)
  %6 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !384
  %7 = zext i1 %6 to i8, !dbg !383
  store i8 %7, ptr %3, align 1, !dbg !383
  %8 = load i8, ptr %3, align 1, !dbg !385
  %9 = trunc i8 %8 to i1, !dbg !385
  %10 = xor i1 %9, true, !dbg !385
  %11 = xor i1 %10, true, !dbg !385
  %12 = zext i1 %11 to i32, !dbg !385
  %13 = sext i32 %12 to i64, !dbg !385
  %14 = icmp ne i64 %13, 0, !dbg !385
  br i1 %14, label %15, label %17, !dbg !385

15:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 106, ptr noundef @.str.2) #8, !dbg !385
  unreachable, !dbg !385

16:                                               ; No predecessors!
  br label %18, !dbg !385

17:                                               ; preds = %0
  br label %18, !dbg !385

18:                                               ; preds = %17, %16
  call void @mutex_unlock(ptr noundef %1), !dbg !386
  call void @mutex_lock(ptr noundef %2), !dbg !387
    #dbg_declare(ptr %4, !389, !DIExpression(), !391)
  %19 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !392
  %20 = zext i1 %19 to i8, !dbg !391
  store i8 %20, ptr %4, align 1, !dbg !391
  %21 = load i8, ptr %4, align 1, !dbg !393
  %22 = trunc i8 %21 to i1, !dbg !393
  %23 = xor i1 %22, true, !dbg !393
  %24 = zext i1 %23 to i32, !dbg !393
  %25 = sext i32 %24 to i64, !dbg !393
  %26 = icmp ne i64 %25, 0, !dbg !393
  br i1 %26, label %27, label %29, !dbg !393

27:                                               ; preds = %18
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 115, ptr noundef @.str.3) #8, !dbg !393
  unreachable, !dbg !393

28:                                               ; No predecessors!
  br label %30, !dbg !393

29:                                               ; preds = %18
  br label %30, !dbg !393

30:                                               ; preds = %29, %28
  call void @mutex_unlock(ptr noundef %1), !dbg !394
    #dbg_declare(ptr %5, !395, !DIExpression(), !397)
  %31 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !398
  %32 = zext i1 %31 to i8, !dbg !397
  store i8 %32, ptr %5, align 1, !dbg !397
  %33 = load i8, ptr %5, align 1, !dbg !399
  %34 = trunc i8 %33 to i1, !dbg !399
  %35 = xor i1 %34, true, !dbg !399
  %36 = zext i1 %35 to i32, !dbg !399
  %37 = sext i32 %36 to i64, !dbg !399
  %38 = icmp ne i64 %37, 0, !dbg !399
  br i1 %38, label %39, label %41, !dbg !399

39:                                               ; preds = %30
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 121, ptr noundef @.str.3) #8, !dbg !399
  unreachable, !dbg !399

40:                                               ; No predecessors!
  br label %42, !dbg !399

41:                                               ; preds = %30
  br label %42, !dbg !399

42:                                               ; preds = %41, %40
  call void @mutex_unlock(ptr noundef %1), !dbg !400
  call void @mutex_unlock(ptr noundef %2), !dbg !401
  call void @mutex_destroy(ptr noundef %2), !dbg !402
  call void @mutex_destroy(ptr noundef %1), !dbg !403
  ret void, !dbg !404
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_init(ptr noundef %0) #0 !dbg !405 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca %union.pthread_condattr_t, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !409, !DIExpression(), !410)
    #dbg_declare(ptr %3, !411, !DIExpression(), !412)
    #dbg_declare(ptr %4, !413, !DIExpression(), !419)
  %5 = call i32 @pthread_condattr_init(ptr noundef %4) #6, !dbg !420
  store i32 %5, ptr %3, align 4, !dbg !421
  %6 = load i32, ptr %3, align 4, !dbg !422
  %7 = icmp eq i32 %6, 0, !dbg !422
  %8 = xor i1 %7, true, !dbg !422
  %9 = zext i1 %8 to i32, !dbg !422
  %10 = sext i32 %9 to i64, !dbg !422
  %11 = icmp ne i64 %10, 0, !dbg !422
  br i1 %11, label %12, label %14, !dbg !422

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 147, ptr noundef @.str.1) #8, !dbg !422
  unreachable, !dbg !422

13:                                               ; No predecessors!
  br label %15, !dbg !422

14:                                               ; preds = %1
  br label %15, !dbg !422

15:                                               ; preds = %14, %13
  %16 = load ptr, ptr %2, align 8, !dbg !423
  %17 = call i32 @pthread_cond_init(ptr noundef %16, ptr noundef %4) #6, !dbg !424
  store i32 %17, ptr %3, align 4, !dbg !425
  %18 = load i32, ptr %3, align 4, !dbg !426
  %19 = icmp eq i32 %18, 0, !dbg !426
  %20 = xor i1 %19, true, !dbg !426
  %21 = zext i1 %20 to i32, !dbg !426
  %22 = sext i32 %21 to i64, !dbg !426
  %23 = icmp ne i64 %22, 0, !dbg !426
  br i1 %23, label %24, label %26, !dbg !426

24:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 150, ptr noundef @.str.1) #8, !dbg !426
  unreachable, !dbg !426

25:                                               ; No predecessors!
  br label %27, !dbg !426

26:                                               ; preds = %15
  br label %27, !dbg !426

27:                                               ; preds = %26, %25
  %28 = call i32 @pthread_condattr_destroy(ptr noundef %4) #6, !dbg !427
  store i32 %28, ptr %3, align 4, !dbg !428
  %29 = load i32, ptr %3, align 4, !dbg !429
  %30 = icmp eq i32 %29, 0, !dbg !429
  %31 = xor i1 %30, true, !dbg !429
  %32 = zext i1 %31 to i32, !dbg !429
  %33 = sext i32 %32 to i64, !dbg !429
  %34 = icmp ne i64 %33, 0, !dbg !429
  br i1 %34, label %35, label %37, !dbg !429

35:                                               ; preds = %27
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 153, ptr noundef @.str.1) #8, !dbg !429
  unreachable, !dbg !429

36:                                               ; No predecessors!
  br label %38, !dbg !429

37:                                               ; preds = %27
  br label %38, !dbg !429

38:                                               ; preds = %37, %36
  ret void, !dbg !430
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_condattr_init(ptr noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_cond_init(ptr noundef, ptr noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_condattr_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_destroy(ptr noundef %0) #0 !dbg !431 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !432, !DIExpression(), !433)
    #dbg_declare(ptr %3, !434, !DIExpression(), !435)
  %4 = load ptr, ptr %2, align 8, !dbg !436
  %5 = call i32 @pthread_cond_destroy(ptr noundef %4) #6, !dbg !437
  store i32 %5, ptr %3, align 4, !dbg !435
  %6 = load i32, ptr %3, align 4, !dbg !438
  %7 = icmp eq i32 %6, 0, !dbg !438
  %8 = xor i1 %7, true, !dbg !438
  %9 = zext i1 %8 to i32, !dbg !438
  %10 = sext i32 %9 to i64, !dbg !438
  %11 = icmp ne i64 %10, 0, !dbg !438
  br i1 %11, label %12, label %14, !dbg !438

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_destroy, ptr noundef @.str, i32 noundef 159, ptr noundef @.str.1) #8, !dbg !438
  unreachable, !dbg !438

13:                                               ; No predecessors!
  br label %15, !dbg !438

14:                                               ; preds = %1
  br label %15, !dbg !438

15:                                               ; preds = %14, %13
  ret void, !dbg !439
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_cond_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_signal(ptr noundef %0) #0 !dbg !440 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !441, !DIExpression(), !442)
    #dbg_declare(ptr %3, !443, !DIExpression(), !444)
  %4 = load ptr, ptr %2, align 8, !dbg !445
  %5 = call i32 @pthread_cond_signal(ptr noundef %4) #7, !dbg !446
  store i32 %5, ptr %3, align 4, !dbg !444
  %6 = load i32, ptr %3, align 4, !dbg !447
  %7 = icmp eq i32 %6, 0, !dbg !447
  %8 = xor i1 %7, true, !dbg !447
  %9 = zext i1 %8 to i32, !dbg !447
  %10 = sext i32 %9 to i64, !dbg !447
  %11 = icmp ne i64 %10, 0, !dbg !447
  br i1 %11, label %12, label %14, !dbg !447

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_signal, ptr noundef @.str, i32 noundef 165, ptr noundef @.str.1) #8, !dbg !447
  unreachable, !dbg !447

13:                                               ; No predecessors!
  br label %15, !dbg !447

14:                                               ; preds = %1
  br label %15, !dbg !447

15:                                               ; preds = %14, %13
  ret void, !dbg !448
}

; Function Attrs: nounwind
declare i32 @pthread_cond_signal(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_broadcast(ptr noundef %0) #0 !dbg !449 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !450, !DIExpression(), !451)
    #dbg_declare(ptr %3, !452, !DIExpression(), !453)
  %4 = load ptr, ptr %2, align 8, !dbg !454
  %5 = call i32 @pthread_cond_broadcast(ptr noundef %4) #7, !dbg !455
  store i32 %5, ptr %3, align 4, !dbg !453
  %6 = load i32, ptr %3, align 4, !dbg !456
  %7 = icmp eq i32 %6, 0, !dbg !456
  %8 = xor i1 %7, true, !dbg !456
  %9 = zext i1 %8 to i32, !dbg !456
  %10 = sext i32 %9 to i64, !dbg !456
  %11 = icmp ne i64 %10, 0, !dbg !456
  br i1 %11, label %12, label %14, !dbg !456

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_broadcast, ptr noundef @.str, i32 noundef 171, ptr noundef @.str.1) #8, !dbg !456
  unreachable, !dbg !456

13:                                               ; No predecessors!
  br label %15, !dbg !456

14:                                               ; preds = %1
  br label %15, !dbg !456

15:                                               ; preds = %14, %13
  ret void, !dbg !457
}

; Function Attrs: nounwind
declare i32 @pthread_cond_broadcast(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_wait(ptr noundef %0, ptr noundef %1) #0 !dbg !458 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !461, !DIExpression(), !462)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !463, !DIExpression(), !464)
    #dbg_declare(ptr %5, !465, !DIExpression(), !466)
  %6 = load ptr, ptr %3, align 8, !dbg !467
  %7 = load ptr, ptr %4, align 8, !dbg !468
  %8 = call i32 @pthread_cond_wait(ptr noundef %6, ptr noundef %7), !dbg !469
  store i32 %8, ptr %5, align 4, !dbg !466
  ret void, !dbg !470
}

declare i32 @pthread_cond_wait(ptr noundef, ptr noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_timedwait(ptr noundef %0, ptr noundef %1, i64 noundef %2) #0 !dbg !471 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i64, align 8
  %7 = alloca %struct.timespec, align 8
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !474, !DIExpression(), !475)
  store ptr %1, ptr %5, align 8
    #dbg_declare(ptr %5, !476, !DIExpression(), !477)
  store i64 %2, ptr %6, align 8
    #dbg_declare(ptr %6, !478, !DIExpression(), !479)
    #dbg_declare(ptr %7, !480, !DIExpression(), !487)
  %9 = load i64, ptr %6, align 8, !dbg !488
    #dbg_declare(ptr %8, !489, !DIExpression(), !490)
  %10 = load ptr, ptr %4, align 8, !dbg !491
  %11 = load ptr, ptr %5, align 8, !dbg !492
  %12 = call i32 @pthread_cond_timedwait(ptr noundef %10, ptr noundef %11, ptr noundef %7), !dbg !493
  store i32 %12, ptr %8, align 4, !dbg !490
  ret void, !dbg !494
}

declare i32 @pthread_cond_timedwait(ptr noundef, ptr noundef, ptr noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @cond_worker(ptr noundef %0) #0 !dbg !495 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i8, align 1
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !496, !DIExpression(), !497)
    #dbg_declare(ptr %4, !498, !DIExpression(), !499)
  store i8 1, ptr %4, align 1, !dbg !499
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !500
  %5 = load i32, ptr @phase, align 4, !dbg !502
  %6 = add nsw i32 %5, 1, !dbg !502
  store i32 %6, ptr @phase, align 4, !dbg !502
  call void @cond_wait(ptr noundef @cond, ptr noundef @cond_mutex), !dbg !503
  %7 = load i32, ptr @phase, align 4, !dbg !504
  %8 = add nsw i32 %7, 1, !dbg !504
  store i32 %8, ptr @phase, align 4, !dbg !504
  %9 = load i32, ptr @phase, align 4, !dbg !505
  %10 = icmp slt i32 %9, 2, !dbg !506
  %11 = zext i1 %10 to i8, !dbg !507
  store i8 %11, ptr %4, align 1, !dbg !507
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !508
  %12 = load i8, ptr %4, align 1, !dbg !509
  %13 = trunc i8 %12 to i1, !dbg !509
  br i1 %13, label %14, label %17, !dbg !511

14:                                               ; preds = %1
  %15 = load ptr, ptr %3, align 8, !dbg !512
  %16 = getelementptr inbounds i8, ptr %15, i64 1, !dbg !513
  store ptr %16, ptr %2, align 8, !dbg !514
  br label %32, !dbg !514

17:                                               ; preds = %1
  store i8 1, ptr %4, align 1, !dbg !515
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !516
  %18 = load i32, ptr @phase, align 4, !dbg !518
  %19 = add nsw i32 %18, 1, !dbg !518
  store i32 %19, ptr @phase, align 4, !dbg !518
  call void @cond_timedwait(ptr noundef @cond, ptr noundef @cond_mutex, i64 noundef 10), !dbg !519
  %20 = load i32, ptr @phase, align 4, !dbg !520
  %21 = add nsw i32 %20, 1, !dbg !520
  store i32 %21, ptr @phase, align 4, !dbg !520
  %22 = load i32, ptr @phase, align 4, !dbg !521
  %23 = icmp sgt i32 %22, 6, !dbg !522
  %24 = zext i1 %23 to i8, !dbg !523
  store i8 %24, ptr %4, align 1, !dbg !523
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !524
  %25 = load i8, ptr %4, align 1, !dbg !525
  %26 = trunc i8 %25 to i1, !dbg !525
  br i1 %26, label %27, label %30, !dbg !527

27:                                               ; preds = %17
  %28 = load ptr, ptr %3, align 8, !dbg !528
  %29 = getelementptr inbounds i8, ptr %28, i64 2, !dbg !529
  store ptr %29, ptr %2, align 8, !dbg !530
  br label %32, !dbg !530

30:                                               ; preds = %17
  %31 = load ptr, ptr %3, align 8, !dbg !531
  store ptr %31, ptr %2, align 8, !dbg !532
  br label %32, !dbg !532

32:                                               ; preds = %30, %27, %14
  %33 = load ptr, ptr %2, align 8, !dbg !533
  ret ptr %33, !dbg !533
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_test() #0 !dbg !534 {
  %1 = alloca ptr, align 8
  %2 = alloca i64, align 8
  %3 = alloca ptr, align 8
    #dbg_declare(ptr %1, !535, !DIExpression(), !536)
  store ptr inttoptr (i64 42 to ptr), ptr %1, align 8, !dbg !536
  call void @mutex_init(ptr noundef @cond_mutex, i32 noundef 0, i32 noundef 0, i32 noundef 0), !dbg !537
  call void @cond_init(ptr noundef @cond), !dbg !538
    #dbg_declare(ptr %2, !539, !DIExpression(), !540)
  %4 = load ptr, ptr %1, align 8, !dbg !541
  %5 = call i64 @thread_create(ptr noundef @cond_worker, ptr noundef %4), !dbg !542
  store i64 %5, ptr %2, align 8, !dbg !540
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !543
  %6 = load i32, ptr @phase, align 4, !dbg !545
  %7 = add nsw i32 %6, 1, !dbg !545
  store i32 %7, ptr @phase, align 4, !dbg !545
  call void @cond_signal(ptr noundef @cond), !dbg !546
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !547
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !548
  %8 = load i32, ptr @phase, align 4, !dbg !550
  %9 = add nsw i32 %8, 1, !dbg !550
  store i32 %9, ptr @phase, align 4, !dbg !550
  call void @cond_broadcast(ptr noundef @cond), !dbg !551
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !552
    #dbg_declare(ptr %3, !553, !DIExpression(), !554)
  %10 = load i64, ptr %2, align 8, !dbg !555
  %11 = call ptr @thread_join(i64 noundef %10), !dbg !556
  store ptr %11, ptr %3, align 8, !dbg !554
  %12 = load ptr, ptr %3, align 8, !dbg !557
  %13 = load ptr, ptr %1, align 8, !dbg !557
  %14 = icmp eq ptr %12, %13, !dbg !557
  %15 = xor i1 %14, true, !dbg !557
  %16 = zext i1 %15 to i32, !dbg !557
  %17 = sext i32 %16 to i64, !dbg !557
  %18 = icmp ne i64 %17, 0, !dbg !557
  br i1 %18, label %19, label %21, !dbg !557

19:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.cond_test, ptr noundef @.str, i32 noundef 245, ptr noundef @.str.4) #8, !dbg !557
  unreachable, !dbg !557

20:                                               ; No predecessors!
  br label %22, !dbg !557

21:                                               ; preds = %0
  br label %22, !dbg !557

22:                                               ; preds = %21, %20
  call void @cond_destroy(ptr noundef @cond), !dbg !558
  call void @mutex_destroy(ptr noundef @cond_mutex), !dbg !559
  ret void, !dbg !560
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_init(ptr noundef %0, i32 noundef %1) #0 !dbg !561 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca %union.pthread_rwlockattr_t, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !589, !DIExpression(), !590)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !591, !DIExpression(), !592)
    #dbg_declare(ptr %5, !593, !DIExpression(), !594)
    #dbg_declare(ptr %6, !595, !DIExpression(), !596)
    #dbg_declare(ptr %7, !597, !DIExpression(), !603)
  %8 = call i32 @pthread_rwlockattr_init(ptr noundef %7) #6, !dbg !604
  store i32 %8, ptr %5, align 4, !dbg !605
  %9 = load i32, ptr %5, align 4, !dbg !606
  %10 = icmp eq i32 %9, 0, !dbg !606
  %11 = xor i1 %10, true, !dbg !606
  %12 = zext i1 %11 to i32, !dbg !606
  %13 = sext i32 %12 to i64, !dbg !606
  %14 = icmp ne i64 %13, 0, !dbg !606
  br i1 %14, label %15, label %17, !dbg !606

15:                                               ; preds = %2
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 262, ptr noundef @.str.1) #8, !dbg !606
  unreachable, !dbg !606

16:                                               ; No predecessors!
  br label %18, !dbg !606

17:                                               ; preds = %2
  br label %18, !dbg !606

18:                                               ; preds = %17, %16
  %19 = load i32, ptr %4, align 4, !dbg !607
  %20 = call i32 @pthread_rwlockattr_setpshared(ptr noundef %7, i32 noundef %19) #6, !dbg !608
  store i32 %20, ptr %5, align 4, !dbg !609
  %21 = load i32, ptr %5, align 4, !dbg !610
  %22 = icmp eq i32 %21, 0, !dbg !610
  %23 = xor i1 %22, true, !dbg !610
  %24 = zext i1 %23 to i32, !dbg !610
  %25 = sext i32 %24 to i64, !dbg !610
  %26 = icmp ne i64 %25, 0, !dbg !610
  br i1 %26, label %27, label %29, !dbg !610

27:                                               ; preds = %18
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 265, ptr noundef @.str.1) #8, !dbg !610
  unreachable, !dbg !610

28:                                               ; No predecessors!
  br label %30, !dbg !610

29:                                               ; preds = %18
  br label %30, !dbg !610

30:                                               ; preds = %29, %28
  %31 = call i32 @pthread_rwlockattr_getpshared(ptr noundef %7, ptr noundef %6) #6, !dbg !611
  store i32 %31, ptr %5, align 4, !dbg !612
  %32 = load i32, ptr %5, align 4, !dbg !613
  %33 = icmp eq i32 %32, 0, !dbg !613
  %34 = xor i1 %33, true, !dbg !613
  %35 = zext i1 %34 to i32, !dbg !613
  %36 = sext i32 %35 to i64, !dbg !613
  %37 = icmp ne i64 %36, 0, !dbg !613
  br i1 %37, label %38, label %40, !dbg !613

38:                                               ; preds = %30
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 267, ptr noundef @.str.1) #8, !dbg !613
  unreachable, !dbg !613

39:                                               ; No predecessors!
  br label %41, !dbg !613

40:                                               ; preds = %30
  br label %41, !dbg !613

41:                                               ; preds = %40, %39
  %42 = load ptr, ptr %3, align 8, !dbg !614
  %43 = call i32 @pthread_rwlock_init(ptr noundef %42, ptr noundef %7) #6, !dbg !615
  store i32 %43, ptr %5, align 4, !dbg !616
  %44 = load i32, ptr %5, align 4, !dbg !617
  %45 = icmp eq i32 %44, 0, !dbg !617
  %46 = xor i1 %45, true, !dbg !617
  %47 = zext i1 %46 to i32, !dbg !617
  %48 = sext i32 %47 to i64, !dbg !617
  %49 = icmp ne i64 %48, 0, !dbg !617
  br i1 %49, label %50, label %52, !dbg !617

50:                                               ; preds = %41
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 270, ptr noundef @.str.1) #8, !dbg !617
  unreachable, !dbg !617

51:                                               ; No predecessors!
  br label %53, !dbg !617

52:                                               ; preds = %41
  br label %53, !dbg !617

53:                                               ; preds = %52, %51
  %54 = call i32 @pthread_rwlockattr_destroy(ptr noundef %7) #6, !dbg !618
  store i32 %54, ptr %5, align 4, !dbg !619
  %55 = load i32, ptr %5, align 4, !dbg !620
  %56 = icmp eq i32 %55, 0, !dbg !620
  %57 = xor i1 %56, true, !dbg !620
  %58 = zext i1 %57 to i32, !dbg !620
  %59 = sext i32 %58 to i64, !dbg !620
  %60 = icmp ne i64 %59, 0, !dbg !620
  br i1 %60, label %61, label %63, !dbg !620

61:                                               ; preds = %53
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 272, ptr noundef @.str.1) #8, !dbg !620
  unreachable, !dbg !620

62:                                               ; No predecessors!
  br label %64, !dbg !620

63:                                               ; preds = %53
  br label %64, !dbg !620

64:                                               ; preds = %63, %62
  ret void, !dbg !621
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
define dso_local void @rwlock_destroy(ptr noundef %0) #0 !dbg !622 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !625, !DIExpression(), !626)
    #dbg_declare(ptr %3, !627, !DIExpression(), !628)
  %4 = load ptr, ptr %2, align 8, !dbg !629
  %5 = call i32 @pthread_rwlock_destroy(ptr noundef %4) #6, !dbg !630
  store i32 %5, ptr %3, align 4, !dbg !628
  %6 = load i32, ptr %3, align 4, !dbg !631
  %7 = icmp eq i32 %6, 0, !dbg !631
  %8 = xor i1 %7, true, !dbg !631
  %9 = zext i1 %8 to i32, !dbg !631
  %10 = sext i32 %9 to i64, !dbg !631
  %11 = icmp ne i64 %10, 0, !dbg !631
  br i1 %11, label %12, label %14, !dbg !631

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_destroy, ptr noundef @.str, i32 noundef 278, ptr noundef @.str.1) #8, !dbg !631
  unreachable, !dbg !631

13:                                               ; No predecessors!
  br label %15, !dbg !631

14:                                               ; preds = %1
  br label %15, !dbg !631

15:                                               ; preds = %14, %13
  ret void, !dbg !632
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_rwlock_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_wrlock(ptr noundef %0) #0 !dbg !633 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !634, !DIExpression(), !635)
    #dbg_declare(ptr %3, !636, !DIExpression(), !637)
  %4 = load ptr, ptr %2, align 8, !dbg !638
  %5 = call i32 @pthread_rwlock_wrlock(ptr noundef %4) #7, !dbg !639
  store i32 %5, ptr %3, align 4, !dbg !637
  %6 = load i32, ptr %3, align 4, !dbg !640
  %7 = icmp eq i32 %6, 0, !dbg !640
  %8 = xor i1 %7, true, !dbg !640
  %9 = zext i1 %8 to i32, !dbg !640
  %10 = sext i32 %9 to i64, !dbg !640
  %11 = icmp ne i64 %10, 0, !dbg !640
  br i1 %11, label %12, label %14, !dbg !640

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_wrlock, ptr noundef @.str, i32 noundef 284, ptr noundef @.str.1) #8, !dbg !640
  unreachable, !dbg !640

13:                                               ; No predecessors!
  br label %15, !dbg !640

14:                                               ; preds = %1
  br label %15, !dbg !640

15:                                               ; preds = %14, %13
  ret void, !dbg !641
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_wrlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @rwlock_trywrlock(ptr noundef %0) #0 !dbg !642 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !645, !DIExpression(), !646)
    #dbg_declare(ptr %3, !647, !DIExpression(), !648)
  %4 = load ptr, ptr %2, align 8, !dbg !649
  %5 = call i32 @pthread_rwlock_trywrlock(ptr noundef %4) #7, !dbg !650
  store i32 %5, ptr %3, align 4, !dbg !648
  %6 = load i32, ptr %3, align 4, !dbg !651
  %7 = icmp eq i32 %6, 0, !dbg !652
  ret i1 %7, !dbg !653
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_trywrlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_rdlock(ptr noundef %0) #0 !dbg !654 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !655, !DIExpression(), !656)
    #dbg_declare(ptr %3, !657, !DIExpression(), !658)
  %4 = load ptr, ptr %2, align 8, !dbg !659
  %5 = call i32 @pthread_rwlock_rdlock(ptr noundef %4) #7, !dbg !660
  store i32 %5, ptr %3, align 4, !dbg !658
  %6 = load i32, ptr %3, align 4, !dbg !661
  %7 = icmp eq i32 %6, 0, !dbg !661
  %8 = xor i1 %7, true, !dbg !661
  %9 = zext i1 %8 to i32, !dbg !661
  %10 = sext i32 %9 to i64, !dbg !661
  %11 = icmp ne i64 %10, 0, !dbg !661
  br i1 %11, label %12, label %14, !dbg !661

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_rdlock, ptr noundef @.str, i32 noundef 297, ptr noundef @.str.1) #8, !dbg !661
  unreachable, !dbg !661

13:                                               ; No predecessors!
  br label %15, !dbg !661

14:                                               ; preds = %1
  br label %15, !dbg !661

15:                                               ; preds = %14, %13
  ret void, !dbg !662
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_rdlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @rwlock_tryrdlock(ptr noundef %0) #0 !dbg !663 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !664, !DIExpression(), !665)
    #dbg_declare(ptr %3, !666, !DIExpression(), !667)
  %4 = load ptr, ptr %2, align 8, !dbg !668
  %5 = call i32 @pthread_rwlock_tryrdlock(ptr noundef %4) #7, !dbg !669
  store i32 %5, ptr %3, align 4, !dbg !667
  %6 = load i32, ptr %3, align 4, !dbg !670
  %7 = icmp eq i32 %6, 0, !dbg !671
  ret i1 %7, !dbg !672
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_tryrdlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_unlock(ptr noundef %0) #0 !dbg !673 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !674, !DIExpression(), !675)
    #dbg_declare(ptr %3, !676, !DIExpression(), !677)
  %4 = load ptr, ptr %2, align 8, !dbg !678
  %5 = call i32 @pthread_rwlock_unlock(ptr noundef %4) #7, !dbg !679
  store i32 %5, ptr %3, align 4, !dbg !677
  %6 = load i32, ptr %3, align 4, !dbg !680
  %7 = icmp eq i32 %6, 0, !dbg !680
  %8 = xor i1 %7, true, !dbg !680
  %9 = zext i1 %8 to i32, !dbg !680
  %10 = sext i32 %9 to i64, !dbg !680
  %11 = icmp ne i64 %10, 0, !dbg !680
  br i1 %11, label %12, label %14, !dbg !680

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_unlock, ptr noundef @.str, i32 noundef 310, ptr noundef @.str.1) #8, !dbg !680
  unreachable, !dbg !680

13:                                               ; No predecessors!
  br label %15, !dbg !680

14:                                               ; preds = %1
  br label %15, !dbg !680

15:                                               ; preds = %14, %13
  ret void, !dbg !681
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_unlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_test() #0 !dbg !682 {
  %1 = alloca %union.pthread_rwlock_t, align 8
  %2 = alloca i32, align 4
  %3 = alloca i8, align 1
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  %6 = alloca i8, align 1
  %7 = alloca i32, align 4
  %8 = alloca i8, align 1
    #dbg_declare(ptr %1, !683, !DIExpression(), !684)
  call void @rwlock_init(ptr noundef %1, i32 noundef 0), !dbg !685
    #dbg_declare(ptr %2, !686, !DIExpression(), !688)
  store i32 4, ptr %2, align 4, !dbg !688
  call void @rwlock_wrlock(ptr noundef %1), !dbg !689
    #dbg_declare(ptr %3, !691, !DIExpression(), !692)
  %9 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !693
  %10 = zext i1 %9 to i8, !dbg !692
  store i8 %10, ptr %3, align 1, !dbg !692
  %11 = load i8, ptr %3, align 1, !dbg !694
  %12 = trunc i8 %11 to i1, !dbg !694
  %13 = xor i1 %12, true, !dbg !694
  %14 = xor i1 %13, true, !dbg !694
  %15 = zext i1 %14 to i32, !dbg !694
  %16 = sext i32 %15 to i64, !dbg !694
  %17 = icmp ne i64 %16, 0, !dbg !694
  br i1 %17, label %18, label %20, !dbg !694

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 322, ptr noundef @.str.2) #8, !dbg !694
  unreachable, !dbg !694

19:                                               ; No predecessors!
  br label %21, !dbg !694

20:                                               ; preds = %0
  br label %21, !dbg !694

21:                                               ; preds = %20, %19
  %22 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %1), !dbg !695
  %23 = zext i1 %22 to i8, !dbg !696
  store i8 %23, ptr %3, align 1, !dbg !696
  %24 = load i8, ptr %3, align 1, !dbg !697
  %25 = trunc i8 %24 to i1, !dbg !697
  %26 = xor i1 %25, true, !dbg !697
  %27 = xor i1 %26, true, !dbg !697
  %28 = zext i1 %27 to i32, !dbg !697
  %29 = sext i32 %28 to i64, !dbg !697
  %30 = icmp ne i64 %29, 0, !dbg !697
  br i1 %30, label %31, label %33, !dbg !697

31:                                               ; preds = %21
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 324, ptr noundef @.str.2) #8, !dbg !697
  unreachable, !dbg !697

32:                                               ; No predecessors!
  br label %34, !dbg !697

33:                                               ; preds = %21
  br label %34, !dbg !697

34:                                               ; preds = %33, %32
  call void @rwlock_unlock(ptr noundef %1), !dbg !698
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !699
    #dbg_declare(ptr %4, !701, !DIExpression(), !703)
  store i32 0, ptr %4, align 4, !dbg !703
  br label %35, !dbg !704

35:                                               ; preds = %51, %34
  %36 = load i32, ptr %4, align 4, !dbg !705
  %37 = icmp slt i32 %36, 4, !dbg !707
  br i1 %37, label %38, label %54, !dbg !708

38:                                               ; preds = %35
    #dbg_declare(ptr %5, !709, !DIExpression(), !711)
  %39 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %1), !dbg !712
  %40 = zext i1 %39 to i8, !dbg !711
  store i8 %40, ptr %5, align 1, !dbg !711
  %41 = load i8, ptr %5, align 1, !dbg !713
  %42 = trunc i8 %41 to i1, !dbg !713
  %43 = xor i1 %42, true, !dbg !713
  %44 = zext i1 %43 to i32, !dbg !713
  %45 = sext i32 %44 to i64, !dbg !713
  %46 = icmp ne i64 %45, 0, !dbg !713
  br i1 %46, label %47, label %49, !dbg !713

47:                                               ; preds = %38
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 333, ptr noundef @.str.3) #8, !dbg !713
  unreachable, !dbg !713

48:                                               ; No predecessors!
  br label %50, !dbg !713

49:                                               ; preds = %38
  br label %50, !dbg !713

50:                                               ; preds = %49, %48
  br label %51, !dbg !714

51:                                               ; preds = %50
  %52 = load i32, ptr %4, align 4, !dbg !715
  %53 = add nsw i32 %52, 1, !dbg !715
  store i32 %53, ptr %4, align 4, !dbg !715
  br label %35, !dbg !716, !llvm.loop !717

54:                                               ; preds = %35
    #dbg_declare(ptr %6, !720, !DIExpression(), !722)
  %55 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !723
  %56 = zext i1 %55 to i8, !dbg !722
  store i8 %56, ptr %6, align 1, !dbg !722
  %57 = load i8, ptr %6, align 1, !dbg !724
  %58 = trunc i8 %57 to i1, !dbg !724
  %59 = xor i1 %58, true, !dbg !724
  %60 = xor i1 %59, true, !dbg !724
  %61 = zext i1 %60 to i32, !dbg !724
  %62 = sext i32 %61 to i64, !dbg !724
  %63 = icmp ne i64 %62, 0, !dbg !724
  br i1 %63, label %64, label %66, !dbg !724

64:                                               ; preds = %54
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 338, ptr noundef @.str.2) #8, !dbg !724
  unreachable, !dbg !724

65:                                               ; No predecessors!
  br label %67, !dbg !724

66:                                               ; preds = %54
  br label %67, !dbg !724

67:                                               ; preds = %66, %65
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !725
    #dbg_declare(ptr %7, !726, !DIExpression(), !728)
  store i32 0, ptr %7, align 4, !dbg !728
  br label %68, !dbg !729

68:                                               ; preds = %72, %67
  %69 = load i32, ptr %7, align 4, !dbg !730
  %70 = icmp slt i32 %69, 4, !dbg !732
  br i1 %70, label %71, label %75, !dbg !733

71:                                               ; preds = %68
  call void @rwlock_unlock(ptr noundef %1), !dbg !734
  br label %72, !dbg !736

72:                                               ; preds = %71
  %73 = load i32, ptr %7, align 4, !dbg !737
  %74 = add nsw i32 %73, 1, !dbg !737
  store i32 %74, ptr %7, align 4, !dbg !737
  br label %68, !dbg !738, !llvm.loop !739

75:                                               ; preds = %68
  call void @rwlock_wrlock(ptr noundef %1), !dbg !741
    #dbg_declare(ptr %8, !743, !DIExpression(), !744)
  %76 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !745
  %77 = zext i1 %76 to i8, !dbg !744
  store i8 %77, ptr %8, align 1, !dbg !744
  %78 = load i8, ptr %8, align 1, !dbg !746
  %79 = trunc i8 %78 to i1, !dbg !746
  %80 = xor i1 %79, true, !dbg !746
  %81 = xor i1 %80, true, !dbg !746
  %82 = zext i1 %81 to i32, !dbg !746
  %83 = sext i32 %82 to i64, !dbg !746
  %84 = icmp ne i64 %83, 0, !dbg !746
  br i1 %84, label %85, label %87, !dbg !746

85:                                               ; preds = %75
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 350, ptr noundef @.str.2) #8, !dbg !746
  unreachable, !dbg !746

86:                                               ; No predecessors!
  br label %88, !dbg !746

87:                                               ; preds = %75
  br label %88, !dbg !746

88:                                               ; preds = %87, %86
  call void @rwlock_unlock(ptr noundef %1), !dbg !747
  call void @rwlock_destroy(ptr noundef %1), !dbg !748
  ret void, !dbg !749
}

declare void @__VERIFIER_loop_bound(i32 noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @key_destroy(ptr noundef %0) #0 !dbg !750 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !753, !DIExpression(), !754)
  %3 = call i64 @pthread_self() #9, !dbg !755
  store i64 %3, ptr @latest_thread, align 8, !dbg !756
  ret void, !dbg !757
}

; Function Attrs: nocallback nounwind willreturn memory(none)
declare i64 @pthread_self() #5

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @key_worker(ptr noundef %0) #0 !dbg !758 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !759, !DIExpression(), !760)
    #dbg_declare(ptr %3, !761, !DIExpression(), !762)
  store i32 1, ptr %3, align 4, !dbg !762
    #dbg_declare(ptr %4, !763, !DIExpression(), !764)
  %6 = load i32, ptr @local_data, align 4, !dbg !765
  %7 = call i32 @pthread_setspecific(i32 noundef %6, ptr noundef %3) #6, !dbg !766
  store i32 %7, ptr %4, align 4, !dbg !764
  %8 = load i32, ptr %4, align 4, !dbg !767
  %9 = icmp eq i32 %8, 0, !dbg !767
  %10 = xor i1 %9, true, !dbg !767
  %11 = zext i1 %10 to i32, !dbg !767
  %12 = sext i32 %11 to i64, !dbg !767
  %13 = icmp ne i64 %12, 0, !dbg !767
  br i1 %13, label %14, label %16, !dbg !767

14:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.key_worker, ptr noundef @.str, i32 noundef 372, ptr noundef @.str.1) #8, !dbg !767
  unreachable, !dbg !767

15:                                               ; No predecessors!
  br label %17, !dbg !767

16:                                               ; preds = %1
  br label %17, !dbg !767

17:                                               ; preds = %16, %15
    #dbg_declare(ptr %5, !768, !DIExpression(), !769)
  %18 = load i32, ptr @local_data, align 4, !dbg !770
  %19 = call ptr @pthread_getspecific(i32 noundef %18) #6, !dbg !771
  store ptr %19, ptr %5, align 8, !dbg !769
  %20 = load ptr, ptr %5, align 8, !dbg !772
  %21 = icmp eq ptr %20, %3, !dbg !772
  %22 = xor i1 %21, true, !dbg !772
  %23 = zext i1 %22 to i32, !dbg !772
  %24 = sext i32 %23 to i64, !dbg !772
  %25 = icmp ne i64 %24, 0, !dbg !772
  br i1 %25, label %26, label %28, !dbg !772

26:                                               ; preds = %17
  call void @__assert_rtn(ptr noundef @__func__.key_worker, ptr noundef @.str, i32 noundef 375, ptr noundef @.str.5) #8, !dbg !772
  unreachable, !dbg !772

27:                                               ; No predecessors!
  br label %29, !dbg !772

28:                                               ; preds = %17
  br label %29, !dbg !772

29:                                               ; preds = %28, %27
  %30 = load ptr, ptr %2, align 8, !dbg !773
  ret ptr %30, !dbg !774
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_setspecific(i32 noundef, ptr noundef) #1

; Function Attrs: nocallback nounwind
declare ptr @pthread_getspecific(i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @key_test() #0 !dbg !775 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i64, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
    #dbg_declare(ptr %1, !776, !DIExpression(), !777)
  store i32 2, ptr %1, align 4, !dbg !777
    #dbg_declare(ptr %2, !778, !DIExpression(), !779)
  store ptr inttoptr (i64 41 to ptr), ptr %2, align 8, !dbg !779
    #dbg_declare(ptr %3, !780, !DIExpression(), !781)
  %7 = call i32 @pthread_key_create(ptr noundef @local_data, ptr noundef @key_destroy) #6, !dbg !782
    #dbg_declare(ptr %4, !783, !DIExpression(), !784)
  %8 = load ptr, ptr %2, align 8, !dbg !785
  %9 = call i64 @thread_create(ptr noundef @key_worker, ptr noundef %8), !dbg !786
  store i64 %9, ptr %4, align 8, !dbg !784
  %10 = load i32, ptr @local_data, align 4, !dbg !787
  %11 = call i32 @pthread_setspecific(i32 noundef %10, ptr noundef %1) #6, !dbg !788
  store i32 %11, ptr %3, align 4, !dbg !789
  %12 = load i32, ptr %3, align 4, !dbg !790
  %13 = icmp eq i32 %12, 0, !dbg !790
  %14 = xor i1 %13, true, !dbg !790
  %15 = zext i1 %14 to i32, !dbg !790
  %16 = sext i32 %15 to i64, !dbg !790
  %17 = icmp ne i64 %16, 0, !dbg !790
  br i1 %17, label %18, label %20, !dbg !790

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 391, ptr noundef @.str.1) #8, !dbg !790
  unreachable, !dbg !790

19:                                               ; No predecessors!
  br label %21, !dbg !790

20:                                               ; preds = %0
  br label %21, !dbg !790

21:                                               ; preds = %20, %19
    #dbg_declare(ptr %5, !791, !DIExpression(), !792)
  %22 = load i32, ptr @local_data, align 4, !dbg !793
  %23 = call ptr @pthread_getspecific(i32 noundef %22) #6, !dbg !794
  store ptr %23, ptr %5, align 8, !dbg !792
  %24 = load ptr, ptr %5, align 8, !dbg !795
  %25 = icmp eq ptr %24, %1, !dbg !795
  %26 = xor i1 %25, true, !dbg !795
  %27 = zext i1 %26 to i32, !dbg !795
  %28 = sext i32 %27 to i64, !dbg !795
  %29 = icmp ne i64 %28, 0, !dbg !795
  br i1 %29, label %30, label %32, !dbg !795

30:                                               ; preds = %21
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 394, ptr noundef @.str.5) #8, !dbg !795
  unreachable, !dbg !795

31:                                               ; No predecessors!
  br label %33, !dbg !795

32:                                               ; preds = %21
  br label %33, !dbg !795

33:                                               ; preds = %32, %31
  %34 = load i32, ptr @local_data, align 4, !dbg !796
  %35 = call i32 @pthread_setspecific(i32 noundef %34, ptr noundef null) #6, !dbg !797
  store i32 %35, ptr %3, align 4, !dbg !798
  %36 = load i32, ptr %3, align 4, !dbg !799
  %37 = icmp eq i32 %36, 0, !dbg !799
  %38 = xor i1 %37, true, !dbg !799
  %39 = zext i1 %38 to i32, !dbg !799
  %40 = sext i32 %39 to i64, !dbg !799
  %41 = icmp ne i64 %40, 0, !dbg !799
  br i1 %41, label %42, label %44, !dbg !799

42:                                               ; preds = %33
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 397, ptr noundef @.str.1) #8, !dbg !799
  unreachable, !dbg !799

43:                                               ; No predecessors!
  br label %45, !dbg !799

44:                                               ; preds = %33
  br label %45, !dbg !799

45:                                               ; preds = %44, %43
    #dbg_declare(ptr %6, !800, !DIExpression(), !801)
  %46 = load i64, ptr %4, align 8, !dbg !802
  %47 = call ptr @thread_join(i64 noundef %46), !dbg !803
  store ptr %47, ptr %6, align 8, !dbg !801
  %48 = load ptr, ptr %6, align 8, !dbg !804
  %49 = load ptr, ptr %2, align 8, !dbg !804
  %50 = icmp eq ptr %48, %49, !dbg !804
  %51 = xor i1 %50, true, !dbg !804
  %52 = zext i1 %51 to i32, !dbg !804
  %53 = sext i32 %52 to i64, !dbg !804
  %54 = icmp ne i64 %53, 0, !dbg !804
  br i1 %54, label %55, label %57, !dbg !804

55:                                               ; preds = %45
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 400, ptr noundef @.str.4) #8, !dbg !804
  unreachable, !dbg !804

56:                                               ; No predecessors!
  br label %58, !dbg !804

57:                                               ; preds = %45
  br label %58, !dbg !804

58:                                               ; preds = %57, %56
  %59 = load i32, ptr @local_data, align 4, !dbg !805
  %60 = call i32 @pthread_key_delete(i32 noundef %59) #6, !dbg !806
  store i32 %60, ptr %3, align 4, !dbg !807
  %61 = load i32, ptr %3, align 4, !dbg !808
  %62 = icmp eq i32 %61, 0, !dbg !808
  %63 = xor i1 %62, true, !dbg !808
  %64 = zext i1 %63 to i32, !dbg !808
  %65 = sext i32 %64 to i64, !dbg !808
  %66 = icmp ne i64 %65, 0, !dbg !808
  br i1 %66, label %67, label %69, !dbg !808

67:                                               ; preds = %58
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 403, ptr noundef @.str.1) #8, !dbg !808
  unreachable, !dbg !808

68:                                               ; No predecessors!
  br label %70, !dbg !808

69:                                               ; preds = %58
  br label %70, !dbg !808

70:                                               ; preds = %69, %68
  ret void, !dbg !809
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_key_create(ptr noundef, ptr noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_key_delete(i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @detach_test_worker0(ptr noundef %0) #0 !dbg !810 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !811, !DIExpression(), !812)
  ret ptr null, !dbg !813
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @detach_test_detach(ptr noundef %0) #0 !dbg !814 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !815, !DIExpression(), !816)
    #dbg_declare(ptr %3, !817, !DIExpression(), !818)
    #dbg_declare(ptr %4, !819, !DIExpression(), !820)
  %5 = call i64 @thread_create(ptr noundef @detach_test_worker0, ptr noundef null), !dbg !821
  store i64 %5, ptr %4, align 8, !dbg !820
  %6 = load i64, ptr %4, align 8, !dbg !822
  %7 = call i32 @pthread_detach(i64 noundef %6) #6, !dbg !823
  store i32 %7, ptr %3, align 4, !dbg !824
  %8 = load i32, ptr %3, align 4, !dbg !825
  %9 = icmp eq i32 %8, 0, !dbg !825
  %10 = xor i1 %9, true, !dbg !825
  %11 = zext i1 %10 to i32, !dbg !825
  %12 = sext i32 %11 to i64, !dbg !825
  %13 = icmp ne i64 %12, 0, !dbg !825
  br i1 %13, label %14, label %16, !dbg !825

14:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.detach_test_detach, ptr noundef @.str, i32 noundef 420, ptr noundef @.str.1) #8, !dbg !825
  unreachable, !dbg !825

15:                                               ; No predecessors!
  br label %17, !dbg !825

16:                                               ; preds = %1
  br label %17, !dbg !825

17:                                               ; preds = %16, %15
  %18 = load i64, ptr %4, align 8, !dbg !826
  %19 = call i32 @pthread_join(i64 noundef %18, ptr noundef null), !dbg !827
  store i32 %19, ptr %3, align 4, !dbg !828
  %20 = load i32, ptr %3, align 4, !dbg !829
  %21 = icmp ne i32 %20, 0, !dbg !829
  %22 = xor i1 %21, true, !dbg !829
  %23 = zext i1 %22 to i32, !dbg !829
  %24 = sext i32 %23 to i64, !dbg !829
  %25 = icmp ne i64 %24, 0, !dbg !829
  br i1 %25, label %26, label %28, !dbg !829

26:                                               ; preds = %17
  call void @__assert_rtn(ptr noundef @__func__.detach_test_detach, ptr noundef @.str, i32 noundef 423, ptr noundef @.str.6) #8, !dbg !829
  unreachable, !dbg !829

27:                                               ; No predecessors!
  br label %29, !dbg !829

28:                                               ; preds = %17
  br label %29, !dbg !829

29:                                               ; preds = %28, %27
  ret ptr null, !dbg !830
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_detach(i64 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @detach_test_attr(ptr noundef %0) #0 !dbg !831 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i64, align 8
  %6 = alloca %union.pthread_attr_t, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !832, !DIExpression(), !833)
    #dbg_declare(ptr %3, !834, !DIExpression(), !835)
    #dbg_declare(ptr %4, !836, !DIExpression(), !837)
    #dbg_declare(ptr %5, !838, !DIExpression(), !839)
    #dbg_declare(ptr %6, !840, !DIExpression(), !841)
  %7 = call i32 @pthread_attr_init(ptr noundef %6) #6, !dbg !842
  store i32 %7, ptr %3, align 4, !dbg !843
  %8 = load i32, ptr %3, align 4, !dbg !844
  %9 = icmp eq i32 %8, 0, !dbg !844
  %10 = xor i1 %9, true, !dbg !844
  %11 = zext i1 %10 to i32, !dbg !844
  %12 = sext i32 %11 to i64, !dbg !844
  %13 = icmp ne i64 %12, 0, !dbg !844
  br i1 %13, label %14, label %16, !dbg !844

14:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 434, ptr noundef @.str.1) #8, !dbg !844
  unreachable, !dbg !844

15:                                               ; No predecessors!
  br label %17, !dbg !844

16:                                               ; preds = %1
  br label %17, !dbg !844

17:                                               ; preds = %16, %15
  %18 = call i32 @pthread_attr_getdetachstate(ptr noundef %6, ptr noundef %4) #6, !dbg !845
  store i32 %18, ptr %3, align 4, !dbg !846
  %19 = load i32, ptr %3, align 4, !dbg !847
  %20 = icmp eq i32 %19, 0, !dbg !847
  br i1 %20, label %21, label %24, !dbg !847

21:                                               ; preds = %17
  %22 = load i32, ptr %4, align 4, !dbg !847
  %23 = icmp eq i32 %22, 0, !dbg !847
  br label %24

24:                                               ; preds = %21, %17
  %25 = phi i1 [ false, %17 ], [ %23, %21 ], !dbg !848
  %26 = xor i1 %25, true, !dbg !847
  %27 = zext i1 %26 to i32, !dbg !847
  %28 = sext i32 %27 to i64, !dbg !847
  %29 = icmp ne i64 %28, 0, !dbg !847
  br i1 %29, label %30, label %32, !dbg !847

30:                                               ; preds = %24
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 436, ptr noundef @.str.7) #8, !dbg !847
  unreachable, !dbg !847

31:                                               ; No predecessors!
  br label %33, !dbg !847

32:                                               ; preds = %24
  br label %33, !dbg !847

33:                                               ; preds = %32, %31
  %34 = call i32 @pthread_attr_setdetachstate(ptr noundef %6, i32 noundef 1) #6, !dbg !849
  store i32 %34, ptr %3, align 4, !dbg !850
  %35 = load i32, ptr %3, align 4, !dbg !851
  %36 = icmp eq i32 %35, 0, !dbg !851
  %37 = xor i1 %36, true, !dbg !851
  %38 = zext i1 %37 to i32, !dbg !851
  %39 = sext i32 %38 to i64, !dbg !851
  %40 = icmp ne i64 %39, 0, !dbg !851
  br i1 %40, label %41, label %43, !dbg !851

41:                                               ; preds = %33
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 438, ptr noundef @.str.1) #8, !dbg !851
  unreachable, !dbg !851

42:                                               ; No predecessors!
  br label %44, !dbg !851

43:                                               ; preds = %33
  br label %44, !dbg !851

44:                                               ; preds = %43, %42
  %45 = call i32 @pthread_attr_getdetachstate(ptr noundef %6, ptr noundef %4) #6, !dbg !852
  store i32 %45, ptr %3, align 4, !dbg !853
  %46 = load i32, ptr %3, align 4, !dbg !854
  %47 = icmp eq i32 %46, 0, !dbg !854
  br i1 %47, label %48, label %51, !dbg !854

48:                                               ; preds = %44
  %49 = load i32, ptr %4, align 4, !dbg !854
  %50 = icmp eq i32 %49, 1, !dbg !854
  br label %51

51:                                               ; preds = %48, %44
  %52 = phi i1 [ false, %44 ], [ %50, %48 ], !dbg !848
  %53 = xor i1 %52, true, !dbg !854
  %54 = zext i1 %53 to i32, !dbg !854
  %55 = sext i32 %54 to i64, !dbg !854
  %56 = icmp ne i64 %55, 0, !dbg !854
  br i1 %56, label %57, label %59, !dbg !854

57:                                               ; preds = %51
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 440, ptr noundef @.str.8) #8, !dbg !854
  unreachable, !dbg !854

58:                                               ; No predecessors!
  br label %60, !dbg !854

59:                                               ; preds = %51
  br label %60, !dbg !854

60:                                               ; preds = %59, %58
  %61 = call i32 @pthread_create(ptr noundef %5, ptr noundef %6, ptr noundef @detach_test_worker0, ptr noundef null) #7, !dbg !855
  store i32 %61, ptr %3, align 4, !dbg !856
  %62 = load i32, ptr %3, align 4, !dbg !857
  %63 = icmp eq i32 %62, 0, !dbg !857
  %64 = xor i1 %63, true, !dbg !857
  %65 = zext i1 %64 to i32, !dbg !857
  %66 = sext i32 %65 to i64, !dbg !857
  %67 = icmp ne i64 %66, 0, !dbg !857
  br i1 %67, label %68, label %70, !dbg !857

68:                                               ; preds = %60
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 442, ptr noundef @.str.1) #8, !dbg !857
  unreachable, !dbg !857

69:                                               ; No predecessors!
  br label %71, !dbg !857

70:                                               ; preds = %60
  br label %71, !dbg !857

71:                                               ; preds = %70, %69
  %72 = call i32 @pthread_attr_destroy(ptr noundef %6) #6, !dbg !858
  %73 = load i64, ptr %5, align 8, !dbg !859
  %74 = call i32 @pthread_join(i64 noundef %73, ptr noundef null), !dbg !860
  store i32 %74, ptr %3, align 4, !dbg !861
  %75 = load i32, ptr %3, align 4, !dbg !862
  %76 = icmp ne i32 %75, 0, !dbg !862
  %77 = xor i1 %76, true, !dbg !862
  %78 = zext i1 %77 to i32, !dbg !862
  %79 = sext i32 %78 to i64, !dbg !862
  %80 = icmp ne i64 %79, 0, !dbg !862
  br i1 %80, label %81, label %83, !dbg !862

81:                                               ; preds = %71
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 446, ptr noundef @.str.6) #8, !dbg !862
  unreachable, !dbg !862

82:                                               ; No predecessors!
  br label %84, !dbg !862

83:                                               ; preds = %71
  br label %84, !dbg !862

84:                                               ; preds = %83, %82
  ret ptr null, !dbg !863
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_attr_getdetachstate(ptr noundef, ptr noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_attr_setdetachstate(ptr noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @detach_test() #0 !dbg !864 {
  %1 = call i64 @thread_create(ptr noundef @detach_test_detach, ptr noundef null), !dbg !865
  %2 = call i64 @thread_create(ptr noundef @detach_test_attr, ptr noundef null), !dbg !866
  ret void, !dbg !867
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !868 {
  call void @mutex_test(), !dbg !871
  call void @cond_test(), !dbg !872
  call void @rwlock_test(), !dbg !873
  call void @key_test(), !dbg !874
  call void @detach_test(), !dbg !875
  ret i32 0, !dbg !876
}

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
!llvm.module.flags = !{!216, !217, !218, !219, !220, !221, !222}
!llvm.ident = !{!223}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 18, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "benchmarks/miscellaneous/pthread.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "de2181b4e1bbeb1b49680be5c0678bee")
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
!60 = distinct !DIGlobalVariable(name: "phase", scope: !61, file: !2, line: 193, type: !149, isLocal: false, isDefinition: true)
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
!91 = !{!0, !8, !13, !18, !21, !26, !28, !30, !35, !37, !42, !47, !50, !52, !54, !59, !92, !94, !99, !101, !103, !105, !107, !109, !111, !113, !118, !121, !126, !128, !133, !138, !140, !175, !209, !213}
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
!122 = distinct !DIGlobalVariable(scope: null, file: !2, line: 420, type: !123, isLocal: true, isDefinition: true)
!123 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 152, elements: !124)
!124 = !{!125}
!125 = !DISubrange(count: 19)
!126 = !DIGlobalVariableExpression(var: !127, expr: !DIExpression())
!127 = distinct !DIGlobalVariable(scope: null, file: !2, line: 423, type: !15, isLocal: true, isDefinition: true)
!128 = !DIGlobalVariableExpression(var: !129, expr: !DIExpression())
!129 = distinct !DIGlobalVariable(scope: null, file: !2, line: 434, type: !130, isLocal: true, isDefinition: true)
!130 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 136, elements: !131)
!131 = !{!132}
!132 = !DISubrange(count: 17)
!133 = !DIGlobalVariableExpression(var: !134, expr: !DIExpression())
!134 = distinct !DIGlobalVariable(scope: null, file: !2, line: 436, type: !135, isLocal: true, isDefinition: true)
!135 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 432, elements: !136)
!136 = !{!137}
!137 = !DISubrange(count: 54)
!138 = !DIGlobalVariableExpression(var: !139, expr: !DIExpression())
!139 = distinct !DIGlobalVariable(scope: null, file: !2, line: 440, type: !135, isLocal: true, isDefinition: true)
!140 = !DIGlobalVariableExpression(var: !141, expr: !DIExpression())
!141 = distinct !DIGlobalVariable(name: "cond_mutex", scope: !61, file: !2, line: 191, type: !142, isLocal: false, isDefinition: true)
!142 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !64, line: 329, baseType: !143)
!143 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !64, line: 324, size: 256, elements: !144)
!144 = !{!145, !169, !173}
!145 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !143, file: !64, line: 326, baseType: !146, size: 256)
!146 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !64, line: 258, size: 256, elements: !147)
!147 = !{!148, !150, !151, !152, !153, !154}
!148 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !146, file: !64, line: 260, baseType: !149, size: 32)
!149 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !146, file: !64, line: 261, baseType: !65, size: 32, offset: 32)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !146, file: !64, line: 262, baseType: !149, size: 32, offset: 64)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !146, file: !64, line: 263, baseType: !149, size: 32, offset: 96)
!153 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !146, file: !64, line: 264, baseType: !65, size: 32, offset: 128)
!154 = !DIDerivedType(tag: DW_TAG_member, scope: !146, file: !64, line: 265, baseType: !155, size: 64, offset: 192)
!155 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !146, file: !64, line: 265, size: 64, elements: !156)
!156 = !{!157, !163}
!157 = !DIDerivedType(tag: DW_TAG_member, name: "__elision_data", scope: !155, file: !64, line: 271, baseType: !158, size: 32)
!158 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !155, file: !64, line: 267, size: 32, elements: !159)
!159 = !{!160, !162}
!160 = !DIDerivedType(tag: DW_TAG_member, name: "__espins", scope: !158, file: !64, line: 269, baseType: !161, size: 16)
!161 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "__eelision", scope: !158, file: !64, line: 270, baseType: !161, size: 16, offset: 16)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !155, file: !64, line: 272, baseType: !164, size: 64)
!164 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_slist_t", file: !64, line: 257, baseType: !165)
!165 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_slist", file: !64, line: 254, size: 64, elements: !166)
!166 = !{!167}
!167 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !165, file: !64, line: 256, baseType: !168, size: 64)
!168 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !165, size: 64)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !143, file: !64, line: 327, baseType: !170, size: 192)
!170 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 192, elements: !171)
!171 = !{!172}
!172 = !DISubrange(count: 24)
!173 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !143, file: !64, line: 328, baseType: !174, size: 64)
!174 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!175 = !DIGlobalVariableExpression(var: !176, expr: !DIExpression())
!176 = distinct !DIGlobalVariable(name: "cond", scope: !61, file: !2, line: 192, type: !177, isLocal: false, isDefinition: true)
!177 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_cond_t", file: !64, line: 335, baseType: !178)
!178 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !64, line: 330, size: 384, elements: !179)
!179 = !{!180, !203, !207}
!180 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !178, file: !64, line: 332, baseType: !181, size: 384)
!181 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_cond_s", file: !64, line: 289, size: 384, elements: !182)
!182 = !{!183, !194, !195, !199, !200, !201, !202}
!183 = !DIDerivedType(tag: DW_TAG_member, name: "__wseq", scope: !181, file: !64, line: 291, baseType: !184, size: 64)
!184 = !DIDerivedType(tag: DW_TAG_typedef, name: "__atomic_wide_counter", file: !64, line: 248, baseType: !185)
!185 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !64, line: 240, size: 64, elements: !186)
!186 = !{!187, !189}
!187 = !DIDerivedType(tag: DW_TAG_member, name: "__value64", scope: !185, file: !64, line: 242, baseType: !188, size: 64)
!188 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!189 = !DIDerivedType(tag: DW_TAG_member, name: "__value32", scope: !185, file: !64, line: 247, baseType: !190, size: 64)
!190 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !185, file: !64, line: 243, size: 64, elements: !191)
!191 = !{!192, !193}
!192 = !DIDerivedType(tag: DW_TAG_member, name: "__low", scope: !190, file: !64, line: 245, baseType: !65, size: 32)
!193 = !DIDerivedType(tag: DW_TAG_member, name: "__high", scope: !190, file: !64, line: 246, baseType: !65, size: 32, offset: 32)
!194 = !DIDerivedType(tag: DW_TAG_member, name: "__g1_start", scope: !181, file: !64, line: 292, baseType: !184, size: 64, offset: 64)
!195 = !DIDerivedType(tag: DW_TAG_member, name: "__g_refs", scope: !181, file: !64, line: 293, baseType: !196, size: 64, offset: 128)
!196 = !DICompositeType(tag: DW_TAG_array_type, baseType: !65, size: 64, elements: !197)
!197 = !{!198}
!198 = !DISubrange(count: 2)
!199 = !DIDerivedType(tag: DW_TAG_member, name: "__g_size", scope: !181, file: !64, line: 294, baseType: !196, size: 64, offset: 192)
!200 = !DIDerivedType(tag: DW_TAG_member, name: "__g1_orig_size", scope: !181, file: !64, line: 295, baseType: !65, size: 32, offset: 256)
!201 = !DIDerivedType(tag: DW_TAG_member, name: "__wrefs", scope: !181, file: !64, line: 296, baseType: !65, size: 32, offset: 288)
!202 = !DIDerivedType(tag: DW_TAG_member, name: "__g_signals", scope: !181, file: !64, line: 297, baseType: !196, size: 64, offset: 320)
!203 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !178, file: !64, line: 333, baseType: !204, size: 384)
!204 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 384, elements: !205)
!205 = !{!206}
!206 = !DISubrange(count: 48)
!207 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !178, file: !64, line: 334, baseType: !208, size: 64)
!208 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!209 = !DIGlobalVariableExpression(var: !210, expr: !DIExpression())
!210 = distinct !DIGlobalVariable(name: "latest_thread", scope: !61, file: !2, line: 359, type: !211, isLocal: false, isDefinition: true)
!211 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !64, line: 305, baseType: !212)
!212 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!213 = !DIGlobalVariableExpression(var: !214, expr: !DIExpression())
!214 = distinct !DIGlobalVariable(name: "local_data", scope: !61, file: !2, line: 360, type: !215, isLocal: false, isDefinition: true)
!215 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_key_t", file: !64, line: 316, baseType: !65)
!216 = !{i32 7, !"Dwarf Version", i32 5}
!217 = !{i32 2, !"Debug Info Version", i32 3}
!218 = !{i32 1, !"wchar_size", i32 4}
!219 = !{i32 8, !"PIC Level", i32 2}
!220 = !{i32 7, !"PIE Level", i32 2}
!221 = !{i32 7, !"uwtable", i32 2}
!222 = !{i32 7, !"frame-pointer", i32 2}
!223 = !{!"Homebrew clang version 19.1.7"}
!224 = distinct !DISubprogram(name: "thread_create", scope: !2, file: !2, line: 12, type: !225, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!225 = !DISubroutineType(types: !226)
!226 = !{!211, !227, !90}
!227 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !228, size: 64)
!228 = !DISubroutineType(types: !229)
!229 = !{!90, !90}
!230 = !{}
!231 = !DILocalVariable(name: "runner", arg: 1, scope: !224, file: !2, line: 12, type: !227)
!232 = !DILocation(line: 12, column: 32, scope: !224)
!233 = !DILocalVariable(name: "data", arg: 2, scope: !224, file: !2, line: 12, type: !90)
!234 = !DILocation(line: 12, column: 54, scope: !224)
!235 = !DILocalVariable(name: "id", scope: !224, file: !2, line: 14, type: !211)
!236 = !DILocation(line: 14, column: 15, scope: !224)
!237 = !DILocalVariable(name: "attr", scope: !224, file: !2, line: 15, type: !238)
!238 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !64, line: 323, baseType: !239)
!239 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !64, line: 318, size: 320, elements: !240)
!240 = !{!241, !245}
!241 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !239, file: !64, line: 320, baseType: !242, size: 288)
!242 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 288, elements: !243)
!243 = !{!244}
!244 = !DISubrange(count: 36)
!245 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !239, file: !64, line: 321, baseType: !174, size: 64)
!246 = !DILocation(line: 15, column: 20, scope: !224)
!247 = !DILocation(line: 16, column: 5, scope: !224)
!248 = !DILocalVariable(name: "status", scope: !224, file: !2, line: 17, type: !149)
!249 = !DILocation(line: 17, column: 9, scope: !224)
!250 = !DILocation(line: 17, column: 45, scope: !224)
!251 = !DILocation(line: 17, column: 53, scope: !224)
!252 = !DILocation(line: 17, column: 18, scope: !224)
!253 = !DILocation(line: 18, column: 5, scope: !224)
!254 = !DILocation(line: 19, column: 5, scope: !224)
!255 = !DILocation(line: 20, column: 12, scope: !224)
!256 = !DILocation(line: 20, column: 5, scope: !224)
!257 = distinct !DISubprogram(name: "thread_join", scope: !2, file: !2, line: 23, type: !258, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!258 = !DISubroutineType(types: !259)
!259 = !{!90, !211}
!260 = !DILocalVariable(name: "id", arg: 1, scope: !257, file: !2, line: 23, type: !211)
!261 = !DILocation(line: 23, column: 29, scope: !257)
!262 = !DILocalVariable(name: "result", scope: !257, file: !2, line: 25, type: !90)
!263 = !DILocation(line: 25, column: 11, scope: !257)
!264 = !DILocalVariable(name: "status", scope: !257, file: !2, line: 26, type: !149)
!265 = !DILocation(line: 26, column: 9, scope: !257)
!266 = !DILocation(line: 26, column: 31, scope: !257)
!267 = !DILocation(line: 26, column: 18, scope: !257)
!268 = !DILocation(line: 27, column: 5, scope: !257)
!269 = !DILocation(line: 28, column: 12, scope: !257)
!270 = !DILocation(line: 28, column: 5, scope: !257)
!271 = distinct !DISubprogram(name: "mutex_init", scope: !2, file: !2, line: 41, type: !272, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!272 = !DISubroutineType(types: !273)
!273 = !{null, !274, !149, !149, !149}
!274 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !142, size: 64)
!275 = !DILocalVariable(name: "lock", arg: 1, scope: !271, file: !2, line: 41, type: !274)
!276 = !DILocation(line: 41, column: 34, scope: !271)
!277 = !DILocalVariable(name: "type", arg: 2, scope: !271, file: !2, line: 41, type: !149)
!278 = !DILocation(line: 41, column: 44, scope: !271)
!279 = !DILocalVariable(name: "protocol", arg: 3, scope: !271, file: !2, line: 41, type: !149)
!280 = !DILocation(line: 41, column: 54, scope: !271)
!281 = !DILocalVariable(name: "prioceiling", arg: 4, scope: !271, file: !2, line: 41, type: !149)
!282 = !DILocation(line: 41, column: 68, scope: !271)
!283 = !DILocalVariable(name: "status", scope: !271, file: !2, line: 43, type: !149)
!284 = !DILocation(line: 43, column: 9, scope: !271)
!285 = !DILocalVariable(name: "value", scope: !271, file: !2, line: 44, type: !149)
!286 = !DILocation(line: 44, column: 9, scope: !271)
!287 = !DILocalVariable(name: "attributes", scope: !271, file: !2, line: 45, type: !288)
!288 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !64, line: 310, baseType: !289)
!289 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !64, line: 306, size: 32, elements: !290)
!290 = !{!291, !295}
!291 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !289, file: !64, line: 308, baseType: !292, size: 32)
!292 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 32, elements: !293)
!293 = !{!294}
!294 = !DISubrange(count: 4)
!295 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !289, file: !64, line: 309, baseType: !149, size: 32)
!296 = !DILocation(line: 45, column: 25, scope: !271)
!297 = !DILocation(line: 46, column: 14, scope: !271)
!298 = !DILocation(line: 46, column: 12, scope: !271)
!299 = !DILocation(line: 47, column: 5, scope: !271)
!300 = !DILocation(line: 49, column: 53, scope: !271)
!301 = !DILocation(line: 49, column: 14, scope: !271)
!302 = !DILocation(line: 49, column: 12, scope: !271)
!303 = !DILocation(line: 50, column: 5, scope: !271)
!304 = !DILocation(line: 51, column: 14, scope: !271)
!305 = !DILocation(line: 51, column: 12, scope: !271)
!306 = !DILocation(line: 52, column: 5, scope: !271)
!307 = !DILocation(line: 54, column: 57, scope: !271)
!308 = !DILocation(line: 54, column: 14, scope: !271)
!309 = !DILocation(line: 54, column: 12, scope: !271)
!310 = !DILocation(line: 55, column: 5, scope: !271)
!311 = !DILocation(line: 56, column: 14, scope: !271)
!312 = !DILocation(line: 56, column: 12, scope: !271)
!313 = !DILocation(line: 57, column: 5, scope: !271)
!314 = !DILocation(line: 59, column: 60, scope: !271)
!315 = !DILocation(line: 59, column: 14, scope: !271)
!316 = !DILocation(line: 59, column: 12, scope: !271)
!317 = !DILocation(line: 60, column: 5, scope: !271)
!318 = !DILocation(line: 61, column: 14, scope: !271)
!319 = !DILocation(line: 61, column: 12, scope: !271)
!320 = !DILocation(line: 62, column: 5, scope: !271)
!321 = !DILocation(line: 64, column: 33, scope: !271)
!322 = !DILocation(line: 64, column: 14, scope: !271)
!323 = !DILocation(line: 64, column: 12, scope: !271)
!324 = !DILocation(line: 65, column: 5, scope: !271)
!325 = !DILocation(line: 66, column: 14, scope: !271)
!326 = !DILocation(line: 66, column: 12, scope: !271)
!327 = !DILocation(line: 67, column: 5, scope: !271)
!328 = !DILocation(line: 68, column: 1, scope: !271)
!329 = distinct !DISubprogram(name: "mutex_destroy", scope: !2, file: !2, line: 70, type: !330, scopeLine: 71, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!330 = !DISubroutineType(types: !331)
!331 = !{null, !274}
!332 = !DILocalVariable(name: "lock", arg: 1, scope: !329, file: !2, line: 70, type: !274)
!333 = !DILocation(line: 70, column: 37, scope: !329)
!334 = !DILocalVariable(name: "status", scope: !329, file: !2, line: 72, type: !149)
!335 = !DILocation(line: 72, column: 9, scope: !329)
!336 = !DILocation(line: 72, column: 40, scope: !329)
!337 = !DILocation(line: 72, column: 18, scope: !329)
!338 = !DILocation(line: 73, column: 5, scope: !329)
!339 = !DILocation(line: 74, column: 1, scope: !329)
!340 = distinct !DISubprogram(name: "mutex_lock", scope: !2, file: !2, line: 76, type: !330, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!341 = !DILocalVariable(name: "lock", arg: 1, scope: !340, file: !2, line: 76, type: !274)
!342 = !DILocation(line: 76, column: 34, scope: !340)
!343 = !DILocalVariable(name: "status", scope: !340, file: !2, line: 78, type: !149)
!344 = !DILocation(line: 78, column: 9, scope: !340)
!345 = !DILocation(line: 78, column: 37, scope: !340)
!346 = !DILocation(line: 78, column: 18, scope: !340)
!347 = !DILocation(line: 79, column: 5, scope: !340)
!348 = !DILocation(line: 80, column: 1, scope: !340)
!349 = distinct !DISubprogram(name: "mutex_trylock", scope: !2, file: !2, line: 82, type: !350, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!350 = !DISubroutineType(types: !351)
!351 = !{!352, !274}
!352 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!353 = !DILocalVariable(name: "lock", arg: 1, scope: !349, file: !2, line: 82, type: !274)
!354 = !DILocation(line: 82, column: 37, scope: !349)
!355 = !DILocalVariable(name: "status", scope: !349, file: !2, line: 84, type: !149)
!356 = !DILocation(line: 84, column: 9, scope: !349)
!357 = !DILocation(line: 84, column: 40, scope: !349)
!358 = !DILocation(line: 84, column: 18, scope: !349)
!359 = !DILocation(line: 86, column: 12, scope: !349)
!360 = !DILocation(line: 86, column: 19, scope: !349)
!361 = !DILocation(line: 86, column: 5, scope: !349)
!362 = distinct !DISubprogram(name: "mutex_unlock", scope: !2, file: !2, line: 89, type: !330, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!363 = !DILocalVariable(name: "lock", arg: 1, scope: !362, file: !2, line: 89, type: !274)
!364 = !DILocation(line: 89, column: 36, scope: !362)
!365 = !DILocalVariable(name: "status", scope: !362, file: !2, line: 91, type: !149)
!366 = !DILocation(line: 91, column: 9, scope: !362)
!367 = !DILocation(line: 91, column: 39, scope: !362)
!368 = !DILocation(line: 91, column: 18, scope: !362)
!369 = !DILocation(line: 92, column: 5, scope: !362)
!370 = !DILocation(line: 93, column: 1, scope: !362)
!371 = distinct !DISubprogram(name: "mutex_test", scope: !2, file: !2, line: 95, type: !372, scopeLine: 96, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!372 = !DISubroutineType(types: !373)
!373 = !{null}
!374 = !DILocalVariable(name: "mutex0", scope: !371, file: !2, line: 97, type: !142)
!375 = !DILocation(line: 97, column: 21, scope: !371)
!376 = !DILocalVariable(name: "mutex1", scope: !371, file: !2, line: 98, type: !142)
!377 = !DILocation(line: 98, column: 21, scope: !371)
!378 = !DILocation(line: 100, column: 5, scope: !371)
!379 = !DILocation(line: 101, column: 5, scope: !371)
!380 = !DILocation(line: 104, column: 9, scope: !381)
!381 = distinct !DILexicalBlock(scope: !371, file: !2, line: 103, column: 5)
!382 = !DILocalVariable(name: "success", scope: !381, file: !2, line: 105, type: !352)
!383 = !DILocation(line: 105, column: 14, scope: !381)
!384 = !DILocation(line: 105, column: 24, scope: !381)
!385 = !DILocation(line: 106, column: 9, scope: !381)
!386 = !DILocation(line: 107, column: 9, scope: !381)
!387 = !DILocation(line: 111, column: 9, scope: !388)
!388 = distinct !DILexicalBlock(scope: !371, file: !2, line: 110, column: 5)
!389 = !DILocalVariable(name: "success", scope: !390, file: !2, line: 114, type: !352)
!390 = distinct !DILexicalBlock(scope: !388, file: !2, line: 113, column: 9)
!391 = !DILocation(line: 114, column: 18, scope: !390)
!392 = !DILocation(line: 114, column: 28, scope: !390)
!393 = !DILocation(line: 115, column: 13, scope: !390)
!394 = !DILocation(line: 116, column: 13, scope: !390)
!395 = !DILocalVariable(name: "success", scope: !396, file: !2, line: 120, type: !352)
!396 = distinct !DILexicalBlock(scope: !388, file: !2, line: 119, column: 9)
!397 = !DILocation(line: 120, column: 18, scope: !396)
!398 = !DILocation(line: 120, column: 28, scope: !396)
!399 = !DILocation(line: 121, column: 13, scope: !396)
!400 = !DILocation(line: 122, column: 13, scope: !396)
!401 = !DILocation(line: 132, column: 9, scope: !388)
!402 = !DILocation(line: 135, column: 5, scope: !371)
!403 = !DILocation(line: 136, column: 5, scope: !371)
!404 = !DILocation(line: 137, column: 1, scope: !371)
!405 = distinct !DISubprogram(name: "cond_init", scope: !2, file: !2, line: 141, type: !406, scopeLine: 142, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!406 = !DISubroutineType(types: !407)
!407 = !{null, !408}
!408 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !177, size: 64)
!409 = !DILocalVariable(name: "cond", arg: 1, scope: !405, file: !2, line: 141, type: !408)
!410 = !DILocation(line: 141, column: 32, scope: !405)
!411 = !DILocalVariable(name: "status", scope: !405, file: !2, line: 143, type: !149)
!412 = !DILocation(line: 143, column: 9, scope: !405)
!413 = !DILocalVariable(name: "attr", scope: !405, file: !2, line: 144, type: !414)
!414 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_condattr_t", file: !64, line: 315, baseType: !415)
!415 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !64, line: 311, size: 32, elements: !416)
!416 = !{!417, !418}
!417 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !415, file: !64, line: 313, baseType: !292, size: 32)
!418 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !415, file: !64, line: 314, baseType: !149, size: 32)
!419 = !DILocation(line: 144, column: 24, scope: !405)
!420 = !DILocation(line: 146, column: 14, scope: !405)
!421 = !DILocation(line: 146, column: 12, scope: !405)
!422 = !DILocation(line: 147, column: 5, scope: !405)
!423 = !DILocation(line: 149, column: 32, scope: !405)
!424 = !DILocation(line: 149, column: 14, scope: !405)
!425 = !DILocation(line: 149, column: 12, scope: !405)
!426 = !DILocation(line: 150, column: 5, scope: !405)
!427 = !DILocation(line: 152, column: 14, scope: !405)
!428 = !DILocation(line: 152, column: 12, scope: !405)
!429 = !DILocation(line: 153, column: 5, scope: !405)
!430 = !DILocation(line: 154, column: 1, scope: !405)
!431 = distinct !DISubprogram(name: "cond_destroy", scope: !2, file: !2, line: 156, type: !406, scopeLine: 157, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!432 = !DILocalVariable(name: "cond", arg: 1, scope: !431, file: !2, line: 156, type: !408)
!433 = !DILocation(line: 156, column: 35, scope: !431)
!434 = !DILocalVariable(name: "status", scope: !431, file: !2, line: 158, type: !149)
!435 = !DILocation(line: 158, column: 9, scope: !431)
!436 = !DILocation(line: 158, column: 39, scope: !431)
!437 = !DILocation(line: 158, column: 18, scope: !431)
!438 = !DILocation(line: 159, column: 5, scope: !431)
!439 = !DILocation(line: 160, column: 1, scope: !431)
!440 = distinct !DISubprogram(name: "cond_signal", scope: !2, file: !2, line: 162, type: !406, scopeLine: 163, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!441 = !DILocalVariable(name: "cond", arg: 1, scope: !440, file: !2, line: 162, type: !408)
!442 = !DILocation(line: 162, column: 34, scope: !440)
!443 = !DILocalVariable(name: "status", scope: !440, file: !2, line: 164, type: !149)
!444 = !DILocation(line: 164, column: 9, scope: !440)
!445 = !DILocation(line: 164, column: 38, scope: !440)
!446 = !DILocation(line: 164, column: 18, scope: !440)
!447 = !DILocation(line: 165, column: 5, scope: !440)
!448 = !DILocation(line: 166, column: 1, scope: !440)
!449 = distinct !DISubprogram(name: "cond_broadcast", scope: !2, file: !2, line: 168, type: !406, scopeLine: 169, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!450 = !DILocalVariable(name: "cond", arg: 1, scope: !449, file: !2, line: 168, type: !408)
!451 = !DILocation(line: 168, column: 37, scope: !449)
!452 = !DILocalVariable(name: "status", scope: !449, file: !2, line: 170, type: !149)
!453 = !DILocation(line: 170, column: 9, scope: !449)
!454 = !DILocation(line: 170, column: 41, scope: !449)
!455 = !DILocation(line: 170, column: 18, scope: !449)
!456 = !DILocation(line: 171, column: 5, scope: !449)
!457 = !DILocation(line: 172, column: 1, scope: !449)
!458 = distinct !DISubprogram(name: "cond_wait", scope: !2, file: !2, line: 174, type: !459, scopeLine: 175, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!459 = !DISubroutineType(types: !460)
!460 = !{null, !408, !274}
!461 = !DILocalVariable(name: "cond", arg: 1, scope: !458, file: !2, line: 174, type: !408)
!462 = !DILocation(line: 174, column: 32, scope: !458)
!463 = !DILocalVariable(name: "lock", arg: 2, scope: !458, file: !2, line: 174, type: !274)
!464 = !DILocation(line: 174, column: 55, scope: !458)
!465 = !DILocalVariable(name: "status", scope: !458, file: !2, line: 176, type: !149)
!466 = !DILocation(line: 176, column: 9, scope: !458)
!467 = !DILocation(line: 176, column: 36, scope: !458)
!468 = !DILocation(line: 176, column: 42, scope: !458)
!469 = !DILocation(line: 176, column: 18, scope: !458)
!470 = !DILocation(line: 178, column: 1, scope: !458)
!471 = distinct !DISubprogram(name: "cond_timedwait", scope: !2, file: !2, line: 180, type: !472, scopeLine: 181, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!472 = !DISubroutineType(types: !473)
!473 = !{null, !408, !274, !208}
!474 = !DILocalVariable(name: "cond", arg: 1, scope: !471, file: !2, line: 180, type: !408)
!475 = !DILocation(line: 180, column: 37, scope: !471)
!476 = !DILocalVariable(name: "lock", arg: 2, scope: !471, file: !2, line: 180, type: !274)
!477 = !DILocation(line: 180, column: 60, scope: !471)
!478 = !DILocalVariable(name: "millis", arg: 3, scope: !471, file: !2, line: 180, type: !208)
!479 = !DILocation(line: 180, column: 76, scope: !471)
!480 = !DILocalVariable(name: "ts", scope: !471, file: !2, line: 183, type: !481)
!481 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !64, line: 212, size: 128, elements: !482)
!482 = !{!483, !485}
!483 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !481, file: !64, line: 214, baseType: !484, size: 64)
!484 = !DIDerivedType(tag: DW_TAG_typedef, name: "__time_t", file: !64, line: 108, baseType: !174)
!485 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !481, file: !64, line: 215, baseType: !486, size: 64, offset: 64)
!486 = !DIDerivedType(tag: DW_TAG_typedef, name: "__syscall_slong_t", file: !64, line: 125, baseType: !174)
!487 = !DILocation(line: 183, column: 21, scope: !471)
!488 = !DILocation(line: 187, column: 11, scope: !471)
!489 = !DILocalVariable(name: "status", scope: !471, file: !2, line: 188, type: !149)
!490 = !DILocation(line: 188, column: 9, scope: !471)
!491 = !DILocation(line: 188, column: 41, scope: !471)
!492 = !DILocation(line: 188, column: 47, scope: !471)
!493 = !DILocation(line: 188, column: 18, scope: !471)
!494 = !DILocation(line: 189, column: 1, scope: !471)
!495 = distinct !DISubprogram(name: "cond_worker", scope: !2, file: !2, line: 195, type: !228, scopeLine: 196, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!496 = !DILocalVariable(name: "message", arg: 1, scope: !495, file: !2, line: 195, type: !90)
!497 = !DILocation(line: 195, column: 25, scope: !495)
!498 = !DILocalVariable(name: "idle", scope: !495, file: !2, line: 197, type: !352)
!499 = !DILocation(line: 197, column: 10, scope: !495)
!500 = !DILocation(line: 199, column: 9, scope: !501)
!501 = distinct !DILexicalBlock(scope: !495, file: !2, line: 198, column: 5)
!502 = !DILocation(line: 200, column: 9, scope: !501)
!503 = !DILocation(line: 201, column: 9, scope: !501)
!504 = !DILocation(line: 202, column: 9, scope: !501)
!505 = !DILocation(line: 203, column: 16, scope: !501)
!506 = !DILocation(line: 203, column: 22, scope: !501)
!507 = !DILocation(line: 203, column: 14, scope: !501)
!508 = !DILocation(line: 204, column: 9, scope: !501)
!509 = !DILocation(line: 206, column: 9, scope: !510)
!510 = distinct !DILexicalBlock(scope: !495, file: !2, line: 206, column: 9)
!511 = !DILocation(line: 206, column: 9, scope: !495)
!512 = !DILocation(line: 207, column: 25, scope: !510)
!513 = !DILocation(line: 207, column: 34, scope: !510)
!514 = !DILocation(line: 207, column: 9, scope: !510)
!515 = !DILocation(line: 208, column: 10, scope: !495)
!516 = !DILocation(line: 210, column: 9, scope: !517)
!517 = distinct !DILexicalBlock(scope: !495, file: !2, line: 209, column: 5)
!518 = !DILocation(line: 211, column: 9, scope: !517)
!519 = !DILocation(line: 212, column: 9, scope: !517)
!520 = !DILocation(line: 213, column: 9, scope: !517)
!521 = !DILocation(line: 214, column: 16, scope: !517)
!522 = !DILocation(line: 214, column: 22, scope: !517)
!523 = !DILocation(line: 214, column: 14, scope: !517)
!524 = !DILocation(line: 215, column: 9, scope: !517)
!525 = !DILocation(line: 217, column: 9, scope: !526)
!526 = distinct !DILexicalBlock(scope: !495, file: !2, line: 217, column: 9)
!527 = !DILocation(line: 217, column: 9, scope: !495)
!528 = !DILocation(line: 218, column: 25, scope: !526)
!529 = !DILocation(line: 218, column: 34, scope: !526)
!530 = !DILocation(line: 218, column: 9, scope: !526)
!531 = !DILocation(line: 219, column: 12, scope: !495)
!532 = !DILocation(line: 219, column: 5, scope: !495)
!533 = !DILocation(line: 220, column: 1, scope: !495)
!534 = distinct !DISubprogram(name: "cond_test", scope: !2, file: !2, line: 222, type: !372, scopeLine: 223, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!535 = !DILocalVariable(name: "message", scope: !534, file: !2, line: 224, type: !90)
!536 = !DILocation(line: 224, column: 11, scope: !534)
!537 = !DILocation(line: 225, column: 5, scope: !534)
!538 = !DILocation(line: 226, column: 5, scope: !534)
!539 = !DILocalVariable(name: "worker", scope: !534, file: !2, line: 228, type: !211)
!540 = !DILocation(line: 228, column: 15, scope: !534)
!541 = !DILocation(line: 228, column: 51, scope: !534)
!542 = !DILocation(line: 228, column: 24, scope: !534)
!543 = !DILocation(line: 231, column: 9, scope: !544)
!544 = distinct !DILexicalBlock(scope: !534, file: !2, line: 230, column: 5)
!545 = !DILocation(line: 232, column: 9, scope: !544)
!546 = !DILocation(line: 233, column: 9, scope: !544)
!547 = !DILocation(line: 234, column: 9, scope: !544)
!548 = !DILocation(line: 238, column: 9, scope: !549)
!549 = distinct !DILexicalBlock(scope: !534, file: !2, line: 237, column: 5)
!550 = !DILocation(line: 239, column: 9, scope: !549)
!551 = !DILocation(line: 240, column: 9, scope: !549)
!552 = !DILocation(line: 241, column: 9, scope: !549)
!553 = !DILocalVariable(name: "result", scope: !534, file: !2, line: 244, type: !90)
!554 = !DILocation(line: 244, column: 11, scope: !534)
!555 = !DILocation(line: 244, column: 32, scope: !534)
!556 = !DILocation(line: 244, column: 20, scope: !534)
!557 = !DILocation(line: 245, column: 5, scope: !534)
!558 = !DILocation(line: 247, column: 5, scope: !534)
!559 = !DILocation(line: 248, column: 5, scope: !534)
!560 = !DILocation(line: 249, column: 1, scope: !534)
!561 = distinct !DISubprogram(name: "rwlock_init", scope: !2, file: !2, line: 256, type: !562, scopeLine: 257, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!562 = !DISubroutineType(types: !563)
!563 = !{null, !564, !149}
!564 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !565, size: 64)
!565 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlock_t", file: !64, line: 341, baseType: !566)
!566 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !64, line: 336, size: 256, elements: !567)
!567 = !{!568, !584, !588}
!568 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !566, file: !64, line: 338, baseType: !569, size: 256)
!569 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_rwlock_arch_t", file: !64, line: 275, size: 256, elements: !570)
!570 = !{!571, !572, !573, !574, !575, !576, !577, !579, !580, !582, !583}
!571 = !DIDerivedType(tag: DW_TAG_member, name: "__readers", scope: !569, file: !64, line: 277, baseType: !65, size: 32)
!572 = !DIDerivedType(tag: DW_TAG_member, name: "__writers", scope: !569, file: !64, line: 278, baseType: !65, size: 32, offset: 32)
!573 = !DIDerivedType(tag: DW_TAG_member, name: "__wrphase_futex", scope: !569, file: !64, line: 279, baseType: !65, size: 32, offset: 64)
!574 = !DIDerivedType(tag: DW_TAG_member, name: "__writers_futex", scope: !569, file: !64, line: 280, baseType: !65, size: 32, offset: 96)
!575 = !DIDerivedType(tag: DW_TAG_member, name: "__pad3", scope: !569, file: !64, line: 281, baseType: !65, size: 32, offset: 128)
!576 = !DIDerivedType(tag: DW_TAG_member, name: "__pad4", scope: !569, file: !64, line: 282, baseType: !65, size: 32, offset: 160)
!577 = !DIDerivedType(tag: DW_TAG_member, name: "__flags", scope: !569, file: !64, line: 283, baseType: !578, size: 8, offset: 192)
!578 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!579 = !DIDerivedType(tag: DW_TAG_member, name: "__shared", scope: !569, file: !64, line: 284, baseType: !578, size: 8, offset: 200)
!580 = !DIDerivedType(tag: DW_TAG_member, name: "__rwelision", scope: !569, file: !64, line: 285, baseType: !581, size: 8, offset: 208)
!581 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!582 = !DIDerivedType(tag: DW_TAG_member, name: "__pad2", scope: !569, file: !64, line: 286, baseType: !578, size: 8, offset: 216)
!583 = !DIDerivedType(tag: DW_TAG_member, name: "__cur_writer", scope: !569, file: !64, line: 287, baseType: !149, size: 32, offset: 224)
!584 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !566, file: !64, line: 339, baseType: !585, size: 256)
!585 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 256, elements: !586)
!586 = !{!587}
!587 = !DISubrange(count: 32)
!588 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !566, file: !64, line: 340, baseType: !174, size: 64)
!589 = !DILocalVariable(name: "lock", arg: 1, scope: !561, file: !2, line: 256, type: !564)
!590 = !DILocation(line: 256, column: 36, scope: !561)
!591 = !DILocalVariable(name: "shared", arg: 2, scope: !561, file: !2, line: 256, type: !149)
!592 = !DILocation(line: 256, column: 46, scope: !561)
!593 = !DILocalVariable(name: "status", scope: !561, file: !2, line: 258, type: !149)
!594 = !DILocation(line: 258, column: 9, scope: !561)
!595 = !DILocalVariable(name: "value", scope: !561, file: !2, line: 259, type: !149)
!596 = !DILocation(line: 259, column: 9, scope: !561)
!597 = !DILocalVariable(name: "attributes", scope: !561, file: !2, line: 260, type: !598)
!598 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlockattr_t", file: !64, line: 346, baseType: !599)
!599 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !64, line: 342, size: 64, elements: !600)
!600 = !{!601, !602}
!601 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !599, file: !64, line: 344, baseType: !44, size: 64)
!602 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !599, file: !64, line: 345, baseType: !174, size: 64)
!603 = !DILocation(line: 260, column: 26, scope: !561)
!604 = !DILocation(line: 261, column: 14, scope: !561)
!605 = !DILocation(line: 261, column: 12, scope: !561)
!606 = !DILocation(line: 262, column: 5, scope: !561)
!607 = !DILocation(line: 264, column: 57, scope: !561)
!608 = !DILocation(line: 264, column: 14, scope: !561)
!609 = !DILocation(line: 264, column: 12, scope: !561)
!610 = !DILocation(line: 265, column: 5, scope: !561)
!611 = !DILocation(line: 266, column: 14, scope: !561)
!612 = !DILocation(line: 266, column: 12, scope: !561)
!613 = !DILocation(line: 267, column: 5, scope: !561)
!614 = !DILocation(line: 269, column: 34, scope: !561)
!615 = !DILocation(line: 269, column: 14, scope: !561)
!616 = !DILocation(line: 269, column: 12, scope: !561)
!617 = !DILocation(line: 270, column: 5, scope: !561)
!618 = !DILocation(line: 271, column: 14, scope: !561)
!619 = !DILocation(line: 271, column: 12, scope: !561)
!620 = !DILocation(line: 272, column: 5, scope: !561)
!621 = !DILocation(line: 273, column: 1, scope: !561)
!622 = distinct !DISubprogram(name: "rwlock_destroy", scope: !2, file: !2, line: 275, type: !623, scopeLine: 276, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!623 = !DISubroutineType(types: !624)
!624 = !{null, !564}
!625 = !DILocalVariable(name: "lock", arg: 1, scope: !622, file: !2, line: 275, type: !564)
!626 = !DILocation(line: 275, column: 39, scope: !622)
!627 = !DILocalVariable(name: "status", scope: !622, file: !2, line: 277, type: !149)
!628 = !DILocation(line: 277, column: 9, scope: !622)
!629 = !DILocation(line: 277, column: 41, scope: !622)
!630 = !DILocation(line: 277, column: 18, scope: !622)
!631 = !DILocation(line: 278, column: 5, scope: !622)
!632 = !DILocation(line: 279, column: 1, scope: !622)
!633 = distinct !DISubprogram(name: "rwlock_wrlock", scope: !2, file: !2, line: 281, type: !623, scopeLine: 282, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!634 = !DILocalVariable(name: "lock", arg: 1, scope: !633, file: !2, line: 281, type: !564)
!635 = !DILocation(line: 281, column: 38, scope: !633)
!636 = !DILocalVariable(name: "status", scope: !633, file: !2, line: 283, type: !149)
!637 = !DILocation(line: 283, column: 9, scope: !633)
!638 = !DILocation(line: 283, column: 40, scope: !633)
!639 = !DILocation(line: 283, column: 18, scope: !633)
!640 = !DILocation(line: 284, column: 5, scope: !633)
!641 = !DILocation(line: 285, column: 1, scope: !633)
!642 = distinct !DISubprogram(name: "rwlock_trywrlock", scope: !2, file: !2, line: 287, type: !643, scopeLine: 288, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!643 = !DISubroutineType(types: !644)
!644 = !{!352, !564}
!645 = !DILocalVariable(name: "lock", arg: 1, scope: !642, file: !2, line: 287, type: !564)
!646 = !DILocation(line: 287, column: 41, scope: !642)
!647 = !DILocalVariable(name: "status", scope: !642, file: !2, line: 289, type: !149)
!648 = !DILocation(line: 289, column: 9, scope: !642)
!649 = !DILocation(line: 289, column: 43, scope: !642)
!650 = !DILocation(line: 289, column: 18, scope: !642)
!651 = !DILocation(line: 291, column: 12, scope: !642)
!652 = !DILocation(line: 291, column: 19, scope: !642)
!653 = !DILocation(line: 291, column: 5, scope: !642)
!654 = distinct !DISubprogram(name: "rwlock_rdlock", scope: !2, file: !2, line: 294, type: !623, scopeLine: 295, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!655 = !DILocalVariable(name: "lock", arg: 1, scope: !654, file: !2, line: 294, type: !564)
!656 = !DILocation(line: 294, column: 38, scope: !654)
!657 = !DILocalVariable(name: "status", scope: !654, file: !2, line: 296, type: !149)
!658 = !DILocation(line: 296, column: 9, scope: !654)
!659 = !DILocation(line: 296, column: 40, scope: !654)
!660 = !DILocation(line: 296, column: 18, scope: !654)
!661 = !DILocation(line: 297, column: 5, scope: !654)
!662 = !DILocation(line: 298, column: 1, scope: !654)
!663 = distinct !DISubprogram(name: "rwlock_tryrdlock", scope: !2, file: !2, line: 300, type: !643, scopeLine: 301, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!664 = !DILocalVariable(name: "lock", arg: 1, scope: !663, file: !2, line: 300, type: !564)
!665 = !DILocation(line: 300, column: 41, scope: !663)
!666 = !DILocalVariable(name: "status", scope: !663, file: !2, line: 302, type: !149)
!667 = !DILocation(line: 302, column: 9, scope: !663)
!668 = !DILocation(line: 302, column: 43, scope: !663)
!669 = !DILocation(line: 302, column: 18, scope: !663)
!670 = !DILocation(line: 304, column: 12, scope: !663)
!671 = !DILocation(line: 304, column: 19, scope: !663)
!672 = !DILocation(line: 304, column: 5, scope: !663)
!673 = distinct !DISubprogram(name: "rwlock_unlock", scope: !2, file: !2, line: 307, type: !623, scopeLine: 308, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!674 = !DILocalVariable(name: "lock", arg: 1, scope: !673, file: !2, line: 307, type: !564)
!675 = !DILocation(line: 307, column: 38, scope: !673)
!676 = !DILocalVariable(name: "status", scope: !673, file: !2, line: 309, type: !149)
!677 = !DILocation(line: 309, column: 9, scope: !673)
!678 = !DILocation(line: 309, column: 40, scope: !673)
!679 = !DILocation(line: 309, column: 18, scope: !673)
!680 = !DILocation(line: 310, column: 5, scope: !673)
!681 = !DILocation(line: 311, column: 1, scope: !673)
!682 = distinct !DISubprogram(name: "rwlock_test", scope: !2, file: !2, line: 313, type: !372, scopeLine: 314, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!683 = !DILocalVariable(name: "lock", scope: !682, file: !2, line: 315, type: !565)
!684 = !DILocation(line: 315, column: 22, scope: !682)
!685 = !DILocation(line: 316, column: 5, scope: !682)
!686 = !DILocalVariable(name: "test_depth", scope: !682, file: !2, line: 317, type: !687)
!687 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !149)
!688 = !DILocation(line: 317, column: 15, scope: !682)
!689 = !DILocation(line: 320, column: 9, scope: !690)
!690 = distinct !DILexicalBlock(scope: !682, file: !2, line: 319, column: 5)
!691 = !DILocalVariable(name: "success", scope: !690, file: !2, line: 321, type: !352)
!692 = !DILocation(line: 321, column: 14, scope: !690)
!693 = !DILocation(line: 321, column: 24, scope: !690)
!694 = !DILocation(line: 322, column: 9, scope: !690)
!695 = !DILocation(line: 323, column: 19, scope: !690)
!696 = !DILocation(line: 323, column: 17, scope: !690)
!697 = !DILocation(line: 324, column: 9, scope: !690)
!698 = !DILocation(line: 325, column: 9, scope: !690)
!699 = !DILocation(line: 329, column: 9, scope: !700)
!700 = distinct !DILexicalBlock(scope: !682, file: !2, line: 328, column: 5)
!701 = !DILocalVariable(name: "i", scope: !702, file: !2, line: 330, type: !149)
!702 = distinct !DILexicalBlock(scope: !700, file: !2, line: 330, column: 9)
!703 = !DILocation(line: 330, column: 18, scope: !702)
!704 = !DILocation(line: 330, column: 14, scope: !702)
!705 = !DILocation(line: 330, column: 25, scope: !706)
!706 = distinct !DILexicalBlock(scope: !702, file: !2, line: 330, column: 9)
!707 = !DILocation(line: 330, column: 27, scope: !706)
!708 = !DILocation(line: 330, column: 9, scope: !702)
!709 = !DILocalVariable(name: "success", scope: !710, file: !2, line: 332, type: !352)
!710 = distinct !DILexicalBlock(scope: !706, file: !2, line: 331, column: 9)
!711 = !DILocation(line: 332, column: 18, scope: !710)
!712 = !DILocation(line: 332, column: 28, scope: !710)
!713 = !DILocation(line: 333, column: 13, scope: !710)
!714 = !DILocation(line: 334, column: 9, scope: !710)
!715 = !DILocation(line: 330, column: 42, scope: !706)
!716 = !DILocation(line: 330, column: 9, scope: !706)
!717 = distinct !{!717, !708, !718, !719}
!718 = !DILocation(line: 334, column: 9, scope: !702)
!719 = !{!"llvm.loop.mustprogress"}
!720 = !DILocalVariable(name: "success", scope: !721, file: !2, line: 337, type: !352)
!721 = distinct !DILexicalBlock(scope: !700, file: !2, line: 336, column: 9)
!722 = !DILocation(line: 337, column: 18, scope: !721)
!723 = !DILocation(line: 337, column: 28, scope: !721)
!724 = !DILocation(line: 338, column: 13, scope: !721)
!725 = !DILocation(line: 341, column: 9, scope: !700)
!726 = !DILocalVariable(name: "i", scope: !727, file: !2, line: 342, type: !149)
!727 = distinct !DILexicalBlock(scope: !700, file: !2, line: 342, column: 9)
!728 = !DILocation(line: 342, column: 18, scope: !727)
!729 = !DILocation(line: 342, column: 14, scope: !727)
!730 = !DILocation(line: 342, column: 25, scope: !731)
!731 = distinct !DILexicalBlock(scope: !727, file: !2, line: 342, column: 9)
!732 = !DILocation(line: 342, column: 27, scope: !731)
!733 = !DILocation(line: 342, column: 9, scope: !727)
!734 = !DILocation(line: 343, column: 13, scope: !735)
!735 = distinct !DILexicalBlock(scope: !731, file: !2, line: 342, column: 46)
!736 = !DILocation(line: 344, column: 9, scope: !735)
!737 = !DILocation(line: 342, column: 42, scope: !731)
!738 = !DILocation(line: 342, column: 9, scope: !731)
!739 = distinct !{!739, !733, !740, !719}
!740 = !DILocation(line: 344, column: 9, scope: !727)
!741 = !DILocation(line: 348, column: 9, scope: !742)
!742 = distinct !DILexicalBlock(scope: !682, file: !2, line: 347, column: 5)
!743 = !DILocalVariable(name: "success", scope: !742, file: !2, line: 349, type: !352)
!744 = !DILocation(line: 349, column: 14, scope: !742)
!745 = !DILocation(line: 349, column: 24, scope: !742)
!746 = !DILocation(line: 350, column: 9, scope: !742)
!747 = !DILocation(line: 351, column: 9, scope: !742)
!748 = !DILocation(line: 354, column: 5, scope: !682)
!749 = !DILocation(line: 355, column: 1, scope: !682)
!750 = distinct !DISubprogram(name: "key_destroy", scope: !2, file: !2, line: 362, type: !751, scopeLine: 363, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!751 = !DISubroutineType(types: !752)
!752 = !{null, !90}
!753 = !DILocalVariable(name: "unused_value", arg: 1, scope: !750, file: !2, line: 362, type: !90)
!754 = !DILocation(line: 362, column: 24, scope: !750)
!755 = !DILocation(line: 364, column: 21, scope: !750)
!756 = !DILocation(line: 364, column: 19, scope: !750)
!757 = !DILocation(line: 365, column: 1, scope: !750)
!758 = distinct !DISubprogram(name: "key_worker", scope: !2, file: !2, line: 367, type: !228, scopeLine: 368, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!759 = !DILocalVariable(name: "message", arg: 1, scope: !758, file: !2, line: 367, type: !90)
!760 = !DILocation(line: 367, column: 24, scope: !758)
!761 = !DILocalVariable(name: "my_secret", scope: !758, file: !2, line: 369, type: !149)
!762 = !DILocation(line: 369, column: 9, scope: !758)
!763 = !DILocalVariable(name: "status", scope: !758, file: !2, line: 371, type: !149)
!764 = !DILocation(line: 371, column: 9, scope: !758)
!765 = !DILocation(line: 371, column: 38, scope: !758)
!766 = !DILocation(line: 371, column: 18, scope: !758)
!767 = !DILocation(line: 372, column: 5, scope: !758)
!768 = !DILocalVariable(name: "my_local_data", scope: !758, file: !2, line: 374, type: !90)
!769 = !DILocation(line: 374, column: 11, scope: !758)
!770 = !DILocation(line: 374, column: 47, scope: !758)
!771 = !DILocation(line: 374, column: 27, scope: !758)
!772 = !DILocation(line: 375, column: 5, scope: !758)
!773 = !DILocation(line: 377, column: 12, scope: !758)
!774 = !DILocation(line: 377, column: 5, scope: !758)
!775 = distinct !DISubprogram(name: "key_test", scope: !2, file: !2, line: 380, type: !372, scopeLine: 381, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!776 = !DILocalVariable(name: "my_secret", scope: !775, file: !2, line: 382, type: !149)
!777 = !DILocation(line: 382, column: 9, scope: !775)
!778 = !DILocalVariable(name: "message", scope: !775, file: !2, line: 383, type: !90)
!779 = !DILocation(line: 383, column: 11, scope: !775)
!780 = !DILocalVariable(name: "status", scope: !775, file: !2, line: 384, type: !149)
!781 = !DILocation(line: 384, column: 9, scope: !775)
!782 = !DILocation(line: 386, column: 5, scope: !775)
!783 = !DILocalVariable(name: "worker", scope: !775, file: !2, line: 388, type: !211)
!784 = !DILocation(line: 388, column: 15, scope: !775)
!785 = !DILocation(line: 388, column: 50, scope: !775)
!786 = !DILocation(line: 388, column: 24, scope: !775)
!787 = !DILocation(line: 390, column: 34, scope: !775)
!788 = !DILocation(line: 390, column: 14, scope: !775)
!789 = !DILocation(line: 390, column: 12, scope: !775)
!790 = !DILocation(line: 391, column: 5, scope: !775)
!791 = !DILocalVariable(name: "my_local_data", scope: !775, file: !2, line: 393, type: !90)
!792 = !DILocation(line: 393, column: 11, scope: !775)
!793 = !DILocation(line: 393, column: 47, scope: !775)
!794 = !DILocation(line: 393, column: 27, scope: !775)
!795 = !DILocation(line: 394, column: 5, scope: !775)
!796 = !DILocation(line: 396, column: 34, scope: !775)
!797 = !DILocation(line: 396, column: 14, scope: !775)
!798 = !DILocation(line: 396, column: 12, scope: !775)
!799 = !DILocation(line: 397, column: 5, scope: !775)
!800 = !DILocalVariable(name: "result", scope: !775, file: !2, line: 399, type: !90)
!801 = !DILocation(line: 399, column: 11, scope: !775)
!802 = !DILocation(line: 399, column: 32, scope: !775)
!803 = !DILocation(line: 399, column: 20, scope: !775)
!804 = !DILocation(line: 400, column: 5, scope: !775)
!805 = !DILocation(line: 402, column: 33, scope: !775)
!806 = !DILocation(line: 402, column: 14, scope: !775)
!807 = !DILocation(line: 402, column: 12, scope: !775)
!808 = !DILocation(line: 403, column: 5, scope: !775)
!809 = !DILocation(line: 406, column: 1, scope: !775)
!810 = distinct !DISubprogram(name: "detach_test_worker0", scope: !2, file: !2, line: 410, type: !228, scopeLine: 411, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!811 = !DILocalVariable(name: "ignore", arg: 1, scope: !810, file: !2, line: 410, type: !90)
!812 = !DILocation(line: 410, column: 33, scope: !810)
!813 = !DILocation(line: 412, column: 5, scope: !810)
!814 = distinct !DISubprogram(name: "detach_test_detach", scope: !2, file: !2, line: 415, type: !228, scopeLine: 416, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!815 = !DILocalVariable(name: "ignore", arg: 1, scope: !814, file: !2, line: 415, type: !90)
!816 = !DILocation(line: 415, column: 32, scope: !814)
!817 = !DILocalVariable(name: "status", scope: !814, file: !2, line: 417, type: !149)
!818 = !DILocation(line: 417, column: 9, scope: !814)
!819 = !DILocalVariable(name: "w0", scope: !814, file: !2, line: 418, type: !211)
!820 = !DILocation(line: 418, column: 15, scope: !814)
!821 = !DILocation(line: 418, column: 20, scope: !814)
!822 = !DILocation(line: 419, column: 29, scope: !814)
!823 = !DILocation(line: 419, column: 14, scope: !814)
!824 = !DILocation(line: 419, column: 12, scope: !814)
!825 = !DILocation(line: 420, column: 5, scope: !814)
!826 = !DILocation(line: 422, column: 27, scope: !814)
!827 = !DILocation(line: 422, column: 14, scope: !814)
!828 = !DILocation(line: 422, column: 12, scope: !814)
!829 = !DILocation(line: 423, column: 5, scope: !814)
!830 = !DILocation(line: 424, column: 5, scope: !814)
!831 = distinct !DISubprogram(name: "detach_test_attr", scope: !2, file: !2, line: 427, type: !228, scopeLine: 428, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !230)
!832 = !DILocalVariable(name: "ignore", arg: 1, scope: !831, file: !2, line: 427, type: !90)
!833 = !DILocation(line: 427, column: 30, scope: !831)
!834 = !DILocalVariable(name: "status", scope: !831, file: !2, line: 429, type: !149)
!835 = !DILocation(line: 429, column: 9, scope: !831)
!836 = !DILocalVariable(name: "detachstate", scope: !831, file: !2, line: 430, type: !149)
!837 = !DILocation(line: 430, column: 9, scope: !831)
!838 = !DILocalVariable(name: "w0", scope: !831, file: !2, line: 431, type: !211)
!839 = !DILocation(line: 431, column: 15, scope: !831)
!840 = !DILocalVariable(name: "w0_attr", scope: !831, file: !2, line: 432, type: !238)
!841 = !DILocation(line: 432, column: 20, scope: !831)
!842 = !DILocation(line: 433, column: 14, scope: !831)
!843 = !DILocation(line: 433, column: 12, scope: !831)
!844 = !DILocation(line: 434, column: 5, scope: !831)
!845 = !DILocation(line: 435, column: 14, scope: !831)
!846 = !DILocation(line: 435, column: 12, scope: !831)
!847 = !DILocation(line: 436, column: 5, scope: !831)
!848 = !DILocation(line: 0, scope: !831)
!849 = !DILocation(line: 437, column: 14, scope: !831)
!850 = !DILocation(line: 437, column: 12, scope: !831)
!851 = !DILocation(line: 438, column: 5, scope: !831)
!852 = !DILocation(line: 439, column: 14, scope: !831)
!853 = !DILocation(line: 439, column: 12, scope: !831)
!854 = !DILocation(line: 440, column: 5, scope: !831)
!855 = !DILocation(line: 441, column: 14, scope: !831)
!856 = !DILocation(line: 441, column: 12, scope: !831)
!857 = !DILocation(line: 442, column: 5, scope: !831)
!858 = !DILocation(line: 443, column: 5, scope: !831)
!859 = !DILocation(line: 445, column: 27, scope: !831)
!860 = !DILocation(line: 445, column: 14, scope: !831)
!861 = !DILocation(line: 445, column: 12, scope: !831)
!862 = !DILocation(line: 446, column: 5, scope: !831)
!863 = !DILocation(line: 447, column: 5, scope: !831)
!864 = distinct !DISubprogram(name: "detach_test", scope: !2, file: !2, line: 450, type: !372, scopeLine: 451, spFlags: DISPFlagDefinition, unit: !61)
!865 = !DILocation(line: 452, column: 5, scope: !864)
!866 = !DILocation(line: 453, column: 5, scope: !864)
!867 = !DILocation(line: 454, column: 1, scope: !864)
!868 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 456, type: !869, scopeLine: 457, spFlags: DISPFlagDefinition, unit: !61)
!869 = !DISubroutineType(types: !870)
!870 = !{!149}
!871 = !DILocation(line: 458, column: 5, scope: !868)
!872 = !DILocation(line: 459, column: 5, scope: !868)
!873 = !DILocation(line: 460, column: 5, scope: !868)
!874 = !DILocation(line: 461, column: 5, scope: !868)
!875 = !DILocation(line: 462, column: 5, scope: !868)
!876 = !DILocation(line: 463, column: 1, scope: !868)
