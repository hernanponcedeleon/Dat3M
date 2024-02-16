; ModuleID = '/home/drc/git/Dat3M/output/rec_ticketlock.ll'
source_filename = "/home/drc/git/libvsync/test/spinlock/rec_ticketlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.rec_ticketlock_s = type { %struct.ticketlock_s, %struct.vatomic32_s, i32 }
%struct.ticketlock_s = type { %struct.vatomic32_s, %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !39
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [34 x i8] c"./include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (3 + 0 + 1)\00", align 1
@lock = dso_local global %struct.rec_ticketlock_s { %struct.ticketlock_s zeroinitializer, %struct.vatomic32_s { i32 -1 }, i32 0 }, align 4, !dbg !18
@.str.3 = private unnamed_addr constant [23 x i8] c"this value is reserved\00", align 1
@.str.4 = private unnamed_addr constant [48 x i8] c"id != (4294967295U) && \22this value is reserved\22\00", align 1
@.str.5 = private unnamed_addr constant [42 x i8] c"./include/vsync/spinlock/rec_ticketlock.h\00", align 1
@__PRETTY_FUNCTION__.rec_ticketlock_tryacquire = private unnamed_addr constant [65 x i8] c"vbool_t rec_ticketlock_tryacquire(rec_ticketlock_t *, vuint32_t)\00", align 1
@__PRETTY_FUNCTION__.rec_ticketlock_acquire = private unnamed_addr constant [59 x i8] c"void rec_ticketlock_acquire(rec_ticketlock_t *, vuint32_t)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !50 {
  ret void, !dbg !54
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !55 {
  ret void, !dbg !56
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !57 {
  ret void, !dbg !58
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cs() #0 !dbg !59 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !60
  %2 = add i32 %1, 1, !dbg !60
  store i32 %2, i32* @g_cs_x, align 4, !dbg !60
  %3 = load i32, i32* @g_cs_y, align 4, !dbg !61
  %4 = add i32 %3, 1, !dbg !61
  store i32 %4, i32* @g_cs_y, align 4, !dbg !61
  ret void, !dbg !62
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !63 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !64
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !64
  %3 = icmp eq i32 %1, %2, !dbg !64
  br i1 %3, label %5, label %4, !dbg !67

4:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @.str.1, i64 0, i64 0), i32 noundef 99, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !64
  unreachable, !dbg !64

5:                                                ; preds = %0
  %6 = icmp eq i32 %1, 4, !dbg !68
  br i1 %6, label %8, label %7, !dbg !71

7:                                                ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @.str.1, i64 0, i64 0), i32 noundef 100, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !68
  unreachable, !dbg !68

8:                                                ; preds = %5
  ret void, !dbg !72
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !73 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !77, metadata !DIExpression()), !dbg !83
  call void @init(), !dbg !84
  call void @llvm.dbg.value(metadata i64 0, metadata !85, metadata !DIExpression()), !dbg !87
  call void @llvm.dbg.value(metadata i64 0, metadata !85, metadata !DIExpression()), !dbg !87
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !88
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef null) #6, !dbg !91
  call void @llvm.dbg.value(metadata i64 1, metadata !85, metadata !DIExpression()), !dbg !87
  call void @llvm.dbg.value(metadata i64 1, metadata !85, metadata !DIExpression()), !dbg !87
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !88
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !91
  call void @llvm.dbg.value(metadata i64 2, metadata !85, metadata !DIExpression()), !dbg !87
  call void @llvm.dbg.value(metadata i64 2, metadata !85, metadata !DIExpression()), !dbg !87
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !88
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !91
  call void @llvm.dbg.value(metadata i64 3, metadata !85, metadata !DIExpression()), !dbg !87
  call void @llvm.dbg.value(metadata i64 3, metadata !85, metadata !DIExpression()), !dbg !87
  call void @post(), !dbg !92
  call void @llvm.dbg.value(metadata i64 0, metadata !93, metadata !DIExpression()), !dbg !95
  call void @llvm.dbg.value(metadata i64 0, metadata !93, metadata !DIExpression()), !dbg !95
  %8 = load i64, i64* %2, align 8, !dbg !96
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !99
  call void @llvm.dbg.value(metadata i64 1, metadata !93, metadata !DIExpression()), !dbg !95
  call void @llvm.dbg.value(metadata i64 1, metadata !93, metadata !DIExpression()), !dbg !95
  %10 = load i64, i64* %4, align 8, !dbg !96
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !99
  call void @llvm.dbg.value(metadata i64 2, metadata !93, metadata !DIExpression()), !dbg !95
  call void @llvm.dbg.value(metadata i64 2, metadata !93, metadata !DIExpression()), !dbg !95
  %12 = load i64, i64* %6, align 8, !dbg !96
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !99
  call void @llvm.dbg.value(metadata i64 3, metadata !93, metadata !DIExpression()), !dbg !95
  call void @llvm.dbg.value(metadata i64 3, metadata !93, metadata !DIExpression()), !dbg !95
  call void @check(), !dbg !100
  call void @fini(), !dbg !101
  ret i32 0, !dbg !102
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @run(i8* noundef %0) #0 !dbg !103 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !106, metadata !DIExpression()), !dbg !107
  %2 = ptrtoint i8* %0 to i64, !dbg !108
  %3 = trunc i64 %2 to i32, !dbg !108
  call void @llvm.dbg.value(metadata i32 %3, metadata !109, metadata !DIExpression()), !dbg !107
  call void @verification_loop_bound(i32 noundef 2), !dbg !110
  call void @llvm.dbg.value(metadata i32 0, metadata !111, metadata !DIExpression()), !dbg !113
  br label %4, !dbg !114

4:                                                ; preds = %.critedge7, %1
  %.02 = phi i32 [ 0, %1 ], [ %18, %.critedge7 ], !dbg !113
  call void @llvm.dbg.value(metadata i32 %.02, metadata !111, metadata !DIExpression()), !dbg !113
  switch i32 %.02, label %.critedge5 [
    i32 0, label %.critedge
    i32 1, label %5
  ], !dbg !115

