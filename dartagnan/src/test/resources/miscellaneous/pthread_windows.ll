; ModuleID = 'pthread.c'
source_filename = "pthread.c"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-w64-windows-gnu"

%struct.pthread_attr_t = type { i32, ptr, i64, %struct.sched_param }
%struct.sched_param = type { i32 }
%struct.timespec = type { i64, i32 }

@.str = private unnamed_addr constant [12 x i8] c"status == 0\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [10 x i8] c"pthread.c\00", align 1, !dbg !7
@.str.2 = private unnamed_addr constant [31 x i8] c"status == 0 || status == EBUSY\00", align 1, !dbg !12
@.str.3 = private unnamed_addr constant [9 x i8] c"!success\00", align 1, !dbg !17
@.str.4 = private unnamed_addr constant [8 x i8] c"success\00", align 1, !dbg !22
@phase = dso_local global i32 0, align 4, !dbg !27
@cond_mutex = dso_local global i64 0, align 8, !dbg !77
@cond = dso_local global i64 0, align 8, !dbg !83
@.str.5 = private unnamed_addr constant [18 x i8] c"result == message\00", align 1, !dbg !34
@latest_thread = dso_local global i64 0, align 8, !dbg !86
@local_data = dso_local global i32 0, align 4, !dbg !91
@.str.6 = private unnamed_addr constant [28 x i8] c"my_local_data == &my_secret\00", align 1, !dbg !39
@.str.7 = private unnamed_addr constant [37 x i8] c"pthread_equal(latest_thread, worker)\00", align 1, !dbg !44
@.str.8 = private unnamed_addr constant [12 x i8] c"status != 0\00", align 1, !dbg !49
@.str.9 = private unnamed_addr constant [54 x i8] c"status == 0 && detachstate == PTHREAD_CREATE_JOINABLE\00", align 1, !dbg !51
@.str.10 = private unnamed_addr constant [54 x i8] c"status == 0 && detachstate == PTHREAD_CREATE_DETACHED\00", align 1, !dbg !56
@once0 = dso_local global i32 0, align 4, !dbg !58
@once1 = dso_local global i32 0, align 4, !dbg !63
@once_calls = dso_local global i32 0, align 4, !dbg !95
@once_value = dso_local global i32 0, align 4, !dbg !98
@.str.11 = private unnamed_addr constant [17 x i8] c"once_value == 42\00", align 1, !dbg !65
@.str.12 = private unnamed_addr constant [16 x i8] c"once_calls == 1\00", align 1, !dbg !70
@.str.13 = private unnamed_addr constant [16 x i8] c"once_calls == 2\00", align 1, !dbg !75

; Function Attrs: noinline nounwind uwtable
define dso_local i64 @thread_create(ptr noundef %runner, ptr noundef %data) #0 !dbg !107 {
entry:
  %runner.addr = alloca ptr, align 8
  %data.addr = alloca ptr, align 8
  %id = alloca i64, align 8
  %attr = alloca %struct.pthread_attr_t, align 8
  %status = alloca i32, align 4
  store ptr %runner, ptr %runner.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %runner.addr, metadata !114, metadata !DIExpression()), !dbg !115
  store ptr %data, ptr %data.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %data.addr, metadata !116, metadata !DIExpression()), !dbg !117
  call void @llvm.dbg.declare(metadata ptr %id, metadata !118, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.declare(metadata ptr %attr, metadata !120, metadata !DIExpression()), !dbg !132
  %call = call i32 @pthread_attr_init(ptr noundef %attr), !dbg !133
  call void @llvm.dbg.declare(metadata ptr %status, metadata !134, metadata !DIExpression()), !dbg !135
  %0 = load ptr, ptr %runner.addr, align 8, !dbg !136
  %1 = load ptr, ptr %data.addr, align 8, !dbg !137
  %call1 = call i32 @pthread_create(ptr noundef %id, ptr noundef %attr, ptr noundef %0, ptr noundef %1), !dbg !138
  store i32 %call1, ptr %status, align 4, !dbg !135
  %2 = load i32, ptr %status, align 4, !dbg !139
  %cmp = icmp eq i32 %2, 0, !dbg !139
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !139

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 19) #4, !dbg !139
  unreachable, !dbg !139

3:                                                ; No predecessors!
  br label %lor.end, !dbg !139

lor.end:                                          ; preds = %3, %entry
  %4 = phi i1 [ true, %entry ], [ false, %3 ]
  %lor.ext = zext i1 %4 to i32, !dbg !139
  %call2 = call i32 @pthread_attr_destroy(ptr noundef %attr), !dbg !140
  %5 = load i64, ptr %id, align 8, !dbg !141
  ret i64 %5, !dbg !142
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @pthread_attr_init(ptr noundef) #2

declare dso_local i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noreturn
declare dllimport void @_assert(ptr noundef, ptr noundef, i32 noundef) #3

declare dso_local i32 @pthread_attr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_join(i64 noundef %id) #0 !dbg !143 {
entry:
  %id.addr = alloca i64, align 8
  %result = alloca ptr, align 8
  %status = alloca i32, align 4
  store i64 %id, ptr %id.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %id.addr, metadata !146, metadata !DIExpression()), !dbg !147
  call void @llvm.dbg.declare(metadata ptr %result, metadata !148, metadata !DIExpression()), !dbg !149
  call void @llvm.dbg.declare(metadata ptr %status, metadata !150, metadata !DIExpression()), !dbg !151
  %0 = load i64, ptr %id.addr, align 8, !dbg !152
  %call = call i32 @pthread_join(i64 noundef %0, ptr noundef %result), !dbg !153
  store i32 %call, ptr %status, align 4, !dbg !151
  %1 = load i32, ptr %status, align 4, !dbg !154
  %cmp = icmp eq i32 %1, 0, !dbg !154
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !154

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 28) #4, !dbg !154
  unreachable, !dbg !154

2:                                                ; No predecessors!
  br label %lor.end, !dbg !154

lor.end:                                          ; preds = %2, %entry
  %3 = phi i1 [ true, %entry ], [ false, %2 ]
  %lor.ext = zext i1 %3 to i32, !dbg !154
  %4 = load ptr, ptr %result, align 8, !dbg !155
  ret ptr %4, !dbg !156
}

declare dso_local i32 @pthread_join(i64 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_init(ptr noundef %lock, i32 noundef %type, i32 noundef %protocol, i32 noundef %prioceiling) #0 !dbg !157 {
entry:
  %lock.addr = alloca ptr, align 8
  %type.addr = alloca i32, align 4
  %protocol.addr = alloca i32, align 4
  %prioceiling.addr = alloca i32, align 4
  %status = alloca i32, align 4
  %value = alloca i32, align 4
  %attributes = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !161, metadata !DIExpression()), !dbg !162
  store i32 %type, ptr %type.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %type.addr, metadata !163, metadata !DIExpression()), !dbg !164
  store i32 %protocol, ptr %protocol.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %protocol.addr, metadata !165, metadata !DIExpression()), !dbg !166
  store i32 %prioceiling, ptr %prioceiling.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %prioceiling.addr, metadata !167, metadata !DIExpression()), !dbg !168
  call void @llvm.dbg.declare(metadata ptr %status, metadata !169, metadata !DIExpression()), !dbg !170
  call void @llvm.dbg.declare(metadata ptr %value, metadata !171, metadata !DIExpression()), !dbg !172
  call void @llvm.dbg.declare(metadata ptr %attributes, metadata !173, metadata !DIExpression()), !dbg !175
  %call = call i32 @pthread_mutexattr_init(ptr noundef %attributes), !dbg !176
  store i32 %call, ptr %status, align 4, !dbg !177
  %0 = load i32, ptr %status, align 4, !dbg !178
  %cmp = icmp eq i32 %0, 0, !dbg !178
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !178

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 48) #4, !dbg !178
  unreachable, !dbg !178

1:                                                ; No predecessors!
  br label %lor.end, !dbg !178

lor.end:                                          ; preds = %1, %entry
  %2 = phi i1 [ true, %entry ], [ false, %1 ]
  %lor.ext = zext i1 %2 to i32, !dbg !178
  %3 = load i32, ptr %type.addr, align 4, !dbg !179
  %call1 = call i32 @pthread_mutexattr_settype(ptr noundef %attributes, i32 noundef %3), !dbg !180
  store i32 %call1, ptr %status, align 4, !dbg !181
  %4 = load i32, ptr %status, align 4, !dbg !182
  %cmp2 = icmp eq i32 %4, 0, !dbg !182
  br i1 %cmp2, label %lor.end4, label %lor.rhs3, !dbg !182

lor.rhs3:                                         ; preds = %lor.end
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 51) #4, !dbg !182
  unreachable, !dbg !182

5:                                                ; No predecessors!
  br label %lor.end4, !dbg !182

lor.end4:                                         ; preds = %5, %lor.end
  %6 = phi i1 [ true, %lor.end ], [ false, %5 ]
  %lor.ext5 = zext i1 %6 to i32, !dbg !182
  %call6 = call i32 @pthread_mutexattr_gettype(ptr noundef %attributes, ptr noundef %value), !dbg !183
  store i32 %call6, ptr %status, align 4, !dbg !184
  %7 = load i32, ptr %status, align 4, !dbg !185
  %cmp7 = icmp eq i32 %7, 0, !dbg !185
  br i1 %cmp7, label %lor.end9, label %lor.rhs8, !dbg !185

lor.rhs8:                                         ; preds = %lor.end4
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 53) #4, !dbg !185
  unreachable, !dbg !185

8:                                                ; No predecessors!
  br label %lor.end9, !dbg !185

lor.end9:                                         ; preds = %8, %lor.end4
  %9 = phi i1 [ true, %lor.end4 ], [ false, %8 ]
  %lor.ext10 = zext i1 %9 to i32, !dbg !185
  %10 = load i32, ptr %protocol.addr, align 4, !dbg !186
  %call11 = call i32 @pthread_mutexattr_setprotocol(ptr noundef %attributes, i32 noundef %10), !dbg !187
  store i32 %call11, ptr %status, align 4, !dbg !188
  %11 = load i32, ptr %status, align 4, !dbg !189
  %cmp12 = icmp eq i32 %11, 0, !dbg !189
  br i1 %cmp12, label %lor.end14, label %lor.rhs13, !dbg !189

lor.rhs13:                                        ; preds = %lor.end9
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 56) #4, !dbg !189
  unreachable, !dbg !189

12:                                               ; No predecessors!
  br label %lor.end14, !dbg !189

lor.end14:                                        ; preds = %12, %lor.end9
  %13 = phi i1 [ true, %lor.end9 ], [ false, %12 ]
  %lor.ext15 = zext i1 %13 to i32, !dbg !189
  %call16 = call i32 @pthread_mutexattr_getprotocol(ptr noundef %attributes, ptr noundef %value), !dbg !190
  store i32 %call16, ptr %status, align 4, !dbg !191
  %14 = load i32, ptr %status, align 4, !dbg !192
  %cmp17 = icmp eq i32 %14, 0, !dbg !192
  br i1 %cmp17, label %lor.end19, label %lor.rhs18, !dbg !192

lor.rhs18:                                        ; preds = %lor.end14
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 58) #4, !dbg !192
  unreachable, !dbg !192

15:                                               ; No predecessors!
  br label %lor.end19, !dbg !192

lor.end19:                                        ; preds = %15, %lor.end14
  %16 = phi i1 [ true, %lor.end14 ], [ false, %15 ]
  %lor.ext20 = zext i1 %16 to i32, !dbg !192
  %17 = load i32, ptr %prioceiling.addr, align 4, !dbg !193
  %call21 = call i32 @pthread_mutexattr_setprioceiling(ptr noundef %attributes, i32 noundef %17), !dbg !194
  store i32 %call21, ptr %status, align 4, !dbg !195
  %18 = load i32, ptr %status, align 4, !dbg !196
  %cmp22 = icmp eq i32 %18, 0, !dbg !196
  br i1 %cmp22, label %lor.end24, label %lor.rhs23, !dbg !196

lor.rhs23:                                        ; preds = %lor.end19
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 61) #4, !dbg !196
  unreachable, !dbg !196

19:                                               ; No predecessors!
  br label %lor.end24, !dbg !196

lor.end24:                                        ; preds = %19, %lor.end19
  %20 = phi i1 [ true, %lor.end19 ], [ false, %19 ]
  %lor.ext25 = zext i1 %20 to i32, !dbg !196
  %call26 = call i32 @pthread_mutexattr_getprioceiling(ptr noundef %attributes, ptr noundef %value), !dbg !197
  store i32 %call26, ptr %status, align 4, !dbg !198
  %21 = load i32, ptr %status, align 4, !dbg !199
  %cmp27 = icmp eq i32 %21, 0, !dbg !199
  br i1 %cmp27, label %lor.end29, label %lor.rhs28, !dbg !199

lor.rhs28:                                        ; preds = %lor.end24
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 63) #4, !dbg !199
  unreachable, !dbg !199

22:                                               ; No predecessors!
  br label %lor.end29, !dbg !199

lor.end29:                                        ; preds = %22, %lor.end24
  %23 = phi i1 [ true, %lor.end24 ], [ false, %22 ]
  %lor.ext30 = zext i1 %23 to i32, !dbg !199
  %24 = load ptr, ptr %lock.addr, align 8, !dbg !200
  %call31 = call i32 @pthread_mutex_init(ptr noundef %24, ptr noundef %attributes), !dbg !201
  store i32 %call31, ptr %status, align 4, !dbg !202
  %25 = load i32, ptr %status, align 4, !dbg !203
  %cmp32 = icmp eq i32 %25, 0, !dbg !203
  br i1 %cmp32, label %lor.end34, label %lor.rhs33, !dbg !203

lor.rhs33:                                        ; preds = %lor.end29
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 66) #4, !dbg !203
  unreachable, !dbg !203

26:                                               ; No predecessors!
  br label %lor.end34, !dbg !203

lor.end34:                                        ; preds = %26, %lor.end29
  %27 = phi i1 [ true, %lor.end29 ], [ false, %26 ]
  %lor.ext35 = zext i1 %27 to i32, !dbg !203
  %call36 = call i32 @pthread_mutexattr_destroy(ptr noundef %attributes), !dbg !204
  store i32 %call36, ptr %status, align 4, !dbg !205
  %28 = load i32, ptr %status, align 4, !dbg !206
  %cmp37 = icmp eq i32 %28, 0, !dbg !206
  br i1 %cmp37, label %lor.end39, label %lor.rhs38, !dbg !206

lor.rhs38:                                        ; preds = %lor.end34
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 68) #4, !dbg !206
  unreachable, !dbg !206

29:                                               ; No predecessors!
  br label %lor.end39, !dbg !206

lor.end39:                                        ; preds = %29, %lor.end34
  %30 = phi i1 [ true, %lor.end34 ], [ false, %29 ]
  %lor.ext40 = zext i1 %30 to i32, !dbg !206
  ret void, !dbg !207
}

declare dso_local i32 @pthread_mutexattr_init(ptr noundef) #2

declare dso_local i32 @pthread_mutexattr_settype(ptr noundef, i32 noundef) #2

declare dso_local i32 @pthread_mutexattr_gettype(ptr noundef, ptr noundef) #2

declare dso_local i32 @pthread_mutexattr_setprotocol(ptr noundef, i32 noundef) #2

declare dso_local i32 @pthread_mutexattr_getprotocol(ptr noundef, ptr noundef) #2

declare dso_local i32 @pthread_mutexattr_setprioceiling(ptr noundef, i32 noundef) #2

declare dso_local i32 @pthread_mutexattr_getprioceiling(ptr noundef, ptr noundef) #2

declare dso_local i32 @pthread_mutex_init(ptr noundef, ptr noundef) #2

declare dso_local i32 @pthread_mutexattr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_destroy(ptr noundef %lock) #0 !dbg !208 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !211, metadata !DIExpression()), !dbg !212
  call void @llvm.dbg.declare(metadata ptr %status, metadata !213, metadata !DIExpression()), !dbg !214
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !215
  %call = call i32 @pthread_mutex_destroy(ptr noundef %0), !dbg !216
  store i32 %call, ptr %status, align 4, !dbg !214
  %1 = load i32, ptr %status, align 4, !dbg !217
  %cmp = icmp eq i32 %1, 0, !dbg !217
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !217

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 74) #4, !dbg !217
  unreachable, !dbg !217

2:                                                ; No predecessors!
  br label %lor.end, !dbg !217

lor.end:                                          ; preds = %2, %entry
  %3 = phi i1 [ true, %entry ], [ false, %2 ]
  %lor.ext = zext i1 %3 to i32, !dbg !217
  ret void, !dbg !218
}

declare dso_local i32 @pthread_mutex_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_lock(ptr noundef %lock) #0 !dbg !219 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !220, metadata !DIExpression()), !dbg !221
  call void @llvm.dbg.declare(metadata ptr %status, metadata !222, metadata !DIExpression()), !dbg !223
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !224
  %call = call i32 @pthread_mutex_lock(ptr noundef %0), !dbg !225
  store i32 %call, ptr %status, align 4, !dbg !223
  %1 = load i32, ptr %status, align 4, !dbg !226
  %cmp = icmp eq i32 %1, 0, !dbg !226
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !226

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 80) #4, !dbg !226
  unreachable, !dbg !226

2:                                                ; No predecessors!
  br label %lor.end, !dbg !226

lor.end:                                          ; preds = %2, %entry
  %3 = phi i1 [ true, %entry ], [ false, %2 ]
  %lor.ext = zext i1 %3 to i32, !dbg !226
  ret void, !dbg !227
}

declare dso_local i32 @pthread_mutex_lock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @mutex_trylock(ptr noundef %lock) #0 !dbg !228 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !232, metadata !DIExpression()), !dbg !233
  call void @llvm.dbg.declare(metadata ptr %status, metadata !234, metadata !DIExpression()), !dbg !235
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !236
  %call = call i32 @pthread_mutex_trylock(ptr noundef %0), !dbg !237
  store i32 %call, ptr %status, align 4, !dbg !235
  %1 = load i32, ptr %status, align 4, !dbg !238
  %cmp = icmp eq i32 %1, 0, !dbg !238
  br i1 %cmp, label %lor.end, label %lor.lhs.false, !dbg !238

