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
@cond_mutex = global %struct._opaque_pthread_mutex_t zeroinitializer, align 8, !dbg !99
@cond = global %struct._opaque_pthread_cond_t zeroinitializer, align 8, !dbg !113
@__func__.cond_test = private unnamed_addr constant [10 x i8] c"cond_test\00", align 1, !dbg !65
@.str.4 = private unnamed_addr constant [18 x i8] c"result == message\00", align 1, !dbg !67
@__func__.rwlock_init = private unnamed_addr constant [12 x i8] c"rwlock_init\00", align 1, !dbg !72
@__func__.rwlock_destroy = private unnamed_addr constant [15 x i8] c"rwlock_destroy\00", align 1, !dbg !74
@__func__.rwlock_wrlock = private unnamed_addr constant [14 x i8] c"rwlock_wrlock\00", align 1, !dbg !76
@__func__.rwlock_rdlock = private unnamed_addr constant [14 x i8] c"rwlock_rdlock\00", align 1, !dbg !78
@__func__.rwlock_unlock = private unnamed_addr constant [14 x i8] c"rwlock_unlock\00", align 1, !dbg !80
@__func__.rwlock_test = private unnamed_addr constant [12 x i8] c"rwlock_test\00", align 1, !dbg !82
@latest_thread = global ptr null, align 8, !dbg !125
@local_data = global i64 0, align 8, !dbg !148
@__func__.key_worker = private unnamed_addr constant [11 x i8] c"key_worker\00", align 1, !dbg !84
@.str.5 = private unnamed_addr constant [28 x i8] c"my_local_data == &my_secret\00", align 1, !dbg !86
@__func__.key_test = private unnamed_addr constant [9 x i8] c"key_test\00", align 1, !dbg !91
@.str.6 = private unnamed_addr constant [37 x i8] c"pthread_equal(latest_thread, worker)\00", align 1, !dbg !94

; Function Attrs: noinline nounwind ssp uwtable
define ptr @thread_create(ptr noundef %0, ptr noundef %1) #0 !dbg !162 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca %struct._opaque_pthread_attr_t, align 8
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !169, metadata !DIExpression()), !dbg !170
  store ptr %1, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !171, metadata !DIExpression()), !dbg !172
  call void @llvm.dbg.declare(metadata ptr %5, metadata !173, metadata !DIExpression()), !dbg !174
  call void @llvm.dbg.declare(metadata ptr %6, metadata !175, metadata !DIExpression()), !dbg !183
  %8 = call i32 @pthread_attr_init(ptr noundef %6), !dbg !184
  call void @llvm.dbg.declare(metadata ptr %7, metadata !185, metadata !DIExpression()), !dbg !186
  %9 = load ptr, ptr %3, align 8, !dbg !187
  %10 = load ptr, ptr %4, align 8, !dbg !188
  %11 = call i32 @pthread_create(ptr noundef %5, ptr noundef %6, ptr noundef %9, ptr noundef %10), !dbg !189
  store i32 %11, ptr %7, align 4, !dbg !186
  %12 = load i32, ptr %7, align 4, !dbg !190
  %13 = icmp eq i32 %12, 0, !dbg !190
  %14 = xor i1 %13, true, !dbg !190
  %15 = zext i1 %14 to i32, !dbg !190
  %16 = sext i32 %15 to i64, !dbg !190
  %17 = icmp ne i64 %16, 0, !dbg !190
  br i1 %17, label %18, label %20, !dbg !190

18:                                               ; preds = %2
  call void @__assert_rtn(ptr noundef @__func__.thread_create, ptr noundef @.str, i32 noundef 19, ptr noundef @.str.1) #4, !dbg !190
  unreachable, !dbg !190

19:                                               ; No predecessors!
  br label %21, !dbg !190

20:                                               ; preds = %2
  br label %21, !dbg !190

21:                                               ; preds = %20, %19
  %22 = call i32 @pthread_attr_destroy(ptr noundef %6), !dbg !191
  %23 = load ptr, ptr %5, align 8, !dbg !192
  ret ptr %23, !dbg !193
}

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @pthread_attr_init(ptr noundef) #2

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

declare i32 @pthread_attr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define ptr @thread_join(ptr noundef %0) #0 !dbg !194 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !197, metadata !DIExpression()), !dbg !198
  call void @llvm.dbg.declare(metadata ptr %3, metadata !199, metadata !DIExpression()), !dbg !200
  call void @llvm.dbg.declare(metadata ptr %4, metadata !201, metadata !DIExpression()), !dbg !202
  %5 = load ptr, ptr %2, align 8, !dbg !203
  %6 = call i32 @pthread_join(ptr noundef %5, ptr noundef %3), !dbg !204
  store i32 %6, ptr %4, align 4, !dbg !202
  %7 = load i32, ptr %4, align 4, !dbg !205
  %8 = icmp eq i32 %7, 0, !dbg !205
  %9 = xor i1 %8, true, !dbg !205
  %10 = zext i1 %9 to i32, !dbg !205
  %11 = sext i32 %10 to i64, !dbg !205
  %12 = icmp ne i64 %11, 0, !dbg !205
  br i1 %12, label %13, label %15, !dbg !205

13:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.thread_join, ptr noundef @.str, i32 noundef 28, ptr noundef @.str.1) #4, !dbg !205
  unreachable, !dbg !205

14:                                               ; No predecessors!
  br label %16, !dbg !205

15:                                               ; preds = %1
  br label %16, !dbg !205

16:                                               ; preds = %15, %14
  %17 = load ptr, ptr %3, align 8, !dbg !206
  ret ptr %17, !dbg !207
}

declare i32 @pthread_join(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_init(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) #0 !dbg !208 {
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca %struct._opaque_pthread_mutexattr_t, align 8
  store ptr %0, ptr %6, align 8
  call void @llvm.dbg.declare(metadata ptr %6, metadata !212, metadata !DIExpression()), !dbg !213
  store i32 %1, ptr %7, align 4
  call void @llvm.dbg.declare(metadata ptr %7, metadata !214, metadata !DIExpression()), !dbg !215
  store i32 %2, ptr %8, align 4
  call void @llvm.dbg.declare(metadata ptr %8, metadata !216, metadata !DIExpression()), !dbg !217
  store i32 %3, ptr %9, align 4
  call void @llvm.dbg.declare(metadata ptr %9, metadata !218, metadata !DIExpression()), !dbg !219
  store i32 %4, ptr %10, align 4
  call void @llvm.dbg.declare(metadata ptr %10, metadata !220, metadata !DIExpression()), !dbg !221
  call void @llvm.dbg.declare(metadata ptr %11, metadata !222, metadata !DIExpression()), !dbg !223
  call void @llvm.dbg.declare(metadata ptr %12, metadata !224, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.declare(metadata ptr %13, metadata !226, metadata !DIExpression()), !dbg !234
  %14 = call i32 @pthread_mutexattr_init(ptr noundef %13), !dbg !235
  store i32 %14, ptr %11, align 4, !dbg !236
  %15 = load i32, ptr %11, align 4, !dbg !237
  %16 = icmp eq i32 %15, 0, !dbg !237
  %17 = xor i1 %16, true, !dbg !237
  %18 = zext i1 %17 to i32, !dbg !237
  %19 = sext i32 %18 to i64, !dbg !237
  %20 = icmp ne i64 %19, 0, !dbg !237
  br i1 %20, label %21, label %23, !dbg !237

21:                                               ; preds = %5
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 50, ptr noundef @.str.1) #4, !dbg !237
  unreachable, !dbg !237

22:                                               ; No predecessors!
  br label %24, !dbg !237

23:                                               ; preds = %5
  br label %24, !dbg !237

24:                                               ; preds = %23, %22
  %25 = load i32, ptr %7, align 4, !dbg !238
  %26 = call i32 @pthread_mutexattr_settype(ptr noundef %13, i32 noundef %25), !dbg !239
  store i32 %26, ptr %11, align 4, !dbg !240
  %27 = load i32, ptr %11, align 4, !dbg !241
  %28 = icmp eq i32 %27, 0, !dbg !241
  %29 = xor i1 %28, true, !dbg !241
  %30 = zext i1 %29 to i32, !dbg !241
  %31 = sext i32 %30 to i64, !dbg !241
  %32 = icmp ne i64 %31, 0, !dbg !241
  br i1 %32, label %33, label %35, !dbg !241

33:                                               ; preds = %24
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 53, ptr noundef @.str.1) #4, !dbg !241
  unreachable, !dbg !241

34:                                               ; No predecessors!
  br label %36, !dbg !241

35:                                               ; preds = %24
  br label %36, !dbg !241

36:                                               ; preds = %35, %34
  %37 = call i32 @pthread_mutexattr_gettype(ptr noundef %13, ptr noundef %12), !dbg !242
  store i32 %37, ptr %11, align 4, !dbg !243
  %38 = load i32, ptr %11, align 4, !dbg !244
  %39 = icmp eq i32 %38, 0, !dbg !244
  %40 = xor i1 %39, true, !dbg !244
  %41 = zext i1 %40 to i32, !dbg !244
  %42 = sext i32 %41 to i64, !dbg !244
  %43 = icmp ne i64 %42, 0, !dbg !244
  br i1 %43, label %44, label %46, !dbg !244

44:                                               ; preds = %36
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 55, ptr noundef @.str.1) #4, !dbg !244
  unreachable, !dbg !244

45:                                               ; No predecessors!
  br label %47, !dbg !244

46:                                               ; preds = %36
  br label %47, !dbg !244

47:                                               ; preds = %46, %45
  %48 = load i32, ptr %8, align 4, !dbg !245
  %49 = call i32 @pthread_mutexattr_setprotocol(ptr noundef %13, i32 noundef %48), !dbg !246
  store i32 %49, ptr %11, align 4, !dbg !247
  %50 = load i32, ptr %11, align 4, !dbg !248
  %51 = icmp eq i32 %50, 0, !dbg !248
  %52 = xor i1 %51, true, !dbg !248
  %53 = zext i1 %52 to i32, !dbg !248
  %54 = sext i32 %53 to i64, !dbg !248
  %55 = icmp ne i64 %54, 0, !dbg !248
  br i1 %55, label %56, label %58, !dbg !248

56:                                               ; preds = %47
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 58, ptr noundef @.str.1) #4, !dbg !248
  unreachable, !dbg !248

57:                                               ; No predecessors!
  br label %59, !dbg !248

58:                                               ; preds = %47
  br label %59, !dbg !248

59:                                               ; preds = %58, %57
  %60 = call i32 @pthread_mutexattr_getprotocol(ptr noundef %13, ptr noundef %12), !dbg !249
  store i32 %60, ptr %11, align 4, !dbg !250
  %61 = load i32, ptr %11, align 4, !dbg !251
  %62 = icmp eq i32 %61, 0, !dbg !251
  %63 = xor i1 %62, true, !dbg !251
  %64 = zext i1 %63 to i32, !dbg !251
  %65 = sext i32 %64 to i64, !dbg !251
  %66 = icmp ne i64 %65, 0, !dbg !251
  br i1 %66, label %67, label %69, !dbg !251

67:                                               ; preds = %59
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 60, ptr noundef @.str.1) #4, !dbg !251
  unreachable, !dbg !251

68:                                               ; No predecessors!
  br label %70, !dbg !251

69:                                               ; preds = %59
  br label %70, !dbg !251

70:                                               ; preds = %69, %68
  %71 = load i32, ptr %9, align 4, !dbg !252
  %72 = call i32 @pthread_mutexattr_setpolicy_np(ptr noundef %13, i32 noundef %71), !dbg !253
  store i32 %72, ptr %11, align 4, !dbg !254
  %73 = load i32, ptr %11, align 4, !dbg !255
  %74 = icmp eq i32 %73, 0, !dbg !255
  %75 = xor i1 %74, true, !dbg !255
  %76 = zext i1 %75 to i32, !dbg !255
  %77 = sext i32 %76 to i64, !dbg !255
  %78 = icmp ne i64 %77, 0, !dbg !255
  br i1 %78, label %79, label %81, !dbg !255

79:                                               ; preds = %70
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 63, ptr noundef @.str.1) #4, !dbg !255
  unreachable, !dbg !255

80:                                               ; No predecessors!
  br label %82, !dbg !255

81:                                               ; preds = %70
  br label %82, !dbg !255

82:                                               ; preds = %81, %80
  %83 = call i32 @pthread_mutexattr_getpolicy_np(ptr noundef %13, ptr noundef %12), !dbg !256
  store i32 %83, ptr %11, align 4, !dbg !257
  %84 = load i32, ptr %11, align 4, !dbg !258
  %85 = icmp eq i32 %84, 0, !dbg !258
  %86 = xor i1 %85, true, !dbg !258
  %87 = zext i1 %86 to i32, !dbg !258
  %88 = sext i32 %87 to i64, !dbg !258
  %89 = icmp ne i64 %88, 0, !dbg !258
  br i1 %89, label %90, label %92, !dbg !258

90:                                               ; preds = %82
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 65, ptr noundef @.str.1) #4, !dbg !258
  unreachable, !dbg !258

91:                                               ; No predecessors!
  br label %93, !dbg !258

92:                                               ; preds = %82
  br label %93, !dbg !258

93:                                               ; preds = %92, %91
  %94 = load i32, ptr %10, align 4, !dbg !259
  %95 = call i32 @pthread_mutexattr_setprioceiling(ptr noundef %13, i32 noundef %94), !dbg !260
  store i32 %95, ptr %11, align 4, !dbg !261
  %96 = load i32, ptr %11, align 4, !dbg !262
  %97 = icmp eq i32 %96, 0, !dbg !262
  %98 = xor i1 %97, true, !dbg !262
  %99 = zext i1 %98 to i32, !dbg !262
  %100 = sext i32 %99 to i64, !dbg !262
  %101 = icmp ne i64 %100, 0, !dbg !262
  br i1 %101, label %102, label %104, !dbg !262