5:                                                ; preds = %4
  %6 = add i32 %3, 1, !dbg !117
  %7 = icmp ult i32 %6, 1, !dbg !117
  br i1 %7, label %.critedge, label %.critedge5, !dbg !118

.critedge:                                        ; preds = %4, %5
  call void @verification_loop_bound(i32 noundef 3), !dbg !119
  call void @llvm.dbg.value(metadata i32 0, metadata !121, metadata !DIExpression()), !dbg !123
  br label %8, !dbg !124

8:                                                ; preds = %.critedge3, %.critedge
  %.01 = phi i32 [ 0, %.critedge ], [ %12, %.critedge3 ], !dbg !123
  call void @llvm.dbg.value(metadata i32 %.01, metadata !121, metadata !DIExpression()), !dbg !123
  switch i32 %.01, label %.critedge6 [
    i32 0, label %.critedge3
    i32 1, label %9
  ], !dbg !125

9:                                                ; preds = %8
  %10 = add i32 %3, 1, !dbg !127
  %11 = icmp ult i32 %10, 2, !dbg !127
  br i1 %11, label %.critedge3, label %.critedge6, !dbg !128

.critedge3:                                       ; preds = %8, %9
  call void @acquire(i32 noundef %3), !dbg !129
  call void @cs(), !dbg !131
  %12 = add nuw nsw i32 %.01, 1, !dbg !132
  call void @llvm.dbg.value(metadata i32 %12, metadata !121, metadata !DIExpression()), !dbg !123
  br label %8, !dbg !133, !llvm.loop !134

.critedge6:                                       ; preds = %8, %9
  call void @verification_loop_bound(i32 noundef 3), !dbg !137
  call void @llvm.dbg.value(metadata i32 0, metadata !138, metadata !DIExpression()), !dbg !140
  br label %13, !dbg !141

13:                                               ; preds = %.critedge4, %.critedge6
  %.0 = phi i32 [ 0, %.critedge6 ], [ %17, %.critedge4 ], !dbg !140
  call void @llvm.dbg.value(metadata i32 %.0, metadata !138, metadata !DIExpression()), !dbg !140
  switch i32 %.0, label %.critedge7 [
    i32 0, label %.critedge4
    i32 1, label %14
  ], !dbg !142

14:                                               ; preds = %13
  %15 = add i32 %3, 1, !dbg !144
  %16 = icmp ult i32 %15, 2, !dbg !144
  br i1 %16, label %.critedge4, label %.critedge7, !dbg !145

.critedge4:                                       ; preds = %13, %14
  call void @release(i32 noundef %3), !dbg !146
  %17 = add nuw nsw i32 %.0, 1, !dbg !148
  call void @llvm.dbg.value(metadata i32 %17, metadata !138, metadata !DIExpression()), !dbg !140
  br label %13, !dbg !149, !llvm.loop !150

.critedge7:                                       ; preds = %13, %14
  %18 = add nuw nsw i32 %.02, 1, !dbg !152
  call void @llvm.dbg.value(metadata i32 %18, metadata !111, metadata !DIExpression()), !dbg !113
  br label %4, !dbg !153, !llvm.loop !154

.critedge5:                                       ; preds = %4, %5
  ret i8* null, !dbg !156
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @acquire(i32 noundef %0) #0 !dbg !157 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !160, metadata !DIExpression()), !dbg !161
  %2 = icmp eq i32 %0, 2, !dbg !162
  br i1 %2, label %3, label %6, !dbg !164

3:                                                ; preds = %3, %1
  %4 = call zeroext i1 @rec_ticketlock_tryacquire(%struct.rec_ticketlock_s* noundef @lock, i32 noundef 2), !dbg !165
  %5 = xor i1 %4, true, !dbg !165
  br i1 %5, label %3, label %7, !dbg !165, !llvm.loop !166

6:                                                ; preds = %1
  call void @rec_ticketlock_acquire(%struct.rec_ticketlock_s* noundef @lock, i32 noundef %0), !dbg !168
  br label %7

7:                                                ; preds = %3, %6
  ret void, !dbg !169
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @rec_ticketlock_tryacquire(%struct.rec_ticketlock_s* noundef %0, i32 noundef %1) #0 !dbg !170 {
  call void @llvm.dbg.value(metadata %struct.rec_ticketlock_s* %0, metadata !176, metadata !DIExpression()), !dbg !177
  call void @llvm.dbg.value(metadata i32 %1, metadata !178, metadata !DIExpression()), !dbg !177
  %3 = getelementptr inbounds %struct.rec_ticketlock_s, %struct.rec_ticketlock_s* %0, i32 0, i32 1, !dbg !179
  %4 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %3), !dbg !179
  call void @llvm.dbg.value(metadata i32 %4, metadata !180, metadata !DIExpression()), !dbg !177
  %5 = icmp ne i32 %1, -1, !dbg !181
  br i1 %5, label %7, label %6, !dbg !181

6:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([42 x i8], [42 x i8]* @.str.5, i64 0, i64 0), i32 noundef 28, i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @__PRETTY_FUNCTION__.rec_ticketlock_tryacquire, i64 0, i64 0)) #5, !dbg !181
  unreachable, !dbg !181

7:                                                ; preds = %2
  %8 = icmp eq i32 %4, %1, !dbg !184
  br i1 %8, label %9, label %13, !dbg !179

9:                                                ; preds = %7
  %10 = getelementptr inbounds %struct.rec_ticketlock_s, %struct.rec_ticketlock_s* %0, i32 0, i32 2, !dbg !186
  %11 = load i32, i32* %10, align 4, !dbg !186
  %12 = add i32 %11, 1, !dbg !186
  store i32 %12, i32* %10, align 4, !dbg !186
  br label %19, !dbg !186

13:                                               ; preds = %7
  %14 = icmp ne i32 %4, -1, !dbg !188
  br i1 %14, label %19, label %15, !dbg !179

15:                                               ; preds = %13
  %16 = getelementptr inbounds %struct.rec_ticketlock_s, %struct.rec_ticketlock_s* %0, i32 0, i32 0, !dbg !190
  %17 = call zeroext i1 @ticketlock_tryacquire(%struct.ticketlock_s* noundef %16), !dbg !190
  br i1 %17, label %18, label %19, !dbg !179

