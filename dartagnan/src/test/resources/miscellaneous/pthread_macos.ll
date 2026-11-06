; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/pthread.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/pthread.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx16.0.0"

%struct._opaque_pthread_mutex_t = type { i64, [56 x i8] }
%struct._opaque_pthread_cond_t = type { i64, [40 x i8] }
%struct._opaque_pthread_once_t = type { i64, [8 x i8] }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }
%struct._opaque_pthread_mutexattr_t = type { i64, [8 x i8] }
%struct._opaque_pthread_condattr_t = type { i64, [8 x i8] }
%struct.timespec = type { i64, i64 }
%struct._opaque_pthread_rwlockattr_t = type { i64, [16 x i8] }
%struct._opaque_pthread_rwlock_t = type { i64, [192 x i8] }

@__func__.thread_create = private unnamed_addr constant [14 x i8] c"thread_create\00", align 1, !dbg !0
@.str = private unnamed_addr constant [10 x i8] c"pthread.c\00", align 1, !dbg !8
@.str.1 = private unnamed_addr constant [12 x i8] c"status == 0\00", align 1, !dbg !13
@__func__.thread_join = private unnamed_addr constant [12 x i8] c"thread_join\00", align 1, !dbg !18
@__func__.mutex_init = private unnamed_addr constant [11 x i8] c"mutex_init\00", align 1, !dbg !21
@__func__.mutex_destroy = private unnamed_addr constant [14 x i8] c"mutex_destroy\00", align 1, !dbg !26
@__func__.mutex_lock = private unnamed_addr constant [11 x i8] c"mutex_lock\00", align 1, !dbg !28
@__func__.mutex_trylock = private unnamed_addr constant [14 x i8] c"mutex_trylock\00", align 1, !dbg !30
@.str.2 = private unnamed_addr constant [31 x i8] c"status == 0 || status == EBUSY\00", align 1, !dbg !32
@__func__.mutex_unlock = private unnamed_addr constant [13 x i8] c"mutex_unlock\00", align 1, !dbg !37
@__func__.mutex_test = private unnamed_addr constant [11 x i8] c"mutex_test\00", align 1, !dbg !42
@.str.3 = private unnamed_addr constant [9 x i8] c"!success\00", align 1, !dbg !44
@.str.4 = private unnamed_addr constant [8 x i8] c"success\00", align 1, !dbg !49
@__func__.cond_init = private unnamed_addr constant [10 x i8] c"cond_init\00", align 1, !dbg !54
@__func__.cond_destroy = private unnamed_addr constant [13 x i8] c"cond_destroy\00", align 1, !dbg !57
@__func__.cond_signal = private unnamed_addr constant [12 x i8] c"cond_signal\00", align 1, !dbg !59
@__func__.cond_broadcast = private unnamed_addr constant [15 x i8] c"cond_broadcast\00", align 1, !dbg !61
@phase = global i32 0, align 4, !dbg !66
@cond_mutex = global %struct._opaque_pthread_mutex_t zeroinitializer, align 8, !dbg !158
@cond = global %struct._opaque_pthread_cond_t zeroinitializer, align 8, !dbg !170
@__func__.cond_test = private unnamed_addr constant [10 x i8] c"cond_test\00", align 1, !dbg !74
@.str.5 = private unnamed_addr constant [18 x i8] c"result == message\00", align 1, !dbg !76
@__func__.rwlock_init = private unnamed_addr constant [12 x i8] c"rwlock_init\00", align 1, !dbg !81
@__func__.rwlock_destroy = private unnamed_addr constant [15 x i8] c"rwlock_destroy\00", align 1, !dbg !83
@__func__.rwlock_wrlock = private unnamed_addr constant [14 x i8] c"rwlock_wrlock\00", align 1, !dbg !85
@__func__.rwlock_trywrlock = private unnamed_addr constant [17 x i8] c"rwlock_trywrlock\00", align 1, !dbg !87
@__func__.rwlock_rdlock = private unnamed_addr constant [14 x i8] c"rwlock_rdlock\00", align 1, !dbg !92
@__func__.rwlock_tryrdlock = private unnamed_addr constant [17 x i8] c"rwlock_tryrdlock\00", align 1, !dbg !94
@__func__.rwlock_unlock = private unnamed_addr constant [14 x i8] c"rwlock_unlock\00", align 1, !dbg !96
@__func__.rwlock_test = private unnamed_addr constant [12 x i8] c"rwlock_test\00", align 1, !dbg !98
@latest_thread = global ptr null, align 8, !dbg !182
@local_data = global i64 0, align 8, !dbg !205
@__func__.key_worker = private unnamed_addr constant [11 x i8] c"key_worker\00", align 1, !dbg !100
@.str.6 = private unnamed_addr constant [28 x i8] c"my_local_data == &my_secret\00", align 1, !dbg !102
@__func__.key_test = private unnamed_addr constant [9 x i8] c"key_test\00", align 1, !dbg !107
@.str.7 = private unnamed_addr constant [37 x i8] c"pthread_equal(latest_thread, worker)\00", align 1, !dbg !110
@__func__.detach_test_detach = private unnamed_addr constant [19 x i8] c"detach_test_detach\00", align 1, !dbg !115
@.str.8 = private unnamed_addr constant [12 x i8] c"status != 0\00", align 1, !dbg !120
@__func__.detach_test_attr = private unnamed_addr constant [17 x i8] c"detach_test_attr\00", align 1, !dbg !122
@.str.9 = private unnamed_addr constant [54 x i8] c"status == 0 && detachstate == PTHREAD_CREATE_JOINABLE\00", align 1, !dbg !124
@.str.10 = private unnamed_addr constant [54 x i8] c"status == 0 && detachstate == PTHREAD_CREATE_DETACHED\00", align 1, !dbg !129
@once0 = global %struct._opaque_pthread_once_t { i64 816954554, [8 x i8] zeroinitializer }, align 8, !dbg !131
@once1 = global %struct._opaque_pthread_once_t { i64 816954554, [8 x i8] zeroinitializer }, align 8, !dbg !142
@once_calls = global i32 0, align 4, !dbg !211
@once_value = global i32 0, align 4, !dbg !214
@__func__.once_worker = private unnamed_addr constant [12 x i8] c"once_worker\00", align 1, !dbg !144
@.str.11 = private unnamed_addr constant [17 x i8] c"once_value == 42\00", align 1, !dbg !146
@__func__.once_test = private unnamed_addr constant [10 x i8] c"once_test\00", align 1, !dbg !149
@.str.12 = private unnamed_addr constant [16 x i8] c"once_calls == 1\00", align 1, !dbg !151
@.str.13 = private unnamed_addr constant [16 x i8] c"once_calls == 2\00", align 1, !dbg !156

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_create(ptr noundef %0, ptr noundef %1) #0 !dbg !223 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca %struct._opaque_pthread_attr_t, align 8
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !230, metadata !DIExpression()), !dbg !231
  store ptr %1, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !232, metadata !DIExpression()), !dbg !233
  call void @llvm.dbg.declare(metadata ptr %5, metadata !234, metadata !DIExpression()), !dbg !235
  call void @llvm.dbg.declare(metadata ptr %6, metadata !236, metadata !DIExpression()), !dbg !244
  %8 = call i32 @pthread_attr_init(ptr noundef %6), !dbg !245
  call void @llvm.dbg.declare(metadata ptr %7, metadata !246, metadata !DIExpression()), !dbg !247
  %9 = load ptr, ptr %3, align 8, !dbg !248
  %10 = load ptr, ptr %4, align 8, !dbg !249
  %11 = call i32 @pthread_create(ptr noundef %5, ptr noundef %6, ptr noundef %9, ptr noundef %10), !dbg !250
  store i32 %11, ptr %7, align 4, !dbg !247
  %12 = load i32, ptr %7, align 4, !dbg !251
  %13 = icmp eq i32 %12, 0, !dbg !251
  %14 = xor i1 %13, true, !dbg !251
  %15 = zext i1 %14 to i32, !dbg !251
  %16 = sext i32 %15 to i64, !dbg !251
  %17 = icmp ne i64 %16, 0, !dbg !251
  br i1 %17, label %18, label %20, !dbg !251

18:                                               ; preds = %2
  call void @__assert_rtn(ptr noundef @__func__.thread_create, ptr noundef @.str, i32 noundef 19, ptr noundef @.str.1) #4, !dbg !251
  unreachable, !dbg !251

19:                                               ; No predecessors!
  br label %21, !dbg !251

20:                                               ; preds = %2
  br label %21, !dbg !251

21:                                               ; preds = %20, %19
  %22 = call i32 @pthread_attr_destroy(ptr noundef %6), !dbg !252
  %23 = load ptr, ptr %5, align 8, !dbg !253
  ret ptr %23, !dbg !254
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @pthread_attr_init(ptr noundef) #2

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

declare i32 @pthread_attr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_join(ptr noundef %0) #0 !dbg !255 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !258, metadata !DIExpression()), !dbg !259
  call void @llvm.dbg.declare(metadata ptr %3, metadata !260, metadata !DIExpression()), !dbg !261
  call void @llvm.dbg.declare(metadata ptr %4, metadata !262, metadata !DIExpression()), !dbg !263
  %5 = load ptr, ptr %2, align 8, !dbg !264
  %6 = call i32 @"\01_pthread_join"(ptr noundef %5, ptr noundef %3), !dbg !265
  store i32 %6, ptr %4, align 4, !dbg !263
  %7 = load i32, ptr %4, align 4, !dbg !266
  %8 = icmp eq i32 %7, 0, !dbg !266
  %9 = xor i1 %8, true, !dbg !266
  %10 = zext i1 %9 to i32, !dbg !266
  %11 = sext i32 %10 to i64, !dbg !266
  %12 = icmp ne i64 %11, 0, !dbg !266
  br i1 %12, label %13, label %15, !dbg !266

13:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.thread_join, ptr noundef @.str, i32 noundef 28, ptr noundef @.str.1) #4, !dbg !266
  unreachable, !dbg !266

14:                                               ; No predecessors!
  br label %16, !dbg !266

15:                                               ; preds = %1
  br label %16, !dbg !266

16:                                               ; preds = %15, %14
  %17 = load ptr, ptr %3, align 8, !dbg !267
  ret ptr %17, !dbg !268
}

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @mutex_init(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) #0 !dbg !269 {
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca %struct._opaque_pthread_mutexattr_t, align 8
  store ptr %0, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !273, metadata !DIExpression()), !dbg !274
  store i32 %1, ptr %6, align 4
  call void @llvm.dbg.declare(metadata ptr %6, metadata !275, metadata !DIExpression()), !dbg !276
  store i32 %2, ptr %7, align 4
  call void @llvm.dbg.declare(metadata ptr %7, metadata !277, metadata !DIExpression()), !dbg !278
  store i32 %3, ptr %8, align 4
  call void @llvm.dbg.declare(metadata ptr %8, metadata !279, metadata !DIExpression()), !dbg !280
  call void @llvm.dbg.declare(metadata ptr %9, metadata !281, metadata !DIExpression()), !dbg !282
  call void @llvm.dbg.declare(metadata ptr %10, metadata !283, metadata !DIExpression()), !dbg !284
  call void @llvm.dbg.declare(metadata ptr %11, metadata !285, metadata !DIExpression()), !dbg !293
  %12 = call i32 @pthread_mutexattr_init(ptr noundef %11), !dbg !294
  store i32 %12, ptr %9, align 4, !dbg !295
  %13 = load i32, ptr %9, align 4, !dbg !296
  %14 = icmp eq i32 %13, 0, !dbg !296
  %15 = xor i1 %14, true, !dbg !296
  %16 = zext i1 %15 to i32, !dbg !296
  %17 = sext i32 %16 to i64, !dbg !296
  %18 = icmp ne i64 %17, 0, !dbg !296
  br i1 %18, label %19, label %21, !dbg !296

19:                                               ; preds = %4
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 48, ptr noundef @.str.1) #4, !dbg !296
  unreachable, !dbg !296

20:                                               ; No predecessors!
  br label %22, !dbg !296

21:                                               ; preds = %4
  br label %22, !dbg !296

22:                                               ; preds = %21, %20
  %23 = load i32, ptr %6, align 4, !dbg !297
  %24 = call i32 @pthread_mutexattr_settype(ptr noundef %11, i32 noundef %23), !dbg !298
  store i32 %24, ptr %9, align 4, !dbg !299
  %25 = load i32, ptr %9, align 4, !dbg !300
  %26 = icmp eq i32 %25, 0, !dbg !300
  %27 = xor i1 %26, true, !dbg !300
  %28 = zext i1 %27 to i32, !dbg !300
  %29 = sext i32 %28 to i64, !dbg !300
  %30 = icmp ne i64 %29, 0, !dbg !300
  br i1 %30, label %31, label %33, !dbg !300

31:                                               ; preds = %22
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 51, ptr noundef @.str.1) #4, !dbg !300
  unreachable, !dbg !300

32:                                               ; No predecessors!
  br label %34, !dbg !300

33:                                               ; preds = %22
  br label %34, !dbg !300

34:                                               ; preds = %33, %32
  %35 = call i32 @pthread_mutexattr_gettype(ptr noundef %11, ptr noundef %10), !dbg !301
  store i32 %35, ptr %9, align 4, !dbg !302
  %36 = load i32, ptr %9, align 4, !dbg !303
  %37 = icmp eq i32 %36, 0, !dbg !303
  %38 = xor i1 %37, true, !dbg !303
  %39 = zext i1 %38 to i32, !dbg !303
  %40 = sext i32 %39 to i64, !dbg !303
  %41 = icmp ne i64 %40, 0, !dbg !303
  br i1 %41, label %42, label %44, !dbg !303

42:                                               ; preds = %34
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 53, ptr noundef @.str.1) #4, !dbg !303
  unreachable, !dbg !303

43:                                               ; No predecessors!
  br label %45, !dbg !303

44:                                               ; preds = %34
  br label %45, !dbg !303

45:                                               ; preds = %44, %43
  %46 = load i32, ptr %7, align 4, !dbg !304
  %47 = call i32 @pthread_mutexattr_setprotocol(ptr noundef %11, i32 noundef %46), !dbg !305
  store i32 %47, ptr %9, align 4, !dbg !306
  %48 = load i32, ptr %9, align 4, !dbg !307
  %49 = icmp eq i32 %48, 0, !dbg !307
  %50 = xor i1 %49, true, !dbg !307
  %51 = zext i1 %50 to i32, !dbg !307
  %52 = sext i32 %51 to i64, !dbg !307
  %53 = icmp ne i64 %52, 0, !dbg !307
  br i1 %53, label %54, label %56, !dbg !307

54:                                               ; preds = %45
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 56, ptr noundef @.str.1) #4, !dbg !307
  unreachable, !dbg !307

55:                                               ; No predecessors!
  br label %57, !dbg !307

56:                                               ; preds = %45
  br label %57, !dbg !307

57:                                               ; preds = %56, %55
  %58 = call i32 @pthread_mutexattr_getprotocol(ptr noundef %11, ptr noundef %10), !dbg !308
  store i32 %58, ptr %9, align 4, !dbg !309
  %59 = load i32, ptr %9, align 4, !dbg !310
  %60 = icmp eq i32 %59, 0, !dbg !310
  %61 = xor i1 %60, true, !dbg !310
  %62 = zext i1 %61 to i32, !dbg !310
  %63 = sext i32 %62 to i64, !dbg !310
  %64 = icmp ne i64 %63, 0, !dbg !310
  br i1 %64, label %65, label %67, !dbg !310

65:                                               ; preds = %57
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 58, ptr noundef @.str.1) #4, !dbg !310
  unreachable, !dbg !310

66:                                               ; No predecessors!
  br label %68, !dbg !310

67:                                               ; preds = %57
  br label %68, !dbg !310

68:                                               ; preds = %67, %66
  %69 = load i32, ptr %8, align 4, !dbg !311
  %70 = call i32 @pthread_mutexattr_setprioceiling(ptr noundef %11, i32 noundef %69), !dbg !312
  store i32 %70, ptr %9, align 4, !dbg !313
  %71 = load i32, ptr %9, align 4, !dbg !314
  %72 = icmp eq i32 %71, 0, !dbg !314
  %73 = xor i1 %72, true, !dbg !314
  %74 = zext i1 %73 to i32, !dbg !314
  %75 = sext i32 %74 to i64, !dbg !314
  %76 = icmp ne i64 %75, 0, !dbg !314
  br i1 %76, label %77, label %79, !dbg !314

77:                                               ; preds = %68
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 61, ptr noundef @.str.1) #4, !dbg !314
  unreachable, !dbg !314

78:                                               ; No predecessors!
  br label %80, !dbg !314

79:                                               ; preds = %68
  br label %80, !dbg !314

80:                                               ; preds = %79, %78
  %81 = call i32 @pthread_mutexattr_getprioceiling(ptr noundef %11, ptr noundef %10), !dbg !315
  store i32 %81, ptr %9, align 4, !dbg !316
  %82 = load i32, ptr %9, align 4, !dbg !317
  %83 = icmp eq i32 %82, 0, !dbg !317
  %84 = xor i1 %83, true, !dbg !317
  %85 = zext i1 %84 to i32, !dbg !317
  %86 = sext i32 %85 to i64, !dbg !317
  %87 = icmp ne i64 %86, 0, !dbg !317
  br i1 %87, label %88, label %90, !dbg !317

88:                                               ; preds = %80
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 63, ptr noundef @.str.1) #4, !dbg !317
  unreachable, !dbg !317

89:                                               ; No predecessors!
  br label %91, !dbg !317

90:                                               ; preds = %80
  br label %91, !dbg !317

91:                                               ; preds = %90, %89
  %92 = load ptr, ptr %5, align 8, !dbg !318
  %93 = call i32 @pthread_mutex_init(ptr noundef %92, ptr noundef %11), !dbg !319
  store i32 %93, ptr %9, align 4, !dbg !320
  %94 = load i32, ptr %9, align 4, !dbg !321
  %95 = icmp eq i32 %94, 0, !dbg !321
  %96 = xor i1 %95, true, !dbg !321
  %97 = zext i1 %96 to i32, !dbg !321
  %98 = sext i32 %97 to i64, !dbg !321
  %99 = icmp ne i64 %98, 0, !dbg !321
  br i1 %99, label %100, label %102, !dbg !321

100:                                              ; preds = %91
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 66, ptr noundef @.str.1) #4, !dbg !321
  unreachable, !dbg !321

101:                                              ; No predecessors!
  br label %103, !dbg !321

102:                                              ; preds = %91
  br label %103, !dbg !321

103:                                              ; preds = %102, %101
  %104 = call i32 @"\01_pthread_mutexattr_destroy"(ptr noundef %11), !dbg !322
  store i32 %104, ptr %9, align 4, !dbg !323
  %105 = load i32, ptr %9, align 4, !dbg !324
  %106 = icmp eq i32 %105, 0, !dbg !324
  %107 = xor i1 %106, true, !dbg !324
  %108 = zext i1 %107 to i32, !dbg !324
  %109 = sext i32 %108 to i64, !dbg !324
  %110 = icmp ne i64 %109, 0, !dbg !324
  br i1 %110, label %111, label %113, !dbg !324

111:                                              ; preds = %103
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 68, ptr noundef @.str.1) #4, !dbg !324
  unreachable, !dbg !324

112:                                              ; No predecessors!
  br label %114, !dbg !324

113:                                              ; preds = %103
  br label %114, !dbg !324

114:                                              ; preds = %113, %112
  ret void, !dbg !325
}

declare i32 @pthread_mutexattr_init(ptr noundef) #2

declare i32 @pthread_mutexattr_settype(ptr noundef, i32 noundef) #2

declare i32 @pthread_mutexattr_gettype(ptr noundef, ptr noundef) #2

declare i32 @pthread_mutexattr_setprotocol(ptr noundef, i32 noundef) #2

declare i32 @pthread_mutexattr_getprotocol(ptr noundef, ptr noundef) #2

declare i32 @pthread_mutexattr_setprioceiling(ptr noundef, i32 noundef) #2

declare i32 @pthread_mutexattr_getprioceiling(ptr noundef, ptr noundef) #2

declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #2

