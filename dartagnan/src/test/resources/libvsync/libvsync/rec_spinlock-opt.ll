; ModuleID = '/home/drc/git/Dat3M/output/rec_spinlock.ll'
source_filename = "/home/drc/git/libvsync/test/spinlock/rec_spinlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.rec_spinlock_s = type { %struct.caslock_s, %struct.vatomic32_s, i32 }
%struct.caslock_s = type { %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !38
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [34 x i8] c"./include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (3 + 0 + 1)\00", align 1
@lock = dso_local global %struct.rec_spinlock_s { %struct.caslock_s zeroinitializer, %struct.vatomic32_s { i32 -1 }, i32 0 }, align 4, !dbg !18
@.str.3 = private unnamed_addr constant [23 x i8] c"this value is reserved\00", align 1
@.str.4 = private unnamed_addr constant [48 x i8] c"id != (4294967295U) && \22this value is reserved\22\00", align 1
@.str.5 = private unnamed_addr constant [40 x i8] c"./include/vsync/spinlock/rec_spinlock.h\00", align 1
@__PRETTY_FUNCTION__.rec_spinlock_tryacquire = private unnamed_addr constant [61 x i8] c"vbool_t rec_spinlock_tryacquire(rec_spinlock_t *, vuint32_t)\00", align 1
@__PRETTY_FUNCTION__.rec_spinlock_acquire = private unnamed_addr constant [55 x i8] c"void rec_spinlock_acquire(rec_spinlock_t *, vuint32_t)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !49 {
  ret void, !dbg !53
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !54 {
  ret void, !dbg !55
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !56 {
  ret void, !dbg !57
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cs() #0 !dbg !58 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !59
  %2 = add i32 %1, 1, !dbg !59
  store i32 %2, i32* @g_cs_x, align 4, !dbg !59
  %3 = load i32, i32* @g_cs_y, align 4, !dbg !60
  %4 = add i32 %3, 1, !dbg !60
  store i32 %4, i32* @g_cs_y, align 4, !dbg !60
  ret void, !dbg !61
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !62 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !63
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !63
  %3 = icmp eq i32 %1, %2, !dbg !63
  br i1 %3, label %5, label %4, !dbg !66

4:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @.str.1, i64 0, i64 0), i32 noundef 99, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !63
  unreachable, !dbg !63

5:                                                ; preds = %0
  %6 = icmp eq i32 %1, 4, !dbg !67
  br i1 %6, label %8, label %7, !dbg !70

7:                                                ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @.str.1, i64 0, i64 0), i32 noundef 100, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !67
  unreachable, !dbg !67

8:                                                ; preds = %5
  ret void, !dbg !71
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !72 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !76, metadata !DIExpression()), !dbg !82
  call void @init(), !dbg !83
  call void @llvm.dbg.value(metadata i64 0, metadata !84, metadata !DIExpression()), !dbg !86
  call void @llvm.dbg.value(metadata i64 0, metadata !84, metadata !DIExpression()), !dbg !86
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !87
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef null) #6, !dbg !90
  call void @llvm.dbg.value(metadata i64 1, metadata !84, metadata !DIExpression()), !dbg !86
  call void @llvm.dbg.value(metadata i64 1, metadata !84, metadata !DIExpression()), !dbg !86
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !87
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !90
  call void @llvm.dbg.value(metadata i64 2, metadata !84, metadata !DIExpression()), !dbg !86
  call void @llvm.dbg.value(metadata i64 2, metadata !84, metadata !DIExpression()), !dbg !86
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !87
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !90
  call void @llvm.dbg.value(metadata i64 3, metadata !84, metadata !DIExpression()), !dbg !86
  call void @llvm.dbg.value(metadata i64 3, metadata !84, metadata !DIExpression()), !dbg !86
  call void @post(), !dbg !91
  call void @llvm.dbg.value(metadata i64 0, metadata !92, metadata !DIExpression()), !dbg !94
  call void @llvm.dbg.value(metadata i64 0, metadata !92, metadata !DIExpression()), !dbg !94
  %8 = load i64, i64* %2, align 8, !dbg !95
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !98
  call void @llvm.dbg.value(metadata i64 1, metadata !92, metadata !DIExpression()), !dbg !94
  call void @llvm.dbg.value(metadata i64 1, metadata !92, metadata !DIExpression()), !dbg !94
  %10 = load i64, i64* %4, align 8, !dbg !95
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !98
  call void @llvm.dbg.value(metadata i64 2, metadata !92, metadata !DIExpression()), !dbg !94
  call void @llvm.dbg.value(metadata i64 2, metadata !92, metadata !DIExpression()), !dbg !94
  %12 = load i64, i64* %6, align 8, !dbg !95
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !98
  call void @llvm.dbg.value(metadata i64 3, metadata !92, metadata !DIExpression()), !dbg !94
  call void @llvm.dbg.value(metadata i64 3, metadata !92, metadata !DIExpression()), !dbg !94
  call void @check(), !dbg !99
  call void @fini(), !dbg !100
  ret i32 0, !dbg !101
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @run(i8* noundef %0) #0 !dbg !102 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !105, metadata !DIExpression()), !dbg !106
  %2 = ptrtoint i8* %0 to i64, !dbg !107
  %3 = trunc i64 %2 to i32, !dbg !107
  call void @llvm.dbg.value(metadata i32 %3, metadata !108, metadata !DIExpression()), !dbg !106
  call void @verification_loop_bound(i32 noundef 2), !dbg !109
  call void @llvm.dbg.value(metadata i32 0, metadata !110, metadata !DIExpression()), !dbg !112
  br label %4, !dbg !113

