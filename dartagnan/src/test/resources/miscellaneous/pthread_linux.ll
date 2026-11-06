; ModuleID = 'pthread.c'
source_filename = "pthread.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%union.pthread_cond_t = type { %struct.__pthread_cond_s }
%struct.__pthread_cond_s = type { %union.__atomic_wide_counter, %union.__atomic_wide_counter, [2 x i32], [2 x i32], i32, i32, [2 x i32] }
%union.__atomic_wide_counter = type { i64 }
%union.pthread_attr_t = type { i64, [48 x i8] }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_condattr_t = type { i32 }
%struct.timespec = type { i64, i64 }
%union.pthread_rwlockattr_t = type { i64 }
%union.pthread_rwlock_t = type { %struct.__pthread_rwlock_arch_t }
%struct.__pthread_rwlock_arch_t = type { i32, i32, i32, i32, i32, i32, i32, i32, i8, [7 x i8], i64, i32 }

@.str = private unnamed_addr constant [12 x i8] c"status == 0\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [10 x i8] c"pthread.c\00", align 1, !dbg !7
@__PRETTY_FUNCTION__.thread_create = private unnamed_addr constant [51 x i8] c"pthread_t thread_create(void *(*)(void *), void *)\00", align 1, !dbg !12
@__PRETTY_FUNCTION__.thread_join = private unnamed_addr constant [29 x i8] c"void *thread_join(pthread_t)\00", align 1, !dbg !18
@__PRETTY_FUNCTION__.mutex_init = private unnamed_addr constant [50 x i8] c"void mutex_init(pthread_mutex_t *, int, int, int)\00", align 1, !dbg !23
@__PRETTY_FUNCTION__.mutex_destroy = private unnamed_addr constant [38 x i8] c"void mutex_destroy(pthread_mutex_t *)\00", align 1, !dbg !28
@__PRETTY_FUNCTION__.mutex_lock = private unnamed_addr constant [35 x i8] c"void mutex_lock(pthread_mutex_t *)\00", align 1, !dbg !33
@.str.2 = private unnamed_addr constant [31 x i8] c"status == 0 || status == EBUSY\00", align 1, !dbg !38
@__PRETTY_FUNCTION__.mutex_trylock = private unnamed_addr constant [39 x i8] c"_Bool mutex_trylock(pthread_mutex_t *)\00", align 1, !dbg !43
@__PRETTY_FUNCTION__.mutex_unlock = private unnamed_addr constant [37 x i8] c"void mutex_unlock(pthread_mutex_t *)\00", align 1, !dbg !48
@.str.3 = private unnamed_addr constant [9 x i8] c"!success\00", align 1, !dbg !53
@__PRETTY_FUNCTION__.mutex_test = private unnamed_addr constant [18 x i8] c"void mutex_test()\00", align 1, !dbg !58
@.str.4 = private unnamed_addr constant [8 x i8] c"success\00", align 1, !dbg !63
@__PRETTY_FUNCTION__.cond_init = private unnamed_addr constant [33 x i8] c"void cond_init(pthread_cond_t *)\00", align 1, !dbg !68
@__PRETTY_FUNCTION__.cond_destroy = private unnamed_addr constant [36 x i8] c"void cond_destroy(pthread_cond_t *)\00", align 1, !dbg !73
@__PRETTY_FUNCTION__.cond_signal = private unnamed_addr constant [35 x i8] c"void cond_signal(pthread_cond_t *)\00", align 1, !dbg !78
@__PRETTY_FUNCTION__.cond_broadcast = private unnamed_addr constant [38 x i8] c"void cond_broadcast(pthread_cond_t *)\00", align 1, !dbg !80
@phase = dso_local global i32 0, align 4, !dbg !82
@cond_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !205
@cond = dso_local global %union.pthread_cond_t zeroinitializer, align 8, !dbg !234
@.str.5 = private unnamed_addr constant [18 x i8] c"result == message\00", align 1, !dbg !115
@__PRETTY_FUNCTION__.cond_test = private unnamed_addr constant [17 x i8] c"void cond_test()\00", align 1, !dbg !118
@__PRETTY_FUNCTION__.rwlock_init = private unnamed_addr constant [42 x i8] c"void rwlock_init(pthread_rwlock_t *, int)\00", align 1, !dbg !123
@__PRETTY_FUNCTION__.rwlock_destroy = private unnamed_addr constant [40 x i8] c"void rwlock_destroy(pthread_rwlock_t *)\00", align 1, !dbg !128
@__PRETTY_FUNCTION__.rwlock_wrlock = private unnamed_addr constant [39 x i8] c"void rwlock_wrlock(pthread_rwlock_t *)\00", align 1, !dbg !133
@__PRETTY_FUNCTION__.rwlock_trywrlock = private unnamed_addr constant [43 x i8] c"_Bool rwlock_trywrlock(pthread_rwlock_t *)\00", align 1, !dbg !135
@__PRETTY_FUNCTION__.rwlock_rdlock = private unnamed_addr constant [39 x i8] c"void rwlock_rdlock(pthread_rwlock_t *)\00", align 1, !dbg !140
@__PRETTY_FUNCTION__.rwlock_tryrdlock = private unnamed_addr constant [43 x i8] c"_Bool rwlock_tryrdlock(pthread_rwlock_t *)\00", align 1, !dbg !142
@__PRETTY_FUNCTION__.rwlock_unlock = private unnamed_addr constant [39 x i8] c"void rwlock_unlock(pthread_rwlock_t *)\00", align 1, !dbg !144
@__PRETTY_FUNCTION__.rwlock_test = private unnamed_addr constant [19 x i8] c"void rwlock_test()\00", align 1, !dbg !146
@latest_thread = dso_local global i64 0, align 8, !dbg !269
@local_data = dso_local global i32 0, align 4, !dbg !273
@__PRETTY_FUNCTION__.key_worker = private unnamed_addr constant [25 x i8] c"void *key_worker(void *)\00", align 1, !dbg !151
@.str.6 = private unnamed_addr constant [28 x i8] c"my_local_data == &my_secret\00", align 1, !dbg !156
@__PRETTY_FUNCTION__.key_test = private unnamed_addr constant [16 x i8] c"void key_test()\00", align 1, !dbg !161
@.str.7 = private unnamed_addr constant [37 x i8] c"pthread_equal(latest_thread, worker)\00", align 1, !dbg !166
@__PRETTY_FUNCTION__.detach_test_detach = private unnamed_addr constant [33 x i8] c"void *detach_test_detach(void *)\00", align 1, !dbg !169
@.str.8 = private unnamed_addr constant [12 x i8] c"status != 0\00", align 1, !dbg !171
@__PRETTY_FUNCTION__.detach_test_attr = private unnamed_addr constant [31 x i8] c"void *detach_test_attr(void *)\00", align 1, !dbg !173
@.str.9 = private unnamed_addr constant [54 x i8] c"status == 0 && detachstate == PTHREAD_CREATE_JOINABLE\00", align 1, !dbg !176
@.str.10 = private unnamed_addr constant [54 x i8] c"status == 0 && detachstate == PTHREAD_CREATE_DETACHED\00", align 1, !dbg !181
@once0 = dso_local global i32 0, align 4, !dbg !183
@once1 = dso_local global i32 0, align 4, !dbg !188
@once_calls = dso_local global i32 0, align 4, !dbg !276
@once_value = dso_local global i32 0, align 4, !dbg !278
@__PRETTY_FUNCTION__.once_worker = private unnamed_addr constant [26 x i8] c"void *once_worker(void *)\00", align 1, !dbg !190
@.str.11 = private unnamed_addr constant [17 x i8] c"once_value == 42\00", align 1, !dbg !195
@.str.12 = private unnamed_addr constant [16 x i8] c"once_calls == 1\00", align 1, !dbg !198
@__PRETTY_FUNCTION__.once_test = private unnamed_addr constant [17 x i8] c"void once_test()\00", align 1, !dbg !201
@.str.13 = private unnamed_addr constant [16 x i8] c"once_calls == 2\00", align 1, !dbg !203

; Function Attrs: noinline nounwind uwtable
define dso_local i64 @thread_create(ptr noundef %runner, ptr noundef %data) #0 !dbg !288 {
entry:
  %runner.addr = alloca ptr, align 8
  %data.addr = alloca ptr, align 8
  %id = alloca i64, align 8
  %attr = alloca %union.pthread_attr_t, align 8
  %status = alloca i32, align 4
  store ptr %runner, ptr %runner.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %runner.addr, metadata !295, metadata !DIExpression()), !dbg !296
  store ptr %data, ptr %data.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %data.addr, metadata !297, metadata !DIExpression()), !dbg !298
  call void @llvm.dbg.declare(metadata ptr %id, metadata !299, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.declare(metadata ptr %attr, metadata !301, metadata !DIExpression()), !dbg !310
  %call = call i32 @pthread_attr_init(ptr noundef %attr) #6, !dbg !311
  call void @llvm.dbg.declare(metadata ptr %status, metadata !312, metadata !DIExpression()), !dbg !313
  %0 = load ptr, ptr %runner.addr, align 8, !dbg !314
  %1 = load ptr, ptr %data.addr, align 8, !dbg !315
  %call1 = call i32 @pthread_create(ptr noundef %id, ptr noundef %attr, ptr noundef %0, ptr noundef %1) #6, !dbg !316
  store i32 %call1, ptr %status, align 4, !dbg !313
  %2 = load i32, ptr %status, align 4, !dbg !317
  %cmp = icmp eq i32 %2, 0, !dbg !317
  br i1 %cmp, label %if.then, label %if.else, !dbg !320

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !320

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 19, ptr noundef @__PRETTY_FUNCTION__.thread_create) #7, !dbg !317
  unreachable, !dbg !317

if.end:                                           ; preds = %if.then
  %call2 = call i32 @pthread_attr_destroy(ptr noundef %attr) #6, !dbg !321
  %3 = load i64, ptr %id, align 8, !dbg !322
  ret i64 %3, !dbg !323
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare i32 @pthread_attr_init(ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_attr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_join(i64 noundef %id) #0 !dbg !324 {
entry:
  %id.addr = alloca i64, align 8
  %result = alloca ptr, align 8
  %status = alloca i32, align 4
  store i64 %id, ptr %id.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %id.addr, metadata !327, metadata !DIExpression()), !dbg !328
  call void @llvm.dbg.declare(metadata ptr %result, metadata !329, metadata !DIExpression()), !dbg !330
  call void @llvm.dbg.declare(metadata ptr %status, metadata !331, metadata !DIExpression()), !dbg !332
  %0 = load i64, ptr %id.addr, align 8, !dbg !333
  %call = call i32 @pthread_join(i64 noundef %0, ptr noundef %result), !dbg !334
  store i32 %call, ptr %status, align 4, !dbg !332
  %1 = load i32, ptr %status, align 4, !dbg !335
  %cmp = icmp eq i32 %1, 0, !dbg !335
  br i1 %cmp, label %if.then, label %if.else, !dbg !338

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !338

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 28, ptr noundef @__PRETTY_FUNCTION__.thread_join) #7, !dbg !335
  unreachable, !dbg !335

if.end:                                           ; preds = %if.then
  %2 = load ptr, ptr %result, align 8, !dbg !339
  ret ptr %2, !dbg !340
}

declare i32 @pthread_join(i64 noundef, ptr noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_init(ptr noundef %lock, i32 noundef %type, i32 noundef %protocol, i32 noundef %prioceiling) #0 !dbg !341 {
entry:
  %lock.addr = alloca ptr, align 8
  %type.addr = alloca i32, align 4
  %protocol.addr = alloca i32, align 4
  %prioceiling.addr = alloca i32, align 4
  %status = alloca i32, align 4
  %value = alloca i32, align 4
  %attributes = alloca %union.pthread_mutexattr_t, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !345, metadata !DIExpression()), !dbg !346
  store i32 %type, ptr %type.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %type.addr, metadata !347, metadata !DIExpression()), !dbg !348
  store i32 %protocol, ptr %protocol.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %protocol.addr, metadata !349, metadata !DIExpression()), !dbg !350
  store i32 %prioceiling, ptr %prioceiling.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %prioceiling.addr, metadata !351, metadata !DIExpression()), !dbg !352
  call void @llvm.dbg.declare(metadata ptr %status, metadata !353, metadata !DIExpression()), !dbg !354
  call void @llvm.dbg.declare(metadata ptr %value, metadata !355, metadata !DIExpression()), !dbg !356
  call void @llvm.dbg.declare(metadata ptr %attributes, metadata !357, metadata !DIExpression()), !dbg !366
  %call = call i32 @pthread_mutexattr_init(ptr noundef %attributes) #6, !dbg !367
  store i32 %call, ptr %status, align 4, !dbg !368
  %0 = load i32, ptr %status, align 4, !dbg !369
  %cmp = icmp eq i32 %0, 0, !dbg !369
  br i1 %cmp, label %if.then, label %if.else, !dbg !372

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !372

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 48, ptr noundef @__PRETTY_FUNCTION__.mutex_init) #7, !dbg !369
  unreachable, !dbg !369

if.end:                                           ; preds = %if.then
  %1 = load i32, ptr %type.addr, align 4, !dbg !373
  %call1 = call i32 @pthread_mutexattr_settype(ptr noundef %attributes, i32 noundef %1) #6, !dbg !374
  store i32 %call1, ptr %status, align 4, !dbg !375
  %2 = load i32, ptr %status, align 4, !dbg !376
  %cmp2 = icmp eq i32 %2, 0, !dbg !376
  br i1 %cmp2, label %if.then3, label %if.else4, !dbg !379

if.then3:                                         ; preds = %if.end
  br label %if.end5, !dbg !379

if.else4:                                         ; preds = %if.end
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 51, ptr noundef @__PRETTY_FUNCTION__.mutex_init) #7, !dbg !376
  unreachable, !dbg !376

if.end5:                                          ; preds = %if.then3
  %call6 = call i32 @pthread_mutexattr_gettype(ptr noundef %attributes, ptr noundef %value) #6, !dbg !380
  store i32 %call6, ptr %status, align 4, !dbg !381
  %3 = load i32, ptr %status, align 4, !dbg !382
  %cmp7 = icmp eq i32 %3, 0, !dbg !382
  br i1 %cmp7, label %if.then8, label %if.else9, !dbg !385

if.then8:                                         ; preds = %if.end5
  br label %if.end10, !dbg !385

if.else9:                                         ; preds = %if.end5
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 53, ptr noundef @__PRETTY_FUNCTION__.mutex_init) #7, !dbg !382
  unreachable, !dbg !382

if.end10:                                         ; preds = %if.then8
  %4 = load i32, ptr %protocol.addr, align 4, !dbg !386
  %call11 = call i32 @pthread_mutexattr_setprotocol(ptr noundef %attributes, i32 noundef %4) #6, !dbg !387
  store i32 %call11, ptr %status, align 4, !dbg !388
  %5 = load i32, ptr %status, align 4, !dbg !389
  %cmp12 = icmp eq i32 %5, 0, !dbg !389
  br i1 %cmp12, label %if.then13, label %if.else14, !dbg !392

if.then13:                                        ; preds = %if.end10
  br label %if.end15, !dbg !392

if.else14:                                        ; preds = %if.end10
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 56, ptr noundef @__PRETTY_FUNCTION__.mutex_init) #7, !dbg !389
  unreachable, !dbg !389

if.end15:                                         ; preds = %if.then13
  %call16 = call i32 @pthread_mutexattr_getprotocol(ptr noundef %attributes, ptr noundef %value) #6, !dbg !393
  store i32 %call16, ptr %status, align 4, !dbg !394
  %6 = load i32, ptr %status, align 4, !dbg !395
  %cmp17 = icmp eq i32 %6, 0, !dbg !395
  br i1 %cmp17, label %if.then18, label %if.else19, !dbg !398

if.then18:                                        ; preds = %if.end15
  br label %if.end20, !dbg !398

if.else19:                                        ; preds = %if.end15
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 58, ptr noundef @__PRETTY_FUNCTION__.mutex_init) #7, !dbg !395
  unreachable, !dbg !395

if.end20:                                         ; preds = %if.then18
  %7 = load i32, ptr %prioceiling.addr, align 4, !dbg !399
  %call21 = call i32 @pthread_mutexattr_setprioceiling(ptr noundef %attributes, i32 noundef %7) #6, !dbg !400
  store i32 %call21, ptr %status, align 4, !dbg !401
  %8 = load i32, ptr %status, align 4, !dbg !402
  %cmp22 = icmp eq i32 %8, 0, !dbg !402
  br i1 %cmp22, label %if.then23, label %if.else24, !dbg !405

if.then23:                                        ; preds = %if.end20
  br label %if.end25, !dbg !405

if.else24:                                        ; preds = %if.end20
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 61, ptr noundef @__PRETTY_FUNCTION__.mutex_init) #7, !dbg !402
  unreachable, !dbg !402

if.end25:                                         ; preds = %if.then23
  %call26 = call i32 @pthread_mutexattr_getprioceiling(ptr noundef %attributes, ptr noundef %value) #6, !dbg !406
  store i32 %call26, ptr %status, align 4, !dbg !407
  %9 = load i32, ptr %status, align 4, !dbg !408
  %cmp27 = icmp eq i32 %9, 0, !dbg !408
  br i1 %cmp27, label %if.then28, label %if.else29, !dbg !411

if.then28:                                        ; preds = %if.end25
  br label %if.end30, !dbg !411

if.else29:                                        ; preds = %if.end25
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 63, ptr noundef @__PRETTY_FUNCTION__.mutex_init) #7, !dbg !408
  unreachable, !dbg !408

if.end30:                                         ; preds = %if.then28
  %10 = load ptr, ptr %lock.addr, align 8, !dbg !412
  %call31 = call i32 @pthread_mutex_init(ptr noundef %10, ptr noundef %attributes) #6, !dbg !413
  store i32 %call31, ptr %status, align 4, !dbg !414
  %11 = load i32, ptr %status, align 4, !dbg !415
  %cmp32 = icmp eq i32 %11, 0, !dbg !415
  br i1 %cmp32, label %if.then33, label %if.else34, !dbg !418

if.then33:                                        ; preds = %if.end30
  br label %if.end35, !dbg !418

if.else34:                                        ; preds = %if.end30
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 66, ptr noundef @__PRETTY_FUNCTION__.mutex_init) #7, !dbg !415
  unreachable, !dbg !415

if.end35:                                         ; preds = %if.then33
  %call36 = call i32 @pthread_mutexattr_destroy(ptr noundef %attributes) #6, !dbg !419
  store i32 %call36, ptr %status, align 4, !dbg !420
  %12 = load i32, ptr %status, align 4, !dbg !421
  %cmp37 = icmp eq i32 %12, 0, !dbg !421
  br i1 %cmp37, label %if.then38, label %if.else39, !dbg !424

if.then38:                                        ; preds = %if.end35
  br label %if.end40, !dbg !424

if.else39:                                        ; preds = %if.end35
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 68, ptr noundef @__PRETTY_FUNCTION__.mutex_init) #7, !dbg !421
  unreachable, !dbg !421

