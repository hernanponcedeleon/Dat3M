; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/pthread.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/pthread.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_mutex_t = type { i64, [56 x i8] }
%struct._opaque_pthread_cond_t = type { i64, [40 x i8] }
%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }
%struct._opaque_pthread_mutexattr_t = type { i64, [8 x i8] }
%struct._opaque_pthread_condattr_t = type { i64, [8 x i8] }
%struct.timespec = type { i64, i64 }
%struct._opaque_pthread_rwlock_t = type { i64, [192 x i8] }
%struct._opaque_pthread_rwlockattr_t = type { i64, [16 x i8] }

@__func__.thread_create = private unnamed_addr constant [14 x i8] c"thread_create\00", align 1
@.str = private unnamed_addr constant [10 x i8] c"pthread.c\00", align 1
@.str.1 = private unnamed_addr constant [12 x i8] c"status == 0\00", align 1
@__func__.thread_join = private unnamed_addr constant [12 x i8] c"thread_join\00", align 1
@__func__.mutex_init = private unnamed_addr constant [11 x i8] c"mutex_init\00", align 1
@__func__.mutex_destroy = private unnamed_addr constant [14 x i8] c"mutex_destroy\00", align 1
@__func__.mutex_lock = private unnamed_addr constant [11 x i8] c"mutex_lock\00", align 1
@__func__.mutex_unlock = private unnamed_addr constant [13 x i8] c"mutex_unlock\00", align 1
@__func__.mutex_test = private unnamed_addr constant [11 x i8] c"mutex_test\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"!success\00", align 1
@.str.3 = private unnamed_addr constant [8 x i8] c"success\00", align 1
@__func__.cond_init = private unnamed_addr constant [10 x i8] c"cond_init\00", align 1
@__func__.cond_destroy = private unnamed_addr constant [13 x i8] c"cond_destroy\00", align 1
@__func__.cond_signal = private unnamed_addr constant [12 x i8] c"cond_signal\00", align 1
@__func__.cond_broadcast = private unnamed_addr constant [15 x i8] c"cond_broadcast\00", align 1
@phase = global i32 0, align 4, !dbg !0
@cond_mutex = global %struct._opaque_pthread_mutex_t zeroinitializer, align 8, !dbg !9
@cond = global %struct._opaque_pthread_cond_t zeroinitializer, align 8, !dbg !24
@__func__.cond_test = private unnamed_addr constant [10 x i8] c"cond_test\00", align 1
@.str.4 = private unnamed_addr constant [18 x i8] c"result == message\00", align 1
@__func__.rwlock_init = private unnamed_addr constant [12 x i8] c"rwlock_init\00", align 1
@__func__.rwlock_destroy = private unnamed_addr constant [15 x i8] c"rwlock_destroy\00", align 1
@__func__.rwlock_wrlock = private unnamed_addr constant [14 x i8] c"rwlock_wrlock\00", align 1
@__func__.rwlock_rdlock = private unnamed_addr constant [14 x i8] c"rwlock_rdlock\00", align 1
@__func__.rwlock_unlock = private unnamed_addr constant [14 x i8] c"rwlock_unlock\00", align 1
@__func__.rwlock_test = private unnamed_addr constant [12 x i8] c"rwlock_test\00", align 1
@latest_thread = global %struct._opaque_pthread_t* null, align 8, !dbg !36
@local_data = global i64 0, align 8, !dbg !59
@__func__.key_worker = private unnamed_addr constant [11 x i8] c"key_worker\00", align 1
@.str.5 = private unnamed_addr constant [28 x i8] c"my_local_data == &my_secret\00", align 1
@__func__.key_test = private unnamed_addr constant [9 x i8] c"key_test\00", align 1

; Function Attrs: noinline nounwind ssp uwtable
define %struct._opaque_pthread_t* @thread_create(i8* (i8*)* noundef %0, i8* noundef %1) #0 !dbg !77 {
  %3 = alloca i8* (i8*)*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca %struct._opaque_pthread_t*, align 8
  %6 = alloca %struct._opaque_pthread_attr_t, align 8
  %7 = alloca i32, align 4
  store i8* (i8*)* %0, i8* (i8*)** %3, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %3, metadata !84, metadata !DIExpression()), !dbg !85
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !86, metadata !DIExpression()), !dbg !87
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %5, metadata !88, metadata !DIExpression()), !dbg !89
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_attr_t* %6, metadata !90, metadata !DIExpression()), !dbg !98
  %8 = call i32 @pthread_attr_init(%struct._opaque_pthread_attr_t* noundef %6), !dbg !99
  call void @llvm.dbg.declare(metadata i32* %7, metadata !100, metadata !DIExpression()), !dbg !101
  %9 = load i8* (i8*)*, i8* (i8*)** %3, align 8, !dbg !102
  %10 = load i8*, i8** %4, align 8, !dbg !103
  %11 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %5, %struct._opaque_pthread_attr_t* noundef %6, i8* (i8*)* noundef %9, i8* noundef %10), !dbg !104
  store i32 %11, i32* %7, align 4, !dbg !101
  %12 = load i32, i32* %7, align 4, !dbg !105
  %13 = icmp eq i32 %12, 0, !dbg !105
  %14 = xor i1 %13, true, !dbg !105
  %15 = zext i1 %14 to i32, !dbg !105
  %16 = sext i32 %15 to i64, !dbg !105
  %17 = icmp ne i64 %16, 0, !dbg !105
  br i1 %17, label %18, label %20, !dbg !105

18:                                               ; preds = %2
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @__func__.thread_create, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 18, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !105
  unreachable, !dbg !105

19:                                               ; No predecessors!
  br label %21, !dbg !105

20:                                               ; preds = %2
  br label %21, !dbg !105

21:                                               ; preds = %20, %19
  %22 = call i32 @pthread_attr_destroy(%struct._opaque_pthread_attr_t* noundef %6), !dbg !106
  %23 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %5, align 8, !dbg !107
  ret %struct._opaque_pthread_t* %23, !dbg !108
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @pthread_attr_init(%struct._opaque_pthread_attr_t* noundef) #2

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

declare i32 @pthread_attr_destroy(%struct._opaque_pthread_attr_t* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread_join(%struct._opaque_pthread_t* noundef %0) #0 !dbg !109 {
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i32, align 4
  store %struct._opaque_pthread_t* %0, %struct._opaque_pthread_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !112, metadata !DIExpression()), !dbg !113
  call void @llvm.dbg.declare(metadata i8** %3, metadata !114, metadata !DIExpression()), !dbg !115
  call void @llvm.dbg.declare(metadata i32* %4, metadata !116, metadata !DIExpression()), !dbg !117
  %5 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %2, align 8, !dbg !118
  %6 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %5, i8** noundef %3), !dbg !119
  store i32 %6, i32* %4, align 4, !dbg !117
  %7 = load i32, i32* %4, align 4, !dbg !120
  %8 = icmp eq i32 %7, 0, !dbg !120
  %9 = xor i1 %8, true, !dbg !120
  %10 = zext i1 %9 to i32, !dbg !120
  %11 = sext i32 %10 to i64, !dbg !120
  %12 = icmp ne i64 %11, 0, !dbg !120
  br i1 %12, label %13, label %15, !dbg !120

13:                                               ; preds = %1
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @__func__.thread_join, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 27, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !120
  unreachable, !dbg !120

14:                                               ; No predecessors!
  br label %16, !dbg !120

15:                                               ; preds = %1
  br label %16, !dbg !120

16:                                               ; preds = %15, %14
  %17 = load i8*, i8** %3, align 8, !dbg !121
  ret i8* %17, !dbg !122
}

declare i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef, i8** noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_init(%struct._opaque_pthread_mutex_t* noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) #0 !dbg !123 {
  %6 = alloca %struct._opaque_pthread_mutex_t*, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca %struct._opaque_pthread_mutexattr_t, align 8
  store %struct._opaque_pthread_mutex_t* %0, %struct._opaque_pthread_mutex_t** %6, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_mutex_t** %6, metadata !127, metadata !DIExpression()), !dbg !128
  store i32 %1, i32* %7, align 4
  call void @llvm.dbg.declare(metadata i32* %7, metadata !129, metadata !DIExpression()), !dbg !130
  store i32 %2, i32* %8, align 4
  call void @llvm.dbg.declare(metadata i32* %8, metadata !131, metadata !DIExpression()), !dbg !132
  store i32 %3, i32* %9, align 4
  call void @llvm.dbg.declare(metadata i32* %9, metadata !133, metadata !DIExpression()), !dbg !134
  store i32 %4, i32* %10, align 4
  call void @llvm.dbg.declare(metadata i32* %10, metadata !135, metadata !DIExpression()), !dbg !136
  call void @llvm.dbg.declare(metadata i32* %11, metadata !137, metadata !DIExpression()), !dbg !138
  call void @llvm.dbg.declare(metadata i32* %12, metadata !139, metadata !DIExpression()), !dbg !140
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_mutexattr_t* %13, metadata !141, metadata !DIExpression()), !dbg !152
  %14 = call i32 @pthread_mutexattr_init(%struct._opaque_pthread_mutexattr_t* noundef %13), !dbg !153
  store i32 %14, i32* %11, align 4, !dbg !154
  %15 = load i32, i32* %11, align 4, !dbg !155
  %16 = icmp eq i32 %15, 0, !dbg !155
  %17 = xor i1 %16, true, !dbg !155
  %18 = zext i1 %17 to i32, !dbg !155
  %19 = sext i32 %18 to i64, !dbg !155
  %20 = icmp ne i64 %19, 0, !dbg !155
  br i1 %20, label %21, label %23, !dbg !155

21:                                               ; preds = %5
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__func__.mutex_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 49, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !155
  unreachable, !dbg !155

22:                                               ; No predecessors!
  br label %24, !dbg !155

23:                                               ; preds = %5
  br label %24, !dbg !155

24:                                               ; preds = %23, %22
  %25 = load i32, i32* %7, align 4, !dbg !156
  %26 = call i32 @pthread_mutexattr_settype(%struct._opaque_pthread_mutexattr_t* noundef %13, i32 noundef %25), !dbg !157
  store i32 %26, i32* %11, align 4, !dbg !158
  %27 = load i32, i32* %11, align 4, !dbg !159
  %28 = icmp eq i32 %27, 0, !dbg !159
  %29 = xor i1 %28, true, !dbg !159
  %30 = zext i1 %29 to i32, !dbg !159
  %31 = sext i32 %30 to i64, !dbg !159
  %32 = icmp ne i64 %31, 0, !dbg !159
  br i1 %32, label %33, label %35, !dbg !159

33:                                               ; preds = %24
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__func__.mutex_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 52, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !159
  unreachable, !dbg !159

34:                                               ; No predecessors!
  br label %36, !dbg !159

35:                                               ; preds = %24
  br label %36, !dbg !159

36:                                               ; preds = %35, %34
  %37 = call i32 @pthread_mutexattr_gettype(%struct._opaque_pthread_mutexattr_t* noundef %13, i32* noundef %12), !dbg !160
  store i32 %37, i32* %11, align 4, !dbg !161
  %38 = load i32, i32* %11, align 4, !dbg !162
  %39 = icmp eq i32 %38, 0, !dbg !162
  %40 = xor i1 %39, true, !dbg !162
  %41 = zext i1 %40 to i32, !dbg !162
  %42 = sext i32 %41 to i64, !dbg !162
  %43 = icmp ne i64 %42, 0, !dbg !162
  br i1 %43, label %44, label %46, !dbg !162

44:                                               ; preds = %36
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__func__.mutex_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 54, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !162
  unreachable, !dbg !162

45:                                               ; No predecessors!
  br label %47, !dbg !162

46:                                               ; preds = %36
  br label %47, !dbg !162

47:                                               ; preds = %46, %45
  %48 = load i32, i32* %8, align 4, !dbg !163
  %49 = call i32 @pthread_mutexattr_setprotocol(%struct._opaque_pthread_mutexattr_t* noundef %13, i32 noundef %48), !dbg !164
  store i32 %49, i32* %11, align 4, !dbg !165
  %50 = load i32, i32* %11, align 4, !dbg !166
  %51 = icmp eq i32 %50, 0, !dbg !166
  %52 = xor i1 %51, true, !dbg !166
  %53 = zext i1 %52 to i32, !dbg !166
  %54 = sext i32 %53 to i64, !dbg !166
  %55 = icmp ne i64 %54, 0, !dbg !166
  br i1 %55, label %56, label %58, !dbg !166

56:                                               ; preds = %47
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__func__.mutex_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 57, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !166
  unreachable, !dbg !166

57:                                               ; No predecessors!
  br label %59, !dbg !166

58:                                               ; preds = %47
  br label %59, !dbg !166

59:                                               ; preds = %58, %57
  %60 = call i32 @pthread_mutexattr_getprotocol(%struct._opaque_pthread_mutexattr_t* noundef %13, i32* noundef %12), !dbg !167
  store i32 %60, i32* %11, align 4, !dbg !168
  %61 = load i32, i32* %11, align 4, !dbg !169
  %62 = icmp eq i32 %61, 0, !dbg !169
  %63 = xor i1 %62, true, !dbg !169
  %64 = zext i1 %63 to i32, !dbg !169
  %65 = sext i32 %64 to i64, !dbg !169
  %66 = icmp ne i64 %65, 0, !dbg !169
  br i1 %66, label %67, label %69, !dbg !169

67:                                               ; preds = %59
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__func__.mutex_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 59, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !169
  unreachable, !dbg !169

68:                                               ; No predecessors!
  br label %70, !dbg !169

69:                                               ; preds = %59
  br label %70, !dbg !169

70:                                               ; preds = %69, %68
  %71 = load i32, i32* %9, align 4, !dbg !170
  %72 = call i32 @pthread_mutexattr_setpolicy_np(%struct._opaque_pthread_mutexattr_t* noundef %13, i32 noundef %71), !dbg !171
  store i32 %72, i32* %11, align 4, !dbg !172
  %73 = load i32, i32* %11, align 4, !dbg !173
  %74 = icmp eq i32 %73, 0, !dbg !173
  %75 = xor i1 %74, true, !dbg !173
  %76 = zext i1 %75 to i32, !dbg !173
  %77 = sext i32 %76 to i64, !dbg !173
  %78 = icmp ne i64 %77, 0, !dbg !173
  br i1 %78, label %79, label %81, !dbg !173

79:                                               ; preds = %70
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__func__.mutex_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 62, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !173
  unreachable, !dbg !173

80:                                               ; No predecessors!
  br label %82, !dbg !173

81:                                               ; preds = %70
  br label %82, !dbg !173

82:                                               ; preds = %81, %80
  %83 = call i32 @pthread_mutexattr_getpolicy_np(%struct._opaque_pthread_mutexattr_t* noundef %13, i32* noundef %12), !dbg !174
  store i32 %83, i32* %11, align 4, !dbg !175
  %84 = load i32, i32* %11, align 4, !dbg !176
  %85 = icmp eq i32 %84, 0, !dbg !176
  %86 = xor i1 %85, true, !dbg !176
  %87 = zext i1 %86 to i32, !dbg !176
  %88 = sext i32 %87 to i64, !dbg !176
  %89 = icmp ne i64 %88, 0, !dbg !176
  br i1 %89, label %90, label %92, !dbg !176

90:                                               ; preds = %82
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__func__.mutex_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 64, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !176
  unreachable, !dbg !176

91:                                               ; No predecessors!
  br label %93, !dbg !176

92:                                               ; preds = %82
  br label %93, !dbg !176

93:                                               ; preds = %92, %91
  %94 = load i32, i32* %10, align 4, !dbg !177
  %95 = call i32 @pthread_mutexattr_setprioceiling(%struct._opaque_pthread_mutexattr_t* noundef %13, i32 noundef %94), !dbg !178
  store i32 %95, i32* %11, align 4, !dbg !179
  %96 = load i32, i32* %11, align 4, !dbg !180
  %97 = icmp eq i32 %96, 0, !dbg !180
  %98 = xor i1 %97, true, !dbg !180
  %99 = zext i1 %98 to i32, !dbg !180
  %100 = sext i32 %99 to i64, !dbg !180
  %101 = icmp ne i64 %100, 0, !dbg !180
  br i1 %101, label %102, label %104, !dbg !180

102:                                              ; preds = %93
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__func__.mutex_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 67, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !180
  unreachable, !dbg !180

103:                                              ; No predecessors!
  br label %105, !dbg !180

104:                                              ; preds = %93
  br label %105, !dbg !180