18:                                               ; preds = %15
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %3, i32 noundef %1), !dbg !179
  br label %19, !dbg !179

19:                                               ; preds = %15, %13, %18, %9
  %.0 = phi i1 [ true, %9 ], [ true, %18 ], [ false, %13 ], [ false, %15 ], !dbg !177
  ret i1 %.0, !dbg !179
}

; Function Attrs: noinline nounwind uwtable
define internal void @rec_ticketlock_acquire(%struct.rec_ticketlock_s* noundef %0, i32 noundef %1) #0 !dbg !192 {
  call void @llvm.dbg.value(metadata %struct.rec_ticketlock_s* %0, metadata !195, metadata !DIExpression()), !dbg !196
  call void @llvm.dbg.value(metadata i32 %1, metadata !197, metadata !DIExpression()), !dbg !196
  %3 = icmp ne i32 %1, -1, !dbg !198
  br i1 %3, label %5, label %4, !dbg !198

4:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([42 x i8], [42 x i8]* @.str.5, i64 0, i64 0), i32 noundef 28, i8* noundef getelementptr inbounds ([59 x i8], [59 x i8]* @__PRETTY_FUNCTION__.rec_ticketlock_acquire, i64 0, i64 0)) #5, !dbg !198
  unreachable, !dbg !198

5:                                                ; preds = %2
  %6 = getelementptr inbounds %struct.rec_ticketlock_s, %struct.rec_ticketlock_s* %0, i32 0, i32 1, !dbg !201
  %7 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %6), !dbg !201
  %8 = icmp eq i32 %7, %1, !dbg !201
  br i1 %8, label %9, label %13, !dbg !203

9:                                                ; preds = %5
  %10 = getelementptr inbounds %struct.rec_ticketlock_s, %struct.rec_ticketlock_s* %0, i32 0, i32 2, !dbg !204
  %11 = load i32, i32* %10, align 4, !dbg !204
  %12 = add i32 %11, 1, !dbg !204
  store i32 %12, i32* %10, align 4, !dbg !204
  br label %15, !dbg !204

13:                                               ; preds = %5
  %14 = getelementptr inbounds %struct.rec_ticketlock_s, %struct.rec_ticketlock_s* %0, i32 0, i32 0, !dbg !203
  call void @ticketlock_acquire(%struct.ticketlock_s* noundef %14), !dbg !203
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %6, i32 noundef %1), !dbg !203
  br label %15, !dbg !203

15:                                               ; preds = %13, %9
  ret void, !dbg !203
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !206 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !207, metadata !DIExpression()), !dbg !208
  call void @rec_ticketlock_release(%struct.rec_ticketlock_s* noundef @lock), !dbg !209
  ret void, !dbg !210
}

; Function Attrs: noinline nounwind uwtable
define internal void @rec_ticketlock_release(%struct.rec_ticketlock_s* noundef %0) #0 !dbg !211 {
  call void @llvm.dbg.value(metadata %struct.rec_ticketlock_s* %0, metadata !214, metadata !DIExpression()), !dbg !215
  %2 = getelementptr inbounds %struct.rec_ticketlock_s, %struct.rec_ticketlock_s* %0, i32 0, i32 2, !dbg !216
  %3 = load i32, i32* %2, align 4, !dbg !216
  %4 = icmp eq i32 %3, 0, !dbg !216
  br i1 %4, label %5, label %8, !dbg !218

5:                                                ; preds = %1
  %6 = getelementptr inbounds %struct.rec_ticketlock_s, %struct.rec_ticketlock_s* %0, i32 0, i32 1, !dbg !219
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %6, i32 noundef -1), !dbg !219
  %7 = getelementptr inbounds %struct.rec_ticketlock_s, %struct.rec_ticketlock_s* %0, i32 0, i32 0, !dbg !219
  call void @ticketlock_release(%struct.ticketlock_s* noundef %7), !dbg !219
  br label %10, !dbg !219

8:                                                ; preds = %1
  %9 = add i32 %3, -1, !dbg !221
  store i32 %9, i32* %2, align 4, !dbg !221
  br label %10

10:                                               ; preds = %8, %5
  ret void, !dbg !218
}

; Function Attrs: noinline nounwind uwtable
define internal void @verification_loop_bound(i32 noundef %0) #0 !dbg !223 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !225, metadata !DIExpression()), !dbg !226
  ret void, !dbg !227
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !228 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !233, metadata !DIExpression()), !dbg !234
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !235, !srcloc !236
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !237
  %3 = load atomic i32, i32* %2 monotonic, align 4, !dbg !238
  call void @llvm.dbg.value(metadata i32 %3, metadata !239, metadata !DIExpression()), !dbg !234
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !240, !srcloc !241
  ret i32 %3, !dbg !242
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @ticketlock_tryacquire(%struct.ticketlock_s* noundef %0) #0 !dbg !243 {
  call void @llvm.dbg.value(metadata %struct.ticketlock_s* %0, metadata !247, metadata !DIExpression()), !dbg !248
  %2 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 1, !dbg !249
  %3 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %2), !dbg !250
  call void @llvm.dbg.value(metadata i32 %3, metadata !251, metadata !DIExpression()), !dbg !248
  %4 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 0, !dbg !252
  %5 = add i32 %3, 1, !dbg !253
  %6 = call i32 @vatomic32_cmpxchg_rlx(%struct.vatomic32_s* noundef %4, i32 noundef %3, i32 noundef %5), !dbg !254
  call void @llvm.dbg.value(metadata i32 %6, metadata !255, metadata !DIExpression()), !dbg !248
  %7 = icmp eq i32 %6, %3, !dbg !256
  ret i1 %7, !dbg !257
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !258 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !261, metadata !DIExpression()), !dbg !262
  call void @llvm.dbg.value(metadata i32 %1, metadata !263, metadata !DIExpression()), !dbg !262
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !264, !srcloc !265
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !266
  store atomic i32 %1, i32* %3 monotonic, align 4, !dbg !267
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !268, !srcloc !269
  ret void, !dbg !270
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !271 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !272, metadata !DIExpression()), !dbg !273
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !274, !srcloc !275
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !276
  %3 = load atomic i32, i32* %2 acquire, align 4, !dbg !277
  call void @llvm.dbg.value(metadata i32 %3, metadata !278, metadata !DIExpression()), !dbg !273
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !279, !srcloc !280
  ret i32 %3, !dbg !281
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !282 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !285, metadata !DIExpression()), !dbg !286
  call void @llvm.dbg.value(metadata i32 %1, metadata !287, metadata !DIExpression()), !dbg !286
  call void @llvm.dbg.value(metadata i32 %2, metadata !288, metadata !DIExpression()), !dbg !286
  call void @llvm.dbg.value(metadata i32 %1, metadata !289, metadata !DIExpression()), !dbg !286
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !290, !srcloc !291
  %4 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !292
  %5 = cmpxchg i32* %4, i32 %1, i32 %2 monotonic monotonic, align 4, !dbg !293
  %6 = extractvalue { i32, i1 } %5, 0, !dbg !293
  %7 = extractvalue { i32, i1 } %5, 1, !dbg !293
  %spec.select = select i1 %7, i32 %1, i32 %6, !dbg !293
  call void @llvm.dbg.value(metadata i32 %spec.select, metadata !289, metadata !DIExpression()), !dbg !286
  %8 = zext i1 %7 to i8, !dbg !293
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !294, !srcloc !295
  ret i32 %spec.select, !dbg !296
}

