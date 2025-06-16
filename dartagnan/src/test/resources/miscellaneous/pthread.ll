; ModuleID = 'benchmarks/miscellaneous/pthread.c'
source_filename = "benchmarks/miscellaneous/pthread.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._opaque_pthread_mutex_t = type { i64, [56 x i8] }
%struct._opaque_pthread_cond_t = type { i64, [40 x i8] }
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
@__func__.mutex_unlock = private unnamed_addr constant [13 x i8] c"mutex_unlock\00", align 1, !dbg !30
@__func__.mutex_test = private unnamed_addr constant [11 x i8] c"mutex_test\00", align 1, !dbg !35
@.str.2 = private unnamed_addr constant [9 x i8] c"!success\00", align 1, !dbg !37
@.str.3 = private unnamed_addr constant [8 x i8] c"success\00", align 1, !dbg !42
@__func__.cond_init = private unnamed_addr constant [10 x i8] c"cond_init\00", align 1, !dbg !47
@__func__.cond_destroy = private unnamed_addr constant [13 x i8] c"cond_destroy\00", align 1, !dbg !50
@__func__.cond_signal = private unnamed_addr constant [12 x i8] c"cond_signal\00", align 1, !dbg !52
@__func__.cond_broadcast = private unnamed_addr constant [15 x i8] c"cond_broadcast\00", align 1, !dbg !54
@phase = dso_local global i32 0, align 4, !dbg !59
@cond_mutex = dso_local global %struct._opaque_pthread_mutex_t zeroinitializer, align 8, !dbg !114
@cond = dso_local global %struct._opaque_pthread_cond_t zeroinitializer, align 8, !dbg !128
@__func__.cond_test = private unnamed_addr constant [10 x i8] c"cond_test\00", align 1, !dbg !66
@.str.4 = private unnamed_addr constant [18 x i8] c"result == message\00", align 1, !dbg !68
@__func__.rwlock_init = private unnamed_addr constant [12 x i8] c"rwlock_init\00", align 1, !dbg !73
@__func__.rwlock_destroy = private unnamed_addr constant [15 x i8] c"rwlock_destroy\00", align 1, !dbg !75
@__func__.rwlock_wrlock = private unnamed_addr constant [14 x i8] c"rwlock_wrlock\00", align 1, !dbg !77
@__func__.rwlock_rdlock = private unnamed_addr constant [14 x i8] c"rwlock_rdlock\00", align 1, !dbg !79
@__func__.rwlock_unlock = private unnamed_addr constant [14 x i8] c"rwlock_unlock\00", align 1, !dbg !81
@__func__.rwlock_test = private unnamed_addr constant [12 x i8] c"rwlock_test\00", align 1, !dbg !83
@latest_thread = dso_local global ptr null, align 8, !dbg !140
@local_data = dso_local global i64 0, align 8, !dbg !163
@__func__.key_worker = private unnamed_addr constant [11 x i8] c"key_worker\00", align 1, !dbg !85
@.str.5 = private unnamed_addr constant [28 x i8] c"my_local_data == &my_secret\00", align 1, !dbg !87
@__func__.key_test = private unnamed_addr constant [9 x i8] c"key_test\00", align 1, !dbg !92
@__func__.detach_test_detach = private unnamed_addr constant [19 x i8] c"detach_test_detach\00", align 1, !dbg !95
@.str.6 = private unnamed_addr constant [12 x i8] c"status != 0\00", align 1, !dbg !100
@__func__.detach_test_attr = private unnamed_addr constant [17 x i8] c"detach_test_attr\00", align 1, !dbg !102
@.str.7 = private unnamed_addr constant [54 x i8] c"status == 0 && detachstate == PTHREAD_CREATE_JOINABLE\00", align 1, !dbg !107
@.str.8 = private unnamed_addr constant [54 x i8] c"status == 0 && detachstate == PTHREAD_CREATE_DETACHED\00", align 1, !dbg !112

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_create(ptr noundef %0, ptr noundef %1) #0 !dbg !178 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca %struct._opaque_pthread_attr_t, align 8
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !185, !DIExpression(), !186)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !187, !DIExpression(), !188)
    #dbg_declare(ptr %5, !189, !DIExpression(), !190)
    #dbg_declare(ptr %6, !191, !DIExpression(), !199)
  %8 = call i32 @pthread_attr_init(ptr noundef %6), !dbg !200
    #dbg_declare(ptr %7, !201, !DIExpression(), !202)
  %9 = load ptr, ptr %3, align 8, !dbg !203
  %10 = load ptr, ptr %4, align 8, !dbg !204
  %11 = call i32 @pthread_create(ptr noundef %5, ptr noundef %6, ptr noundef %9, ptr noundef %10), !dbg !205
  store i32 %11, ptr %7, align 4, !dbg !202
  %12 = load i32, ptr %7, align 4, !dbg !206
  %13 = icmp eq i32 %12, 0, !dbg !206
  %14 = xor i1 %13, true, !dbg !206
  %15 = zext i1 %14 to i32, !dbg !206
  %16 = sext i32 %15 to i64, !dbg !206
  %17 = icmp ne i64 %16, 0, !dbg !206
  br i1 %17, label %18, label %20, !dbg !206

18:                                               ; preds = %2
  call void @__assert_rtn(ptr noundef @__func__.thread_create, ptr noundef @.str, i32 noundef 18, ptr noundef @.str.1) #3, !dbg !206
  unreachable, !dbg !206

19:                                               ; No predecessors!
  br label %21, !dbg !206

20:                                               ; preds = %2
  br label %21, !dbg !206

21:                                               ; preds = %20, %19
  %22 = call i32 @pthread_attr_destroy(ptr noundef %6), !dbg !207
  %23 = load ptr, ptr %5, align 8, !dbg !208
  ret ptr %23, !dbg !209
}

declare i32 @pthread_attr_init(ptr noundef) #1

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

declare i32 @pthread_attr_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_join(ptr noundef %0) #0 !dbg !210 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !213, !DIExpression(), !214)
    #dbg_declare(ptr %3, !215, !DIExpression(), !216)
    #dbg_declare(ptr %4, !217, !DIExpression(), !218)
  %5 = load ptr, ptr %2, align 8, !dbg !219
  %6 = call i32 @_pthread_join(ptr noundef %5, ptr noundef %3), !dbg !220
  store i32 %6, ptr %4, align 4, !dbg !218
  %7 = load i32, ptr %4, align 4, !dbg !221
  %8 = icmp eq i32 %7, 0, !dbg !221
  %9 = xor i1 %8, true, !dbg !221
  %10 = zext i1 %9 to i32, !dbg !221
  %11 = sext i32 %10 to i64, !dbg !221
  %12 = icmp ne i64 %11, 0, !dbg !221
  br i1 %12, label %13, label %15, !dbg !221

13:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.thread_join, ptr noundef @.str, i32 noundef 27, ptr noundef @.str.1) #3, !dbg !221
  unreachable, !dbg !221

14:                                               ; No predecessors!
  br label %16, !dbg !221

15:                                               ; preds = %1
  br label %16, !dbg !221

16:                                               ; preds = %15, %14
  %17 = load ptr, ptr %3, align 8, !dbg !222
  ret ptr %17, !dbg !223
}

declare i32 @_pthread_join(ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_init(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) #0 !dbg !224 {
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca %struct._opaque_pthread_mutexattr_t, align 8
  store ptr %0, ptr %6, align 8
    #dbg_declare(ptr %6, !228, !DIExpression(), !229)
  store i32 %1, ptr %7, align 4
    #dbg_declare(ptr %7, !230, !DIExpression(), !231)
  store i32 %2, ptr %8, align 4
    #dbg_declare(ptr %8, !232, !DIExpression(), !233)
  store i32 %3, ptr %9, align 4
    #dbg_declare(ptr %9, !234, !DIExpression(), !235)
  store i32 %4, ptr %10, align 4
    #dbg_declare(ptr %10, !236, !DIExpression(), !237)
    #dbg_declare(ptr %11, !238, !DIExpression(), !239)
    #dbg_declare(ptr %12, !240, !DIExpression(), !241)
    #dbg_declare(ptr %13, !242, !DIExpression(), !250)
  %14 = call i32 @pthread_mutexattr_init(ptr noundef %13), !dbg !251
  store i32 %14, ptr %11, align 4, !dbg !252
  %15 = load i32, ptr %11, align 4, !dbg !253
  %16 = icmp eq i32 %15, 0, !dbg !253
  %17 = xor i1 %16, true, !dbg !253
  %18 = zext i1 %17 to i32, !dbg !253
  %19 = sext i32 %18 to i64, !dbg !253
  %20 = icmp ne i64 %19, 0, !dbg !253
  br i1 %20, label %21, label %23, !dbg !253

21:                                               ; preds = %5
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 49, ptr noundef @.str.1) #3, !dbg !253
  unreachable, !dbg !253

22:                                               ; No predecessors!
  br label %24, !dbg !253

23:                                               ; preds = %5
  br label %24, !dbg !253

24:                                               ; preds = %23, %22
  %25 = load i32, ptr %7, align 4, !dbg !254
  %26 = call i32 @pthread_mutexattr_settype(ptr noundef %13, i32 noundef %25), !dbg !255
  store i32 %26, ptr %11, align 4, !dbg !256
  %27 = load i32, ptr %11, align 4, !dbg !257
  %28 = icmp eq i32 %27, 0, !dbg !257
  %29 = xor i1 %28, true, !dbg !257
  %30 = zext i1 %29 to i32, !dbg !257
  %31 = sext i32 %30 to i64, !dbg !257
  %32 = icmp ne i64 %31, 0, !dbg !257
  br i1 %32, label %33, label %35, !dbg !257

33:                                               ; preds = %24
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 52, ptr noundef @.str.1) #3, !dbg !257
  unreachable, !dbg !257

34:                                               ; No predecessors!
  br label %36, !dbg !257

35:                                               ; preds = %24
  br label %36, !dbg !257

36:                                               ; preds = %35, %34
  %37 = call i32 @pthread_mutexattr_gettype(ptr noundef %13, ptr noundef %12), !dbg !258
  store i32 %37, ptr %11, align 4, !dbg !259
  %38 = load i32, ptr %11, align 4, !dbg !260
  %39 = icmp eq i32 %38, 0, !dbg !260
  %40 = xor i1 %39, true, !dbg !260
  %41 = zext i1 %40 to i32, !dbg !260
  %42 = sext i32 %41 to i64, !dbg !260
  %43 = icmp ne i64 %42, 0, !dbg !260
  br i1 %43, label %44, label %46, !dbg !260

44:                                               ; preds = %36
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 54, ptr noundef @.str.1) #3, !dbg !260
  unreachable, !dbg !260

45:                                               ; No predecessors!
  br label %47, !dbg !260

46:                                               ; preds = %36
  br label %47, !dbg !260

47:                                               ; preds = %46, %45
  %48 = load i32, ptr %8, align 4, !dbg !261
  %49 = call i32 @pthread_mutexattr_setprotocol(ptr noundef %13, i32 noundef %48), !dbg !262
  store i32 %49, ptr %11, align 4, !dbg !263
  %50 = load i32, ptr %11, align 4, !dbg !264
  %51 = icmp eq i32 %50, 0, !dbg !264
  %52 = xor i1 %51, true, !dbg !264
  %53 = zext i1 %52 to i32, !dbg !264
  %54 = sext i32 %53 to i64, !dbg !264
  %55 = icmp ne i64 %54, 0, !dbg !264
  br i1 %55, label %56, label %58, !dbg !264

56:                                               ; preds = %47
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 57, ptr noundef @.str.1) #3, !dbg !264
  unreachable, !dbg !264

57:                                               ; No predecessors!
  br label %59, !dbg !264

58:                                               ; preds = %47
  br label %59, !dbg !264

59:                                               ; preds = %58, %57
  %60 = call i32 @pthread_mutexattr_getprotocol(ptr noundef %13, ptr noundef %12), !dbg !265
  store i32 %60, ptr %11, align 4, !dbg !266
  %61 = load i32, ptr %11, align 4, !dbg !267
  %62 = icmp eq i32 %61, 0, !dbg !267
  %63 = xor i1 %62, true, !dbg !267
  %64 = zext i1 %63 to i32, !dbg !267
  %65 = sext i32 %64 to i64, !dbg !267
  %66 = icmp ne i64 %65, 0, !dbg !267
  br i1 %66, label %67, label %69, !dbg !267

67:                                               ; preds = %59
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 59, ptr noundef @.str.1) #3, !dbg !267
  unreachable, !dbg !267

68:                                               ; No predecessors!
  br label %70, !dbg !267

69:                                               ; preds = %59
  br label %70, !dbg !267

70:                                               ; preds = %69, %68
  %71 = load i32, ptr %9, align 4, !dbg !268
  %72 = call i32 @pthread_mutexattr_setpolicy_np(ptr noundef %13, i32 noundef %71), !dbg !269
  store i32 %72, ptr %11, align 4, !dbg !270
  %73 = load i32, ptr %11, align 4, !dbg !271
  %74 = icmp eq i32 %73, 0, !dbg !271
  %75 = xor i1 %74, true, !dbg !271
  %76 = zext i1 %75 to i32, !dbg !271
  %77 = sext i32 %76 to i64, !dbg !271
  %78 = icmp ne i64 %77, 0, !dbg !271
  br i1 %78, label %79, label %81, !dbg !271

79:                                               ; preds = %70
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 62, ptr noundef @.str.1) #3, !dbg !271
  unreachable, !dbg !271

80:                                               ; No predecessors!
  br label %82, !dbg !271

81:                                               ; preds = %70
  br label %82, !dbg !271

82:                                               ; preds = %81, %80
  %83 = call i32 @pthread_mutexattr_getpolicy_np(ptr noundef %13, ptr noundef %12), !dbg !272
  store i32 %83, ptr %11, align 4, !dbg !273
  %84 = load i32, ptr %11, align 4, !dbg !274
  %85 = icmp eq i32 %84, 0, !dbg !274
  %86 = xor i1 %85, true, !dbg !274
  %87 = zext i1 %86 to i32, !dbg !274
  %88 = sext i32 %87 to i64, !dbg !274
  %89 = icmp ne i64 %88, 0, !dbg !274
  br i1 %89, label %90, label %92, !dbg !274

90:                                               ; preds = %82
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 64, ptr noundef @.str.1) #3, !dbg !274
  unreachable, !dbg !274

91:                                               ; No predecessors!
  br label %93, !dbg !274

92:                                               ; preds = %82
  br label %93, !dbg !274

93:                                               ; preds = %92, %91
  %94 = load i32, ptr %10, align 4, !dbg !275
  %95 = call i32 @pthread_mutexattr_setprioceiling(ptr noundef %13, i32 noundef %94), !dbg !276
  store i32 %95, ptr %11, align 4, !dbg !277
  %96 = load i32, ptr %11, align 4, !dbg !278
  %97 = icmp eq i32 %96, 0, !dbg !278
  %98 = xor i1 %97, true, !dbg !278
  %99 = zext i1 %98 to i32, !dbg !278
  %100 = sext i32 %99 to i64, !dbg !278
  %101 = icmp ne i64 %100, 0, !dbg !278
  br i1 %101, label %102, label %104, !dbg !278

102:                                              ; preds = %93
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 67, ptr noundef @.str.1) #3, !dbg !278
  unreachable, !dbg !278

103:                                              ; No predecessors!
  br label %105, !dbg !278

104:                                              ; preds = %93
  br label %105, !dbg !278

105:                                              ; preds = %104, %103
  %106 = call i32 @pthread_mutexattr_getprioceiling(ptr noundef %13, ptr noundef %12), !dbg !279
  store i32 %106, ptr %11, align 4, !dbg !280
  %107 = load i32, ptr %11, align 4, !dbg !281
  %108 = icmp eq i32 %107, 0, !dbg !281
  %109 = xor i1 %108, true, !dbg !281
  %110 = zext i1 %109 to i32, !dbg !281
  %111 = sext i32 %110 to i64, !dbg !281
  %112 = icmp ne i64 %111, 0, !dbg !281
  br i1 %112, label %113, label %115, !dbg !281

113:                                              ; preds = %105
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 69, ptr noundef @.str.1) #3, !dbg !281
  unreachable, !dbg !281

114:                                              ; No predecessors!
  br label %116, !dbg !281

115:                                              ; preds = %105
  br label %116, !dbg !281

116:                                              ; preds = %115, %114
  %117 = load ptr, ptr %6, align 8, !dbg !282
  %118 = call i32 @pthread_mutex_init(ptr noundef %117, ptr noundef %13), !dbg !283
  store i32 %118, ptr %11, align 4, !dbg !284
  %119 = load i32, ptr %11, align 4, !dbg !285
  %120 = icmp eq i32 %119, 0, !dbg !285
  %121 = xor i1 %120, true, !dbg !285
  %122 = zext i1 %121 to i32, !dbg !285
  %123 = sext i32 %122 to i64, !dbg !285
  %124 = icmp ne i64 %123, 0, !dbg !285
  br i1 %124, label %125, label %127, !dbg !285

125:                                              ; preds = %116
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 72, ptr noundef @.str.1) #3, !dbg !285
  unreachable, !dbg !285

126:                                              ; No predecessors!
  br label %128, !dbg !285