105:                                              ; preds = %104, %103
  %106 = call i32 @pthread_mutexattr_getprioceiling(%struct._opaque_pthread_mutexattr_t* noundef %13, i32* noundef %12), !dbg !181
  store i32 %106, i32* %11, align 4, !dbg !182
  %107 = load i32, i32* %11, align 4, !dbg !183
  %108 = icmp eq i32 %107, 0, !dbg !183
  %109 = xor i1 %108, true, !dbg !183
  %110 = zext i1 %109 to i32, !dbg !183
  %111 = sext i32 %110 to i64, !dbg !183
  %112 = icmp ne i64 %111, 0, !dbg !183
  br i1 %112, label %113, label %115, !dbg !183

113:                                              ; preds = %105
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__func__.mutex_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 69, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !183
  unreachable, !dbg !183

114:                                              ; No predecessors!
  br label %116, !dbg !183

115:                                              ; preds = %105
  br label %116, !dbg !183

116:                                              ; preds = %115, %114
  %117 = load %struct._opaque_pthread_mutex_t*, %struct._opaque_pthread_mutex_t** %6, align 8, !dbg !184
  %118 = call i32 @pthread_mutex_init(%struct._opaque_pthread_mutex_t* noundef %117, %struct._opaque_pthread_mutexattr_t* noundef %13), !dbg !185
  store i32 %118, i32* %11, align 4, !dbg !186
  %119 = load i32, i32* %11, align 4, !dbg !187
  %120 = icmp eq i32 %119, 0, !dbg !187
  %121 = xor i1 %120, true, !dbg !187
  %122 = zext i1 %121 to i32, !dbg !187
  %123 = sext i32 %122 to i64, !dbg !187
  %124 = icmp ne i64 %123, 0, !dbg !187
  br i1 %124, label %125, label %127, !dbg !187

125:                                              ; preds = %116
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__func__.mutex_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 72, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !187
  unreachable, !dbg !187

126:                                              ; No predecessors!
  br label %128, !dbg !187

127:                                              ; preds = %116
  br label %128, !dbg !187

128:                                              ; preds = %127, %126
  %129 = call i32 @"\01_pthread_mutexattr_destroy"(%struct._opaque_pthread_mutexattr_t* noundef %13), !dbg !188
  store i32 %129, i32* %11, align 4, !dbg !189
  %130 = load i32, i32* %11, align 4, !dbg !190
  %131 = icmp eq i32 %130, 0, !dbg !190
  %132 = xor i1 %131, true, !dbg !190
  %133 = zext i1 %132 to i32, !dbg !190
  %134 = sext i32 %133 to i64, !dbg !190
  %135 = icmp ne i64 %134, 0, !dbg !190
  br i1 %135, label %136, label %138, !dbg !190

136:                                              ; preds = %128
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__func__.mutex_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 74, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !190
  unreachable, !dbg !190

137:                                              ; No predecessors!
  br label %139, !dbg !190

138:                                              ; preds = %128
  br label %139, !dbg !190

139:                                              ; preds = %138, %137
  ret void, !dbg !191
}

declare i32 @pthread_mutexattr_init(%struct._opaque_pthread_mutexattr_t* noundef) #2

declare i32 @pthread_mutexattr_settype(%struct._opaque_pthread_mutexattr_t* noundef, i32 noundef) #2

declare i32 @pthread_mutexattr_gettype(%struct._opaque_pthread_mutexattr_t* noundef, i32* noundef) #2

declare i32 @pthread_mutexattr_setprotocol(%struct._opaque_pthread_mutexattr_t* noundef, i32 noundef) #2

declare i32 @pthread_mutexattr_getprotocol(%struct._opaque_pthread_mutexattr_t* noundef, i32* noundef) #2

declare i32 @pthread_mutexattr_setpolicy_np(%struct._opaque_pthread_mutexattr_t* noundef, i32 noundef) #2

declare i32 @pthread_mutexattr_getpolicy_np(%struct._opaque_pthread_mutexattr_t* noundef, i32* noundef) #2

declare i32 @pthread_mutexattr_setprioceiling(%struct._opaque_pthread_mutexattr_t* noundef, i32 noundef) #2

declare i32 @pthread_mutexattr_getprioceiling(%struct._opaque_pthread_mutexattr_t* noundef, i32* noundef) #2

declare i32 @pthread_mutex_init(%struct._opaque_pthread_mutex_t* noundef, %struct._opaque_pthread_mutexattr_t* noundef) #2

declare i32 @"\01_pthread_mutexattr_destroy"(%struct._opaque_pthread_mutexattr_t* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_destroy(%struct._opaque_pthread_mutex_t* noundef %0) #0 !dbg !192 {
  %2 = alloca %struct._opaque_pthread_mutex_t*, align 8
  %3 = alloca i32, align 4
  store %struct._opaque_pthread_mutex_t* %0, %struct._opaque_pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_mutex_t** %2, metadata !195, metadata !DIExpression()), !dbg !196
  call void @llvm.dbg.declare(metadata i32* %3, metadata !197, metadata !DIExpression()), !dbg !198
  %4 = load %struct._opaque_pthread_mutex_t*, %struct._opaque_pthread_mutex_t** %2, align 8, !dbg !199
  %5 = call i32 @pthread_mutex_destroy(%struct._opaque_pthread_mutex_t* noundef %4), !dbg !200
  store i32 %5, i32* %3, align 4, !dbg !198
  %6 = load i32, i32* %3, align 4, !dbg !201
  %7 = icmp eq i32 %6, 0, !dbg !201
  %8 = xor i1 %7, true, !dbg !201
  %9 = zext i1 %8 to i32, !dbg !201
  %10 = sext i32 %9 to i64, !dbg !201
  %11 = icmp ne i64 %10, 0, !dbg !201
  br i1 %11, label %12, label %14, !dbg !201

12:                                               ; preds = %1
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @__func__.mutex_destroy, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 80, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !201
  unreachable, !dbg !201

13:                                               ; No predecessors!
  br label %15, !dbg !201

14:                                               ; preds = %1
  br label %15, !dbg !201

15:                                               ; preds = %14, %13
  ret void, !dbg !202
}

declare i32 @pthread_mutex_destroy(%struct._opaque_pthread_mutex_t* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_lock(%struct._opaque_pthread_mutex_t* noundef %0) #0 !dbg !203 {
  %2 = alloca %struct._opaque_pthread_mutex_t*, align 8
  %3 = alloca i32, align 4
  store %struct._opaque_pthread_mutex_t* %0, %struct._opaque_pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_mutex_t** %2, metadata !204, metadata !DIExpression()), !dbg !205
  call void @llvm.dbg.declare(metadata i32* %3, metadata !206, metadata !DIExpression()), !dbg !207
  %4 = load %struct._opaque_pthread_mutex_t*, %struct._opaque_pthread_mutex_t** %2, align 8, !dbg !208
  %5 = call i32 @pthread_mutex_lock(%struct._opaque_pthread_mutex_t* noundef %4), !dbg !209
  store i32 %5, i32* %3, align 4, !dbg !207
  %6 = load i32, i32* %3, align 4, !dbg !210
  %7 = icmp eq i32 %6, 0, !dbg !210
  %8 = xor i1 %7, true, !dbg !210
  %9 = zext i1 %8 to i32, !dbg !210
  %10 = sext i32 %9 to i64, !dbg !210
  %11 = icmp ne i64 %10, 0, !dbg !210
  br i1 %11, label %12, label %14, !dbg !210

12:                                               ; preds = %1
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__func__.mutex_lock, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 86, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !210
  unreachable, !dbg !210

13:                                               ; No predecessors!
  br label %15, !dbg !210

14:                                               ; preds = %1
  br label %15, !dbg !210

15:                                               ; preds = %14, %13
  ret void, !dbg !211
}

declare i32 @pthread_mutex_lock(%struct._opaque_pthread_mutex_t* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define zeroext i1 @mutex_trylock(%struct._opaque_pthread_mutex_t* noundef %0) #0 !dbg !212 {
  %2 = alloca %struct._opaque_pthread_mutex_t*, align 8
  %3 = alloca i32, align 4
  store %struct._opaque_pthread_mutex_t* %0, %struct._opaque_pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_mutex_t** %2, metadata !216, metadata !DIExpression()), !dbg !217
  call void @llvm.dbg.declare(metadata i32* %3, metadata !218, metadata !DIExpression()), !dbg !219
  %4 = load %struct._opaque_pthread_mutex_t*, %struct._opaque_pthread_mutex_t** %2, align 8, !dbg !220
  %5 = call i32 @pthread_mutex_trylock(%struct._opaque_pthread_mutex_t* noundef %4), !dbg !221
  store i32 %5, i32* %3, align 4, !dbg !219
  %6 = load i32, i32* %3, align 4, !dbg !222
  %7 = icmp eq i32 %6, 0, !dbg !223
  ret i1 %7, !dbg !224
}

declare i32 @pthread_mutex_trylock(%struct._opaque_pthread_mutex_t* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_unlock(%struct._opaque_pthread_mutex_t* noundef %0) #0 !dbg !225 {
  %2 = alloca %struct._opaque_pthread_mutex_t*, align 8
  %3 = alloca i32, align 4
  store %struct._opaque_pthread_mutex_t* %0, %struct._opaque_pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_mutex_t** %2, metadata !226, metadata !DIExpression()), !dbg !227
  call void @llvm.dbg.declare(metadata i32* %3, metadata !228, metadata !DIExpression()), !dbg !229
  %4 = load %struct._opaque_pthread_mutex_t*, %struct._opaque_pthread_mutex_t** %2, align 8, !dbg !230
  %5 = call i32 @pthread_mutex_unlock(%struct._opaque_pthread_mutex_t* noundef %4), !dbg !231
  store i32 %5, i32* %3, align 4, !dbg !229
  %6 = load i32, i32* %3, align 4, !dbg !232
  %7 = icmp eq i32 %6, 0, !dbg !232
  %8 = xor i1 %7, true, !dbg !232
  %9 = zext i1 %8 to i32, !dbg !232
  %10 = sext i32 %9 to i64, !dbg !232
  %11 = icmp ne i64 %10, 0, !dbg !232
  br i1 %11, label %12, label %14, !dbg !232

12:                                               ; preds = %1
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @__func__.mutex_unlock, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 99, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !232
  unreachable, !dbg !232

13:                                               ; No predecessors!
  br label %15, !dbg !232

14:                                               ; preds = %1
  br label %15, !dbg !232

15:                                               ; preds = %14, %13
  ret void, !dbg !233
}

declare i32 @pthread_mutex_unlock(%struct._opaque_pthread_mutex_t* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @mutex_test() #0 !dbg !234 {
  %1 = alloca %struct._opaque_pthread_mutex_t, align 8
  %2 = alloca %struct._opaque_pthread_mutex_t, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  %5 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_mutex_t* %1, metadata !237, metadata !DIExpression()), !dbg !238
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_mutex_t* %2, metadata !239, metadata !DIExpression()), !dbg !240
  call void @mutex_init(%struct._opaque_pthread_mutex_t* noundef %1, i32 noundef 1, i32 noundef 1, i32 noundef 1, i32 noundef 1), !dbg !241
  call void @mutex_init(%struct._opaque_pthread_mutex_t* noundef %2, i32 noundef 2, i32 noundef 2, i32 noundef 3, i32 noundef 2), !dbg !242
  call void @mutex_lock(%struct._opaque_pthread_mutex_t* noundef %1), !dbg !243
  call void @llvm.dbg.declare(metadata i8* %3, metadata !245, metadata !DIExpression()), !dbg !246
  %6 = call zeroext i1 @mutex_trylock(%struct._opaque_pthread_mutex_t* noundef %1), !dbg !247
  %7 = zext i1 %6 to i8, !dbg !246
  store i8 %7, i8* %3, align 1, !dbg !246
  %8 = load i8, i8* %3, align 1, !dbg !248
  %9 = trunc i8 %8 to i1, !dbg !248
  %10 = xor i1 %9, true, !dbg !248
  %11 = xor i1 %10, true, !dbg !248
  %12 = zext i1 %11 to i32, !dbg !248
  %13 = sext i32 %12 to i64, !dbg !248
  %14 = icmp ne i64 %13, 0, !dbg !248
  br i1 %14, label %15, label %17, !dbg !248

15:                                               ; preds = %0
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__func__.mutex_test, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 113, i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0)) #4, !dbg !248
  unreachable, !dbg !248

16:                                               ; No predecessors!
  br label %18, !dbg !248

17:                                               ; preds = %0
  br label %18, !dbg !248

18:                                               ; preds = %17, %16
  call void @mutex_unlock(%struct._opaque_pthread_mutex_t* noundef %1), !dbg !249
  call void @mutex_lock(%struct._opaque_pthread_mutex_t* noundef %2), !dbg !250
  call void @llvm.dbg.declare(metadata i8* %4, metadata !252, metadata !DIExpression()), !dbg !254
  %19 = call zeroext i1 @mutex_trylock(%struct._opaque_pthread_mutex_t* noundef %1), !dbg !255
  %20 = zext i1 %19 to i8, !dbg !254
  store i8 %20, i8* %4, align 1, !dbg !254
  %21 = load i8, i8* %4, align 1, !dbg !256
  %22 = trunc i8 %21 to i1, !dbg !256
  %23 = xor i1 %22, true, !dbg !256
  %24 = zext i1 %23 to i32, !dbg !256
  %25 = sext i32 %24 to i64, !dbg !256
  %26 = icmp ne i64 %25, 0, !dbg !256
  br i1 %26, label %27, label %29, !dbg !256

27:                                               ; preds = %18
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__func__.mutex_test, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 122, i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.3, i64 0, i64 0)) #4, !dbg !256
  unreachable, !dbg !256

28:                                               ; No predecessors!
  br label %30, !dbg !256

29:                                               ; preds = %18
  br label %30, !dbg !256

30:                                               ; preds = %29, %28
  call void @mutex_unlock(%struct._opaque_pthread_mutex_t* noundef %1), !dbg !257
  call void @llvm.dbg.declare(metadata i8* %5, metadata !258, metadata !DIExpression()), !dbg !260
  %31 = call zeroext i1 @mutex_trylock(%struct._opaque_pthread_mutex_t* noundef %1), !dbg !261
  %32 = zext i1 %31 to i8, !dbg !260
  store i8 %32, i8* %5, align 1, !dbg !260
  %33 = load i8, i8* %5, align 1, !dbg !262
  %34 = trunc i8 %33 to i1, !dbg !262
  %35 = xor i1 %34, true, !dbg !262
  %36 = zext i1 %35 to i32, !dbg !262
  %37 = sext i32 %36 to i64, !dbg !262
  %38 = icmp ne i64 %37, 0, !dbg !262
  br i1 %38, label %39, label %41, !dbg !262

39:                                               ; preds = %30
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__func__.mutex_test, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 128, i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.3, i64 0, i64 0)) #4, !dbg !262
  unreachable, !dbg !262

40:                                               ; No predecessors!
  br label %42, !dbg !262

41:                                               ; preds = %30
  br label %42, !dbg !262

42:                                               ; preds = %41, %40
  call void @mutex_unlock(%struct._opaque_pthread_mutex_t* noundef %1), !dbg !263
  call void @mutex_unlock(%struct._opaque_pthread_mutex_t* noundef %2), !dbg !264
  call void @mutex_destroy(%struct._opaque_pthread_mutex_t* noundef %2), !dbg !265
  call void @mutex_destroy(%struct._opaque_pthread_mutex_t* noundef %1), !dbg !266
  ret void, !dbg !267
}

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_init(%struct._opaque_pthread_cond_t* noundef %0) #0 !dbg !268 {
  %2 = alloca %struct._opaque_pthread_cond_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca %struct._opaque_pthread_condattr_t, align 8
  store %struct._opaque_pthread_cond_t* %0, %struct._opaque_pthread_cond_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_cond_t** %2, metadata !272, metadata !DIExpression()), !dbg !273
  call void @llvm.dbg.declare(metadata i32* %3, metadata !274, metadata !DIExpression()), !dbg !275
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_condattr_t* %4, metadata !276, metadata !DIExpression()), !dbg !284
  %5 = call i32 @pthread_condattr_init(%struct._opaque_pthread_condattr_t* noundef %4), !dbg !285
  store i32 %5, i32* %3, align 4, !dbg !286
  %6 = load i32, i32* %3, align 4, !dbg !287
  %7 = icmp eq i32 %6, 0, !dbg !287
  %8 = xor i1 %7, true, !dbg !287
  %9 = zext i1 %8 to i32, !dbg !287
  %10 = sext i32 %9 to i64, !dbg !287
  %11 = icmp ne i64 %10, 0, !dbg !287
  br i1 %11, label %12, label %14, !dbg !287

12:                                               ; preds = %1
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.cond_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 154, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !287
  unreachable, !dbg !287

13:                                               ; No predecessors!
  br label %15, !dbg !287

14:                                               ; preds = %1
  br label %15, !dbg !287

