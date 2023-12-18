; ModuleID = 'benchmarks/c/miscellaneous/pthread.c'
source_filename = "benchmarks/c/miscellaneous/pthread.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

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
@cond_mutex = global %struct._opaque_pthread_mutex_t zeroinitializer, align 8, !dbg !100
@cond = global %struct._opaque_pthread_cond_t zeroinitializer, align 8, !dbg !114
@__func__.cond_test = private unnamed_addr constant [10 x i8] c"cond_test\00", align 1, !dbg !66
@.str.4 = private unnamed_addr constant [18 x i8] c"result == message\00", align 1, !dbg !68
@__func__.rwlock_init = private unnamed_addr constant [12 x i8] c"rwlock_init\00", align 1, !dbg !73
@__func__.rwlock_destroy = private unnamed_addr constant [15 x i8] c"rwlock_destroy\00", align 1, !dbg !75
@__func__.rwlock_wrlock = private unnamed_addr constant [14 x i8] c"rwlock_wrlock\00", align 1, !dbg !77
@__func__.rwlock_rdlock = private unnamed_addr constant [14 x i8] c"rwlock_rdlock\00", align 1, !dbg !79
@__func__.rwlock_unlock = private unnamed_addr constant [14 x i8] c"rwlock_unlock\00", align 1, !dbg !81
@__func__.rwlock_test = private unnamed_addr constant [12 x i8] c"rwlock_test\00", align 1, !dbg !83
@latest_thread = global ptr null, align 8, !dbg !126
@local_data = global i64 0, align 8, !dbg !149
@__func__.key_worker = private unnamed_addr constant [11 x i8] c"key_worker\00", align 1, !dbg !85
@.str.5 = private unnamed_addr constant [28 x i8] c"my_local_data == &my_secret\00", align 1, !dbg !87
@__func__.key_test = private unnamed_addr constant [9 x i8] c"key_test\00", align 1, !dbg !92
@.str.6 = private unnamed_addr constant [37 x i8] c"pthread_equal(latest_thread, worker)\00", align 1, !dbg !95

; Function Attrs: noinline nounwind ssp uwtable
define ptr @thread_create(ptr noundef %0, ptr noundef %1) #0 !dbg !163 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca %struct._opaque_pthread_attr_t, align 8
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !170, metadata !DIExpression()), !dbg !171
  store ptr %1, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !172, metadata !DIExpression()), !dbg !173
  call void @llvm.dbg.declare(metadata ptr %5, metadata !174, metadata !DIExpression()), !dbg !175
  call void @llvm.dbg.declare(metadata ptr %6, metadata !176, metadata !DIExpression()), !dbg !184
  %8 = call i32 @pthread_attr_init(ptr noundef %6), !dbg !185
  call void @llvm.dbg.declare(metadata ptr %7, metadata !186, metadata !DIExpression()), !dbg !187
  %9 = load ptr, ptr %3, align 8, !dbg !188
  %10 = load ptr, ptr %4, align 8, !dbg !189
  %11 = call i32 @pthread_create(ptr noundef %5, ptr noundef %6, ptr noundef %9, ptr noundef %10), !dbg !190
  store i32 %11, ptr %7, align 4, !dbg !187
  %12 = load i32, ptr %7, align 4, !dbg !191
  %13 = icmp eq i32 %12, 0, !dbg !191
  %14 = xor i1 %13, true, !dbg !191
  %15 = zext i1 %14 to i32, !dbg !191
  %16 = sext i32 %15 to i64, !dbg !191
  %17 = icmp ne i64 %16, 0, !dbg !191
  br i1 %17, label %18, label %20, !dbg !191

18:                                               ; preds = %2
  call void @__assert_rtn(ptr noundef @__func__.thread_create, ptr noundef @.str, i32 noundef 18, ptr noundef @.str.1) #4, !dbg !191
  unreachable, !dbg !191

19:                                               ; No predecessors!
  br label %21, !dbg !191

20:                                               ; preds = %2
  br label %21, !dbg !191

21:                                               ; preds = %20, %19
  %22 = call i32 @pthread_attr_destroy(ptr noundef %6), !dbg !192
  %23 = load ptr, ptr %5, align 8, !dbg !193
  ret ptr %23, !dbg !194
}

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @pthread_attr_init(ptr noundef) #2

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

declare i32 @pthread_attr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define ptr @thread_join(ptr noundef %0) #0 !dbg !195 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !198, metadata !DIExpression()), !dbg !199
  call void @llvm.dbg.declare(metadata ptr %3, metadata !200, metadata !DIExpression()), !dbg !201
  call void @llvm.dbg.declare(metadata ptr %4, metadata !202, metadata !DIExpression()), !dbg !203
  %5 = load ptr, ptr %2, align 8, !dbg !204
  %6 = call i32 @"\01_pthread_join"(ptr noundef %5, ptr noundef %3), !dbg !205
  store i32 %6, ptr %4, align 4, !dbg !203
  %7 = load i32, ptr %4, align 4, !dbg !206
  %8 = icmp eq i32 %7, 0, !dbg !206
  %9 = xor i1 %8, true, !dbg !206
  %10 = zext i1 %9 to i32, !dbg !206
  %11 = sext i32 %10 to i64, !dbg !206
  %12 = icmp ne i64 %11, 0, !dbg !206
  br i1 %12, label %13, label %15, !dbg !206

13:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.thread_join, ptr noundef @.str, i32 noundef 27, ptr noundef @.str.1) #4, !dbg !206
  unreachable, !dbg !206

14:                                               ; No predecessors!
  br label %16, !dbg !206

15:                                               ; preds = %1
  br label %16, !dbg !206

16:                                               ; preds = %15, %14
  %17 = load ptr, ptr %3, align 8, !dbg !207
  ret ptr %17, !dbg !208
}

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_init(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) #0 !dbg !209 {
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca %struct._opaque_pthread_mutexattr_t, align 8
  store ptr %0, ptr %6, align 8
  call void @llvm.dbg.declare(metadata ptr %6, metadata !213, metadata !DIExpression()), !dbg !214
  store i32 %1, ptr %7, align 4
  call void @llvm.dbg.declare(metadata ptr %7, metadata !215, metadata !DIExpression()), !dbg !216
  store i32 %2, ptr %8, align 4
  call void @llvm.dbg.declare(metadata ptr %8, metadata !217, metadata !DIExpression()), !dbg !218
  store i32 %3, ptr %9, align 4
  call void @llvm.dbg.declare(metadata ptr %9, metadata !219, metadata !DIExpression()), !dbg !220
  store i32 %4, ptr %10, align 4
  call void @llvm.dbg.declare(metadata ptr %10, metadata !221, metadata !DIExpression()), !dbg !222
  call void @llvm.dbg.declare(metadata ptr %11, metadata !223, metadata !DIExpression()), !dbg !224
  call void @llvm.dbg.declare(metadata ptr %12, metadata !225, metadata !DIExpression()), !dbg !226
  call void @llvm.dbg.declare(metadata ptr %13, metadata !227, metadata !DIExpression()), !dbg !235
  %14 = call i32 @pthread_mutexattr_init(ptr noundef %13), !dbg !236
  store i32 %14, ptr %11, align 4, !dbg !237
  %15 = load i32, ptr %11, align 4, !dbg !238
  %16 = icmp eq i32 %15, 0, !dbg !238
  %17 = xor i1 %16, true, !dbg !238
  %18 = zext i1 %17 to i32, !dbg !238
  %19 = sext i32 %18 to i64, !dbg !238
  %20 = icmp ne i64 %19, 0, !dbg !238
  br i1 %20, label %21, label %23, !dbg !238

21:                                               ; preds = %5
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 49, ptr noundef @.str.1) #4, !dbg !238
  unreachable, !dbg !238

22:                                               ; No predecessors!
  br label %24, !dbg !238

23:                                               ; preds = %5
  br label %24, !dbg !238

24:                                               ; preds = %23, %22
  %25 = load i32, ptr %7, align 4, !dbg !239
  %26 = call i32 @pthread_mutexattr_settype(ptr noundef %13, i32 noundef %25), !dbg !240
  store i32 %26, ptr %11, align 4, !dbg !241
  %27 = load i32, ptr %11, align 4, !dbg !242
  %28 = icmp eq i32 %27, 0, !dbg !242
  %29 = xor i1 %28, true, !dbg !242
  %30 = zext i1 %29 to i32, !dbg !242
  %31 = sext i32 %30 to i64, !dbg !242
  %32 = icmp ne i64 %31, 0, !dbg !242
  br i1 %32, label %33, label %35, !dbg !242

33:                                               ; preds = %24
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 52, ptr noundef @.str.1) #4, !dbg !242
  unreachable, !dbg !242

34:                                               ; No predecessors!
  br label %36, !dbg !242

35:                                               ; preds = %24
  br label %36, !dbg !242

36:                                               ; preds = %35, %34
  %37 = call i32 @pthread_mutexattr_gettype(ptr noundef %13, ptr noundef %12), !dbg !243
  store i32 %37, ptr %11, align 4, !dbg !244
  %38 = load i32, ptr %11, align 4, !dbg !245
  %39 = icmp eq i32 %38, 0, !dbg !245
  %40 = xor i1 %39, true, !dbg !245
  %41 = zext i1 %40 to i32, !dbg !245
  %42 = sext i32 %41 to i64, !dbg !245
  %43 = icmp ne i64 %42, 0, !dbg !245
  br i1 %43, label %44, label %46, !dbg !245

44:                                               ; preds = %36
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 54, ptr noundef @.str.1) #4, !dbg !245
  unreachable, !dbg !245

45:                                               ; No predecessors!
  br label %47, !dbg !245

46:                                               ; preds = %36
  br label %47, !dbg !245

47:                                               ; preds = %46, %45
  %48 = load i32, ptr %8, align 4, !dbg !246
  %49 = call i32 @pthread_mutexattr_setprotocol(ptr noundef %13, i32 noundef %48), !dbg !247
  store i32 %49, ptr %11, align 4, !dbg !248
  %50 = load i32, ptr %11, align 4, !dbg !249
  %51 = icmp eq i32 %50, 0, !dbg !249
  %52 = xor i1 %51, true, !dbg !249
  %53 = zext i1 %52 to i32, !dbg !249
  %54 = sext i32 %53 to i64, !dbg !249
  %55 = icmp ne i64 %54, 0, !dbg !249
  br i1 %55, label %56, label %58, !dbg !249

56:                                               ; preds = %47
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 57, ptr noundef @.str.1) #4, !dbg !249
  unreachable, !dbg !249

57:                                               ; No predecessors!
  br label %59, !dbg !249

58:                                               ; preds = %47
  br label %59, !dbg !249

59:                                               ; preds = %58, %57
  %60 = call i32 @pthread_mutexattr_getprotocol(ptr noundef %13, ptr noundef %12), !dbg !250
  store i32 %60, ptr %11, align 4, !dbg !251
  %61 = load i32, ptr %11, align 4, !dbg !252
  %62 = icmp eq i32 %61, 0, !dbg !252
  %63 = xor i1 %62, true, !dbg !252
  %64 = zext i1 %63 to i32, !dbg !252
  %65 = sext i32 %64 to i64, !dbg !252
  %66 = icmp ne i64 %65, 0, !dbg !252
  br i1 %66, label %67, label %69, !dbg !252

67:                                               ; preds = %59
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 59, ptr noundef @.str.1) #4, !dbg !252
  unreachable, !dbg !252

68:                                               ; No predecessors!
  br label %70, !dbg !252

69:                                               ; preds = %59
  br label %70, !dbg !252

70:                                               ; preds = %69, %68
  %71 = load i32, ptr %9, align 4, !dbg !253
  %72 = call i32 @pthread_mutexattr_setpolicy_np(ptr noundef %13, i32 noundef %71), !dbg !254
  store i32 %72, ptr %11, align 4, !dbg !255
  %73 = load i32, ptr %11, align 4, !dbg !256
  %74 = icmp eq i32 %73, 0, !dbg !256
  %75 = xor i1 %74, true, !dbg !256
  %76 = zext i1 %75 to i32, !dbg !256
  %77 = sext i32 %76 to i64, !dbg !256
  %78 = icmp ne i64 %77, 0, !dbg !256
  br i1 %78, label %79, label %81, !dbg !256

79:                                               ; preds = %70
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 62, ptr noundef @.str.1) #4, !dbg !256
  unreachable, !dbg !256

80:                                               ; No predecessors!
  br label %82, !dbg !256

81:                                               ; preds = %70
  br label %82, !dbg !256

82:                                               ; preds = %81, %80
  %83 = call i32 @pthread_mutexattr_getpolicy_np(ptr noundef %13, ptr noundef %12), !dbg !257
  store i32 %83, ptr %11, align 4, !dbg !258
  %84 = load i32, ptr %11, align 4, !dbg !259
  %85 = icmp eq i32 %84, 0, !dbg !259
  %86 = xor i1 %85, true, !dbg !259
  %87 = zext i1 %86 to i32, !dbg !259
  %88 = sext i32 %87 to i64, !dbg !259
  %89 = icmp ne i64 %88, 0, !dbg !259
  br i1 %89, label %90, label %92, !dbg !259

90:                                               ; preds = %82
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 64, ptr noundef @.str.1) #4, !dbg !259
  unreachable, !dbg !259

91:                                               ; No predecessors!
  br label %93, !dbg !259

92:                                               ; preds = %82
  br label %93, !dbg !259

93:                                               ; preds = %92, %91
  %94 = load i32, ptr %10, align 4, !dbg !260
  %95 = call i32 @pthread_mutexattr_setprioceiling(ptr noundef %13, i32 noundef %94), !dbg !261
  store i32 %95, ptr %11, align 4, !dbg !262
  %96 = load i32, ptr %11, align 4, !dbg !263
  %97 = icmp eq i32 %96, 0, !dbg !263
  %98 = xor i1 %97, true, !dbg !263
  %99 = zext i1 %98 to i32, !dbg !263
  %100 = sext i32 %99 to i64, !dbg !263
  %101 = icmp ne i64 %100, 0, !dbg !263
  br i1 %101, label %102, label %104, !dbg !263

102:                                              ; preds = %93
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 67, ptr noundef @.str.1) #4, !dbg !263
  unreachable, !dbg !263

103:                                              ; No predecessors!
  br label %105, !dbg !263

104:                                              ; preds = %93
  br label %105, !dbg !263

105:                                              ; preds = %104, %103
  %106 = call i32 @pthread_mutexattr_getprioceiling(ptr noundef %13, ptr noundef %12), !dbg !264
  store i32 %106, ptr %11, align 4, !dbg !265
  %107 = load i32, ptr %11, align 4, !dbg !266
  %108 = icmp eq i32 %107, 0, !dbg !266
  %109 = xor i1 %108, true, !dbg !266
  %110 = zext i1 %109 to i32, !dbg !266
  %111 = sext i32 %110 to i64, !dbg !266
  %112 = icmp ne i64 %111, 0, !dbg !266
  br i1 %112, label %113, label %115, !dbg !266

113:                                              ; preds = %105
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 69, ptr noundef @.str.1) #4, !dbg !266
  unreachable, !dbg !266