4:                                                ; preds = %.critedge7, %1
  %.02 = phi i32 [ 0, %1 ], [ %18, %.critedge7 ], !dbg !112
  call void @llvm.dbg.value(metadata i32 %.02, metadata !110, metadata !DIExpression()), !dbg !112
  switch i32 %.02, label %.critedge5 [
    i32 0, label %.critedge
    i32 1, label %5
  ], !dbg !114

5:                                                ; preds = %4
  %6 = add i32 %3, 1, !dbg !116
  %7 = icmp ult i32 %6, 1, !dbg !116
  br i1 %7, label %.critedge, label %.critedge5, !dbg !117

.critedge:                                        ; preds = %4, %5
  call void @verification_loop_bound(i32 noundef 3), !dbg !118
  call void @llvm.dbg.value(metadata i32 0, metadata !120, metadata !DIExpression()), !dbg !122
  br label %8, !dbg !123

8:                                                ; preds = %.critedge3, %.critedge
  %.01 = phi i32 [ 0, %.critedge ], [ %12, %.critedge3 ], !dbg !122
  call void @llvm.dbg.value(metadata i32 %.01, metadata !120, metadata !DIExpression()), !dbg !122
  switch i32 %.01, label %.critedge6 [
    i32 0, label %.critedge3
    i32 1, label %9
  ], !dbg !124

9:                                                ; preds = %8
  %10 = add i32 %3, 1, !dbg !126
  %11 = icmp ult i32 %10, 2, !dbg !126
  br i1 %11, label %.critedge3, label %.critedge6, !dbg !127

.critedge3:                                       ; preds = %8, %9
  call void @acquire(i32 noundef %3), !dbg !128
  call void @cs(), !dbg !130
  %12 = add nuw nsw i32 %.01, 1, !dbg !131
  call void @llvm.dbg.value(metadata i32 %12, metadata !120, metadata !DIExpression()), !dbg !122
  br label %8, !dbg !132, !llvm.loop !133

.critedge6:                                       ; preds = %8, %9
  call void @verification_loop_bound(i32 noundef 3), !dbg !136
  call void @llvm.dbg.value(metadata i32 0, metadata !137, metadata !DIExpression()), !dbg !139
  br label %13, !dbg !140

13:                                               ; preds = %.critedge4, %.critedge6
  %.0 = phi i32 [ 0, %.critedge6 ], [ %17, %.critedge4 ], !dbg !139
  call void @llvm.dbg.value(metadata i32 %.0, metadata !137, metadata !DIExpression()), !dbg !139
  switch i32 %.0, label %.critedge7 [
    i32 0, label %.critedge4
    i32 1, label %14
  ], !dbg !141

14:                                               ; preds = %13
  %15 = add i32 %3, 1, !dbg !143
  %16 = icmp ult i32 %15, 2, !dbg !143
  br i1 %16, label %.critedge4, label %.critedge7, !dbg !144

.critedge4:                                       ; preds = %13, %14
  call void @release(i32 noundef %3), !dbg !145
  %17 = add nuw nsw i32 %.0, 1, !dbg !147
  call void @llvm.dbg.value(metadata i32 %17, metadata !137, metadata !DIExpression()), !dbg !139
  br label %13, !dbg !148, !llvm.loop !149

.critedge7:                                       ; preds = %13, %14
  %18 = add nuw nsw i32 %.02, 1, !dbg !151
  call void @llvm.dbg.value(metadata i32 %18, metadata !110, metadata !DIExpression()), !dbg !112
  br label %4, !dbg !152, !llvm.loop !153

.critedge5:                                       ; preds = %4, %5
  ret i8* null, !dbg !155
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @acquire(i32 noundef %0) #0 !dbg !156 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !159, metadata !DIExpression()), !dbg !160
  %2 = icmp eq i32 %0, 2, !dbg !161
  br i1 %2, label %3, label %6, !dbg !163

3:                                                ; preds = %3, %1
  %4 = call zeroext i1 @rec_spinlock_tryacquire(%struct.rec_spinlock_s* noundef @lock, i32 noundef 2), !dbg !164
  %5 = xor i1 %4, true, !dbg !164
  br i1 %5, label %3, label %7, !dbg !164, !llvm.loop !165

6:                                                ; preds = %1
  call void @rec_spinlock_acquire(%struct.rec_spinlock_s* noundef @lock, i32 noundef %0), !dbg !167
  br label %7

7:                                                ; preds = %3, %6
  ret void, !dbg !168
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @rec_spinlock_tryacquire(%struct.rec_spinlock_s* noundef %0, i32 noundef %1) #0 !dbg !169 {
  call void @llvm.dbg.value(metadata %struct.rec_spinlock_s* %0, metadata !175, metadata !DIExpression()), !dbg !176
  call void @llvm.dbg.value(metadata i32 %1, metadata !177, metadata !DIExpression()), !dbg !176
  %3 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %0, i32 0, i32 1, !dbg !178
  %4 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %3), !dbg !178
  call void @llvm.dbg.value(metadata i32 %4, metadata !179, metadata !DIExpression()), !dbg !176
  %5 = icmp ne i32 %1, -1, !dbg !180
  br i1 %5, label %7, label %6, !dbg !180

6:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @.str.5, i64 0, i64 0), i32 noundef 27, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__.rec_spinlock_tryacquire, i64 0, i64 0)) #5, !dbg !180
  unreachable, !dbg !180

7:                                                ; preds = %2
  %8 = icmp eq i32 %4, %1, !dbg !183
  br i1 %8, label %9, label %13, !dbg !178

9:                                                ; preds = %7
  %10 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %0, i32 0, i32 2, !dbg !185
  %11 = load i32, i32* %10, align 4, !dbg !185
  %12 = add i32 %11, 1, !dbg !185
  store i32 %12, i32* %10, align 4, !dbg !185
  br label %19, !dbg !185