15:                                               ; preds = %14, %13
  %16 = load %struct._opaque_pthread_cond_t*, %struct._opaque_pthread_cond_t** %2, align 8, !dbg !288
  %17 = call i32 @"\01_pthread_cond_init"(%struct._opaque_pthread_cond_t* noundef %16, %struct._opaque_pthread_condattr_t* noundef %4), !dbg !289
  store i32 %17, i32* %3, align 4, !dbg !290
  %18 = load i32, i32* %3, align 4, !dbg !291
  %19 = icmp eq i32 %18, 0, !dbg !291
  %20 = xor i1 %19, true, !dbg !291
  %21 = zext i1 %20 to i32, !dbg !291
  %22 = sext i32 %21 to i64, !dbg !291
  %23 = icmp ne i64 %22, 0, !dbg !291
  br i1 %23, label %24, label %26, !dbg !291

24:                                               ; preds = %15
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.cond_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 157, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !291
  unreachable, !dbg !291

25:                                               ; No predecessors!
  br label %27, !dbg !291

26:                                               ; preds = %15
  br label %27, !dbg !291

27:                                               ; preds = %26, %25
  %28 = call i32 @pthread_condattr_destroy(%struct._opaque_pthread_condattr_t* noundef %4), !dbg !292
  store i32 %28, i32* %3, align 4, !dbg !293
  %29 = load i32, i32* %3, align 4, !dbg !294
  %30 = icmp eq i32 %29, 0, !dbg !294
  %31 = xor i1 %30, true, !dbg !294
  %32 = zext i1 %31 to i32, !dbg !294
  %33 = sext i32 %32 to i64, !dbg !294
  %34 = icmp ne i64 %33, 0, !dbg !294
  br i1 %34, label %35, label %37, !dbg !294

35:                                               ; preds = %27
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.cond_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 160, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !294
  unreachable, !dbg !294

36:                                               ; No predecessors!
  br label %38, !dbg !294

37:                                               ; preds = %27
  br label %38, !dbg !294

38:                                               ; preds = %37, %36
  ret void, !dbg !295
}

declare i32 @pthread_condattr_init(%struct._opaque_pthread_condattr_t* noundef) #2

declare i32 @"\01_pthread_cond_init"(%struct._opaque_pthread_cond_t* noundef, %struct._opaque_pthread_condattr_t* noundef) #2

declare i32 @pthread_condattr_destroy(%struct._opaque_pthread_condattr_t* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_destroy(%struct._opaque_pthread_cond_t* noundef %0) #0 !dbg !296 {
  %2 = alloca %struct._opaque_pthread_cond_t*, align 8
  %3 = alloca i32, align 4
  store %struct._opaque_pthread_cond_t* %0, %struct._opaque_pthread_cond_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_cond_t** %2, metadata !297, metadata !DIExpression()), !dbg !298
  call void @llvm.dbg.declare(metadata i32* %3, metadata !299, metadata !DIExpression()), !dbg !300
  %4 = load %struct._opaque_pthread_cond_t*, %struct._opaque_pthread_cond_t** %2, align 8, !dbg !301
  %5 = call i32 @pthread_cond_destroy(%struct._opaque_pthread_cond_t* noundef %4), !dbg !302
  store i32 %5, i32* %3, align 4, !dbg !300
  %6 = load i32, i32* %3, align 4, !dbg !303
  %7 = icmp eq i32 %6, 0, !dbg !303
  %8 = xor i1 %7, true, !dbg !303
  %9 = zext i1 %8 to i32, !dbg !303
  %10 = sext i32 %9 to i64, !dbg !303
  %11 = icmp ne i64 %10, 0, !dbg !303
  br i1 %11, label %12, label %14, !dbg !303

12:                                               ; preds = %1
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @__func__.cond_destroy, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 166, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !303
  unreachable, !dbg !303

13:                                               ; No predecessors!
  br label %15, !dbg !303

14:                                               ; preds = %1
  br label %15, !dbg !303

15:                                               ; preds = %14, %13
  ret void, !dbg !304
}

declare i32 @pthread_cond_destroy(%struct._opaque_pthread_cond_t* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_signal(%struct._opaque_pthread_cond_t* noundef %0) #0 !dbg !305 {
  %2 = alloca %struct._opaque_pthread_cond_t*, align 8
  %3 = alloca i32, align 4
  store %struct._opaque_pthread_cond_t* %0, %struct._opaque_pthread_cond_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_cond_t** %2, metadata !306, metadata !DIExpression()), !dbg !307
  call void @llvm.dbg.declare(metadata i32* %3, metadata !308, metadata !DIExpression()), !dbg !309
  %4 = load %struct._opaque_pthread_cond_t*, %struct._opaque_pthread_cond_t** %2, align 8, !dbg !310
  %5 = call i32 @pthread_cond_signal(%struct._opaque_pthread_cond_t* noundef %4), !dbg !311
  store i32 %5, i32* %3, align 4, !dbg !309
  %6 = load i32, i32* %3, align 4, !dbg !312
  %7 = icmp eq i32 %6, 0, !dbg !312
  %8 = xor i1 %7, true, !dbg !312
  %9 = zext i1 %8 to i32, !dbg !312
  %10 = sext i32 %9 to i64, !dbg !312
  %11 = icmp ne i64 %10, 0, !dbg !312
  br i1 %11, label %12, label %14, !dbg !312

12:                                               ; preds = %1
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @__func__.cond_signal, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 172, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !312
  unreachable, !dbg !312

13:                                               ; No predecessors!
  br label %15, !dbg !312

14:                                               ; preds = %1
  br label %15, !dbg !312

15:                                               ; preds = %14, %13
  ret void, !dbg !313
}

declare i32 @pthread_cond_signal(%struct._opaque_pthread_cond_t* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_broadcast(%struct._opaque_pthread_cond_t* noundef %0) #0 !dbg !314 {
  %2 = alloca %struct._opaque_pthread_cond_t*, align 8
  %3 = alloca i32, align 4
  store %struct._opaque_pthread_cond_t* %0, %struct._opaque_pthread_cond_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_cond_t** %2, metadata !315, metadata !DIExpression()), !dbg !316
  call void @llvm.dbg.declare(metadata i32* %3, metadata !317, metadata !DIExpression()), !dbg !318
  %4 = load %struct._opaque_pthread_cond_t*, %struct._opaque_pthread_cond_t** %2, align 8, !dbg !319
  %5 = call i32 @pthread_cond_broadcast(%struct._opaque_pthread_cond_t* noundef %4), !dbg !320
  store i32 %5, i32* %3, align 4, !dbg !318
  %6 = load i32, i32* %3, align 4, !dbg !321
  %7 = icmp eq i32 %6, 0, !dbg !321
  %8 = xor i1 %7, true, !dbg !321
  %9 = zext i1 %8 to i32, !dbg !321
  %10 = sext i32 %9 to i64, !dbg !321
  %11 = icmp ne i64 %10, 0, !dbg !321
  br i1 %11, label %12, label %14, !dbg !321

12:                                               ; preds = %1
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__func__.cond_broadcast, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 178, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !321
  unreachable, !dbg !321

13:                                               ; No predecessors!
  br label %15, !dbg !321

14:                                               ; preds = %1
  br label %15, !dbg !321

15:                                               ; preds = %14, %13
  ret void, !dbg !322
}

declare i32 @pthread_cond_broadcast(%struct._opaque_pthread_cond_t* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_wait(%struct._opaque_pthread_cond_t* noundef %0, %struct._opaque_pthread_mutex_t* noundef %1) #0 !dbg !323 {
  %3 = alloca %struct._opaque_pthread_cond_t*, align 8
  %4 = alloca %struct._opaque_pthread_mutex_t*, align 8
  %5 = alloca i32, align 4
  store %struct._opaque_pthread_cond_t* %0, %struct._opaque_pthread_cond_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_cond_t** %3, metadata !326, metadata !DIExpression()), !dbg !327
  store %struct._opaque_pthread_mutex_t* %1, %struct._opaque_pthread_mutex_t** %4, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_mutex_t** %4, metadata !328, metadata !DIExpression()), !dbg !329
  call void @llvm.dbg.declare(metadata i32* %5, metadata !330, metadata !DIExpression()), !dbg !331
  %6 = load %struct._opaque_pthread_cond_t*, %struct._opaque_pthread_cond_t** %3, align 8, !dbg !332
  %7 = load %struct._opaque_pthread_mutex_t*, %struct._opaque_pthread_mutex_t** %4, align 8, !dbg !333
  %8 = call i32 @"\01_pthread_cond_wait"(%struct._opaque_pthread_cond_t* noundef %6, %struct._opaque_pthread_mutex_t* noundef %7), !dbg !334
  store i32 %8, i32* %5, align 4, !dbg !331
  ret void, !dbg !335
}

declare i32 @"\01_pthread_cond_wait"(%struct._opaque_pthread_cond_t* noundef, %struct._opaque_pthread_mutex_t* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_timedwait(%struct._opaque_pthread_cond_t* noundef %0, %struct._opaque_pthread_mutex_t* noundef %1, i64 noundef %2) #0 !dbg !336 {
  %4 = alloca %struct._opaque_pthread_cond_t*, align 8
  %5 = alloca %struct._opaque_pthread_mutex_t*, align 8
  %6 = alloca i64, align 8
  %7 = alloca %struct.timespec, align 8
  %8 = alloca i32, align 4
  store %struct._opaque_pthread_cond_t* %0, %struct._opaque_pthread_cond_t** %4, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_cond_t** %4, metadata !340, metadata !DIExpression()), !dbg !341
  store %struct._opaque_pthread_mutex_t* %1, %struct._opaque_pthread_mutex_t** %5, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_mutex_t** %5, metadata !342, metadata !DIExpression()), !dbg !343
  store i64 %2, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !344, metadata !DIExpression()), !dbg !345
  call void @llvm.dbg.declare(metadata %struct.timespec* %7, metadata !346, metadata !DIExpression()), !dbg !354
  %9 = load i64, i64* %6, align 8, !dbg !355
  call void @llvm.dbg.declare(metadata i32* %8, metadata !356, metadata !DIExpression()), !dbg !357
  %10 = load %struct._opaque_pthread_cond_t*, %struct._opaque_pthread_cond_t** %4, align 8, !dbg !358
  %11 = load %struct._opaque_pthread_mutex_t*, %struct._opaque_pthread_mutex_t** %5, align 8, !dbg !359
  %12 = call i32 @"\01_pthread_cond_timedwait"(%struct._opaque_pthread_cond_t* noundef %10, %struct._opaque_pthread_mutex_t* noundef %11, %struct.timespec* noundef %7), !dbg !360
  store i32 %12, i32* %8, align 4, !dbg !357
  ret void, !dbg !361
}

declare i32 @"\01_pthread_cond_timedwait"(%struct._opaque_pthread_cond_t* noundef, %struct._opaque_pthread_mutex_t* noundef, %struct.timespec* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i8* @cond_worker(i8* noundef %0) #0 !dbg !362 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i8, align 1
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !363, metadata !DIExpression()), !dbg !364
  call void @llvm.dbg.declare(metadata i8* %4, metadata !365, metadata !DIExpression()), !dbg !366
  store i8 1, i8* %4, align 1, !dbg !366
  call void @mutex_lock(%struct._opaque_pthread_mutex_t* noundef @cond_mutex), !dbg !367
  %5 = load i32, i32* @phase, align 4, !dbg !369
  %6 = add nsw i32 %5, 1, !dbg !369
  store i32 %6, i32* @phase, align 4, !dbg !369
  call void @cond_wait(%struct._opaque_pthread_cond_t* noundef @cond, %struct._opaque_pthread_mutex_t* noundef @cond_mutex), !dbg !370
  %7 = load i32, i32* @phase, align 4, !dbg !371
  %8 = add nsw i32 %7, 1, !dbg !371
  store i32 %8, i32* @phase, align 4, !dbg !371
  %9 = load i32, i32* @phase, align 4, !dbg !372
  %10 = icmp slt i32 %9, 2, !dbg !373
  %11 = zext i1 %10 to i8, !dbg !374
  store i8 %11, i8* %4, align 1, !dbg !374
  call void @mutex_unlock(%struct._opaque_pthread_mutex_t* noundef @cond_mutex), !dbg !375
  %12 = load i8, i8* %4, align 1, !dbg !376
  %13 = trunc i8 %12 to i1, !dbg !376
  br i1 %13, label %14, label %17, !dbg !378

14:                                               ; preds = %1
  %15 = load i8*, i8** %3, align 8, !dbg !379
  %16 = getelementptr inbounds i8, i8* %15, i64 1, !dbg !380
  store i8* %16, i8** %2, align 8, !dbg !381
  br label %32, !dbg !381

17:                                               ; preds = %1
  store i8 1, i8* %4, align 1, !dbg !382
  call void @mutex_lock(%struct._opaque_pthread_mutex_t* noundef @cond_mutex), !dbg !383
  %18 = load i32, i32* @phase, align 4, !dbg !385
  %19 = add nsw i32 %18, 1, !dbg !385
  store i32 %19, i32* @phase, align 4, !dbg !385
  call void @cond_timedwait(%struct._opaque_pthread_cond_t* noundef @cond, %struct._opaque_pthread_mutex_t* noundef @cond_mutex, i64 noundef 10), !dbg !386
  %20 = load i32, i32* @phase, align 4, !dbg !387
  %21 = add nsw i32 %20, 1, !dbg !387
  store i32 %21, i32* @phase, align 4, !dbg !387
  %22 = load i32, i32* @phase, align 4, !dbg !388
  %23 = icmp sgt i32 %22, 6, !dbg !389
  %24 = zext i1 %23 to i8, !dbg !390
  store i8 %24, i8* %4, align 1, !dbg !390
  call void @mutex_unlock(%struct._opaque_pthread_mutex_t* noundef @cond_mutex), !dbg !391
  %25 = load i8, i8* %4, align 1, !dbg !392
  %26 = trunc i8 %25 to i1, !dbg !392
  br i1 %26, label %27, label %30, !dbg !394

27:                                               ; preds = %17
  %28 = load i8*, i8** %3, align 8, !dbg !395
  %29 = getelementptr inbounds i8, i8* %28, i64 2, !dbg !396
  store i8* %29, i8** %2, align 8, !dbg !397
  br label %32, !dbg !397

30:                                               ; preds = %17
  %31 = load i8*, i8** %3, align 8, !dbg !398
  store i8* %31, i8** %2, align 8, !dbg !399
  br label %32, !dbg !399

32:                                               ; preds = %30, %27, %14
  %33 = load i8*, i8** %2, align 8, !dbg !400
  ret i8* %33, !dbg !400
}

; Function Attrs: noinline nounwind ssp uwtable
define void @cond_test() #0 !dbg !401 {
  %1 = alloca i8*, align 8
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca i8*, align 8
  call void @llvm.dbg.declare(metadata i8** %1, metadata !402, metadata !DIExpression()), !dbg !403
  store i8* inttoptr (i64 42 to i8*), i8** %1, align 8, !dbg !403
  call void @mutex_init(%struct._opaque_pthread_mutex_t* noundef @cond_mutex, i32 noundef 0, i32 noundef 0, i32 noundef 3, i32 noundef 0), !dbg !404
  call void @cond_init(%struct._opaque_pthread_cond_t* noundef @cond), !dbg !405
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !406, metadata !DIExpression()), !dbg !407
  %4 = load i8*, i8** %1, align 8, !dbg !408
  %5 = call %struct._opaque_pthread_t* @thread_create(i8* (i8*)* noundef @cond_worker, i8* noundef %4), !dbg !409
  store %struct._opaque_pthread_t* %5, %struct._opaque_pthread_t** %2, align 8, !dbg !407
  call void @mutex_lock(%struct._opaque_pthread_mutex_t* noundef @cond_mutex), !dbg !410
  %6 = load i32, i32* @phase, align 4, !dbg !412
  %7 = add nsw i32 %6, 1, !dbg !412
  store i32 %7, i32* @phase, align 4, !dbg !412
  call void @cond_signal(%struct._opaque_pthread_cond_t* noundef @cond), !dbg !413
  call void @mutex_unlock(%struct._opaque_pthread_mutex_t* noundef @cond_mutex), !dbg !414
  call void @mutex_lock(%struct._opaque_pthread_mutex_t* noundef @cond_mutex), !dbg !415
  %8 = load i32, i32* @phase, align 4, !dbg !417
  %9 = add nsw i32 %8, 1, !dbg !417
  store i32 %9, i32* @phase, align 4, !dbg !417
  call void @cond_broadcast(%struct._opaque_pthread_cond_t* noundef @cond), !dbg !418
  call void @mutex_unlock(%struct._opaque_pthread_mutex_t* noundef @cond_mutex), !dbg !419
  call void @llvm.dbg.declare(metadata i8** %3, metadata !420, metadata !DIExpression()), !dbg !421
  %10 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %2, align 8, !dbg !422
  %11 = call i8* @thread_join(%struct._opaque_pthread_t* noundef %10), !dbg !423
  store i8* %11, i8** %3, align 8, !dbg !421
  %12 = load i8*, i8** %3, align 8, !dbg !424
  %13 = load i8*, i8** %1, align 8, !dbg !424
  %14 = icmp eq i8* %12, %13, !dbg !424
  %15 = xor i1 %14, true, !dbg !424
  %16 = zext i1 %15 to i32, !dbg !424
  %17 = sext i32 %16 to i64, !dbg !424
  %18 = icmp ne i64 %17, 0, !dbg !424
  br i1 %18, label %19, label %21, !dbg !424