if.end40:                                         ; preds = %if.then38
  ret void, !dbg !425
}

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_init(ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_settype(ptr noundef, i32 noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_gettype(ptr noundef, ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_setprotocol(ptr noundef, i32 noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_getprotocol(ptr noundef, ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_setprioceiling(ptr noundef, i32 noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_getprioceiling(ptr noundef, ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_destroy(ptr noundef %lock) #0 !dbg !426 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !429, metadata !DIExpression()), !dbg !430
  call void @llvm.dbg.declare(metadata ptr %status, metadata !431, metadata !DIExpression()), !dbg !432
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !433
  %call = call i32 @pthread_mutex_destroy(ptr noundef %0) #6, !dbg !434
  store i32 %call, ptr %status, align 4, !dbg !432
  %1 = load i32, ptr %status, align 4, !dbg !435
  %cmp = icmp eq i32 %1, 0, !dbg !435
  br i1 %cmp, label %if.then, label %if.else, !dbg !438

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !438

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 74, ptr noundef @__PRETTY_FUNCTION__.mutex_destroy) #7, !dbg !435
  unreachable, !dbg !435

if.end:                                           ; preds = %if.then
  ret void, !dbg !439
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_lock(ptr noundef %lock) #0 !dbg !440 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !441, metadata !DIExpression()), !dbg !442
  call void @llvm.dbg.declare(metadata ptr %status, metadata !443, metadata !DIExpression()), !dbg !444
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !445
  %call = call i32 @pthread_mutex_lock(ptr noundef %0) #6, !dbg !446
  store i32 %call, ptr %status, align 4, !dbg !444
  %1 = load i32, ptr %status, align 4, !dbg !447
  %cmp = icmp eq i32 %1, 0, !dbg !447
  br i1 %cmp, label %if.then, label %if.else, !dbg !450

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !450

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 80, ptr noundef @__PRETTY_FUNCTION__.mutex_lock) #7, !dbg !447
  unreachable, !dbg !447

if.end:                                           ; preds = %if.then
  ret void, !dbg !451
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @mutex_trylock(ptr noundef %lock) #0 !dbg !452 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !456, metadata !DIExpression()), !dbg !457
  call void @llvm.dbg.declare(metadata ptr %status, metadata !458, metadata !DIExpression()), !dbg !459
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !460
  %call = call i32 @pthread_mutex_trylock(ptr noundef %0) #6, !dbg !461
  store i32 %call, ptr %status, align 4, !dbg !459
  %1 = load i32, ptr %status, align 4, !dbg !462
  %cmp = icmp eq i32 %1, 0, !dbg !462
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !462

lor.lhs.false:                                    ; preds = %entry
  %2 = load i32, ptr %status, align 4, !dbg !462
  %cmp1 = icmp eq i32 %2, 16, !dbg !462
  br i1 %cmp1, label %if.then, label %if.else, !dbg !465

if.then:                                          ; preds = %lor.lhs.false, %entry
  br label %if.end, !dbg !465

if.else:                                          ; preds = %lor.lhs.false
  call void @__assert_fail(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 86, ptr noundef @__PRETTY_FUNCTION__.mutex_trylock) #7, !dbg !462
  unreachable, !dbg !462

if.end:                                           ; preds = %if.then
  %3 = load i32, ptr %status, align 4, !dbg !466
  %cmp2 = icmp eq i32 %3, 0, !dbg !467
  ret i1 %cmp2, !dbg !468
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_trylock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_unlock(ptr noundef %lock) #0 !dbg !469 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !470, metadata !DIExpression()), !dbg !471
  call void @llvm.dbg.declare(metadata ptr %status, metadata !472, metadata !DIExpression()), !dbg !473
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !474
  %call = call i32 @pthread_mutex_unlock(ptr noundef %0) #6, !dbg !475
  store i32 %call, ptr %status, align 4, !dbg !473
  %1 = load i32, ptr %status, align 4, !dbg !476
  %cmp = icmp eq i32 %1, 0, !dbg !476
  br i1 %cmp, label %if.then, label %if.else, !dbg !479

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !479

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 93, ptr noundef @__PRETTY_FUNCTION__.mutex_unlock) #7, !dbg !476
  unreachable, !dbg !476

if.end:                                           ; preds = %if.then
  ret void, !dbg !480
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_test() #0 !dbg !481 {
entry:
  %mutex0 = alloca %union.pthread_mutex_t, align 8
  %mutex1 = alloca %union.pthread_mutex_t, align 8
  %success = alloca i8, align 1
  %success1 = alloca i8, align 1
  %success8 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata ptr %mutex0, metadata !484, metadata !DIExpression()), !dbg !485
  call void @llvm.dbg.declare(metadata ptr %mutex1, metadata !486, metadata !DIExpression()), !dbg !487
  call void @mutex_init(ptr noundef %mutex0, i32 noundef 2, i32 noundef 1, i32 noundef 1), !dbg !488
  call void @mutex_init(ptr noundef %mutex1, i32 noundef 0, i32 noundef 2, i32 noundef 2), !dbg !489
  call void @mutex_lock(ptr noundef %mutex0), !dbg !490
  call void @llvm.dbg.declare(metadata ptr %success, metadata !492, metadata !DIExpression()), !dbg !493
  %call = call zeroext i1 @mutex_trylock(ptr noundef %mutex0), !dbg !494
  %frombool = zext i1 %call to i8, !dbg !493
  store i8 %frombool, ptr %success, align 1, !dbg !493
  %0 = load i8, ptr %success, align 1, !dbg !495
  %tobool = trunc i8 %0 to i1, !dbg !495
  br i1 %tobool, label %if.else, label %if.then, !dbg !498

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !498

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 107, ptr noundef @__PRETTY_FUNCTION__.mutex_test) #7, !dbg !495
  unreachable, !dbg !495

if.end:                                           ; preds = %if.then
  call void @mutex_unlock(ptr noundef %mutex0), !dbg !499
  call void @mutex_lock(ptr noundef %mutex1), !dbg !500
  call void @llvm.dbg.declare(metadata ptr %success1, metadata !502, metadata !DIExpression()), !dbg !504
  %call2 = call zeroext i1 @mutex_trylock(ptr noundef %mutex0), !dbg !505
  %frombool3 = zext i1 %call2 to i8, !dbg !504
  store i8 %frombool3, ptr %success1, align 1, !dbg !504
  %1 = load i8, ptr %success1, align 1, !dbg !506
  %tobool4 = trunc i8 %1 to i1, !dbg !506
  br i1 %tobool4, label %if.then5, label %if.else6, !dbg !509

if.then5:                                         ; preds = %if.end
  br label %if.end7, !dbg !509

if.else6:                                         ; preds = %if.end
  call void @__assert_fail(ptr noundef @.str.4, ptr noundef @.str.1, i32 noundef 116, ptr noundef @__PRETTY_FUNCTION__.mutex_test) #7, !dbg !506
  unreachable, !dbg !506

if.end7:                                          ; preds = %if.then5
  call void @mutex_unlock(ptr noundef %mutex0), !dbg !510
  call void @llvm.dbg.declare(metadata ptr %success8, metadata !511, metadata !DIExpression()), !dbg !513
  %call9 = call zeroext i1 @mutex_trylock(ptr noundef %mutex0), !dbg !514
  %frombool10 = zext i1 %call9 to i8, !dbg !513
  store i8 %frombool10, ptr %success8, align 1, !dbg !513
  %2 = load i8, ptr %success8, align 1, !dbg !515
  %tobool11 = trunc i8 %2 to i1, !dbg !515
  br i1 %tobool11, label %if.then12, label %if.else13, !dbg !518

if.then12:                                        ; preds = %if.end7
  br label %if.end14, !dbg !518

if.else13:                                        ; preds = %if.end7
  call void @__assert_fail(ptr noundef @.str.4, ptr noundef @.str.1, i32 noundef 122, ptr noundef @__PRETTY_FUNCTION__.mutex_test) #7, !dbg !515
  unreachable, !dbg !515

if.end14:                                         ; preds = %if.then12
  call void @mutex_unlock(ptr noundef %mutex0), !dbg !519
  call void @mutex_unlock(ptr noundef %mutex1), !dbg !520
  call void @mutex_destroy(ptr noundef %mutex1), !dbg !521
  call void @mutex_destroy(ptr noundef %mutex0), !dbg !522
  ret void, !dbg !523
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_init(ptr noundef %cond) #0 !dbg !524 {
entry:
  %cond.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  %attr = alloca %union.pthread_condattr_t, align 4
  store ptr %cond, ptr %cond.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %cond.addr, metadata !528, metadata !DIExpression()), !dbg !529
  call void @llvm.dbg.declare(metadata ptr %status, metadata !530, metadata !DIExpression()), !dbg !531
  call void @llvm.dbg.declare(metadata ptr %attr, metadata !532, metadata !DIExpression()), !dbg !538
  %call = call i32 @pthread_condattr_init(ptr noundef %attr) #6, !dbg !539
  store i32 %call, ptr %status, align 4, !dbg !540
  %0 = load i32, ptr %status, align 4, !dbg !541
  %cmp = icmp eq i32 %0, 0, !dbg !541
  br i1 %cmp, label %if.then, label %if.else, !dbg !544

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !544

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 143, ptr noundef @__PRETTY_FUNCTION__.cond_init) #7, !dbg !541
  unreachable, !dbg !541

if.end:                                           ; preds = %if.then
  %1 = load ptr, ptr %cond.addr, align 8, !dbg !545
  %call1 = call i32 @pthread_cond_init(ptr noundef %1, ptr noundef %attr) #6, !dbg !546
  store i32 %call1, ptr %status, align 4, !dbg !547
  %2 = load i32, ptr %status, align 4, !dbg !548
  %cmp2 = icmp eq i32 %2, 0, !dbg !548
  br i1 %cmp2, label %if.then3, label %if.else4, !dbg !551

if.then3:                                         ; preds = %if.end
  br label %if.end5, !dbg !551

if.else4:                                         ; preds = %if.end
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 146, ptr noundef @__PRETTY_FUNCTION__.cond_init) #7, !dbg !548
  unreachable, !dbg !548

if.end5:                                          ; preds = %if.then3
  %call6 = call i32 @pthread_condattr_destroy(ptr noundef %attr) #6, !dbg !552
  store i32 %call6, ptr %status, align 4, !dbg !553
  %3 = load i32, ptr %status, align 4, !dbg !554
  %cmp7 = icmp eq i32 %3, 0, !dbg !554
  br i1 %cmp7, label %if.then8, label %if.else9, !dbg !557

if.then8:                                         ; preds = %if.end5
  br label %if.end10, !dbg !557

if.else9:                                         ; preds = %if.end5
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 149, ptr noundef @__PRETTY_FUNCTION__.cond_init) #7, !dbg !554
  unreachable, !dbg !554

if.end10:                                         ; preds = %if.then8
  ret void, !dbg !558
}

; Function Attrs: nounwind
declare i32 @pthread_condattr_init(ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_cond_init(ptr noundef, ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_condattr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_destroy(ptr noundef %cond) #0 !dbg !559 {
entry:
  %cond.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %cond, ptr %cond.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %cond.addr, metadata !560, metadata !DIExpression()), !dbg !561
  call void @llvm.dbg.declare(metadata ptr %status, metadata !562, metadata !DIExpression()), !dbg !563
  %0 = load ptr, ptr %cond.addr, align 8, !dbg !564
  %call = call i32 @pthread_cond_destroy(ptr noundef %0) #6, !dbg !565
  store i32 %call, ptr %status, align 4, !dbg !563
  %1 = load i32, ptr %status, align 4, !dbg !566
  %cmp = icmp eq i32 %1, 0, !dbg !566
  br i1 %cmp, label %if.then, label %if.else, !dbg !569

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !569

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 155, ptr noundef @__PRETTY_FUNCTION__.cond_destroy) #7, !dbg !566
  unreachable, !dbg !566

if.end:                                           ; preds = %if.then
  ret void, !dbg !570
}

; Function Attrs: nounwind
declare i32 @pthread_cond_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_signal(ptr noundef %cond) #0 !dbg !571 {
entry:
  %cond.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %cond, ptr %cond.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %cond.addr, metadata !572, metadata !DIExpression()), !dbg !573
  call void @llvm.dbg.declare(metadata ptr %status, metadata !574, metadata !DIExpression()), !dbg !575
  %0 = load ptr, ptr %cond.addr, align 8, !dbg !576
  %call = call i32 @pthread_cond_signal(ptr noundef %0) #6, !dbg !577
  store i32 %call, ptr %status, align 4, !dbg !575
  %1 = load i32, ptr %status, align 4, !dbg !578
  %cmp = icmp eq i32 %1, 0, !dbg !578
  br i1 %cmp, label %if.then, label %if.else, !dbg !581

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !581

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 161, ptr noundef @__PRETTY_FUNCTION__.cond_signal) #7, !dbg !578
  unreachable, !dbg !578

if.end:                                           ; preds = %if.then
  ret void, !dbg !582
}

; Function Attrs: nounwind
declare i32 @pthread_cond_signal(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_broadcast(ptr noundef %cond) #0 !dbg !583 {
entry:
  %cond.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %cond, ptr %cond.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %cond.addr, metadata !584, metadata !DIExpression()), !dbg !585
  call void @llvm.dbg.declare(metadata ptr %status, metadata !586, metadata !DIExpression()), !dbg !587
  %0 = load ptr, ptr %cond.addr, align 8, !dbg !588
  %call = call i32 @pthread_cond_broadcast(ptr noundef %0) #6, !dbg !589
  store i32 %call, ptr %status, align 4, !dbg !587
  %1 = load i32, ptr %status, align 4, !dbg !590
  %cmp = icmp eq i32 %1, 0, !dbg !590
  br i1 %cmp, label %if.then, label %if.else, !dbg !593

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !593

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 167, ptr noundef @__PRETTY_FUNCTION__.cond_broadcast) #7, !dbg !590
  unreachable, !dbg !590

if.end:                                           ; preds = %if.then
  ret void, !dbg !594
}

; Function Attrs: nounwind
declare i32 @pthread_cond_broadcast(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_wait(ptr noundef %cond, ptr noundef %lock) #0 !dbg !595 {
entry:
  %cond.addr = alloca ptr, align 8
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %cond, ptr %cond.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %cond.addr, metadata !598, metadata !DIExpression()), !dbg !599
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !600, metadata !DIExpression()), !dbg !601
  call void @llvm.dbg.declare(metadata ptr %status, metadata !602, metadata !DIExpression()), !dbg !603
  %0 = load ptr, ptr %cond.addr, align 8, !dbg !604
  %1 = load ptr, ptr %lock.addr, align 8, !dbg !605
  %call = call i32 @pthread_cond_wait(ptr noundef %0, ptr noundef %1), !dbg !606
  store i32 %call, ptr %status, align 4, !dbg !603
  ret void, !dbg !607
}

declare i32 @pthread_cond_wait(ptr noundef, ptr noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_timedwait(ptr noundef %cond, ptr noundef %lock, i64 noundef %millis) #0 !dbg !608 {
entry:
  %cond.addr = alloca ptr, align 8
  %lock.addr = alloca ptr, align 8
  %millis.addr = alloca i64, align 8
  %ts = alloca %struct.timespec, align 8
  %status = alloca i32, align 4
  store ptr %cond, ptr %cond.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %cond.addr, metadata !611, metadata !DIExpression()), !dbg !612
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !613, metadata !DIExpression()), !dbg !614
  store i64 %millis, ptr %millis.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %millis.addr, metadata !615, metadata !DIExpression()), !dbg !616
  call void @llvm.dbg.declare(metadata ptr %ts, metadata !617, metadata !DIExpression()), !dbg !626
  %0 = load i64, ptr %millis.addr, align 8, !dbg !627
  call void @llvm.dbg.declare(metadata ptr %status, metadata !628, metadata !DIExpression()), !dbg !629
  %1 = load ptr, ptr %cond.addr, align 8, !dbg !630
  %2 = load ptr, ptr %lock.addr, align 8, !dbg !631
  %call = call i32 @pthread_cond_timedwait(ptr noundef %1, ptr noundef %2, ptr noundef %ts), !dbg !632
  store i32 %call, ptr %status, align 4, !dbg !629
  ret void, !dbg !633
}

declare i32 @pthread_cond_timedwait(ptr noundef, ptr noundef, ptr noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @cond_worker(ptr noundef %message) #0 !dbg !634 {
entry:
  %retval = alloca ptr, align 8
  %message.addr = alloca ptr, align 8
  %idle = alloca i8, align 1
  store ptr %message, ptr %message.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %message.addr, metadata !635, metadata !DIExpression()), !dbg !636
  call void @llvm.dbg.declare(metadata ptr %idle, metadata !637, metadata !DIExpression()), !dbg !638
  store i8 1, ptr %idle, align 1, !dbg !638
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !639
  %0 = load i32, ptr @phase, align 4, !dbg !641
  %inc = add nsw i32 %0, 1, !dbg !641
  store i32 %inc, ptr @phase, align 4, !dbg !641
  call void @cond_wait(ptr noundef @cond, ptr noundef @cond_mutex), !dbg !642
  %1 = load i32, ptr @phase, align 4, !dbg !643
  %inc1 = add nsw i32 %1, 1, !dbg !643
  store i32 %inc1, ptr @phase, align 4, !dbg !643
  %2 = load i32, ptr @phase, align 4, !dbg !644
  %cmp = icmp slt i32 %2, 2, !dbg !645
  %frombool = zext i1 %cmp to i8, !dbg !646
  store i8 %frombool, ptr %idle, align 1, !dbg !646
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !647
  %3 = load i8, ptr %idle, align 1, !dbg !648
  %tobool = trunc i8 %3 to i1, !dbg !648
  br i1 %tobool, label %if.then, label %if.end, !dbg !650

if.then:                                          ; preds = %entry
  %4 = load ptr, ptr %message.addr, align 8, !dbg !651
  %add.ptr = getelementptr inbounds i8, ptr %4, i64 1, !dbg !652
  store ptr %add.ptr, ptr %retval, align 8, !dbg !653
  br label %return, !dbg !653

if.end:                                           ; preds = %entry
  store i8 1, ptr %idle, align 1, !dbg !654
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !655
  %5 = load i32, ptr @phase, align 4, !dbg !657
  %inc2 = add nsw i32 %5, 1, !dbg !657
  store i32 %inc2, ptr @phase, align 4, !dbg !657
  call void @cond_timedwait(ptr noundef @cond, ptr noundef @cond_mutex, i64 noundef 10), !dbg !658
  %6 = load i32, ptr @phase, align 4, !dbg !659
  %inc3 = add nsw i32 %6, 1, !dbg !659
  store i32 %inc3, ptr @phase, align 4, !dbg !659
  %7 = load i32, ptr @phase, align 4, !dbg !660
  %cmp4 = icmp sgt i32 %7, 6, !dbg !661
  %frombool5 = zext i1 %cmp4 to i8, !dbg !662
  store i8 %frombool5, ptr %idle, align 1, !dbg !662
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !663
  %8 = load i8, ptr %idle, align 1, !dbg !664
  %tobool6 = trunc i8 %8 to i1, !dbg !664
  br i1 %tobool6, label %if.then7, label %if.end9, !dbg !666

if.then7:                                         ; preds = %if.end
  %9 = load ptr, ptr %message.addr, align 8, !dbg !667
  %add.ptr8 = getelementptr inbounds i8, ptr %9, i64 2, !dbg !668
  store ptr %add.ptr8, ptr %retval, align 8, !dbg !669
  br label %return, !dbg !669

if.end9:                                          ; preds = %if.end
  %10 = load ptr, ptr %message.addr, align 8, !dbg !670
  store ptr %10, ptr %retval, align 8, !dbg !671
  br label %return, !dbg !671

return:                                           ; preds = %if.end9, %if.then7, %if.then
  %11 = load ptr, ptr %retval, align 8, !dbg !672
  ret ptr %11, !dbg !672
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_test() #0 !dbg !673 {
entry:
  %message = alloca ptr, align 8
  %worker = alloca i64, align 8
  %result = alloca ptr, align 8
  call void @llvm.dbg.declare(metadata ptr %message, metadata !674, metadata !DIExpression()), !dbg !675
  store ptr inttoptr (i64 42 to ptr), ptr %message, align 8, !dbg !675
  call void @mutex_init(ptr noundef @cond_mutex, i32 noundef 0, i32 noundef 0, i32 noundef 0), !dbg !676
  call void @cond_init(ptr noundef @cond), !dbg !677
  call void @llvm.dbg.declare(metadata ptr %worker, metadata !678, metadata !DIExpression()), !dbg !679
  %0 = load ptr, ptr %message, align 8, !dbg !680
  %call = call i64 @thread_create(ptr noundef @cond_worker, ptr noundef %0), !dbg !681
  store i64 %call, ptr %worker, align 8, !dbg !679
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !682
  %1 = load i32, ptr @phase, align 4, !dbg !684
  %inc = add nsw i32 %1, 1, !dbg !684
  store i32 %inc, ptr @phase, align 4, !dbg !684
  call void @cond_signal(ptr noundef @cond), !dbg !685
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !686
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !687
  %2 = load i32, ptr @phase, align 4, !dbg !689
  %inc1 = add nsw i32 %2, 1, !dbg !689
  store i32 %inc1, ptr @phase, align 4, !dbg !689
  call void @cond_broadcast(ptr noundef @cond), !dbg !690
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !691
  call void @llvm.dbg.declare(metadata ptr %result, metadata !692, metadata !DIExpression()), !dbg !693
  %3 = load i64, ptr %worker, align 8, !dbg !694
  %call2 = call ptr @thread_join(i64 noundef %3), !dbg !695
  store ptr %call2, ptr %result, align 8, !dbg !693
  %4 = load ptr, ptr %result, align 8, !dbg !696
  %5 = load ptr, ptr %message, align 8, !dbg !696
  %cmp = icmp eq ptr %4, %5, !dbg !696
  br i1 %cmp, label %if.then, label %if.else, !dbg !699

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !699

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str.5, ptr noundef @.str.1, i32 noundef 241, ptr noundef @__PRETTY_FUNCTION__.cond_test) #7, !dbg !696
  unreachable, !dbg !696

if.end:                                           ; preds = %if.then
  call void @cond_destroy(ptr noundef @cond), !dbg !700
  call void @mutex_destroy(ptr noundef @cond_mutex), !dbg !701
  ret void, !dbg !702
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_init(ptr noundef %lock, i32 noundef %shared) #0 !dbg !703 {
entry:
  %lock.addr = alloca ptr, align 8
  %shared.addr = alloca i32, align 4
  %status = alloca i32, align 4
  %value = alloca i32, align 4
  %attributes = alloca %union.pthread_rwlockattr_t, align 8
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !733, metadata !DIExpression()), !dbg !734
  store i32 %shared, ptr %shared.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %shared.addr, metadata !735, metadata !DIExpression()), !dbg !736
  call void @llvm.dbg.declare(metadata ptr %status, metadata !737, metadata !DIExpression()), !dbg !738
  call void @llvm.dbg.declare(metadata ptr %value, metadata !739, metadata !DIExpression()), !dbg !740
  call void @llvm.dbg.declare(metadata ptr %attributes, metadata !741, metadata !DIExpression()), !dbg !747
  %call = call i32 @pthread_rwlockattr_init(ptr noundef %attributes) #6, !dbg !748
  store i32 %call, ptr %status, align 4, !dbg !749
  %0 = load i32, ptr %status, align 4, !dbg !750
  %cmp = icmp eq i32 %0, 0, !dbg !750
  br i1 %cmp, label %if.then, label %if.else, !dbg !753

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !753

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 258, ptr noundef @__PRETTY_FUNCTION__.rwlock_init) #7, !dbg !750
  unreachable, !dbg !750

if.end:                                           ; preds = %if.then
  %1 = load i32, ptr %shared.addr, align 4, !dbg !754
  %call1 = call i32 @pthread_rwlockattr_setpshared(ptr noundef %attributes, i32 noundef %1) #6, !dbg !755
  store i32 %call1, ptr %status, align 4, !dbg !756
  %2 = load i32, ptr %status, align 4, !dbg !757
  %cmp2 = icmp eq i32 %2, 0, !dbg !757
  br i1 %cmp2, label %if.then3, label %if.else4, !dbg !760

if.then3:                                         ; preds = %if.end
  br label %if.end5, !dbg !760

if.else4:                                         ; preds = %if.end
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 261, ptr noundef @__PRETTY_FUNCTION__.rwlock_init) #7, !dbg !757
  unreachable, !dbg !757

if.end5:                                          ; preds = %if.then3
  %call6 = call i32 @pthread_rwlockattr_getpshared(ptr noundef %attributes, ptr noundef %value) #6, !dbg !761
  store i32 %call6, ptr %status, align 4, !dbg !762
  %3 = load i32, ptr %status, align 4, !dbg !763
  %cmp7 = icmp eq i32 %3, 0, !dbg !763
  br i1 %cmp7, label %if.then8, label %if.else9, !dbg !766

if.then8:                                         ; preds = %if.end5
  br label %if.end10, !dbg !766

if.else9:                                         ; preds = %if.end5
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 263, ptr noundef @__PRETTY_FUNCTION__.rwlock_init) #7, !dbg !763
  unreachable, !dbg !763