127:                                              ; preds = %116
  br label %128, !dbg !285

128:                                              ; preds = %127, %126
  %129 = call i32 @_pthread_mutexattr_destroy(ptr noundef %13), !dbg !286
  store i32 %129, ptr %11, align 4, !dbg !287
  %130 = load i32, ptr %11, align 4, !dbg !288
  %131 = icmp eq i32 %130, 0, !dbg !288
  %132 = xor i1 %131, true, !dbg !288
  %133 = zext i1 %132 to i32, !dbg !288
  %134 = sext i32 %133 to i64, !dbg !288
  %135 = icmp ne i64 %134, 0, !dbg !288
  br i1 %135, label %136, label %138, !dbg !288

136:                                              ; preds = %128
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 74, ptr noundef @.str.1) #3, !dbg !288
  unreachable, !dbg !288

137:                                              ; No predecessors!
  br label %139, !dbg !288

138:                                              ; preds = %128
  br label %139, !dbg !288

139:                                              ; preds = %138, %137
  ret void, !dbg !289
}

declare i32 @pthread_mutexattr_init(ptr noundef) #1

declare i32 @pthread_mutexattr_settype(ptr noundef, i32 noundef) #1

declare i32 @pthread_mutexattr_gettype(ptr noundef, ptr noundef) #1

declare i32 @pthread_mutexattr_setprotocol(ptr noundef, i32 noundef) #1

declare i32 @pthread_mutexattr_getprotocol(ptr noundef, ptr noundef) #1

declare i32 @pthread_mutexattr_setpolicy_np(ptr noundef, i32 noundef) #1

declare i32 @pthread_mutexattr_getpolicy_np(ptr noundef, ptr noundef) #1

declare i32 @pthread_mutexattr_setprioceiling(ptr noundef, i32 noundef) #1

declare i32 @pthread_mutexattr_getprioceiling(ptr noundef, ptr noundef) #1

declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #1

declare i32 @_pthread_mutexattr_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_destroy(ptr noundef %0) #0 !dbg !290 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !293, !DIExpression(), !294)
    #dbg_declare(ptr %3, !295, !DIExpression(), !296)
  %4 = load ptr, ptr %2, align 8, !dbg !297
  %5 = call i32 @pthread_mutex_destroy(ptr noundef %4), !dbg !298
  store i32 %5, ptr %3, align 4, !dbg !296
  %6 = load i32, ptr %3, align 4, !dbg !299
  %7 = icmp eq i32 %6, 0, !dbg !299
  %8 = xor i1 %7, true, !dbg !299
  %9 = zext i1 %8 to i32, !dbg !299
  %10 = sext i32 %9 to i64, !dbg !299
  %11 = icmp ne i64 %10, 0, !dbg !299
  br i1 %11, label %12, label %14, !dbg !299

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_destroy, ptr noundef @.str, i32 noundef 80, ptr noundef @.str.1) #3, !dbg !299
  unreachable, !dbg !299

13:                                               ; No predecessors!
  br label %15, !dbg !299

14:                                               ; preds = %1
  br label %15, !dbg !299

15:                                               ; preds = %14, %13
  ret void, !dbg !300
}

declare i32 @pthread_mutex_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_lock(ptr noundef %0) #0 !dbg !301 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !302, !DIExpression(), !303)
    #dbg_declare(ptr %3, !304, !DIExpression(), !305)
  %4 = load ptr, ptr %2, align 8, !dbg !306
  %5 = call i32 @pthread_mutex_lock(ptr noundef %4), !dbg !307
  store i32 %5, ptr %3, align 4, !dbg !305
  %6 = load i32, ptr %3, align 4, !dbg !308
  %7 = icmp eq i32 %6, 0, !dbg !308
  %8 = xor i1 %7, true, !dbg !308
  %9 = zext i1 %8 to i32, !dbg !308
  %10 = sext i32 %9 to i64, !dbg !308
  %11 = icmp ne i64 %10, 0, !dbg !308
  br i1 %11, label %12, label %14, !dbg !308

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_lock, ptr noundef @.str, i32 noundef 86, ptr noundef @.str.1) #3, !dbg !308
  unreachable, !dbg !308

13:                                               ; No predecessors!
  br label %15, !dbg !308

14:                                               ; preds = %1
  br label %15, !dbg !308

15:                                               ; preds = %14, %13
  ret void, !dbg !309
}

declare i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @mutex_trylock(ptr noundef %0) #0 !dbg !310 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !314, !DIExpression(), !315)
    #dbg_declare(ptr %3, !316, !DIExpression(), !317)
  %4 = load ptr, ptr %2, align 8, !dbg !318
  %5 = call i32 @pthread_mutex_trylock(ptr noundef %4), !dbg !319
  store i32 %5, ptr %3, align 4, !dbg !317
  %6 = load i32, ptr %3, align 4, !dbg !320
  %7 = icmp eq i32 %6, 0, !dbg !321
  ret i1 %7, !dbg !322
}

declare i32 @pthread_mutex_trylock(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_unlock(ptr noundef %0) #0 !dbg !323 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !324, !DIExpression(), !325)
    #dbg_declare(ptr %3, !326, !DIExpression(), !327)
  %4 = load ptr, ptr %2, align 8, !dbg !328
  %5 = call i32 @pthread_mutex_unlock(ptr noundef %4), !dbg !329
  store i32 %5, ptr %3, align 4, !dbg !327
  %6 = load i32, ptr %3, align 4, !dbg !330
  %7 = icmp eq i32 %6, 0, !dbg !330
  %8 = xor i1 %7, true, !dbg !330
  %9 = zext i1 %8 to i32, !dbg !330
  %10 = sext i32 %9 to i64, !dbg !330
  %11 = icmp ne i64 %10, 0, !dbg !330
  br i1 %11, label %12, label %14, !dbg !330

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_unlock, ptr noundef @.str, i32 noundef 99, ptr noundef @.str.1) #3, !dbg !330
  unreachable, !dbg !330

13:                                               ; No predecessors!
  br label %15, !dbg !330

14:                                               ; preds = %1
  br label %15, !dbg !330

15:                                               ; preds = %14, %13
  ret void, !dbg !331
}

declare i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_test() #0 !dbg !332 {
  %1 = alloca %struct._opaque_pthread_mutex_t, align 8
  %2 = alloca %struct._opaque_pthread_mutex_t, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  %5 = alloca i8, align 1
    #dbg_declare(ptr %1, !335, !DIExpression(), !336)
    #dbg_declare(ptr %2, !337, !DIExpression(), !338)
  call void @mutex_init(ptr noundef %1, i32 noundef 1, i32 noundef 1, i32 noundef 1, i32 noundef 1), !dbg !339
  call void @mutex_init(ptr noundef %2, i32 noundef 2, i32 noundef 2, i32 noundef 3, i32 noundef 2), !dbg !340
  call void @mutex_lock(ptr noundef %1), !dbg !341
    #dbg_declare(ptr %3, !343, !DIExpression(), !344)
  %6 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !345
  %7 = zext i1 %6 to i8, !dbg !344
  store i8 %7, ptr %3, align 1, !dbg !344
  %8 = load i8, ptr %3, align 1, !dbg !346
  %9 = trunc i8 %8 to i1, !dbg !346
  %10 = xor i1 %9, true, !dbg !346
  %11 = xor i1 %10, true, !dbg !346
  %12 = zext i1 %11 to i32, !dbg !346
  %13 = sext i32 %12 to i64, !dbg !346
  %14 = icmp ne i64 %13, 0, !dbg !346
  br i1 %14, label %15, label %17, !dbg !346

15:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 113, ptr noundef @.str.2) #3, !dbg !346
  unreachable, !dbg !346

16:                                               ; No predecessors!
  br label %18, !dbg !346

17:                                               ; preds = %0
  br label %18, !dbg !346

18:                                               ; preds = %17, %16
  call void @mutex_unlock(ptr noundef %1), !dbg !347
  call void @mutex_lock(ptr noundef %2), !dbg !348
    #dbg_declare(ptr %4, !350, !DIExpression(), !352)
  %19 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !353
  %20 = zext i1 %19 to i8, !dbg !352
  store i8 %20, ptr %4, align 1, !dbg !352
  %21 = load i8, ptr %4, align 1, !dbg !354
  %22 = trunc i8 %21 to i1, !dbg !354
  %23 = xor i1 %22, true, !dbg !354
  %24 = zext i1 %23 to i32, !dbg !354
  %25 = sext i32 %24 to i64, !dbg !354
  %26 = icmp ne i64 %25, 0, !dbg !354
  br i1 %26, label %27, label %29, !dbg !354

27:                                               ; preds = %18
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 122, ptr noundef @.str.3) #3, !dbg !354
  unreachable, !dbg !354

28:                                               ; No predecessors!
  br label %30, !dbg !354

29:                                               ; preds = %18
  br label %30, !dbg !354

30:                                               ; preds = %29, %28
  call void @mutex_unlock(ptr noundef %1), !dbg !355
    #dbg_declare(ptr %5, !356, !DIExpression(), !358)
  %31 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !359
  %32 = zext i1 %31 to i8, !dbg !358
  store i8 %32, ptr %5, align 1, !dbg !358
  %33 = load i8, ptr %5, align 1, !dbg !360
  %34 = trunc i8 %33 to i1, !dbg !360
  %35 = xor i1 %34, true, !dbg !360
  %36 = zext i1 %35 to i32, !dbg !360
  %37 = sext i32 %36 to i64, !dbg !360
  %38 = icmp ne i64 %37, 0, !dbg !360
  br i1 %38, label %39, label %41, !dbg !360

39:                                               ; preds = %30
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 128, ptr noundef @.str.3) #3, !dbg !360
  unreachable, !dbg !360

40:                                               ; No predecessors!
  br label %42, !dbg !360

41:                                               ; preds = %30
  br label %42, !dbg !360

42:                                               ; preds = %41, %40
  call void @mutex_unlock(ptr noundef %1), !dbg !361
  call void @mutex_unlock(ptr noundef %2), !dbg !362
  call void @mutex_destroy(ptr noundef %2), !dbg !363
  call void @mutex_destroy(ptr noundef %1), !dbg !364
  ret void, !dbg !365
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_init(ptr noundef %0) #0 !dbg !366 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca %struct._opaque_pthread_condattr_t, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !370, !DIExpression(), !371)
    #dbg_declare(ptr %3, !372, !DIExpression(), !373)
    #dbg_declare(ptr %4, !374, !DIExpression(), !382)
  %5 = call i32 @pthread_condattr_init(ptr noundef %4), !dbg !383
  store i32 %5, ptr %3, align 4, !dbg !384
  %6 = load i32, ptr %3, align 4, !dbg !385
  %7 = icmp eq i32 %6, 0, !dbg !385
  %8 = xor i1 %7, true, !dbg !385
  %9 = zext i1 %8 to i32, !dbg !385
  %10 = sext i32 %9 to i64, !dbg !385
  %11 = icmp ne i64 %10, 0, !dbg !385
  br i1 %11, label %12, label %14, !dbg !385

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 154, ptr noundef @.str.1) #3, !dbg !385
  unreachable, !dbg !385

13:                                               ; No predecessors!
  br label %15, !dbg !385

14:                                               ; preds = %1
  br label %15, !dbg !385

15:                                               ; preds = %14, %13
  %16 = load ptr, ptr %2, align 8, !dbg !386
  %17 = call i32 @_pthread_cond_init(ptr noundef %16, ptr noundef %4), !dbg !387
  store i32 %17, ptr %3, align 4, !dbg !388
  %18 = load i32, ptr %3, align 4, !dbg !389
  %19 = icmp eq i32 %18, 0, !dbg !389
  %20 = xor i1 %19, true, !dbg !389
  %21 = zext i1 %20 to i32, !dbg !389
  %22 = sext i32 %21 to i64, !dbg !389
  %23 = icmp ne i64 %22, 0, !dbg !389
  br i1 %23, label %24, label %26, !dbg !389

24:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 157, ptr noundef @.str.1) #3, !dbg !389
  unreachable, !dbg !389

25:                                               ; No predecessors!
  br label %27, !dbg !389

26:                                               ; preds = %15
  br label %27, !dbg !389

27:                                               ; preds = %26, %25
  %28 = call i32 @pthread_condattr_destroy(ptr noundef %4), !dbg !390
  store i32 %28, ptr %3, align 4, !dbg !391
  %29 = load i32, ptr %3, align 4, !dbg !392
  %30 = icmp eq i32 %29, 0, !dbg !392
  %31 = xor i1 %30, true, !dbg !392
  %32 = zext i1 %31 to i32, !dbg !392
  %33 = sext i32 %32 to i64, !dbg !392
  %34 = icmp ne i64 %33, 0, !dbg !392
  br i1 %34, label %35, label %37, !dbg !392

35:                                               ; preds = %27
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 160, ptr noundef @.str.1) #3, !dbg !392
  unreachable, !dbg !392

36:                                               ; No predecessors!
  br label %38, !dbg !392

37:                                               ; preds = %27
  br label %38, !dbg !392

38:                                               ; preds = %37, %36
  ret void, !dbg !393
}

declare i32 @pthread_condattr_init(ptr noundef) #1

declare i32 @_pthread_cond_init(ptr noundef, ptr noundef) #1

declare i32 @pthread_condattr_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_destroy(ptr noundef %0) #0 !dbg !394 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !395, !DIExpression(), !396)
    #dbg_declare(ptr %3, !397, !DIExpression(), !398)
  %4 = load ptr, ptr %2, align 8, !dbg !399
  %5 = call i32 @pthread_cond_destroy(ptr noundef %4), !dbg !400
  store i32 %5, ptr %3, align 4, !dbg !398
  %6 = load i32, ptr %3, align 4, !dbg !401
  %7 = icmp eq i32 %6, 0, !dbg !401
  %8 = xor i1 %7, true, !dbg !401
  %9 = zext i1 %8 to i32, !dbg !401
  %10 = sext i32 %9 to i64, !dbg !401
  %11 = icmp ne i64 %10, 0, !dbg !401
  br i1 %11, label %12, label %14, !dbg !401

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_destroy, ptr noundef @.str, i32 noundef 166, ptr noundef @.str.1) #3, !dbg !401
  unreachable, !dbg !401

13:                                               ; No predecessors!
  br label %15, !dbg !401

14:                                               ; preds = %1
  br label %15, !dbg !401

15:                                               ; preds = %14, %13
  ret void, !dbg !402
}

declare i32 @pthread_cond_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_signal(ptr noundef %0) #0 !dbg !403 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !404, !DIExpression(), !405)
    #dbg_declare(ptr %3, !406, !DIExpression(), !407)
  %4 = load ptr, ptr %2, align 8, !dbg !408
  %5 = call i32 @pthread_cond_signal(ptr noundef %4), !dbg !409
  store i32 %5, ptr %3, align 4, !dbg !407
  %6 = load i32, ptr %3, align 4, !dbg !410
  %7 = icmp eq i32 %6, 0, !dbg !410
  %8 = xor i1 %7, true, !dbg !410
  %9 = zext i1 %8 to i32, !dbg !410
  %10 = sext i32 %9 to i64, !dbg !410
  %11 = icmp ne i64 %10, 0, !dbg !410
  br i1 %11, label %12, label %14, !dbg !410

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_signal, ptr noundef @.str, i32 noundef 172, ptr noundef @.str.1) #3, !dbg !410
  unreachable, !dbg !410

13:                                               ; No predecessors!
  br label %15, !dbg !410

14:                                               ; preds = %1
  br label %15, !dbg !410

15:                                               ; preds = %14, %13
  ret void, !dbg !411
}

declare i32 @pthread_cond_signal(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_broadcast(ptr noundef %0) #0 !dbg !412 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !413, !DIExpression(), !414)
    #dbg_declare(ptr %3, !415, !DIExpression(), !416)
  %4 = load ptr, ptr %2, align 8, !dbg !417
  %5 = call i32 @pthread_cond_broadcast(ptr noundef %4), !dbg !418
  store i32 %5, ptr %3, align 4, !dbg !416
  %6 = load i32, ptr %3, align 4, !dbg !419
  %7 = icmp eq i32 %6, 0, !dbg !419
  %8 = xor i1 %7, true, !dbg !419
  %9 = zext i1 %8 to i32, !dbg !419
  %10 = sext i32 %9 to i64, !dbg !419
  %11 = icmp ne i64 %10, 0, !dbg !419
  br i1 %11, label %12, label %14, !dbg !419

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_broadcast, ptr noundef @.str, i32 noundef 178, ptr noundef @.str.1) #3, !dbg !419
  unreachable, !dbg !419

13:                                               ; No predecessors!
  br label %15, !dbg !419

14:                                               ; preds = %1
  br label %15, !dbg !419

15:                                               ; preds = %14, %13
  ret void, !dbg !420
}

declare i32 @pthread_cond_broadcast(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_wait(ptr noundef %0, ptr noundef %1) #0 !dbg !421 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !424, !DIExpression(), !425)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !426, !DIExpression(), !427)
    #dbg_declare(ptr %5, !428, !DIExpression(), !429)
  %6 = load ptr, ptr %3, align 8, !dbg !430
  %7 = load ptr, ptr %4, align 8, !dbg !431
  %8 = call i32 @_pthread_cond_wait(ptr noundef %6, ptr noundef %7), !dbg !432
  store i32 %8, ptr %5, align 4, !dbg !429
  ret void, !dbg !433
}

