; ModuleID = 'benchmarks/miscellaneous/pthread.c'
source_filename = "benchmarks/miscellaneous/pthread.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

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
@phase = global i32 0, align 4, !dbg !59
@cond_mutex = global %struct._opaque_pthread_mutex_t zeroinitializer, align 8, !dbg !111
@cond = global %struct._opaque_pthread_cond_t zeroinitializer, align 8, !dbg !125
@__func__.cond_test = private unnamed_addr constant [10 x i8] c"cond_test\00", align 1, !dbg !66
@.str.4 = private unnamed_addr constant [18 x i8] c"result == message\00", align 1, !dbg !68
@__func__.rwlock_init = private unnamed_addr constant [12 x i8] c"rwlock_init\00", align 1, !dbg !73
@__func__.rwlock_destroy = private unnamed_addr constant [15 x i8] c"rwlock_destroy\00", align 1, !dbg !75
@__func__.rwlock_wrlock = private unnamed_addr constant [14 x i8] c"rwlock_wrlock\00", align 1, !dbg !77
@__func__.rwlock_rdlock = private unnamed_addr constant [14 x i8] c"rwlock_rdlock\00", align 1, !dbg !79
@__func__.rwlock_unlock = private unnamed_addr constant [14 x i8] c"rwlock_unlock\00", align 1, !dbg !81
@__func__.rwlock_test = private unnamed_addr constant [12 x i8] c"rwlock_test\00", align 1, !dbg !83
@latest_thread = global ptr null, align 8, !dbg !137
@local_data = global i64 0, align 8, !dbg !160
@__func__.key_worker = private unnamed_addr constant [11 x i8] c"key_worker\00", align 1, !dbg !85
@.str.5 = private unnamed_addr constant [28 x i8] c"my_local_data == &my_secret\00", align 1, !dbg !87
@__func__.key_test = private unnamed_addr constant [9 x i8] c"key_test\00", align 1, !dbg !92
@__func__.detach_test_detach = private unnamed_addr constant [19 x i8] c"detach_test_detach\00", align 1, !dbg !95
@.str.6 = private unnamed_addr constant [17 x i8] c"join_status != 0\00", align 1, !dbg !100
@__func__.detach_test_attr = private unnamed_addr constant [17 x i8] c"detach_test_attr\00", align 1, !dbg !105
@.str.7 = private unnamed_addr constant [19 x i8] c"create_status == 0\00", align 1, !dbg !108

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_create(ptr noundef %0, ptr noundef %1) #0 !dbg !174 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca %struct._opaque_pthread_attr_t, align 8
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !181, !DIExpression(), !182)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !183, !DIExpression(), !184)
    #dbg_declare(ptr %5, !185, !DIExpression(), !186)
    #dbg_declare(ptr %6, !187, !DIExpression(), !195)
  %8 = call i32 @pthread_attr_init(ptr noundef %6), !dbg !196
    #dbg_declare(ptr %7, !197, !DIExpression(), !198)
  %9 = load ptr, ptr %3, align 8, !dbg !199
  %10 = load ptr, ptr %4, align 8, !dbg !200
  %11 = call i32 @pthread_create(ptr noundef %5, ptr noundef %6, ptr noundef %9, ptr noundef %10), !dbg !201
  store i32 %11, ptr %7, align 4, !dbg !198
  %12 = load i32, ptr %7, align 4, !dbg !202
  %13 = icmp eq i32 %12, 0, !dbg !202
  %14 = xor i1 %13, true, !dbg !202
  %15 = zext i1 %14 to i32, !dbg !202
  %16 = sext i32 %15 to i64, !dbg !202
  %17 = icmp ne i64 %16, 0, !dbg !202
  br i1 %17, label %18, label %20, !dbg !202

18:                                               ; preds = %2
  call void @__assert_rtn(ptr noundef @__func__.thread_create, ptr noundef @.str, i32 noundef 18, ptr noundef @.str.1) #3, !dbg !202
  unreachable, !dbg !202

19:                                               ; No predecessors!
  br label %21, !dbg !202

20:                                               ; preds = %2
  br label %21, !dbg !202

21:                                               ; preds = %20, %19
  %22 = call i32 @pthread_attr_destroy(ptr noundef %6), !dbg !203
  %23 = load ptr, ptr %5, align 8, !dbg !204
  ret ptr %23, !dbg !205
}

declare i32 @pthread_attr_init(ptr noundef) #1

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

declare i32 @pthread_attr_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_join(ptr noundef %0) #0 !dbg !206 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !209, !DIExpression(), !210)
    #dbg_declare(ptr %3, !211, !DIExpression(), !212)
    #dbg_declare(ptr %4, !213, !DIExpression(), !214)
  %5 = load ptr, ptr %2, align 8, !dbg !215
  %6 = call i32 @"\01_pthread_join"(ptr noundef %5, ptr noundef %3), !dbg !216
  store i32 %6, ptr %4, align 4, !dbg !214
  %7 = load i32, ptr %4, align 4, !dbg !217
  %8 = icmp eq i32 %7, 0, !dbg !217
  %9 = xor i1 %8, true, !dbg !217
  %10 = zext i1 %9 to i32, !dbg !217
  %11 = sext i32 %10 to i64, !dbg !217
  %12 = icmp ne i64 %11, 0, !dbg !217
  br i1 %12, label %13, label %15, !dbg !217

13:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.thread_join, ptr noundef @.str, i32 noundef 27, ptr noundef @.str.1) #3, !dbg !217
  unreachable, !dbg !217

14:                                               ; No predecessors!
  br label %16, !dbg !217

15:                                               ; preds = %1
  br label %16, !dbg !217

16:                                               ; preds = %15, %14
  %17 = load ptr, ptr %3, align 8, !dbg !218
  ret ptr %17, !dbg !219
}

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @mutex_init(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) #0 !dbg !220 {
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca %struct._opaque_pthread_mutexattr_t, align 8
  store ptr %0, ptr %6, align 8
    #dbg_declare(ptr %6, !224, !DIExpression(), !225)
  store i32 %1, ptr %7, align 4
    #dbg_declare(ptr %7, !226, !DIExpression(), !227)
  store i32 %2, ptr %8, align 4
    #dbg_declare(ptr %8, !228, !DIExpression(), !229)
  store i32 %3, ptr %9, align 4
    #dbg_declare(ptr %9, !230, !DIExpression(), !231)
  store i32 %4, ptr %10, align 4
    #dbg_declare(ptr %10, !232, !DIExpression(), !233)
    #dbg_declare(ptr %11, !234, !DIExpression(), !235)
    #dbg_declare(ptr %12, !236, !DIExpression(), !237)
    #dbg_declare(ptr %13, !238, !DIExpression(), !246)
  %14 = call i32 @pthread_mutexattr_init(ptr noundef %13), !dbg !247
  store i32 %14, ptr %11, align 4, !dbg !248
  %15 = load i32, ptr %11, align 4, !dbg !249
  %16 = icmp eq i32 %15, 0, !dbg !249
  %17 = xor i1 %16, true, !dbg !249
  %18 = zext i1 %17 to i32, !dbg !249
  %19 = sext i32 %18 to i64, !dbg !249
  %20 = icmp ne i64 %19, 0, !dbg !249
  br i1 %20, label %21, label %23, !dbg !249

21:                                               ; preds = %5
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 49, ptr noundef @.str.1) #3, !dbg !249
  unreachable, !dbg !249

22:                                               ; No predecessors!
  br label %24, !dbg !249

23:                                               ; preds = %5
  br label %24, !dbg !249

24:                                               ; preds = %23, %22
  %25 = load i32, ptr %7, align 4, !dbg !250
  %26 = call i32 @pthread_mutexattr_settype(ptr noundef %13, i32 noundef %25), !dbg !251
  store i32 %26, ptr %11, align 4, !dbg !252
  %27 = load i32, ptr %11, align 4, !dbg !253
  %28 = icmp eq i32 %27, 0, !dbg !253
  %29 = xor i1 %28, true, !dbg !253
  %30 = zext i1 %29 to i32, !dbg !253
  %31 = sext i32 %30 to i64, !dbg !253
  %32 = icmp ne i64 %31, 0, !dbg !253
  br i1 %32, label %33, label %35, !dbg !253

33:                                               ; preds = %24
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 52, ptr noundef @.str.1) #3, !dbg !253
  unreachable, !dbg !253

34:                                               ; No predecessors!
  br label %36, !dbg !253

35:                                               ; preds = %24
  br label %36, !dbg !253

36:                                               ; preds = %35, %34
  %37 = call i32 @pthread_mutexattr_gettype(ptr noundef %13, ptr noundef %12), !dbg !254
  store i32 %37, ptr %11, align 4, !dbg !255
  %38 = load i32, ptr %11, align 4, !dbg !256
  %39 = icmp eq i32 %38, 0, !dbg !256
  %40 = xor i1 %39, true, !dbg !256
  %41 = zext i1 %40 to i32, !dbg !256
  %42 = sext i32 %41 to i64, !dbg !256
  %43 = icmp ne i64 %42, 0, !dbg !256
  br i1 %43, label %44, label %46, !dbg !256

44:                                               ; preds = %36
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 54, ptr noundef @.str.1) #3, !dbg !256
  unreachable, !dbg !256

45:                                               ; No predecessors!
  br label %47, !dbg !256

46:                                               ; preds = %36
  br label %47, !dbg !256

47:                                               ; preds = %46, %45
  %48 = load i32, ptr %8, align 4, !dbg !257
  %49 = call i32 @pthread_mutexattr_setprotocol(ptr noundef %13, i32 noundef %48), !dbg !258
  store i32 %49, ptr %11, align 4, !dbg !259
  %50 = load i32, ptr %11, align 4, !dbg !260
  %51 = icmp eq i32 %50, 0, !dbg !260
  %52 = xor i1 %51, true, !dbg !260
  %53 = zext i1 %52 to i32, !dbg !260
  %54 = sext i32 %53 to i64, !dbg !260
  %55 = icmp ne i64 %54, 0, !dbg !260
  br i1 %55, label %56, label %58, !dbg !260

56:                                               ; preds = %47
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 57, ptr noundef @.str.1) #3, !dbg !260
  unreachable, !dbg !260

57:                                               ; No predecessors!
  br label %59, !dbg !260

58:                                               ; preds = %47
  br label %59, !dbg !260

59:                                               ; preds = %58, %57
  %60 = call i32 @pthread_mutexattr_getprotocol(ptr noundef %13, ptr noundef %12), !dbg !261
  store i32 %60, ptr %11, align 4, !dbg !262
  %61 = load i32, ptr %11, align 4, !dbg !263
  %62 = icmp eq i32 %61, 0, !dbg !263
  %63 = xor i1 %62, true, !dbg !263
  %64 = zext i1 %63 to i32, !dbg !263
  %65 = sext i32 %64 to i64, !dbg !263
  %66 = icmp ne i64 %65, 0, !dbg !263
  br i1 %66, label %67, label %69, !dbg !263

67:                                               ; preds = %59
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 59, ptr noundef @.str.1) #3, !dbg !263
  unreachable, !dbg !263

68:                                               ; No predecessors!
  br label %70, !dbg !263

69:                                               ; preds = %59
  br label %70, !dbg !263

70:                                               ; preds = %69, %68
  %71 = load i32, ptr %9, align 4, !dbg !264
  %72 = call i32 @pthread_mutexattr_setpolicy_np(ptr noundef %13, i32 noundef %71), !dbg !265
  store i32 %72, ptr %11, align 4, !dbg !266
  %73 = load i32, ptr %11, align 4, !dbg !267
  %74 = icmp eq i32 %73, 0, !dbg !267
  %75 = xor i1 %74, true, !dbg !267
  %76 = zext i1 %75 to i32, !dbg !267
  %77 = sext i32 %76 to i64, !dbg !267
  %78 = icmp ne i64 %77, 0, !dbg !267
  br i1 %78, label %79, label %81, !dbg !267

79:                                               ; preds = %70
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 62, ptr noundef @.str.1) #3, !dbg !267
  unreachable, !dbg !267

80:                                               ; No predecessors!
  br label %82, !dbg !267

81:                                               ; preds = %70
  br label %82, !dbg !267

82:                                               ; preds = %81, %80
  %83 = call i32 @pthread_mutexattr_getpolicy_np(ptr noundef %13, ptr noundef %12), !dbg !268
  store i32 %83, ptr %11, align 4, !dbg !269
  %84 = load i32, ptr %11, align 4, !dbg !270
  %85 = icmp eq i32 %84, 0, !dbg !270
  %86 = xor i1 %85, true, !dbg !270
  %87 = zext i1 %86 to i32, !dbg !270
  %88 = sext i32 %87 to i64, !dbg !270
  %89 = icmp ne i64 %88, 0, !dbg !270
  br i1 %89, label %90, label %92, !dbg !270

90:                                               ; preds = %82
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 64, ptr noundef @.str.1) #3, !dbg !270
  unreachable, !dbg !270

91:                                               ; No predecessors!
  br label %93, !dbg !270

92:                                               ; preds = %82
  br label %93, !dbg !270

93:                                               ; preds = %92, %91
  %94 = load i32, ptr %10, align 4, !dbg !271
  %95 = call i32 @pthread_mutexattr_setprioceiling(ptr noundef %13, i32 noundef %94), !dbg !272
  store i32 %95, ptr %11, align 4, !dbg !273
  %96 = load i32, ptr %11, align 4, !dbg !274
  %97 = icmp eq i32 %96, 0, !dbg !274
  %98 = xor i1 %97, true, !dbg !274
  %99 = zext i1 %98 to i32, !dbg !274
  %100 = sext i32 %99 to i64, !dbg !274
  %101 = icmp ne i64 %100, 0, !dbg !274
  br i1 %101, label %102, label %104, !dbg !274

102:                                              ; preds = %93
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 67, ptr noundef @.str.1) #3, !dbg !274
  unreachable, !dbg !274

103:                                              ; No predecessors!
  br label %105, !dbg !274

104:                                              ; preds = %93
  br label %105, !dbg !274

105:                                              ; preds = %104, %103
  %106 = call i32 @pthread_mutexattr_getprioceiling(ptr noundef %13, ptr noundef %12), !dbg !275
  store i32 %106, ptr %11, align 4, !dbg !276
  %107 = load i32, ptr %11, align 4, !dbg !277
  %108 = icmp eq i32 %107, 0, !dbg !277
  %109 = xor i1 %108, true, !dbg !277
  %110 = zext i1 %109 to i32, !dbg !277
  %111 = sext i32 %110 to i64, !dbg !277
  %112 = icmp ne i64 %111, 0, !dbg !277
  br i1 %112, label %113, label %115, !dbg !277

113:                                              ; preds = %105
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 69, ptr noundef @.str.1) #3, !dbg !277
  unreachable, !dbg !277

114:                                              ; No predecessors!
  br label %116, !dbg !277

115:                                              ; preds = %105
  br label %116, !dbg !277

116:                                              ; preds = %115, %114
  %117 = load ptr, ptr %6, align 8, !dbg !278
  %118 = call i32 @pthread_mutex_init(ptr noundef %117, ptr noundef %13), !dbg !279
  store i32 %118, ptr %11, align 4, !dbg !280
  %119 = load i32, ptr %11, align 4, !dbg !281
  %120 = icmp eq i32 %119, 0, !dbg !281
  %121 = xor i1 %120, true, !dbg !281
  %122 = zext i1 %121 to i32, !dbg !281
  %123 = sext i32 %122 to i64, !dbg !281
  %124 = icmp ne i64 %123, 0, !dbg !281
  br i1 %124, label %125, label %127, !dbg !281

125:                                              ; preds = %116
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 72, ptr noundef @.str.1) #3, !dbg !281
  unreachable, !dbg !281