if.end10:                                         ; preds = %if.then8
  %4 = load ptr, ptr %lock.addr, align 8, !dbg !767
  %call11 = call i32 @pthread_rwlock_init(ptr noundef %4, ptr noundef %attributes) #6, !dbg !768
  store i32 %call11, ptr %status, align 4, !dbg !769
  %5 = load i32, ptr %status, align 4, !dbg !770
  %cmp12 = icmp eq i32 %5, 0, !dbg !770
  br i1 %cmp12, label %if.then13, label %if.else14, !dbg !773

if.then13:                                        ; preds = %if.end10
  br label %if.end15, !dbg !773

if.else14:                                        ; preds = %if.end10
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 266, ptr noundef @__PRETTY_FUNCTION__.rwlock_init) #7, !dbg !770
  unreachable, !dbg !770

if.end15:                                         ; preds = %if.then13
  %call16 = call i32 @pthread_rwlockattr_destroy(ptr noundef %attributes) #6, !dbg !774
  store i32 %call16, ptr %status, align 4, !dbg !775
  %6 = load i32, ptr %status, align 4, !dbg !776
  %cmp17 = icmp eq i32 %6, 0, !dbg !776
  br i1 %cmp17, label %if.then18, label %if.else19, !dbg !779

if.then18:                                        ; preds = %if.end15
  br label %if.end20, !dbg !779

if.else19:                                        ; preds = %if.end15
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 268, ptr noundef @__PRETTY_FUNCTION__.rwlock_init) #7, !dbg !776
  unreachable, !dbg !776

if.end20:                                         ; preds = %if.then18
  ret void, !dbg !780
}

; Function Attrs: nounwind
declare i32 @pthread_rwlockattr_init(ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_rwlockattr_setpshared(ptr noundef, i32 noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_rwlockattr_getpshared(ptr noundef, ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_rwlock_init(ptr noundef, ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_rwlockattr_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_destroy(ptr noundef %lock) #0 !dbg !781 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !784, metadata !DIExpression()), !dbg !785
  call void @llvm.dbg.declare(metadata ptr %status, metadata !786, metadata !DIExpression()), !dbg !787
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !788
  %call = call i32 @pthread_rwlock_destroy(ptr noundef %0) #6, !dbg !789
  store i32 %call, ptr %status, align 4, !dbg !787
  %1 = load i32, ptr %status, align 4, !dbg !790
  %cmp = icmp eq i32 %1, 0, !dbg !790
  br i1 %cmp, label %if.then, label %if.else, !dbg !793

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !793

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 274, ptr noundef @__PRETTY_FUNCTION__.rwlock_destroy) #7, !dbg !790
  unreachable, !dbg !790

if.end:                                           ; preds = %if.then
  ret void, !dbg !794
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_destroy(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_wrlock(ptr noundef %lock) #0 !dbg !795 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !796, metadata !DIExpression()), !dbg !797
  call void @llvm.dbg.declare(metadata ptr %status, metadata !798, metadata !DIExpression()), !dbg !799
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !800
  %call = call i32 @pthread_rwlock_wrlock(ptr noundef %0) #6, !dbg !801
  store i32 %call, ptr %status, align 4, !dbg !799
  %1 = load i32, ptr %status, align 4, !dbg !802
  %cmp = icmp eq i32 %1, 0, !dbg !802
  br i1 %cmp, label %if.then, label %if.else, !dbg !805

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !805

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 280, ptr noundef @__PRETTY_FUNCTION__.rwlock_wrlock) #7, !dbg !802
  unreachable, !dbg !802

if.end:                                           ; preds = %if.then
  ret void, !dbg !806
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_wrlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @rwlock_trywrlock(ptr noundef %lock) #0 !dbg !807 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !810, metadata !DIExpression()), !dbg !811
  call void @llvm.dbg.declare(metadata ptr %status, metadata !812, metadata !DIExpression()), !dbg !813
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !814
  %call = call i32 @pthread_rwlock_trywrlock(ptr noundef %0) #6, !dbg !815
  store i32 %call, ptr %status, align 4, !dbg !813
  %1 = load i32, ptr %status, align 4, !dbg !816
  %cmp = icmp eq i32 %1, 0, !dbg !816
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !816

lor.lhs.false:                                    ; preds = %entry
  %2 = load i32, ptr %status, align 4, !dbg !816
  %cmp1 = icmp eq i32 %2, 16, !dbg !816
  br i1 %cmp1, label %if.then, label %if.else, !dbg !819

if.then:                                          ; preds = %lor.lhs.false, %entry
  br label %if.end, !dbg !819

if.else:                                          ; preds = %lor.lhs.false
  call void @__assert_fail(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 286, ptr noundef @__PRETTY_FUNCTION__.rwlock_trywrlock) #7, !dbg !816
  unreachable, !dbg !816

if.end:                                           ; preds = %if.then
  %3 = load i32, ptr %status, align 4, !dbg !820
  %cmp2 = icmp eq i32 %3, 0, !dbg !821
  ret i1 %cmp2, !dbg !822
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_trywrlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_rdlock(ptr noundef %lock) #0 !dbg !823 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !824, metadata !DIExpression()), !dbg !825
  call void @llvm.dbg.declare(metadata ptr %status, metadata !826, metadata !DIExpression()), !dbg !827
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !828
  %call = call i32 @pthread_rwlock_rdlock(ptr noundef %0) #6, !dbg !829
  store i32 %call, ptr %status, align 4, !dbg !827
  %1 = load i32, ptr %status, align 4, !dbg !830
  %cmp = icmp eq i32 %1, 0, !dbg !830
  br i1 %cmp, label %if.then, label %if.else, !dbg !833

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !833

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 293, ptr noundef @__PRETTY_FUNCTION__.rwlock_rdlock) #7, !dbg !830
  unreachable, !dbg !830

if.end:                                           ; preds = %if.then
  ret void, !dbg !834
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_rdlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @rwlock_tryrdlock(ptr noundef %lock) #0 !dbg !835 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !836, metadata !DIExpression()), !dbg !837
  call void @llvm.dbg.declare(metadata ptr %status, metadata !838, metadata !DIExpression()), !dbg !839
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !840
  %call = call i32 @pthread_rwlock_tryrdlock(ptr noundef %0) #6, !dbg !841
  store i32 %call, ptr %status, align 4, !dbg !839
  %1 = load i32, ptr %status, align 4, !dbg !842
  %cmp = icmp eq i32 %1, 0, !dbg !842
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !842

lor.lhs.false:                                    ; preds = %entry
  %2 = load i32, ptr %status, align 4, !dbg !842
  %cmp1 = icmp eq i32 %2, 16, !dbg !842
  br i1 %cmp1, label %if.then, label %if.else, !dbg !845

if.then:                                          ; preds = %lor.lhs.false, %entry
  br label %if.end, !dbg !845

if.else:                                          ; preds = %lor.lhs.false
  call void @__assert_fail(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 299, ptr noundef @__PRETTY_FUNCTION__.rwlock_tryrdlock) #7, !dbg !842
  unreachable, !dbg !842

if.end:                                           ; preds = %if.then
  %3 = load i32, ptr %status, align 4, !dbg !846
  %cmp2 = icmp eq i32 %3, 0, !dbg !847
  ret i1 %cmp2, !dbg !848
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_tryrdlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_unlock(ptr noundef %lock) #0 !dbg !849 {
entry:
  %lock.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %lock, ptr %lock.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %lock.addr, metadata !850, metadata !DIExpression()), !dbg !851
  call void @llvm.dbg.declare(metadata ptr %status, metadata !852, metadata !DIExpression()), !dbg !853
  %0 = load ptr, ptr %lock.addr, align 8, !dbg !854
  %call = call i32 @pthread_rwlock_unlock(ptr noundef %0) #6, !dbg !855
  store i32 %call, ptr %status, align 4, !dbg !853
  %1 = load i32, ptr %status, align 4, !dbg !856
  %cmp = icmp eq i32 %1, 0, !dbg !856
  br i1 %cmp, label %if.then, label %if.else, !dbg !859

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !859

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 306, ptr noundef @__PRETTY_FUNCTION__.rwlock_unlock) #7, !dbg !856
  unreachable, !dbg !856

if.end:                                           ; preds = %if.then
  ret void, !dbg !860
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_unlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_test() #0 !dbg !861 {
entry:
  %lock = alloca %union.pthread_rwlock_t, align 8
  %test_depth = alloca i32, align 4
  %success = alloca i8, align 1
  %i = alloca i32, align 4
  %success7 = alloca i8, align 1
  %success14 = alloca i8, align 1
  %i21 = alloca i32, align 4
  %success28 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata ptr %lock, metadata !862, metadata !DIExpression()), !dbg !863
  call void @rwlock_init(ptr noundef %lock, i32 noundef 0), !dbg !864
  call void @llvm.dbg.declare(metadata ptr %test_depth, metadata !865, metadata !DIExpression()), !dbg !867
  store i32 4, ptr %test_depth, align 4, !dbg !867
  call void @rwlock_wrlock(ptr noundef %lock), !dbg !868
  call void @llvm.dbg.declare(metadata ptr %success, metadata !870, metadata !DIExpression()), !dbg !871
  %call = call zeroext i1 @rwlock_trywrlock(ptr noundef %lock), !dbg !872
  %frombool = zext i1 %call to i8, !dbg !871
  store i8 %frombool, ptr %success, align 1, !dbg !871
  %0 = load i8, ptr %success, align 1, !dbg !873
  %tobool = trunc i8 %0 to i1, !dbg !873
  br i1 %tobool, label %if.else, label %if.then, !dbg !876

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !876

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 318, ptr noundef @__PRETTY_FUNCTION__.rwlock_test) #7, !dbg !873
  unreachable, !dbg !873

if.end:                                           ; preds = %if.then
  %call1 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %lock), !dbg !877
  %frombool2 = zext i1 %call1 to i8, !dbg !878
  store i8 %frombool2, ptr %success, align 1, !dbg !878
  %1 = load i8, ptr %success, align 1, !dbg !879
  %tobool3 = trunc i8 %1 to i1, !dbg !879
  br i1 %tobool3, label %if.else5, label %if.then4, !dbg !882

if.then4:                                         ; preds = %if.end
  br label %if.end6, !dbg !882

if.else5:                                         ; preds = %if.end
  call void @__assert_fail(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 320, ptr noundef @__PRETTY_FUNCTION__.rwlock_test) #7, !dbg !879
  unreachable, !dbg !879

if.end6:                                          ; preds = %if.then4
  call void @rwlock_unlock(ptr noundef %lock), !dbg !883
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !884
  call void @llvm.dbg.declare(metadata ptr %i, metadata !886, metadata !DIExpression()), !dbg !888
  store i32 0, ptr %i, align 4, !dbg !888
  br label %for.cond, !dbg !889

for.cond:                                         ; preds = %for.inc, %if.end6
  %2 = load i32, ptr %i, align 4, !dbg !890
  %cmp = icmp slt i32 %2, 4, !dbg !892
  br i1 %cmp, label %for.body, label %for.end, !dbg !893

for.body:                                         ; preds = %for.cond
  call void @llvm.dbg.declare(metadata ptr %success7, metadata !894, metadata !DIExpression()), !dbg !896
  %call8 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %lock), !dbg !897
  %frombool9 = zext i1 %call8 to i8, !dbg !896
  store i8 %frombool9, ptr %success7, align 1, !dbg !896
  %3 = load i8, ptr %success7, align 1, !dbg !898
  %tobool10 = trunc i8 %3 to i1, !dbg !898
  br i1 %tobool10, label %if.then11, label %if.else12, !dbg !901

if.then11:                                        ; preds = %for.body
  br label %if.end13, !dbg !901

if.else12:                                        ; preds = %for.body
  call void @__assert_fail(ptr noundef @.str.4, ptr noundef @.str.1, i32 noundef 329, ptr noundef @__PRETTY_FUNCTION__.rwlock_test) #7, !dbg !898
  unreachable, !dbg !898

if.end13:                                         ; preds = %if.then11
  br label %for.inc, !dbg !902

for.inc:                                          ; preds = %if.end13
  %4 = load i32, ptr %i, align 4, !dbg !903
  %inc = add nsw i32 %4, 1, !dbg !903
  store i32 %inc, ptr %i, align 4, !dbg !903
  br label %for.cond, !dbg !904, !llvm.loop !905

for.end:                                          ; preds = %for.cond
  call void @llvm.dbg.declare(metadata ptr %success14, metadata !908, metadata !DIExpression()), !dbg !910
  %call15 = call zeroext i1 @rwlock_trywrlock(ptr noundef %lock), !dbg !911
  %frombool16 = zext i1 %call15 to i8, !dbg !910
  store i8 %frombool16, ptr %success14, align 1, !dbg !910
  %5 = load i8, ptr %success14, align 1, !dbg !912
  %tobool17 = trunc i8 %5 to i1, !dbg !912
  br i1 %tobool17, label %if.else19, label %if.then18, !dbg !915

if.then18:                                        ; preds = %for.end
  br label %if.end20, !dbg !915

if.else19:                                        ; preds = %for.end
  call void @__assert_fail(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 334, ptr noundef @__PRETTY_FUNCTION__.rwlock_test) #7, !dbg !912
  unreachable, !dbg !912

if.end20:                                         ; preds = %if.then18
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !916
  call void @llvm.dbg.declare(metadata ptr %i21, metadata !917, metadata !DIExpression()), !dbg !919
  store i32 0, ptr %i21, align 4, !dbg !919
  br label %for.cond22, !dbg !920

for.cond22:                                       ; preds = %for.inc25, %if.end20
  %6 = load i32, ptr %i21, align 4, !dbg !921
  %cmp23 = icmp slt i32 %6, 4, !dbg !923
  br i1 %cmp23, label %for.body24, label %for.end27, !dbg !924

for.body24:                                       ; preds = %for.cond22
  call void @rwlock_unlock(ptr noundef %lock), !dbg !925
  br label %for.inc25, !dbg !927

for.inc25:                                        ; preds = %for.body24
  %7 = load i32, ptr %i21, align 4, !dbg !928
  %inc26 = add nsw i32 %7, 1, !dbg !928
  store i32 %inc26, ptr %i21, align 4, !dbg !928
  br label %for.cond22, !dbg !929, !llvm.loop !930

for.end27:                                        ; preds = %for.cond22
  call void @rwlock_wrlock(ptr noundef %lock), !dbg !932
  call void @llvm.dbg.declare(metadata ptr %success28, metadata !934, metadata !DIExpression()), !dbg !935
  %call29 = call zeroext i1 @rwlock_trywrlock(ptr noundef %lock), !dbg !936
  %frombool30 = zext i1 %call29 to i8, !dbg !935
  store i8 %frombool30, ptr %success28, align 1, !dbg !935
  %8 = load i8, ptr %success28, align 1, !dbg !937
  %tobool31 = trunc i8 %8 to i1, !dbg !937
  br i1 %tobool31, label %if.else33, label %if.then32, !dbg !940

if.then32:                                        ; preds = %for.end27
  br label %if.end34, !dbg !940

if.else33:                                        ; preds = %for.end27
  call void @__assert_fail(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 346, ptr noundef @__PRETTY_FUNCTION__.rwlock_test) #7, !dbg !937
  unreachable, !dbg !937

if.end34:                                         ; preds = %if.then32
  call void @rwlock_unlock(ptr noundef %lock), !dbg !941
  call void @rwlock_destroy(ptr noundef %lock), !dbg !942
  ret void, !dbg !943
}

declare void @__VERIFIER_loop_bound(i32 noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @key_destroy(ptr noundef %unused_value) #0 !dbg !944 {
entry:
  %unused_value.addr = alloca ptr, align 8
  store ptr %unused_value, ptr %unused_value.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %unused_value.addr, metadata !947, metadata !DIExpression()), !dbg !948
  %call = call i64 @pthread_self() #8, !dbg !949
  store i64 %call, ptr @latest_thread, align 8, !dbg !950
  ret void, !dbg !951
}

; Function Attrs: nounwind willreturn memory(none)
declare i64 @pthread_self() #5

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @key_worker(ptr noundef %message) #0 !dbg !952 {
entry:
  %message.addr = alloca ptr, align 8
  %my_secret = alloca i32, align 4
  %status = alloca i32, align 4
  %my_local_data = alloca ptr, align 8
  store ptr %message, ptr %message.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %message.addr, metadata !953, metadata !DIExpression()), !dbg !954
  call void @llvm.dbg.declare(metadata ptr %my_secret, metadata !955, metadata !DIExpression()), !dbg !956
  store i32 1, ptr %my_secret, align 4, !dbg !956
  call void @llvm.dbg.declare(metadata ptr %status, metadata !957, metadata !DIExpression()), !dbg !958
  %0 = load i32, ptr @local_data, align 4, !dbg !959
  %call = call i32 @pthread_setspecific(i32 noundef %0, ptr noundef %my_secret) #6, !dbg !960
  store i32 %call, ptr %status, align 4, !dbg !958
  %1 = load i32, ptr %status, align 4, !dbg !961
  %cmp = icmp eq i32 %1, 0, !dbg !961
  br i1 %cmp, label %if.then, label %if.else, !dbg !964

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !964

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 368, ptr noundef @__PRETTY_FUNCTION__.key_worker) #7, !dbg !961
  unreachable, !dbg !961

if.end:                                           ; preds = %if.then
  call void @llvm.dbg.declare(metadata ptr %my_local_data, metadata !965, metadata !DIExpression()), !dbg !966
  %2 = load i32, ptr @local_data, align 4, !dbg !967
  %call1 = call ptr @pthread_getspecific(i32 noundef %2) #6, !dbg !968
  store ptr %call1, ptr %my_local_data, align 8, !dbg !966
  %3 = load ptr, ptr %my_local_data, align 8, !dbg !969
  %cmp2 = icmp eq ptr %3, %my_secret, !dbg !969
  br i1 %cmp2, label %if.then3, label %if.else4, !dbg !972

if.then3:                                         ; preds = %if.end
  br label %if.end5, !dbg !972

if.else4:                                         ; preds = %if.end
  call void @__assert_fail(ptr noundef @.str.6, ptr noundef @.str.1, i32 noundef 371, ptr noundef @__PRETTY_FUNCTION__.key_worker) #7, !dbg !969
  unreachable, !dbg !969

if.end5:                                          ; preds = %if.then3
  %4 = load ptr, ptr %message.addr, align 8, !dbg !973
  ret ptr %4, !dbg !974
}

; Function Attrs: nounwind
declare i32 @pthread_setspecific(i32 noundef, ptr noundef) #2

; Function Attrs: nounwind
declare ptr @pthread_getspecific(i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @key_test() #0 !dbg !975 {
entry:
  %my_secret = alloca i32, align 4
  %message = alloca ptr, align 8
  %status = alloca i32, align 4
  %worker = alloca i64, align 8
  %my_local_data = alloca ptr, align 8
  %result = alloca ptr, align 8
  call void @llvm.dbg.declare(metadata ptr %my_secret, metadata !976, metadata !DIExpression()), !dbg !977
  store i32 2, ptr %my_secret, align 4, !dbg !977
  call void @llvm.dbg.declare(metadata ptr %message, metadata !978, metadata !DIExpression()), !dbg !979
  store ptr inttoptr (i64 41 to ptr), ptr %message, align 8, !dbg !979
  call void @llvm.dbg.declare(metadata ptr %status, metadata !980, metadata !DIExpression()), !dbg !981
  %call = call i32 @pthread_key_create(ptr noundef @local_data, ptr noundef @key_destroy) #6, !dbg !982
  call void @llvm.dbg.declare(metadata ptr %worker, metadata !983, metadata !DIExpression()), !dbg !984
  %0 = load ptr, ptr %message, align 8, !dbg !985
  %call1 = call i64 @thread_create(ptr noundef @key_worker, ptr noundef %0), !dbg !986
  store i64 %call1, ptr %worker, align 8, !dbg !984
  %1 = load i32, ptr @local_data, align 4, !dbg !987
  %call2 = call i32 @pthread_setspecific(i32 noundef %1, ptr noundef %my_secret) #6, !dbg !988
  store i32 %call2, ptr %status, align 4, !dbg !989
  %2 = load i32, ptr %status, align 4, !dbg !990
  %cmp = icmp eq i32 %2, 0, !dbg !990
  br i1 %cmp, label %if.then, label %if.else, !dbg !993

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !993

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 387, ptr noundef @__PRETTY_FUNCTION__.key_test) #7, !dbg !990
  unreachable, !dbg !990

if.end:                                           ; preds = %if.then
  call void @llvm.dbg.declare(metadata ptr %my_local_data, metadata !994, metadata !DIExpression()), !dbg !995
  %3 = load i32, ptr @local_data, align 4, !dbg !996
  %call3 = call ptr @pthread_getspecific(i32 noundef %3) #6, !dbg !997
  store ptr %call3, ptr %my_local_data, align 8, !dbg !995
  %4 = load ptr, ptr %my_local_data, align 8, !dbg !998
  %cmp4 = icmp eq ptr %4, %my_secret, !dbg !998
  br i1 %cmp4, label %if.then5, label %if.else6, !dbg !1001

if.then5:                                         ; preds = %if.end
  br label %if.end7, !dbg !1001

if.else6:                                         ; preds = %if.end
  call void @__assert_fail(ptr noundef @.str.6, ptr noundef @.str.1, i32 noundef 390, ptr noundef @__PRETTY_FUNCTION__.key_test) #7, !dbg !998
  unreachable, !dbg !998

if.end7:                                          ; preds = %if.then5
  %5 = load i32, ptr @local_data, align 4, !dbg !1002
  %call8 = call i32 @pthread_setspecific(i32 noundef %5, ptr noundef null) #6, !dbg !1003
  store i32 %call8, ptr %status, align 4, !dbg !1004
  %6 = load i32, ptr %status, align 4, !dbg !1005
  %cmp9 = icmp eq i32 %6, 0, !dbg !1005
  br i1 %cmp9, label %if.then10, label %if.else11, !dbg !1008

if.then10:                                        ; preds = %if.end7
  br label %if.end12, !dbg !1008

if.else11:                                        ; preds = %if.end7
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 393, ptr noundef @__PRETTY_FUNCTION__.key_test) #7, !dbg !1005
  unreachable, !dbg !1005