declare i32 @_pthread_cond_wait(ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_timedwait(ptr noundef %0, ptr noundef %1, i64 noundef %2) #0 !dbg !434 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i64, align 8
  %7 = alloca %struct.timespec, align 8
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !438, !DIExpression(), !439)
  store ptr %1, ptr %5, align 8
    #dbg_declare(ptr %5, !440, !DIExpression(), !441)
  store i64 %2, ptr %6, align 8
    #dbg_declare(ptr %6, !442, !DIExpression(), !443)
    #dbg_declare(ptr %7, !444, !DIExpression(), !452)
  %9 = load i64, ptr %6, align 8, !dbg !453
    #dbg_declare(ptr %8, !454, !DIExpression(), !455)
  %10 = load ptr, ptr %4, align 8, !dbg !456
  %11 = load ptr, ptr %5, align 8, !dbg !457
  %12 = call i32 @_pthread_cond_timedwait(ptr noundef %10, ptr noundef %11, ptr noundef %7), !dbg !458
  store i32 %12, ptr %8, align 4, !dbg !455
  ret void, !dbg !459
}

declare i32 @_pthread_cond_timedwait(ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @cond_worker(ptr noundef %0) #0 !dbg !460 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i8, align 1
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !461, !DIExpression(), !462)
    #dbg_declare(ptr %4, !463, !DIExpression(), !464)
  store i8 1, ptr %4, align 1, !dbg !464
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !465
  %5 = load i32, ptr @phase, align 4, !dbg !467
  %6 = add nsw i32 %5, 1, !dbg !467
  store i32 %6, ptr @phase, align 4, !dbg !467
  call void @cond_wait(ptr noundef @cond, ptr noundef @cond_mutex), !dbg !468
  %7 = load i32, ptr @phase, align 4, !dbg !469
  %8 = add nsw i32 %7, 1, !dbg !469
  store i32 %8, ptr @phase, align 4, !dbg !469
  %9 = load i32, ptr @phase, align 4, !dbg !470
  %10 = icmp slt i32 %9, 2, !dbg !471
  %11 = zext i1 %10 to i8, !dbg !472
  store i8 %11, ptr %4, align 1, !dbg !472
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !473
  %12 = load i8, ptr %4, align 1, !dbg !474
  %13 = trunc i8 %12 to i1, !dbg !474
  br i1 %13, label %14, label %17, !dbg !476

14:                                               ; preds = %1
  %15 = load ptr, ptr %3, align 8, !dbg !477
  %16 = getelementptr inbounds i8, ptr %15, i64 1, !dbg !478
  store ptr %16, ptr %2, align 8, !dbg !479
  br label %32, !dbg !479

17:                                               ; preds = %1
  store i8 1, ptr %4, align 1, !dbg !480
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !481
  %18 = load i32, ptr @phase, align 4, !dbg !483
  %19 = add nsw i32 %18, 1, !dbg !483
  store i32 %19, ptr @phase, align 4, !dbg !483
  call void @cond_timedwait(ptr noundef @cond, ptr noundef @cond_mutex, i64 noundef 10), !dbg !484
  %20 = load i32, ptr @phase, align 4, !dbg !485
  %21 = add nsw i32 %20, 1, !dbg !485
  store i32 %21, ptr @phase, align 4, !dbg !485
  %22 = load i32, ptr @phase, align 4, !dbg !486
  %23 = icmp sgt i32 %22, 6, !dbg !487
  %24 = zext i1 %23 to i8, !dbg !488
  store i8 %24, ptr %4, align 1, !dbg !488
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !489
  %25 = load i8, ptr %4, align 1, !dbg !490
  %26 = trunc i8 %25 to i1, !dbg !490
  br i1 %26, label %27, label %30, !dbg !492

27:                                               ; preds = %17
  %28 = load ptr, ptr %3, align 8, !dbg !493
  %29 = getelementptr inbounds i8, ptr %28, i64 2, !dbg !494
  store ptr %29, ptr %2, align 8, !dbg !495
  br label %32, !dbg !495

30:                                               ; preds = %17
  %31 = load ptr, ptr %3, align 8, !dbg !496
  store ptr %31, ptr %2, align 8, !dbg !497
  br label %32, !dbg !497

32:                                               ; preds = %30, %27, %14
  %33 = load ptr, ptr %2, align 8, !dbg !498
  ret ptr %33, !dbg !498
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_test() #0 !dbg !499 {
  %1 = alloca ptr, align 8
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
    #dbg_declare(ptr %1, !500, !DIExpression(), !501)
  store ptr inttoptr (i64 42 to ptr), ptr %1, align 8, !dbg !501
  call void @mutex_init(ptr noundef @cond_mutex, i32 noundef 0, i32 noundef 0, i32 noundef 3, i32 noundef 0), !dbg !502
  call void @cond_init(ptr noundef @cond), !dbg !503
    #dbg_declare(ptr %2, !504, !DIExpression(), !505)
  %4 = load ptr, ptr %1, align 8, !dbg !506
  %5 = call ptr @thread_create(ptr noundef @cond_worker, ptr noundef %4), !dbg !507
  store ptr %5, ptr %2, align 8, !dbg !505
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !508
  %6 = load i32, ptr @phase, align 4, !dbg !510
  %7 = add nsw i32 %6, 1, !dbg !510
  store i32 %7, ptr @phase, align 4, !dbg !510
  call void @cond_signal(ptr noundef @cond), !dbg !511
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !512
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !513
  %8 = load i32, ptr @phase, align 4, !dbg !515
  %9 = add nsw i32 %8, 1, !dbg !515
  store i32 %9, ptr @phase, align 4, !dbg !515
  call void @cond_broadcast(ptr noundef @cond), !dbg !516
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !517
    #dbg_declare(ptr %3, !518, !DIExpression(), !519)
  %10 = load ptr, ptr %2, align 8, !dbg !520
  %11 = call ptr @thread_join(ptr noundef %10), !dbg !521
  store ptr %11, ptr %3, align 8, !dbg !519
  %12 = load ptr, ptr %3, align 8, !dbg !522
  %13 = load ptr, ptr %1, align 8, !dbg !522
  %14 = icmp eq ptr %12, %13, !dbg !522
  %15 = xor i1 %14, true, !dbg !522
  %16 = zext i1 %15 to i32, !dbg !522
  %17 = sext i32 %16 to i64, !dbg !522
  %18 = icmp ne i64 %17, 0, !dbg !522
  br i1 %18, label %19, label %21, !dbg !522

19:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.cond_test, ptr noundef @.str, i32 noundef 252, ptr noundef @.str.4) #3, !dbg !522
  unreachable, !dbg !522

20:                                               ; No predecessors!
  br label %22, !dbg !522

21:                                               ; preds = %0
  br label %22, !dbg !522

22:                                               ; preds = %21, %20
  call void @cond_destroy(ptr noundef @cond), !dbg !523
  call void @mutex_destroy(ptr noundef @cond_mutex), !dbg !524
  ret void, !dbg !525
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_init(ptr noundef %0, i32 noundef %1) #0 !dbg !526 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca %struct._opaque_pthread_rwlockattr_t, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !540, !DIExpression(), !541)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !542, !DIExpression(), !543)
    #dbg_declare(ptr %5, !544, !DIExpression(), !545)
    #dbg_declare(ptr %6, !546, !DIExpression(), !547)
    #dbg_declare(ptr %7, !548, !DIExpression(), !559)
  %8 = call i32 @pthread_rwlockattr_init(ptr noundef %7), !dbg !560
  store i32 %8, ptr %5, align 4, !dbg !561
  %9 = load i32, ptr %5, align 4, !dbg !562
  %10 = icmp eq i32 %9, 0, !dbg !562
  %11 = xor i1 %10, true, !dbg !562
  %12 = zext i1 %11 to i32, !dbg !562
  %13 = sext i32 %12 to i64, !dbg !562
  %14 = icmp ne i64 %13, 0, !dbg !562
  br i1 %14, label %15, label %17, !dbg !562

15:                                               ; preds = %2
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 269, ptr noundef @.str.1) #3, !dbg !562
  unreachable, !dbg !562

16:                                               ; No predecessors!
  br label %18, !dbg !562

17:                                               ; preds = %2
  br label %18, !dbg !562

18:                                               ; preds = %17, %16
  %19 = load i32, ptr %4, align 4, !dbg !563
  %20 = call i32 @pthread_rwlockattr_setpshared(ptr noundef %7, i32 noundef %19), !dbg !564
  store i32 %20, ptr %5, align 4, !dbg !565
  %21 = load i32, ptr %5, align 4, !dbg !566
  %22 = icmp eq i32 %21, 0, !dbg !566
  %23 = xor i1 %22, true, !dbg !566
  %24 = zext i1 %23 to i32, !dbg !566
  %25 = sext i32 %24 to i64, !dbg !566
  %26 = icmp ne i64 %25, 0, !dbg !566
  br i1 %26, label %27, label %29, !dbg !566

27:                                               ; preds = %18
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 272, ptr noundef @.str.1) #3, !dbg !566
  unreachable, !dbg !566

28:                                               ; No predecessors!
  br label %30, !dbg !566

29:                                               ; preds = %18
  br label %30, !dbg !566

30:                                               ; preds = %29, %28
  %31 = call i32 @pthread_rwlockattr_getpshared(ptr noundef %7, ptr noundef %6), !dbg !567
  store i32 %31, ptr %5, align 4, !dbg !568
  %32 = load i32, ptr %5, align 4, !dbg !569
  %33 = icmp eq i32 %32, 0, !dbg !569
  %34 = xor i1 %33, true, !dbg !569
  %35 = zext i1 %34 to i32, !dbg !569
  %36 = sext i32 %35 to i64, !dbg !569
  %37 = icmp ne i64 %36, 0, !dbg !569
  br i1 %37, label %38, label %40, !dbg !569

38:                                               ; preds = %30
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 274, ptr noundef @.str.1) #3, !dbg !569
  unreachable, !dbg !569

39:                                               ; No predecessors!
  br label %41, !dbg !569

40:                                               ; preds = %30
  br label %41, !dbg !569

41:                                               ; preds = %40, %39
  %42 = load ptr, ptr %3, align 8, !dbg !570
  %43 = call i32 @_pthread_rwlock_init(ptr noundef %42, ptr noundef %7), !dbg !571
  store i32 %43, ptr %5, align 4, !dbg !572
  %44 = load i32, ptr %5, align 4, !dbg !573
  %45 = icmp eq i32 %44, 0, !dbg !573
  %46 = xor i1 %45, true, !dbg !573
  %47 = zext i1 %46 to i32, !dbg !573
  %48 = sext i32 %47 to i64, !dbg !573
  %49 = icmp ne i64 %48, 0, !dbg !573
  br i1 %49, label %50, label %52, !dbg !573

50:                                               ; preds = %41
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 277, ptr noundef @.str.1) #3, !dbg !573
  unreachable, !dbg !573

51:                                               ; No predecessors!
  br label %53, !dbg !573

52:                                               ; preds = %41
  br label %53, !dbg !573

53:                                               ; preds = %52, %51
  %54 = call i32 @pthread_rwlockattr_destroy(ptr noundef %7), !dbg !574
  store i32 %54, ptr %5, align 4, !dbg !575
  %55 = load i32, ptr %5, align 4, !dbg !576
  %56 = icmp eq i32 %55, 0, !dbg !576
  %57 = xor i1 %56, true, !dbg !576
  %58 = zext i1 %57 to i32, !dbg !576
  %59 = sext i32 %58 to i64, !dbg !576
  %60 = icmp ne i64 %59, 0, !dbg !576
  br i1 %60, label %61, label %63, !dbg !576

61:                                               ; preds = %53
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 279, ptr noundef @.str.1) #3, !dbg !576
  unreachable, !dbg !576

62:                                               ; No predecessors!
  br label %64, !dbg !576

63:                                               ; preds = %53
  br label %64, !dbg !576

64:                                               ; preds = %63, %62
  ret void, !dbg !577
}

declare i32 @pthread_rwlockattr_init(ptr noundef) #1

declare i32 @pthread_rwlockattr_setpshared(ptr noundef, i32 noundef) #1

declare i32 @pthread_rwlockattr_getpshared(ptr noundef, ptr noundef) #1

declare i32 @_pthread_rwlock_init(ptr noundef, ptr noundef) #1

declare i32 @pthread_rwlockattr_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_destroy(ptr noundef %0) #0 !dbg !578 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !581, !DIExpression(), !582)
    #dbg_declare(ptr %3, !583, !DIExpression(), !584)
  %4 = load ptr, ptr %2, align 8, !dbg !585
  %5 = call i32 @_pthread_rwlock_destroy(ptr noundef %4), !dbg !586
  store i32 %5, ptr %3, align 4, !dbg !584
  %6 = load i32, ptr %3, align 4, !dbg !587
  %7 = icmp eq i32 %6, 0, !dbg !587
  %8 = xor i1 %7, true, !dbg !587
  %9 = zext i1 %8 to i32, !dbg !587
  %10 = sext i32 %9 to i64, !dbg !587
  %11 = icmp ne i64 %10, 0, !dbg !587
  br i1 %11, label %12, label %14, !dbg !587

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_destroy, ptr noundef @.str, i32 noundef 285, ptr noundef @.str.1) #3, !dbg !587
  unreachable, !dbg !587

13:                                               ; No predecessors!
  br label %15, !dbg !587

14:                                               ; preds = %1
  br label %15, !dbg !587

15:                                               ; preds = %14, %13
  ret void, !dbg !588
}

declare i32 @_pthread_rwlock_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_wrlock(ptr noundef %0) #0 !dbg !589 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !590, !DIExpression(), !591)
    #dbg_declare(ptr %3, !592, !DIExpression(), !593)
  %4 = load ptr, ptr %2, align 8, !dbg !594
  %5 = call i32 @_pthread_rwlock_wrlock(ptr noundef %4), !dbg !595
  store i32 %5, ptr %3, align 4, !dbg !593
  %6 = load i32, ptr %3, align 4, !dbg !596
  %7 = icmp eq i32 %6, 0, !dbg !596
  %8 = xor i1 %7, true, !dbg !596
  %9 = zext i1 %8 to i32, !dbg !596
  %10 = sext i32 %9 to i64, !dbg !596
  %11 = icmp ne i64 %10, 0, !dbg !596
  br i1 %11, label %12, label %14, !dbg !596

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_wrlock, ptr noundef @.str, i32 noundef 291, ptr noundef @.str.1) #3, !dbg !596
  unreachable, !dbg !596

13:                                               ; No predecessors!
  br label %15, !dbg !596

14:                                               ; preds = %1
  br label %15, !dbg !596

15:                                               ; preds = %14, %13
  ret void, !dbg !597
}

declare i32 @_pthread_rwlock_wrlock(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @rwlock_trywrlock(ptr noundef %0) #0 !dbg !598 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !601, !DIExpression(), !602)
    #dbg_declare(ptr %3, !603, !DIExpression(), !604)
  %4 = load ptr, ptr %2, align 8, !dbg !605
  %5 = call i32 @_pthread_rwlock_trywrlock(ptr noundef %4), !dbg !606
  store i32 %5, ptr %3, align 4, !dbg !604
  %6 = load i32, ptr %3, align 4, !dbg !607
  %7 = icmp eq i32 %6, 0, !dbg !608
  ret i1 %7, !dbg !609
}

declare i32 @_pthread_rwlock_trywrlock(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_rdlock(ptr noundef %0) #0 !dbg !610 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !611, !DIExpression(), !612)
    #dbg_declare(ptr %3, !613, !DIExpression(), !614)
  %4 = load ptr, ptr %2, align 8, !dbg !615
  %5 = call i32 @_pthread_rwlock_rdlock(ptr noundef %4), !dbg !616
  store i32 %5, ptr %3, align 4, !dbg !614
  %6 = load i32, ptr %3, align 4, !dbg !617
  %7 = icmp eq i32 %6, 0, !dbg !617
  %8 = xor i1 %7, true, !dbg !617
  %9 = zext i1 %8 to i32, !dbg !617
  %10 = sext i32 %9 to i64, !dbg !617
  %11 = icmp ne i64 %10, 0, !dbg !617
  br i1 %11, label %12, label %14, !dbg !617

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_rdlock, ptr noundef @.str, i32 noundef 304, ptr noundef @.str.1) #3, !dbg !617
  unreachable, !dbg !617

13:                                               ; No predecessors!
  br label %15, !dbg !617

14:                                               ; preds = %1
  br label %15, !dbg !617

15:                                               ; preds = %14, %13
  ret void, !dbg !618
}

declare i32 @_pthread_rwlock_rdlock(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @rwlock_tryrdlock(ptr noundef %0) #0 !dbg !619 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !620, !DIExpression(), !621)
    #dbg_declare(ptr %3, !622, !DIExpression(), !623)
  %4 = load ptr, ptr %2, align 8, !dbg !624
  %5 = call i32 @_pthread_rwlock_tryrdlock(ptr noundef %4), !dbg !625
  store i32 %5, ptr %3, align 4, !dbg !623
  %6 = load i32, ptr %3, align 4, !dbg !626
  %7 = icmp eq i32 %6, 0, !dbg !627
  ret i1 %7, !dbg !628
}