19:                                               ; preds = %0
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.cond_test, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 252, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str.4, i64 0, i64 0)) #4, !dbg !424
  unreachable, !dbg !424

20:                                               ; No predecessors!
  br label %22, !dbg !424

21:                                               ; preds = %0
  br label %22, !dbg !424

22:                                               ; preds = %21, %20
  call void @cond_destroy(%struct._opaque_pthread_cond_t* noundef @cond), !dbg !425
  call void @mutex_destroy(%struct._opaque_pthread_mutex_t* noundef @cond_mutex), !dbg !426
  ret void, !dbg !427
}

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_init(%struct._opaque_pthread_rwlock_t* noundef %0, i32 noundef %1) #0 !dbg !428 {
  %3 = alloca %struct._opaque_pthread_rwlock_t*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca %struct._opaque_pthread_rwlockattr_t, align 8
  store %struct._opaque_pthread_rwlock_t* %0, %struct._opaque_pthread_rwlock_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_rwlock_t** %3, metadata !442, metadata !DIExpression()), !dbg !443
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !444, metadata !DIExpression()), !dbg !445
  call void @llvm.dbg.declare(metadata i32* %5, metadata !446, metadata !DIExpression()), !dbg !447
  call void @llvm.dbg.declare(metadata i32* %6, metadata !448, metadata !DIExpression()), !dbg !449
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_rwlockattr_t* %7, metadata !450, metadata !DIExpression()), !dbg !461
  %8 = call i32 @pthread_rwlockattr_init(%struct._opaque_pthread_rwlockattr_t* noundef %7), !dbg !462
  store i32 %8, i32* %5, align 4, !dbg !463
  %9 = load i32, i32* %5, align 4, !dbg !464
  %10 = icmp eq i32 %9, 0, !dbg !464
  %11 = xor i1 %10, true, !dbg !464
  %12 = zext i1 %11 to i32, !dbg !464
  %13 = sext i32 %12 to i64, !dbg !464
  %14 = icmp ne i64 %13, 0, !dbg !464
  br i1 %14, label %15, label %17, !dbg !464

15:                                               ; preds = %2
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @__func__.rwlock_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 269, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !464
  unreachable, !dbg !464

16:                                               ; No predecessors!
  br label %18, !dbg !464

17:                                               ; preds = %2
  br label %18, !dbg !464

18:                                               ; preds = %17, %16
  %19 = load i32, i32* %4, align 4, !dbg !465
  %20 = call i32 @pthread_rwlockattr_setpshared(%struct._opaque_pthread_rwlockattr_t* noundef %7, i32 noundef %19), !dbg !466
  store i32 %20, i32* %5, align 4, !dbg !467
  %21 = load i32, i32* %5, align 4, !dbg !468
  %22 = icmp eq i32 %21, 0, !dbg !468
  %23 = xor i1 %22, true, !dbg !468
  %24 = zext i1 %23 to i32, !dbg !468
  %25 = sext i32 %24 to i64, !dbg !468
  %26 = icmp ne i64 %25, 0, !dbg !468
  br i1 %26, label %27, label %29, !dbg !468

27:                                               ; preds = %18
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @__func__.rwlock_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 272, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !468
  unreachable, !dbg !468

28:                                               ; No predecessors!
  br label %30, !dbg !468

29:                                               ; preds = %18
  br label %30, !dbg !468

30:                                               ; preds = %29, %28
  %31 = call i32 @pthread_rwlockattr_getpshared(%struct._opaque_pthread_rwlockattr_t* noundef %7, i32* noundef %6), !dbg !469
  store i32 %31, i32* %5, align 4, !dbg !470
  %32 = load i32, i32* %5, align 4, !dbg !471
  %33 = icmp eq i32 %32, 0, !dbg !471
  %34 = xor i1 %33, true, !dbg !471
  %35 = zext i1 %34 to i32, !dbg !471
  %36 = sext i32 %35 to i64, !dbg !471
  %37 = icmp ne i64 %36, 0, !dbg !471
  br i1 %37, label %38, label %40, !dbg !471

38:                                               ; preds = %30
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @__func__.rwlock_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 274, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !471
  unreachable, !dbg !471

39:                                               ; No predecessors!
  br label %41, !dbg !471

40:                                               ; preds = %30
  br label %41, !dbg !471

41:                                               ; preds = %40, %39
  %42 = load %struct._opaque_pthread_rwlock_t*, %struct._opaque_pthread_rwlock_t** %3, align 8, !dbg !472
  %43 = call i32 @"\01_pthread_rwlock_init"(%struct._opaque_pthread_rwlock_t* noundef %42, %struct._opaque_pthread_rwlockattr_t* noundef %7), !dbg !473
  store i32 %43, i32* %5, align 4, !dbg !474
  %44 = load i32, i32* %5, align 4, !dbg !475
  %45 = icmp eq i32 %44, 0, !dbg !475
  %46 = xor i1 %45, true, !dbg !475
  %47 = zext i1 %46 to i32, !dbg !475
  %48 = sext i32 %47 to i64, !dbg !475
  %49 = icmp ne i64 %48, 0, !dbg !475
  br i1 %49, label %50, label %52, !dbg !475

50:                                               ; preds = %41
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @__func__.rwlock_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 277, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !475
  unreachable, !dbg !475

51:                                               ; No predecessors!
  br label %53, !dbg !475

52:                                               ; preds = %41
  br label %53, !dbg !475

53:                                               ; preds = %52, %51
  %54 = call i32 @pthread_rwlockattr_destroy(%struct._opaque_pthread_rwlockattr_t* noundef %7), !dbg !476
  store i32 %54, i32* %5, align 4, !dbg !477
  %55 = load i32, i32* %5, align 4, !dbg !478
  %56 = icmp eq i32 %55, 0, !dbg !478
  %57 = xor i1 %56, true, !dbg !478
  %58 = zext i1 %57 to i32, !dbg !478
  %59 = sext i32 %58 to i64, !dbg !478
  %60 = icmp ne i64 %59, 0, !dbg !478
  br i1 %60, label %61, label %63, !dbg !478

61:                                               ; preds = %53
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @__func__.rwlock_init, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 279, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !478
  unreachable, !dbg !478

62:                                               ; No predecessors!
  br label %64, !dbg !478

63:                                               ; preds = %53
  br label %64, !dbg !478

64:                                               ; preds = %63, %62
  ret void, !dbg !479
}

declare i32 @pthread_rwlockattr_init(%struct._opaque_pthread_rwlockattr_t* noundef) #2

declare i32 @pthread_rwlockattr_setpshared(%struct._opaque_pthread_rwlockattr_t* noundef, i32 noundef) #2

declare i32 @pthread_rwlockattr_getpshared(%struct._opaque_pthread_rwlockattr_t* noundef, i32* noundef) #2

declare i32 @"\01_pthread_rwlock_init"(%struct._opaque_pthread_rwlock_t* noundef, %struct._opaque_pthread_rwlockattr_t* noundef) #2

declare i32 @pthread_rwlockattr_destroy(%struct._opaque_pthread_rwlockattr_t* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_destroy(%struct._opaque_pthread_rwlock_t* noundef %0) #0 !dbg !480 {
  %2 = alloca %struct._opaque_pthread_rwlock_t*, align 8
  %3 = alloca i32, align 4
  store %struct._opaque_pthread_rwlock_t* %0, %struct._opaque_pthread_rwlock_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_rwlock_t** %2, metadata !483, metadata !DIExpression()), !dbg !484
  call void @llvm.dbg.declare(metadata i32* %3, metadata !485, metadata !DIExpression()), !dbg !486
  %4 = load %struct._opaque_pthread_rwlock_t*, %struct._opaque_pthread_rwlock_t** %2, align 8, !dbg !487
  %5 = call i32 @"\01_pthread_rwlock_destroy"(%struct._opaque_pthread_rwlock_t* noundef %4), !dbg !488
  store i32 %5, i32* %3, align 4, !dbg !486
  %6 = load i32, i32* %3, align 4, !dbg !489
  %7 = icmp eq i32 %6, 0, !dbg !489
  %8 = xor i1 %7, true, !dbg !489
  %9 = zext i1 %8 to i32, !dbg !489
  %10 = sext i32 %9 to i64, !dbg !489
  %11 = icmp ne i64 %10, 0, !dbg !489
  br i1 %11, label %12, label %14, !dbg !489

12:                                               ; preds = %1
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__func__.rwlock_destroy, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 285, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !489
  unreachable, !dbg !489

13:                                               ; No predecessors!
  br label %15, !dbg !489

14:                                               ; preds = %1
  br label %15, !dbg !489

15:                                               ; preds = %14, %13
  ret void, !dbg !490
}

declare i32 @"\01_pthread_rwlock_destroy"(%struct._opaque_pthread_rwlock_t* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_wrlock(%struct._opaque_pthread_rwlock_t* noundef %0) #0 !dbg !491 {
  %2 = alloca %struct._opaque_pthread_rwlock_t*, align 8
  %3 = alloca i32, align 4
  store %struct._opaque_pthread_rwlock_t* %0, %struct._opaque_pthread_rwlock_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_rwlock_t** %2, metadata !492, metadata !DIExpression()), !dbg !493
  call void @llvm.dbg.declare(metadata i32* %3, metadata !494, metadata !DIExpression()), !dbg !495
  %4 = load %struct._opaque_pthread_rwlock_t*, %struct._opaque_pthread_rwlock_t** %2, align 8, !dbg !496
  %5 = call i32 @"\01_pthread_rwlock_wrlock"(%struct._opaque_pthread_rwlock_t* noundef %4), !dbg !497
  store i32 %5, i32* %3, align 4, !dbg !495
  %6 = load i32, i32* %3, align 4, !dbg !498
  %7 = icmp eq i32 %6, 0, !dbg !498
  %8 = xor i1 %7, true, !dbg !498
  %9 = zext i1 %8 to i32, !dbg !498
  %10 = sext i32 %9 to i64, !dbg !498
  %11 = icmp ne i64 %10, 0, !dbg !498
  br i1 %11, label %12, label %14, !dbg !498

12:                                               ; preds = %1
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @__func__.rwlock_wrlock, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 291, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !498
  unreachable, !dbg !498

13:                                               ; No predecessors!
  br label %15, !dbg !498

14:                                               ; preds = %1
  br label %15, !dbg !498

15:                                               ; preds = %14, %13
  ret void, !dbg !499
}

declare i32 @"\01_pthread_rwlock_wrlock"(%struct._opaque_pthread_rwlock_t* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define zeroext i1 @rwlock_trywrlock(%struct._opaque_pthread_rwlock_t* noundef %0) #0 !dbg !500 {
  %2 = alloca %struct._opaque_pthread_rwlock_t*, align 8
  %3 = alloca i32, align 4
  store %struct._opaque_pthread_rwlock_t* %0, %struct._opaque_pthread_rwlock_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_rwlock_t** %2, metadata !503, metadata !DIExpression()), !dbg !504
  call void @llvm.dbg.declare(metadata i32* %3, metadata !505, metadata !DIExpression()), !dbg !506
  %4 = load %struct._opaque_pthread_rwlock_t*, %struct._opaque_pthread_rwlock_t** %2, align 8, !dbg !507
  %5 = call i32 @"\01_pthread_rwlock_trywrlock"(%struct._opaque_pthread_rwlock_t* noundef %4), !dbg !508
  store i32 %5, i32* %3, align 4, !dbg !506
  %6 = load i32, i32* %3, align 4, !dbg !509
  %7 = icmp eq i32 %6, 0, !dbg !510
  ret i1 %7, !dbg !511
}

declare i32 @"\01_pthread_rwlock_trywrlock"(%struct._opaque_pthread_rwlock_t* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_rdlock(%struct._opaque_pthread_rwlock_t* noundef %0) #0 !dbg !512 {
  %2 = alloca %struct._opaque_pthread_rwlock_t*, align 8
  %3 = alloca i32, align 4
  store %struct._opaque_pthread_rwlock_t* %0, %struct._opaque_pthread_rwlock_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_rwlock_t** %2, metadata !513, metadata !DIExpression()), !dbg !514
  call void @llvm.dbg.declare(metadata i32* %3, metadata !515, metadata !DIExpression()), !dbg !516
  %4 = load %struct._opaque_pthread_rwlock_t*, %struct._opaque_pthread_rwlock_t** %2, align 8, !dbg !517
  %5 = call i32 @"\01_pthread_rwlock_rdlock"(%struct._opaque_pthread_rwlock_t* noundef %4), !dbg !518
  store i32 %5, i32* %3, align 4, !dbg !516
  %6 = load i32, i32* %3, align 4, !dbg !519
  %7 = icmp eq i32 %6, 0, !dbg !519
  %8 = xor i1 %7, true, !dbg !519
  %9 = zext i1 %8 to i32, !dbg !519
  %10 = sext i32 %9 to i64, !dbg !519
  %11 = icmp ne i64 %10, 0, !dbg !519
  br i1 %11, label %12, label %14, !dbg !519

12:                                               ; preds = %1
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @__func__.rwlock_rdlock, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 304, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !519
  unreachable, !dbg !519

13:                                               ; No predecessors!
  br label %15, !dbg !519

14:                                               ; preds = %1
  br label %15, !dbg !519

15:                                               ; preds = %14, %13
  ret void, !dbg !520
}

declare i32 @"\01_pthread_rwlock_rdlock"(%struct._opaque_pthread_rwlock_t* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define zeroext i1 @rwlock_tryrdlock(%struct._opaque_pthread_rwlock_t* noundef %0) #0 !dbg !521 {
  %2 = alloca %struct._opaque_pthread_rwlock_t*, align 8
  %3 = alloca i32, align 4
  store %struct._opaque_pthread_rwlock_t* %0, %struct._opaque_pthread_rwlock_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_rwlock_t** %2, metadata !522, metadata !DIExpression()), !dbg !523
  call void @llvm.dbg.declare(metadata i32* %3, metadata !524, metadata !DIExpression()), !dbg !525
  %4 = load %struct._opaque_pthread_rwlock_t*, %struct._opaque_pthread_rwlock_t** %2, align 8, !dbg !526
  %5 = call i32 @"\01_pthread_rwlock_tryrdlock"(%struct._opaque_pthread_rwlock_t* noundef %4), !dbg !527
  store i32 %5, i32* %3, align 4, !dbg !525
  %6 = load i32, i32* %3, align 4, !dbg !528
  %7 = icmp eq i32 %6, 0, !dbg !529
  ret i1 %7, !dbg !530
}

declare i32 @"\01_pthread_rwlock_tryrdlock"(%struct._opaque_pthread_rwlock_t* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_unlock(%struct._opaque_pthread_rwlock_t* noundef %0) #0 !dbg !531 {
  %2 = alloca %struct._opaque_pthread_rwlock_t*, align 8
  %3 = alloca i32, align 4
  store %struct._opaque_pthread_rwlock_t* %0, %struct._opaque_pthread_rwlock_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_rwlock_t** %2, metadata !532, metadata !DIExpression()), !dbg !533
  call void @llvm.dbg.declare(metadata i32* %3, metadata !534, metadata !DIExpression()), !dbg !535
  %4 = load %struct._opaque_pthread_rwlock_t*, %struct._opaque_pthread_rwlock_t** %2, align 8, !dbg !536
  %5 = call i32 @"\01_pthread_rwlock_unlock"(%struct._opaque_pthread_rwlock_t* noundef %4), !dbg !537
  store i32 %5, i32* %3, align 4, !dbg !535
  %6 = load i32, i32* %3, align 4, !dbg !538
  %7 = icmp eq i32 %6, 0, !dbg !538
  %8 = xor i1 %7, true, !dbg !538
  %9 = zext i1 %8 to i32, !dbg !538
  %10 = sext i32 %9 to i64, !dbg !538
  %11 = icmp ne i64 %10, 0, !dbg !538
  br i1 %11, label %12, label %14, !dbg !538