; Function Attrs: noinline nounwind uwtable
define internal void @ticketlock_acquire(%struct.ticketlock_s* noundef %0) #0 !dbg !297 {
  call void @llvm.dbg.value(metadata %struct.ticketlock_s* %0, metadata !300, metadata !DIExpression()), !dbg !301
  %2 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 0, !dbg !302
  %3 = call i32 @vatomic32_get_inc_rlx(%struct.vatomic32_s* noundef %2), !dbg !303
  call void @llvm.dbg.value(metadata i32 %3, metadata !304, metadata !DIExpression()), !dbg !301
  %4 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 1, !dbg !305
  %5 = call i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %4, i32 noundef %3), !dbg !306
  ret void, !dbg !307
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !308 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !310, metadata !DIExpression()), !dbg !311
  %2 = call i32 @vatomic32_get_add_rlx(%struct.vatomic32_s* noundef %0, i32 noundef 1), !dbg !312
  ret i32 %2, !dbg !313
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !314 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !317, metadata !DIExpression()), !dbg !318
  call void @llvm.dbg.value(metadata i32 %1, metadata !319, metadata !DIExpression()), !dbg !318
  call void @llvm.dbg.value(metadata i32 %1, metadata !320, metadata !DIExpression()), !dbg !318
  call void @llvm.dbg.value(metadata i32 0, metadata !321, metadata !DIExpression()), !dbg !318
  br label %3, !dbg !322

3:                                                ; preds = %3, %2
  %.0 = phi i32 [ %1, %2 ], [ %4, %3 ], !dbg !318
  call void @llvm.dbg.value(metadata i32 %.0, metadata !320, metadata !DIExpression()), !dbg !318
  %4 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0), !dbg !322
  call void @llvm.dbg.value(metadata i32 %4, metadata !321, metadata !DIExpression()), !dbg !318
  %5 = icmp ne i32 %4, %1, !dbg !322
  br i1 %5, label %3, label %6, !dbg !322, !llvm.loop !323

6:                                                ; preds = %3
  ret i32 %.0, !dbg !325
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !326 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !327, metadata !DIExpression()), !dbg !328
  call void @llvm.dbg.value(metadata i32 %1, metadata !329, metadata !DIExpression()), !dbg !328
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !330, !srcloc !331
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !332
  %4 = atomicrmw add i32* %3, i32 %1 monotonic, align 4, !dbg !333
  call void @llvm.dbg.value(metadata i32 %4, metadata !334, metadata !DIExpression()), !dbg !328
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !335, !srcloc !336
  ret i32 %4, !dbg !337
}