102:                                              ; preds = %93
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 68, ptr noundef @.str.1) #4, !dbg !262
  unreachable, !dbg !262

103:                                              ; No predecessors!
  br label %105, !dbg !262

104:                                              ; preds = %93
  br label %105, !dbg !262

105:                                              ; preds = %104, %103
  %106 = call i32 @pthread_mutexattr_getprioceiling(ptr noundef %13, ptr noundef %12), !dbg !263
  store i32 %106, ptr %11, align 4, !dbg !264
  %107 = load i32, ptr %11, align 4, !dbg !265
  %108 = icmp eq i32 %107, 0, !dbg !265
  %109 = xor i1 %108, true, !dbg !265
  %110 = zext i1 %109 to i32, !dbg !265
  %111 = sext i32 %110 to i64, !dbg !265
  %112 = icmp ne i64 %111, 0, !dbg !265
  br i1 %112, label %113, label %115, !dbg !265

113:                                              ; preds = %105
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 70, ptr noundef @.str.1) #4, !dbg !265
  unreachable, !dbg !265

114:                                              ; No predecessors!
  br label %116, !dbg !265

115:                                              ; preds = %105
  br label %116, !dbg !265

116:                                              ; preds = %115, %114
  %117 = load ptr, ptr %6, align 8, !dbg !266
  %118 = call i32 @pthread_mutex_init(ptr noundef %117, ptr noundef %13), !dbg !267
  store i32 %118, ptr %11, align 4, !dbg !268
  %119 = load i32, ptr %11, align 4, !dbg !269
  %120 = icmp eq i32 %119, 0, !dbg !269
  %121 = xor i1 %120, true, !dbg !269
  %122 = zext i1 %121 to i32, !dbg !269
  %123 = sext i32 %122 to i64, !dbg !269
  %124 = icmp ne i64 %123, 0, !dbg !269
  br i1 %124, label %125, label %127, !dbg !269

125:                                              ; preds = %116
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 73, ptr noundef @.str.1) #4, !dbg !269
  unreachable, !dbg !269

126:                                              ; No predecessors!
  br label %128, !dbg !269

127:                                              ; preds = %116
  br label %128, !dbg !269

128:                                              ; preds = %127, %126
  %129 = call i32 @pthread_mutexattr_destroy(ptr noundef %13), !dbg !270
  store i32 %129, ptr %11, align 4, !dbg !271
  %130 = load i32, ptr %11, align 4, !dbg !272
  %131 = icmp eq i32 %130, 0, !dbg !272
  %132 = xor i1 %131, true, !dbg !272
  %133 = zext i1 %132 to i32, !dbg !272
  %134 = sext i32 %133 to i64, !dbg !272
  %135 = icmp ne i64 %134, 0, !dbg !272
  br i1 %135, label %136, label %138, !dbg !272

136:                                              ; preds = %128
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 75, ptr noundef @.str.1) #4, !dbg !272
  unreachable, !dbg !272

137:                                              ; No predecessors!
  br label %139, !dbg !272

138:                                              ; preds = %128
  br label %139, !dbg !272

139:                                              ; preds = %138, %137
  ret void, !dbg !273
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

declare i32 @pthread_mutexattr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_destroy(ptr noundef %0) #0 !dbg !274 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !277, metadata !DIExpression()), !dbg !278
  call void @llvm.dbg.declare(metadata ptr %3, metadata !279, metadata !DIExpression()), !dbg !280
  %4 = load ptr, ptr %2, align 8, !dbg !281
  %5 = call i32 @pthread_mutex_destroy(ptr noundef %4), !dbg !282
  store i32 %5, ptr %3, align 4, !dbg !280
  %6 = load i32, ptr %3, align 4, !dbg !283
  %7 = icmp eq i32 %6, 0, !dbg !283
  %8 = xor i1 %7, true, !dbg !283
  %9 = zext i1 %8 to i32, !dbg !283
  %10 = sext i32 %9 to i64, !dbg !283
  %11 = icmp ne i64 %10, 0, !dbg !283
  br i1 %11, label %12, label %14, !dbg !283

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_destroy, ptr noundef @.str, i32 noundef 81, ptr noundef @.str.1) #4, !dbg !283
  unreachable, !dbg !283

13:                                               ; No predecessors!
  br label %15, !dbg !283

14:                                               ; preds = %1
  br label %15, !dbg !283

15:                                               ; preds = %14, %13
  ret void, !dbg !284
}

declare i32 @pthread_mutex_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_lock(ptr noundef %0) #0 !dbg !285 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !286, metadata !DIExpression()), !dbg !287
  call void @llvm.dbg.declare(metadata ptr %3, metadata !288, metadata !DIExpression()), !dbg !289
  %4 = load ptr, ptr %2, align 8, !dbg !290
  %5 = call i32 @pthread_mutex_lock(ptr noundef %4), !dbg !291
  store i32 %5, ptr %3, align 4, !dbg !289
  %6 = load i32, ptr %3, align 4, !dbg !292
  %7 = icmp eq i32 %6, 0, !dbg !292
  %8 = xor i1 %7, true, !dbg !292
  %9 = zext i1 %8 to i32, !dbg !292
  %10 = sext i32 %9 to i64, !dbg !292
  %11 = icmp ne i64 %10, 0, !dbg !292
  br i1 %11, label %12, label %14, !dbg !292

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_lock, ptr noundef @.str, i32 noundef 87, ptr noundef @.str.1) #4, !dbg !292
  unreachable, !dbg !292

13:                                               ; No predecessors!
  br label %15, !dbg !292

14:                                               ; preds = %1
  br label %15, !dbg !292

15:                                               ; preds = %14, %13
  ret void, !dbg !293
}

declare i32 @pthread_mutex_lock(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define zeroext i1 @mutex_trylock(ptr noundef %0) #0 !dbg !294 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !298, metadata !DIExpression()), !dbg !299
  call void @llvm.dbg.declare(metadata ptr %3, metadata !300, metadata !DIExpression()), !dbg !301
  %4 = load ptr, ptr %2, align 8, !dbg !302
  %5 = call i32 @pthread_mutex_trylock(ptr noundef %4), !dbg !303
  store i32 %5, ptr %3, align 4, !dbg !301
  %6 = load i32, ptr %3, align 4, !dbg !304
  %7 = icmp eq i32 %6, 0, !dbg !305
  ret i1 %7, !dbg !306
}

declare i32 @pthread_mutex_trylock(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_unlock(ptr noundef %0) #0 !dbg !307 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !308, metadata !DIExpression()), !dbg !309
  call void @llvm.dbg.declare(metadata ptr %3, metadata !310, metadata !DIExpression()), !dbg !311
  %4 = load ptr, ptr %2, align 8, !dbg !312
  %5 = call i32 @pthread_mutex_unlock(ptr noundef %4), !dbg !313
  store i32 %5, ptr %3, align 4, !dbg !311
  %6 = load i32, ptr %3, align 4, !dbg !314
  %7 = icmp eq i32 %6, 0, !dbg !314
  %8 = xor i1 %7, true, !dbg !314
  %9 = zext i1 %8 to i32, !dbg !314
  %10 = sext i32 %9 to i64, !dbg !314
  %11 = icmp ne i64 %10, 0, !dbg !314
  br i1 %11, label %12, label %14, !dbg !314

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_unlock, ptr noundef @.str, i32 noundef 100, ptr noundef @.str.1) #4, !dbg !314
  unreachable, !dbg !314

13:                                               ; No predecessors!
  br label %15, !dbg !314

14:                                               ; preds = %1
  br label %15, !dbg !314

15:                                               ; preds = %14, %13
  ret void, !dbg !315
}

declare i32 @pthread_mutex_unlock(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_test() #0 !dbg !316 {
  %1 = alloca %struct._opaque_pthread_mutex_t, align 8
  %2 = alloca %struct._opaque_pthread_mutex_t, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  %5 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata ptr %1, metadata !319, metadata !DIExpression()), !dbg !320
  call void @llvm.dbg.declare(metadata ptr %2, metadata !321, metadata !DIExpression()), !dbg !322
  call void @mutex_init(ptr noundef %1, i32 noundef 1, i32 noundef 1, i32 noundef 1, i32 noundef 1), !dbg !323
  call void @mutex_init(ptr noundef %2, i32 noundef 2, i32 noundef 2, i32 noundef 3, i32 noundef 2), !dbg !324
  call void @mutex_lock(ptr noundef %1), !dbg !325
  call void @llvm.dbg.declare(metadata ptr %3, metadata !327, metadata !DIExpression()), !dbg !328
  %6 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !329
  %7 = zext i1 %6 to i8, !dbg !328
  store i8 %7, ptr %3, align 1, !dbg !328
  %8 = load i8, ptr %3, align 1, !dbg !330
  %9 = trunc i8 %8 to i1, !dbg !330
  %10 = xor i1 %9, true, !dbg !330
  %11 = xor i1 %10, true, !dbg !330
  %12 = zext i1 %11 to i32, !dbg !330
  %13 = sext i32 %12 to i64, !dbg !330
  %14 = icmp ne i64 %13, 0, !dbg !330
  br i1 %14, label %15, label %17, !dbg !330

15:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 114, ptr noundef @.str.2) #4, !dbg !330
  unreachable, !dbg !330

16:                                               ; No predecessors!
  br label %18, !dbg !330

17:                                               ; preds = %0
  br label %18, !dbg !330

18:                                               ; preds = %17, %16
  call void @mutex_unlock(ptr noundef %1), !dbg !331
  call void @mutex_lock(ptr noundef %2), !dbg !332
  call void @llvm.dbg.declare(metadata ptr %4, metadata !334, metadata !DIExpression()), !dbg !336
  %19 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !337
  %20 = zext i1 %19 to i8, !dbg !336
  store i8 %20, ptr %4, align 1, !dbg !336
  %21 = load i8, ptr %4, align 1, !dbg !338
  %22 = trunc i8 %21 to i1, !dbg !338
  %23 = xor i1 %22, true, !dbg !338
  %24 = zext i1 %23 to i32, !dbg !338
  %25 = sext i32 %24 to i64, !dbg !338
  %26 = icmp ne i64 %25, 0, !dbg !338
  br i1 %26, label %27, label %29, !dbg !338

27:                                               ; preds = %18
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 123, ptr noundef @.str.3) #4, !dbg !338
  unreachable, !dbg !338

28:                                               ; No predecessors!
  br label %30, !dbg !338

29:                                               ; preds = %18
  br label %30, !dbg !338

30:                                               ; preds = %29, %28
  call void @mutex_unlock(ptr noundef %1), !dbg !339
  call void @llvm.dbg.declare(metadata ptr %5, metadata !340, metadata !DIExpression()), !dbg !342
  %31 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !343
  %32 = zext i1 %31 to i8, !dbg !342
  store i8 %32, ptr %5, align 1, !dbg !342
  %33 = load i8, ptr %5, align 1, !dbg !344
  %34 = trunc i8 %33 to i1, !dbg !344
  %35 = xor i1 %34, true, !dbg !344
  %36 = zext i1 %35 to i32, !dbg !344
  %37 = sext i32 %36 to i64, !dbg !344
  %38 = icmp ne i64 %37, 0, !dbg !344
  br i1 %38, label %39, label %41, !dbg !344

39:                                               ; preds = %30
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 129, ptr noundef @.str.3) #4, !dbg !344
  unreachable, !dbg !344

40:                                               ; No predecessors!
  br label %42, !dbg !344

41:                                               ; preds = %30
  br label %42, !dbg !344

42:                                               ; preds = %41, %40
  call void @mutex_unlock(ptr noundef %1), !dbg !345
  call void @mutex_unlock(ptr noundef %2), !dbg !346
  call void @mutex_destroy(ptr noundef %2), !dbg !347
  call void @mutex_destroy(ptr noundef %1), !dbg !348
  ret void, !dbg !349
}

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_init(ptr noundef %0) #0 !dbg !350 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca %struct._opaque_pthread_condattr_t, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !354, metadata !DIExpression()), !dbg !355
  call void @llvm.dbg.declare(metadata ptr %3, metadata !356, metadata !DIExpression()), !dbg !357
  call void @llvm.dbg.declare(metadata ptr %4, metadata !358, metadata !DIExpression()), !dbg !366
  %5 = call i32 @pthread_condattr_init(ptr noundef %4), !dbg !367
  store i32 %5, ptr %3, align 4, !dbg !368
  %6 = load i32, ptr %3, align 4, !dbg !369
  %7 = icmp eq i32 %6, 0, !dbg !369
  %8 = xor i1 %7, true, !dbg !369
  %9 = zext i1 %8 to i32, !dbg !369
  %10 = sext i32 %9 to i64, !dbg !369
  %11 = icmp ne i64 %10, 0, !dbg !369
  br i1 %11, label %12, label %14, !dbg !369

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 155, ptr noundef @.str.1) #4, !dbg !369
  unreachable, !dbg !369

13:                                               ; No predecessors!
  br label %15, !dbg !369

14:                                               ; preds = %1
  br label %15, !dbg !369

15:                                               ; preds = %14, %13
  %16 = load ptr, ptr %2, align 8, !dbg !370
  %17 = call i32 @pthread_cond_init(ptr noundef %16, ptr noundef %4), !dbg !371
  store i32 %17, ptr %3, align 4, !dbg !372
  %18 = load i32, ptr %3, align 4, !dbg !373
  %19 = icmp eq i32 %18, 0, !dbg !373
  %20 = xor i1 %19, true, !dbg !373
  %21 = zext i1 %20 to i32, !dbg !373
  %22 = sext i32 %21 to i64, !dbg !373
  %23 = icmp ne i64 %22, 0, !dbg !373
  br i1 %23, label %24, label %26, !dbg !373

24:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 158, ptr noundef @.str.1) #4, !dbg !373
  unreachable, !dbg !373

25:                                               ; No predecessors!
  br label %27, !dbg !373