12:                                               ; preds = %1
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @__func__.rwlock_unlock, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 317, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !538
  unreachable, !dbg !538

13:                                               ; No predecessors!
  br label %15, !dbg !538

14:                                               ; preds = %1
  br label %15, !dbg !538

15:                                               ; preds = %14, %13
  ret void, !dbg !539
}

declare i32 @"\01_pthread_rwlock_unlock"(%struct._opaque_pthread_rwlock_t* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @rwlock_test() #0 !dbg !540 {
  %1 = alloca %struct._opaque_pthread_rwlock_t, align 8
  %2 = alloca i32, align 4
  %3 = alloca i8, align 1
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  %6 = alloca i8, align 1
  %7 = alloca i32, align 4
  %8 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_rwlock_t* %1, metadata !541, metadata !DIExpression()), !dbg !542
  call void @rwlock_init(%struct._opaque_pthread_rwlock_t* noundef %1, i32 noundef 2), !dbg !543
  call void @llvm.dbg.declare(metadata i32* %2, metadata !544, metadata !DIExpression()), !dbg !546
  store i32 4, i32* %2, align 4, !dbg !546
  call void @rwlock_wrlock(%struct._opaque_pthread_rwlock_t* noundef %1), !dbg !547
  call void @llvm.dbg.declare(metadata i8* %3, metadata !549, metadata !DIExpression()), !dbg !550
  %9 = call zeroext i1 @rwlock_trywrlock(%struct._opaque_pthread_rwlock_t* noundef %1), !dbg !551
  %10 = zext i1 %9 to i8, !dbg !550
  store i8 %10, i8* %3, align 1, !dbg !550
  %11 = load i8, i8* %3, align 1, !dbg !552
  %12 = trunc i8 %11 to i1, !dbg !552
  %13 = xor i1 %12, true, !dbg !552
  %14 = xor i1 %13, true, !dbg !552
  %15 = zext i1 %14 to i32, !dbg !552
  %16 = sext i32 %15 to i64, !dbg !552
  %17 = icmp ne i64 %16, 0, !dbg !552
  br i1 %17, label %18, label %20, !dbg !552

18:                                               ; preds = %0
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @__func__.rwlock_test, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 329, i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0)) #4, !dbg !552
  unreachable, !dbg !552

19:                                               ; No predecessors!
  br label %21, !dbg !552

20:                                               ; preds = %0
  br label %21, !dbg !552

21:                                               ; preds = %20, %19
  %22 = call zeroext i1 @rwlock_tryrdlock(%struct._opaque_pthread_rwlock_t* noundef %1), !dbg !553
  %23 = zext i1 %22 to i8, !dbg !554
  store i8 %23, i8* %3, align 1, !dbg !554
  %24 = load i8, i8* %3, align 1, !dbg !555
  %25 = trunc i8 %24 to i1, !dbg !555
  %26 = xor i1 %25, true, !dbg !555
  %27 = xor i1 %26, true, !dbg !555
  %28 = zext i1 %27 to i32, !dbg !555
  %29 = sext i32 %28 to i64, !dbg !555
  %30 = icmp ne i64 %29, 0, !dbg !555
  br i1 %30, label %31, label %33, !dbg !555

31:                                               ; preds = %21
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @__func__.rwlock_test, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 331, i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0)) #4, !dbg !555
  unreachable, !dbg !555

32:                                               ; No predecessors!
  br label %34, !dbg !555

33:                                               ; preds = %21
  br label %34, !dbg !555

34:                                               ; preds = %33, %32
  call void @rwlock_unlock(%struct._opaque_pthread_rwlock_t* noundef %1), !dbg !556
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !557
  call void @llvm.dbg.declare(metadata i32* %4, metadata !559, metadata !DIExpression()), !dbg !561
  store i32 0, i32* %4, align 4, !dbg !561
  br label %35, !dbg !562

35:                                               ; preds = %51, %34
  %36 = load i32, i32* %4, align 4, !dbg !563
  %37 = icmp slt i32 %36, 4, !dbg !565
  br i1 %37, label %38, label %54, !dbg !566

38:                                               ; preds = %35
  call void @llvm.dbg.declare(metadata i8* %5, metadata !567, metadata !DIExpression()), !dbg !569
  %39 = call zeroext i1 @rwlock_tryrdlock(%struct._opaque_pthread_rwlock_t* noundef %1), !dbg !570
  %40 = zext i1 %39 to i8, !dbg !569
  store i8 %40, i8* %5, align 1, !dbg !569
  %41 = load i8, i8* %5, align 1, !dbg !571
  %42 = trunc i8 %41 to i1, !dbg !571
  %43 = xor i1 %42, true, !dbg !571
  %44 = zext i1 %43 to i32, !dbg !571
  %45 = sext i32 %44 to i64, !dbg !571
  %46 = icmp ne i64 %45, 0, !dbg !571
  br i1 %46, label %47, label %49, !dbg !571

47:                                               ; preds = %38
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @__func__.rwlock_test, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 340, i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.3, i64 0, i64 0)) #4, !dbg !571
  unreachable, !dbg !571

48:                                               ; No predecessors!
  br label %50, !dbg !571

49:                                               ; preds = %38
  br label %50, !dbg !571

50:                                               ; preds = %49, %48
  br label %51, !dbg !572

51:                                               ; preds = %50
  %52 = load i32, i32* %4, align 4, !dbg !573
  %53 = add nsw i32 %52, 1, !dbg !573
  store i32 %53, i32* %4, align 4, !dbg !573
  br label %35, !dbg !574, !llvm.loop !575

54:                                               ; preds = %35
  call void @llvm.dbg.declare(metadata i8* %6, metadata !578, metadata !DIExpression()), !dbg !580
  %55 = call zeroext i1 @rwlock_trywrlock(%struct._opaque_pthread_rwlock_t* noundef %1), !dbg !581
  %56 = zext i1 %55 to i8, !dbg !580
  store i8 %56, i8* %6, align 1, !dbg !580
  %57 = load i8, i8* %6, align 1, !dbg !582
  %58 = trunc i8 %57 to i1, !dbg !582
  %59 = xor i1 %58, true, !dbg !582
  %60 = xor i1 %59, true, !dbg !582
  %61 = zext i1 %60 to i32, !dbg !582
  %62 = sext i32 %61 to i64, !dbg !582
  %63 = icmp ne i64 %62, 0, !dbg !582
  br i1 %63, label %64, label %66, !dbg !582

64:                                               ; preds = %54
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @__func__.rwlock_test, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 345, i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0)) #4, !dbg !582
  unreachable, !dbg !582

65:                                               ; No predecessors!
  br label %67, !dbg !582

66:                                               ; preds = %54
  br label %67, !dbg !582

67:                                               ; preds = %66, %65
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !583
  call void @llvm.dbg.declare(metadata i32* %7, metadata !584, metadata !DIExpression()), !dbg !586
  store i32 0, i32* %7, align 4, !dbg !586
  br label %68, !dbg !587

68:                                               ; preds = %72, %67
  %69 = load i32, i32* %7, align 4, !dbg !588
  %70 = icmp slt i32 %69, 4, !dbg !590
  br i1 %70, label %71, label %75, !dbg !591

71:                                               ; preds = %68
  call void @rwlock_unlock(%struct._opaque_pthread_rwlock_t* noundef %1), !dbg !592
  br label %72, !dbg !594

72:                                               ; preds = %71
  %73 = load i32, i32* %7, align 4, !dbg !595
  %74 = add nsw i32 %73, 1, !dbg !595
  store i32 %74, i32* %7, align 4, !dbg !595
  br label %68, !dbg !596, !llvm.loop !597

75:                                               ; preds = %68
  call void @rwlock_wrlock(%struct._opaque_pthread_rwlock_t* noundef %1), !dbg !599
  call void @llvm.dbg.declare(metadata i8* %8, metadata !601, metadata !DIExpression()), !dbg !602
  %76 = call zeroext i1 @rwlock_trywrlock(%struct._opaque_pthread_rwlock_t* noundef %1), !dbg !603
  %77 = zext i1 %76 to i8, !dbg !602
  store i8 %77, i8* %8, align 1, !dbg !602
  %78 = load i8, i8* %8, align 1, !dbg !604
  %79 = trunc i8 %78 to i1, !dbg !604
  %80 = xor i1 %79, true, !dbg !604
  %81 = xor i1 %80, true, !dbg !604
  %82 = zext i1 %81 to i32, !dbg !604
  %83 = sext i32 %82 to i64, !dbg !604
  %84 = icmp ne i64 %83, 0, !dbg !604
  br i1 %84, label %85, label %87, !dbg !604

85:                                               ; preds = %75
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @__func__.rwlock_test, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 357, i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0)) #4, !dbg !604
  unreachable, !dbg !604

86:                                               ; No predecessors!
  br label %88, !dbg !604

87:                                               ; preds = %75
  br label %88, !dbg !604

88:                                               ; preds = %87, %86
  call void @rwlock_unlock(%struct._opaque_pthread_rwlock_t* noundef %1), !dbg !605
  call void @rwlock_destroy(%struct._opaque_pthread_rwlock_t* noundef %1), !dbg !606
  ret void, !dbg !607
}

declare void @__VERIFIER_loop_bound(i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @key_destroy(i8* noundef %0) #0 !dbg !608 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !609, metadata !DIExpression()), !dbg !610
  %3 = call %struct._opaque_pthread_t* @pthread_self(), !dbg !611
  store %struct._opaque_pthread_t* %3, %struct._opaque_pthread_t** @latest_thread, align 8, !dbg !612
  ret void, !dbg !613
}

declare %struct._opaque_pthread_t* @pthread_self() #2

; Function Attrs: noinline nounwind ssp uwtable
define i8* @key_worker(i8* noundef %0) #0 !dbg !614 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !615, metadata !DIExpression()), !dbg !616
  call void @llvm.dbg.declare(metadata i32* %3, metadata !617, metadata !DIExpression()), !dbg !618
  store i32 1, i32* %3, align 4, !dbg !618
  call void @llvm.dbg.declare(metadata i32* %4, metadata !619, metadata !DIExpression()), !dbg !620
  %6 = load i64, i64* @local_data, align 8, !dbg !621
  %7 = bitcast i32* %3 to i8*, !dbg !622
  %8 = call i32 @pthread_setspecific(i64 noundef %6, i8* noundef %7), !dbg !623
  store i32 %8, i32* %4, align 4, !dbg !620
  %9 = load i32, i32* %4, align 4, !dbg !624
  %10 = icmp eq i32 %9, 0, !dbg !624
  %11 = xor i1 %10, true, !dbg !624
  %12 = zext i1 %11 to i32, !dbg !624
  %13 = sext i32 %12 to i64, !dbg !624
  %14 = icmp ne i64 %13, 0, !dbg !624
  br i1 %14, label %15, label %17, !dbg !624

15:                                               ; preds = %1
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__func__.key_worker, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 379, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !624
  unreachable, !dbg !624

16:                                               ; No predecessors!
  br label %18, !dbg !624

17:                                               ; preds = %1
  br label %18, !dbg !624

18:                                               ; preds = %17, %16
  call void @llvm.dbg.declare(metadata i8** %5, metadata !625, metadata !DIExpression()), !dbg !626
  %19 = load i64, i64* @local_data, align 8, !dbg !627
  %20 = call i8* @pthread_getspecific(i64 noundef %19), !dbg !628
  store i8* %20, i8** %5, align 8, !dbg !626
  %21 = load i8*, i8** %5, align 8, !dbg !629
  %22 = bitcast i32* %3 to i8*, !dbg !629
  %23 = icmp eq i8* %21, %22, !dbg !629
  %24 = xor i1 %23, true, !dbg !629
  %25 = zext i1 %24 to i32, !dbg !629
  %26 = sext i32 %25 to i64, !dbg !629
  %27 = icmp ne i64 %26, 0, !dbg !629
  br i1 %27, label %28, label %30, !dbg !629

28:                                               ; preds = %18
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__func__.key_worker, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 382, i8* noundef getelementptr inbounds ([28 x i8], [28 x i8]* @.str.5, i64 0, i64 0)) #4, !dbg !629
  unreachable, !dbg !629

29:                                               ; No predecessors!
  br label %31, !dbg !629

30:                                               ; preds = %18
  br label %31, !dbg !629

31:                                               ; preds = %30, %29
  %32 = load i8*, i8** %2, align 8, !dbg !630
  ret i8* %32, !dbg !631
}

declare i32 @pthread_setspecific(i64 noundef, i8* noundef) #2

declare i8* @pthread_getspecific(i64 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define void @key_test() #0 !dbg !632 {
  %1 = alloca i32, align 4
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca %struct._opaque_pthread_t*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i8*, align 8
  call void @llvm.dbg.declare(metadata i32* %1, metadata !633, metadata !DIExpression()), !dbg !634
  store i32 2, i32* %1, align 4, !dbg !634
  call void @llvm.dbg.declare(metadata i8** %2, metadata !635, metadata !DIExpression()), !dbg !636
  store i8* inttoptr (i64 41 to i8*), i8** %2, align 8, !dbg !636
  call void @llvm.dbg.declare(metadata i32* %3, metadata !637, metadata !DIExpression()), !dbg !638
  %7 = call i32 @pthread_key_create(i64* noundef @local_data, void (i8*)* noundef @key_destroy), !dbg !639
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %4, metadata !640, metadata !DIExpression()), !dbg !641
  %8 = load i8*, i8** %2, align 8, !dbg !642
  %9 = call %struct._opaque_pthread_t* @thread_create(i8* (i8*)* noundef @key_worker, i8* noundef %8), !dbg !643
  store %struct._opaque_pthread_t* %9, %struct._opaque_pthread_t** %4, align 8, !dbg !641
  %10 = load i64, i64* @local_data, align 8, !dbg !644
  %11 = bitcast i32* %1 to i8*, !dbg !645
  %12 = call i32 @pthread_setspecific(i64 noundef %10, i8* noundef %11), !dbg !646
  store i32 %12, i32* %3, align 4, !dbg !647
  %13 = load i32, i32* %3, align 4, !dbg !648
  %14 = icmp eq i32 %13, 0, !dbg !648
  %15 = xor i1 %14, true, !dbg !648
  %16 = zext i1 %15 to i32, !dbg !648
  %17 = sext i32 %16 to i64, !dbg !648
  %18 = icmp ne i64 %17, 0, !dbg !648
  br i1 %18, label %19, label %21, !dbg !648

19:                                               ; preds = %0
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @__func__.key_test, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 398, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !648
  unreachable, !dbg !648

20:                                               ; No predecessors!
  br label %22, !dbg !648

21:                                               ; preds = %0
  br label %22, !dbg !648

22:                                               ; preds = %21, %20
  call void @llvm.dbg.declare(metadata i8** %5, metadata !649, metadata !DIExpression()), !dbg !650
  %23 = load i64, i64* @local_data, align 8, !dbg !651
  %24 = call i8* @pthread_getspecific(i64 noundef %23), !dbg !652
  store i8* %24, i8** %5, align 8, !dbg !650
  %25 = load i8*, i8** %5, align 8, !dbg !653
  %26 = bitcast i32* %1 to i8*, !dbg !653
  %27 = icmp eq i8* %25, %26, !dbg !653
  %28 = xor i1 %27, true, !dbg !653
  %29 = zext i1 %28 to i32, !dbg !653
  %30 = sext i32 %29 to i64, !dbg !653
  %31 = icmp ne i64 %30, 0, !dbg !653
  br i1 %31, label %32, label %34, !dbg !653

32:                                               ; preds = %22
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @__func__.key_test, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 401, i8* noundef getelementptr inbounds ([28 x i8], [28 x i8]* @.str.5, i64 0, i64 0)) #4, !dbg !653
  unreachable, !dbg !653

33:                                               ; No predecessors!
  br label %35, !dbg !653

34:                                               ; preds = %22
  br label %35, !dbg !653

35:                                               ; preds = %34, %33
  %36 = load i64, i64* @local_data, align 8, !dbg !654
  %37 = call i32 @pthread_setspecific(i64 noundef %36, i8* noundef null), !dbg !655
  store i32 %37, i32* %3, align 4, !dbg !656
  %38 = load i32, i32* %3, align 4, !dbg !657
  %39 = icmp eq i32 %38, 0, !dbg !657
  %40 = xor i1 %39, true, !dbg !657
  %41 = zext i1 %40 to i32, !dbg !657
  %42 = sext i32 %41 to i64, !dbg !657
  %43 = icmp ne i64 %42, 0, !dbg !657
  br i1 %43, label %44, label %46, !dbg !657

44:                                               ; preds = %35
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @__func__.key_test, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 404, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !657
  unreachable, !dbg !657

45:                                               ; No predecessors!
  br label %47, !dbg !657