; Function Attrs: noinline nounwind uwtable
define internal void @ticketlock_release(%struct.ticketlock_s* noundef %0) #0 !dbg !338 {
  call void @llvm.dbg.value(metadata %struct.ticketlock_s* %0, metadata !339, metadata !DIExpression()), !dbg !340
  %2 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 1, !dbg !341
  %3 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %2), !dbg !342
  call void @llvm.dbg.value(metadata i32 %3, metadata !343, metadata !DIExpression()), !dbg !340
  %4 = add i32 %3, 1, !dbg !344
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %2, i32 noundef %4), !dbg !345
  ret void, !dbg !346
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !347 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !348, metadata !DIExpression()), !dbg !349
  call void @llvm.dbg.value(metadata i32 %1, metadata !350, metadata !DIExpression()), !dbg !349
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !351, !srcloc !352
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !353
  store atomic i32 %1, i32* %3 release, align 4, !dbg !354
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !355, !srcloc !356
  ret void, !dbg !357
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
!llvm.module.flags = !{!42, !43, !44, !45, !46, !47, !48}
!llvm.ident = !{!49}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !41, line: 87, type: !11, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/libvsync/test/spinlock/rec_ticketlock.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "4625ddb4d88b21fa0a806262e141aee0")
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
!17 = !{!18, !0, !39}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !20, line: 10, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "test/spinlock/rec_ticketlock.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "4625ddb4d88b21fa0a806262e141aee0")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "rec_ticketlock_t", file: !22, line: 26, baseType: !23)
!22 = !DIFile(filename: "./include/vsync/spinlock/rec_ticketlock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "5f8e2a74169f809af15273afc7e20133")
!23 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "rec_ticketlock_s", file: !22, line: 26, size: 128, elements: !24)
!24 = !{!25, !37, !38}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !23, file: !22, line: 26, baseType: !26, size: 64)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "ticketlock_t", file: !27, line: 24, baseType: !28)
!27 = !DIFile(filename: "./include/vsync/spinlock/ticketlock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "daf4189859ee3f1df58f186b9f69eee7")
!28 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ticketlock_s", file: !27, line: 21, size: 64, elements: !29)
!29 = !{!30, !36}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !28, file: !27, line: 22, baseType: !31, size: 32, align: 32)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !32, line: 62, baseType: !33)
!32 = !DIFile(filename: "./include/vsync/atomic/core.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "1cc0657a82f0605ef67642f178a77e1c")
!33 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !32, line: 60, size: 32, align: 32, elements: !34)
!34 = !{!35}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !33, file: !32, line: 61, baseType: !11, size: 32)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "owner", scope: !28, file: !27, line: 23, baseType: !31, size: 32, align: 32, offset: 32)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "owner", scope: !23, file: !22, line: 26, baseType: !31, size: 32, align: 32, offset: 64)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !23, file: !22, line: 26, baseType: !11, size: 32, offset: 96)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !41, line: 88, type: !11, isLocal: true, isDefinition: true)
!41 = !DIFile(filename: "./include/test/boilerplate/lock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "c9c29de1465ea379ec6432998a180648")
!42 = !{i32 7, !"Dwarf Version", i32 5}
!43 = !{i32 2, !"Debug Info Version", i32 3}
!44 = !{i32 1, !"wchar_size", i32 4}
!45 = !{i32 7, !"PIC Level", i32 2}
!46 = !{i32 7, !"PIE Level", i32 2}
!47 = !{i32 7, !"uwtable", i32 1}
!48 = !{i32 7, !"frame-pointer", i32 2}
!49 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!50 = distinct !DISubprogram(name: "init", scope: !41, file: !41, line: 55, type: !51, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!51 = !DISubroutineType(types: !52)
!52 = !{null}
!53 = !{}
!54 = !DILocation(line: 57, column: 1, scope: !50)
!55 = distinct !DISubprogram(name: "post", scope: !41, file: !41, line: 64, type: !51, scopeLine: 65, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!56 = !DILocation(line: 66, column: 1, scope: !55)
!57 = distinct !DISubprogram(name: "fini", scope: !41, file: !41, line: 73, type: !51, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!58 = !DILocation(line: 75, column: 1, scope: !57)
!59 = distinct !DISubprogram(name: "cs", scope: !41, file: !41, line: 91, type: !51, scopeLine: 92, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!60 = !DILocation(line: 93, column: 8, scope: !59)
!61 = !DILocation(line: 94, column: 8, scope: !59)
!62 = !DILocation(line: 95, column: 1, scope: !59)
!63 = distinct !DISubprogram(name: "check", scope: !41, file: !41, line: 97, type: !51, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!64 = !DILocation(line: 99, column: 2, scope: !65)
!65 = distinct !DILexicalBlock(scope: !66, file: !41, line: 99, column: 2)
!66 = distinct !DILexicalBlock(scope: !63, file: !41, line: 99, column: 2)
!67 = !DILocation(line: 99, column: 2, scope: !66)
!68 = !DILocation(line: 100, column: 2, scope: !69)
!69 = distinct !DILexicalBlock(scope: !70, file: !41, line: 100, column: 2)
!70 = distinct !DILexicalBlock(scope: !63, file: !41, line: 100, column: 2)
!71 = !DILocation(line: 100, column: 2, scope: !70)
!72 = !DILocation(line: 101, column: 1, scope: !63)
!73 = distinct !DISubprogram(name: "main", scope: !41, file: !41, line: 136, type: !74, scopeLine: 137, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!74 = !DISubroutineType(types: !75)
!75 = !{!76}
!76 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!77 = !DILocalVariable(name: "t", scope: !73, file: !41, line: 138, type: !78)
!78 = !DICompositeType(tag: DW_TAG_array_type, baseType: !79, size: 192, elements: !81)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !80, line: 27, baseType: !10)
!80 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!81 = !{!82}
!82 = !DISubrange(count: 3)
!83 = !DILocation(line: 138, column: 12, scope: !73)
!84 = !DILocation(line: 146, column: 2, scope: !73)
!85 = !DILocalVariable(name: "i", scope: !86, file: !41, line: 148, type: !6)
!86 = distinct !DILexicalBlock(scope: !73, file: !41, line: 148, column: 2)
!87 = !DILocation(line: 0, scope: !86)
!88 = !DILocation(line: 149, column: 25, scope: !89)
!89 = distinct !DILexicalBlock(scope: !90, file: !41, line: 148, column: 44)
!90 = distinct !DILexicalBlock(scope: !86, file: !41, line: 148, column: 2)
!91 = !DILocation(line: 149, column: 9, scope: !89)
!92 = !DILocation(line: 152, column: 2, scope: !73)
!93 = !DILocalVariable(name: "i", scope: !94, file: !41, line: 154, type: !6)
!94 = distinct !DILexicalBlock(scope: !73, file: !41, line: 154, column: 2)
!95 = !DILocation(line: 0, scope: !94)
!96 = !DILocation(line: 155, column: 22, scope: !97)
!97 = distinct !DILexicalBlock(scope: !98, file: !41, line: 154, column: 44)
!98 = distinct !DILexicalBlock(scope: !94, file: !41, line: 154, column: 2)
!99 = !DILocation(line: 155, column: 9, scope: !97)
!100 = !DILocation(line: 163, column: 2, scope: !73)
!101 = !DILocation(line: 164, column: 2, scope: !73)
!102 = !DILocation(line: 166, column: 2, scope: !73)
!103 = distinct !DISubprogram(name: "run", scope: !41, file: !41, line: 111, type: !104, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!104 = !DISubroutineType(types: !105)
!105 = !{!5, !5}
!106 = !DILocalVariable(name: "arg", arg: 1, scope: !103, file: !41, line: 111, type: !5)
!107 = !DILocation(line: 0, scope: !103)
!108 = !DILocation(line: 113, column: 18, scope: !103)
!109 = !DILocalVariable(name: "tid", scope: !103, file: !41, line: 113, type: !11)
!110 = !DILocation(line: 117, column: 2, scope: !103)
!111 = !DILocalVariable(name: "i", scope: !112, file: !41, line: 118, type: !76)
!112 = distinct !DILexicalBlock(scope: !103, file: !41, line: 118, column: 2)
!113 = !DILocation(line: 0, scope: !112)
!114 = !DILocation(line: 118, column: 7, scope: !112)
!115 = !DILocation(line: 118, column: 25, scope: !116)
!116 = distinct !DILexicalBlock(scope: !112, file: !41, line: 118, column: 2)
!117 = !DILocation(line: 118, column: 28, scope: !116)
!118 = !DILocation(line: 118, column: 2, scope: !112)
!119 = !DILocation(line: 122, column: 3, scope: !120)
!120 = distinct !DILexicalBlock(scope: !116, file: !41, line: 118, column: 60)
!121 = !DILocalVariable(name: "j", scope: !122, file: !41, line: 123, type: !76)
!122 = distinct !DILexicalBlock(scope: !120, file: !41, line: 123, column: 3)
!123 = !DILocation(line: 0, scope: !122)
!124 = !DILocation(line: 123, column: 8, scope: !122)
!125 = !DILocation(line: 123, column: 26, scope: !126)
!126 = distinct !DILexicalBlock(scope: !122, file: !41, line: 123, column: 3)
!127 = !DILocation(line: 123, column: 29, scope: !126)
!128 = !DILocation(line: 123, column: 3, scope: !122)
!129 = !DILocation(line: 124, column: 4, scope: !130)
!130 = distinct !DILexicalBlock(scope: !126, file: !41, line: 123, column: 61)
!131 = !DILocation(line: 125, column: 4, scope: !130)
!132 = !DILocation(line: 123, column: 57, scope: !126)
!133 = !DILocation(line: 123, column: 3, scope: !126)
!134 = distinct !{!134, !128, !135, !136}
!135 = !DILocation(line: 126, column: 3, scope: !122)
!136 = !{!"llvm.loop.mustprogress"}
!137 = !DILocation(line: 127, column: 3, scope: !120)
!138 = !DILocalVariable(name: "j", scope: !139, file: !41, line: 128, type: !76)
!139 = distinct !DILexicalBlock(scope: !120, file: !41, line: 128, column: 3)
!140 = !DILocation(line: 0, scope: !139)
!141 = !DILocation(line: 128, column: 8, scope: !139)
!142 = !DILocation(line: 128, column: 26, scope: !143)
!143 = distinct !DILexicalBlock(scope: !139, file: !41, line: 128, column: 3)
!144 = !DILocation(line: 128, column: 29, scope: !143)
!145 = !DILocation(line: 128, column: 3, scope: !139)
!146 = !DILocation(line: 129, column: 4, scope: !147)
!147 = distinct !DILexicalBlock(scope: !143, file: !41, line: 128, column: 61)
!148 = !DILocation(line: 128, column: 57, scope: !143)
!149 = !DILocation(line: 128, column: 3, scope: !143)
!150 = distinct !{!150, !145, !151, !136}
!151 = !DILocation(line: 130, column: 3, scope: !139)
!152 = !DILocation(line: 118, column: 56, scope: !116)
!153 = !DILocation(line: 118, column: 2, scope: !116)
!154 = distinct !{!154, !118, !155, !136}
!155 = !DILocation(line: 131, column: 2, scope: !112)
!156 = !DILocation(line: 132, column: 2, scope: !103)
!157 = distinct !DISubprogram(name: "acquire", scope: !20, file: !20, line: 13, type: !158, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!158 = !DISubroutineType(types: !159)
!159 = !{null, !11}
!160 = !DILocalVariable(name: "tid", arg: 1, scope: !157, file: !20, line: 13, type: !11)
!161 = !DILocation(line: 0, scope: !157)
!162 = !DILocation(line: 15, column: 10, scope: !163)
!163 = distinct !DILexicalBlock(scope: !157, file: !20, line: 15, column: 6)
!164 = !DILocation(line: 15, column: 6, scope: !157)
!165 = !DILocation(line: 16, column: 3, scope: !163)
!166 = distinct !{!166, !165, !167, !136}
!167 = !DILocation(line: 17, column: 4, scope: !163)
!168 = !DILocation(line: 19, column: 3, scope: !163)
!169 = !DILocation(line: 20, column: 1, scope: !157)
!170 = distinct !DISubprogram(name: "rec_ticketlock_tryacquire", scope: !22, file: !22, line: 26, type: !171, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!171 = !DISubroutineType(types: !172)
!172 = !{!173, !175, !11}
!173 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !7, line: 43, baseType: !174)
!174 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!175 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!176 = !DILocalVariable(name: "l", arg: 1, scope: !170, file: !22, line: 26, type: !175)
!177 = !DILocation(line: 0, scope: !170)
!178 = !DILocalVariable(name: "id", arg: 2, scope: !170, file: !22, line: 26, type: !11)
!179 = !DILocation(line: 26, column: 1, scope: !170)
!180 = !DILocalVariable(name: "owner", scope: !170, file: !22, line: 26, type: !11)
!181 = !DILocation(line: 26, column: 1, scope: !182)
!182 = distinct !DILexicalBlock(scope: !183, file: !22, line: 26, column: 1)
!183 = distinct !DILexicalBlock(scope: !170, file: !22, line: 26, column: 1)
!184 = !DILocation(line: 26, column: 1, scope: !185)
!185 = distinct !DILexicalBlock(scope: !170, file: !22, line: 26, column: 1)
!186 = !DILocation(line: 26, column: 1, scope: !187)
!187 = distinct !DILexicalBlock(scope: !185, file: !22, line: 26, column: 1)
!188 = !DILocation(line: 26, column: 1, scope: !189)
!189 = distinct !DILexicalBlock(scope: !170, file: !22, line: 26, column: 1)
!190 = !DILocation(line: 26, column: 1, scope: !191)
!191 = distinct !DILexicalBlock(scope: !170, file: !22, line: 26, column: 1)
!192 = distinct !DISubprogram(name: "rec_ticketlock_acquire", scope: !22, file: !22, line: 26, type: !193, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!193 = !DISubroutineType(types: !194)
!194 = !{null, !175, !11}
!195 = !DILocalVariable(name: "l", arg: 1, scope: !192, file: !22, line: 26, type: !175)
!196 = !DILocation(line: 0, scope: !192)
!197 = !DILocalVariable(name: "id", arg: 2, scope: !192, file: !22, line: 26, type: !11)
!198 = !DILocation(line: 26, column: 1, scope: !199)
!199 = distinct !DILexicalBlock(scope: !200, file: !22, line: 26, column: 1)
!200 = distinct !DILexicalBlock(scope: !192, file: !22, line: 26, column: 1)
!201 = !DILocation(line: 26, column: 1, scope: !202)
!202 = distinct !DILexicalBlock(scope: !192, file: !22, line: 26, column: 1)
!203 = !DILocation(line: 26, column: 1, scope: !192)
!204 = !DILocation(line: 26, column: 1, scope: !205)
!205 = distinct !DILexicalBlock(scope: !202, file: !22, line: 26, column: 1)
!206 = distinct !DISubprogram(name: "release", scope: !20, file: !20, line: 23, type: !158, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!207 = !DILocalVariable(name: "tid", arg: 1, scope: !206, file: !20, line: 23, type: !11)
!208 = !DILocation(line: 0, scope: !206)
!209 = !DILocation(line: 26, column: 2, scope: !206)
!210 = !DILocation(line: 27, column: 1, scope: !206)
!211 = distinct !DISubprogram(name: "rec_ticketlock_release", scope: !22, file: !22, line: 26, type: !212, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!212 = !DISubroutineType(types: !213)
!213 = !{null, !175}
!214 = !DILocalVariable(name: "l", arg: 1, scope: !211, file: !22, line: 26, type: !175)
!215 = !DILocation(line: 0, scope: !211)
!216 = !DILocation(line: 26, column: 1, scope: !217)
!217 = distinct !DILexicalBlock(scope: !211, file: !22, line: 26, column: 1)
!218 = !DILocation(line: 26, column: 1, scope: !211)
!219 = !DILocation(line: 26, column: 1, scope: !220)
!220 = distinct !DILexicalBlock(scope: !217, file: !22, line: 26, column: 1)
!221 = !DILocation(line: 26, column: 1, scope: !222)
!222 = distinct !DILexicalBlock(scope: !217, file: !22, line: 26, column: 1)
!223 = distinct !DISubprogram(name: "verification_loop_bound", scope: !224, file: !224, line: 80, type: !158, scopeLine: 81, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!224 = !DIFile(filename: "./include/vsync/common/verify.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "3a0b94d9e7ec6d94ef39ae9297c4bc2a")
!225 = !DILocalVariable(name: "bound", arg: 1, scope: !223, file: !224, line: 80, type: !11)
!226 = !DILocation(line: 0, scope: !223)
!227 = !DILocation(line: 83, column: 1, scope: !223)
!228 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !229, file: !229, line: 193, type: !230, scopeLine: 194, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!229 = !DIFile(filename: "./include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "31d9a9647b315cadb2f817a7c8e98ecf")
!230 = !DISubroutineType(types: !231)
!231 = !{!11, !232}
!232 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!233 = !DILocalVariable(name: "a", arg: 1, scope: !228, file: !229, line: 193, type: !232)
!234 = !DILocation(line: 0, scope: !228)
!235 = !DILocation(line: 195, column: 2, scope: !228)
!236 = !{i64 2147851636}
!237 = !DILocation(line: 197, column: 7, scope: !228)
!238 = !DILocation(line: 196, column: 29, scope: !228)
!239 = !DILocalVariable(name: "tmp", scope: !228, file: !229, line: 196, type: !11)
!240 = !DILocation(line: 198, column: 2, scope: !228)
!241 = !{i64 2147851682}
!242 = !DILocation(line: 199, column: 2, scope: !228)
!243 = distinct !DISubprogram(name: "ticketlock_tryacquire", scope: !27, file: !27, line: 64, type: !244, scopeLine: 65, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!244 = !DISubroutineType(types: !245)
!245 = !{!173, !246}
!246 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!247 = !DILocalVariable(name: "l", arg: 1, scope: !243, file: !27, line: 64, type: !246)
!248 = !DILocation(line: 0, scope: !243)
!249 = !DILocation(line: 66, column: 39, scope: !243)
!250 = !DILocation(line: 66, column: 16, scope: !243)
!251 = !DILocalVariable(name: "o", scope: !243, file: !27, line: 66, type: !11)
!252 = !DILocation(line: 67, column: 42, scope: !243)
!253 = !DILocation(line: 67, column: 53, scope: !243)
!254 = !DILocation(line: 67, column: 16, scope: !243)
!255 = !DILocalVariable(name: "n", scope: !243, file: !27, line: 67, type: !11)
!256 = !DILocation(line: 68, column: 11, scope: !243)
!257 = !DILocation(line: 68, column: 2, scope: !243)
!258 = distinct !DISubprogram(name: "vatomic32_write_rlx", scope: !229, file: !229, line: 451, type: !259, scopeLine: 452, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!259 = !DISubroutineType(types: !260)
!260 = !{null, !232, !11}
!261 = !DILocalVariable(name: "a", arg: 1, scope: !258, file: !229, line: 451, type: !232)
!262 = !DILocation(line: 0, scope: !258)
!263 = !DILocalVariable(name: "v", arg: 2, scope: !258, file: !229, line: 451, type: !11)
!264 = !DILocation(line: 453, column: 2, scope: !258)
!265 = !{i64 2147853148}
!266 = !DILocation(line: 454, column: 23, scope: !258)
!267 = !DILocation(line: 454, column: 2, scope: !258)
!268 = !DILocation(line: 455, column: 2, scope: !258)
!269 = !{i64 2147853194}
!270 = !DILocation(line: 456, column: 1, scope: !258)
!271 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !229, file: !229, line: 178, type: !230, scopeLine: 179, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!272 = !DILocalVariable(name: "a", arg: 1, scope: !271, file: !229, line: 178, type: !232)
!273 = !DILocation(line: 0, scope: !271)
!274 = !DILocation(line: 180, column: 2, scope: !271)
!275 = !{i64 2147851552}
!276 = !DILocation(line: 182, column: 7, scope: !271)
!277 = !DILocation(line: 181, column: 29, scope: !271)
!278 = !DILocalVariable(name: "tmp", scope: !271, file: !229, line: 181, type: !11)
!279 = !DILocation(line: 183, column: 2, scope: !271)
!280 = !{i64 2147851598}
!281 = !DILocation(line: 184, column: 2, scope: !271)
!282 = distinct !DISubprogram(name: "vatomic32_cmpxchg_rlx", scope: !229, file: !229, line: 1136, type: !283, scopeLine: 1137, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!283 = !DISubroutineType(types: !284)
!284 = !{!11, !232, !11, !11}
!285 = !DILocalVariable(name: "a", arg: 1, scope: !282, file: !229, line: 1136, type: !232)
!286 = !DILocation(line: 0, scope: !282)
!287 = !DILocalVariable(name: "e", arg: 2, scope: !282, file: !229, line: 1136, type: !11)
!288 = !DILocalVariable(name: "v", arg: 3, scope: !282, file: !229, line: 1136, type: !11)
!289 = !DILocalVariable(name: "exp", scope: !282, file: !229, line: 1138, type: !11)
!290 = !DILocation(line: 1139, column: 2, scope: !282)
!291 = !{i64 2147857016}
!292 = !DILocation(line: 1140, column: 34, scope: !282)
!293 = !DILocation(line: 1140, column: 2, scope: !282)
!294 = !DILocation(line: 1143, column: 2, scope: !282)
!295 = !{i64 2147857070}
!296 = !DILocation(line: 1144, column: 2, scope: !282)
!297 = distinct !DISubprogram(name: "ticketlock_acquire", scope: !27, file: !27, line: 51, type: !298, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!298 = !DISubroutineType(types: !299)
!299 = !{null, !246}
!300 = !DILocalVariable(name: "l", arg: 1, scope: !297, file: !27, line: 51, type: !246)
!301 = !DILocation(line: 0, scope: !297)
!302 = !DILocation(line: 53, column: 47, scope: !297)
!303 = !DILocation(line: 53, column: 21, scope: !297)
!304 = !DILocalVariable(name: "ticket", scope: !297, file: !27, line: 53, type: !11)
!305 = !DILocation(line: 54, column: 29, scope: !297)
!306 = !DILocation(line: 54, column: 2, scope: !297)
!307 = !DILocation(line: 55, column: 1, scope: !297)
!308 = distinct !DISubprogram(name: "vatomic32_get_inc_rlx", scope: !309, file: !309, line: 2516, type: !230, scopeLine: 2517, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!309 = !DIFile(filename: "./include/vsync/atomic/internal/fallback.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "bfc5d50ad810da3af0d582a48b47498f")
!310 = !DILocalVariable(name: "a", arg: 1, scope: !308, file: !309, line: 2516, type: !232)
!311 = !DILocation(line: 0, scope: !308)
!312 = !DILocation(line: 2518, column: 9, scope: !308)
!313 = !DILocation(line: 2518, column: 2, scope: !308)
!314 = distinct !DISubprogram(name: "vatomic32_await_eq_acq", scope: !309, file: !309, line: 4389, type: !315, scopeLine: 4390, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!315 = !DISubroutineType(types: !316)
!316 = !{!11, !232, !11}
!317 = !DILocalVariable(name: "a", arg: 1, scope: !314, file: !309, line: 4389, type: !232)
!318 = !DILocation(line: 0, scope: !314)
!319 = !DILocalVariable(name: "c", arg: 2, scope: !314, file: !309, line: 4389, type: !11)
!320 = !DILocalVariable(name: "ret", scope: !314, file: !309, line: 4391, type: !11)
!321 = !DILocalVariable(name: "o", scope: !314, file: !309, line: 4392, type: !11)
!322 = !DILocation(line: 4393, column: 2, scope: !314)
!323 = distinct !{!323, !322, !324, !136}
!324 = !DILocation(line: 4396, column: 2, scope: !314)
!325 = !DILocation(line: 4397, column: 2, scope: !314)
!326 = distinct !DISubprogram(name: "vatomic32_get_add_rlx", scope: !229, file: !229, line: 2438, type: !315, scopeLine: 2439, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!327 = !DILocalVariable(name: "a", arg: 1, scope: !326, file: !229, line: 2438, type: !232)
!328 = !DILocation(line: 0, scope: !326)
!329 = !DILocalVariable(name: "v", arg: 2, scope: !326, file: !229, line: 2438, type: !11)
!330 = !DILocation(line: 2440, column: 2, scope: !326)
!331 = !{i64 2147864176}
!332 = !DILocation(line: 2442, column: 7, scope: !326)
!333 = !DILocation(line: 2441, column: 29, scope: !326)
!334 = !DILocalVariable(name: "tmp", scope: !326, file: !229, line: 2441, type: !11)
!335 = !DILocation(line: 2443, column: 2, scope: !326)
!336 = !{i64 2147864222}
!337 = !DILocation(line: 2444, column: 2, scope: !326)
!338 = distinct !DISubprogram(name: "ticketlock_release", scope: !27, file: !27, line: 76, type: !298, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!339 = !DILocalVariable(name: "l", arg: 1, scope: !338, file: !27, line: 76, type: !246)
!340 = !DILocation(line: 0, scope: !338)
!341 = !DILocation(line: 78, column: 43, scope: !338)
!342 = !DILocation(line: 78, column: 20, scope: !338)
!343 = !DILocalVariable(name: "owner", scope: !338, file: !27, line: 78, type: !11)
!344 = !DILocation(line: 79, column: 39, scope: !338)
!345 = !DILocation(line: 79, column: 2, scope: !338)
!346 = !DILocation(line: 80, column: 1, scope: !338)
!347 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !229, file: !229, line: 438, type: !259, scopeLine: 439, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!348 = !DILocalVariable(name: "a", arg: 1, scope: !347, file: !229, line: 438, type: !232)
!349 = !DILocation(line: 0, scope: !347)
!350 = !DILocalVariable(name: "v", arg: 2, scope: !347, file: !229, line: 438, type: !11)
!351 = !DILocation(line: 440, column: 2, scope: !347)
!352 = !{i64 2147853064}
!353 = !DILocation(line: 441, column: 23, scope: !347)
!354 = !DILocation(line: 441, column: 2, scope: !347)
!355 = !DILocation(line: 442, column: 2, scope: !347)
!356 = !{i64 2147853110}
!357 = !DILocation(line: 443, column: 1, scope: !347)
