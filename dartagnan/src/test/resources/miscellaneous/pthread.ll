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
@cond_mutex = global %struct._opaque_pthread_mutex_t zeroinitializer, align 8, !dbg !88
@cond = global %struct._opaque_pthread_cond_t zeroinitializer, align 8, !dbg !102
@__func__.rwlock_init = private unnamed_addr constant [12 x i8] c"rwlock_init\00", align 1, !dbg !66
@__func__.rwlock_destroy = private unnamed_addr constant [15 x i8] c"rwlock_destroy\00", align 1, !dbg !68
@__func__.rwlock_wrlock = private unnamed_addr constant [14 x i8] c"rwlock_wrlock\00", align 1, !dbg !70
@__func__.rwlock_rdlock = private unnamed_addr constant [14 x i8] c"rwlock_rdlock\00", align 1, !dbg !72
@__func__.rwlock_unlock = private unnamed_addr constant [14 x i8] c"rwlock_unlock\00", align 1, !dbg !74
@__func__.rwlock_test = private unnamed_addr constant [12 x i8] c"rwlock_test\00", align 1, !dbg !76
@latest_thread = global ptr null, align 8, !dbg !114
@local_data = global i64 0, align 8, !dbg !137
@__func__.key_worker = private unnamed_addr constant [11 x i8] c"key_worker\00", align 1, !dbg !78
@.str.4 = private unnamed_addr constant [28 x i8] c"my_local_data == &my_secret\00", align 1, !dbg !80
@__func__.key_test = private unnamed_addr constant [9 x i8] c"key_test\00", align 1, !dbg !85

; Function Attrs: noinline nounwind ssp uwtable
define ptr @thread_create(ptr noundef %0, ptr noundef %1) #0 !dbg !151 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca %struct._opaque_pthread_attr_t, align 8
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !158, metadata !DIExpression()), !dbg !159
  store ptr %1, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !160, metadata !DIExpression()), !dbg !161
  call void @llvm.dbg.declare(metadata ptr %5, metadata !162, metadata !DIExpression()), !dbg !163
  call void @llvm.dbg.declare(metadata ptr %6, metadata !164, metadata !DIExpression()), !dbg !172
  %8 = call i32 @pthread_attr_init(ptr noundef %6), !dbg !173
  call void @llvm.dbg.declare(metadata ptr %7, metadata !174, metadata !DIExpression()), !dbg !175
  %9 = load ptr, ptr %3, align 8, !dbg !176
  %10 = load ptr, ptr %4, align 8, !dbg !177
  %11 = call i32 @pthread_create(ptr noundef %5, ptr noundef %6, ptr noundef %9, ptr noundef %10), !dbg !178
  store i32 %11, ptr %7, align 4, !dbg !175
  %12 = load i32, ptr %7, align 4, !dbg !179
  %13 = icmp eq i32 %12, 0, !dbg !179
  %14 = xor i1 %13, true, !dbg !179
  %15 = zext i1 %14 to i32, !dbg !179
  %16 = sext i32 %15 to i64, !dbg !179
  %17 = icmp ne i64 %16, 0, !dbg !179
  br i1 %17, label %18, label %20, !dbg !179

18:                                               ; preds = %2
  call void @__assert_rtn(ptr noundef @__func__.thread_create, ptr noundef @.str, i32 noundef 18, ptr noundef @.str.1) #4, !dbg !179
  unreachable, !dbg !179

19:                                               ; No predecessors!
  br label %21, !dbg !179

20:                                               ; preds = %2
  br label %21, !dbg !179

21:                                               ; preds = %20, %19
  %22 = call i32 @pthread_attr_destroy(ptr noundef %6), !dbg !180
  %23 = load ptr, ptr %5, align 8, !dbg !181
  ret ptr %23, !dbg !182
}

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @pthread_attr_init(ptr noundef) #2

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

declare i32 @pthread_attr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define ptr @thread_join(ptr noundef %0) #0 !dbg !183 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !186, metadata !DIExpression()), !dbg !187
  call void @llvm.dbg.declare(metadata ptr %3, metadata !188, metadata !DIExpression()), !dbg !189
  call void @llvm.dbg.declare(metadata ptr %4, metadata !190, metadata !DIExpression()), !dbg !191
  %5 = load ptr, ptr %2, align 8, !dbg !192
  %6 = call i32 @"\01_pthread_join"(ptr noundef %5, ptr noundef %3), !dbg !193
  store i32 %6, ptr %4, align 4, !dbg !191
  %7 = load i32, ptr %4, align 4, !dbg !194
  %8 = icmp eq i32 %7, 0, !dbg !194
  %9 = xor i1 %8, true, !dbg !194
  %10 = zext i1 %9 to i32, !dbg !194
  %11 = sext i32 %10 to i64, !dbg !194
  %12 = icmp ne i64 %11, 0, !dbg !194
  br i1 %12, label %13, label %15, !dbg !194

13:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.thread_join, ptr noundef @.str, i32 noundef 27, ptr noundef @.str.1) #4, !dbg !194
  unreachable, !dbg !194

14:                                               ; No predecessors!
  br label %16, !dbg !194

15:                                               ; preds = %1
  br label %16, !dbg !194

16:                                               ; preds = %15, %14
  %17 = load ptr, ptr %3, align 8, !dbg !195
  ret ptr %17, !dbg !196
}

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_init(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) #0 !dbg !197 {
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca %struct._opaque_pthread_mutexattr_t, align 8
  store ptr %0, ptr %6, align 8
  call void @llvm.dbg.declare(metadata ptr %6, metadata !201, metadata !DIExpression()), !dbg !202
  store i32 %1, ptr %7, align 4
  call void @llvm.dbg.declare(metadata ptr %7, metadata !203, metadata !DIExpression()), !dbg !204
  store i32 %2, ptr %8, align 4
  call void @llvm.dbg.declare(metadata ptr %8, metadata !205, metadata !DIExpression()), !dbg !206
  store i32 %3, ptr %9, align 4
  call void @llvm.dbg.declare(metadata ptr %9, metadata !207, metadata !DIExpression()), !dbg !208
  store i32 %4, ptr %10, align 4
  call void @llvm.dbg.declare(metadata ptr %10, metadata !209, metadata !DIExpression()), !dbg !210
  call void @llvm.dbg.declare(metadata ptr %11, metadata !211, metadata !DIExpression()), !dbg !212
  call void @llvm.dbg.declare(metadata ptr %12, metadata !213, metadata !DIExpression()), !dbg !214
  call void @llvm.dbg.declare(metadata ptr %13, metadata !215, metadata !DIExpression()), !dbg !223
  %14 = call i32 @pthread_mutexattr_init(ptr noundef %13), !dbg !224
  store i32 %14, ptr %11, align 4, !dbg !225
  %15 = load i32, ptr %11, align 4, !dbg !226
  %16 = icmp eq i32 %15, 0, !dbg !226
  %17 = xor i1 %16, true, !dbg !226
  %18 = zext i1 %17 to i32, !dbg !226
  %19 = sext i32 %18 to i64, !dbg !226
  %20 = icmp ne i64 %19, 0, !dbg !226
  br i1 %20, label %21, label %23, !dbg !226

21:                                               ; preds = %5
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 49, ptr noundef @.str.1) #4, !dbg !226
  unreachable, !dbg !226

22:                                               ; No predecessors!
  br label %24, !dbg !226

23:                                               ; preds = %5
  br label %24, !dbg !226

24:                                               ; preds = %23, %22
  %25 = load i32, ptr %7, align 4, !dbg !227
  %26 = call i32 @pthread_mutexattr_settype(ptr noundef %13, i32 noundef %25), !dbg !228
  store i32 %26, ptr %11, align 4, !dbg !229
  %27 = load i32, ptr %11, align 4, !dbg !230
  %28 = icmp eq i32 %27, 0, !dbg !230
  %29 = xor i1 %28, true, !dbg !230
  %30 = zext i1 %29 to i32, !dbg !230
  %31 = sext i32 %30 to i64, !dbg !230
  %32 = icmp ne i64 %31, 0, !dbg !230
  br i1 %32, label %33, label %35, !dbg !230

33:                                               ; preds = %24
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 52, ptr noundef @.str.1) #4, !dbg !230
  unreachable, !dbg !230

34:                                               ; No predecessors!
  br label %36, !dbg !230

35:                                               ; preds = %24
  br label %36, !dbg !230

36:                                               ; preds = %35, %34
  %37 = call i32 @pthread_mutexattr_gettype(ptr noundef %13, ptr noundef %12), !dbg !231
  store i32 %37, ptr %11, align 4, !dbg !232
  %38 = load i32, ptr %11, align 4, !dbg !233
  %39 = icmp eq i32 %38, 0, !dbg !233
  %40 = xor i1 %39, true, !dbg !233
  %41 = zext i1 %40 to i32, !dbg !233
  %42 = sext i32 %41 to i64, !dbg !233
  %43 = icmp ne i64 %42, 0, !dbg !233
  br i1 %43, label %44, label %46, !dbg !233

44:                                               ; preds = %36
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 54, ptr noundef @.str.1) #4, !dbg !233
  unreachable, !dbg !233

45:                                               ; No predecessors!
  br label %47, !dbg !233

46:                                               ; preds = %36
  br label %47, !dbg !233

47:                                               ; preds = %46, %45
  %48 = load i32, ptr %8, align 4, !dbg !234
  %49 = call i32 @pthread_mutexattr_setprotocol(ptr noundef %13, i32 noundef %48), !dbg !235
  store i32 %49, ptr %11, align 4, !dbg !236
  %50 = load i32, ptr %11, align 4, !dbg !237
  %51 = icmp eq i32 %50, 0, !dbg !237
  %52 = xor i1 %51, true, !dbg !237
  %53 = zext i1 %52 to i32, !dbg !237
  %54 = sext i32 %53 to i64, !dbg !237
  %55 = icmp ne i64 %54, 0, !dbg !237
  br i1 %55, label %56, label %58, !dbg !237

56:                                               ; preds = %47
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 57, ptr noundef @.str.1) #4, !dbg !237
  unreachable, !dbg !237

57:                                               ; No predecessors!
  br label %59, !dbg !237

58:                                               ; preds = %47
  br label %59, !dbg !237

59:                                               ; preds = %58, %57
  %60 = call i32 @pthread_mutexattr_getprotocol(ptr noundef %13, ptr noundef %12), !dbg !238
  store i32 %60, ptr %11, align 4, !dbg !239
  %61 = load i32, ptr %11, align 4, !dbg !240
  %62 = icmp eq i32 %61, 0, !dbg !240
  %63 = xor i1 %62, true, !dbg !240
  %64 = zext i1 %63 to i32, !dbg !240
  %65 = sext i32 %64 to i64, !dbg !240
  %66 = icmp ne i64 %65, 0, !dbg !240
  br i1 %66, label %67, label %69, !dbg !240

67:                                               ; preds = %59
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 59, ptr noundef @.str.1) #4, !dbg !240
  unreachable, !dbg !240

68:                                               ; No predecessors!
  br label %70, !dbg !240

69:                                               ; preds = %59
  br label %70, !dbg !240

70:                                               ; preds = %69, %68
  %71 = load i32, ptr %9, align 4, !dbg !241
  %72 = call i32 @pthread_mutexattr_setpolicy_np(ptr noundef %13, i32 noundef %71), !dbg !242
  store i32 %72, ptr %11, align 4, !dbg !243
  %73 = load i32, ptr %11, align 4, !dbg !244
  %74 = icmp eq i32 %73, 0, !dbg !244
  %75 = xor i1 %74, true, !dbg !244
  %76 = zext i1 %75 to i32, !dbg !244
  %77 = sext i32 %76 to i64, !dbg !244
  %78 = icmp ne i64 %77, 0, !dbg !244
  br i1 %78, label %79, label %81, !dbg !244

79:                                               ; preds = %70
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 62, ptr noundef @.str.1) #4, !dbg !244
  unreachable, !dbg !244

80:                                               ; No predecessors!
  br label %82, !dbg !244

81:                                               ; preds = %70
  br label %82, !dbg !244

82:                                               ; preds = %81, %80
  %83 = call i32 @pthread_mutexattr_getpolicy_np(ptr noundef %13, ptr noundef %12), !dbg !245
  store i32 %83, ptr %11, align 4, !dbg !246
  %84 = load i32, ptr %11, align 4, !dbg !247
  %85 = icmp eq i32 %84, 0, !dbg !247
  %86 = xor i1 %85, true, !dbg !247
  %87 = zext i1 %86 to i32, !dbg !247
  %88 = sext i32 %87 to i64, !dbg !247
  %89 = icmp ne i64 %88, 0, !dbg !247
  br i1 %89, label %90, label %92, !dbg !247

90:                                               ; preds = %82
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 64, ptr noundef @.str.1) #4, !dbg !247
  unreachable, !dbg !247

91:                                               ; No predecessors!
  br label %93, !dbg !247

92:                                               ; preds = %82
  br label %93, !dbg !247

93:                                               ; preds = %92, %91
  %94 = load i32, ptr %10, align 4, !dbg !248
  %95 = call i32 @pthread_mutexattr_setprioceiling(ptr noundef %13, i32 noundef %94), !dbg !249
  store i32 %95, ptr %11, align 4, !dbg !250
  %96 = load i32, ptr %11, align 4, !dbg !251
  %97 = icmp eq i32 %96, 0, !dbg !251
  %98 = xor i1 %97, true, !dbg !251
  %99 = zext i1 %98 to i32, !dbg !251
  %100 = sext i32 %99 to i64, !dbg !251
  %101 = icmp ne i64 %100, 0, !dbg !251
  br i1 %101, label %102, label %104, !dbg !251

102:                                              ; preds = %93
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 67, ptr noundef @.str.1) #4, !dbg !251
  unreachable, !dbg !251

103:                                              ; No predecessors!
  br label %105, !dbg !251

104:                                              ; preds = %93
  br label %105, !dbg !251

105:                                              ; preds = %104, %103
  %106 = call i32 @pthread_mutexattr_getprioceiling(ptr noundef %13, ptr noundef %12), !dbg !252
  store i32 %106, ptr %11, align 4, !dbg !253
  %107 = load i32, ptr %11, align 4, !dbg !254
  %108 = icmp eq i32 %107, 0, !dbg !254
  %109 = xor i1 %108, true, !dbg !254
  %110 = zext i1 %109 to i32, !dbg !254
  %111 = sext i32 %110 to i64, !dbg !254
  %112 = icmp ne i64 %111, 0, !dbg !254
  br i1 %112, label %113, label %115, !dbg !254

113:                                              ; preds = %105
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 69, ptr noundef @.str.1) #4, !dbg !254
  unreachable, !dbg !254

114:                                              ; No predecessors!
  br label %116, !dbg !254