13:                                               ; preds = %7
  %14 = icmp ne i32 %4, -1, !dbg !187
  br i1 %14, label %19, label %15, !dbg !178

15:                                               ; preds = %13
  %16 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %0, i32 0, i32 0, !dbg !189
  %17 = call zeroext i1 @caslock_tryacquire(%struct.caslock_s* noundef %16), !dbg !189
  br i1 %17, label %18, label %19, !dbg !178

18:                                               ; preds = %15
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %3, i32 noundef %1), !dbg !178
  br label %19, !dbg !178

19:                                               ; preds = %15, %13, %18, %9
  %.0 = phi i1 [ true, %9 ], [ true, %18 ], [ false, %13 ], [ false, %15 ], !dbg !176
  ret i1 %.0, !dbg !178
}

; Function Attrs: noinline nounwind uwtable
define internal void @rec_spinlock_acquire(%struct.rec_spinlock_s* noundef %0, i32 noundef %1) #0 !dbg !191 {
  call void @llvm.dbg.value(metadata %struct.rec_spinlock_s* %0, metadata !194, metadata !DIExpression()), !dbg !195
  call void @llvm.dbg.value(metadata i32 %1, metadata !196, metadata !DIExpression()), !dbg !195
  %3 = icmp ne i32 %1, -1, !dbg !197
  br i1 %3, label %5, label %4, !dbg !197

4:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @.str.5, i64 0, i64 0), i32 noundef 27, i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @__PRETTY_FUNCTION__.rec_spinlock_acquire, i64 0, i64 0)) #5, !dbg !197
  unreachable, !dbg !197

5:                                                ; preds = %2
  %6 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %0, i32 0, i32 1, !dbg !200
  %7 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %6), !dbg !200
  %8 = icmp eq i32 %7, %1, !dbg !200
  br i1 %8, label %9, label %13, !dbg !202

9:                                                ; preds = %5
  %10 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %0, i32 0, i32 2, !dbg !203
  %11 = load i32, i32* %10, align 4, !dbg !203
  %12 = add i32 %11, 1, !dbg !203
  store i32 %12, i32* %10, align 4, !dbg !203
  br label %15, !dbg !203

13:                                               ; preds = %5
  %14 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %0, i32 0, i32 0, !dbg !202
  call void @caslock_acquire(%struct.caslock_s* noundef %14), !dbg !202
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %6, i32 noundef %1), !dbg !202
  br label %15, !dbg !202

15:                                               ; preds = %13, %9
  ret void, !dbg !202
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !205 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !206, metadata !DIExpression()), !dbg !207
  call void @rec_spinlock_release(%struct.rec_spinlock_s* noundef @lock), !dbg !208
  ret void, !dbg !209
}

; Function Attrs: noinline nounwind uwtable
define internal void @rec_spinlock_release(%struct.rec_spinlock_s* noundef %0) #0 !dbg !210 {
  call void @llvm.dbg.value(metadata %struct.rec_spinlock_s* %0, metadata !213, metadata !DIExpression()), !dbg !214
  %2 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %0, i32 0, i32 2, !dbg !215
  %3 = load i32, i32* %2, align 4, !dbg !215
  %4 = icmp eq i32 %3, 0, !dbg !215
  br i1 %4, label %5, label %8, !dbg !217

5:                                                ; preds = %1
  %6 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %0, i32 0, i32 1, !dbg !218
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %6, i32 noundef -1), !dbg !218
  %7 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %0, i32 0, i32 0, !dbg !218
  call void @caslock_release(%struct.caslock_s* noundef %7), !dbg !218
  br label %10, !dbg !218

8:                                                ; preds = %1
  %9 = add i32 %3, -1, !dbg !220
  store i32 %9, i32* %2, align 4, !dbg !220
  br label %10

10:                                               ; preds = %8, %5
  ret void, !dbg !217
}

; Function Attrs: noinline nounwind uwtable
define internal void @verification_loop_bound(i32 noundef %0) #0 !dbg !222 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !224, metadata !DIExpression()), !dbg !225
  ret void, !dbg !226
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !227 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !232, metadata !DIExpression()), !dbg !233
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !234, !srcloc !235
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !236
  %3 = load atomic i32, i32* %2 monotonic, align 4, !dbg !237
  call void @llvm.dbg.value(metadata i32 %3, metadata !238, metadata !DIExpression()), !dbg !233
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !239, !srcloc !240
  ret i32 %3, !dbg !241
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @caslock_tryacquire(%struct.caslock_s* noundef %0) #0 !dbg !242 {
  call void @llvm.dbg.value(metadata %struct.caslock_s* %0, metadata !246, metadata !DIExpression()), !dbg !247
  %2 = getelementptr inbounds %struct.caslock_s, %struct.caslock_s* %0, i32 0, i32 0, !dbg !248
  %3 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %2, i32 noundef 0, i32 noundef 1), !dbg !249
  %4 = icmp eq i32 %3, 0, !dbg !250
  ret i1 %4, !dbg !251
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !252 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !255, metadata !DIExpression()), !dbg !256
  call void @llvm.dbg.value(metadata i32 %1, metadata !257, metadata !DIExpression()), !dbg !256
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !258, !srcloc !259
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !260
  store atomic i32 %1, i32* %3 monotonic, align 4, !dbg !261
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !262, !srcloc !263
  ret void, !dbg !264
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !265 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !268, metadata !DIExpression()), !dbg !269
  call void @llvm.dbg.value(metadata i32 %1, metadata !270, metadata !DIExpression()), !dbg !269
  call void @llvm.dbg.value(metadata i32 %2, metadata !271, metadata !DIExpression()), !dbg !269
  call void @llvm.dbg.value(metadata i32 %1, metadata !272, metadata !DIExpression()), !dbg !269
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !273, !srcloc !274
  %4 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !275
  %5 = cmpxchg i32* %4, i32 %1, i32 %2 acquire acquire, align 4, !dbg !276
  %6 = extractvalue { i32, i1 } %5, 0, !dbg !276
  %7 = extractvalue { i32, i1 } %5, 1, !dbg !276
  %spec.select = select i1 %7, i32 %1, i32 %6, !dbg !276
  call void @llvm.dbg.value(metadata i32 %spec.select, metadata !272, metadata !DIExpression()), !dbg !269
  %8 = zext i1 %7 to i8, !dbg !276
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !277, !srcloc !278
  ret i32 %spec.select, !dbg !279
}