26:                                               ; preds = %15
  br label %27, !dbg !373

27:                                               ; preds = %26, %25
  %28 = call i32 @pthread_condattr_destroy(ptr noundef %4), !dbg !374
  store i32 %28, ptr %3, align 4, !dbg !375
  %29 = load i32, ptr %3, align 4, !dbg !376
  %30 = icmp eq i32 %29, 0, !dbg !376
  %31 = xor i1 %30, true, !dbg !376
  %32 = zext i1 %31 to i32, !dbg !376
  %33 = sext i32 %32 to i64, !dbg !376
  %34 = icmp ne i64 %33, 0, !dbg !376
  br i1 %34, label %35, label %37, !dbg !376

35:                                               ; preds = %27
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 161, ptr noundef @.str.1) #4, !dbg !376
  unreachable, !dbg !376

36:                                               ; No predecessors!
  br label %38, !dbg !376

37:                                               ; preds = %27
  br label %38, !dbg !376

38:                                               ; preds = %37, %36
  ret void, !dbg !377
}

declare i32 @pthread_condattr_init(ptr noundef) #2

declare i32 @pthread_cond_init(ptr noundef, ptr noundef) #2

declare i32 @pthread_condattr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_destroy(ptr noundef %0) #0 !dbg !378 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !379, metadata !DIExpression()), !dbg !380
  call void @llvm.dbg.declare(metadata ptr %3, metadata !381, metadata !DIExpression()), !dbg !382
  %4 = load ptr, ptr %2, align 8, !dbg !383
  %5 = call i32 @pthread_cond_destroy(ptr noundef %4), !dbg !384
  store i32 %5, ptr %3, align 4, !dbg !382
  %6 = load i32, ptr %3, align 4, !dbg !385
  %7 = icmp eq i32 %6, 0, !dbg !385
  %8 = xor i1 %7, true, !dbg !385
  %9 = zext i1 %8 to i32, !dbg !385
  %10 = sext i32 %9 to i64, !dbg !385
  %11 = icmp ne i64 %10, 0, !dbg !385
  br i1 %11, label %12, label %14, !dbg !385

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_destroy, ptr noundef @.str, i32 noundef 167, ptr noundef @.str.1) #4, !dbg !385
  unreachable, !dbg !385

13:                                               ; No predecessors!
  br label %15, !dbg !385

14:                                               ; preds = %1
  br label %15, !dbg !385

15:                                               ; preds = %14, %13
  ret void, !dbg !386
}

declare i32 @pthread_cond_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_signal(ptr noundef %0) #0 !dbg !387 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !388, metadata !DIExpression()), !dbg !389
  call void @llvm.dbg.declare(metadata ptr %3, metadata !390, metadata !DIExpression()), !dbg !391
  %4 = load ptr, ptr %2, align 8, !dbg !392
  %5 = call i32 @pthread_cond_signal(ptr noundef %4), !dbg !393
  store i32 %5, ptr %3, align 4, !dbg !391
  %6 = load i32, ptr %3, align 4, !dbg !394
  %7 = icmp eq i32 %6, 0, !dbg !394
  %8 = xor i1 %7, true, !dbg !394
  %9 = zext i1 %8 to i32, !dbg !394
  %10 = sext i32 %9 to i64, !dbg !394
  %11 = icmp ne i64 %10, 0, !dbg !394
  br i1 %11, label %12, label %14, !dbg !394

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_signal, ptr noundef @.str, i32 noundef 173, ptr noundef @.str.1) #4, !dbg !394
  unreachable, !dbg !394

13:                                               ; No predecessors!
  br label %15, !dbg !394

14:                                               ; preds = %1
  br label %15, !dbg !394

15:                                               ; preds = %14, %13
  ret void, !dbg !395
}

declare i32 @pthread_cond_signal(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_broadcast(ptr noundef %0) #0 !dbg !396 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !397, metadata !DIExpression()), !dbg !398
  call void @llvm.dbg.declare(metadata ptr %3, metadata !399, metadata !DIExpression()), !dbg !400
  %4 = load ptr, ptr %2, align 8, !dbg !401
  %5 = call i32 @pthread_cond_broadcast(ptr noundef %4), !dbg !402
  store i32 %5, ptr %3, align 4, !dbg !400
  %6 = load i32, ptr %3, align 4, !dbg !403
  %7 = icmp eq i32 %6, 0, !dbg !403
  %8 = xor i1 %7, true, !dbg !403
  %9 = zext i1 %8 to i32, !dbg !403
  %10 = sext i32 %9 to i64, !dbg !403
  %11 = icmp ne i64 %10, 0, !dbg !403
  br i1 %11, label %12, label %14, !dbg !403

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_broadcast, ptr noundef @.str, i32 noundef 179, ptr noundef @.str.1) #4, !dbg !403
  unreachable, !dbg !403

13:                                               ; No predecessors!
  br label %15, !dbg !403

14:                                               ; preds = %1
  br label %15, !dbg !403

15:                                               ; preds = %14, %13
  ret void, !dbg !404
}

declare i32 @pthread_cond_broadcast(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_wait(ptr noundef %0, ptr noundef %1) #0 !dbg !405 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !408, metadata !DIExpression()), !dbg !409
  store ptr %1, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !410, metadata !DIExpression()), !dbg !411
  call void @llvm.dbg.declare(metadata ptr %5, metadata !412, metadata !DIExpression()), !dbg !413
  %6 = load ptr, ptr %3, align 8, !dbg !414
  %7 = load ptr, ptr %4, align 8, !dbg !415
  %8 = call i32 @pthread_cond_wait(ptr noundef %6, ptr noundef %7), !dbg !416
  store i32 %8, ptr %5, align 4, !dbg !413
  ret void, !dbg !417
}

declare i32 @pthread_cond_wait(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_timedwait(ptr noundef %0, ptr noundef %1, i64 noundef %2) #0 !dbg !418 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i64, align 8
  %7 = alloca %struct.timespec, align 8
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !422, metadata !DIExpression()), !dbg !423
  store ptr %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !424, metadata !DIExpression()), !dbg !425
  store i64 %2, ptr %6, align 8
  call void @llvm.dbg.declare(metadata ptr %6, metadata !426, metadata !DIExpression()), !dbg !427
  call void @llvm.dbg.declare(metadata ptr %7, metadata !428, metadata !DIExpression()), !dbg !436
  %9 = load i64, ptr %6, align 8, !dbg !437
  call void @llvm.dbg.declare(metadata ptr %8, metadata !438, metadata !DIExpression()), !dbg !439
  %10 = load ptr, ptr %4, align 8, !dbg !440
  %11 = load ptr, ptr %5, align 8, !dbg !441
  %12 = call i32 @pthread_cond_timedwait(ptr noundef %10, ptr noundef %11, ptr noundef %7), !dbg !442
  store i32 %12, ptr %8, align 4, !dbg !439
  ret void, !dbg !443
}

declare i32 @pthread_cond_timedwait(ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define ptr @cond_worker(ptr noundef %0) #0 !dbg !444 {
  %2 = alloca ptr, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !445, metadata !DIExpression()), !dbg !446
  call void @llvm.dbg.declare(metadata ptr %3, metadata !447, metadata !DIExpression()), !dbg !449
  store i8 1, ptr %3, align 1, !dbg !449
  br label %5, !dbg !450

5:                                                ; preds = %8, %1
  %6 = load i8, ptr %3, align 1, !dbg !451
  %7 = trunc i8 %6 to i1, !dbg !451
  br i1 %7, label %8, label %12, !dbg !453

8:                                                ; preds = %5
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !454
  call void @cond_wait(ptr noundef @cond, ptr noundef @cond_mutex), !dbg !456
  %9 = load i32, ptr @phase, align 4, !dbg !457
  %10 = icmp slt i32 %9, 1, !dbg !458
  %11 = zext i1 %10 to i8, !dbg !459
  store i8 %11, ptr %3, align 1, !dbg !459
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !460
  br label %5, !dbg !461, !llvm.loop !462

12:                                               ; preds = %5
  call void @llvm.dbg.declare(metadata ptr %4, metadata !465, metadata !DIExpression()), !dbg !467
  store i8 1, ptr %4, align 1, !dbg !467
  br label %13, !dbg !468

13:                                               ; preds = %16, %12
  %14 = load i8, ptr %4, align 1, !dbg !469
  %15 = trunc i8 %14 to i1, !dbg !469
  br i1 %15, label %16, label %20, !dbg !471

16:                                               ; preds = %13
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !472
  call void @cond_timedwait(ptr noundef @cond, ptr noundef @cond_mutex, i64 noundef 10), !dbg !474
  %17 = load i32, ptr @phase, align 4, !dbg !475
  %18 = icmp slt i32 %17, 2, !dbg !476
  %19 = zext i1 %18 to i8, !dbg !477
  store i8 %19, ptr %4, align 1, !dbg !477
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !478
  br label %13, !dbg !479, !llvm.loop !480

20:                                               ; preds = %13
  %21 = load ptr, ptr %2, align 8, !dbg !482
  ret ptr %21, !dbg !483
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
  call void @__assert_rtn(ptr noundef @__func__.cond_test, ptr noundef @.str, i32 noundef 245, ptr noundef @.str.4) #4, !dbg !507
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
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 262, ptr noundef @.str.1) #4, !dbg !547
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
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 265, ptr noundef @.str.1) #4, !dbg !551
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
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 267, ptr noundef @.str.1) #4, !dbg !554
  unreachable, !dbg !554

39:                                               ; No predecessors!
  br label %41, !dbg !554

40:                                               ; preds = %30
  br label %41, !dbg !554

41:                                               ; preds = %40, %39
  %42 = load ptr, ptr %3, align 8, !dbg !555
  %43 = call i32 @pthread_rwlock_init(ptr noundef %42, ptr noundef %7), !dbg !556
  store i32 %43, ptr %5, align 4, !dbg !557
  %44 = load i32, ptr %5, align 4, !dbg !558
  %45 = icmp eq i32 %44, 0, !dbg !558
  %46 = xor i1 %45, true, !dbg !558
  %47 = zext i1 %46 to i32, !dbg !558
  %48 = sext i32 %47 to i64, !dbg !558
  %49 = icmp ne i64 %48, 0, !dbg !558
  br i1 %49, label %50, label %52, !dbg !558

50:                                               ; preds = %41
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 270, ptr noundef @.str.1) #4, !dbg !558
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
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 272, ptr noundef @.str.1) #4, !dbg !561
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

declare i32 @pthread_rwlock_init(ptr noundef, ptr noundef) #2

declare i32 @pthread_rwlockattr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_destroy(ptr noundef %0) #0 !dbg !563 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !566, metadata !DIExpression()), !dbg !567
  call void @llvm.dbg.declare(metadata ptr %3, metadata !568, metadata !DIExpression()), !dbg !569
  %4 = load ptr, ptr %2, align 8, !dbg !570
  %5 = call i32 @pthread_rwlock_destroy(ptr noundef %4), !dbg !571
  store i32 %5, ptr %3, align 4, !dbg !569
  %6 = load i32, ptr %3, align 4, !dbg !572
  %7 = icmp eq i32 %6, 0, !dbg !572
  %8 = xor i1 %7, true, !dbg !572
  %9 = zext i1 %8 to i32, !dbg !572
  %10 = sext i32 %9 to i64, !dbg !572
  %11 = icmp ne i64 %10, 0, !dbg !572
  br i1 %11, label %12, label %14, !dbg !572

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_destroy, ptr noundef @.str, i32 noundef 278, ptr noundef @.str.1) #4, !dbg !572
  unreachable, !dbg !572

13:                                               ; No predecessors!
  br label %15, !dbg !572

14:                                               ; preds = %1
  br label %15, !dbg !572

15:                                               ; preds = %14, %13
  ret void, !dbg !573
}

declare i32 @pthread_rwlock_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_wrlock(ptr noundef %0) #0 !dbg !574 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !575, metadata !DIExpression()), !dbg !576
  call void @llvm.dbg.declare(metadata ptr %3, metadata !577, metadata !DIExpression()), !dbg !578
  %4 = load ptr, ptr %2, align 8, !dbg !579
  %5 = call i32 @pthread_rwlock_wrlock(ptr noundef %4), !dbg !580
  store i32 %5, ptr %3, align 4, !dbg !578
  %6 = load i32, ptr %3, align 4, !dbg !581
  %7 = icmp eq i32 %6, 0, !dbg !581
  %8 = xor i1 %7, true, !dbg !581
  %9 = zext i1 %8 to i32, !dbg !581
  %10 = sext i32 %9 to i64, !dbg !581
  %11 = icmp ne i64 %10, 0, !dbg !581
  br i1 %11, label %12, label %14, !dbg !581

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_wrlock, ptr noundef @.str, i32 noundef 284, ptr noundef @.str.1) #4, !dbg !581
  unreachable, !dbg !581

13:                                               ; No predecessors!
  br label %15, !dbg !581

14:                                               ; preds = %1
  br label %15, !dbg !581

15:                                               ; preds = %14, %13
  ret void, !dbg !582
}

declare i32 @pthread_rwlock_wrlock(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define zeroext i1 @rwlock_trywrlock(ptr noundef %0) #0 !dbg !583 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !586, metadata !DIExpression()), !dbg !587
  call void @llvm.dbg.declare(metadata ptr %3, metadata !588, metadata !DIExpression()), !dbg !589
  %4 = load ptr, ptr %2, align 8, !dbg !590
  %5 = call i32 @pthread_rwlock_trywrlock(ptr noundef %4), !dbg !591
  store i32 %5, ptr %3, align 4, !dbg !589
  %6 = load i32, ptr %3, align 4, !dbg !592
  %7 = icmp eq i32 %6, 0, !dbg !593
  ret i1 %7, !dbg !594
}