126:                                              ; No predecessors!
  br label %128, !dbg !281

127:                                              ; preds = %116
  br label %128, !dbg !281

128:                                              ; preds = %127, %126
  %129 = call i32 @"\01_pthread_mutexattr_destroy"(ptr noundef %13), !dbg !282
  store i32 %129, ptr %11, align 4, !dbg !283
  %130 = load i32, ptr %11, align 4, !dbg !284
  %131 = icmp eq i32 %130, 0, !dbg !284
  %132 = xor i1 %131, true, !dbg !284
  %133 = zext i1 %132 to i32, !dbg !284
  %134 = sext i32 %133 to i64, !dbg !284
  %135 = icmp ne i64 %134, 0, !dbg !284
  br i1 %135, label %136, label %138, !dbg !284

136:                                              ; preds = %128
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 74, ptr noundef @.str.1) #3, !dbg !284
  unreachable, !dbg !284

137:                                              ; No predecessors!
  br label %139, !dbg !284

138:                                              ; preds = %128
  br label %139, !dbg !284

139:                                              ; preds = %138, %137
  ret void, !dbg !285
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

declare i32 @"\01_pthread_mutexattr_destroy"(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @mutex_destroy(ptr noundef %0) #0 !dbg !286 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !289, !DIExpression(), !290)
    #dbg_declare(ptr %3, !291, !DIExpression(), !292)
  %4 = load ptr, ptr %2, align 8, !dbg !293
  %5 = call i32 @pthread_mutex_destroy(ptr noundef %4), !dbg !294
  store i32 %5, ptr %3, align 4, !dbg !292
  %6 = load i32, ptr %3, align 4, !dbg !295
  %7 = icmp eq i32 %6, 0, !dbg !295
  %8 = xor i1 %7, true, !dbg !295
  %9 = zext i1 %8 to i32, !dbg !295
  %10 = sext i32 %9 to i64, !dbg !295
  %11 = icmp ne i64 %10, 0, !dbg !295
  br i1 %11, label %12, label %14, !dbg !295

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_destroy, ptr noundef @.str, i32 noundef 80, ptr noundef @.str.1) #3, !dbg !295
  unreachable, !dbg !295

13:                                               ; No predecessors!
  br label %15, !dbg !295

14:                                               ; preds = %1
  br label %15, !dbg !295

15:                                               ; preds = %14, %13
  ret void, !dbg !296
}

declare i32 @pthread_mutex_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @mutex_lock(ptr noundef %0) #0 !dbg !297 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !298, !DIExpression(), !299)
    #dbg_declare(ptr %3, !300, !DIExpression(), !301)
  %4 = load ptr, ptr %2, align 8, !dbg !302
  %5 = call i32 @pthread_mutex_lock(ptr noundef %4), !dbg !303
  store i32 %5, ptr %3, align 4, !dbg !301
  %6 = load i32, ptr %3, align 4, !dbg !304
  %7 = icmp eq i32 %6, 0, !dbg !304
  %8 = xor i1 %7, true, !dbg !304
  %9 = zext i1 %8 to i32, !dbg !304
  %10 = sext i32 %9 to i64, !dbg !304
  %11 = icmp ne i64 %10, 0, !dbg !304
  br i1 %11, label %12, label %14, !dbg !304

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_lock, ptr noundef @.str, i32 noundef 86, ptr noundef @.str.1) #3, !dbg !304
  unreachable, !dbg !304

13:                                               ; No predecessors!
  br label %15, !dbg !304

14:                                               ; preds = %1
  br label %15, !dbg !304

15:                                               ; preds = %14, %13
  ret void, !dbg !305
}

declare i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define zeroext i1 @mutex_trylock(ptr noundef %0) #0 !dbg !306 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !310, !DIExpression(), !311)
    #dbg_declare(ptr %3, !312, !DIExpression(), !313)
  %4 = load ptr, ptr %2, align 8, !dbg !314
  %5 = call i32 @pthread_mutex_trylock(ptr noundef %4), !dbg !315
  store i32 %5, ptr %3, align 4, !dbg !313
  %6 = load i32, ptr %3, align 4, !dbg !316
  %7 = icmp eq i32 %6, 0, !dbg !317
  ret i1 %7, !dbg !318
}

declare i32 @pthread_mutex_trylock(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @mutex_unlock(ptr noundef %0) #0 !dbg !319 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !320, !DIExpression(), !321)
    #dbg_declare(ptr %3, !322, !DIExpression(), !323)
  %4 = load ptr, ptr %2, align 8, !dbg !324
  %5 = call i32 @pthread_mutex_unlock(ptr noundef %4), !dbg !325
  store i32 %5, ptr %3, align 4, !dbg !323
  %6 = load i32, ptr %3, align 4, !dbg !326
  %7 = icmp eq i32 %6, 0, !dbg !326
  %8 = xor i1 %7, true, !dbg !326
  %9 = zext i1 %8 to i32, !dbg !326
  %10 = sext i32 %9 to i64, !dbg !326
  %11 = icmp ne i64 %10, 0, !dbg !326
  br i1 %11, label %12, label %14, !dbg !326

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_unlock, ptr noundef @.str, i32 noundef 99, ptr noundef @.str.1) #3, !dbg !326
  unreachable, !dbg !326

13:                                               ; No predecessors!
  br label %15, !dbg !326

14:                                               ; preds = %1
  br label %15, !dbg !326

15:                                               ; preds = %14, %13
  ret void, !dbg !327
}

declare i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @mutex_test() #0 !dbg !328 {
  %1 = alloca %struct._opaque_pthread_mutex_t, align 8
  %2 = alloca %struct._opaque_pthread_mutex_t, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  %5 = alloca i8, align 1
    #dbg_declare(ptr %1, !331, !DIExpression(), !332)
    #dbg_declare(ptr %2, !333, !DIExpression(), !334)
  call void @mutex_init(ptr noundef %1, i32 noundef 1, i32 noundef 1, i32 noundef 1, i32 noundef 1), !dbg !335
  call void @mutex_init(ptr noundef %2, i32 noundef 2, i32 noundef 2, i32 noundef 3, i32 noundef 2), !dbg !336
  call void @mutex_lock(ptr noundef %1), !dbg !337
    #dbg_declare(ptr %3, !339, !DIExpression(), !340)
  %6 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !341
  %7 = zext i1 %6 to i8, !dbg !340
  store i8 %7, ptr %3, align 1, !dbg !340
  %8 = load i8, ptr %3, align 1, !dbg !342
  %9 = trunc i8 %8 to i1, !dbg !342
  %10 = xor i1 %9, true, !dbg !342
  %11 = xor i1 %10, true, !dbg !342
  %12 = zext i1 %11 to i32, !dbg !342
  %13 = sext i32 %12 to i64, !dbg !342
  %14 = icmp ne i64 %13, 0, !dbg !342
  br i1 %14, label %15, label %17, !dbg !342

15:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 113, ptr noundef @.str.2) #3, !dbg !342
  unreachable, !dbg !342

16:                                               ; No predecessors!
  br label %18, !dbg !342

17:                                               ; preds = %0
  br label %18, !dbg !342

18:                                               ; preds = %17, %16
  call void @mutex_unlock(ptr noundef %1), !dbg !343
  call void @mutex_lock(ptr noundef %2), !dbg !344
    #dbg_declare(ptr %4, !346, !DIExpression(), !348)
  %19 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !349
  %20 = zext i1 %19 to i8, !dbg !348
  store i8 %20, ptr %4, align 1, !dbg !348
  %21 = load i8, ptr %4, align 1, !dbg !350
  %22 = trunc i8 %21 to i1, !dbg !350
  %23 = xor i1 %22, true, !dbg !350
  %24 = zext i1 %23 to i32, !dbg !350
  %25 = sext i32 %24 to i64, !dbg !350
  %26 = icmp ne i64 %25, 0, !dbg !350
  br i1 %26, label %27, label %29, !dbg !350

27:                                               ; preds = %18
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 122, ptr noundef @.str.3) #3, !dbg !350
  unreachable, !dbg !350

28:                                               ; No predecessors!
  br label %30, !dbg !350

29:                                               ; preds = %18
  br label %30, !dbg !350

30:                                               ; preds = %29, %28
  call void @mutex_unlock(ptr noundef %1), !dbg !351
    #dbg_declare(ptr %5, !352, !DIExpression(), !354)
  %31 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !355
  %32 = zext i1 %31 to i8, !dbg !354
  store i8 %32, ptr %5, align 1, !dbg !354
  %33 = load i8, ptr %5, align 1, !dbg !356
  %34 = trunc i8 %33 to i1, !dbg !356
  %35 = xor i1 %34, true, !dbg !356
  %36 = zext i1 %35 to i32, !dbg !356
  %37 = sext i32 %36 to i64, !dbg !356
  %38 = icmp ne i64 %37, 0, !dbg !356
  br i1 %38, label %39, label %41, !dbg !356

39:                                               ; preds = %30
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 128, ptr noundef @.str.3) #3, !dbg !356
  unreachable, !dbg !356

40:                                               ; No predecessors!
  br label %42, !dbg !356

41:                                               ; preds = %30
  br label %42, !dbg !356

42:                                               ; preds = %41, %40
  call void @mutex_unlock(ptr noundef %1), !dbg !357
  call void @mutex_unlock(ptr noundef %2), !dbg !358
  call void @mutex_destroy(ptr noundef %2), !dbg !359
  call void @mutex_destroy(ptr noundef %1), !dbg !360
  ret void, !dbg !361
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @cond_init(ptr noundef %0) #0 !dbg !362 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca %struct._opaque_pthread_condattr_t, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !366, !DIExpression(), !367)
    #dbg_declare(ptr %3, !368, !DIExpression(), !369)
    #dbg_declare(ptr %4, !370, !DIExpression(), !378)
  %5 = call i32 @pthread_condattr_init(ptr noundef %4), !dbg !379
  store i32 %5, ptr %3, align 4, !dbg !380
  %6 = load i32, ptr %3, align 4, !dbg !381
  %7 = icmp eq i32 %6, 0, !dbg !381
  %8 = xor i1 %7, true, !dbg !381
  %9 = zext i1 %8 to i32, !dbg !381
  %10 = sext i32 %9 to i64, !dbg !381
  %11 = icmp ne i64 %10, 0, !dbg !381
  br i1 %11, label %12, label %14, !dbg !381

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 154, ptr noundef @.str.1) #3, !dbg !381
  unreachable, !dbg !381

13:                                               ; No predecessors!
  br label %15, !dbg !381

14:                                               ; preds = %1
  br label %15, !dbg !381

15:                                               ; preds = %14, %13
  %16 = load ptr, ptr %2, align 8, !dbg !382
  %17 = call i32 @"\01_pthread_cond_init"(ptr noundef %16, ptr noundef %4), !dbg !383
  store i32 %17, ptr %3, align 4, !dbg !384
  %18 = load i32, ptr %3, align 4, !dbg !385
  %19 = icmp eq i32 %18, 0, !dbg !385
  %20 = xor i1 %19, true, !dbg !385
  %21 = zext i1 %20 to i32, !dbg !385
  %22 = sext i32 %21 to i64, !dbg !385
  %23 = icmp ne i64 %22, 0, !dbg !385
  br i1 %23, label %24, label %26, !dbg !385

24:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 157, ptr noundef @.str.1) #3, !dbg !385
  unreachable, !dbg !385

25:                                               ; No predecessors!
  br label %27, !dbg !385

26:                                               ; preds = %15
  br label %27, !dbg !385

27:                                               ; preds = %26, %25
  %28 = call i32 @pthread_condattr_destroy(ptr noundef %4), !dbg !386
  store i32 %28, ptr %3, align 4, !dbg !387
  %29 = load i32, ptr %3, align 4, !dbg !388
  %30 = icmp eq i32 %29, 0, !dbg !388
  %31 = xor i1 %30, true, !dbg !388
  %32 = zext i1 %31 to i32, !dbg !388
  %33 = sext i32 %32 to i64, !dbg !388
  %34 = icmp ne i64 %33, 0, !dbg !388
  br i1 %34, label %35, label %37, !dbg !388

35:                                               ; preds = %27
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 160, ptr noundef @.str.1) #3, !dbg !388
  unreachable, !dbg !388

36:                                               ; No predecessors!
  br label %38, !dbg !388

37:                                               ; preds = %27
  br label %38, !dbg !388

38:                                               ; preds = %37, %36
  ret void, !dbg !389
}

declare i32 @pthread_condattr_init(ptr noundef) #1

declare i32 @"\01_pthread_cond_init"(ptr noundef, ptr noundef) #1

declare i32 @pthread_condattr_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @cond_destroy(ptr noundef %0) #0 !dbg !390 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !391, !DIExpression(), !392)
    #dbg_declare(ptr %3, !393, !DIExpression(), !394)
  %4 = load ptr, ptr %2, align 8, !dbg !395
  %5 = call i32 @pthread_cond_destroy(ptr noundef %4), !dbg !396
  store i32 %5, ptr %3, align 4, !dbg !394
  %6 = load i32, ptr %3, align 4, !dbg !397
  %7 = icmp eq i32 %6, 0, !dbg !397
  %8 = xor i1 %7, true, !dbg !397
  %9 = zext i1 %8 to i32, !dbg !397
  %10 = sext i32 %9 to i64, !dbg !397
  %11 = icmp ne i64 %10, 0, !dbg !397
  br i1 %11, label %12, label %14, !dbg !397

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_destroy, ptr noundef @.str, i32 noundef 166, ptr noundef @.str.1) #3, !dbg !397
  unreachable, !dbg !397

13:                                               ; No predecessors!
  br label %15, !dbg !397

14:                                               ; preds = %1
  br label %15, !dbg !397

15:                                               ; preds = %14, %13
  ret void, !dbg !398
}

declare i32 @pthread_cond_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @cond_signal(ptr noundef %0) #0 !dbg !399 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !400, !DIExpression(), !401)
    #dbg_declare(ptr %3, !402, !DIExpression(), !403)
  %4 = load ptr, ptr %2, align 8, !dbg !404
  %5 = call i32 @pthread_cond_signal(ptr noundef %4), !dbg !405
  store i32 %5, ptr %3, align 4, !dbg !403
  %6 = load i32, ptr %3, align 4, !dbg !406
  %7 = icmp eq i32 %6, 0, !dbg !406
  %8 = xor i1 %7, true, !dbg !406
  %9 = zext i1 %8 to i32, !dbg !406
  %10 = sext i32 %9 to i64, !dbg !406
  %11 = icmp ne i64 %10, 0, !dbg !406
  br i1 %11, label %12, label %14, !dbg !406

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_signal, ptr noundef @.str, i32 noundef 172, ptr noundef @.str.1) #3, !dbg !406
  unreachable, !dbg !406

13:                                               ; No predecessors!
  br label %15, !dbg !406

14:                                               ; preds = %1
  br label %15, !dbg !406

15:                                               ; preds = %14, %13
  ret void, !dbg !407
}

declare i32 @pthread_cond_signal(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @cond_broadcast(ptr noundef %0) #0 !dbg !408 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !409, !DIExpression(), !410)
    #dbg_declare(ptr %3, !411, !DIExpression(), !412)
  %4 = load ptr, ptr %2, align 8, !dbg !413
  %5 = call i32 @pthread_cond_broadcast(ptr noundef %4), !dbg !414
  store i32 %5, ptr %3, align 4, !dbg !412
  %6 = load i32, ptr %3, align 4, !dbg !415
  %7 = icmp eq i32 %6, 0, !dbg !415
  %8 = xor i1 %7, true, !dbg !415
  %9 = zext i1 %8 to i32, !dbg !415
  %10 = sext i32 %9 to i64, !dbg !415
  %11 = icmp ne i64 %10, 0, !dbg !415
  br i1 %11, label %12, label %14, !dbg !415

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_broadcast, ptr noundef @.str, i32 noundef 178, ptr noundef @.str.1) #3, !dbg !415
  unreachable, !dbg !415