; Function Attrs: noinline nounwind uwtable
define internal void @caslock_acquire(%struct.caslock_s* noundef %0) #0 !dbg !280 {
  call void @llvm.dbg.value(metadata %struct.caslock_s* %0, metadata !283, metadata !DIExpression()), !dbg !284
  %2 = getelementptr inbounds %struct.caslock_s, %struct.caslock_s* %0, i32 0, i32 0, !dbg !285
  %3 = call i32 @vatomic32_await_eq_set_acq(%struct.vatomic32_s* noundef %2, i32 noundef 0, i32 noundef 1), !dbg !286
  ret void, !dbg !287
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_set_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !288 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !290, metadata !DIExpression()), !dbg !291
  call void @llvm.dbg.value(metadata i32 %1, metadata !292, metadata !DIExpression()), !dbg !291
  call void @llvm.dbg.value(metadata i32 %2, metadata !293, metadata !DIExpression()), !dbg !291
  br label %4, !dbg !294

4:                                                ; preds = %4, %3
  %5 = call i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1), !dbg !295
  %6 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2), !dbg !297
  %7 = icmp ne i32 %6, %1, !dbg !298
  br i1 %7, label %4, label %8, !dbg !299, !llvm.loop !300

8:                                                ; preds = %4
  ret i32 %1, !dbg !302
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !303 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !306, metadata !DIExpression()), !dbg !307
  call void @llvm.dbg.value(metadata i32 %1, metadata !308, metadata !DIExpression()), !dbg !307
  call void @llvm.dbg.value(metadata i32 %1, metadata !309, metadata !DIExpression()), !dbg !307
  call void @llvm.dbg.value(metadata i32 0, metadata !310, metadata !DIExpression()), !dbg !307
  br label %3, !dbg !311

3:                                                ; preds = %3, %2
  %.0 = phi i32 [ %1, %2 ], [ %4, %3 ], !dbg !307
  call void @llvm.dbg.value(metadata i32 %.0, metadata !309, metadata !DIExpression()), !dbg !307
  %4 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0), !dbg !311
  call void @llvm.dbg.value(metadata i32 %4, metadata !310, metadata !DIExpression()), !dbg !307
  %5 = icmp ne i32 %4, %1, !dbg !311
  br i1 %5, label %3, label %6, !dbg !311, !llvm.loop !312

6:                                                ; preds = %3
  ret i32 %.0, !dbg !314
}