declare i32 @pthread_rwlock_trywrlock(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_rdlock(ptr noundef %0) #0 !dbg !595 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !596, metadata !DIExpression()), !dbg !597
  call void @llvm.dbg.declare(metadata ptr %3, metadata !598, metadata !DIExpression()), !dbg !599
  %4 = load ptr, ptr %2, align 8, !dbg !600
  %5 = call i32 @pthread_rwlock_rdlock(ptr noundef %4), !dbg !601
  store i32 %5, ptr %3, align 4, !dbg !599
  %6 = load i32, ptr %3, align 4, !dbg !602
  %7 = icmp eq i32 %6, 0, !dbg !602
  %8 = xor i1 %7, true, !dbg !602
  %9 = zext i1 %8 to i32, !dbg !602
  %10 = sext i32 %9 to i64, !dbg !602
  %11 = icmp ne i64 %10, 0, !dbg !602
  br i1 %11, label %12, label %14, !dbg !602

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_rdlock, ptr noundef @.str, i32 noundef 297, ptr noundef @.str.1) #4, !dbg !602
  unreachable, !dbg !602

13:                                               ; No predecessors!
  br label %15, !dbg !602

14:                                               ; preds = %1
  br label %15, !dbg !602

15:                                               ; preds = %14, %13
  ret void, !dbg !603
}

declare i32 @pthread_rwlock_rdlock(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define zeroext i1 @rwlock_tryrdlock(ptr noundef %0) #0 !dbg !604 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !605, metadata !DIExpression()), !dbg !606
  call void @llvm.dbg.declare(metadata ptr %3, metadata !607, metadata !DIExpression()), !dbg !608
  %4 = load ptr, ptr %2, align 8, !dbg !609
  %5 = call i32 @pthread_rwlock_tryrdlock(ptr noundef %4), !dbg !610
  store i32 %5, ptr %3, align 4, !dbg !608
  %6 = load i32, ptr %3, align 4, !dbg !611
  %7 = icmp eq i32 %6, 0, !dbg !612
  ret i1 %7, !dbg !613
}

declare i32 @pthread_rwlock_tryrdlock(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_unlock(ptr noundef %0) #0 !dbg !614 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !615, metadata !DIExpression()), !dbg !616
  call void @llvm.dbg.declare(metadata ptr %3, metadata !617, metadata !DIExpression()), !dbg !618
  %4 = load ptr, ptr %2, align 8, !dbg !619
  %5 = call i32 @pthread_rwlock_unlock(ptr noundef %4), !dbg !620
  store i32 %5, ptr %3, align 4, !dbg !618
  %6 = load i32, ptr %3, align 4, !dbg !621
  %7 = icmp eq i32 %6, 0, !dbg !621
  %8 = xor i1 %7, true, !dbg !621
  %9 = zext i1 %8 to i32, !dbg !621
  %10 = sext i32 %9 to i64, !dbg !621
  %11 = icmp ne i64 %10, 0, !dbg !621
  br i1 %11, label %12, label %14, !dbg !621

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_unlock, ptr noundef @.str, i32 noundef 310, ptr noundef @.str.1) #4, !dbg !621
  unreachable, !dbg !621

13:                                               ; No predecessors!
  br label %15, !dbg !621

14:                                               ; preds = %1
  br label %15, !dbg !621

15:                                               ; preds = %14, %13
  ret void, !dbg !622
}

declare i32 @pthread_rwlock_unlock(ptr noundef) #2

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
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 322, ptr noundef @.str.2) #4, !dbg !635
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
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 324, ptr noundef @.str.2) #4, !dbg !638
  unreachable, !dbg !638

32:                                               ; No predecessors!
  br label %34, !dbg !638

33:                                               ; preds = %21
  br label %34, !dbg !638

34:                                               ; preds = %33, %32
  call void @rwlock_unlock(ptr noundef %1), !dbg !639
  call void @__VERIFIER_loop_bound(i32 noundef 4), !dbg !640
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
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 333, ptr noundef @.str.3) #4, !dbg !654
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
  call void @llvm.dbg.declare(metadata ptr %6, metadata !660, metadata !DIExpression()), !dbg !662
  %55 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !663
  %56 = zext i1 %55 to i8, !dbg !662
  store i8 %56, ptr %6, align 1, !dbg !662
  %57 = load i8, ptr %6, align 1, !dbg !664
  %58 = trunc i8 %57 to i1, !dbg !664
  %59 = xor i1 %58, true, !dbg !664
  %60 = xor i1 %59, true, !dbg !664
  %61 = zext i1 %60 to i32, !dbg !664
  %62 = sext i32 %61 to i64, !dbg !664
  %63 = icmp ne i64 %62, 0, !dbg !664
  br i1 %63, label %64, label %66, !dbg !664

64:                                               ; preds = %54
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 338, ptr noundef @.str.2) #4, !dbg !664
  unreachable, !dbg !664

65:                                               ; No predecessors!
  br label %67, !dbg !664

66:                                               ; preds = %54
  br label %67, !dbg !664

67:                                               ; preds = %66, %65
  call void @__VERIFIER_loop_bound(i32 noundef 4), !dbg !665
  call void @llvm.dbg.declare(metadata ptr %7, metadata !666, metadata !DIExpression()), !dbg !668
  store i32 0, ptr %7, align 4, !dbg !668
  br label %68, !dbg !669

68:                                               ; preds = %72, %67
  %69 = load i32, ptr %7, align 4, !dbg !670
  %70 = icmp slt i32 %69, 4, !dbg !672
  br i1 %70, label %71, label %75, !dbg !673

71:                                               ; preds = %68
  call void @rwlock_unlock(ptr noundef %1), !dbg !674
  br label %72, !dbg !676

72:                                               ; preds = %71
  %73 = load i32, ptr %7, align 4, !dbg !677
  %74 = add nsw i32 %73, 1, !dbg !677
  store i32 %74, ptr %7, align 4, !dbg !677
  br label %68, !dbg !678, !llvm.loop !679

75:                                               ; preds = %68
  call void @rwlock_wrlock(ptr noundef %1), !dbg !681
  call void @llvm.dbg.declare(metadata ptr %8, metadata !683, metadata !DIExpression()), !dbg !684
  %76 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !685
  %77 = zext i1 %76 to i8, !dbg !684
  store i8 %77, ptr %8, align 1, !dbg !684
  call void @rwlock_unlock(ptr noundef %1), !dbg !686
  call void @rwlock_destroy(ptr noundef %1), !dbg !687
  ret void, !dbg !688
}

declare void @__VERIFIER_loop_bound(i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @key_destroy(ptr noundef %0) #0 !dbg !689 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !690, metadata !DIExpression()), !dbg !691
  %3 = call ptr @pthread_self(), !dbg !692
  store ptr %3, ptr @latest_thread, align 8, !dbg !693
  ret void, !dbg !694
}

declare ptr @pthread_self() #2

; Function Attrs: noinline nounwind ssp uwtable
define ptr @key_worker(ptr noundef %0) #0 !dbg !695 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !696, metadata !DIExpression()), !dbg !697
  call void @llvm.dbg.declare(metadata ptr %3, metadata !698, metadata !DIExpression()), !dbg !699
  store i32 1, ptr %3, align 4, !dbg !699
  call void @llvm.dbg.declare(metadata ptr %4, metadata !700, metadata !DIExpression()), !dbg !701
  %6 = load i64, ptr @local_data, align 8, !dbg !702
  %7 = call i32 @pthread_setspecific(i64 noundef %6, ptr noundef %3), !dbg !703
  store i32 %7, ptr %4, align 4, !dbg !701
  %8 = load i32, ptr %4, align 4, !dbg !704
  %9 = icmp eq i32 %8, 0, !dbg !704
  %10 = xor i1 %9, true, !dbg !704
  %11 = zext i1 %10 to i32, !dbg !704
  %12 = sext i32 %11 to i64, !dbg !704
  %13 = icmp ne i64 %12, 0, !dbg !704
  br i1 %13, label %14, label %16, !dbg !704

14:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.key_worker, ptr noundef @.str, i32 noundef 371, ptr noundef @.str.1) #4, !dbg !704
  unreachable, !dbg !704

15:                                               ; No predecessors!
  br label %17, !dbg !704

16:                                               ; preds = %1
  br label %17, !dbg !704

17:                                               ; preds = %16, %15
  call void @llvm.dbg.declare(metadata ptr %5, metadata !705, metadata !DIExpression()), !dbg !706
  %18 = load i64, ptr @local_data, align 8, !dbg !707
  %19 = call ptr @pthread_getspecific(i64 noundef %18), !dbg !708
  store ptr %19, ptr %5, align 8, !dbg !706
  %20 = load ptr, ptr %5, align 8, !dbg !709
  %21 = icmp eq ptr %20, %3, !dbg !709
  %22 = xor i1 %21, true, !dbg !709
  %23 = zext i1 %22 to i32, !dbg !709
  %24 = sext i32 %23 to i64, !dbg !709
  %25 = icmp ne i64 %24, 0, !dbg !709
  br i1 %25, label %26, label %28, !dbg !709

26:                                               ; preds = %17
  call void @__assert_rtn(ptr noundef @__func__.key_worker, ptr noundef @.str, i32 noundef 374, ptr noundef @.str.5) #4, !dbg !709
  unreachable, !dbg !709

27:                                               ; No predecessors!
  br label %29, !dbg !709

28:                                               ; preds = %17
  br label %29, !dbg !709

29:                                               ; preds = %28, %27
  %30 = load ptr, ptr %2, align 8, !dbg !710
  ret ptr %30, !dbg !711
}

declare i32 @pthread_setspecific(i64 noundef, ptr noundef) #2

declare ptr @pthread_getspecific(i64 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @key_test() #0 !dbg !712 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  call void @llvm.dbg.declare(metadata ptr %1, metadata !713, metadata !DIExpression()), !dbg !714
  store i32 2, ptr %1, align 4, !dbg !714
  call void @llvm.dbg.declare(metadata ptr %2, metadata !715, metadata !DIExpression()), !dbg !716
  store ptr inttoptr (i64 41 to ptr), ptr %2, align 8, !dbg !716
  call void @llvm.dbg.declare(metadata ptr %3, metadata !717, metadata !DIExpression()), !dbg !718
  %7 = call i32 @pthread_key_create(ptr noundef @local_data, ptr noundef @key_destroy), !dbg !719
  call void @llvm.dbg.declare(metadata ptr %4, metadata !720, metadata !DIExpression()), !dbg !721
  %8 = load ptr, ptr %2, align 8, !dbg !722
  %9 = call ptr @thread_create(ptr noundef @key_worker, ptr noundef %8), !dbg !723
  store ptr %9, ptr %4, align 8, !dbg !721
  %10 = load i64, ptr @local_data, align 8, !dbg !724
  %11 = call i32 @pthread_setspecific(i64 noundef %10, ptr noundef %1), !dbg !725
  store i32 %11, ptr %3, align 4, !dbg !726
  %12 = load i32, ptr %3, align 4, !dbg !727
  %13 = icmp eq i32 %12, 0, !dbg !727
  %14 = xor i1 %13, true, !dbg !727
  %15 = zext i1 %14 to i32, !dbg !727
  %16 = sext i32 %15 to i64, !dbg !727
  %17 = icmp ne i64 %16, 0, !dbg !727
  br i1 %17, label %18, label %20, !dbg !727

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 390, ptr noundef @.str.1) #4, !dbg !727
  unreachable, !dbg !727

19:                                               ; No predecessors!
  br label %21, !dbg !727

20:                                               ; preds = %0
  br label %21, !dbg !727

21:                                               ; preds = %20, %19
  call void @llvm.dbg.declare(metadata ptr %5, metadata !728, metadata !DIExpression()), !dbg !729
  %22 = load i64, ptr @local_data, align 8, !dbg !730
  %23 = call ptr @pthread_getspecific(i64 noundef %22), !dbg !731
  store ptr %23, ptr %5, align 8, !dbg !729
  %24 = load ptr, ptr %5, align 8, !dbg !732
  %25 = icmp eq ptr %24, %1, !dbg !732
  %26 = xor i1 %25, true, !dbg !732
  %27 = zext i1 %26 to i32, !dbg !732
  %28 = sext i32 %27 to i64, !dbg !732
  %29 = icmp ne i64 %28, 0, !dbg !732
  br i1 %29, label %30, label %32, !dbg !732

30:                                               ; preds = %21
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 393, ptr noundef @.str.5) #4, !dbg !732
  unreachable, !dbg !732

31:                                               ; No predecessors!
  br label %33, !dbg !732

32:                                               ; preds = %21
  br label %33, !dbg !732

33:                                               ; preds = %32, %31
  %34 = load i64, ptr @local_data, align 8, !dbg !733
  %35 = call i32 @pthread_setspecific(i64 noundef %34, ptr noundef null), !dbg !734
  store i32 %35, ptr %3, align 4, !dbg !735
  %36 = load i32, ptr %3, align 4, !dbg !736
  %37 = icmp eq i32 %36, 0, !dbg !736
  %38 = xor i1 %37, true, !dbg !736
  %39 = zext i1 %38 to i32, !dbg !736
  %40 = sext i32 %39 to i64, !dbg !736
  %41 = icmp ne i64 %40, 0, !dbg !736
  br i1 %41, label %42, label %44, !dbg !736

42:                                               ; preds = %33
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 396, ptr noundef @.str.1) #4, !dbg !736
  unreachable, !dbg !736

43:                                               ; No predecessors!
  br label %45, !dbg !736

44:                                               ; preds = %33
  br label %45, !dbg !736

45:                                               ; preds = %44, %43
  call void @llvm.dbg.declare(metadata ptr %6, metadata !737, metadata !DIExpression()), !dbg !738
  %46 = load ptr, ptr %4, align 8, !dbg !739
  %47 = call ptr @thread_join(ptr noundef %46), !dbg !740
  store ptr %47, ptr %6, align 8, !dbg !738
  %48 = load ptr, ptr %6, align 8, !dbg !741
  %49 = load ptr, ptr %2, align 8, !dbg !741
  %50 = icmp eq ptr %48, %49, !dbg !741
  %51 = xor i1 %50, true, !dbg !741
  %52 = zext i1 %51 to i32, !dbg !741
  %53 = sext i32 %52 to i64, !dbg !741
  %54 = icmp ne i64 %53, 0, !dbg !741
  br i1 %54, label %55, label %57, !dbg !741