declare i32 @_pthread_rwlock_tryrdlock(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_unlock(ptr noundef %0) #0 !dbg !629 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !630, !DIExpression(), !631)
    #dbg_declare(ptr %3, !632, !DIExpression(), !633)
  %4 = load ptr, ptr %2, align 8, !dbg !634
  %5 = call i32 @_pthread_rwlock_unlock(ptr noundef %4), !dbg !635
  store i32 %5, ptr %3, align 4, !dbg !633
  %6 = load i32, ptr %3, align 4, !dbg !636
  %7 = icmp eq i32 %6, 0, !dbg !636
  %8 = xor i1 %7, true, !dbg !636
  %9 = zext i1 %8 to i32, !dbg !636
  %10 = sext i32 %9 to i64, !dbg !636
  %11 = icmp ne i64 %10, 0, !dbg !636
  br i1 %11, label %12, label %14, !dbg !636

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_unlock, ptr noundef @.str, i32 noundef 317, ptr noundef @.str.1) #3, !dbg !636
  unreachable, !dbg !636

13:                                               ; No predecessors!
  br label %15, !dbg !636

14:                                               ; preds = %1
  br label %15, !dbg !636

15:                                               ; preds = %14, %13
  ret void, !dbg !637
}

declare i32 @_pthread_rwlock_unlock(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_test() #0 !dbg !638 {
  %1 = alloca %struct._opaque_pthread_rwlock_t, align 8
  %2 = alloca i32, align 4
  %3 = alloca i8, align 1
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  %6 = alloca i8, align 1
  %7 = alloca i32, align 4
  %8 = alloca i8, align 1
    #dbg_declare(ptr %1, !639, !DIExpression(), !640)
  call void @rwlock_init(ptr noundef %1, i32 noundef 2), !dbg !641
    #dbg_declare(ptr %2, !642, !DIExpression(), !644)
  store i32 4, ptr %2, align 4, !dbg !644
  call void @rwlock_wrlock(ptr noundef %1), !dbg !645
    #dbg_declare(ptr %3, !647, !DIExpression(), !648)
  %9 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !649
  %10 = zext i1 %9 to i8, !dbg !648
  store i8 %10, ptr %3, align 1, !dbg !648
  %11 = load i8, ptr %3, align 1, !dbg !650
  %12 = trunc i8 %11 to i1, !dbg !650
  %13 = xor i1 %12, true, !dbg !650
  %14 = xor i1 %13, true, !dbg !650
  %15 = zext i1 %14 to i32, !dbg !650
  %16 = sext i32 %15 to i64, !dbg !650
  %17 = icmp ne i64 %16, 0, !dbg !650
  br i1 %17, label %18, label %20, !dbg !650

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 329, ptr noundef @.str.2) #3, !dbg !650
  unreachable, !dbg !650

19:                                               ; No predecessors!
  br label %21, !dbg !650

20:                                               ; preds = %0
  br label %21, !dbg !650

21:                                               ; preds = %20, %19
  %22 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %1), !dbg !651
  %23 = zext i1 %22 to i8, !dbg !652
  store i8 %23, ptr %3, align 1, !dbg !652
  %24 = load i8, ptr %3, align 1, !dbg !653
  %25 = trunc i8 %24 to i1, !dbg !653
  %26 = xor i1 %25, true, !dbg !653
  %27 = xor i1 %26, true, !dbg !653
  %28 = zext i1 %27 to i32, !dbg !653
  %29 = sext i32 %28 to i64, !dbg !653
  %30 = icmp ne i64 %29, 0, !dbg !653
  br i1 %30, label %31, label %33, !dbg !653

31:                                               ; preds = %21
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 331, ptr noundef @.str.2) #3, !dbg !653
  unreachable, !dbg !653

32:                                               ; No predecessors!
  br label %34, !dbg !653

33:                                               ; preds = %21
  br label %34, !dbg !653

34:                                               ; preds = %33, %32
  call void @rwlock_unlock(ptr noundef %1), !dbg !654
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !655
    #dbg_declare(ptr %4, !657, !DIExpression(), !659)
  store i32 0, ptr %4, align 4, !dbg !659
  br label %35, !dbg !660

35:                                               ; preds = %51, %34
  %36 = load i32, ptr %4, align 4, !dbg !661
  %37 = icmp slt i32 %36, 4, !dbg !663
  br i1 %37, label %38, label %54, !dbg !664

38:                                               ; preds = %35
    #dbg_declare(ptr %5, !665, !DIExpression(), !667)
  %39 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %1), !dbg !668
  %40 = zext i1 %39 to i8, !dbg !667
  store i8 %40, ptr %5, align 1, !dbg !667
  %41 = load i8, ptr %5, align 1, !dbg !669
  %42 = trunc i8 %41 to i1, !dbg !669
  %43 = xor i1 %42, true, !dbg !669
  %44 = zext i1 %43 to i32, !dbg !669
  %45 = sext i32 %44 to i64, !dbg !669
  %46 = icmp ne i64 %45, 0, !dbg !669
  br i1 %46, label %47, label %49, !dbg !669

47:                                               ; preds = %38
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 340, ptr noundef @.str.3) #3, !dbg !669
  unreachable, !dbg !669

48:                                               ; No predecessors!
  br label %50, !dbg !669

49:                                               ; preds = %38
  br label %50, !dbg !669

50:                                               ; preds = %49, %48
  br label %51, !dbg !670

51:                                               ; preds = %50
  %52 = load i32, ptr %4, align 4, !dbg !671
  %53 = add nsw i32 %52, 1, !dbg !671
  store i32 %53, ptr %4, align 4, !dbg !671
  br label %35, !dbg !672, !llvm.loop !673

54:                                               ; preds = %35
    #dbg_declare(ptr %6, !676, !DIExpression(), !678)
  %55 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !679
  %56 = zext i1 %55 to i8, !dbg !678
  store i8 %56, ptr %6, align 1, !dbg !678
  %57 = load i8, ptr %6, align 1, !dbg !680
  %58 = trunc i8 %57 to i1, !dbg !680
  %59 = xor i1 %58, true, !dbg !680
  %60 = xor i1 %59, true, !dbg !680
  %61 = zext i1 %60 to i32, !dbg !680
  %62 = sext i32 %61 to i64, !dbg !680
  %63 = icmp ne i64 %62, 0, !dbg !680
  br i1 %63, label %64, label %66, !dbg !680

64:                                               ; preds = %54
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 345, ptr noundef @.str.2) #3, !dbg !680
  unreachable, !dbg !680

65:                                               ; No predecessors!
  br label %67, !dbg !680

66:                                               ; preds = %54
  br label %67, !dbg !680

67:                                               ; preds = %66, %65
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !681
    #dbg_declare(ptr %7, !682, !DIExpression(), !684)
  store i32 0, ptr %7, align 4, !dbg !684
  br label %68, !dbg !685

68:                                               ; preds = %72, %67
  %69 = load i32, ptr %7, align 4, !dbg !686
  %70 = icmp slt i32 %69, 4, !dbg !688
  br i1 %70, label %71, label %75, !dbg !689

71:                                               ; preds = %68
  call void @rwlock_unlock(ptr noundef %1), !dbg !690
  br label %72, !dbg !692

72:                                               ; preds = %71
  %73 = load i32, ptr %7, align 4, !dbg !693
  %74 = add nsw i32 %73, 1, !dbg !693
  store i32 %74, ptr %7, align 4, !dbg !693
  br label %68, !dbg !694, !llvm.loop !695

75:                                               ; preds = %68
  call void @rwlock_wrlock(ptr noundef %1), !dbg !697
    #dbg_declare(ptr %8, !699, !DIExpression(), !700)
  %76 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !701
  %77 = zext i1 %76 to i8, !dbg !700
  store i8 %77, ptr %8, align 1, !dbg !700
  %78 = load i8, ptr %8, align 1, !dbg !702
  %79 = trunc i8 %78 to i1, !dbg !702
  %80 = xor i1 %79, true, !dbg !702
  %81 = xor i1 %80, true, !dbg !702
  %82 = zext i1 %81 to i32, !dbg !702
  %83 = sext i32 %82 to i64, !dbg !702
  %84 = icmp ne i64 %83, 0, !dbg !702
  br i1 %84, label %85, label %87, !dbg !702

85:                                               ; preds = %75
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 357, ptr noundef @.str.2) #3, !dbg !702
  unreachable, !dbg !702

86:                                               ; No predecessors!
  br label %88, !dbg !702

87:                                               ; preds = %75
  br label %88, !dbg !702

88:                                               ; preds = %87, %86
  call void @rwlock_unlock(ptr noundef %1), !dbg !703
  call void @rwlock_destroy(ptr noundef %1), !dbg !704
  ret void, !dbg !705
}

declare void @__VERIFIER_loop_bound(i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @key_destroy(ptr noundef %0) #0 !dbg !706 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !707, !DIExpression(), !708)
  %3 = call ptr @pthread_self(), !dbg !709
  store ptr %3, ptr @latest_thread, align 8, !dbg !710
  ret void, !dbg !711
}

declare ptr @pthread_self() #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @key_worker(ptr noundef %0) #0 !dbg !712 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !713, !DIExpression(), !714)
    #dbg_declare(ptr %3, !715, !DIExpression(), !716)
  store i32 1, ptr %3, align 4, !dbg !716
    #dbg_declare(ptr %4, !717, !DIExpression(), !718)
  %6 = load i64, ptr @local_data, align 8, !dbg !719
  %7 = call i32 @pthread_setspecific(i64 noundef %6, ptr noundef %3), !dbg !720
  store i32 %7, ptr %4, align 4, !dbg !718
  %8 = load i32, ptr %4, align 4, !dbg !721
  %9 = icmp eq i32 %8, 0, !dbg !721
  %10 = xor i1 %9, true, !dbg !721
  %11 = zext i1 %10 to i32, !dbg !721
  %12 = sext i32 %11 to i64, !dbg !721
  %13 = icmp ne i64 %12, 0, !dbg !721
  br i1 %13, label %14, label %16, !dbg !721

14:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.key_worker, ptr noundef @.str, i32 noundef 379, ptr noundef @.str.1) #3, !dbg !721
  unreachable, !dbg !721

15:                                               ; No predecessors!
  br label %17, !dbg !721

16:                                               ; preds = %1
  br label %17, !dbg !721

17:                                               ; preds = %16, %15
    #dbg_declare(ptr %5, !722, !DIExpression(), !723)
  %18 = load i64, ptr @local_data, align 8, !dbg !724
  %19 = call ptr @pthread_getspecific(i64 noundef %18), !dbg !725
  store ptr %19, ptr %5, align 8, !dbg !723
  %20 = load ptr, ptr %5, align 8, !dbg !726
  %21 = icmp eq ptr %20, %3, !dbg !726
  %22 = xor i1 %21, true, !dbg !726
  %23 = zext i1 %22 to i32, !dbg !726
  %24 = sext i32 %23 to i64, !dbg !726
  %25 = icmp ne i64 %24, 0, !dbg !726
  br i1 %25, label %26, label %28, !dbg !726

26:                                               ; preds = %17
  call void @__assert_rtn(ptr noundef @__func__.key_worker, ptr noundef @.str, i32 noundef 382, ptr noundef @.str.5) #3, !dbg !726
  unreachable, !dbg !726

27:                                               ; No predecessors!
  br label %29, !dbg !726

28:                                               ; preds = %17
  br label %29, !dbg !726

29:                                               ; preds = %28, %27
  %30 = load ptr, ptr %2, align 8, !dbg !727
  ret ptr %30, !dbg !728
}

declare i32 @pthread_setspecific(i64 noundef, ptr noundef) #1

declare ptr @pthread_getspecific(i64 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @key_test() #0 !dbg !729 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
    #dbg_declare(ptr %1, !730, !DIExpression(), !731)
  store i32 2, ptr %1, align 4, !dbg !731
    #dbg_declare(ptr %2, !732, !DIExpression(), !733)
  store ptr inttoptr (i64 41 to ptr), ptr %2, align 8, !dbg !733
    #dbg_declare(ptr %3, !734, !DIExpression(), !735)
  %7 = call i32 @pthread_key_create(ptr noundef @local_data, ptr noundef @key_destroy), !dbg !736
    #dbg_declare(ptr %4, !737, !DIExpression(), !738)
  %8 = load ptr, ptr %2, align 8, !dbg !739
  %9 = call ptr @thread_create(ptr noundef @key_worker, ptr noundef %8), !dbg !740
  store ptr %9, ptr %4, align 8, !dbg !738
  %10 = load i64, ptr @local_data, align 8, !dbg !741
  %11 = call i32 @pthread_setspecific(i64 noundef %10, ptr noundef %1), !dbg !742
  store i32 %11, ptr %3, align 4, !dbg !743
  %12 = load i32, ptr %3, align 4, !dbg !744
  %13 = icmp eq i32 %12, 0, !dbg !744
  %14 = xor i1 %13, true, !dbg !744
  %15 = zext i1 %14 to i32, !dbg !744
  %16 = sext i32 %15 to i64, !dbg !744
  %17 = icmp ne i64 %16, 0, !dbg !744
  br i1 %17, label %18, label %20, !dbg !744

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 398, ptr noundef @.str.1) #3, !dbg !744
  unreachable, !dbg !744

19:                                               ; No predecessors!
  br label %21, !dbg !744

20:                                               ; preds = %0
  br label %21, !dbg !744

21:                                               ; preds = %20, %19
    #dbg_declare(ptr %5, !745, !DIExpression(), !746)
  %22 = load i64, ptr @local_data, align 8, !dbg !747
  %23 = call ptr @pthread_getspecific(i64 noundef %22), !dbg !748
  store ptr %23, ptr %5, align 8, !dbg !746
  %24 = load ptr, ptr %5, align 8, !dbg !749
  %25 = icmp eq ptr %24, %1, !dbg !749
  %26 = xor i1 %25, true, !dbg !749
  %27 = zext i1 %26 to i32, !dbg !749
  %28 = sext i32 %27 to i64, !dbg !749
  %29 = icmp ne i64 %28, 0, !dbg !749
  br i1 %29, label %30, label %32, !dbg !749

30:                                               ; preds = %21
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 401, ptr noundef @.str.5) #3, !dbg !749
  unreachable, !dbg !749

31:                                               ; No predecessors!
  br label %33, !dbg !749

32:                                               ; preds = %21
  br label %33, !dbg !749

33:                                               ; preds = %32, %31
  %34 = load i64, ptr @local_data, align 8, !dbg !750
  %35 = call i32 @pthread_setspecific(i64 noundef %34, ptr noundef null), !dbg !751
  store i32 %35, ptr %3, align 4, !dbg !752
  %36 = load i32, ptr %3, align 4, !dbg !753
  %37 = icmp eq i32 %36, 0, !dbg !753
  %38 = xor i1 %37, true, !dbg !753
  %39 = zext i1 %38 to i32, !dbg !753
  %40 = sext i32 %39 to i64, !dbg !753
  %41 = icmp ne i64 %40, 0, !dbg !753
  br i1 %41, label %42, label %44, !dbg !753

42:                                               ; preds = %33
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 404, ptr noundef @.str.1) #3, !dbg !753
  unreachable, !dbg !753

43:                                               ; No predecessors!
  br label %45, !dbg !753

44:                                               ; preds = %33
  br label %45, !dbg !753

45:                                               ; preds = %44, %43
    #dbg_declare(ptr %6, !754, !DIExpression(), !755)
  %46 = load ptr, ptr %4, align 8, !dbg !756
  %47 = call ptr @thread_join(ptr noundef %46), !dbg !757
  store ptr %47, ptr %6, align 8, !dbg !755
  %48 = load ptr, ptr %6, align 8, !dbg !758
  %49 = load ptr, ptr %2, align 8, !dbg !758
  %50 = icmp eq ptr %48, %49, !dbg !758
  %51 = xor i1 %50, true, !dbg !758
  %52 = zext i1 %51 to i32, !dbg !758
  %53 = sext i32 %52 to i64, !dbg !758
  %54 = icmp ne i64 %53, 0, !dbg !758
  br i1 %54, label %55, label %57, !dbg !758

55:                                               ; preds = %45
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 407, ptr noundef @.str.4) #3, !dbg !758
  unreachable, !dbg !758

56:                                               ; No predecessors!
  br label %58, !dbg !758

57:                                               ; preds = %45
  br label %58, !dbg !758

58:                                               ; preds = %57, %56
  %59 = load i64, ptr @local_data, align 8, !dbg !759
  %60 = call i32 @pthread_key_delete(i64 noundef %59), !dbg !760
  store i32 %60, ptr %3, align 4, !dbg !761
  %61 = load i32, ptr %3, align 4, !dbg !762
  %62 = icmp eq i32 %61, 0, !dbg !762
  %63 = xor i1 %62, true, !dbg !762
  %64 = zext i1 %63 to i32, !dbg !762
  %65 = sext i32 %64 to i64, !dbg !762
  %66 = icmp ne i64 %65, 0, !dbg !762
  br i1 %66, label %67, label %69, !dbg !762

67:                                               ; preds = %58
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 410, ptr noundef @.str.1) #3, !dbg !762
  unreachable, !dbg !762