declare i32 @"\01_pthread_mutexattr_destroy"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @mutex_destroy(ptr noundef %0) #0 !dbg !326 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !329, metadata !DIExpression()), !dbg !330
  call void @llvm.dbg.declare(metadata ptr %3, metadata !331, metadata !DIExpression()), !dbg !332
  %4 = load ptr, ptr %2, align 8, !dbg !333
  %5 = call i32 @pthread_mutex_destroy(ptr noundef %4), !dbg !334
  store i32 %5, ptr %3, align 4, !dbg !332
  %6 = load i32, ptr %3, align 4, !dbg !335
  %7 = icmp eq i32 %6, 0, !dbg !335
  %8 = xor i1 %7, true, !dbg !335
  %9 = zext i1 %8 to i32, !dbg !335
  %10 = sext i32 %9 to i64, !dbg !335
  %11 = icmp ne i64 %10, 0, !dbg !335
  br i1 %11, label %12, label %14, !dbg !335

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_destroy, ptr noundef @.str, i32 noundef 74, ptr noundef @.str.1) #4, !dbg !335
  unreachable, !dbg !335

13:                                               ; No predecessors!
  br label %15, !dbg !335

14:                                               ; preds = %1
  br label %15, !dbg !335

15:                                               ; preds = %14, %13
  ret void, !dbg !336
}

declare i32 @pthread_mutex_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @mutex_lock(ptr noundef %0) #0 !dbg !337 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !338, metadata !DIExpression()), !dbg !339
  call void @llvm.dbg.declare(metadata ptr %3, metadata !340, metadata !DIExpression()), !dbg !341
  %4 = load ptr, ptr %2, align 8, !dbg !342
  %5 = call i32 @pthread_mutex_lock(ptr noundef %4), !dbg !343
  store i32 %5, ptr %3, align 4, !dbg !341
  %6 = load i32, ptr %3, align 4, !dbg !344
  %7 = icmp eq i32 %6, 0, !dbg !344
  %8 = xor i1 %7, true, !dbg !344
  %9 = zext i1 %8 to i32, !dbg !344
  %10 = sext i32 %9 to i64, !dbg !344
  %11 = icmp ne i64 %10, 0, !dbg !344
  br i1 %11, label %12, label %14, !dbg !344

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_lock, ptr noundef @.str, i32 noundef 80, ptr noundef @.str.1) #4, !dbg !344
  unreachable, !dbg !344

13:                                               ; No predecessors!
  br label %15, !dbg !344

14:                                               ; preds = %1
  br label %15, !dbg !344

15:                                               ; preds = %14, %13
  ret void, !dbg !345
}

declare i32 @pthread_mutex_lock(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define zeroext i1 @mutex_trylock(ptr noundef %0) #0 !dbg !346 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !350, metadata !DIExpression()), !dbg !351
  call void @llvm.dbg.declare(metadata ptr %3, metadata !352, metadata !DIExpression()), !dbg !353
  %4 = load ptr, ptr %2, align 8, !dbg !354
  %5 = call i32 @pthread_mutex_trylock(ptr noundef %4), !dbg !355
  store i32 %5, ptr %3, align 4, !dbg !353
  %6 = load i32, ptr %3, align 4, !dbg !356
  %7 = icmp eq i32 %6, 0, !dbg !356
  br i1 %7, label %11, label %8, !dbg !356

8:                                                ; preds = %1
  %9 = load i32, ptr %3, align 4, !dbg !356
  %10 = icmp eq i32 %9, 16, !dbg !356
  br label %11, !dbg !356

11:                                               ; preds = %8, %1
  %12 = phi i1 [ true, %1 ], [ %10, %8 ]
  %13 = xor i1 %12, true, !dbg !356
  %14 = zext i1 %13 to i32, !dbg !356
  %15 = sext i32 %14 to i64, !dbg !356
  %16 = icmp ne i64 %15, 0, !dbg !356
  br i1 %16, label %17, label %19, !dbg !356

17:                                               ; preds = %11
  call void @__assert_rtn(ptr noundef @__func__.mutex_trylock, ptr noundef @.str, i32 noundef 86, ptr noundef @.str.2) #4, !dbg !356
  unreachable, !dbg !356

18:                                               ; No predecessors!
  br label %20, !dbg !356

19:                                               ; preds = %11
  br label %20, !dbg !356

20:                                               ; preds = %19, %18
  %21 = load i32, ptr %3, align 4, !dbg !357
  %22 = icmp eq i32 %21, 0, !dbg !358
  ret i1 %22, !dbg !359
}

declare i32 @pthread_mutex_trylock(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @mutex_unlock(ptr noundef %0) #0 !dbg !360 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !361, metadata !DIExpression()), !dbg !362
  call void @llvm.dbg.declare(metadata ptr %3, metadata !363, metadata !DIExpression()), !dbg !364
  %4 = load ptr, ptr %2, align 8, !dbg !365
  %5 = call i32 @pthread_mutex_unlock(ptr noundef %4), !dbg !366
  store i32 %5, ptr %3, align 4, !dbg !364
  %6 = load i32, ptr %3, align 4, !dbg !367
  %7 = icmp eq i32 %6, 0, !dbg !367
  %8 = xor i1 %7, true, !dbg !367
  %9 = zext i1 %8 to i32, !dbg !367
  %10 = sext i32 %9 to i64, !dbg !367
  %11 = icmp ne i64 %10, 0, !dbg !367
  br i1 %11, label %12, label %14, !dbg !367

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_unlock, ptr noundef @.str, i32 noundef 93, ptr noundef @.str.1) #4, !dbg !367
  unreachable, !dbg !367

13:                                               ; No predecessors!
  br label %15, !dbg !367

14:                                               ; preds = %1
  br label %15, !dbg !367

15:                                               ; preds = %14, %13
  ret void, !dbg !368
}

declare i32 @pthread_mutex_unlock(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @mutex_test() #0 !dbg !369 {
  %1 = alloca %struct._opaque_pthread_mutex_t, align 8
  %2 = alloca %struct._opaque_pthread_mutex_t, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  %5 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata ptr %1, metadata !372, metadata !DIExpression()), !dbg !373
  call void @llvm.dbg.declare(metadata ptr %2, metadata !374, metadata !DIExpression()), !dbg !375
  call void @mutex_init(ptr noundef %1, i32 noundef 1, i32 noundef 1, i32 noundef 1), !dbg !376
  call void @mutex_init(ptr noundef %2, i32 noundef 0, i32 noundef 2, i32 noundef 2), !dbg !377
  call void @mutex_lock(ptr noundef %1), !dbg !378
  call void @llvm.dbg.declare(metadata ptr %3, metadata !380, metadata !DIExpression()), !dbg !381
  %6 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !382
  %7 = zext i1 %6 to i8, !dbg !381
  store i8 %7, ptr %3, align 1, !dbg !381
  %8 = load i8, ptr %3, align 1, !dbg !383
  %9 = trunc i8 %8 to i1, !dbg !383
  %10 = xor i1 %9, true, !dbg !383
  %11 = xor i1 %10, true, !dbg !383
  %12 = zext i1 %11 to i32, !dbg !383
  %13 = sext i32 %12 to i64, !dbg !383
  %14 = icmp ne i64 %13, 0, !dbg !383
  br i1 %14, label %15, label %17, !dbg !383

15:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 107, ptr noundef @.str.3) #4, !dbg !383
  unreachable, !dbg !383

16:                                               ; No predecessors!
  br label %18, !dbg !383

17:                                               ; preds = %0
  br label %18, !dbg !383

18:                                               ; preds = %17, %16
  call void @mutex_unlock(ptr noundef %1), !dbg !384
  call void @mutex_lock(ptr noundef %2), !dbg !385
  call void @llvm.dbg.declare(metadata ptr %4, metadata !387, metadata !DIExpression()), !dbg !389
  %19 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !390
  %20 = zext i1 %19 to i8, !dbg !389
  store i8 %20, ptr %4, align 1, !dbg !389
  %21 = load i8, ptr %4, align 1, !dbg !391
  %22 = trunc i8 %21 to i1, !dbg !391
  %23 = xor i1 %22, true, !dbg !391
  %24 = zext i1 %23 to i32, !dbg !391
  %25 = sext i32 %24 to i64, !dbg !391
  %26 = icmp ne i64 %25, 0, !dbg !391
  br i1 %26, label %27, label %29, !dbg !391

27:                                               ; preds = %18
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 116, ptr noundef @.str.4) #4, !dbg !391
  unreachable, !dbg !391

28:                                               ; No predecessors!
  br label %30, !dbg !391

29:                                               ; preds = %18
  br label %30, !dbg !391

30:                                               ; preds = %29, %28
  call void @mutex_unlock(ptr noundef %1), !dbg !392
  call void @llvm.dbg.declare(metadata ptr %5, metadata !393, metadata !DIExpression()), !dbg !395
  %31 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !396
  %32 = zext i1 %31 to i8, !dbg !395
  store i8 %32, ptr %5, align 1, !dbg !395
  %33 = load i8, ptr %5, align 1, !dbg !397
  %34 = trunc i8 %33 to i1, !dbg !397
  %35 = xor i1 %34, true, !dbg !397
  %36 = zext i1 %35 to i32, !dbg !397
  %37 = sext i32 %36 to i64, !dbg !397
  %38 = icmp ne i64 %37, 0, !dbg !397
  br i1 %38, label %39, label %41, !dbg !397

39:                                               ; preds = %30
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 122, ptr noundef @.str.4) #4, !dbg !397
  unreachable, !dbg !397

40:                                               ; No predecessors!
  br label %42, !dbg !397

41:                                               ; preds = %30
  br label %42, !dbg !397

42:                                               ; preds = %41, %40
  call void @mutex_unlock(ptr noundef %1), !dbg !398
  call void @mutex_unlock(ptr noundef %2), !dbg !399
  call void @mutex_destroy(ptr noundef %2), !dbg !400
  call void @mutex_destroy(ptr noundef %1), !dbg !401
  ret void, !dbg !402
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @cond_init(ptr noundef %0) #0 !dbg !403 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca %struct._opaque_pthread_condattr_t, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !407, metadata !DIExpression()), !dbg !408
  call void @llvm.dbg.declare(metadata ptr %3, metadata !409, metadata !DIExpression()), !dbg !410
  call void @llvm.dbg.declare(metadata ptr %4, metadata !411, metadata !DIExpression()), !dbg !419
  %5 = call i32 @pthread_condattr_init(ptr noundef %4), !dbg !420
  store i32 %5, ptr %3, align 4, !dbg !421
  %6 = load i32, ptr %3, align 4, !dbg !422
  %7 = icmp eq i32 %6, 0, !dbg !422
  %8 = xor i1 %7, true, !dbg !422
  %9 = zext i1 %8 to i32, !dbg !422
  %10 = sext i32 %9 to i64, !dbg !422
  %11 = icmp ne i64 %10, 0, !dbg !422
  br i1 %11, label %12, label %14, !dbg !422

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 143, ptr noundef @.str.1) #4, !dbg !422
  unreachable, !dbg !422

13:                                               ; No predecessors!
  br label %15, !dbg !422

14:                                               ; preds = %1
  br label %15, !dbg !422

15:                                               ; preds = %14, %13
  %16 = load ptr, ptr %2, align 8, !dbg !423
  %17 = call i32 @"\01_pthread_cond_init"(ptr noundef %16, ptr noundef %4), !dbg !424
  store i32 %17, ptr %3, align 4, !dbg !425
  %18 = load i32, ptr %3, align 4, !dbg !426
  %19 = icmp eq i32 %18, 0, !dbg !426
  %20 = xor i1 %19, true, !dbg !426
  %21 = zext i1 %20 to i32, !dbg !426
  %22 = sext i32 %21 to i64, !dbg !426
  %23 = icmp ne i64 %22, 0, !dbg !426
  br i1 %23, label %24, label %26, !dbg !426

24:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 146, ptr noundef @.str.1) #4, !dbg !426
  unreachable, !dbg !426

25:                                               ; No predecessors!
  br label %27, !dbg !426

26:                                               ; preds = %15
  br label %27, !dbg !426

27:                                               ; preds = %26, %25
  %28 = call i32 @pthread_condattr_destroy(ptr noundef %4), !dbg !427
  store i32 %28, ptr %3, align 4, !dbg !428
  %29 = load i32, ptr %3, align 4, !dbg !429
  %30 = icmp eq i32 %29, 0, !dbg !429
  %31 = xor i1 %30, true, !dbg !429
  %32 = zext i1 %31 to i32, !dbg !429
  %33 = sext i32 %32 to i64, !dbg !429
  %34 = icmp ne i64 %33, 0, !dbg !429
  br i1 %34, label %35, label %37, !dbg !429

35:                                               ; preds = %27
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 149, ptr noundef @.str.1) #4, !dbg !429
  unreachable, !dbg !429

36:                                               ; No predecessors!
  br label %38, !dbg !429

37:                                               ; preds = %27
  br label %38, !dbg !429

38:                                               ; preds = %37, %36
  ret void, !dbg !430
}

declare i32 @pthread_condattr_init(ptr noundef) #2

declare i32 @"\01_pthread_cond_init"(ptr noundef, ptr noundef) #2

declare i32 @pthread_condattr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @cond_destroy(ptr noundef %0) #0 !dbg !431 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !432, metadata !DIExpression()), !dbg !433
  call void @llvm.dbg.declare(metadata ptr %3, metadata !434, metadata !DIExpression()), !dbg !435
  %4 = load ptr, ptr %2, align 8, !dbg !436
  %5 = call i32 @pthread_cond_destroy(ptr noundef %4), !dbg !437
  store i32 %5, ptr %3, align 4, !dbg !435
  %6 = load i32, ptr %3, align 4, !dbg !438
  %7 = icmp eq i32 %6, 0, !dbg !438
  %8 = xor i1 %7, true, !dbg !438
  %9 = zext i1 %8 to i32, !dbg !438
  %10 = sext i32 %9 to i64, !dbg !438
  %11 = icmp ne i64 %10, 0, !dbg !438
  br i1 %11, label %12, label %14, !dbg !438

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_destroy, ptr noundef @.str, i32 noundef 155, ptr noundef @.str.1) #4, !dbg !438
  unreachable, !dbg !438

13:                                               ; No predecessors!
  br label %15, !dbg !438

14:                                               ; preds = %1
  br label %15, !dbg !438

15:                                               ; preds = %14, %13
  ret void, !dbg !439
}

declare i32 @pthread_cond_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @cond_signal(ptr noundef %0) #0 !dbg !440 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !441, metadata !DIExpression()), !dbg !442
  call void @llvm.dbg.declare(metadata ptr %3, metadata !443, metadata !DIExpression()), !dbg !444
  %4 = load ptr, ptr %2, align 8, !dbg !445
  %5 = call i32 @pthread_cond_signal(ptr noundef %4), !dbg !446
  store i32 %5, ptr %3, align 4, !dbg !444
  %6 = load i32, ptr %3, align 4, !dbg !447
  %7 = icmp eq i32 %6, 0, !dbg !447
  %8 = xor i1 %7, true, !dbg !447
  %9 = zext i1 %8 to i32, !dbg !447
  %10 = sext i32 %9 to i64, !dbg !447
  %11 = icmp ne i64 %10, 0, !dbg !447
  br i1 %11, label %12, label %14, !dbg !447

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_signal, ptr noundef @.str, i32 noundef 161, ptr noundef @.str.1) #4, !dbg !447
  unreachable, !dbg !447

13:                                               ; No predecessors!
  br label %15, !dbg !447

14:                                               ; preds = %1
  br label %15, !dbg !447

15:                                               ; preds = %14, %13
  ret void, !dbg !448
}

declare i32 @pthread_cond_signal(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @cond_broadcast(ptr noundef %0) #0 !dbg !449 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !450, metadata !DIExpression()), !dbg !451
  call void @llvm.dbg.declare(metadata ptr %3, metadata !452, metadata !DIExpression()), !dbg !453
  %4 = load ptr, ptr %2, align 8, !dbg !454
  %5 = call i32 @pthread_cond_broadcast(ptr noundef %4), !dbg !455
  store i32 %5, ptr %3, align 4, !dbg !453
  %6 = load i32, ptr %3, align 4, !dbg !456
  %7 = icmp eq i32 %6, 0, !dbg !456
  %8 = xor i1 %7, true, !dbg !456
  %9 = zext i1 %8 to i32, !dbg !456
  %10 = sext i32 %9 to i64, !dbg !456
  %11 = icmp ne i64 %10, 0, !dbg !456
  br i1 %11, label %12, label %14, !dbg !456

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_broadcast, ptr noundef @.str, i32 noundef 167, ptr noundef @.str.1) #4, !dbg !456
  unreachable, !dbg !456

13:                                               ; No predecessors!
  br label %15, !dbg !456

14:                                               ; preds = %1
  br label %15, !dbg !456

15:                                               ; preds = %14, %13
  ret void, !dbg !457
}

declare i32 @pthread_cond_broadcast(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @cond_wait(ptr noundef %0, ptr noundef %1) #0 !dbg !458 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !461, metadata !DIExpression()), !dbg !462
  store ptr %1, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !463, metadata !DIExpression()), !dbg !464
  call void @llvm.dbg.declare(metadata ptr %5, metadata !465, metadata !DIExpression()), !dbg !466
  %6 = load ptr, ptr %3, align 8, !dbg !467
  %7 = load ptr, ptr %4, align 8, !dbg !468
  %8 = call i32 @"\01_pthread_cond_wait"(ptr noundef %6, ptr noundef %7), !dbg !469
  store i32 %8, ptr %5, align 4, !dbg !466
  ret void, !dbg !470
}

declare i32 @"\01_pthread_cond_wait"(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @cond_timedwait(ptr noundef %0, ptr noundef %1, i64 noundef %2) #0 !dbg !471 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i64, align 8
  %7 = alloca %struct.timespec, align 8
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !475, metadata !DIExpression()), !dbg !476
  store ptr %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !477, metadata !DIExpression()), !dbg !478
  store i64 %2, ptr %6, align 8
  call void @llvm.dbg.declare(metadata ptr %6, metadata !479, metadata !DIExpression()), !dbg !480
  call void @llvm.dbg.declare(metadata ptr %7, metadata !481, metadata !DIExpression()), !dbg !489
  %9 = load i64, ptr %6, align 8, !dbg !490
  call void @llvm.dbg.declare(metadata ptr %8, metadata !491, metadata !DIExpression()), !dbg !492
  %10 = load ptr, ptr %4, align 8, !dbg !493
  %11 = load ptr, ptr %5, align 8, !dbg !494
  %12 = call i32 @"\01_pthread_cond_timedwait"(ptr noundef %10, ptr noundef %11, ptr noundef %7), !dbg !495
  store i32 %12, ptr %8, align 4, !dbg !492
  ret void, !dbg !496
}

declare i32 @"\01_pthread_cond_timedwait"(ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @cond_worker(ptr noundef %0) #0 !dbg !497 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i8, align 1
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !498, metadata !DIExpression()), !dbg !499
  call void @llvm.dbg.declare(metadata ptr %4, metadata !500, metadata !DIExpression()), !dbg !501
  store i8 1, ptr %4, align 1, !dbg !501
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !502
  %5 = load i32, ptr @phase, align 4, !dbg !504
  %6 = add nsw i32 %5, 1, !dbg !504
  store i32 %6, ptr @phase, align 4, !dbg !504
  call void @cond_wait(ptr noundef @cond, ptr noundef @cond_mutex), !dbg !505
  %7 = load i32, ptr @phase, align 4, !dbg !506
  %8 = add nsw i32 %7, 1, !dbg !506
  store i32 %8, ptr @phase, align 4, !dbg !506
  %9 = load i32, ptr @phase, align 4, !dbg !507
  %10 = icmp slt i32 %9, 2, !dbg !508
  %11 = zext i1 %10 to i8, !dbg !509
  store i8 %11, ptr %4, align 1, !dbg !509
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !510
  %12 = load i8, ptr %4, align 1, !dbg !511
  %13 = trunc i8 %12 to i1, !dbg !511
  br i1 %13, label %14, label %17, !dbg !513