lor.lhs.false:                                    ; preds = %entry
  %2 = load i32, ptr %status, align 4, !dbg !238
  %cmp1 = icmp eq i32 %2, 16, !dbg !238
  br i1 %cmp1, label %lor.end, label %lor.rhs, !dbg !238

lor.rhs:                                          ; preds = %lor.lhs.false
  call void @_assert(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 86) #4, !dbg !238
  unreachable, !dbg !238

3:                                                ; No predecessors!
  br label %lor.end, !dbg !238

lor.end:                                          ; preds = %3, %lor.lhs.false, %entry
  %4 = phi i1 [ true, %lor.lhs.false ], [ true, %entry ], [ false, %3 ]
  %lor.ext = zext i1 %4 to i32, !dbg !238
  %5 = load i32, ptr %status, align 4, !dbg !239
  %cmp2 = icmp eq i32 %5, 0, !dbg !240
  ret i1 %cmp2, !dbg !241
}

declare dso_local i32 @pthread_mutex_trylock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_unlock(ptr noundef %lock) #0 !dbg !242 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !243, metadata !DIExpression()), !dbg !244
  call void @llvm.dbg.declare(metadata ptr %status, metadata !245, metadata !DIExpression()), !dbg !246
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !247
  %call = call i32 @pthread_mutex_unlock(ptr noundef %0), !dbg !248
  store i32 %call, ptr %status, align 4, !dbg !246
  %1 = load i32, ptr %status, align 4, !dbg !249
  %cmp = icmp eq i32 %1, 0, !dbg !249
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !249

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 93) #4, !dbg !249
  unreachable, !dbg !249

2:                                                ; No predecessors!
  br label %lor.end, !dbg !249

lor.end:                                          ; preds = %2, %entry
  %3 = phi i1 [ true, %entry ], [ false, %2 ]
  %lor.ext = zext i1 %3 to i32, !dbg !249
  ret void, !dbg !250
}

declare dso_local i32 @pthread_mutex_unlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_test() #0 !dbg !251 {
entry:
  %mutex0 = alloca i64, align 8
  %mutex1 = alloca i64, align 8
  %success = alloca i8, align 1
  %success1 = alloca i8, align 1
  %success8 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata ptr %mutex0, metadata !254, metadata !DIExpression()), !dbg !255
  call void @llvm.dbg.declare(metadata ptr %mutex1, metadata !256, metadata !DIExpression()), !dbg !257
  call void @mutex_init(ptr noundef %mutex0, i32 noundef 1, i32 noundef 8, i32 noundef 1), !dbg !258
  call void @mutex_init(ptr noundef %mutex1, i32 noundef 0, i32 noundef 16, i32 noundef 2), !dbg !259
  call void @mutex_lock(ptr noundef %mutex0), !dbg !260
  call void @llvm.dbg.declare(metadata ptr %success, metadata !262, metadata !DIExpression()), !dbg !263
  %call = call zeroext i1 @mutex_trylock(ptr noundef %mutex0), !dbg !264
  %frombool = zext i1 %call to i8, !dbg !263
  store i8 %frombool, ptr %success, align 1, !dbg !263
  %0 = load i8, ptr %success, align 1, !dbg !265
  %tobool = trunc i8 %0 to i1, !dbg !265
  br i1 %tobool, label %lor.rhs, label %lor.end, !dbg !265

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 107) #4, !dbg !265
  unreachable, !dbg !265

1:                                                ; No predecessors!
  br label %lor.end, !dbg !265

lor.end:                                          ; preds = %1, %entry
  %2 = phi i1 [ true, %entry ], [ false, %1 ]
  %lor.ext = zext i1 %2 to i32, !dbg !265
  call void @mutex_unlock(ptr noundef %mutex0), !dbg !266
  call void @mutex_lock(ptr noundef %mutex1), !dbg !267
  call void @llvm.dbg.declare(metadata ptr %success1, metadata !269, metadata !DIExpression()), !dbg !271
  %call2 = call zeroext i1 @mutex_trylock(ptr noundef %mutex0), !dbg !272
  %frombool3 = zext i1 %call2 to i8, !dbg !271
  store i8 %frombool3, ptr %success1, align 1, !dbg !271
  %3 = load i8, ptr %success1, align 1, !dbg !273
  %tobool4 = trunc i8 %3 to i1, !dbg !273
  br i1 %tobool4, label %lor.end6, label %lor.rhs5, !dbg !273

lor.rhs5:                                         ; preds = %lor.end
  call void @_assert(ptr noundef @.str.4, ptr noundef @.str.1, i32 noundef 116) #4, !dbg !273
  unreachable, !dbg !273

4:                                                ; No predecessors!
  br label %lor.end6, !dbg !273

lor.end6:                                         ; preds = %4, %lor.end
  %5 = phi i1 [ true, %lor.end ], [ false, %4 ]
  %lor.ext7 = zext i1 %5 to i32, !dbg !273
  call void @mutex_unlock(ptr noundef %mutex0), !dbg !274
  call void @llvm.dbg.declare(metadata ptr %success8, metadata !275, metadata !DIExpression()), !dbg !277
  %call9 = call zeroext i1 @mutex_trylock(ptr noundef %mutex0), !dbg !278
  %frombool10 = zext i1 %call9 to i8, !dbg !277
  store i8 %frombool10, ptr %success8, align 1, !dbg !277
  %6 = load i8, ptr %success8, align 1, !dbg !279
  %tobool11 = trunc i8 %6 to i1, !dbg !279
  br i1 %tobool11, label %lor.end13, label %lor.rhs12, !dbg !279

lor.rhs12:                                        ; preds = %lor.end6
  call void @_assert(ptr noundef @.str.4, ptr noundef @.str.1, i32 noundef 122) #4, !dbg !279
  unreachable, !dbg !279

7:                                                ; No predecessors!
  br label %lor.end13, !dbg !279

lor.end13:                                        ; preds = %7, %lor.end6
  %8 = phi i1 [ true, %lor.end6 ], [ false, %7 ]
  %lor.ext14 = zext i1 %8 to i32, !dbg !279
  call void @mutex_unlock(ptr noundef %mutex0), !dbg !280
  call void @mutex_unlock(ptr noundef %mutex1), !dbg !281
  call void @mutex_destroy(ptr noundef %mutex1), !dbg !282
  call void @mutex_destroy(ptr noundef %mutex0), !dbg !283
  ret void, !dbg !284
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_init(ptr noundef %cond) #0 !dbg !285 {
entry:
  %cond.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  %attr = alloca i32, align 4
  store ptr %cond, ptr %cond.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %cond.addr, metadata !289, metadata !DIExpression()), !dbg !290
  call void @llvm.dbg.declare(metadata ptr %status, metadata !291, metadata !DIExpression()), !dbg !292
  call void @llvm.dbg.declare(metadata ptr %attr, metadata !293, metadata !DIExpression()), !dbg !295
  %call = call i32 @pthread_condattr_init(ptr noundef %attr), !dbg !296
  store i32 %call, ptr %status, align 4, !dbg !297
  %0 = load i32, ptr %status, align 4, !dbg !298
  %cmp = icmp eq i32 %0, 0, !dbg !298
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !298

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 143) #4, !dbg !298
  unreachable, !dbg !298

1:                                                ; No predecessors!
  br label %lor.end, !dbg !298

lor.end:                                          ; preds = %1, %entry
  %2 = phi i1 [ true, %entry ], [ false, %1 ]
  %lor.ext = zext i1 %2 to i32, !dbg !298
  %3 = load ptr, ptr %cond.addr, align 8, !dbg !299
  %call1 = call i32 @pthread_cond_init(ptr noundef %3, ptr noundef %attr), !dbg !300
  store i32 %call1, ptr %status, align 4, !dbg !301
  %4 = load i32, ptr %status, align 4, !dbg !302
  %cmp2 = icmp eq i32 %4, 0, !dbg !302
  br i1 %cmp2, label %lor.end4, label %lor.rhs3, !dbg !302

lor.rhs3:                                         ; preds = %lor.end
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 146) #4, !dbg !302
  unreachable, !dbg !302

5:                                                ; No predecessors!
  br label %lor.end4, !dbg !302

lor.end4:                                         ; preds = %5, %lor.end
  %6 = phi i1 [ true, %lor.end ], [ false, %5 ]
  %lor.ext5 = zext i1 %6 to i32, !dbg !302
  %call6 = call i32 @pthread_condattr_destroy(ptr noundef %attr), !dbg !303
  store i32 %call6, ptr %status, align 4, !dbg !304
  %7 = load i32, ptr %status, align 4, !dbg !305
  %cmp7 = icmp eq i32 %7, 0, !dbg !305
  br i1 %cmp7, label %lor.end9, label %lor.rhs8, !dbg !305

lor.rhs8:                                         ; preds = %lor.end4
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 149) #4, !dbg !305
  unreachable, !dbg !305

8:                                                ; No predecessors!
  br label %lor.end9, !dbg !305

lor.end9:                                         ; preds = %8, %lor.end4
  %9 = phi i1 [ true, %lor.end4 ], [ false, %8 ]
  %lor.ext10 = zext i1 %9 to i32, !dbg !305
  ret void, !dbg !306
}

declare dso_local i32 @pthread_condattr_init(ptr noundef) #2

declare dso_local i32 @pthread_cond_init(ptr noundef, ptr noundef) #2

declare dso_local i32 @pthread_condattr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_destroy(ptr noundef %cond) #0 !dbg !307 {
entry:
  %cond.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %cond, ptr %cond.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %cond.addr, metadata !308, metadata !DIExpression()), !dbg !309
  call void @llvm.dbg.declare(metadata ptr %status, metadata !310, metadata !DIExpression()), !dbg !311
  %0 = load ptr, ptr %cond.addr, align 8, !dbg !312
  %call = call i32 @pthread_cond_destroy(ptr noundef %0), !dbg !313
  store i32 %call, ptr %status, align 4, !dbg !311
  %1 = load i32, ptr %status, align 4, !dbg !314
  %cmp = icmp eq i32 %1, 0, !dbg !314
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !314

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 155) #4, !dbg !314
  unreachable, !dbg !314

2:                                                ; No predecessors!
  br label %lor.end, !dbg !314

lor.end:                                          ; preds = %2, %entry
  %3 = phi i1 [ true, %entry ], [ false, %2 ]
  %lor.ext = zext i1 %3 to i32, !dbg !314
  ret void, !dbg !315
}

declare dso_local i32 @pthread_cond_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_signal(ptr noundef %cond) #0 !dbg !316 {
entry:
  %cond.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %cond, ptr %cond.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %cond.addr, metadata !317, metadata !DIExpression()), !dbg !318
  call void @llvm.dbg.declare(metadata ptr %status, metadata !319, metadata !DIExpression()), !dbg !320
  %0 = load ptr, ptr %cond.addr, align 8, !dbg !321
  %call = call i32 @pthread_cond_signal(ptr noundef %0), !dbg !322
  store i32 %call, ptr %status, align 4, !dbg !320
  %1 = load i32, ptr %status, align 4, !dbg !323
  %cmp = icmp eq i32 %1, 0, !dbg !323
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !323

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 161) #4, !dbg !323
  unreachable, !dbg !323

2:                                                ; No predecessors!
  br label %lor.end, !dbg !323

lor.end:                                          ; preds = %2, %entry
  %3 = phi i1 [ true, %entry ], [ false, %2 ]
  %lor.ext = zext i1 %3 to i32, !dbg !323
  ret void, !dbg !324
}

declare dso_local i32 @pthread_cond_signal(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_broadcast(ptr noundef %cond) #0 !dbg !325 {
entry:
  %cond.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %cond, ptr %cond.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %cond.addr, metadata !326, metadata !DIExpression()), !dbg !327
  call void @llvm.dbg.declare(metadata ptr %status, metadata !328, metadata !DIExpression()), !dbg !329
  %0 = load ptr, ptr %cond.addr, align 8, !dbg !330
  %call = call i32 @pthread_cond_broadcast(ptr noundef %0), !dbg !331
  store i32 %call, ptr %status, align 4, !dbg !329
  %1 = load i32, ptr %status, align 4, !dbg !332
  %cmp = icmp eq i32 %1, 0, !dbg !332
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !332

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 167) #4, !dbg !332
  unreachable, !dbg !332

2:                                                ; No predecessors!
  br label %lor.end, !dbg !332

lor.end:                                          ; preds = %2, %entry
  %3 = phi i1 [ true, %entry ], [ false, %2 ]
  %lor.ext = zext i1 %3 to i32, !dbg !332
  ret void, !dbg !333
}

declare dso_local i32 @pthread_cond_broadcast(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_wait(ptr noundef %cond, ptr noundef %lock) #0 !dbg !334 {
entry:
  %cond.addr = alloca ptr, align 8
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %cond, ptr %cond.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %cond.addr, metadata !337, metadata !DIExpression()), !dbg !338
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !339, metadata !DIExpression()), !dbg !340
  call void @llvm.dbg.declare(metadata ptr %status, metadata !341, metadata !DIExpression()), !dbg !342
  %0 = load ptr, ptr %cond.addr, align 8, !dbg !343
  %1 = load ptr, ptr %lock.addr, align 8, !dbg !344
  %call = call i32 @pthread_cond_wait(ptr noundef %0, ptr noundef %1), !dbg !345
  store i32 %call, ptr %status, align 4, !dbg !342
  ret void, !dbg !346
}

declare dso_local i32 @pthread_cond_wait(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_timedwait(ptr noundef %cond, ptr noundef %lock, i64 noundef %millis) #0 !dbg !347 {
entry:
  %cond.addr = alloca ptr, align 8
  %lock.addr = alloca ptr, align 8
  %millis.addr = alloca i64, align 8
  %ts = alloca %struct.timespec, align 8
  %status = alloca i32, align 4
  store ptr %cond, ptr %cond.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %cond.addr, metadata !350, metadata !DIExpression()), !dbg !351
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !352, metadata !DIExpression()), !dbg !353
  store i64 %millis, ptr %millis.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %millis.addr, metadata !354, metadata !DIExpression()), !dbg !355
  call void @llvm.dbg.declare(metadata ptr %ts, metadata !356, metadata !DIExpression()), !dbg !364
  %0 = load i64, ptr %millis.addr, align 8, !dbg !365
  call void @llvm.dbg.declare(metadata ptr %status, metadata !366, metadata !DIExpression()), !dbg !367
  %1 = load ptr, ptr %cond.addr, align 8, !dbg !368
  %2 = load ptr, ptr %lock.addr, align 8, !dbg !369
  %call = call i32 @pthread_cond_timedwait(ptr noundef %1, ptr noundef %2, ptr noundef %ts), !dbg !370
  store i32 %call, ptr %status, align 4, !dbg !367
  ret void, !dbg !371
}

declare dso_local i32 @pthread_cond_timedwait(ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @cond_worker(ptr noundef %message) #0 !dbg !372 {
entry:
  %retval = alloca ptr, align 8
  %message.addr = alloca ptr, align 8
  %idle = alloca i8, align 1
  store ptr %message, ptr %message.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %message.addr, metadata !373, metadata !DIExpression()), !dbg !374
  call void @llvm.dbg.declare(metadata ptr %idle, metadata !375, metadata !DIExpression()), !dbg !376
  store i8 1, ptr %idle, align 1, !dbg !376
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !377
  %0 = load i32, ptr @phase, align 4, !dbg !379
  %inc = add nsw i32 %0, 1, !dbg !379
  store i32 %inc, ptr @phase, align 4, !dbg !379
  call void @cond_wait(ptr noundef @cond, ptr noundef @cond_mutex), !dbg !380
  %1 = load i32, ptr @phase, align 4, !dbg !381
  %inc1 = add nsw i32 %1, 1, !dbg !381
  store i32 %inc1, ptr @phase, align 4, !dbg !381
  %2 = load i32, ptr @phase, align 4, !dbg !382
  %cmp = icmp slt i32 %2, 2, !dbg !383
  %frombool = zext i1 %cmp to i8, !dbg !384
  store i8 %frombool, ptr %idle, align 1, !dbg !384
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !385
  %3 = load i8, ptr %idle, align 1, !dbg !386
  %tobool = trunc i8 %3 to i1, !dbg !386
  br i1 %tobool, label %if.then, label %if.end, !dbg !388

if.then:                                          ; preds = %entry
  %4 = load ptr, ptr %message.addr, align 8, !dbg !389
  %add.ptr = getelementptr inbounds i8, ptr %4, i64 1, !dbg !390
  store ptr %add.ptr, ptr %retval, align 8, !dbg !391
  br label %return, !dbg !391

if.end:                                           ; preds = %entry
  store i8 1, ptr %idle, align 1, !dbg !392
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !393
  %5 = load i32, ptr @phase, align 4, !dbg !395
  %inc2 = add nsw i32 %5, 1, !dbg !395
  store i32 %inc2, ptr @phase, align 4, !dbg !395
  call void @cond_timedwait(ptr noundef @cond, ptr noundef @cond_mutex, i64 noundef 10), !dbg !396
  %6 = load i32, ptr @phase, align 4, !dbg !397
  %inc3 = add nsw i32 %6, 1, !dbg !397
  store i32 %inc3, ptr @phase, align 4, !dbg !397
  %7 = load i32, ptr @phase, align 4, !dbg !398
  %cmp4 = icmp sgt i32 %7, 6, !dbg !399
  %frombool5 = zext i1 %cmp4 to i8, !dbg !400
  store i8 %frombool5, ptr %idle, align 1, !dbg !400
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !401
  %8 = load i8, ptr %idle, align 1, !dbg !402
  %tobool6 = trunc i8 %8 to i1, !dbg !402
  br i1 %tobool6, label %if.then7, label %if.end9, !dbg !404