115:                                              ; preds = %105
  br label %116, !dbg !254

116:                                              ; preds = %115, %114
  %117 = load ptr, ptr %6, align 8, !dbg !255
  %118 = call i32 @pthread_mutex_init(ptr noundef %117, ptr noundef %13), !dbg !256
  store i32 %118, ptr %11, align 4, !dbg !257
  %119 = load i32, ptr %11, align 4, !dbg !258
  %120 = icmp eq i32 %119, 0, !dbg !258
  %121 = xor i1 %120, true, !dbg !258
  %122 = zext i1 %121 to i32, !dbg !258
  %123 = sext i32 %122 to i64, !dbg !258
  %124 = icmp ne i64 %123, 0, !dbg !258
  br i1 %124, label %125, label %127, !dbg !258

125:                                              ; preds = %116
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 72, ptr noundef @.str.1) #4, !dbg !258
  unreachable, !dbg !258

126:                                              ; No predecessors!
  br label %128, !dbg !258

127:                                              ; preds = %116
  br label %128, !dbg !258

128:                                              ; preds = %127, %126
  %129 = call i32 @"\01_pthread_mutexattr_destroy"(ptr noundef %13), !dbg !259
  store i32 %129, ptr %11, align 4, !dbg !260
  %130 = load i32, ptr %11, align 4, !dbg !261
  %131 = icmp eq i32 %130, 0, !dbg !261
  %132 = xor i1 %131, true, !dbg !261
  %133 = zext i1 %132 to i32, !dbg !261
  %134 = sext i32 %133 to i64, !dbg !261
  %135 = icmp ne i64 %134, 0, !dbg !261
  br i1 %135, label %136, label %138, !dbg !261

136:                                              ; preds = %128
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 74, ptr noundef @.str.1) #4, !dbg !261
  unreachable, !dbg !261

137:                                              ; No predecessors!
  br label %139, !dbg !261

138:                                              ; preds = %128
  br label %139, !dbg !261

139:                                              ; preds = %138, %137
  ret void, !dbg !262
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
define void @mutex_destroy(ptr noundef %0) #0 !dbg !263 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !266, metadata !DIExpression()), !dbg !267
  call void @llvm.dbg.declare(metadata ptr %3, metadata !268, metadata !DIExpression()), !dbg !269
  %4 = load ptr, ptr %2, align 8, !dbg !270
  %5 = call i32 @pthread_mutex_destroy(ptr noundef %4), !dbg !271
  store i32 %5, ptr %3, align 4, !dbg !269
  %6 = load i32, ptr %3, align 4, !dbg !272
  %7 = icmp eq i32 %6, 0, !dbg !272
  %8 = xor i1 %7, true, !dbg !272
  %9 = zext i1 %8 to i32, !dbg !272
  %10 = sext i32 %9 to i64, !dbg !272
  %11 = icmp ne i64 %10, 0, !dbg !272
  br i1 %11, label %12, label %14, !dbg !272

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_destroy, ptr noundef @.str, i32 noundef 80, ptr noundef @.str.1) #4, !dbg !272
  unreachable, !dbg !272

13:                                               ; No predecessors!
  br label %15, !dbg !272

14:                                               ; preds = %1
  br label %15, !dbg !272

15:                                               ; preds = %14, %13
  ret void, !dbg !273
}

declare i32 @pthread_mutex_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_lock(ptr noundef %0) #0 !dbg !274 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !275, metadata !DIExpression()), !dbg !276
  call void @llvm.dbg.declare(metadata ptr %3, metadata !277, metadata !DIExpression()), !dbg !278
  %4 = load ptr, ptr %2, align 8, !dbg !279
  %5 = call i32 @pthread_mutex_lock(ptr noundef %4), !dbg !280
  store i32 %5, ptr %3, align 4, !dbg !278
  %6 = load i32, ptr %3, align 4, !dbg !281
  %7 = icmp eq i32 %6, 0, !dbg !281
  %8 = xor i1 %7, true, !dbg !281
  %9 = zext i1 %8 to i32, !dbg !281
  %10 = sext i32 %9 to i64, !dbg !281
  %11 = icmp ne i64 %10, 0, !dbg !281
  br i1 %11, label %12, label %14, !dbg !281

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_lock, ptr noundef @.str, i32 noundef 86, ptr noundef @.str.1) #4, !dbg !281
  unreachable, !dbg !281

13:                                               ; No predecessors!
  br label %15, !dbg !281

14:                                               ; preds = %1
  br label %15, !dbg !281

15:                                               ; preds = %14, %13
  ret void, !dbg !282
}

declare i32 @pthread_mutex_lock(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define zeroext i1 @mutex_trylock(ptr noundef %0) #0 !dbg !283 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !287, metadata !DIExpression()), !dbg !288
  call void @llvm.dbg.declare(metadata ptr %3, metadata !289, metadata !DIExpression()), !dbg !290
  %4 = load ptr, ptr %2, align 8, !dbg !291
  %5 = call i32 @pthread_mutex_trylock(ptr noundef %4), !dbg !292
  store i32 %5, ptr %3, align 4, !dbg !290
  %6 = load i32, ptr %3, align 4, !dbg !293
  %7 = icmp eq i32 %6, 0, !dbg !294
  ret i1 %7, !dbg !295
}

declare i32 @pthread_mutex_trylock(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_unlock(ptr noundef %0) #0 !dbg !296 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !297, metadata !DIExpression()), !dbg !298
  call void @llvm.dbg.declare(metadata ptr %3, metadata !299, metadata !DIExpression()), !dbg !300
  %4 = load ptr, ptr %2, align 8, !dbg !301
  %5 = call i32 @pthread_mutex_unlock(ptr noundef %4), !dbg !302
  store i32 %5, ptr %3, align 4, !dbg !300
  %6 = load i32, ptr %3, align 4, !dbg !303
  %7 = icmp eq i32 %6, 0, !dbg !303
  %8 = xor i1 %7, true, !dbg !303
  %9 = zext i1 %8 to i32, !dbg !303
  %10 = sext i32 %9 to i64, !dbg !303
  %11 = icmp ne i64 %10, 0, !dbg !303
  br i1 %11, label %12, label %14, !dbg !303

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_unlock, ptr noundef @.str, i32 noundef 99, ptr noundef @.str.1) #4, !dbg !303
  unreachable, !dbg !303

13:                                               ; No predecessors!
  br label %15, !dbg !303

14:                                               ; preds = %1
  br label %15, !dbg !303

15:                                               ; preds = %14, %13
  ret void, !dbg !304
}

declare i32 @pthread_mutex_unlock(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_test() #0 !dbg !305 {
  %1 = alloca %struct._opaque_pthread_mutex_t, align 8
  %2 = alloca %struct._opaque_pthread_mutex_t, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  %5 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata ptr %1, metadata !308, metadata !DIExpression()), !dbg !309
  call void @llvm.dbg.declare(metadata ptr %2, metadata !310, metadata !DIExpression()), !dbg !311
  call void @mutex_init(ptr noundef %1, i32 noundef 1, i32 noundef 1, i32 noundef 1, i32 noundef 1), !dbg !312
  call void @mutex_init(ptr noundef %2, i32 noundef 2, i32 noundef 2, i32 noundef 3, i32 noundef 2), !dbg !313
  call void @mutex_lock(ptr noundef %1), !dbg !314
  call void @llvm.dbg.declare(metadata ptr %3, metadata !316, metadata !DIExpression()), !dbg !317
  %6 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !318
  %7 = zext i1 %6 to i8, !dbg !317
  store i8 %7, ptr %3, align 1, !dbg !317
  %8 = load i8, ptr %3, align 1, !dbg !319
  %9 = trunc i8 %8 to i1, !dbg !319
  %10 = xor i1 %9, true, !dbg !319
  %11 = xor i1 %10, true, !dbg !319
  %12 = zext i1 %11 to i32, !dbg !319
  %13 = sext i32 %12 to i64, !dbg !319
  %14 = icmp ne i64 %13, 0, !dbg !319
  br i1 %14, label %15, label %17, !dbg !319

15:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 113, ptr noundef @.str.2) #4, !dbg !319
  unreachable, !dbg !319

16:                                               ; No predecessors!
  br label %18, !dbg !319

17:                                               ; preds = %0
  br label %18, !dbg !319

18:                                               ; preds = %17, %16
  call void @mutex_unlock(ptr noundef %1), !dbg !320
  call void @mutex_lock(ptr noundef %2), !dbg !321
  call void @llvm.dbg.declare(metadata ptr %4, metadata !323, metadata !DIExpression()), !dbg !325
  %19 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !326
  %20 = zext i1 %19 to i8, !dbg !325
  store i8 %20, ptr %4, align 1, !dbg !325
  %21 = load i8, ptr %4, align 1, !dbg !327
  %22 = trunc i8 %21 to i1, !dbg !327
  %23 = xor i1 %22, true, !dbg !327
  %24 = zext i1 %23 to i32, !dbg !327
  %25 = sext i32 %24 to i64, !dbg !327
  %26 = icmp ne i64 %25, 0, !dbg !327
  br i1 %26, label %27, label %29, !dbg !327

27:                                               ; preds = %18
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 122, ptr noundef @.str.3) #4, !dbg !327
  unreachable, !dbg !327

28:                                               ; No predecessors!
  br label %30, !dbg !327

29:                                               ; preds = %18
  br label %30, !dbg !327

30:                                               ; preds = %29, %28
  call void @mutex_unlock(ptr noundef %1), !dbg !328
  call void @llvm.dbg.declare(metadata ptr %5, metadata !329, metadata !DIExpression()), !dbg !331
  %31 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !332
  %32 = zext i1 %31 to i8, !dbg !331
  store i8 %32, ptr %5, align 1, !dbg !331
  %33 = load i8, ptr %5, align 1, !dbg !333
  %34 = trunc i8 %33 to i1, !dbg !333
  %35 = xor i1 %34, true, !dbg !333
  %36 = zext i1 %35 to i32, !dbg !333
  %37 = sext i32 %36 to i64, !dbg !333
  %38 = icmp ne i64 %37, 0, !dbg !333
  br i1 %38, label %39, label %41, !dbg !333

39:                                               ; preds = %30
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 128, ptr noundef @.str.3) #4, !dbg !333
  unreachable, !dbg !333

40:                                               ; No predecessors!
  br label %42, !dbg !333

41:                                               ; preds = %30
  br label %42, !dbg !333

42:                                               ; preds = %41, %40
  call void @mutex_unlock(ptr noundef %1), !dbg !334
  call void @mutex_unlock(ptr noundef %2), !dbg !335
  call void @mutex_destroy(ptr noundef %2), !dbg !336
  call void @mutex_destroy(ptr noundef %1), !dbg !337
  ret void, !dbg !338
}

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_init(ptr noundef %0) #0 !dbg !339 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca %struct._opaque_pthread_condattr_t, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !343, metadata !DIExpression()), !dbg !344
  call void @llvm.dbg.declare(metadata ptr %3, metadata !345, metadata !DIExpression()), !dbg !346
  call void @llvm.dbg.declare(metadata ptr %4, metadata !347, metadata !DIExpression()), !dbg !355
  %5 = call i32 @pthread_condattr_init(ptr noundef %4), !dbg !356
  store i32 %5, ptr %3, align 4, !dbg !357
  %6 = load i32, ptr %3, align 4, !dbg !358
  %7 = icmp eq i32 %6, 0, !dbg !358
  %8 = xor i1 %7, true, !dbg !358
  %9 = zext i1 %8 to i32, !dbg !358
  %10 = sext i32 %9 to i64, !dbg !358
  %11 = icmp ne i64 %10, 0, !dbg !358
  br i1 %11, label %12, label %14, !dbg !358

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 154, ptr noundef @.str.1) #4, !dbg !358
  unreachable, !dbg !358

13:                                               ; No predecessors!
  br label %15, !dbg !358

14:                                               ; preds = %1
  br label %15, !dbg !358

15:                                               ; preds = %14, %13
  %16 = load ptr, ptr %2, align 8, !dbg !359
  %17 = call i32 @"\01_pthread_cond_init"(ptr noundef %16, ptr noundef %4), !dbg !360
  store i32 %17, ptr %3, align 4, !dbg !361
  %18 = load i32, ptr %3, align 4, !dbg !362
  %19 = icmp eq i32 %18, 0, !dbg !362
  %20 = xor i1 %19, true, !dbg !362
  %21 = zext i1 %20 to i32, !dbg !362
  %22 = sext i32 %21 to i64, !dbg !362
  %23 = icmp ne i64 %22, 0, !dbg !362
  br i1 %23, label %24, label %26, !dbg !362

24:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 157, ptr noundef @.str.1) #4, !dbg !362
  unreachable, !dbg !362

25:                                               ; No predecessors!
  br label %27, !dbg !362

26:                                               ; preds = %15
  br label %27, !dbg !362

27:                                               ; preds = %26, %25
  %28 = call i32 @pthread_condattr_destroy(ptr noundef %4), !dbg !363
  store i32 %28, ptr %3, align 4, !dbg !364
  %29 = load i32, ptr %3, align 4, !dbg !365
  %30 = icmp eq i32 %29, 0, !dbg !365
  %31 = xor i1 %30, true, !dbg !365
  %32 = zext i1 %31 to i32, !dbg !365
  %33 = sext i32 %32 to i64, !dbg !365
  %34 = icmp ne i64 %33, 0, !dbg !365
  br i1 %34, label %35, label %37, !dbg !365

35:                                               ; preds = %27
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 160, ptr noundef @.str.1) #4, !dbg !365
  unreachable, !dbg !365

36:                                               ; No predecessors!
  br label %38, !dbg !365

37:                                               ; preds = %27
  br label %38, !dbg !365

38:                                               ; preds = %37, %36
  ret void, !dbg !366
}

declare i32 @pthread_condattr_init(ptr noundef) #2

declare i32 @"\01_pthread_cond_init"(ptr noundef, ptr noundef) #2

declare i32 @pthread_condattr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_destroy(ptr noundef %0) #0 !dbg !367 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !368, metadata !DIExpression()), !dbg !369
  call void @llvm.dbg.declare(metadata ptr %3, metadata !370, metadata !DIExpression()), !dbg !371
  %4 = load ptr, ptr %2, align 8, !dbg !372
  %5 = call i32 @pthread_cond_destroy(ptr noundef %4), !dbg !373
  store i32 %5, ptr %3, align 4, !dbg !371
  %6 = load i32, ptr %3, align 4, !dbg !374
  %7 = icmp eq i32 %6, 0, !dbg !374
  %8 = xor i1 %7, true, !dbg !374
  %9 = zext i1 %8 to i32, !dbg !374
  %10 = sext i32 %9 to i64, !dbg !374
  %11 = icmp ne i64 %10, 0, !dbg !374
  br i1 %11, label %12, label %14, !dbg !374

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_destroy, ptr noundef @.str, i32 noundef 166, ptr noundef @.str.1) #4, !dbg !374
  unreachable, !dbg !374