; Function Attrs: noinline nounwind uwtable
define internal void @caslock_release(%struct.caslock_s* noundef %0) #0 !dbg !315 {
  call void @llvm.dbg.value(metadata %struct.caslock_s* %0, metadata !316, metadata !DIExpression()), !dbg !317
  %2 = getelementptr inbounds %struct.caslock_s, %struct.caslock_s* %0, i32 0, i32 0, !dbg !318
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %2, i32 noundef 0), !dbg !319
  ret void, !dbg !320
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !321 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !322, metadata !DIExpression()), !dbg !323
  call void @llvm.dbg.value(metadata i32 %1, metadata !324, metadata !DIExpression()), !dbg !323
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !325, !srcloc !326
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !327
  store atomic i32 %1, i32* %3 release, align 4, !dbg !328
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !329, !srcloc !330
  ret void, !dbg !331
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!41, !42, !43, !44, !45, !46, !47}
!llvm.ident = !{!48}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !40, line: 87, type: !11, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/libvsync/test/spinlock/rec_spinlock.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "bddcbe0d3f2efa71890c46584b39ded0")
!4 = !{!5, !6, !11}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !7, line: 36, baseType: !8)
!7 = !DIFile(filename: "./include/vsync/vtypes.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "6ac6784bf37e03e28013e7eed706797e")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !9, line: 90, baseType: !10)
!9 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!10 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !7, line: 34, baseType: !12)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !13, line: 26, baseType: !14)
!13 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !15, line: 42, baseType: !16)
!15 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!16 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!17 = !{!18, !0, !38}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !20, line: 10, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "test/spinlock/rec_spinlock.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "bddcbe0d3f2efa71890c46584b39ded0")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "rec_spinlock_t", file: !22, line: 25, baseType: !23)
!22 = !DIFile(filename: "./include/vsync/spinlock/rec_spinlock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "5c701ef0cfb63ca7a6ff15dc398e731c")
!23 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "rec_spinlock_s", file: !22, line: 25, size: 96, elements: !24)
!24 = !{!25, !36, !37}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !23, file: !22, line: 25, baseType: !26, size: 32)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "caslock_t", file: !27, line: 21, baseType: !28)
!27 = !DIFile(filename: "./include/vsync/spinlock/caslock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "0b3ff5813922de394db335c768849f1c")
!28 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "caslock_s", file: !27, line: 19, size: 32, elements: !29)
!29 = !{!30}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !28, file: !27, line: 20, baseType: !31, size: 32, align: 32)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !32, line: 62, baseType: !33)
!32 = !DIFile(filename: "./include/vsync/atomic/core.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "1cc0657a82f0605ef67642f178a77e1c")
!33 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !32, line: 60, size: 32, align: 32, elements: !34)
!34 = !{!35}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !33, file: !32, line: 61, baseType: !11, size: 32)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "owner", scope: !23, file: !22, line: 25, baseType: !31, size: 32, align: 32, offset: 32)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !23, file: !22, line: 25, baseType: !11, size: 32, offset: 64)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !40, line: 88, type: !11, isLocal: true, isDefinition: true)
!40 = !DIFile(filename: "./include/test/boilerplate/lock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "c9c29de1465ea379ec6432998a180648")
!41 = !{i32 7, !"Dwarf Version", i32 5}
!42 = !{i32 2, !"Debug Info Version", i32 3}
!43 = !{i32 1, !"wchar_size", i32 4}
!44 = !{i32 7, !"PIC Level", i32 2}
!45 = !{i32 7, !"PIE Level", i32 2}
!46 = !{i32 7, !"uwtable", i32 1}
!47 = !{i32 7, !"frame-pointer", i32 2}
!48 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!49 = distinct !DISubprogram(name: "init", scope: !40, file: !40, line: 55, type: !50, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!50 = !DISubroutineType(types: !51)
!51 = !{null}
!52 = !{}
!53 = !DILocation(line: 57, column: 1, scope: !49)
!54 = distinct !DISubprogram(name: "post", scope: !40, file: !40, line: 64, type: !50, scopeLine: 65, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!55 = !DILocation(line: 66, column: 1, scope: !54)
!56 = distinct !DISubprogram(name: "fini", scope: !40, file: !40, line: 73, type: !50, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!57 = !DILocation(line: 75, column: 1, scope: !56)
!58 = distinct !DISubprogram(name: "cs", scope: !40, file: !40, line: 91, type: !50, scopeLine: 92, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!59 = !DILocation(line: 93, column: 8, scope: !58)
!60 = !DILocation(line: 94, column: 8, scope: !58)
!61 = !DILocation(line: 95, column: 1, scope: !58)
!62 = distinct !DISubprogram(name: "check", scope: !40, file: !40, line: 97, type: !50, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!63 = !DILocation(line: 99, column: 2, scope: !64)
!64 = distinct !DILexicalBlock(scope: !65, file: !40, line: 99, column: 2)
!65 = distinct !DILexicalBlock(scope: !62, file: !40, line: 99, column: 2)
!66 = !DILocation(line: 99, column: 2, scope: !65)
!67 = !DILocation(line: 100, column: 2, scope: !68)
!68 = distinct !DILexicalBlock(scope: !69, file: !40, line: 100, column: 2)
!69 = distinct !DILexicalBlock(scope: !62, file: !40, line: 100, column: 2)
!70 = !DILocation(line: 100, column: 2, scope: !69)
!71 = !DILocation(line: 101, column: 1, scope: !62)
!72 = distinct !DISubprogram(name: "main", scope: !40, file: !40, line: 136, type: !73, scopeLine: 137, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!73 = !DISubroutineType(types: !74)
!74 = !{!75}
!75 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!76 = !DILocalVariable(name: "t", scope: !72, file: !40, line: 138, type: !77)
!77 = !DICompositeType(tag: DW_TAG_array_type, baseType: !78, size: 192, elements: !80)
!78 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !79, line: 27, baseType: !10)
!79 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!80 = !{!81}
!81 = !DISubrange(count: 3)
!82 = !DILocation(line: 138, column: 12, scope: !72)
!83 = !DILocation(line: 146, column: 2, scope: !72)
!84 = !DILocalVariable(name: "i", scope: !85, file: !40, line: 148, type: !6)
!85 = distinct !DILexicalBlock(scope: !72, file: !40, line: 148, column: 2)
!86 = !DILocation(line: 0, scope: !85)
!87 = !DILocation(line: 149, column: 25, scope: !88)
!88 = distinct !DILexicalBlock(scope: !89, file: !40, line: 148, column: 44)
!89 = distinct !DILexicalBlock(scope: !85, file: !40, line: 148, column: 2)
!90 = !DILocation(line: 149, column: 9, scope: !88)
!91 = !DILocation(line: 152, column: 2, scope: !72)
!92 = !DILocalVariable(name: "i", scope: !93, file: !40, line: 154, type: !6)
!93 = distinct !DILexicalBlock(scope: !72, file: !40, line: 154, column: 2)
!94 = !DILocation(line: 0, scope: !93)
!95 = !DILocation(line: 155, column: 22, scope: !96)
!96 = distinct !DILexicalBlock(scope: !97, file: !40, line: 154, column: 44)
!97 = distinct !DILexicalBlock(scope: !93, file: !40, line: 154, column: 2)
!98 = !DILocation(line: 155, column: 9, scope: !96)
!99 = !DILocation(line: 163, column: 2, scope: !72)
!100 = !DILocation(line: 164, column: 2, scope: !72)
!101 = !DILocation(line: 166, column: 2, scope: !72)
!102 = distinct !DISubprogram(name: "run", scope: !40, file: !40, line: 111, type: !103, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!103 = !DISubroutineType(types: !104)
!104 = !{!5, !5}
!105 = !DILocalVariable(name: "arg", arg: 1, scope: !102, file: !40, line: 111, type: !5)
!106 = !DILocation(line: 0, scope: !102)
!107 = !DILocation(line: 113, column: 18, scope: !102)
!108 = !DILocalVariable(name: "tid", scope: !102, file: !40, line: 113, type: !11)
!109 = !DILocation(line: 117, column: 2, scope: !102)
!110 = !DILocalVariable(name: "i", scope: !111, file: !40, line: 118, type: !75)
!111 = distinct !DILexicalBlock(scope: !102, file: !40, line: 118, column: 2)
!112 = !DILocation(line: 0, scope: !111)
!113 = !DILocation(line: 118, column: 7, scope: !111)
!114 = !DILocation(line: 118, column: 25, scope: !115)
!115 = distinct !DILexicalBlock(scope: !111, file: !40, line: 118, column: 2)
!116 = !DILocation(line: 118, column: 28, scope: !115)
!117 = !DILocation(line: 118, column: 2, scope: !111)
!118 = !DILocation(line: 122, column: 3, scope: !119)
!119 = distinct !DILexicalBlock(scope: !115, file: !40, line: 118, column: 60)
!120 = !DILocalVariable(name: "j", scope: !121, file: !40, line: 123, type: !75)
!121 = distinct !DILexicalBlock(scope: !119, file: !40, line: 123, column: 3)
!122 = !DILocation(line: 0, scope: !121)
!123 = !DILocation(line: 123, column: 8, scope: !121)
!124 = !DILocation(line: 123, column: 26, scope: !125)
!125 = distinct !DILexicalBlock(scope: !121, file: !40, line: 123, column: 3)
!126 = !DILocation(line: 123, column: 29, scope: !125)
!127 = !DILocation(line: 123, column: 3, scope: !121)
!128 = !DILocation(line: 124, column: 4, scope: !129)
!129 = distinct !DILexicalBlock(scope: !125, file: !40, line: 123, column: 61)
!130 = !DILocation(line: 125, column: 4, scope: !129)
!131 = !DILocation(line: 123, column: 57, scope: !125)
!132 = !DILocation(line: 123, column: 3, scope: !125)
!133 = distinct !{!133, !127, !134, !135}
!134 = !DILocation(line: 126, column: 3, scope: !121)
!135 = !{!"llvm.loop.mustprogress"}
!136 = !DILocation(line: 127, column: 3, scope: !119)
!137 = !DILocalVariable(name: "j", scope: !138, file: !40, line: 128, type: !75)
!138 = distinct !DILexicalBlock(scope: !119, file: !40, line: 128, column: 3)
!139 = !DILocation(line: 0, scope: !138)
!140 = !DILocation(line: 128, column: 8, scope: !138)
!141 = !DILocation(line: 128, column: 26, scope: !142)
!142 = distinct !DILexicalBlock(scope: !138, file: !40, line: 128, column: 3)
!143 = !DILocation(line: 128, column: 29, scope: !142)
!144 = !DILocation(line: 128, column: 3, scope: !138)
!145 = !DILocation(line: 129, column: 4, scope: !146)
!146 = distinct !DILexicalBlock(scope: !142, file: !40, line: 128, column: 61)
!147 = !DILocation(line: 128, column: 57, scope: !142)
!148 = !DILocation(line: 128, column: 3, scope: !142)
!149 = distinct !{!149, !144, !150, !135}
!150 = !DILocation(line: 130, column: 3, scope: !138)
!151 = !DILocation(line: 118, column: 56, scope: !115)
!152 = !DILocation(line: 118, column: 2, scope: !115)
!153 = distinct !{!153, !117, !154, !135}
!154 = !DILocation(line: 131, column: 2, scope: !111)
!155 = !DILocation(line: 132, column: 2, scope: !102)
!156 = distinct !DISubprogram(name: "acquire", scope: !20, file: !20, line: 13, type: !157, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!157 = !DISubroutineType(types: !158)
!158 = !{null, !11}
!159 = !DILocalVariable(name: "tid", arg: 1, scope: !156, file: !20, line: 13, type: !11)
!160 = !DILocation(line: 0, scope: !156)
!161 = !DILocation(line: 15, column: 10, scope: !162)
!162 = distinct !DILexicalBlock(scope: !156, file: !20, line: 15, column: 6)
!163 = !DILocation(line: 15, column: 6, scope: !156)
!164 = !DILocation(line: 16, column: 3, scope: !162)
!165 = distinct !{!165, !164, !166, !135}
!166 = !DILocation(line: 17, column: 4, scope: !162)
!167 = !DILocation(line: 19, column: 3, scope: !162)
!168 = !DILocation(line: 20, column: 1, scope: !156)
!169 = distinct !DISubprogram(name: "rec_spinlock_tryacquire", scope: !22, file: !22, line: 25, type: !170, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!170 = !DISubroutineType(types: !171)
!171 = !{!172, !174, !11}
!172 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !7, line: 43, baseType: !173)
!173 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!174 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!175 = !DILocalVariable(name: "l", arg: 1, scope: !169, file: !22, line: 25, type: !174)
!176 = !DILocation(line: 0, scope: !169)
!177 = !DILocalVariable(name: "id", arg: 2, scope: !169, file: !22, line: 25, type: !11)
!178 = !DILocation(line: 25, column: 1, scope: !169)
!179 = !DILocalVariable(name: "owner", scope: !169, file: !22, line: 25, type: !11)
!180 = !DILocation(line: 25, column: 1, scope: !181)
!181 = distinct !DILexicalBlock(scope: !182, file: !22, line: 25, column: 1)
!182 = distinct !DILexicalBlock(scope: !169, file: !22, line: 25, column: 1)
!183 = !DILocation(line: 25, column: 1, scope: !184)
!184 = distinct !DILexicalBlock(scope: !169, file: !22, line: 25, column: 1)
!185 = !DILocation(line: 25, column: 1, scope: !186)
!186 = distinct !DILexicalBlock(scope: !184, file: !22, line: 25, column: 1)
!187 = !DILocation(line: 25, column: 1, scope: !188)
!188 = distinct !DILexicalBlock(scope: !169, file: !22, line: 25, column: 1)
!189 = !DILocation(line: 25, column: 1, scope: !190)
!190 = distinct !DILexicalBlock(scope: !169, file: !22, line: 25, column: 1)
!191 = distinct !DISubprogram(name: "rec_spinlock_acquire", scope: !22, file: !22, line: 25, type: !192, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!192 = !DISubroutineType(types: !193)
!193 = !{null, !174, !11}
!194 = !DILocalVariable(name: "l", arg: 1, scope: !191, file: !22, line: 25, type: !174)
!195 = !DILocation(line: 0, scope: !191)
!196 = !DILocalVariable(name: "id", arg: 2, scope: !191, file: !22, line: 25, type: !11)
!197 = !DILocation(line: 25, column: 1, scope: !198)
!198 = distinct !DILexicalBlock(scope: !199, file: !22, line: 25, column: 1)
!199 = distinct !DILexicalBlock(scope: !191, file: !22, line: 25, column: 1)
!200 = !DILocation(line: 25, column: 1, scope: !201)
!201 = distinct !DILexicalBlock(scope: !191, file: !22, line: 25, column: 1)
!202 = !DILocation(line: 25, column: 1, scope: !191)
!203 = !DILocation(line: 25, column: 1, scope: !204)
!204 = distinct !DILexicalBlock(scope: !201, file: !22, line: 25, column: 1)
!205 = distinct !DISubprogram(name: "release", scope: !20, file: !20, line: 23, type: !157, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!206 = !DILocalVariable(name: "tid", arg: 1, scope: !205, file: !20, line: 23, type: !11)
!207 = !DILocation(line: 0, scope: !205)
!208 = !DILocation(line: 26, column: 2, scope: !205)
!209 = !DILocation(line: 27, column: 1, scope: !205)
!210 = distinct !DISubprogram(name: "rec_spinlock_release", scope: !22, file: !22, line: 25, type: !211, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!211 = !DISubroutineType(types: !212)
!212 = !{null, !174}
!213 = !DILocalVariable(name: "l", arg: 1, scope: !210, file: !22, line: 25, type: !174)
!214 = !DILocation(line: 0, scope: !210)
!215 = !DILocation(line: 25, column: 1, scope: !216)
!216 = distinct !DILexicalBlock(scope: !210, file: !22, line: 25, column: 1)
!217 = !DILocation(line: 25, column: 1, scope: !210)
!218 = !DILocation(line: 25, column: 1, scope: !219)
!219 = distinct !DILexicalBlock(scope: !216, file: !22, line: 25, column: 1)
!220 = !DILocation(line: 25, column: 1, scope: !221)
!221 = distinct !DILexicalBlock(scope: !216, file: !22, line: 25, column: 1)
!222 = distinct !DISubprogram(name: "verification_loop_bound", scope: !223, file: !223, line: 80, type: !157, scopeLine: 81, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!223 = !DIFile(filename: "./include/vsync/common/verify.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "3a0b94d9e7ec6d94ef39ae9297c4bc2a")
!224 = !DILocalVariable(name: "bound", arg: 1, scope: !222, file: !223, line: 80, type: !11)
!225 = !DILocation(line: 0, scope: !222)
!226 = !DILocation(line: 83, column: 1, scope: !222)
!227 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !228, file: !228, line: 193, type: !229, scopeLine: 194, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!228 = !DIFile(filename: "./include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "31d9a9647b315cadb2f817a7c8e98ecf")
!229 = !DISubroutineType(types: !230)
!230 = !{!11, !231}
!231 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!232 = !DILocalVariable(name: "a", arg: 1, scope: !227, file: !228, line: 193, type: !231)
!233 = !DILocation(line: 0, scope: !227)
!234 = !DILocation(line: 195, column: 2, scope: !227)
!235 = !{i64 2147851104}
!236 = !DILocation(line: 197, column: 7, scope: !227)
!237 = !DILocation(line: 196, column: 29, scope: !227)
!238 = !DILocalVariable(name: "tmp", scope: !227, file: !228, line: 196, type: !11)
!239 = !DILocation(line: 198, column: 2, scope: !227)
!240 = !{i64 2147851150}
!241 = !DILocation(line: 199, column: 2, scope: !227)
!242 = distinct !DISubprogram(name: "caslock_tryacquire", scope: !27, file: !27, line: 58, type: !243, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!243 = !DISubroutineType(types: !244)
!244 = !{!172, !245}
!245 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!246 = !DILocalVariable(name: "l", arg: 1, scope: !242, file: !27, line: 58, type: !245)
!247 = !DILocation(line: 0, scope: !242)
!248 = !DILocation(line: 60, column: 35, scope: !242)
!249 = !DILocation(line: 60, column: 9, scope: !242)
!250 = !DILocation(line: 60, column: 47, scope: !242)
!251 = !DILocation(line: 60, column: 2, scope: !242)
!252 = distinct !DISubprogram(name: "vatomic32_write_rlx", scope: !228, file: !228, line: 451, type: !253, scopeLine: 452, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!253 = !DISubroutineType(types: !254)
!254 = !{null, !231, !11}
!255 = !DILocalVariable(name: "a", arg: 1, scope: !252, file: !228, line: 451, type: !231)
!256 = !DILocation(line: 0, scope: !252)
!257 = !DILocalVariable(name: "v", arg: 2, scope: !252, file: !228, line: 451, type: !11)
!258 = !DILocation(line: 453, column: 2, scope: !252)
!259 = !{i64 2147852616}
!260 = !DILocation(line: 454, column: 23, scope: !252)
!261 = !DILocation(line: 454, column: 2, scope: !252)
!262 = !DILocation(line: 455, column: 2, scope: !252)
!263 = !{i64 2147852662}
!264 = !DILocation(line: 456, column: 1, scope: !252)
!265 = distinct !DISubprogram(name: "vatomic32_cmpxchg_acq", scope: !228, file: !228, line: 1102, type: !266, scopeLine: 1103, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!266 = !DISubroutineType(types: !267)
!267 = !{!11, !231, !11, !11}
!268 = !DILocalVariable(name: "a", arg: 1, scope: !265, file: !228, line: 1102, type: !231)
!269 = !DILocation(line: 0, scope: !265)
!270 = !DILocalVariable(name: "e", arg: 2, scope: !265, file: !228, line: 1102, type: !11)
!271 = !DILocalVariable(name: "v", arg: 3, scope: !265, file: !228, line: 1102, type: !11)
!272 = !DILocalVariable(name: "exp", scope: !265, file: !228, line: 1104, type: !11)
!273 = !DILocation(line: 1105, column: 2, scope: !265)
!274 = !{i64 2147856300}
!275 = !DILocation(line: 1106, column: 34, scope: !265)
!276 = !DILocation(line: 1106, column: 2, scope: !265)
!277 = !DILocation(line: 1109, column: 2, scope: !265)
!278 = !{i64 2147856354}
!279 = !DILocation(line: 1110, column: 2, scope: !265)
!280 = distinct !DISubprogram(name: "caslock_acquire", scope: !27, file: !27, line: 46, type: !281, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!281 = !DISubroutineType(types: !282)
!282 = !{null, !245}
!283 = !DILocalVariable(name: "l", arg: 1, scope: !280, file: !27, line: 46, type: !245)
!284 = !DILocation(line: 0, scope: !280)
!285 = !DILocation(line: 48, column: 33, scope: !280)
!286 = !DILocation(line: 48, column: 2, scope: !280)
!287 = !DILocation(line: 49, column: 1, scope: !280)
!288 = distinct !DISubprogram(name: "vatomic32_await_eq_set_acq", scope: !289, file: !289, line: 7487, type: !266, scopeLine: 7488, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!289 = !DIFile(filename: "./include/vsync/atomic/internal/fallback.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "bfc5d50ad810da3af0d582a48b47498f")
!290 = !DILocalVariable(name: "a", arg: 1, scope: !288, file: !289, line: 7487, type: !231)
!291 = !DILocation(line: 0, scope: !288)
!292 = !DILocalVariable(name: "c", arg: 2, scope: !288, file: !289, line: 7487, type: !11)
!293 = !DILocalVariable(name: "v", arg: 3, scope: !288, file: !289, line: 7487, type: !11)
!294 = !DILocation(line: 7489, column: 2, scope: !288)
!295 = !DILocation(line: 7490, column: 9, scope: !296)
!296 = distinct !DILexicalBlock(scope: !288, file: !289, line: 7489, column: 5)
!297 = !DILocation(line: 7491, column: 11, scope: !288)
!298 = !DILocation(line: 7491, column: 42, scope: !288)
!299 = !DILocation(line: 7491, column: 2, scope: !296)
!300 = distinct !{!300, !294, !301, !135}
!301 = !DILocation(line: 7491, column: 46, scope: !288)
!302 = !DILocation(line: 7492, column: 2, scope: !288)
!303 = distinct !DISubprogram(name: "vatomic32_await_eq_rlx", scope: !289, file: !289, line: 4406, type: !304, scopeLine: 4407, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!304 = !DISubroutineType(types: !305)
!305 = !{!11, !231, !11}
!306 = !DILocalVariable(name: "a", arg: 1, scope: !303, file: !289, line: 4406, type: !231)
!307 = !DILocation(line: 0, scope: !303)
!308 = !DILocalVariable(name: "c", arg: 2, scope: !303, file: !289, line: 4406, type: !11)
!309 = !DILocalVariable(name: "ret", scope: !303, file: !289, line: 4408, type: !11)
!310 = !DILocalVariable(name: "o", scope: !303, file: !289, line: 4409, type: !11)
!311 = !DILocation(line: 4410, column: 2, scope: !303)
!312 = distinct !{!312, !311, !313, !135}
!313 = !DILocation(line: 4413, column: 2, scope: !303)
!314 = !DILocation(line: 4414, column: 2, scope: !303)
!315 = distinct !DISubprogram(name: "caslock_release", scope: !27, file: !27, line: 68, type: !281, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!316 = !DILocalVariable(name: "l", arg: 1, scope: !315, file: !27, line: 68, type: !245)
!317 = !DILocation(line: 0, scope: !315)
!318 = !DILocation(line: 70, column: 26, scope: !315)
!319 = !DILocation(line: 70, column: 2, scope: !315)
!320 = !DILocation(line: 71, column: 1, scope: !315)
!321 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !228, file: !228, line: 438, type: !253, scopeLine: 439, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!322 = !DILocalVariable(name: "a", arg: 1, scope: !321, file: !228, line: 438, type: !231)
!323 = !DILocation(line: 0, scope: !321)
!324 = !DILocalVariable(name: "v", arg: 2, scope: !321, file: !228, line: 438, type: !11)
!325 = !DILocation(line: 440, column: 2, scope: !321)
!326 = !{i64 2147852532}
!327 = !DILocation(line: 441, column: 23, scope: !321)
!328 = !DILocation(line: 441, column: 2, scope: !321)
!329 = !DILocation(line: 442, column: 2, scope: !321)
!330 = !{i64 2147852578}
!331 = !DILocation(line: 443, column: 1, scope: !321)