if.then7:                                         ; preds = %if.end
  %9 = load ptr, ptr %message.addr, align 8, !dbg !405
  %add.ptr8 = getelementptr inbounds i8, ptr %9, i64 2, !dbg !406
  store ptr %add.ptr8, ptr %retval, align 8, !dbg !407
  br label %return, !dbg !407

if.end9:                                          ; preds = %if.end
  %10 = load ptr, ptr %message.addr, align 8, !dbg !408
  store ptr %10, ptr %retval, align 8, !dbg !409
  br label %return, !dbg !409

return:                                           ; preds = %if.end9, %if.then7, %if.then
  %11 = load ptr, ptr %retval, align 8, !dbg !410
  ret ptr %11, !dbg !410
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_test() #0 !dbg !411 {
entry:
  %message = alloca ptr, align 8
  %worker = alloca i64, align 8
  %result = alloca ptr, align 8
  call void @llvm.dbg.declare(metadata ptr %message, metadata !412, metadata !DIExpression()), !dbg !413
  store ptr inttoptr (i64 42 to ptr), ptr %message, align 8, !dbg !413
  call void @mutex_init(ptr noundef @cond_mutex, i32 noundef 0, i32 noundef 0, i32 noundef 0), !dbg !414
  call void @cond_init(ptr noundef @cond), !dbg !415
  call void @llvm.dbg.declare(metadata ptr %worker, metadata !416, metadata !DIExpression()), !dbg !417
  %0 = load ptr, ptr %message, align 8, !dbg !418
  %call = call i64 @thread_create(ptr noundef @cond_worker, ptr noundef %0), !dbg !419
  store i64 %call, ptr %worker, align 8, !dbg !417
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !420
  %1 = load i32, ptr @phase, align 4, !dbg !422
  %inc = add nsw i32 %1, 1, !dbg !422
  store i32 %inc, ptr @phase, align 4, !dbg !422
  call void @cond_signal(ptr noundef @cond), !dbg !423
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !424
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !425
  %2 = load i32, ptr @phase, align 4, !dbg !427
  %inc1 = add nsw i32 %2, 1, !dbg !427
  store i32 %inc1, ptr @phase, align 4, !dbg !427
  call void @cond_broadcast(ptr noundef @cond), !dbg !428
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !429
  call void @llvm.dbg.declare(metadata ptr %result, metadata !430, metadata !DIExpression()), !dbg !431
  %3 = load i64, ptr %worker, align 8, !dbg !432
  %call2 = call ptr @thread_join(i64 noundef %3), !dbg !433
  store ptr %call2, ptr %result, align 8, !dbg !431
  %4 = load ptr, ptr %result, align 8, !dbg !434
  %5 = load ptr, ptr %message, align 8, !dbg !434
  %cmp = icmp eq ptr %4, %5, !dbg !434
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !434

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str.5, ptr noundef @.str.1, i32 noundef 241) #4, !dbg !434
  unreachable, !dbg !434

6:                                                ; No predecessors!
  br label %lor.end, !dbg !434

lor.end:                                          ; preds = %6, %entry
  %7 = phi i1 [ true, %entry ], [ false, %6 ]
  %lor.ext = zext i1 %7 to i32, !dbg !434
  call void @cond_destroy(ptr noundef @cond), !dbg !435
  call void @mutex_destroy(ptr noundef @cond_mutex), !dbg !436
  ret void, !dbg !437
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_init(ptr noundef %lock, i32 noundef %shared) #0 !dbg !438 {
entry:
  %lock.addr = alloca ptr, align 8
  %shared.addr = alloca i32, align 4
  %status = alloca i32, align 4
  %value = alloca i32, align 4
  %attributes = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !443, metadata !DIExpression()), !dbg !444
  store i32 %shared, ptr %shared.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %shared.addr, metadata !445, metadata !DIExpression()), !dbg !446
  call void @llvm.dbg.declare(metadata ptr %status, metadata !447, metadata !DIExpression()), !dbg !448
  call void @llvm.dbg.declare(metadata ptr %value, metadata !449, metadata !DIExpression()), !dbg !450
  call void @llvm.dbg.declare(metadata ptr %attributes, metadata !451, metadata !DIExpression()), !dbg !453
  %call = call i32 @pthread_rwlockattr_init(ptr noundef %attributes), !dbg !454
  store i32 %call, ptr %status, align 4, !dbg !455
  %0 = load i32, ptr %status, align 4, !dbg !456
  %cmp = icmp eq i32 %0, 0, !dbg !456
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !456

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 258) #4, !dbg !456
  unreachable, !dbg !456

1:                                                ; No predecessors!
  br label %lor.end, !dbg !456

lor.end:                                          ; preds = %1, %entry
  %2 = phi i1 [ true, %entry ], [ false, %1 ]
  %lor.ext = zext i1 %2 to i32, !dbg !456
  %3 = load i32, ptr %shared.addr, align 4, !dbg !457
  %call1 = call i32 @pthread_rwlockattr_setpshared(ptr noundef %attributes, i32 noundef %3), !dbg !458
  store i32 %call1, ptr %status, align 4, !dbg !459
  %4 = load i32, ptr %status, align 4, !dbg !460
  %cmp2 = icmp eq i32 %4, 0, !dbg !460
  br i1 %cmp2, label %lor.end4, label %lor.rhs3, !dbg !460

lor.rhs3:                                         ; preds = %lor.end
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 261) #4, !dbg !460
  unreachable, !dbg !460

5:                                                ; No predecessors!
  br label %lor.end4, !dbg !460

lor.end4:                                         ; preds = %5, %lor.end
  %6 = phi i1 [ true, %lor.end ], [ false, %5 ]
  %lor.ext5 = zext i1 %6 to i32, !dbg !460
  %call6 = call i32 @pthread_rwlockattr_getpshared(ptr noundef %attributes, ptr noundef %value), !dbg !461
  store i32 %call6, ptr %status, align 4, !dbg !462
  %7 = load i32, ptr %status, align 4, !dbg !463
  %cmp7 = icmp eq i32 %7, 0, !dbg !463
  br i1 %cmp7, label %lor.end9, label %lor.rhs8, !dbg !463

lor.rhs8:                                         ; preds = %lor.end4
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 263) #4, !dbg !463
  unreachable, !dbg !463

8:                                                ; No predecessors!
  br label %lor.end9, !dbg !463

lor.end9:                                         ; preds = %8, %lor.end4
  %9 = phi i1 [ true, %lor.end4 ], [ false, %8 ]
  %lor.ext10 = zext i1 %9 to i32, !dbg !463
  %10 = load ptr, ptr %lock.addr, align 8, !dbg !464
  %call11 = call i32 @pthread_rwlock_init(ptr noundef %10, ptr noundef %attributes), !dbg !465
  store i32 %call11, ptr %status, align 4, !dbg !466
  %11 = load i32, ptr %status, align 4, !dbg !467
  %cmp12 = icmp eq i32 %11, 0, !dbg !467
  br i1 %cmp12, label %lor.end14, label %lor.rhs13, !dbg !467

lor.rhs13:                                        ; preds = %lor.end9
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 266) #4, !dbg !467
  unreachable, !dbg !467

12:                                               ; No predecessors!
  br label %lor.end14, !dbg !467

lor.end14:                                        ; preds = %12, %lor.end9
  %13 = phi i1 [ true, %lor.end9 ], [ false, %12 ]
  %lor.ext15 = zext i1 %13 to i32, !dbg !467
  %call16 = call i32 @pthread_rwlockattr_destroy(ptr noundef %attributes), !dbg !468
  store i32 %call16, ptr %status, align 4, !dbg !469
  %14 = load i32, ptr %status, align 4, !dbg !470
  %cmp17 = icmp eq i32 %14, 0, !dbg !470
  br i1 %cmp17, label %lor.end19, label %lor.rhs18, !dbg !470

lor.rhs18:                                        ; preds = %lor.end14
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 268) #4, !dbg !470
  unreachable, !dbg !470

15:                                               ; No predecessors!
  br label %lor.end19, !dbg !470

lor.end19:                                        ; preds = %15, %lor.end14
  %16 = phi i1 [ true, %lor.end14 ], [ false, %15 ]
  %lor.ext20 = zext i1 %16 to i32, !dbg !470
  ret void, !dbg !471
}

declare dso_local i32 @pthread_rwlockattr_init(ptr noundef) #2

declare dso_local i32 @pthread_rwlockattr_setpshared(ptr noundef, i32 noundef) #2

declare dso_local i32 @pthread_rwlockattr_getpshared(ptr noundef, ptr noundef) #2

declare dso_local i32 @pthread_rwlock_init(ptr noundef, ptr noundef) #2

declare dso_local i32 @pthread_rwlockattr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_destroy(ptr noundef %lock) #0 !dbg !472 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !475, metadata !DIExpression()), !dbg !476
  call void @llvm.dbg.declare(metadata ptr %status, metadata !477, metadata !DIExpression()), !dbg !478
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !479
  %call = call i32 @pthread_rwlock_destroy(ptr noundef %0), !dbg !480
  store i32 %call, ptr %status, align 4, !dbg !478
  %1 = load i32, ptr %status, align 4, !dbg !481
  %cmp = icmp eq i32 %1, 0, !dbg !481
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !481

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 274) #4, !dbg !481
  unreachable, !dbg !481

2:                                                ; No predecessors!
  br label %lor.end, !dbg !481

lor.end:                                          ; preds = %2, %entry
  %3 = phi i1 [ true, %entry ], [ false, %2 ]
  %lor.ext = zext i1 %3 to i32, !dbg !481
  ret void, !dbg !482
}

declare dso_local i32 @pthread_rwlock_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_wrlock(ptr noundef %lock) #0 !dbg !483 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !484, metadata !DIExpression()), !dbg !485
  call void @llvm.dbg.declare(metadata ptr %status, metadata !486, metadata !DIExpression()), !dbg !487
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !488
  %call = call i32 @pthread_rwlock_wrlock(ptr noundef %0), !dbg !489
  store i32 %call, ptr %status, align 4, !dbg !487
  %1 = load i32, ptr %status, align 4, !dbg !490
  %cmp = icmp eq i32 %1, 0, !dbg !490
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !490

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 280) #4, !dbg !490
  unreachable, !dbg !490

2:                                                ; No predecessors!
  br label %lor.end, !dbg !490

lor.end:                                          ; preds = %2, %entry
  %3 = phi i1 [ true, %entry ], [ false, %2 ]
  %lor.ext = zext i1 %3 to i32, !dbg !490
  ret void, !dbg !491
}

declare dso_local i32 @pthread_rwlock_wrlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @rwlock_trywrlock(ptr noundef %lock) #0 !dbg !492 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !495, metadata !DIExpression()), !dbg !496
  call void @llvm.dbg.declare(metadata ptr %status, metadata !497, metadata !DIExpression()), !dbg !498
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !499
  %call = call i32 @pthread_rwlock_trywrlock(ptr noundef %0), !dbg !500
  store i32 %call, ptr %status, align 4, !dbg !498
  %1 = load i32, ptr %status, align 4, !dbg !501
  %cmp = icmp eq i32 %1, 0, !dbg !501
  br i1 %cmp, label %lor.end, label %lor.lhs.false, !dbg !501

lor.lhs.false:                                    ; preds = %entry
  %2 = load i32, ptr %status, align 4, !dbg !501
  %cmp1 = icmp eq i32 %2, 16, !dbg !501
  br i1 %cmp1, label %lor.end, label %lor.rhs, !dbg !501

lor.rhs:                                          ; preds = %lor.lhs.false
  call void @_assert(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 286) #4, !dbg !501
  unreachable, !dbg !501

3:                                                ; No predecessors!
  br label %lor.end, !dbg !501

lor.end:                                          ; preds = %3, %lor.lhs.false, %entry
  %4 = phi i1 [ true, %lor.lhs.false ], [ true, %entry ], [ false, %3 ]
  %lor.ext = zext i1 %4 to i32, !dbg !501
  %5 = load i32, ptr %status, align 4, !dbg !502
  %cmp2 = icmp eq i32 %5, 0, !dbg !503
  ret i1 %cmp2, !dbg !504
}

declare dso_local i32 @pthread_rwlock_trywrlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_rdlock(ptr noundef %lock) #0 !dbg !505 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !506, metadata !DIExpression()), !dbg !507
  call void @llvm.dbg.declare(metadata ptr %status, metadata !508, metadata !DIExpression()), !dbg !509
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !510
  %call = call i32 @pthread_rwlock_rdlock(ptr noundef %0), !dbg !511
  store i32 %call, ptr %status, align 4, !dbg !509
  %1 = load i32, ptr %status, align 4, !dbg !512
  %cmp = icmp eq i32 %1, 0, !dbg !512
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !512

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 293) #4, !dbg !512
  unreachable, !dbg !512

2:                                                ; No predecessors!
  br label %lor.end, !dbg !512

lor.end:                                          ; preds = %2, %entry
  %3 = phi i1 [ true, %entry ], [ false, %2 ]
  %lor.ext = zext i1 %3 to i32, !dbg !512
  ret void, !dbg !513
}

declare dso_local i32 @pthread_rwlock_rdlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @rwlock_tryrdlock(ptr noundef %lock) #0 !dbg !514 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !515, metadata !DIExpression()), !dbg !516
  call void @llvm.dbg.declare(metadata ptr %status, metadata !517, metadata !DIExpression()), !dbg !518
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !519
  %call = call i32 @pthread_rwlock_tryrdlock(ptr noundef %0), !dbg !520
  store i32 %call, ptr %status, align 4, !dbg !518
  %1 = load i32, ptr %status, align 4, !dbg !521
  %cmp = icmp eq i32 %1, 0, !dbg !521
  br i1 %cmp, label %lor.end, label %lor.lhs.false, !dbg !521

lor.lhs.false:                                    ; preds = %entry
  %2 = load i32, ptr %status, align 4, !dbg !521
  %cmp1 = icmp eq i32 %2, 16, !dbg !521
  br i1 %cmp1, label %lor.end, label %lor.rhs, !dbg !521

lor.rhs:                                          ; preds = %lor.lhs.false
  call void @_assert(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 299) #4, !dbg !521
  unreachable, !dbg !521

3:                                                ; No predecessors!
  br label %lor.end, !dbg !521

lor.end:                                          ; preds = %3, %lor.lhs.false, %entry
  %4 = phi i1 [ true, %lor.lhs.false ], [ true, %entry ], [ false, %3 ]
  %lor.ext = zext i1 %4 to i32, !dbg !521
  %5 = load i32, ptr %status, align 4, !dbg !522
  %cmp2 = icmp eq i32 %5, 0, !dbg !523
  ret i1 %cmp2, !dbg !524
}

declare dso_local i32 @pthread_rwlock_tryrdlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_unlock(ptr noundef %lock) #0 !dbg !525 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !526, metadata !DIExpression()), !dbg !527
  call void @llvm.dbg.declare(metadata ptr %status, metadata !528, metadata !DIExpression()), !dbg !529
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !530
  %call = call i32 @pthread_rwlock_unlock(ptr noundef %0), !dbg !531
  store i32 %call, ptr %status, align 4, !dbg !529
  %1 = load i32, ptr %status, align 4, !dbg !532
  %cmp = icmp eq i32 %1, 0, !dbg !532
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !532

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 306) #4, !dbg !532
  unreachable, !dbg !532

2:                                                ; No predecessors!
  br label %lor.end, !dbg !532

lor.end:                                          ; preds = %2, %entry
  %3 = phi i1 [ true, %entry ], [ false, %2 ]
  %lor.ext = zext i1 %3 to i32, !dbg !532
  ret void, !dbg !533
}

declare dso_local i32 @pthread_rwlock_unlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_test() #0 !dbg !534 {
entry:
  %lock = alloca i64, align 8
  %test_depth = alloca i32, align 4
  %success = alloca i8, align 1
  %i = alloca i32, align 4
  %success7 = alloca i8, align 1
  %success14 = alloca i8, align 1
  %i21 = alloca i32, align 4
  %success28 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata ptr %lock, metadata !535, metadata !DIExpression()), !dbg !536
  call void @rwlock_init(ptr noundef %lock, i32 noundef 0), !dbg !537
  call void @llvm.dbg.declare(metadata ptr %test_depth, metadata !538, metadata !DIExpression()), !dbg !540
  store i32 4, ptr %test_depth, align 4, !dbg !540
  call void @rwlock_wrlock(ptr noundef %lock), !dbg !541
  call void @llvm.dbg.declare(metadata ptr %success, metadata !543, metadata !DIExpression()), !dbg !544
  %call = call zeroext i1 @rwlock_trywrlock(ptr noundef %lock), !dbg !545
  %frombool = zext i1 %call to i8, !dbg !544
  store i8 %frombool, ptr %success, align 1, !dbg !544
  %0 = load i8, ptr %success, align 1, !dbg !546
  %tobool = trunc i8 %0 to i1, !dbg !546
  br i1 %tobool, label %lor.rhs, label %lor.end, !dbg !546

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 318) #4, !dbg !546
  unreachable, !dbg !546

1:                                                ; No predecessors!
  br label %lor.end, !dbg !546

lor.end:                                          ; preds = %1, %entry
  %2 = phi i1 [ true, %entry ], [ false, %1 ]
  %lor.ext = zext i1 %2 to i32, !dbg !546
  %call1 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %lock), !dbg !547
  %frombool2 = zext i1 %call1 to i8, !dbg !548
  store i8 %frombool2, ptr %success, align 1, !dbg !548
  %3 = load i8, ptr %success, align 1, !dbg !549
  %tobool3 = trunc i8 %3 to i1, !dbg !549
  br i1 %tobool3, label %lor.rhs4, label %lor.end5, !dbg !549

lor.rhs4:                                         ; preds = %lor.end
  call void @_assert(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 320) #4, !dbg !549
  unreachable, !dbg !549

4:                                                ; No predecessors!
  br label %lor.end5, !dbg !549