14:                                               ; preds = %1
  %15 = load ptr, ptr %3, align 8, !dbg !514
  %16 = getelementptr inbounds i8, ptr %15, i64 1, !dbg !515
  store ptr %16, ptr %2, align 8, !dbg !516
  br label %32, !dbg !516

17:                                               ; preds = %1
  store i8 1, ptr %4, align 1, !dbg !517
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !518
  %18 = load i32, ptr @phase, align 4, !dbg !520
  %19 = add nsw i32 %18, 1, !dbg !520
  store i32 %19, ptr @phase, align 4, !dbg !520
  call void @cond_timedwait(ptr noundef @cond, ptr noundef @cond_mutex, i64 noundef 10), !dbg !521
  %20 = load i32, ptr @phase, align 4, !dbg !522
  %21 = add nsw i32 %20, 1, !dbg !522
  store i32 %21, ptr @phase, align 4, !dbg !522
  %22 = load i32, ptr @phase, align 4, !dbg !523
  %23 = icmp sgt i32 %22, 6, !dbg !524
  %24 = zext i1 %23 to i8, !dbg !525
  store i8 %24, ptr %4, align 1, !dbg !525
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !526
  %25 = load i8, ptr %4, align 1, !dbg !527
  %26 = trunc i8 %25 to i1, !dbg !527
  br i1 %26, label %27, label %30, !dbg !529

27:                                               ; preds = %17
  %28 = load ptr, ptr %3, align 8, !dbg !530
  %29 = getelementptr inbounds i8, ptr %28, i64 2, !dbg !531
  store ptr %29, ptr %2, align 8, !dbg !532
  br label %32, !dbg !532

30:                                               ; preds = %17
  %31 = load ptr, ptr %3, align 8, !dbg !533
  store ptr %31, ptr %2, align 8, !dbg !534
  br label %32, !dbg !534

32:                                               ; preds = %30, %27, %14
  %33 = load ptr, ptr %2, align 8, !dbg !535
  ret ptr %33, !dbg !535
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @cond_test() #0 !dbg !536 {
  %1 = alloca ptr, align 8
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  call void @llvm.dbg.declare(metadata ptr %1, metadata !537, metadata !DIExpression()), !dbg !538
  store ptr inttoptr (i64 42 to ptr), ptr %1, align 8, !dbg !538
  call void @mutex_init(ptr noundef @cond_mutex, i32 noundef 0, i32 noundef 0, i32 noundef 0), !dbg !539
  call void @cond_init(ptr noundef @cond), !dbg !540
  call void @llvm.dbg.declare(metadata ptr %2, metadata !541, metadata !DIExpression()), !dbg !542
  %4 = load ptr, ptr %1, align 8, !dbg !543
  %5 = call ptr @thread_create(ptr noundef @cond_worker, ptr noundef %4), !dbg !544
  store ptr %5, ptr %2, align 8, !dbg !542
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !545
  %6 = load i32, ptr @phase, align 4, !dbg !547
  %7 = add nsw i32 %6, 1, !dbg !547
  store i32 %7, ptr @phase, align 4, !dbg !547
  call void @cond_signal(ptr noundef @cond), !dbg !548
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !549
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !550
  %8 = load i32, ptr @phase, align 4, !dbg !552
  %9 = add nsw i32 %8, 1, !dbg !552
  store i32 %9, ptr @phase, align 4, !dbg !552
  call void @cond_broadcast(ptr noundef @cond), !dbg !553
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !554
  call void @llvm.dbg.declare(metadata ptr %3, metadata !555, metadata !DIExpression()), !dbg !556
  %10 = load ptr, ptr %2, align 8, !dbg !557
  %11 = call ptr @thread_join(ptr noundef %10), !dbg !558
  store ptr %11, ptr %3, align 8, !dbg !556
  %12 = load ptr, ptr %3, align 8, !dbg !559
  %13 = load ptr, ptr %1, align 8, !dbg !559
  %14 = icmp eq ptr %12, %13, !dbg !559
  %15 = xor i1 %14, true, !dbg !559
  %16 = zext i1 %15 to i32, !dbg !559
  %17 = sext i32 %16 to i64, !dbg !559
  %18 = icmp ne i64 %17, 0, !dbg !559
  br i1 %18, label %19, label %21, !dbg !559

19:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.cond_test, ptr noundef @.str, i32 noundef 241, ptr noundef @.str.5) #4, !dbg !559
  unreachable, !dbg !559

20:                                               ; No predecessors!
  br label %22, !dbg !559

21:                                               ; preds = %0
  br label %22, !dbg !559

22:                                               ; preds = %21, %20
  call void @cond_destroy(ptr noundef @cond), !dbg !560
  call void @mutex_destroy(ptr noundef @cond_mutex), !dbg !561
  ret void, !dbg !562
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @rwlock_init(ptr noundef %0, i32 noundef %1) #0 !dbg !563 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca %struct._opaque_pthread_rwlockattr_t, align 8
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !577, metadata !DIExpression()), !dbg !578
  store i32 %1, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !579, metadata !DIExpression()), !dbg !580
  call void @llvm.dbg.declare(metadata ptr %5, metadata !581, metadata !DIExpression()), !dbg !582
  call void @llvm.dbg.declare(metadata ptr %6, metadata !583, metadata !DIExpression()), !dbg !584
  call void @llvm.dbg.declare(metadata ptr %7, metadata !585, metadata !DIExpression()), !dbg !593
  %8 = call i32 @pthread_rwlockattr_init(ptr noundef %7), !dbg !594
  store i32 %8, ptr %5, align 4, !dbg !595
  %9 = load i32, ptr %5, align 4, !dbg !596
  %10 = icmp eq i32 %9, 0, !dbg !596
  %11 = xor i1 %10, true, !dbg !596
  %12 = zext i1 %11 to i32, !dbg !596
  %13 = sext i32 %12 to i64, !dbg !596
  %14 = icmp ne i64 %13, 0, !dbg !596
  br i1 %14, label %15, label %17, !dbg !596

15:                                               ; preds = %2
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 258, ptr noundef @.str.1) #4, !dbg !596
  unreachable, !dbg !596

16:                                               ; No predecessors!
  br label %18, !dbg !596

17:                                               ; preds = %2
  br label %18, !dbg !596

18:                                               ; preds = %17, %16
  %19 = load i32, ptr %4, align 4, !dbg !597
  %20 = call i32 @pthread_rwlockattr_setpshared(ptr noundef %7, i32 noundef %19), !dbg !598
  store i32 %20, ptr %5, align 4, !dbg !599
  %21 = load i32, ptr %5, align 4, !dbg !600
  %22 = icmp eq i32 %21, 0, !dbg !600
  %23 = xor i1 %22, true, !dbg !600
  %24 = zext i1 %23 to i32, !dbg !600
  %25 = sext i32 %24 to i64, !dbg !600
  %26 = icmp ne i64 %25, 0, !dbg !600
  br i1 %26, label %27, label %29, !dbg !600

27:                                               ; preds = %18
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 261, ptr noundef @.str.1) #4, !dbg !600
  unreachable, !dbg !600

28:                                               ; No predecessors!
  br label %30, !dbg !600

29:                                               ; preds = %18
  br label %30, !dbg !600

30:                                               ; preds = %29, %28
  %31 = call i32 @pthread_rwlockattr_getpshared(ptr noundef %7, ptr noundef %6), !dbg !601
  store i32 %31, ptr %5, align 4, !dbg !602
  %32 = load i32, ptr %5, align 4, !dbg !603
  %33 = icmp eq i32 %32, 0, !dbg !603
  %34 = xor i1 %33, true, !dbg !603
  %35 = zext i1 %34 to i32, !dbg !603
  %36 = sext i32 %35 to i64, !dbg !603
  %37 = icmp ne i64 %36, 0, !dbg !603
  br i1 %37, label %38, label %40, !dbg !603

38:                                               ; preds = %30
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 263, ptr noundef @.str.1) #4, !dbg !603
  unreachable, !dbg !603

39:                                               ; No predecessors!
  br label %41, !dbg !603

40:                                               ; preds = %30
  br label %41, !dbg !603

41:                                               ; preds = %40, %39
  %42 = load ptr, ptr %3, align 8, !dbg !604
  %43 = call i32 @"\01_pthread_rwlock_init"(ptr noundef %42, ptr noundef %7), !dbg !605
  store i32 %43, ptr %5, align 4, !dbg !606
  %44 = load i32, ptr %5, align 4, !dbg !607
  %45 = icmp eq i32 %44, 0, !dbg !607
  %46 = xor i1 %45, true, !dbg !607
  %47 = zext i1 %46 to i32, !dbg !607
  %48 = sext i32 %47 to i64, !dbg !607
  %49 = icmp ne i64 %48, 0, !dbg !607
  br i1 %49, label %50, label %52, !dbg !607

50:                                               ; preds = %41
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 266, ptr noundef @.str.1) #4, !dbg !607
  unreachable, !dbg !607

51:                                               ; No predecessors!
  br label %53, !dbg !607

52:                                               ; preds = %41
  br label %53, !dbg !607

53:                                               ; preds = %52, %51
  %54 = call i32 @pthread_rwlockattr_destroy(ptr noundef %7), !dbg !608
  store i32 %54, ptr %5, align 4, !dbg !609
  %55 = load i32, ptr %5, align 4, !dbg !610
  %56 = icmp eq i32 %55, 0, !dbg !610
  %57 = xor i1 %56, true, !dbg !610
  %58 = zext i1 %57 to i32, !dbg !610
  %59 = sext i32 %58 to i64, !dbg !610
  %60 = icmp ne i64 %59, 0, !dbg !610
  br i1 %60, label %61, label %63, !dbg !610

61:                                               ; preds = %53
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 268, ptr noundef @.str.1) #4, !dbg !610
  unreachable, !dbg !610

62:                                               ; No predecessors!
  br label %64, !dbg !610

63:                                               ; preds = %53
  br label %64, !dbg !610

64:                                               ; preds = %63, %62
  ret void, !dbg !611
}

declare i32 @pthread_rwlockattr_init(ptr noundef) #2

declare i32 @pthread_rwlockattr_setpshared(ptr noundef, i32 noundef) #2

declare i32 @pthread_rwlockattr_getpshared(ptr noundef, ptr noundef) #2

declare i32 @"\01_pthread_rwlock_init"(ptr noundef, ptr noundef) #2

declare i32 @pthread_rwlockattr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @rwlock_destroy(ptr noundef %0) #0 !dbg !612 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !615, metadata !DIExpression()), !dbg !616
  call void @llvm.dbg.declare(metadata ptr %3, metadata !617, metadata !DIExpression()), !dbg !618
  %4 = load ptr, ptr %2, align 8, !dbg !619
  %5 = call i32 @"\01_pthread_rwlock_destroy"(ptr noundef %4), !dbg !620
  store i32 %5, ptr %3, align 4, !dbg !618
  %6 = load i32, ptr %3, align 4, !dbg !621
  %7 = icmp eq i32 %6, 0, !dbg !621
  %8 = xor i1 %7, true, !dbg !621
  %9 = zext i1 %8 to i32, !dbg !621
  %10 = sext i32 %9 to i64, !dbg !621
  %11 = icmp ne i64 %10, 0, !dbg !621
  br i1 %11, label %12, label %14, !dbg !621

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_destroy, ptr noundef @.str, i32 noundef 274, ptr noundef @.str.1) #4, !dbg !621
  unreachable, !dbg !621

13:                                               ; No predecessors!
  br label %15, !dbg !621

14:                                               ; preds = %1
  br label %15, !dbg !621

15:                                               ; preds = %14, %13
  ret void, !dbg !622
}

declare i32 @"\01_pthread_rwlock_destroy"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @rwlock_wrlock(ptr noundef %0) #0 !dbg !623 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !624, metadata !DIExpression()), !dbg !625
  call void @llvm.dbg.declare(metadata ptr %3, metadata !626, metadata !DIExpression()), !dbg !627
  %4 = load ptr, ptr %2, align 8, !dbg !628
  %5 = call i32 @"\01_pthread_rwlock_wrlock"(ptr noundef %4), !dbg !629
  store i32 %5, ptr %3, align 4, !dbg !627
  %6 = load i32, ptr %3, align 4, !dbg !630
  %7 = icmp eq i32 %6, 0, !dbg !630
  %8 = xor i1 %7, true, !dbg !630
  %9 = zext i1 %8 to i32, !dbg !630
  %10 = sext i32 %9 to i64, !dbg !630
  %11 = icmp ne i64 %10, 0, !dbg !630
  br i1 %11, label %12, label %14, !dbg !630

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_wrlock, ptr noundef @.str, i32 noundef 280, ptr noundef @.str.1) #4, !dbg !630
  unreachable, !dbg !630

13:                                               ; No predecessors!
  br label %15, !dbg !630

14:                                               ; preds = %1
  br label %15, !dbg !630

15:                                               ; preds = %14, %13
  ret void, !dbg !631
}

declare i32 @"\01_pthread_rwlock_wrlock"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define zeroext i1 @rwlock_trywrlock(ptr noundef %0) #0 !dbg !632 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !635, metadata !DIExpression()), !dbg !636
  call void @llvm.dbg.declare(metadata ptr %3, metadata !637, metadata !DIExpression()), !dbg !638
  %4 = load ptr, ptr %2, align 8, !dbg !639
  %5 = call i32 @"\01_pthread_rwlock_trywrlock"(ptr noundef %4), !dbg !640
  store i32 %5, ptr %3, align 4, !dbg !638
  %6 = load i32, ptr %3, align 4, !dbg !641
  %7 = icmp eq i32 %6, 0, !dbg !641
  br i1 %7, label %11, label %8, !dbg !641

8:                                                ; preds = %1
  %9 = load i32, ptr %3, align 4, !dbg !641
  %10 = icmp eq i32 %9, 16, !dbg !641
  br label %11, !dbg !641

11:                                               ; preds = %8, %1
  %12 = phi i1 [ true, %1 ], [ %10, %8 ]
  %13 = xor i1 %12, true, !dbg !641
  %14 = zext i1 %13 to i32, !dbg !641
  %15 = sext i32 %14 to i64, !dbg !641
  %16 = icmp ne i64 %15, 0, !dbg !641
  br i1 %16, label %17, label %19, !dbg !641

17:                                               ; preds = %11
  call void @__assert_rtn(ptr noundef @__func__.rwlock_trywrlock, ptr noundef @.str, i32 noundef 286, ptr noundef @.str.2) #4, !dbg !641
  unreachable, !dbg !641

18:                                               ; No predecessors!
  br label %20, !dbg !641

19:                                               ; preds = %11
  br label %20, !dbg !641

20:                                               ; preds = %19, %18
  %21 = load i32, ptr %3, align 4, !dbg !642
  %22 = icmp eq i32 %21, 0, !dbg !643
  ret i1 %22, !dbg !644
}

declare i32 @"\01_pthread_rwlock_trywrlock"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @rwlock_rdlock(ptr noundef %0) #0 !dbg !645 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !646, metadata !DIExpression()), !dbg !647
  call void @llvm.dbg.declare(metadata ptr %3, metadata !648, metadata !DIExpression()), !dbg !649
  %4 = load ptr, ptr %2, align 8, !dbg !650
  %5 = call i32 @"\01_pthread_rwlock_rdlock"(ptr noundef %4), !dbg !651
  store i32 %5, ptr %3, align 4, !dbg !649
  %6 = load i32, ptr %3, align 4, !dbg !652
  %7 = icmp eq i32 %6, 0, !dbg !652
  %8 = xor i1 %7, true, !dbg !652
  %9 = zext i1 %8 to i32, !dbg !652
  %10 = sext i32 %9 to i64, !dbg !652
  %11 = icmp ne i64 %10, 0, !dbg !652
  br i1 %11, label %12, label %14, !dbg !652

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_rdlock, ptr noundef @.str, i32 noundef 293, ptr noundef @.str.1) #4, !dbg !652
  unreachable, !dbg !652

13:                                               ; No predecessors!
  br label %15, !dbg !652

14:                                               ; preds = %1
  br label %15, !dbg !652

15:                                               ; preds = %14, %13
  ret void, !dbg !653
}

declare i32 @"\01_pthread_rwlock_rdlock"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define zeroext i1 @rwlock_tryrdlock(ptr noundef %0) #0 !dbg !654 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !655, metadata !DIExpression()), !dbg !656
  call void @llvm.dbg.declare(metadata ptr %3, metadata !657, metadata !DIExpression()), !dbg !658
  %4 = load ptr, ptr %2, align 8, !dbg !659
  %5 = call i32 @"\01_pthread_rwlock_tryrdlock"(ptr noundef %4), !dbg !660
  store i32 %5, ptr %3, align 4, !dbg !658
  %6 = load i32, ptr %3, align 4, !dbg !661
  %7 = icmp eq i32 %6, 0, !dbg !661
  br i1 %7, label %11, label %8, !dbg !661

8:                                                ; preds = %1
  %9 = load i32, ptr %3, align 4, !dbg !661
  %10 = icmp eq i32 %9, 16, !dbg !661
  br label %11, !dbg !661

11:                                               ; preds = %8, %1
  %12 = phi i1 [ true, %1 ], [ %10, %8 ]
  %13 = xor i1 %12, true, !dbg !661
  %14 = zext i1 %13 to i32, !dbg !661
  %15 = sext i32 %14 to i64, !dbg !661
  %16 = icmp ne i64 %15, 0, !dbg !661
  br i1 %16, label %17, label %19, !dbg !661

17:                                               ; preds = %11
  call void @__assert_rtn(ptr noundef @__func__.rwlock_tryrdlock, ptr noundef @.str, i32 noundef 299, ptr noundef @.str.2) #4, !dbg !661
  unreachable, !dbg !661

18:                                               ; No predecessors!
  br label %20, !dbg !661

19:                                               ; preds = %11
  br label %20, !dbg !661

20:                                               ; preds = %19, %18
  %21 = load i32, ptr %3, align 4, !dbg !662
  %22 = icmp eq i32 %21, 0, !dbg !663
  ret i1 %22, !dbg !664
}

declare i32 @"\01_pthread_rwlock_tryrdlock"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @rwlock_unlock(ptr noundef %0) #0 !dbg !665 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !666, metadata !DIExpression()), !dbg !667
  call void @llvm.dbg.declare(metadata ptr %3, metadata !668, metadata !DIExpression()), !dbg !669
  %4 = load ptr, ptr %2, align 8, !dbg !670
  %5 = call i32 @"\01_pthread_rwlock_unlock"(ptr noundef %4), !dbg !671
  store i32 %5, ptr %3, align 4, !dbg !669
  %6 = load i32, ptr %3, align 4, !dbg !672
  %7 = icmp eq i32 %6, 0, !dbg !672
  %8 = xor i1 %7, true, !dbg !672
  %9 = zext i1 %8 to i32, !dbg !672
  %10 = sext i32 %9 to i64, !dbg !672
  %11 = icmp ne i64 %10, 0, !dbg !672
  br i1 %11, label %12, label %14, !dbg !672

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_unlock, ptr noundef @.str, i32 noundef 306, ptr noundef @.str.1) #4, !dbg !672
  unreachable, !dbg !672

13:                                               ; No predecessors!
  br label %15, !dbg !672

14:                                               ; preds = %1
  br label %15, !dbg !672

15:                                               ; preds = %14, %13
  ret void, !dbg !673
}

declare i32 @"\01_pthread_rwlock_unlock"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @rwlock_test() #0 !dbg !674 {
  %1 = alloca %struct._opaque_pthread_rwlock_t, align 8
  %2 = alloca i32, align 4
  %3 = alloca i8, align 1
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  %6 = alloca i8, align 1
  %7 = alloca i32, align 4
  %8 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata ptr %1, metadata !675, metadata !DIExpression()), !dbg !676
  call void @rwlock_init(ptr noundef %1, i32 noundef 2), !dbg !677
  call void @llvm.dbg.declare(metadata ptr %2, metadata !678, metadata !DIExpression()), !dbg !680
  store i32 4, ptr %2, align 4, !dbg !680
  call void @rwlock_wrlock(ptr noundef %1), !dbg !681
  call void @llvm.dbg.declare(metadata ptr %3, metadata !683, metadata !DIExpression()), !dbg !684
  %9 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !685
  %10 = zext i1 %9 to i8, !dbg !684
  store i8 %10, ptr %3, align 1, !dbg !684
  %11 = load i8, ptr %3, align 1, !dbg !686
  %12 = trunc i8 %11 to i1, !dbg !686
  %13 = xor i1 %12, true, !dbg !686
  %14 = xor i1 %13, true, !dbg !686
  %15 = zext i1 %14 to i32, !dbg !686
  %16 = sext i32 %15 to i64, !dbg !686
  %17 = icmp ne i64 %16, 0, !dbg !686
  br i1 %17, label %18, label %20, !dbg !686

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 318, ptr noundef @.str.3) #4, !dbg !686
  unreachable, !dbg !686