if.end12:                                         ; preds = %if.then10
  call void @llvm.dbg.declare(metadata ptr %result, metadata !1009, metadata !DIExpression()), !dbg !1010
  %7 = load i64, ptr %worker, align 8, !dbg !1011
  %call13 = call ptr @thread_join(i64 noundef %7), !dbg !1012
  store ptr %call13, ptr %result, align 8, !dbg !1010
  %8 = load ptr, ptr %result, align 8, !dbg !1013
  %9 = load ptr, ptr %message, align 8, !dbg !1013
  %cmp14 = icmp eq ptr %8, %9, !dbg !1013
  br i1 %cmp14, label %if.then15, label %if.else16, !dbg !1016

if.then15:                                        ; preds = %if.end12
  br label %if.end17, !dbg !1016

if.else16:                                        ; preds = %if.end12
  call void @__assert_fail(ptr noundef @.str.5, ptr noundef @.str.1, i32 noundef 396, ptr noundef @__PRETTY_FUNCTION__.key_test) #7, !dbg !1013
  unreachable, !dbg !1013

if.end17:                                         ; preds = %if.then15
  %10 = load i32, ptr @local_data, align 4, !dbg !1017
  %call18 = call i32 @pthread_key_delete(i32 noundef %10) #6, !dbg !1018
  store i32 %call18, ptr %status, align 4, !dbg !1019
  %11 = load i32, ptr %status, align 4, !dbg !1020
  %cmp19 = icmp eq i32 %11, 0, !dbg !1020
  br i1 %cmp19, label %if.then20, label %if.else21, !dbg !1023

if.then20:                                        ; preds = %if.end17
  br label %if.end22, !dbg !1023

if.else21:                                        ; preds = %if.end17
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 399, ptr noundef @__PRETTY_FUNCTION__.key_test) #7, !dbg !1020
  unreachable, !dbg !1020

if.end22:                                         ; preds = %if.then20
  %12 = load i64, ptr @latest_thread, align 8, !dbg !1024
  %13 = load i64, ptr %worker, align 8, !dbg !1024
  %call23 = call i32 @pthread_equal(i64 noundef %12, i64 noundef %13) #8, !dbg !1024
  %tobool = icmp ne i32 %call23, 0, !dbg !1024
  br i1 %tobool, label %if.then24, label %if.else25, !dbg !1027

if.then24:                                        ; preds = %if.end22
  br label %if.end26, !dbg !1027

if.else25:                                        ; preds = %if.end22
  call void @__assert_fail(ptr noundef @.str.7, ptr noundef @.str.1, i32 noundef 401, ptr noundef @__PRETTY_FUNCTION__.key_test) #7, !dbg !1024
  unreachable, !dbg !1024

if.end26:                                         ; preds = %if.then24
  ret void, !dbg !1028
}

; Function Attrs: nounwind
declare i32 @pthread_key_create(ptr noundef, ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_key_delete(i32 noundef) #2

; Function Attrs: nounwind willreturn memory(none)
declare i32 @pthread_equal(i64 noundef, i64 noundef) #5

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @detach_test_worker0(ptr noundef %ignore) #0 !dbg !1029 {
entry:
  %ignore.addr = alloca ptr, align 8
  store ptr %ignore, ptr %ignore.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %ignore.addr, metadata !1030, metadata !DIExpression()), !dbg !1031
  ret ptr null, !dbg !1032
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @detach_test_detach(ptr noundef %ignore) #0 !dbg !1033 {
entry:
  %ignore.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  %w0 = alloca i64, align 8
  store ptr %ignore, ptr %ignore.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %ignore.addr, metadata !1034, metadata !DIExpression()), !dbg !1035
  call void @llvm.dbg.declare(metadata ptr %status, metadata !1036, metadata !DIExpression()), !dbg !1037
  call void @llvm.dbg.declare(metadata ptr %w0, metadata !1038, metadata !DIExpression()), !dbg !1039
  %call = call i64 @thread_create(ptr noundef @detach_test_worker0, ptr noundef null), !dbg !1040
  store i64 %call, ptr %w0, align 8, !dbg !1039
  %0 = load i64, ptr %w0, align 8, !dbg !1041
  %call1 = call i32 @pthread_detach(i64 noundef %0) #6, !dbg !1042
  store i32 %call1, ptr %status, align 4, !dbg !1043
  %1 = load i32, ptr %status, align 4, !dbg !1044
  %cmp = icmp eq i32 %1, 0, !dbg !1044
  br i1 %cmp, label %if.then, label %if.else, !dbg !1047

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !1047

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 416, ptr noundef @__PRETTY_FUNCTION__.detach_test_detach) #7, !dbg !1044
  unreachable, !dbg !1044

if.end:                                           ; preds = %if.then
  %2 = load i64, ptr %w0, align 8, !dbg !1048
  %call2 = call i32 @pthread_join(i64 noundef %2, ptr noundef null), !dbg !1049
  store i32 %call2, ptr %status, align 4, !dbg !1050
  %3 = load i32, ptr %status, align 4, !dbg !1051
  %cmp3 = icmp ne i32 %3, 0, !dbg !1051
  br i1 %cmp3, label %if.then4, label %if.else5, !dbg !1054

if.then4:                                         ; preds = %if.end
  br label %if.end6, !dbg !1054

if.else5:                                         ; preds = %if.end
  call void @__assert_fail(ptr noundef @.str.8, ptr noundef @.str.1, i32 noundef 419, ptr noundef @__PRETTY_FUNCTION__.detach_test_detach) #7, !dbg !1051
  unreachable, !dbg !1051

if.end6:                                          ; preds = %if.then4
  ret ptr null, !dbg !1055
}

; Function Attrs: nounwind
declare i32 @pthread_detach(i64 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @detach_test_attr(ptr noundef %ignore) #0 !dbg !1056 {
entry:
  %ignore.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  %detachstate = alloca i32, align 4
  %w0 = alloca i64, align 8
  %w0_attr = alloca %union.pthread_attr_t, align 8
  store ptr %ignore, ptr %ignore.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %ignore.addr, metadata !1057, metadata !DIExpression()), !dbg !1058
  call void @llvm.dbg.declare(metadata ptr %status, metadata !1059, metadata !DIExpression()), !dbg !1060
  call void @llvm.dbg.declare(metadata ptr %detachstate, metadata !1061, metadata !DIExpression()), !dbg !1062
  call void @llvm.dbg.declare(metadata ptr %w0, metadata !1063, metadata !DIExpression()), !dbg !1064
  call void @llvm.dbg.declare(metadata ptr %w0_attr, metadata !1065, metadata !DIExpression()), !dbg !1066
  %call = call i32 @pthread_attr_init(ptr noundef %w0_attr) #6, !dbg !1067
  store i32 %call, ptr %status, align 4, !dbg !1068
  %0 = load i32, ptr %status, align 4, !dbg !1069
  %cmp = icmp eq i32 %0, 0, !dbg !1069
  br i1 %cmp, label %if.then, label %if.else, !dbg !1072

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !1072

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 430, ptr noundef @__PRETTY_FUNCTION__.detach_test_attr) #7, !dbg !1069
  unreachable, !dbg !1069

if.end:                                           ; preds = %if.then
  %call1 = call i32 @pthread_attr_getdetachstate(ptr noundef %w0_attr, ptr noundef %detachstate) #6, !dbg !1073
  store i32 %call1, ptr %status, align 4, !dbg !1074
  %1 = load i32, ptr %status, align 4, !dbg !1075
  %cmp2 = icmp eq i32 %1, 0, !dbg !1075
  br i1 %cmp2, label %land.lhs.true, label %if.else5, !dbg !1075

land.lhs.true:                                    ; preds = %if.end
  %2 = load i32, ptr %detachstate, align 4, !dbg !1075
  %cmp3 = icmp eq i32 %2, 0, !dbg !1075
  br i1 %cmp3, label %if.then4, label %if.else5, !dbg !1078

if.then4:                                         ; preds = %land.lhs.true
  br label %if.end6, !dbg !1078

if.else5:                                         ; preds = %land.lhs.true, %if.end
  call void @__assert_fail(ptr noundef @.str.9, ptr noundef @.str.1, i32 noundef 432, ptr noundef @__PRETTY_FUNCTION__.detach_test_attr) #7, !dbg !1075
  unreachable, !dbg !1075

if.end6:                                          ; preds = %if.then4
  %call7 = call i32 @pthread_attr_setdetachstate(ptr noundef %w0_attr, i32 noundef 1) #6, !dbg !1079
  store i32 %call7, ptr %status, align 4, !dbg !1080
  %3 = load i32, ptr %status, align 4, !dbg !1081
  %cmp8 = icmp eq i32 %3, 0, !dbg !1081
  br i1 %cmp8, label %if.then9, label %if.else10, !dbg !1084

if.then9:                                         ; preds = %if.end6
  br label %if.end11, !dbg !1084

if.else10:                                        ; preds = %if.end6
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 434, ptr noundef @__PRETTY_FUNCTION__.detach_test_attr) #7, !dbg !1081
  unreachable, !dbg !1081

if.end11:                                         ; preds = %if.then9
  %call12 = call i32 @pthread_attr_getdetachstate(ptr noundef %w0_attr, ptr noundef %detachstate) #6, !dbg !1085
  store i32 %call12, ptr %status, align 4, !dbg !1086
  %4 = load i32, ptr %status, align 4, !dbg !1087
  %cmp13 = icmp eq i32 %4, 0, !dbg !1087
  br i1 %cmp13, label %land.lhs.true14, label %if.else17, !dbg !1087

land.lhs.true14:                                  ; preds = %if.end11
  %5 = load i32, ptr %detachstate, align 4, !dbg !1087
  %cmp15 = icmp eq i32 %5, 1, !dbg !1087
  br i1 %cmp15, label %if.then16, label %if.else17, !dbg !1090

if.then16:                                        ; preds = %land.lhs.true14
  br label %if.end18, !dbg !1090

if.else17:                                        ; preds = %land.lhs.true14, %if.end11
  call void @__assert_fail(ptr noundef @.str.10, ptr noundef @.str.1, i32 noundef 436, ptr noundef @__PRETTY_FUNCTION__.detach_test_attr) #7, !dbg !1087
  unreachable, !dbg !1087

if.end18:                                         ; preds = %if.then16
  %call19 = call i32 @pthread_create(ptr noundef %w0, ptr noundef %w0_attr, ptr noundef @detach_test_worker0, ptr noundef null) #6, !dbg !1091
  store i32 %call19, ptr %status, align 4, !dbg !1092
  %6 = load i32, ptr %status, align 4, !dbg !1093
  %cmp20 = icmp eq i32 %6, 0, !dbg !1093
  br i1 %cmp20, label %if.then21, label %if.else22, !dbg !1096

if.then21:                                        ; preds = %if.end18
  br label %if.end23, !dbg !1096

if.else22:                                        ; preds = %if.end18
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 438, ptr noundef @__PRETTY_FUNCTION__.detach_test_attr) #7, !dbg !1093
  unreachable, !dbg !1093

if.end23:                                         ; preds = %if.then21
  %call24 = call i32 @pthread_attr_destroy(ptr noundef %w0_attr) #6, !dbg !1097
  %7 = load i64, ptr %w0, align 8, !dbg !1098
  %call25 = call i32 @pthread_join(i64 noundef %7, ptr noundef null), !dbg !1099
  store i32 %call25, ptr %status, align 4, !dbg !1100
  %8 = load i32, ptr %status, align 4, !dbg !1101
  %cmp26 = icmp ne i32 %8, 0, !dbg !1101
  br i1 %cmp26, label %if.then27, label %if.else28, !dbg !1104

if.then27:                                        ; preds = %if.end23
  br label %if.end29, !dbg !1104

if.else28:                                        ; preds = %if.end23
  call void @__assert_fail(ptr noundef @.str.8, ptr noundef @.str.1, i32 noundef 442, ptr noundef @__PRETTY_FUNCTION__.detach_test_attr) #7, !dbg !1101
  unreachable, !dbg !1101

if.end29:                                         ; preds = %if.then27
  ret ptr null, !dbg !1105
}

; Function Attrs: nounwind
declare i32 @pthread_attr_getdetachstate(ptr noundef, ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_attr_setdetachstate(ptr noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @detach_test() #0 !dbg !1106 {
entry:
  %call = call i64 @thread_create(ptr noundef @detach_test_detach, ptr noundef null), !dbg !1107
  %call1 = call i64 @thread_create(ptr noundef @detach_test_attr, ptr noundef null), !dbg !1108
  ret void, !dbg !1109
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @once_init0() #0 !dbg !1110 {
entry:
  %0 = load i32, ptr @once_calls, align 4, !dbg !1111
  %inc = add nsw i32 %0, 1, !dbg !1111
  store i32 %inc, ptr @once_calls, align 4, !dbg !1111
  store i32 42, ptr @once_value, align 4, !dbg !1112
  ret void, !dbg !1113
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @once_init1() #0 !dbg !1114 {
entry:
  %0 = load i32, ptr @once_calls, align 4, !dbg !1115
  %inc = add nsw i32 %0, 1, !dbg !1115
  store i32 %inc, ptr @once_calls, align 4, !dbg !1115
  ret void, !dbg !1116
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @once_worker(ptr noundef %ignore) #0 !dbg !1117 {
entry:
  %ignore.addr = alloca ptr, align 8
  %status = alloca i32, align 4
  store ptr %ignore, ptr %ignore.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %ignore.addr, metadata !1118, metadata !DIExpression()), !dbg !1119
  call void @llvm.dbg.declare(metadata ptr %status, metadata !1120, metadata !DIExpression()), !dbg !1121
  %call = call i32 @pthread_once(ptr noundef @once0, ptr noundef @once_init0), !dbg !1122
  store i32 %call, ptr %status, align 4, !dbg !1121
  %0 = load i32, ptr %status, align 4, !dbg !1123
  %cmp = icmp eq i32 %0, 0, !dbg !1123
  br i1 %cmp, label %if.then, label %if.else, !dbg !1126

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !1126

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 473, ptr noundef @__PRETTY_FUNCTION__.once_worker) #7, !dbg !1123
  unreachable, !dbg !1123

if.end:                                           ; preds = %if.then
  %1 = load i32, ptr @once_value, align 4, !dbg !1127
  %cmp1 = icmp eq i32 %1, 42, !dbg !1127
  br i1 %cmp1, label %if.then2, label %if.else3, !dbg !1130

if.then2:                                         ; preds = %if.end
  br label %if.end4, !dbg !1130

if.else3:                                         ; preds = %if.end
  call void @__assert_fail(ptr noundef @.str.11, ptr noundef @.str.1, i32 noundef 474, ptr noundef @__PRETTY_FUNCTION__.once_worker) #7, !dbg !1127
  unreachable, !dbg !1127

if.end4:                                          ; preds = %if.then2
  ret ptr null, !dbg !1131
}

declare i32 @pthread_once(ptr noundef, ptr noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @once_test() #0 !dbg !1132 {
entry:
  %worker0 = alloca i64, align 8
  %worker1 = alloca i64, align 8
  %status = alloca i32, align 4
  call void @llvm.dbg.declare(metadata ptr %worker0, metadata !1133, metadata !DIExpression()), !dbg !1134
  %call = call i64 @thread_create(ptr noundef @once_worker, ptr noundef null), !dbg !1135
  store i64 %call, ptr %worker0, align 8, !dbg !1134
  call void @llvm.dbg.declare(metadata ptr %worker1, metadata !1136, metadata !DIExpression()), !dbg !1137
  %call1 = call i64 @thread_create(ptr noundef @once_worker, ptr noundef null), !dbg !1138
  store i64 %call1, ptr %worker1, align 8, !dbg !1137
  %0 = load i64, ptr %worker0, align 8, !dbg !1139
  %call2 = call ptr @thread_join(i64 noundef %0), !dbg !1140
  %1 = load i64, ptr %worker1, align 8, !dbg !1141
  %call3 = call ptr @thread_join(i64 noundef %1), !dbg !1142
  %2 = load i32, ptr @once_calls, align 4, !dbg !1143
  %cmp = icmp eq i32 %2, 1, !dbg !1143
  br i1 %cmp, label %if.then, label %if.else, !dbg !1146

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !1146

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str.12, ptr noundef @.str.1, i32 noundef 484, ptr noundef @__PRETTY_FUNCTION__.once_test) #7, !dbg !1143
  unreachable, !dbg !1143

if.end:                                           ; preds = %if.then
  call void @llvm.dbg.declare(metadata ptr %status, metadata !1147, metadata !DIExpression()), !dbg !1148
  %call4 = call i32 @pthread_once(ptr noundef @once1, ptr noundef @once_init1), !dbg !1149
  store i32 %call4, ptr %status, align 4, !dbg !1148
  %3 = load i32, ptr %status, align 4, !dbg !1150
  %cmp5 = icmp eq i32 %3, 0, !dbg !1150
  br i1 %cmp5, label %if.then6, label %if.else7, !dbg !1153

if.then6:                                         ; preds = %if.end
  br label %if.end8, !dbg !1153

if.else7:                                         ; preds = %if.end
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 487, ptr noundef @__PRETTY_FUNCTION__.once_test) #7, !dbg !1150
  unreachable, !dbg !1150

if.end8:                                          ; preds = %if.then6
  %call9 = call i32 @pthread_once(ptr noundef @once1, ptr noundef @once_init1), !dbg !1154
  store i32 %call9, ptr %status, align 4, !dbg !1155
  %4 = load i32, ptr %status, align 4, !dbg !1156
  %cmp10 = icmp eq i32 %4, 0, !dbg !1156
  br i1 %cmp10, label %if.then11, label %if.else12, !dbg !1159

if.then11:                                        ; preds = %if.end8
  br label %if.end13, !dbg !1159

if.else12:                                        ; preds = %if.end8
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 489, ptr noundef @__PRETTY_FUNCTION__.once_test) #7, !dbg !1156
  unreachable, !dbg !1156

if.end13:                                         ; preds = %if.then11
  %5 = load i32, ptr @once_calls, align 4, !dbg !1160
  %cmp14 = icmp eq i32 %5, 2, !dbg !1160
  br i1 %cmp14, label %if.then15, label %if.else16, !dbg !1163

if.then15:                                        ; preds = %if.end13
  br label %if.end17, !dbg !1163

if.else16:                                        ; preds = %if.end13
  call void @__assert_fail(ptr noundef @.str.13, ptr noundef @.str.1, i32 noundef 490, ptr noundef @__PRETTY_FUNCTION__.once_test) #7, !dbg !1160
  unreachable, !dbg !1160

if.end17:                                         ; preds = %if.then15
  ret void, !dbg !1164
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !1165 {
entry:
  %retval = alloca i32, align 4
  store i32 0, ptr %retval, align 4
  %call = call i32 @__VERIFIER_nondet_int(), !dbg !1168
  switch i32 %call, label %sw.epilog [
    i32 1, label %sw.bb
    i32 2, label %sw.bb1
    i32 3, label %sw.bb2
    i32 4, label %sw.bb3
    i32 5, label %sw.bb4
    i32 6, label %sw.bb5
  ], !dbg !1169

sw.bb:                                            ; preds = %entry
  call void @mutex_test(), !dbg !1170
  br label %sw.epilog, !dbg !1172

sw.bb1:                                           ; preds = %entry
  call void @cond_test(), !dbg !1173
  br label %sw.epilog, !dbg !1174

sw.bb2:                                           ; preds = %entry
  call void @rwlock_test(), !dbg !1175
  br label %sw.epilog, !dbg !1176

sw.bb3:                                           ; preds = %entry
  call void @key_test(), !dbg !1177
  br label %sw.epilog, !dbg !1178

sw.bb4:                                           ; preds = %entry
  call void @detach_test(), !dbg !1179
  br label %sw.epilog, !dbg !1180

sw.bb5:                                           ; preds = %entry
  call void @once_test(), !dbg !1181
  br label %sw.epilog, !dbg !1182

sw.epilog:                                        ; preds = %entry, %sw.bb5, %sw.bb4, %sw.bb3, %sw.bb2, %sw.bb1, %sw.bb
  %0 = load i32, ptr %retval, align 4, !dbg !1183
  ret i32 %0, !dbg !1183
}

declare i32 @__VERIFIER_nondet_int() #4

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind willreturn memory(none) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nounwind }
attributes #7 = { noreturn nounwind }
attributes #8 = { nounwind willreturn memory(none) }