lor.end5:                                         ; preds = %4, %lor.end
  %5 = phi i1 [ true, %lor.end ], [ false, %4 ]
  %lor.ext6 = zext i1 %5 to i32, !dbg !549
  call void @rwlock_unlock(ptr noundef %lock), !dbg !550
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !551
  call void @llvm.dbg.declare(metadata ptr %i, metadata !553, metadata !DIExpression()), !dbg !555
  store i32 0, ptr %i, align 4, !dbg !555
  br label %for.cond, !dbg !556

for.cond:                                         ; preds = %for.inc, %lor.end5
  %6 = load i32, ptr %i, align 4, !dbg !557
  %cmp = icmp slt i32 %6, 4, !dbg !559
  br i1 %cmp, label %for.body, label %for.end, !dbg !560

for.body:                                         ; preds = %for.cond
  call void @llvm.dbg.declare(metadata ptr %success7, metadata !561, metadata !DIExpression()), !dbg !563
  %call8 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %lock), !dbg !564
  %frombool9 = zext i1 %call8 to i8, !dbg !563
  store i8 %frombool9, ptr %success7, align 1, !dbg !563
  %7 = load i8, ptr %success7, align 1, !dbg !565
  %tobool10 = trunc i8 %7 to i1, !dbg !565
  br i1 %tobool10, label %lor.end12, label %lor.rhs11, !dbg !565

lor.rhs11:                                        ; preds = %for.body
  call void @_assert(ptr noundef @.str.4, ptr noundef @.str.1, i32 noundef 329) #4, !dbg !565
  unreachable, !dbg !565

8:                                                ; No predecessors!
  br label %lor.end12, !dbg !565

lor.end12:                                        ; preds = %8, %for.body
  %9 = phi i1 [ true, %for.body ], [ false, %8 ]
  %lor.ext13 = zext i1 %9 to i32, !dbg !565
  br label %for.inc, !dbg !566

for.inc:                                          ; preds = %lor.end12
  %10 = load i32, ptr %i, align 4, !dbg !567
  %inc = add nsw i32 %10, 1, !dbg !567
  store i32 %inc, ptr %i, align 4, !dbg !567
  br label %for.cond, !dbg !568, !llvm.loop !569

for.end:                                          ; preds = %for.cond
  call void @llvm.dbg.declare(metadata ptr %success14, metadata !572, metadata !DIExpression()), !dbg !574
  %call15 = call zeroext i1 @rwlock_trywrlock(ptr noundef %lock), !dbg !575
  %frombool16 = zext i1 %call15 to i8, !dbg !574
  store i8 %frombool16, ptr %success14, align 1, !dbg !574
  %11 = load i8, ptr %success14, align 1, !dbg !576
  %tobool17 = trunc i8 %11 to i1, !dbg !576
  br i1 %tobool17, label %lor.rhs18, label %lor.end19, !dbg !576

lor.rhs18:                                        ; preds = %for.end
  call void @_assert(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 334) #4, !dbg !576
  unreachable, !dbg !576

12:                                               ; No predecessors!
  br label %lor.end19, !dbg !576

lor.end19:                                        ; preds = %12, %for.end
  %13 = phi i1 [ true, %for.end ], [ false, %12 ]
  %lor.ext20 = zext i1 %13 to i32, !dbg !576
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !577
  call void @llvm.dbg.declare(metadata ptr %i21, metadata !578, metadata !DIExpression()), !dbg !580
  store i32 0, ptr %i21, align 4, !dbg !580
  br label %for.cond22, !dbg !581

for.cond22:                                       ; preds = %for.inc25, %lor.end19
  %14 = load i32, ptr %i21, align 4, !dbg !582
  %cmp23 = icmp slt i32 %14, 4, !dbg !584
  br i1 %cmp23, label %for.body24, label %for.end27, !dbg !585

for.body24:                                       ; preds = %for.cond22
  call void @rwlock_unlock(ptr noundef %lock), !dbg !586
  br label %for.inc25, !dbg !588

for.inc25:                                        ; preds = %for.body24
  %15 = load i32, ptr %i21, align 4, !dbg !589
  %inc26 = add nsw i32 %15, 1, !dbg !589
  store i32 %inc26, ptr %i21, align 4, !dbg !589
  br label %for.cond22, !dbg !590, !llvm.loop !591

for.end27:                                        ; preds = %for.cond22
  call void @rwlock_wrlock(ptr noundef %lock), !dbg !593
  call void @llvm.dbg.declare(metadata ptr %success28, metadata !595, metadata !DIExpression()), !dbg !596
  %call29 = call zeroext i1 @rwlock_trywrlock(ptr noundef %lock), !dbg !597
  %frombool30 = zext i1 %call29 to i8, !dbg !596
  store i8 %frombool30, ptr %success28, align 1, !dbg !596
  %16 = load i8, ptr %success28, align 1, !dbg !598
  %tobool31 = trunc i8 %16 to i1, !dbg !598
  br i1 %tobool31, label %lor.rhs32, label %lor.end33, !dbg !598

lor.rhs32:                                        ; preds = %for.end27
  call void @_assert(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 346) #4, !dbg !598
  unreachable, !dbg !598

17:                                               ; No predecessors!
  br label %lor.end33, !dbg !598

lor.end33:                                        ; preds = %17, %for.end27
  %18 = phi i1 [ true, %for.end27 ], [ false, %17 ]
  %lor.ext34 = zext i1 %18 to i32, !dbg !598
  call void @rwlock_unlock(ptr noundef %lock), !dbg !599
  call void @rwlock_destroy(ptr noundef %lock), !dbg !600
  ret void, !dbg !601
}

declare dso_local void @__VERIFIER_loop_bound(i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @key_destroy(ptr noundef %unused_value) #0 !dbg !602 {
entry:
  %unused_value.addr = alloca ptr, align 8
  store ptr %unused_value, ptr %unused_value.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %unused_value.addr, metadata !605, metadata !DIExpression()), !dbg !606
  %call = call i64 @pthread_self(), !dbg !607
  store i64 %call, ptr @latest_thread, align 8, !dbg !608
  ret void, !dbg !609
}

declare dso_local i64 @pthread_self() #2

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @key_worker(ptr noundef %message) #0 !dbg !610 {
entry:
  %message.addr = alloca ptr, align 8
  %my_secret = alloca i32, align 4
  %status = alloca i32, align 4
  %my_local_data = alloca ptr, align 8
  store ptr %message, ptr %message.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %message.addr, metadata !611, metadata !DIExpression()), !dbg !612
  call void @llvm.dbg.declare(metadata ptr %my_secret, metadata !613, metadata !DIExpression()), !dbg !614
  store i32 1, ptr %my_secret, align 4, !dbg !614
  call void @llvm.dbg.declare(metadata ptr %status, metadata !615, metadata !DIExpression()), !dbg !616
  %0 = load i32, ptr @local_data, align 4, !dbg !617
  %call = call i32 @pthread_setspecific(i32 noundef %0, ptr noundef %my_secret), !dbg !618
  store i32 %call, ptr %status, align 4, !dbg !616
  %1 = load i32, ptr %status, align 4, !dbg !619
  %cmp = icmp eq i32 %1, 0, !dbg !619
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !619

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 368) #4, !dbg !619
  unreachable, !dbg !619

2:                                                ; No predecessors!
  br label %lor.end, !dbg !619

lor.end:                                          ; preds = %2, %entry
  %3 = phi i1 [ true, %entry ], [ false, %2 ]
  %lor.ext = zext i1 %3 to i32, !dbg !619
  call void @llvm.dbg.declare(metadata ptr %my_local_data, metadata !620, metadata !DIExpression()), !dbg !621
  %4 = load i32, ptr @local_data, align 4, !dbg !622
  %call1 = call ptr @pthread_getspecific(i32 noundef %4), !dbg !623
  store ptr %call1, ptr %my_local_data, align 8, !dbg !621
  %5 = load ptr, ptr %my_local_data, align 8, !dbg !624
  %cmp2 = icmp eq ptr %5, %my_secret, !dbg !624
  br i1 %cmp2, label %lor.end4, label %lor.rhs3, !dbg !624

lor.rhs3:                                         ; preds = %lor.end
  call void @_assert(ptr noundef @.str.6, ptr noundef @.str.1, i32 noundef 371) #4, !dbg !624
  unreachable, !dbg !624

6:                                                ; No predecessors!
  br label %lor.end4, !dbg !624

lor.end4:                                         ; preds = %6, %lor.end
  %7 = phi i1 [ true, %lor.end ], [ false, %6 ]
  %lor.ext5 = zext i1 %7 to i32, !dbg !624
  %8 = load ptr, ptr %message.addr, align 8, !dbg !625
  ret ptr %8, !dbg !626
}

declare dso_local i32 @pthread_setspecific(i32 noundef, ptr noundef) #2

declare dso_local ptr @pthread_getspecific(i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @key_test() #0 !dbg !627 {
entry:
  %my_secret = alloca i32, align 4
  %message = alloca ptr, align 8
  %status = alloca i32, align 4
  %worker = alloca i64, align 8
  %my_local_data = alloca ptr, align 8
  %result = alloca ptr, align 8
  call void @llvm.dbg.declare(metadata ptr %my_secret, metadata !628, metadata !DIExpression()), !dbg !629
  store i32 2, ptr %my_secret, align 4, !dbg !629
  call void @llvm.dbg.declare(metadata ptr %message, metadata !630, metadata !DIExpression()), !dbg !631
  store ptr inttoptr (i64 41 to ptr), ptr %message, align 8, !dbg !631
  call void @llvm.dbg.declare(metadata ptr %status, metadata !632, metadata !DIExpression()), !dbg !633
  %call = call i32 @pthread_key_create(ptr noundef @local_data, ptr noundef @key_destroy), !dbg !634
  call void @llvm.dbg.declare(metadata ptr %worker, metadata !635, metadata !DIExpression()), !dbg !636
  %0 = load ptr, ptr %message, align 8, !dbg !637
  %call1 = call i64 @thread_create(ptr noundef @key_worker, ptr noundef %0), !dbg !638
  store i64 %call1, ptr %worker, align 8, !dbg !636
  %1 = load i32, ptr @local_data, align 4, !dbg !639
  %call2 = call i32 @pthread_setspecific(i32 noundef %1, ptr noundef %my_secret), !dbg !640
  store i32 %call2, ptr %status, align 4, !dbg !641
  %2 = load i32, ptr %status, align 4, !dbg !642
  %cmp = icmp eq i32 %2, 0, !dbg !642
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !642

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 387) #4, !dbg !642
  unreachable, !dbg !642

3:                                                ; No predecessors!
  br label %lor.end, !dbg !642

lor.end:                                          ; preds = %3, %entry
  %4 = phi i1 [ true, %entry ], [ false, %3 ]
  %lor.ext = zext i1 %4 to i32, !dbg !642
  call void @llvm.dbg.declare(metadata ptr %my_local_data, metadata !643, metadata !DIExpression()), !dbg !644
  %5 = load i32, ptr @local_data, align 4, !dbg !645
  %call3 = call ptr @pthread_getspecific(i32 noundef %5), !dbg !646
  store ptr %call3, ptr %my_local_data, align 8, !dbg !644
  %6 = load ptr, ptr %my_local_data, align 8, !dbg !647
  %cmp4 = icmp eq ptr %6, %my_secret, !dbg !647
  br i1 %cmp4, label %lor.end6, label %lor.rhs5, !dbg !647

lor.rhs5:                                         ; preds = %lor.end
  call void @_assert(ptr noundef @.str.6, ptr noundef @.str.1, i32 noundef 390) #4, !dbg !647
  unreachable, !dbg !647

7:                                                ; No predecessors!
  br label %lor.end6, !dbg !647

lor.end6:                                         ; preds = %7, %lor.end
  %8 = phi i1 [ true, %lor.end ], [ false, %7 ]
  %lor.ext7 = zext i1 %8 to i32, !dbg !647
  %9 = load i32, ptr @local_data, align 4, !dbg !648
  %call8 = call i32 @pthread_setspecific(i32 noundef %9, ptr noundef null), !dbg !649
  store i32 %call8, ptr %status, align 4, !dbg !650
  %10 = load i32, ptr %status, align 4, !dbg !651
  %cmp9 = icmp eq i32 %10, 0, !dbg !651
  br i1 %cmp9, label %lor.end11, label %lor.rhs10, !dbg !651

lor.rhs10:                                        ; preds = %lor.end6
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 393) #4, !dbg !651
  unreachable, !dbg !651

11:                                               ; No predecessors!
  br label %lor.end11, !dbg !651

lor.end11:                                        ; preds = %11, %lor.end6
  %12 = phi i1 [ true, %lor.end6 ], [ false, %11 ]
  %lor.ext12 = zext i1 %12 to i32, !dbg !651
  call void @llvm.dbg.declare(metadata ptr %result, metadata !652, metadata !DIExpression()), !dbg !653
  %13 = load i64, ptr %worker, align 8, !dbg !654
  %call13 = call ptr @thread_join(i64 noundef %13), !dbg !655
  store ptr %call13, ptr %result, align 8, !dbg !653
  %14 = load ptr, ptr %result, align 8, !dbg !656
  %15 = load ptr, ptr %message, align 8, !dbg !656
  %cmp14 = icmp eq ptr %14, %15, !dbg !656
  br i1 %cmp14, label %lor.end16, label %lor.rhs15, !dbg !656

lor.rhs15:                                        ; preds = %lor.end11
  call void @_assert(ptr noundef @.str.5, ptr noundef @.str.1, i32 noundef 396) #4, !dbg !656
  unreachable, !dbg !656

16:                                               ; No predecessors!
  br label %lor.end16, !dbg !656

lor.end16:                                        ; preds = %16, %lor.end11
  %17 = phi i1 [ true, %lor.end11 ], [ false, %16 ]
  %lor.ext17 = zext i1 %17 to i32, !dbg !656
  %18 = load i32, ptr @local_data, align 4, !dbg !657
  %call18 = call i32 @pthread_key_delete(i32 noundef %18), !dbg !658
  store i32 %call18, ptr %status, align 4, !dbg !659
  %19 = load i32, ptr %status, align 4, !dbg !660
  %cmp19 = icmp eq i32 %19, 0, !dbg !660
  br i1 %cmp19, label %lor.end21, label %lor.rhs20, !dbg !660

lor.rhs20:                                        ; preds = %lor.end16
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 399) #4, !dbg !660
  unreachable, !dbg !660

20:                                               ; No predecessors!
  br label %lor.end21, !dbg !660

lor.end21:                                        ; preds = %20, %lor.end16
  %21 = phi i1 [ true, %lor.end16 ], [ false, %20 ]
  %lor.ext22 = zext i1 %21 to i32, !dbg !660
  %22 = load i64, ptr @latest_thread, align 8, !dbg !661
  %23 = load i64, ptr %worker, align 8, !dbg !661
  %call23 = call i32 @pthread_equal(i64 noundef %22, i64 noundef %23), !dbg !661
  %tobool = icmp ne i32 %call23, 0, !dbg !661
  br i1 %tobool, label %lor.end25, label %lor.rhs24, !dbg !661

lor.rhs24:                                        ; preds = %lor.end21
  call void @_assert(ptr noundef @.str.7, ptr noundef @.str.1, i32 noundef 401) #4, !dbg !661
  unreachable, !dbg !661

24:                                               ; No predecessors!
  br label %lor.end25, !dbg !661

lor.end25:                                        ; preds = %24, %lor.end21
  %25 = phi i1 [ true, %lor.end21 ], [ false, %24 ]
  %lor.ext26 = zext i1 %25 to i32, !dbg !661
  ret void, !dbg !662
}

declare dso_local i32 @pthread_key_create(ptr noundef, ptr noundef) #2

declare dso_local i32 @pthread_key_delete(i32 noundef) #2

declare dso_local i32 @pthread_equal(i64 noundef, i64 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @detach_test_worker0(ptr noundef %ignore) #0 !dbg !663 {
entry:
  %ignore.addr = alloca ptr, align 8
  store ptr %ignore, ptr %ignore.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %ignore.addr, metadata !664, metadata !DIExpression()), !dbg !665
  ret ptr null, !dbg !666
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @detach_test_detach(ptr noundef %ignore) #0 !dbg !667 {
entry:
  %ignore.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  %w0 = alloca i64, align 8
  store ptr %ignore, ptr %ignore.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %ignore.addr, metadata !668, metadata !DIExpression()), !dbg !669
  call void @llvm.dbg.declare(metadata ptr %status, metadata !670, metadata !DIExpression()), !dbg !671
  call void @llvm.dbg.declare(metadata ptr %w0, metadata !672, metadata !DIExpression()), !dbg !673
  %call = call i64 @thread_create(ptr noundef @detach_test_worker0, ptr noundef null), !dbg !674
  store i64 %call, ptr %w0, align 8, !dbg !673
  %0 = load i64, ptr %w0, align 8, !dbg !675
  %call1 = call i32 @pthread_detach(i64 noundef %0), !dbg !676
  store i32 %call1, ptr %status, align 4, !dbg !677
  %1 = load i32, ptr %status, align 4, !dbg !678
  %cmp = icmp eq i32 %1, 0, !dbg !678
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !678

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 416) #4, !dbg !678
  unreachable, !dbg !678

2:                                                ; No predecessors!
  br label %lor.end, !dbg !678

lor.end:                                          ; preds = %2, %entry
  %3 = phi i1 [ true, %entry ], [ false, %2 ]
  %lor.ext = zext i1 %3 to i32, !dbg !678
  %4 = load i64, ptr %w0, align 8, !dbg !679
  %call2 = call i32 @pthread_join(i64 noundef %4, ptr noundef null), !dbg !680
  store i32 %call2, ptr %status, align 4, !dbg !681
  %5 = load i32, ptr %status, align 4, !dbg !682
  %cmp3 = icmp ne i32 %5, 0, !dbg !682
  br i1 %cmp3, label %lor.end5, label %lor.rhs4, !dbg !682

lor.rhs4:                                         ; preds = %lor.end
  call void @_assert(ptr noundef @.str.8, ptr noundef @.str.1, i32 noundef 419) #4, !dbg !682
  unreachable, !dbg !682

6:                                                ; No predecessors!
  br label %lor.end5, !dbg !682