19:                                               ; No predecessors!
  br label %21, !dbg !686

20:                                               ; preds = %0
  br label %21, !dbg !686

21:                                               ; preds = %20, %19
  %22 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %1), !dbg !687
  %23 = zext i1 %22 to i8, !dbg !688
  store i8 %23, ptr %3, align 1, !dbg !688
  %24 = load i8, ptr %3, align 1, !dbg !689
  %25 = trunc i8 %24 to i1, !dbg !689
  %26 = xor i1 %25, true, !dbg !689
  %27 = xor i1 %26, true, !dbg !689
  %28 = zext i1 %27 to i32, !dbg !689
  %29 = sext i32 %28 to i64, !dbg !689
  %30 = icmp ne i64 %29, 0, !dbg !689
  br i1 %30, label %31, label %33, !dbg !689

31:                                               ; preds = %21
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 320, ptr noundef @.str.3) #4, !dbg !689
  unreachable, !dbg !689

32:                                               ; No predecessors!
  br label %34, !dbg !689

33:                                               ; preds = %21
  br label %34, !dbg !689

34:                                               ; preds = %33, %32
  call void @rwlock_unlock(ptr noundef %1), !dbg !690
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !691
  call void @llvm.dbg.declare(metadata ptr %4, metadata !693, metadata !DIExpression()), !dbg !695
  store i32 0, ptr %4, align 4, !dbg !695
  br label %35, !dbg !696

35:                                               ; preds = %51, %34
  %36 = load i32, ptr %4, align 4, !dbg !697
  %37 = icmp slt i32 %36, 4, !dbg !699
  br i1 %37, label %38, label %54, !dbg !700

38:                                               ; preds = %35
  call void @llvm.dbg.declare(metadata ptr %5, metadata !701, metadata !DIExpression()), !dbg !703
  %39 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %1), !dbg !704
  %40 = zext i1 %39 to i8, !dbg !703
  store i8 %40, ptr %5, align 1, !dbg !703
  %41 = load i8, ptr %5, align 1, !dbg !705
  %42 = trunc i8 %41 to i1, !dbg !705
  %43 = xor i1 %42, true, !dbg !705
  %44 = zext i1 %43 to i32, !dbg !705
  %45 = sext i32 %44 to i64, !dbg !705
  %46 = icmp ne i64 %45, 0, !dbg !705
  br i1 %46, label %47, label %49, !dbg !705

47:                                               ; preds = %38
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 329, ptr noundef @.str.4) #4, !dbg !705
  unreachable, !dbg !705

48:                                               ; No predecessors!
  br label %50, !dbg !705

49:                                               ; preds = %38
  br label %50, !dbg !705

50:                                               ; preds = %49, %48
  br label %51, !dbg !706

51:                                               ; preds = %50
  %52 = load i32, ptr %4, align 4, !dbg !707
  %53 = add nsw i32 %52, 1, !dbg !707
  store i32 %53, ptr %4, align 4, !dbg !707
  br label %35, !dbg !708, !llvm.loop !709

54:                                               ; preds = %35
  call void @llvm.dbg.declare(metadata ptr %6, metadata !712, metadata !DIExpression()), !dbg !714
  %55 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !715
  %56 = zext i1 %55 to i8, !dbg !714
  store i8 %56, ptr %6, align 1, !dbg !714
  %57 = load i8, ptr %6, align 1, !dbg !716
  %58 = trunc i8 %57 to i1, !dbg !716
  %59 = xor i1 %58, true, !dbg !716
  %60 = xor i1 %59, true, !dbg !716
  %61 = zext i1 %60 to i32, !dbg !716
  %62 = sext i32 %61 to i64, !dbg !716
  %63 = icmp ne i64 %62, 0, !dbg !716
  br i1 %63, label %64, label %66, !dbg !716

64:                                               ; preds = %54
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 334, ptr noundef @.str.3) #4, !dbg !716
  unreachable, !dbg !716

65:                                               ; No predecessors!
  br label %67, !dbg !716

66:                                               ; preds = %54
  br label %67, !dbg !716

67:                                               ; preds = %66, %65
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !717
  call void @llvm.dbg.declare(metadata ptr %7, metadata !718, metadata !DIExpression()), !dbg !720
  store i32 0, ptr %7, align 4, !dbg !720
  br label %68, !dbg !721

68:                                               ; preds = %72, %67
  %69 = load i32, ptr %7, align 4, !dbg !722
  %70 = icmp slt i32 %69, 4, !dbg !724
  br i1 %70, label %71, label %75, !dbg !725

71:                                               ; preds = %68
  call void @rwlock_unlock(ptr noundef %1), !dbg !726
  br label %72, !dbg !728

72:                                               ; preds = %71
  %73 = load i32, ptr %7, align 4, !dbg !729
  %74 = add nsw i32 %73, 1, !dbg !729
  store i32 %74, ptr %7, align 4, !dbg !729
  br label %68, !dbg !730, !llvm.loop !731

75:                                               ; preds = %68
  call void @rwlock_wrlock(ptr noundef %1), !dbg !733
  call void @llvm.dbg.declare(metadata ptr %8, metadata !735, metadata !DIExpression()), !dbg !736
  %76 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !737
  %77 = zext i1 %76 to i8, !dbg !736
  store i8 %77, ptr %8, align 1, !dbg !736
  %78 = load i8, ptr %8, align 1, !dbg !738
  %79 = trunc i8 %78 to i1, !dbg !738
  %80 = xor i1 %79, true, !dbg !738
  %81 = xor i1 %80, true, !dbg !738
  %82 = zext i1 %81 to i32, !dbg !738
  %83 = sext i32 %82 to i64, !dbg !738
  %84 = icmp ne i64 %83, 0, !dbg !738
  br i1 %84, label %85, label %87, !dbg !738

85:                                               ; preds = %75
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 346, ptr noundef @.str.3) #4, !dbg !738
  unreachable, !dbg !738

86:                                               ; No predecessors!
  br label %88, !dbg !738

87:                                               ; preds = %75
  br label %88, !dbg !738

88:                                               ; preds = %87, %86
  call void @rwlock_unlock(ptr noundef %1), !dbg !739
  call void @rwlock_destroy(ptr noundef %1), !dbg !740
  ret void, !dbg !741
}

declare void @__VERIFIER_loop_bound(i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @key_destroy(ptr noundef %0) #0 !dbg !742 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !743, metadata !DIExpression()), !dbg !744
  %3 = call ptr @pthread_self(), !dbg !745
  store ptr %3, ptr @latest_thread, align 8, !dbg !746
  ret void, !dbg !747
}

declare ptr @pthread_self() #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @key_worker(ptr noundef %0) #0 !dbg !748 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !749, metadata !DIExpression()), !dbg !750
  call void @llvm.dbg.declare(metadata ptr %3, metadata !751, metadata !DIExpression()), !dbg !752
  store i32 1, ptr %3, align 4, !dbg !752
  call void @llvm.dbg.declare(metadata ptr %4, metadata !753, metadata !DIExpression()), !dbg !754
  %6 = load i64, ptr @local_data, align 8, !dbg !755
  %7 = call i32 @pthread_setspecific(i64 noundef %6, ptr noundef %3), !dbg !756
  store i32 %7, ptr %4, align 4, !dbg !754
  %8 = load i32, ptr %4, align 4, !dbg !757
  %9 = icmp eq i32 %8, 0, !dbg !757
  %10 = xor i1 %9, true, !dbg !757
  %11 = zext i1 %10 to i32, !dbg !757
  %12 = sext i32 %11 to i64, !dbg !757
  %13 = icmp ne i64 %12, 0, !dbg !757
  br i1 %13, label %14, label %16, !dbg !757

14:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.key_worker, ptr noundef @.str, i32 noundef 368, ptr noundef @.str.1) #4, !dbg !757
  unreachable, !dbg !757

15:                                               ; No predecessors!
  br label %17, !dbg !757

16:                                               ; preds = %1
  br label %17, !dbg !757

17:                                               ; preds = %16, %15
  call void @llvm.dbg.declare(metadata ptr %5, metadata !758, metadata !DIExpression()), !dbg !759
  %18 = load i64, ptr @local_data, align 8, !dbg !760
  %19 = call ptr @pthread_getspecific(i64 noundef %18), !dbg !761
  store ptr %19, ptr %5, align 8, !dbg !759
  %20 = load ptr, ptr %5, align 8, !dbg !762
  %21 = icmp eq ptr %20, %3, !dbg !762
  %22 = xor i1 %21, true, !dbg !762
  %23 = zext i1 %22 to i32, !dbg !762
  %24 = sext i32 %23 to i64, !dbg !762
  %25 = icmp ne i64 %24, 0, !dbg !762
  br i1 %25, label %26, label %28, !dbg !762

26:                                               ; preds = %17
  call void @__assert_rtn(ptr noundef @__func__.key_worker, ptr noundef @.str, i32 noundef 371, ptr noundef @.str.6) #4, !dbg !762
  unreachable, !dbg !762

27:                                               ; No predecessors!
  br label %29, !dbg !762

28:                                               ; preds = %17
  br label %29, !dbg !762

29:                                               ; preds = %28, %27
  %30 = load ptr, ptr %2, align 8, !dbg !763
  ret ptr %30, !dbg !764
}

declare i32 @pthread_setspecific(i64 noundef, ptr noundef) #2

declare ptr @pthread_getspecific(i64 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @key_test() #0 !dbg !765 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  call void @llvm.dbg.declare(metadata ptr %1, metadata !766, metadata !DIExpression()), !dbg !767
  store i32 2, ptr %1, align 4, !dbg !767
  call void @llvm.dbg.declare(metadata ptr %2, metadata !768, metadata !DIExpression()), !dbg !769
  store ptr inttoptr (i64 41 to ptr), ptr %2, align 8, !dbg !769
  call void @llvm.dbg.declare(metadata ptr %3, metadata !770, metadata !DIExpression()), !dbg !771
  %7 = call i32 @pthread_key_create(ptr noundef @local_data, ptr noundef @key_destroy), !dbg !772
  call void @llvm.dbg.declare(metadata ptr %4, metadata !773, metadata !DIExpression()), !dbg !774
  %8 = load ptr, ptr %2, align 8, !dbg !775
  %9 = call ptr @thread_create(ptr noundef @key_worker, ptr noundef %8), !dbg !776
  store ptr %9, ptr %4, align 8, !dbg !774
  %10 = load i64, ptr @local_data, align 8, !dbg !777
  %11 = call i32 @pthread_setspecific(i64 noundef %10, ptr noundef %1), !dbg !778
  store i32 %11, ptr %3, align 4, !dbg !779
  %12 = load i32, ptr %3, align 4, !dbg !780
  %13 = icmp eq i32 %12, 0, !dbg !780
  %14 = xor i1 %13, true, !dbg !780
  %15 = zext i1 %14 to i32, !dbg !780
  %16 = sext i32 %15 to i64, !dbg !780
  %17 = icmp ne i64 %16, 0, !dbg !780
  br i1 %17, label %18, label %20, !dbg !780

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 387, ptr noundef @.str.1) #4, !dbg !780
  unreachable, !dbg !780

19:                                               ; No predecessors!
  br label %21, !dbg !780

20:                                               ; preds = %0
  br label %21, !dbg !780

21:                                               ; preds = %20, %19
  call void @llvm.dbg.declare(metadata ptr %5, metadata !781, metadata !DIExpression()), !dbg !782
  %22 = load i64, ptr @local_data, align 8, !dbg !783
  %23 = call ptr @pthread_getspecific(i64 noundef %22), !dbg !784
  store ptr %23, ptr %5, align 8, !dbg !782
  %24 = load ptr, ptr %5, align 8, !dbg !785
  %25 = icmp eq ptr %24, %1, !dbg !785
  %26 = xor i1 %25, true, !dbg !785
  %27 = zext i1 %26 to i32, !dbg !785
  %28 = sext i32 %27 to i64, !dbg !785
  %29 = icmp ne i64 %28, 0, !dbg !785
  br i1 %29, label %30, label %32, !dbg !785

30:                                               ; preds = %21
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 390, ptr noundef @.str.6) #4, !dbg !785
  unreachable, !dbg !785

31:                                               ; No predecessors!
  br label %33, !dbg !785

32:                                               ; preds = %21
  br label %33, !dbg !785

33:                                               ; preds = %32, %31
  %34 = load i64, ptr @local_data, align 8, !dbg !786
  %35 = call i32 @pthread_setspecific(i64 noundef %34, ptr noundef null), !dbg !787
  store i32 %35, ptr %3, align 4, !dbg !788
  %36 = load i32, ptr %3, align 4, !dbg !789
  %37 = icmp eq i32 %36, 0, !dbg !789
  %38 = xor i1 %37, true, !dbg !789
  %39 = zext i1 %38 to i32, !dbg !789
  %40 = sext i32 %39 to i64, !dbg !789
  %41 = icmp ne i64 %40, 0, !dbg !789
  br i1 %41, label %42, label %44, !dbg !789

42:                                               ; preds = %33
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 393, ptr noundef @.str.1) #4, !dbg !789
  unreachable, !dbg !789

43:                                               ; No predecessors!
  br label %45, !dbg !789

44:                                               ; preds = %33
  br label %45, !dbg !789

45:                                               ; preds = %44, %43
  call void @llvm.dbg.declare(metadata ptr %6, metadata !790, metadata !DIExpression()), !dbg !791
  %46 = load ptr, ptr %4, align 8, !dbg !792
  %47 = call ptr @thread_join(ptr noundef %46), !dbg !793
  store ptr %47, ptr %6, align 8, !dbg !791
  %48 = load ptr, ptr %6, align 8, !dbg !794
  %49 = load ptr, ptr %2, align 8, !dbg !794
  %50 = icmp eq ptr %48, %49, !dbg !794
  %51 = xor i1 %50, true, !dbg !794
  %52 = zext i1 %51 to i32, !dbg !794
  %53 = sext i32 %52 to i64, !dbg !794
  %54 = icmp ne i64 %53, 0, !dbg !794
  br i1 %54, label %55, label %57, !dbg !794

55:                                               ; preds = %45
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 396, ptr noundef @.str.5) #4, !dbg !794
  unreachable, !dbg !794

56:                                               ; No predecessors!
  br label %58, !dbg !794

57:                                               ; preds = %45
  br label %58, !dbg !794

58:                                               ; preds = %57, %56
  %59 = load i64, ptr @local_data, align 8, !dbg !795
  %60 = call i32 @pthread_key_delete(i64 noundef %59), !dbg !796
  store i32 %60, ptr %3, align 4, !dbg !797
  %61 = load i32, ptr %3, align 4, !dbg !798
  %62 = icmp eq i32 %61, 0, !dbg !798
  %63 = xor i1 %62, true, !dbg !798
  %64 = zext i1 %63 to i32, !dbg !798
  %65 = sext i32 %64 to i64, !dbg !798
  %66 = icmp ne i64 %65, 0, !dbg !798
  br i1 %66, label %67, label %69, !dbg !798

67:                                               ; preds = %58
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 399, ptr noundef @.str.1) #4, !dbg !798
  unreachable, !dbg !798

68:                                               ; No predecessors!
  br label %70, !dbg !798

69:                                               ; preds = %58
  br label %70, !dbg !798

70:                                               ; preds = %69, %68
  %71 = load ptr, ptr @latest_thread, align 8, !dbg !799
  %72 = load ptr, ptr %4, align 8, !dbg !799
  %73 = call i32 @pthread_equal(ptr noundef %71, ptr noundef %72), !dbg !799
  %74 = icmp ne i32 %73, 0, !dbg !799
  %75 = xor i1 %74, true, !dbg !799
  %76 = zext i1 %75 to i32, !dbg !799
  %77 = sext i32 %76 to i64, !dbg !799
  %78 = icmp ne i64 %77, 0, !dbg !799
  br i1 %78, label %79, label %81, !dbg !799

79:                                               ; preds = %70
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 401, ptr noundef @.str.7) #4, !dbg !799
  unreachable, !dbg !799

80:                                               ; No predecessors!
  br label %82, !dbg !799

81:                                               ; preds = %70
  br label %82, !dbg !799

82:                                               ; preds = %81, %80
  ret void, !dbg !800
}

declare i32 @pthread_key_create(ptr noundef, ptr noundef) #2

declare i32 @pthread_key_delete(i64 noundef) #2

declare i32 @pthread_equal(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @detach_test_worker0(ptr noundef %0) #0 !dbg !801 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !802, metadata !DIExpression()), !dbg !803
  ret ptr null, !dbg !804
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @detach_test_detach(ptr noundef %0) #0 !dbg !805 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !806, metadata !DIExpression()), !dbg !807
  call void @llvm.dbg.declare(metadata ptr %3, metadata !808, metadata !DIExpression()), !dbg !809
  call void @llvm.dbg.declare(metadata ptr %4, metadata !810, metadata !DIExpression()), !dbg !811
  %5 = call ptr @thread_create(ptr noundef @detach_test_worker0, ptr noundef null), !dbg !812
  store ptr %5, ptr %4, align 8, !dbg !811
  %6 = load ptr, ptr %4, align 8, !dbg !813
  %7 = call i32 @pthread_detach(ptr noundef %6), !dbg !814
  store i32 %7, ptr %3, align 4, !dbg !815
  %8 = load i32, ptr %3, align 4, !dbg !816
  %9 = icmp eq i32 %8, 0, !dbg !816
  %10 = xor i1 %9, true, !dbg !816
  %11 = zext i1 %10 to i32, !dbg !816
  %12 = sext i32 %11 to i64, !dbg !816
  %13 = icmp ne i64 %12, 0, !dbg !816
  br i1 %13, label %14, label %16, !dbg !816

14:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.detach_test_detach, ptr noundef @.str, i32 noundef 416, ptr noundef @.str.1) #4, !dbg !816
  unreachable, !dbg !816

15:                                               ; No predecessors!
  br label %17, !dbg !816

16:                                               ; preds = %1
  br label %17, !dbg !816

17:                                               ; preds = %16, %15
  %18 = load ptr, ptr %4, align 8, !dbg !817
  %19 = call i32 @"\01_pthread_join"(ptr noundef %18, ptr noundef null), !dbg !818
  store i32 %19, ptr %3, align 4, !dbg !819
  %20 = load i32, ptr %3, align 4, !dbg !820
  %21 = icmp ne i32 %20, 0, !dbg !820
  %22 = xor i1 %21, true, !dbg !820
  %23 = zext i1 %22 to i32, !dbg !820
  %24 = sext i32 %23 to i64, !dbg !820
  %25 = icmp ne i64 %24, 0, !dbg !820
  br i1 %25, label %26, label %28, !dbg !820

26:                                               ; preds = %17
  call void @__assert_rtn(ptr noundef @__func__.detach_test_detach, ptr noundef @.str, i32 noundef 419, ptr noundef @.str.8) #4, !dbg !820
  unreachable, !dbg !820

27:                                               ; No predecessors!
  br label %29, !dbg !820

28:                                               ; preds = %17
  br label %29, !dbg !820

29:                                               ; preds = %28, %27
  ret ptr null, !dbg !821
}