13:                                               ; No predecessors!
  br label %15, !dbg !374

14:                                               ; preds = %1
  br label %15, !dbg !374

15:                                               ; preds = %14, %13
  ret void, !dbg !375
}

declare i32 @pthread_cond_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_signal(ptr noundef %0) #0 !dbg !376 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !377, metadata !DIExpression()), !dbg !378
  call void @llvm.dbg.declare(metadata ptr %3, metadata !379, metadata !DIExpression()), !dbg !380
  %4 = load ptr, ptr %2, align 8, !dbg !381
  %5 = call i32 @pthread_cond_signal(ptr noundef %4), !dbg !382
  store i32 %5, ptr %3, align 4, !dbg !380
  %6 = load i32, ptr %3, align 4, !dbg !383
  %7 = icmp eq i32 %6, 0, !dbg !383
  %8 = xor i1 %7, true, !dbg !383
  %9 = zext i1 %8 to i32, !dbg !383
  %10 = sext i32 %9 to i64, !dbg !383
  %11 = icmp ne i64 %10, 0, !dbg !383
  br i1 %11, label %12, label %14, !dbg !383

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_signal, ptr noundef @.str, i32 noundef 172, ptr noundef @.str.1) #4, !dbg !383
  unreachable, !dbg !383

13:                                               ; No predecessors!
  br label %15, !dbg !383

14:                                               ; preds = %1
  br label %15, !dbg !383

15:                                               ; preds = %14, %13
  ret void, !dbg !384
}

declare i32 @pthread_cond_signal(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_broadcast(ptr noundef %0) #0 !dbg !385 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !386, metadata !DIExpression()), !dbg !387
  call void @llvm.dbg.declare(metadata ptr %3, metadata !388, metadata !DIExpression()), !dbg !389
  %4 = load ptr, ptr %2, align 8, !dbg !390
  %5 = call i32 @pthread_cond_broadcast(ptr noundef %4), !dbg !391
  store i32 %5, ptr %3, align 4, !dbg !389
  %6 = load i32, ptr %3, align 4, !dbg !392
  %7 = icmp eq i32 %6, 0, !dbg !392
  %8 = xor i1 %7, true, !dbg !392
  %9 = zext i1 %8 to i32, !dbg !392
  %10 = sext i32 %9 to i64, !dbg !392
  %11 = icmp ne i64 %10, 0, !dbg !392
  br i1 %11, label %12, label %14, !dbg !392

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_broadcast, ptr noundef @.str, i32 noundef 178, ptr noundef @.str.1) #4, !dbg !392
  unreachable, !dbg !392

13:                                               ; No predecessors!
  br label %15, !dbg !392

14:                                               ; preds = %1
  br label %15, !dbg !392

15:                                               ; preds = %14, %13
  ret void, !dbg !393
}

declare i32 @pthread_cond_broadcast(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_wait(ptr noundef %0, ptr noundef %1) #0 !dbg !394 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !397, metadata !DIExpression()), !dbg !398
  store ptr %1, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !399, metadata !DIExpression()), !dbg !400
  call void @llvm.dbg.declare(metadata ptr %5, metadata !401, metadata !DIExpression()), !dbg !402
  %6 = load ptr, ptr %3, align 8, !dbg !403
  %7 = load ptr, ptr %4, align 8, !dbg !404
  %8 = call i32 @"\01_pthread_cond_wait"(ptr noundef %6, ptr noundef %7), !dbg !405
  store i32 %8, ptr %5, align 4, !dbg !402
  ret void, !dbg !406
}

declare i32 @"\01_pthread_cond_wait"(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_timedwait(ptr noundef %0, ptr noundef %1, i64 noundef %2) #0 !dbg !407 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i64, align 8
  %7 = alloca %struct.timespec, align 8
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !411, metadata !DIExpression()), !dbg !412
  store ptr %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !413, metadata !DIExpression()), !dbg !414
  store i64 %2, ptr %6, align 8
  call void @llvm.dbg.declare(metadata ptr %6, metadata !415, metadata !DIExpression()), !dbg !416
  call void @llvm.dbg.declare(metadata ptr %7, metadata !417, metadata !DIExpression()), !dbg !425
  %9 = load i64, ptr %6, align 8, !dbg !426
  call void @llvm.dbg.declare(metadata ptr %8, metadata !427, metadata !DIExpression()), !dbg !428
  %10 = load ptr, ptr %4, align 8, !dbg !429
  %11 = load ptr, ptr %5, align 8, !dbg !430
  %12 = call i32 @"\01_pthread_cond_timedwait"(ptr noundef %10, ptr noundef %11, ptr noundef %7), !dbg !431
  store i32 %12, ptr %8, align 4, !dbg !428
  ret void, !dbg !432
}

declare i32 @"\01_pthread_cond_timedwait"(ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define ptr @cond_worker(ptr noundef %0) #0 !dbg !433 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i8, align 1
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !434, metadata !DIExpression()), !dbg !435
  call void @llvm.dbg.declare(metadata ptr %4, metadata !436, metadata !DIExpression()), !dbg !437
  store i8 1, ptr %4, align 1, !dbg !437
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !438
  %5 = load i32, ptr @phase, align 4, !dbg !440
  %6 = add nsw i32 %5, 1, !dbg !440
  store i32 %6, ptr @phase, align 4, !dbg !440
  call void @cond_wait(ptr noundef @cond, ptr noundef @cond_mutex), !dbg !441
  %7 = load i32, ptr @phase, align 4, !dbg !442
  %8 = add nsw i32 %7, 1, !dbg !442
  store i32 %8, ptr @phase, align 4, !dbg !442
  %9 = load i32, ptr @phase, align 4, !dbg !443
  %10 = icmp slt i32 %9, 2, !dbg !444
  %11 = zext i1 %10 to i8, !dbg !445
  store i8 %11, ptr %4, align 1, !dbg !445
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !446
  %12 = load i8, ptr %4, align 1, !dbg !447
  %13 = trunc i8 %12 to i1, !dbg !447
  br i1 %13, label %14, label %17, !dbg !449

14:                                               ; preds = %1
  %15 = load ptr, ptr %3, align 8, !dbg !450
  %16 = getelementptr inbounds i8, ptr %15, i64 1, !dbg !451
  store ptr %16, ptr %2, align 8, !dbg !452
  br label %32, !dbg !452

17:                                               ; preds = %1
  store i8 1, ptr %4, align 1, !dbg !453
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !454
  %18 = load i32, ptr @phase, align 4, !dbg !456
  %19 = add nsw i32 %18, 1, !dbg !456
  store i32 %19, ptr @phase, align 4, !dbg !456
  call void @cond_timedwait(ptr noundef @cond, ptr noundef @cond_mutex, i64 noundef 10), !dbg !457
  %20 = load i32, ptr @phase, align 4, !dbg !458
  %21 = add nsw i32 %20, 1, !dbg !458
  store i32 %21, ptr @phase, align 4, !dbg !458
  %22 = load i32, ptr @phase, align 4, !dbg !459
  %23 = icmp sgt i32 %22, 6, !dbg !460
  %24 = zext i1 %23 to i8, !dbg !461
  store i8 %24, ptr %4, align 1, !dbg !461
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !462
  %25 = load i8, ptr %4, align 1, !dbg !463
  %26 = trunc i8 %25 to i1, !dbg !463
  br i1 %26, label %27, label %30, !dbg !465

27:                                               ; preds = %17
  %28 = load ptr, ptr %3, align 8, !dbg !466
  %29 = getelementptr inbounds i8, ptr %28, i64 2, !dbg !467
  store ptr %29, ptr %2, align 8, !dbg !468
  br label %32, !dbg !468

30:                                               ; preds = %17
  %31 = load ptr, ptr %3, align 8, !dbg !469
  store ptr %31, ptr %2, align 8, !dbg !470
  br label %32, !dbg !470

32:                                               ; preds = %30, %27, %14
  %33 = load ptr, ptr %2, align 8, !dbg !471
  ret ptr %33, !dbg !471
}

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_test() #0 !dbg !472 {
  %1 = alloca ptr, align 8
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  call void @llvm.dbg.declare(metadata ptr %1, metadata !473, metadata !DIExpression()), !dbg !474
  store ptr inttoptr (i64 42 to ptr), ptr %1, align 8, !dbg !474
  call void @mutex_init(ptr noundef @cond_mutex, i32 noundef 0, i32 noundef 0, i32 noundef 3, i32 noundef 0), !dbg !475
  call void @cond_init(ptr noundef @cond), !dbg !476
  call void @llvm.dbg.declare(metadata ptr %2, metadata !477, metadata !DIExpression()), !dbg !478
  %4 = load ptr, ptr %1, align 8, !dbg !479
  %5 = call ptr @thread_create(ptr noundef @cond_worker, ptr noundef %4), !dbg !480
  store ptr %5, ptr %2, align 8, !dbg !478
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !481
  %6 = load i32, ptr @phase, align 4, !dbg !483
  %7 = add nsw i32 %6, 1, !dbg !483
  store i32 %7, ptr @phase, align 4, !dbg !483
  call void @cond_signal(ptr noundef @cond), !dbg !484
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !485
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !486
  %8 = load i32, ptr @phase, align 4, !dbg !488
  %9 = add nsw i32 %8, 1, !dbg !488
  store i32 %9, ptr @phase, align 4, !dbg !488
  call void @cond_broadcast(ptr noundef @cond), !dbg !489
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !490
  call void @llvm.dbg.declare(metadata ptr %3, metadata !491, metadata !DIExpression()), !dbg !492
  %10 = load ptr, ptr %2, align 8, !dbg !493
  %11 = call ptr @thread_join(ptr noundef %10), !dbg !494
  store ptr %11, ptr %3, align 8, !dbg !492
  call void @cond_destroy(ptr noundef @cond), !dbg !495
  call void @mutex_destroy(ptr noundef @cond_mutex), !dbg !496
  ret void, !dbg !497
}

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_init(ptr noundef %0, i32 noundef %1) #0 !dbg !498 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca %struct._opaque_pthread_rwlockattr_t, align 8
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !512, metadata !DIExpression()), !dbg !513
  store i32 %1, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !514, metadata !DIExpression()), !dbg !515
  call void @llvm.dbg.declare(metadata ptr %5, metadata !516, metadata !DIExpression()), !dbg !517
  call void @llvm.dbg.declare(metadata ptr %6, metadata !518, metadata !DIExpression()), !dbg !519
  call void @llvm.dbg.declare(metadata ptr %7, metadata !520, metadata !DIExpression()), !dbg !531
  %8 = call i32 @pthread_rwlockattr_init(ptr noundef %7), !dbg !532
  store i32 %8, ptr %5, align 4, !dbg !533
  %9 = load i32, ptr %5, align 4, !dbg !534
  %10 = icmp eq i32 %9, 0, !dbg !534
  %11 = xor i1 %10, true, !dbg !534
  %12 = zext i1 %11 to i32, !dbg !534
  %13 = sext i32 %12 to i64, !dbg !534
  %14 = icmp ne i64 %13, 0, !dbg !534
  br i1 %14, label %15, label %17, !dbg !534

15:                                               ; preds = %2
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 269, ptr noundef @.str.1) #4, !dbg !534
  unreachable, !dbg !534

16:                                               ; No predecessors!
  br label %18, !dbg !534

17:                                               ; preds = %2
  br label %18, !dbg !534

18:                                               ; preds = %17, %16
  %19 = load i32, ptr %4, align 4, !dbg !535
  %20 = call i32 @pthread_rwlockattr_setpshared(ptr noundef %7, i32 noundef %19), !dbg !536
  store i32 %20, ptr %5, align 4, !dbg !537
  %21 = load i32, ptr %5, align 4, !dbg !538
  %22 = icmp eq i32 %21, 0, !dbg !538
  %23 = xor i1 %22, true, !dbg !538
  %24 = zext i1 %23 to i32, !dbg !538
  %25 = sext i32 %24 to i64, !dbg !538
  %26 = icmp ne i64 %25, 0, !dbg !538
  br i1 %26, label %27, label %29, !dbg !538

27:                                               ; preds = %18
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 272, ptr noundef @.str.1) #4, !dbg !538
  unreachable, !dbg !538

28:                                               ; No predecessors!
  br label %30, !dbg !538

29:                                               ; preds = %18
  br label %30, !dbg !538

30:                                               ; preds = %29, %28
  %31 = call i32 @pthread_rwlockattr_getpshared(ptr noundef %7, ptr noundef %6), !dbg !539
  store i32 %31, ptr %5, align 4, !dbg !540
  %32 = load i32, ptr %5, align 4, !dbg !541
  %33 = icmp eq i32 %32, 0, !dbg !541
  %34 = xor i1 %33, true, !dbg !541
  %35 = zext i1 %34 to i32, !dbg !541
  %36 = sext i32 %35 to i64, !dbg !541
  %37 = icmp ne i64 %36, 0, !dbg !541
  br i1 %37, label %38, label %40, !dbg !541

38:                                               ; preds = %30
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 274, ptr noundef @.str.1) #4, !dbg !541
  unreachable, !dbg !541

39:                                               ; No predecessors!
  br label %41, !dbg !541

40:                                               ; preds = %30
  br label %41, !dbg !541

41:                                               ; preds = %40, %39
  %42 = load ptr, ptr %3, align 8, !dbg !542
  %43 = call i32 @"\01_pthread_rwlock_init"(ptr noundef %42, ptr noundef %7), !dbg !543
  store i32 %43, ptr %5, align 4, !dbg !544
  %44 = load i32, ptr %5, align 4, !dbg !545
  %45 = icmp eq i32 %44, 0, !dbg !545
  %46 = xor i1 %45, true, !dbg !545
  %47 = zext i1 %46 to i32, !dbg !545
  %48 = sext i32 %47 to i64, !dbg !545
  %49 = icmp ne i64 %48, 0, !dbg !545
  br i1 %49, label %50, label %52, !dbg !545

50:                                               ; preds = %41
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 277, ptr noundef @.str.1) #4, !dbg !545
  unreachable, !dbg !545

51:                                               ; No predecessors!
  br label %53, !dbg !545

52:                                               ; preds = %41
  br label %53, !dbg !545

53:                                               ; preds = %52, %51
  %54 = call i32 @pthread_rwlockattr_destroy(ptr noundef %7), !dbg !546
  store i32 %54, ptr %5, align 4, !dbg !547
  %55 = load i32, ptr %5, align 4, !dbg !548
  %56 = icmp eq i32 %55, 0, !dbg !548
  %57 = xor i1 %56, true, !dbg !548
  %58 = zext i1 %57 to i32, !dbg !548
  %59 = sext i32 %58 to i64, !dbg !548
  %60 = icmp ne i64 %59, 0, !dbg !548
  br i1 %60, label %61, label %63, !dbg !548