13:                                               ; No predecessors!
  br label %15, !dbg !415

14:                                               ; preds = %1
  br label %15, !dbg !415

15:                                               ; preds = %14, %13
  ret void, !dbg !416
}

declare i32 @pthread_cond_broadcast(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @cond_wait(ptr noundef %0, ptr noundef %1) #0 !dbg !417 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !420, !DIExpression(), !421)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !422, !DIExpression(), !423)
    #dbg_declare(ptr %5, !424, !DIExpression(), !425)
  %6 = load ptr, ptr %3, align 8, !dbg !426
  %7 = load ptr, ptr %4, align 8, !dbg !427
  %8 = call i32 @"\01_pthread_cond_wait"(ptr noundef %6, ptr noundef %7), !dbg !428
  store i32 %8, ptr %5, align 4, !dbg !425
  ret void, !dbg !429
}

declare i32 @"\01_pthread_cond_wait"(ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @cond_timedwait(ptr noundef %0, ptr noundef %1, i64 noundef %2) #0 !dbg !430 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i64, align 8
  %7 = alloca %struct.timespec, align 8
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !434, !DIExpression(), !435)
  store ptr %1, ptr %5, align 8
    #dbg_declare(ptr %5, !436, !DIExpression(), !437)
  store i64 %2, ptr %6, align 8
    #dbg_declare(ptr %6, !438, !DIExpression(), !439)
    #dbg_declare(ptr %7, !440, !DIExpression(), !448)
  %9 = load i64, ptr %6, align 8, !dbg !449
    #dbg_declare(ptr %8, !450, !DIExpression(), !451)
  %10 = load ptr, ptr %4, align 8, !dbg !452
  %11 = load ptr, ptr %5, align 8, !dbg !453
  %12 = call i32 @"\01_pthread_cond_timedwait"(ptr noundef %10, ptr noundef %11, ptr noundef %7), !dbg !454
  store i32 %12, ptr %8, align 4, !dbg !451
  ret void, !dbg !455
}

declare i32 @"\01_pthread_cond_timedwait"(ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @cond_worker(ptr noundef %0) #0 !dbg !456 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i8, align 1
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !457, !DIExpression(), !458)
    #dbg_declare(ptr %4, !459, !DIExpression(), !460)
  store i8 1, ptr %4, align 1, !dbg !460
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !461
  %5 = load i32, ptr @phase, align 4, !dbg !463
  %6 = add nsw i32 %5, 1, !dbg !463
  store i32 %6, ptr @phase, align 4, !dbg !463
  call void @cond_wait(ptr noundef @cond, ptr noundef @cond_mutex), !dbg !464
  %7 = load i32, ptr @phase, align 4, !dbg !465
  %8 = add nsw i32 %7, 1, !dbg !465
  store i32 %8, ptr @phase, align 4, !dbg !465
  %9 = load i32, ptr @phase, align 4, !dbg !466
  %10 = icmp slt i32 %9, 2, !dbg !467
  %11 = zext i1 %10 to i8, !dbg !468
  store i8 %11, ptr %4, align 1, !dbg !468
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !469
  %12 = load i8, ptr %4, align 1, !dbg !470
  %13 = trunc i8 %12 to i1, !dbg !470
  br i1 %13, label %14, label %17, !dbg !472

14:                                               ; preds = %1
  %15 = load ptr, ptr %3, align 8, !dbg !473
  %16 = getelementptr inbounds i8, ptr %15, i64 1, !dbg !474
  store ptr %16, ptr %2, align 8, !dbg !475
  br label %32, !dbg !475

17:                                               ; preds = %1
  store i8 1, ptr %4, align 1, !dbg !476
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !477
  %18 = load i32, ptr @phase, align 4, !dbg !479
  %19 = add nsw i32 %18, 1, !dbg !479
  store i32 %19, ptr @phase, align 4, !dbg !479
  call void @cond_timedwait(ptr noundef @cond, ptr noundef @cond_mutex, i64 noundef 10), !dbg !480
  %20 = load i32, ptr @phase, align 4, !dbg !481
  %21 = add nsw i32 %20, 1, !dbg !481
  store i32 %21, ptr @phase, align 4, !dbg !481
  %22 = load i32, ptr @phase, align 4, !dbg !482
  %23 = icmp sgt i32 %22, 6, !dbg !483
  %24 = zext i1 %23 to i8, !dbg !484
  store i8 %24, ptr %4, align 1, !dbg !484
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !485
  %25 = load i8, ptr %4, align 1, !dbg !486
  %26 = trunc i8 %25 to i1, !dbg !486
  br i1 %26, label %27, label %30, !dbg !488

27:                                               ; preds = %17
  %28 = load ptr, ptr %3, align 8, !dbg !489
  %29 = getelementptr inbounds i8, ptr %28, i64 2, !dbg !490
  store ptr %29, ptr %2, align 8, !dbg !491
  br label %32, !dbg !491

30:                                               ; preds = %17
  %31 = load ptr, ptr %3, align 8, !dbg !492
  store ptr %31, ptr %2, align 8, !dbg !493
  br label %32, !dbg !493

32:                                               ; preds = %30, %27, %14
  %33 = load ptr, ptr %2, align 8, !dbg !494
  ret ptr %33, !dbg !494
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @cond_test() #0 !dbg !495 {
  %1 = alloca ptr, align 8
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
    #dbg_declare(ptr %1, !496, !DIExpression(), !497)
  store ptr inttoptr (i64 42 to ptr), ptr %1, align 8, !dbg !497
  call void @mutex_init(ptr noundef @cond_mutex, i32 noundef 0, i32 noundef 0, i32 noundef 3, i32 noundef 0), !dbg !498
  call void @cond_init(ptr noundef @cond), !dbg !499
    #dbg_declare(ptr %2, !500, !DIExpression(), !501)
  %4 = load ptr, ptr %1, align 8, !dbg !502
  %5 = call ptr @thread_create(ptr noundef @cond_worker, ptr noundef %4), !dbg !503
  store ptr %5, ptr %2, align 8, !dbg !501
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !504
  %6 = load i32, ptr @phase, align 4, !dbg !506
  %7 = add nsw i32 %6, 1, !dbg !506
  store i32 %7, ptr @phase, align 4, !dbg !506
  call void @cond_signal(ptr noundef @cond), !dbg !507
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !508
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !509
  %8 = load i32, ptr @phase, align 4, !dbg !511
  %9 = add nsw i32 %8, 1, !dbg !511
  store i32 %9, ptr @phase, align 4, !dbg !511
  call void @cond_broadcast(ptr noundef @cond), !dbg !512
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !513
    #dbg_declare(ptr %3, !514, !DIExpression(), !515)
  %10 = load ptr, ptr %2, align 8, !dbg !516
  %11 = call ptr @thread_join(ptr noundef %10), !dbg !517
  store ptr %11, ptr %3, align 8, !dbg !515
  %12 = load ptr, ptr %3, align 8, !dbg !518
  %13 = load ptr, ptr %1, align 8, !dbg !518
  %14 = icmp eq ptr %12, %13, !dbg !518
  %15 = xor i1 %14, true, !dbg !518
  %16 = zext i1 %15 to i32, !dbg !518
  %17 = sext i32 %16 to i64, !dbg !518
  %18 = icmp ne i64 %17, 0, !dbg !518
  br i1 %18, label %19, label %21, !dbg !518

19:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.cond_test, ptr noundef @.str, i32 noundef 252, ptr noundef @.str.4) #3, !dbg !518
  unreachable, !dbg !518

20:                                               ; No predecessors!
  br label %22, !dbg !518

21:                                               ; preds = %0
  br label %22, !dbg !518

22:                                               ; preds = %21, %20
  call void @cond_destroy(ptr noundef @cond), !dbg !519
  call void @mutex_destroy(ptr noundef @cond_mutex), !dbg !520
  ret void, !dbg !521
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @rwlock_init(ptr noundef %0, i32 noundef %1) #0 !dbg !522 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca %struct._opaque_pthread_rwlockattr_t, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !536, !DIExpression(), !537)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !538, !DIExpression(), !539)
    #dbg_declare(ptr %5, !540, !DIExpression(), !541)
    #dbg_declare(ptr %6, !542, !DIExpression(), !543)
    #dbg_declare(ptr %7, !544, !DIExpression(), !555)
  %8 = call i32 @pthread_rwlockattr_init(ptr noundef %7), !dbg !556
  store i32 %8, ptr %5, align 4, !dbg !557
  %9 = load i32, ptr %5, align 4, !dbg !558
  %10 = icmp eq i32 %9, 0, !dbg !558
  %11 = xor i1 %10, true, !dbg !558
  %12 = zext i1 %11 to i32, !dbg !558
  %13 = sext i32 %12 to i64, !dbg !558
  %14 = icmp ne i64 %13, 0, !dbg !558
  br i1 %14, label %15, label %17, !dbg !558

15:                                               ; preds = %2
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 269, ptr noundef @.str.1) #3, !dbg !558
  unreachable, !dbg !558

16:                                               ; No predecessors!
  br label %18, !dbg !558

17:                                               ; preds = %2
  br label %18, !dbg !558

18:                                               ; preds = %17, %16
  %19 = load i32, ptr %4, align 4, !dbg !559
  %20 = call i32 @pthread_rwlockattr_setpshared(ptr noundef %7, i32 noundef %19), !dbg !560
  store i32 %20, ptr %5, align 4, !dbg !561
  %21 = load i32, ptr %5, align 4, !dbg !562
  %22 = icmp eq i32 %21, 0, !dbg !562
  %23 = xor i1 %22, true, !dbg !562
  %24 = zext i1 %23 to i32, !dbg !562
  %25 = sext i32 %24 to i64, !dbg !562
  %26 = icmp ne i64 %25, 0, !dbg !562
  br i1 %26, label %27, label %29, !dbg !562

27:                                               ; preds = %18
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 272, ptr noundef @.str.1) #3, !dbg !562
  unreachable, !dbg !562

28:                                               ; No predecessors!
  br label %30, !dbg !562

29:                                               ; preds = %18
  br label %30, !dbg !562

30:                                               ; preds = %29, %28
  %31 = call i32 @pthread_rwlockattr_getpshared(ptr noundef %7, ptr noundef %6), !dbg !563
  store i32 %31, ptr %5, align 4, !dbg !564
  %32 = load i32, ptr %5, align 4, !dbg !565
  %33 = icmp eq i32 %32, 0, !dbg !565
  %34 = xor i1 %33, true, !dbg !565
  %35 = zext i1 %34 to i32, !dbg !565
  %36 = sext i32 %35 to i64, !dbg !565
  %37 = icmp ne i64 %36, 0, !dbg !565
  br i1 %37, label %38, label %40, !dbg !565

38:                                               ; preds = %30
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 274, ptr noundef @.str.1) #3, !dbg !565
  unreachable, !dbg !565

39:                                               ; No predecessors!
  br label %41, !dbg !565

40:                                               ; preds = %30
  br label %41, !dbg !565

41:                                               ; preds = %40, %39
  %42 = load ptr, ptr %3, align 8, !dbg !566
  %43 = call i32 @"\01_pthread_rwlock_init"(ptr noundef %42, ptr noundef %7), !dbg !567
  store i32 %43, ptr %5, align 4, !dbg !568
  %44 = load i32, ptr %5, align 4, !dbg !569
  %45 = icmp eq i32 %44, 0, !dbg !569
  %46 = xor i1 %45, true, !dbg !569
  %47 = zext i1 %46 to i32, !dbg !569
  %48 = sext i32 %47 to i64, !dbg !569
  %49 = icmp ne i64 %48, 0, !dbg !569
  br i1 %49, label %50, label %52, !dbg !569

50:                                               ; preds = %41
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 277, ptr noundef @.str.1) #3, !dbg !569
  unreachable, !dbg !569

51:                                               ; No predecessors!
  br label %53, !dbg !569

52:                                               ; preds = %41
  br label %53, !dbg !569

53:                                               ; preds = %52, %51
  %54 = call i32 @pthread_rwlockattr_destroy(ptr noundef %7), !dbg !570
  store i32 %54, ptr %5, align 4, !dbg !571
  %55 = load i32, ptr %5, align 4, !dbg !572
  %56 = icmp eq i32 %55, 0, !dbg !572
  %57 = xor i1 %56, true, !dbg !572
  %58 = zext i1 %57 to i32, !dbg !572
  %59 = sext i32 %58 to i64, !dbg !572
  %60 = icmp ne i64 %59, 0, !dbg !572
  br i1 %60, label %61, label %63, !dbg !572

61:                                               ; preds = %53
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 279, ptr noundef @.str.1) #3, !dbg !572
  unreachable, !dbg !572

62:                                               ; No predecessors!
  br label %64, !dbg !572

63:                                               ; preds = %53
  br label %64, !dbg !572

64:                                               ; preds = %63, %62
  ret void, !dbg !573
}

declare i32 @pthread_rwlockattr_init(ptr noundef) #1

declare i32 @pthread_rwlockattr_setpshared(ptr noundef, i32 noundef) #1

declare i32 @pthread_rwlockattr_getpshared(ptr noundef, ptr noundef) #1

declare i32 @"\01_pthread_rwlock_init"(ptr noundef, ptr noundef) #1

declare i32 @pthread_rwlockattr_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @rwlock_destroy(ptr noundef %0) #0 !dbg !574 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !577, !DIExpression(), !578)
    #dbg_declare(ptr %3, !579, !DIExpression(), !580)
  %4 = load ptr, ptr %2, align 8, !dbg !581
  %5 = call i32 @"\01_pthread_rwlock_destroy"(ptr noundef %4), !dbg !582
  store i32 %5, ptr %3, align 4, !dbg !580
  %6 = load i32, ptr %3, align 4, !dbg !583
  %7 = icmp eq i32 %6, 0, !dbg !583
  %8 = xor i1 %7, true, !dbg !583
  %9 = zext i1 %8 to i32, !dbg !583
  %10 = sext i32 %9 to i64, !dbg !583
  %11 = icmp ne i64 %10, 0, !dbg !583
  br i1 %11, label %12, label %14, !dbg !583

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_destroy, ptr noundef @.str, i32 noundef 285, ptr noundef @.str.1) #3, !dbg !583
  unreachable, !dbg !583

13:                                               ; No predecessors!
  br label %15, !dbg !583

14:                                               ; preds = %1
  br label %15, !dbg !583

15:                                               ; preds = %14, %13
  ret void, !dbg !584
}

declare i32 @"\01_pthread_rwlock_destroy"(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @rwlock_wrlock(ptr noundef %0) #0 !dbg !585 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !586, !DIExpression(), !587)
    #dbg_declare(ptr %3, !588, !DIExpression(), !589)
  %4 = load ptr, ptr %2, align 8, !dbg !590
  %5 = call i32 @"\01_pthread_rwlock_wrlock"(ptr noundef %4), !dbg !591
  store i32 %5, ptr %3, align 4, !dbg !589
  %6 = load i32, ptr %3, align 4, !dbg !592
  %7 = icmp eq i32 %6, 0, !dbg !592
  %8 = xor i1 %7, true, !dbg !592
  %9 = zext i1 %8 to i32, !dbg !592
  %10 = sext i32 %9 to i64, !dbg !592
  %11 = icmp ne i64 %10, 0, !dbg !592
  br i1 %11, label %12, label %14, !dbg !592

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_wrlock, ptr noundef @.str, i32 noundef 291, ptr noundef @.str.1) #3, !dbg !592
  unreachable, !dbg !592

13:                                               ; No predecessors!
  br label %15, !dbg !592

14:                                               ; preds = %1
  br label %15, !dbg !592