114:                                              ; No predecessors!
  br label %116, !dbg !266

115:                                              ; preds = %105
  br label %116, !dbg !266

116:                                              ; preds = %115, %114
  %117 = load ptr, ptr %6, align 8, !dbg !267
  %118 = call i32 @pthread_mutex_init(ptr noundef %117, ptr noundef %13), !dbg !268
  store i32 %118, ptr %11, align 4, !dbg !269
  %119 = load i32, ptr %11, align 4, !dbg !270
  %120 = icmp eq i32 %119, 0, !dbg !270
  %121 = xor i1 %120, true, !dbg !270
  %122 = zext i1 %121 to i32, !dbg !270
  %123 = sext i32 %122 to i64, !dbg !270
  %124 = icmp ne i64 %123, 0, !dbg !270
  br i1 %124, label %125, label %127, !dbg !270

125:                                              ; preds = %116
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 72, ptr noundef @.str.1) #4, !dbg !270
  unreachable, !dbg !270

126:                                              ; No predecessors!
  br label %128, !dbg !270

127:                                              ; preds = %116
  br label %128, !dbg !270

128:                                              ; preds = %127, %126
  %129 = call i32 @"\01_pthread_mutexattr_destroy"(ptr noundef %13), !dbg !271
  store i32 %129, ptr %11, align 4, !dbg !272
  %130 = load i32, ptr %11, align 4, !dbg !273
  %131 = icmp eq i32 %130, 0, !dbg !273
  %132 = xor i1 %131, true, !dbg !273
  %133 = zext i1 %132 to i32, !dbg !273
  %134 = sext i32 %133 to i64, !dbg !273
  %135 = icmp ne i64 %134, 0, !dbg !273
  br i1 %135, label %136, label %138, !dbg !273

136:                                              ; preds = %128
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 74, ptr noundef @.str.1) #4, !dbg !273
  unreachable, !dbg !273

137:                                              ; No predecessors!
  br label %139, !dbg !273

138:                                              ; preds = %128
  br label %139, !dbg !273

139:                                              ; preds = %138, %137
  ret void, !dbg !274
}

declare i32 @pthread_mutexattr_init(ptr noundef) #2

declare i32 @pthread_mutexattr_settype(ptr noundef, i32 noundef) #2

declare i32 @pthread_mutexattr_gettype(ptr noundef, ptr noundef) #2

declare i32 @pthread_mutexattr_setprotocol(ptr noundef, i32 noundef) #2

declare i32 @pthread_mutexattr_getprotocol(ptr noundef, ptr noundef) #2

declare i32 @pthread_mutexattr_setpolicy_np(ptr noundef, i32 noundef) #2

declare i32 @pthread_mutexattr_getpolicy_np(ptr noundef, ptr noundef) #2

declare i32 @pthread_mutexattr_setprioceiling(ptr noundef, i32 noundef) #2

declare i32 @pthread_mutexattr_getprioceiling(ptr noundef, ptr noundef) #2

declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #2

declare i32 @"\01_pthread_mutexattr_destroy"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_destroy(ptr noundef %0) #0 !dbg !275 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !278, metadata !DIExpression()), !dbg !279
  call void @llvm.dbg.declare(metadata ptr %3, metadata !280, metadata !DIExpression()), !dbg !281
  %4 = load ptr, ptr %2, align 8, !dbg !282
  %5 = call i32 @pthread_mutex_destroy(ptr noundef %4), !dbg !283
  store i32 %5, ptr %3, align 4, !dbg !281
  %6 = load i32, ptr %3, align 4, !dbg !284
  %7 = icmp eq i32 %6, 0, !dbg !284
  %8 = xor i1 %7, true, !dbg !284
  %9 = zext i1 %8 to i32, !dbg !284
  %10 = sext i32 %9 to i64, !dbg !284
  %11 = icmp ne i64 %10, 0, !dbg !284
  br i1 %11, label %12, label %14, !dbg !284

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_destroy, ptr noundef @.str, i32 noundef 80, ptr noundef @.str.1) #4, !dbg !284
  unreachable, !dbg !284

13:                                               ; No predecessors!
  br label %15, !dbg !284

14:                                               ; preds = %1
  br label %15, !dbg !284

15:                                               ; preds = %14, %13
  ret void, !dbg !285
}

declare i32 @pthread_mutex_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_lock(ptr noundef %0) #0 !dbg !286 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !287, metadata !DIExpression()), !dbg !288
  call void @llvm.dbg.declare(metadata ptr %3, metadata !289, metadata !DIExpression()), !dbg !290
  %4 = load ptr, ptr %2, align 8, !dbg !291
  %5 = call i32 @pthread_mutex_lock(ptr noundef %4), !dbg !292
  store i32 %5, ptr %3, align 4, !dbg !290
  %6 = load i32, ptr %3, align 4, !dbg !293
  %7 = icmp eq i32 %6, 0, !dbg !293
  %8 = xor i1 %7, true, !dbg !293
  %9 = zext i1 %8 to i32, !dbg !293
  %10 = sext i32 %9 to i64, !dbg !293
  %11 = icmp ne i64 %10, 0, !dbg !293
  br i1 %11, label %12, label %14, !dbg !293

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_lock, ptr noundef @.str, i32 noundef 86, ptr noundef @.str.1) #4, !dbg !293
  unreachable, !dbg !293

13:                                               ; No predecessors!
  br label %15, !dbg !293

14:                                               ; preds = %1
  br label %15, !dbg !293

15:                                               ; preds = %14, %13
  ret void, !dbg !294
}

declare i32 @pthread_mutex_lock(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define zeroext i1 @mutex_trylock(ptr noundef %0) #0 !dbg !295 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !299, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.declare(metadata ptr %3, metadata !301, metadata !DIExpression()), !dbg !302
  %4 = load ptr, ptr %2, align 8, !dbg !303
  %5 = call i32 @pthread_mutex_trylock(ptr noundef %4), !dbg !304
  store i32 %5, ptr %3, align 4, !dbg !302
  %6 = load i32, ptr %3, align 4, !dbg !305
  %7 = icmp eq i32 %6, 0, !dbg !306
  ret i1 %7, !dbg !307
}

declare i32 @pthread_mutex_trylock(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_unlock(ptr noundef %0) #0 !dbg !308 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !309, metadata !DIExpression()), !dbg !310
  call void @llvm.dbg.declare(metadata ptr %3, metadata !311, metadata !DIExpression()), !dbg !312
  %4 = load ptr, ptr %2, align 8, !dbg !313
  %5 = call i32 @pthread_mutex_unlock(ptr noundef %4), !dbg !314
  store i32 %5, ptr %3, align 4, !dbg !312
  %6 = load i32, ptr %3, align 4, !dbg !315
  %7 = icmp eq i32 %6, 0, !dbg !315
  %8 = xor i1 %7, true, !dbg !315
  %9 = zext i1 %8 to i32, !dbg !315
  %10 = sext i32 %9 to i64, !dbg !315
  %11 = icmp ne i64 %10, 0, !dbg !315
  br i1 %11, label %12, label %14, !dbg !315

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_unlock, ptr noundef @.str, i32 noundef 99, ptr noundef @.str.1) #4, !dbg !315
  unreachable, !dbg !315

13:                                               ; No predecessors!
  br label %15, !dbg !315

14:                                               ; preds = %1
  br label %15, !dbg !315

15:                                               ; preds = %14, %13
  ret void, !dbg !316
}

declare i32 @pthread_mutex_unlock(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_test() #0 !dbg !317 {
  %1 = alloca %struct._opaque_pthread_mutex_t, align 8
  %2 = alloca %struct._opaque_pthread_mutex_t, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  %5 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata ptr %1, metadata !320, metadata !DIExpression()), !dbg !321
  call void @llvm.dbg.declare(metadata ptr %2, metadata !322, metadata !DIExpression()), !dbg !323
  call void @mutex_init(ptr noundef %1, i32 noundef 1, i32 noundef 1, i32 noundef 1, i32 noundef 1), !dbg !324
  call void @mutex_init(ptr noundef %2, i32 noundef 2, i32 noundef 2, i32 noundef 3, i32 noundef 2), !dbg !325
  call void @mutex_lock(ptr noundef %1), !dbg !326
  call void @llvm.dbg.declare(metadata ptr %3, metadata !328, metadata !DIExpression()), !dbg !329
  %6 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !330
  %7 = zext i1 %6 to i8, !dbg !329
  store i8 %7, ptr %3, align 1, !dbg !329
  %8 = load i8, ptr %3, align 1, !dbg !331
  %9 = trunc i8 %8 to i1, !dbg !331
  %10 = xor i1 %9, true, !dbg !331
  %11 = xor i1 %10, true, !dbg !331
  %12 = zext i1 %11 to i32, !dbg !331
  %13 = sext i32 %12 to i64, !dbg !331
  %14 = icmp ne i64 %13, 0, !dbg !331
  br i1 %14, label %15, label %17, !dbg !331

15:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 113, ptr noundef @.str.2) #4, !dbg !331
  unreachable, !dbg !331

16:                                               ; No predecessors!
  br label %18, !dbg !331

17:                                               ; preds = %0
  br label %18, !dbg !331

18:                                               ; preds = %17, %16
  call void @mutex_unlock(ptr noundef %1), !dbg !332
  call void @mutex_lock(ptr noundef %2), !dbg !333
  call void @llvm.dbg.declare(metadata ptr %4, metadata !335, metadata !DIExpression()), !dbg !337
  %19 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !338
  %20 = zext i1 %19 to i8, !dbg !337
  store i8 %20, ptr %4, align 1, !dbg !337
  %21 = load i8, ptr %4, align 1, !dbg !339
  %22 = trunc i8 %21 to i1, !dbg !339
  %23 = xor i1 %22, true, !dbg !339
  %24 = zext i1 %23 to i32, !dbg !339
  %25 = sext i32 %24 to i64, !dbg !339
  %26 = icmp ne i64 %25, 0, !dbg !339
  br i1 %26, label %27, label %29, !dbg !339

27:                                               ; preds = %18
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 122, ptr noundef @.str.3) #4, !dbg !339
  unreachable, !dbg !339

28:                                               ; No predecessors!
  br label %30, !dbg !339

29:                                               ; preds = %18
  br label %30, !dbg !339

30:                                               ; preds = %29, %28
  call void @mutex_unlock(ptr noundef %1), !dbg !340
  call void @llvm.dbg.declare(metadata ptr %5, metadata !341, metadata !DIExpression()), !dbg !343
  %31 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !344
  %32 = zext i1 %31 to i8, !dbg !343
  store i8 %32, ptr %5, align 1, !dbg !343
  %33 = load i8, ptr %5, align 1, !dbg !345
  %34 = trunc i8 %33 to i1, !dbg !345
  %35 = xor i1 %34, true, !dbg !345
  %36 = zext i1 %35 to i32, !dbg !345
  %37 = sext i32 %36 to i64, !dbg !345
  %38 = icmp ne i64 %37, 0, !dbg !345
  br i1 %38, label %39, label %41, !dbg !345

39:                                               ; preds = %30
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 128, ptr noundef @.str.3) #4, !dbg !345
  unreachable, !dbg !345

40:                                               ; No predecessors!
  br label %42, !dbg !345

41:                                               ; preds = %30
  br label %42, !dbg !345

42:                                               ; preds = %41, %40
  call void @mutex_unlock(ptr noundef %1), !dbg !346
  call void @mutex_unlock(ptr noundef %2), !dbg !347
  call void @mutex_destroy(ptr noundef %2), !dbg !348
  call void @mutex_destroy(ptr noundef %1), !dbg !349
  ret void, !dbg !350
}

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_init(ptr noundef %0) #0 !dbg !351 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca %struct._opaque_pthread_condattr_t, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !355, metadata !DIExpression()), !dbg !356
  call void @llvm.dbg.declare(metadata ptr %3, metadata !357, metadata !DIExpression()), !dbg !358
  call void @llvm.dbg.declare(metadata ptr %4, metadata !359, metadata !DIExpression()), !dbg !367
  %5 = call i32 @pthread_condattr_init(ptr noundef %4), !dbg !368
  store i32 %5, ptr %3, align 4, !dbg !369
  %6 = load i32, ptr %3, align 4, !dbg !370
  %7 = icmp eq i32 %6, 0, !dbg !370
  %8 = xor i1 %7, true, !dbg !370
  %9 = zext i1 %8 to i32, !dbg !370
  %10 = sext i32 %9 to i64, !dbg !370
  %11 = icmp ne i64 %10, 0, !dbg !370
  br i1 %11, label %12, label %14, !dbg !370

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 154, ptr noundef @.str.1) #4, !dbg !370
  unreachable, !dbg !370

13:                                               ; No predecessors!
  br label %15, !dbg !370

14:                                               ; preds = %1
  br label %15, !dbg !370

15:                                               ; preds = %14, %13
  %16 = load ptr, ptr %2, align 8, !dbg !371
  %17 = call i32 @"\01_pthread_cond_init"(ptr noundef %16, ptr noundef %4), !dbg !372
  store i32 %17, ptr %3, align 4, !dbg !373
  %18 = load i32, ptr %3, align 4, !dbg !374
  %19 = icmp eq i32 %18, 0, !dbg !374
  %20 = xor i1 %19, true, !dbg !374
  %21 = zext i1 %20 to i32, !dbg !374
  %22 = sext i32 %21 to i64, !dbg !374
  %23 = icmp ne i64 %22, 0, !dbg !374
  br i1 %23, label %24, label %26, !dbg !374

24:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 157, ptr noundef @.str.1) #4, !dbg !374
  unreachable, !dbg !374

25:                                               ; No predecessors!
  br label %27, !dbg !374

26:                                               ; preds = %15
  br label %27, !dbg !374

27:                                               ; preds = %26, %25
  %28 = call i32 @pthread_condattr_destroy(ptr noundef %4), !dbg !375
  store i32 %28, ptr %3, align 4, !dbg !376
  %29 = load i32, ptr %3, align 4, !dbg !377
  %30 = icmp eq i32 %29, 0, !dbg !377
  %31 = xor i1 %30, true, !dbg !377
  %32 = zext i1 %31 to i32, !dbg !377
  %33 = sext i32 %32 to i64, !dbg !377
  %34 = icmp ne i64 %33, 0, !dbg !377
  br i1 %34, label %35, label %37, !dbg !377

35:                                               ; preds = %27
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 160, ptr noundef @.str.1) #4, !dbg !377
  unreachable, !dbg !377

36:                                               ; No predecessors!
  br label %38, !dbg !377

37:                                               ; preds = %27
  br label %38, !dbg !377

38:                                               ; preds = %37, %36
  ret void, !dbg !378
}

declare i32 @pthread_condattr_init(ptr noundef) #2

declare i32 @"\01_pthread_cond_init"(ptr noundef, ptr noundef) #2