lor.end5:                                         ; preds = %6, %lor.end
  %7 = phi i1 [ true, %lor.end ], [ false, %6 ]
  %lor.ext6 = zext i1 %7 to i32, !dbg !682
  ret ptr null, !dbg !683
}

declare dso_local i32 @pthread_detach(i64 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @detach_test_attr(ptr noundef %ignore) #0 !dbg !684 {
entry:
  %ignore.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  %detachstate = alloca i32, align 4
  %w0 = alloca i64, align 8
  %w0_attr = alloca %struct.pthread_attr_t, align 8
  store ptr %ignore, ptr %ignore.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %ignore.addr, metadata !685, metadata !DIExpression()), !dbg !686
  call void @llvm.dbg.declare(metadata ptr %status, metadata !687, metadata !DIExpression()), !dbg !688
  call void @llvm.dbg.declare(metadata ptr %detachstate, metadata !689, metadata !DIExpression()), !dbg !690
  call void @llvm.dbg.declare(metadata ptr %w0, metadata !691, metadata !DIExpression()), !dbg !692
  call void @llvm.dbg.declare(metadata ptr %w0_attr, metadata !693, metadata !DIExpression()), !dbg !694
  %call = call i32 @pthread_attr_init(ptr noundef %w0_attr), !dbg !695
  store i32 %call, ptr %status, align 4, !dbg !696
  %0 = load i32, ptr %status, align 4, !dbg !697
  %cmp = icmp eq i32 %0, 0, !dbg !697
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !697

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 430) #4, !dbg !697
  unreachable, !dbg !697

1:                                                ; No predecessors!
  br label %lor.end, !dbg !697

lor.end:                                          ; preds = %1, %entry
  %2 = phi i1 [ true, %entry ], [ false, %1 ]
  %lor.ext = zext i1 %2 to i32, !dbg !697
  %call1 = call i32 @pthread_attr_getdetachstate(ptr noundef %w0_attr, ptr noundef %detachstate), !dbg !698
  store i32 %call1, ptr %status, align 4, !dbg !699
  %3 = load i32, ptr %status, align 4, !dbg !700
  %cmp2 = icmp eq i32 %3, 0, !dbg !700
  br i1 %cmp2, label %land.lhs.true, label %lor.rhs4, !dbg !700

land.lhs.true:                                    ; preds = %lor.end
  %4 = load i32, ptr %detachstate, align 4, !dbg !700
  %cmp3 = icmp eq i32 %4, 0, !dbg !700
  br i1 %cmp3, label %lor.end5, label %lor.rhs4, !dbg !700

lor.rhs4:                                         ; preds = %land.lhs.true, %lor.end
  call void @_assert(ptr noundef @.str.9, ptr noundef @.str.1, i32 noundef 432) #4, !dbg !700
  unreachable, !dbg !700

5:                                                ; No predecessors!
  br label %lor.end5, !dbg !700

lor.end5:                                         ; preds = %5, %land.lhs.true
  %6 = phi i1 [ true, %land.lhs.true ], [ false, %5 ]
  %lor.ext6 = zext i1 %6 to i32, !dbg !700
  %call7 = call i32 @pthread_attr_setdetachstate(ptr noundef %w0_attr, i32 noundef 4), !dbg !701
  store i32 %call7, ptr %status, align 4, !dbg !702
  %7 = load i32, ptr %status, align 4, !dbg !703
  %cmp8 = icmp eq i32 %7, 0, !dbg !703
  br i1 %cmp8, label %lor.end10, label %lor.rhs9, !dbg !703

lor.rhs9:                                         ; preds = %lor.end5
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 434) #4, !dbg !703
  unreachable, !dbg !703

8:                                                ; No predecessors!
  br label %lor.end10, !dbg !703

lor.end10:                                        ; preds = %8, %lor.end5
  %9 = phi i1 [ true, %lor.end5 ], [ false, %8 ]
  %lor.ext11 = zext i1 %9 to i32, !dbg !703
  %call12 = call i32 @pthread_attr_getdetachstate(ptr noundef %w0_attr, ptr noundef %detachstate), !dbg !704
  store i32 %call12, ptr %status, align 4, !dbg !705
  %10 = load i32, ptr %status, align 4, !dbg !706
  %cmp13 = icmp eq i32 %10, 0, !dbg !706
  br i1 %cmp13, label %land.lhs.true14, label %lor.rhs16, !dbg !706

land.lhs.true14:                                  ; preds = %lor.end10
  %11 = load i32, ptr %detachstate, align 4, !dbg !706
  %cmp15 = icmp eq i32 %11, 4, !dbg !706
  br i1 %cmp15, label %lor.end17, label %lor.rhs16, !dbg !706

lor.rhs16:                                        ; preds = %land.lhs.true14, %lor.end10
  call void @_assert(ptr noundef @.str.10, ptr noundef @.str.1, i32 noundef 436) #4, !dbg !706
  unreachable, !dbg !706

12:                                               ; No predecessors!
  br label %lor.end17, !dbg !706

lor.end17:                                        ; preds = %12, %land.lhs.true14
  %13 = phi i1 [ true, %land.lhs.true14 ], [ false, %12 ]
  %lor.ext18 = zext i1 %13 to i32, !dbg !706
  %call19 = call i32 @pthread_create(ptr noundef %w0, ptr noundef %w0_attr, ptr noundef @detach_test_worker0, ptr noundef null), !dbg !707
  store i32 %call19, ptr %status, align 4, !dbg !708
  %14 = load i32, ptr %status, align 4, !dbg !709
  %cmp20 = icmp eq i32 %14, 0, !dbg !709
  br i1 %cmp20, label %lor.end22, label %lor.rhs21, !dbg !709

lor.rhs21:                                        ; preds = %lor.end17
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 438) #4, !dbg !709
  unreachable, !dbg !709

15:                                               ; No predecessors!
  br label %lor.end22, !dbg !709

lor.end22:                                        ; preds = %15, %lor.end17
  %16 = phi i1 [ true, %lor.end17 ], [ false, %15 ]
  %lor.ext23 = zext i1 %16 to i32, !dbg !709
  %call24 = call i32 @pthread_attr_destroy(ptr noundef %w0_attr), !dbg !710
  %17 = load i64, ptr %w0, align 8, !dbg !711
  %call25 = call i32 @pthread_join(i64 noundef %17, ptr noundef null), !dbg !712
  store i32 %call25, ptr %status, align 4, !dbg !713
  %18 = load i32, ptr %status, align 4, !dbg !714
  %cmp26 = icmp ne i32 %18, 0, !dbg !714
  br i1 %cmp26, label %lor.end28, label %lor.rhs27, !dbg !714

lor.rhs27:                                        ; preds = %lor.end22
  call void @_assert(ptr noundef @.str.8, ptr noundef @.str.1, i32 noundef 442) #4, !dbg !714
  unreachable, !dbg !714

19:                                               ; No predecessors!
  br label %lor.end28, !dbg !714

lor.end28:                                        ; preds = %19, %lor.end22
  %20 = phi i1 [ true, %lor.end22 ], [ false, %19 ]
  %lor.ext29 = zext i1 %20 to i32, !dbg !714
  ret ptr null, !dbg !715
}

declare dso_local i32 @pthread_attr_getdetachstate(ptr noundef, ptr noundef) #2

declare dso_local i32 @pthread_attr_setdetachstate(ptr noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @detach_test() #0 !dbg !716 {
entry:
  %call = call i64 @thread_create(ptr noundef @detach_test_detach, ptr noundef null), !dbg !717
  %call1 = call i64 @thread_create(ptr noundef @detach_test_attr, ptr noundef null), !dbg !718
  ret void, !dbg !719
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @once_init0() #0 !dbg !720 {
entry:
  %0 = load i32, ptr @once_calls, align 4, !dbg !721
  %inc = add nsw i32 %0, 1, !dbg !721
  store i32 %inc, ptr @once_calls, align 4, !dbg !721
  store i32 42, ptr @once_value, align 4, !dbg !722
  ret void, !dbg !723
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @once_init1() #0 !dbg !724 {
entry:
  %0 = load i32, ptr @once_calls, align 4, !dbg !725
  %inc = add nsw i32 %0, 1, !dbg !725
  store i32 %inc, ptr @once_calls, align 4, !dbg !725
  ret void, !dbg !726
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @once_worker(ptr noundef %ignore) #0 !dbg !727 {
entry:
  %ignore.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %ignore, ptr %ignore.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %ignore.addr, metadata !728, metadata !DIExpression()), !dbg !729
  call void @llvm.dbg.declare(metadata ptr %status, metadata !730, metadata !DIExpression()), !dbg !731
  %call = call i32 @pthread_once(ptr noundef @once0, ptr noundef @once_init0), !dbg !732
  store i32 %call, ptr %status, align 4, !dbg !731
  %0 = load i32, ptr %status, align 4, !dbg !733
  %cmp = icmp eq i32 %0, 0, !dbg !733
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !733

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 473) #4, !dbg !733
  unreachable, !dbg !733

1:                                                ; No predecessors!
  br label %lor.end, !dbg !733

lor.end:                                          ; preds = %1, %entry
  %2 = phi i1 [ true, %entry ], [ false, %1 ]
  %lor.ext = zext i1 %2 to i32, !dbg !733
  %3 = load i32, ptr @once_value, align 4, !dbg !734
  %cmp1 = icmp eq i32 %3, 42, !dbg !734
  br i1 %cmp1, label %lor.end3, label %lor.rhs2, !dbg !734

lor.rhs2:                                         ; preds = %lor.end
  call void @_assert(ptr noundef @.str.11, ptr noundef @.str.1, i32 noundef 474) #4, !dbg !734
  unreachable, !dbg !734

4:                                                ; No predecessors!
  br label %lor.end3, !dbg !734

lor.end3:                                         ; preds = %4, %lor.end
  %5 = phi i1 [ true, %lor.end ], [ false, %4 ]
  %lor.ext4 = zext i1 %5 to i32, !dbg !734
  ret ptr null, !dbg !735
}

declare dso_local i32 @pthread_once(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @once_test() #0 !dbg !736 {
entry:
  %worker0 = alloca i64, align 8
  %worker1 = alloca i64, align 8
  %status = alloca i32, align 4
  call void @llvm.dbg.declare(metadata ptr %worker0, metadata !737, metadata !DIExpression()), !dbg !738
  %call = call i64 @thread_create(ptr noundef @once_worker, ptr noundef null), !dbg !739
  store i64 %call, ptr %worker0, align 8, !dbg !738
  call void @llvm.dbg.declare(metadata ptr %worker1, metadata !740, metadata !DIExpression()), !dbg !741
  %call1 = call i64 @thread_create(ptr noundef @once_worker, ptr noundef null), !dbg !742
  store i64 %call1, ptr %worker1, align 8, !dbg !741
  %0 = load i64, ptr %worker0, align 8, !dbg !743
  %call2 = call ptr @thread_join(i64 noundef %0), !dbg !744
  %1 = load i64, ptr %worker1, align 8, !dbg !745
  %call3 = call ptr @thread_join(i64 noundef %1), !dbg !746
  %2 = load i32, ptr @once_calls, align 4, !dbg !747
  %cmp = icmp eq i32 %2, 1, !dbg !747
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !747

lor.rhs:                                          ; preds = %entry
  call void @_assert(ptr noundef @.str.12, ptr noundef @.str.1, i32 noundef 484) #4, !dbg !747
  unreachable, !dbg !747

3:                                                ; No predecessors!
  br label %lor.end, !dbg !747

lor.end:                                          ; preds = %3, %entry
  %4 = phi i1 [ true, %entry ], [ false, %3 ]
  %lor.ext = zext i1 %4 to i32, !dbg !747
  call void @llvm.dbg.declare(metadata ptr %status, metadata !748, metadata !DIExpression()), !dbg !749
  %call4 = call i32 @pthread_once(ptr noundef @once1, ptr noundef @once_init1), !dbg !750
  store i32 %call4, ptr %status, align 4, !dbg !749
  %5 = load i32, ptr %status, align 4, !dbg !751
  %cmp5 = icmp eq i32 %5, 0, !dbg !751
  br i1 %cmp5, label %lor.end7, label %lor.rhs6, !dbg !751

lor.rhs6:                                         ; preds = %lor.end
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 487) #4, !dbg !751
  unreachable, !dbg !751

6:                                                ; No predecessors!
  br label %lor.end7, !dbg !751

lor.end7:                                         ; preds = %6, %lor.end
  %7 = phi i1 [ true, %lor.end ], [ false, %6 ]
  %lor.ext8 = zext i1 %7 to i32, !dbg !751
  %call9 = call i32 @pthread_once(ptr noundef @once1, ptr noundef @once_init1), !dbg !752
  store i32 %call9, ptr %status, align 4, !dbg !753
  %8 = load i32, ptr %status, align 4, !dbg !754
  %cmp10 = icmp eq i32 %8, 0, !dbg !754
  br i1 %cmp10, label %lor.end12, label %lor.rhs11, !dbg !754

lor.rhs11:                                        ; preds = %lor.end7
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 489) #4, !dbg !754
  unreachable, !dbg !754

9:                                                ; No predecessors!
  br label %lor.end12, !dbg !754

lor.end12:                                        ; preds = %9, %lor.end7
  %10 = phi i1 [ true, %lor.end7 ], [ false, %9 ]
  %lor.ext13 = zext i1 %10 to i32, !dbg !754
  %11 = load i32, ptr @once_calls, align 4, !dbg !755
  %cmp14 = icmp eq i32 %11, 2, !dbg !755
  br i1 %cmp14, label %lor.end16, label %lor.rhs15, !dbg !755

lor.rhs15:                                        ; preds = %lor.end12
  call void @_assert(ptr noundef @.str.13, ptr noundef @.str.1, i32 noundef 490) #4, !dbg !755
  unreachable, !dbg !755

12:                                               ; No predecessors!
  br label %lor.end16, !dbg !755

lor.end16:                                        ; preds = %12, %lor.end12
  %13 = phi i1 [ true, %lor.end12 ], [ false, %12 ]
  %lor.ext17 = zext i1 %13 to i32, !dbg !755
  ret void, !dbg !756
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !757 {
entry:
  %retval = alloca i32, align 4
  store i32 0, ptr %retval, align 4
  %call = call i32 @__VERIFIER_nondet_int(), !dbg !760
  switch i32 %call, label %sw.epilog [
    i32 1, label %sw.bb
    i32 2, label %sw.bb1
    i32 3, label %sw.bb2
    i32 4, label %sw.bb3
    i32 5, label %sw.bb4
    i32 6, label %sw.bb5
  ], !dbg !761

sw.bb:                                            ; preds = %entry
  call void @mutex_test(), !dbg !762
  br label %sw.epilog, !dbg !764

sw.bb1:                                           ; preds = %entry
  call void @cond_test(), !dbg !765
  br label %sw.epilog, !dbg !766

sw.bb2:                                           ; preds = %entry
  call void @rwlock_test(), !dbg !767
  br label %sw.epilog, !dbg !768

sw.bb3:                                           ; preds = %entry
  call void @key_test(), !dbg !769
  br label %sw.epilog, !dbg !770

sw.bb4:                                           ; preds = %entry
  call void @detach_test(), !dbg !771
  br label %sw.epilog, !dbg !772

sw.bb5:                                           ; preds = %entry
  call void @once_test(), !dbg !773
  br label %sw.epilog, !dbg !774

sw.epilog:                                        ; preds = %entry, %sw.bb5, %sw.bb4, %sw.bb3, %sw.bb2, %sw.bb1, %sw.bb
  %0 = load i32, ptr %retval, align 4, !dbg !775
  ret i32 %0, !dbg !775
}

declare dso_local i32 @__VERIFIER_nondet_int() #2

attributes #0 = { noinline nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn }

!llvm.dbg.cu = !{!29}
!llvm.module.flags = !{!100, !101, !102, !103, !104, !105}
!llvm.ident = !{!106}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 19, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "pthread.c", directory: "/w")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 96, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 12)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 19, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 80, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 10)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !2, line: 86, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 248, elements: !15)
!15 = !{!16}
!16 = !DISubrange(count: 31)
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(scope: null, file: !2, line: 107, type: !19, isLocal: true, isDefinition: true)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 72, elements: !20)
!20 = !{!21}
!21 = !DISubrange(count: 9)
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(scope: null, file: !2, line: 116, type: !24, isLocal: true, isDefinition: true)
!24 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 64, elements: !25)
!25 = !{!26}
!26 = !DISubrange(count: 8)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(name: "phase", scope: !29, file: !2, line: 189, type: !97, isLocal: false, isDefinition: true)
!29 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Ubuntu clang version 17.0.6 (9ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !30, globals: !33, splitDebugInlining: false, nameTableKind: None)
!30 = !{!31, !32}
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!33 = !{!0, !7, !12, !17, !22, !27, !34, !39, !44, !49, !51, !56, !58, !63, !65, !70, !75, !77, !83, !86, !91, !95, !98}
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(scope: null, file: !2, line: 241, type: !36, isLocal: true, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 144, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: 18)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(scope: null, file: !2, line: 371, type: !41, isLocal: true, isDefinition: true)
!41 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 224, elements: !42)
!42 = !{!43}
!43 = !DISubrange(count: 28)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(scope: null, file: !2, line: 401, type: !46, isLocal: true, isDefinition: true)
!46 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 296, elements: !47)
!47 = !{!48}
!48 = !DISubrange(count: 37)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(scope: null, file: !2, line: 419, type: !3, isLocal: true, isDefinition: true)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(scope: null, file: !2, line: 432, type: !53, isLocal: true, isDefinition: true)
!53 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 432, elements: !54)
!54 = !{!55}
!55 = !DISubrange(count: 54)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(scope: null, file: !2, line: 436, type: !53, isLocal: true, isDefinition: true)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "once0", scope: !29, file: !2, line: 454, type: !60, isLocal: false, isDefinition: true)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_once_t", file: !61, line: 185, baseType: !62)
!61 = !DIFile(filename: "/usr/x86_64-w64-mingw32/include/pthread.h", directory: "")
!62 = !DIBasicType(name: "long", size: 32, encoding: DW_ATE_signed)
!63 = !DIGlobalVariableExpression(var: !64, expr: !DIExpression())
!64 = distinct !DIGlobalVariable(name: "once1", scope: !29, file: !2, line: 455, type: !60, isLocal: false, isDefinition: true)
!65 = !DIGlobalVariableExpression(var: !66, expr: !DIExpression())
!66 = distinct !DIGlobalVariable(scope: null, file: !2, line: 474, type: !67, isLocal: true, isDefinition: true)
!67 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 136, elements: !68)
!68 = !{!69}
!69 = !DISubrange(count: 17)
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(scope: null, file: !2, line: 484, type: !72, isLocal: true, isDefinition: true)
!72 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 128, elements: !73)
!73 = !{!74}
!74 = !DISubrange(count: 16)
!75 = !DIGlobalVariableExpression(var: !76, expr: !DIExpression())
!76 = distinct !DIGlobalVariable(scope: null, file: !2, line: 490, type: !72, isLocal: true, isDefinition: true)
!77 = !DIGlobalVariableExpression(var: !78, expr: !DIExpression())
!78 = distinct !DIGlobalVariable(name: "cond_mutex", scope: !29, file: !2, line: 187, type: !79, isLocal: false, isDefinition: true)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !61, line: 260, baseType: !80)
!80 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !81, line: 62, baseType: !82)
!81 = !DIFile(filename: "/usr/x86_64-w64-mingw32/include/corecrt.h", directory: "")
!82 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!83 = !DIGlobalVariableExpression(var: !84, expr: !DIExpression())
!84 = distinct !DIGlobalVariable(name: "cond", scope: !29, file: !2, line: 188, type: !85, isLocal: false, isDefinition: true)
!85 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_cond_t", file: !61, line: 261, baseType: !80)
!86 = !DIGlobalVariableExpression(var: !87, expr: !DIExpression())
!87 = distinct !DIGlobalVariable(name: "latest_thread", scope: !29, file: !2, line: 355, type: !88, isLocal: false, isDefinition: true)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !61, line: 201, baseType: !89)
!89 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !81, line: 75, baseType: !90)
!90 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!91 = !DIGlobalVariableExpression(var: !92, expr: !DIExpression())
!92 = distinct !DIGlobalVariable(name: "local_data", scope: !29, file: !2, line: 356, type: !93, isLocal: false, isDefinition: true)
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_key_t", file: !61, line: 187, baseType: !94)
!94 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!95 = !DIGlobalVariableExpression(var: !96, expr: !DIExpression())
!96 = distinct !DIGlobalVariable(name: "once_calls", scope: !29, file: !2, line: 456, type: !97, isLocal: false, isDefinition: true)
!97 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!98 = !DIGlobalVariableExpression(var: !99, expr: !DIExpression())
!99 = distinct !DIGlobalVariable(name: "once_value", scope: !29, file: !2, line: 457, type: !97, isLocal: false, isDefinition: true)
!100 = !{i32 7, !"Dwarf Version", i32 4}
!101 = !{i32 2, !"Debug Info Version", i32 3}
!102 = !{i32 1, !"wchar_size", i32 2}
!103 = !{i32 8, !"PIC Level", i32 2}
!104 = !{i32 7, !"uwtable", i32 2}
!105 = !{i32 1, !"MaxTLSAlign", i32 65536}
!106 = !{!"Ubuntu clang version 17.0.6 (9ubuntu1)"}
!107 = distinct !DISubprogram(name: "thread_create", scope: !2, file: !2, line: 13, type: !108, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!108 = !DISubroutineType(types: !109)
!109 = !{!88, !110, !32}
!110 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !111, size: 64)
!111 = !DISubroutineType(types: !112)
!112 = !{!32, !32}
!113 = !{}
!114 = !DILocalVariable(name: "runner", arg: 1, scope: !107, file: !2, line: 13, type: !110)
!115 = !DILocation(line: 13, column: 32, scope: !107)
!116 = !DILocalVariable(name: "data", arg: 2, scope: !107, file: !2, line: 13, type: !32)
!117 = !DILocation(line: 13, column: 54, scope: !107)
!118 = !DILocalVariable(name: "id", scope: !107, file: !2, line: 15, type: !88)
!119 = !DILocation(line: 15, column: 15, scope: !107)
!120 = !DILocalVariable(name: "attr", scope: !107, file: !2, line: 16, type: !121)
!121 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !61, line: 242, baseType: !122)
!122 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "pthread_attr_t", file: !61, line: 243, size: 256, elements: !123)
!123 = !{!124, !125, !126, !128}
!124 = !DIDerivedType(tag: DW_TAG_member, name: "p_state", scope: !122, file: !61, line: 245, baseType: !94, size: 32)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "stack", scope: !122, file: !61, line: 246, baseType: !32, size: 64, offset: 64)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "s_size", scope: !122, file: !61, line: 247, baseType: !127, size: 64, offset: 128)
!127 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !81, line: 35, baseType: !90)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "param", scope: !122, file: !61, line: 248, baseType: !129, size: 32, offset: 192)
!129 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "sched_param", file: !61, line: 230, size: 32, elements: !130)
!130 = !{!131}
!131 = !DIDerivedType(tag: DW_TAG_member, name: "sched_priority", scope: !129, file: !61, line: 231, baseType: !97, size: 32)
!132 = !DILocation(line: 16, column: 20, scope: !107)
!133 = !DILocation(line: 17, column: 5, scope: !107)
!134 = !DILocalVariable(name: "status", scope: !107, file: !2, line: 18, type: !97)
!135 = !DILocation(line: 18, column: 9, scope: !107)
!136 = !DILocation(line: 18, column: 45, scope: !107)
!137 = !DILocation(line: 18, column: 53, scope: !107)
!138 = !DILocation(line: 18, column: 18, scope: !107)
!139 = !DILocation(line: 19, column: 5, scope: !107)
!140 = !DILocation(line: 20, column: 5, scope: !107)
!141 = !DILocation(line: 21, column: 12, scope: !107)
!142 = !DILocation(line: 21, column: 5, scope: !107)
!143 = distinct !DISubprogram(name: "thread_join", scope: !2, file: !2, line: 24, type: !144, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!144 = !DISubroutineType(types: !145)
!145 = !{!32, !88}
!146 = !DILocalVariable(name: "id", arg: 1, scope: !143, file: !2, line: 24, type: !88)
!147 = !DILocation(line: 24, column: 29, scope: !143)
!148 = !DILocalVariable(name: "result", scope: !143, file: !2, line: 26, type: !32)
!149 = !DILocation(line: 26, column: 11, scope: !143)
!150 = !DILocalVariable(name: "status", scope: !143, file: !2, line: 27, type: !97)
!151 = !DILocation(line: 27, column: 9, scope: !143)
!152 = !DILocation(line: 27, column: 31, scope: !143)
!153 = !DILocation(line: 27, column: 18, scope: !143)
!154 = !DILocation(line: 28, column: 5, scope: !143)
!155 = !DILocation(line: 29, column: 12, scope: !143)
!156 = !DILocation(line: 29, column: 5, scope: !143)
!157 = distinct !DISubprogram(name: "mutex_init", scope: !2, file: !2, line: 42, type: !158, scopeLine: 43, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!158 = !DISubroutineType(types: !159)
!159 = !{null, !160, !97, !97, !97}
!160 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !79, size: 64)
!161 = !DILocalVariable(name: "lock", arg: 1, scope: !157, file: !2, line: 42, type: !160)
!162 = !DILocation(line: 42, column: 34, scope: !157)
!163 = !DILocalVariable(name: "type", arg: 2, scope: !157, file: !2, line: 42, type: !97)
!164 = !DILocation(line: 42, column: 44, scope: !157)
!165 = !DILocalVariable(name: "protocol", arg: 3, scope: !157, file: !2, line: 42, type: !97)
!166 = !DILocation(line: 42, column: 54, scope: !157)
!167 = !DILocalVariable(name: "prioceiling", arg: 4, scope: !157, file: !2, line: 42, type: !97)
!168 = !DILocation(line: 42, column: 68, scope: !157)
!169 = !DILocalVariable(name: "status", scope: !157, file: !2, line: 44, type: !97)
!170 = !DILocation(line: 44, column: 9, scope: !157)
!171 = !DILocalVariable(name: "value", scope: !157, file: !2, line: 45, type: !97)
!172 = !DILocation(line: 45, column: 9, scope: !157)
!173 = !DILocalVariable(name: "attributes", scope: !157, file: !2, line: 46, type: !174)
!174 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !61, line: 186, baseType: !94)
!175 = !DILocation(line: 46, column: 25, scope: !157)
!176 = !DILocation(line: 47, column: 14, scope: !157)
!177 = !DILocation(line: 47, column: 12, scope: !157)
!178 = !DILocation(line: 48, column: 5, scope: !157)
!179 = !DILocation(line: 50, column: 53, scope: !157)
!180 = !DILocation(line: 50, column: 14, scope: !157)
!181 = !DILocation(line: 50, column: 12, scope: !157)
!182 = !DILocation(line: 51, column: 5, scope: !157)
!183 = !DILocation(line: 52, column: 14, scope: !157)
!184 = !DILocation(line: 52, column: 12, scope: !157)
!185 = !DILocation(line: 53, column: 5, scope: !157)
!186 = !DILocation(line: 55, column: 57, scope: !157)
!187 = !DILocation(line: 55, column: 14, scope: !157)
!188 = !DILocation(line: 55, column: 12, scope: !157)
!189 = !DILocation(line: 56, column: 5, scope: !157)
!190 = !DILocation(line: 57, column: 14, scope: !157)
!191 = !DILocation(line: 57, column: 12, scope: !157)
!192 = !DILocation(line: 58, column: 5, scope: !157)
!193 = !DILocation(line: 60, column: 60, scope: !157)
!194 = !DILocation(line: 60, column: 14, scope: !157)
!195 = !DILocation(line: 60, column: 12, scope: !157)
!196 = !DILocation(line: 61, column: 5, scope: !157)
!197 = !DILocation(line: 62, column: 14, scope: !157)
!198 = !DILocation(line: 62, column: 12, scope: !157)
!199 = !DILocation(line: 63, column: 5, scope: !157)
!200 = !DILocation(line: 65, column: 33, scope: !157)
!201 = !DILocation(line: 65, column: 14, scope: !157)
!202 = !DILocation(line: 65, column: 12, scope: !157)
!203 = !DILocation(line: 66, column: 5, scope: !157)
!204 = !DILocation(line: 67, column: 14, scope: !157)
!205 = !DILocation(line: 67, column: 12, scope: !157)
!206 = !DILocation(line: 68, column: 5, scope: !157)
!207 = !DILocation(line: 69, column: 1, scope: !157)
!208 = distinct !DISubprogram(name: "mutex_destroy", scope: !2, file: !2, line: 71, type: !209, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!209 = !DISubroutineType(types: !210)
!210 = !{null, !160}
!211 = !DILocalVariable(name: "lock", arg: 1, scope: !208, file: !2, line: 71, type: !160)
!212 = !DILocation(line: 71, column: 37, scope: !208)
!213 = !DILocalVariable(name: "status", scope: !208, file: !2, line: 73, type: !97)
!214 = !DILocation(line: 73, column: 9, scope: !208)
!215 = !DILocation(line: 73, column: 40, scope: !208)
!216 = !DILocation(line: 73, column: 18, scope: !208)
!217 = !DILocation(line: 74, column: 5, scope: !208)
!218 = !DILocation(line: 75, column: 1, scope: !208)
!219 = distinct !DISubprogram(name: "mutex_lock", scope: !2, file: !2, line: 77, type: !209, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!220 = !DILocalVariable(name: "lock", arg: 1, scope: !219, file: !2, line: 77, type: !160)
!221 = !DILocation(line: 77, column: 34, scope: !219)
!222 = !DILocalVariable(name: "status", scope: !219, file: !2, line: 79, type: !97)
!223 = !DILocation(line: 79, column: 9, scope: !219)
!224 = !DILocation(line: 79, column: 37, scope: !219)
!225 = !DILocation(line: 79, column: 18, scope: !219)
!226 = !DILocation(line: 80, column: 5, scope: !219)
!227 = !DILocation(line: 81, column: 1, scope: !219)
!228 = distinct !DISubprogram(name: "mutex_trylock", scope: !2, file: !2, line: 83, type: !229, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!229 = !DISubroutineType(types: !230)
!230 = !{!231, !160}
!231 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!232 = !DILocalVariable(name: "lock", arg: 1, scope: !228, file: !2, line: 83, type: !160)
!233 = !DILocation(line: 83, column: 37, scope: !228)
!234 = !DILocalVariable(name: "status", scope: !228, file: !2, line: 85, type: !97)
!235 = !DILocation(line: 85, column: 9, scope: !228)
!236 = !DILocation(line: 85, column: 40, scope: !228)
!237 = !DILocation(line: 85, column: 18, scope: !228)
!238 = !DILocation(line: 86, column: 5, scope: !228)
!239 = !DILocation(line: 87, column: 12, scope: !228)
!240 = !DILocation(line: 87, column: 19, scope: !228)
!241 = !DILocation(line: 87, column: 5, scope: !228)
!242 = distinct !DISubprogram(name: "mutex_unlock", scope: !2, file: !2, line: 90, type: !209, scopeLine: 91, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!243 = !DILocalVariable(name: "lock", arg: 1, scope: !242, file: !2, line: 90, type: !160)
!244 = !DILocation(line: 90, column: 36, scope: !242)
!245 = !DILocalVariable(name: "status", scope: !242, file: !2, line: 92, type: !97)
!246 = !DILocation(line: 92, column: 9, scope: !242)
!247 = !DILocation(line: 92, column: 39, scope: !242)
!248 = !DILocation(line: 92, column: 18, scope: !242)
!249 = !DILocation(line: 93, column: 5, scope: !242)
!250 = !DILocation(line: 94, column: 1, scope: !242)
!251 = distinct !DISubprogram(name: "mutex_test", scope: !2, file: !2, line: 96, type: !252, scopeLine: 97, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!252 = !DISubroutineType(types: !253)
!253 = !{null}
!254 = !DILocalVariable(name: "mutex0", scope: !251, file: !2, line: 98, type: !79)
!255 = !DILocation(line: 98, column: 21, scope: !251)
!256 = !DILocalVariable(name: "mutex1", scope: !251, file: !2, line: 99, type: !79)
!257 = !DILocation(line: 99, column: 21, scope: !251)
!258 = !DILocation(line: 101, column: 5, scope: !251)
!259 = !DILocation(line: 102, column: 5, scope: !251)
!260 = !DILocation(line: 105, column: 9, scope: !261)
!261 = distinct !DILexicalBlock(scope: !251, file: !2, line: 104, column: 5)
!262 = !DILocalVariable(name: "success", scope: !261, file: !2, line: 106, type: !231)
!263 = !DILocation(line: 106, column: 14, scope: !261)
!264 = !DILocation(line: 106, column: 24, scope: !261)
!265 = !DILocation(line: 107, column: 9, scope: !261)
!266 = !DILocation(line: 108, column: 9, scope: !261)
!267 = !DILocation(line: 112, column: 9, scope: !268)
!268 = distinct !DILexicalBlock(scope: !251, file: !2, line: 111, column: 5)
!269 = !DILocalVariable(name: "success", scope: !270, file: !2, line: 115, type: !231)
!270 = distinct !DILexicalBlock(scope: !268, file: !2, line: 114, column: 9)
!271 = !DILocation(line: 115, column: 18, scope: !270)
!272 = !DILocation(line: 115, column: 28, scope: !270)
!273 = !DILocation(line: 116, column: 13, scope: !270)
!274 = !DILocation(line: 117, column: 13, scope: !270)
!275 = !DILocalVariable(name: "success", scope: !276, file: !2, line: 121, type: !231)
!276 = distinct !DILexicalBlock(scope: !268, file: !2, line: 120, column: 9)
!277 = !DILocation(line: 121, column: 18, scope: !276)
!278 = !DILocation(line: 121, column: 28, scope: !276)
!279 = !DILocation(line: 122, column: 13, scope: !276)
!280 = !DILocation(line: 123, column: 13, scope: !276)
!281 = !DILocation(line: 128, column: 9, scope: !268)
!282 = !DILocation(line: 131, column: 5, scope: !251)
!283 = !DILocation(line: 132, column: 5, scope: !251)
!284 = !DILocation(line: 133, column: 1, scope: !251)
!285 = distinct !DISubprogram(name: "cond_init", scope: !2, file: !2, line: 137, type: !286, scopeLine: 138, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!286 = !DISubroutineType(types: !287)
!287 = !{null, !288}
!288 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !85, size: 64)
!289 = !DILocalVariable(name: "cond", arg: 1, scope: !285, file: !2, line: 137, type: !288)
!290 = !DILocation(line: 137, column: 32, scope: !285)
!291 = !DILocalVariable(name: "status", scope: !285, file: !2, line: 139, type: !97)
!292 = !DILocation(line: 139, column: 9, scope: !285)
!293 = !DILocalVariable(name: "attr", scope: !285, file: !2, line: 140, type: !294)
!294 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_condattr_t", file: !61, line: 189, baseType: !97)
!295 = !DILocation(line: 140, column: 24, scope: !285)
!296 = !DILocation(line: 142, column: 14, scope: !285)
!297 = !DILocation(line: 142, column: 12, scope: !285)
!298 = !DILocation(line: 143, column: 5, scope: !285)
!299 = !DILocation(line: 145, column: 32, scope: !285)
!300 = !DILocation(line: 145, column: 14, scope: !285)
!301 = !DILocation(line: 145, column: 12, scope: !285)
!302 = !DILocation(line: 146, column: 5, scope: !285)
!303 = !DILocation(line: 148, column: 14, scope: !285)
!304 = !DILocation(line: 148, column: 12, scope: !285)
!305 = !DILocation(line: 149, column: 5, scope: !285)
!306 = !DILocation(line: 150, column: 1, scope: !285)
!307 = distinct !DISubprogram(name: "cond_destroy", scope: !2, file: !2, line: 152, type: !286, scopeLine: 153, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!308 = !DILocalVariable(name: "cond", arg: 1, scope: !307, file: !2, line: 152, type: !288)
!309 = !DILocation(line: 152, column: 35, scope: !307)
!310 = !DILocalVariable(name: "status", scope: !307, file: !2, line: 154, type: !97)
!311 = !DILocation(line: 154, column: 9, scope: !307)
!312 = !DILocation(line: 154, column: 39, scope: !307)
!313 = !DILocation(line: 154, column: 18, scope: !307)
!314 = !DILocation(line: 155, column: 5, scope: !307)
!315 = !DILocation(line: 156, column: 1, scope: !307)
!316 = distinct !DISubprogram(name: "cond_signal", scope: !2, file: !2, line: 158, type: !286, scopeLine: 159, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!317 = !DILocalVariable(name: "cond", arg: 1, scope: !316, file: !2, line: 158, type: !288)
!318 = !DILocation(line: 158, column: 34, scope: !316)
!319 = !DILocalVariable(name: "status", scope: !316, file: !2, line: 160, type: !97)
!320 = !DILocation(line: 160, column: 9, scope: !316)
!321 = !DILocation(line: 160, column: 38, scope: !316)
!322 = !DILocation(line: 160, column: 18, scope: !316)
!323 = !DILocation(line: 161, column: 5, scope: !316)
!324 = !DILocation(line: 162, column: 1, scope: !316)
!325 = distinct !DISubprogram(name: "cond_broadcast", scope: !2, file: !2, line: 164, type: !286, scopeLine: 165, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!326 = !DILocalVariable(name: "cond", arg: 1, scope: !325, file: !2, line: 164, type: !288)
!327 = !DILocation(line: 164, column: 37, scope: !325)
!328 = !DILocalVariable(name: "status", scope: !325, file: !2, line: 166, type: !97)
!329 = !DILocation(line: 166, column: 9, scope: !325)
!330 = !DILocation(line: 166, column: 41, scope: !325)
!331 = !DILocation(line: 166, column: 18, scope: !325)
!332 = !DILocation(line: 167, column: 5, scope: !325)
!333 = !DILocation(line: 168, column: 1, scope: !325)
!334 = distinct !DISubprogram(name: "cond_wait", scope: !2, file: !2, line: 170, type: !335, scopeLine: 171, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!335 = !DISubroutineType(types: !336)
!336 = !{null, !288, !160}
!337 = !DILocalVariable(name: "cond", arg: 1, scope: !334, file: !2, line: 170, type: !288)
!338 = !DILocation(line: 170, column: 32, scope: !334)
!339 = !DILocalVariable(name: "lock", arg: 2, scope: !334, file: !2, line: 170, type: !160)
!340 = !DILocation(line: 170, column: 55, scope: !334)
!341 = !DILocalVariable(name: "status", scope: !334, file: !2, line: 172, type: !97)
!342 = !DILocation(line: 172, column: 9, scope: !334)
!343 = !DILocation(line: 172, column: 36, scope: !334)
!344 = !DILocation(line: 172, column: 42, scope: !334)
!345 = !DILocation(line: 172, column: 18, scope: !334)
!346 = !DILocation(line: 174, column: 1, scope: !334)
!347 = distinct !DISubprogram(name: "cond_timedwait", scope: !2, file: !2, line: 176, type: !348, scopeLine: 177, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!348 = !DISubroutineType(types: !349)
!349 = !{null, !288, !160, !82}
!350 = !DILocalVariable(name: "cond", arg: 1, scope: !347, file: !2, line: 176, type: !288)
!351 = !DILocation(line: 176, column: 37, scope: !347)
!352 = !DILocalVariable(name: "lock", arg: 2, scope: !347, file: !2, line: 176, type: !160)
!353 = !DILocation(line: 176, column: 60, scope: !347)
!354 = !DILocalVariable(name: "millis", arg: 3, scope: !347, file: !2, line: 176, type: !82)
!355 = !DILocation(line: 176, column: 76, scope: !347)
!356 = !DILocalVariable(name: "ts", scope: !347, file: !2, line: 179, type: !357)
!357 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !358, line: 89, size: 128, elements: !359)
!358 = !DIFile(filename: "/usr/x86_64-w64-mingw32/include/sys/types.h", directory: "")
!359 = !{!360, !363}
!360 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !357, file: !358, line: 90, baseType: !361, size: 64)
!361 = !DIDerivedType(tag: DW_TAG_typedef, name: "time_t", file: !81, line: 138, baseType: !362)
!362 = !DIDerivedType(tag: DW_TAG_typedef, name: "__time64_t", file: !81, line: 123, baseType: !82)
!363 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !357, file: !358, line: 91, baseType: !62, size: 32, offset: 64)
!364 = !DILocation(line: 179, column: 21, scope: !347)
!365 = !DILocation(line: 183, column: 11, scope: !347)
!366 = !DILocalVariable(name: "status", scope: !347, file: !2, line: 184, type: !97)
!367 = !DILocation(line: 184, column: 9, scope: !347)
!368 = !DILocation(line: 184, column: 41, scope: !347)
!369 = !DILocation(line: 184, column: 47, scope: !347)
!370 = !DILocation(line: 184, column: 18, scope: !347)
!371 = !DILocation(line: 185, column: 1, scope: !347)
!372 = distinct !DISubprogram(name: "cond_worker", scope: !2, file: !2, line: 191, type: !111, scopeLine: 192, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!373 = !DILocalVariable(name: "message", arg: 1, scope: !372, file: !2, line: 191, type: !32)
!374 = !DILocation(line: 191, column: 25, scope: !372)
!375 = !DILocalVariable(name: "idle", scope: !372, file: !2, line: 193, type: !231)
!376 = !DILocation(line: 193, column: 10, scope: !372)
!377 = !DILocation(line: 195, column: 9, scope: !378)
!378 = distinct !DILexicalBlock(scope: !372, file: !2, line: 194, column: 5)
!379 = !DILocation(line: 196, column: 9, scope: !378)
!380 = !DILocation(line: 197, column: 9, scope: !378)
!381 = !DILocation(line: 198, column: 9, scope: !378)
!382 = !DILocation(line: 199, column: 16, scope: !378)
!383 = !DILocation(line: 199, column: 22, scope: !378)
!384 = !DILocation(line: 199, column: 14, scope: !378)
!385 = !DILocation(line: 200, column: 9, scope: !378)
!386 = !DILocation(line: 202, column: 9, scope: !387)
!387 = distinct !DILexicalBlock(scope: !372, file: !2, line: 202, column: 9)
!388 = !DILocation(line: 202, column: 9, scope: !372)
!389 = !DILocation(line: 203, column: 25, scope: !387)
!390 = !DILocation(line: 203, column: 34, scope: !387)
!391 = !DILocation(line: 203, column: 9, scope: !387)
!392 = !DILocation(line: 204, column: 10, scope: !372)
!393 = !DILocation(line: 206, column: 9, scope: !394)
!394 = distinct !DILexicalBlock(scope: !372, file: !2, line: 205, column: 5)
!395 = !DILocation(line: 207, column: 9, scope: !394)
!396 = !DILocation(line: 208, column: 9, scope: !394)
!397 = !DILocation(line: 209, column: 9, scope: !394)
!398 = !DILocation(line: 210, column: 16, scope: !394)
!399 = !DILocation(line: 210, column: 22, scope: !394)
!400 = !DILocation(line: 210, column: 14, scope: !394)
!401 = !DILocation(line: 211, column: 9, scope: !394)
!402 = !DILocation(line: 213, column: 9, scope: !403)
!403 = distinct !DILexicalBlock(scope: !372, file: !2, line: 213, column: 9)
!404 = !DILocation(line: 213, column: 9, scope: !372)
!405 = !DILocation(line: 214, column: 25, scope: !403)
!406 = !DILocation(line: 214, column: 34, scope: !403)
!407 = !DILocation(line: 214, column: 9, scope: !403)
!408 = !DILocation(line: 215, column: 12, scope: !372)
!409 = !DILocation(line: 215, column: 5, scope: !372)
!410 = !DILocation(line: 216, column: 1, scope: !372)
!411 = distinct !DISubprogram(name: "cond_test", scope: !2, file: !2, line: 218, type: !252, scopeLine: 219, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!412 = !DILocalVariable(name: "message", scope: !411, file: !2, line: 220, type: !32)
!413 = !DILocation(line: 220, column: 11, scope: !411)
!414 = !DILocation(line: 221, column: 5, scope: !411)
!415 = !DILocation(line: 222, column: 5, scope: !411)
!416 = !DILocalVariable(name: "worker", scope: !411, file: !2, line: 224, type: !88)
!417 = !DILocation(line: 224, column: 15, scope: !411)
!418 = !DILocation(line: 224, column: 51, scope: !411)
!419 = !DILocation(line: 224, column: 24, scope: !411)
!420 = !DILocation(line: 227, column: 9, scope: !421)
!421 = distinct !DILexicalBlock(scope: !411, file: !2, line: 226, column: 5)
!422 = !DILocation(line: 228, column: 9, scope: !421)
!423 = !DILocation(line: 229, column: 9, scope: !421)
!424 = !DILocation(line: 230, column: 9, scope: !421)
!425 = !DILocation(line: 234, column: 9, scope: !426)
!426 = distinct !DILexicalBlock(scope: !411, file: !2, line: 233, column: 5)
!427 = !DILocation(line: 235, column: 9, scope: !426)
!428 = !DILocation(line: 236, column: 9, scope: !426)
!429 = !DILocation(line: 237, column: 9, scope: !426)
!430 = !DILocalVariable(name: "result", scope: !411, file: !2, line: 240, type: !32)
!431 = !DILocation(line: 240, column: 11, scope: !411)
!432 = !DILocation(line: 240, column: 32, scope: !411)
!433 = !DILocation(line: 240, column: 20, scope: !411)
!434 = !DILocation(line: 241, column: 5, scope: !411)
!435 = !DILocation(line: 243, column: 5, scope: !411)
!436 = !DILocation(line: 244, column: 5, scope: !411)
!437 = !DILocation(line: 245, column: 1, scope: !411)
!438 = distinct !DISubprogram(name: "rwlock_init", scope: !2, file: !2, line: 252, type: !439, scopeLine: 253, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!439 = !DISubroutineType(types: !440)
!440 = !{null, !441, !97}
!441 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !442, size: 64)
!442 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlock_t", file: !61, line: 262, baseType: !80)
!443 = !DILocalVariable(name: "lock", arg: 1, scope: !438, file: !2, line: 252, type: !441)
!444 = !DILocation(line: 252, column: 36, scope: !438)
!445 = !DILocalVariable(name: "shared", arg: 2, scope: !438, file: !2, line: 252, type: !97)
!446 = !DILocation(line: 252, column: 46, scope: !438)
!447 = !DILocalVariable(name: "status", scope: !438, file: !2, line: 254, type: !97)
!448 = !DILocation(line: 254, column: 9, scope: !438)
!449 = !DILocalVariable(name: "value", scope: !438, file: !2, line: 255, type: !97)
!450 = !DILocation(line: 255, column: 9, scope: !438)
!451 = !DILocalVariable(name: "attributes", scope: !438, file: !2, line: 256, type: !452)
!452 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlockattr_t", file: !61, line: 190, baseType: !97)
!453 = !DILocation(line: 256, column: 26, scope: !438)
!454 = !DILocation(line: 257, column: 14, scope: !438)
!455 = !DILocation(line: 257, column: 12, scope: !438)
!456 = !DILocation(line: 258, column: 5, scope: !438)
!457 = !DILocation(line: 260, column: 57, scope: !438)
!458 = !DILocation(line: 260, column: 14, scope: !438)
!459 = !DILocation(line: 260, column: 12, scope: !438)
!460 = !DILocation(line: 261, column: 5, scope: !438)
!461 = !DILocation(line: 262, column: 14, scope: !438)
!462 = !DILocation(line: 262, column: 12, scope: !438)
!463 = !DILocation(line: 263, column: 5, scope: !438)
!464 = !DILocation(line: 265, column: 34, scope: !438)
!465 = !DILocation(line: 265, column: 14, scope: !438)
!466 = !DILocation(line: 265, column: 12, scope: !438)
!467 = !DILocation(line: 266, column: 5, scope: !438)
!468 = !DILocation(line: 267, column: 14, scope: !438)
!469 = !DILocation(line: 267, column: 12, scope: !438)
!470 = !DILocation(line: 268, column: 5, scope: !438)
!471 = !DILocation(line: 269, column: 1, scope: !438)
!472 = distinct !DISubprogram(name: "rwlock_destroy", scope: !2, file: !2, line: 271, type: !473, scopeLine: 272, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!473 = !DISubroutineType(types: !474)
!474 = !{null, !441}
!475 = !DILocalVariable(name: "lock", arg: 1, scope: !472, file: !2, line: 271, type: !441)
!476 = !DILocation(line: 271, column: 39, scope: !472)
!477 = !DILocalVariable(name: "status", scope: !472, file: !2, line: 273, type: !97)
!478 = !DILocation(line: 273, column: 9, scope: !472)
!479 = !DILocation(line: 273, column: 41, scope: !472)
!480 = !DILocation(line: 273, column: 18, scope: !472)
!481 = !DILocation(line: 274, column: 5, scope: !472)
!482 = !DILocation(line: 275, column: 1, scope: !472)
!483 = distinct !DISubprogram(name: "rwlock_wrlock", scope: !2, file: !2, line: 277, type: !473, scopeLine: 278, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!484 = !DILocalVariable(name: "lock", arg: 1, scope: !483, file: !2, line: 277, type: !441)
!485 = !DILocation(line: 277, column: 38, scope: !483)
!486 = !DILocalVariable(name: "status", scope: !483, file: !2, line: 279, type: !97)
!487 = !DILocation(line: 279, column: 9, scope: !483)
!488 = !DILocation(line: 279, column: 40, scope: !483)
!489 = !DILocation(line: 279, column: 18, scope: !483)
!490 = !DILocation(line: 280, column: 5, scope: !483)
!491 = !DILocation(line: 281, column: 1, scope: !483)
!492 = distinct !DISubprogram(name: "rwlock_trywrlock", scope: !2, file: !2, line: 283, type: !493, scopeLine: 284, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!493 = !DISubroutineType(types: !494)
!494 = !{!231, !441}
!495 = !DILocalVariable(name: "lock", arg: 1, scope: !492, file: !2, line: 283, type: !441)
!496 = !DILocation(line: 283, column: 41, scope: !492)
!497 = !DILocalVariable(name: "status", scope: !492, file: !2, line: 285, type: !97)
!498 = !DILocation(line: 285, column: 9, scope: !492)
!499 = !DILocation(line: 285, column: 43, scope: !492)
!500 = !DILocation(line: 285, column: 18, scope: !492)
!501 = !DILocation(line: 286, column: 5, scope: !492)
!502 = !DILocation(line: 287, column: 12, scope: !492)
!503 = !DILocation(line: 287, column: 19, scope: !492)
!504 = !DILocation(line: 287, column: 5, scope: !492)
!505 = distinct !DISubprogram(name: "rwlock_rdlock", scope: !2, file: !2, line: 290, type: !473, scopeLine: 291, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!506 = !DILocalVariable(name: "lock", arg: 1, scope: !505, file: !2, line: 290, type: !441)
!507 = !DILocation(line: 290, column: 38, scope: !505)
!508 = !DILocalVariable(name: "status", scope: !505, file: !2, line: 292, type: !97)
!509 = !DILocation(line: 292, column: 9, scope: !505)
!510 = !DILocation(line: 292, column: 40, scope: !505)
!511 = !DILocation(line: 292, column: 18, scope: !505)
!512 = !DILocation(line: 293, column: 5, scope: !505)
!513 = !DILocation(line: 294, column: 1, scope: !505)
!514 = distinct !DISubprogram(name: "rwlock_tryrdlock", scope: !2, file: !2, line: 296, type: !493, scopeLine: 297, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!515 = !DILocalVariable(name: "lock", arg: 1, scope: !514, file: !2, line: 296, type: !441)
!516 = !DILocation(line: 296, column: 41, scope: !514)
!517 = !DILocalVariable(name: "status", scope: !514, file: !2, line: 298, type: !97)
!518 = !DILocation(line: 298, column: 9, scope: !514)
!519 = !DILocation(line: 298, column: 43, scope: !514)
!520 = !DILocation(line: 298, column: 18, scope: !514)
!521 = !DILocation(line: 299, column: 5, scope: !514)
!522 = !DILocation(line: 300, column: 12, scope: !514)
!523 = !DILocation(line: 300, column: 19, scope: !514)
!524 = !DILocation(line: 300, column: 5, scope: !514)
!525 = distinct !DISubprogram(name: "rwlock_unlock", scope: !2, file: !2, line: 303, type: !473, scopeLine: 304, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!526 = !DILocalVariable(name: "lock", arg: 1, scope: !525, file: !2, line: 303, type: !441)
!527 = !DILocation(line: 303, column: 38, scope: !525)
!528 = !DILocalVariable(name: "status", scope: !525, file: !2, line: 305, type: !97)
!529 = !DILocation(line: 305, column: 9, scope: !525)
!530 = !DILocation(line: 305, column: 40, scope: !525)
!531 = !DILocation(line: 305, column: 18, scope: !525)
!532 = !DILocation(line: 306, column: 5, scope: !525)
!533 = !DILocation(line: 307, column: 1, scope: !525)
!534 = distinct !DISubprogram(name: "rwlock_test", scope: !2, file: !2, line: 309, type: !252, scopeLine: 310, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!535 = !DILocalVariable(name: "lock", scope: !534, file: !2, line: 311, type: !442)
!536 = !DILocation(line: 311, column: 22, scope: !534)
!537 = !DILocation(line: 312, column: 5, scope: !534)
!538 = !DILocalVariable(name: "test_depth", scope: !534, file: !2, line: 313, type: !539)
!539 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !97)
!540 = !DILocation(line: 313, column: 15, scope: !534)
!541 = !DILocation(line: 316, column: 9, scope: !542)
!542 = distinct !DILexicalBlock(scope: !534, file: !2, line: 315, column: 5)
!543 = !DILocalVariable(name: "success", scope: !542, file: !2, line: 317, type: !231)
!544 = !DILocation(line: 317, column: 14, scope: !542)
!545 = !DILocation(line: 317, column: 24, scope: !542)
!546 = !DILocation(line: 318, column: 9, scope: !542)
!547 = !DILocation(line: 319, column: 19, scope: !542)
!548 = !DILocation(line: 319, column: 17, scope: !542)
!549 = !DILocation(line: 320, column: 9, scope: !542)
!550 = !DILocation(line: 321, column: 9, scope: !542)
!551 = !DILocation(line: 325, column: 9, scope: !552)
!552 = distinct !DILexicalBlock(scope: !534, file: !2, line: 324, column: 5)
!553 = !DILocalVariable(name: "i", scope: !554, file: !2, line: 326, type: !97)
!554 = distinct !DILexicalBlock(scope: !552, file: !2, line: 326, column: 9)
!555 = !DILocation(line: 326, column: 18, scope: !554)
!556 = !DILocation(line: 326, column: 14, scope: !554)
!557 = !DILocation(line: 326, column: 25, scope: !558)
!558 = distinct !DILexicalBlock(scope: !554, file: !2, line: 326, column: 9)
!559 = !DILocation(line: 326, column: 27, scope: !558)
!560 = !DILocation(line: 326, column: 9, scope: !554)
!561 = !DILocalVariable(name: "success", scope: !562, file: !2, line: 328, type: !231)
!562 = distinct !DILexicalBlock(scope: !558, file: !2, line: 327, column: 9)
!563 = !DILocation(line: 328, column: 18, scope: !562)
!564 = !DILocation(line: 328, column: 28, scope: !562)
!565 = !DILocation(line: 329, column: 13, scope: !562)
!566 = !DILocation(line: 330, column: 9, scope: !562)
!567 = !DILocation(line: 326, column: 42, scope: !558)
!568 = !DILocation(line: 326, column: 9, scope: !558)
!569 = distinct !{!569, !560, !570, !571}
!570 = !DILocation(line: 330, column: 9, scope: !554)
!571 = !{!"llvm.loop.mustprogress"}
!572 = !DILocalVariable(name: "success", scope: !573, file: !2, line: 333, type: !231)
!573 = distinct !DILexicalBlock(scope: !552, file: !2, line: 332, column: 9)
!574 = !DILocation(line: 333, column: 18, scope: !573)
!575 = !DILocation(line: 333, column: 28, scope: !573)
!576 = !DILocation(line: 334, column: 13, scope: !573)
!577 = !DILocation(line: 337, column: 9, scope: !552)
!578 = !DILocalVariable(name: "i", scope: !579, file: !2, line: 338, type: !97)
!579 = distinct !DILexicalBlock(scope: !552, file: !2, line: 338, column: 9)
!580 = !DILocation(line: 338, column: 18, scope: !579)
!581 = !DILocation(line: 338, column: 14, scope: !579)
!582 = !DILocation(line: 338, column: 25, scope: !583)
!583 = distinct !DILexicalBlock(scope: !579, file: !2, line: 338, column: 9)
!584 = !DILocation(line: 338, column: 27, scope: !583)
!585 = !DILocation(line: 338, column: 9, scope: !579)
!586 = !DILocation(line: 339, column: 13, scope: !587)
!587 = distinct !DILexicalBlock(scope: !583, file: !2, line: 338, column: 46)
!588 = !DILocation(line: 340, column: 9, scope: !587)
!589 = !DILocation(line: 338, column: 42, scope: !583)
!590 = !DILocation(line: 338, column: 9, scope: !583)
!591 = distinct !{!591, !585, !592, !571}
!592 = !DILocation(line: 340, column: 9, scope: !579)
!593 = !DILocation(line: 344, column: 9, scope: !594)
!594 = distinct !DILexicalBlock(scope: !534, file: !2, line: 343, column: 5)
!595 = !DILocalVariable(name: "success", scope: !594, file: !2, line: 345, type: !231)
!596 = !DILocation(line: 345, column: 14, scope: !594)
!597 = !DILocation(line: 345, column: 24, scope: !594)
!598 = !DILocation(line: 346, column: 9, scope: !594)
!599 = !DILocation(line: 347, column: 9, scope: !594)
!600 = !DILocation(line: 350, column: 5, scope: !534)
!601 = !DILocation(line: 351, column: 1, scope: !534)
!602 = distinct !DISubprogram(name: "key_destroy", scope: !2, file: !2, line: 358, type: !603, scopeLine: 359, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!603 = !DISubroutineType(types: !604)
!604 = !{null, !32}
!605 = !DILocalVariable(name: "unused_value", arg: 1, scope: !602, file: !2, line: 358, type: !32)
!606 = !DILocation(line: 358, column: 24, scope: !602)
!607 = !DILocation(line: 360, column: 21, scope: !602)
!608 = !DILocation(line: 360, column: 19, scope: !602)
!609 = !DILocation(line: 361, column: 1, scope: !602)
!610 = distinct !DISubprogram(name: "key_worker", scope: !2, file: !2, line: 363, type: !111, scopeLine: 364, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!611 = !DILocalVariable(name: "message", arg: 1, scope: !610, file: !2, line: 363, type: !32)
!612 = !DILocation(line: 363, column: 24, scope: !610)
!613 = !DILocalVariable(name: "my_secret", scope: !610, file: !2, line: 365, type: !97)
!614 = !DILocation(line: 365, column: 9, scope: !610)
!615 = !DILocalVariable(name: "status", scope: !610, file: !2, line: 367, type: !97)
!616 = !DILocation(line: 367, column: 9, scope: !610)
!617 = !DILocation(line: 367, column: 38, scope: !610)
!618 = !DILocation(line: 367, column: 18, scope: !610)
!619 = !DILocation(line: 368, column: 5, scope: !610)
!620 = !DILocalVariable(name: "my_local_data", scope: !610, file: !2, line: 370, type: !32)
!621 = !DILocation(line: 370, column: 11, scope: !610)
!622 = !DILocation(line: 370, column: 47, scope: !610)
!623 = !DILocation(line: 370, column: 27, scope: !610)
!624 = !DILocation(line: 371, column: 5, scope: !610)
!625 = !DILocation(line: 373, column: 12, scope: !610)
!626 = !DILocation(line: 373, column: 5, scope: !610)
!627 = distinct !DISubprogram(name: "key_test", scope: !2, file: !2, line: 376, type: !252, scopeLine: 377, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!628 = !DILocalVariable(name: "my_secret", scope: !627, file: !2, line: 378, type: !97)
!629 = !DILocation(line: 378, column: 9, scope: !627)
!630 = !DILocalVariable(name: "message", scope: !627, file: !2, line: 379, type: !32)
!631 = !DILocation(line: 379, column: 11, scope: !627)
!632 = !DILocalVariable(name: "status", scope: !627, file: !2, line: 380, type: !97)
!633 = !DILocation(line: 380, column: 9, scope: !627)
!634 = !DILocation(line: 382, column: 5, scope: !627)
!635 = !DILocalVariable(name: "worker", scope: !627, file: !2, line: 384, type: !88)
!636 = !DILocation(line: 384, column: 15, scope: !627)
!637 = !DILocation(line: 384, column: 50, scope: !627)
!638 = !DILocation(line: 384, column: 24, scope: !627)
!639 = !DILocation(line: 386, column: 34, scope: !627)
!640 = !DILocation(line: 386, column: 14, scope: !627)
!641 = !DILocation(line: 386, column: 12, scope: !627)
!642 = !DILocation(line: 387, column: 5, scope: !627)
!643 = !DILocalVariable(name: "my_local_data", scope: !627, file: !2, line: 389, type: !32)
!644 = !DILocation(line: 389, column: 11, scope: !627)
!645 = !DILocation(line: 389, column: 47, scope: !627)
!646 = !DILocation(line: 389, column: 27, scope: !627)
!647 = !DILocation(line: 390, column: 5, scope: !627)
!648 = !DILocation(line: 392, column: 34, scope: !627)
!649 = !DILocation(line: 392, column: 14, scope: !627)
!650 = !DILocation(line: 392, column: 12, scope: !627)
!651 = !DILocation(line: 393, column: 5, scope: !627)
!652 = !DILocalVariable(name: "result", scope: !627, file: !2, line: 395, type: !32)
!653 = !DILocation(line: 395, column: 11, scope: !627)
!654 = !DILocation(line: 395, column: 32, scope: !627)
!655 = !DILocation(line: 395, column: 20, scope: !627)
!656 = !DILocation(line: 396, column: 5, scope: !627)
!657 = !DILocation(line: 398, column: 33, scope: !627)
!658 = !DILocation(line: 398, column: 14, scope: !627)
!659 = !DILocation(line: 398, column: 12, scope: !627)
!660 = !DILocation(line: 399, column: 5, scope: !627)
!661 = !DILocation(line: 401, column: 5, scope: !627)
!662 = !DILocation(line: 402, column: 1, scope: !627)
!663 = distinct !DISubprogram(name: "detach_test_worker0", scope: !2, file: !2, line: 406, type: !111, scopeLine: 407, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!664 = !DILocalVariable(name: "ignore", arg: 1, scope: !663, file: !2, line: 406, type: !32)
!665 = !DILocation(line: 406, column: 33, scope: !663)
!666 = !DILocation(line: 408, column: 5, scope: !663)
!667 = distinct !DISubprogram(name: "detach_test_detach", scope: !2, file: !2, line: 411, type: !111, scopeLine: 412, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!668 = !DILocalVariable(name: "ignore", arg: 1, scope: !667, file: !2, line: 411, type: !32)
!669 = !DILocation(line: 411, column: 32, scope: !667)
!670 = !DILocalVariable(name: "status", scope: !667, file: !2, line: 413, type: !97)
!671 = !DILocation(line: 413, column: 9, scope: !667)
!672 = !DILocalVariable(name: "w0", scope: !667, file: !2, line: 414, type: !88)
!673 = !DILocation(line: 414, column: 15, scope: !667)
!674 = !DILocation(line: 414, column: 20, scope: !667)
!675 = !DILocation(line: 415, column: 29, scope: !667)
!676 = !DILocation(line: 415, column: 14, scope: !667)
!677 = !DILocation(line: 415, column: 12, scope: !667)
!678 = !DILocation(line: 416, column: 5, scope: !667)
!679 = !DILocation(line: 418, column: 27, scope: !667)
!680 = !DILocation(line: 418, column: 14, scope: !667)
!681 = !DILocation(line: 418, column: 12, scope: !667)
!682 = !DILocation(line: 419, column: 5, scope: !667)
!683 = !DILocation(line: 420, column: 5, scope: !667)
!684 = distinct !DISubprogram(name: "detach_test_attr", scope: !2, file: !2, line: 423, type: !111, scopeLine: 424, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!685 = !DILocalVariable(name: "ignore", arg: 1, scope: !684, file: !2, line: 423, type: !32)
!686 = !DILocation(line: 423, column: 30, scope: !684)
!687 = !DILocalVariable(name: "status", scope: !684, file: !2, line: 425, type: !97)
!688 = !DILocation(line: 425, column: 9, scope: !684)
!689 = !DILocalVariable(name: "detachstate", scope: !684, file: !2, line: 426, type: !97)
!690 = !DILocation(line: 426, column: 9, scope: !684)
!691 = !DILocalVariable(name: "w0", scope: !684, file: !2, line: 427, type: !88)
!692 = !DILocation(line: 427, column: 15, scope: !684)
!693 = !DILocalVariable(name: "w0_attr", scope: !684, file: !2, line: 428, type: !121)
!694 = !DILocation(line: 428, column: 20, scope: !684)
!695 = !DILocation(line: 429, column: 14, scope: !684)
!696 = !DILocation(line: 429, column: 12, scope: !684)
!697 = !DILocation(line: 430, column: 5, scope: !684)
!698 = !DILocation(line: 431, column: 14, scope: !684)
!699 = !DILocation(line: 431, column: 12, scope: !684)
!700 = !DILocation(line: 432, column: 5, scope: !684)
!701 = !DILocation(line: 433, column: 14, scope: !684)
!702 = !DILocation(line: 433, column: 12, scope: !684)
!703 = !DILocation(line: 434, column: 5, scope: !684)
!704 = !DILocation(line: 435, column: 14, scope: !684)
!705 = !DILocation(line: 435, column: 12, scope: !684)
!706 = !DILocation(line: 436, column: 5, scope: !684)
!707 = !DILocation(line: 437, column: 14, scope: !684)
!708 = !DILocation(line: 437, column: 12, scope: !684)
!709 = !DILocation(line: 438, column: 5, scope: !684)
!710 = !DILocation(line: 439, column: 5, scope: !684)
!711 = !DILocation(line: 441, column: 27, scope: !684)
!712 = !DILocation(line: 441, column: 14, scope: !684)
!713 = !DILocation(line: 441, column: 12, scope: !684)
!714 = !DILocation(line: 442, column: 5, scope: !684)
!715 = !DILocation(line: 443, column: 5, scope: !684)
!716 = distinct !DISubprogram(name: "detach_test", scope: !2, file: !2, line: 446, type: !252, scopeLine: 447, spFlags: DISPFlagDefinition, unit: !29)
!717 = !DILocation(line: 448, column: 5, scope: !716)
!718 = !DILocation(line: 449, column: 5, scope: !716)
!719 = !DILocation(line: 450, column: 1, scope: !716)
!720 = distinct !DISubprogram(name: "once_init0", scope: !2, file: !2, line: 459, type: !252, scopeLine: 460, spFlags: DISPFlagDefinition, unit: !29)
!721 = !DILocation(line: 461, column: 5, scope: !720)
!722 = !DILocation(line: 462, column: 16, scope: !720)
!723 = !DILocation(line: 463, column: 1, scope: !720)
!724 = distinct !DISubprogram(name: "once_init1", scope: !2, file: !2, line: 465, type: !252, scopeLine: 466, spFlags: DISPFlagDefinition, unit: !29)
!725 = !DILocation(line: 467, column: 5, scope: !724)
!726 = !DILocation(line: 468, column: 1, scope: !724)
!727 = distinct !DISubprogram(name: "once_worker", scope: !2, file: !2, line: 470, type: !111, scopeLine: 471, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!728 = !DILocalVariable(name: "ignore", arg: 1, scope: !727, file: !2, line: 470, type: !32)
!729 = !DILocation(line: 470, column: 25, scope: !727)
!730 = !DILocalVariable(name: "status", scope: !727, file: !2, line: 472, type: !97)
!731 = !DILocation(line: 472, column: 9, scope: !727)
!732 = !DILocation(line: 472, column: 18, scope: !727)
!733 = !DILocation(line: 473, column: 5, scope: !727)
!734 = !DILocation(line: 474, column: 5, scope: !727)
!735 = !DILocation(line: 475, column: 5, scope: !727)
!736 = distinct !DISubprogram(name: "once_test", scope: !2, file: !2, line: 478, type: !252, scopeLine: 479, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !113)
!737 = !DILocalVariable(name: "worker0", scope: !736, file: !2, line: 480, type: !88)
!738 = !DILocation(line: 480, column: 15, scope: !736)
!739 = !DILocation(line: 480, column: 25, scope: !736)
!740 = !DILocalVariable(name: "worker1", scope: !736, file: !2, line: 481, type: !88)
!741 = !DILocation(line: 481, column: 15, scope: !736)
!742 = !DILocation(line: 481, column: 25, scope: !736)
!743 = !DILocation(line: 482, column: 17, scope: !736)
!744 = !DILocation(line: 482, column: 5, scope: !736)
!745 = !DILocation(line: 483, column: 17, scope: !736)
!746 = !DILocation(line: 483, column: 5, scope: !736)
!747 = !DILocation(line: 484, column: 5, scope: !736)
!748 = !DILocalVariable(name: "status", scope: !736, file: !2, line: 486, type: !97)
!749 = !DILocation(line: 486, column: 9, scope: !736)
!750 = !DILocation(line: 486, column: 18, scope: !736)
!751 = !DILocation(line: 487, column: 5, scope: !736)
!752 = !DILocation(line: 488, column: 14, scope: !736)
!753 = !DILocation(line: 488, column: 12, scope: !736)
!754 = !DILocation(line: 489, column: 5, scope: !736)
!755 = !DILocation(line: 490, column: 5, scope: !736)
!756 = !DILocation(line: 491, column: 1, scope: !736)
!757 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 493, type: !758, scopeLine: 494, spFlags: DISPFlagDefinition, unit: !29)
!758 = !DISubroutineType(types: !759)
!759 = !{!97}
!760 = !DILocation(line: 495, column: 13, scope: !757)
!761 = !DILocation(line: 495, column: 5, scope: !757)
!762 = !DILocation(line: 496, column: 17, scope: !763)
!763 = distinct !DILexicalBlock(scope: !757, file: !2, line: 495, column: 38)
!764 = !DILocation(line: 496, column: 31, scope: !763)
!765 = !DILocation(line: 497, column: 17, scope: !763)
!766 = !DILocation(line: 497, column: 30, scope: !763)
!767 = !DILocation(line: 498, column: 17, scope: !763)
!768 = !DILocation(line: 498, column: 32, scope: !763)
!769 = !DILocation(line: 499, column: 17, scope: !763)
!770 = !DILocation(line: 499, column: 29, scope: !763)
!771 = !DILocation(line: 500, column: 17, scope: !763)
!772 = !DILocation(line: 500, column: 32, scope: !763)
!773 = !DILocation(line: 501, column: 17, scope: !763)
!774 = !DILocation(line: 501, column: 30, scope: !763)
!775 = !DILocation(line: 503, column: 1, scope: !757)