68:                                               ; No predecessors!
  br label %70, !dbg !762

69:                                               ; preds = %58
  br label %70, !dbg !762

70:                                               ; preds = %69, %68
  ret void, !dbg !763
}

declare i32 @pthread_key_create(ptr noundef, ptr noundef) #1

declare i32 @pthread_key_delete(i64 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @detach_test_worker0(ptr noundef %0) #0 !dbg !764 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !765, !DIExpression(), !766)
  ret ptr null, !dbg !767
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @detach_test_detach(ptr noundef %0) #0 !dbg !768 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !769, !DIExpression(), !770)
    #dbg_declare(ptr %3, !771, !DIExpression(), !772)
    #dbg_declare(ptr %4, !773, !DIExpression(), !774)
  %5 = call ptr @thread_create(ptr noundef @detach_test_worker0, ptr noundef null), !dbg !775
  store ptr %5, ptr %4, align 8, !dbg !774
  %6 = load ptr, ptr %4, align 8, !dbg !776
  %7 = call i32 @pthread_detach(ptr noundef %6), !dbg !777
  store i32 %7, ptr %3, align 4, !dbg !778
  %8 = load i32, ptr %3, align 4, !dbg !779
  %9 = icmp eq i32 %8, 0, !dbg !779
  %10 = xor i1 %9, true, !dbg !779
  %11 = zext i1 %10 to i32, !dbg !779
  %12 = sext i32 %11 to i64, !dbg !779
  %13 = icmp ne i64 %12, 0, !dbg !779
  br i1 %13, label %14, label %16, !dbg !779

14:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.detach_test_detach, ptr noundef @.str, i32 noundef 427, ptr noundef @.str.1) #3, !dbg !779
  unreachable, !dbg !779

15:                                               ; No predecessors!
  br label %17, !dbg !779

16:                                               ; preds = %1
  br label %17, !dbg !779

17:                                               ; preds = %16, %15
  %18 = load ptr, ptr %4, align 8, !dbg !780
  %19 = call i32 @_pthread_join(ptr noundef %18, ptr noundef null), !dbg !781
  store i32 %19, ptr %3, align 4, !dbg !782
  %20 = load i32, ptr %3, align 4, !dbg !783
  %21 = icmp ne i32 %20, 0, !dbg !783
  %22 = xor i1 %21, true, !dbg !783
  %23 = zext i1 %22 to i32, !dbg !783
  %24 = sext i32 %23 to i64, !dbg !783
  %25 = icmp ne i64 %24, 0, !dbg !783
  br i1 %25, label %26, label %28, !dbg !783

26:                                               ; preds = %17
  call void @__assert_rtn(ptr noundef @__func__.detach_test_detach, ptr noundef @.str, i32 noundef 430, ptr noundef @.str.6) #3, !dbg !783
  unreachable, !dbg !783

27:                                               ; No predecessors!
  br label %29, !dbg !783

28:                                               ; preds = %17
  br label %29, !dbg !783

29:                                               ; preds = %28, %27
  ret ptr null, !dbg !784
}

declare i32 @pthread_detach(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @detach_test_attr(ptr noundef %0) #0 !dbg !785 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca %struct._opaque_pthread_attr_t, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !786, !DIExpression(), !787)
    #dbg_declare(ptr %3, !788, !DIExpression(), !789)
    #dbg_declare(ptr %4, !790, !DIExpression(), !791)
    #dbg_declare(ptr %5, !792, !DIExpression(), !793)
    #dbg_declare(ptr %6, !794, !DIExpression(), !795)
  %7 = call i32 @pthread_attr_init(ptr noundef %6), !dbg !796
  store i32 %7, ptr %3, align 4, !dbg !797
  %8 = load i32, ptr %3, align 4, !dbg !798
  %9 = icmp eq i32 %8, 0, !dbg !798
  %10 = xor i1 %9, true, !dbg !798
  %11 = zext i1 %10 to i32, !dbg !798
  %12 = sext i32 %11 to i64, !dbg !798
  %13 = icmp ne i64 %12, 0, !dbg !798
  br i1 %13, label %14, label %16, !dbg !798

14:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 441, ptr noundef @.str.1) #3, !dbg !798
  unreachable, !dbg !798

15:                                               ; No predecessors!
  br label %17, !dbg !798

16:                                               ; preds = %1
  br label %17, !dbg !798

17:                                               ; preds = %16, %15
  %18 = call i32 @pthread_attr_getdetachstate(ptr noundef %6, ptr noundef %4), !dbg !799
  store i32 %18, ptr %3, align 4, !dbg !800
  %19 = load i32, ptr %3, align 4, !dbg !801
  %20 = icmp eq i32 %19, 0, !dbg !801
  br i1 %20, label %21, label %24, !dbg !801

21:                                               ; preds = %17
  %22 = load i32, ptr %4, align 4, !dbg !801
  %23 = icmp eq i32 %22, 1, !dbg !801
  br label %24

24:                                               ; preds = %21, %17
  %25 = phi i1 [ false, %17 ], [ %23, %21 ], !dbg !802
  %26 = xor i1 %25, true, !dbg !801
  %27 = zext i1 %26 to i32, !dbg !801
  %28 = sext i32 %27 to i64, !dbg !801
  %29 = icmp ne i64 %28, 0, !dbg !801
  br i1 %29, label %30, label %32, !dbg !801

30:                                               ; preds = %24
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 443, ptr noundef @.str.7) #3, !dbg !801
  unreachable, !dbg !801

31:                                               ; No predecessors!
  br label %33, !dbg !801

32:                                               ; preds = %24
  br label %33, !dbg !801

33:                                               ; preds = %32, %31
  %34 = call i32 @pthread_attr_setdetachstate(ptr noundef %6, i32 noundef 2), !dbg !803
  store i32 %34, ptr %3, align 4, !dbg !804
  %35 = load i32, ptr %3, align 4, !dbg !805
  %36 = icmp eq i32 %35, 0, !dbg !805
  %37 = xor i1 %36, true, !dbg !805
  %38 = zext i1 %37 to i32, !dbg !805
  %39 = sext i32 %38 to i64, !dbg !805
  %40 = icmp ne i64 %39, 0, !dbg !805
  br i1 %40, label %41, label %43, !dbg !805

41:                                               ; preds = %33
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 445, ptr noundef @.str.1) #3, !dbg !805
  unreachable, !dbg !805

42:                                               ; No predecessors!
  br label %44, !dbg !805

43:                                               ; preds = %33
  br label %44, !dbg !805

44:                                               ; preds = %43, %42
  %45 = call i32 @pthread_attr_getdetachstate(ptr noundef %6, ptr noundef %4), !dbg !806
  store i32 %45, ptr %3, align 4, !dbg !807
  %46 = load i32, ptr %3, align 4, !dbg !808
  %47 = icmp eq i32 %46, 0, !dbg !808
  br i1 %47, label %48, label %51, !dbg !808

48:                                               ; preds = %44
  %49 = load i32, ptr %4, align 4, !dbg !808
  %50 = icmp eq i32 %49, 2, !dbg !808
  br label %51

51:                                               ; preds = %48, %44
  %52 = phi i1 [ false, %44 ], [ %50, %48 ], !dbg !802
  %53 = xor i1 %52, true, !dbg !808
  %54 = zext i1 %53 to i32, !dbg !808
  %55 = sext i32 %54 to i64, !dbg !808
  %56 = icmp ne i64 %55, 0, !dbg !808
  br i1 %56, label %57, label %59, !dbg !808

57:                                               ; preds = %51
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 447, ptr noundef @.str.8) #3, !dbg !808
  unreachable, !dbg !808

58:                                               ; No predecessors!
  br label %60, !dbg !808

59:                                               ; preds = %51
  br label %60, !dbg !808

60:                                               ; preds = %59, %58
  %61 = call i32 @pthread_create(ptr noundef %5, ptr noundef %6, ptr noundef @detach_test_worker0, ptr noundef null), !dbg !809
  store i32 %61, ptr %3, align 4, !dbg !810
  %62 = load i32, ptr %3, align 4, !dbg !811
  %63 = icmp eq i32 %62, 0, !dbg !811
  %64 = xor i1 %63, true, !dbg !811
  %65 = zext i1 %64 to i32, !dbg !811
  %66 = sext i32 %65 to i64, !dbg !811
  %67 = icmp ne i64 %66, 0, !dbg !811
  br i1 %67, label %68, label %70, !dbg !811

68:                                               ; preds = %60
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 449, ptr noundef @.str.1) #3, !dbg !811
  unreachable, !dbg !811

69:                                               ; No predecessors!
  br label %71, !dbg !811

70:                                               ; preds = %60
  br label %71, !dbg !811

71:                                               ; preds = %70, %69
  %72 = call i32 @pthread_attr_destroy(ptr noundef %6), !dbg !812
  %73 = load ptr, ptr %5, align 8, !dbg !813
  %74 = call i32 @_pthread_join(ptr noundef %73, ptr noundef null), !dbg !814
  store i32 %74, ptr %3, align 4, !dbg !815
  %75 = load i32, ptr %3, align 4, !dbg !816
  %76 = icmp ne i32 %75, 0, !dbg !816
  %77 = xor i1 %76, true, !dbg !816
  %78 = zext i1 %77 to i32, !dbg !816
  %79 = sext i32 %78 to i64, !dbg !816
  %80 = icmp ne i64 %79, 0, !dbg !816
  br i1 %80, label %81, label %83, !dbg !816

81:                                               ; preds = %71
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 453, ptr noundef @.str.6) #3, !dbg !816
  unreachable, !dbg !816

82:                                               ; No predecessors!
  br label %84, !dbg !816

83:                                               ; preds = %71
  br label %84, !dbg !816

84:                                               ; preds = %83, %82
  ret ptr null, !dbg !817
}

declare i32 @pthread_attr_getdetachstate(ptr noundef, ptr noundef) #1