declare i32 @pthread_detach(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @detach_test_attr(ptr noundef %0) #0 !dbg !822 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca %struct._opaque_pthread_attr_t, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !823, metadata !DIExpression()), !dbg !824
  call void @llvm.dbg.declare(metadata ptr %3, metadata !825, metadata !DIExpression()), !dbg !826
  call void @llvm.dbg.declare(metadata ptr %4, metadata !827, metadata !DIExpression()), !dbg !828
  call void @llvm.dbg.declare(metadata ptr %5, metadata !829, metadata !DIExpression()), !dbg !830
  call void @llvm.dbg.declare(metadata ptr %6, metadata !831, metadata !DIExpression()), !dbg !832
  %7 = call i32 @pthread_attr_init(ptr noundef %6), !dbg !833
  store i32 %7, ptr %3, align 4, !dbg !834
  %8 = load i32, ptr %3, align 4, !dbg !835
  %9 = icmp eq i32 %8, 0, !dbg !835
  %10 = xor i1 %9, true, !dbg !835
  %11 = zext i1 %10 to i32, !dbg !835
  %12 = sext i32 %11 to i64, !dbg !835
  %13 = icmp ne i64 %12, 0, !dbg !835
  br i1 %13, label %14, label %16, !dbg !835

14:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 430, ptr noundef @.str.1) #4, !dbg !835
  unreachable, !dbg !835

15:                                               ; No predecessors!
  br label %17, !dbg !835

16:                                               ; preds = %1
  br label %17, !dbg !835

17:                                               ; preds = %16, %15
  %18 = call i32 @pthread_attr_getdetachstate(ptr noundef %6, ptr noundef %4), !dbg !836
  store i32 %18, ptr %3, align 4, !dbg !837
  %19 = load i32, ptr %3, align 4, !dbg !838
  %20 = icmp eq i32 %19, 0, !dbg !838
  br i1 %20, label %21, label %24, !dbg !838

21:                                               ; preds = %17
  %22 = load i32, ptr %4, align 4, !dbg !838
  %23 = icmp eq i32 %22, 1, !dbg !838
  br label %24

24:                                               ; preds = %21, %17
  %25 = phi i1 [ false, %17 ], [ %23, %21 ], !dbg !839
  %26 = xor i1 %25, true, !dbg !838
  %27 = zext i1 %26 to i32, !dbg !838
  %28 = sext i32 %27 to i64, !dbg !838
  %29 = icmp ne i64 %28, 0, !dbg !838
  br i1 %29, label %30, label %32, !dbg !838

30:                                               ; preds = %24
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 432, ptr noundef @.str.9) #4, !dbg !838
  unreachable, !dbg !838

31:                                               ; No predecessors!
  br label %33, !dbg !838

32:                                               ; preds = %24
  br label %33, !dbg !838

33:                                               ; preds = %32, %31
  %34 = call i32 @pthread_attr_setdetachstate(ptr noundef %6, i32 noundef 2), !dbg !840
  store i32 %34, ptr %3, align 4, !dbg !841
  %35 = load i32, ptr %3, align 4, !dbg !842
  %36 = icmp eq i32 %35, 0, !dbg !842
  %37 = xor i1 %36, true, !dbg !842
  %38 = zext i1 %37 to i32, !dbg !842
  %39 = sext i32 %38 to i64, !dbg !842
  %40 = icmp ne i64 %39, 0, !dbg !842
  br i1 %40, label %41, label %43, !dbg !842

41:                                               ; preds = %33
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 434, ptr noundef @.str.1) #4, !dbg !842
  unreachable, !dbg !842

42:                                               ; No predecessors!
  br label %44, !dbg !842

43:                                               ; preds = %33
  br label %44, !dbg !842

44:                                               ; preds = %43, %42
  %45 = call i32 @pthread_attr_getdetachstate(ptr noundef %6, ptr noundef %4), !dbg !843
  store i32 %45, ptr %3, align 4, !dbg !844
  %46 = load i32, ptr %3, align 4, !dbg !845
  %47 = icmp eq i32 %46, 0, !dbg !845
  br i1 %47, label %48, label %51, !dbg !845

48:                                               ; preds = %44
  %49 = load i32, ptr %4, align 4, !dbg !845
  %50 = icmp eq i32 %49, 2, !dbg !845
  br label %51

51:                                               ; preds = %48, %44
  %52 = phi i1 [ false, %44 ], [ %50, %48 ], !dbg !839
  %53 = xor i1 %52, true, !dbg !845
  %54 = zext i1 %53 to i32, !dbg !845
  %55 = sext i32 %54 to i64, !dbg !845
  %56 = icmp ne i64 %55, 0, !dbg !845
  br i1 %56, label %57, label %59, !dbg !845

57:                                               ; preds = %51
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 436, ptr noundef @.str.10) #4, !dbg !845
  unreachable, !dbg !845

58:                                               ; No predecessors!
  br label %60, !dbg !845

59:                                               ; preds = %51
  br label %60, !dbg !845

60:                                               ; preds = %59, %58
  %61 = call i32 @pthread_create(ptr noundef %5, ptr noundef %6, ptr noundef @detach_test_worker0, ptr noundef null), !dbg !846
  store i32 %61, ptr %3, align 4, !dbg !847
  %62 = load i32, ptr %3, align 4, !dbg !848
  %63 = icmp eq i32 %62, 0, !dbg !848
  %64 = xor i1 %63, true, !dbg !848
  %65 = zext i1 %64 to i32, !dbg !848
  %66 = sext i32 %65 to i64, !dbg !848
  %67 = icmp ne i64 %66, 0, !dbg !848
  br i1 %67, label %68, label %70, !dbg !848

68:                                               ; preds = %60
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 438, ptr noundef @.str.1) #4, !dbg !848
  unreachable, !dbg !848

69:                                               ; No predecessors!
  br label %71, !dbg !848

70:                                               ; preds = %60
  br label %71, !dbg !848

71:                                               ; preds = %70, %69
  %72 = call i32 @pthread_attr_destroy(ptr noundef %6), !dbg !849
  %73 = load ptr, ptr %5, align 8, !dbg !850
  %74 = call i32 @"\01_pthread_join"(ptr noundef %73, ptr noundef null), !dbg !851
  store i32 %74, ptr %3, align 4, !dbg !852
  %75 = load i32, ptr %3, align 4, !dbg !853
  %76 = icmp ne i32 %75, 0, !dbg !853
  %77 = xor i1 %76, true, !dbg !853
  %78 = zext i1 %77 to i32, !dbg !853
  %79 = sext i32 %78 to i64, !dbg !853
  %80 = icmp ne i64 %79, 0, !dbg !853
  br i1 %80, label %81, label %83, !dbg !853

81:                                               ; preds = %71
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 442, ptr noundef @.str.8) #4, !dbg !853
  unreachable, !dbg !853

82:                                               ; No predecessors!
  br label %84, !dbg !853

83:                                               ; preds = %71
  br label %84, !dbg !853

84:                                               ; preds = %83, %82
  ret ptr null, !dbg !854
}

declare i32 @pthread_attr_getdetachstate(ptr noundef, ptr noundef) #2

declare i32 @pthread_attr_setdetachstate(ptr noundef, i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @detach_test() #0 !dbg !855 {
  %1 = call ptr @thread_create(ptr noundef @detach_test_detach, ptr noundef null), !dbg !856
  %2 = call ptr @thread_create(ptr noundef @detach_test_attr, ptr noundef null), !dbg !857
  ret void, !dbg !858
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @once_init0() #0 !dbg !859 {
  %1 = load i32, ptr @once_calls, align 4, !dbg !860
  %2 = add nsw i32 %1, 1, !dbg !860
  store i32 %2, ptr @once_calls, align 4, !dbg !860
  store i32 42, ptr @once_value, align 4, !dbg !861
  ret void, !dbg !862
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @once_init1() #0 !dbg !863 {
  %1 = load i32, ptr @once_calls, align 4, !dbg !864
  %2 = add nsw i32 %1, 1, !dbg !864
  store i32 %2, ptr @once_calls, align 4, !dbg !864
  ret void, !dbg !865
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @once_worker(ptr noundef %0) #0 !dbg !866 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !867, metadata !DIExpression()), !dbg !868
  call void @llvm.dbg.declare(metadata ptr %3, metadata !869, metadata !DIExpression()), !dbg !870
  %4 = call i32 @pthread_once(ptr noundef @once0, ptr noundef @once_init0), !dbg !871
  store i32 %4, ptr %3, align 4, !dbg !870
  %5 = load i32, ptr %3, align 4, !dbg !872
  %6 = icmp eq i32 %5, 0, !dbg !872
  %7 = xor i1 %6, true, !dbg !872
  %8 = zext i1 %7 to i32, !dbg !872
  %9 = sext i32 %8 to i64, !dbg !872
  %10 = icmp ne i64 %9, 0, !dbg !872
  br i1 %10, label %11, label %13, !dbg !872

11:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.once_worker, ptr noundef @.str, i32 noundef 473, ptr noundef @.str.1) #4, !dbg !872
  unreachable, !dbg !872

12:                                               ; No predecessors!
  br label %14, !dbg !872

13:                                               ; preds = %1
  br label %14, !dbg !872

14:                                               ; preds = %13, %12
  %15 = load i32, ptr @once_value, align 4, !dbg !873
  %16 = icmp eq i32 %15, 42, !dbg !873
  %17 = xor i1 %16, true, !dbg !873
  %18 = zext i1 %17 to i32, !dbg !873
  %19 = sext i32 %18 to i64, !dbg !873
  %20 = icmp ne i64 %19, 0, !dbg !873
  br i1 %20, label %21, label %23, !dbg !873

21:                                               ; preds = %14
  call void @__assert_rtn(ptr noundef @__func__.once_worker, ptr noundef @.str, i32 noundef 474, ptr noundef @.str.11) #4, !dbg !873
  unreachable, !dbg !873

22:                                               ; No predecessors!
  br label %24, !dbg !873

23:                                               ; preds = %14
  br label %24, !dbg !873

24:                                               ; preds = %23, %22
  ret ptr null, !dbg !874
}

declare i32 @pthread_once(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @once_test() #0 !dbg !875 {
  %1 = alloca ptr, align 8
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata ptr %1, metadata !876, metadata !DIExpression()), !dbg !877
  %4 = call ptr @thread_create(ptr noundef @once_worker, ptr noundef null), !dbg !878
  store ptr %4, ptr %1, align 8, !dbg !877
  call void @llvm.dbg.declare(metadata ptr %2, metadata !879, metadata !DIExpression()), !dbg !880
  %5 = call ptr @thread_create(ptr noundef @once_worker, ptr noundef null), !dbg !881
  store ptr %5, ptr %2, align 8, !dbg !880
  %6 = load ptr, ptr %1, align 8, !dbg !882
  %7 = call ptr @thread_join(ptr noundef %6), !dbg !883
  %8 = load ptr, ptr %2, align 8, !dbg !884
  %9 = call ptr @thread_join(ptr noundef %8), !dbg !885
  %10 = load i32, ptr @once_calls, align 4, !dbg !886
  %11 = icmp eq i32 %10, 1, !dbg !886
  %12 = xor i1 %11, true, !dbg !886
  %13 = zext i1 %12 to i32, !dbg !886
  %14 = sext i32 %13 to i64, !dbg !886
  %15 = icmp ne i64 %14, 0, !dbg !886
  br i1 %15, label %16, label %18, !dbg !886

16:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.once_test, ptr noundef @.str, i32 noundef 484, ptr noundef @.str.12) #4, !dbg !886
  unreachable, !dbg !886

17:                                               ; No predecessors!
  br label %19, !dbg !886

18:                                               ; preds = %0
  br label %19, !dbg !886

19:                                               ; preds = %18, %17
  call void @llvm.dbg.declare(metadata ptr %3, metadata !887, metadata !DIExpression()), !dbg !888
  %20 = call i32 @pthread_once(ptr noundef @once1, ptr noundef @once_init1), !dbg !889
  store i32 %20, ptr %3, align 4, !dbg !888
  %21 = load i32, ptr %3, align 4, !dbg !890
  %22 = icmp eq i32 %21, 0, !dbg !890
  %23 = xor i1 %22, true, !dbg !890
  %24 = zext i1 %23 to i32, !dbg !890
  %25 = sext i32 %24 to i64, !dbg !890
  %26 = icmp ne i64 %25, 0, !dbg !890
  br i1 %26, label %27, label %29, !dbg !890

27:                                               ; preds = %19
  call void @__assert_rtn(ptr noundef @__func__.once_test, ptr noundef @.str, i32 noundef 487, ptr noundef @.str.1) #4, !dbg !890
  unreachable, !dbg !890

28:                                               ; No predecessors!
  br label %30, !dbg !890

29:                                               ; preds = %19
  br label %30, !dbg !890

30:                                               ; preds = %29, %28
  %31 = call i32 @pthread_once(ptr noundef @once1, ptr noundef @once_init1), !dbg !891
  store i32 %31, ptr %3, align 4, !dbg !892
  %32 = load i32, ptr %3, align 4, !dbg !893
  %33 = icmp eq i32 %32, 0, !dbg !893
  %34 = xor i1 %33, true, !dbg !893
  %35 = zext i1 %34 to i32, !dbg !893
  %36 = sext i32 %35 to i64, !dbg !893
  %37 = icmp ne i64 %36, 0, !dbg !893
  br i1 %37, label %38, label %40, !dbg !893

38:                                               ; preds = %30
  call void @__assert_rtn(ptr noundef @__func__.once_test, ptr noundef @.str, i32 noundef 489, ptr noundef @.str.1) #4, !dbg !893
  unreachable, !dbg !893

39:                                               ; No predecessors!
  br label %41, !dbg !893

40:                                               ; preds = %30
  br label %41, !dbg !893

41:                                               ; preds = %40, %39
  %42 = load i32, ptr @once_calls, align 4, !dbg !894
  %43 = icmp eq i32 %42, 2, !dbg !894
  %44 = xor i1 %43, true, !dbg !894
  %45 = zext i1 %44 to i32, !dbg !894
  %46 = sext i32 %45 to i64, !dbg !894
  %47 = icmp ne i64 %46, 0, !dbg !894
  br i1 %47, label %48, label %50, !dbg !894

48:                                               ; preds = %41
  call void @__assert_rtn(ptr noundef @__func__.once_test, ptr noundef @.str, i32 noundef 490, ptr noundef @.str.13) #4, !dbg !894
  unreachable, !dbg !894

49:                                               ; No predecessors!
  br label %51, !dbg !894

50:                                               ; preds = %41
  br label %51, !dbg !894

51:                                               ; preds = %50, %49
  ret void, !dbg !895
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !896 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %2 = call i32 @__VERIFIER_nondet_int(), !dbg !899
  switch i32 %2, label %9 [
    i32 1, label %3
    i32 2, label %4
    i32 3, label %5
    i32 4, label %6
    i32 5, label %7
    i32 6, label %8
  ], !dbg !900

3:                                                ; preds = %0
  call void @mutex_test(), !dbg !901
  br label %9, !dbg !903

4:                                                ; preds = %0
  call void @cond_test(), !dbg !904
  br label %9, !dbg !905

5:                                                ; preds = %0
  call void @rwlock_test(), !dbg !906
  br label %9, !dbg !907

6:                                                ; preds = %0
  call void @key_test(), !dbg !908
  br label %9, !dbg !909

7:                                                ; preds = %0
  call void @detach_test(), !dbg !910
  br label %9, !dbg !911

8:                                                ; preds = %0
  call void @once_test(), !dbg !912
  br label %9, !dbg !913

9:                                                ; preds = %0, %8, %7, %6, %5, %4, %3
  %10 = load i32, ptr %1, align 4, !dbg !914
  ret i32 %10, !dbg !914
}

declare i32 @__VERIFIER_nondet_int() #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #4 = { cold noreturn }