55:                                               ; preds = %45
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 399, ptr noundef @.str.4) #4, !dbg !741
  unreachable, !dbg !741

56:                                               ; No predecessors!
  br label %58, !dbg !741

57:                                               ; preds = %45
  br label %58, !dbg !741

58:                                               ; preds = %57, %56
  %59 = load i64, ptr @local_data, align 8, !dbg !742
  %60 = call i32 @pthread_key_delete(i64 noundef %59), !dbg !743
  store i32 %60, ptr %3, align 4, !dbg !744
  %61 = load i32, ptr %3, align 4, !dbg !745
  %62 = icmp eq i32 %61, 0, !dbg !745
  %63 = xor i1 %62, true, !dbg !745
  %64 = zext i1 %63 to i32, !dbg !745
  %65 = sext i32 %64 to i64, !dbg !745
  %66 = icmp ne i64 %65, 0, !dbg !745
  br i1 %66, label %67, label %69, !dbg !745

67:                                               ; preds = %58
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 402, ptr noundef @.str.1) #4, !dbg !745
  unreachable, !dbg !745

68:                                               ; No predecessors!
  br label %70, !dbg !745

69:                                               ; preds = %58
  br label %70, !dbg !745

70:                                               ; preds = %69, %68
  %71 = load ptr, ptr @latest_thread, align 8, !dbg !746
  %72 = load ptr, ptr %4, align 8, !dbg !746
  %73 = call i32 @pthread_equal(ptr noundef %71, ptr noundef %72), !dbg !746
  %74 = icmp ne i32 %73, 0, !dbg !746
  %75 = xor i1 %74, true, !dbg !746
  %76 = zext i1 %75 to i32, !dbg !746
  %77 = sext i32 %76 to i64, !dbg !746
  %78 = icmp ne i64 %77, 0, !dbg !746
  br i1 %78, label %79, label %81, !dbg !746

79:                                               ; preds = %70
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 404, ptr noundef @.str.6) #4, !dbg !746
  unreachable, !dbg !746

80:                                               ; No predecessors!
  br label %82, !dbg !746

81:                                               ; preds = %70
  br label %82, !dbg !746

82:                                               ; preds = %81, %80
  ret void, !dbg !747
}

declare i32 @pthread_key_create(ptr noundef, ptr noundef) #2

declare i32 @pthread_key_delete(i64 noundef) #2