!llvm.dbg.cu = !{!84}
!llvm.module.flags = !{!280, !281, !282, !283, !284, !285, !286}
!llvm.ident = !{!287}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 19, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "pthread.c", directory: "/w", checksumkind: CSK_MD5, checksum: "3e6789ef26e62219839f3ccb22679ec6")
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
!13 = distinct !DIGlobalVariable(scope: null, file: !2, line: 19, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 408, elements: !16)
!15 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!16 = !{!17}
!17 = !DISubrange(count: 51)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !2, line: 28, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 232, elements: !21)
!21 = !{!22}
!22 = !DISubrange(count: 29)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(scope: null, file: !2, line: 48, type: !25, isLocal: true, isDefinition: true)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 400, elements: !26)
!26 = !{!27}
!27 = !DISubrange(count: 50)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(scope: null, file: !2, line: 74, type: !30, isLocal: true, isDefinition: true)
!30 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 304, elements: !31)
!31 = !{!32}
!32 = !DISubrange(count: 38)
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(scope: null, file: !2, line: 80, type: !35, isLocal: true, isDefinition: true)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 280, elements: !36)
!36 = !{!37}
!37 = !DISubrange(count: 35)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !2, line: 86, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 248, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 31)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !2, line: 86, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 312, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 39)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(scope: null, file: !2, line: 93, type: !50, isLocal: true, isDefinition: true)
!50 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 296, elements: !51)
!51 = !{!52}
!52 = !DISubrange(count: 37)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(scope: null, file: !2, line: 107, type: !55, isLocal: true, isDefinition: true)
!55 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 72, elements: !56)
!56 = !{!57}
!57 = !DISubrange(count: 9)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(scope: null, file: !2, line: 107, type: !60, isLocal: true, isDefinition: true)
!60 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 144, elements: !61)
!61 = !{!62}
!62 = !DISubrange(count: 18)
!63 = !DIGlobalVariableExpression(var: !64, expr: !DIExpression())
!64 = distinct !DIGlobalVariable(scope: null, file: !2, line: 116, type: !65, isLocal: true, isDefinition: true)
!65 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 64, elements: !66)
!66 = !{!67}
!67 = !DISubrange(count: 8)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(scope: null, file: !2, line: 143, type: !70, isLocal: true, isDefinition: true)
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 264, elements: !71)
!71 = !{!72}
!72 = !DISubrange(count: 33)
!73 = !DIGlobalVariableExpression(var: !74, expr: !DIExpression())
!74 = distinct !DIGlobalVariable(scope: null, file: !2, line: 155, type: !75, isLocal: true, isDefinition: true)
!75 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 288, elements: !76)
!76 = !{!77}
!77 = !DISubrange(count: 36)
!78 = !DIGlobalVariableExpression(var: !79, expr: !DIExpression())
!79 = distinct !DIGlobalVariable(scope: null, file: !2, line: 161, type: !35, isLocal: true, isDefinition: true)
!80 = !DIGlobalVariableExpression(var: !81, expr: !DIExpression())
!81 = distinct !DIGlobalVariable(scope: null, file: !2, line: 167, type: !30, isLocal: true, isDefinition: true)
!82 = !DIGlobalVariableExpression(var: !83, expr: !DIExpression())
!83 = distinct !DIGlobalVariable(name: "phase", scope: !84, file: !2, line: 189, type: !187, isLocal: false, isDefinition: true)
!84 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Ubuntu clang version 17.0.6 (9ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !85, retainedTypes: !111, globals: !114, splitDebugInlining: false, nameTableKind: None)
!85 = !{!86, !98, !103, !107}
!86 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !87, line: 47, baseType: !88, size: 32, elements: !89)
!87 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!88 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!89 = !{!90, !91, !92, !93, !94, !95, !96, !97}
!90 = !DIEnumerator(name: "PTHREAD_MUTEX_TIMED_NP", value: 0)
!91 = !DIEnumerator(name: "PTHREAD_MUTEX_RECURSIVE_NP", value: 1)
!92 = !DIEnumerator(name: "PTHREAD_MUTEX_ERRORCHECK_NP", value: 2)
!93 = !DIEnumerator(name: "PTHREAD_MUTEX_ADAPTIVE_NP", value: 3)
!94 = !DIEnumerator(name: "PTHREAD_MUTEX_NORMAL", value: 0)
!95 = !DIEnumerator(name: "PTHREAD_MUTEX_RECURSIVE", value: 1)
!96 = !DIEnumerator(name: "PTHREAD_MUTEX_ERRORCHECK", value: 2)
!97 = !DIEnumerator(name: "PTHREAD_MUTEX_DEFAULT", value: 0)
!98 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !87, line: 81, baseType: !88, size: 32, elements: !99)
!99 = !{!100, !101, !102}
!100 = !DIEnumerator(name: "PTHREAD_PRIO_NONE", value: 0)
!101 = !DIEnumerator(name: "PTHREAD_PRIO_INHERIT", value: 1)
!102 = !DIEnumerator(name: "PTHREAD_PRIO_PROTECT", value: 2)
!103 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !87, line: 144, baseType: !88, size: 32, elements: !104)
!104 = !{!105, !106}
!105 = !DIEnumerator(name: "PTHREAD_PROCESS_PRIVATE", value: 0)
!106 = !DIEnumerator(name: "PTHREAD_PROCESS_SHARED", value: 1)
!107 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !87, line: 37, baseType: !88, size: 32, elements: !108)
!108 = !{!109, !110}
!109 = !DIEnumerator(name: "PTHREAD_CREATE_JOINABLE", value: 0)
!110 = !DIEnumerator(name: "PTHREAD_CREATE_DETACHED", value: 1)
!111 = !{!112, !113}
!112 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!114 = !{!0, !7, !12, !18, !23, !28, !33, !38, !43, !48, !53, !58, !63, !68, !73, !78, !80, !82, !115, !118, !123, !128, !133, !135, !140, !142, !144, !146, !151, !156, !161, !166, !169, !171, !173, !176, !181, !183, !188, !190, !195, !198, !201, !203, !205, !234, !269, !273, !276, !278}
!115 = !DIGlobalVariableExpression(var: !116, expr: !DIExpression())
!116 = distinct !DIGlobalVariable(scope: null, file: !2, line: 241, type: !117, isLocal: true, isDefinition: true)
!117 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 144, elements: !61)
!118 = !DIGlobalVariableExpression(var: !119, expr: !DIExpression())
!119 = distinct !DIGlobalVariable(scope: null, file: !2, line: 241, type: !120, isLocal: true, isDefinition: true)
!120 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 136, elements: !121)
!121 = !{!122}
!122 = !DISubrange(count: 17)
!123 = !DIGlobalVariableExpression(var: !124, expr: !DIExpression())
!124 = distinct !DIGlobalVariable(scope: null, file: !2, line: 258, type: !125, isLocal: true, isDefinition: true)
!125 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 336, elements: !126)
!126 = !{!127}
!127 = !DISubrange(count: 42)
!128 = !DIGlobalVariableExpression(var: !129, expr: !DIExpression())
!129 = distinct !DIGlobalVariable(scope: null, file: !2, line: 274, type: !130, isLocal: true, isDefinition: true)
!130 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 320, elements: !131)
!131 = !{!132}
!132 = !DISubrange(count: 40)
!133 = !DIGlobalVariableExpression(var: !134, expr: !DIExpression())
!134 = distinct !DIGlobalVariable(scope: null, file: !2, line: 280, type: !45, isLocal: true, isDefinition: true)
!135 = !DIGlobalVariableExpression(var: !136, expr: !DIExpression())
!136 = distinct !DIGlobalVariable(scope: null, file: !2, line: 286, type: !137, isLocal: true, isDefinition: true)
!137 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 344, elements: !138)
!138 = !{!139}
!139 = !DISubrange(count: 43)
!140 = !DIGlobalVariableExpression(var: !141, expr: !DIExpression())
!141 = distinct !DIGlobalVariable(scope: null, file: !2, line: 293, type: !45, isLocal: true, isDefinition: true)
!142 = !DIGlobalVariableExpression(var: !143, expr: !DIExpression())
!143 = distinct !DIGlobalVariable(scope: null, file: !2, line: 299, type: !137, isLocal: true, isDefinition: true)
!144 = !DIGlobalVariableExpression(var: !145, expr: !DIExpression())
!145 = distinct !DIGlobalVariable(scope: null, file: !2, line: 306, type: !45, isLocal: true, isDefinition: true)
!146 = !DIGlobalVariableExpression(var: !147, expr: !DIExpression())
!147 = distinct !DIGlobalVariable(scope: null, file: !2, line: 318, type: !148, isLocal: true, isDefinition: true)
!148 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 152, elements: !149)
!149 = !{!150}
!150 = !DISubrange(count: 19)
!151 = !DIGlobalVariableExpression(var: !152, expr: !DIExpression())
!152 = distinct !DIGlobalVariable(scope: null, file: !2, line: 368, type: !153, isLocal: true, isDefinition: true)
!153 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 200, elements: !154)
!154 = !{!155}
!155 = !DISubrange(count: 25)
!156 = !DIGlobalVariableExpression(var: !157, expr: !DIExpression())
!157 = distinct !DIGlobalVariable(scope: null, file: !2, line: 371, type: !158, isLocal: true, isDefinition: true)
!158 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 224, elements: !159)
!159 = !{!160}
!160 = !DISubrange(count: 28)
!161 = !DIGlobalVariableExpression(var: !162, expr: !DIExpression())
!162 = distinct !DIGlobalVariable(scope: null, file: !2, line: 387, type: !163, isLocal: true, isDefinition: true)
!163 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 128, elements: !164)
!164 = !{!165}
!165 = !DISubrange(count: 16)
!166 = !DIGlobalVariableExpression(var: !167, expr: !DIExpression())
!167 = distinct !DIGlobalVariable(scope: null, file: !2, line: 401, type: !168, isLocal: true, isDefinition: true)
!168 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 296, elements: !51)
!169 = !DIGlobalVariableExpression(var: !170, expr: !DIExpression())
!170 = distinct !DIGlobalVariable(scope: null, file: !2, line: 416, type: !70, isLocal: true, isDefinition: true)
!171 = !DIGlobalVariableExpression(var: !172, expr: !DIExpression())
!172 = distinct !DIGlobalVariable(scope: null, file: !2, line: 419, type: !3, isLocal: true, isDefinition: true)
!173 = !DIGlobalVariableExpression(var: !174, expr: !DIExpression())
!174 = distinct !DIGlobalVariable(scope: null, file: !2, line: 430, type: !175, isLocal: true, isDefinition: true)
!175 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 248, elements: !41)
!176 = !DIGlobalVariableExpression(var: !177, expr: !DIExpression())
!177 = distinct !DIGlobalVariable(scope: null, file: !2, line: 432, type: !178, isLocal: true, isDefinition: true)
!178 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 432, elements: !179)
!179 = !{!180}
!180 = !DISubrange(count: 54)
!181 = !DIGlobalVariableExpression(var: !182, expr: !DIExpression())
!182 = distinct !DIGlobalVariable(scope: null, file: !2, line: 436, type: !178, isLocal: true, isDefinition: true)
!183 = !DIGlobalVariableExpression(var: !184, expr: !DIExpression())
!184 = distinct !DIGlobalVariable(name: "once0", scope: !84, file: !2, line: 454, type: !185, isLocal: false, isDefinition: true)
!185 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_once_t", file: !186, line: 53, baseType: !187)
!186 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!187 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!188 = !DIGlobalVariableExpression(var: !189, expr: !DIExpression())
!189 = distinct !DIGlobalVariable(name: "once1", scope: !84, file: !2, line: 455, type: !185, isLocal: false, isDefinition: true)
!190 = !DIGlobalVariableExpression(var: !191, expr: !DIExpression())
!191 = distinct !DIGlobalVariable(scope: null, file: !2, line: 473, type: !192, isLocal: true, isDefinition: true)
!192 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 208, elements: !193)
!193 = !{!194}
!194 = !DISubrange(count: 26)
!195 = !DIGlobalVariableExpression(var: !196, expr: !DIExpression())
!196 = distinct !DIGlobalVariable(scope: null, file: !2, line: 474, type: !197, isLocal: true, isDefinition: true)
!197 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 136, elements: !121)
!198 = !DIGlobalVariableExpression(var: !199, expr: !DIExpression())
!199 = distinct !DIGlobalVariable(scope: null, file: !2, line: 484, type: !200, isLocal: true, isDefinition: true)
!200 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 128, elements: !164)
!201 = !DIGlobalVariableExpression(var: !202, expr: !DIExpression())
!202 = distinct !DIGlobalVariable(scope: null, file: !2, line: 484, type: !120, isLocal: true, isDefinition: true)
!203 = !DIGlobalVariableExpression(var: !204, expr: !DIExpression())
!204 = distinct !DIGlobalVariable(scope: null, file: !2, line: 490, type: !200, isLocal: true, isDefinition: true)
!205 = !DIGlobalVariableExpression(var: !206, expr: !DIExpression())
!206 = distinct !DIGlobalVariable(name: "cond_mutex", scope: !84, file: !2, line: 187, type: !207, isLocal: false, isDefinition: true)
!207 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !186, line: 72, baseType: !208)
!208 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !186, line: 67, size: 320, elements: !209)
!209 = !{!210, !230, !232}
!210 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !208, file: !186, line: 69, baseType: !211, size: 320)
!211 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !212, line: 22, size: 320, elements: !213)
!212 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "6b075eca9ab0e2d761b2afc4ecfab776")
!213 = !{!214, !215, !216, !217, !218, !219, !221, !222}
!214 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !211, file: !212, line: 24, baseType: !187, size: 32)
!215 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !211, file: !212, line: 25, baseType: !88, size: 32, offset: 32)
!216 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !211, file: !212, line: 26, baseType: !187, size: 32, offset: 64)
!217 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !211, file: !212, line: 28, baseType: !88, size: 32, offset: 96)
!218 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !211, file: !212, line: 32, baseType: !187, size: 32, offset: 128)
!219 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !211, file: !212, line: 34, baseType: !220, size: 16, offset: 160)
!220 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!221 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !211, file: !212, line: 35, baseType: !220, size: 16, offset: 176)
!222 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !211, file: !212, line: 36, baseType: !223, size: 128, offset: 192)
!223 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !224, line: 55, baseType: !225)
!224 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "b9a7199822bce372686baacd32a9f4f3")
!225 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !224, line: 51, size: 128, elements: !226)
!226 = !{!227, !229}
!227 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !225, file: !224, line: 53, baseType: !228, size: 64)
!228 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !225, size: 64)
!229 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !225, file: !224, line: 54, baseType: !228, size: 64, offset: 64)
!230 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !208, file: !186, line: 70, baseType: !231, size: 320)
!231 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 320, elements: !131)
!232 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !208, file: !186, line: 71, baseType: !233, size: 64)
!233 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!234 = !DIGlobalVariableExpression(var: !235, expr: !DIExpression())
!235 = distinct !DIGlobalVariable(name: "cond", scope: !84, file: !2, line: 188, type: !236, isLocal: false, isDefinition: true)
!236 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_cond_t", file: !186, line: 80, baseType: !237)
!237 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !186, line: 75, size: 384, elements: !238)
!238 = !{!239, !263, !267}
!239 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !237, file: !186, line: 77, baseType: !240, size: 384)
!240 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_cond_s", file: !224, line: 94, size: 384, elements: !241)
!241 = !{!242, !254, !255, !259, !260, !261, !262}
!242 = !DIDerivedType(tag: DW_TAG_member, name: "__wseq", scope: !240, file: !224, line: 96, baseType: !243, size: 64)
!243 = !DIDerivedType(tag: DW_TAG_typedef, name: "__atomic_wide_counter", file: !244, line: 33, baseType: !245)
!244 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/atomic_wide_counter.h", directory: "", checksumkind: CSK_MD5, checksum: "d1ec99b0f6e36c0a42ac284d459cbd38")
!245 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !244, line: 25, size: 64, elements: !246)
!246 = !{!247, !249}
!247 = !DIDerivedType(tag: DW_TAG_member, name: "__value64", scope: !245, file: !244, line: 27, baseType: !248, size: 64)
!248 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!249 = !DIDerivedType(tag: DW_TAG_member, name: "__value32", scope: !245, file: !244, line: 32, baseType: !250, size: 64)
!250 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !245, file: !244, line: 28, size: 64, elements: !251)
!251 = !{!252, !253}
!252 = !DIDerivedType(tag: DW_TAG_member, name: "__low", scope: !250, file: !244, line: 30, baseType: !88, size: 32)
!253 = !DIDerivedType(tag: DW_TAG_member, name: "__high", scope: !250, file: !244, line: 31, baseType: !88, size: 32, offset: 32)
!254 = !DIDerivedType(tag: DW_TAG_member, name: "__g1_start", scope: !240, file: !224, line: 97, baseType: !243, size: 64, offset: 64)
!255 = !DIDerivedType(tag: DW_TAG_member, name: "__g_refs", scope: !240, file: !224, line: 98, baseType: !256, size: 64, offset: 128)
!256 = !DICompositeType(tag: DW_TAG_array_type, baseType: !88, size: 64, elements: !257)
!257 = !{!258}
!258 = !DISubrange(count: 2)
!259 = !DIDerivedType(tag: DW_TAG_member, name: "__g_size", scope: !240, file: !224, line: 99, baseType: !256, size: 64, offset: 192)
!260 = !DIDerivedType(tag: DW_TAG_member, name: "__g1_orig_size", scope: !240, file: !224, line: 100, baseType: !88, size: 32, offset: 256)
!261 = !DIDerivedType(tag: DW_TAG_member, name: "__wrefs", scope: !240, file: !224, line: 101, baseType: !88, size: 32, offset: 288)
!262 = !DIDerivedType(tag: DW_TAG_member, name: "__g_signals", scope: !240, file: !224, line: 102, baseType: !256, size: 64, offset: 320)
!263 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !237, file: !186, line: 78, baseType: !264, size: 384)
!264 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 384, elements: !265)
!265 = !{!266}
!266 = !DISubrange(count: 48)
!267 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !237, file: !186, line: 79, baseType: !268, size: 64)
!268 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!269 = !DIGlobalVariableExpression(var: !270, expr: !DIExpression())
!270 = distinct !DIGlobalVariable(name: "latest_thread", scope: !84, file: !2, line: 355, type: !271, isLocal: false, isDefinition: true)
!271 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !186, line: 27, baseType: !272)
!272 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!273 = !DIGlobalVariableExpression(var: !274, expr: !DIExpression())
!274 = distinct !DIGlobalVariable(name: "local_data", scope: !84, file: !2, line: 356, type: !275, isLocal: false, isDefinition: true)
!275 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_key_t", file: !186, line: 49, baseType: !88)
!276 = !DIGlobalVariableExpression(var: !277, expr: !DIExpression())
!277 = distinct !DIGlobalVariable(name: "once_calls", scope: !84, file: !2, line: 456, type: !187, isLocal: false, isDefinition: true)
!278 = !DIGlobalVariableExpression(var: !279, expr: !DIExpression())
!279 = distinct !DIGlobalVariable(name: "once_value", scope: !84, file: !2, line: 457, type: !187, isLocal: false, isDefinition: true)
!280 = !{i32 7, !"Dwarf Version", i32 5}
!281 = !{i32 2, !"Debug Info Version", i32 3}
!282 = !{i32 1, !"wchar_size", i32 4}
!283 = !{i32 8, !"PIC Level", i32 2}
!284 = !{i32 7, !"PIE Level", i32 2}
!285 = !{i32 7, !"uwtable", i32 2}
!286 = !{i32 7, !"frame-pointer", i32 2}
!287 = !{!"Ubuntu clang version 17.0.6 (9ubuntu1)"}
!288 = distinct !DISubprogram(name: "thread_create", scope: !2, file: !2, line: 13, type: !289, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!289 = !DISubroutineType(types: !290)
!290 = !{!271, !291, !113}
!291 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !292, size: 64)
!292 = !DISubroutineType(types: !293)
!293 = !{!113, !113}
!294 = !{}
!295 = !DILocalVariable(name: "runner", arg: 1, scope: !288, file: !2, line: 13, type: !291)
!296 = !DILocation(line: 13, column: 32, scope: !288)
!297 = !DILocalVariable(name: "data", arg: 2, scope: !288, file: !2, line: 13, type: !113)
!298 = !DILocation(line: 13, column: 54, scope: !288)
!299 = !DILocalVariable(name: "id", scope: !288, file: !2, line: 15, type: !271)
!300 = !DILocation(line: 15, column: 15, scope: !288)
!301 = !DILocalVariable(name: "attr", scope: !288, file: !2, line: 16, type: !302)
!302 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !186, line: 62, baseType: !303)
!303 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !186, line: 56, size: 448, elements: !304)
!304 = !{!305, !309}
!305 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !303, file: !186, line: 58, baseType: !306, size: 448)
!306 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 448, elements: !307)
!307 = !{!308}
!308 = !DISubrange(count: 56)
!309 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !303, file: !186, line: 59, baseType: !233, size: 64)
!310 = !DILocation(line: 16, column: 20, scope: !288)
!311 = !DILocation(line: 17, column: 5, scope: !288)
!312 = !DILocalVariable(name: "status", scope: !288, file: !2, line: 18, type: !187)
!313 = !DILocation(line: 18, column: 9, scope: !288)
!314 = !DILocation(line: 18, column: 45, scope: !288)
!315 = !DILocation(line: 18, column: 53, scope: !288)
!316 = !DILocation(line: 18, column: 18, scope: !288)
!317 = !DILocation(line: 19, column: 5, scope: !318)
!318 = distinct !DILexicalBlock(scope: !319, file: !2, line: 19, column: 5)
!319 = distinct !DILexicalBlock(scope: !288, file: !2, line: 19, column: 5)
!320 = !DILocation(line: 19, column: 5, scope: !319)
!321 = !DILocation(line: 20, column: 5, scope: !288)
!322 = !DILocation(line: 21, column: 12, scope: !288)
!323 = !DILocation(line: 21, column: 5, scope: !288)
!324 = distinct !DISubprogram(name: "thread_join", scope: !2, file: !2, line: 24, type: !325, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!325 = !DISubroutineType(types: !326)
!326 = !{!113, !271}
!327 = !DILocalVariable(name: "id", arg: 1, scope: !324, file: !2, line: 24, type: !271)
!328 = !DILocation(line: 24, column: 29, scope: !324)
!329 = !DILocalVariable(name: "result", scope: !324, file: !2, line: 26, type: !113)
!330 = !DILocation(line: 26, column: 11, scope: !324)
!331 = !DILocalVariable(name: "status", scope: !324, file: !2, line: 27, type: !187)
!332 = !DILocation(line: 27, column: 9, scope: !324)
!333 = !DILocation(line: 27, column: 31, scope: !324)
!334 = !DILocation(line: 27, column: 18, scope: !324)
!335 = !DILocation(line: 28, column: 5, scope: !336)
!336 = distinct !DILexicalBlock(scope: !337, file: !2, line: 28, column: 5)
!337 = distinct !DILexicalBlock(scope: !324, file: !2, line: 28, column: 5)
!338 = !DILocation(line: 28, column: 5, scope: !337)
!339 = !DILocation(line: 29, column: 12, scope: !324)
!340 = !DILocation(line: 29, column: 5, scope: !324)
!341 = distinct !DISubprogram(name: "mutex_init", scope: !2, file: !2, line: 42, type: !342, scopeLine: 43, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!342 = !DISubroutineType(types: !343)
!343 = !{null, !344, !187, !187, !187}
!344 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !207, size: 64)
!345 = !DILocalVariable(name: "lock", arg: 1, scope: !341, file: !2, line: 42, type: !344)
!346 = !DILocation(line: 42, column: 34, scope: !341)
!347 = !DILocalVariable(name: "type", arg: 2, scope: !341, file: !2, line: 42, type: !187)
!348 = !DILocation(line: 42, column: 44, scope: !341)
!349 = !DILocalVariable(name: "protocol", arg: 3, scope: !341, file: !2, line: 42, type: !187)
!350 = !DILocation(line: 42, column: 54, scope: !341)
!351 = !DILocalVariable(name: "prioceiling", arg: 4, scope: !341, file: !2, line: 42, type: !187)
!352 = !DILocation(line: 42, column: 68, scope: !341)
!353 = !DILocalVariable(name: "status", scope: !341, file: !2, line: 44, type: !187)
!354 = !DILocation(line: 44, column: 9, scope: !341)
!355 = !DILocalVariable(name: "value", scope: !341, file: !2, line: 45, type: !187)
!356 = !DILocation(line: 45, column: 9, scope: !341)
!357 = !DILocalVariable(name: "attributes", scope: !341, file: !2, line: 46, type: !358)
!358 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !186, line: 36, baseType: !359)
!359 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !186, line: 32, size: 32, elements: !360)
!360 = !{!361, !365}
!361 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !359, file: !186, line: 34, baseType: !362, size: 32)
!362 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 32, elements: !363)
!363 = !{!364}
!364 = !DISubrange(count: 4)
!365 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !359, file: !186, line: 35, baseType: !187, size: 32)
!366 = !DILocation(line: 46, column: 25, scope: !341)
!367 = !DILocation(line: 47, column: 14, scope: !341)
!368 = !DILocation(line: 47, column: 12, scope: !341)
!369 = !DILocation(line: 48, column: 5, scope: !370)
!370 = distinct !DILexicalBlock(scope: !371, file: !2, line: 48, column: 5)
!371 = distinct !DILexicalBlock(scope: !341, file: !2, line: 48, column: 5)
!372 = !DILocation(line: 48, column: 5, scope: !371)
!373 = !DILocation(line: 50, column: 53, scope: !341)
!374 = !DILocation(line: 50, column: 14, scope: !341)
!375 = !DILocation(line: 50, column: 12, scope: !341)
!376 = !DILocation(line: 51, column: 5, scope: !377)
!377 = distinct !DILexicalBlock(scope: !378, file: !2, line: 51, column: 5)
!378 = distinct !DILexicalBlock(scope: !341, file: !2, line: 51, column: 5)
!379 = !DILocation(line: 51, column: 5, scope: !378)
!380 = !DILocation(line: 52, column: 14, scope: !341)
!381 = !DILocation(line: 52, column: 12, scope: !341)
!382 = !DILocation(line: 53, column: 5, scope: !383)
!383 = distinct !DILexicalBlock(scope: !384, file: !2, line: 53, column: 5)
!384 = distinct !DILexicalBlock(scope: !341, file: !2, line: 53, column: 5)
!385 = !DILocation(line: 53, column: 5, scope: !384)
!386 = !DILocation(line: 55, column: 57, scope: !341)
!387 = !DILocation(line: 55, column: 14, scope: !341)
!388 = !DILocation(line: 55, column: 12, scope: !341)
!389 = !DILocation(line: 56, column: 5, scope: !390)
!390 = distinct !DILexicalBlock(scope: !391, file: !2, line: 56, column: 5)
!391 = distinct !DILexicalBlock(scope: !341, file: !2, line: 56, column: 5)
!392 = !DILocation(line: 56, column: 5, scope: !391)
!393 = !DILocation(line: 57, column: 14, scope: !341)
!394 = !DILocation(line: 57, column: 12, scope: !341)
!395 = !DILocation(line: 58, column: 5, scope: !396)
!396 = distinct !DILexicalBlock(scope: !397, file: !2, line: 58, column: 5)
!397 = distinct !DILexicalBlock(scope: !341, file: !2, line: 58, column: 5)
!398 = !DILocation(line: 58, column: 5, scope: !397)
!399 = !DILocation(line: 60, column: 60, scope: !341)
!400 = !DILocation(line: 60, column: 14, scope: !341)
!401 = !DILocation(line: 60, column: 12, scope: !341)
!402 = !DILocation(line: 61, column: 5, scope: !403)
!403 = distinct !DILexicalBlock(scope: !404, file: !2, line: 61, column: 5)
!404 = distinct !DILexicalBlock(scope: !341, file: !2, line: 61, column: 5)
!405 = !DILocation(line: 61, column: 5, scope: !404)
!406 = !DILocation(line: 62, column: 14, scope: !341)
!407 = !DILocation(line: 62, column: 12, scope: !341)
!408 = !DILocation(line: 63, column: 5, scope: !409)
!409 = distinct !DILexicalBlock(scope: !410, file: !2, line: 63, column: 5)
!410 = distinct !DILexicalBlock(scope: !341, file: !2, line: 63, column: 5)
!411 = !DILocation(line: 63, column: 5, scope: !410)
!412 = !DILocation(line: 65, column: 33, scope: !341)
!413 = !DILocation(line: 65, column: 14, scope: !341)
!414 = !DILocation(line: 65, column: 12, scope: !341)
!415 = !DILocation(line: 66, column: 5, scope: !416)
!416 = distinct !DILexicalBlock(scope: !417, file: !2, line: 66, column: 5)
!417 = distinct !DILexicalBlock(scope: !341, file: !2, line: 66, column: 5)
!418 = !DILocation(line: 66, column: 5, scope: !417)
!419 = !DILocation(line: 67, column: 14, scope: !341)
!420 = !DILocation(line: 67, column: 12, scope: !341)
!421 = !DILocation(line: 68, column: 5, scope: !422)
!422 = distinct !DILexicalBlock(scope: !423, file: !2, line: 68, column: 5)
!423 = distinct !DILexicalBlock(scope: !341, file: !2, line: 68, column: 5)
!424 = !DILocation(line: 68, column: 5, scope: !423)
!425 = !DILocation(line: 69, column: 1, scope: !341)
!426 = distinct !DISubprogram(name: "mutex_destroy", scope: !2, file: !2, line: 71, type: !427, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!427 = !DISubroutineType(types: !428)
!428 = !{null, !344}
!429 = !DILocalVariable(name: "lock", arg: 1, scope: !426, file: !2, line: 71, type: !344)
!430 = !DILocation(line: 71, column: 37, scope: !426)
!431 = !DILocalVariable(name: "status", scope: !426, file: !2, line: 73, type: !187)
!432 = !DILocation(line: 73, column: 9, scope: !426)
!433 = !DILocation(line: 73, column: 40, scope: !426)
!434 = !DILocation(line: 73, column: 18, scope: !426)
!435 = !DILocation(line: 74, column: 5, scope: !436)
!436 = distinct !DILexicalBlock(scope: !437, file: !2, line: 74, column: 5)
!437 = distinct !DILexicalBlock(scope: !426, file: !2, line: 74, column: 5)
!438 = !DILocation(line: 74, column: 5, scope: !437)
!439 = !DILocation(line: 75, column: 1, scope: !426)
!440 = distinct !DISubprogram(name: "mutex_lock", scope: !2, file: !2, line: 77, type: !427, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!441 = !DILocalVariable(name: "lock", arg: 1, scope: !440, file: !2, line: 77, type: !344)
!442 = !DILocation(line: 77, column: 34, scope: !440)
!443 = !DILocalVariable(name: "status", scope: !440, file: !2, line: 79, type: !187)
!444 = !DILocation(line: 79, column: 9, scope: !440)
!445 = !DILocation(line: 79, column: 37, scope: !440)
!446 = !DILocation(line: 79, column: 18, scope: !440)
!447 = !DILocation(line: 80, column: 5, scope: !448)
!448 = distinct !DILexicalBlock(scope: !449, file: !2, line: 80, column: 5)
!449 = distinct !DILexicalBlock(scope: !440, file: !2, line: 80, column: 5)
!450 = !DILocation(line: 80, column: 5, scope: !449)
!451 = !DILocation(line: 81, column: 1, scope: !440)
!452 = distinct !DISubprogram(name: "mutex_trylock", scope: !2, file: !2, line: 83, type: !453, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!453 = !DISubroutineType(types: !454)
!454 = !{!455, !344}
!455 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!456 = !DILocalVariable(name: "lock", arg: 1, scope: !452, file: !2, line: 83, type: !344)
!457 = !DILocation(line: 83, column: 37, scope: !452)
!458 = !DILocalVariable(name: "status", scope: !452, file: !2, line: 85, type: !187)
!459 = !DILocation(line: 85, column: 9, scope: !452)
!460 = !DILocation(line: 85, column: 40, scope: !452)
!461 = !DILocation(line: 85, column: 18, scope: !452)
!462 = !DILocation(line: 86, column: 5, scope: !463)
!463 = distinct !DILexicalBlock(scope: !464, file: !2, line: 86, column: 5)
!464 = distinct !DILexicalBlock(scope: !452, file: !2, line: 86, column: 5)
!465 = !DILocation(line: 86, column: 5, scope: !464)
!466 = !DILocation(line: 87, column: 12, scope: !452)
!467 = !DILocation(line: 87, column: 19, scope: !452)
!468 = !DILocation(line: 87, column: 5, scope: !452)
!469 = distinct !DISubprogram(name: "mutex_unlock", scope: !2, file: !2, line: 90, type: !427, scopeLine: 91, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!470 = !DILocalVariable(name: "lock", arg: 1, scope: !469, file: !2, line: 90, type: !344)
!471 = !DILocation(line: 90, column: 36, scope: !469)
!472 = !DILocalVariable(name: "status", scope: !469, file: !2, line: 92, type: !187)
!473 = !DILocation(line: 92, column: 9, scope: !469)
!474 = !DILocation(line: 92, column: 39, scope: !469)
!475 = !DILocation(line: 92, column: 18, scope: !469)
!476 = !DILocation(line: 93, column: 5, scope: !477)
!477 = distinct !DILexicalBlock(scope: !478, file: !2, line: 93, column: 5)
!478 = distinct !DILexicalBlock(scope: !469, file: !2, line: 93, column: 5)
!479 = !DILocation(line: 93, column: 5, scope: !478)
!480 = !DILocation(line: 94, column: 1, scope: !469)
!481 = distinct !DISubprogram(name: "mutex_test", scope: !2, file: !2, line: 96, type: !482, scopeLine: 97, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!482 = !DISubroutineType(types: !483)
!483 = !{null}
!484 = !DILocalVariable(name: "mutex0", scope: !481, file: !2, line: 98, type: !207)
!485 = !DILocation(line: 98, column: 21, scope: !481)
!486 = !DILocalVariable(name: "mutex1", scope: !481, file: !2, line: 99, type: !207)
!487 = !DILocation(line: 99, column: 21, scope: !481)
!488 = !DILocation(line: 101, column: 5, scope: !481)
!489 = !DILocation(line: 102, column: 5, scope: !481)
!490 = !DILocation(line: 105, column: 9, scope: !491)
!491 = distinct !DILexicalBlock(scope: !481, file: !2, line: 104, column: 5)
!492 = !DILocalVariable(name: "success", scope: !491, file: !2, line: 106, type: !455)
!493 = !DILocation(line: 106, column: 14, scope: !491)
!494 = !DILocation(line: 106, column: 24, scope: !491)
!495 = !DILocation(line: 107, column: 9, scope: !496)
!496 = distinct !DILexicalBlock(scope: !497, file: !2, line: 107, column: 9)
!497 = distinct !DILexicalBlock(scope: !491, file: !2, line: 107, column: 9)
!498 = !DILocation(line: 107, column: 9, scope: !497)
!499 = !DILocation(line: 108, column: 9, scope: !491)
!500 = !DILocation(line: 112, column: 9, scope: !501)
!501 = distinct !DILexicalBlock(scope: !481, file: !2, line: 111, column: 5)
!502 = !DILocalVariable(name: "success", scope: !503, file: !2, line: 115, type: !455)
!503 = distinct !DILexicalBlock(scope: !501, file: !2, line: 114, column: 9)
!504 = !DILocation(line: 115, column: 18, scope: !503)
!505 = !DILocation(line: 115, column: 28, scope: !503)
!506 = !DILocation(line: 116, column: 13, scope: !507)
!507 = distinct !DILexicalBlock(scope: !508, file: !2, line: 116, column: 13)
!508 = distinct !DILexicalBlock(scope: !503, file: !2, line: 116, column: 13)
!509 = !DILocation(line: 116, column: 13, scope: !508)
!510 = !DILocation(line: 117, column: 13, scope: !503)
!511 = !DILocalVariable(name: "success", scope: !512, file: !2, line: 121, type: !455)
!512 = distinct !DILexicalBlock(scope: !501, file: !2, line: 120, column: 9)
!513 = !DILocation(line: 121, column: 18, scope: !512)
!514 = !DILocation(line: 121, column: 28, scope: !512)
!515 = !DILocation(line: 122, column: 13, scope: !516)
!516 = distinct !DILexicalBlock(scope: !517, file: !2, line: 122, column: 13)
!517 = distinct !DILexicalBlock(scope: !512, file: !2, line: 122, column: 13)
!518 = !DILocation(line: 122, column: 13, scope: !517)
!519 = !DILocation(line: 123, column: 13, scope: !512)
!520 = !DILocation(line: 128, column: 9, scope: !501)
!521 = !DILocation(line: 131, column: 5, scope: !481)
!522 = !DILocation(line: 132, column: 5, scope: !481)
!523 = !DILocation(line: 133, column: 1, scope: !481)
!524 = distinct !DISubprogram(name: "cond_init", scope: !2, file: !2, line: 137, type: !525, scopeLine: 138, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!525 = !DISubroutineType(types: !526)
!526 = !{null, !527}
!527 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !236, size: 64)
!528 = !DILocalVariable(name: "cond", arg: 1, scope: !524, file: !2, line: 137, type: !527)
!529 = !DILocation(line: 137, column: 32, scope: !524)
!530 = !DILocalVariable(name: "status", scope: !524, file: !2, line: 139, type: !187)
!531 = !DILocation(line: 139, column: 9, scope: !524)
!532 = !DILocalVariable(name: "attr", scope: !524, file: !2, line: 140, type: !533)
!533 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_condattr_t", file: !186, line: 45, baseType: !534)
!534 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !186, line: 41, size: 32, elements: !535)
!535 = !{!536, !537}
!536 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !534, file: !186, line: 43, baseType: !362, size: 32)
!537 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !534, file: !186, line: 44, baseType: !187, size: 32)
!538 = !DILocation(line: 140, column: 24, scope: !524)
!539 = !DILocation(line: 142, column: 14, scope: !524)
!540 = !DILocation(line: 142, column: 12, scope: !524)
!541 = !DILocation(line: 143, column: 5, scope: !542)
!542 = distinct !DILexicalBlock(scope: !543, file: !2, line: 143, column: 5)
!543 = distinct !DILexicalBlock(scope: !524, file: !2, line: 143, column: 5)
!544 = !DILocation(line: 143, column: 5, scope: !543)
!545 = !DILocation(line: 145, column: 32, scope: !524)
!546 = !DILocation(line: 145, column: 14, scope: !524)
!547 = !DILocation(line: 145, column: 12, scope: !524)
!548 = !DILocation(line: 146, column: 5, scope: !549)
!549 = distinct !DILexicalBlock(scope: !550, file: !2, line: 146, column: 5)
!550 = distinct !DILexicalBlock(scope: !524, file: !2, line: 146, column: 5)
!551 = !DILocation(line: 146, column: 5, scope: !550)
!552 = !DILocation(line: 148, column: 14, scope: !524)
!553 = !DILocation(line: 148, column: 12, scope: !524)
!554 = !DILocation(line: 149, column: 5, scope: !555)
!555 = distinct !DILexicalBlock(scope: !556, file: !2, line: 149, column: 5)
!556 = distinct !DILexicalBlock(scope: !524, file: !2, line: 149, column: 5)
!557 = !DILocation(line: 149, column: 5, scope: !556)
!558 = !DILocation(line: 150, column: 1, scope: !524)
!559 = distinct !DISubprogram(name: "cond_destroy", scope: !2, file: !2, line: 152, type: !525, scopeLine: 153, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!560 = !DILocalVariable(name: "cond", arg: 1, scope: !559, file: !2, line: 152, type: !527)
!561 = !DILocation(line: 152, column: 35, scope: !559)
!562 = !DILocalVariable(name: "status", scope: !559, file: !2, line: 154, type: !187)
!563 = !DILocation(line: 154, column: 9, scope: !559)
!564 = !DILocation(line: 154, column: 39, scope: !559)
!565 = !DILocation(line: 154, column: 18, scope: !559)
!566 = !DILocation(line: 155, column: 5, scope: !567)
!567 = distinct !DILexicalBlock(scope: !568, file: !2, line: 155, column: 5)
!568 = distinct !DILexicalBlock(scope: !559, file: !2, line: 155, column: 5)
!569 = !DILocation(line: 155, column: 5, scope: !568)
!570 = !DILocation(line: 156, column: 1, scope: !559)
!571 = distinct !DISubprogram(name: "cond_signal", scope: !2, file: !2, line: 158, type: !525, scopeLine: 159, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!572 = !DILocalVariable(name: "cond", arg: 1, scope: !571, file: !2, line: 158, type: !527)
!573 = !DILocation(line: 158, column: 34, scope: !571)
!574 = !DILocalVariable(name: "status", scope: !571, file: !2, line: 160, type: !187)
!575 = !DILocation(line: 160, column: 9, scope: !571)
!576 = !DILocation(line: 160, column: 38, scope: !571)
!577 = !DILocation(line: 160, column: 18, scope: !571)
!578 = !DILocation(line: 161, column: 5, scope: !579)
!579 = distinct !DILexicalBlock(scope: !580, file: !2, line: 161, column: 5)
!580 = distinct !DILexicalBlock(scope: !571, file: !2, line: 161, column: 5)
!581 = !DILocation(line: 161, column: 5, scope: !580)
!582 = !DILocation(line: 162, column: 1, scope: !571)
!583 = distinct !DISubprogram(name: "cond_broadcast", scope: !2, file: !2, line: 164, type: !525, scopeLine: 165, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!584 = !DILocalVariable(name: "cond", arg: 1, scope: !583, file: !2, line: 164, type: !527)
!585 = !DILocation(line: 164, column: 37, scope: !583)
!586 = !DILocalVariable(name: "status", scope: !583, file: !2, line: 166, type: !187)
!587 = !DILocation(line: 166, column: 9, scope: !583)
!588 = !DILocation(line: 166, column: 41, scope: !583)
!589 = !DILocation(line: 166, column: 18, scope: !583)
!590 = !DILocation(line: 167, column: 5, scope: !591)
!591 = distinct !DILexicalBlock(scope: !592, file: !2, line: 167, column: 5)
!592 = distinct !DILexicalBlock(scope: !583, file: !2, line: 167, column: 5)
!593 = !DILocation(line: 167, column: 5, scope: !592)
!594 = !DILocation(line: 168, column: 1, scope: !583)
!595 = distinct !DISubprogram(name: "cond_wait", scope: !2, file: !2, line: 170, type: !596, scopeLine: 171, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!596 = !DISubroutineType(types: !597)
!597 = !{null, !527, !344}
!598 = !DILocalVariable(name: "cond", arg: 1, scope: !595, file: !2, line: 170, type: !527)
!599 = !DILocation(line: 170, column: 32, scope: !595)
!600 = !DILocalVariable(name: "lock", arg: 2, scope: !595, file: !2, line: 170, type: !344)
!601 = !DILocation(line: 170, column: 55, scope: !595)
!602 = !DILocalVariable(name: "status", scope: !595, file: !2, line: 172, type: !187)
!603 = !DILocation(line: 172, column: 9, scope: !595)
!604 = !DILocation(line: 172, column: 36, scope: !595)
!605 = !DILocation(line: 172, column: 42, scope: !595)
!606 = !DILocation(line: 172, column: 18, scope: !595)
!607 = !DILocation(line: 174, column: 1, scope: !595)
!608 = distinct !DISubprogram(name: "cond_timedwait", scope: !2, file: !2, line: 176, type: !609, scopeLine: 177, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!609 = !DISubroutineType(types: !610)
!610 = !{null, !527, !344, !268}
!611 = !DILocalVariable(name: "cond", arg: 1, scope: !608, file: !2, line: 176, type: !527)
!612 = !DILocation(line: 176, column: 37, scope: !608)
!613 = !DILocalVariable(name: "lock", arg: 2, scope: !608, file: !2, line: 176, type: !344)
!614 = !DILocation(line: 176, column: 60, scope: !608)
!615 = !DILocalVariable(name: "millis", arg: 3, scope: !608, file: !2, line: 176, type: !268)
!616 = !DILocation(line: 176, column: 76, scope: !608)
!617 = !DILocalVariable(name: "ts", scope: !608, file: !2, line: 179, type: !618)
!618 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !619, line: 11, size: 128, elements: !620)
!619 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_timespec.h", directory: "", checksumkind: CSK_MD5, checksum: "55dc154df3f21a5aa944dcafba9b43f6")
!620 = !{!621, !624}
!621 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !618, file: !619, line: 16, baseType: !622, size: 64)
!622 = !DIDerivedType(tag: DW_TAG_typedef, name: "__time_t", file: !623, line: 160, baseType: !233)
!623 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "e1865d9fe29fe1b5ced550b7ba458f9e")
!624 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !618, file: !619, line: 21, baseType: !625, size: 64, offset: 64)
!625 = !DIDerivedType(tag: DW_TAG_typedef, name: "__syscall_slong_t", file: !623, line: 197, baseType: !233)
!626 = !DILocation(line: 179, column: 21, scope: !608)
!627 = !DILocation(line: 183, column: 11, scope: !608)
!628 = !DILocalVariable(name: "status", scope: !608, file: !2, line: 184, type: !187)
!629 = !DILocation(line: 184, column: 9, scope: !608)
!630 = !DILocation(line: 184, column: 41, scope: !608)
!631 = !DILocation(line: 184, column: 47, scope: !608)
!632 = !DILocation(line: 184, column: 18, scope: !608)
!633 = !DILocation(line: 185, column: 1, scope: !608)
!634 = distinct !DISubprogram(name: "cond_worker", scope: !2, file: !2, line: 191, type: !292, scopeLine: 192, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!635 = !DILocalVariable(name: "message", arg: 1, scope: !634, file: !2, line: 191, type: !113)
!636 = !DILocation(line: 191, column: 25, scope: !634)
!637 = !DILocalVariable(name: "idle", scope: !634, file: !2, line: 193, type: !455)
!638 = !DILocation(line: 193, column: 10, scope: !634)
!639 = !DILocation(line: 195, column: 9, scope: !640)
!640 = distinct !DILexicalBlock(scope: !634, file: !2, line: 194, column: 5)
!641 = !DILocation(line: 196, column: 9, scope: !640)
!642 = !DILocation(line: 197, column: 9, scope: !640)
!643 = !DILocation(line: 198, column: 9, scope: !640)
!644 = !DILocation(line: 199, column: 16, scope: !640)
!645 = !DILocation(line: 199, column: 22, scope: !640)
!646 = !DILocation(line: 199, column: 14, scope: !640)
!647 = !DILocation(line: 200, column: 9, scope: !640)
!648 = !DILocation(line: 202, column: 9, scope: !649)
!649 = distinct !DILexicalBlock(scope: !634, file: !2, line: 202, column: 9)
!650 = !DILocation(line: 202, column: 9, scope: !634)
!651 = !DILocation(line: 203, column: 25, scope: !649)
!652 = !DILocation(line: 203, column: 34, scope: !649)
!653 = !DILocation(line: 203, column: 9, scope: !649)
!654 = !DILocation(line: 204, column: 10, scope: !634)
!655 = !DILocation(line: 206, column: 9, scope: !656)
!656 = distinct !DILexicalBlock(scope: !634, file: !2, line: 205, column: 5)
!657 = !DILocation(line: 207, column: 9, scope: !656)
!658 = !DILocation(line: 208, column: 9, scope: !656)
!659 = !DILocation(line: 209, column: 9, scope: !656)
!660 = !DILocation(line: 210, column: 16, scope: !656)
!661 = !DILocation(line: 210, column: 22, scope: !656)
!662 = !DILocation(line: 210, column: 14, scope: !656)
!663 = !DILocation(line: 211, column: 9, scope: !656)
!664 = !DILocation(line: 213, column: 9, scope: !665)
!665 = distinct !DILexicalBlock(scope: !634, file: !2, line: 213, column: 9)
!666 = !DILocation(line: 213, column: 9, scope: !634)
!667 = !DILocation(line: 214, column: 25, scope: !665)
!668 = !DILocation(line: 214, column: 34, scope: !665)
!669 = !DILocation(line: 214, column: 9, scope: !665)
!670 = !DILocation(line: 215, column: 12, scope: !634)
!671 = !DILocation(line: 215, column: 5, scope: !634)
!672 = !DILocation(line: 216, column: 1, scope: !634)
!673 = distinct !DISubprogram(name: "cond_test", scope: !2, file: !2, line: 218, type: !482, scopeLine: 219, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!674 = !DILocalVariable(name: "message", scope: !673, file: !2, line: 220, type: !113)
!675 = !DILocation(line: 220, column: 11, scope: !673)
!676 = !DILocation(line: 221, column: 5, scope: !673)
!677 = !DILocation(line: 222, column: 5, scope: !673)
!678 = !DILocalVariable(name: "worker", scope: !673, file: !2, line: 224, type: !271)
!679 = !DILocation(line: 224, column: 15, scope: !673)
!680 = !DILocation(line: 224, column: 51, scope: !673)
!681 = !DILocation(line: 224, column: 24, scope: !673)
!682 = !DILocation(line: 227, column: 9, scope: !683)
!683 = distinct !DILexicalBlock(scope: !673, file: !2, line: 226, column: 5)
!684 = !DILocation(line: 228, column: 9, scope: !683)
!685 = !DILocation(line: 229, column: 9, scope: !683)
!686 = !DILocation(line: 230, column: 9, scope: !683)
!687 = !DILocation(line: 234, column: 9, scope: !688)
!688 = distinct !DILexicalBlock(scope: !673, file: !2, line: 233, column: 5)
!689 = !DILocation(line: 235, column: 9, scope: !688)
!690 = !DILocation(line: 236, column: 9, scope: !688)
!691 = !DILocation(line: 237, column: 9, scope: !688)
!692 = !DILocalVariable(name: "result", scope: !673, file: !2, line: 240, type: !113)
!693 = !DILocation(line: 240, column: 11, scope: !673)
!694 = !DILocation(line: 240, column: 32, scope: !673)
!695 = !DILocation(line: 240, column: 20, scope: !673)
!696 = !DILocation(line: 241, column: 5, scope: !697)
!697 = distinct !DILexicalBlock(scope: !698, file: !2, line: 241, column: 5)
!698 = distinct !DILexicalBlock(scope: !673, file: !2, line: 241, column: 5)
!699 = !DILocation(line: 241, column: 5, scope: !698)
!700 = !DILocation(line: 243, column: 5, scope: !673)
!701 = !DILocation(line: 244, column: 5, scope: !673)
!702 = !DILocation(line: 245, column: 1, scope: !673)
!703 = distinct !DISubprogram(name: "rwlock_init", scope: !2, file: !2, line: 252, type: !704, scopeLine: 253, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!704 = !DISubroutineType(types: !705)
!705 = !{null, !706, !187}
!706 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !707, size: 64)
!707 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlock_t", file: !186, line: 91, baseType: !708)
!708 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !186, line: 86, size: 448, elements: !709)
!709 = !{!710, !731, !732}
!710 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !708, file: !186, line: 88, baseType: !711, size: 448)
!711 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_rwlock_arch_t", file: !712, line: 23, size: 448, elements: !713)
!712 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_rwlock.h", directory: "", checksumkind: CSK_MD5, checksum: "c43c4f3db67914fc938807f222075238")
!713 = !{!714, !715, !716, !717, !718, !719, !720, !721, !722, !724, !729, !730}
!714 = !DIDerivedType(tag: DW_TAG_member, name: "__readers", scope: !711, file: !712, line: 25, baseType: !88, size: 32)
!715 = !DIDerivedType(tag: DW_TAG_member, name: "__writers", scope: !711, file: !712, line: 26, baseType: !88, size: 32, offset: 32)
!716 = !DIDerivedType(tag: DW_TAG_member, name: "__wrphase_futex", scope: !711, file: !712, line: 27, baseType: !88, size: 32, offset: 64)
!717 = !DIDerivedType(tag: DW_TAG_member, name: "__writers_futex", scope: !711, file: !712, line: 28, baseType: !88, size: 32, offset: 96)
!718 = !DIDerivedType(tag: DW_TAG_member, name: "__pad3", scope: !711, file: !712, line: 29, baseType: !88, size: 32, offset: 128)
!719 = !DIDerivedType(tag: DW_TAG_member, name: "__pad4", scope: !711, file: !712, line: 30, baseType: !88, size: 32, offset: 160)
!720 = !DIDerivedType(tag: DW_TAG_member, name: "__cur_writer", scope: !711, file: !712, line: 32, baseType: !187, size: 32, offset: 192)
!721 = !DIDerivedType(tag: DW_TAG_member, name: "__shared", scope: !711, file: !712, line: 33, baseType: !187, size: 32, offset: 224)
!722 = !DIDerivedType(tag: DW_TAG_member, name: "__rwelision", scope: !711, file: !712, line: 34, baseType: !723, size: 8, offset: 256)
!723 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!724 = !DIDerivedType(tag: DW_TAG_member, name: "__pad1", scope: !711, file: !712, line: 39, baseType: !725, size: 56, offset: 264)
!725 = !DICompositeType(tag: DW_TAG_array_type, baseType: !726, size: 56, elements: !727)
!726 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!727 = !{!728}
!728 = !DISubrange(count: 7)
!729 = !DIDerivedType(tag: DW_TAG_member, name: "__pad2", scope: !711, file: !712, line: 42, baseType: !272, size: 64, offset: 320)
!730 = !DIDerivedType(tag: DW_TAG_member, name: "__flags", scope: !711, file: !712, line: 45, baseType: !88, size: 32, offset: 384)
!731 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !708, file: !186, line: 89, baseType: !306, size: 448)
!732 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !708, file: !186, line: 90, baseType: !233, size: 64)
!733 = !DILocalVariable(name: "lock", arg: 1, scope: !703, file: !2, line: 252, type: !706)
!734 = !DILocation(line: 252, column: 36, scope: !703)
!735 = !DILocalVariable(name: "shared", arg: 2, scope: !703, file: !2, line: 252, type: !187)
!736 = !DILocation(line: 252, column: 46, scope: !703)
!737 = !DILocalVariable(name: "status", scope: !703, file: !2, line: 254, type: !187)
!738 = !DILocation(line: 254, column: 9, scope: !703)
!739 = !DILocalVariable(name: "value", scope: !703, file: !2, line: 255, type: !187)
!740 = !DILocation(line: 255, column: 9, scope: !703)
!741 = !DILocalVariable(name: "attributes", scope: !703, file: !2, line: 256, type: !742)
!742 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlockattr_t", file: !186, line: 97, baseType: !743)
!743 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !186, line: 93, size: 64, elements: !744)
!744 = !{!745, !746}
!745 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !743, file: !186, line: 95, baseType: !65, size: 64)
!746 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !743, file: !186, line: 96, baseType: !233, size: 64)
!747 = !DILocation(line: 256, column: 26, scope: !703)
!748 = !DILocation(line: 257, column: 14, scope: !703)
!749 = !DILocation(line: 257, column: 12, scope: !703)
!750 = !DILocation(line: 258, column: 5, scope: !751)
!751 = distinct !DILexicalBlock(scope: !752, file: !2, line: 258, column: 5)
!752 = distinct !DILexicalBlock(scope: !703, file: !2, line: 258, column: 5)
!753 = !DILocation(line: 258, column: 5, scope: !752)
!754 = !DILocation(line: 260, column: 57, scope: !703)
!755 = !DILocation(line: 260, column: 14, scope: !703)
!756 = !DILocation(line: 260, column: 12, scope: !703)
!757 = !DILocation(line: 261, column: 5, scope: !758)
!758 = distinct !DILexicalBlock(scope: !759, file: !2, line: 261, column: 5)
!759 = distinct !DILexicalBlock(scope: !703, file: !2, line: 261, column: 5)
!760 = !DILocation(line: 261, column: 5, scope: !759)
!761 = !DILocation(line: 262, column: 14, scope: !703)
!762 = !DILocation(line: 262, column: 12, scope: !703)
!763 = !DILocation(line: 263, column: 5, scope: !764)
!764 = distinct !DILexicalBlock(scope: !765, file: !2, line: 263, column: 5)
!765 = distinct !DILexicalBlock(scope: !703, file: !2, line: 263, column: 5)
!766 = !DILocation(line: 263, column: 5, scope: !765)
!767 = !DILocation(line: 265, column: 34, scope: !703)
!768 = !DILocation(line: 265, column: 14, scope: !703)
!769 = !DILocation(line: 265, column: 12, scope: !703)
!770 = !DILocation(line: 266, column: 5, scope: !771)
!771 = distinct !DILexicalBlock(scope: !772, file: !2, line: 266, column: 5)
!772 = distinct !DILexicalBlock(scope: !703, file: !2, line: 266, column: 5)
!773 = !DILocation(line: 266, column: 5, scope: !772)
!774 = !DILocation(line: 267, column: 14, scope: !703)
!775 = !DILocation(line: 267, column: 12, scope: !703)
!776 = !DILocation(line: 268, column: 5, scope: !777)
!777 = distinct !DILexicalBlock(scope: !778, file: !2, line: 268, column: 5)
!778 = distinct !DILexicalBlock(scope: !703, file: !2, line: 268, column: 5)
!779 = !DILocation(line: 268, column: 5, scope: !778)
!780 = !DILocation(line: 269, column: 1, scope: !703)
!781 = distinct !DISubprogram(name: "rwlock_destroy", scope: !2, file: !2, line: 271, type: !782, scopeLine: 272, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!782 = !DISubroutineType(types: !783)
!783 = !{null, !706}
!784 = !DILocalVariable(name: "lock", arg: 1, scope: !781, file: !2, line: 271, type: !706)
!785 = !DILocation(line: 271, column: 39, scope: !781)
!786 = !DILocalVariable(name: "status", scope: !781, file: !2, line: 273, type: !187)
!787 = !DILocation(line: 273, column: 9, scope: !781)
!788 = !DILocation(line: 273, column: 41, scope: !781)
!789 = !DILocation(line: 273, column: 18, scope: !781)
!790 = !DILocation(line: 274, column: 5, scope: !791)
!791 = distinct !DILexicalBlock(scope: !792, file: !2, line: 274, column: 5)
!792 = distinct !DILexicalBlock(scope: !781, file: !2, line: 274, column: 5)
!793 = !DILocation(line: 274, column: 5, scope: !792)
!794 = !DILocation(line: 275, column: 1, scope: !781)
!795 = distinct !DISubprogram(name: "rwlock_wrlock", scope: !2, file: !2, line: 277, type: !782, scopeLine: 278, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!796 = !DILocalVariable(name: "lock", arg: 1, scope: !795, file: !2, line: 277, type: !706)
!797 = !DILocation(line: 277, column: 38, scope: !795)
!798 = !DILocalVariable(name: "status", scope: !795, file: !2, line: 279, type: !187)
!799 = !DILocation(line: 279, column: 9, scope: !795)
!800 = !DILocation(line: 279, column: 40, scope: !795)
!801 = !DILocation(line: 279, column: 18, scope: !795)
!802 = !DILocation(line: 280, column: 5, scope: !803)
!803 = distinct !DILexicalBlock(scope: !804, file: !2, line: 280, column: 5)
!804 = distinct !DILexicalBlock(scope: !795, file: !2, line: 280, column: 5)
!805 = !DILocation(line: 280, column: 5, scope: !804)
!806 = !DILocation(line: 281, column: 1, scope: !795)
!807 = distinct !DISubprogram(name: "rwlock_trywrlock", scope: !2, file: !2, line: 283, type: !808, scopeLine: 284, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!808 = !DISubroutineType(types: !809)
!809 = !{!455, !706}
!810 = !DILocalVariable(name: "lock", arg: 1, scope: !807, file: !2, line: 283, type: !706)
!811 = !DILocation(line: 283, column: 41, scope: !807)
!812 = !DILocalVariable(name: "status", scope: !807, file: !2, line: 285, type: !187)
!813 = !DILocation(line: 285, column: 9, scope: !807)
!814 = !DILocation(line: 285, column: 43, scope: !807)
!815 = !DILocation(line: 285, column: 18, scope: !807)
!816 = !DILocation(line: 286, column: 5, scope: !817)
!817 = distinct !DILexicalBlock(scope: !818, file: !2, line: 286, column: 5)
!818 = distinct !DILexicalBlock(scope: !807, file: !2, line: 286, column: 5)
!819 = !DILocation(line: 286, column: 5, scope: !818)
!820 = !DILocation(line: 287, column: 12, scope: !807)
!821 = !DILocation(line: 287, column: 19, scope: !807)
!822 = !DILocation(line: 287, column: 5, scope: !807)
!823 = distinct !DISubprogram(name: "rwlock_rdlock", scope: !2, file: !2, line: 290, type: !782, scopeLine: 291, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!824 = !DILocalVariable(name: "lock", arg: 1, scope: !823, file: !2, line: 290, type: !706)
!825 = !DILocation(line: 290, column: 38, scope: !823)
!826 = !DILocalVariable(name: "status", scope: !823, file: !2, line: 292, type: !187)
!827 = !DILocation(line: 292, column: 9, scope: !823)
!828 = !DILocation(line: 292, column: 40, scope: !823)
!829 = !DILocation(line: 292, column: 18, scope: !823)
!830 = !DILocation(line: 293, column: 5, scope: !831)
!831 = distinct !DILexicalBlock(scope: !832, file: !2, line: 293, column: 5)
!832 = distinct !DILexicalBlock(scope: !823, file: !2, line: 293, column: 5)
!833 = !DILocation(line: 293, column: 5, scope: !832)
!834 = !DILocation(line: 294, column: 1, scope: !823)
!835 = distinct !DISubprogram(name: "rwlock_tryrdlock", scope: !2, file: !2, line: 296, type: !808, scopeLine: 297, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!836 = !DILocalVariable(name: "lock", arg: 1, scope: !835, file: !2, line: 296, type: !706)
!837 = !DILocation(line: 296, column: 41, scope: !835)
!838 = !DILocalVariable(name: "status", scope: !835, file: !2, line: 298, type: !187)
!839 = !DILocation(line: 298, column: 9, scope: !835)
!840 = !DILocation(line: 298, column: 43, scope: !835)
!841 = !DILocation(line: 298, column: 18, scope: !835)
!842 = !DILocation(line: 299, column: 5, scope: !843)
!843 = distinct !DILexicalBlock(scope: !844, file: !2, line: 299, column: 5)
!844 = distinct !DILexicalBlock(scope: !835, file: !2, line: 299, column: 5)
!845 = !DILocation(line: 299, column: 5, scope: !844)
!846 = !DILocation(line: 300, column: 12, scope: !835)
!847 = !DILocation(line: 300, column: 19, scope: !835)
!848 = !DILocation(line: 300, column: 5, scope: !835)
!849 = distinct !DISubprogram(name: "rwlock_unlock", scope: !2, file: !2, line: 303, type: !782, scopeLine: 304, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!850 = !DILocalVariable(name: "lock", arg: 1, scope: !849, file: !2, line: 303, type: !706)
!851 = !DILocation(line: 303, column: 38, scope: !849)
!852 = !DILocalVariable(name: "status", scope: !849, file: !2, line: 305, type: !187)
!853 = !DILocation(line: 305, column: 9, scope: !849)
!854 = !DILocation(line: 305, column: 40, scope: !849)
!855 = !DILocation(line: 305, column: 18, scope: !849)
!856 = !DILocation(line: 306, column: 5, scope: !857)
!857 = distinct !DILexicalBlock(scope: !858, file: !2, line: 306, column: 5)
!858 = distinct !DILexicalBlock(scope: !849, file: !2, line: 306, column: 5)
!859 = !DILocation(line: 306, column: 5, scope: !858)
!860 = !DILocation(line: 307, column: 1, scope: !849)
!861 = distinct !DISubprogram(name: "rwlock_test", scope: !2, file: !2, line: 309, type: !482, scopeLine: 310, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!862 = !DILocalVariable(name: "lock", scope: !861, file: !2, line: 311, type: !707)
!863 = !DILocation(line: 311, column: 22, scope: !861)
!864 = !DILocation(line: 312, column: 5, scope: !861)
!865 = !DILocalVariable(name: "test_depth", scope: !861, file: !2, line: 313, type: !866)
!866 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !187)
!867 = !DILocation(line: 313, column: 15, scope: !861)
!868 = !DILocation(line: 316, column: 9, scope: !869)
!869 = distinct !DILexicalBlock(scope: !861, file: !2, line: 315, column: 5)
!870 = !DILocalVariable(name: "success", scope: !869, file: !2, line: 317, type: !455)
!871 = !DILocation(line: 317, column: 14, scope: !869)
!872 = !DILocation(line: 317, column: 24, scope: !869)
!873 = !DILocation(line: 318, column: 9, scope: !874)
!874 = distinct !DILexicalBlock(scope: !875, file: !2, line: 318, column: 9)
!875 = distinct !DILexicalBlock(scope: !869, file: !2, line: 318, column: 9)
!876 = !DILocation(line: 318, column: 9, scope: !875)
!877 = !DILocation(line: 319, column: 19, scope: !869)
!878 = !DILocation(line: 319, column: 17, scope: !869)
!879 = !DILocation(line: 320, column: 9, scope: !880)
!880 = distinct !DILexicalBlock(scope: !881, file: !2, line: 320, column: 9)
!881 = distinct !DILexicalBlock(scope: !869, file: !2, line: 320, column: 9)
!882 = !DILocation(line: 320, column: 9, scope: !881)
!883 = !DILocation(line: 321, column: 9, scope: !869)
!884 = !DILocation(line: 325, column: 9, scope: !885)
!885 = distinct !DILexicalBlock(scope: !861, file: !2, line: 324, column: 5)
!886 = !DILocalVariable(name: "i", scope: !887, file: !2, line: 326, type: !187)
!887 = distinct !DILexicalBlock(scope: !885, file: !2, line: 326, column: 9)
!888 = !DILocation(line: 326, column: 18, scope: !887)
!889 = !DILocation(line: 326, column: 14, scope: !887)
!890 = !DILocation(line: 326, column: 25, scope: !891)
!891 = distinct !DILexicalBlock(scope: !887, file: !2, line: 326, column: 9)
!892 = !DILocation(line: 326, column: 27, scope: !891)
!893 = !DILocation(line: 326, column: 9, scope: !887)
!894 = !DILocalVariable(name: "success", scope: !895, file: !2, line: 328, type: !455)
!895 = distinct !DILexicalBlock(scope: !891, file: !2, line: 327, column: 9)
!896 = !DILocation(line: 328, column: 18, scope: !895)
!897 = !DILocation(line: 328, column: 28, scope: !895)
!898 = !DILocation(line: 329, column: 13, scope: !899)
!899 = distinct !DILexicalBlock(scope: !900, file: !2, line: 329, column: 13)
!900 = distinct !DILexicalBlock(scope: !895, file: !2, line: 329, column: 13)
!901 = !DILocation(line: 329, column: 13, scope: !900)
!902 = !DILocation(line: 330, column: 9, scope: !895)
!903 = !DILocation(line: 326, column: 42, scope: !891)
!904 = !DILocation(line: 326, column: 9, scope: !891)
!905 = distinct !{!905, !893, !906, !907}
!906 = !DILocation(line: 330, column: 9, scope: !887)
!907 = !{!"llvm.loop.mustprogress"}
!908 = !DILocalVariable(name: "success", scope: !909, file: !2, line: 333, type: !455)
!909 = distinct !DILexicalBlock(scope: !885, file: !2, line: 332, column: 9)
!910 = !DILocation(line: 333, column: 18, scope: !909)
!911 = !DILocation(line: 333, column: 28, scope: !909)
!912 = !DILocation(line: 334, column: 13, scope: !913)
!913 = distinct !DILexicalBlock(scope: !914, file: !2, line: 334, column: 13)
!914 = distinct !DILexicalBlock(scope: !909, file: !2, line: 334, column: 13)
!915 = !DILocation(line: 334, column: 13, scope: !914)
!916 = !DILocation(line: 337, column: 9, scope: !885)
!917 = !DILocalVariable(name: "i", scope: !918, file: !2, line: 338, type: !187)
!918 = distinct !DILexicalBlock(scope: !885, file: !2, line: 338, column: 9)
!919 = !DILocation(line: 338, column: 18, scope: !918)
!920 = !DILocation(line: 338, column: 14, scope: !918)
!921 = !DILocation(line: 338, column: 25, scope: !922)
!922 = distinct !DILexicalBlock(scope: !918, file: !2, line: 338, column: 9)
!923 = !DILocation(line: 338, column: 27, scope: !922)
!924 = !DILocation(line: 338, column: 9, scope: !918)
!925 = !DILocation(line: 339, column: 13, scope: !926)
!926 = distinct !DILexicalBlock(scope: !922, file: !2, line: 338, column: 46)
!927 = !DILocation(line: 340, column: 9, scope: !926)
!928 = !DILocation(line: 338, column: 42, scope: !922)
!929 = !DILocation(line: 338, column: 9, scope: !922)
!930 = distinct !{!930, !924, !931, !907}
!931 = !DILocation(line: 340, column: 9, scope: !918)
!932 = !DILocation(line: 344, column: 9, scope: !933)
!933 = distinct !DILexicalBlock(scope: !861, file: !2, line: 343, column: 5)
!934 = !DILocalVariable(name: "success", scope: !933, file: !2, line: 345, type: !455)
!935 = !DILocation(line: 345, column: 14, scope: !933)
!936 = !DILocation(line: 345, column: 24, scope: !933)
!937 = !DILocation(line: 346, column: 9, scope: !938)
!938 = distinct !DILexicalBlock(scope: !939, file: !2, line: 346, column: 9)
!939 = distinct !DILexicalBlock(scope: !933, file: !2, line: 346, column: 9)
!940 = !DILocation(line: 346, column: 9, scope: !939)
!941 = !DILocation(line: 347, column: 9, scope: !933)
!942 = !DILocation(line: 350, column: 5, scope: !861)
!943 = !DILocation(line: 351, column: 1, scope: !861)
!944 = distinct !DISubprogram(name: "key_destroy", scope: !2, file: !2, line: 358, type: !945, scopeLine: 359, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!945 = !DISubroutineType(types: !946)
!946 = !{null, !113}
!947 = !DILocalVariable(name: "unused_value", arg: 1, scope: !944, file: !2, line: 358, type: !113)
!948 = !DILocation(line: 358, column: 24, scope: !944)
!949 = !DILocation(line: 360, column: 21, scope: !944)
!950 = !DILocation(line: 360, column: 19, scope: !944)
!951 = !DILocation(line: 361, column: 1, scope: !944)
!952 = distinct !DISubprogram(name: "key_worker", scope: !2, file: !2, line: 363, type: !292, scopeLine: 364, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!953 = !DILocalVariable(name: "message", arg: 1, scope: !952, file: !2, line: 363, type: !113)
!954 = !DILocation(line: 363, column: 24, scope: !952)
!955 = !DILocalVariable(name: "my_secret", scope: !952, file: !2, line: 365, type: !187)
!956 = !DILocation(line: 365, column: 9, scope: !952)
!957 = !DILocalVariable(name: "status", scope: !952, file: !2, line: 367, type: !187)
!958 = !DILocation(line: 367, column: 9, scope: !952)
!959 = !DILocation(line: 367, column: 38, scope: !952)
!960 = !DILocation(line: 367, column: 18, scope: !952)
!961 = !DILocation(line: 368, column: 5, scope: !962)
!962 = distinct !DILexicalBlock(scope: !963, file: !2, line: 368, column: 5)
!963 = distinct !DILexicalBlock(scope: !952, file: !2, line: 368, column: 5)
!964 = !DILocation(line: 368, column: 5, scope: !963)
!965 = !DILocalVariable(name: "my_local_data", scope: !952, file: !2, line: 370, type: !113)
!966 = !DILocation(line: 370, column: 11, scope: !952)
!967 = !DILocation(line: 370, column: 47, scope: !952)
!968 = !DILocation(line: 370, column: 27, scope: !952)
!969 = !DILocation(line: 371, column: 5, scope: !970)
!970 = distinct !DILexicalBlock(scope: !971, file: !2, line: 371, column: 5)
!971 = distinct !DILexicalBlock(scope: !952, file: !2, line: 371, column: 5)
!972 = !DILocation(line: 371, column: 5, scope: !971)
!973 = !DILocation(line: 373, column: 12, scope: !952)
!974 = !DILocation(line: 373, column: 5, scope: !952)
!975 = distinct !DISubprogram(name: "key_test", scope: !2, file: !2, line: 376, type: !482, scopeLine: 377, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!976 = !DILocalVariable(name: "my_secret", scope: !975, file: !2, line: 378, type: !187)
!977 = !DILocation(line: 378, column: 9, scope: !975)
!978 = !DILocalVariable(name: "message", scope: !975, file: !2, line: 379, type: !113)
!979 = !DILocation(line: 379, column: 11, scope: !975)
!980 = !DILocalVariable(name: "status", scope: !975, file: !2, line: 380, type: !187)
!981 = !DILocation(line: 380, column: 9, scope: !975)
!982 = !DILocation(line: 382, column: 5, scope: !975)
!983 = !DILocalVariable(name: "worker", scope: !975, file: !2, line: 384, type: !271)
!984 = !DILocation(line: 384, column: 15, scope: !975)
!985 = !DILocation(line: 384, column: 50, scope: !975)
!986 = !DILocation(line: 384, column: 24, scope: !975)
!987 = !DILocation(line: 386, column: 34, scope: !975)
!988 = !DILocation(line: 386, column: 14, scope: !975)
!989 = !DILocation(line: 386, column: 12, scope: !975)
!990 = !DILocation(line: 387, column: 5, scope: !991)
!991 = distinct !DILexicalBlock(scope: !992, file: !2, line: 387, column: 5)
!992 = distinct !DILexicalBlock(scope: !975, file: !2, line: 387, column: 5)
!993 = !DILocation(line: 387, column: 5, scope: !992)
!994 = !DILocalVariable(name: "my_local_data", scope: !975, file: !2, line: 389, type: !113)
!995 = !DILocation(line: 389, column: 11, scope: !975)
!996 = !DILocation(line: 389, column: 47, scope: !975)
!997 = !DILocation(line: 389, column: 27, scope: !975)
!998 = !DILocation(line: 390, column: 5, scope: !999)
!999 = distinct !DILexicalBlock(scope: !1000, file: !2, line: 390, column: 5)
!1000 = distinct !DILexicalBlock(scope: !975, file: !2, line: 390, column: 5)
!1001 = !DILocation(line: 390, column: 5, scope: !1000)
!1002 = !DILocation(line: 392, column: 34, scope: !975)
!1003 = !DILocation(line: 392, column: 14, scope: !975)
!1004 = !DILocation(line: 392, column: 12, scope: !975)
!1005 = !DILocation(line: 393, column: 5, scope: !1006)
!1006 = distinct !DILexicalBlock(scope: !1007, file: !2, line: 393, column: 5)
!1007 = distinct !DILexicalBlock(scope: !975, file: !2, line: 393, column: 5)
!1008 = !DILocation(line: 393, column: 5, scope: !1007)
!1009 = !DILocalVariable(name: "result", scope: !975, file: !2, line: 395, type: !113)
!1010 = !DILocation(line: 395, column: 11, scope: !975)
!1011 = !DILocation(line: 395, column: 32, scope: !975)
!1012 = !DILocation(line: 395, column: 20, scope: !975)
!1013 = !DILocation(line: 396, column: 5, scope: !1014)
!1014 = distinct !DILexicalBlock(scope: !1015, file: !2, line: 396, column: 5)
!1015 = distinct !DILexicalBlock(scope: !975, file: !2, line: 396, column: 5)
!1016 = !DILocation(line: 396, column: 5, scope: !1015)
!1017 = !DILocation(line: 398, column: 33, scope: !975)
!1018 = !DILocation(line: 398, column: 14, scope: !975)
!1019 = !DILocation(line: 398, column: 12, scope: !975)
!1020 = !DILocation(line: 399, column: 5, scope: !1021)
!1021 = distinct !DILexicalBlock(scope: !1022, file: !2, line: 399, column: 5)
!1022 = distinct !DILexicalBlock(scope: !975, file: !2, line: 399, column: 5)
!1023 = !DILocation(line: 399, column: 5, scope: !1022)
!1024 = !DILocation(line: 401, column: 5, scope: !1025)
!1025 = distinct !DILexicalBlock(scope: !1026, file: !2, line: 401, column: 5)
!1026 = distinct !DILexicalBlock(scope: !975, file: !2, line: 401, column: 5)
!1027 = !DILocation(line: 401, column: 5, scope: !1026)
!1028 = !DILocation(line: 402, column: 1, scope: !975)
!1029 = distinct !DISubprogram(name: "detach_test_worker0", scope: !2, file: !2, line: 406, type: !292, scopeLine: 407, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!1030 = !DILocalVariable(name: "ignore", arg: 1, scope: !1029, file: !2, line: 406, type: !113)
!1031 = !DILocation(line: 406, column: 33, scope: !1029)
!1032 = !DILocation(line: 408, column: 5, scope: !1029)
!1033 = distinct !DISubprogram(name: "detach_test_detach", scope: !2, file: !2, line: 411, type: !292, scopeLine: 412, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!1034 = !DILocalVariable(name: "ignore", arg: 1, scope: !1033, file: !2, line: 411, type: !113)
!1035 = !DILocation(line: 411, column: 32, scope: !1033)
!1036 = !DILocalVariable(name: "status", scope: !1033, file: !2, line: 413, type: !187)
!1037 = !DILocation(line: 413, column: 9, scope: !1033)
!1038 = !DILocalVariable(name: "w0", scope: !1033, file: !2, line: 414, type: !271)
!1039 = !DILocation(line: 414, column: 15, scope: !1033)
!1040 = !DILocation(line: 414, column: 20, scope: !1033)
!1041 = !DILocation(line: 415, column: 29, scope: !1033)
!1042 = !DILocation(line: 415, column: 14, scope: !1033)
!1043 = !DILocation(line: 415, column: 12, scope: !1033)
!1044 = !DILocation(line: 416, column: 5, scope: !1045)
!1045 = distinct !DILexicalBlock(scope: !1046, file: !2, line: 416, column: 5)
!1046 = distinct !DILexicalBlock(scope: !1033, file: !2, line: 416, column: 5)
!1047 = !DILocation(line: 416, column: 5, scope: !1046)
!1048 = !DILocation(line: 418, column: 27, scope: !1033)
!1049 = !DILocation(line: 418, column: 14, scope: !1033)
!1050 = !DILocation(line: 418, column: 12, scope: !1033)
!1051 = !DILocation(line: 419, column: 5, scope: !1052)
!1052 = distinct !DILexicalBlock(scope: !1053, file: !2, line: 419, column: 5)
!1053 = distinct !DILexicalBlock(scope: !1033, file: !2, line: 419, column: 5)
!1054 = !DILocation(line: 419, column: 5, scope: !1053)
!1055 = !DILocation(line: 420, column: 5, scope: !1033)
!1056 = distinct !DISubprogram(name: "detach_test_attr", scope: !2, file: !2, line: 423, type: !292, scopeLine: 424, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!1057 = !DILocalVariable(name: "ignore", arg: 1, scope: !1056, file: !2, line: 423, type: !113)
!1058 = !DILocation(line: 423, column: 30, scope: !1056)
!1059 = !DILocalVariable(name: "status", scope: !1056, file: !2, line: 425, type: !187)
!1060 = !DILocation(line: 425, column: 9, scope: !1056)
!1061 = !DILocalVariable(name: "detachstate", scope: !1056, file: !2, line: 426, type: !187)
!1062 = !DILocation(line: 426, column: 9, scope: !1056)
!1063 = !DILocalVariable(name: "w0", scope: !1056, file: !2, line: 427, type: !271)
!1064 = !DILocation(line: 427, column: 15, scope: !1056)
!1065 = !DILocalVariable(name: "w0_attr", scope: !1056, file: !2, line: 428, type: !302)
!1066 = !DILocation(line: 428, column: 20, scope: !1056)
!1067 = !DILocation(line: 429, column: 14, scope: !1056)
!1068 = !DILocation(line: 429, column: 12, scope: !1056)
!1069 = !DILocation(line: 430, column: 5, scope: !1070)
!1070 = distinct !DILexicalBlock(scope: !1071, file: !2, line: 430, column: 5)
!1071 = distinct !DILexicalBlock(scope: !1056, file: !2, line: 430, column: 5)
!1072 = !DILocation(line: 430, column: 5, scope: !1071)
!1073 = !DILocation(line: 431, column: 14, scope: !1056)
!1074 = !DILocation(line: 431, column: 12, scope: !1056)
!1075 = !DILocation(line: 432, column: 5, scope: !1076)
!1076 = distinct !DILexicalBlock(scope: !1077, file: !2, line: 432, column: 5)
!1077 = distinct !DILexicalBlock(scope: !1056, file: !2, line: 432, column: 5)
!1078 = !DILocation(line: 432, column: 5, scope: !1077)
!1079 = !DILocation(line: 433, column: 14, scope: !1056)
!1080 = !DILocation(line: 433, column: 12, scope: !1056)
!1081 = !DILocation(line: 434, column: 5, scope: !1082)
!1082 = distinct !DILexicalBlock(scope: !1083, file: !2, line: 434, column: 5)
!1083 = distinct !DILexicalBlock(scope: !1056, file: !2, line: 434, column: 5)
!1084 = !DILocation(line: 434, column: 5, scope: !1083)
!1085 = !DILocation(line: 435, column: 14, scope: !1056)
!1086 = !DILocation(line: 435, column: 12, scope: !1056)
!1087 = !DILocation(line: 436, column: 5, scope: !1088)
!1088 = distinct !DILexicalBlock(scope: !1089, file: !2, line: 436, column: 5)
!1089 = distinct !DILexicalBlock(scope: !1056, file: !2, line: 436, column: 5)
!1090 = !DILocation(line: 436, column: 5, scope: !1089)
!1091 = !DILocation(line: 437, column: 14, scope: !1056)
!1092 = !DILocation(line: 437, column: 12, scope: !1056)
!1093 = !DILocation(line: 438, column: 5, scope: !1094)
!1094 = distinct !DILexicalBlock(scope: !1095, file: !2, line: 438, column: 5)
!1095 = distinct !DILexicalBlock(scope: !1056, file: !2, line: 438, column: 5)
!1096 = !DILocation(line: 438, column: 5, scope: !1095)
!1097 = !DILocation(line: 439, column: 5, scope: !1056)
!1098 = !DILocation(line: 441, column: 27, scope: !1056)
!1099 = !DILocation(line: 441, column: 14, scope: !1056)
!1100 = !DILocation(line: 441, column: 12, scope: !1056)
!1101 = !DILocation(line: 442, column: 5, scope: !1102)
!1102 = distinct !DILexicalBlock(scope: !1103, file: !2, line: 442, column: 5)
!1103 = distinct !DILexicalBlock(scope: !1056, file: !2, line: 442, column: 5)
!1104 = !DILocation(line: 442, column: 5, scope: !1103)
!1105 = !DILocation(line: 443, column: 5, scope: !1056)
!1106 = distinct !DISubprogram(name: "detach_test", scope: !2, file: !2, line: 446, type: !482, scopeLine: 447, spFlags: DISPFlagDefinition, unit: !84)
!1107 = !DILocation(line: 448, column: 5, scope: !1106)
!1108 = !DILocation(line: 449, column: 5, scope: !1106)
!1109 = !DILocation(line: 450, column: 1, scope: !1106)
!1110 = distinct !DISubprogram(name: "once_init0", scope: !2, file: !2, line: 459, type: !482, scopeLine: 460, spFlags: DISPFlagDefinition, unit: !84)
!1111 = !DILocation(line: 461, column: 5, scope: !1110)
!1112 = !DILocation(line: 462, column: 16, scope: !1110)
!1113 = !DILocation(line: 463, column: 1, scope: !1110)
!1114 = distinct !DISubprogram(name: "once_init1", scope: !2, file: !2, line: 465, type: !482, scopeLine: 466, spFlags: DISPFlagDefinition, unit: !84)
!1115 = !DILocation(line: 467, column: 5, scope: !1114)
!1116 = !DILocation(line: 468, column: 1, scope: !1114)
!1117 = distinct !DISubprogram(name: "once_worker", scope: !2, file: !2, line: 470, type: !292, scopeLine: 471, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!1118 = !DILocalVariable(name: "ignore", arg: 1, scope: !1117, file: !2, line: 470, type: !113)
!1119 = !DILocation(line: 470, column: 25, scope: !1117)
!1120 = !DILocalVariable(name: "status", scope: !1117, file: !2, line: 472, type: !187)
!1121 = !DILocation(line: 472, column: 9, scope: !1117)
!1122 = !DILocation(line: 472, column: 18, scope: !1117)
!1123 = !DILocation(line: 473, column: 5, scope: !1124)
!1124 = distinct !DILexicalBlock(scope: !1125, file: !2, line: 473, column: 5)
!1125 = distinct !DILexicalBlock(scope: !1117, file: !2, line: 473, column: 5)
!1126 = !DILocation(line: 473, column: 5, scope: !1125)
!1127 = !DILocation(line: 474, column: 5, scope: !1128)
!1128 = distinct !DILexicalBlock(scope: !1129, file: !2, line: 474, column: 5)
!1129 = distinct !DILexicalBlock(scope: !1117, file: !2, line: 474, column: 5)
!1130 = !DILocation(line: 474, column: 5, scope: !1129)
!1131 = !DILocation(line: 475, column: 5, scope: !1117)
!1132 = distinct !DISubprogram(name: "once_test", scope: !2, file: !2, line: 478, type: !482, scopeLine: 479, spFlags: DISPFlagDefinition, unit: !84, retainedNodes: !294)
!1133 = !DILocalVariable(name: "worker0", scope: !1132, file: !2, line: 480, type: !271)
!1134 = !DILocation(line: 480, column: 15, scope: !1132)
!1135 = !DILocation(line: 480, column: 25, scope: !1132)
!1136 = !DILocalVariable(name: "worker1", scope: !1132, file: !2, line: 481, type: !271)
!1137 = !DILocation(line: 481, column: 15, scope: !1132)
!1138 = !DILocation(line: 481, column: 25, scope: !1132)
!1139 = !DILocation(line: 482, column: 17, scope: !1132)
!1140 = !DILocation(line: 482, column: 5, scope: !1132)
!1141 = !DILocation(line: 483, column: 17, scope: !1132)
!1142 = !DILocation(line: 483, column: 5, scope: !1132)
!1143 = !DILocation(line: 484, column: 5, scope: !1144)
!1144 = distinct !DILexicalBlock(scope: !1145, file: !2, line: 484, column: 5)
!1145 = distinct !DILexicalBlock(scope: !1132, file: !2, line: 484, column: 5)
!1146 = !DILocation(line: 484, column: 5, scope: !1145)
!1147 = !DILocalVariable(name: "status", scope: !1132, file: !2, line: 486, type: !187)
!1148 = !DILocation(line: 486, column: 9, scope: !1132)
!1149 = !DILocation(line: 486, column: 18, scope: !1132)
!1150 = !DILocation(line: 487, column: 5, scope: !1151)
!1151 = distinct !DILexicalBlock(scope: !1152, file: !2, line: 487, column: 5)
!1152 = distinct !DILexicalBlock(scope: !1132, file: !2, line: 487, column: 5)
!1153 = !DILocation(line: 487, column: 5, scope: !1152)
!1154 = !DILocation(line: 488, column: 14, scope: !1132)
!1155 = !DILocation(line: 488, column: 12, scope: !1132)
!1156 = !DILocation(line: 489, column: 5, scope: !1157)
!1157 = distinct !DILexicalBlock(scope: !1158, file: !2, line: 489, column: 5)
!1158 = distinct !DILexicalBlock(scope: !1132, file: !2, line: 489, column: 5)
!1159 = !DILocation(line: 489, column: 5, scope: !1158)
!1160 = !DILocation(line: 490, column: 5, scope: !1161)
!1161 = distinct !DILexicalBlock(scope: !1162, file: !2, line: 490, column: 5)
!1162 = distinct !DILexicalBlock(scope: !1132, file: !2, line: 490, column: 5)
!1163 = !DILocation(line: 490, column: 5, scope: !1162)
!1164 = !DILocation(line: 491, column: 1, scope: !1132)
!1165 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 493, type: !1166, scopeLine: 494, spFlags: DISPFlagDefinition, unit: !84)
!1166 = !DISubroutineType(types: !1167)
!1167 = !{!187}
!1168 = !DILocation(line: 495, column: 13, scope: !1165)
!1169 = !DILocation(line: 495, column: 5, scope: !1165)
!1170 = !DILocation(line: 496, column: 17, scope: !1171)
!1171 = distinct !DILexicalBlock(scope: !1165, file: !2, line: 495, column: 38)
!1172 = !DILocation(line: 496, column: 31, scope: !1171)
!1173 = !DILocation(line: 497, column: 17, scope: !1171)
!1174 = !DILocation(line: 497, column: 30, scope: !1171)
!1175 = !DILocation(line: 498, column: 17, scope: !1171)
!1176 = !DILocation(line: 498, column: 32, scope: !1171)
!1177 = !DILocation(line: 499, column: 17, scope: !1171)
!1178 = !DILocation(line: 499, column: 29, scope: !1171)
!1179 = !DILocation(line: 500, column: 17, scope: !1171)
!1180 = !DILocation(line: 500, column: 32, scope: !1171)
!1181 = !DILocation(line: 501, column: 17, scope: !1171)
!1182 = !DILocation(line: 501, column: 30, scope: !1171)
!1183 = !DILocation(line: 503, column: 1, scope: !1165)