declare i32 @pthread_condattr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_destroy(ptr noundef %0) #0 !dbg !379 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !380, metadata !DIExpression()), !dbg !381
  call void @llvm.dbg.declare(metadata ptr %3, metadata !382, metadata !DIExpression()), !dbg !383
  %4 = load ptr, ptr %2, align 8, !dbg !384
  %5 = call i32 @pthread_cond_destroy(ptr noundef %4), !dbg !385
  store i32 %5, ptr %3, align 4, !dbg !383
  %6 = load i32, ptr %3, align 4, !dbg !386
  %7 = icmp eq i32 %6, 0, !dbg !386
  %8 = xor i1 %7, true, !dbg !386
  %9 = zext i1 %8 to i32, !dbg !386
  %10 = sext i32 %9 to i64, !dbg !386
  %11 = icmp ne i64 %10, 0, !dbg !386
  br i1 %11, label %12, label %14, !dbg !386

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_destroy, ptr noundef @.str, i32 noundef 166, ptr noundef @.str.1) #4, !dbg !386
  unreachable, !dbg !386

13:                                               ; No predecessors!
  br label %15, !dbg !386

14:                                               ; preds = %1
  br label %15, !dbg !386

15:                                               ; preds = %14, %13
  ret void, !dbg !387
}

declare i32 @pthread_cond_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_signal(ptr noundef %0) #0 !dbg !388 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !389, metadata !DIExpression()), !dbg !390
  call void @llvm.dbg.declare(metadata ptr %3, metadata !391, metadata !DIExpression()), !dbg !392
  %4 = load ptr, ptr %2, align 8, !dbg !393
  %5 = call i32 @pthread_cond_signal(ptr noundef %4), !dbg !394
  store i32 %5, ptr %3, align 4, !dbg !392
  %6 = load i32, ptr %3, align 4, !dbg !395
  %7 = icmp eq i32 %6, 0, !dbg !395
  %8 = xor i1 %7, true, !dbg !395
  %9 = zext i1 %8 to i32, !dbg !395
  %10 = sext i32 %9 to i64, !dbg !395
  %11 = icmp ne i64 %10, 0, !dbg !395
  br i1 %11, label %12, label %14, !dbg !395

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_signal, ptr noundef @.str, i32 noundef 172, ptr noundef @.str.1) #4, !dbg !395
  unreachable, !dbg !395

13:                                               ; No predecessors!
  br label %15, !dbg !395

14:                                               ; preds = %1
  br label %15, !dbg !395

15:                                               ; preds = %14, %13
  ret void, !dbg !396
}

declare i32 @pthread_cond_signal(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_broadcast(ptr noundef %0) #0 !dbg !397 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !398, metadata !DIExpression()), !dbg !399
  call void @llvm.dbg.declare(metadata ptr %3, metadata !400, metadata !DIExpression()), !dbg !401
  %4 = load ptr, ptr %2, align 8, !dbg !402
  %5 = call i32 @pthread_cond_broadcast(ptr noundef %4), !dbg !403
  store i32 %5, ptr %3, align 4, !dbg !401
  %6 = load i32, ptr %3, align 4, !dbg !404
  %7 = icmp eq i32 %6, 0, !dbg !404
  %8 = xor i1 %7, true, !dbg !404
  %9 = zext i1 %8 to i32, !dbg !404
  %10 = sext i32 %9 to i64, !dbg !404
  %11 = icmp ne i64 %10, 0, !dbg !404
  br i1 %11, label %12, label %14, !dbg !404

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_broadcast, ptr noundef @.str, i32 noundef 178, ptr noundef @.str.1) #4, !dbg !404
  unreachable, !dbg !404

13:                                               ; No predecessors!
  br label %15, !dbg !404

14:                                               ; preds = %1
  br label %15, !dbg !404

15:                                               ; preds = %14, %13
  ret void, !dbg !405
}

declare i32 @pthread_cond_broadcast(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_wait(ptr noundef %0, ptr noundef %1) #0 !dbg !406 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !409, metadata !DIExpression()), !dbg !410
  store ptr %1, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !411, metadata !DIExpression()), !dbg !412
  call void @llvm.dbg.declare(metadata ptr %5, metadata !413, metadata !DIExpression()), !dbg !414
  %6 = load ptr, ptr %3, align 8, !dbg !415
  %7 = load ptr, ptr %4, align 8, !dbg !416
  %8 = call i32 @"\01_pthread_cond_wait"(ptr noundef %6, ptr noundef %7), !dbg !417
  store i32 %8, ptr %5, align 4, !dbg !414
  ret void, !dbg !418
}

declare i32 @"\01_pthread_cond_wait"(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_timedwait(ptr noundef %0, ptr noundef %1, i64 noundef %2) #0 !dbg !419 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i64, align 8
  %7 = alloca %struct.timespec, align 8
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !423, metadata !DIExpression()), !dbg !424
  store ptr %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !425, metadata !DIExpression()), !dbg !426
  store i64 %2, ptr %6, align 8
  call void @llvm.dbg.declare(metadata ptr %6, metadata !427, metadata !DIExpression()), !dbg !428
  call void @llvm.dbg.declare(metadata ptr %7, metadata !429, metadata !DIExpression()), !dbg !437
  %9 = load i64, ptr %6, align 8, !dbg !438
  call void @llvm.dbg.declare(metadata ptr %8, metadata !439, metadata !DIExpression()), !dbg !440
  %10 = load ptr, ptr %4, align 8, !dbg !441
  %11 = load ptr, ptr %5, align 8, !dbg !442
  %12 = call i32 @"\01_pthread_cond_timedwait"(ptr noundef %10, ptr noundef %11, ptr noundef %7), !dbg !443
  store i32 %12, ptr %8, align 4, !dbg !440
  ret void, !dbg !444
}

declare i32 @"\01_pthread_cond_timedwait"(ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define ptr @cond_worker(ptr noundef %0) #0 !dbg !445 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i8, align 1
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !446, metadata !DIExpression()), !dbg !447
  call void @llvm.dbg.declare(metadata ptr %4, metadata !448, metadata !DIExpression()), !dbg !449
  store i8 1, ptr %4, align 1, !dbg !449
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !450
  %5 = load i32, ptr @phase, align 4, !dbg !452
  %6 = add nsw i32 %5, 1, !dbg !452
  store i32 %6, ptr @phase, align 4, !dbg !452
  call void @cond_wait(ptr noundef @cond, ptr noundef @cond_mutex), !dbg !453
  %7 = load i32, ptr @phase, align 4, !dbg !454
  %8 = add nsw i32 %7, 1, !dbg !454
  store i32 %8, ptr @phase, align 4, !dbg !454
  %9 = load i32, ptr @phase, align 4, !dbg !455
  %10 = icmp slt i32 %9, 2, !dbg !456
  %11 = zext i1 %10 to i8, !dbg !457
  store i8 %11, ptr %4, align 1, !dbg !457
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !458
  %12 = load i8, ptr %4, align 1, !dbg !459
  %13 = trunc i8 %12 to i1, !dbg !459
  br i1 %13, label %14, label %17, !dbg !461

14:                                               ; preds = %1
  %15 = load ptr, ptr %3, align 8, !dbg !462
  %16 = getelementptr inbounds i8, ptr %15, i64 1, !dbg !463
  store ptr %16, ptr %2, align 8, !dbg !464
  br label %32, !dbg !464

17:                                               ; preds = %1
  store i8 1, ptr %4, align 1, !dbg !465
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !466
  %18 = load i32, ptr @phase, align 4, !dbg !468
  %19 = add nsw i32 %18, 1, !dbg !468
  store i32 %19, ptr @phase, align 4, !dbg !468
  call void @cond_timedwait(ptr noundef @cond, ptr noundef @cond_mutex, i64 noundef 10), !dbg !469
  %20 = load i32, ptr @phase, align 4, !dbg !470
  %21 = add nsw i32 %20, 1, !dbg !470
  store i32 %21, ptr @phase, align 4, !dbg !470
  %22 = load i32, ptr @phase, align 4, !dbg !471
  %23 = icmp sgt i32 %22, 6, !dbg !472
  %24 = zext i1 %23 to i8, !dbg !473
  store i8 %24, ptr %4, align 1, !dbg !473
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !474
  %25 = load i8, ptr %4, align 1, !dbg !475
  %26 = trunc i8 %25 to i1, !dbg !475
  br i1 %26, label %27, label %30, !dbg !477

27:                                               ; preds = %17
  %28 = load ptr, ptr %3, align 8, !dbg !478
  %29 = getelementptr inbounds i8, ptr %28, i64 2, !dbg !479
  store ptr %29, ptr %2, align 8, !dbg !480
  br label %32, !dbg !480

30:                                               ; preds = %17
  %31 = load ptr, ptr %3, align 8, !dbg !481
  store ptr %31, ptr %2, align 8, !dbg !482
  br label %32, !dbg !482

32:                                               ; preds = %30, %27, %14
  %33 = load ptr, ptr %2, align 8, !dbg !483
  ret ptr %33, !dbg !483
}

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_test() #0 !dbg !484 {
  %1 = alloca ptr, align 8
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  call void @llvm.dbg.declare(metadata ptr %1, metadata !485, metadata !DIExpression()), !dbg !486
  store ptr inttoptr (i64 42 to ptr), ptr %1, align 8, !dbg !486
  call void @mutex_init(ptr noundef @cond_mutex, i32 noundef 0, i32 noundef 0, i32 noundef 3, i32 noundef 0), !dbg !487
  call void @cond_init(ptr noundef @cond), !dbg !488
  call void @llvm.dbg.declare(metadata ptr %2, metadata !489, metadata !DIExpression()), !dbg !490
  %4 = load ptr, ptr %1, align 8, !dbg !491
  %5 = call ptr @thread_create(ptr noundef @cond_worker, ptr noundef %4), !dbg !492
  store ptr %5, ptr %2, align 8, !dbg !490
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !493
  %6 = load i32, ptr @phase, align 4, !dbg !495
  %7 = add nsw i32 %6, 1, !dbg !495
  store i32 %7, ptr @phase, align 4, !dbg !495
  call void @cond_signal(ptr noundef @cond), !dbg !496
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !497
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !498
  %8 = load i32, ptr @phase, align 4, !dbg !500
  %9 = add nsw i32 %8, 1, !dbg !500
  store i32 %9, ptr @phase, align 4, !dbg !500
  call void @cond_broadcast(ptr noundef @cond), !dbg !501
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !502
  call void @llvm.dbg.declare(metadata ptr %3, metadata !503, metadata !DIExpression()), !dbg !504
  %10 = load ptr, ptr %2, align 8, !dbg !505
  %11 = call ptr @thread_join(ptr noundef %10), !dbg !506
  store ptr %11, ptr %3, align 8, !dbg !504
  %12 = load ptr, ptr %3, align 8, !dbg !507
  %13 = load ptr, ptr %1, align 8, !dbg !507
  %14 = icmp eq ptr %12, %13, !dbg !507
  %15 = xor i1 %14, true, !dbg !507
  %16 = zext i1 %15 to i32, !dbg !507
  %17 = sext i32 %16 to i64, !dbg !507
  %18 = icmp ne i64 %17, 0, !dbg !507
  br i1 %18, label %19, label %21, !dbg !507

19:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.cond_test, ptr noundef @.str, i32 noundef 252, ptr noundef @.str.4) #4, !dbg !507
  unreachable, !dbg !507

20:                                               ; No predecessors!
  br label %22, !dbg !507

21:                                               ; preds = %0
  br label %22, !dbg !507

22:                                               ; preds = %21, %20
  call void @cond_destroy(ptr noundef @cond), !dbg !508
  call void @mutex_destroy(ptr noundef @cond_mutex), !dbg !509
  ret void, !dbg !510
}

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_init(ptr noundef %0, i32 noundef %1) #0 !dbg !511 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca %struct._opaque_pthread_rwlockattr_t, align 8
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !525, metadata !DIExpression()), !dbg !526
  store i32 %1, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !527, metadata !DIExpression()), !dbg !528
  call void @llvm.dbg.declare(metadata ptr %5, metadata !529, metadata !DIExpression()), !dbg !530
  call void @llvm.dbg.declare(metadata ptr %6, metadata !531, metadata !DIExpression()), !dbg !532
  call void @llvm.dbg.declare(metadata ptr %7, metadata !533, metadata !DIExpression()), !dbg !544
  %8 = call i32 @pthread_rwlockattr_init(ptr noundef %7), !dbg !545
  store i32 %8, ptr %5, align 4, !dbg !546
  %9 = load i32, ptr %5, align 4, !dbg !547
  %10 = icmp eq i32 %9, 0, !dbg !547
  %11 = xor i1 %10, true, !dbg !547
  %12 = zext i1 %11 to i32, !dbg !547
  %13 = sext i32 %12 to i64, !dbg !547
  %14 = icmp ne i64 %13, 0, !dbg !547
  br i1 %14, label %15, label %17, !dbg !547

15:                                               ; preds = %2
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 269, ptr noundef @.str.1) #4, !dbg !547
  unreachable, !dbg !547

16:                                               ; No predecessors!
  br label %18, !dbg !547

17:                                               ; preds = %2
  br label %18, !dbg !547

18:                                               ; preds = %17, %16
  %19 = load i32, ptr %4, align 4, !dbg !548
  %20 = call i32 @pthread_rwlockattr_setpshared(ptr noundef %7, i32 noundef %19), !dbg !549
  store i32 %20, ptr %5, align 4, !dbg !550
  %21 = load i32, ptr %5, align 4, !dbg !551
  %22 = icmp eq i32 %21, 0, !dbg !551
  %23 = xor i1 %22, true, !dbg !551
  %24 = zext i1 %23 to i32, !dbg !551
  %25 = sext i32 %24 to i64, !dbg !551
  %26 = icmp ne i64 %25, 0, !dbg !551
  br i1 %26, label %27, label %29, !dbg !551

27:                                               ; preds = %18
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 272, ptr noundef @.str.1) #4, !dbg !551
  unreachable, !dbg !551

28:                                               ; No predecessors!
  br label %30, !dbg !551

29:                                               ; preds = %18
  br label %30, !dbg !551

30:                                               ; preds = %29, %28
  %31 = call i32 @pthread_rwlockattr_getpshared(ptr noundef %7, ptr noundef %6), !dbg !552
  store i32 %31, ptr %5, align 4, !dbg !553
  %32 = load i32, ptr %5, align 4, !dbg !554
  %33 = icmp eq i32 %32, 0, !dbg !554
  %34 = xor i1 %33, true, !dbg !554
  %35 = zext i1 %34 to i32, !dbg !554
  %36 = sext i32 %35 to i64, !dbg !554
  %37 = icmp ne i64 %36, 0, !dbg !554
  br i1 %37, label %38, label %40, !dbg !554

38:                                               ; preds = %30
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 274, ptr noundef @.str.1) #4, !dbg !554
  unreachable, !dbg !554

39:                                               ; No predecessors!
  br label %41, !dbg !554

40:                                               ; preds = %30
  br label %41, !dbg !554