declare i32 @pthread_equal(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !748 {
  call void @mutex_test(), !dbg !751
  call void @cond_test(), !dbg !752
  call void @rwlock_test(), !dbg !753
  call void @key_test(), !dbg !754
  ret i32 0, !dbg !755
}

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #4 = { cold noreturn }

!llvm.dbg.cu = !{!61}
!llvm.module.flags = !{!155, !156, !157, !158, !159, !160}
!llvm.ident = !{!161}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 19, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "benchmarks/c/miscellaneous/pthread.c", directory: "/Users/r/Documents/Dat3M")
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
!22 = distinct !DIGlobalVariable(scope: null, file: !2, line: 50, type: !23, isLocal: true, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 88, elements: !24)
!24 = !{!25}
!25 = !DISubrange(count: 11)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(scope: null, file: !2, line: 81, type: !3, isLocal: true, isDefinition: true)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(scope: null, file: !2, line: 87, type: !23, isLocal: true, isDefinition: true)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !2, line: 100, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 104, elements: !33)
!33 = !{!34}
!34 = !DISubrange(count: 13)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(scope: null, file: !2, line: 114, type: !23, isLocal: true, isDefinition: true)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !2, line: 114, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 72, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 9)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !2, line: 123, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 64, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 8)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(scope: null, file: !2, line: 155, type: !49, isLocal: true, isDefinition: true)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 80, elements: !11)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(scope: null, file: !2, line: 167, type: !32, isLocal: true, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(scope: null, file: !2, line: 173, type: !20, isLocal: true, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(scope: null, file: !2, line: 179, type: !56, isLocal: true, isDefinition: true)
!56 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 120, elements: !57)
!57 = !{!58}
!58 = !DISubrange(count: 15)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "phase", scope: !61, file: !2, line: 201, type: !154, isLocal: false, isDefinition: true)
!61 = distinct !DICompileUnit(language: DW_LANG_C99, file: !2, producer: "Homebrew clang version 15.0.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !62, globals: !64, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!62 = !{!63}
!63 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!64 = !{!0, !8, !13, !18, !21, !26, !28, !30, !35, !37, !42, !47, !50, !52, !54, !59, !65, !67, !72, !74, !76, !78, !80, !82, !84, !86, !91, !94, !99, !113, !125, !148}
!65 = !DIGlobalVariableExpression(var: !66, expr: !DIExpression())
!66 = distinct !DIGlobalVariable(scope: null, file: !2, line: 245, type: !49, isLocal: true, isDefinition: true)
!67 = !DIGlobalVariableExpression(var: !68, expr: !DIExpression())
!68 = distinct !DIGlobalVariable(scope: null, file: !2, line: 245, type: !69, isLocal: true, isDefinition: true)
!69 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 144, elements: !70)
!70 = !{!71}
!71 = !DISubrange(count: 18)
!72 = !DIGlobalVariableExpression(var: !73, expr: !DIExpression())
!73 = distinct !DIGlobalVariable(scope: null, file: !2, line: 262, type: !20, isLocal: true, isDefinition: true)
!74 = !DIGlobalVariableExpression(var: !75, expr: !DIExpression())
!75 = distinct !DIGlobalVariable(scope: null, file: !2, line: 278, type: !56, isLocal: true, isDefinition: true)
!76 = !DIGlobalVariableExpression(var: !77, expr: !DIExpression())
!77 = distinct !DIGlobalVariable(scope: null, file: !2, line: 284, type: !3, isLocal: true, isDefinition: true)
!78 = !DIGlobalVariableExpression(var: !79, expr: !DIExpression())
!79 = distinct !DIGlobalVariable(scope: null, file: !2, line: 297, type: !3, isLocal: true, isDefinition: true)
!80 = !DIGlobalVariableExpression(var: !81, expr: !DIExpression())
!81 = distinct !DIGlobalVariable(scope: null, file: !2, line: 310, type: !3, isLocal: true, isDefinition: true)
!82 = !DIGlobalVariableExpression(var: !83, expr: !DIExpression())
!83 = distinct !DIGlobalVariable(scope: null, file: !2, line: 322, type: !20, isLocal: true, isDefinition: true)
!84 = !DIGlobalVariableExpression(var: !85, expr: !DIExpression())
!85 = distinct !DIGlobalVariable(scope: null, file: !2, line: 371, type: !23, isLocal: true, isDefinition: true)
!86 = !DIGlobalVariableExpression(var: !87, expr: !DIExpression())
!87 = distinct !DIGlobalVariable(scope: null, file: !2, line: 374, type: !88, isLocal: true, isDefinition: true)
!88 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 224, elements: !89)
!89 = !{!90}
!90 = !DISubrange(count: 28)
!91 = !DIGlobalVariableExpression(var: !92, expr: !DIExpression())
!92 = distinct !DIGlobalVariable(scope: null, file: !2, line: 390, type: !93, isLocal: true, isDefinition: true)
!93 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 72, elements: !40)
!94 = !DIGlobalVariableExpression(var: !95, expr: !DIExpression())
!95 = distinct !DIGlobalVariable(scope: null, file: !2, line: 404, type: !96, isLocal: true, isDefinition: true)
!96 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 296, elements: !97)
!97 = !{!98}
!98 = !DISubrange(count: 37)
!99 = !DIGlobalVariableExpression(var: !100, expr: !DIExpression())
!100 = distinct !DIGlobalVariable(name: "cond_mutex", scope: !61, file: !2, line: 199, type: !101, isLocal: false, isDefinition: true)
!101 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !102, line: 31, baseType: !103)
!102 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_mutex_t.h", directory: "")
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutex_t", file: !104, line: 113, baseType: !105)
!104 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!105 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutex_t", file: !104, line: 78, size: 512, elements: !106)
!106 = !{!107, !109}
!107 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !105, file: !104, line: 79, baseType: !108, size: 64)
!108 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !105, file: !104, line: 80, baseType: !110, size: 448, offset: 64)
!110 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 448, elements: !111)
!111 = !{!112}
!112 = !DISubrange(count: 56)
!113 = !DIGlobalVariableExpression(var: !114, expr: !DIExpression())
!114 = distinct !DIGlobalVariable(name: "cond", scope: !61, file: !2, line: 200, type: !115, isLocal: false, isDefinition: true)
!115 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_cond_t", file: !116, line: 31, baseType: !117)
!116 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_cond_t.h", directory: "")
!117 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_cond_t", file: !104, line: 110, baseType: !118)
!118 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_cond_t", file: !104, line: 68, size: 384, elements: !119)
!119 = !{!120, !121}
!120 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !118, file: !104, line: 69, baseType: !108, size: 64)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !118, file: !104, line: 70, baseType: !122, size: 320, offset: 64)
!122 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 320, elements: !123)
!123 = !{!124}
!124 = !DISubrange(count: 40)
!125 = !DIGlobalVariableExpression(var: !126, expr: !DIExpression())
!126 = distinct !DIGlobalVariable(name: "latest_thread", scope: !61, file: !2, line: 358, type: !127, isLocal: false, isDefinition: true)
!127 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !128, line: 31, baseType: !129)
!128 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!129 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !104, line: 118, baseType: !130)
!130 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !131, size: 64)
!131 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !104, line: 103, size: 65536, elements: !132)
!132 = !{!133, !134, !144}
!133 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !131, file: !104, line: 104, baseType: !108, size: 64)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !131, file: !104, line: 105, baseType: !135, size: 64, offset: 64)
!135 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !136, size: 64)
!136 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !104, line: 57, size: 192, elements: !137)
!137 = !{!138, !142, !143}
!138 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !136, file: !104, line: 58, baseType: !139, size: 64)
!139 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !140, size: 64)
!140 = !DISubroutineType(types: !141)
!141 = !{null, !63}
!142 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !136, file: !104, line: 59, baseType: !63, size: 64, offset: 64)
!143 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !136, file: !104, line: 60, baseType: !135, size: 64, offset: 128)
!144 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !131, file: !104, line: 106, baseType: !145, size: 65408, offset: 128)
!145 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 65408, elements: !146)
!146 = !{!147}
!147 = !DISubrange(count: 8176)
!148 = !DIGlobalVariableExpression(var: !149, expr: !DIExpression())
!149 = distinct !DIGlobalVariable(name: "local_data", scope: !61, file: !2, line: 359, type: !150, isLocal: false, isDefinition: true)
!150 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_key_t", file: !151, line: 31, baseType: !152)
!151 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_key_t.h", directory: "")
!152 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_key_t", file: !104, line: 112, baseType: !153)
!153 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!154 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!155 = !{i32 7, !"Dwarf Version", i32 4}
!156 = !{i32 2, !"Debug Info Version", i32 3}
!157 = !{i32 1, !"wchar_size", i32 4}
!158 = !{i32 7, !"PIC Level", i32 2}
!159 = !{i32 7, !"uwtable", i32 2}
!160 = !{i32 7, !"frame-pointer", i32 1}
!161 = !{!"Homebrew clang version 15.0.7"}
!162 = distinct !DISubprogram(name: "thread_create", scope: !2, file: !2, line: 13, type: !163, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!163 = !DISubroutineType(types: !164)
!164 = !{!127, !165, !63}
!165 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !166, size: 64)
!166 = !DISubroutineType(types: !167)
!167 = !{!63, !63}
!168 = !{}
!169 = !DILocalVariable(name: "runner", arg: 1, scope: !162, file: !2, line: 13, type: !165)
!170 = !DILocation(line: 13, column: 32, scope: !162)
!171 = !DILocalVariable(name: "data", arg: 2, scope: !162, file: !2, line: 13, type: !63)
!172 = !DILocation(line: 13, column: 54, scope: !162)
!173 = !DILocalVariable(name: "id", scope: !162, file: !2, line: 15, type: !127)
!174 = !DILocation(line: 15, column: 15, scope: !162)
!175 = !DILocalVariable(name: "attr", scope: !162, file: !2, line: 16, type: !176)
!176 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !177, line: 31, baseType: !178)
!177 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_attr_t.h", directory: "")
!178 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_attr_t", file: !104, line: 109, baseType: !179)
!179 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_attr_t", file: !104, line: 63, size: 512, elements: !180)
!180 = !{!181, !182}
!181 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !179, file: !104, line: 64, baseType: !108, size: 64)
!182 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !179, file: !104, line: 65, baseType: !110, size: 448, offset: 64)
!183 = !DILocation(line: 16, column: 20, scope: !162)
!184 = !DILocation(line: 17, column: 5, scope: !162)
!185 = !DILocalVariable(name: "status", scope: !162, file: !2, line: 18, type: !154)
!186 = !DILocation(line: 18, column: 9, scope: !162)
!187 = !DILocation(line: 18, column: 45, scope: !162)
!188 = !DILocation(line: 18, column: 53, scope: !162)
!189 = !DILocation(line: 18, column: 18, scope: !162)
!190 = !DILocation(line: 19, column: 5, scope: !162)
!191 = !DILocation(line: 20, column: 5, scope: !162)
!192 = !DILocation(line: 21, column: 12, scope: !162)
!193 = !DILocation(line: 21, column: 5, scope: !162)
!194 = distinct !DISubprogram(name: "thread_join", scope: !2, file: !2, line: 24, type: !195, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!195 = !DISubroutineType(types: !196)
!196 = !{!63, !127}
!197 = !DILocalVariable(name: "id", arg: 1, scope: !194, file: !2, line: 24, type: !127)
!198 = !DILocation(line: 24, column: 29, scope: !194)
!199 = !DILocalVariable(name: "result", scope: !194, file: !2, line: 26, type: !63)
!200 = !DILocation(line: 26, column: 11, scope: !194)
!201 = !DILocalVariable(name: "status", scope: !194, file: !2, line: 27, type: !154)
!202 = !DILocation(line: 27, column: 9, scope: !194)
!203 = !DILocation(line: 27, column: 31, scope: !194)
!204 = !DILocation(line: 27, column: 18, scope: !194)
!205 = !DILocation(line: 28, column: 5, scope: !194)
!206 = !DILocation(line: 29, column: 12, scope: !194)
!207 = !DILocation(line: 29, column: 5, scope: !194)
!208 = distinct !DISubprogram(name: "mutex_init", scope: !2, file: !2, line: 44, type: !209, scopeLine: 45, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!209 = !DISubroutineType(types: !210)
!210 = !{null, !211, !154, !154, !154, !154}
!211 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !101, size: 64)
!212 = !DILocalVariable(name: "lock", arg: 1, scope: !208, file: !2, line: 44, type: !211)
!213 = !DILocation(line: 44, column: 34, scope: !208)
!214 = !DILocalVariable(name: "type", arg: 2, scope: !208, file: !2, line: 44, type: !154)
!215 = !DILocation(line: 44, column: 44, scope: !208)
!216 = !DILocalVariable(name: "protocol", arg: 3, scope: !208, file: !2, line: 44, type: !154)
!217 = !DILocation(line: 44, column: 54, scope: !208)
!218 = !DILocalVariable(name: "policy", arg: 4, scope: !208, file: !2, line: 44, type: !154)
!219 = !DILocation(line: 44, column: 68, scope: !208)
!220 = !DILocalVariable(name: "prioceiling", arg: 5, scope: !208, file: !2, line: 44, type: !154)
!221 = !DILocation(line: 44, column: 80, scope: !208)
!222 = !DILocalVariable(name: "status", scope: !208, file: !2, line: 46, type: !154)
!223 = !DILocation(line: 46, column: 9, scope: !208)
!224 = !DILocalVariable(name: "value", scope: !208, file: !2, line: 47, type: !154)
!225 = !DILocation(line: 47, column: 9, scope: !208)
!226 = !DILocalVariable(name: "attributes", scope: !208, file: !2, line: 48, type: !227)
!227 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !228, line: 31, baseType: !229)
!228 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_mutexattr_t.h", directory: "")
!229 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutexattr_t", file: !104, line: 114, baseType: !230)
!230 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutexattr_t", file: !104, line: 83, size: 128, elements: !231)
!231 = !{!232, !233}
!232 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !230, file: !104, line: 84, baseType: !108, size: 64)
!233 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !230, file: !104, line: 85, baseType: !44, size: 64, offset: 64)
!234 = !DILocation(line: 48, column: 25, scope: !208)
!235 = !DILocation(line: 49, column: 14, scope: !208)
!236 = !DILocation(line: 49, column: 12, scope: !208)
!237 = !DILocation(line: 50, column: 5, scope: !208)
!238 = !DILocation(line: 52, column: 53, scope: !208)
!239 = !DILocation(line: 52, column: 14, scope: !208)
!240 = !DILocation(line: 52, column: 12, scope: !208)
!241 = !DILocation(line: 53, column: 5, scope: !208)
!242 = !DILocation(line: 54, column: 14, scope: !208)
!243 = !DILocation(line: 54, column: 12, scope: !208)
!244 = !DILocation(line: 55, column: 5, scope: !208)
!245 = !DILocation(line: 57, column: 57, scope: !208)
!246 = !DILocation(line: 57, column: 14, scope: !208)
!247 = !DILocation(line: 57, column: 12, scope: !208)
!248 = !DILocation(line: 58, column: 5, scope: !208)
!249 = !DILocation(line: 59, column: 14, scope: !208)
!250 = !DILocation(line: 59, column: 12, scope: !208)
!251 = !DILocation(line: 60, column: 5, scope: !208)
!252 = !DILocation(line: 62, column: 58, scope: !208)
!253 = !DILocation(line: 62, column: 14, scope: !208)
!254 = !DILocation(line: 62, column: 12, scope: !208)
!255 = !DILocation(line: 63, column: 5, scope: !208)
!256 = !DILocation(line: 64, column: 14, scope: !208)
!257 = !DILocation(line: 64, column: 12, scope: !208)
!258 = !DILocation(line: 65, column: 5, scope: !208)
!259 = !DILocation(line: 67, column: 60, scope: !208)
!260 = !DILocation(line: 67, column: 14, scope: !208)
!261 = !DILocation(line: 67, column: 12, scope: !208)
!262 = !DILocation(line: 68, column: 5, scope: !208)
!263 = !DILocation(line: 69, column: 14, scope: !208)
!264 = !DILocation(line: 69, column: 12, scope: !208)
!265 = !DILocation(line: 70, column: 5, scope: !208)
!266 = !DILocation(line: 72, column: 33, scope: !208)
!267 = !DILocation(line: 72, column: 14, scope: !208)
!268 = !DILocation(line: 72, column: 12, scope: !208)
!269 = !DILocation(line: 73, column: 5, scope: !208)
!270 = !DILocation(line: 74, column: 14, scope: !208)
!271 = !DILocation(line: 74, column: 12, scope: !208)
!272 = !DILocation(line: 75, column: 5, scope: !208)
!273 = !DILocation(line: 76, column: 1, scope: !208)
!274 = distinct !DISubprogram(name: "mutex_destroy", scope: !2, file: !2, line: 78, type: !275, scopeLine: 79, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!275 = !DISubroutineType(types: !276)
!276 = !{null, !211}
!277 = !DILocalVariable(name: "lock", arg: 1, scope: !274, file: !2, line: 78, type: !211)
!278 = !DILocation(line: 78, column: 37, scope: !274)
!279 = !DILocalVariable(name: "status", scope: !274, file: !2, line: 80, type: !154)
!280 = !DILocation(line: 80, column: 9, scope: !274)
!281 = !DILocation(line: 80, column: 40, scope: !274)
!282 = !DILocation(line: 80, column: 18, scope: !274)
!283 = !DILocation(line: 81, column: 5, scope: !274)
!284 = !DILocation(line: 82, column: 1, scope: !274)
!285 = distinct !DISubprogram(name: "mutex_lock", scope: !2, file: !2, line: 84, type: !275, scopeLine: 85, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!286 = !DILocalVariable(name: "lock", arg: 1, scope: !285, file: !2, line: 84, type: !211)
!287 = !DILocation(line: 84, column: 34, scope: !285)
!288 = !DILocalVariable(name: "status", scope: !285, file: !2, line: 86, type: !154)
!289 = !DILocation(line: 86, column: 9, scope: !285)
!290 = !DILocation(line: 86, column: 37, scope: !285)
!291 = !DILocation(line: 86, column: 18, scope: !285)
!292 = !DILocation(line: 87, column: 5, scope: !285)
!293 = !DILocation(line: 88, column: 1, scope: !285)
!294 = distinct !DISubprogram(name: "mutex_trylock", scope: !2, file: !2, line: 90, type: !295, scopeLine: 91, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!295 = !DISubroutineType(types: !296)
!296 = !{!297, !211}
!297 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!298 = !DILocalVariable(name: "lock", arg: 1, scope: !294, file: !2, line: 90, type: !211)
!299 = !DILocation(line: 90, column: 37, scope: !294)
!300 = !DILocalVariable(name: "status", scope: !294, file: !2, line: 92, type: !154)
!301 = !DILocation(line: 92, column: 9, scope: !294)
!302 = !DILocation(line: 92, column: 40, scope: !294)
!303 = !DILocation(line: 92, column: 18, scope: !294)
!304 = !DILocation(line: 94, column: 12, scope: !294)
!305 = !DILocation(line: 94, column: 19, scope: !294)
!306 = !DILocation(line: 94, column: 5, scope: !294)
!307 = distinct !DISubprogram(name: "mutex_unlock", scope: !2, file: !2, line: 97, type: !275, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!308 = !DILocalVariable(name: "lock", arg: 1, scope: !307, file: !2, line: 97, type: !211)
!309 = !DILocation(line: 97, column: 36, scope: !307)
!310 = !DILocalVariable(name: "status", scope: !307, file: !2, line: 99, type: !154)
!311 = !DILocation(line: 99, column: 9, scope: !307)
!312 = !DILocation(line: 99, column: 39, scope: !307)
!313 = !DILocation(line: 99, column: 18, scope: !307)
!314 = !DILocation(line: 100, column: 5, scope: !307)
!315 = !DILocation(line: 101, column: 1, scope: !307)
!316 = distinct !DISubprogram(name: "mutex_test", scope: !2, file: !2, line: 103, type: !317, scopeLine: 104, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!317 = !DISubroutineType(types: !318)
!318 = !{null}
!319 = !DILocalVariable(name: "mutex0", scope: !316, file: !2, line: 105, type: !101)
!320 = !DILocation(line: 105, column: 21, scope: !316)
!321 = !DILocalVariable(name: "mutex1", scope: !316, file: !2, line: 106, type: !101)
!322 = !DILocation(line: 106, column: 21, scope: !316)
!323 = !DILocation(line: 108, column: 5, scope: !316)
!324 = !DILocation(line: 109, column: 5, scope: !316)
!325 = !DILocation(line: 112, column: 9, scope: !326)
!326 = distinct !DILexicalBlock(scope: !316, file: !2, line: 111, column: 5)
!327 = !DILocalVariable(name: "success", scope: !326, file: !2, line: 113, type: !297)
!328 = !DILocation(line: 113, column: 14, scope: !326)
!329 = !DILocation(line: 113, column: 24, scope: !326)
!330 = !DILocation(line: 114, column: 9, scope: !326)
!331 = !DILocation(line: 115, column: 9, scope: !326)
!332 = !DILocation(line: 119, column: 9, scope: !333)
!333 = distinct !DILexicalBlock(scope: !316, file: !2, line: 118, column: 5)
!334 = !DILocalVariable(name: "success", scope: !335, file: !2, line: 122, type: !297)
!335 = distinct !DILexicalBlock(scope: !333, file: !2, line: 121, column: 9)
!336 = !DILocation(line: 122, column: 18, scope: !335)
!337 = !DILocation(line: 122, column: 28, scope: !335)
!338 = !DILocation(line: 123, column: 13, scope: !335)
!339 = !DILocation(line: 124, column: 13, scope: !335)
!340 = !DILocalVariable(name: "success", scope: !341, file: !2, line: 128, type: !297)
!341 = distinct !DILexicalBlock(scope: !333, file: !2, line: 127, column: 9)
!342 = !DILocation(line: 128, column: 18, scope: !341)
!343 = !DILocation(line: 128, column: 28, scope: !341)
!344 = !DILocation(line: 129, column: 13, scope: !341)
!345 = !DILocation(line: 130, column: 13, scope: !341)
!346 = !DILocation(line: 140, column: 9, scope: !333)
!347 = !DILocation(line: 143, column: 5, scope: !316)
!348 = !DILocation(line: 144, column: 5, scope: !316)
!349 = !DILocation(line: 145, column: 1, scope: !316)
!350 = distinct !DISubprogram(name: "cond_init", scope: !2, file: !2, line: 149, type: !351, scopeLine: 150, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!351 = !DISubroutineType(types: !352)
!352 = !{null, !353}
!353 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !115, size: 64)
!354 = !DILocalVariable(name: "cond", arg: 1, scope: !350, file: !2, line: 149, type: !353)
!355 = !DILocation(line: 149, column: 32, scope: !350)
!356 = !DILocalVariable(name: "status", scope: !350, file: !2, line: 151, type: !154)
!357 = !DILocation(line: 151, column: 9, scope: !350)
!358 = !DILocalVariable(name: "attr", scope: !350, file: !2, line: 152, type: !359)
!359 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_condattr_t", file: !360, line: 31, baseType: !361)
!360 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_condattr_t.h", directory: "")
!361 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_condattr_t", file: !104, line: 111, baseType: !362)
!362 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_condattr_t", file: !104, line: 73, size: 128, elements: !363)
!363 = !{!364, !365}
!364 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !362, file: !104, line: 74, baseType: !108, size: 64)
!365 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !362, file: !104, line: 75, baseType: !44, size: 64, offset: 64)
!366 = !DILocation(line: 152, column: 24, scope: !350)
!367 = !DILocation(line: 154, column: 14, scope: !350)
!368 = !DILocation(line: 154, column: 12, scope: !350)
!369 = !DILocation(line: 155, column: 5, scope: !350)
!370 = !DILocation(line: 157, column: 32, scope: !350)
!371 = !DILocation(line: 157, column: 14, scope: !350)
!372 = !DILocation(line: 157, column: 12, scope: !350)
!373 = !DILocation(line: 158, column: 5, scope: !350)
!374 = !DILocation(line: 160, column: 14, scope: !350)
!375 = !DILocation(line: 160, column: 12, scope: !350)
!376 = !DILocation(line: 161, column: 5, scope: !350)
!377 = !DILocation(line: 162, column: 1, scope: !350)
!378 = distinct !DISubprogram(name: "cond_destroy", scope: !2, file: !2, line: 164, type: !351, scopeLine: 165, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!379 = !DILocalVariable(name: "cond", arg: 1, scope: !378, file: !2, line: 164, type: !353)
!380 = !DILocation(line: 164, column: 35, scope: !378)
!381 = !DILocalVariable(name: "status", scope: !378, file: !2, line: 166, type: !154)
!382 = !DILocation(line: 166, column: 9, scope: !378)
!383 = !DILocation(line: 166, column: 39, scope: !378)
!384 = !DILocation(line: 166, column: 18, scope: !378)
!385 = !DILocation(line: 167, column: 5, scope: !378)
!386 = !DILocation(line: 168, column: 1, scope: !378)
!387 = distinct !DISubprogram(name: "cond_signal", scope: !2, file: !2, line: 170, type: !351, scopeLine: 171, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!388 = !DILocalVariable(name: "cond", arg: 1, scope: !387, file: !2, line: 170, type: !353)
!389 = !DILocation(line: 170, column: 34, scope: !387)
!390 = !DILocalVariable(name: "status", scope: !387, file: !2, line: 172, type: !154)
!391 = !DILocation(line: 172, column: 9, scope: !387)
!392 = !DILocation(line: 172, column: 38, scope: !387)
!393 = !DILocation(line: 172, column: 18, scope: !387)
!394 = !DILocation(line: 173, column: 5, scope: !387)
!395 = !DILocation(line: 174, column: 1, scope: !387)
!396 = distinct !DISubprogram(name: "cond_broadcast", scope: !2, file: !2, line: 176, type: !351, scopeLine: 177, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!397 = !DILocalVariable(name: "cond", arg: 1, scope: !396, file: !2, line: 176, type: !353)
!398 = !DILocation(line: 176, column: 37, scope: !396)
!399 = !DILocalVariable(name: "status", scope: !396, file: !2, line: 178, type: !154)
!400 = !DILocation(line: 178, column: 9, scope: !396)
!401 = !DILocation(line: 178, column: 41, scope: !396)
!402 = !DILocation(line: 178, column: 18, scope: !396)
!403 = !DILocation(line: 179, column: 5, scope: !396)
!404 = !DILocation(line: 180, column: 1, scope: !396)
!405 = distinct !DISubprogram(name: "cond_wait", scope: !2, file: !2, line: 182, type: !406, scopeLine: 183, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!406 = !DISubroutineType(types: !407)
!407 = !{null, !353, !211}
!408 = !DILocalVariable(name: "cond", arg: 1, scope: !405, file: !2, line: 182, type: !353)
!409 = !DILocation(line: 182, column: 32, scope: !405)
!410 = !DILocalVariable(name: "lock", arg: 2, scope: !405, file: !2, line: 182, type: !211)
!411 = !DILocation(line: 182, column: 55, scope: !405)
!412 = !DILocalVariable(name: "status", scope: !405, file: !2, line: 184, type: !154)
!413 = !DILocation(line: 184, column: 9, scope: !405)
!414 = !DILocation(line: 184, column: 36, scope: !405)
!415 = !DILocation(line: 184, column: 42, scope: !405)
!416 = !DILocation(line: 184, column: 18, scope: !405)
!417 = !DILocation(line: 186, column: 1, scope: !405)
!418 = distinct !DISubprogram(name: "cond_timedwait", scope: !2, file: !2, line: 188, type: !419, scopeLine: 189, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!419 = !DISubroutineType(types: !420)
!420 = !{null, !353, !211, !421}
!421 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!422 = !DILocalVariable(name: "cond", arg: 1, scope: !418, file: !2, line: 188, type: !353)
!423 = !DILocation(line: 188, column: 37, scope: !418)
!424 = !DILocalVariable(name: "lock", arg: 2, scope: !418, file: !2, line: 188, type: !211)
!425 = !DILocation(line: 188, column: 60, scope: !418)
!426 = !DILocalVariable(name: "millis", arg: 3, scope: !418, file: !2, line: 188, type: !421)
!427 = !DILocation(line: 188, column: 76, scope: !418)
!428 = !DILocalVariable(name: "ts", scope: !418, file: !2, line: 191, type: !429)
!429 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !430, line: 33, size: 128, elements: !431)
!430 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_types/_timespec.h", directory: "")
!431 = !{!432, !435}
!432 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !429, file: !430, line: 35, baseType: !433, size: 64)
!433 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_time_t", file: !434, line: 98, baseType: !108)
!434 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/arm/_types.h", directory: "")
!435 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !429, file: !430, line: 36, baseType: !108, size: 64, offset: 64)
!436 = !DILocation(line: 191, column: 21, scope: !418)
!437 = !DILocation(line: 195, column: 11, scope: !418)
!438 = !DILocalVariable(name: "status", scope: !418, file: !2, line: 196, type: !154)
!439 = !DILocation(line: 196, column: 9, scope: !418)
!440 = !DILocation(line: 196, column: 41, scope: !418)
!441 = !DILocation(line: 196, column: 47, scope: !418)
!442 = !DILocation(line: 196, column: 18, scope: !418)
!443 = !DILocation(line: 197, column: 1, scope: !418)
!444 = distinct !DISubprogram(name: "cond_worker", scope: !2, file: !2, line: 203, type: !166, scopeLine: 204, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!445 = !DILocalVariable(name: "message", arg: 1, scope: !444, file: !2, line: 203, type: !63)
!446 = !DILocation(line: 203, column: 25, scope: !444)
!447 = !DILocalVariable(name: "idle", scope: !448, file: !2, line: 205, type: !297)
!448 = distinct !DILexicalBlock(scope: !444, file: !2, line: 205, column: 5)
!449 = !DILocation(line: 205, column: 15, scope: !448)
!450 = !DILocation(line: 205, column: 10, scope: !448)
!451 = !DILocation(line: 205, column: 28, scope: !452)
!452 = distinct !DILexicalBlock(scope: !448, file: !2, line: 205, column: 5)
!453 = !DILocation(line: 205, column: 5, scope: !448)
!454 = !DILocation(line: 207, column: 9, scope: !455)
!455 = distinct !DILexicalBlock(scope: !452, file: !2, line: 206, column: 5)
!456 = !DILocation(line: 208, column: 9, scope: !455)
!457 = !DILocation(line: 209, column: 16, scope: !455)
!458 = !DILocation(line: 209, column: 22, scope: !455)
!459 = !DILocation(line: 209, column: 14, scope: !455)
!460 = !DILocation(line: 210, column: 9, scope: !455)
!461 = !DILocation(line: 205, column: 5, scope: !452)
!462 = distinct !{!462, !453, !463, !464}
!463 = !DILocation(line: 211, column: 5, scope: !448)
!464 = !{!"llvm.loop.mustprogress"}
!465 = !DILocalVariable(name: "idle", scope: !466, file: !2, line: 212, type: !297)
!466 = distinct !DILexicalBlock(scope: !444, file: !2, line: 212, column: 5)
!467 = !DILocation(line: 212, column: 15, scope: !466)
!468 = !DILocation(line: 212, column: 10, scope: !466)
!469 = !DILocation(line: 212, column: 28, scope: !470)
!470 = distinct !DILexicalBlock(scope: !466, file: !2, line: 212, column: 5)
!471 = !DILocation(line: 212, column: 5, scope: !466)
!472 = !DILocation(line: 214, column: 9, scope: !473)
!473 = distinct !DILexicalBlock(scope: !470, file: !2, line: 213, column: 5)
!474 = !DILocation(line: 215, column: 9, scope: !473)
!475 = !DILocation(line: 216, column: 16, scope: !473)
!476 = !DILocation(line: 216, column: 22, scope: !473)
!477 = !DILocation(line: 216, column: 14, scope: !473)
!478 = !DILocation(line: 217, column: 9, scope: !473)
!479 = !DILocation(line: 212, column: 5, scope: !470)
!480 = distinct !{!480, !471, !481, !464}
!481 = !DILocation(line: 218, column: 5, scope: !466)
!482 = !DILocation(line: 219, column: 12, scope: !444)
!483 = !DILocation(line: 219, column: 5, scope: !444)
!484 = distinct !DISubprogram(name: "cond_test", scope: !2, file: !2, line: 222, type: !317, scopeLine: 223, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!485 = !DILocalVariable(name: "message", scope: !484, file: !2, line: 224, type: !63)
!486 = !DILocation(line: 224, column: 11, scope: !484)
!487 = !DILocation(line: 225, column: 5, scope: !484)
!488 = !DILocation(line: 226, column: 5, scope: !484)
!489 = !DILocalVariable(name: "worker", scope: !484, file: !2, line: 228, type: !127)
!490 = !DILocation(line: 228, column: 15, scope: !484)
!491 = !DILocation(line: 228, column: 51, scope: !484)
!492 = !DILocation(line: 228, column: 24, scope: !484)
!493 = !DILocation(line: 231, column: 9, scope: !494)
!494 = distinct !DILexicalBlock(scope: !484, file: !2, line: 230, column: 5)
!495 = !DILocation(line: 232, column: 9, scope: !494)
!496 = !DILocation(line: 233, column: 9, scope: !494)
!497 = !DILocation(line: 234, column: 9, scope: !494)
!498 = !DILocation(line: 238, column: 9, scope: !499)
!499 = distinct !DILexicalBlock(scope: !484, file: !2, line: 237, column: 5)
!500 = !DILocation(line: 239, column: 9, scope: !499)
!501 = !DILocation(line: 240, column: 9, scope: !499)
!502 = !DILocation(line: 241, column: 9, scope: !499)
!503 = !DILocalVariable(name: "result", scope: !484, file: !2, line: 244, type: !63)
!504 = !DILocation(line: 244, column: 11, scope: !484)
!505 = !DILocation(line: 244, column: 32, scope: !484)
!506 = !DILocation(line: 244, column: 20, scope: !484)
!507 = !DILocation(line: 245, column: 5, scope: !484)
!508 = !DILocation(line: 247, column: 5, scope: !484)
!509 = !DILocation(line: 248, column: 5, scope: !484)
!510 = !DILocation(line: 249, column: 1, scope: !484)
!511 = distinct !DISubprogram(name: "rwlock_init", scope: !2, file: !2, line: 256, type: !512, scopeLine: 257, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!512 = !DISubroutineType(types: !513)
!513 = !{null, !514, !154}
!514 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !515, size: 64)
!515 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlock_t", file: !516, line: 31, baseType: !517)
!516 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_rwlock_t.h", directory: "")
!517 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_rwlock_t", file: !104, line: 116, baseType: !518)
!518 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_rwlock_t", file: !104, line: 93, size: 1600, elements: !519)
!519 = !{!520, !521}
!520 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !518, file: !104, line: 94, baseType: !108, size: 64)
!521 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !518, file: !104, line: 95, baseType: !522, size: 1536, offset: 64)
!522 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 1536, elements: !523)
!523 = !{!524}
!524 = !DISubrange(count: 192)
!525 = !DILocalVariable(name: "lock", arg: 1, scope: !511, file: !2, line: 256, type: !514)
!526 = !DILocation(line: 256, column: 36, scope: !511)
!527 = !DILocalVariable(name: "shared", arg: 2, scope: !511, file: !2, line: 256, type: !154)
!528 = !DILocation(line: 256, column: 46, scope: !511)
!529 = !DILocalVariable(name: "status", scope: !511, file: !2, line: 258, type: !154)
!530 = !DILocation(line: 258, column: 9, scope: !511)
!531 = !DILocalVariable(name: "value", scope: !511, file: !2, line: 259, type: !154)
!532 = !DILocation(line: 259, column: 9, scope: !511)
!533 = !DILocalVariable(name: "attributes", scope: !511, file: !2, line: 260, type: !534)
!534 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlockattr_t", file: !535, line: 31, baseType: !536)
!535 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_rwlockattr_t.h", directory: "")
!536 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_rwlockattr_t", file: !104, line: 117, baseType: !537)
!537 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_rwlockattr_t", file: !104, line: 98, size: 192, elements: !538)
!538 = !{!539, !540}
!539 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !537, file: !104, line: 99, baseType: !108, size: 64)
!540 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !537, file: !104, line: 100, baseType: !541, size: 128, offset: 64)
!541 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 128, elements: !542)
!542 = !{!543}
!543 = !DISubrange(count: 16)
!544 = !DILocation(line: 260, column: 26, scope: !511)
!545 = !DILocation(line: 261, column: 14, scope: !511)
!546 = !DILocation(line: 261, column: 12, scope: !511)
!547 = !DILocation(line: 262, column: 5, scope: !511)
!548 = !DILocation(line: 264, column: 57, scope: !511)
!549 = !DILocation(line: 264, column: 14, scope: !511)
!550 = !DILocation(line: 264, column: 12, scope: !511)
!551 = !DILocation(line: 265, column: 5, scope: !511)
!552 = !DILocation(line: 266, column: 14, scope: !511)
!553 = !DILocation(line: 266, column: 12, scope: !511)
!554 = !DILocation(line: 267, column: 5, scope: !511)
!555 = !DILocation(line: 269, column: 34, scope: !511)
!556 = !DILocation(line: 269, column: 14, scope: !511)
!557 = !DILocation(line: 269, column: 12, scope: !511)
!558 = !DILocation(line: 270, column: 5, scope: !511)
!559 = !DILocation(line: 271, column: 14, scope: !511)
!560 = !DILocation(line: 271, column: 12, scope: !511)
!561 = !DILocation(line: 272, column: 5, scope: !511)
!562 = !DILocation(line: 273, column: 1, scope: !511)
!563 = distinct !DISubprogram(name: "rwlock_destroy", scope: !2, file: !2, line: 275, type: !564, scopeLine: 276, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!564 = !DISubroutineType(types: !565)
!565 = !{null, !514}
!566 = !DILocalVariable(name: "lock", arg: 1, scope: !563, file: !2, line: 275, type: !514)
!567 = !DILocation(line: 275, column: 39, scope: !563)
!568 = !DILocalVariable(name: "status", scope: !563, file: !2, line: 277, type: !154)
!569 = !DILocation(line: 277, column: 9, scope: !563)
!570 = !DILocation(line: 277, column: 41, scope: !563)
!571 = !DILocation(line: 277, column: 18, scope: !563)
!572 = !DILocation(line: 278, column: 5, scope: !563)
!573 = !DILocation(line: 279, column: 1, scope: !563)
!574 = distinct !DISubprogram(name: "rwlock_wrlock", scope: !2, file: !2, line: 281, type: !564, scopeLine: 282, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!575 = !DILocalVariable(name: "lock", arg: 1, scope: !574, file: !2, line: 281, type: !514)
!576 = !DILocation(line: 281, column: 38, scope: !574)
!577 = !DILocalVariable(name: "status", scope: !574, file: !2, line: 283, type: !154)
!578 = !DILocation(line: 283, column: 9, scope: !574)
!579 = !DILocation(line: 283, column: 40, scope: !574)
!580 = !DILocation(line: 283, column: 18, scope: !574)
!581 = !DILocation(line: 284, column: 5, scope: !574)
!582 = !DILocation(line: 285, column: 1, scope: !574)
!583 = distinct !DISubprogram(name: "rwlock_trywrlock", scope: !2, file: !2, line: 287, type: !584, scopeLine: 288, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!584 = !DISubroutineType(types: !585)
!585 = !{!297, !514}
!586 = !DILocalVariable(name: "lock", arg: 1, scope: !583, file: !2, line: 287, type: !514)
!587 = !DILocation(line: 287, column: 41, scope: !583)
!588 = !DILocalVariable(name: "status", scope: !583, file: !2, line: 289, type: !154)
!589 = !DILocation(line: 289, column: 9, scope: !583)
!590 = !DILocation(line: 289, column: 43, scope: !583)
!591 = !DILocation(line: 289, column: 18, scope: !583)
!592 = !DILocation(line: 291, column: 12, scope: !583)
!593 = !DILocation(line: 291, column: 19, scope: !583)
!594 = !DILocation(line: 291, column: 5, scope: !583)
!595 = distinct !DISubprogram(name: "rwlock_rdlock", scope: !2, file: !2, line: 294, type: !564, scopeLine: 295, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!596 = !DILocalVariable(name: "lock", arg: 1, scope: !595, file: !2, line: 294, type: !514)
!597 = !DILocation(line: 294, column: 38, scope: !595)
!598 = !DILocalVariable(name: "status", scope: !595, file: !2, line: 296, type: !154)
!599 = !DILocation(line: 296, column: 9, scope: !595)
!600 = !DILocation(line: 296, column: 40, scope: !595)
!601 = !DILocation(line: 296, column: 18, scope: !595)
!602 = !DILocation(line: 297, column: 5, scope: !595)
!603 = !DILocation(line: 298, column: 1, scope: !595)
!604 = distinct !DISubprogram(name: "rwlock_tryrdlock", scope: !2, file: !2, line: 300, type: !584, scopeLine: 301, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!605 = !DILocalVariable(name: "lock", arg: 1, scope: !604, file: !2, line: 300, type: !514)
!606 = !DILocation(line: 300, column: 41, scope: !604)
!607 = !DILocalVariable(name: "status", scope: !604, file: !2, line: 302, type: !154)
!608 = !DILocation(line: 302, column: 9, scope: !604)
!609 = !DILocation(line: 302, column: 43, scope: !604)
!610 = !DILocation(line: 302, column: 18, scope: !604)
!611 = !DILocation(line: 304, column: 12, scope: !604)
!612 = !DILocation(line: 304, column: 19, scope: !604)
!613 = !DILocation(line: 304, column: 5, scope: !604)
!614 = distinct !DISubprogram(name: "rwlock_unlock", scope: !2, file: !2, line: 307, type: !564, scopeLine: 308, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!615 = !DILocalVariable(name: "lock", arg: 1, scope: !614, file: !2, line: 307, type: !514)
!616 = !DILocation(line: 307, column: 38, scope: !614)
!617 = !DILocalVariable(name: "status", scope: !614, file: !2, line: 309, type: !154)
!618 = !DILocation(line: 309, column: 9, scope: !614)
!619 = !DILocation(line: 309, column: 40, scope: !614)
!620 = !DILocation(line: 309, column: 18, scope: !614)
!621 = !DILocation(line: 310, column: 5, scope: !614)
!622 = !DILocation(line: 311, column: 1, scope: !614)
!623 = distinct !DISubprogram(name: "rwlock_test", scope: !2, file: !2, line: 313, type: !317, scopeLine: 314, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!624 = !DILocalVariable(name: "lock", scope: !623, file: !2, line: 315, type: !515)
!625 = !DILocation(line: 315, column: 22, scope: !623)
!626 = !DILocation(line: 316, column: 5, scope: !623)
!627 = !DILocalVariable(name: "test_depth", scope: !623, file: !2, line: 317, type: !628)
!628 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !154)
!629 = !DILocation(line: 317, column: 15, scope: !623)
!630 = !DILocation(line: 320, column: 9, scope: !631)
!631 = distinct !DILexicalBlock(scope: !623, file: !2, line: 319, column: 5)
!632 = !DILocalVariable(name: "success", scope: !631, file: !2, line: 321, type: !297)
!633 = !DILocation(line: 321, column: 14, scope: !631)
!634 = !DILocation(line: 321, column: 24, scope: !631)
!635 = !DILocation(line: 322, column: 9, scope: !631)
!636 = !DILocation(line: 323, column: 19, scope: !631)
!637 = !DILocation(line: 323, column: 17, scope: !631)
!638 = !DILocation(line: 324, column: 9, scope: !631)
!639 = !DILocation(line: 325, column: 9, scope: !631)
!640 = !DILocation(line: 329, column: 9, scope: !641)
!641 = distinct !DILexicalBlock(scope: !623, file: !2, line: 328, column: 5)
!642 = !DILocalVariable(name: "i", scope: !643, file: !2, line: 330, type: !154)
!643 = distinct !DILexicalBlock(scope: !641, file: !2, line: 330, column: 9)
!644 = !DILocation(line: 330, column: 18, scope: !643)
!645 = !DILocation(line: 330, column: 14, scope: !643)
!646 = !DILocation(line: 330, column: 25, scope: !647)
!647 = distinct !DILexicalBlock(scope: !643, file: !2, line: 330, column: 9)
!648 = !DILocation(line: 330, column: 27, scope: !647)
!649 = !DILocation(line: 330, column: 9, scope: !643)
!650 = !DILocalVariable(name: "success", scope: !651, file: !2, line: 332, type: !297)
!651 = distinct !DILexicalBlock(scope: !647, file: !2, line: 331, column: 9)
!652 = !DILocation(line: 332, column: 18, scope: !651)
!653 = !DILocation(line: 332, column: 28, scope: !651)
!654 = !DILocation(line: 333, column: 13, scope: !651)
!655 = !DILocation(line: 334, column: 9, scope: !651)
!656 = !DILocation(line: 330, column: 42, scope: !647)
!657 = !DILocation(line: 330, column: 9, scope: !647)
!658 = distinct !{!658, !649, !659, !464}
!659 = !DILocation(line: 334, column: 9, scope: !643)
!660 = !DILocalVariable(name: "success", scope: !661, file: !2, line: 337, type: !297)
!661 = distinct !DILexicalBlock(scope: !641, file: !2, line: 336, column: 9)
!662 = !DILocation(line: 337, column: 18, scope: !661)
!663 = !DILocation(line: 337, column: 28, scope: !661)
!664 = !DILocation(line: 338, column: 13, scope: !661)
!665 = !DILocation(line: 341, column: 9, scope: !641)
!666 = !DILocalVariable(name: "i", scope: !667, file: !2, line: 342, type: !154)
!667 = distinct !DILexicalBlock(scope: !641, file: !2, line: 342, column: 9)
!668 = !DILocation(line: 342, column: 18, scope: !667)
!669 = !DILocation(line: 342, column: 14, scope: !667)
!670 = !DILocation(line: 342, column: 25, scope: !671)
!671 = distinct !DILexicalBlock(scope: !667, file: !2, line: 342, column: 9)
!672 = !DILocation(line: 342, column: 27, scope: !671)
!673 = !DILocation(line: 342, column: 9, scope: !667)
!674 = !DILocation(line: 343, column: 13, scope: !675)
!675 = distinct !DILexicalBlock(scope: !671, file: !2, line: 342, column: 46)
!676 = !DILocation(line: 344, column: 9, scope: !675)
!677 = !DILocation(line: 342, column: 42, scope: !671)
!678 = !DILocation(line: 342, column: 9, scope: !671)
!679 = distinct !{!679, !673, !680, !464}
!680 = !DILocation(line: 344, column: 9, scope: !667)
!681 = !DILocation(line: 348, column: 9, scope: !682)
!682 = distinct !DILexicalBlock(scope: !623, file: !2, line: 347, column: 5)
!683 = !DILocalVariable(name: "success", scope: !682, file: !2, line: 349, type: !297)
!684 = !DILocation(line: 349, column: 14, scope: !682)
!685 = !DILocation(line: 349, column: 24, scope: !682)
!686 = !DILocation(line: 350, column: 9, scope: !682)
!687 = !DILocation(line: 353, column: 5, scope: !623)
!688 = !DILocation(line: 354, column: 1, scope: !623)
!689 = distinct !DISubprogram(name: "key_destroy", scope: !2, file: !2, line: 361, type: !140, scopeLine: 362, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!690 = !DILocalVariable(name: "unused_value", arg: 1, scope: !689, file: !2, line: 361, type: !63)
!691 = !DILocation(line: 361, column: 24, scope: !689)
!692 = !DILocation(line: 363, column: 21, scope: !689)
!693 = !DILocation(line: 363, column: 19, scope: !689)
!694 = !DILocation(line: 364, column: 1, scope: !689)
!695 = distinct !DISubprogram(name: "key_worker", scope: !2, file: !2, line: 366, type: !166, scopeLine: 367, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!696 = !DILocalVariable(name: "message", arg: 1, scope: !695, file: !2, line: 366, type: !63)
!697 = !DILocation(line: 366, column: 24, scope: !695)
!698 = !DILocalVariable(name: "my_secret", scope: !695, file: !2, line: 368, type: !154)
!699 = !DILocation(line: 368, column: 9, scope: !695)
!700 = !DILocalVariable(name: "status", scope: !695, file: !2, line: 370, type: !154)
!701 = !DILocation(line: 370, column: 9, scope: !695)
!702 = !DILocation(line: 370, column: 38, scope: !695)
!703 = !DILocation(line: 370, column: 18, scope: !695)
!704 = !DILocation(line: 371, column: 5, scope: !695)
!705 = !DILocalVariable(name: "my_local_data", scope: !695, file: !2, line: 373, type: !63)
!706 = !DILocation(line: 373, column: 11, scope: !695)
!707 = !DILocation(line: 373, column: 47, scope: !695)
!708 = !DILocation(line: 373, column: 27, scope: !695)
!709 = !DILocation(line: 374, column: 5, scope: !695)
!710 = !DILocation(line: 376, column: 12, scope: !695)
!711 = !DILocation(line: 376, column: 5, scope: !695)
!712 = distinct !DISubprogram(name: "key_test", scope: !2, file: !2, line: 379, type: !317, scopeLine: 380, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!713 = !DILocalVariable(name: "my_secret", scope: !712, file: !2, line: 381, type: !154)
!714 = !DILocation(line: 381, column: 9, scope: !712)
!715 = !DILocalVariable(name: "message", scope: !712, file: !2, line: 382, type: !63)
!716 = !DILocation(line: 382, column: 11, scope: !712)
!717 = !DILocalVariable(name: "status", scope: !712, file: !2, line: 383, type: !154)
!718 = !DILocation(line: 383, column: 9, scope: !712)
!719 = !DILocation(line: 385, column: 5, scope: !712)
!720 = !DILocalVariable(name: "worker", scope: !712, file: !2, line: 387, type: !127)
!721 = !DILocation(line: 387, column: 15, scope: !712)
!722 = !DILocation(line: 387, column: 50, scope: !712)
!723 = !DILocation(line: 387, column: 24, scope: !712)
!724 = !DILocation(line: 389, column: 34, scope: !712)
!725 = !DILocation(line: 389, column: 14, scope: !712)
!726 = !DILocation(line: 389, column: 12, scope: !712)
!727 = !DILocation(line: 390, column: 5, scope: !712)
!728 = !DILocalVariable(name: "my_local_data", scope: !712, file: !2, line: 392, type: !63)
!729 = !DILocation(line: 392, column: 11, scope: !712)
!730 = !DILocation(line: 392, column: 47, scope: !712)
!731 = !DILocation(line: 392, column: 27, scope: !712)
!732 = !DILocation(line: 393, column: 5, scope: !712)
!733 = !DILocation(line: 395, column: 34, scope: !712)
!734 = !DILocation(line: 395, column: 14, scope: !712)
!735 = !DILocation(line: 395, column: 12, scope: !712)
!736 = !DILocation(line: 396, column: 5, scope: !712)
!737 = !DILocalVariable(name: "result", scope: !712, file: !2, line: 398, type: !63)
!738 = !DILocation(line: 398, column: 11, scope: !712)
!739 = !DILocation(line: 398, column: 32, scope: !712)
!740 = !DILocation(line: 398, column: 20, scope: !712)
!741 = !DILocation(line: 399, column: 5, scope: !712)
!742 = !DILocation(line: 401, column: 33, scope: !712)
!743 = !DILocation(line: 401, column: 14, scope: !712)
!744 = !DILocation(line: 401, column: 12, scope: !712)
!745 = !DILocation(line: 402, column: 5, scope: !712)
!746 = !DILocation(line: 404, column: 5, scope: !712)
!747 = !DILocation(line: 405, column: 1, scope: !712)
!748 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 407, type: !749, scopeLine: 408, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !168)
!749 = !DISubroutineType(types: !750)
!750 = !{!154}
!751 = !DILocation(line: 409, column: 5, scope: !748)
!752 = !DILocation(line: 410, column: 5, scope: !748)
!753 = !DILocation(line: 411, column: 5, scope: !748)
!754 = !DILocation(line: 412, column: 5, scope: !748)
!755 = !DILocation(line: 413, column: 1, scope: !748)