46:                                               ; preds = %35
  br label %47, !dbg !657

47:                                               ; preds = %46, %45
  call void @llvm.dbg.declare(metadata i8** %6, metadata !658, metadata !DIExpression()), !dbg !659
  %48 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %4, align 8, !dbg !660
  %49 = call i8* @thread_join(%struct._opaque_pthread_t* noundef %48), !dbg !661
  store i8* %49, i8** %6, align 8, !dbg !659
  %50 = load i8*, i8** %6, align 8, !dbg !662
  %51 = load i8*, i8** %2, align 8, !dbg !662
  %52 = icmp eq i8* %50, %51, !dbg !662
  %53 = xor i1 %52, true, !dbg !662
  %54 = zext i1 %53 to i32, !dbg !662
  %55 = sext i32 %54 to i64, !dbg !662
  %56 = icmp ne i64 %55, 0, !dbg !662
  br i1 %56, label %57, label %59, !dbg !662

57:                                               ; preds = %47
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @__func__.key_test, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 407, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str.4, i64 0, i64 0)) #4, !dbg !662
  unreachable, !dbg !662

58:                                               ; No predecessors!
  br label %60, !dbg !662

59:                                               ; preds = %47
  br label %60, !dbg !662

60:                                               ; preds = %59, %58
  %61 = load i64, i64* @local_data, align 8, !dbg !663
  %62 = call i32 @pthread_key_delete(i64 noundef %61), !dbg !664
  store i32 %62, i32* %3, align 4, !dbg !665
  %63 = load i32, i32* %3, align 4, !dbg !666
  %64 = icmp eq i32 %63, 0, !dbg !666
  %65 = xor i1 %64, true, !dbg !666
  %66 = zext i1 %65 to i32, !dbg !666
  %67 = sext i32 %66 to i64, !dbg !666
  %68 = icmp ne i64 %67, 0, !dbg !666
  br i1 %68, label %69, label %71, !dbg !666

69:                                               ; preds = %60
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @__func__.key_test, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 noundef 410, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !666
  unreachable, !dbg !666

70:                                               ; No predecessors!
  br label %72, !dbg !666

71:                                               ; preds = %60
  br label %72, !dbg !666

72:                                               ; preds = %71, %70
  ret void, !dbg !667
}

declare i32 @pthread_key_create(i64* noundef, void (i8*)* noundef) #2