!llvm.dbg.cu = !{!68}
!llvm.module.flags = !{!216, !217, !218, !219, !220, !221}
!llvm.ident = !{!222}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 19, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "benchmarks/miscellaneous/pthread.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 112, elements: !6)
!4 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !5)
!5 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!6 = !{!7}
!7 = !DISubrange(count: 14)
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(scope: null, file: !2, line: 19, type: !10, isLocal: true, isDefinition: true)
!10 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 80, elements: !11)
!11 = !{!12}
!12 = !DISubrange(count: 10)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(scope: null, file: !2, line: 19, type: !15, isLocal: true, isDefinition: true)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 96, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 12)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !2, line: 28, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 96, elements: !16)
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(scope: null, file: !2, line: 48, type: !23, isLocal: true, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 88, elements: !24)
!24 = !{!25}
!25 = !DISubrange(count: 11)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(scope: null, file: !2, line: 74, type: !3, isLocal: true, isDefinition: true)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(scope: null, file: !2, line: 80, type: !23, isLocal: true, isDefinition: true)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !2, line: 86, type: !3, isLocal: true, isDefinition: true)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(scope: null, file: !2, line: 86, type: !34, isLocal: true, isDefinition: true)
!34 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 248, elements: !35)
!35 = !{!36}
!36 = !DISubrange(count: 31)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !2, line: 93, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 104, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 13)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !2, line: 107, type: !23, isLocal: true, isDefinition: true)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(scope: null, file: !2, line: 107, type: !46, isLocal: true, isDefinition: true)
!46 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 72, elements: !47)
!47 = !{!48}
!48 = !DISubrange(count: 9)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(scope: null, file: !2, line: 116, type: !51, isLocal: true, isDefinition: true)
!51 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 64, elements: !52)
!52 = !{!53}
!53 = !DISubrange(count: 8)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(scope: null, file: !2, line: 143, type: !56, isLocal: true, isDefinition: true)
!56 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 80, elements: !11)
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(scope: null, file: !2, line: 155, type: !39, isLocal: true, isDefinition: true)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(scope: null, file: !2, line: 161, type: !20, isLocal: true, isDefinition: true)
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(scope: null, file: !2, line: 167, type: !63, isLocal: true, isDefinition: true)
!63 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 120, elements: !64)
!64 = !{!65}
!65 = !DISubrange(count: 15)
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(name: "phase", scope: !68, file: !2, line: 189, type: !213, isLocal: false, isDefinition: true)
!68 = distinct !DICompileUnit(language: DW_LANG_C11, file: !69, producer: "Homebrew clang version 17.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !70, globals: !73, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!69 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/pthread.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!70 = !{!71, !72}
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!73 = !{!0, !8, !13, !18, !21, !26, !28, !30, !32, !37, !42, !44, !49, !54, !57, !59, !61, !66, !74, !76, !81, !83, !85, !87, !92, !94, !96, !98, !100, !102, !107, !110, !115, !120, !122, !124, !129, !131, !142, !144, !146, !149, !151, !156, !158, !170, !182, !205, !211, !214}
!74 = !DIGlobalVariableExpression(var: !75, expr: !DIExpression())
!75 = distinct !DIGlobalVariable(scope: null, file: !2, line: 241, type: !56, isLocal: true, isDefinition: true)
!76 = !DIGlobalVariableExpression(var: !77, expr: !DIExpression())
!77 = distinct !DIGlobalVariable(scope: null, file: !2, line: 241, type: !78, isLocal: true, isDefinition: true)
!78 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 144, elements: !79)
!79 = !{!80}
!80 = !DISubrange(count: 18)
!81 = !DIGlobalVariableExpression(var: !82, expr: !DIExpression())
!82 = distinct !DIGlobalVariable(scope: null, file: !2, line: 258, type: !20, isLocal: true, isDefinition: true)
!83 = !DIGlobalVariableExpression(var: !84, expr: !DIExpression())
!84 = distinct !DIGlobalVariable(scope: null, file: !2, line: 274, type: !63, isLocal: true, isDefinition: true)
!85 = !DIGlobalVariableExpression(var: !86, expr: !DIExpression())
!86 = distinct !DIGlobalVariable(scope: null, file: !2, line: 280, type: !3, isLocal: true, isDefinition: true)
!87 = !DIGlobalVariableExpression(var: !88, expr: !DIExpression())
!88 = distinct !DIGlobalVariable(scope: null, file: !2, line: 286, type: !89, isLocal: true, isDefinition: true)
!89 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 136, elements: !90)
!90 = !{!91}
!91 = !DISubrange(count: 17)
!92 = !DIGlobalVariableExpression(var: !93, expr: !DIExpression())
!93 = distinct !DIGlobalVariable(scope: null, file: !2, line: 293, type: !3, isLocal: true, isDefinition: true)
!94 = !DIGlobalVariableExpression(var: !95, expr: !DIExpression())
!95 = distinct !DIGlobalVariable(scope: null, file: !2, line: 299, type: !89, isLocal: true, isDefinition: true)
!96 = !DIGlobalVariableExpression(var: !97, expr: !DIExpression())
!97 = distinct !DIGlobalVariable(scope: null, file: !2, line: 306, type: !3, isLocal: true, isDefinition: true)
!98 = !DIGlobalVariableExpression(var: !99, expr: !DIExpression())
!99 = distinct !DIGlobalVariable(scope: null, file: !2, line: 318, type: !20, isLocal: true, isDefinition: true)
!100 = !DIGlobalVariableExpression(var: !101, expr: !DIExpression())
!101 = distinct !DIGlobalVariable(scope: null, file: !2, line: 368, type: !23, isLocal: true, isDefinition: true)
!102 = !DIGlobalVariableExpression(var: !103, expr: !DIExpression())
!103 = distinct !DIGlobalVariable(scope: null, file: !2, line: 371, type: !104, isLocal: true, isDefinition: true)
!104 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 224, elements: !105)
!105 = !{!106}
!106 = !DISubrange(count: 28)
!107 = !DIGlobalVariableExpression(var: !108, expr: !DIExpression())
!108 = distinct !DIGlobalVariable(scope: null, file: !2, line: 387, type: !109, isLocal: true, isDefinition: true)
!109 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 72, elements: !47)
!110 = !DIGlobalVariableExpression(var: !111, expr: !DIExpression())
!111 = distinct !DIGlobalVariable(scope: null, file: !2, line: 401, type: !112, isLocal: true, isDefinition: true)
!112 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 296, elements: !113)
!113 = !{!114}
!114 = !DISubrange(count: 37)
!115 = !DIGlobalVariableExpression(var: !116, expr: !DIExpression())
!116 = distinct !DIGlobalVariable(scope: null, file: !2, line: 416, type: !117, isLocal: true, isDefinition: true)
!117 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 152, elements: !118)
!118 = !{!119}
!119 = !DISubrange(count: 19)
!120 = !DIGlobalVariableExpression(var: !121, expr: !DIExpression())
!121 = distinct !DIGlobalVariable(scope: null, file: !2, line: 419, type: !15, isLocal: true, isDefinition: true)
!122 = !DIGlobalVariableExpression(var: !123, expr: !DIExpression())
!123 = distinct !DIGlobalVariable(scope: null, file: !2, line: 430, type: !89, isLocal: true, isDefinition: true)
!124 = !DIGlobalVariableExpression(var: !125, expr: !DIExpression())
!125 = distinct !DIGlobalVariable(scope: null, file: !2, line: 432, type: !126, isLocal: true, isDefinition: true)
!126 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 432, elements: !127)
!127 = !{!128}
!128 = !DISubrange(count: 54)
!129 = !DIGlobalVariableExpression(var: !130, expr: !DIExpression())
!130 = distinct !DIGlobalVariable(scope: null, file: !2, line: 436, type: !126, isLocal: true, isDefinition: true)
!131 = !DIGlobalVariableExpression(var: !132, expr: !DIExpression())
!132 = distinct !DIGlobalVariable(name: "once0", scope: !68, file: !2, line: 454, type: !133, isLocal: false, isDefinition: true)
!133 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_once_t", file: !134, line: 31, baseType: !135)
!134 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_once_t.h", directory: "")
!135 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_once_t", file: !136, line: 115, baseType: !137)
!136 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!137 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_once_t", file: !136, line: 88, size: 128, elements: !138)
!138 = !{!139, !141}
!139 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !137, file: !136, line: 89, baseType: !140, size: 64)
!140 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !137, file: !136, line: 90, baseType: !51, size: 64, offset: 64)
!142 = !DIGlobalVariableExpression(var: !143, expr: !DIExpression())
!143 = distinct !DIGlobalVariable(name: "once1", scope: !68, file: !2, line: 455, type: !133, isLocal: false, isDefinition: true)
!144 = !DIGlobalVariableExpression(var: !145, expr: !DIExpression())
!145 = distinct !DIGlobalVariable(scope: null, file: !2, line: 473, type: !20, isLocal: true, isDefinition: true)
!146 = !DIGlobalVariableExpression(var: !147, expr: !DIExpression())
!147 = distinct !DIGlobalVariable(scope: null, file: !2, line: 474, type: !148, isLocal: true, isDefinition: true)
!148 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 136, elements: !90)
!149 = !DIGlobalVariableExpression(var: !150, expr: !DIExpression())
!150 = distinct !DIGlobalVariable(scope: null, file: !2, line: 484, type: !56, isLocal: true, isDefinition: true)
!151 = !DIGlobalVariableExpression(var: !152, expr: !DIExpression())
!152 = distinct !DIGlobalVariable(scope: null, file: !2, line: 484, type: !153, isLocal: true, isDefinition: true)
!153 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 128, elements: !154)
!154 = !{!155}
!155 = !DISubrange(count: 16)
!156 = !DIGlobalVariableExpression(var: !157, expr: !DIExpression())
!157 = distinct !DIGlobalVariable(scope: null, file: !2, line: 490, type: !153, isLocal: true, isDefinition: true)
!158 = !DIGlobalVariableExpression(var: !159, expr: !DIExpression())
!159 = distinct !DIGlobalVariable(name: "cond_mutex", scope: !68, file: !2, line: 187, type: !160, isLocal: false, isDefinition: true)
!160 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !161, line: 31, baseType: !162)
!161 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_mutex_t.h", directory: "")
!162 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutex_t", file: !136, line: 113, baseType: !163)
!163 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutex_t", file: !136, line: 78, size: 512, elements: !164)
!164 = !{!165, !166}
!165 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !163, file: !136, line: 79, baseType: !140, size: 64)
!166 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !163, file: !136, line: 80, baseType: !167, size: 448, offset: 64)
!167 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 448, elements: !168)
!168 = !{!169}
!169 = !DISubrange(count: 56)
!170 = !DIGlobalVariableExpression(var: !171, expr: !DIExpression())
!171 = distinct !DIGlobalVariable(name: "cond", scope: !68, file: !2, line: 188, type: !172, isLocal: false, isDefinition: true)
!172 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_cond_t", file: !173, line: 31, baseType: !174)
!173 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_cond_t.h", directory: "")
!174 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_cond_t", file: !136, line: 110, baseType: !175)
!175 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_cond_t", file: !136, line: 68, size: 384, elements: !176)
!176 = !{!177, !178}
!177 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !175, file: !136, line: 69, baseType: !140, size: 64)
!178 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !175, file: !136, line: 70, baseType: !179, size: 320, offset: 64)
!179 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 320, elements: !180)
!180 = !{!181}
!181 = !DISubrange(count: 40)
!182 = !DIGlobalVariableExpression(var: !183, expr: !DIExpression())
!183 = distinct !DIGlobalVariable(name: "latest_thread", scope: !68, file: !2, line: 355, type: !184, isLocal: false, isDefinition: true)
!184 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !185, line: 31, baseType: !186)
!185 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!186 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !136, line: 118, baseType: !187)
!187 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !188, size: 64)
!188 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !136, line: 103, size: 65536, elements: !189)
!189 = !{!190, !191, !201}
!190 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !188, file: !136, line: 104, baseType: !140, size: 64)
!191 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !188, file: !136, line: 105, baseType: !192, size: 64, offset: 64)
!192 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !193, size: 64)
!193 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !136, line: 57, size: 192, elements: !194)
!194 = !{!195, !199, !200}
!195 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !193, file: !136, line: 58, baseType: !196, size: 64)
!196 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !197, size: 64)
!197 = !DISubroutineType(types: !198)
!198 = !{null, !72}
!199 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !193, file: !136, line: 59, baseType: !72, size: 64, offset: 64)
!200 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !193, file: !136, line: 60, baseType: !192, size: 64, offset: 128)
!201 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !188, file: !136, line: 106, baseType: !202, size: 65408, offset: 128)
!202 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 65408, elements: !203)
!203 = !{!204}
!204 = !DISubrange(count: 8176)
!205 = !DIGlobalVariableExpression(var: !206, expr: !DIExpression())
!206 = distinct !DIGlobalVariable(name: "local_data", scope: !68, file: !2, line: 356, type: !207, isLocal: false, isDefinition: true)
!207 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_key_t", file: !208, line: 31, baseType: !209)
!208 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_key_t.h", directory: "")
!209 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_key_t", file: !136, line: 112, baseType: !210)
!210 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!211 = !DIGlobalVariableExpression(var: !212, expr: !DIExpression())
!212 = distinct !DIGlobalVariable(name: "once_calls", scope: !68, file: !2, line: 456, type: !213, isLocal: false, isDefinition: true)
!213 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!214 = !DIGlobalVariableExpression(var: !215, expr: !DIExpression())
!215 = distinct !DIGlobalVariable(name: "once_value", scope: !68, file: !2, line: 457, type: !213, isLocal: false, isDefinition: true)
!216 = !{i32 7, !"Dwarf Version", i32 4}
!217 = !{i32 2, !"Debug Info Version", i32 3}
!218 = !{i32 1, !"wchar_size", i32 4}
!219 = !{i32 8, !"PIC Level", i32 2}
!220 = !{i32 7, !"uwtable", i32 1}
!221 = !{i32 7, !"frame-pointer", i32 1}
!222 = !{!"Homebrew clang version 17.0.6"}
!223 = distinct !DISubprogram(name: "thread_create", scope: !2, file: !2, line: 13, type: !224, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!224 = !DISubroutineType(types: !225)
!225 = !{!184, !226, !72}
!226 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !227, size: 64)
!227 = !DISubroutineType(types: !228)
!228 = !{!72, !72}
!229 = !{}
!230 = !DILocalVariable(name: "runner", arg: 1, scope: !223, file: !2, line: 13, type: !226)
!231 = !DILocation(line: 13, column: 32, scope: !223)
!232 = !DILocalVariable(name: "data", arg: 2, scope: !223, file: !2, line: 13, type: !72)
!233 = !DILocation(line: 13, column: 54, scope: !223)
!234 = !DILocalVariable(name: "id", scope: !223, file: !2, line: 15, type: !184)
!235 = !DILocation(line: 15, column: 15, scope: !223)
!236 = !DILocalVariable(name: "attr", scope: !223, file: !2, line: 16, type: !237)
!237 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !238, line: 31, baseType: !239)
!238 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_attr_t.h", directory: "")
!239 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_attr_t", file: !136, line: 109, baseType: !240)
!240 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_attr_t", file: !136, line: 63, size: 512, elements: !241)
!241 = !{!242, !243}
!242 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !240, file: !136, line: 64, baseType: !140, size: 64)
!243 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !240, file: !136, line: 65, baseType: !167, size: 448, offset: 64)
!244 = !DILocation(line: 16, column: 20, scope: !223)
!245 = !DILocation(line: 17, column: 5, scope: !223)
!246 = !DILocalVariable(name: "status", scope: !223, file: !2, line: 18, type: !213)
!247 = !DILocation(line: 18, column: 9, scope: !223)
!248 = !DILocation(line: 18, column: 45, scope: !223)
!249 = !DILocation(line: 18, column: 53, scope: !223)
!250 = !DILocation(line: 18, column: 18, scope: !223)
!251 = !DILocation(line: 19, column: 5, scope: !223)
!252 = !DILocation(line: 20, column: 5, scope: !223)
!253 = !DILocation(line: 21, column: 12, scope: !223)
!254 = !DILocation(line: 21, column: 5, scope: !223)
!255 = distinct !DISubprogram(name: "thread_join", scope: !2, file: !2, line: 24, type: !256, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!256 = !DISubroutineType(types: !257)
!257 = !{!72, !184}
!258 = !DILocalVariable(name: "id", arg: 1, scope: !255, file: !2, line: 24, type: !184)
!259 = !DILocation(line: 24, column: 29, scope: !255)
!260 = !DILocalVariable(name: "result", scope: !255, file: !2, line: 26, type: !72)
!261 = !DILocation(line: 26, column: 11, scope: !255)
!262 = !DILocalVariable(name: "status", scope: !255, file: !2, line: 27, type: !213)
!263 = !DILocation(line: 27, column: 9, scope: !255)
!264 = !DILocation(line: 27, column: 31, scope: !255)
!265 = !DILocation(line: 27, column: 18, scope: !255)
!266 = !DILocation(line: 28, column: 5, scope: !255)
!267 = !DILocation(line: 29, column: 12, scope: !255)
!268 = !DILocation(line: 29, column: 5, scope: !255)
!269 = distinct !DISubprogram(name: "mutex_init", scope: !2, file: !2, line: 42, type: !270, scopeLine: 43, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!270 = !DISubroutineType(types: !271)
!271 = !{null, !272, !213, !213, !213}
!272 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !160, size: 64)
!273 = !DILocalVariable(name: "lock", arg: 1, scope: !269, file: !2, line: 42, type: !272)
!274 = !DILocation(line: 42, column: 34, scope: !269)
!275 = !DILocalVariable(name: "type", arg: 2, scope: !269, file: !2, line: 42, type: !213)
!276 = !DILocation(line: 42, column: 44, scope: !269)
!277 = !DILocalVariable(name: "protocol", arg: 3, scope: !269, file: !2, line: 42, type: !213)
!278 = !DILocation(line: 42, column: 54, scope: !269)
!279 = !DILocalVariable(name: "prioceiling", arg: 4, scope: !269, file: !2, line: 42, type: !213)
!280 = !DILocation(line: 42, column: 68, scope: !269)
!281 = !DILocalVariable(name: "status", scope: !269, file: !2, line: 44, type: !213)
!282 = !DILocation(line: 44, column: 9, scope: !269)
!283 = !DILocalVariable(name: "value", scope: !269, file: !2, line: 45, type: !213)
!284 = !DILocation(line: 45, column: 9, scope: !269)
!285 = !DILocalVariable(name: "attributes", scope: !269, file: !2, line: 46, type: !286)
!286 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !287, line: 31, baseType: !288)
!287 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_mutexattr_t.h", directory: "")
!288 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutexattr_t", file: !136, line: 114, baseType: !289)
!289 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutexattr_t", file: !136, line: 83, size: 128, elements: !290)
!290 = !{!291, !292}
!291 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !289, file: !136, line: 84, baseType: !140, size: 64)
!292 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !289, file: !136, line: 85, baseType: !51, size: 64, offset: 64)
!293 = !DILocation(line: 46, column: 25, scope: !269)
!294 = !DILocation(line: 47, column: 14, scope: !269)
!295 = !DILocation(line: 47, column: 12, scope: !269)
!296 = !DILocation(line: 48, column: 5, scope: !269)
!297 = !DILocation(line: 50, column: 53, scope: !269)
!298 = !DILocation(line: 50, column: 14, scope: !269)
!299 = !DILocation(line: 50, column: 12, scope: !269)
!300 = !DILocation(line: 51, column: 5, scope: !269)
!301 = !DILocation(line: 52, column: 14, scope: !269)
!302 = !DILocation(line: 52, column: 12, scope: !269)
!303 = !DILocation(line: 53, column: 5, scope: !269)
!304 = !DILocation(line: 55, column: 57, scope: !269)
!305 = !DILocation(line: 55, column: 14, scope: !269)
!306 = !DILocation(line: 55, column: 12, scope: !269)
!307 = !DILocation(line: 56, column: 5, scope: !269)
!308 = !DILocation(line: 57, column: 14, scope: !269)
!309 = !DILocation(line: 57, column: 12, scope: !269)
!310 = !DILocation(line: 58, column: 5, scope: !269)
!311 = !DILocation(line: 60, column: 60, scope: !269)
!312 = !DILocation(line: 60, column: 14, scope: !269)
!313 = !DILocation(line: 60, column: 12, scope: !269)
!314 = !DILocation(line: 61, column: 5, scope: !269)
!315 = !DILocation(line: 62, column: 14, scope: !269)
!316 = !DILocation(line: 62, column: 12, scope: !269)
!317 = !DILocation(line: 63, column: 5, scope: !269)
!318 = !DILocation(line: 65, column: 33, scope: !269)
!319 = !DILocation(line: 65, column: 14, scope: !269)
!320 = !DILocation(line: 65, column: 12, scope: !269)
!321 = !DILocation(line: 66, column: 5, scope: !269)
!322 = !DILocation(line: 67, column: 14, scope: !269)
!323 = !DILocation(line: 67, column: 12, scope: !269)
!324 = !DILocation(line: 68, column: 5, scope: !269)
!325 = !DILocation(line: 69, column: 1, scope: !269)
!326 = distinct !DISubprogram(name: "mutex_destroy", scope: !2, file: !2, line: 71, type: !327, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!327 = !DISubroutineType(types: !328)
!328 = !{null, !272}
!329 = !DILocalVariable(name: "lock", arg: 1, scope: !326, file: !2, line: 71, type: !272)
!330 = !DILocation(line: 71, column: 37, scope: !326)
!331 = !DILocalVariable(name: "status", scope: !326, file: !2, line: 73, type: !213)
!332 = !DILocation(line: 73, column: 9, scope: !326)
!333 = !DILocation(line: 73, column: 40, scope: !326)
!334 = !DILocation(line: 73, column: 18, scope: !326)
!335 = !DILocation(line: 74, column: 5, scope: !326)
!336 = !DILocation(line: 75, column: 1, scope: !326)
!337 = distinct !DISubprogram(name: "mutex_lock", scope: !2, file: !2, line: 77, type: !327, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!338 = !DILocalVariable(name: "lock", arg: 1, scope: !337, file: !2, line: 77, type: !272)
!339 = !DILocation(line: 77, column: 34, scope: !337)
!340 = !DILocalVariable(name: "status", scope: !337, file: !2, line: 79, type: !213)
!341 = !DILocation(line: 79, column: 9, scope: !337)
!342 = !DILocation(line: 79, column: 37, scope: !337)
!343 = !DILocation(line: 79, column: 18, scope: !337)
!344 = !DILocation(line: 80, column: 5, scope: !337)
!345 = !DILocation(line: 81, column: 1, scope: !337)
!346 = distinct !DISubprogram(name: "mutex_trylock", scope: !2, file: !2, line: 83, type: !347, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!347 = !DISubroutineType(types: !348)
!348 = !{!349, !272}
!349 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!350 = !DILocalVariable(name: "lock", arg: 1, scope: !346, file: !2, line: 83, type: !272)
!351 = !DILocation(line: 83, column: 37, scope: !346)
!352 = !DILocalVariable(name: "status", scope: !346, file: !2, line: 85, type: !213)
!353 = !DILocation(line: 85, column: 9, scope: !346)
!354 = !DILocation(line: 85, column: 40, scope: !346)
!355 = !DILocation(line: 85, column: 18, scope: !346)
!356 = !DILocation(line: 86, column: 5, scope: !346)
!357 = !DILocation(line: 87, column: 12, scope: !346)
!358 = !DILocation(line: 87, column: 19, scope: !346)
!359 = !DILocation(line: 87, column: 5, scope: !346)
!360 = distinct !DISubprogram(name: "mutex_unlock", scope: !2, file: !2, line: 90, type: !327, scopeLine: 91, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!361 = !DILocalVariable(name: "lock", arg: 1, scope: !360, file: !2, line: 90, type: !272)
!362 = !DILocation(line: 90, column: 36, scope: !360)
!363 = !DILocalVariable(name: "status", scope: !360, file: !2, line: 92, type: !213)
!364 = !DILocation(line: 92, column: 9, scope: !360)
!365 = !DILocation(line: 92, column: 39, scope: !360)
!366 = !DILocation(line: 92, column: 18, scope: !360)
!367 = !DILocation(line: 93, column: 5, scope: !360)
!368 = !DILocation(line: 94, column: 1, scope: !360)
!369 = distinct !DISubprogram(name: "mutex_test", scope: !2, file: !2, line: 96, type: !370, scopeLine: 97, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!370 = !DISubroutineType(types: !371)
!371 = !{null}
!372 = !DILocalVariable(name: "mutex0", scope: !369, file: !2, line: 98, type: !160)
!373 = !DILocation(line: 98, column: 21, scope: !369)
!374 = !DILocalVariable(name: "mutex1", scope: !369, file: !2, line: 99, type: !160)
!375 = !DILocation(line: 99, column: 21, scope: !369)
!376 = !DILocation(line: 101, column: 5, scope: !369)
!377 = !DILocation(line: 102, column: 5, scope: !369)
!378 = !DILocation(line: 105, column: 9, scope: !379)
!379 = distinct !DILexicalBlock(scope: !369, file: !2, line: 104, column: 5)
!380 = !DILocalVariable(name: "success", scope: !379, file: !2, line: 106, type: !349)
!381 = !DILocation(line: 106, column: 14, scope: !379)
!382 = !DILocation(line: 106, column: 24, scope: !379)
!383 = !DILocation(line: 107, column: 9, scope: !379)
!384 = !DILocation(line: 108, column: 9, scope: !379)
!385 = !DILocation(line: 112, column: 9, scope: !386)
!386 = distinct !DILexicalBlock(scope: !369, file: !2, line: 111, column: 5)
!387 = !DILocalVariable(name: "success", scope: !388, file: !2, line: 115, type: !349)
!388 = distinct !DILexicalBlock(scope: !386, file: !2, line: 114, column: 9)
!389 = !DILocation(line: 115, column: 18, scope: !388)
!390 = !DILocation(line: 115, column: 28, scope: !388)
!391 = !DILocation(line: 116, column: 13, scope: !388)
!392 = !DILocation(line: 117, column: 13, scope: !388)
!393 = !DILocalVariable(name: "success", scope: !394, file: !2, line: 121, type: !349)
!394 = distinct !DILexicalBlock(scope: !386, file: !2, line: 120, column: 9)
!395 = !DILocation(line: 121, column: 18, scope: !394)
!396 = !DILocation(line: 121, column: 28, scope: !394)
!397 = !DILocation(line: 122, column: 13, scope: !394)
!398 = !DILocation(line: 123, column: 13, scope: !394)
!399 = !DILocation(line: 128, column: 9, scope: !386)
!400 = !DILocation(line: 131, column: 5, scope: !369)
!401 = !DILocation(line: 132, column: 5, scope: !369)
!402 = !DILocation(line: 133, column: 1, scope: !369)
!403 = distinct !DISubprogram(name: "cond_init", scope: !2, file: !2, line: 137, type: !404, scopeLine: 138, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!404 = !DISubroutineType(types: !405)
!405 = !{null, !406}
!406 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !172, size: 64)
!407 = !DILocalVariable(name: "cond", arg: 1, scope: !403, file: !2, line: 137, type: !406)
!408 = !DILocation(line: 137, column: 32, scope: !403)
!409 = !DILocalVariable(name: "status", scope: !403, file: !2, line: 139, type: !213)
!410 = !DILocation(line: 139, column: 9, scope: !403)
!411 = !DILocalVariable(name: "attr", scope: !403, file: !2, line: 140, type: !412)
!412 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_condattr_t", file: !413, line: 31, baseType: !414)
!413 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_condattr_t.h", directory: "")
!414 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_condattr_t", file: !136, line: 111, baseType: !415)
!415 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_condattr_t", file: !136, line: 73, size: 128, elements: !416)
!416 = !{!417, !418}
!417 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !415, file: !136, line: 74, baseType: !140, size: 64)
!418 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !415, file: !136, line: 75, baseType: !51, size: 64, offset: 64)
!419 = !DILocation(line: 140, column: 24, scope: !403)
!420 = !DILocation(line: 142, column: 14, scope: !403)
!421 = !DILocation(line: 142, column: 12, scope: !403)
!422 = !DILocation(line: 143, column: 5, scope: !403)
!423 = !DILocation(line: 145, column: 32, scope: !403)
!424 = !DILocation(line: 145, column: 14, scope: !403)
!425 = !DILocation(line: 145, column: 12, scope: !403)
!426 = !DILocation(line: 146, column: 5, scope: !403)
!427 = !DILocation(line: 148, column: 14, scope: !403)
!428 = !DILocation(line: 148, column: 12, scope: !403)
!429 = !DILocation(line: 149, column: 5, scope: !403)
!430 = !DILocation(line: 150, column: 1, scope: !403)
!431 = distinct !DISubprogram(name: "cond_destroy", scope: !2, file: !2, line: 152, type: !404, scopeLine: 153, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!432 = !DILocalVariable(name: "cond", arg: 1, scope: !431, file: !2, line: 152, type: !406)
!433 = !DILocation(line: 152, column: 35, scope: !431)
!434 = !DILocalVariable(name: "status", scope: !431, file: !2, line: 154, type: !213)
!435 = !DILocation(line: 154, column: 9, scope: !431)
!436 = !DILocation(line: 154, column: 39, scope: !431)
!437 = !DILocation(line: 154, column: 18, scope: !431)
!438 = !DILocation(line: 155, column: 5, scope: !431)
!439 = !DILocation(line: 156, column: 1, scope: !431)
!440 = distinct !DISubprogram(name: "cond_signal", scope: !2, file: !2, line: 158, type: !404, scopeLine: 159, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!441 = !DILocalVariable(name: "cond", arg: 1, scope: !440, file: !2, line: 158, type: !406)
!442 = !DILocation(line: 158, column: 34, scope: !440)
!443 = !DILocalVariable(name: "status", scope: !440, file: !2, line: 160, type: !213)
!444 = !DILocation(line: 160, column: 9, scope: !440)
!445 = !DILocation(line: 160, column: 38, scope: !440)
!446 = !DILocation(line: 160, column: 18, scope: !440)
!447 = !DILocation(line: 161, column: 5, scope: !440)
!448 = !DILocation(line: 162, column: 1, scope: !440)
!449 = distinct !DISubprogram(name: "cond_broadcast", scope: !2, file: !2, line: 164, type: !404, scopeLine: 165, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!450 = !DILocalVariable(name: "cond", arg: 1, scope: !449, file: !2, line: 164, type: !406)
!451 = !DILocation(line: 164, column: 37, scope: !449)
!452 = !DILocalVariable(name: "status", scope: !449, file: !2, line: 166, type: !213)
!453 = !DILocation(line: 166, column: 9, scope: !449)
!454 = !DILocation(line: 166, column: 41, scope: !449)
!455 = !DILocation(line: 166, column: 18, scope: !449)
!456 = !DILocation(line: 167, column: 5, scope: !449)
!457 = !DILocation(line: 168, column: 1, scope: !449)
!458 = distinct !DISubprogram(name: "cond_wait", scope: !2, file: !2, line: 170, type: !459, scopeLine: 171, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!459 = !DISubroutineType(types: !460)
!460 = !{null, !406, !272}
!461 = !DILocalVariable(name: "cond", arg: 1, scope: !458, file: !2, line: 170, type: !406)
!462 = !DILocation(line: 170, column: 32, scope: !458)
!463 = !DILocalVariable(name: "lock", arg: 2, scope: !458, file: !2, line: 170, type: !272)
!464 = !DILocation(line: 170, column: 55, scope: !458)
!465 = !DILocalVariable(name: "status", scope: !458, file: !2, line: 172, type: !213)
!466 = !DILocation(line: 172, column: 9, scope: !458)
!467 = !DILocation(line: 172, column: 36, scope: !458)
!468 = !DILocation(line: 172, column: 42, scope: !458)
!469 = !DILocation(line: 172, column: 18, scope: !458)
!470 = !DILocation(line: 174, column: 1, scope: !458)
!471 = distinct !DISubprogram(name: "cond_timedwait", scope: !2, file: !2, line: 176, type: !472, scopeLine: 177, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!472 = !DISubroutineType(types: !473)
!473 = !{null, !406, !272, !474}
!474 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!475 = !DILocalVariable(name: "cond", arg: 1, scope: !471, file: !2, line: 176, type: !406)
!476 = !DILocation(line: 176, column: 37, scope: !471)
!477 = !DILocalVariable(name: "lock", arg: 2, scope: !471, file: !2, line: 176, type: !272)
!478 = !DILocation(line: 176, column: 60, scope: !471)
!479 = !DILocalVariable(name: "millis", arg: 3, scope: !471, file: !2, line: 176, type: !474)
!480 = !DILocation(line: 176, column: 76, scope: !471)
!481 = !DILocalVariable(name: "ts", scope: !471, file: !2, line: 179, type: !482)
!482 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !483, line: 33, size: 128, elements: !484)
!483 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_types/_timespec.h", directory: "")
!484 = !{!485, !488}
!485 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !482, file: !483, line: 35, baseType: !486, size: 64)
!486 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_time_t", file: !487, line: 119, baseType: !140)
!487 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/arm/_types.h", directory: "")
!488 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !482, file: !483, line: 36, baseType: !140, size: 64, offset: 64)
!489 = !DILocation(line: 179, column: 21, scope: !471)
!490 = !DILocation(line: 183, column: 11, scope: !471)
!491 = !DILocalVariable(name: "status", scope: !471, file: !2, line: 184, type: !213)
!492 = !DILocation(line: 184, column: 9, scope: !471)
!493 = !DILocation(line: 184, column: 41, scope: !471)
!494 = !DILocation(line: 184, column: 47, scope: !471)
!495 = !DILocation(line: 184, column: 18, scope: !471)
!496 = !DILocation(line: 185, column: 1, scope: !471)
!497 = distinct !DISubprogram(name: "cond_worker", scope: !2, file: !2, line: 191, type: !227, scopeLine: 192, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!498 = !DILocalVariable(name: "message", arg: 1, scope: !497, file: !2, line: 191, type: !72)
!499 = !DILocation(line: 191, column: 25, scope: !497)
!500 = !DILocalVariable(name: "idle", scope: !497, file: !2, line: 193, type: !349)
!501 = !DILocation(line: 193, column: 10, scope: !497)
!502 = !DILocation(line: 195, column: 9, scope: !503)
!503 = distinct !DILexicalBlock(scope: !497, file: !2, line: 194, column: 5)
!504 = !DILocation(line: 196, column: 9, scope: !503)
!505 = !DILocation(line: 197, column: 9, scope: !503)
!506 = !DILocation(line: 198, column: 9, scope: !503)
!507 = !DILocation(line: 199, column: 16, scope: !503)
!508 = !DILocation(line: 199, column: 22, scope: !503)
!509 = !DILocation(line: 199, column: 14, scope: !503)
!510 = !DILocation(line: 200, column: 9, scope: !503)
!511 = !DILocation(line: 202, column: 9, scope: !512)
!512 = distinct !DILexicalBlock(scope: !497, file: !2, line: 202, column: 9)
!513 = !DILocation(line: 202, column: 9, scope: !497)
!514 = !DILocation(line: 203, column: 25, scope: !512)
!515 = !DILocation(line: 203, column: 34, scope: !512)
!516 = !DILocation(line: 203, column: 9, scope: !512)
!517 = !DILocation(line: 204, column: 10, scope: !497)
!518 = !DILocation(line: 206, column: 9, scope: !519)
!519 = distinct !DILexicalBlock(scope: !497, file: !2, line: 205, column: 5)
!520 = !DILocation(line: 207, column: 9, scope: !519)
!521 = !DILocation(line: 208, column: 9, scope: !519)
!522 = !DILocation(line: 209, column: 9, scope: !519)
!523 = !DILocation(line: 210, column: 16, scope: !519)
!524 = !DILocation(line: 210, column: 22, scope: !519)
!525 = !DILocation(line: 210, column: 14, scope: !519)
!526 = !DILocation(line: 211, column: 9, scope: !519)
!527 = !DILocation(line: 213, column: 9, scope: !528)
!528 = distinct !DILexicalBlock(scope: !497, file: !2, line: 213, column: 9)
!529 = !DILocation(line: 213, column: 9, scope: !497)
!530 = !DILocation(line: 214, column: 25, scope: !528)
!531 = !DILocation(line: 214, column: 34, scope: !528)
!532 = !DILocation(line: 214, column: 9, scope: !528)
!533 = !DILocation(line: 215, column: 12, scope: !497)
!534 = !DILocation(line: 215, column: 5, scope: !497)
!535 = !DILocation(line: 216, column: 1, scope: !497)
!536 = distinct !DISubprogram(name: "cond_test", scope: !2, file: !2, line: 218, type: !370, scopeLine: 219, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!537 = !DILocalVariable(name: "message", scope: !536, file: !2, line: 220, type: !72)
!538 = !DILocation(line: 220, column: 11, scope: !536)
!539 = !DILocation(line: 221, column: 5, scope: !536)
!540 = !DILocation(line: 222, column: 5, scope: !536)
!541 = !DILocalVariable(name: "worker", scope: !536, file: !2, line: 224, type: !184)
!542 = !DILocation(line: 224, column: 15, scope: !536)
!543 = !DILocation(line: 224, column: 51, scope: !536)
!544 = !DILocation(line: 224, column: 24, scope: !536)
!545 = !DILocation(line: 227, column: 9, scope: !546)
!546 = distinct !DILexicalBlock(scope: !536, file: !2, line: 226, column: 5)
!547 = !DILocation(line: 228, column: 9, scope: !546)
!548 = !DILocation(line: 229, column: 9, scope: !546)
!549 = !DILocation(line: 230, column: 9, scope: !546)
!550 = !DILocation(line: 234, column: 9, scope: !551)
!551 = distinct !DILexicalBlock(scope: !536, file: !2, line: 233, column: 5)
!552 = !DILocation(line: 235, column: 9, scope: !551)
!553 = !DILocation(line: 236, column: 9, scope: !551)
!554 = !DILocation(line: 237, column: 9, scope: !551)
!555 = !DILocalVariable(name: "result", scope: !536, file: !2, line: 240, type: !72)
!556 = !DILocation(line: 240, column: 11, scope: !536)
!557 = !DILocation(line: 240, column: 32, scope: !536)
!558 = !DILocation(line: 240, column: 20, scope: !536)
!559 = !DILocation(line: 241, column: 5, scope: !536)
!560 = !DILocation(line: 243, column: 5, scope: !536)
!561 = !DILocation(line: 244, column: 5, scope: !536)
!562 = !DILocation(line: 245, column: 1, scope: !536)
!563 = distinct !DISubprogram(name: "rwlock_init", scope: !2, file: !2, line: 252, type: !564, scopeLine: 253, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!564 = !DISubroutineType(types: !565)
!565 = !{null, !566, !213}
!566 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !567, size: 64)
!567 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlock_t", file: !568, line: 31, baseType: !569)
!568 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_rwlock_t.h", directory: "")
!569 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_rwlock_t", file: !136, line: 116, baseType: !570)
!570 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_rwlock_t", file: !136, line: 93, size: 1600, elements: !571)
!571 = !{!572, !573}
!572 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !570, file: !136, line: 94, baseType: !140, size: 64)
!573 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !570, file: !136, line: 95, baseType: !574, size: 1536, offset: 64)
!574 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 1536, elements: !575)
!575 = !{!576}
!576 = !DISubrange(count: 192)
!577 = !DILocalVariable(name: "lock", arg: 1, scope: !563, file: !2, line: 252, type: !566)
!578 = !DILocation(line: 252, column: 36, scope: !563)
!579 = !DILocalVariable(name: "shared", arg: 2, scope: !563, file: !2, line: 252, type: !213)
!580 = !DILocation(line: 252, column: 46, scope: !563)
!581 = !DILocalVariable(name: "status", scope: !563, file: !2, line: 254, type: !213)
!582 = !DILocation(line: 254, column: 9, scope: !563)
!583 = !DILocalVariable(name: "value", scope: !563, file: !2, line: 255, type: !213)
!584 = !DILocation(line: 255, column: 9, scope: !563)
!585 = !DILocalVariable(name: "attributes", scope: !563, file: !2, line: 256, type: !586)
!586 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlockattr_t", file: !587, line: 31, baseType: !588)
!587 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_rwlockattr_t.h", directory: "")
!588 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_rwlockattr_t", file: !136, line: 117, baseType: !589)
!589 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_rwlockattr_t", file: !136, line: 98, size: 192, elements: !590)
!590 = !{!591, !592}
!591 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !589, file: !136, line: 99, baseType: !140, size: 64)
!592 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !589, file: !136, line: 100, baseType: !153, size: 128, offset: 64)
!593 = !DILocation(line: 256, column: 26, scope: !563)
!594 = !DILocation(line: 257, column: 14, scope: !563)
!595 = !DILocation(line: 257, column: 12, scope: !563)
!596 = !DILocation(line: 258, column: 5, scope: !563)
!597 = !DILocation(line: 260, column: 57, scope: !563)
!598 = !DILocation(line: 260, column: 14, scope: !563)
!599 = !DILocation(line: 260, column: 12, scope: !563)
!600 = !DILocation(line: 261, column: 5, scope: !563)
!601 = !DILocation(line: 262, column: 14, scope: !563)
!602 = !DILocation(line: 262, column: 12, scope: !563)
!603 = !DILocation(line: 263, column: 5, scope: !563)
!604 = !DILocation(line: 265, column: 34, scope: !563)
!605 = !DILocation(line: 265, column: 14, scope: !563)
!606 = !DILocation(line: 265, column: 12, scope: !563)
!607 = !DILocation(line: 266, column: 5, scope: !563)
!608 = !DILocation(line: 267, column: 14, scope: !563)
!609 = !DILocation(line: 267, column: 12, scope: !563)
!610 = !DILocation(line: 268, column: 5, scope: !563)
!611 = !DILocation(line: 269, column: 1, scope: !563)
!612 = distinct !DISubprogram(name: "rwlock_destroy", scope: !2, file: !2, line: 271, type: !613, scopeLine: 272, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!613 = !DISubroutineType(types: !614)
!614 = !{null, !566}
!615 = !DILocalVariable(name: "lock", arg: 1, scope: !612, file: !2, line: 271, type: !566)
!616 = !DILocation(line: 271, column: 39, scope: !612)
!617 = !DILocalVariable(name: "status", scope: !612, file: !2, line: 273, type: !213)
!618 = !DILocation(line: 273, column: 9, scope: !612)
!619 = !DILocation(line: 273, column: 41, scope: !612)
!620 = !DILocation(line: 273, column: 18, scope: !612)
!621 = !DILocation(line: 274, column: 5, scope: !612)
!622 = !DILocation(line: 275, column: 1, scope: !612)
!623 = distinct !DISubprogram(name: "rwlock_wrlock", scope: !2, file: !2, line: 277, type: !613, scopeLine: 278, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!624 = !DILocalVariable(name: "lock", arg: 1, scope: !623, file: !2, line: 277, type: !566)
!625 = !DILocation(line: 277, column: 38, scope: !623)
!626 = !DILocalVariable(name: "status", scope: !623, file: !2, line: 279, type: !213)
!627 = !DILocation(line: 279, column: 9, scope: !623)
!628 = !DILocation(line: 279, column: 40, scope: !623)
!629 = !DILocation(line: 279, column: 18, scope: !623)
!630 = !DILocation(line: 280, column: 5, scope: !623)
!631 = !DILocation(line: 281, column: 1, scope: !623)
!632 = distinct !DISubprogram(name: "rwlock_trywrlock", scope: !2, file: !2, line: 283, type: !633, scopeLine: 284, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!633 = !DISubroutineType(types: !634)
!634 = !{!349, !566}
!635 = !DILocalVariable(name: "lock", arg: 1, scope: !632, file: !2, line: 283, type: !566)
!636 = !DILocation(line: 283, column: 41, scope: !632)
!637 = !DILocalVariable(name: "status", scope: !632, file: !2, line: 285, type: !213)
!638 = !DILocation(line: 285, column: 9, scope: !632)
!639 = !DILocation(line: 285, column: 43, scope: !632)
!640 = !DILocation(line: 285, column: 18, scope: !632)
!641 = !DILocation(line: 286, column: 5, scope: !632)
!642 = !DILocation(line: 287, column: 12, scope: !632)
!643 = !DILocation(line: 287, column: 19, scope: !632)
!644 = !DILocation(line: 287, column: 5, scope: !632)
!645 = distinct !DISubprogram(name: "rwlock_rdlock", scope: !2, file: !2, line: 290, type: !613, scopeLine: 291, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!646 = !DILocalVariable(name: "lock", arg: 1, scope: !645, file: !2, line: 290, type: !566)
!647 = !DILocation(line: 290, column: 38, scope: !645)
!648 = !DILocalVariable(name: "status", scope: !645, file: !2, line: 292, type: !213)
!649 = !DILocation(line: 292, column: 9, scope: !645)
!650 = !DILocation(line: 292, column: 40, scope: !645)
!651 = !DILocation(line: 292, column: 18, scope: !645)
!652 = !DILocation(line: 293, column: 5, scope: !645)
!653 = !DILocation(line: 294, column: 1, scope: !645)
!654 = distinct !DISubprogram(name: "rwlock_tryrdlock", scope: !2, file: !2, line: 296, type: !633, scopeLine: 297, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!655 = !DILocalVariable(name: "lock", arg: 1, scope: !654, file: !2, line: 296, type: !566)
!656 = !DILocation(line: 296, column: 41, scope: !654)
!657 = !DILocalVariable(name: "status", scope: !654, file: !2, line: 298, type: !213)
!658 = !DILocation(line: 298, column: 9, scope: !654)
!659 = !DILocation(line: 298, column: 43, scope: !654)
!660 = !DILocation(line: 298, column: 18, scope: !654)
!661 = !DILocation(line: 299, column: 5, scope: !654)
!662 = !DILocation(line: 300, column: 12, scope: !654)
!663 = !DILocation(line: 300, column: 19, scope: !654)
!664 = !DILocation(line: 300, column: 5, scope: !654)
!665 = distinct !DISubprogram(name: "rwlock_unlock", scope: !2, file: !2, line: 303, type: !613, scopeLine: 304, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!666 = !DILocalVariable(name: "lock", arg: 1, scope: !665, file: !2, line: 303, type: !566)
!667 = !DILocation(line: 303, column: 38, scope: !665)
!668 = !DILocalVariable(name: "status", scope: !665, file: !2, line: 305, type: !213)
!669 = !DILocation(line: 305, column: 9, scope: !665)
!670 = !DILocation(line: 305, column: 40, scope: !665)
!671 = !DILocation(line: 305, column: 18, scope: !665)
!672 = !DILocation(line: 306, column: 5, scope: !665)
!673 = !DILocation(line: 307, column: 1, scope: !665)
!674 = distinct !DISubprogram(name: "rwlock_test", scope: !2, file: !2, line: 309, type: !370, scopeLine: 310, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!675 = !DILocalVariable(name: "lock", scope: !674, file: !2, line: 311, type: !567)
!676 = !DILocation(line: 311, column: 22, scope: !674)
!677 = !DILocation(line: 312, column: 5, scope: !674)
!678 = !DILocalVariable(name: "test_depth", scope: !674, file: !2, line: 313, type: !679)
!679 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !213)
!680 = !DILocation(line: 313, column: 15, scope: !674)
!681 = !DILocation(line: 316, column: 9, scope: !682)
!682 = distinct !DILexicalBlock(scope: !674, file: !2, line: 315, column: 5)
!683 = !DILocalVariable(name: "success", scope: !682, file: !2, line: 317, type: !349)
!684 = !DILocation(line: 317, column: 14, scope: !682)
!685 = !DILocation(line: 317, column: 24, scope: !682)
!686 = !DILocation(line: 318, column: 9, scope: !682)
!687 = !DILocation(line: 319, column: 19, scope: !682)
!688 = !DILocation(line: 319, column: 17, scope: !682)
!689 = !DILocation(line: 320, column: 9, scope: !682)
!690 = !DILocation(line: 321, column: 9, scope: !682)
!691 = !DILocation(line: 325, column: 9, scope: !692)
!692 = distinct !DILexicalBlock(scope: !674, file: !2, line: 324, column: 5)
!693 = !DILocalVariable(name: "i", scope: !694, file: !2, line: 326, type: !213)
!694 = distinct !DILexicalBlock(scope: !692, file: !2, line: 326, column: 9)
!695 = !DILocation(line: 326, column: 18, scope: !694)
!696 = !DILocation(line: 326, column: 14, scope: !694)
!697 = !DILocation(line: 326, column: 25, scope: !698)
!698 = distinct !DILexicalBlock(scope: !694, file: !2, line: 326, column: 9)
!699 = !DILocation(line: 326, column: 27, scope: !698)
!700 = !DILocation(line: 326, column: 9, scope: !694)
!701 = !DILocalVariable(name: "success", scope: !702, file: !2, line: 328, type: !349)
!702 = distinct !DILexicalBlock(scope: !698, file: !2, line: 327, column: 9)
!703 = !DILocation(line: 328, column: 18, scope: !702)
!704 = !DILocation(line: 328, column: 28, scope: !702)
!705 = !DILocation(line: 329, column: 13, scope: !702)
!706 = !DILocation(line: 330, column: 9, scope: !702)
!707 = !DILocation(line: 326, column: 42, scope: !698)
!708 = !DILocation(line: 326, column: 9, scope: !698)
!709 = distinct !{!709, !700, !710, !711}
!710 = !DILocation(line: 330, column: 9, scope: !694)
!711 = !{!"llvm.loop.mustprogress"}
!712 = !DILocalVariable(name: "success", scope: !713, file: !2, line: 333, type: !349)
!713 = distinct !DILexicalBlock(scope: !692, file: !2, line: 332, column: 9)
!714 = !DILocation(line: 333, column: 18, scope: !713)
!715 = !DILocation(line: 333, column: 28, scope: !713)
!716 = !DILocation(line: 334, column: 13, scope: !713)
!717 = !DILocation(line: 337, column: 9, scope: !692)
!718 = !DILocalVariable(name: "i", scope: !719, file: !2, line: 338, type: !213)
!719 = distinct !DILexicalBlock(scope: !692, file: !2, line: 338, column: 9)
!720 = !DILocation(line: 338, column: 18, scope: !719)
!721 = !DILocation(line: 338, column: 14, scope: !719)
!722 = !DILocation(line: 338, column: 25, scope: !723)
!723 = distinct !DILexicalBlock(scope: !719, file: !2, line: 338, column: 9)
!724 = !DILocation(line: 338, column: 27, scope: !723)
!725 = !DILocation(line: 338, column: 9, scope: !719)
!726 = !DILocation(line: 339, column: 13, scope: !727)
!727 = distinct !DILexicalBlock(scope: !723, file: !2, line: 338, column: 46)
!728 = !DILocation(line: 340, column: 9, scope: !727)
!729 = !DILocation(line: 338, column: 42, scope: !723)
!730 = !DILocation(line: 338, column: 9, scope: !723)
!731 = distinct !{!731, !725, !732, !711}
!732 = !DILocation(line: 340, column: 9, scope: !719)
!733 = !DILocation(line: 344, column: 9, scope: !734)
!734 = distinct !DILexicalBlock(scope: !674, file: !2, line: 343, column: 5)
!735 = !DILocalVariable(name: "success", scope: !734, file: !2, line: 345, type: !349)
!736 = !DILocation(line: 345, column: 14, scope: !734)
!737 = !DILocation(line: 345, column: 24, scope: !734)
!738 = !DILocation(line: 346, column: 9, scope: !734)
!739 = !DILocation(line: 347, column: 9, scope: !734)
!740 = !DILocation(line: 350, column: 5, scope: !674)
!741 = !DILocation(line: 351, column: 1, scope: !674)
!742 = distinct !DISubprogram(name: "key_destroy", scope: !2, file: !2, line: 358, type: !197, scopeLine: 359, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!743 = !DILocalVariable(name: "unused_value", arg: 1, scope: !742, file: !2, line: 358, type: !72)
!744 = !DILocation(line: 358, column: 24, scope: !742)
!745 = !DILocation(line: 360, column: 21, scope: !742)
!746 = !DILocation(line: 360, column: 19, scope: !742)
!747 = !DILocation(line: 361, column: 1, scope: !742)
!748 = distinct !DISubprogram(name: "key_worker", scope: !2, file: !2, line: 363, type: !227, scopeLine: 364, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!749 = !DILocalVariable(name: "message", arg: 1, scope: !748, file: !2, line: 363, type: !72)
!750 = !DILocation(line: 363, column: 24, scope: !748)
!751 = !DILocalVariable(name: "my_secret", scope: !748, file: !2, line: 365, type: !213)
!752 = !DILocation(line: 365, column: 9, scope: !748)
!753 = !DILocalVariable(name: "status", scope: !748, file: !2, line: 367, type: !213)
!754 = !DILocation(line: 367, column: 9, scope: !748)
!755 = !DILocation(line: 367, column: 38, scope: !748)
!756 = !DILocation(line: 367, column: 18, scope: !748)
!757 = !DILocation(line: 368, column: 5, scope: !748)
!758 = !DILocalVariable(name: "my_local_data", scope: !748, file: !2, line: 370, type: !72)
!759 = !DILocation(line: 370, column: 11, scope: !748)
!760 = !DILocation(line: 370, column: 47, scope: !748)
!761 = !DILocation(line: 370, column: 27, scope: !748)
!762 = !DILocation(line: 371, column: 5, scope: !748)
!763 = !DILocation(line: 373, column: 12, scope: !748)
!764 = !DILocation(line: 373, column: 5, scope: !748)
!765 = distinct !DISubprogram(name: "key_test", scope: !2, file: !2, line: 376, type: !370, scopeLine: 377, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!766 = !DILocalVariable(name: "my_secret", scope: !765, file: !2, line: 378, type: !213)
!767 = !DILocation(line: 378, column: 9, scope: !765)
!768 = !DILocalVariable(name: "message", scope: !765, file: !2, line: 379, type: !72)
!769 = !DILocation(line: 379, column: 11, scope: !765)
!770 = !DILocalVariable(name: "status", scope: !765, file: !2, line: 380, type: !213)
!771 = !DILocation(line: 380, column: 9, scope: !765)
!772 = !DILocation(line: 382, column: 5, scope: !765)
!773 = !DILocalVariable(name: "worker", scope: !765, file: !2, line: 384, type: !184)
!774 = !DILocation(line: 384, column: 15, scope: !765)
!775 = !DILocation(line: 384, column: 50, scope: !765)
!776 = !DILocation(line: 384, column: 24, scope: !765)
!777 = !DILocation(line: 386, column: 34, scope: !765)
!778 = !DILocation(line: 386, column: 14, scope: !765)
!779 = !DILocation(line: 386, column: 12, scope: !765)
!780 = !DILocation(line: 387, column: 5, scope: !765)
!781 = !DILocalVariable(name: "my_local_data", scope: !765, file: !2, line: 389, type: !72)
!782 = !DILocation(line: 389, column: 11, scope: !765)
!783 = !DILocation(line: 389, column: 47, scope: !765)
!784 = !DILocation(line: 389, column: 27, scope: !765)
!785 = !DILocation(line: 390, column: 5, scope: !765)
!786 = !DILocation(line: 392, column: 34, scope: !765)
!787 = !DILocation(line: 392, column: 14, scope: !765)
!788 = !DILocation(line: 392, column: 12, scope: !765)
!789 = !DILocation(line: 393, column: 5, scope: !765)
!790 = !DILocalVariable(name: "result", scope: !765, file: !2, line: 395, type: !72)
!791 = !DILocation(line: 395, column: 11, scope: !765)
!792 = !DILocation(line: 395, column: 32, scope: !765)
!793 = !DILocation(line: 395, column: 20, scope: !765)
!794 = !DILocation(line: 396, column: 5, scope: !765)
!795 = !DILocation(line: 398, column: 33, scope: !765)
!796 = !DILocation(line: 398, column: 14, scope: !765)
!797 = !DILocation(line: 398, column: 12, scope: !765)
!798 = !DILocation(line: 399, column: 5, scope: !765)
!799 = !DILocation(line: 401, column: 5, scope: !765)
!800 = !DILocation(line: 402, column: 1, scope: !765)
!801 = distinct !DISubprogram(name: "detach_test_worker0", scope: !2, file: !2, line: 406, type: !227, scopeLine: 407, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!802 = !DILocalVariable(name: "ignore", arg: 1, scope: !801, file: !2, line: 406, type: !72)
!803 = !DILocation(line: 406, column: 33, scope: !801)
!804 = !DILocation(line: 408, column: 5, scope: !801)
!805 = distinct !DISubprogram(name: "detach_test_detach", scope: !2, file: !2, line: 411, type: !227, scopeLine: 412, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!806 = !DILocalVariable(name: "ignore", arg: 1, scope: !805, file: !2, line: 411, type: !72)
!807 = !DILocation(line: 411, column: 32, scope: !805)
!808 = !DILocalVariable(name: "status", scope: !805, file: !2, line: 413, type: !213)
!809 = !DILocation(line: 413, column: 9, scope: !805)
!810 = !DILocalVariable(name: "w0", scope: !805, file: !2, line: 414, type: !184)
!811 = !DILocation(line: 414, column: 15, scope: !805)
!812 = !DILocation(line: 414, column: 20, scope: !805)
!813 = !DILocation(line: 415, column: 29, scope: !805)
!814 = !DILocation(line: 415, column: 14, scope: !805)
!815 = !DILocation(line: 415, column: 12, scope: !805)
!816 = !DILocation(line: 416, column: 5, scope: !805)
!817 = !DILocation(line: 418, column: 27, scope: !805)
!818 = !DILocation(line: 418, column: 14, scope: !805)
!819 = !DILocation(line: 418, column: 12, scope: !805)
!820 = !DILocation(line: 419, column: 5, scope: !805)
!821 = !DILocation(line: 420, column: 5, scope: !805)
!822 = distinct !DISubprogram(name: "detach_test_attr", scope: !2, file: !2, line: 423, type: !227, scopeLine: 424, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!823 = !DILocalVariable(name: "ignore", arg: 1, scope: !822, file: !2, line: 423, type: !72)
!824 = !DILocation(line: 423, column: 30, scope: !822)
!825 = !DILocalVariable(name: "status", scope: !822, file: !2, line: 425, type: !213)
!826 = !DILocation(line: 425, column: 9, scope: !822)
!827 = !DILocalVariable(name: "detachstate", scope: !822, file: !2, line: 426, type: !213)
!828 = !DILocation(line: 426, column: 9, scope: !822)
!829 = !DILocalVariable(name: "w0", scope: !822, file: !2, line: 427, type: !184)
!830 = !DILocation(line: 427, column: 15, scope: !822)
!831 = !DILocalVariable(name: "w0_attr", scope: !822, file: !2, line: 428, type: !237)
!832 = !DILocation(line: 428, column: 20, scope: !822)
!833 = !DILocation(line: 429, column: 14, scope: !822)
!834 = !DILocation(line: 429, column: 12, scope: !822)
!835 = !DILocation(line: 430, column: 5, scope: !822)
!836 = !DILocation(line: 431, column: 14, scope: !822)
!837 = !DILocation(line: 431, column: 12, scope: !822)
!838 = !DILocation(line: 432, column: 5, scope: !822)
!839 = !DILocation(line: 0, scope: !822)
!840 = !DILocation(line: 433, column: 14, scope: !822)
!841 = !DILocation(line: 433, column: 12, scope: !822)
!842 = !DILocation(line: 434, column: 5, scope: !822)
!843 = !DILocation(line: 435, column: 14, scope: !822)
!844 = !DILocation(line: 435, column: 12, scope: !822)
!845 = !DILocation(line: 436, column: 5, scope: !822)
!846 = !DILocation(line: 437, column: 14, scope: !822)
!847 = !DILocation(line: 437, column: 12, scope: !822)
!848 = !DILocation(line: 438, column: 5, scope: !822)
!849 = !DILocation(line: 439, column: 5, scope: !822)
!850 = !DILocation(line: 441, column: 27, scope: !822)
!851 = !DILocation(line: 441, column: 14, scope: !822)
!852 = !DILocation(line: 441, column: 12, scope: !822)
!853 = !DILocation(line: 442, column: 5, scope: !822)
!854 = !DILocation(line: 443, column: 5, scope: !822)
!855 = distinct !DISubprogram(name: "detach_test", scope: !2, file: !2, line: 446, type: !370, scopeLine: 447, spFlags: DISPFlagDefinition, unit: !68)
!856 = !DILocation(line: 448, column: 5, scope: !855)
!857 = !DILocation(line: 449, column: 5, scope: !855)
!858 = !DILocation(line: 450, column: 1, scope: !855)
!859 = distinct !DISubprogram(name: "once_init0", scope: !2, file: !2, line: 459, type: !370, scopeLine: 460, spFlags: DISPFlagDefinition, unit: !68)
!860 = !DILocation(line: 461, column: 5, scope: !859)
!861 = !DILocation(line: 462, column: 16, scope: !859)
!862 = !DILocation(line: 463, column: 1, scope: !859)
!863 = distinct !DISubprogram(name: "once_init1", scope: !2, file: !2, line: 465, type: !370, scopeLine: 466, spFlags: DISPFlagDefinition, unit: !68)
!864 = !DILocation(line: 467, column: 5, scope: !863)
!865 = !DILocation(line: 468, column: 1, scope: !863)
!866 = distinct !DISubprogram(name: "once_worker", scope: !2, file: !2, line: 470, type: !227, scopeLine: 471, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!867 = !DILocalVariable(name: "ignore", arg: 1, scope: !866, file: !2, line: 470, type: !72)
!868 = !DILocation(line: 470, column: 25, scope: !866)
!869 = !DILocalVariable(name: "status", scope: !866, file: !2, line: 472, type: !213)
!870 = !DILocation(line: 472, column: 9, scope: !866)
!871 = !DILocation(line: 472, column: 18, scope: !866)
!872 = !DILocation(line: 473, column: 5, scope: !866)
!873 = !DILocation(line: 474, column: 5, scope: !866)
!874 = !DILocation(line: 475, column: 5, scope: !866)
!875 = distinct !DISubprogram(name: "once_test", scope: !2, file: !2, line: 478, type: !370, scopeLine: 479, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !229)
!876 = !DILocalVariable(name: "worker0", scope: !875, file: !2, line: 480, type: !184)
!877 = !DILocation(line: 480, column: 15, scope: !875)
!878 = !DILocation(line: 480, column: 25, scope: !875)
!879 = !DILocalVariable(name: "worker1", scope: !875, file: !2, line: 481, type: !184)
!880 = !DILocation(line: 481, column: 15, scope: !875)
!881 = !DILocation(line: 481, column: 25, scope: !875)
!882 = !DILocation(line: 482, column: 17, scope: !875)
!883 = !DILocation(line: 482, column: 5, scope: !875)
!884 = !DILocation(line: 483, column: 17, scope: !875)
!885 = !DILocation(line: 483, column: 5, scope: !875)
!886 = !DILocation(line: 484, column: 5, scope: !875)
!887 = !DILocalVariable(name: "status", scope: !875, file: !2, line: 486, type: !213)
!888 = !DILocation(line: 486, column: 9, scope: !875)
!889 = !DILocation(line: 486, column: 18, scope: !875)
!890 = !DILocation(line: 487, column: 5, scope: !875)
!891 = !DILocation(line: 488, column: 14, scope: !875)
!892 = !DILocation(line: 488, column: 12, scope: !875)
!893 = !DILocation(line: 489, column: 5, scope: !875)
!894 = !DILocation(line: 490, column: 5, scope: !875)
!895 = !DILocation(line: 491, column: 1, scope: !875)
!896 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 493, type: !897, scopeLine: 494, spFlags: DISPFlagDefinition, unit: !68)
!897 = !DISubroutineType(types: !898)
!898 = !{!213}
!899 = !DILocation(line: 495, column: 13, scope: !896)
!900 = !DILocation(line: 495, column: 5, scope: !896)
!901 = !DILocation(line: 496, column: 17, scope: !902)
!902 = distinct !DILexicalBlock(scope: !896, file: !2, line: 495, column: 38)
!903 = !DILocation(line: 496, column: 31, scope: !902)
!904 = !DILocation(line: 497, column: 17, scope: !902)
!905 = !DILocation(line: 497, column: 30, scope: !902)
!906 = !DILocation(line: 498, column: 17, scope: !902)
!907 = !DILocation(line: 498, column: 32, scope: !902)
!908 = !DILocation(line: 499, column: 17, scope: !902)
!909 = !DILocation(line: 499, column: 29, scope: !902)
!910 = !DILocation(line: 500, column: 17, scope: !902)
!911 = !DILocation(line: 500, column: 32, scope: !902)
!912 = !DILocation(line: 501, column: 17, scope: !902)
!913 = !DILocation(line: 501, column: 30, scope: !902)
!914 = !DILocation(line: 503, column: 1, scope: !896)