15:                                               ; preds = %14, %13
  ret void, !dbg !593
}

declare i32 @"\01_pthread_rwlock_wrlock"(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define zeroext i1 @rwlock_trywrlock(ptr noundef %0) #0 !dbg !594 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !597, !DIExpression(), !598)
    #dbg_declare(ptr %3, !599, !DIExpression(), !600)
  %4 = load ptr, ptr %2, align 8, !dbg !601
  %5 = call i32 @"\01_pthread_rwlock_trywrlock"(ptr noundef %4), !dbg !602
  store i32 %5, ptr %3, align 4, !dbg !600
  %6 = load i32, ptr %3, align 4, !dbg !603
  %7 = icmp eq i32 %6, 0, !dbg !604
  ret i1 %7, !dbg !605
}

declare i32 @"\01_pthread_rwlock_trywrlock"(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @rwlock_rdlock(ptr noundef %0) #0 !dbg !606 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !607, !DIExpression(), !608)
    #dbg_declare(ptr %3, !609, !DIExpression(), !610)
  %4 = load ptr, ptr %2, align 8, !dbg !611
  %5 = call i32 @"\01_pthread_rwlock_rdlock"(ptr noundef %4), !dbg !612
  store i32 %5, ptr %3, align 4, !dbg !610
  %6 = load i32, ptr %3, align 4, !dbg !613
  %7 = icmp eq i32 %6, 0, !dbg !613
  %8 = xor i1 %7, true, !dbg !613
  %9 = zext i1 %8 to i32, !dbg !613
  %10 = sext i32 %9 to i64, !dbg !613
  %11 = icmp ne i64 %10, 0, !dbg !613
  br i1 %11, label %12, label %14, !dbg !613

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_rdlock, ptr noundef @.str, i32 noundef 304, ptr noundef @.str.1) #3, !dbg !613
  unreachable, !dbg !613

13:                                               ; No predecessors!
  br label %15, !dbg !613

14:                                               ; preds = %1
  br label %15, !dbg !613

15:                                               ; preds = %14, %13
  ret void, !dbg !614
}

declare i32 @"\01_pthread_rwlock_rdlock"(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define zeroext i1 @rwlock_tryrdlock(ptr noundef %0) #0 !dbg !615 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !616, !DIExpression(), !617)
    #dbg_declare(ptr %3, !618, !DIExpression(), !619)
  %4 = load ptr, ptr %2, align 8, !dbg !620
  %5 = call i32 @"\01_pthread_rwlock_tryrdlock"(ptr noundef %4), !dbg !621
  store i32 %5, ptr %3, align 4, !dbg !619
  %6 = load i32, ptr %3, align 4, !dbg !622
  %7 = icmp eq i32 %6, 0, !dbg !623
  ret i1 %7, !dbg !624
}

declare i32 @"\01_pthread_rwlock_tryrdlock"(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @rwlock_unlock(ptr noundef %0) #0 !dbg !625 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !626, !DIExpression(), !627)
    #dbg_declare(ptr %3, !628, !DIExpression(), !629)
  %4 = load ptr, ptr %2, align 8, !dbg !630
  %5 = call i32 @"\01_pthread_rwlock_unlock"(ptr noundef %4), !dbg !631
  store i32 %5, ptr %3, align 4, !dbg !629
  %6 = load i32, ptr %3, align 4, !dbg !632
  %7 = icmp eq i32 %6, 0, !dbg !632
  %8 = xor i1 %7, true, !dbg !632
  %9 = zext i1 %8 to i32, !dbg !632
  %10 = sext i32 %9 to i64, !dbg !632
  %11 = icmp ne i64 %10, 0, !dbg !632
  br i1 %11, label %12, label %14, !dbg !632

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_unlock, ptr noundef @.str, i32 noundef 317, ptr noundef @.str.1) #3, !dbg !632
  unreachable, !dbg !632

13:                                               ; No predecessors!
  br label %15, !dbg !632

14:                                               ; preds = %1
  br label %15, !dbg !632

15:                                               ; preds = %14, %13
  ret void, !dbg !633
}

declare i32 @"\01_pthread_rwlock_unlock"(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @rwlock_test() #0 !dbg !634 {
  %1 = alloca %struct._opaque_pthread_rwlock_t, align 8
  %2 = alloca i32, align 4
  %3 = alloca i8, align 1
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  %6 = alloca i8, align 1
  %7 = alloca i32, align 4
  %8 = alloca i8, align 1
    #dbg_declare(ptr %1, !635, !DIExpression(), !636)
  call void @rwlock_init(ptr noundef %1, i32 noundef 2), !dbg !637
    #dbg_declare(ptr %2, !638, !DIExpression(), !640)
  store i32 4, ptr %2, align 4, !dbg !640
  call void @rwlock_wrlock(ptr noundef %1), !dbg !641
    #dbg_declare(ptr %3, !643, !DIExpression(), !644)
  %9 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !645
  %10 = zext i1 %9 to i8, !dbg !644
  store i8 %10, ptr %3, align 1, !dbg !644
  %11 = load i8, ptr %3, align 1, !dbg !646
  %12 = trunc i8 %11 to i1, !dbg !646
  %13 = xor i1 %12, true, !dbg !646
  %14 = xor i1 %13, true, !dbg !646
  %15 = zext i1 %14 to i32, !dbg !646
  %16 = sext i32 %15 to i64, !dbg !646
  %17 = icmp ne i64 %16, 0, !dbg !646
  br i1 %17, label %18, label %20, !dbg !646

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 329, ptr noundef @.str.2) #3, !dbg !646
  unreachable, !dbg !646

19:                                               ; No predecessors!
  br label %21, !dbg !646

20:                                               ; preds = %0
  br label %21, !dbg !646

21:                                               ; preds = %20, %19
  %22 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %1), !dbg !647
  %23 = zext i1 %22 to i8, !dbg !648
  store i8 %23, ptr %3, align 1, !dbg !648
  %24 = load i8, ptr %3, align 1, !dbg !649
  %25 = trunc i8 %24 to i1, !dbg !649
  %26 = xor i1 %25, true, !dbg !649
  %27 = xor i1 %26, true, !dbg !649
  %28 = zext i1 %27 to i32, !dbg !649
  %29 = sext i32 %28 to i64, !dbg !649
  %30 = icmp ne i64 %29, 0, !dbg !649
  br i1 %30, label %31, label %33, !dbg !649

31:                                               ; preds = %21
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 331, ptr noundef @.str.2) #3, !dbg !649
  unreachable, !dbg !649

32:                                               ; No predecessors!
  br label %34, !dbg !649

33:                                               ; preds = %21
  br label %34, !dbg !649

34:                                               ; preds = %33, %32
  call void @rwlock_unlock(ptr noundef %1), !dbg !650
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !651
    #dbg_declare(ptr %4, !653, !DIExpression(), !655)
  store i32 0, ptr %4, align 4, !dbg !655
  br label %35, !dbg !656

35:                                               ; preds = %51, %34
  %36 = load i32, ptr %4, align 4, !dbg !657
  %37 = icmp slt i32 %36, 4, !dbg !659
  br i1 %37, label %38, label %54, !dbg !660

38:                                               ; preds = %35
    #dbg_declare(ptr %5, !661, !DIExpression(), !663)
  %39 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %1), !dbg !664
  %40 = zext i1 %39 to i8, !dbg !663
  store i8 %40, ptr %5, align 1, !dbg !663
  %41 = load i8, ptr %5, align 1, !dbg !665
  %42 = trunc i8 %41 to i1, !dbg !665
  %43 = xor i1 %42, true, !dbg !665
  %44 = zext i1 %43 to i32, !dbg !665
  %45 = sext i32 %44 to i64, !dbg !665
  %46 = icmp ne i64 %45, 0, !dbg !665
  br i1 %46, label %47, label %49, !dbg !665

47:                                               ; preds = %38
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 340, ptr noundef @.str.3) #3, !dbg !665
  unreachable, !dbg !665

48:                                               ; No predecessors!
  unreachable, !dbg !665

49:                                               ; preds = %38
  br label %50, !dbg !665

50:                                               ; preds = %49
  br label %51, !dbg !666

51:                                               ; preds = %50
  %52 = load i32, ptr %4, align 4, !dbg !667
  %53 = add nsw i32 %52, 1, !dbg !667
  store i32 %53, ptr %4, align 4, !dbg !667
  br label %35, !dbg !668, !llvm.loop !669

54:                                               ; preds = %35
    #dbg_declare(ptr %6, !672, !DIExpression(), !674)
  %55 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !675
  %56 = zext i1 %55 to i8, !dbg !674
  store i8 %56, ptr %6, align 1, !dbg !674
  %57 = load i8, ptr %6, align 1, !dbg !676
  %58 = trunc i8 %57 to i1, !dbg !676
  %59 = xor i1 %58, true, !dbg !676
  %60 = xor i1 %59, true, !dbg !676
  %61 = zext i1 %60 to i32, !dbg !676
  %62 = sext i32 %61 to i64, !dbg !676
  %63 = icmp ne i64 %62, 0, !dbg !676
  br i1 %63, label %64, label %66, !dbg !676

64:                                               ; preds = %54
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 345, ptr noundef @.str.2) #3, !dbg !676
  unreachable, !dbg !676

65:                                               ; No predecessors!
  br label %67, !dbg !676

66:                                               ; preds = %54
  br label %67, !dbg !676

67:                                               ; preds = %66, %65
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !677
    #dbg_declare(ptr %7, !678, !DIExpression(), !680)
  store i32 0, ptr %7, align 4, !dbg !680
  br label %68, !dbg !681

68:                                               ; preds = %72, %67
  %69 = load i32, ptr %7, align 4, !dbg !682
  %70 = icmp slt i32 %69, 4, !dbg !684
  br i1 %70, label %71, label %75, !dbg !685

71:                                               ; preds = %68
  call void @rwlock_unlock(ptr noundef %1), !dbg !686
  br label %72, !dbg !688

72:                                               ; preds = %71
  %73 = load i32, ptr %7, align 4, !dbg !689
  %74 = add nsw i32 %73, 1, !dbg !689
  store i32 %74, ptr %7, align 4, !dbg !689
  br label %68, !dbg !690, !llvm.loop !691

75:                                               ; preds = %68
  call void @rwlock_wrlock(ptr noundef %1), !dbg !693
    #dbg_declare(ptr %8, !695, !DIExpression(), !696)
  %76 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !697
  %77 = zext i1 %76 to i8, !dbg !696
  store i8 %77, ptr %8, align 1, !dbg !696
  %78 = load i8, ptr %8, align 1, !dbg !698
  %79 = trunc i8 %78 to i1, !dbg !698
  %80 = xor i1 %79, true, !dbg !698
  %81 = xor i1 %80, true, !dbg !698
  %82 = zext i1 %81 to i32, !dbg !698
  %83 = sext i32 %82 to i64, !dbg !698
  %84 = icmp ne i64 %83, 0, !dbg !698
  br i1 %84, label %85, label %87, !dbg !698

85:                                               ; preds = %75
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 357, ptr noundef @.str.2) #3, !dbg !698
  unreachable, !dbg !698

86:                                               ; No predecessors!
  br label %88, !dbg !698

87:                                               ; preds = %75
  br label %88, !dbg !698

88:                                               ; preds = %87, %86
  call void @rwlock_unlock(ptr noundef %1), !dbg !699
  call void @rwlock_destroy(ptr noundef %1), !dbg !700
  ret void, !dbg !701
}

declare void @__VERIFIER_loop_bound(i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @key_destroy(ptr noundef %0) #0 !dbg !702 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !703, !DIExpression(), !704)
  %3 = call ptr @pthread_self(), !dbg !705
  store ptr %3, ptr @latest_thread, align 8, !dbg !706
  ret void, !dbg !707
}

declare ptr @pthread_self() #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @key_worker(ptr noundef %0) #0 !dbg !708 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !709, !DIExpression(), !710)
    #dbg_declare(ptr %3, !711, !DIExpression(), !712)
  store i32 1, ptr %3, align 4, !dbg !712
    #dbg_declare(ptr %4, !713, !DIExpression(), !714)
  %6 = load i64, ptr @local_data, align 8, !dbg !715
  %7 = call i32 @pthread_setspecific(i64 noundef %6, ptr noundef %3), !dbg !716
  store i32 %7, ptr %4, align 4, !dbg !714
  %8 = load i32, ptr %4, align 4, !dbg !717
  %9 = icmp eq i32 %8, 0, !dbg !717
  %10 = xor i1 %9, true, !dbg !717
  %11 = zext i1 %10 to i32, !dbg !717
  %12 = sext i32 %11 to i64, !dbg !717
  %13 = icmp ne i64 %12, 0, !dbg !717
  br i1 %13, label %14, label %16, !dbg !717

14:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.key_worker, ptr noundef @.str, i32 noundef 379, ptr noundef @.str.1) #3, !dbg !717
  unreachable, !dbg !717

15:                                               ; No predecessors!
  br label %17, !dbg !717

16:                                               ; preds = %1
  br label %17, !dbg !717

17:                                               ; preds = %16, %15
    #dbg_declare(ptr %5, !718, !DIExpression(), !719)
  %18 = load i64, ptr @local_data, align 8, !dbg !720
  %19 = call ptr @pthread_getspecific(i64 noundef %18), !dbg !721
  store ptr %19, ptr %5, align 8, !dbg !719
  %20 = load ptr, ptr %5, align 8, !dbg !722
  %21 = icmp eq ptr %20, %3, !dbg !722
  %22 = xor i1 %21, true, !dbg !722
  %23 = zext i1 %22 to i32, !dbg !722
  %24 = sext i32 %23 to i64, !dbg !722
  %25 = icmp ne i64 %24, 0, !dbg !722
  br i1 %25, label %26, label %28, !dbg !722

26:                                               ; preds = %17
  call void @__assert_rtn(ptr noundef @__func__.key_worker, ptr noundef @.str, i32 noundef 382, ptr noundef @.str.5) #3, !dbg !722
  unreachable, !dbg !722

27:                                               ; No predecessors!
  br label %29, !dbg !722

28:                                               ; preds = %17
  br label %29, !dbg !722

29:                                               ; preds = %28, %27
  %30 = load ptr, ptr %2, align 8, !dbg !723
  ret ptr %30, !dbg !724
}

declare i32 @pthread_setspecific(i64 noundef, ptr noundef) #1

declare ptr @pthread_getspecific(i64 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @key_test() #0 !dbg !725 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
    #dbg_declare(ptr %1, !726, !DIExpression(), !727)
  store i32 2, ptr %1, align 4, !dbg !727
    #dbg_declare(ptr %2, !728, !DIExpression(), !729)
  store ptr inttoptr (i64 41 to ptr), ptr %2, align 8, !dbg !729
    #dbg_declare(ptr %3, !730, !DIExpression(), !731)
  %7 = call i32 @pthread_key_create(ptr noundef @local_data, ptr noundef @key_destroy), !dbg !732
    #dbg_declare(ptr %4, !733, !DIExpression(), !734)
  %8 = load ptr, ptr %2, align 8, !dbg !735
  %9 = call ptr @thread_create(ptr noundef @key_worker, ptr noundef %8), !dbg !736
  store ptr %9, ptr %4, align 8, !dbg !734
  %10 = load i64, ptr @local_data, align 8, !dbg !737
  %11 = call i32 @pthread_setspecific(i64 noundef %10, ptr noundef %1), !dbg !738
  store i32 %11, ptr %3, align 4, !dbg !739
  %12 = load i32, ptr %3, align 4, !dbg !740
  %13 = icmp eq i32 %12, 0, !dbg !740
  %14 = xor i1 %13, true, !dbg !740
  %15 = zext i1 %14 to i32, !dbg !740
  %16 = sext i32 %15 to i64, !dbg !740
  %17 = icmp ne i64 %16, 0, !dbg !740
  br i1 %17, label %18, label %20, !dbg !740

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 398, ptr noundef @.str.1) #3, !dbg !740
  unreachable, !dbg !740