declare i32 @pthread_attr_setdetachstate(ptr noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @detach_test() #0 !dbg !818 {
  %1 = call ptr @thread_create(ptr noundef @detach_test_detach, ptr noundef null), !dbg !819
  %2 = call ptr @thread_create(ptr noundef @detach_test_attr, ptr noundef null), !dbg !820
  ret void, !dbg !821
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !822 {
  call void @mutex_test(), !dbg !825
  call void @cond_test(), !dbg !826
  call void @rwlock_test(), !dbg !827
  call void @key_test(), !dbg !828
  call void @detach_test(), !dbg !829
  ret i32 0, !dbg !830
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!61}
!llvm.module.flags = !{!170, !171, !172, !173, !174, !175, !176}
!llvm.ident = !{!177}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 18, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "benchmarks/miscellaneous/pthread.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "8958a967cefe9f6512011dfd7798a4f3")
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
!22 = distinct !DIGlobalVariable(scope: null, file: !2, line: 49, type: !23, isLocal: true, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 88, elements: !24)
!24 = !{!25}
!25 = !DISubrange(count: 11)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(scope: null, file: !2, line: 80, type: !3, isLocal: true, isDefinition: true)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(scope: null, file: !2, line: 86, type: !23, isLocal: true, isDefinition: true)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !2, line: 99, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 104, elements: !33)
!33 = !{!34}
!34 = !DISubrange(count: 13)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(scope: null, file: !2, line: 113, type: !23, isLocal: true, isDefinition: true)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !2, line: 113, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 72, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 9)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !2, line: 122, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 64, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 8)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(scope: null, file: !2, line: 154, type: !49, isLocal: true, isDefinition: true)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 80, elements: !11)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(scope: null, file: !2, line: 166, type: !32, isLocal: true, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(scope: null, file: !2, line: 172, type: !20, isLocal: true, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(scope: null, file: !2, line: 178, type: !56, isLocal: true, isDefinition: true)
!56 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 120, elements: !57)
!57 = !{!58}
!58 = !DISubrange(count: 15)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "phase", scope: !61, file: !2, line: 200, type: !169, isLocal: false, isDefinition: true)
!61 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !62, globals: !65, splitDebugInlining: false, nameTableKind: None)
!62 = !{!63, !64}
!63 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!65 = !{!0, !8, !13, !18, !21, !26, !28, !30, !35, !37, !42, !47, !50, !52, !54, !59, !66, !68, !73, !75, !77, !79, !81, !83, !85, !87, !92, !95, !100, !102, !107, !112, !114, !128, !140, !163}
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(scope: null, file: !2, line: 252, type: !49, isLocal: true, isDefinition: true)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(scope: null, file: !2, line: 252, type: !70, isLocal: true, isDefinition: true)
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 144, elements: !71)
!71 = !{!72}
!72 = !DISubrange(count: 18)
!73 = !DIGlobalVariableExpression(var: !74, expr: !DIExpression())
!74 = distinct !DIGlobalVariable(scope: null, file: !2, line: 269, type: !20, isLocal: true, isDefinition: true)
!75 = !DIGlobalVariableExpression(var: !76, expr: !DIExpression())
!76 = distinct !DIGlobalVariable(scope: null, file: !2, line: 285, type: !56, isLocal: true, isDefinition: true)
!77 = !DIGlobalVariableExpression(var: !78, expr: !DIExpression())
!78 = distinct !DIGlobalVariable(scope: null, file: !2, line: 291, type: !3, isLocal: true, isDefinition: true)
!79 = !DIGlobalVariableExpression(var: !80, expr: !DIExpression())
!80 = distinct !DIGlobalVariable(scope: null, file: !2, line: 304, type: !3, isLocal: true, isDefinition: true)
!81 = !DIGlobalVariableExpression(var: !82, expr: !DIExpression())
!82 = distinct !DIGlobalVariable(scope: null, file: !2, line: 317, type: !3, isLocal: true, isDefinition: true)
!83 = !DIGlobalVariableExpression(var: !84, expr: !DIExpression())
!84 = distinct !DIGlobalVariable(scope: null, file: !2, line: 329, type: !20, isLocal: true, isDefinition: true)
!85 = !DIGlobalVariableExpression(var: !86, expr: !DIExpression())
!86 = distinct !DIGlobalVariable(scope: null, file: !2, line: 379, type: !23, isLocal: true, isDefinition: true)
!87 = !DIGlobalVariableExpression(var: !88, expr: !DIExpression())
!88 = distinct !DIGlobalVariable(scope: null, file: !2, line: 382, type: !89, isLocal: true, isDefinition: true)
!89 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 224, elements: !90)
!90 = !{!91}
!91 = !DISubrange(count: 28)
!92 = !DIGlobalVariableExpression(var: !93, expr: !DIExpression())
!93 = distinct !DIGlobalVariable(scope: null, file: !2, line: 398, type: !94, isLocal: true, isDefinition: true)
!94 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 72, elements: !40)
!95 = !DIGlobalVariableExpression(var: !96, expr: !DIExpression())
!96 = distinct !DIGlobalVariable(scope: null, file: !2, line: 427, type: !97, isLocal: true, isDefinition: true)
!97 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 152, elements: !98)
!98 = !{!99}
!99 = !DISubrange(count: 19)
!100 = !DIGlobalVariableExpression(var: !101, expr: !DIExpression())
!101 = distinct !DIGlobalVariable(scope: null, file: !2, line: 430, type: !15, isLocal: true, isDefinition: true)
!102 = !DIGlobalVariableExpression(var: !103, expr: !DIExpression())
!103 = distinct !DIGlobalVariable(scope: null, file: !2, line: 441, type: !104, isLocal: true, isDefinition: true)
!104 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 136, elements: !105)
!105 = !{!106}
!106 = !DISubrange(count: 17)
!107 = !DIGlobalVariableExpression(var: !108, expr: !DIExpression())
!108 = distinct !DIGlobalVariable(scope: null, file: !2, line: 443, type: !109, isLocal: true, isDefinition: true)
!109 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 432, elements: !110)
!110 = !{!111}
!111 = !DISubrange(count: 54)
!112 = !DIGlobalVariableExpression(var: !113, expr: !DIExpression())
!113 = distinct !DIGlobalVariable(scope: null, file: !2, line: 447, type: !109, isLocal: true, isDefinition: true)
!114 = !DIGlobalVariableExpression(var: !115, expr: !DIExpression())
!115 = distinct !DIGlobalVariable(name: "cond_mutex", scope: !61, file: !2, line: 198, type: !116, isLocal: false, isDefinition: true)
!116 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !117, line: 31, baseType: !118)
!117 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_mutex_t.h", directory: "", checksumkind: CSK_MD5, checksum: "583a89b25a16f85ebbdf32f8d9f237ec")
!118 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutex_t", file: !119, line: 113, baseType: !120)
!119 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!120 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutex_t", file: !119, line: 78, size: 512, elements: !121)
!121 = !{!122, !124}
!122 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !120, file: !119, line: 79, baseType: !123, size: 64)
!123 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !120, file: !119, line: 80, baseType: !125, size: 448, offset: 64)
!125 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 448, elements: !126)
!126 = !{!127}
!127 = !DISubrange(count: 56)
!128 = !DIGlobalVariableExpression(var: !129, expr: !DIExpression())
!129 = distinct !DIGlobalVariable(name: "cond", scope: !61, file: !2, line: 199, type: !130, isLocal: false, isDefinition: true)
!130 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_cond_t", file: !131, line: 31, baseType: !132)
!131 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_cond_t.h", directory: "", checksumkind: CSK_MD5, checksum: "a08af80ea124ebd303c431fa8c0affff")
!132 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_cond_t", file: !119, line: 110, baseType: !133)
!133 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_cond_t", file: !119, line: 68, size: 384, elements: !134)
!134 = !{!135, !136}
!135 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !133, file: !119, line: 69, baseType: !123, size: 64)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !133, file: !119, line: 70, baseType: !137, size: 320, offset: 64)
!137 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 320, elements: !138)
!138 = !{!139}
!139 = !DISubrange(count: 40)
!140 = !DIGlobalVariableExpression(var: !141, expr: !DIExpression())
!141 = distinct !DIGlobalVariable(name: "latest_thread", scope: !61, file: !2, line: 366, type: !142, isLocal: false, isDefinition: true)
!142 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !143, line: 31, baseType: !144)
!143 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!144 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !119, line: 118, baseType: !145)
!145 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !146, size: 64)
!146 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !119, line: 103, size: 65536, elements: !147)
!147 = !{!148, !149, !159}
!148 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !146, file: !119, line: 104, baseType: !123, size: 64)
!149 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !146, file: !119, line: 105, baseType: !150, size: 64, offset: 64)
!150 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !151, size: 64)
!151 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !119, line: 57, size: 192, elements: !152)
!152 = !{!153, !157, !158}
!153 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !151, file: !119, line: 58, baseType: !154, size: 64)
!154 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !155, size: 64)
!155 = !DISubroutineType(types: !156)
!156 = !{null, !64}
!157 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !151, file: !119, line: 59, baseType: !64, size: 64, offset: 64)
!158 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !151, file: !119, line: 60, baseType: !150, size: 64, offset: 128)
!159 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !146, file: !119, line: 106, baseType: !160, size: 65408, offset: 128)
!160 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 65408, elements: !161)
!161 = !{!162}
!162 = !DISubrange(count: 8176)
!163 = !DIGlobalVariableExpression(var: !164, expr: !DIExpression())
!164 = distinct !DIGlobalVariable(name: "local_data", scope: !61, file: !2, line: 367, type: !165, isLocal: false, isDefinition: true)
!165 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_key_t", file: !166, line: 31, baseType: !167)
!166 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_key_t.h", directory: "", checksumkind: CSK_MD5, checksum: "5b81238049903288f8d6142c5fcfabd6")
!167 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_key_t", file: !119, line: 112, baseType: !168)
!168 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!169 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!170 = !{i32 7, !"Dwarf Version", i32 5}
!171 = !{i32 2, !"Debug Info Version", i32 3}
!172 = !{i32 1, !"wchar_size", i32 4}
!173 = !{i32 8, !"PIC Level", i32 2}
!174 = !{i32 7, !"PIE Level", i32 2}
!175 = !{i32 7, !"uwtable", i32 2}
!176 = !{i32 7, !"frame-pointer", i32 2}
!177 = !{!"Homebrew clang version 19.1.7"}
!178 = distinct !DISubprogram(name: "thread_create", scope: !2, file: !2, line: 12, type: !179, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!179 = !DISubroutineType(types: !180)
!180 = !{!142, !181, !64}
!181 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !182, size: 64)
!182 = !DISubroutineType(types: !183)
!183 = !{!64, !64}
!184 = !{}
!185 = !DILocalVariable(name: "runner", arg: 1, scope: !178, file: !2, line: 12, type: !181)
!186 = !DILocation(line: 12, column: 32, scope: !178)
!187 = !DILocalVariable(name: "data", arg: 2, scope: !178, file: !2, line: 12, type: !64)
!188 = !DILocation(line: 12, column: 54, scope: !178)
!189 = !DILocalVariable(name: "id", scope: !178, file: !2, line: 14, type: !142)
!190 = !DILocation(line: 14, column: 15, scope: !178)
!191 = !DILocalVariable(name: "attr", scope: !178, file: !2, line: 15, type: !192)
!192 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !193, line: 31, baseType: !194)
!193 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_attr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "383e78324250b910a1128f1b9a464b23")
!194 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_attr_t", file: !119, line: 109, baseType: !195)
!195 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_attr_t", file: !119, line: 63, size: 512, elements: !196)
!196 = !{!197, !198}
!197 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !195, file: !119, line: 64, baseType: !123, size: 64)
!198 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !195, file: !119, line: 65, baseType: !125, size: 448, offset: 64)
!199 = !DILocation(line: 15, column: 20, scope: !178)
!200 = !DILocation(line: 16, column: 5, scope: !178)
!201 = !DILocalVariable(name: "status", scope: !178, file: !2, line: 17, type: !169)
!202 = !DILocation(line: 17, column: 9, scope: !178)
!203 = !DILocation(line: 17, column: 45, scope: !178)
!204 = !DILocation(line: 17, column: 53, scope: !178)
!205 = !DILocation(line: 17, column: 18, scope: !178)
!206 = !DILocation(line: 18, column: 5, scope: !178)
!207 = !DILocation(line: 19, column: 5, scope: !178)
!208 = !DILocation(line: 20, column: 12, scope: !178)
!209 = !DILocation(line: 20, column: 5, scope: !178)
!210 = distinct !DISubprogram(name: "thread_join", scope: !2, file: !2, line: 23, type: !211, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!211 = !DISubroutineType(types: !212)
!212 = !{!64, !142}
!213 = !DILocalVariable(name: "id", arg: 1, scope: !210, file: !2, line: 23, type: !142)
!214 = !DILocation(line: 23, column: 29, scope: !210)
!215 = !DILocalVariable(name: "result", scope: !210, file: !2, line: 25, type: !64)
!216 = !DILocation(line: 25, column: 11, scope: !210)
!217 = !DILocalVariable(name: "status", scope: !210, file: !2, line: 26, type: !169)
!218 = !DILocation(line: 26, column: 9, scope: !210)
!219 = !DILocation(line: 26, column: 31, scope: !210)
!220 = !DILocation(line: 26, column: 18, scope: !210)
!221 = !DILocation(line: 27, column: 5, scope: !210)
!222 = !DILocation(line: 28, column: 12, scope: !210)
!223 = !DILocation(line: 28, column: 5, scope: !210)
!224 = distinct !DISubprogram(name: "mutex_init", scope: !2, file: !2, line: 43, type: !225, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!225 = !DISubroutineType(types: !226)
!226 = !{null, !227, !169, !169, !169, !169}
!227 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !116, size: 64)
!228 = !DILocalVariable(name: "lock", arg: 1, scope: !224, file: !2, line: 43, type: !227)
!229 = !DILocation(line: 43, column: 34, scope: !224)
!230 = !DILocalVariable(name: "type", arg: 2, scope: !224, file: !2, line: 43, type: !169)
!231 = !DILocation(line: 43, column: 44, scope: !224)
!232 = !DILocalVariable(name: "protocol", arg: 3, scope: !224, file: !2, line: 43, type: !169)
!233 = !DILocation(line: 43, column: 54, scope: !224)
!234 = !DILocalVariable(name: "policy", arg: 4, scope: !224, file: !2, line: 43, type: !169)
!235 = !DILocation(line: 43, column: 68, scope: !224)
!236 = !DILocalVariable(name: "prioceiling", arg: 5, scope: !224, file: !2, line: 43, type: !169)
!237 = !DILocation(line: 43, column: 80, scope: !224)
!238 = !DILocalVariable(name: "status", scope: !224, file: !2, line: 45, type: !169)
!239 = !DILocation(line: 45, column: 9, scope: !224)
!240 = !DILocalVariable(name: "value", scope: !224, file: !2, line: 46, type: !169)
!241 = !DILocation(line: 46, column: 9, scope: !224)
!242 = !DILocalVariable(name: "attributes", scope: !224, file: !2, line: 47, type: !243)
!243 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !244, line: 31, baseType: !245)
!244 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_mutexattr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "785eb3f812f7ebee764058667d4b4693")
!245 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutexattr_t", file: !119, line: 114, baseType: !246)
!246 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutexattr_t", file: !119, line: 83, size: 128, elements: !247)
!247 = !{!248, !249}
!248 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !246, file: !119, line: 84, baseType: !123, size: 64)
!249 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !246, file: !119, line: 85, baseType: !44, size: 64, offset: 64)
!250 = !DILocation(line: 47, column: 25, scope: !224)
!251 = !DILocation(line: 48, column: 14, scope: !224)
!252 = !DILocation(line: 48, column: 12, scope: !224)
!253 = !DILocation(line: 49, column: 5, scope: !224)
!254 = !DILocation(line: 51, column: 53, scope: !224)
!255 = !DILocation(line: 51, column: 14, scope: !224)
!256 = !DILocation(line: 51, column: 12, scope: !224)
!257 = !DILocation(line: 52, column: 5, scope: !224)
!258 = !DILocation(line: 53, column: 14, scope: !224)
!259 = !DILocation(line: 53, column: 12, scope: !224)
!260 = !DILocation(line: 54, column: 5, scope: !224)
!261 = !DILocation(line: 56, column: 57, scope: !224)
!262 = !DILocation(line: 56, column: 14, scope: !224)
!263 = !DILocation(line: 56, column: 12, scope: !224)
!264 = !DILocation(line: 57, column: 5, scope: !224)
!265 = !DILocation(line: 58, column: 14, scope: !224)
!266 = !DILocation(line: 58, column: 12, scope: !224)
!267 = !DILocation(line: 59, column: 5, scope: !224)
!268 = !DILocation(line: 61, column: 58, scope: !224)
!269 = !DILocation(line: 61, column: 14, scope: !224)
!270 = !DILocation(line: 61, column: 12, scope: !224)
!271 = !DILocation(line: 62, column: 5, scope: !224)
!272 = !DILocation(line: 63, column: 14, scope: !224)
!273 = !DILocation(line: 63, column: 12, scope: !224)
!274 = !DILocation(line: 64, column: 5, scope: !224)
!275 = !DILocation(line: 66, column: 60, scope: !224)
!276 = !DILocation(line: 66, column: 14, scope: !224)
!277 = !DILocation(line: 66, column: 12, scope: !224)
!278 = !DILocation(line: 67, column: 5, scope: !224)
!279 = !DILocation(line: 68, column: 14, scope: !224)
!280 = !DILocation(line: 68, column: 12, scope: !224)
!281 = !DILocation(line: 69, column: 5, scope: !224)
!282 = !DILocation(line: 71, column: 33, scope: !224)
!283 = !DILocation(line: 71, column: 14, scope: !224)
!284 = !DILocation(line: 71, column: 12, scope: !224)
!285 = !DILocation(line: 72, column: 5, scope: !224)
!286 = !DILocation(line: 73, column: 14, scope: !224)
!287 = !DILocation(line: 73, column: 12, scope: !224)
!288 = !DILocation(line: 74, column: 5, scope: !224)
!289 = !DILocation(line: 75, column: 1, scope: !224)
!290 = distinct !DISubprogram(name: "mutex_destroy", scope: !2, file: !2, line: 77, type: !291, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!291 = !DISubroutineType(types: !292)
!292 = !{null, !227}
!293 = !DILocalVariable(name: "lock", arg: 1, scope: !290, file: !2, line: 77, type: !227)
!294 = !DILocation(line: 77, column: 37, scope: !290)
!295 = !DILocalVariable(name: "status", scope: !290, file: !2, line: 79, type: !169)
!296 = !DILocation(line: 79, column: 9, scope: !290)
!297 = !DILocation(line: 79, column: 40, scope: !290)
!298 = !DILocation(line: 79, column: 18, scope: !290)
!299 = !DILocation(line: 80, column: 5, scope: !290)
!300 = !DILocation(line: 81, column: 1, scope: !290)
!301 = distinct !DISubprogram(name: "mutex_lock", scope: !2, file: !2, line: 83, type: !291, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!302 = !DILocalVariable(name: "lock", arg: 1, scope: !301, file: !2, line: 83, type: !227)
!303 = !DILocation(line: 83, column: 34, scope: !301)
!304 = !DILocalVariable(name: "status", scope: !301, file: !2, line: 85, type: !169)
!305 = !DILocation(line: 85, column: 9, scope: !301)
!306 = !DILocation(line: 85, column: 37, scope: !301)
!307 = !DILocation(line: 85, column: 18, scope: !301)
!308 = !DILocation(line: 86, column: 5, scope: !301)
!309 = !DILocation(line: 87, column: 1, scope: !301)
!310 = distinct !DISubprogram(name: "mutex_trylock", scope: !2, file: !2, line: 89, type: !311, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!311 = !DISubroutineType(types: !312)
!312 = !{!313, !227}
!313 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!314 = !DILocalVariable(name: "lock", arg: 1, scope: !310, file: !2, line: 89, type: !227)
!315 = !DILocation(line: 89, column: 37, scope: !310)
!316 = !DILocalVariable(name: "status", scope: !310, file: !2, line: 91, type: !169)
!317 = !DILocation(line: 91, column: 9, scope: !310)
!318 = !DILocation(line: 91, column: 40, scope: !310)
!319 = !DILocation(line: 91, column: 18, scope: !310)
!320 = !DILocation(line: 93, column: 12, scope: !310)
!321 = !DILocation(line: 93, column: 19, scope: !310)
!322 = !DILocation(line: 93, column: 5, scope: !310)
!323 = distinct !DISubprogram(name: "mutex_unlock", scope: !2, file: !2, line: 96, type: !291, scopeLine: 97, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!324 = !DILocalVariable(name: "lock", arg: 1, scope: !323, file: !2, line: 96, type: !227)
!325 = !DILocation(line: 96, column: 36, scope: !323)
!326 = !DILocalVariable(name: "status", scope: !323, file: !2, line: 98, type: !169)
!327 = !DILocation(line: 98, column: 9, scope: !323)
!328 = !DILocation(line: 98, column: 39, scope: !323)
!329 = !DILocation(line: 98, column: 18, scope: !323)
!330 = !DILocation(line: 99, column: 5, scope: !323)
!331 = !DILocation(line: 100, column: 1, scope: !323)
!332 = distinct !DISubprogram(name: "mutex_test", scope: !2, file: !2, line: 102, type: !333, scopeLine: 103, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!333 = !DISubroutineType(types: !334)
!334 = !{null}
!335 = !DILocalVariable(name: "mutex0", scope: !332, file: !2, line: 104, type: !116)
!336 = !DILocation(line: 104, column: 21, scope: !332)
!337 = !DILocalVariable(name: "mutex1", scope: !332, file: !2, line: 105, type: !116)
!338 = !DILocation(line: 105, column: 21, scope: !332)
!339 = !DILocation(line: 107, column: 5, scope: !332)
!340 = !DILocation(line: 108, column: 5, scope: !332)
!341 = !DILocation(line: 111, column: 9, scope: !342)
!342 = distinct !DILexicalBlock(scope: !332, file: !2, line: 110, column: 5)
!343 = !DILocalVariable(name: "success", scope: !342, file: !2, line: 112, type: !313)
!344 = !DILocation(line: 112, column: 14, scope: !342)
!345 = !DILocation(line: 112, column: 24, scope: !342)
!346 = !DILocation(line: 113, column: 9, scope: !342)
!347 = !DILocation(line: 114, column: 9, scope: !342)
!348 = !DILocation(line: 118, column: 9, scope: !349)
!349 = distinct !DILexicalBlock(scope: !332, file: !2, line: 117, column: 5)
!350 = !DILocalVariable(name: "success", scope: !351, file: !2, line: 121, type: !313)
!351 = distinct !DILexicalBlock(scope: !349, file: !2, line: 120, column: 9)
!352 = !DILocation(line: 121, column: 18, scope: !351)
!353 = !DILocation(line: 121, column: 28, scope: !351)
!354 = !DILocation(line: 122, column: 13, scope: !351)
!355 = !DILocation(line: 123, column: 13, scope: !351)
!356 = !DILocalVariable(name: "success", scope: !357, file: !2, line: 127, type: !313)
!357 = distinct !DILexicalBlock(scope: !349, file: !2, line: 126, column: 9)
!358 = !DILocation(line: 127, column: 18, scope: !357)
!359 = !DILocation(line: 127, column: 28, scope: !357)
!360 = !DILocation(line: 128, column: 13, scope: !357)
!361 = !DILocation(line: 129, column: 13, scope: !357)
!362 = !DILocation(line: 139, column: 9, scope: !349)
!363 = !DILocation(line: 142, column: 5, scope: !332)
!364 = !DILocation(line: 143, column: 5, scope: !332)
!365 = !DILocation(line: 144, column: 1, scope: !332)
!366 = distinct !DISubprogram(name: "cond_init", scope: !2, file: !2, line: 148, type: !367, scopeLine: 149, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!367 = !DISubroutineType(types: !368)
!368 = !{null, !369}
!369 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !130, size: 64)
!370 = !DILocalVariable(name: "cond", arg: 1, scope: !366, file: !2, line: 148, type: !369)
!371 = !DILocation(line: 148, column: 32, scope: !366)
!372 = !DILocalVariable(name: "status", scope: !366, file: !2, line: 150, type: !169)
!373 = !DILocation(line: 150, column: 9, scope: !366)
!374 = !DILocalVariable(name: "attr", scope: !366, file: !2, line: 151, type: !375)
!375 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_condattr_t", file: !376, line: 31, baseType: !377)
!376 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_condattr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "6a8d104d1f0f0413f6823c132bf5423e")
!377 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_condattr_t", file: !119, line: 111, baseType: !378)
!378 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_condattr_t", file: !119, line: 73, size: 128, elements: !379)
!379 = !{!380, !381}
!380 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !378, file: !119, line: 74, baseType: !123, size: 64)
!381 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !378, file: !119, line: 75, baseType: !44, size: 64, offset: 64)
!382 = !DILocation(line: 151, column: 24, scope: !366)
!383 = !DILocation(line: 153, column: 14, scope: !366)
!384 = !DILocation(line: 153, column: 12, scope: !366)
!385 = !DILocation(line: 154, column: 5, scope: !366)
!386 = !DILocation(line: 156, column: 32, scope: !366)
!387 = !DILocation(line: 156, column: 14, scope: !366)
!388 = !DILocation(line: 156, column: 12, scope: !366)
!389 = !DILocation(line: 157, column: 5, scope: !366)
!390 = !DILocation(line: 159, column: 14, scope: !366)
!391 = !DILocation(line: 159, column: 12, scope: !366)
!392 = !DILocation(line: 160, column: 5, scope: !366)
!393 = !DILocation(line: 161, column: 1, scope: !366)
!394 = distinct !DISubprogram(name: "cond_destroy", scope: !2, file: !2, line: 163, type: !367, scopeLine: 164, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!395 = !DILocalVariable(name: "cond", arg: 1, scope: !394, file: !2, line: 163, type: !369)
!396 = !DILocation(line: 163, column: 35, scope: !394)
!397 = !DILocalVariable(name: "status", scope: !394, file: !2, line: 165, type: !169)
!398 = !DILocation(line: 165, column: 9, scope: !394)
!399 = !DILocation(line: 165, column: 39, scope: !394)
!400 = !DILocation(line: 165, column: 18, scope: !394)
!401 = !DILocation(line: 166, column: 5, scope: !394)
!402 = !DILocation(line: 167, column: 1, scope: !394)
!403 = distinct !DISubprogram(name: "cond_signal", scope: !2, file: !2, line: 169, type: !367, scopeLine: 170, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!404 = !DILocalVariable(name: "cond", arg: 1, scope: !403, file: !2, line: 169, type: !369)
!405 = !DILocation(line: 169, column: 34, scope: !403)
!406 = !DILocalVariable(name: "status", scope: !403, file: !2, line: 171, type: !169)
!407 = !DILocation(line: 171, column: 9, scope: !403)
!408 = !DILocation(line: 171, column: 38, scope: !403)
!409 = !DILocation(line: 171, column: 18, scope: !403)
!410 = !DILocation(line: 172, column: 5, scope: !403)
!411 = !DILocation(line: 173, column: 1, scope: !403)
!412 = distinct !DISubprogram(name: "cond_broadcast", scope: !2, file: !2, line: 175, type: !367, scopeLine: 176, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!413 = !DILocalVariable(name: "cond", arg: 1, scope: !412, file: !2, line: 175, type: !369)
!414 = !DILocation(line: 175, column: 37, scope: !412)
!415 = !DILocalVariable(name: "status", scope: !412, file: !2, line: 177, type: !169)
!416 = !DILocation(line: 177, column: 9, scope: !412)
!417 = !DILocation(line: 177, column: 41, scope: !412)
!418 = !DILocation(line: 177, column: 18, scope: !412)
!419 = !DILocation(line: 178, column: 5, scope: !412)
!420 = !DILocation(line: 179, column: 1, scope: !412)
!421 = distinct !DISubprogram(name: "cond_wait", scope: !2, file: !2, line: 181, type: !422, scopeLine: 182, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!422 = !DISubroutineType(types: !423)
!423 = !{null, !369, !227}
!424 = !DILocalVariable(name: "cond", arg: 1, scope: !421, file: !2, line: 181, type: !369)
!425 = !DILocation(line: 181, column: 32, scope: !421)
!426 = !DILocalVariable(name: "lock", arg: 2, scope: !421, file: !2, line: 181, type: !227)
!427 = !DILocation(line: 181, column: 55, scope: !421)
!428 = !DILocalVariable(name: "status", scope: !421, file: !2, line: 183, type: !169)
!429 = !DILocation(line: 183, column: 9, scope: !421)
!430 = !DILocation(line: 183, column: 36, scope: !421)
!431 = !DILocation(line: 183, column: 42, scope: !421)
!432 = !DILocation(line: 183, column: 18, scope: !421)
!433 = !DILocation(line: 185, column: 1, scope: !421)
!434 = distinct !DISubprogram(name: "cond_timedwait", scope: !2, file: !2, line: 187, type: !435, scopeLine: 188, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!435 = !DISubroutineType(types: !436)
!436 = !{null, !369, !227, !437}
!437 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!438 = !DILocalVariable(name: "cond", arg: 1, scope: !434, file: !2, line: 187, type: !369)
!439 = !DILocation(line: 187, column: 37, scope: !434)
!440 = !DILocalVariable(name: "lock", arg: 2, scope: !434, file: !2, line: 187, type: !227)
!441 = !DILocation(line: 187, column: 60, scope: !434)
!442 = !DILocalVariable(name: "millis", arg: 3, scope: !434, file: !2, line: 187, type: !437)
!443 = !DILocation(line: 187, column: 76, scope: !434)
!444 = !DILocalVariable(name: "ts", scope: !434, file: !2, line: 190, type: !445)
!445 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !446, line: 33, size: 128, elements: !447)
!446 = !DIFile(filename: "/usr/local/include/sys/_types/_timespec.h", directory: "", checksumkind: CSK_MD5, checksum: "8d740567ad568a1ef1d70ccb6b1755cb")
!447 = !{!448, !451}
!448 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !445, file: !446, line: 35, baseType: !449, size: 64)
!449 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_time_t", file: !450, line: 143, baseType: !123)
!450 = !DIFile(filename: "/usr/local/include/i386/_types.h", directory: "", checksumkind: CSK_MD5, checksum: "eb9e401b3b97107c79f668bcc91916e5")
!451 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !445, file: !446, line: 36, baseType: !123, size: 64, offset: 64)
!452 = !DILocation(line: 190, column: 21, scope: !434)
!453 = !DILocation(line: 194, column: 11, scope: !434)
!454 = !DILocalVariable(name: "status", scope: !434, file: !2, line: 195, type: !169)
!455 = !DILocation(line: 195, column: 9, scope: !434)
!456 = !DILocation(line: 195, column: 41, scope: !434)
!457 = !DILocation(line: 195, column: 47, scope: !434)
!458 = !DILocation(line: 195, column: 18, scope: !434)
!459 = !DILocation(line: 196, column: 1, scope: !434)
!460 = distinct !DISubprogram(name: "cond_worker", scope: !2, file: !2, line: 202, type: !182, scopeLine: 203, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!461 = !DILocalVariable(name: "message", arg: 1, scope: !460, file: !2, line: 202, type: !64)
!462 = !DILocation(line: 202, column: 25, scope: !460)
!463 = !DILocalVariable(name: "idle", scope: !460, file: !2, line: 204, type: !313)
!464 = !DILocation(line: 204, column: 10, scope: !460)
!465 = !DILocation(line: 206, column: 9, scope: !466)
!466 = distinct !DILexicalBlock(scope: !460, file: !2, line: 205, column: 5)
!467 = !DILocation(line: 207, column: 9, scope: !466)
!468 = !DILocation(line: 208, column: 9, scope: !466)
!469 = !DILocation(line: 209, column: 9, scope: !466)
!470 = !DILocation(line: 210, column: 16, scope: !466)
!471 = !DILocation(line: 210, column: 22, scope: !466)
!472 = !DILocation(line: 210, column: 14, scope: !466)
!473 = !DILocation(line: 211, column: 9, scope: !466)
!474 = !DILocation(line: 213, column: 9, scope: !475)
!475 = distinct !DILexicalBlock(scope: !460, file: !2, line: 213, column: 9)
!476 = !DILocation(line: 213, column: 9, scope: !460)
!477 = !DILocation(line: 214, column: 25, scope: !475)
!478 = !DILocation(line: 214, column: 34, scope: !475)
!479 = !DILocation(line: 214, column: 9, scope: !475)
!480 = !DILocation(line: 215, column: 10, scope: !460)
!481 = !DILocation(line: 217, column: 9, scope: !482)
!482 = distinct !DILexicalBlock(scope: !460, file: !2, line: 216, column: 5)
!483 = !DILocation(line: 218, column: 9, scope: !482)
!484 = !DILocation(line: 219, column: 9, scope: !482)
!485 = !DILocation(line: 220, column: 9, scope: !482)
!486 = !DILocation(line: 221, column: 16, scope: !482)
!487 = !DILocation(line: 221, column: 22, scope: !482)
!488 = !DILocation(line: 221, column: 14, scope: !482)
!489 = !DILocation(line: 222, column: 9, scope: !482)
!490 = !DILocation(line: 224, column: 9, scope: !491)
!491 = distinct !DILexicalBlock(scope: !460, file: !2, line: 224, column: 9)
!492 = !DILocation(line: 224, column: 9, scope: !460)
!493 = !DILocation(line: 225, column: 25, scope: !491)
!494 = !DILocation(line: 225, column: 34, scope: !491)
!495 = !DILocation(line: 225, column: 9, scope: !491)
!496 = !DILocation(line: 226, column: 12, scope: !460)
!497 = !DILocation(line: 226, column: 5, scope: !460)
!498 = !DILocation(line: 227, column: 1, scope: !460)
!499 = distinct !DISubprogram(name: "cond_test", scope: !2, file: !2, line: 229, type: !333, scopeLine: 230, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!500 = !DILocalVariable(name: "message", scope: !499, file: !2, line: 231, type: !64)
!501 = !DILocation(line: 231, column: 11, scope: !499)
!502 = !DILocation(line: 232, column: 5, scope: !499)
!503 = !DILocation(line: 233, column: 5, scope: !499)
!504 = !DILocalVariable(name: "worker", scope: !499, file: !2, line: 235, type: !142)
!505 = !DILocation(line: 235, column: 15, scope: !499)
!506 = !DILocation(line: 235, column: 51, scope: !499)
!507 = !DILocation(line: 235, column: 24, scope: !499)
!508 = !DILocation(line: 238, column: 9, scope: !509)
!509 = distinct !DILexicalBlock(scope: !499, file: !2, line: 237, column: 5)
!510 = !DILocation(line: 239, column: 9, scope: !509)
!511 = !DILocation(line: 240, column: 9, scope: !509)
!512 = !DILocation(line: 241, column: 9, scope: !509)
!513 = !DILocation(line: 245, column: 9, scope: !514)
!514 = distinct !DILexicalBlock(scope: !499, file: !2, line: 244, column: 5)
!515 = !DILocation(line: 246, column: 9, scope: !514)
!516 = !DILocation(line: 247, column: 9, scope: !514)
!517 = !DILocation(line: 248, column: 9, scope: !514)
!518 = !DILocalVariable(name: "result", scope: !499, file: !2, line: 251, type: !64)
!519 = !DILocation(line: 251, column: 11, scope: !499)
!520 = !DILocation(line: 251, column: 32, scope: !499)
!521 = !DILocation(line: 251, column: 20, scope: !499)
!522 = !DILocation(line: 252, column: 5, scope: !499)
!523 = !DILocation(line: 254, column: 5, scope: !499)
!524 = !DILocation(line: 255, column: 5, scope: !499)
!525 = !DILocation(line: 256, column: 1, scope: !499)
!526 = distinct !DISubprogram(name: "rwlock_init", scope: !2, file: !2, line: 263, type: !527, scopeLine: 264, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!527 = !DISubroutineType(types: !528)
!528 = !{null, !529, !169}
!529 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !530, size: 64)
!530 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlock_t", file: !531, line: 31, baseType: !532)
!531 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_rwlock_t.h", directory: "", checksumkind: CSK_MD5, checksum: "90af75f8fbbfc12b61c909d26e0aa196")
!532 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_rwlock_t", file: !119, line: 116, baseType: !533)
!533 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_rwlock_t", file: !119, line: 93, size: 1600, elements: !534)
!534 = !{!535, !536}
!535 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !533, file: !119, line: 94, baseType: !123, size: 64)
!536 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !533, file: !119, line: 95, baseType: !537, size: 1536, offset: 64)
!537 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 1536, elements: !538)
!538 = !{!539}
!539 = !DISubrange(count: 192)
!540 = !DILocalVariable(name: "lock", arg: 1, scope: !526, file: !2, line: 263, type: !529)
!541 = !DILocation(line: 263, column: 36, scope: !526)
!542 = !DILocalVariable(name: "shared", arg: 2, scope: !526, file: !2, line: 263, type: !169)
!543 = !DILocation(line: 263, column: 46, scope: !526)
!544 = !DILocalVariable(name: "status", scope: !526, file: !2, line: 265, type: !169)
!545 = !DILocation(line: 265, column: 9, scope: !526)
!546 = !DILocalVariable(name: "value", scope: !526, file: !2, line: 266, type: !169)
!547 = !DILocation(line: 266, column: 9, scope: !526)
!548 = !DILocalVariable(name: "attributes", scope: !526, file: !2, line: 267, type: !549)
!549 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlockattr_t", file: !550, line: 31, baseType: !551)
!550 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_rwlockattr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "c5c5da82785d693a726632cb5d3a4f7e")
!551 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_rwlockattr_t", file: !119, line: 117, baseType: !552)
!552 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_rwlockattr_t", file: !119, line: 98, size: 192, elements: !553)
!553 = !{!554, !555}
!554 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !552, file: !119, line: 99, baseType: !123, size: 64)
!555 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !552, file: !119, line: 100, baseType: !556, size: 128, offset: 64)
!556 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 128, elements: !557)
!557 = !{!558}
!558 = !DISubrange(count: 16)
!559 = !DILocation(line: 267, column: 26, scope: !526)
!560 = !DILocation(line: 268, column: 14, scope: !526)
!561 = !DILocation(line: 268, column: 12, scope: !526)
!562 = !DILocation(line: 269, column: 5, scope: !526)
!563 = !DILocation(line: 271, column: 57, scope: !526)
!564 = !DILocation(line: 271, column: 14, scope: !526)
!565 = !DILocation(line: 271, column: 12, scope: !526)
!566 = !DILocation(line: 272, column: 5, scope: !526)
!567 = !DILocation(line: 273, column: 14, scope: !526)
!568 = !DILocation(line: 273, column: 12, scope: !526)
!569 = !DILocation(line: 274, column: 5, scope: !526)
!570 = !DILocation(line: 276, column: 34, scope: !526)
!571 = !DILocation(line: 276, column: 14, scope: !526)
!572 = !DILocation(line: 276, column: 12, scope: !526)
!573 = !DILocation(line: 277, column: 5, scope: !526)
!574 = !DILocation(line: 278, column: 14, scope: !526)
!575 = !DILocation(line: 278, column: 12, scope: !526)
!576 = !DILocation(line: 279, column: 5, scope: !526)
!577 = !DILocation(line: 280, column: 1, scope: !526)
!578 = distinct !DISubprogram(name: "rwlock_destroy", scope: !2, file: !2, line: 282, type: !579, scopeLine: 283, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!579 = !DISubroutineType(types: !580)
!580 = !{null, !529}
!581 = !DILocalVariable(name: "lock", arg: 1, scope: !578, file: !2, line: 282, type: !529)
!582 = !DILocation(line: 282, column: 39, scope: !578)
!583 = !DILocalVariable(name: "status", scope: !578, file: !2, line: 284, type: !169)
!584 = !DILocation(line: 284, column: 9, scope: !578)
!585 = !DILocation(line: 284, column: 41, scope: !578)
!586 = !DILocation(line: 284, column: 18, scope: !578)
!587 = !DILocation(line: 285, column: 5, scope: !578)
!588 = !DILocation(line: 286, column: 1, scope: !578)
!589 = distinct !DISubprogram(name: "rwlock_wrlock", scope: !2, file: !2, line: 288, type: !579, scopeLine: 289, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!590 = !DILocalVariable(name: "lock", arg: 1, scope: !589, file: !2, line: 288, type: !529)
!591 = !DILocation(line: 288, column: 38, scope: !589)
!592 = !DILocalVariable(name: "status", scope: !589, file: !2, line: 290, type: !169)
!593 = !DILocation(line: 290, column: 9, scope: !589)
!594 = !DILocation(line: 290, column: 40, scope: !589)
!595 = !DILocation(line: 290, column: 18, scope: !589)
!596 = !DILocation(line: 291, column: 5, scope: !589)
!597 = !DILocation(line: 292, column: 1, scope: !589)
!598 = distinct !DISubprogram(name: "rwlock_trywrlock", scope: !2, file: !2, line: 294, type: !599, scopeLine: 295, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!599 = !DISubroutineType(types: !600)
!600 = !{!313, !529}
!601 = !DILocalVariable(name: "lock", arg: 1, scope: !598, file: !2, line: 294, type: !529)
!602 = !DILocation(line: 294, column: 41, scope: !598)
!603 = !DILocalVariable(name: "status", scope: !598, file: !2, line: 296, type: !169)
!604 = !DILocation(line: 296, column: 9, scope: !598)
!605 = !DILocation(line: 296, column: 43, scope: !598)
!606 = !DILocation(line: 296, column: 18, scope: !598)
!607 = !DILocation(line: 298, column: 12, scope: !598)
!608 = !DILocation(line: 298, column: 19, scope: !598)
!609 = !DILocation(line: 298, column: 5, scope: !598)
!610 = distinct !DISubprogram(name: "rwlock_rdlock", scope: !2, file: !2, line: 301, type: !579, scopeLine: 302, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!611 = !DILocalVariable(name: "lock", arg: 1, scope: !610, file: !2, line: 301, type: !529)
!612 = !DILocation(line: 301, column: 38, scope: !610)
!613 = !DILocalVariable(name: "status", scope: !610, file: !2, line: 303, type: !169)
!614 = !DILocation(line: 303, column: 9, scope: !610)
!615 = !DILocation(line: 303, column: 40, scope: !610)
!616 = !DILocation(line: 303, column: 18, scope: !610)
!617 = !DILocation(line: 304, column: 5, scope: !610)
!618 = !DILocation(line: 305, column: 1, scope: !610)
!619 = distinct !DISubprogram(name: "rwlock_tryrdlock", scope: !2, file: !2, line: 307, type: !599, scopeLine: 308, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!620 = !DILocalVariable(name: "lock", arg: 1, scope: !619, file: !2, line: 307, type: !529)
!621 = !DILocation(line: 307, column: 41, scope: !619)
!622 = !DILocalVariable(name: "status", scope: !619, file: !2, line: 309, type: !169)
!623 = !DILocation(line: 309, column: 9, scope: !619)
!624 = !DILocation(line: 309, column: 43, scope: !619)
!625 = !DILocation(line: 309, column: 18, scope: !619)
!626 = !DILocation(line: 311, column: 12, scope: !619)
!627 = !DILocation(line: 311, column: 19, scope: !619)
!628 = !DILocation(line: 311, column: 5, scope: !619)
!629 = distinct !DISubprogram(name: "rwlock_unlock", scope: !2, file: !2, line: 314, type: !579, scopeLine: 315, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!630 = !DILocalVariable(name: "lock", arg: 1, scope: !629, file: !2, line: 314, type: !529)
!631 = !DILocation(line: 314, column: 38, scope: !629)
!632 = !DILocalVariable(name: "status", scope: !629, file: !2, line: 316, type: !169)
!633 = !DILocation(line: 316, column: 9, scope: !629)
!634 = !DILocation(line: 316, column: 40, scope: !629)
!635 = !DILocation(line: 316, column: 18, scope: !629)
!636 = !DILocation(line: 317, column: 5, scope: !629)
!637 = !DILocation(line: 318, column: 1, scope: !629)
!638 = distinct !DISubprogram(name: "rwlock_test", scope: !2, file: !2, line: 320, type: !333, scopeLine: 321, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!639 = !DILocalVariable(name: "lock", scope: !638, file: !2, line: 322, type: !530)
!640 = !DILocation(line: 322, column: 22, scope: !638)
!641 = !DILocation(line: 323, column: 5, scope: !638)
!642 = !DILocalVariable(name: "test_depth", scope: !638, file: !2, line: 324, type: !643)
!643 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !169)
!644 = !DILocation(line: 324, column: 15, scope: !638)
!645 = !DILocation(line: 327, column: 9, scope: !646)
!646 = distinct !DILexicalBlock(scope: !638, file: !2, line: 326, column: 5)
!647 = !DILocalVariable(name: "success", scope: !646, file: !2, line: 328, type: !313)
!648 = !DILocation(line: 328, column: 14, scope: !646)
!649 = !DILocation(line: 328, column: 24, scope: !646)
!650 = !DILocation(line: 329, column: 9, scope: !646)
!651 = !DILocation(line: 330, column: 19, scope: !646)
!652 = !DILocation(line: 330, column: 17, scope: !646)
!653 = !DILocation(line: 331, column: 9, scope: !646)
!654 = !DILocation(line: 332, column: 9, scope: !646)
!655 = !DILocation(line: 336, column: 9, scope: !656)
!656 = distinct !DILexicalBlock(scope: !638, file: !2, line: 335, column: 5)
!657 = !DILocalVariable(name: "i", scope: !658, file: !2, line: 337, type: !169)
!658 = distinct !DILexicalBlock(scope: !656, file: !2, line: 337, column: 9)
!659 = !DILocation(line: 337, column: 18, scope: !658)
!660 = !DILocation(line: 337, column: 14, scope: !658)
!661 = !DILocation(line: 337, column: 25, scope: !662)
!662 = distinct !DILexicalBlock(scope: !658, file: !2, line: 337, column: 9)
!663 = !DILocation(line: 337, column: 27, scope: !662)
!664 = !DILocation(line: 337, column: 9, scope: !658)
!665 = !DILocalVariable(name: "success", scope: !666, file: !2, line: 339, type: !313)
!666 = distinct !DILexicalBlock(scope: !662, file: !2, line: 338, column: 9)
!667 = !DILocation(line: 339, column: 18, scope: !666)
!668 = !DILocation(line: 339, column: 28, scope: !666)
!669 = !DILocation(line: 340, column: 13, scope: !666)
!670 = !DILocation(line: 341, column: 9, scope: !666)
!671 = !DILocation(line: 337, column: 42, scope: !662)
!672 = !DILocation(line: 337, column: 9, scope: !662)
!673 = distinct !{!673, !664, !674, !675}
!674 = !DILocation(line: 341, column: 9, scope: !658)
!675 = !{!"llvm.loop.mustprogress"}
!676 = !DILocalVariable(name: "success", scope: !677, file: !2, line: 344, type: !313)
!677 = distinct !DILexicalBlock(scope: !656, file: !2, line: 343, column: 9)
!678 = !DILocation(line: 344, column: 18, scope: !677)
!679 = !DILocation(line: 344, column: 28, scope: !677)
!680 = !DILocation(line: 345, column: 13, scope: !677)
!681 = !DILocation(line: 348, column: 9, scope: !656)
!682 = !DILocalVariable(name: "i", scope: !683, file: !2, line: 349, type: !169)
!683 = distinct !DILexicalBlock(scope: !656, file: !2, line: 349, column: 9)
!684 = !DILocation(line: 349, column: 18, scope: !683)
!685 = !DILocation(line: 349, column: 14, scope: !683)
!686 = !DILocation(line: 349, column: 25, scope: !687)
!687 = distinct !DILexicalBlock(scope: !683, file: !2, line: 349, column: 9)
!688 = !DILocation(line: 349, column: 27, scope: !687)
!689 = !DILocation(line: 349, column: 9, scope: !683)
!690 = !DILocation(line: 350, column: 13, scope: !691)
!691 = distinct !DILexicalBlock(scope: !687, file: !2, line: 349, column: 46)
!692 = !DILocation(line: 351, column: 9, scope: !691)
!693 = !DILocation(line: 349, column: 42, scope: !687)
!694 = !DILocation(line: 349, column: 9, scope: !687)
!695 = distinct !{!695, !689, !696, !675}
!696 = !DILocation(line: 351, column: 9, scope: !683)
!697 = !DILocation(line: 355, column: 9, scope: !698)
!698 = distinct !DILexicalBlock(scope: !638, file: !2, line: 354, column: 5)
!699 = !DILocalVariable(name: "success", scope: !698, file: !2, line: 356, type: !313)
!700 = !DILocation(line: 356, column: 14, scope: !698)
!701 = !DILocation(line: 356, column: 24, scope: !698)
!702 = !DILocation(line: 357, column: 9, scope: !698)
!703 = !DILocation(line: 358, column: 9, scope: !698)
!704 = !DILocation(line: 361, column: 5, scope: !638)
!705 = !DILocation(line: 362, column: 1, scope: !638)
!706 = distinct !DISubprogram(name: "key_destroy", scope: !2, file: !2, line: 369, type: !155, scopeLine: 370, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!707 = !DILocalVariable(name: "unused_value", arg: 1, scope: !706, file: !2, line: 369, type: !64)
!708 = !DILocation(line: 369, column: 24, scope: !706)
!709 = !DILocation(line: 371, column: 21, scope: !706)
!710 = !DILocation(line: 371, column: 19, scope: !706)
!711 = !DILocation(line: 372, column: 1, scope: !706)
!712 = distinct !DISubprogram(name: "key_worker", scope: !2, file: !2, line: 374, type: !182, scopeLine: 375, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!713 = !DILocalVariable(name: "message", arg: 1, scope: !712, file: !2, line: 374, type: !64)
!714 = !DILocation(line: 374, column: 24, scope: !712)
!715 = !DILocalVariable(name: "my_secret", scope: !712, file: !2, line: 376, type: !169)
!716 = !DILocation(line: 376, column: 9, scope: !712)
!717 = !DILocalVariable(name: "status", scope: !712, file: !2, line: 378, type: !169)
!718 = !DILocation(line: 378, column: 9, scope: !712)
!719 = !DILocation(line: 378, column: 38, scope: !712)
!720 = !DILocation(line: 378, column: 18, scope: !712)
!721 = !DILocation(line: 379, column: 5, scope: !712)
!722 = !DILocalVariable(name: "my_local_data", scope: !712, file: !2, line: 381, type: !64)
!723 = !DILocation(line: 381, column: 11, scope: !712)
!724 = !DILocation(line: 381, column: 47, scope: !712)
!725 = !DILocation(line: 381, column: 27, scope: !712)
!726 = !DILocation(line: 382, column: 5, scope: !712)
!727 = !DILocation(line: 384, column: 12, scope: !712)
!728 = !DILocation(line: 384, column: 5, scope: !712)
!729 = distinct !DISubprogram(name: "key_test", scope: !2, file: !2, line: 387, type: !333, scopeLine: 388, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!730 = !DILocalVariable(name: "my_secret", scope: !729, file: !2, line: 389, type: !169)
!731 = !DILocation(line: 389, column: 9, scope: !729)
!732 = !DILocalVariable(name: "message", scope: !729, file: !2, line: 390, type: !64)
!733 = !DILocation(line: 390, column: 11, scope: !729)
!734 = !DILocalVariable(name: "status", scope: !729, file: !2, line: 391, type: !169)
!735 = !DILocation(line: 391, column: 9, scope: !729)
!736 = !DILocation(line: 393, column: 5, scope: !729)
!737 = !DILocalVariable(name: "worker", scope: !729, file: !2, line: 395, type: !142)
!738 = !DILocation(line: 395, column: 15, scope: !729)
!739 = !DILocation(line: 395, column: 50, scope: !729)
!740 = !DILocation(line: 395, column: 24, scope: !729)
!741 = !DILocation(line: 397, column: 34, scope: !729)
!742 = !DILocation(line: 397, column: 14, scope: !729)
!743 = !DILocation(line: 397, column: 12, scope: !729)
!744 = !DILocation(line: 398, column: 5, scope: !729)
!745 = !DILocalVariable(name: "my_local_data", scope: !729, file: !2, line: 400, type: !64)
!746 = !DILocation(line: 400, column: 11, scope: !729)
!747 = !DILocation(line: 400, column: 47, scope: !729)
!748 = !DILocation(line: 400, column: 27, scope: !729)
!749 = !DILocation(line: 401, column: 5, scope: !729)
!750 = !DILocation(line: 403, column: 34, scope: !729)
!751 = !DILocation(line: 403, column: 14, scope: !729)
!752 = !DILocation(line: 403, column: 12, scope: !729)
!753 = !DILocation(line: 404, column: 5, scope: !729)
!754 = !DILocalVariable(name: "result", scope: !729, file: !2, line: 406, type: !64)
!755 = !DILocation(line: 406, column: 11, scope: !729)
!756 = !DILocation(line: 406, column: 32, scope: !729)
!757 = !DILocation(line: 406, column: 20, scope: !729)
!758 = !DILocation(line: 407, column: 5, scope: !729)
!759 = !DILocation(line: 409, column: 33, scope: !729)
!760 = !DILocation(line: 409, column: 14, scope: !729)
!761 = !DILocation(line: 409, column: 12, scope: !729)
!762 = !DILocation(line: 410, column: 5, scope: !729)
!763 = !DILocation(line: 413, column: 1, scope: !729)
!764 = distinct !DISubprogram(name: "detach_test_worker0", scope: !2, file: !2, line: 417, type: !182, scopeLine: 418, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!765 = !DILocalVariable(name: "ignore", arg: 1, scope: !764, file: !2, line: 417, type: !64)
!766 = !DILocation(line: 417, column: 33, scope: !764)
!767 = !DILocation(line: 419, column: 5, scope: !764)
!768 = distinct !DISubprogram(name: "detach_test_detach", scope: !2, file: !2, line: 422, type: !182, scopeLine: 423, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!769 = !DILocalVariable(name: "ignore", arg: 1, scope: !768, file: !2, line: 422, type: !64)
!770 = !DILocation(line: 422, column: 32, scope: !768)
!771 = !DILocalVariable(name: "status", scope: !768, file: !2, line: 424, type: !169)
!772 = !DILocation(line: 424, column: 9, scope: !768)
!773 = !DILocalVariable(name: "w0", scope: !768, file: !2, line: 425, type: !142)
!774 = !DILocation(line: 425, column: 15, scope: !768)
!775 = !DILocation(line: 425, column: 20, scope: !768)
!776 = !DILocation(line: 426, column: 29, scope: !768)
!777 = !DILocation(line: 426, column: 14, scope: !768)
!778 = !DILocation(line: 426, column: 12, scope: !768)
!779 = !DILocation(line: 427, column: 5, scope: !768)
!780 = !DILocation(line: 429, column: 27, scope: !768)
!781 = !DILocation(line: 429, column: 14, scope: !768)
!782 = !DILocation(line: 429, column: 12, scope: !768)
!783 = !DILocation(line: 430, column: 5, scope: !768)
!784 = !DILocation(line: 431, column: 5, scope: !768)
!785 = distinct !DISubprogram(name: "detach_test_attr", scope: !2, file: !2, line: 434, type: !182, scopeLine: 435, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !184)
!786 = !DILocalVariable(name: "ignore", arg: 1, scope: !785, file: !2, line: 434, type: !64)
!787 = !DILocation(line: 434, column: 30, scope: !785)
!788 = !DILocalVariable(name: "status", scope: !785, file: !2, line: 436, type: !169)
!789 = !DILocation(line: 436, column: 9, scope: !785)
!790 = !DILocalVariable(name: "detachstate", scope: !785, file: !2, line: 437, type: !169)
!791 = !DILocation(line: 437, column: 9, scope: !785)
!792 = !DILocalVariable(name: "w0", scope: !785, file: !2, line: 438, type: !142)
!793 = !DILocation(line: 438, column: 15, scope: !785)
!794 = !DILocalVariable(name: "w0_attr", scope: !785, file: !2, line: 439, type: !192)
!795 = !DILocation(line: 439, column: 20, scope: !785)
!796 = !DILocation(line: 440, column: 14, scope: !785)
!797 = !DILocation(line: 440, column: 12, scope: !785)
!798 = !DILocation(line: 441, column: 5, scope: !785)
!799 = !DILocation(line: 442, column: 14, scope: !785)
!800 = !DILocation(line: 442, column: 12, scope: !785)
!801 = !DILocation(line: 443, column: 5, scope: !785)
!802 = !DILocation(line: 0, scope: !785)
!803 = !DILocation(line: 444, column: 14, scope: !785)
!804 = !DILocation(line: 444, column: 12, scope: !785)
!805 = !DILocation(line: 445, column: 5, scope: !785)
!806 = !DILocation(line: 446, column: 14, scope: !785)
!807 = !DILocation(line: 446, column: 12, scope: !785)
!808 = !DILocation(line: 447, column: 5, scope: !785)
!809 = !DILocation(line: 448, column: 14, scope: !785)
!810 = !DILocation(line: 448, column: 12, scope: !785)
!811 = !DILocation(line: 449, column: 5, scope: !785)
!812 = !DILocation(line: 450, column: 5, scope: !785)
!813 = !DILocation(line: 452, column: 27, scope: !785)
!814 = !DILocation(line: 452, column: 14, scope: !785)
!815 = !DILocation(line: 452, column: 12, scope: !785)
!816 = !DILocation(line: 453, column: 5, scope: !785)
!817 = !DILocation(line: 454, column: 5, scope: !785)
!818 = distinct !DISubprogram(name: "detach_test", scope: !2, file: !2, line: 457, type: !333, scopeLine: 458, spFlags: DISPFlagDefinition, unit: !61)
!819 = !DILocation(line: 459, column: 5, scope: !818)
!820 = !DILocation(line: 460, column: 5, scope: !818)
!821 = !DILocation(line: 461, column: 1, scope: !818)
!822 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 463, type: !823, scopeLine: 464, spFlags: DISPFlagDefinition, unit: !61)
!823 = !DISubroutineType(types: !824)
!824 = !{!169}
!825 = !DILocation(line: 465, column: 5, scope: !822)
!826 = !DILocation(line: 466, column: 5, scope: !822)
!827 = !DILocation(line: 467, column: 5, scope: !822)
!828 = !DILocation(line: 468, column: 5, scope: !822)
!829 = !DILocation(line: 469, column: 5, scope: !822)
!830 = !DILocation(line: 470, column: 1, scope: !822)