41:                                               ; preds = %40, %39
  %42 = load ptr, ptr %3, align 8, !dbg !555
  %43 = call i32 @"\01_pthread_rwlock_init"(ptr noundef %42, ptr noundef %7), !dbg !556
  store i32 %43, ptr %5, align 4, !dbg !557
  %44 = load i32, ptr %5, align 4, !dbg !558
  %45 = icmp eq i32 %44, 0, !dbg !558
  %46 = xor i1 %45, true, !dbg !558
  %47 = zext i1 %46 to i32, !dbg !558
  %48 = sext i32 %47 to i64, !dbg !558
  %49 = icmp ne i64 %48, 0, !dbg !558
  br i1 %49, label %50, label %52, !dbg !558

50:                                               ; preds = %41
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 277, ptr noundef @.str.1) #4, !dbg !558
  unreachable, !dbg !558

51:                                               ; No predecessors!
  br label %53, !dbg !558

52:                                               ; preds = %41
  br label %53, !dbg !558

53:                                               ; preds = %52, %51
  %54 = call i32 @pthread_rwlockattr_destroy(ptr noundef %7), !dbg !559
  store i32 %54, ptr %5, align 4, !dbg !560
  %55 = load i32, ptr %5, align 4, !dbg !561
  %56 = icmp eq i32 %55, 0, !dbg !561
  %57 = xor i1 %56, true, !dbg !561
  %58 = zext i1 %57 to i32, !dbg !561
  %59 = sext i32 %58 to i64, !dbg !561
  %60 = icmp ne i64 %59, 0, !dbg !561
  br i1 %60, label %61, label %63, !dbg !561

61:                                               ; preds = %53
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 279, ptr noundef @.str.1) #4, !dbg !561
  unreachable, !dbg !561

62:                                               ; No predecessors!
  br label %64, !dbg !561

63:                                               ; preds = %53
  br label %64, !dbg !561

64:                                               ; preds = %63, %62
  ret void, !dbg !562
}

declare i32 @pthread_rwlockattr_init(ptr noundef) #2

declare i32 @pthread_rwlockattr_setpshared(ptr noundef, i32 noundef) #2

declare i32 @pthread_rwlockattr_getpshared(ptr noundef, ptr noundef) #2

declare i32 @"\01_pthread_rwlock_init"(ptr noundef, ptr noundef) #2

declare i32 @pthread_rwlockattr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_destroy(ptr noundef %0) #0 !dbg !563 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !566, metadata !DIExpression()), !dbg !567
  call void @llvm.dbg.declare(metadata ptr %3, metadata !568, metadata !DIExpression()), !dbg !569
  %4 = load ptr, ptr %2, align 8, !dbg !570
  %5 = call i32 @"\01_pthread_rwlock_destroy"(ptr noundef %4), !dbg !571
  store i32 %5, ptr %3, align 4, !dbg !569
  %6 = load i32, ptr %3, align 4, !dbg !572
  %7 = icmp eq i32 %6, 0, !dbg !572
  %8 = xor i1 %7, true, !dbg !572
  %9 = zext i1 %8 to i32, !dbg !572
  %10 = sext i32 %9 to i64, !dbg !572
  %11 = icmp ne i64 %10, 0, !dbg !572
  br i1 %11, label %12, label %14, !dbg !572

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_destroy, ptr noundef @.str, i32 noundef 285, ptr noundef @.str.1) #4, !dbg !572
  unreachable, !dbg !572

13:                                               ; No predecessors!
  br label %15, !dbg !572

14:                                               ; preds = %1
  br label %15, !dbg !572

15:                                               ; preds = %14, %13
  ret void, !dbg !573
}

declare i32 @"\01_pthread_rwlock_destroy"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_wrlock(ptr noundef %0) #0 !dbg !574 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !575, metadata !DIExpression()), !dbg !576
  call void @llvm.dbg.declare(metadata ptr %3, metadata !577, metadata !DIExpression()), !dbg !578
  %4 = load ptr, ptr %2, align 8, !dbg !579
  %5 = call i32 @"\01_pthread_rwlock_wrlock"(ptr noundef %4), !dbg !580
  store i32 %5, ptr %3, align 4, !dbg !578
  %6 = load i32, ptr %3, align 4, !dbg !581
  %7 = icmp eq i32 %6, 0, !dbg !581
  %8 = xor i1 %7, true, !dbg !581
  %9 = zext i1 %8 to i32, !dbg !581
  %10 = sext i32 %9 to i64, !dbg !581
  %11 = icmp ne i64 %10, 0, !dbg !581
  br i1 %11, label %12, label %14, !dbg !581

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_wrlock, ptr noundef @.str, i32 noundef 291, ptr noundef @.str.1) #4, !dbg !581
  unreachable, !dbg !581

13:                                               ; No predecessors!
  br label %15, !dbg !581

14:                                               ; preds = %1
  br label %15, !dbg !581

15:                                               ; preds = %14, %13
  ret void, !dbg !582
}

declare i32 @"\01_pthread_rwlock_wrlock"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define zeroext i1 @rwlock_trywrlock(ptr noundef %0) #0 !dbg !583 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !586, metadata !DIExpression()), !dbg !587
  call void @llvm.dbg.declare(metadata ptr %3, metadata !588, metadata !DIExpression()), !dbg !589
  %4 = load ptr, ptr %2, align 8, !dbg !590
  %5 = call i32 @"\01_pthread_rwlock_trywrlock"(ptr noundef %4), !dbg !591
  store i32 %5, ptr %3, align 4, !dbg !589
  %6 = load i32, ptr %3, align 4, !dbg !592
  %7 = icmp eq i32 %6, 0, !dbg !593
  ret i1 %7, !dbg !594
}

declare i32 @"\01_pthread_rwlock_trywrlock"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_rdlock(ptr noundef %0) #0 !dbg !595 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !596, metadata !DIExpression()), !dbg !597
  call void @llvm.dbg.declare(metadata ptr %3, metadata !598, metadata !DIExpression()), !dbg !599
  %4 = load ptr, ptr %2, align 8, !dbg !600
  %5 = call i32 @"\01_pthread_rwlock_rdlock"(ptr noundef %4), !dbg !601
  store i32 %5, ptr %3, align 4, !dbg !599
  %6 = load i32, ptr %3, align 4, !dbg !602
  %7 = icmp eq i32 %6, 0, !dbg !602
  %8 = xor i1 %7, true, !dbg !602
  %9 = zext i1 %8 to i32, !dbg !602
  %10 = sext i32 %9 to i64, !dbg !602
  %11 = icmp ne i64 %10, 0, !dbg !602
  br i1 %11, label %12, label %14, !dbg !602

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_rdlock, ptr noundef @.str, i32 noundef 304, ptr noundef @.str.1) #4, !dbg !602
  unreachable, !dbg !602

13:                                               ; No predecessors!
  br label %15, !dbg !602

14:                                               ; preds = %1
  br label %15, !dbg !602

15:                                               ; preds = %14, %13
  ret void, !dbg !603
}

declare i32 @"\01_pthread_rwlock_rdlock"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define zeroext i1 @rwlock_tryrdlock(ptr noundef %0) #0 !dbg !604 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !605, metadata !DIExpression()), !dbg !606
  call void @llvm.dbg.declare(metadata ptr %3, metadata !607, metadata !DIExpression()), !dbg !608
  %4 = load ptr, ptr %2, align 8, !dbg !609
  %5 = call i32 @"\01_pthread_rwlock_tryrdlock"(ptr noundef %4), !dbg !610
  store i32 %5, ptr %3, align 4, !dbg !608
  %6 = load i32, ptr %3, align 4, !dbg !611
  %7 = icmp eq i32 %6, 0, !dbg !612
  ret i1 %7, !dbg !613
}

declare i32 @"\01_pthread_rwlock_tryrdlock"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_unlock(ptr noundef %0) #0 !dbg !614 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !615, metadata !DIExpression()), !dbg !616
  call void @llvm.dbg.declare(metadata ptr %3, metadata !617, metadata !DIExpression()), !dbg !618
  %4 = load ptr, ptr %2, align 8, !dbg !619
  %5 = call i32 @"\01_pthread_rwlock_unlock"(ptr noundef %4), !dbg !620
  store i32 %5, ptr %3, align 4, !dbg !618
  %6 = load i32, ptr %3, align 4, !dbg !621
  %7 = icmp eq i32 %6, 0, !dbg !621
  %8 = xor i1 %7, true, !dbg !621
  %9 = zext i1 %8 to i32, !dbg !621
  %10 = sext i32 %9 to i64, !dbg !621
  %11 = icmp ne i64 %10, 0, !dbg !621
  br i1 %11, label %12, label %14, !dbg !621

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_unlock, ptr noundef @.str, i32 noundef 317, ptr noundef @.str.1) #4, !dbg !621
  unreachable, !dbg !621

13:                                               ; No predecessors!
  br label %15, !dbg !621

14:                                               ; preds = %1
  br label %15, !dbg !621

15:                                               ; preds = %14, %13
  ret void, !dbg !622
}

declare i32 @"\01_pthread_rwlock_unlock"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_test() #0 !dbg !623 {
  %1 = alloca %struct._opaque_pthread_rwlock_t, align 8
  %2 = alloca i32, align 4
  %3 = alloca i8, align 1
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  %6 = alloca i8, align 1
  %7 = alloca i32, align 4
  %8 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata ptr %1, metadata !624, metadata !DIExpression()), !dbg !625
  call void @rwlock_init(ptr noundef %1, i32 noundef 2), !dbg !626
  call void @llvm.dbg.declare(metadata ptr %2, metadata !627, metadata !DIExpression()), !dbg !629
  store i32 4, ptr %2, align 4, !dbg !629
  call void @rwlock_wrlock(ptr noundef %1), !dbg !630
  call void @llvm.dbg.declare(metadata ptr %3, metadata !632, metadata !DIExpression()), !dbg !633
  %9 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !634
  %10 = zext i1 %9 to i8, !dbg !633
  store i8 %10, ptr %3, align 1, !dbg !633
  %11 = load i8, ptr %3, align 1, !dbg !635
  %12 = trunc i8 %11 to i1, !dbg !635
  %13 = xor i1 %12, true, !dbg !635
  %14 = xor i1 %13, true, !dbg !635
  %15 = zext i1 %14 to i32, !dbg !635
  %16 = sext i32 %15 to i64, !dbg !635
  %17 = icmp ne i64 %16, 0, !dbg !635
  br i1 %17, label %18, label %20, !dbg !635

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 329, ptr noundef @.str.2) #4, !dbg !635
  unreachable, !dbg !635

19:                                               ; No predecessors!
  br label %21, !dbg !635

20:                                               ; preds = %0
  br label %21, !dbg !635

21:                                               ; preds = %20, %19
  %22 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %1), !dbg !636
  %23 = zext i1 %22 to i8, !dbg !637
  store i8 %23, ptr %3, align 1, !dbg !637
  %24 = load i8, ptr %3, align 1, !dbg !638
  %25 = trunc i8 %24 to i1, !dbg !638
  %26 = xor i1 %25, true, !dbg !638
  %27 = xor i1 %26, true, !dbg !638
  %28 = zext i1 %27 to i32, !dbg !638
  %29 = sext i32 %28 to i64, !dbg !638
  %30 = icmp ne i64 %29, 0, !dbg !638
  br i1 %30, label %31, label %33, !dbg !638

31:                                               ; preds = %21
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 331, ptr noundef @.str.2) #4, !dbg !638
  unreachable, !dbg !638

32:                                               ; No predecessors!
  br label %34, !dbg !638

33:                                               ; preds = %21
  br label %34, !dbg !638

34:                                               ; preds = %33, %32
  call void @rwlock_unlock(ptr noundef %1), !dbg !639
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !640
  call void @llvm.dbg.declare(metadata ptr %4, metadata !642, metadata !DIExpression()), !dbg !644
  store i32 0, ptr %4, align 4, !dbg !644
  br label %35, !dbg !645

35:                                               ; preds = %51, %34
  %36 = load i32, ptr %4, align 4, !dbg !646
  %37 = icmp slt i32 %36, 4, !dbg !648
  br i1 %37, label %38, label %54, !dbg !649

38:                                               ; preds = %35
  call void @llvm.dbg.declare(metadata ptr %5, metadata !650, metadata !DIExpression()), !dbg !652
  %39 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %1), !dbg !653
  %40 = zext i1 %39 to i8, !dbg !652
  store i8 %40, ptr %5, align 1, !dbg !652
  %41 = load i8, ptr %5, align 1, !dbg !654
  %42 = trunc i8 %41 to i1, !dbg !654
  %43 = xor i1 %42, true, !dbg !654
  %44 = zext i1 %43 to i32, !dbg !654
  %45 = sext i32 %44 to i64, !dbg !654
  %46 = icmp ne i64 %45, 0, !dbg !654
  br i1 %46, label %47, label %49, !dbg !654

47:                                               ; preds = %38
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 340, ptr noundef @.str.3) #4, !dbg !654
  unreachable, !dbg !654

48:                                               ; No predecessors!
  br label %50, !dbg !654

49:                                               ; preds = %38
  br label %50, !dbg !654

50:                                               ; preds = %49, %48
  br label %51, !dbg !655

51:                                               ; preds = %50
  %52 = load i32, ptr %4, align 4, !dbg !656
  %53 = add nsw i32 %52, 1, !dbg !656
  store i32 %53, ptr %4, align 4, !dbg !656
  br label %35, !dbg !657, !llvm.loop !658

54:                                               ; preds = %35
  call void @llvm.dbg.declare(metadata ptr %6, metadata !661, metadata !DIExpression()), !dbg !663
  %55 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !664
  %56 = zext i1 %55 to i8, !dbg !663
  store i8 %56, ptr %6, align 1, !dbg !663
  %57 = load i8, ptr %6, align 1, !dbg !665
  %58 = trunc i8 %57 to i1, !dbg !665
  %59 = xor i1 %58, true, !dbg !665
  %60 = xor i1 %59, true, !dbg !665
  %61 = zext i1 %60 to i32, !dbg !665
  %62 = sext i32 %61 to i64, !dbg !665
  %63 = icmp ne i64 %62, 0, !dbg !665
  br i1 %63, label %64, label %66, !dbg !665

64:                                               ; preds = %54
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 345, ptr noundef @.str.2) #4, !dbg !665
  unreachable, !dbg !665

65:                                               ; No predecessors!
  br label %67, !dbg !665

66:                                               ; preds = %54
  br label %67, !dbg !665

67:                                               ; preds = %66, %65
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !666
  call void @llvm.dbg.declare(metadata ptr %7, metadata !667, metadata !DIExpression()), !dbg !669
  store i32 0, ptr %7, align 4, !dbg !669
  br label %68, !dbg !670

68:                                               ; preds = %72, %67
  %69 = load i32, ptr %7, align 4, !dbg !671
  %70 = icmp slt i32 %69, 4, !dbg !673
  br i1 %70, label %71, label %75, !dbg !674

71:                                               ; preds = %68
  call void @rwlock_unlock(ptr noundef %1), !dbg !675
  br label %72, !dbg !677

72:                                               ; preds = %71
  %73 = load i32, ptr %7, align 4, !dbg !678
  %74 = add nsw i32 %73, 1, !dbg !678
  store i32 %74, ptr %7, align 4, !dbg !678
  br label %68, !dbg !679, !llvm.loop !680