61:                                               ; preds = %53
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 279, ptr noundef @.str.1) #4, !dbg !548
  unreachable, !dbg !548

62:                                               ; No predecessors!
  br label %64, !dbg !548

63:                                               ; preds = %53
  br label %64, !dbg !548

64:                                               ; preds = %63, %62
  ret void, !dbg !549
}

declare i32 @pthread_rwlockattr_init(ptr noundef) #2

declare i32 @pthread_rwlockattr_setpshared(ptr noundef, i32 noundef) #2

declare i32 @pthread_rwlockattr_getpshared(ptr noundef, ptr noundef) #2

declare i32 @"\01_pthread_rwlock_init"(ptr noundef, ptr noundef) #2

declare i32 @pthread_rwlockattr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_destroy(ptr noundef %0) #0 !dbg !550 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !553, metadata !DIExpression()), !dbg !554
  call void @llvm.dbg.declare(metadata ptr %3, metadata !555, metadata !DIExpression()), !dbg !556
  %4 = load ptr, ptr %2, align 8, !dbg !557
  %5 = call i32 @"\01_pthread_rwlock_destroy"(ptr noundef %4), !dbg !558
  store i32 %5, ptr %3, align 4, !dbg !556
  %6 = load i32, ptr %3, align 4, !dbg !559
  %7 = icmp eq i32 %6, 0, !dbg !559
  %8 = xor i1 %7, true, !dbg !559
  %9 = zext i1 %8 to i32, !dbg !559
  %10 = sext i32 %9 to i64, !dbg !559
  %11 = icmp ne i64 %10, 0, !dbg !559
  br i1 %11, label %12, label %14, !dbg !559

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_destroy, ptr noundef @.str, i32 noundef 285, ptr noundef @.str.1) #4, !dbg !559
  unreachable, !dbg !559

13:                                               ; No predecessors!
  br label %15, !dbg !559

14:                                               ; preds = %1
  br label %15, !dbg !559

15:                                               ; preds = %14, %13
  ret void, !dbg !560
}

declare i32 @"\01_pthread_rwlock_destroy"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_wrlock(ptr noundef %0) #0 !dbg !561 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !562, metadata !DIExpression()), !dbg !563
  call void @llvm.dbg.declare(metadata ptr %3, metadata !564, metadata !DIExpression()), !dbg !565
  %4 = load ptr, ptr %2, align 8, !dbg !566
  %5 = call i32 @"\01_pthread_rwlock_wrlock"(ptr noundef %4), !dbg !567
  store i32 %5, ptr %3, align 4, !dbg !565
  %6 = load i32, ptr %3, align 4, !dbg !568
  %7 = icmp eq i32 %6, 0, !dbg !568
  %8 = xor i1 %7, true, !dbg !568
  %9 = zext i1 %8 to i32, !dbg !568
  %10 = sext i32 %9 to i64, !dbg !568
  %11 = icmp ne i64 %10, 0, !dbg !568
  br i1 %11, label %12, label %14, !dbg !568

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_wrlock, ptr noundef @.str, i32 noundef 291, ptr noundef @.str.1) #4, !dbg !568
  unreachable, !dbg !568

13:                                               ; No predecessors!
  br label %15, !dbg !568

14:                                               ; preds = %1
  br label %15, !dbg !568

15:                                               ; preds = %14, %13
  ret void, !dbg !569
}

declare i32 @"\01_pthread_rwlock_wrlock"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define zeroext i1 @rwlock_trywrlock(ptr noundef %0) #0 !dbg !570 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !573, metadata !DIExpression()), !dbg !574
  call void @llvm.dbg.declare(metadata ptr %3, metadata !575, metadata !DIExpression()), !dbg !576
  %4 = load ptr, ptr %2, align 8, !dbg !577
  %5 = call i32 @"\01_pthread_rwlock_trywrlock"(ptr noundef %4), !dbg !578
  store i32 %5, ptr %3, align 4, !dbg !576
  %6 = load i32, ptr %3, align 4, !dbg !579
  %7 = icmp eq i32 %6, 0, !dbg !580
  ret i1 %7, !dbg !581
}

declare i32 @"\01_pthread_rwlock_trywrlock"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_rdlock(ptr noundef %0) #0 !dbg !582 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !583, metadata !DIExpression()), !dbg !584
  call void @llvm.dbg.declare(metadata ptr %3, metadata !585, metadata !DIExpression()), !dbg !586
  %4 = load ptr, ptr %2, align 8, !dbg !587
  %5 = call i32 @"\01_pthread_rwlock_rdlock"(ptr noundef %4), !dbg !588
  store i32 %5, ptr %3, align 4, !dbg !586
  %6 = load i32, ptr %3, align 4, !dbg !589
  %7 = icmp eq i32 %6, 0, !dbg !589
  %8 = xor i1 %7, true, !dbg !589
  %9 = zext i1 %8 to i32, !dbg !589
  %10 = sext i32 %9 to i64, !dbg !589
  %11 = icmp ne i64 %10, 0, !dbg !589
  br i1 %11, label %12, label %14, !dbg !589

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_rdlock, ptr noundef @.str, i32 noundef 304, ptr noundef @.str.1) #4, !dbg !589
  unreachable, !dbg !589

13:                                               ; No predecessors!
  br label %15, !dbg !589

14:                                               ; preds = %1
  br label %15, !dbg !589

15:                                               ; preds = %14, %13
  ret void, !dbg !590
}

declare i32 @"\01_pthread_rwlock_rdlock"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define zeroext i1 @rwlock_tryrdlock(ptr noundef %0) #0 !dbg !591 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !592, metadata !DIExpression()), !dbg !593
  call void @llvm.dbg.declare(metadata ptr %3, metadata !594, metadata !DIExpression()), !dbg !595
  %4 = load ptr, ptr %2, align 8, !dbg !596
  %5 = call i32 @"\01_pthread_rwlock_tryrdlock"(ptr noundef %4), !dbg !597
  store i32 %5, ptr %3, align 4, !dbg !595
  %6 = load i32, ptr %3, align 4, !dbg !598
  %7 = icmp eq i32 %6, 0, !dbg !599
  ret i1 %7, !dbg !600
}

declare i32 @"\01_pthread_rwlock_tryrdlock"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_unlock(ptr noundef %0) #0 !dbg !601 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !602, metadata !DIExpression()), !dbg !603
  call void @llvm.dbg.declare(metadata ptr %3, metadata !604, metadata !DIExpression()), !dbg !605
  %4 = load ptr, ptr %2, align 8, !dbg !606
  %5 = call i32 @"\01_pthread_rwlock_unlock"(ptr noundef %4), !dbg !607
  store i32 %5, ptr %3, align 4, !dbg !605
  %6 = load i32, ptr %3, align 4, !dbg !608
  %7 = icmp eq i32 %6, 0, !dbg !608
  %8 = xor i1 %7, true, !dbg !608
  %9 = zext i1 %8 to i32, !dbg !608
  %10 = sext i32 %9 to i64, !dbg !608
  %11 = icmp ne i64 %10, 0, !dbg !608
  br i1 %11, label %12, label %14, !dbg !608

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_unlock, ptr noundef @.str, i32 noundef 317, ptr noundef @.str.1) #4, !dbg !608
  unreachable, !dbg !608

13:                                               ; No predecessors!
  br label %15, !dbg !608

14:                                               ; preds = %1
  br label %15, !dbg !608

15:                                               ; preds = %14, %13
  ret void, !dbg !609
}

declare i32 @"\01_pthread_rwlock_unlock"(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_test() #0 !dbg !610 {
  %1 = alloca %struct._opaque_pthread_rwlock_t, align 8
  %2 = alloca i32, align 4
  %3 = alloca i8, align 1
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  %6 = alloca i8, align 1
  %7 = alloca i32, align 4
  %8 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata ptr %1, metadata !611, metadata !DIExpression()), !dbg !612
  call void @rwlock_init(ptr noundef %1, i32 noundef 2), !dbg !613
  call void @llvm.dbg.declare(metadata ptr %2, metadata !614, metadata !DIExpression()), !dbg !616
  store i32 4, ptr %2, align 4, !dbg !616
  call void @rwlock_wrlock(ptr noundef %1), !dbg !617
  call void @llvm.dbg.declare(metadata ptr %3, metadata !619, metadata !DIExpression()), !dbg !620
  %9 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !621
  %10 = zext i1 %9 to i8, !dbg !620
  store i8 %10, ptr %3, align 1, !dbg !620
  %11 = load i8, ptr %3, align 1, !dbg !622
  %12 = trunc i8 %11 to i1, !dbg !622
  %13 = xor i1 %12, true, !dbg !622
  %14 = xor i1 %13, true, !dbg !622
  %15 = zext i1 %14 to i32, !dbg !622
  %16 = sext i32 %15 to i64, !dbg !622
  %17 = icmp ne i64 %16, 0, !dbg !622
  br i1 %17, label %18, label %20, !dbg !622

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 329, ptr noundef @.str.2) #4, !dbg !622
  unreachable, !dbg !622

19:                                               ; No predecessors!
  br label %21, !dbg !622

20:                                               ; preds = %0
  br label %21, !dbg !622

21:                                               ; preds = %20, %19
  %22 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %1), !dbg !623
  %23 = zext i1 %22 to i8, !dbg !624
  store i8 %23, ptr %3, align 1, !dbg !624
  %24 = load i8, ptr %3, align 1, !dbg !625
  %25 = trunc i8 %24 to i1, !dbg !625
  %26 = xor i1 %25, true, !dbg !625
  %27 = xor i1 %26, true, !dbg !625
  %28 = zext i1 %27 to i32, !dbg !625
  %29 = sext i32 %28 to i64, !dbg !625
  %30 = icmp ne i64 %29, 0, !dbg !625
  br i1 %30, label %31, label %33, !dbg !625

31:                                               ; preds = %21
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 331, ptr noundef @.str.2) #4, !dbg !625
  unreachable, !dbg !625

32:                                               ; No predecessors!
  br label %34, !dbg !625

33:                                               ; preds = %21
  br label %34, !dbg !625

34:                                               ; preds = %33, %32
  call void @rwlock_unlock(ptr noundef %1), !dbg !626
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !627
  call void @llvm.dbg.declare(metadata ptr %4, metadata !629, metadata !DIExpression()), !dbg !631
  store i32 0, ptr %4, align 4, !dbg !631
  br label %35, !dbg !632

35:                                               ; preds = %51, %34
  %36 = load i32, ptr %4, align 4, !dbg !633
  %37 = icmp slt i32 %36, 4, !dbg !635
  br i1 %37, label %38, label %54, !dbg !636

38:                                               ; preds = %35
  call void @llvm.dbg.declare(metadata ptr %5, metadata !637, metadata !DIExpression()), !dbg !639
  %39 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %1), !dbg !640
  %40 = zext i1 %39 to i8, !dbg !639
  store i8 %40, ptr %5, align 1, !dbg !639
  %41 = load i8, ptr %5, align 1, !dbg !641
  %42 = trunc i8 %41 to i1, !dbg !641
  %43 = xor i1 %42, true, !dbg !641
  %44 = zext i1 %43 to i32, !dbg !641
  %45 = sext i32 %44 to i64, !dbg !641
  %46 = icmp ne i64 %45, 0, !dbg !641
  br i1 %46, label %47, label %49, !dbg !641

47:                                               ; preds = %38
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 340, ptr noundef @.str.3) #4, !dbg !641
  unreachable, !dbg !641

48:                                               ; No predecessors!
  br label %50, !dbg !641

49:                                               ; preds = %38
  br label %50, !dbg !641

50:                                               ; preds = %49, %48
  br label %51, !dbg !642

51:                                               ; preds = %50
  %52 = load i32, ptr %4, align 4, !dbg !643
  %53 = add nsw i32 %52, 1, !dbg !643
  store i32 %53, ptr %4, align 4, !dbg !643
  br label %35, !dbg !644, !llvm.loop !645

54:                                               ; preds = %35
  call void @llvm.dbg.declare(metadata ptr %6, metadata !648, metadata !DIExpression()), !dbg !650
  %55 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !651
  %56 = zext i1 %55 to i8, !dbg !650
  store i8 %56, ptr %6, align 1, !dbg !650
  %57 = load i8, ptr %6, align 1, !dbg !652
  %58 = trunc i8 %57 to i1, !dbg !652
  %59 = xor i1 %58, true, !dbg !652
  %60 = xor i1 %59, true, !dbg !652
  %61 = zext i1 %60 to i32, !dbg !652
  %62 = sext i32 %61 to i64, !dbg !652
  %63 = icmp ne i64 %62, 0, !dbg !652
  br i1 %63, label %64, label %66, !dbg !652

64:                                               ; preds = %54
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 345, ptr noundef @.str.2) #4, !dbg !652
  unreachable, !dbg !652

65:                                               ; No predecessors!
  br label %67, !dbg !652

66:                                               ; preds = %54
  br label %67, !dbg !652

67:                                               ; preds = %66, %65
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !653
  call void @llvm.dbg.declare(metadata ptr %7, metadata !654, metadata !DIExpression()), !dbg !656
  store i32 0, ptr %7, align 4, !dbg !656
  br label %68, !dbg !657

68:                                               ; preds = %72, %67
  %69 = load i32, ptr %7, align 4, !dbg !658
  %70 = icmp slt i32 %69, 4, !dbg !660
  br i1 %70, label %71, label %75, !dbg !661

71:                                               ; preds = %68
  call void @rwlock_unlock(ptr noundef %1), !dbg !662
  br label %72, !dbg !664

72:                                               ; preds = %71
  %73 = load i32, ptr %7, align 4, !dbg !665
  %74 = add nsw i32 %73, 1, !dbg !665
  store i32 %74, ptr %7, align 4, !dbg !665
  br label %68, !dbg !666, !llvm.loop !667

75:                                               ; preds = %68
  call void @rwlock_wrlock(ptr noundef %1), !dbg !669
  call void @llvm.dbg.declare(metadata ptr %8, metadata !671, metadata !DIExpression()), !dbg !672
  %76 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !673
  %77 = zext i1 %76 to i8, !dbg !672
  store i8 %77, ptr %8, align 1, !dbg !672
  %78 = load i8, ptr %8, align 1, !dbg !674
  %79 = trunc i8 %78 to i1, !dbg !674
  %80 = xor i1 %79, true, !dbg !674
  %81 = xor i1 %80, true, !dbg !674
  %82 = zext i1 %81 to i32, !dbg !674
  %83 = sext i32 %82 to i64, !dbg !674
  %84 = icmp ne i64 %83, 0, !dbg !674
  br i1 %84, label %85, label %87, !dbg !674