19:                                               ; No predecessors!
  br label %21, !dbg !740

20:                                               ; preds = %0
  br label %21, !dbg !740

21:                                               ; preds = %20, %19
    #dbg_declare(ptr %5, !741, !DIExpression(), !742)
  %22 = load i64, ptr @local_data, align 8, !dbg !743
  %23 = call ptr @pthread_getspecific(i64 noundef %22), !dbg !744
  store ptr %23, ptr %5, align 8, !dbg !742
  %24 = load ptr, ptr %5, align 8, !dbg !745
  %25 = icmp eq ptr %24, %1, !dbg !745
  %26 = xor i1 %25, true, !dbg !745
  %27 = zext i1 %26 to i32, !dbg !745
  %28 = sext i32 %27 to i64, !dbg !745
  %29 = icmp ne i64 %28, 0, !dbg !745
  br i1 %29, label %30, label %32, !dbg !745

30:                                               ; preds = %21
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 401, ptr noundef @.str.5) #3, !dbg !745
  unreachable, !dbg !745

31:                                               ; No predecessors!
  br label %33, !dbg !745

32:                                               ; preds = %21
  br label %33, !dbg !745

33:                                               ; preds = %32, %31
  %34 = load i64, ptr @local_data, align 8, !dbg !746
  %35 = call i32 @pthread_setspecific(i64 noundef %34, ptr noundef null), !dbg !747
  store i32 %35, ptr %3, align 4, !dbg !748
  %36 = load i32, ptr %3, align 4, !dbg !749
  %37 = icmp eq i32 %36, 0, !dbg !749
  %38 = xor i1 %37, true, !dbg !749
  %39 = zext i1 %38 to i32, !dbg !749
  %40 = sext i32 %39 to i64, !dbg !749
  %41 = icmp ne i64 %40, 0, !dbg !749
  br i1 %41, label %42, label %44, !dbg !749

42:                                               ; preds = %33
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 404, ptr noundef @.str.1) #3, !dbg !749
  unreachable, !dbg !749

43:                                               ; No predecessors!
  br label %45, !dbg !749

44:                                               ; preds = %33
  br label %45, !dbg !749

45:                                               ; preds = %44, %43
    #dbg_declare(ptr %6, !750, !DIExpression(), !751)
  %46 = load ptr, ptr %4, align 8, !dbg !752
  %47 = call ptr @thread_join(ptr noundef %46), !dbg !753
  store ptr %47, ptr %6, align 8, !dbg !751
  %48 = load ptr, ptr %6, align 8, !dbg !754
  %49 = load ptr, ptr %2, align 8, !dbg !754
  %50 = icmp eq ptr %48, %49, !dbg !754
  %51 = xor i1 %50, true, !dbg !754
  %52 = zext i1 %51 to i32, !dbg !754
  %53 = sext i32 %52 to i64, !dbg !754
  %54 = icmp ne i64 %53, 0, !dbg !754
  br i1 %54, label %55, label %57, !dbg !754

55:                                               ; preds = %45
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 407, ptr noundef @.str.4) #3, !dbg !754
  unreachable, !dbg !754

56:                                               ; No predecessors!
  br label %58, !dbg !754

57:                                               ; preds = %45
  br label %58, !dbg !754

58:                                               ; preds = %57, %56
  %59 = load i64, ptr @local_data, align 8, !dbg !755
  %60 = call i32 @pthread_key_delete(i64 noundef %59), !dbg !756
  store i32 %60, ptr %3, align 4, !dbg !757
  %61 = load i32, ptr %3, align 4, !dbg !758
  %62 = icmp eq i32 %61, 0, !dbg !758
  %63 = xor i1 %62, true, !dbg !758
  %64 = zext i1 %63 to i32, !dbg !758
  %65 = sext i32 %64 to i64, !dbg !758
  %66 = icmp ne i64 %65, 0, !dbg !758
  br i1 %66, label %67, label %69, !dbg !758

67:                                               ; preds = %58
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 410, ptr noundef @.str.1) #3, !dbg !758
  unreachable, !dbg !758

68:                                               ; No predecessors!
  br label %70, !dbg !758

69:                                               ; preds = %58
  br label %70, !dbg !758

70:                                               ; preds = %69, %68
  ret void, !dbg !759
}

declare i32 @pthread_key_create(ptr noundef, ptr noundef) #1

declare i32 @pthread_key_delete(i64 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @detach_test_worker0(ptr noundef %0) #0 !dbg !760 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !761, !DIExpression(), !762)
  ret ptr null, !dbg !763
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @detach_test_detach(ptr noundef %0) #0 !dbg !764 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !765, !DIExpression(), !766)
    #dbg_declare(ptr %3, !767, !DIExpression(), !768)
  %5 = call ptr @thread_create(ptr noundef @detach_test_worker0, ptr noundef null), !dbg !769
  store ptr %5, ptr %3, align 8, !dbg !768
  %6 = load ptr, ptr %3, align 8, !dbg !770
  %7 = call i32 @pthread_detach(ptr noundef %6), !dbg !771
    #dbg_declare(ptr %4, !772, !DIExpression(), !773)
  %8 = load ptr, ptr %3, align 8, !dbg !774
  %9 = call i32 @"\01_pthread_join"(ptr noundef %8, ptr noundef null), !dbg !775
  store i32 %9, ptr %4, align 4, !dbg !773
  %10 = load i32, ptr %4, align 4, !dbg !776
  %11 = icmp ne i32 %10, 0, !dbg !776
  %12 = xor i1 %11, true, !dbg !776
  %13 = zext i1 %12 to i32, !dbg !776
  %14 = sext i32 %13 to i64, !dbg !776
  %15 = icmp ne i64 %14, 0, !dbg !776
  br i1 %15, label %16, label %18, !dbg !776

16:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.detach_test_detach, ptr noundef @.str, i32 noundef 428, ptr noundef @.str.6) #3, !dbg !776
  unreachable, !dbg !776

17:                                               ; No predecessors!
  br label %19, !dbg !776

18:                                               ; preds = %1
  br label %19, !dbg !776

19:                                               ; preds = %18, %17
  ret ptr null, !dbg !777
}

declare i32 @pthread_detach(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @detach_test_attr(ptr noundef %0) #0 !dbg !778 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca %struct._opaque_pthread_attr_t, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !779, !DIExpression(), !780)
    #dbg_declare(ptr %3, !781, !DIExpression(), !782)
    #dbg_declare(ptr %4, !783, !DIExpression(), !784)
  %7 = call i32 @pthread_attr_init(ptr noundef %4), !dbg !785
  %8 = call i32 @pthread_attr_setdetachstate(ptr noundef %4, i32 noundef 2), !dbg !786
    #dbg_declare(ptr %5, !787, !DIExpression(), !788)
  %9 = call i32 @pthread_create(ptr noundef %3, ptr noundef %4, ptr noundef @detach_test_worker0, ptr noundef null), !dbg !789
  store i32 %9, ptr %5, align 4, !dbg !788
  %10 = load i32, ptr %5, align 4, !dbg !790
  %11 = icmp eq i32 %10, 0, !dbg !790
  %12 = xor i1 %11, true, !dbg !790
  %13 = zext i1 %12 to i32, !dbg !790
  %14 = sext i32 %13 to i64, !dbg !790
  %15 = icmp ne i64 %14, 0, !dbg !790
  br i1 %15, label %16, label %18, !dbg !790

16:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 439, ptr noundef @.str.7) #3, !dbg !790
  unreachable, !dbg !790

17:                                               ; No predecessors!
  br label %19, !dbg !790

18:                                               ; preds = %1
  br label %19, !dbg !790

19:                                               ; preds = %18, %17
  %20 = call i32 @pthread_attr_destroy(ptr noundef %4), !dbg !791
    #dbg_declare(ptr %6, !792, !DIExpression(), !793)
  %21 = load ptr, ptr %3, align 8, !dbg !794
  %22 = call i32 @"\01_pthread_join"(ptr noundef %21, ptr noundef null), !dbg !795
  store i32 %22, ptr %6, align 4, !dbg !793
  %23 = load i32, ptr %6, align 4, !dbg !796
  %24 = icmp ne i32 %23, 0, !dbg !796
  %25 = xor i1 %24, true, !dbg !796
  %26 = zext i1 %25 to i32, !dbg !796
  %27 = sext i32 %26 to i64, !dbg !796
  %28 = icmp ne i64 %27, 0, !dbg !796
  br i1 %28, label %29, label %31, !dbg !796

29:                                               ; preds = %19
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 443, ptr noundef @.str.6) #3, !dbg !796
  unreachable, !dbg !796

30:                                               ; No predecessors!
  br label %32, !dbg !796

31:                                               ; preds = %19
  br label %32, !dbg !796

32:                                               ; preds = %31, %30
  ret ptr null, !dbg !797
}