75:                                               ; preds = %68
  call void @rwlock_wrlock(ptr noundef %1), !dbg !682
  call void @llvm.dbg.declare(metadata ptr %8, metadata !684, metadata !DIExpression()), !dbg !685
  %76 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !686
  %77 = zext i1 %76 to i8, !dbg !685
  store i8 %77, ptr %8, align 1, !dbg !685
  call void @rwlock_unlock(ptr noundef %1), !dbg !687
  call void @rwlock_destroy(ptr noundef %1), !dbg !688
  ret void, !dbg !689
}

declare void @__VERIFIER_loop_bound(i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @key_destroy(ptr noundef %0) #0 !dbg !690 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !691, metadata !DIExpression()), !dbg !692
  %3 = call ptr @pthread_self(), !dbg !693
  store ptr %3, ptr @latest_thread, align 8, !dbg !694
  ret void, !dbg !695
}

declare ptr @pthread_self() #2

; Function Attrs: noinline nounwind ssp uwtable
define ptr @key_worker(ptr noundef %0) #0 !dbg !696 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !697, metadata !DIExpression()), !dbg !698
  call void @llvm.dbg.declare(metadata ptr %3, metadata !699, metadata !DIExpression()), !dbg !700
  store i32 1, ptr %3, align 4, !dbg !700
  call void @llvm.dbg.declare(metadata ptr %4, metadata !701, metadata !DIExpression()), !dbg !702
  %6 = load i64, ptr @local_data, align 8, !dbg !703
  %7 = call i32 @pthread_setspecific(i64 noundef %6, ptr noundef %3), !dbg !704
  store i32 %7, ptr %4, align 4, !dbg !702
  %8 = load i32, ptr %4, align 4, !dbg !705
  %9 = icmp eq i32 %8, 0, !dbg !705
  %10 = xor i1 %9, true, !dbg !705
  %11 = zext i1 %10 to i32, !dbg !705
  %12 = sext i32 %11 to i64, !dbg !705
  %13 = icmp ne i64 %12, 0, !dbg !705
  br i1 %13, label %14, label %16, !dbg !705

14:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.key_worker, ptr noundef @.str, i32 noundef 378, ptr noundef @.str.1) #4, !dbg !705
  unreachable, !dbg !705

15:                                               ; No predecessors!
  br label %17, !dbg !705

16:                                               ; preds = %1
  br label %17, !dbg !705

17:                                               ; preds = %16, %15
  call void @llvm.dbg.declare(metadata ptr %5, metadata !706, metadata !DIExpression()), !dbg !707
  %18 = load i64, ptr @local_data, align 8, !dbg !708
  %19 = call ptr @pthread_getspecific(i64 noundef %18), !dbg !709
  store ptr %19, ptr %5, align 8, !dbg !707
  %20 = load ptr, ptr %5, align 8, !dbg !710
  %21 = icmp eq ptr %20, %3, !dbg !710
  %22 = xor i1 %21, true, !dbg !710
  %23 = zext i1 %22 to i32, !dbg !710
  %24 = sext i32 %23 to i64, !dbg !710
  %25 = icmp ne i64 %24, 0, !dbg !710
  br i1 %25, label %26, label %28, !dbg !710

26:                                               ; preds = %17
  call void @__assert_rtn(ptr noundef @__func__.key_worker, ptr noundef @.str, i32 noundef 381, ptr noundef @.str.5) #4, !dbg !710
  unreachable, !dbg !710

27:                                               ; No predecessors!
  br label %29, !dbg !710

28:                                               ; preds = %17
  br label %29, !dbg !710

29:                                               ; preds = %28, %27
  %30 = load ptr, ptr %2, align 8, !dbg !711
  ret ptr %30, !dbg !712
}

declare i32 @pthread_setspecific(i64 noundef, ptr noundef) #2

declare ptr @pthread_getspecific(i64 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @key_test() #0 !dbg !713 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  call void @llvm.dbg.declare(metadata ptr %1, metadata !714, metadata !DIExpression()), !dbg !715
  store i32 2, ptr %1, align 4, !dbg !715
  call void @llvm.dbg.declare(metadata ptr %2, metadata !716, metadata !DIExpression()), !dbg !717
  store ptr inttoptr (i64 41 to ptr), ptr %2, align 8, !dbg !717
  call void @llvm.dbg.declare(metadata ptr %3, metadata !718, metadata !DIExpression()), !dbg !719
  %7 = call i32 @pthread_key_create(ptr noundef @local_data, ptr noundef @key_destroy), !dbg !720
  call void @llvm.dbg.declare(metadata ptr %4, metadata !721, metadata !DIExpression()), !dbg !722
  %8 = load ptr, ptr %2, align 8, !dbg !723
  %9 = call ptr @thread_create(ptr noundef @key_worker, ptr noundef %8), !dbg !724
  store ptr %9, ptr %4, align 8, !dbg !722
  %10 = load i64, ptr @local_data, align 8, !dbg !725
  %11 = call i32 @pthread_setspecific(i64 noundef %10, ptr noundef %1), !dbg !726
  store i32 %11, ptr %3, align 4, !dbg !727
  %12 = load i32, ptr %3, align 4, !dbg !728
  %13 = icmp eq i32 %12, 0, !dbg !728
  %14 = xor i1 %13, true, !dbg !728
  %15 = zext i1 %14 to i32, !dbg !728
  %16 = sext i32 %15 to i64, !dbg !728
  %17 = icmp ne i64 %16, 0, !dbg !728
  br i1 %17, label %18, label %20, !dbg !728

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 397, ptr noundef @.str.1) #4, !dbg !728
  unreachable, !dbg !728

19:                                               ; No predecessors!
  br label %21, !dbg !728

20:                                               ; preds = %0
  br label %21, !dbg !728

21:                                               ; preds = %20, %19
  call void @llvm.dbg.declare(metadata ptr %5, metadata !729, metadata !DIExpression()), !dbg !730
  %22 = load i64, ptr @local_data, align 8, !dbg !731
  %23 = call ptr @pthread_getspecific(i64 noundef %22), !dbg !732
  store ptr %23, ptr %5, align 8, !dbg !730
  %24 = load ptr, ptr %5, align 8, !dbg !733
  %25 = icmp eq ptr %24, %1, !dbg !733
  %26 = xor i1 %25, true, !dbg !733
  %27 = zext i1 %26 to i32, !dbg !733
  %28 = sext i32 %27 to i64, !dbg !733
  %29 = icmp ne i64 %28, 0, !dbg !733
  br i1 %29, label %30, label %32, !dbg !733

30:                                               ; preds = %21
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 400, ptr noundef @.str.5) #4, !dbg !733
  unreachable, !dbg !733

31:                                               ; No predecessors!
  br label %33, !dbg !733

32:                                               ; preds = %21
  br label %33, !dbg !733

33:                                               ; preds = %32, %31
  %34 = load i64, ptr @local_data, align 8, !dbg !734
  %35 = call i32 @pthread_setspecific(i64 noundef %34, ptr noundef null), !dbg !735
  store i32 %35, ptr %3, align 4, !dbg !736
  %36 = load i32, ptr %3, align 4, !dbg !737
  %37 = icmp eq i32 %36, 0, !dbg !737
  %38 = xor i1 %37, true, !dbg !737
  %39 = zext i1 %38 to i32, !dbg !737
  %40 = sext i32 %39 to i64, !dbg !737
  %41 = icmp ne i64 %40, 0, !dbg !737
  br i1 %41, label %42, label %44, !dbg !737

42:                                               ; preds = %33
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 403, ptr noundef @.str.1) #4, !dbg !737
  unreachable, !dbg !737

43:                                               ; No predecessors!
  br label %45, !dbg !737

44:                                               ; preds = %33
  br label %45, !dbg !737

45:                                               ; preds = %44, %43
  call void @llvm.dbg.declare(metadata ptr %6, metadata !738, metadata !DIExpression()), !dbg !739
  %46 = load ptr, ptr %4, align 8, !dbg !740
  %47 = call ptr @thread_join(ptr noundef %46), !dbg !741
  store ptr %47, ptr %6, align 8, !dbg !739
  %48 = load ptr, ptr %6, align 8, !dbg !742
  %49 = load ptr, ptr %2, align 8, !dbg !742
  %50 = icmp eq ptr %48, %49, !dbg !742
  %51 = xor i1 %50, true, !dbg !742
  %52 = zext i1 %51 to i32, !dbg !742
  %53 = sext i32 %52 to i64, !dbg !742
  %54 = icmp ne i64 %53, 0, !dbg !742
  br i1 %54, label %55, label %57, !dbg !742

55:                                               ; preds = %45
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 406, ptr noundef @.str.4) #4, !dbg !742
  unreachable, !dbg !742

56:                                               ; No predecessors!
  br label %58, !dbg !742

57:                                               ; preds = %45
  br label %58, !dbg !742

58:                                               ; preds = %57, %56
  %59 = load i64, ptr @local_data, align 8, !dbg !743
  %60 = call i32 @pthread_key_delete(i64 noundef %59), !dbg !744
  store i32 %60, ptr %3, align 4, !dbg !745
  %61 = load i32, ptr %3, align 4, !dbg !746
  %62 = icmp eq i32 %61, 0, !dbg !746
  %63 = xor i1 %62, true, !dbg !746
  %64 = zext i1 %63 to i32, !dbg !746
  %65 = sext i32 %64 to i64, !dbg !746
  %66 = icmp ne i64 %65, 0, !dbg !746
  br i1 %66, label %67, label %69, !dbg !746

67:                                               ; preds = %58
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 409, ptr noundef @.str.1) #4, !dbg !746
  unreachable, !dbg !746

68:                                               ; No predecessors!
  br label %70, !dbg !746

69:                                               ; preds = %58
  br label %70, !dbg !746

70:                                               ; preds = %69, %68
  %71 = load ptr, ptr @latest_thread, align 8, !dbg !747
  %72 = load ptr, ptr %4, align 8, !dbg !747
  %73 = call i32 @pthread_equal(ptr noundef %71, ptr noundef %72), !dbg !747
  %74 = icmp ne i32 %73, 0, !dbg !747
  %75 = xor i1 %74, true, !dbg !747
  %76 = zext i1 %75 to i32, !dbg !747
  %77 = sext i32 %76 to i64, !dbg !747
  %78 = icmp ne i64 %77, 0, !dbg !747
  br i1 %78, label %79, label %81, !dbg !747

79:                                               ; preds = %70
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 411, ptr noundef @.str.6) #4, !dbg !747
  unreachable, !dbg !747

80:                                               ; No predecessors!
  br label %82, !dbg !747

81:                                               ; preds = %70
  br label %82, !dbg !747

82:                                               ; preds = %81, %80
  ret void, !dbg !748
}

declare i32 @pthread_key_create(ptr noundef, ptr noundef) #2

declare i32 @pthread_key_delete(i64 noundef) #2