85:                                               ; preds = %75
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 357, ptr noundef @.str.2) #4, !dbg !674
  unreachable, !dbg !674

86:                                               ; No predecessors!
  br label %88, !dbg !674

87:                                               ; preds = %75
  br label %88, !dbg !674

88:                                               ; preds = %87, %86
  call void @rwlock_unlock(ptr noundef %1), !dbg !675
  call void @rwlock_destroy(ptr noundef %1), !dbg !676
  ret void, !dbg !677
}

declare void @__VERIFIER_loop_bound(i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @key_destroy(ptr noundef %0) #0 !dbg !678 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !679, metadata !DIExpression()), !dbg !680
  %3 = call ptr @pthread_self(), !dbg !681
  store ptr %3, ptr @latest_thread, align 8, !dbg !682
  ret void, !dbg !683
}

declare ptr @pthread_self() #2

; Function Attrs: noinline nounwind ssp uwtable
define ptr @key_worker(ptr noundef %0) #0 !dbg !684 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !685, metadata !DIExpression()), !dbg !686
  call void @llvm.dbg.declare(metadata ptr %3, metadata !687, metadata !DIExpression()), !dbg !688
  store i32 1, ptr %3, align 4, !dbg !688
  call void @llvm.dbg.declare(metadata ptr %4, metadata !689, metadata !DIExpression()), !dbg !690
  %6 = load i64, ptr @local_data, align 8, !dbg !691
  %7 = call i32 @pthread_setspecific(i64 noundef %6, ptr noundef %3), !dbg !692
  store i32 %7, ptr %4, align 4, !dbg !690
  %8 = load i32, ptr %4, align 4, !dbg !693
  %9 = icmp eq i32 %8, 0, !dbg !693
  %10 = xor i1 %9, true, !dbg !693
  %11 = zext i1 %10 to i32, !dbg !693
  %12 = sext i32 %11 to i64, !dbg !693
  %13 = icmp ne i64 %12, 0, !dbg !693
  br i1 %13, label %14, label %16, !dbg !693

14:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.key_worker, ptr noundef @.str, i32 noundef 379, ptr noundef @.str.1) #4, !dbg !693
  unreachable, !dbg !693

15:                                               ; No predecessors!
  br label %17, !dbg !693

16:                                               ; preds = %1
  br label %17, !dbg !693

17:                                               ; preds = %16, %15
  call void @llvm.dbg.declare(metadata ptr %5, metadata !694, metadata !DIExpression()), !dbg !695
  %18 = load i64, ptr @local_data, align 8, !dbg !696
  %19 = call ptr @pthread_getspecific(i64 noundef %18), !dbg !697
  store ptr %19, ptr %5, align 8, !dbg !695
  %20 = load ptr, ptr %5, align 8, !dbg !698
  %21 = icmp eq ptr %20, %3, !dbg !698
  %22 = xor i1 %21, true, !dbg !698
  %23 = zext i1 %22 to i32, !dbg !698
  %24 = sext i32 %23 to i64, !dbg !698
  %25 = icmp ne i64 %24, 0, !dbg !698
  br i1 %25, label %26, label %28, !dbg !698

26:                                               ; preds = %17
  call void @__assert_rtn(ptr noundef @__func__.key_worker, ptr noundef @.str, i32 noundef 382, ptr noundef @.str.4) #4, !dbg !698
  unreachable, !dbg !698

27:                                               ; No predecessors!
  br label %29, !dbg !698

28:                                               ; preds = %17
  br label %29, !dbg !698

29:                                               ; preds = %28, %27
  %30 = load ptr, ptr %2, align 8, !dbg !699
  ret ptr %30, !dbg !700
}

declare i32 @pthread_setspecific(i64 noundef, ptr noundef) #2

declare ptr @pthread_getspecific(i64 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @key_test() #0 !dbg !701 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  call void @llvm.dbg.declare(metadata ptr %1, metadata !702, metadata !DIExpression()), !dbg !703
  store i32 2, ptr %1, align 4, !dbg !703
  call void @llvm.dbg.declare(metadata ptr %2, metadata !704, metadata !DIExpression()), !dbg !705
  store ptr inttoptr (i64 41 to ptr), ptr %2, align 8, !dbg !705
  call void @llvm.dbg.declare(metadata ptr %3, metadata !706, metadata !DIExpression()), !dbg !707
  %7 = call i32 @pthread_key_create(ptr noundef @local_data, ptr noundef @key_destroy), !dbg !708
  call void @llvm.dbg.declare(metadata ptr %4, metadata !709, metadata !DIExpression()), !dbg !710
  %8 = load ptr, ptr %2, align 8, !dbg !711
  %9 = call ptr @thread_create(ptr noundef @key_worker, ptr noundef %8), !dbg !712
  store ptr %9, ptr %4, align 8, !dbg !710
  %10 = load i64, ptr @local_data, align 8, !dbg !713
  %11 = call i32 @pthread_setspecific(i64 noundef %10, ptr noundef %1), !dbg !714
  store i32 %11, ptr %3, align 4, !dbg !715
  %12 = load i32, ptr %3, align 4, !dbg !716
  %13 = icmp eq i32 %12, 0, !dbg !716
  %14 = xor i1 %13, true, !dbg !716
  %15 = zext i1 %14 to i32, !dbg !716
  %16 = sext i32 %15 to i64, !dbg !716
  %17 = icmp ne i64 %16, 0, !dbg !716
  br i1 %17, label %18, label %20, !dbg !716

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 398, ptr noundef @.str.1) #4, !dbg !716
  unreachable, !dbg !716

19:                                               ; No predecessors!
  br label %21, !dbg !716

20:                                               ; preds = %0
  br label %21, !dbg !716

21:                                               ; preds = %20, %19
  call void @llvm.dbg.declare(metadata ptr %5, metadata !717, metadata !DIExpression()), !dbg !718
  %22 = load i64, ptr @local_data, align 8, !dbg !719
  %23 = call ptr @pthread_getspecific(i64 noundef %22), !dbg !720
  store ptr %23, ptr %5, align 8, !dbg !718
  %24 = load ptr, ptr %5, align 8, !dbg !721
  %25 = icmp eq ptr %24, %1, !dbg !721
  %26 = xor i1 %25, true, !dbg !721
  %27 = zext i1 %26 to i32, !dbg !721
  %28 = sext i32 %27 to i64, !dbg !721
  %29 = icmp ne i64 %28, 0, !dbg !721
  br i1 %29, label %30, label %32, !dbg !721

30:                                               ; preds = %21
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 401, ptr noundef @.str.4) #4, !dbg !721
  unreachable, !dbg !721

31:                                               ; No predecessors!
  br label %33, !dbg !721

32:                                               ; preds = %21
  br label %33, !dbg !721

33:                                               ; preds = %32, %31
  %34 = load i64, ptr @local_data, align 8, !dbg !722
  %35 = call i32 @pthread_setspecific(i64 noundef %34, ptr noundef null), !dbg !723
  store i32 %35, ptr %3, align 4, !dbg !724
  %36 = load i32, ptr %3, align 4, !dbg !725
  %37 = icmp eq i32 %36, 0, !dbg !725
  %38 = xor i1 %37, true, !dbg !725
  %39 = zext i1 %38 to i32, !dbg !725
  %40 = sext i32 %39 to i64, !dbg !725
  %41 = icmp ne i64 %40, 0, !dbg !725
  br i1 %41, label %42, label %44, !dbg !725

42:                                               ; preds = %33
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 404, ptr noundef @.str.1) #4, !dbg !725
  unreachable, !dbg !725

43:                                               ; No predecessors!
  br label %45, !dbg !725

44:                                               ; preds = %33
  br label %45, !dbg !725

45:                                               ; preds = %44, %43
  call void @llvm.dbg.declare(metadata ptr %6, metadata !726, metadata !DIExpression()), !dbg !727
  %46 = load ptr, ptr %4, align 8, !dbg !728
  %47 = call ptr @thread_join(ptr noundef %46), !dbg !729
  store ptr %47, ptr %6, align 8, !dbg !727
  %48 = load i64, ptr @local_data, align 8, !dbg !730
  %49 = call i32 @pthread_key_delete(i64 noundef %48), !dbg !731
  store i32 %49, ptr %3, align 4, !dbg !732
  %50 = load i32, ptr %3, align 4, !dbg !733
  %51 = icmp eq i32 %50, 0, !dbg !733
  %52 = xor i1 %51, true, !dbg !733
  %53 = zext i1 %52 to i32, !dbg !733
  %54 = sext i32 %53 to i64, !dbg !733
  %55 = icmp ne i64 %54, 0, !dbg !733
  br i1 %55, label %56, label %58, !dbg !733

56:                                               ; preds = %45
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 410, ptr noundef @.str.1) #4, !dbg !733
  unreachable, !dbg !733

57:                                               ; No predecessors!
  br label %59, !dbg !733

58:                                               ; preds = %45
  br label %59, !dbg !733

59:                                               ; preds = %58, %57
  ret void, !dbg !734
}

declare i32 @pthread_key_create(ptr noundef, ptr noundef) #2