declare i32 @pthread_key_delete(i64 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !668 {
  call void @mutex_test(), !dbg !671
  call void @cond_test(), !dbg !672
  call void @rwlock_test(), !dbg !673
  call void @key_test(), !dbg !674
  ret i32 0, !dbg !675
}

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #4 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!66, !67, !68, !69, !70, !71, !72, !73, !74, !75}
!llvm.ident = !{!76}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "phase", scope: !2, file: !11, line: 200, type: !65, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !8, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/pthread.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5, !7}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!8 = !{!0, !9, !24, !36, !59}
!9 = !DIGlobalVariableExpression(var: !10, expr: !DIExpression())
!10 = distinct !DIGlobalVariable(name: "cond_mutex", scope: !2, file: !11, line: 198, type: !12, isLocal: false, isDefinition: true)
!11 = !DIFile(filename: "benchmarks/miscellaneous/pthread.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !13, line: 31, baseType: !14)
!13 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_mutex_t.h", directory: "")
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutex_t", file: !15, line: 113, baseType: !16)
!15 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!16 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutex_t", file: !15, line: 78, size: 512, elements: !17)
!17 = !{!18, !20}
!18 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !16, file: !15, line: 79, baseType: !19, size: 64)
!19 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !16, file: !15, line: 80, baseType: !21, size: 448, offset: 64)
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 448, elements: !22)
!22 = !{!23}
!23 = !DISubrange(count: 56)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "cond", scope: !2, file: !11, line: 199, type: !26, isLocal: false, isDefinition: true)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_cond_t", file: !27, line: 31, baseType: !28)
!27 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_cond_t.h", directory: "")
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_cond_t", file: !15, line: 110, baseType: !29)
!29 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_cond_t", file: !15, line: 68, size: 384, elements: !30)
!30 = !{!31, !32}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !29, file: !15, line: 69, baseType: !19, size: 64)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !29, file: !15, line: 70, baseType: !33, size: 320, offset: 64)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 320, elements: !34)
!34 = !{!35}
!35 = !DISubrange(count: 40)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "latest_thread", scope: !2, file: !11, line: 366, type: !38, isLocal: false, isDefinition: true)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !39, line: 31, baseType: !40)
!39 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!40 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !15, line: 118, baseType: !41)
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!42 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !15, line: 103, size: 65536, elements: !43)
!43 = !{!44, !45, !55}
!44 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !42, file: !15, line: 104, baseType: !19, size: 64)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !42, file: !15, line: 105, baseType: !46, size: 64, offset: 64)
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!47 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !15, line: 57, size: 192, elements: !48)
!48 = !{!49, !53, !54}
!49 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !47, file: !15, line: 58, baseType: !50, size: 64)
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!51 = !DISubroutineType(types: !52)
!52 = !{null, !7}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !47, file: !15, line: 59, baseType: !7, size: 64, offset: 64)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !47, file: !15, line: 60, baseType: !46, size: 64, offset: 128)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !42, file: !15, line: 106, baseType: !56, size: 65408, offset: 128)
!56 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 65408, elements: !57)
!57 = !{!58}
!58 = !DISubrange(count: 8176)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "local_data", scope: !2, file: !11, line: 367, type: !61, isLocal: false, isDefinition: true)
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_key_t", file: !62, line: 31, baseType: !63)
!62 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_key_t.h", directory: "")
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_key_t", file: !15, line: 112, baseType: !64)
!64 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!65 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!66 = !{i32 7, !"Dwarf Version", i32 4}
!67 = !{i32 2, !"Debug Info Version", i32 3}
!68 = !{i32 1, !"wchar_size", i32 4}
!69 = !{i32 1, !"branch-target-enforcement", i32 0}
!70 = !{i32 1, !"sign-return-address", i32 0}
!71 = !{i32 1, !"sign-return-address-all", i32 0}
!72 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!73 = !{i32 7, !"PIC Level", i32 2}
!74 = !{i32 7, !"uwtable", i32 1}
!75 = !{i32 7, !"frame-pointer", i32 1}
!76 = !{!"Homebrew clang version 14.0.6"}
!77 = distinct !DISubprogram(name: "thread_create", scope: !11, file: !11, line: 12, type: !78, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!78 = !DISubroutineType(types: !79)
!79 = !{!38, !80, !7}
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!81 = !DISubroutineType(types: !82)
!82 = !{!7, !7}
!83 = !{}
!84 = !DILocalVariable(name: "runner", arg: 1, scope: !77, file: !11, line: 12, type: !80)
!85 = !DILocation(line: 12, column: 32, scope: !77)
!86 = !DILocalVariable(name: "data", arg: 2, scope: !77, file: !11, line: 12, type: !7)
!87 = !DILocation(line: 12, column: 54, scope: !77)
!88 = !DILocalVariable(name: "id", scope: !77, file: !11, line: 14, type: !38)
!89 = !DILocation(line: 14, column: 15, scope: !77)
!90 = !DILocalVariable(name: "attr", scope: !77, file: !11, line: 15, type: !91)
!91 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !92, line: 31, baseType: !93)
!92 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_attr_t.h", directory: "")
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_attr_t", file: !15, line: 109, baseType: !94)
!94 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_attr_t", file: !15, line: 63, size: 512, elements: !95)
!95 = !{!96, !97}
!96 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !94, file: !15, line: 64, baseType: !19, size: 64)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !94, file: !15, line: 65, baseType: !21, size: 448, offset: 64)
!98 = !DILocation(line: 15, column: 20, scope: !77)
!99 = !DILocation(line: 16, column: 5, scope: !77)
!100 = !DILocalVariable(name: "status", scope: !77, file: !11, line: 17, type: !65)
!101 = !DILocation(line: 17, column: 9, scope: !77)
!102 = !DILocation(line: 17, column: 45, scope: !77)
!103 = !DILocation(line: 17, column: 53, scope: !77)
!104 = !DILocation(line: 17, column: 18, scope: !77)
!105 = !DILocation(line: 18, column: 5, scope: !77)
!106 = !DILocation(line: 19, column: 5, scope: !77)
!107 = !DILocation(line: 20, column: 12, scope: !77)
!108 = !DILocation(line: 20, column: 5, scope: !77)
!109 = distinct !DISubprogram(name: "thread_join", scope: !11, file: !11, line: 23, type: !110, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!110 = !DISubroutineType(types: !111)
!111 = !{!7, !38}
!112 = !DILocalVariable(name: "id", arg: 1, scope: !109, file: !11, line: 23, type: !38)
!113 = !DILocation(line: 23, column: 29, scope: !109)
!114 = !DILocalVariable(name: "result", scope: !109, file: !11, line: 25, type: !7)
!115 = !DILocation(line: 25, column: 11, scope: !109)
!116 = !DILocalVariable(name: "status", scope: !109, file: !11, line: 26, type: !65)
!117 = !DILocation(line: 26, column: 9, scope: !109)
!118 = !DILocation(line: 26, column: 31, scope: !109)
!119 = !DILocation(line: 26, column: 18, scope: !109)
!120 = !DILocation(line: 27, column: 5, scope: !109)
!121 = !DILocation(line: 28, column: 12, scope: !109)
!122 = !DILocation(line: 28, column: 5, scope: !109)
!123 = distinct !DISubprogram(name: "mutex_init", scope: !11, file: !11, line: 43, type: !124, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!124 = !DISubroutineType(types: !125)
!125 = !{null, !126, !65, !65, !65, !65}
!126 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!127 = !DILocalVariable(name: "lock", arg: 1, scope: !123, file: !11, line: 43, type: !126)
!128 = !DILocation(line: 43, column: 34, scope: !123)
!129 = !DILocalVariable(name: "type", arg: 2, scope: !123, file: !11, line: 43, type: !65)
!130 = !DILocation(line: 43, column: 44, scope: !123)
!131 = !DILocalVariable(name: "protocol", arg: 3, scope: !123, file: !11, line: 43, type: !65)
!132 = !DILocation(line: 43, column: 54, scope: !123)
!133 = !DILocalVariable(name: "policy", arg: 4, scope: !123, file: !11, line: 43, type: !65)
!134 = !DILocation(line: 43, column: 68, scope: !123)
!135 = !DILocalVariable(name: "prioceiling", arg: 5, scope: !123, file: !11, line: 43, type: !65)
!136 = !DILocation(line: 43, column: 80, scope: !123)
!137 = !DILocalVariable(name: "status", scope: !123, file: !11, line: 45, type: !65)
!138 = !DILocation(line: 45, column: 9, scope: !123)
!139 = !DILocalVariable(name: "value", scope: !123, file: !11, line: 46, type: !65)
!140 = !DILocation(line: 46, column: 9, scope: !123)
!141 = !DILocalVariable(name: "attributes", scope: !123, file: !11, line: 47, type: !142)
!142 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !143, line: 31, baseType: !144)
!143 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_mutexattr_t.h", directory: "")
!144 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutexattr_t", file: !15, line: 114, baseType: !145)
!145 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutexattr_t", file: !15, line: 83, size: 128, elements: !146)
!146 = !{!147, !148}
!147 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !145, file: !15, line: 84, baseType: !19, size: 64)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !145, file: !15, line: 85, baseType: !149, size: 64, offset: 64)
!149 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 64, elements: !150)
!150 = !{!151}
!151 = !DISubrange(count: 8)
!152 = !DILocation(line: 47, column: 25, scope: !123)
!153 = !DILocation(line: 48, column: 14, scope: !123)
!154 = !DILocation(line: 48, column: 12, scope: !123)
!155 = !DILocation(line: 49, column: 5, scope: !123)
!156 = !DILocation(line: 51, column: 53, scope: !123)
!157 = !DILocation(line: 51, column: 14, scope: !123)
!158 = !DILocation(line: 51, column: 12, scope: !123)
!159 = !DILocation(line: 52, column: 5, scope: !123)
!160 = !DILocation(line: 53, column: 14, scope: !123)
!161 = !DILocation(line: 53, column: 12, scope: !123)
!162 = !DILocation(line: 54, column: 5, scope: !123)
!163 = !DILocation(line: 56, column: 57, scope: !123)
!164 = !DILocation(line: 56, column: 14, scope: !123)
!165 = !DILocation(line: 56, column: 12, scope: !123)
!166 = !DILocation(line: 57, column: 5, scope: !123)
!167 = !DILocation(line: 58, column: 14, scope: !123)
!168 = !DILocation(line: 58, column: 12, scope: !123)
!169 = !DILocation(line: 59, column: 5, scope: !123)
!170 = !DILocation(line: 61, column: 58, scope: !123)
!171 = !DILocation(line: 61, column: 14, scope: !123)
!172 = !DILocation(line: 61, column: 12, scope: !123)
!173 = !DILocation(line: 62, column: 5, scope: !123)
!174 = !DILocation(line: 63, column: 14, scope: !123)
!175 = !DILocation(line: 63, column: 12, scope: !123)
!176 = !DILocation(line: 64, column: 5, scope: !123)
!177 = !DILocation(line: 66, column: 60, scope: !123)
!178 = !DILocation(line: 66, column: 14, scope: !123)
!179 = !DILocation(line: 66, column: 12, scope: !123)
!180 = !DILocation(line: 67, column: 5, scope: !123)
!181 = !DILocation(line: 68, column: 14, scope: !123)
!182 = !DILocation(line: 68, column: 12, scope: !123)
!183 = !DILocation(line: 69, column: 5, scope: !123)
!184 = !DILocation(line: 71, column: 33, scope: !123)
!185 = !DILocation(line: 71, column: 14, scope: !123)
!186 = !DILocation(line: 71, column: 12, scope: !123)
!187 = !DILocation(line: 72, column: 5, scope: !123)
!188 = !DILocation(line: 73, column: 14, scope: !123)
!189 = !DILocation(line: 73, column: 12, scope: !123)
!190 = !DILocation(line: 74, column: 5, scope: !123)
!191 = !DILocation(line: 75, column: 1, scope: !123)
!192 = distinct !DISubprogram(name: "mutex_destroy", scope: !11, file: !11, line: 77, type: !193, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!193 = !DISubroutineType(types: !194)
!194 = !{null, !126}
!195 = !DILocalVariable(name: "lock", arg: 1, scope: !192, file: !11, line: 77, type: !126)
!196 = !DILocation(line: 77, column: 37, scope: !192)
!197 = !DILocalVariable(name: "status", scope: !192, file: !11, line: 79, type: !65)
!198 = !DILocation(line: 79, column: 9, scope: !192)
!199 = !DILocation(line: 79, column: 40, scope: !192)
!200 = !DILocation(line: 79, column: 18, scope: !192)
!201 = !DILocation(line: 80, column: 5, scope: !192)
!202 = !DILocation(line: 81, column: 1, scope: !192)
!203 = distinct !DISubprogram(name: "mutex_lock", scope: !11, file: !11, line: 83, type: !193, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!204 = !DILocalVariable(name: "lock", arg: 1, scope: !203, file: !11, line: 83, type: !126)
!205 = !DILocation(line: 83, column: 34, scope: !203)
!206 = !DILocalVariable(name: "status", scope: !203, file: !11, line: 85, type: !65)
!207 = !DILocation(line: 85, column: 9, scope: !203)
!208 = !DILocation(line: 85, column: 37, scope: !203)
!209 = !DILocation(line: 85, column: 18, scope: !203)
!210 = !DILocation(line: 86, column: 5, scope: !203)
!211 = !DILocation(line: 87, column: 1, scope: !203)
!212 = distinct !DISubprogram(name: "mutex_trylock", scope: !11, file: !11, line: 89, type: !213, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!213 = !DISubroutineType(types: !214)
!214 = !{!215, !126}
!215 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!216 = !DILocalVariable(name: "lock", arg: 1, scope: !212, file: !11, line: 89, type: !126)
!217 = !DILocation(line: 89, column: 37, scope: !212)
!218 = !DILocalVariable(name: "status", scope: !212, file: !11, line: 91, type: !65)
!219 = !DILocation(line: 91, column: 9, scope: !212)
!220 = !DILocation(line: 91, column: 40, scope: !212)
!221 = !DILocation(line: 91, column: 18, scope: !212)
!222 = !DILocation(line: 93, column: 12, scope: !212)
!223 = !DILocation(line: 93, column: 19, scope: !212)
!224 = !DILocation(line: 93, column: 5, scope: !212)
!225 = distinct !DISubprogram(name: "mutex_unlock", scope: !11, file: !11, line: 96, type: !193, scopeLine: 97, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!226 = !DILocalVariable(name: "lock", arg: 1, scope: !225, file: !11, line: 96, type: !126)
!227 = !DILocation(line: 96, column: 36, scope: !225)
!228 = !DILocalVariable(name: "status", scope: !225, file: !11, line: 98, type: !65)
!229 = !DILocation(line: 98, column: 9, scope: !225)
!230 = !DILocation(line: 98, column: 39, scope: !225)
!231 = !DILocation(line: 98, column: 18, scope: !225)
!232 = !DILocation(line: 99, column: 5, scope: !225)
!233 = !DILocation(line: 100, column: 1, scope: !225)
!234 = distinct !DISubprogram(name: "mutex_test", scope: !11, file: !11, line: 102, type: !235, scopeLine: 103, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!235 = !DISubroutineType(types: !236)
!236 = !{null}
!237 = !DILocalVariable(name: "mutex0", scope: !234, file: !11, line: 104, type: !12)
!238 = !DILocation(line: 104, column: 21, scope: !234)
!239 = !DILocalVariable(name: "mutex1", scope: !234, file: !11, line: 105, type: !12)
!240 = !DILocation(line: 105, column: 21, scope: !234)
!241 = !DILocation(line: 107, column: 5, scope: !234)
!242 = !DILocation(line: 108, column: 5, scope: !234)
!243 = !DILocation(line: 111, column: 9, scope: !244)
!244 = distinct !DILexicalBlock(scope: !234, file: !11, line: 110, column: 5)
!245 = !DILocalVariable(name: "success", scope: !244, file: !11, line: 112, type: !215)
!246 = !DILocation(line: 112, column: 14, scope: !244)
!247 = !DILocation(line: 112, column: 24, scope: !244)
!248 = !DILocation(line: 113, column: 9, scope: !244)
!249 = !DILocation(line: 114, column: 9, scope: !244)
!250 = !DILocation(line: 118, column: 9, scope: !251)
!251 = distinct !DILexicalBlock(scope: !234, file: !11, line: 117, column: 5)
!252 = !DILocalVariable(name: "success", scope: !253, file: !11, line: 121, type: !215)
!253 = distinct !DILexicalBlock(scope: !251, file: !11, line: 120, column: 9)
!254 = !DILocation(line: 121, column: 18, scope: !253)
!255 = !DILocation(line: 121, column: 28, scope: !253)
!256 = !DILocation(line: 122, column: 13, scope: !253)
!257 = !DILocation(line: 123, column: 13, scope: !253)
!258 = !DILocalVariable(name: "success", scope: !259, file: !11, line: 127, type: !215)
!259 = distinct !DILexicalBlock(scope: !251, file: !11, line: 126, column: 9)
!260 = !DILocation(line: 127, column: 18, scope: !259)
!261 = !DILocation(line: 127, column: 28, scope: !259)
!262 = !DILocation(line: 128, column: 13, scope: !259)
!263 = !DILocation(line: 129, column: 13, scope: !259)
!264 = !DILocation(line: 139, column: 9, scope: !251)
!265 = !DILocation(line: 142, column: 5, scope: !234)
!266 = !DILocation(line: 143, column: 5, scope: !234)
!267 = !DILocation(line: 144, column: 1, scope: !234)
!268 = distinct !DISubprogram(name: "cond_init", scope: !11, file: !11, line: 148, type: !269, scopeLine: 149, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!269 = !DISubroutineType(types: !270)
!270 = !{null, !271}
!271 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!272 = !DILocalVariable(name: "cond", arg: 1, scope: !268, file: !11, line: 148, type: !271)
!273 = !DILocation(line: 148, column: 32, scope: !268)
!274 = !DILocalVariable(name: "status", scope: !268, file: !11, line: 150, type: !65)
!275 = !DILocation(line: 150, column: 9, scope: !268)
!276 = !DILocalVariable(name: "attr", scope: !268, file: !11, line: 151, type: !277)
!277 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_condattr_t", file: !278, line: 31, baseType: !279)
!278 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_condattr_t.h", directory: "")
!279 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_condattr_t", file: !15, line: 111, baseType: !280)
!280 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_condattr_t", file: !15, line: 73, size: 128, elements: !281)
!281 = !{!282, !283}
!282 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !280, file: !15, line: 74, baseType: !19, size: 64)
!283 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !280, file: !15, line: 75, baseType: !149, size: 64, offset: 64)
!284 = !DILocation(line: 151, column: 24, scope: !268)
!285 = !DILocation(line: 153, column: 14, scope: !268)
!286 = !DILocation(line: 153, column: 12, scope: !268)
!287 = !DILocation(line: 154, column: 5, scope: !268)
!288 = !DILocation(line: 156, column: 32, scope: !268)
!289 = !DILocation(line: 156, column: 14, scope: !268)
!290 = !DILocation(line: 156, column: 12, scope: !268)
!291 = !DILocation(line: 157, column: 5, scope: !268)
!292 = !DILocation(line: 159, column: 14, scope: !268)
!293 = !DILocation(line: 159, column: 12, scope: !268)
!294 = !DILocation(line: 160, column: 5, scope: !268)
!295 = !DILocation(line: 161, column: 1, scope: !268)
!296 = distinct !DISubprogram(name: "cond_destroy", scope: !11, file: !11, line: 163, type: !269, scopeLine: 164, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!297 = !DILocalVariable(name: "cond", arg: 1, scope: !296, file: !11, line: 163, type: !271)
!298 = !DILocation(line: 163, column: 35, scope: !296)
!299 = !DILocalVariable(name: "status", scope: !296, file: !11, line: 165, type: !65)
!300 = !DILocation(line: 165, column: 9, scope: !296)
!301 = !DILocation(line: 165, column: 39, scope: !296)
!302 = !DILocation(line: 165, column: 18, scope: !296)
!303 = !DILocation(line: 166, column: 5, scope: !296)
!304 = !DILocation(line: 167, column: 1, scope: !296)
!305 = distinct !DISubprogram(name: "cond_signal", scope: !11, file: !11, line: 169, type: !269, scopeLine: 170, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!306 = !DILocalVariable(name: "cond", arg: 1, scope: !305, file: !11, line: 169, type: !271)
!307 = !DILocation(line: 169, column: 34, scope: !305)
!308 = !DILocalVariable(name: "status", scope: !305, file: !11, line: 171, type: !65)
!309 = !DILocation(line: 171, column: 9, scope: !305)
!310 = !DILocation(line: 171, column: 38, scope: !305)
!311 = !DILocation(line: 171, column: 18, scope: !305)
!312 = !DILocation(line: 172, column: 5, scope: !305)
!313 = !DILocation(line: 173, column: 1, scope: !305)
!314 = distinct !DISubprogram(name: "cond_broadcast", scope: !11, file: !11, line: 175, type: !269, scopeLine: 176, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!315 = !DILocalVariable(name: "cond", arg: 1, scope: !314, file: !11, line: 175, type: !271)
!316 = !DILocation(line: 175, column: 37, scope: !314)
!317 = !DILocalVariable(name: "status", scope: !314, file: !11, line: 177, type: !65)
!318 = !DILocation(line: 177, column: 9, scope: !314)
!319 = !DILocation(line: 177, column: 41, scope: !314)
!320 = !DILocation(line: 177, column: 18, scope: !314)
!321 = !DILocation(line: 178, column: 5, scope: !314)
!322 = !DILocation(line: 179, column: 1, scope: !314)
!323 = distinct !DISubprogram(name: "cond_wait", scope: !11, file: !11, line: 181, type: !324, scopeLine: 182, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!324 = !DISubroutineType(types: !325)
!325 = !{null, !271, !126}
!326 = !DILocalVariable(name: "cond", arg: 1, scope: !323, file: !11, line: 181, type: !271)
!327 = !DILocation(line: 181, column: 32, scope: !323)
!328 = !DILocalVariable(name: "lock", arg: 2, scope: !323, file: !11, line: 181, type: !126)
!329 = !DILocation(line: 181, column: 55, scope: !323)
!330 = !DILocalVariable(name: "status", scope: !323, file: !11, line: 183, type: !65)
!331 = !DILocation(line: 183, column: 9, scope: !323)
!332 = !DILocation(line: 183, column: 36, scope: !323)
!333 = !DILocation(line: 183, column: 42, scope: !323)
!334 = !DILocation(line: 183, column: 18, scope: !323)
!335 = !DILocation(line: 185, column: 1, scope: !323)
!336 = distinct !DISubprogram(name: "cond_timedwait", scope: !11, file: !11, line: 187, type: !337, scopeLine: 188, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!337 = !DISubroutineType(types: !338)
!338 = !{null, !271, !126, !339}
!339 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!340 = !DILocalVariable(name: "cond", arg: 1, scope: !336, file: !11, line: 187, type: !271)
!341 = !DILocation(line: 187, column: 37, scope: !336)
!342 = !DILocalVariable(name: "lock", arg: 2, scope: !336, file: !11, line: 187, type: !126)
!343 = !DILocation(line: 187, column: 60, scope: !336)
!344 = !DILocalVariable(name: "millis", arg: 3, scope: !336, file: !11, line: 187, type: !339)
!345 = !DILocation(line: 187, column: 76, scope: !336)
!346 = !DILocalVariable(name: "ts", scope: !336, file: !11, line: 190, type: !347)
!347 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !348, line: 33, size: 128, elements: !349)
!348 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_types/_timespec.h", directory: "")
!349 = !{!350, !353}
!350 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !347, file: !348, line: 35, baseType: !351, size: 64)
!351 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_time_t", file: !352, line: 98, baseType: !19)
!352 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/arm/_types.h", directory: "")
!353 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !347, file: !348, line: 36, baseType: !19, size: 64, offset: 64)
!354 = !DILocation(line: 190, column: 21, scope: !336)
!355 = !DILocation(line: 194, column: 11, scope: !336)
!356 = !DILocalVariable(name: "status", scope: !336, file: !11, line: 195, type: !65)
!357 = !DILocation(line: 195, column: 9, scope: !336)
!358 = !DILocation(line: 195, column: 41, scope: !336)
!359 = !DILocation(line: 195, column: 47, scope: !336)
!360 = !DILocation(line: 195, column: 18, scope: !336)
!361 = !DILocation(line: 196, column: 1, scope: !336)
!362 = distinct !DISubprogram(name: "cond_worker", scope: !11, file: !11, line: 202, type: !81, scopeLine: 203, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!363 = !DILocalVariable(name: "message", arg: 1, scope: !362, file: !11, line: 202, type: !7)
!364 = !DILocation(line: 202, column: 25, scope: !362)
!365 = !DILocalVariable(name: "idle", scope: !362, file: !11, line: 204, type: !215)
!366 = !DILocation(line: 204, column: 10, scope: !362)
!367 = !DILocation(line: 206, column: 9, scope: !368)
!368 = distinct !DILexicalBlock(scope: !362, file: !11, line: 205, column: 5)
!369 = !DILocation(line: 207, column: 9, scope: !368)
!370 = !DILocation(line: 208, column: 9, scope: !368)
!371 = !DILocation(line: 209, column: 9, scope: !368)
!372 = !DILocation(line: 210, column: 16, scope: !368)
!373 = !DILocation(line: 210, column: 22, scope: !368)
!374 = !DILocation(line: 210, column: 14, scope: !368)
!375 = !DILocation(line: 211, column: 9, scope: !368)
!376 = !DILocation(line: 213, column: 9, scope: !377)
!377 = distinct !DILexicalBlock(scope: !362, file: !11, line: 213, column: 9)
!378 = !DILocation(line: 213, column: 9, scope: !362)
!379 = !DILocation(line: 214, column: 25, scope: !377)
!380 = !DILocation(line: 214, column: 34, scope: !377)
!381 = !DILocation(line: 214, column: 9, scope: !377)
!382 = !DILocation(line: 215, column: 10, scope: !362)
!383 = !DILocation(line: 217, column: 9, scope: !384)
!384 = distinct !DILexicalBlock(scope: !362, file: !11, line: 216, column: 5)
!385 = !DILocation(line: 218, column: 9, scope: !384)
!386 = !DILocation(line: 219, column: 9, scope: !384)
!387 = !DILocation(line: 220, column: 9, scope: !384)
!388 = !DILocation(line: 221, column: 16, scope: !384)
!389 = !DILocation(line: 221, column: 22, scope: !384)
!390 = !DILocation(line: 221, column: 14, scope: !384)
!391 = !DILocation(line: 222, column: 9, scope: !384)
!392 = !DILocation(line: 224, column: 9, scope: !393)
!393 = distinct !DILexicalBlock(scope: !362, file: !11, line: 224, column: 9)
!394 = !DILocation(line: 224, column: 9, scope: !362)
!395 = !DILocation(line: 225, column: 25, scope: !393)
!396 = !DILocation(line: 225, column: 34, scope: !393)
!397 = !DILocation(line: 225, column: 9, scope: !393)
!398 = !DILocation(line: 226, column: 12, scope: !362)
!399 = !DILocation(line: 226, column: 5, scope: !362)
!400 = !DILocation(line: 227, column: 1, scope: !362)
!401 = distinct !DISubprogram(name: "cond_test", scope: !11, file: !11, line: 229, type: !235, scopeLine: 230, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!402 = !DILocalVariable(name: "message", scope: !401, file: !11, line: 231, type: !7)
!403 = !DILocation(line: 231, column: 11, scope: !401)
!404 = !DILocation(line: 232, column: 5, scope: !401)
!405 = !DILocation(line: 233, column: 5, scope: !401)
!406 = !DILocalVariable(name: "worker", scope: !401, file: !11, line: 235, type: !38)
!407 = !DILocation(line: 235, column: 15, scope: !401)
!408 = !DILocation(line: 235, column: 51, scope: !401)
!409 = !DILocation(line: 235, column: 24, scope: !401)
!410 = !DILocation(line: 238, column: 9, scope: !411)
!411 = distinct !DILexicalBlock(scope: !401, file: !11, line: 237, column: 5)
!412 = !DILocation(line: 239, column: 9, scope: !411)
!413 = !DILocation(line: 240, column: 9, scope: !411)
!414 = !DILocation(line: 241, column: 9, scope: !411)
!415 = !DILocation(line: 245, column: 9, scope: !416)
!416 = distinct !DILexicalBlock(scope: !401, file: !11, line: 244, column: 5)
!417 = !DILocation(line: 246, column: 9, scope: !416)
!418 = !DILocation(line: 247, column: 9, scope: !416)
!419 = !DILocation(line: 248, column: 9, scope: !416)
!420 = !DILocalVariable(name: "result", scope: !401, file: !11, line: 251, type: !7)
!421 = !DILocation(line: 251, column: 11, scope: !401)
!422 = !DILocation(line: 251, column: 32, scope: !401)
!423 = !DILocation(line: 251, column: 20, scope: !401)
!424 = !DILocation(line: 252, column: 5, scope: !401)
!425 = !DILocation(line: 254, column: 5, scope: !401)
!426 = !DILocation(line: 255, column: 5, scope: !401)
!427 = !DILocation(line: 256, column: 1, scope: !401)
!428 = distinct !DISubprogram(name: "rwlock_init", scope: !11, file: !11, line: 263, type: !429, scopeLine: 264, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!429 = !DISubroutineType(types: !430)
!430 = !{null, !431, !65}
!431 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !432, size: 64)
!432 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlock_t", file: !433, line: 31, baseType: !434)
!433 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_rwlock_t.h", directory: "")
!434 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_rwlock_t", file: !15, line: 116, baseType: !435)
!435 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_rwlock_t", file: !15, line: 93, size: 1600, elements: !436)
!436 = !{!437, !438}
!437 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !435, file: !15, line: 94, baseType: !19, size: 64)
!438 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !435, file: !15, line: 95, baseType: !439, size: 1536, offset: 64)
!439 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 1536, elements: !440)
!440 = !{!441}
!441 = !DISubrange(count: 192)
!442 = !DILocalVariable(name: "lock", arg: 1, scope: !428, file: !11, line: 263, type: !431)
!443 = !DILocation(line: 263, column: 36, scope: !428)
!444 = !DILocalVariable(name: "shared", arg: 2, scope: !428, file: !11, line: 263, type: !65)
!445 = !DILocation(line: 263, column: 46, scope: !428)
!446 = !DILocalVariable(name: "status", scope: !428, file: !11, line: 265, type: !65)
!447 = !DILocation(line: 265, column: 9, scope: !428)
!448 = !DILocalVariable(name: "value", scope: !428, file: !11, line: 266, type: !65)
!449 = !DILocation(line: 266, column: 9, scope: !428)
!450 = !DILocalVariable(name: "attributes", scope: !428, file: !11, line: 267, type: !451)
!451 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlockattr_t", file: !452, line: 31, baseType: !453)
!452 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_rwlockattr_t.h", directory: "")
!453 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_rwlockattr_t", file: !15, line: 117, baseType: !454)
!454 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_rwlockattr_t", file: !15, line: 98, size: 192, elements: !455)
!455 = !{!456, !457}
!456 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !454, file: !15, line: 99, baseType: !19, size: 64)
!457 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !454, file: !15, line: 100, baseType: !458, size: 128, offset: 64)
!458 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 128, elements: !459)
!459 = !{!460}
!460 = !DISubrange(count: 16)
!461 = !DILocation(line: 267, column: 26, scope: !428)
!462 = !DILocation(line: 268, column: 14, scope: !428)
!463 = !DILocation(line: 268, column: 12, scope: !428)
!464 = !DILocation(line: 269, column: 5, scope: !428)
!465 = !DILocation(line: 271, column: 57, scope: !428)
!466 = !DILocation(line: 271, column: 14, scope: !428)
!467 = !DILocation(line: 271, column: 12, scope: !428)
!468 = !DILocation(line: 272, column: 5, scope: !428)
!469 = !DILocation(line: 273, column: 14, scope: !428)
!470 = !DILocation(line: 273, column: 12, scope: !428)
!471 = !DILocation(line: 274, column: 5, scope: !428)
!472 = !DILocation(line: 276, column: 34, scope: !428)
!473 = !DILocation(line: 276, column: 14, scope: !428)
!474 = !DILocation(line: 276, column: 12, scope: !428)
!475 = !DILocation(line: 277, column: 5, scope: !428)
!476 = !DILocation(line: 278, column: 14, scope: !428)
!477 = !DILocation(line: 278, column: 12, scope: !428)
!478 = !DILocation(line: 279, column: 5, scope: !428)
!479 = !DILocation(line: 280, column: 1, scope: !428)
!480 = distinct !DISubprogram(name: "rwlock_destroy", scope: !11, file: !11, line: 282, type: !481, scopeLine: 283, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!481 = !DISubroutineType(types: !482)
!482 = !{null, !431}
!483 = !DILocalVariable(name: "lock", arg: 1, scope: !480, file: !11, line: 282, type: !431)
!484 = !DILocation(line: 282, column: 39, scope: !480)
!485 = !DILocalVariable(name: "status", scope: !480, file: !11, line: 284, type: !65)
!486 = !DILocation(line: 284, column: 9, scope: !480)
!487 = !DILocation(line: 284, column: 41, scope: !480)
!488 = !DILocation(line: 284, column: 18, scope: !480)
!489 = !DILocation(line: 285, column: 5, scope: !480)
!490 = !DILocation(line: 286, column: 1, scope: !480)
!491 = distinct !DISubprogram(name: "rwlock_wrlock", scope: !11, file: !11, line: 288, type: !481, scopeLine: 289, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!492 = !DILocalVariable(name: "lock", arg: 1, scope: !491, file: !11, line: 288, type: !431)
!493 = !DILocation(line: 288, column: 38, scope: !491)
!494 = !DILocalVariable(name: "status", scope: !491, file: !11, line: 290, type: !65)
!495 = !DILocation(line: 290, column: 9, scope: !491)
!496 = !DILocation(line: 290, column: 40, scope: !491)
!497 = !DILocation(line: 290, column: 18, scope: !491)
!498 = !DILocation(line: 291, column: 5, scope: !491)
!499 = !DILocation(line: 292, column: 1, scope: !491)
!500 = distinct !DISubprogram(name: "rwlock_trywrlock", scope: !11, file: !11, line: 294, type: !501, scopeLine: 295, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!501 = !DISubroutineType(types: !502)
!502 = !{!215, !431}
!503 = !DILocalVariable(name: "lock", arg: 1, scope: !500, file: !11, line: 294, type: !431)
!504 = !DILocation(line: 294, column: 41, scope: !500)
!505 = !DILocalVariable(name: "status", scope: !500, file: !11, line: 296, type: !65)
!506 = !DILocation(line: 296, column: 9, scope: !500)
!507 = !DILocation(line: 296, column: 43, scope: !500)
!508 = !DILocation(line: 296, column: 18, scope: !500)
!509 = !DILocation(line: 298, column: 12, scope: !500)
!510 = !DILocation(line: 298, column: 19, scope: !500)
!511 = !DILocation(line: 298, column: 5, scope: !500)
!512 = distinct !DISubprogram(name: "rwlock_rdlock", scope: !11, file: !11, line: 301, type: !481, scopeLine: 302, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!513 = !DILocalVariable(name: "lock", arg: 1, scope: !512, file: !11, line: 301, type: !431)
!514 = !DILocation(line: 301, column: 38, scope: !512)
!515 = !DILocalVariable(name: "status", scope: !512, file: !11, line: 303, type: !65)
!516 = !DILocation(line: 303, column: 9, scope: !512)
!517 = !DILocation(line: 303, column: 40, scope: !512)
!518 = !DILocation(line: 303, column: 18, scope: !512)
!519 = !DILocation(line: 304, column: 5, scope: !512)
!520 = !DILocation(line: 305, column: 1, scope: !512)
!521 = distinct !DISubprogram(name: "rwlock_tryrdlock", scope: !11, file: !11, line: 307, type: !501, scopeLine: 308, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!522 = !DILocalVariable(name: "lock", arg: 1, scope: !521, file: !11, line: 307, type: !431)
!523 = !DILocation(line: 307, column: 41, scope: !521)
!524 = !DILocalVariable(name: "status", scope: !521, file: !11, line: 309, type: !65)
!525 = !DILocation(line: 309, column: 9, scope: !521)
!526 = !DILocation(line: 309, column: 43, scope: !521)
!527 = !DILocation(line: 309, column: 18, scope: !521)
!528 = !DILocation(line: 311, column: 12, scope: !521)
!529 = !DILocation(line: 311, column: 19, scope: !521)
!530 = !DILocation(line: 311, column: 5, scope: !521)
!531 = distinct !DISubprogram(name: "rwlock_unlock", scope: !11, file: !11, line: 314, type: !481, scopeLine: 315, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!532 = !DILocalVariable(name: "lock", arg: 1, scope: !531, file: !11, line: 314, type: !431)
!533 = !DILocation(line: 314, column: 38, scope: !531)
!534 = !DILocalVariable(name: "status", scope: !531, file: !11, line: 316, type: !65)
!535 = !DILocation(line: 316, column: 9, scope: !531)
!536 = !DILocation(line: 316, column: 40, scope: !531)
!537 = !DILocation(line: 316, column: 18, scope: !531)
!538 = !DILocation(line: 317, column: 5, scope: !531)
!539 = !DILocation(line: 318, column: 1, scope: !531)
!540 = distinct !DISubprogram(name: "rwlock_test", scope: !11, file: !11, line: 320, type: !235, scopeLine: 321, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!541 = !DILocalVariable(name: "lock", scope: !540, file: !11, line: 322, type: !432)
!542 = !DILocation(line: 322, column: 22, scope: !540)
!543 = !DILocation(line: 323, column: 5, scope: !540)
!544 = !DILocalVariable(name: "test_depth", scope: !540, file: !11, line: 324, type: !545)
!545 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !65)
!546 = !DILocation(line: 324, column: 15, scope: !540)
!547 = !DILocation(line: 327, column: 9, scope: !548)
!548 = distinct !DILexicalBlock(scope: !540, file: !11, line: 326, column: 5)
!549 = !DILocalVariable(name: "success", scope: !548, file: !11, line: 328, type: !215)
!550 = !DILocation(line: 328, column: 14, scope: !548)
!551 = !DILocation(line: 328, column: 24, scope: !548)
!552 = !DILocation(line: 329, column: 9, scope: !548)
!553 = !DILocation(line: 330, column: 19, scope: !548)
!554 = !DILocation(line: 330, column: 17, scope: !548)
!555 = !DILocation(line: 331, column: 9, scope: !548)
!556 = !DILocation(line: 332, column: 9, scope: !548)
!557 = !DILocation(line: 336, column: 9, scope: !558)
!558 = distinct !DILexicalBlock(scope: !540, file: !11, line: 335, column: 5)
!559 = !DILocalVariable(name: "i", scope: !560, file: !11, line: 337, type: !65)
!560 = distinct !DILexicalBlock(scope: !558, file: !11, line: 337, column: 9)
!561 = !DILocation(line: 337, column: 18, scope: !560)
!562 = !DILocation(line: 337, column: 14, scope: !560)
!563 = !DILocation(line: 337, column: 25, scope: !564)
!564 = distinct !DILexicalBlock(scope: !560, file: !11, line: 337, column: 9)
!565 = !DILocation(line: 337, column: 27, scope: !564)
!566 = !DILocation(line: 337, column: 9, scope: !560)
!567 = !DILocalVariable(name: "success", scope: !568, file: !11, line: 339, type: !215)
!568 = distinct !DILexicalBlock(scope: !564, file: !11, line: 338, column: 9)
!569 = !DILocation(line: 339, column: 18, scope: !568)
!570 = !DILocation(line: 339, column: 28, scope: !568)
!571 = !DILocation(line: 340, column: 13, scope: !568)
!572 = !DILocation(line: 341, column: 9, scope: !568)
!573 = !DILocation(line: 337, column: 42, scope: !564)
!574 = !DILocation(line: 337, column: 9, scope: !564)
!575 = distinct !{!575, !566, !576, !577}
!576 = !DILocation(line: 341, column: 9, scope: !560)
!577 = !{!"llvm.loop.mustprogress"}
!578 = !DILocalVariable(name: "success", scope: !579, file: !11, line: 344, type: !215)
!579 = distinct !DILexicalBlock(scope: !558, file: !11, line: 343, column: 9)
!580 = !DILocation(line: 344, column: 18, scope: !579)
!581 = !DILocation(line: 344, column: 28, scope: !579)
!582 = !DILocation(line: 345, column: 13, scope: !579)
!583 = !DILocation(line: 348, column: 9, scope: !558)
!584 = !DILocalVariable(name: "i", scope: !585, file: !11, line: 349, type: !65)
!585 = distinct !DILexicalBlock(scope: !558, file: !11, line: 349, column: 9)
!586 = !DILocation(line: 349, column: 18, scope: !585)
!587 = !DILocation(line: 349, column: 14, scope: !585)
!588 = !DILocation(line: 349, column: 25, scope: !589)
!589 = distinct !DILexicalBlock(scope: !585, file: !11, line: 349, column: 9)
!590 = !DILocation(line: 349, column: 27, scope: !589)
!591 = !DILocation(line: 349, column: 9, scope: !585)
!592 = !DILocation(line: 350, column: 13, scope: !593)
!593 = distinct !DILexicalBlock(scope: !589, file: !11, line: 349, column: 46)
!594 = !DILocation(line: 351, column: 9, scope: !593)
!595 = !DILocation(line: 349, column: 42, scope: !589)
!596 = !DILocation(line: 349, column: 9, scope: !589)
!597 = distinct !{!597, !591, !598, !577}
!598 = !DILocation(line: 351, column: 9, scope: !585)
!599 = !DILocation(line: 355, column: 9, scope: !600)
!600 = distinct !DILexicalBlock(scope: !540, file: !11, line: 354, column: 5)
!601 = !DILocalVariable(name: "success", scope: !600, file: !11, line: 356, type: !215)
!602 = !DILocation(line: 356, column: 14, scope: !600)
!603 = !DILocation(line: 356, column: 24, scope: !600)
!604 = !DILocation(line: 357, column: 9, scope: !600)
!605 = !DILocation(line: 358, column: 9, scope: !600)
!606 = !DILocation(line: 361, column: 5, scope: !540)
!607 = !DILocation(line: 362, column: 1, scope: !540)
!608 = distinct !DISubprogram(name: "key_destroy", scope: !11, file: !11, line: 369, type: !51, scopeLine: 370, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!609 = !DILocalVariable(name: "unused_value", arg: 1, scope: !608, file: !11, line: 369, type: !7)
!610 = !DILocation(line: 369, column: 24, scope: !608)
!611 = !DILocation(line: 371, column: 21, scope: !608)
!612 = !DILocation(line: 371, column: 19, scope: !608)
!613 = !DILocation(line: 372, column: 1, scope: !608)
!614 = distinct !DISubprogram(name: "key_worker", scope: !11, file: !11, line: 374, type: !81, scopeLine: 375, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!615 = !DILocalVariable(name: "message", arg: 1, scope: !614, file: !11, line: 374, type: !7)
!616 = !DILocation(line: 374, column: 24, scope: !614)
!617 = !DILocalVariable(name: "my_secret", scope: !614, file: !11, line: 376, type: !65)
!618 = !DILocation(line: 376, column: 9, scope: !614)
!619 = !DILocalVariable(name: "status", scope: !614, file: !11, line: 378, type: !65)
!620 = !DILocation(line: 378, column: 9, scope: !614)
!621 = !DILocation(line: 378, column: 38, scope: !614)
!622 = !DILocation(line: 378, column: 50, scope: !614)
!623 = !DILocation(line: 378, column: 18, scope: !614)
!624 = !DILocation(line: 379, column: 5, scope: !614)
!625 = !DILocalVariable(name: "my_local_data", scope: !614, file: !11, line: 381, type: !7)
!626 = !DILocation(line: 381, column: 11, scope: !614)
!627 = !DILocation(line: 381, column: 47, scope: !614)
!628 = !DILocation(line: 381, column: 27, scope: !614)
!629 = !DILocation(line: 382, column: 5, scope: !614)
!630 = !DILocation(line: 384, column: 12, scope: !614)
!631 = !DILocation(line: 384, column: 5, scope: !614)
!632 = distinct !DISubprogram(name: "key_test", scope: !11, file: !11, line: 387, type: !235, scopeLine: 388, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!633 = !DILocalVariable(name: "my_secret", scope: !632, file: !11, line: 389, type: !65)
!634 = !DILocation(line: 389, column: 9, scope: !632)
!635 = !DILocalVariable(name: "message", scope: !632, file: !11, line: 390, type: !7)
!636 = !DILocation(line: 390, column: 11, scope: !632)
!637 = !DILocalVariable(name: "status", scope: !632, file: !11, line: 391, type: !65)
!638 = !DILocation(line: 391, column: 9, scope: !632)
!639 = !DILocation(line: 393, column: 5, scope: !632)
!640 = !DILocalVariable(name: "worker", scope: !632, file: !11, line: 395, type: !38)
!641 = !DILocation(line: 395, column: 15, scope: !632)
!642 = !DILocation(line: 395, column: 50, scope: !632)
!643 = !DILocation(line: 395, column: 24, scope: !632)
!644 = !DILocation(line: 397, column: 34, scope: !632)
!645 = !DILocation(line: 397, column: 46, scope: !632)
!646 = !DILocation(line: 397, column: 14, scope: !632)
!647 = !DILocation(line: 397, column: 12, scope: !632)
!648 = !DILocation(line: 398, column: 5, scope: !632)
!649 = !DILocalVariable(name: "my_local_data", scope: !632, file: !11, line: 400, type: !7)
!650 = !DILocation(line: 400, column: 11, scope: !632)
!651 = !DILocation(line: 400, column: 47, scope: !632)
!652 = !DILocation(line: 400, column: 27, scope: !632)
!653 = !DILocation(line: 401, column: 5, scope: !632)
!654 = !DILocation(line: 403, column: 34, scope: !632)
!655 = !DILocation(line: 403, column: 14, scope: !632)
!656 = !DILocation(line: 403, column: 12, scope: !632)
!657 = !DILocation(line: 404, column: 5, scope: !632)
!658 = !DILocalVariable(name: "result", scope: !632, file: !11, line: 406, type: !7)
!659 = !DILocation(line: 406, column: 11, scope: !632)
!660 = !DILocation(line: 406, column: 32, scope: !632)
!661 = !DILocation(line: 406, column: 20, scope: !632)
!662 = !DILocation(line: 407, column: 5, scope: !632)
!663 = !DILocation(line: 409, column: 33, scope: !632)
!664 = !DILocation(line: 409, column: 14, scope: !632)
!665 = !DILocation(line: 409, column: 12, scope: !632)
!666 = !DILocation(line: 410, column: 5, scope: !632)
!667 = !DILocation(line: 413, column: 1, scope: !632)
!668 = distinct !DISubprogram(name: "main", scope: !11, file: !11, line: 415, type: !669, scopeLine: 416, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!669 = !DISubroutineType(types: !670)
!670 = !{!65}
!671 = !DILocation(line: 417, column: 5, scope: !668)
!672 = !DILocation(line: 418, column: 5, scope: !668)
!673 = !DILocation(line: 419, column: 5, scope: !668)
!674 = !DILocation(line: 420, column: 5, scope: !668)
!675 = !DILocation(line: 421, column: 1, scope: !668)