declare i32 @pthread_equal(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !749 {
  call void @mutex_test(), !dbg !752
  call void @cond_test(), !dbg !753
  call void @rwlock_test(), !dbg !754
  call void @key_test(), !dbg !755
  ret i32 0, !dbg !756
}

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #4 = { cold noreturn }

!llvm.dbg.cu = !{!61}
!llvm.module.flags = !{!156, !157, !158, !159, !160, !161}
!llvm.ident = !{!162}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 18, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "benchmarks/c/miscellaneous/pthread.c", directory: "/Users/r/Documents/Dat3M")
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
!60 = distinct !DIGlobalVariable(name: "phase", scope: !61, file: !2, line: 200, type: !155, isLocal: false, isDefinition: true)
!61 = distinct !DICompileUnit(language: DW_LANG_C99, file: !2, producer: "Homebrew clang version 15.0.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !62, globals: !65, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!62 = !{!63, !64}
!63 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!65 = !{!0, !8, !13, !18, !21, !26, !28, !30, !35, !37, !42, !47, !50, !52, !54, !59, !66, !68, !73, !75, !77, !79, !81, !83, !85, !87, !92, !95, !100, !114, !126, !149}
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
!86 = distinct !DIGlobalVariable(scope: null, file: !2, line: 378, type: !23, isLocal: true, isDefinition: true)
!87 = !DIGlobalVariableExpression(var: !88, expr: !DIExpression())
!88 = distinct !DIGlobalVariable(scope: null, file: !2, line: 381, type: !89, isLocal: true, isDefinition: true)
!89 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 224, elements: !90)
!90 = !{!91}
!91 = !DISubrange(count: 28)
!92 = !DIGlobalVariableExpression(var: !93, expr: !DIExpression())
!93 = distinct !DIGlobalVariable(scope: null, file: !2, line: 397, type: !94, isLocal: true, isDefinition: true)
!94 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 72, elements: !40)
!95 = !DIGlobalVariableExpression(var: !96, expr: !DIExpression())
!96 = distinct !DIGlobalVariable(scope: null, file: !2, line: 411, type: !97, isLocal: true, isDefinition: true)
!97 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 296, elements: !98)
!98 = !{!99}
!99 = !DISubrange(count: 37)
!100 = !DIGlobalVariableExpression(var: !101, expr: !DIExpression())
!101 = distinct !DIGlobalVariable(name: "cond_mutex", scope: !61, file: !2, line: 198, type: !102, isLocal: false, isDefinition: true)
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !103, line: 31, baseType: !104)
!103 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_mutex_t.h", directory: "")
!104 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutex_t", file: !105, line: 113, baseType: !106)
!105 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!106 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutex_t", file: !105, line: 78, size: 512, elements: !107)
!107 = !{!108, !110}
!108 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !106, file: !105, line: 79, baseType: !109, size: 64)
!109 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !106, file: !105, line: 80, baseType: !111, size: 448, offset: 64)
!111 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 448, elements: !112)
!112 = !{!113}
!113 = !DISubrange(count: 56)
!114 = !DIGlobalVariableExpression(var: !115, expr: !DIExpression())
!115 = distinct !DIGlobalVariable(name: "cond", scope: !61, file: !2, line: 199, type: !116, isLocal: false, isDefinition: true)
!116 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_cond_t", file: !117, line: 31, baseType: !118)
!117 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_cond_t.h", directory: "")
!118 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_cond_t", file: !105, line: 110, baseType: !119)
!119 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_cond_t", file: !105, line: 68, size: 384, elements: !120)
!120 = !{!121, !122}
!121 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !119, file: !105, line: 69, baseType: !109, size: 64)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !119, file: !105, line: 70, baseType: !123, size: 320, offset: 64)
!123 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 320, elements: !124)
!124 = !{!125}
!125 = !DISubrange(count: 40)
!126 = !DIGlobalVariableExpression(var: !127, expr: !DIExpression())
!127 = distinct !DIGlobalVariable(name: "latest_thread", scope: !61, file: !2, line: 365, type: !128, isLocal: false, isDefinition: true)
!128 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !129, line: 31, baseType: !130)
!129 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!130 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !105, line: 118, baseType: !131)
!131 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !132, size: 64)
!132 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !105, line: 103, size: 65536, elements: !133)
!133 = !{!134, !135, !145}
!134 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !132, file: !105, line: 104, baseType: !109, size: 64)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !132, file: !105, line: 105, baseType: !136, size: 64, offset: 64)
!136 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !137, size: 64)
!137 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !105, line: 57, size: 192, elements: !138)
!138 = !{!139, !143, !144}
!139 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !137, file: !105, line: 58, baseType: !140, size: 64)
!140 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !141, size: 64)
!141 = !DISubroutineType(types: !142)
!142 = !{null, !64}
!143 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !137, file: !105, line: 59, baseType: !64, size: 64, offset: 64)
!144 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !137, file: !105, line: 60, baseType: !136, size: 64, offset: 128)
!145 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !132, file: !105, line: 106, baseType: !146, size: 65408, offset: 128)
!146 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 65408, elements: !147)
!147 = !{!148}
!148 = !DISubrange(count: 8176)
!149 = !DIGlobalVariableExpression(var: !150, expr: !DIExpression())
!150 = distinct !DIGlobalVariable(name: "local_data", scope: !61, file: !2, line: 366, type: !151, isLocal: false, isDefinition: true)
!151 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_key_t", file: !152, line: 31, baseType: !153)
!152 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_key_t.h", directory: "")
!153 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_key_t", file: !105, line: 112, baseType: !154)
!154 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!155 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!156 = !{i32 7, !"Dwarf Version", i32 4}
!157 = !{i32 2, !"Debug Info Version", i32 3}
!158 = !{i32 1, !"wchar_size", i32 4}
!159 = !{i32 7, !"PIC Level", i32 2}
!160 = !{i32 7, !"uwtable", i32 2}
!161 = !{i32 7, !"frame-pointer", i32 1}
!162 = !{!"Homebrew clang version 15.0.7"}
!163 = distinct !DISubprogram(name: "thread_create", scope: !2, file: !2, line: 12, type: !164, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!164 = !DISubroutineType(types: !165)
!165 = !{!128, !166, !64}
!166 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !167, size: 64)
!167 = !DISubroutineType(types: !168)
!168 = !{!64, !64}
!169 = !{}
!170 = !DILocalVariable(name: "runner", arg: 1, scope: !163, file: !2, line: 12, type: !166)
!171 = !DILocation(line: 12, column: 32, scope: !163)
!172 = !DILocalVariable(name: "data", arg: 2, scope: !163, file: !2, line: 12, type: !64)
!173 = !DILocation(line: 12, column: 54, scope: !163)
!174 = !DILocalVariable(name: "id", scope: !163, file: !2, line: 14, type: !128)
!175 = !DILocation(line: 14, column: 15, scope: !163)
!176 = !DILocalVariable(name: "attr", scope: !163, file: !2, line: 15, type: !177)
!177 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !178, line: 31, baseType: !179)
!178 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_attr_t.h", directory: "")
!179 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_attr_t", file: !105, line: 109, baseType: !180)
!180 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_attr_t", file: !105, line: 63, size: 512, elements: !181)
!181 = !{!182, !183}
!182 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !180, file: !105, line: 64, baseType: !109, size: 64)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !180, file: !105, line: 65, baseType: !111, size: 448, offset: 64)
!184 = !DILocation(line: 15, column: 20, scope: !163)
!185 = !DILocation(line: 16, column: 5, scope: !163)
!186 = !DILocalVariable(name: "status", scope: !163, file: !2, line: 17, type: !155)
!187 = !DILocation(line: 17, column: 9, scope: !163)
!188 = !DILocation(line: 17, column: 45, scope: !163)
!189 = !DILocation(line: 17, column: 53, scope: !163)
!190 = !DILocation(line: 17, column: 18, scope: !163)
!191 = !DILocation(line: 18, column: 5, scope: !163)
!192 = !DILocation(line: 19, column: 5, scope: !163)
!193 = !DILocation(line: 20, column: 12, scope: !163)
!194 = !DILocation(line: 20, column: 5, scope: !163)
!195 = distinct !DISubprogram(name: "thread_join", scope: !2, file: !2, line: 23, type: !196, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!196 = !DISubroutineType(types: !197)
!197 = !{!64, !128}
!198 = !DILocalVariable(name: "id", arg: 1, scope: !195, file: !2, line: 23, type: !128)
!199 = !DILocation(line: 23, column: 29, scope: !195)
!200 = !DILocalVariable(name: "result", scope: !195, file: !2, line: 25, type: !64)
!201 = !DILocation(line: 25, column: 11, scope: !195)
!202 = !DILocalVariable(name: "status", scope: !195, file: !2, line: 26, type: !155)
!203 = !DILocation(line: 26, column: 9, scope: !195)
!204 = !DILocation(line: 26, column: 31, scope: !195)
!205 = !DILocation(line: 26, column: 18, scope: !195)
!206 = !DILocation(line: 27, column: 5, scope: !195)
!207 = !DILocation(line: 28, column: 12, scope: !195)
!208 = !DILocation(line: 28, column: 5, scope: !195)
!209 = distinct !DISubprogram(name: "mutex_init", scope: !2, file: !2, line: 43, type: !210, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!210 = !DISubroutineType(types: !211)
!211 = !{null, !212, !155, !155, !155, !155}
!212 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !102, size: 64)
!213 = !DILocalVariable(name: "lock", arg: 1, scope: !209, file: !2, line: 43, type: !212)
!214 = !DILocation(line: 43, column: 34, scope: !209)
!215 = !DILocalVariable(name: "type", arg: 2, scope: !209, file: !2, line: 43, type: !155)
!216 = !DILocation(line: 43, column: 44, scope: !209)
!217 = !DILocalVariable(name: "protocol", arg: 3, scope: !209, file: !2, line: 43, type: !155)
!218 = !DILocation(line: 43, column: 54, scope: !209)
!219 = !DILocalVariable(name: "policy", arg: 4, scope: !209, file: !2, line: 43, type: !155)
!220 = !DILocation(line: 43, column: 68, scope: !209)
!221 = !DILocalVariable(name: "prioceiling", arg: 5, scope: !209, file: !2, line: 43, type: !155)
!222 = !DILocation(line: 43, column: 80, scope: !209)
!223 = !DILocalVariable(name: "status", scope: !209, file: !2, line: 45, type: !155)
!224 = !DILocation(line: 45, column: 9, scope: !209)
!225 = !DILocalVariable(name: "value", scope: !209, file: !2, line: 46, type: !155)
!226 = !DILocation(line: 46, column: 9, scope: !209)
!227 = !DILocalVariable(name: "attributes", scope: !209, file: !2, line: 47, type: !228)
!228 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !229, line: 31, baseType: !230)
!229 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_mutexattr_t.h", directory: "")
!230 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutexattr_t", file: !105, line: 114, baseType: !231)
!231 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutexattr_t", file: !105, line: 83, size: 128, elements: !232)
!232 = !{!233, !234}
!233 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !231, file: !105, line: 84, baseType: !109, size: 64)
!234 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !231, file: !105, line: 85, baseType: !44, size: 64, offset: 64)
!235 = !DILocation(line: 47, column: 25, scope: !209)
!236 = !DILocation(line: 48, column: 14, scope: !209)
!237 = !DILocation(line: 48, column: 12, scope: !209)
!238 = !DILocation(line: 49, column: 5, scope: !209)
!239 = !DILocation(line: 51, column: 53, scope: !209)
!240 = !DILocation(line: 51, column: 14, scope: !209)
!241 = !DILocation(line: 51, column: 12, scope: !209)
!242 = !DILocation(line: 52, column: 5, scope: !209)
!243 = !DILocation(line: 53, column: 14, scope: !209)
!244 = !DILocation(line: 53, column: 12, scope: !209)
!245 = !DILocation(line: 54, column: 5, scope: !209)
!246 = !DILocation(line: 56, column: 57, scope: !209)
!247 = !DILocation(line: 56, column: 14, scope: !209)
!248 = !DILocation(line: 56, column: 12, scope: !209)
!249 = !DILocation(line: 57, column: 5, scope: !209)
!250 = !DILocation(line: 58, column: 14, scope: !209)
!251 = !DILocation(line: 58, column: 12, scope: !209)
!252 = !DILocation(line: 59, column: 5, scope: !209)
!253 = !DILocation(line: 61, column: 58, scope: !209)
!254 = !DILocation(line: 61, column: 14, scope: !209)
!255 = !DILocation(line: 61, column: 12, scope: !209)
!256 = !DILocation(line: 62, column: 5, scope: !209)
!257 = !DILocation(line: 63, column: 14, scope: !209)
!258 = !DILocation(line: 63, column: 12, scope: !209)
!259 = !DILocation(line: 64, column: 5, scope: !209)
!260 = !DILocation(line: 66, column: 60, scope: !209)
!261 = !DILocation(line: 66, column: 14, scope: !209)
!262 = !DILocation(line: 66, column: 12, scope: !209)
!263 = !DILocation(line: 67, column: 5, scope: !209)
!264 = !DILocation(line: 68, column: 14, scope: !209)
!265 = !DILocation(line: 68, column: 12, scope: !209)
!266 = !DILocation(line: 69, column: 5, scope: !209)
!267 = !DILocation(line: 71, column: 33, scope: !209)
!268 = !DILocation(line: 71, column: 14, scope: !209)
!269 = !DILocation(line: 71, column: 12, scope: !209)
!270 = !DILocation(line: 72, column: 5, scope: !209)
!271 = !DILocation(line: 73, column: 14, scope: !209)
!272 = !DILocation(line: 73, column: 12, scope: !209)
!273 = !DILocation(line: 74, column: 5, scope: !209)
!274 = !DILocation(line: 75, column: 1, scope: !209)
!275 = distinct !DISubprogram(name: "mutex_destroy", scope: !2, file: !2, line: 77, type: !276, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!276 = !DISubroutineType(types: !277)
!277 = !{null, !212}
!278 = !DILocalVariable(name: "lock", arg: 1, scope: !275, file: !2, line: 77, type: !212)
!279 = !DILocation(line: 77, column: 37, scope: !275)
!280 = !DILocalVariable(name: "status", scope: !275, file: !2, line: 79, type: !155)
!281 = !DILocation(line: 79, column: 9, scope: !275)
!282 = !DILocation(line: 79, column: 40, scope: !275)
!283 = !DILocation(line: 79, column: 18, scope: !275)
!284 = !DILocation(line: 80, column: 5, scope: !275)
!285 = !DILocation(line: 81, column: 1, scope: !275)
!286 = distinct !DISubprogram(name: "mutex_lock", scope: !2, file: !2, line: 83, type: !276, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!287 = !DILocalVariable(name: "lock", arg: 1, scope: !286, file: !2, line: 83, type: !212)
!288 = !DILocation(line: 83, column: 34, scope: !286)
!289 = !DILocalVariable(name: "status", scope: !286, file: !2, line: 85, type: !155)
!290 = !DILocation(line: 85, column: 9, scope: !286)
!291 = !DILocation(line: 85, column: 37, scope: !286)
!292 = !DILocation(line: 85, column: 18, scope: !286)
!293 = !DILocation(line: 86, column: 5, scope: !286)
!294 = !DILocation(line: 87, column: 1, scope: !286)
!295 = distinct !DISubprogram(name: "mutex_trylock", scope: !2, file: !2, line: 89, type: !296, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!296 = !DISubroutineType(types: !297)
!297 = !{!298, !212}
!298 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!299 = !DILocalVariable(name: "lock", arg: 1, scope: !295, file: !2, line: 89, type: !212)
!300 = !DILocation(line: 89, column: 37, scope: !295)
!301 = !DILocalVariable(name: "status", scope: !295, file: !2, line: 91, type: !155)
!302 = !DILocation(line: 91, column: 9, scope: !295)
!303 = !DILocation(line: 91, column: 40, scope: !295)
!304 = !DILocation(line: 91, column: 18, scope: !295)
!305 = !DILocation(line: 93, column: 12, scope: !295)
!306 = !DILocation(line: 93, column: 19, scope: !295)
!307 = !DILocation(line: 93, column: 5, scope: !295)
!308 = distinct !DISubprogram(name: "mutex_unlock", scope: !2, file: !2, line: 96, type: !276, scopeLine: 97, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!309 = !DILocalVariable(name: "lock", arg: 1, scope: !308, file: !2, line: 96, type: !212)
!310 = !DILocation(line: 96, column: 36, scope: !308)
!311 = !DILocalVariable(name: "status", scope: !308, file: !2, line: 98, type: !155)
!312 = !DILocation(line: 98, column: 9, scope: !308)
!313 = !DILocation(line: 98, column: 39, scope: !308)
!314 = !DILocation(line: 98, column: 18, scope: !308)
!315 = !DILocation(line: 99, column: 5, scope: !308)
!316 = !DILocation(line: 100, column: 1, scope: !308)
!317 = distinct !DISubprogram(name: "mutex_test", scope: !2, file: !2, line: 102, type: !318, scopeLine: 103, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!318 = !DISubroutineType(types: !319)
!319 = !{null}
!320 = !DILocalVariable(name: "mutex0", scope: !317, file: !2, line: 104, type: !102)
!321 = !DILocation(line: 104, column: 21, scope: !317)
!322 = !DILocalVariable(name: "mutex1", scope: !317, file: !2, line: 105, type: !102)
!323 = !DILocation(line: 105, column: 21, scope: !317)
!324 = !DILocation(line: 107, column: 5, scope: !317)
!325 = !DILocation(line: 108, column: 5, scope: !317)
!326 = !DILocation(line: 111, column: 9, scope: !327)
!327 = distinct !DILexicalBlock(scope: !317, file: !2, line: 110, column: 5)
!328 = !DILocalVariable(name: "success", scope: !327, file: !2, line: 112, type: !298)
!329 = !DILocation(line: 112, column: 14, scope: !327)
!330 = !DILocation(line: 112, column: 24, scope: !327)
!331 = !DILocation(line: 113, column: 9, scope: !327)
!332 = !DILocation(line: 114, column: 9, scope: !327)
!333 = !DILocation(line: 118, column: 9, scope: !334)
!334 = distinct !DILexicalBlock(scope: !317, file: !2, line: 117, column: 5)
!335 = !DILocalVariable(name: "success", scope: !336, file: !2, line: 121, type: !298)
!336 = distinct !DILexicalBlock(scope: !334, file: !2, line: 120, column: 9)
!337 = !DILocation(line: 121, column: 18, scope: !336)
!338 = !DILocation(line: 121, column: 28, scope: !336)
!339 = !DILocation(line: 122, column: 13, scope: !336)
!340 = !DILocation(line: 123, column: 13, scope: !336)
!341 = !DILocalVariable(name: "success", scope: !342, file: !2, line: 127, type: !298)
!342 = distinct !DILexicalBlock(scope: !334, file: !2, line: 126, column: 9)
!343 = !DILocation(line: 127, column: 18, scope: !342)
!344 = !DILocation(line: 127, column: 28, scope: !342)
!345 = !DILocation(line: 128, column: 13, scope: !342)
!346 = !DILocation(line: 129, column: 13, scope: !342)
!347 = !DILocation(line: 139, column: 9, scope: !334)
!348 = !DILocation(line: 142, column: 5, scope: !317)
!349 = !DILocation(line: 143, column: 5, scope: !317)
!350 = !DILocation(line: 144, column: 1, scope: !317)
!351 = distinct !DISubprogram(name: "cond_init", scope: !2, file: !2, line: 148, type: !352, scopeLine: 149, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!352 = !DISubroutineType(types: !353)
!353 = !{null, !354}
!354 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !116, size: 64)
!355 = !DILocalVariable(name: "cond", arg: 1, scope: !351, file: !2, line: 148, type: !354)
!356 = !DILocation(line: 148, column: 32, scope: !351)
!357 = !DILocalVariable(name: "status", scope: !351, file: !2, line: 150, type: !155)
!358 = !DILocation(line: 150, column: 9, scope: !351)
!359 = !DILocalVariable(name: "attr", scope: !351, file: !2, line: 151, type: !360)
!360 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_condattr_t", file: !361, line: 31, baseType: !362)
!361 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_condattr_t.h", directory: "")
!362 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_condattr_t", file: !105, line: 111, baseType: !363)
!363 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_condattr_t", file: !105, line: 73, size: 128, elements: !364)
!364 = !{!365, !366}
!365 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !363, file: !105, line: 74, baseType: !109, size: 64)
!366 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !363, file: !105, line: 75, baseType: !44, size: 64, offset: 64)
!367 = !DILocation(line: 151, column: 24, scope: !351)
!368 = !DILocation(line: 153, column: 14, scope: !351)
!369 = !DILocation(line: 153, column: 12, scope: !351)
!370 = !DILocation(line: 154, column: 5, scope: !351)
!371 = !DILocation(line: 156, column: 32, scope: !351)
!372 = !DILocation(line: 156, column: 14, scope: !351)
!373 = !DILocation(line: 156, column: 12, scope: !351)
!374 = !DILocation(line: 157, column: 5, scope: !351)
!375 = !DILocation(line: 159, column: 14, scope: !351)
!376 = !DILocation(line: 159, column: 12, scope: !351)
!377 = !DILocation(line: 160, column: 5, scope: !351)
!378 = !DILocation(line: 161, column: 1, scope: !351)
!379 = distinct !DISubprogram(name: "cond_destroy", scope: !2, file: !2, line: 163, type: !352, scopeLine: 164, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!380 = !DILocalVariable(name: "cond", arg: 1, scope: !379, file: !2, line: 163, type: !354)
!381 = !DILocation(line: 163, column: 35, scope: !379)
!382 = !DILocalVariable(name: "status", scope: !379, file: !2, line: 165, type: !155)
!383 = !DILocation(line: 165, column: 9, scope: !379)
!384 = !DILocation(line: 165, column: 39, scope: !379)
!385 = !DILocation(line: 165, column: 18, scope: !379)
!386 = !DILocation(line: 166, column: 5, scope: !379)
!387 = !DILocation(line: 167, column: 1, scope: !379)
!388 = distinct !DISubprogram(name: "cond_signal", scope: !2, file: !2, line: 169, type: !352, scopeLine: 170, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!389 = !DILocalVariable(name: "cond", arg: 1, scope: !388, file: !2, line: 169, type: !354)
!390 = !DILocation(line: 169, column: 34, scope: !388)
!391 = !DILocalVariable(name: "status", scope: !388, file: !2, line: 171, type: !155)
!392 = !DILocation(line: 171, column: 9, scope: !388)
!393 = !DILocation(line: 171, column: 38, scope: !388)
!394 = !DILocation(line: 171, column: 18, scope: !388)
!395 = !DILocation(line: 172, column: 5, scope: !388)
!396 = !DILocation(line: 173, column: 1, scope: !388)
!397 = distinct !DISubprogram(name: "cond_broadcast", scope: !2, file: !2, line: 175, type: !352, scopeLine: 176, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!398 = !DILocalVariable(name: "cond", arg: 1, scope: !397, file: !2, line: 175, type: !354)
!399 = !DILocation(line: 175, column: 37, scope: !397)
!400 = !DILocalVariable(name: "status", scope: !397, file: !2, line: 177, type: !155)
!401 = !DILocation(line: 177, column: 9, scope: !397)
!402 = !DILocation(line: 177, column: 41, scope: !397)
!403 = !DILocation(line: 177, column: 18, scope: !397)
!404 = !DILocation(line: 178, column: 5, scope: !397)
!405 = !DILocation(line: 179, column: 1, scope: !397)
!406 = distinct !DISubprogram(name: "cond_wait", scope: !2, file: !2, line: 181, type: !407, scopeLine: 182, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!407 = !DISubroutineType(types: !408)
!408 = !{null, !354, !212}
!409 = !DILocalVariable(name: "cond", arg: 1, scope: !406, file: !2, line: 181, type: !354)
!410 = !DILocation(line: 181, column: 32, scope: !406)
!411 = !DILocalVariable(name: "lock", arg: 2, scope: !406, file: !2, line: 181, type: !212)
!412 = !DILocation(line: 181, column: 55, scope: !406)
!413 = !DILocalVariable(name: "status", scope: !406, file: !2, line: 183, type: !155)
!414 = !DILocation(line: 183, column: 9, scope: !406)
!415 = !DILocation(line: 183, column: 36, scope: !406)
!416 = !DILocation(line: 183, column: 42, scope: !406)
!417 = !DILocation(line: 183, column: 18, scope: !406)
!418 = !DILocation(line: 185, column: 1, scope: !406)
!419 = distinct !DISubprogram(name: "cond_timedwait", scope: !2, file: !2, line: 187, type: !420, scopeLine: 188, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!420 = !DISubroutineType(types: !421)
!421 = !{null, !354, !212, !422}
!422 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!423 = !DILocalVariable(name: "cond", arg: 1, scope: !419, file: !2, line: 187, type: !354)
!424 = !DILocation(line: 187, column: 37, scope: !419)
!425 = !DILocalVariable(name: "lock", arg: 2, scope: !419, file: !2, line: 187, type: !212)
!426 = !DILocation(line: 187, column: 60, scope: !419)
!427 = !DILocalVariable(name: "millis", arg: 3, scope: !419, file: !2, line: 187, type: !422)
!428 = !DILocation(line: 187, column: 76, scope: !419)
!429 = !DILocalVariable(name: "ts", scope: !419, file: !2, line: 190, type: !430)
!430 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !431, line: 33, size: 128, elements: !432)
!431 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_types/_timespec.h", directory: "")
!432 = !{!433, !436}
!433 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !430, file: !431, line: 35, baseType: !434, size: 64)
!434 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_time_t", file: !435, line: 98, baseType: !109)
!435 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/arm/_types.h", directory: "")
!436 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !430, file: !431, line: 36, baseType: !109, size: 64, offset: 64)
!437 = !DILocation(line: 190, column: 21, scope: !419)
!438 = !DILocation(line: 194, column: 11, scope: !419)
!439 = !DILocalVariable(name: "status", scope: !419, file: !2, line: 195, type: !155)
!440 = !DILocation(line: 195, column: 9, scope: !419)
!441 = !DILocation(line: 195, column: 41, scope: !419)
!442 = !DILocation(line: 195, column: 47, scope: !419)
!443 = !DILocation(line: 195, column: 18, scope: !419)
!444 = !DILocation(line: 196, column: 1, scope: !419)
!445 = distinct !DISubprogram(name: "cond_worker", scope: !2, file: !2, line: 202, type: !167, scopeLine: 203, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!446 = !DILocalVariable(name: "message", arg: 1, scope: !445, file: !2, line: 202, type: !64)
!447 = !DILocation(line: 202, column: 25, scope: !445)
!448 = !DILocalVariable(name: "idle", scope: !445, file: !2, line: 204, type: !298)
!449 = !DILocation(line: 204, column: 10, scope: !445)
!450 = !DILocation(line: 206, column: 9, scope: !451)
!451 = distinct !DILexicalBlock(scope: !445, file: !2, line: 205, column: 5)
!452 = !DILocation(line: 207, column: 9, scope: !451)
!453 = !DILocation(line: 208, column: 9, scope: !451)
!454 = !DILocation(line: 209, column: 9, scope: !451)
!455 = !DILocation(line: 210, column: 16, scope: !451)
!456 = !DILocation(line: 210, column: 22, scope: !451)
!457 = !DILocation(line: 210, column: 14, scope: !451)
!458 = !DILocation(line: 211, column: 9, scope: !451)
!459 = !DILocation(line: 213, column: 9, scope: !460)
!460 = distinct !DILexicalBlock(scope: !445, file: !2, line: 213, column: 9)
!461 = !DILocation(line: 213, column: 9, scope: !445)
!462 = !DILocation(line: 214, column: 25, scope: !460)
!463 = !DILocation(line: 214, column: 34, scope: !460)
!464 = !DILocation(line: 214, column: 9, scope: !460)
!465 = !DILocation(line: 215, column: 10, scope: !445)
!466 = !DILocation(line: 217, column: 9, scope: !467)
!467 = distinct !DILexicalBlock(scope: !445, file: !2, line: 216, column: 5)
!468 = !DILocation(line: 218, column: 9, scope: !467)
!469 = !DILocation(line: 219, column: 9, scope: !467)
!470 = !DILocation(line: 220, column: 9, scope: !467)
!471 = !DILocation(line: 221, column: 16, scope: !467)
!472 = !DILocation(line: 221, column: 22, scope: !467)
!473 = !DILocation(line: 221, column: 14, scope: !467)
!474 = !DILocation(line: 222, column: 9, scope: !467)
!475 = !DILocation(line: 224, column: 9, scope: !476)
!476 = distinct !DILexicalBlock(scope: !445, file: !2, line: 224, column: 9)
!477 = !DILocation(line: 224, column: 9, scope: !445)
!478 = !DILocation(line: 225, column: 25, scope: !476)
!479 = !DILocation(line: 225, column: 34, scope: !476)
!480 = !DILocation(line: 225, column: 9, scope: !476)
!481 = !DILocation(line: 226, column: 12, scope: !445)
!482 = !DILocation(line: 226, column: 5, scope: !445)
!483 = !DILocation(line: 227, column: 1, scope: !445)
!484 = distinct !DISubprogram(name: "cond_test", scope: !2, file: !2, line: 229, type: !318, scopeLine: 230, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!485 = !DILocalVariable(name: "message", scope: !484, file: !2, line: 231, type: !64)
!486 = !DILocation(line: 231, column: 11, scope: !484)
!487 = !DILocation(line: 232, column: 5, scope: !484)
!488 = !DILocation(line: 233, column: 5, scope: !484)
!489 = !DILocalVariable(name: "worker", scope: !484, file: !2, line: 235, type: !128)
!490 = !DILocation(line: 235, column: 15, scope: !484)
!491 = !DILocation(line: 235, column: 51, scope: !484)
!492 = !DILocation(line: 235, column: 24, scope: !484)
!493 = !DILocation(line: 238, column: 9, scope: !494)
!494 = distinct !DILexicalBlock(scope: !484, file: !2, line: 237, column: 5)
!495 = !DILocation(line: 239, column: 9, scope: !494)
!496 = !DILocation(line: 240, column: 9, scope: !494)
!497 = !DILocation(line: 241, column: 9, scope: !494)
!498 = !DILocation(line: 245, column: 9, scope: !499)
!499 = distinct !DILexicalBlock(scope: !484, file: !2, line: 244, column: 5)
!500 = !DILocation(line: 246, column: 9, scope: !499)
!501 = !DILocation(line: 247, column: 9, scope: !499)
!502 = !DILocation(line: 248, column: 9, scope: !499)
!503 = !DILocalVariable(name: "result", scope: !484, file: !2, line: 251, type: !64)
!504 = !DILocation(line: 251, column: 11, scope: !484)
!505 = !DILocation(line: 251, column: 32, scope: !484)
!506 = !DILocation(line: 251, column: 20, scope: !484)
!507 = !DILocation(line: 252, column: 5, scope: !484)
!508 = !DILocation(line: 254, column: 5, scope: !484)
!509 = !DILocation(line: 255, column: 5, scope: !484)
!510 = !DILocation(line: 256, column: 1, scope: !484)
!511 = distinct !DISubprogram(name: "rwlock_init", scope: !2, file: !2, line: 263, type: !512, scopeLine: 264, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!512 = !DISubroutineType(types: !513)
!513 = !{null, !514, !155}
!514 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !515, size: 64)
!515 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlock_t", file: !516, line: 31, baseType: !517)
!516 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_rwlock_t.h", directory: "")
!517 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_rwlock_t", file: !105, line: 116, baseType: !518)
!518 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_rwlock_t", file: !105, line: 93, size: 1600, elements: !519)
!519 = !{!520, !521}
!520 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !518, file: !105, line: 94, baseType: !109, size: 64)
!521 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !518, file: !105, line: 95, baseType: !522, size: 1536, offset: 64)
!522 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 1536, elements: !523)
!523 = !{!524}
!524 = !DISubrange(count: 192)
!525 = !DILocalVariable(name: "lock", arg: 1, scope: !511, file: !2, line: 263, type: !514)
!526 = !DILocation(line: 263, column: 36, scope: !511)
!527 = !DILocalVariable(name: "shared", arg: 2, scope: !511, file: !2, line: 263, type: !155)
!528 = !DILocation(line: 263, column: 46, scope: !511)
!529 = !DILocalVariable(name: "status", scope: !511, file: !2, line: 265, type: !155)
!530 = !DILocation(line: 265, column: 9, scope: !511)
!531 = !DILocalVariable(name: "value", scope: !511, file: !2, line: 266, type: !155)
!532 = !DILocation(line: 266, column: 9, scope: !511)
!533 = !DILocalVariable(name: "attributes", scope: !511, file: !2, line: 267, type: !534)
!534 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlockattr_t", file: !535, line: 31, baseType: !536)
!535 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_rwlockattr_t.h", directory: "")
!536 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_rwlockattr_t", file: !105, line: 117, baseType: !537)
!537 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_rwlockattr_t", file: !105, line: 98, size: 192, elements: !538)
!538 = !{!539, !540}
!539 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !537, file: !105, line: 99, baseType: !109, size: 64)
!540 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !537, file: !105, line: 100, baseType: !541, size: 128, offset: 64)
!541 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 128, elements: !542)
!542 = !{!543}
!543 = !DISubrange(count: 16)
!544 = !DILocation(line: 267, column: 26, scope: !511)
!545 = !DILocation(line: 268, column: 14, scope: !511)
!546 = !DILocation(line: 268, column: 12, scope: !511)
!547 = !DILocation(line: 269, column: 5, scope: !511)
!548 = !DILocation(line: 271, column: 57, scope: !511)
!549 = !DILocation(line: 271, column: 14, scope: !511)
!550 = !DILocation(line: 271, column: 12, scope: !511)
!551 = !DILocation(line: 272, column: 5, scope: !511)
!552 = !DILocation(line: 273, column: 14, scope: !511)
!553 = !DILocation(line: 273, column: 12, scope: !511)
!554 = !DILocation(line: 274, column: 5, scope: !511)
!555 = !DILocation(line: 276, column: 34, scope: !511)
!556 = !DILocation(line: 276, column: 14, scope: !511)
!557 = !DILocation(line: 276, column: 12, scope: !511)
!558 = !DILocation(line: 277, column: 5, scope: !511)
!559 = !DILocation(line: 278, column: 14, scope: !511)
!560 = !DILocation(line: 278, column: 12, scope: !511)
!561 = !DILocation(line: 279, column: 5, scope: !511)
!562 = !DILocation(line: 280, column: 1, scope: !511)
!563 = distinct !DISubprogram(name: "rwlock_destroy", scope: !2, file: !2, line: 282, type: !564, scopeLine: 283, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!564 = !DISubroutineType(types: !565)
!565 = !{null, !514}
!566 = !DILocalVariable(name: "lock", arg: 1, scope: !563, file: !2, line: 282, type: !514)
!567 = !DILocation(line: 282, column: 39, scope: !563)
!568 = !DILocalVariable(name: "status", scope: !563, file: !2, line: 284, type: !155)
!569 = !DILocation(line: 284, column: 9, scope: !563)
!570 = !DILocation(line: 284, column: 41, scope: !563)
!571 = !DILocation(line: 284, column: 18, scope: !563)
!572 = !DILocation(line: 285, column: 5, scope: !563)
!573 = !DILocation(line: 286, column: 1, scope: !563)
!574 = distinct !DISubprogram(name: "rwlock_wrlock", scope: !2, file: !2, line: 288, type: !564, scopeLine: 289, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!575 = !DILocalVariable(name: "lock", arg: 1, scope: !574, file: !2, line: 288, type: !514)
!576 = !DILocation(line: 288, column: 38, scope: !574)
!577 = !DILocalVariable(name: "status", scope: !574, file: !2, line: 290, type: !155)
!578 = !DILocation(line: 290, column: 9, scope: !574)
!579 = !DILocation(line: 290, column: 40, scope: !574)
!580 = !DILocation(line: 290, column: 18, scope: !574)
!581 = !DILocation(line: 291, column: 5, scope: !574)
!582 = !DILocation(line: 292, column: 1, scope: !574)
!583 = distinct !DISubprogram(name: "rwlock_trywrlock", scope: !2, file: !2, line: 294, type: !584, scopeLine: 295, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!584 = !DISubroutineType(types: !585)
!585 = !{!298, !514}
!586 = !DILocalVariable(name: "lock", arg: 1, scope: !583, file: !2, line: 294, type: !514)
!587 = !DILocation(line: 294, column: 41, scope: !583)
!588 = !DILocalVariable(name: "status", scope: !583, file: !2, line: 296, type: !155)
!589 = !DILocation(line: 296, column: 9, scope: !583)
!590 = !DILocation(line: 296, column: 43, scope: !583)
!591 = !DILocation(line: 296, column: 18, scope: !583)
!592 = !DILocation(line: 298, column: 12, scope: !583)
!593 = !DILocation(line: 298, column: 19, scope: !583)
!594 = !DILocation(line: 298, column: 5, scope: !583)
!595 = distinct !DISubprogram(name: "rwlock_rdlock", scope: !2, file: !2, line: 301, type: !564, scopeLine: 302, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!596 = !DILocalVariable(name: "lock", arg: 1, scope: !595, file: !2, line: 301, type: !514)
!597 = !DILocation(line: 301, column: 38, scope: !595)
!598 = !DILocalVariable(name: "status", scope: !595, file: !2, line: 303, type: !155)
!599 = !DILocation(line: 303, column: 9, scope: !595)
!600 = !DILocation(line: 303, column: 40, scope: !595)
!601 = !DILocation(line: 303, column: 18, scope: !595)
!602 = !DILocation(line: 304, column: 5, scope: !595)
!603 = !DILocation(line: 305, column: 1, scope: !595)
!604 = distinct !DISubprogram(name: "rwlock_tryrdlock", scope: !2, file: !2, line: 307, type: !584, scopeLine: 308, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!605 = !DILocalVariable(name: "lock", arg: 1, scope: !604, file: !2, line: 307, type: !514)
!606 = !DILocation(line: 307, column: 41, scope: !604)
!607 = !DILocalVariable(name: "status", scope: !604, file: !2, line: 309, type: !155)
!608 = !DILocation(line: 309, column: 9, scope: !604)
!609 = !DILocation(line: 309, column: 43, scope: !604)
!610 = !DILocation(line: 309, column: 18, scope: !604)
!611 = !DILocation(line: 311, column: 12, scope: !604)
!612 = !DILocation(line: 311, column: 19, scope: !604)
!613 = !DILocation(line: 311, column: 5, scope: !604)
!614 = distinct !DISubprogram(name: "rwlock_unlock", scope: !2, file: !2, line: 314, type: !564, scopeLine: 315, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!615 = !DILocalVariable(name: "lock", arg: 1, scope: !614, file: !2, line: 314, type: !514)
!616 = !DILocation(line: 314, column: 38, scope: !614)
!617 = !DILocalVariable(name: "status", scope: !614, file: !2, line: 316, type: !155)
!618 = !DILocation(line: 316, column: 9, scope: !614)
!619 = !DILocation(line: 316, column: 40, scope: !614)
!620 = !DILocation(line: 316, column: 18, scope: !614)
!621 = !DILocation(line: 317, column: 5, scope: !614)
!622 = !DILocation(line: 318, column: 1, scope: !614)
!623 = distinct !DISubprogram(name: "rwlock_test", scope: !2, file: !2, line: 320, type: !318, scopeLine: 321, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!624 = !DILocalVariable(name: "lock", scope: !623, file: !2, line: 322, type: !515)
!625 = !DILocation(line: 322, column: 22, scope: !623)
!626 = !DILocation(line: 323, column: 5, scope: !623)
!627 = !DILocalVariable(name: "test_depth", scope: !623, file: !2, line: 324, type: !628)
!628 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !155)
!629 = !DILocation(line: 324, column: 15, scope: !623)
!630 = !DILocation(line: 327, column: 9, scope: !631)
!631 = distinct !DILexicalBlock(scope: !623, file: !2, line: 326, column: 5)
!632 = !DILocalVariable(name: "success", scope: !631, file: !2, line: 328, type: !298)
!633 = !DILocation(line: 328, column: 14, scope: !631)
!634 = !DILocation(line: 328, column: 24, scope: !631)
!635 = !DILocation(line: 329, column: 9, scope: !631)
!636 = !DILocation(line: 330, column: 19, scope: !631)
!637 = !DILocation(line: 330, column: 17, scope: !631)
!638 = !DILocation(line: 331, column: 9, scope: !631)
!639 = !DILocation(line: 332, column: 9, scope: !631)
!640 = !DILocation(line: 336, column: 9, scope: !641)
!641 = distinct !DILexicalBlock(scope: !623, file: !2, line: 335, column: 5)
!642 = !DILocalVariable(name: "i", scope: !643, file: !2, line: 337, type: !155)
!643 = distinct !DILexicalBlock(scope: !641, file: !2, line: 337, column: 9)
!644 = !DILocation(line: 337, column: 18, scope: !643)
!645 = !DILocation(line: 337, column: 14, scope: !643)
!646 = !DILocation(line: 337, column: 25, scope: !647)
!647 = distinct !DILexicalBlock(scope: !643, file: !2, line: 337, column: 9)
!648 = !DILocation(line: 337, column: 27, scope: !647)
!649 = !DILocation(line: 337, column: 9, scope: !643)
!650 = !DILocalVariable(name: "success", scope: !651, file: !2, line: 339, type: !298)
!651 = distinct !DILexicalBlock(scope: !647, file: !2, line: 338, column: 9)
!652 = !DILocation(line: 339, column: 18, scope: !651)
!653 = !DILocation(line: 339, column: 28, scope: !651)
!654 = !DILocation(line: 340, column: 13, scope: !651)
!655 = !DILocation(line: 341, column: 9, scope: !651)
!656 = !DILocation(line: 337, column: 42, scope: !647)
!657 = !DILocation(line: 337, column: 9, scope: !647)
!658 = distinct !{!658, !649, !659, !660}
!659 = !DILocation(line: 341, column: 9, scope: !643)
!660 = !{!"llvm.loop.mustprogress"}
!661 = !DILocalVariable(name: "success", scope: !662, file: !2, line: 344, type: !298)
!662 = distinct !DILexicalBlock(scope: !641, file: !2, line: 343, column: 9)
!663 = !DILocation(line: 344, column: 18, scope: !662)
!664 = !DILocation(line: 344, column: 28, scope: !662)
!665 = !DILocation(line: 345, column: 13, scope: !662)
!666 = !DILocation(line: 348, column: 9, scope: !641)
!667 = !DILocalVariable(name: "i", scope: !668, file: !2, line: 349, type: !155)
!668 = distinct !DILexicalBlock(scope: !641, file: !2, line: 349, column: 9)
!669 = !DILocation(line: 349, column: 18, scope: !668)
!670 = !DILocation(line: 349, column: 14, scope: !668)
!671 = !DILocation(line: 349, column: 25, scope: !672)
!672 = distinct !DILexicalBlock(scope: !668, file: !2, line: 349, column: 9)
!673 = !DILocation(line: 349, column: 27, scope: !672)
!674 = !DILocation(line: 349, column: 9, scope: !668)
!675 = !DILocation(line: 350, column: 13, scope: !676)
!676 = distinct !DILexicalBlock(scope: !672, file: !2, line: 349, column: 46)
!677 = !DILocation(line: 351, column: 9, scope: !676)
!678 = !DILocation(line: 349, column: 42, scope: !672)
!679 = !DILocation(line: 349, column: 9, scope: !672)
!680 = distinct !{!680, !674, !681, !660}
!681 = !DILocation(line: 351, column: 9, scope: !668)
!682 = !DILocation(line: 355, column: 9, scope: !683)
!683 = distinct !DILexicalBlock(scope: !623, file: !2, line: 354, column: 5)
!684 = !DILocalVariable(name: "success", scope: !683, file: !2, line: 356, type: !298)
!685 = !DILocation(line: 356, column: 14, scope: !683)
!686 = !DILocation(line: 356, column: 24, scope: !683)
!687 = !DILocation(line: 357, column: 9, scope: !683)
!688 = !DILocation(line: 360, column: 5, scope: !623)
!689 = !DILocation(line: 361, column: 1, scope: !623)
!690 = distinct !DISubprogram(name: "key_destroy", scope: !2, file: !2, line: 368, type: !141, scopeLine: 369, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!691 = !DILocalVariable(name: "unused_value", arg: 1, scope: !690, file: !2, line: 368, type: !64)
!692 = !DILocation(line: 368, column: 24, scope: !690)
!693 = !DILocation(line: 370, column: 21, scope: !690)
!694 = !DILocation(line: 370, column: 19, scope: !690)
!695 = !DILocation(line: 371, column: 1, scope: !690)
!696 = distinct !DISubprogram(name: "key_worker", scope: !2, file: !2, line: 373, type: !167, scopeLine: 374, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!697 = !DILocalVariable(name: "message", arg: 1, scope: !696, file: !2, line: 373, type: !64)
!698 = !DILocation(line: 373, column: 24, scope: !696)
!699 = !DILocalVariable(name: "my_secret", scope: !696, file: !2, line: 375, type: !155)
!700 = !DILocation(line: 375, column: 9, scope: !696)
!701 = !DILocalVariable(name: "status", scope: !696, file: !2, line: 377, type: !155)
!702 = !DILocation(line: 377, column: 9, scope: !696)
!703 = !DILocation(line: 377, column: 38, scope: !696)
!704 = !DILocation(line: 377, column: 18, scope: !696)
!705 = !DILocation(line: 378, column: 5, scope: !696)
!706 = !DILocalVariable(name: "my_local_data", scope: !696, file: !2, line: 380, type: !64)
!707 = !DILocation(line: 380, column: 11, scope: !696)
!708 = !DILocation(line: 380, column: 47, scope: !696)
!709 = !DILocation(line: 380, column: 27, scope: !696)
!710 = !DILocation(line: 381, column: 5, scope: !696)
!711 = !DILocation(line: 383, column: 12, scope: !696)
!712 = !DILocation(line: 383, column: 5, scope: !696)
!713 = distinct !DISubprogram(name: "key_test", scope: !2, file: !2, line: 386, type: !318, scopeLine: 387, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!714 = !DILocalVariable(name: "my_secret", scope: !713, file: !2, line: 388, type: !155)
!715 = !DILocation(line: 388, column: 9, scope: !713)
!716 = !DILocalVariable(name: "message", scope: !713, file: !2, line: 389, type: !64)
!717 = !DILocation(line: 389, column: 11, scope: !713)
!718 = !DILocalVariable(name: "status", scope: !713, file: !2, line: 390, type: !155)
!719 = !DILocation(line: 390, column: 9, scope: !713)
!720 = !DILocation(line: 392, column: 5, scope: !713)
!721 = !DILocalVariable(name: "worker", scope: !713, file: !2, line: 394, type: !128)
!722 = !DILocation(line: 394, column: 15, scope: !713)
!723 = !DILocation(line: 394, column: 50, scope: !713)
!724 = !DILocation(line: 394, column: 24, scope: !713)
!725 = !DILocation(line: 396, column: 34, scope: !713)
!726 = !DILocation(line: 396, column: 14, scope: !713)
!727 = !DILocation(line: 396, column: 12, scope: !713)
!728 = !DILocation(line: 397, column: 5, scope: !713)
!729 = !DILocalVariable(name: "my_local_data", scope: !713, file: !2, line: 399, type: !64)
!730 = !DILocation(line: 399, column: 11, scope: !713)
!731 = !DILocation(line: 399, column: 47, scope: !713)
!732 = !DILocation(line: 399, column: 27, scope: !713)
!733 = !DILocation(line: 400, column: 5, scope: !713)
!734 = !DILocation(line: 402, column: 34, scope: !713)
!735 = !DILocation(line: 402, column: 14, scope: !713)
!736 = !DILocation(line: 402, column: 12, scope: !713)
!737 = !DILocation(line: 403, column: 5, scope: !713)
!738 = !DILocalVariable(name: "result", scope: !713, file: !2, line: 405, type: !64)
!739 = !DILocation(line: 405, column: 11, scope: !713)
!740 = !DILocation(line: 405, column: 32, scope: !713)
!741 = !DILocation(line: 405, column: 20, scope: !713)
!742 = !DILocation(line: 406, column: 5, scope: !713)
!743 = !DILocation(line: 408, column: 33, scope: !713)
!744 = !DILocation(line: 408, column: 14, scope: !713)
!745 = !DILocation(line: 408, column: 12, scope: !713)
!746 = !DILocation(line: 409, column: 5, scope: !713)
!747 = !DILocation(line: 411, column: 5, scope: !713)
!748 = !DILocation(line: 412, column: 1, scope: !713)
!749 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 414, type: !750, scopeLine: 415, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !169)
!750 = !DISubroutineType(types: !751)
!751 = !{!155}
!752 = !DILocation(line: 416, column: 5, scope: !749)
!753 = !DILocation(line: 417, column: 5, scope: !749)
!754 = !DILocation(line: 418, column: 5, scope: !749)
!755 = !DILocation(line: 419, column: 5, scope: !749)
!756 = !DILocation(line: 420, column: 1, scope: !749)