declare i32 @pthread_attr_setdetachstate(ptr noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @detach_test() #0 !dbg !798 {
  %1 = call ptr @thread_create(ptr noundef @detach_test_detach, ptr noundef null), !dbg !799
  ret void, !dbg !800
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !801 {
  call void @mutex_test(), !dbg !804
  call void @cond_test(), !dbg !805
  call void @rwlock_test(), !dbg !806
  call void @key_test(), !dbg !807
  call void @detach_test(), !dbg !808
  ret i32 0, !dbg !809
}

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!61}
!llvm.module.flags = !{!167, !168, !169, !170, !171, !172}
!llvm.ident = !{!173}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 18, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "benchmarks/miscellaneous/pthread.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a07a5311dcb48169203f87e3741b9f25")
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
!60 = distinct !DIGlobalVariable(name: "phase", scope: !61, file: !2, line: 200, type: !166, isLocal: false, isDefinition: true)
!61 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !62, globals: !65, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!62 = !{!63, !64}
!63 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!65 = !{!0, !8, !13, !18, !21, !26, !28, !30, !35, !37, !42, !47, !50, !52, !54, !59, !66, !68, !73, !75, !77, !79, !81, !83, !85, !87, !92, !95, !100, !105, !108, !111, !125, !137, !160}
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
!96 = distinct !DIGlobalVariable(scope: null, file: !2, line: 428, type: !97, isLocal: true, isDefinition: true)
!97 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 152, elements: !98)
!98 = !{!99}
!99 = !DISubrange(count: 19)
!100 = !DIGlobalVariableExpression(var: !101, expr: !DIExpression())
!101 = distinct !DIGlobalVariable(scope: null, file: !2, line: 428, type: !102, isLocal: true, isDefinition: true)
!102 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 136, elements: !103)
!103 = !{!104}
!104 = !DISubrange(count: 17)
!105 = !DIGlobalVariableExpression(var: !106, expr: !DIExpression())
!106 = distinct !DIGlobalVariable(scope: null, file: !2, line: 439, type: !107, isLocal: true, isDefinition: true)
!107 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 136, elements: !103)
!108 = !DIGlobalVariableExpression(var: !109, expr: !DIExpression())
!109 = distinct !DIGlobalVariable(scope: null, file: !2, line: 439, type: !110, isLocal: true, isDefinition: true)
!110 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 152, elements: !98)
!111 = !DIGlobalVariableExpression(var: !112, expr: !DIExpression())
!112 = distinct !DIGlobalVariable(name: "cond_mutex", scope: !61, file: !2, line: 198, type: !113, isLocal: false, isDefinition: true)
!113 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !114, line: 31, baseType: !115)
!114 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_mutex_t.h", directory: "", checksumkind: CSK_MD5, checksum: "583a89b25a16f85ebbdf32f8d9f237ec")
!115 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutex_t", file: !116, line: 113, baseType: !117)
!116 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!117 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutex_t", file: !116, line: 78, size: 512, elements: !118)
!118 = !{!119, !121}
!119 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !117, file: !116, line: 79, baseType: !120, size: 64)
!120 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !117, file: !116, line: 80, baseType: !122, size: 448, offset: 64)
!122 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 448, elements: !123)
!123 = !{!124}
!124 = !DISubrange(count: 56)
!125 = !DIGlobalVariableExpression(var: !126, expr: !DIExpression())
!126 = distinct !DIGlobalVariable(name: "cond", scope: !61, file: !2, line: 199, type: !127, isLocal: false, isDefinition: true)
!127 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_cond_t", file: !128, line: 31, baseType: !129)
!128 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_cond_t.h", directory: "", checksumkind: CSK_MD5, checksum: "a08af80ea124ebd303c431fa8c0affff")
!129 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_cond_t", file: !116, line: 110, baseType: !130)
!130 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_cond_t", file: !116, line: 68, size: 384, elements: !131)
!131 = !{!132, !133}
!132 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !130, file: !116, line: 69, baseType: !120, size: 64)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !130, file: !116, line: 70, baseType: !134, size: 320, offset: 64)
!134 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 320, elements: !135)
!135 = !{!136}
!136 = !DISubrange(count: 40)
!137 = !DIGlobalVariableExpression(var: !138, expr: !DIExpression())
!138 = distinct !DIGlobalVariable(name: "latest_thread", scope: !61, file: !2, line: 366, type: !139, isLocal: false, isDefinition: true)
!139 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !140, line: 31, baseType: !141)
!140 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!141 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !116, line: 118, baseType: !142)
!142 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !143, size: 64)
!143 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !116, line: 103, size: 65536, elements: !144)
!144 = !{!145, !146, !156}
!145 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !143, file: !116, line: 104, baseType: !120, size: 64)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !143, file: !116, line: 105, baseType: !147, size: 64, offset: 64)
!147 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !148, size: 64)
!148 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !116, line: 57, size: 192, elements: !149)
!149 = !{!150, !154, !155}
!150 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !148, file: !116, line: 58, baseType: !151, size: 64)
!151 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !152, size: 64)
!152 = !DISubroutineType(types: !153)
!153 = !{null, !64}
!154 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !148, file: !116, line: 59, baseType: !64, size: 64, offset: 64)
!155 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !148, file: !116, line: 60, baseType: !147, size: 64, offset: 128)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !143, file: !116, line: 106, baseType: !157, size: 65408, offset: 128)
!157 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 65408, elements: !158)
!158 = !{!159}
!159 = !DISubrange(count: 8176)
!160 = !DIGlobalVariableExpression(var: !161, expr: !DIExpression())
!161 = distinct !DIGlobalVariable(name: "local_data", scope: !61, file: !2, line: 367, type: !162, isLocal: false, isDefinition: true)
!162 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_key_t", file: !163, line: 31, baseType: !164)
!163 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_key_t.h", directory: "", checksumkind: CSK_MD5, checksum: "5b81238049903288f8d6142c5fcfabd6")
!164 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_key_t", file: !116, line: 112, baseType: !165)
!165 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!166 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!167 = !{i32 7, !"Dwarf Version", i32 5}
!168 = !{i32 2, !"Debug Info Version", i32 3}
!169 = !{i32 1, !"wchar_size", i32 4}
!170 = !{i32 8, !"PIC Level", i32 2}
!171 = !{i32 7, !"uwtable", i32 1}
!172 = !{i32 7, !"frame-pointer", i32 1}
!173 = !{!"Homebrew clang version 19.1.7"}
!174 = distinct !DISubprogram(name: "thread_create", scope: !2, file: !2, line: 12, type: !175, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!175 = !DISubroutineType(types: !176)
!176 = !{!139, !177, !64}
!177 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !178, size: 64)
!178 = !DISubroutineType(types: !179)
!179 = !{!64, !64}
!180 = !{}
!181 = !DILocalVariable(name: "runner", arg: 1, scope: !174, file: !2, line: 12, type: !177)
!182 = !DILocation(line: 12, column: 32, scope: !174)
!183 = !DILocalVariable(name: "data", arg: 2, scope: !174, file: !2, line: 12, type: !64)
!184 = !DILocation(line: 12, column: 54, scope: !174)
!185 = !DILocalVariable(name: "id", scope: !174, file: !2, line: 14, type: !139)
!186 = !DILocation(line: 14, column: 15, scope: !174)
!187 = !DILocalVariable(name: "attr", scope: !174, file: !2, line: 15, type: !188)
!188 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !189, line: 31, baseType: !190)
!189 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_attr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "383e78324250b910a1128f1b9a464b23")
!190 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_attr_t", file: !116, line: 109, baseType: !191)
!191 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_attr_t", file: !116, line: 63, size: 512, elements: !192)
!192 = !{!193, !194}
!193 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !191, file: !116, line: 64, baseType: !120, size: 64)
!194 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !191, file: !116, line: 65, baseType: !122, size: 448, offset: 64)
!195 = !DILocation(line: 15, column: 20, scope: !174)
!196 = !DILocation(line: 16, column: 5, scope: !174)
!197 = !DILocalVariable(name: "status", scope: !174, file: !2, line: 17, type: !166)
!198 = !DILocation(line: 17, column: 9, scope: !174)
!199 = !DILocation(line: 17, column: 45, scope: !174)
!200 = !DILocation(line: 17, column: 53, scope: !174)
!201 = !DILocation(line: 17, column: 18, scope: !174)
!202 = !DILocation(line: 18, column: 5, scope: !174)
!203 = !DILocation(line: 19, column: 5, scope: !174)
!204 = !DILocation(line: 20, column: 12, scope: !174)
!205 = !DILocation(line: 20, column: 5, scope: !174)
!206 = distinct !DISubprogram(name: "thread_join", scope: !2, file: !2, line: 23, type: !207, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!207 = !DISubroutineType(types: !208)
!208 = !{!64, !139}
!209 = !DILocalVariable(name: "id", arg: 1, scope: !206, file: !2, line: 23, type: !139)
!210 = !DILocation(line: 23, column: 29, scope: !206)
!211 = !DILocalVariable(name: "result", scope: !206, file: !2, line: 25, type: !64)
!212 = !DILocation(line: 25, column: 11, scope: !206)
!213 = !DILocalVariable(name: "status", scope: !206, file: !2, line: 26, type: !166)
!214 = !DILocation(line: 26, column: 9, scope: !206)
!215 = !DILocation(line: 26, column: 31, scope: !206)
!216 = !DILocation(line: 26, column: 18, scope: !206)
!217 = !DILocation(line: 27, column: 5, scope: !206)
!218 = !DILocation(line: 28, column: 12, scope: !206)
!219 = !DILocation(line: 28, column: 5, scope: !206)
!220 = distinct !DISubprogram(name: "mutex_init", scope: !2, file: !2, line: 43, type: !221, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!221 = !DISubroutineType(types: !222)
!222 = !{null, !223, !166, !166, !166, !166}
!223 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !113, size: 64)
!224 = !DILocalVariable(name: "lock", arg: 1, scope: !220, file: !2, line: 43, type: !223)
!225 = !DILocation(line: 43, column: 34, scope: !220)
!226 = !DILocalVariable(name: "type", arg: 2, scope: !220, file: !2, line: 43, type: !166)
!227 = !DILocation(line: 43, column: 44, scope: !220)
!228 = !DILocalVariable(name: "protocol", arg: 3, scope: !220, file: !2, line: 43, type: !166)
!229 = !DILocation(line: 43, column: 54, scope: !220)
!230 = !DILocalVariable(name: "policy", arg: 4, scope: !220, file: !2, line: 43, type: !166)
!231 = !DILocation(line: 43, column: 68, scope: !220)
!232 = !DILocalVariable(name: "prioceiling", arg: 5, scope: !220, file: !2, line: 43, type: !166)
!233 = !DILocation(line: 43, column: 80, scope: !220)
!234 = !DILocalVariable(name: "status", scope: !220, file: !2, line: 45, type: !166)
!235 = !DILocation(line: 45, column: 9, scope: !220)
!236 = !DILocalVariable(name: "value", scope: !220, file: !2, line: 46, type: !166)
!237 = !DILocation(line: 46, column: 9, scope: !220)
!238 = !DILocalVariable(name: "attributes", scope: !220, file: !2, line: 47, type: !239)
!239 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !240, line: 31, baseType: !241)
!240 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_mutexattr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "785eb3f812f7ebee764058667d4b4693")
!241 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutexattr_t", file: !116, line: 114, baseType: !242)
!242 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutexattr_t", file: !116, line: 83, size: 128, elements: !243)
!243 = !{!244, !245}
!244 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !242, file: !116, line: 84, baseType: !120, size: 64)
!245 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !242, file: !116, line: 85, baseType: !44, size: 64, offset: 64)
!246 = !DILocation(line: 47, column: 25, scope: !220)
!247 = !DILocation(line: 48, column: 14, scope: !220)
!248 = !DILocation(line: 48, column: 12, scope: !220)
!249 = !DILocation(line: 49, column: 5, scope: !220)
!250 = !DILocation(line: 51, column: 53, scope: !220)
!251 = !DILocation(line: 51, column: 14, scope: !220)
!252 = !DILocation(line: 51, column: 12, scope: !220)
!253 = !DILocation(line: 52, column: 5, scope: !220)
!254 = !DILocation(line: 53, column: 14, scope: !220)
!255 = !DILocation(line: 53, column: 12, scope: !220)
!256 = !DILocation(line: 54, column: 5, scope: !220)
!257 = !DILocation(line: 56, column: 57, scope: !220)
!258 = !DILocation(line: 56, column: 14, scope: !220)
!259 = !DILocation(line: 56, column: 12, scope: !220)
!260 = !DILocation(line: 57, column: 5, scope: !220)
!261 = !DILocation(line: 58, column: 14, scope: !220)
!262 = !DILocation(line: 58, column: 12, scope: !220)
!263 = !DILocation(line: 59, column: 5, scope: !220)
!264 = !DILocation(line: 61, column: 58, scope: !220)
!265 = !DILocation(line: 61, column: 14, scope: !220)
!266 = !DILocation(line: 61, column: 12, scope: !220)
!267 = !DILocation(line: 62, column: 5, scope: !220)
!268 = !DILocation(line: 63, column: 14, scope: !220)
!269 = !DILocation(line: 63, column: 12, scope: !220)
!270 = !DILocation(line: 64, column: 5, scope: !220)
!271 = !DILocation(line: 66, column: 60, scope: !220)
!272 = !DILocation(line: 66, column: 14, scope: !220)
!273 = !DILocation(line: 66, column: 12, scope: !220)
!274 = !DILocation(line: 67, column: 5, scope: !220)
!275 = !DILocation(line: 68, column: 14, scope: !220)
!276 = !DILocation(line: 68, column: 12, scope: !220)
!277 = !DILocation(line: 69, column: 5, scope: !220)
!278 = !DILocation(line: 71, column: 33, scope: !220)
!279 = !DILocation(line: 71, column: 14, scope: !220)
!280 = !DILocation(line: 71, column: 12, scope: !220)
!281 = !DILocation(line: 72, column: 5, scope: !220)
!282 = !DILocation(line: 73, column: 14, scope: !220)
!283 = !DILocation(line: 73, column: 12, scope: !220)
!284 = !DILocation(line: 74, column: 5, scope: !220)
!285 = !DILocation(line: 75, column: 1, scope: !220)
!286 = distinct !DISubprogram(name: "mutex_destroy", scope: !2, file: !2, line: 77, type: !287, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!287 = !DISubroutineType(types: !288)
!288 = !{null, !223}
!289 = !DILocalVariable(name: "lock", arg: 1, scope: !286, file: !2, line: 77, type: !223)
!290 = !DILocation(line: 77, column: 37, scope: !286)
!291 = !DILocalVariable(name: "status", scope: !286, file: !2, line: 79, type: !166)
!292 = !DILocation(line: 79, column: 9, scope: !286)
!293 = !DILocation(line: 79, column: 40, scope: !286)
!294 = !DILocation(line: 79, column: 18, scope: !286)
!295 = !DILocation(line: 80, column: 5, scope: !286)
!296 = !DILocation(line: 81, column: 1, scope: !286)
!297 = distinct !DISubprogram(name: "mutex_lock", scope: !2, file: !2, line: 83, type: !287, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!298 = !DILocalVariable(name: "lock", arg: 1, scope: !297, file: !2, line: 83, type: !223)
!299 = !DILocation(line: 83, column: 34, scope: !297)
!300 = !DILocalVariable(name: "status", scope: !297, file: !2, line: 85, type: !166)
!301 = !DILocation(line: 85, column: 9, scope: !297)
!302 = !DILocation(line: 85, column: 37, scope: !297)
!303 = !DILocation(line: 85, column: 18, scope: !297)
!304 = !DILocation(line: 86, column: 5, scope: !297)
!305 = !DILocation(line: 87, column: 1, scope: !297)
!306 = distinct !DISubprogram(name: "mutex_trylock", scope: !2, file: !2, line: 89, type: !307, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!307 = !DISubroutineType(types: !308)
!308 = !{!309, !223}
!309 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!310 = !DILocalVariable(name: "lock", arg: 1, scope: !306, file: !2, line: 89, type: !223)
!311 = !DILocation(line: 89, column: 37, scope: !306)
!312 = !DILocalVariable(name: "status", scope: !306, file: !2, line: 91, type: !166)
!313 = !DILocation(line: 91, column: 9, scope: !306)
!314 = !DILocation(line: 91, column: 40, scope: !306)
!315 = !DILocation(line: 91, column: 18, scope: !306)
!316 = !DILocation(line: 93, column: 12, scope: !306)
!317 = !DILocation(line: 93, column: 19, scope: !306)
!318 = !DILocation(line: 93, column: 5, scope: !306)
!319 = distinct !DISubprogram(name: "mutex_unlock", scope: !2, file: !2, line: 96, type: !287, scopeLine: 97, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!320 = !DILocalVariable(name: "lock", arg: 1, scope: !319, file: !2, line: 96, type: !223)
!321 = !DILocation(line: 96, column: 36, scope: !319)
!322 = !DILocalVariable(name: "status", scope: !319, file: !2, line: 98, type: !166)
!323 = !DILocation(line: 98, column: 9, scope: !319)
!324 = !DILocation(line: 98, column: 39, scope: !319)
!325 = !DILocation(line: 98, column: 18, scope: !319)
!326 = !DILocation(line: 99, column: 5, scope: !319)
!327 = !DILocation(line: 100, column: 1, scope: !319)
!328 = distinct !DISubprogram(name: "mutex_test", scope: !2, file: !2, line: 102, type: !329, scopeLine: 103, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!329 = !DISubroutineType(types: !330)
!330 = !{null}
!331 = !DILocalVariable(name: "mutex0", scope: !328, file: !2, line: 104, type: !113)
!332 = !DILocation(line: 104, column: 21, scope: !328)
!333 = !DILocalVariable(name: "mutex1", scope: !328, file: !2, line: 105, type: !113)
!334 = !DILocation(line: 105, column: 21, scope: !328)
!335 = !DILocation(line: 107, column: 5, scope: !328)
!336 = !DILocation(line: 108, column: 5, scope: !328)
!337 = !DILocation(line: 111, column: 9, scope: !338)
!338 = distinct !DILexicalBlock(scope: !328, file: !2, line: 110, column: 5)
!339 = !DILocalVariable(name: "success", scope: !338, file: !2, line: 112, type: !309)
!340 = !DILocation(line: 112, column: 14, scope: !338)
!341 = !DILocation(line: 112, column: 24, scope: !338)
!342 = !DILocation(line: 113, column: 9, scope: !338)
!343 = !DILocation(line: 114, column: 9, scope: !338)
!344 = !DILocation(line: 118, column: 9, scope: !345)
!345 = distinct !DILexicalBlock(scope: !328, file: !2, line: 117, column: 5)
!346 = !DILocalVariable(name: "success", scope: !347, file: !2, line: 121, type: !309)
!347 = distinct !DILexicalBlock(scope: !345, file: !2, line: 120, column: 9)
!348 = !DILocation(line: 121, column: 18, scope: !347)
!349 = !DILocation(line: 121, column: 28, scope: !347)
!350 = !DILocation(line: 122, column: 13, scope: !347)
!351 = !DILocation(line: 123, column: 13, scope: !347)
!352 = !DILocalVariable(name: "success", scope: !353, file: !2, line: 127, type: !309)
!353 = distinct !DILexicalBlock(scope: !345, file: !2, line: 126, column: 9)
!354 = !DILocation(line: 127, column: 18, scope: !353)
!355 = !DILocation(line: 127, column: 28, scope: !353)
!356 = !DILocation(line: 128, column: 13, scope: !353)
!357 = !DILocation(line: 129, column: 13, scope: !353)
!358 = !DILocation(line: 139, column: 9, scope: !345)
!359 = !DILocation(line: 142, column: 5, scope: !328)
!360 = !DILocation(line: 143, column: 5, scope: !328)
!361 = !DILocation(line: 144, column: 1, scope: !328)
!362 = distinct !DISubprogram(name: "cond_init", scope: !2, file: !2, line: 148, type: !363, scopeLine: 149, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!363 = !DISubroutineType(types: !364)
!364 = !{null, !365}
!365 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !127, size: 64)
!366 = !DILocalVariable(name: "cond", arg: 1, scope: !362, file: !2, line: 148, type: !365)
!367 = !DILocation(line: 148, column: 32, scope: !362)
!368 = !DILocalVariable(name: "status", scope: !362, file: !2, line: 150, type: !166)
!369 = !DILocation(line: 150, column: 9, scope: !362)
!370 = !DILocalVariable(name: "attr", scope: !362, file: !2, line: 151, type: !371)
!371 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_condattr_t", file: !372, line: 31, baseType: !373)
!372 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_condattr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "6a8d104d1f0f0413f6823c132bf5423e")
!373 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_condattr_t", file: !116, line: 111, baseType: !374)
!374 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_condattr_t", file: !116, line: 73, size: 128, elements: !375)
!375 = !{!376, !377}
!376 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !374, file: !116, line: 74, baseType: !120, size: 64)
!377 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !374, file: !116, line: 75, baseType: !44, size: 64, offset: 64)
!378 = !DILocation(line: 151, column: 24, scope: !362)
!379 = !DILocation(line: 153, column: 14, scope: !362)
!380 = !DILocation(line: 153, column: 12, scope: !362)
!381 = !DILocation(line: 154, column: 5, scope: !362)
!382 = !DILocation(line: 156, column: 32, scope: !362)
!383 = !DILocation(line: 156, column: 14, scope: !362)
!384 = !DILocation(line: 156, column: 12, scope: !362)
!385 = !DILocation(line: 157, column: 5, scope: !362)
!386 = !DILocation(line: 159, column: 14, scope: !362)
!387 = !DILocation(line: 159, column: 12, scope: !362)
!388 = !DILocation(line: 160, column: 5, scope: !362)
!389 = !DILocation(line: 161, column: 1, scope: !362)
!390 = distinct !DISubprogram(name: "cond_destroy", scope: !2, file: !2, line: 163, type: !363, scopeLine: 164, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!391 = !DILocalVariable(name: "cond", arg: 1, scope: !390, file: !2, line: 163, type: !365)
!392 = !DILocation(line: 163, column: 35, scope: !390)
!393 = !DILocalVariable(name: "status", scope: !390, file: !2, line: 165, type: !166)
!394 = !DILocation(line: 165, column: 9, scope: !390)
!395 = !DILocation(line: 165, column: 39, scope: !390)
!396 = !DILocation(line: 165, column: 18, scope: !390)
!397 = !DILocation(line: 166, column: 5, scope: !390)
!398 = !DILocation(line: 167, column: 1, scope: !390)
!399 = distinct !DISubprogram(name: "cond_signal", scope: !2, file: !2, line: 169, type: !363, scopeLine: 170, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!400 = !DILocalVariable(name: "cond", arg: 1, scope: !399, file: !2, line: 169, type: !365)
!401 = !DILocation(line: 169, column: 34, scope: !399)
!402 = !DILocalVariable(name: "status", scope: !399, file: !2, line: 171, type: !166)
!403 = !DILocation(line: 171, column: 9, scope: !399)
!404 = !DILocation(line: 171, column: 38, scope: !399)
!405 = !DILocation(line: 171, column: 18, scope: !399)
!406 = !DILocation(line: 172, column: 5, scope: !399)
!407 = !DILocation(line: 173, column: 1, scope: !399)
!408 = distinct !DISubprogram(name: "cond_broadcast", scope: !2, file: !2, line: 175, type: !363, scopeLine: 176, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!409 = !DILocalVariable(name: "cond", arg: 1, scope: !408, file: !2, line: 175, type: !365)
!410 = !DILocation(line: 175, column: 37, scope: !408)
!411 = !DILocalVariable(name: "status", scope: !408, file: !2, line: 177, type: !166)
!412 = !DILocation(line: 177, column: 9, scope: !408)
!413 = !DILocation(line: 177, column: 41, scope: !408)
!414 = !DILocation(line: 177, column: 18, scope: !408)
!415 = !DILocation(line: 178, column: 5, scope: !408)
!416 = !DILocation(line: 179, column: 1, scope: !408)
!417 = distinct !DISubprogram(name: "cond_wait", scope: !2, file: !2, line: 181, type: !418, scopeLine: 182, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!418 = !DISubroutineType(types: !419)
!419 = !{null, !365, !223}
!420 = !DILocalVariable(name: "cond", arg: 1, scope: !417, file: !2, line: 181, type: !365)
!421 = !DILocation(line: 181, column: 32, scope: !417)
!422 = !DILocalVariable(name: "lock", arg: 2, scope: !417, file: !2, line: 181, type: !223)
!423 = !DILocation(line: 181, column: 55, scope: !417)
!424 = !DILocalVariable(name: "status", scope: !417, file: !2, line: 183, type: !166)
!425 = !DILocation(line: 183, column: 9, scope: !417)
!426 = !DILocation(line: 183, column: 36, scope: !417)
!427 = !DILocation(line: 183, column: 42, scope: !417)
!428 = !DILocation(line: 183, column: 18, scope: !417)
!429 = !DILocation(line: 185, column: 1, scope: !417)
!430 = distinct !DISubprogram(name: "cond_timedwait", scope: !2, file: !2, line: 187, type: !431, scopeLine: 188, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!431 = !DISubroutineType(types: !432)
!432 = !{null, !365, !223, !433}
!433 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!434 = !DILocalVariable(name: "cond", arg: 1, scope: !430, file: !2, line: 187, type: !365)
!435 = !DILocation(line: 187, column: 37, scope: !430)
!436 = !DILocalVariable(name: "lock", arg: 2, scope: !430, file: !2, line: 187, type: !223)
!437 = !DILocation(line: 187, column: 60, scope: !430)
!438 = !DILocalVariable(name: "millis", arg: 3, scope: !430, file: !2, line: 187, type: !433)
!439 = !DILocation(line: 187, column: 76, scope: !430)
!440 = !DILocalVariable(name: "ts", scope: !430, file: !2, line: 190, type: !441)
!441 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !442, line: 33, size: 128, elements: !443)
!442 = !DIFile(filename: "/usr/local/include/sys/_types/_timespec.h", directory: "", checksumkind: CSK_MD5, checksum: "8d740567ad568a1ef1d70ccb6b1755cb")
!443 = !{!444, !447}
!444 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !441, file: !442, line: 35, baseType: !445, size: 64)
!445 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_time_t", file: !446, line: 119, baseType: !120)
!446 = !DIFile(filename: "/usr/local/include/arm/_types.h", directory: "", checksumkind: CSK_MD5, checksum: "b270144f57ae258d0ce80b8f87be068c")
!447 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !441, file: !442, line: 36, baseType: !120, size: 64, offset: 64)
!448 = !DILocation(line: 190, column: 21, scope: !430)
!449 = !DILocation(line: 194, column: 11, scope: !430)
!450 = !DILocalVariable(name: "status", scope: !430, file: !2, line: 195, type: !166)
!451 = !DILocation(line: 195, column: 9, scope: !430)
!452 = !DILocation(line: 195, column: 41, scope: !430)
!453 = !DILocation(line: 195, column: 47, scope: !430)
!454 = !DILocation(line: 195, column: 18, scope: !430)
!455 = !DILocation(line: 196, column: 1, scope: !430)
!456 = distinct !DISubprogram(name: "cond_worker", scope: !2, file: !2, line: 202, type: !178, scopeLine: 203, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!457 = !DILocalVariable(name: "message", arg: 1, scope: !456, file: !2, line: 202, type: !64)
!458 = !DILocation(line: 202, column: 25, scope: !456)
!459 = !DILocalVariable(name: "idle", scope: !456, file: !2, line: 204, type: !309)
!460 = !DILocation(line: 204, column: 10, scope: !456)
!461 = !DILocation(line: 206, column: 9, scope: !462)
!462 = distinct !DILexicalBlock(scope: !456, file: !2, line: 205, column: 5)
!463 = !DILocation(line: 207, column: 9, scope: !462)
!464 = !DILocation(line: 208, column: 9, scope: !462)
!465 = !DILocation(line: 209, column: 9, scope: !462)
!466 = !DILocation(line: 210, column: 16, scope: !462)
!467 = !DILocation(line: 210, column: 22, scope: !462)
!468 = !DILocation(line: 210, column: 14, scope: !462)
!469 = !DILocation(line: 211, column: 9, scope: !462)
!470 = !DILocation(line: 213, column: 9, scope: !471)
!471 = distinct !DILexicalBlock(scope: !456, file: !2, line: 213, column: 9)
!472 = !DILocation(line: 213, column: 9, scope: !456)
!473 = !DILocation(line: 214, column: 25, scope: !471)
!474 = !DILocation(line: 214, column: 34, scope: !471)
!475 = !DILocation(line: 214, column: 9, scope: !471)
!476 = !DILocation(line: 215, column: 10, scope: !456)
!477 = !DILocation(line: 217, column: 9, scope: !478)
!478 = distinct !DILexicalBlock(scope: !456, file: !2, line: 216, column: 5)
!479 = !DILocation(line: 218, column: 9, scope: !478)
!480 = !DILocation(line: 219, column: 9, scope: !478)
!481 = !DILocation(line: 220, column: 9, scope: !478)
!482 = !DILocation(line: 221, column: 16, scope: !478)
!483 = !DILocation(line: 221, column: 22, scope: !478)
!484 = !DILocation(line: 221, column: 14, scope: !478)
!485 = !DILocation(line: 222, column: 9, scope: !478)
!486 = !DILocation(line: 224, column: 9, scope: !487)
!487 = distinct !DILexicalBlock(scope: !456, file: !2, line: 224, column: 9)
!488 = !DILocation(line: 224, column: 9, scope: !456)
!489 = !DILocation(line: 225, column: 25, scope: !487)
!490 = !DILocation(line: 225, column: 34, scope: !487)
!491 = !DILocation(line: 225, column: 9, scope: !487)
!492 = !DILocation(line: 226, column: 12, scope: !456)
!493 = !DILocation(line: 226, column: 5, scope: !456)
!494 = !DILocation(line: 227, column: 1, scope: !456)
!495 = distinct !DISubprogram(name: "cond_test", scope: !2, file: !2, line: 229, type: !329, scopeLine: 230, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!496 = !DILocalVariable(name: "message", scope: !495, file: !2, line: 231, type: !64)
!497 = !DILocation(line: 231, column: 11, scope: !495)
!498 = !DILocation(line: 232, column: 5, scope: !495)
!499 = !DILocation(line: 233, column: 5, scope: !495)
!500 = !DILocalVariable(name: "worker", scope: !495, file: !2, line: 235, type: !139)
!501 = !DILocation(line: 235, column: 15, scope: !495)
!502 = !DILocation(line: 235, column: 51, scope: !495)
!503 = !DILocation(line: 235, column: 24, scope: !495)
!504 = !DILocation(line: 238, column: 9, scope: !505)
!505 = distinct !DILexicalBlock(scope: !495, file: !2, line: 237, column: 5)
!506 = !DILocation(line: 239, column: 9, scope: !505)
!507 = !DILocation(line: 240, column: 9, scope: !505)
!508 = !DILocation(line: 241, column: 9, scope: !505)
!509 = !DILocation(line: 245, column: 9, scope: !510)
!510 = distinct !DILexicalBlock(scope: !495, file: !2, line: 244, column: 5)
!511 = !DILocation(line: 246, column: 9, scope: !510)
!512 = !DILocation(line: 247, column: 9, scope: !510)
!513 = !DILocation(line: 248, column: 9, scope: !510)
!514 = !DILocalVariable(name: "result", scope: !495, file: !2, line: 251, type: !64)
!515 = !DILocation(line: 251, column: 11, scope: !495)
!516 = !DILocation(line: 251, column: 32, scope: !495)
!517 = !DILocation(line: 251, column: 20, scope: !495)
!518 = !DILocation(line: 252, column: 5, scope: !495)
!519 = !DILocation(line: 254, column: 5, scope: !495)
!520 = !DILocation(line: 255, column: 5, scope: !495)
!521 = !DILocation(line: 256, column: 1, scope: !495)
!522 = distinct !DISubprogram(name: "rwlock_init", scope: !2, file: !2, line: 263, type: !523, scopeLine: 264, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!523 = !DISubroutineType(types: !524)
!524 = !{null, !525, !166}
!525 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !526, size: 64)
!526 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlock_t", file: !527, line: 31, baseType: !528)
!527 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_rwlock_t.h", directory: "", checksumkind: CSK_MD5, checksum: "90af75f8fbbfc12b61c909d26e0aa196")
!528 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_rwlock_t", file: !116, line: 116, baseType: !529)
!529 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_rwlock_t", file: !116, line: 93, size: 1600, elements: !530)
!530 = !{!531, !532}
!531 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !529, file: !116, line: 94, baseType: !120, size: 64)
!532 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !529, file: !116, line: 95, baseType: !533, size: 1536, offset: 64)
!533 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 1536, elements: !534)
!534 = !{!535}
!535 = !DISubrange(count: 192)
!536 = !DILocalVariable(name: "lock", arg: 1, scope: !522, file: !2, line: 263, type: !525)
!537 = !DILocation(line: 263, column: 36, scope: !522)
!538 = !DILocalVariable(name: "shared", arg: 2, scope: !522, file: !2, line: 263, type: !166)
!539 = !DILocation(line: 263, column: 46, scope: !522)
!540 = !DILocalVariable(name: "status", scope: !522, file: !2, line: 265, type: !166)
!541 = !DILocation(line: 265, column: 9, scope: !522)
!542 = !DILocalVariable(name: "value", scope: !522, file: !2, line: 266, type: !166)
!543 = !DILocation(line: 266, column: 9, scope: !522)
!544 = !DILocalVariable(name: "attributes", scope: !522, file: !2, line: 267, type: !545)
!545 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlockattr_t", file: !546, line: 31, baseType: !547)
!546 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_rwlockattr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "c5c5da82785d693a726632cb5d3a4f7e")
!547 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_rwlockattr_t", file: !116, line: 117, baseType: !548)
!548 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_rwlockattr_t", file: !116, line: 98, size: 192, elements: !549)
!549 = !{!550, !551}
!550 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !548, file: !116, line: 99, baseType: !120, size: 64)
!551 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !548, file: !116, line: 100, baseType: !552, size: 128, offset: 64)
!552 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 128, elements: !553)
!553 = !{!554}
!554 = !DISubrange(count: 16)
!555 = !DILocation(line: 267, column: 26, scope: !522)
!556 = !DILocation(line: 268, column: 14, scope: !522)
!557 = !DILocation(line: 268, column: 12, scope: !522)
!558 = !DILocation(line: 269, column: 5, scope: !522)
!559 = !DILocation(line: 271, column: 57, scope: !522)
!560 = !DILocation(line: 271, column: 14, scope: !522)
!561 = !DILocation(line: 271, column: 12, scope: !522)
!562 = !DILocation(line: 272, column: 5, scope: !522)
!563 = !DILocation(line: 273, column: 14, scope: !522)
!564 = !DILocation(line: 273, column: 12, scope: !522)
!565 = !DILocation(line: 274, column: 5, scope: !522)
!566 = !DILocation(line: 276, column: 34, scope: !522)
!567 = !DILocation(line: 276, column: 14, scope: !522)
!568 = !DILocation(line: 276, column: 12, scope: !522)
!569 = !DILocation(line: 277, column: 5, scope: !522)
!570 = !DILocation(line: 278, column: 14, scope: !522)
!571 = !DILocation(line: 278, column: 12, scope: !522)
!572 = !DILocation(line: 279, column: 5, scope: !522)
!573 = !DILocation(line: 280, column: 1, scope: !522)
!574 = distinct !DISubprogram(name: "rwlock_destroy", scope: !2, file: !2, line: 282, type: !575, scopeLine: 283, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!575 = !DISubroutineType(types: !576)
!576 = !{null, !525}
!577 = !DILocalVariable(name: "lock", arg: 1, scope: !574, file: !2, line: 282, type: !525)
!578 = !DILocation(line: 282, column: 39, scope: !574)
!579 = !DILocalVariable(name: "status", scope: !574, file: !2, line: 284, type: !166)
!580 = !DILocation(line: 284, column: 9, scope: !574)
!581 = !DILocation(line: 284, column: 41, scope: !574)
!582 = !DILocation(line: 284, column: 18, scope: !574)
!583 = !DILocation(line: 285, column: 5, scope: !574)
!584 = !DILocation(line: 286, column: 1, scope: !574)
!585 = distinct !DISubprogram(name: "rwlock_wrlock", scope: !2, file: !2, line: 288, type: !575, scopeLine: 289, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!586 = !DILocalVariable(name: "lock", arg: 1, scope: !585, file: !2, line: 288, type: !525)
!587 = !DILocation(line: 288, column: 38, scope: !585)
!588 = !DILocalVariable(name: "status", scope: !585, file: !2, line: 290, type: !166)
!589 = !DILocation(line: 290, column: 9, scope: !585)
!590 = !DILocation(line: 290, column: 40, scope: !585)
!591 = !DILocation(line: 290, column: 18, scope: !585)
!592 = !DILocation(line: 291, column: 5, scope: !585)
!593 = !DILocation(line: 292, column: 1, scope: !585)
!594 = distinct !DISubprogram(name: "rwlock_trywrlock", scope: !2, file: !2, line: 294, type: !595, scopeLine: 295, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!595 = !DISubroutineType(types: !596)
!596 = !{!309, !525}
!597 = !DILocalVariable(name: "lock", arg: 1, scope: !594, file: !2, line: 294, type: !525)
!598 = !DILocation(line: 294, column: 41, scope: !594)
!599 = !DILocalVariable(name: "status", scope: !594, file: !2, line: 296, type: !166)
!600 = !DILocation(line: 296, column: 9, scope: !594)
!601 = !DILocation(line: 296, column: 43, scope: !594)
!602 = !DILocation(line: 296, column: 18, scope: !594)
!603 = !DILocation(line: 298, column: 12, scope: !594)
!604 = !DILocation(line: 298, column: 19, scope: !594)
!605 = !DILocation(line: 298, column: 5, scope: !594)
!606 = distinct !DISubprogram(name: "rwlock_rdlock", scope: !2, file: !2, line: 301, type: !575, scopeLine: 302, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!607 = !DILocalVariable(name: "lock", arg: 1, scope: !606, file: !2, line: 301, type: !525)
!608 = !DILocation(line: 301, column: 38, scope: !606)
!609 = !DILocalVariable(name: "status", scope: !606, file: !2, line: 303, type: !166)
!610 = !DILocation(line: 303, column: 9, scope: !606)
!611 = !DILocation(line: 303, column: 40, scope: !606)
!612 = !DILocation(line: 303, column: 18, scope: !606)
!613 = !DILocation(line: 304, column: 5, scope: !606)
!614 = !DILocation(line: 305, column: 1, scope: !606)
!615 = distinct !DISubprogram(name: "rwlock_tryrdlock", scope: !2, file: !2, line: 307, type: !595, scopeLine: 308, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!616 = !DILocalVariable(name: "lock", arg: 1, scope: !615, file: !2, line: 307, type: !525)
!617 = !DILocation(line: 307, column: 41, scope: !615)
!618 = !DILocalVariable(name: "status", scope: !615, file: !2, line: 309, type: !166)
!619 = !DILocation(line: 309, column: 9, scope: !615)
!620 = !DILocation(line: 309, column: 43, scope: !615)
!621 = !DILocation(line: 309, column: 18, scope: !615)
!622 = !DILocation(line: 311, column: 12, scope: !615)
!623 = !DILocation(line: 311, column: 19, scope: !615)
!624 = !DILocation(line: 311, column: 5, scope: !615)
!625 = distinct !DISubprogram(name: "rwlock_unlock", scope: !2, file: !2, line: 314, type: !575, scopeLine: 315, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!626 = !DILocalVariable(name: "lock", arg: 1, scope: !625, file: !2, line: 314, type: !525)
!627 = !DILocation(line: 314, column: 38, scope: !625)
!628 = !DILocalVariable(name: "status", scope: !625, file: !2, line: 316, type: !166)
!629 = !DILocation(line: 316, column: 9, scope: !625)
!630 = !DILocation(line: 316, column: 40, scope: !625)
!631 = !DILocation(line: 316, column: 18, scope: !625)
!632 = !DILocation(line: 317, column: 5, scope: !625)
!633 = !DILocation(line: 318, column: 1, scope: !625)
!634 = distinct !DISubprogram(name: "rwlock_test", scope: !2, file: !2, line: 320, type: !329, scopeLine: 321, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!635 = !DILocalVariable(name: "lock", scope: !634, file: !2, line: 322, type: !526)
!636 = !DILocation(line: 322, column: 22, scope: !634)
!637 = !DILocation(line: 323, column: 5, scope: !634)
!638 = !DILocalVariable(name: "test_depth", scope: !634, file: !2, line: 324, type: !639)
!639 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !166)
!640 = !DILocation(line: 324, column: 15, scope: !634)
!641 = !DILocation(line: 327, column: 9, scope: !642)
!642 = distinct !DILexicalBlock(scope: !634, file: !2, line: 326, column: 5)
!643 = !DILocalVariable(name: "success", scope: !642, file: !2, line: 328, type: !309)
!644 = !DILocation(line: 328, column: 14, scope: !642)
!645 = !DILocation(line: 328, column: 24, scope: !642)
!646 = !DILocation(line: 329, column: 9, scope: !642)
!647 = !DILocation(line: 330, column: 19, scope: !642)
!648 = !DILocation(line: 330, column: 17, scope: !642)
!649 = !DILocation(line: 331, column: 9, scope: !642)
!650 = !DILocation(line: 332, column: 9, scope: !642)
!651 = !DILocation(line: 336, column: 9, scope: !652)
!652 = distinct !DILexicalBlock(scope: !634, file: !2, line: 335, column: 5)
!653 = !DILocalVariable(name: "i", scope: !654, file: !2, line: 337, type: !166)
!654 = distinct !DILexicalBlock(scope: !652, file: !2, line: 337, column: 9)
!655 = !DILocation(line: 337, column: 18, scope: !654)
!656 = !DILocation(line: 337, column: 14, scope: !654)
!657 = !DILocation(line: 337, column: 25, scope: !658)
!658 = distinct !DILexicalBlock(scope: !654, file: !2, line: 337, column: 9)
!659 = !DILocation(line: 337, column: 27, scope: !658)
!660 = !DILocation(line: 337, column: 9, scope: !654)
!661 = !DILocalVariable(name: "success", scope: !662, file: !2, line: 339, type: !309)
!662 = distinct !DILexicalBlock(scope: !658, file: !2, line: 338, column: 9)
!663 = !DILocation(line: 339, column: 18, scope: !662)
!664 = !DILocation(line: 339, column: 28, scope: !662)
!665 = !DILocation(line: 340, column: 13, scope: !662)
!666 = !DILocation(line: 341, column: 9, scope: !662)
!667 = !DILocation(line: 337, column: 42, scope: !658)
!668 = !DILocation(line: 337, column: 9, scope: !658)
!669 = distinct !{!669, !660, !670, !671}
!670 = !DILocation(line: 341, column: 9, scope: !654)
!671 = !{!"llvm.loop.mustprogress"}
!672 = !DILocalVariable(name: "success", scope: !673, file: !2, line: 344, type: !309)
!673 = distinct !DILexicalBlock(scope: !652, file: !2, line: 343, column: 9)
!674 = !DILocation(line: 344, column: 18, scope: !673)
!675 = !DILocation(line: 344, column: 28, scope: !673)
!676 = !DILocation(line: 345, column: 13, scope: !673)
!677 = !DILocation(line: 348, column: 9, scope: !652)
!678 = !DILocalVariable(name: "i", scope: !679, file: !2, line: 349, type: !166)
!679 = distinct !DILexicalBlock(scope: !652, file: !2, line: 349, column: 9)
!680 = !DILocation(line: 349, column: 18, scope: !679)
!681 = !DILocation(line: 349, column: 14, scope: !679)
!682 = !DILocation(line: 349, column: 25, scope: !683)
!683 = distinct !DILexicalBlock(scope: !679, file: !2, line: 349, column: 9)
!684 = !DILocation(line: 349, column: 27, scope: !683)
!685 = !DILocation(line: 349, column: 9, scope: !679)
!686 = !DILocation(line: 350, column: 13, scope: !687)
!687 = distinct !DILexicalBlock(scope: !683, file: !2, line: 349, column: 46)
!688 = !DILocation(line: 351, column: 9, scope: !687)
!689 = !DILocation(line: 349, column: 42, scope: !683)
!690 = !DILocation(line: 349, column: 9, scope: !683)
!691 = distinct !{!691, !685, !692, !671}
!692 = !DILocation(line: 351, column: 9, scope: !679)
!693 = !DILocation(line: 355, column: 9, scope: !694)
!694 = distinct !DILexicalBlock(scope: !634, file: !2, line: 354, column: 5)
!695 = !DILocalVariable(name: "success", scope: !694, file: !2, line: 356, type: !309)
!696 = !DILocation(line: 356, column: 14, scope: !694)
!697 = !DILocation(line: 356, column: 24, scope: !694)
!698 = !DILocation(line: 357, column: 9, scope: !694)
!699 = !DILocation(line: 358, column: 9, scope: !694)
!700 = !DILocation(line: 361, column: 5, scope: !634)
!701 = !DILocation(line: 362, column: 1, scope: !634)
!702 = distinct !DISubprogram(name: "key_destroy", scope: !2, file: !2, line: 369, type: !152, scopeLine: 370, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!703 = !DILocalVariable(name: "unused_value", arg: 1, scope: !702, file: !2, line: 369, type: !64)
!704 = !DILocation(line: 369, column: 24, scope: !702)
!705 = !DILocation(line: 371, column: 21, scope: !702)
!706 = !DILocation(line: 371, column: 19, scope: !702)
!707 = !DILocation(line: 372, column: 1, scope: !702)
!708 = distinct !DISubprogram(name: "key_worker", scope: !2, file: !2, line: 374, type: !178, scopeLine: 375, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!709 = !DILocalVariable(name: "message", arg: 1, scope: !708, file: !2, line: 374, type: !64)
!710 = !DILocation(line: 374, column: 24, scope: !708)
!711 = !DILocalVariable(name: "my_secret", scope: !708, file: !2, line: 376, type: !166)
!712 = !DILocation(line: 376, column: 9, scope: !708)
!713 = !DILocalVariable(name: "status", scope: !708, file: !2, line: 378, type: !166)
!714 = !DILocation(line: 378, column: 9, scope: !708)
!715 = !DILocation(line: 378, column: 38, scope: !708)
!716 = !DILocation(line: 378, column: 18, scope: !708)
!717 = !DILocation(line: 379, column: 5, scope: !708)
!718 = !DILocalVariable(name: "my_local_data", scope: !708, file: !2, line: 381, type: !64)
!719 = !DILocation(line: 381, column: 11, scope: !708)
!720 = !DILocation(line: 381, column: 47, scope: !708)
!721 = !DILocation(line: 381, column: 27, scope: !708)
!722 = !DILocation(line: 382, column: 5, scope: !708)
!723 = !DILocation(line: 384, column: 12, scope: !708)
!724 = !DILocation(line: 384, column: 5, scope: !708)
!725 = distinct !DISubprogram(name: "key_test", scope: !2, file: !2, line: 387, type: !329, scopeLine: 388, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!726 = !DILocalVariable(name: "my_secret", scope: !725, file: !2, line: 389, type: !166)
!727 = !DILocation(line: 389, column: 9, scope: !725)
!728 = !DILocalVariable(name: "message", scope: !725, file: !2, line: 390, type: !64)
!729 = !DILocation(line: 390, column: 11, scope: !725)
!730 = !DILocalVariable(name: "status", scope: !725, file: !2, line: 391, type: !166)
!731 = !DILocation(line: 391, column: 9, scope: !725)
!732 = !DILocation(line: 393, column: 5, scope: !725)
!733 = !DILocalVariable(name: "worker", scope: !725, file: !2, line: 395, type: !139)
!734 = !DILocation(line: 395, column: 15, scope: !725)
!735 = !DILocation(line: 395, column: 50, scope: !725)
!736 = !DILocation(line: 395, column: 24, scope: !725)
!737 = !DILocation(line: 397, column: 34, scope: !725)
!738 = !DILocation(line: 397, column: 14, scope: !725)
!739 = !DILocation(line: 397, column: 12, scope: !725)
!740 = !DILocation(line: 398, column: 5, scope: !725)
!741 = !DILocalVariable(name: "my_local_data", scope: !725, file: !2, line: 400, type: !64)
!742 = !DILocation(line: 400, column: 11, scope: !725)
!743 = !DILocation(line: 400, column: 47, scope: !725)
!744 = !DILocation(line: 400, column: 27, scope: !725)
!745 = !DILocation(line: 401, column: 5, scope: !725)
!746 = !DILocation(line: 403, column: 34, scope: !725)
!747 = !DILocation(line: 403, column: 14, scope: !725)
!748 = !DILocation(line: 403, column: 12, scope: !725)
!749 = !DILocation(line: 404, column: 5, scope: !725)
!750 = !DILocalVariable(name: "result", scope: !725, file: !2, line: 406, type: !64)
!751 = !DILocation(line: 406, column: 11, scope: !725)
!752 = !DILocation(line: 406, column: 32, scope: !725)
!753 = !DILocation(line: 406, column: 20, scope: !725)
!754 = !DILocation(line: 407, column: 5, scope: !725)
!755 = !DILocation(line: 409, column: 33, scope: !725)
!756 = !DILocation(line: 409, column: 14, scope: !725)
!757 = !DILocation(line: 409, column: 12, scope: !725)
!758 = !DILocation(line: 410, column: 5, scope: !725)
!759 = !DILocation(line: 413, column: 1, scope: !725)
!760 = distinct !DISubprogram(name: "detach_test_worker0", scope: !2, file: !2, line: 417, type: !178, scopeLine: 418, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!761 = !DILocalVariable(name: "ignore", arg: 1, scope: !760, file: !2, line: 417, type: !64)
!762 = !DILocation(line: 417, column: 33, scope: !760)
!763 = !DILocation(line: 419, column: 5, scope: !760)
!764 = distinct !DISubprogram(name: "detach_test_detach", scope: !2, file: !2, line: 422, type: !178, scopeLine: 423, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!765 = !DILocalVariable(name: "ignore", arg: 1, scope: !764, file: !2, line: 422, type: !64)
!766 = !DILocation(line: 422, column: 32, scope: !764)
!767 = !DILocalVariable(name: "w0", scope: !764, file: !2, line: 424, type: !139)
!768 = !DILocation(line: 424, column: 15, scope: !764)
!769 = !DILocation(line: 424, column: 20, scope: !764)
!770 = !DILocation(line: 425, column: 20, scope: !764)
!771 = !DILocation(line: 425, column: 5, scope: !764)
!772 = !DILocalVariable(name: "join_status", scope: !764, file: !2, line: 427, type: !166)
!773 = !DILocation(line: 427, column: 9, scope: !764)
!774 = !DILocation(line: 427, column: 36, scope: !764)
!775 = !DILocation(line: 427, column: 23, scope: !764)
!776 = !DILocation(line: 428, column: 5, scope: !764)
!777 = !DILocation(line: 429, column: 5, scope: !764)
!778 = distinct !DISubprogram(name: "detach_test_attr", scope: !2, file: !2, line: 432, type: !178, scopeLine: 433, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !180)
!779 = !DILocalVariable(name: "ignore", arg: 1, scope: !778, file: !2, line: 432, type: !64)
!780 = !DILocation(line: 432, column: 30, scope: !778)
!781 = !DILocalVariable(name: "w0", scope: !778, file: !2, line: 434, type: !139)
!782 = !DILocation(line: 434, column: 15, scope: !778)
!783 = !DILocalVariable(name: "w0_attr", scope: !778, file: !2, line: 435, type: !188)
!784 = !DILocation(line: 435, column: 20, scope: !778)
!785 = !DILocation(line: 436, column: 5, scope: !778)
!786 = !DILocation(line: 437, column: 5, scope: !778)
!787 = !DILocalVariable(name: "create_status", scope: !778, file: !2, line: 438, type: !166)
!788 = !DILocation(line: 438, column: 9, scope: !778)
!789 = !DILocation(line: 438, column: 25, scope: !778)
!790 = !DILocation(line: 439, column: 5, scope: !778)
!791 = !DILocation(line: 440, column: 5, scope: !778)
!792 = !DILocalVariable(name: "join_status", scope: !778, file: !2, line: 442, type: !166)
!793 = !DILocation(line: 442, column: 9, scope: !778)
!794 = !DILocation(line: 442, column: 36, scope: !778)
!795 = !DILocation(line: 442, column: 23, scope: !778)
!796 = !DILocation(line: 443, column: 5, scope: !778)
!797 = !DILocation(line: 444, column: 5, scope: !778)
!798 = distinct !DISubprogram(name: "detach_test", scope: !2, file: !2, line: 447, type: !329, scopeLine: 448, spFlags: DISPFlagDefinition, unit: !61)
!799 = !DILocation(line: 449, column: 5, scope: !798)
!800 = !DILocation(line: 451, column: 1, scope: !798)
!801 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 453, type: !802, scopeLine: 454, spFlags: DISPFlagDefinition, unit: !61)
!802 = !DISubroutineType(types: !803)
!803 = !{!166}
!804 = !DILocation(line: 455, column: 5, scope: !801)
!805 = !DILocation(line: 456, column: 5, scope: !801)
!806 = !DILocation(line: 457, column: 5, scope: !801)
!807 = !DILocation(line: 458, column: 5, scope: !801)
!808 = !DILocation(line: 459, column: 5, scope: !801)
!809 = !DILocation(line: 460, column: 1, scope: !801)