declare i32 @pthread_key_delete(i64 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !735 {
  call void @mutex_test(), !dbg !738
  call void @cond_test(), !dbg !739
  call void @rwlock_test(), !dbg !740
  call void @key_test(), !dbg !741
  ret i32 0, !dbg !742
}

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #4 = { cold noreturn }

!llvm.dbg.cu = !{!61}
!llvm.module.flags = !{!144, !145, !146, !147, !148, !149}
!llvm.ident = !{!150}

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
!60 = distinct !DIGlobalVariable(name: "phase", scope: !61, file: !2, line: 200, type: !143, isLocal: false, isDefinition: true)
!61 = distinct !DICompileUnit(language: DW_LANG_C99, file: !2, producer: "Homebrew clang version 15.0.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !62, globals: !65, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!62 = !{!63, !64}
!63 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!65 = !{!0, !8, !13, !18, !21, !26, !28, !30, !35, !37, !42, !47, !50, !52, !54, !59, !66, !68, !70, !72, !74, !76, !78, !80, !85, !88, !102, !114, !137}
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(scope: null, file: !2, line: 269, type: !20, isLocal: true, isDefinition: true)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(scope: null, file: !2, line: 285, type: !56, isLocal: true, isDefinition: true)
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(scope: null, file: !2, line: 291, type: !3, isLocal: true, isDefinition: true)
!72 = !DIGlobalVariableExpression(var: !73, expr: !DIExpression())
!73 = distinct !DIGlobalVariable(scope: null, file: !2, line: 304, type: !3, isLocal: true, isDefinition: true)
!74 = !DIGlobalVariableExpression(var: !75, expr: !DIExpression())
!75 = distinct !DIGlobalVariable(scope: null, file: !2, line: 317, type: !3, isLocal: true, isDefinition: true)
!76 = !DIGlobalVariableExpression(var: !77, expr: !DIExpression())
!77 = distinct !DIGlobalVariable(scope: null, file: !2, line: 329, type: !20, isLocal: true, isDefinition: true)
!78 = !DIGlobalVariableExpression(var: !79, expr: !DIExpression())
!79 = distinct !DIGlobalVariable(scope: null, file: !2, line: 379, type: !23, isLocal: true, isDefinition: true)
!80 = !DIGlobalVariableExpression(var: !81, expr: !DIExpression())
!81 = distinct !DIGlobalVariable(scope: null, file: !2, line: 382, type: !82, isLocal: true, isDefinition: true)
!82 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 224, elements: !83)
!83 = !{!84}
!84 = !DISubrange(count: 28)
!85 = !DIGlobalVariableExpression(var: !86, expr: !DIExpression())
!86 = distinct !DIGlobalVariable(scope: null, file: !2, line: 398, type: !87, isLocal: true, isDefinition: true)
!87 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 72, elements: !40)
!88 = !DIGlobalVariableExpression(var: !89, expr: !DIExpression())
!89 = distinct !DIGlobalVariable(name: "cond_mutex", scope: !61, file: !2, line: 198, type: !90, isLocal: false, isDefinition: true)
!90 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !91, line: 31, baseType: !92)
!91 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_mutex_t.h", directory: "")
!92 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutex_t", file: !93, line: 113, baseType: !94)
!93 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!94 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutex_t", file: !93, line: 78, size: 512, elements: !95)
!95 = !{!96, !98}
!96 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !94, file: !93, line: 79, baseType: !97, size: 64)
!97 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !94, file: !93, line: 80, baseType: !99, size: 448, offset: 64)
!99 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 448, elements: !100)
!100 = !{!101}
!101 = !DISubrange(count: 56)
!102 = !DIGlobalVariableExpression(var: !103, expr: !DIExpression())
!103 = distinct !DIGlobalVariable(name: "cond", scope: !61, file: !2, line: 199, type: !104, isLocal: false, isDefinition: true)
!104 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_cond_t", file: !105, line: 31, baseType: !106)
!105 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_cond_t.h", directory: "")
!106 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_cond_t", file: !93, line: 110, baseType: !107)
!107 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_cond_t", file: !93, line: 68, size: 384, elements: !108)
!108 = !{!109, !110}
!109 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !107, file: !93, line: 69, baseType: !97, size: 64)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !107, file: !93, line: 70, baseType: !111, size: 320, offset: 64)
!111 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 320, elements: !112)
!112 = !{!113}
!113 = !DISubrange(count: 40)
!114 = !DIGlobalVariableExpression(var: !115, expr: !DIExpression())
!115 = distinct !DIGlobalVariable(name: "latest_thread", scope: !61, file: !2, line: 366, type: !116, isLocal: false, isDefinition: true)
!116 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !117, line: 31, baseType: !118)
!117 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!118 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !93, line: 118, baseType: !119)
!119 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !120, size: 64)
!120 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !93, line: 103, size: 65536, elements: !121)
!121 = !{!122, !123, !133}
!122 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !120, file: !93, line: 104, baseType: !97, size: 64)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !120, file: !93, line: 105, baseType: !124, size: 64, offset: 64)
!124 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !125, size: 64)
!125 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !93, line: 57, size: 192, elements: !126)
!126 = !{!127, !131, !132}
!127 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !125, file: !93, line: 58, baseType: !128, size: 64)
!128 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !129, size: 64)
!129 = !DISubroutineType(types: !130)
!130 = !{null, !64}
!131 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !125, file: !93, line: 59, baseType: !64, size: 64, offset: 64)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !125, file: !93, line: 60, baseType: !124, size: 64, offset: 128)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !120, file: !93, line: 106, baseType: !134, size: 65408, offset: 128)
!134 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 65408, elements: !135)
!135 = !{!136}
!136 = !DISubrange(count: 8176)
!137 = !DIGlobalVariableExpression(var: !138, expr: !DIExpression())
!138 = distinct !DIGlobalVariable(name: "local_data", scope: !61, file: !2, line: 367, type: !139, isLocal: false, isDefinition: true)
!139 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_key_t", file: !140, line: 31, baseType: !141)
!140 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_key_t.h", directory: "")
!141 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_key_t", file: !93, line: 112, baseType: !142)
!142 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!143 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!144 = !{i32 7, !"Dwarf Version", i32 4}
!145 = !{i32 2, !"Debug Info Version", i32 3}
!146 = !{i32 1, !"wchar_size", i32 4}
!147 = !{i32 7, !"PIC Level", i32 2}
!148 = !{i32 7, !"uwtable", i32 2}
!149 = !{i32 7, !"frame-pointer", i32 1}
!150 = !{!"Homebrew clang version 15.0.7"}
!151 = distinct !DISubprogram(name: "thread_create", scope: !2, file: !2, line: 12, type: !152, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!152 = !DISubroutineType(types: !153)
!153 = !{!116, !154, !64}
!154 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !155, size: 64)
!155 = !DISubroutineType(types: !156)
!156 = !{!64, !64}
!157 = !{}
!158 = !DILocalVariable(name: "runner", arg: 1, scope: !151, file: !2, line: 12, type: !154)
!159 = !DILocation(line: 12, column: 32, scope: !151)
!160 = !DILocalVariable(name: "data", arg: 2, scope: !151, file: !2, line: 12, type: !64)
!161 = !DILocation(line: 12, column: 54, scope: !151)
!162 = !DILocalVariable(name: "id", scope: !151, file: !2, line: 14, type: !116)
!163 = !DILocation(line: 14, column: 15, scope: !151)
!164 = !DILocalVariable(name: "attr", scope: !151, file: !2, line: 15, type: !165)
!165 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !166, line: 31, baseType: !167)
!166 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_attr_t.h", directory: "")
!167 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_attr_t", file: !93, line: 109, baseType: !168)
!168 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_attr_t", file: !93, line: 63, size: 512, elements: !169)
!169 = !{!170, !171}
!170 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !168, file: !93, line: 64, baseType: !97, size: 64)
!171 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !168, file: !93, line: 65, baseType: !99, size: 448, offset: 64)
!172 = !DILocation(line: 15, column: 20, scope: !151)
!173 = !DILocation(line: 16, column: 5, scope: !151)
!174 = !DILocalVariable(name: "status", scope: !151, file: !2, line: 17, type: !143)
!175 = !DILocation(line: 17, column: 9, scope: !151)
!176 = !DILocation(line: 17, column: 45, scope: !151)
!177 = !DILocation(line: 17, column: 53, scope: !151)
!178 = !DILocation(line: 17, column: 18, scope: !151)
!179 = !DILocation(line: 18, column: 5, scope: !151)
!180 = !DILocation(line: 19, column: 5, scope: !151)
!181 = !DILocation(line: 20, column: 12, scope: !151)
!182 = !DILocation(line: 20, column: 5, scope: !151)
!183 = distinct !DISubprogram(name: "thread_join", scope: !2, file: !2, line: 23, type: !184, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!184 = !DISubroutineType(types: !185)
!185 = !{!64, !116}
!186 = !DILocalVariable(name: "id", arg: 1, scope: !183, file: !2, line: 23, type: !116)
!187 = !DILocation(line: 23, column: 29, scope: !183)
!188 = !DILocalVariable(name: "result", scope: !183, file: !2, line: 25, type: !64)
!189 = !DILocation(line: 25, column: 11, scope: !183)
!190 = !DILocalVariable(name: "status", scope: !183, file: !2, line: 26, type: !143)
!191 = !DILocation(line: 26, column: 9, scope: !183)
!192 = !DILocation(line: 26, column: 31, scope: !183)
!193 = !DILocation(line: 26, column: 18, scope: !183)
!194 = !DILocation(line: 27, column: 5, scope: !183)
!195 = !DILocation(line: 28, column: 12, scope: !183)
!196 = !DILocation(line: 28, column: 5, scope: !183)
!197 = distinct !DISubprogram(name: "mutex_init", scope: !2, file: !2, line: 43, type: !198, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!198 = !DISubroutineType(types: !199)
!199 = !{null, !200, !143, !143, !143, !143}
!200 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !90, size: 64)
!201 = !DILocalVariable(name: "lock", arg: 1, scope: !197, file: !2, line: 43, type: !200)
!202 = !DILocation(line: 43, column: 34, scope: !197)
!203 = !DILocalVariable(name: "type", arg: 2, scope: !197, file: !2, line: 43, type: !143)
!204 = !DILocation(line: 43, column: 44, scope: !197)
!205 = !DILocalVariable(name: "protocol", arg: 3, scope: !197, file: !2, line: 43, type: !143)
!206 = !DILocation(line: 43, column: 54, scope: !197)
!207 = !DILocalVariable(name: "policy", arg: 4, scope: !197, file: !2, line: 43, type: !143)
!208 = !DILocation(line: 43, column: 68, scope: !197)
!209 = !DILocalVariable(name: "prioceiling", arg: 5, scope: !197, file: !2, line: 43, type: !143)
!210 = !DILocation(line: 43, column: 80, scope: !197)
!211 = !DILocalVariable(name: "status", scope: !197, file: !2, line: 45, type: !143)
!212 = !DILocation(line: 45, column: 9, scope: !197)
!213 = !DILocalVariable(name: "value", scope: !197, file: !2, line: 46, type: !143)
!214 = !DILocation(line: 46, column: 9, scope: !197)
!215 = !DILocalVariable(name: "attributes", scope: !197, file: !2, line: 47, type: !216)
!216 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !217, line: 31, baseType: !218)
!217 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_mutexattr_t.h", directory: "")
!218 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutexattr_t", file: !93, line: 114, baseType: !219)
!219 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutexattr_t", file: !93, line: 83, size: 128, elements: !220)
!220 = !{!221, !222}
!221 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !219, file: !93, line: 84, baseType: !97, size: 64)
!222 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !219, file: !93, line: 85, baseType: !44, size: 64, offset: 64)
!223 = !DILocation(line: 47, column: 25, scope: !197)
!224 = !DILocation(line: 48, column: 14, scope: !197)
!225 = !DILocation(line: 48, column: 12, scope: !197)
!226 = !DILocation(line: 49, column: 5, scope: !197)
!227 = !DILocation(line: 51, column: 53, scope: !197)
!228 = !DILocation(line: 51, column: 14, scope: !197)
!229 = !DILocation(line: 51, column: 12, scope: !197)
!230 = !DILocation(line: 52, column: 5, scope: !197)
!231 = !DILocation(line: 53, column: 14, scope: !197)
!232 = !DILocation(line: 53, column: 12, scope: !197)
!233 = !DILocation(line: 54, column: 5, scope: !197)
!234 = !DILocation(line: 56, column: 57, scope: !197)
!235 = !DILocation(line: 56, column: 14, scope: !197)
!236 = !DILocation(line: 56, column: 12, scope: !197)
!237 = !DILocation(line: 57, column: 5, scope: !197)
!238 = !DILocation(line: 58, column: 14, scope: !197)
!239 = !DILocation(line: 58, column: 12, scope: !197)
!240 = !DILocation(line: 59, column: 5, scope: !197)
!241 = !DILocation(line: 61, column: 58, scope: !197)
!242 = !DILocation(line: 61, column: 14, scope: !197)
!243 = !DILocation(line: 61, column: 12, scope: !197)
!244 = !DILocation(line: 62, column: 5, scope: !197)
!245 = !DILocation(line: 63, column: 14, scope: !197)
!246 = !DILocation(line: 63, column: 12, scope: !197)
!247 = !DILocation(line: 64, column: 5, scope: !197)
!248 = !DILocation(line: 66, column: 60, scope: !197)
!249 = !DILocation(line: 66, column: 14, scope: !197)
!250 = !DILocation(line: 66, column: 12, scope: !197)
!251 = !DILocation(line: 67, column: 5, scope: !197)
!252 = !DILocation(line: 68, column: 14, scope: !197)
!253 = !DILocation(line: 68, column: 12, scope: !197)
!254 = !DILocation(line: 69, column: 5, scope: !197)
!255 = !DILocation(line: 71, column: 33, scope: !197)
!256 = !DILocation(line: 71, column: 14, scope: !197)
!257 = !DILocation(line: 71, column: 12, scope: !197)
!258 = !DILocation(line: 72, column: 5, scope: !197)
!259 = !DILocation(line: 73, column: 14, scope: !197)
!260 = !DILocation(line: 73, column: 12, scope: !197)
!261 = !DILocation(line: 74, column: 5, scope: !197)
!262 = !DILocation(line: 75, column: 1, scope: !197)
!263 = distinct !DISubprogram(name: "mutex_destroy", scope: !2, file: !2, line: 77, type: !264, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!264 = !DISubroutineType(types: !265)
!265 = !{null, !200}
!266 = !DILocalVariable(name: "lock", arg: 1, scope: !263, file: !2, line: 77, type: !200)
!267 = !DILocation(line: 77, column: 37, scope: !263)
!268 = !DILocalVariable(name: "status", scope: !263, file: !2, line: 79, type: !143)
!269 = !DILocation(line: 79, column: 9, scope: !263)
!270 = !DILocation(line: 79, column: 40, scope: !263)
!271 = !DILocation(line: 79, column: 18, scope: !263)
!272 = !DILocation(line: 80, column: 5, scope: !263)
!273 = !DILocation(line: 81, column: 1, scope: !263)
!274 = distinct !DISubprogram(name: "mutex_lock", scope: !2, file: !2, line: 83, type: !264, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!275 = !DILocalVariable(name: "lock", arg: 1, scope: !274, file: !2, line: 83, type: !200)
!276 = !DILocation(line: 83, column: 34, scope: !274)
!277 = !DILocalVariable(name: "status", scope: !274, file: !2, line: 85, type: !143)
!278 = !DILocation(line: 85, column: 9, scope: !274)
!279 = !DILocation(line: 85, column: 37, scope: !274)
!280 = !DILocation(line: 85, column: 18, scope: !274)
!281 = !DILocation(line: 86, column: 5, scope: !274)
!282 = !DILocation(line: 87, column: 1, scope: !274)
!283 = distinct !DISubprogram(name: "mutex_trylock", scope: !2, file: !2, line: 89, type: !284, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!284 = !DISubroutineType(types: !285)
!285 = !{!286, !200}
!286 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!287 = !DILocalVariable(name: "lock", arg: 1, scope: !283, file: !2, line: 89, type: !200)
!288 = !DILocation(line: 89, column: 37, scope: !283)
!289 = !DILocalVariable(name: "status", scope: !283, file: !2, line: 91, type: !143)
!290 = !DILocation(line: 91, column: 9, scope: !283)
!291 = !DILocation(line: 91, column: 40, scope: !283)
!292 = !DILocation(line: 91, column: 18, scope: !283)
!293 = !DILocation(line: 93, column: 12, scope: !283)
!294 = !DILocation(line: 93, column: 19, scope: !283)
!295 = !DILocation(line: 93, column: 5, scope: !283)
!296 = distinct !DISubprogram(name: "mutex_unlock", scope: !2, file: !2, line: 96, type: !264, scopeLine: 97, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!297 = !DILocalVariable(name: "lock", arg: 1, scope: !296, file: !2, line: 96, type: !200)
!298 = !DILocation(line: 96, column: 36, scope: !296)
!299 = !DILocalVariable(name: "status", scope: !296, file: !2, line: 98, type: !143)
!300 = !DILocation(line: 98, column: 9, scope: !296)
!301 = !DILocation(line: 98, column: 39, scope: !296)
!302 = !DILocation(line: 98, column: 18, scope: !296)
!303 = !DILocation(line: 99, column: 5, scope: !296)
!304 = !DILocation(line: 100, column: 1, scope: !296)
!305 = distinct !DISubprogram(name: "mutex_test", scope: !2, file: !2, line: 102, type: !306, scopeLine: 103, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!306 = !DISubroutineType(types: !307)
!307 = !{null}
!308 = !DILocalVariable(name: "mutex0", scope: !305, file: !2, line: 104, type: !90)
!309 = !DILocation(line: 104, column: 21, scope: !305)
!310 = !DILocalVariable(name: "mutex1", scope: !305, file: !2, line: 105, type: !90)
!311 = !DILocation(line: 105, column: 21, scope: !305)
!312 = !DILocation(line: 107, column: 5, scope: !305)
!313 = !DILocation(line: 108, column: 5, scope: !305)
!314 = !DILocation(line: 111, column: 9, scope: !315)
!315 = distinct !DILexicalBlock(scope: !305, file: !2, line: 110, column: 5)
!316 = !DILocalVariable(name: "success", scope: !315, file: !2, line: 112, type: !286)
!317 = !DILocation(line: 112, column: 14, scope: !315)
!318 = !DILocation(line: 112, column: 24, scope: !315)
!319 = !DILocation(line: 113, column: 9, scope: !315)
!320 = !DILocation(line: 114, column: 9, scope: !315)
!321 = !DILocation(line: 118, column: 9, scope: !322)
!322 = distinct !DILexicalBlock(scope: !305, file: !2, line: 117, column: 5)
!323 = !DILocalVariable(name: "success", scope: !324, file: !2, line: 121, type: !286)
!324 = distinct !DILexicalBlock(scope: !322, file: !2, line: 120, column: 9)
!325 = !DILocation(line: 121, column: 18, scope: !324)
!326 = !DILocation(line: 121, column: 28, scope: !324)
!327 = !DILocation(line: 122, column: 13, scope: !324)
!328 = !DILocation(line: 123, column: 13, scope: !324)
!329 = !DILocalVariable(name: "success", scope: !330, file: !2, line: 127, type: !286)
!330 = distinct !DILexicalBlock(scope: !322, file: !2, line: 126, column: 9)
!331 = !DILocation(line: 127, column: 18, scope: !330)
!332 = !DILocation(line: 127, column: 28, scope: !330)
!333 = !DILocation(line: 128, column: 13, scope: !330)
!334 = !DILocation(line: 129, column: 13, scope: !330)
!335 = !DILocation(line: 139, column: 9, scope: !322)
!336 = !DILocation(line: 142, column: 5, scope: !305)
!337 = !DILocation(line: 143, column: 5, scope: !305)
!338 = !DILocation(line: 144, column: 1, scope: !305)
!339 = distinct !DISubprogram(name: "cond_init", scope: !2, file: !2, line: 148, type: !340, scopeLine: 149, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!340 = !DISubroutineType(types: !341)
!341 = !{null, !342}
!342 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !104, size: 64)
!343 = !DILocalVariable(name: "cond", arg: 1, scope: !339, file: !2, line: 148, type: !342)
!344 = !DILocation(line: 148, column: 32, scope: !339)
!345 = !DILocalVariable(name: "status", scope: !339, file: !2, line: 150, type: !143)
!346 = !DILocation(line: 150, column: 9, scope: !339)
!347 = !DILocalVariable(name: "attr", scope: !339, file: !2, line: 151, type: !348)
!348 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_condattr_t", file: !349, line: 31, baseType: !350)
!349 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_condattr_t.h", directory: "")
!350 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_condattr_t", file: !93, line: 111, baseType: !351)
!351 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_condattr_t", file: !93, line: 73, size: 128, elements: !352)
!352 = !{!353, !354}
!353 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !351, file: !93, line: 74, baseType: !97, size: 64)
!354 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !351, file: !93, line: 75, baseType: !44, size: 64, offset: 64)
!355 = !DILocation(line: 151, column: 24, scope: !339)
!356 = !DILocation(line: 153, column: 14, scope: !339)
!357 = !DILocation(line: 153, column: 12, scope: !339)
!358 = !DILocation(line: 154, column: 5, scope: !339)
!359 = !DILocation(line: 156, column: 32, scope: !339)
!360 = !DILocation(line: 156, column: 14, scope: !339)
!361 = !DILocation(line: 156, column: 12, scope: !339)
!362 = !DILocation(line: 157, column: 5, scope: !339)
!363 = !DILocation(line: 159, column: 14, scope: !339)
!364 = !DILocation(line: 159, column: 12, scope: !339)
!365 = !DILocation(line: 160, column: 5, scope: !339)
!366 = !DILocation(line: 161, column: 1, scope: !339)
!367 = distinct !DISubprogram(name: "cond_destroy", scope: !2, file: !2, line: 163, type: !340, scopeLine: 164, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!368 = !DILocalVariable(name: "cond", arg: 1, scope: !367, file: !2, line: 163, type: !342)
!369 = !DILocation(line: 163, column: 35, scope: !367)
!370 = !DILocalVariable(name: "status", scope: !367, file: !2, line: 165, type: !143)
!371 = !DILocation(line: 165, column: 9, scope: !367)
!372 = !DILocation(line: 165, column: 39, scope: !367)
!373 = !DILocation(line: 165, column: 18, scope: !367)
!374 = !DILocation(line: 166, column: 5, scope: !367)
!375 = !DILocation(line: 167, column: 1, scope: !367)
!376 = distinct !DISubprogram(name: "cond_signal", scope: !2, file: !2, line: 169, type: !340, scopeLine: 170, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!377 = !DILocalVariable(name: "cond", arg: 1, scope: !376, file: !2, line: 169, type: !342)
!378 = !DILocation(line: 169, column: 34, scope: !376)
!379 = !DILocalVariable(name: "status", scope: !376, file: !2, line: 171, type: !143)
!380 = !DILocation(line: 171, column: 9, scope: !376)
!381 = !DILocation(line: 171, column: 38, scope: !376)
!382 = !DILocation(line: 171, column: 18, scope: !376)
!383 = !DILocation(line: 172, column: 5, scope: !376)
!384 = !DILocation(line: 173, column: 1, scope: !376)
!385 = distinct !DISubprogram(name: "cond_broadcast", scope: !2, file: !2, line: 175, type: !340, scopeLine: 176, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!386 = !DILocalVariable(name: "cond", arg: 1, scope: !385, file: !2, line: 175, type: !342)
!387 = !DILocation(line: 175, column: 37, scope: !385)
!388 = !DILocalVariable(name: "status", scope: !385, file: !2, line: 177, type: !143)
!389 = !DILocation(line: 177, column: 9, scope: !385)
!390 = !DILocation(line: 177, column: 41, scope: !385)
!391 = !DILocation(line: 177, column: 18, scope: !385)
!392 = !DILocation(line: 178, column: 5, scope: !385)
!393 = !DILocation(line: 179, column: 1, scope: !385)
!394 = distinct !DISubprogram(name: "cond_wait", scope: !2, file: !2, line: 181, type: !395, scopeLine: 182, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!395 = !DISubroutineType(types: !396)
!396 = !{null, !342, !200}
!397 = !DILocalVariable(name: "cond", arg: 1, scope: !394, file: !2, line: 181, type: !342)
!398 = !DILocation(line: 181, column: 32, scope: !394)
!399 = !DILocalVariable(name: "lock", arg: 2, scope: !394, file: !2, line: 181, type: !200)
!400 = !DILocation(line: 181, column: 55, scope: !394)
!401 = !DILocalVariable(name: "status", scope: !394, file: !2, line: 183, type: !143)
!402 = !DILocation(line: 183, column: 9, scope: !394)
!403 = !DILocation(line: 183, column: 36, scope: !394)
!404 = !DILocation(line: 183, column: 42, scope: !394)
!405 = !DILocation(line: 183, column: 18, scope: !394)
!406 = !DILocation(line: 185, column: 1, scope: !394)
!407 = distinct !DISubprogram(name: "cond_timedwait", scope: !2, file: !2, line: 187, type: !408, scopeLine: 188, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!408 = !DISubroutineType(types: !409)
!409 = !{null, !342, !200, !410}
!410 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!411 = !DILocalVariable(name: "cond", arg: 1, scope: !407, file: !2, line: 187, type: !342)
!412 = !DILocation(line: 187, column: 37, scope: !407)
!413 = !DILocalVariable(name: "lock", arg: 2, scope: !407, file: !2, line: 187, type: !200)
!414 = !DILocation(line: 187, column: 60, scope: !407)
!415 = !DILocalVariable(name: "millis", arg: 3, scope: !407, file: !2, line: 187, type: !410)
!416 = !DILocation(line: 187, column: 76, scope: !407)
!417 = !DILocalVariable(name: "ts", scope: !407, file: !2, line: 190, type: !418)
!418 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !419, line: 33, size: 128, elements: !420)
!419 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_types/_timespec.h", directory: "")
!420 = !{!421, !424}
!421 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !418, file: !419, line: 35, baseType: !422, size: 64)
!422 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_time_t", file: !423, line: 98, baseType: !97)
!423 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/arm/_types.h", directory: "")
!424 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !418, file: !419, line: 36, baseType: !97, size: 64, offset: 64)
!425 = !DILocation(line: 190, column: 21, scope: !407)
!426 = !DILocation(line: 194, column: 11, scope: !407)
!427 = !DILocalVariable(name: "status", scope: !407, file: !2, line: 195, type: !143)
!428 = !DILocation(line: 195, column: 9, scope: !407)
!429 = !DILocation(line: 195, column: 41, scope: !407)
!430 = !DILocation(line: 195, column: 47, scope: !407)
!431 = !DILocation(line: 195, column: 18, scope: !407)
!432 = !DILocation(line: 196, column: 1, scope: !407)
!433 = distinct !DISubprogram(name: "cond_worker", scope: !2, file: !2, line: 202, type: !155, scopeLine: 203, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!434 = !DILocalVariable(name: "message", arg: 1, scope: !433, file: !2, line: 202, type: !64)
!435 = !DILocation(line: 202, column: 25, scope: !433)
!436 = !DILocalVariable(name: "idle", scope: !433, file: !2, line: 204, type: !286)
!437 = !DILocation(line: 204, column: 10, scope: !433)
!438 = !DILocation(line: 206, column: 9, scope: !439)
!439 = distinct !DILexicalBlock(scope: !433, file: !2, line: 205, column: 5)
!440 = !DILocation(line: 207, column: 9, scope: !439)
!441 = !DILocation(line: 208, column: 9, scope: !439)
!442 = !DILocation(line: 209, column: 9, scope: !439)
!443 = !DILocation(line: 210, column: 16, scope: !439)
!444 = !DILocation(line: 210, column: 22, scope: !439)
!445 = !DILocation(line: 210, column: 14, scope: !439)
!446 = !DILocation(line: 211, column: 9, scope: !439)
!447 = !DILocation(line: 213, column: 9, scope: !448)
!448 = distinct !DILexicalBlock(scope: !433, file: !2, line: 213, column: 9)
!449 = !DILocation(line: 213, column: 9, scope: !433)
!450 = !DILocation(line: 214, column: 25, scope: !448)
!451 = !DILocation(line: 214, column: 34, scope: !448)
!452 = !DILocation(line: 214, column: 9, scope: !448)
!453 = !DILocation(line: 215, column: 10, scope: !433)
!454 = !DILocation(line: 217, column: 9, scope: !455)
!455 = distinct !DILexicalBlock(scope: !433, file: !2, line: 216, column: 5)
!456 = !DILocation(line: 218, column: 9, scope: !455)
!457 = !DILocation(line: 219, column: 9, scope: !455)
!458 = !DILocation(line: 220, column: 9, scope: !455)
!459 = !DILocation(line: 221, column: 16, scope: !455)
!460 = !DILocation(line: 221, column: 22, scope: !455)
!461 = !DILocation(line: 221, column: 14, scope: !455)
!462 = !DILocation(line: 222, column: 9, scope: !455)
!463 = !DILocation(line: 224, column: 9, scope: !464)
!464 = distinct !DILexicalBlock(scope: !433, file: !2, line: 224, column: 9)
!465 = !DILocation(line: 224, column: 9, scope: !433)
!466 = !DILocation(line: 225, column: 25, scope: !464)
!467 = !DILocation(line: 225, column: 34, scope: !464)
!468 = !DILocation(line: 225, column: 9, scope: !464)
!469 = !DILocation(line: 226, column: 12, scope: !433)
!470 = !DILocation(line: 226, column: 5, scope: !433)
!471 = !DILocation(line: 227, column: 1, scope: !433)
!472 = distinct !DISubprogram(name: "cond_test", scope: !2, file: !2, line: 229, type: !306, scopeLine: 230, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!473 = !DILocalVariable(name: "message", scope: !472, file: !2, line: 231, type: !64)
!474 = !DILocation(line: 231, column: 11, scope: !472)
!475 = !DILocation(line: 232, column: 5, scope: !472)
!476 = !DILocation(line: 233, column: 5, scope: !472)
!477 = !DILocalVariable(name: "worker", scope: !472, file: !2, line: 235, type: !116)
!478 = !DILocation(line: 235, column: 15, scope: !472)
!479 = !DILocation(line: 235, column: 51, scope: !472)
!480 = !DILocation(line: 235, column: 24, scope: !472)
!481 = !DILocation(line: 238, column: 9, scope: !482)
!482 = distinct !DILexicalBlock(scope: !472, file: !2, line: 237, column: 5)
!483 = !DILocation(line: 239, column: 9, scope: !482)
!484 = !DILocation(line: 240, column: 9, scope: !482)
!485 = !DILocation(line: 241, column: 9, scope: !482)
!486 = !DILocation(line: 245, column: 9, scope: !487)
!487 = distinct !DILexicalBlock(scope: !472, file: !2, line: 244, column: 5)
!488 = !DILocation(line: 246, column: 9, scope: !487)
!489 = !DILocation(line: 247, column: 9, scope: !487)
!490 = !DILocation(line: 248, column: 9, scope: !487)
!491 = !DILocalVariable(name: "result", scope: !472, file: !2, line: 251, type: !64)
!492 = !DILocation(line: 251, column: 11, scope: !472)
!493 = !DILocation(line: 251, column: 32, scope: !472)
!494 = !DILocation(line: 251, column: 20, scope: !472)
!495 = !DILocation(line: 254, column: 5, scope: !472)
!496 = !DILocation(line: 255, column: 5, scope: !472)
!497 = !DILocation(line: 256, column: 1, scope: !472)
!498 = distinct !DISubprogram(name: "rwlock_init", scope: !2, file: !2, line: 263, type: !499, scopeLine: 264, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!499 = !DISubroutineType(types: !500)
!500 = !{null, !501, !143}
!501 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !502, size: 64)
!502 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlock_t", file: !503, line: 31, baseType: !504)
!503 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_rwlock_t.h", directory: "")
!504 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_rwlock_t", file: !93, line: 116, baseType: !505)
!505 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_rwlock_t", file: !93, line: 93, size: 1600, elements: !506)
!506 = !{!507, !508}
!507 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !505, file: !93, line: 94, baseType: !97, size: 64)
!508 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !505, file: !93, line: 95, baseType: !509, size: 1536, offset: 64)
!509 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 1536, elements: !510)
!510 = !{!511}
!511 = !DISubrange(count: 192)
!512 = !DILocalVariable(name: "lock", arg: 1, scope: !498, file: !2, line: 263, type: !501)
!513 = !DILocation(line: 263, column: 36, scope: !498)
!514 = !DILocalVariable(name: "shared", arg: 2, scope: !498, file: !2, line: 263, type: !143)
!515 = !DILocation(line: 263, column: 46, scope: !498)
!516 = !DILocalVariable(name: "status", scope: !498, file: !2, line: 265, type: !143)
!517 = !DILocation(line: 265, column: 9, scope: !498)
!518 = !DILocalVariable(name: "value", scope: !498, file: !2, line: 266, type: !143)
!519 = !DILocation(line: 266, column: 9, scope: !498)
!520 = !DILocalVariable(name: "attributes", scope: !498, file: !2, line: 267, type: !521)
!521 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlockattr_t", file: !522, line: 31, baseType: !523)
!522 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_rwlockattr_t.h", directory: "")
!523 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_rwlockattr_t", file: !93, line: 117, baseType: !524)
!524 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_rwlockattr_t", file: !93, line: 98, size: 192, elements: !525)
!525 = !{!526, !527}
!526 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !524, file: !93, line: 99, baseType: !97, size: 64)
!527 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !524, file: !93, line: 100, baseType: !528, size: 128, offset: 64)
!528 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 128, elements: !529)
!529 = !{!530}
!530 = !DISubrange(count: 16)
!531 = !DILocation(line: 267, column: 26, scope: !498)
!532 = !DILocation(line: 268, column: 14, scope: !498)
!533 = !DILocation(line: 268, column: 12, scope: !498)
!534 = !DILocation(line: 269, column: 5, scope: !498)
!535 = !DILocation(line: 271, column: 57, scope: !498)
!536 = !DILocation(line: 271, column: 14, scope: !498)
!537 = !DILocation(line: 271, column: 12, scope: !498)
!538 = !DILocation(line: 272, column: 5, scope: !498)
!539 = !DILocation(line: 273, column: 14, scope: !498)
!540 = !DILocation(line: 273, column: 12, scope: !498)
!541 = !DILocation(line: 274, column: 5, scope: !498)
!542 = !DILocation(line: 276, column: 34, scope: !498)
!543 = !DILocation(line: 276, column: 14, scope: !498)
!544 = !DILocation(line: 276, column: 12, scope: !498)
!545 = !DILocation(line: 277, column: 5, scope: !498)
!546 = !DILocation(line: 278, column: 14, scope: !498)
!547 = !DILocation(line: 278, column: 12, scope: !498)
!548 = !DILocation(line: 279, column: 5, scope: !498)
!549 = !DILocation(line: 280, column: 1, scope: !498)
!550 = distinct !DISubprogram(name: "rwlock_destroy", scope: !2, file: !2, line: 282, type: !551, scopeLine: 283, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!551 = !DISubroutineType(types: !552)
!552 = !{null, !501}
!553 = !DILocalVariable(name: "lock", arg: 1, scope: !550, file: !2, line: 282, type: !501)
!554 = !DILocation(line: 282, column: 39, scope: !550)
!555 = !DILocalVariable(name: "status", scope: !550, file: !2, line: 284, type: !143)
!556 = !DILocation(line: 284, column: 9, scope: !550)
!557 = !DILocation(line: 284, column: 41, scope: !550)
!558 = !DILocation(line: 284, column: 18, scope: !550)
!559 = !DILocation(line: 285, column: 5, scope: !550)
!560 = !DILocation(line: 286, column: 1, scope: !550)
!561 = distinct !DISubprogram(name: "rwlock_wrlock", scope: !2, file: !2, line: 288, type: !551, scopeLine: 289, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!562 = !DILocalVariable(name: "lock", arg: 1, scope: !561, file: !2, line: 288, type: !501)
!563 = !DILocation(line: 288, column: 38, scope: !561)
!564 = !DILocalVariable(name: "status", scope: !561, file: !2, line: 290, type: !143)
!565 = !DILocation(line: 290, column: 9, scope: !561)
!566 = !DILocation(line: 290, column: 40, scope: !561)
!567 = !DILocation(line: 290, column: 18, scope: !561)
!568 = !DILocation(line: 291, column: 5, scope: !561)
!569 = !DILocation(line: 292, column: 1, scope: !561)
!570 = distinct !DISubprogram(name: "rwlock_trywrlock", scope: !2, file: !2, line: 294, type: !571, scopeLine: 295, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!571 = !DISubroutineType(types: !572)
!572 = !{!286, !501}
!573 = !DILocalVariable(name: "lock", arg: 1, scope: !570, file: !2, line: 294, type: !501)
!574 = !DILocation(line: 294, column: 41, scope: !570)
!575 = !DILocalVariable(name: "status", scope: !570, file: !2, line: 296, type: !143)
!576 = !DILocation(line: 296, column: 9, scope: !570)
!577 = !DILocation(line: 296, column: 43, scope: !570)
!578 = !DILocation(line: 296, column: 18, scope: !570)
!579 = !DILocation(line: 298, column: 12, scope: !570)
!580 = !DILocation(line: 298, column: 19, scope: !570)
!581 = !DILocation(line: 298, column: 5, scope: !570)
!582 = distinct !DISubprogram(name: "rwlock_rdlock", scope: !2, file: !2, line: 301, type: !551, scopeLine: 302, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!583 = !DILocalVariable(name: "lock", arg: 1, scope: !582, file: !2, line: 301, type: !501)
!584 = !DILocation(line: 301, column: 38, scope: !582)
!585 = !DILocalVariable(name: "status", scope: !582, file: !2, line: 303, type: !143)
!586 = !DILocation(line: 303, column: 9, scope: !582)
!587 = !DILocation(line: 303, column: 40, scope: !582)
!588 = !DILocation(line: 303, column: 18, scope: !582)
!589 = !DILocation(line: 304, column: 5, scope: !582)
!590 = !DILocation(line: 305, column: 1, scope: !582)
!591 = distinct !DISubprogram(name: "rwlock_tryrdlock", scope: !2, file: !2, line: 307, type: !571, scopeLine: 308, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!592 = !DILocalVariable(name: "lock", arg: 1, scope: !591, file: !2, line: 307, type: !501)
!593 = !DILocation(line: 307, column: 41, scope: !591)
!594 = !DILocalVariable(name: "status", scope: !591, file: !2, line: 309, type: !143)
!595 = !DILocation(line: 309, column: 9, scope: !591)
!596 = !DILocation(line: 309, column: 43, scope: !591)
!597 = !DILocation(line: 309, column: 18, scope: !591)
!598 = !DILocation(line: 311, column: 12, scope: !591)
!599 = !DILocation(line: 311, column: 19, scope: !591)
!600 = !DILocation(line: 311, column: 5, scope: !591)
!601 = distinct !DISubprogram(name: "rwlock_unlock", scope: !2, file: !2, line: 314, type: !551, scopeLine: 315, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!602 = !DILocalVariable(name: "lock", arg: 1, scope: !601, file: !2, line: 314, type: !501)
!603 = !DILocation(line: 314, column: 38, scope: !601)
!604 = !DILocalVariable(name: "status", scope: !601, file: !2, line: 316, type: !143)
!605 = !DILocation(line: 316, column: 9, scope: !601)
!606 = !DILocation(line: 316, column: 40, scope: !601)
!607 = !DILocation(line: 316, column: 18, scope: !601)
!608 = !DILocation(line: 317, column: 5, scope: !601)
!609 = !DILocation(line: 318, column: 1, scope: !601)
!610 = distinct !DISubprogram(name: "rwlock_test", scope: !2, file: !2, line: 320, type: !306, scopeLine: 321, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!611 = !DILocalVariable(name: "lock", scope: !610, file: !2, line: 322, type: !502)
!612 = !DILocation(line: 322, column: 22, scope: !610)
!613 = !DILocation(line: 323, column: 5, scope: !610)
!614 = !DILocalVariable(name: "test_depth", scope: !610, file: !2, line: 324, type: !615)
!615 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !143)
!616 = !DILocation(line: 324, column: 15, scope: !610)
!617 = !DILocation(line: 327, column: 9, scope: !618)
!618 = distinct !DILexicalBlock(scope: !610, file: !2, line: 326, column: 5)
!619 = !DILocalVariable(name: "success", scope: !618, file: !2, line: 328, type: !286)
!620 = !DILocation(line: 328, column: 14, scope: !618)
!621 = !DILocation(line: 328, column: 24, scope: !618)
!622 = !DILocation(line: 329, column: 9, scope: !618)
!623 = !DILocation(line: 330, column: 19, scope: !618)
!624 = !DILocation(line: 330, column: 17, scope: !618)
!625 = !DILocation(line: 331, column: 9, scope: !618)
!626 = !DILocation(line: 332, column: 9, scope: !618)
!627 = !DILocation(line: 336, column: 9, scope: !628)
!628 = distinct !DILexicalBlock(scope: !610, file: !2, line: 335, column: 5)
!629 = !DILocalVariable(name: "i", scope: !630, file: !2, line: 337, type: !143)
!630 = distinct !DILexicalBlock(scope: !628, file: !2, line: 337, column: 9)
!631 = !DILocation(line: 337, column: 18, scope: !630)
!632 = !DILocation(line: 337, column: 14, scope: !630)
!633 = !DILocation(line: 337, column: 25, scope: !634)
!634 = distinct !DILexicalBlock(scope: !630, file: !2, line: 337, column: 9)
!635 = !DILocation(line: 337, column: 27, scope: !634)
!636 = !DILocation(line: 337, column: 9, scope: !630)
!637 = !DILocalVariable(name: "success", scope: !638, file: !2, line: 339, type: !286)
!638 = distinct !DILexicalBlock(scope: !634, file: !2, line: 338, column: 9)
!639 = !DILocation(line: 339, column: 18, scope: !638)
!640 = !DILocation(line: 339, column: 28, scope: !638)
!641 = !DILocation(line: 340, column: 13, scope: !638)
!642 = !DILocation(line: 341, column: 9, scope: !638)
!643 = !DILocation(line: 337, column: 42, scope: !634)
!644 = !DILocation(line: 337, column: 9, scope: !634)
!645 = distinct !{!645, !636, !646, !647}
!646 = !DILocation(line: 341, column: 9, scope: !630)
!647 = !{!"llvm.loop.mustprogress"}
!648 = !DILocalVariable(name: "success", scope: !649, file: !2, line: 344, type: !286)
!649 = distinct !DILexicalBlock(scope: !628, file: !2, line: 343, column: 9)
!650 = !DILocation(line: 344, column: 18, scope: !649)
!651 = !DILocation(line: 344, column: 28, scope: !649)
!652 = !DILocation(line: 345, column: 13, scope: !649)
!653 = !DILocation(line: 348, column: 9, scope: !628)
!654 = !DILocalVariable(name: "i", scope: !655, file: !2, line: 349, type: !143)
!655 = distinct !DILexicalBlock(scope: !628, file: !2, line: 349, column: 9)
!656 = !DILocation(line: 349, column: 18, scope: !655)
!657 = !DILocation(line: 349, column: 14, scope: !655)
!658 = !DILocation(line: 349, column: 25, scope: !659)
!659 = distinct !DILexicalBlock(scope: !655, file: !2, line: 349, column: 9)
!660 = !DILocation(line: 349, column: 27, scope: !659)
!661 = !DILocation(line: 349, column: 9, scope: !655)
!662 = !DILocation(line: 350, column: 13, scope: !663)
!663 = distinct !DILexicalBlock(scope: !659, file: !2, line: 349, column: 46)
!664 = !DILocation(line: 351, column: 9, scope: !663)
!665 = !DILocation(line: 349, column: 42, scope: !659)
!666 = !DILocation(line: 349, column: 9, scope: !659)
!667 = distinct !{!667, !661, !668, !647}
!668 = !DILocation(line: 351, column: 9, scope: !655)
!669 = !DILocation(line: 355, column: 9, scope: !670)
!670 = distinct !DILexicalBlock(scope: !610, file: !2, line: 354, column: 5)
!671 = !DILocalVariable(name: "success", scope: !670, file: !2, line: 356, type: !286)
!672 = !DILocation(line: 356, column: 14, scope: !670)
!673 = !DILocation(line: 356, column: 24, scope: !670)
!674 = !DILocation(line: 357, column: 9, scope: !670)
!675 = !DILocation(line: 358, column: 9, scope: !670)
!676 = !DILocation(line: 361, column: 5, scope: !610)
!677 = !DILocation(line: 362, column: 1, scope: !610)
!678 = distinct !DISubprogram(name: "key_destroy", scope: !2, file: !2, line: 369, type: !129, scopeLine: 370, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!679 = !DILocalVariable(name: "unused_value", arg: 1, scope: !678, file: !2, line: 369, type: !64)
!680 = !DILocation(line: 369, column: 24, scope: !678)
!681 = !DILocation(line: 371, column: 21, scope: !678)
!682 = !DILocation(line: 371, column: 19, scope: !678)
!683 = !DILocation(line: 372, column: 1, scope: !678)
!684 = distinct !DISubprogram(name: "key_worker", scope: !2, file: !2, line: 374, type: !155, scopeLine: 375, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!685 = !DILocalVariable(name: "message", arg: 1, scope: !684, file: !2, line: 374, type: !64)
!686 = !DILocation(line: 374, column: 24, scope: !684)
!687 = !DILocalVariable(name: "my_secret", scope: !684, file: !2, line: 376, type: !143)
!688 = !DILocation(line: 376, column: 9, scope: !684)
!689 = !DILocalVariable(name: "status", scope: !684, file: !2, line: 378, type: !143)
!690 = !DILocation(line: 378, column: 9, scope: !684)
!691 = !DILocation(line: 378, column: 38, scope: !684)
!692 = !DILocation(line: 378, column: 18, scope: !684)
!693 = !DILocation(line: 379, column: 5, scope: !684)
!694 = !DILocalVariable(name: "my_local_data", scope: !684, file: !2, line: 381, type: !64)
!695 = !DILocation(line: 381, column: 11, scope: !684)
!696 = !DILocation(line: 381, column: 47, scope: !684)
!697 = !DILocation(line: 381, column: 27, scope: !684)
!698 = !DILocation(line: 382, column: 5, scope: !684)
!699 = !DILocation(line: 384, column: 12, scope: !684)
!700 = !DILocation(line: 384, column: 5, scope: !684)
!701 = distinct !DISubprogram(name: "key_test", scope: !2, file: !2, line: 387, type: !306, scopeLine: 388, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!702 = !DILocalVariable(name: "my_secret", scope: !701, file: !2, line: 389, type: !143)
!703 = !DILocation(line: 389, column: 9, scope: !701)
!704 = !DILocalVariable(name: "message", scope: !701, file: !2, line: 390, type: !64)
!705 = !DILocation(line: 390, column: 11, scope: !701)
!706 = !DILocalVariable(name: "status", scope: !701, file: !2, line: 391, type: !143)
!707 = !DILocation(line: 391, column: 9, scope: !701)
!708 = !DILocation(line: 393, column: 5, scope: !701)
!709 = !DILocalVariable(name: "worker", scope: !701, file: !2, line: 395, type: !116)
!710 = !DILocation(line: 395, column: 15, scope: !701)
!711 = !DILocation(line: 395, column: 50, scope: !701)
!712 = !DILocation(line: 395, column: 24, scope: !701)
!713 = !DILocation(line: 397, column: 34, scope: !701)
!714 = !DILocation(line: 397, column: 14, scope: !701)
!715 = !DILocation(line: 397, column: 12, scope: !701)
!716 = !DILocation(line: 398, column: 5, scope: !701)
!717 = !DILocalVariable(name: "my_local_data", scope: !701, file: !2, line: 400, type: !64)
!718 = !DILocation(line: 400, column: 11, scope: !701)
!719 = !DILocation(line: 400, column: 47, scope: !701)
!720 = !DILocation(line: 400, column: 27, scope: !701)
!721 = !DILocation(line: 401, column: 5, scope: !701)
!722 = !DILocation(line: 403, column: 34, scope: !701)
!723 = !DILocation(line: 403, column: 14, scope: !701)
!724 = !DILocation(line: 403, column: 12, scope: !701)
!725 = !DILocation(line: 404, column: 5, scope: !701)
!726 = !DILocalVariable(name: "result", scope: !701, file: !2, line: 406, type: !64)
!727 = !DILocation(line: 406, column: 11, scope: !701)
!728 = !DILocation(line: 406, column: 32, scope: !701)
!729 = !DILocation(line: 406, column: 20, scope: !701)
!730 = !DILocation(line: 409, column: 33, scope: !701)
!731 = !DILocation(line: 409, column: 14, scope: !701)
!732 = !DILocation(line: 409, column: 12, scope: !701)
!733 = !DILocation(line: 410, column: 5, scope: !701)
!734 = !DILocation(line: 413, column: 1, scope: !701)
!735 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 415, type: !736, scopeLine: 416, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !157)
!736 = !DISubroutineType(types: !737)
!737 = !{!143}
!738 = !DILocation(line: 417, column: 5, scope: !735)
!739 = !DILocation(line: 418, column: 5, scope: !735)
!740 = !DILocation(line: 419, column: 5, scope: !735)
!741 = !DILocation(line: 420, column: 5, scope: !735)
!742 = !DILocation(line: 421, column: 1, scope: !735)
