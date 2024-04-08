; ModuleID = '/home/drc/git/Dat3M/output/ticketlock.ll'
source_filename = "/home/drc/git/libvsync/test/spinlock/ticketlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.ticketlock_s = type { %struct.vatomic32_s, %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !32
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [34 x i8] c"./include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (3 + 0 + 0)\00", align 1
@lock = dso_local global %struct.ticketlock_s zeroinitializer, align 4, !dbg !18

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !43 {
  ret void, !dbg !47
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !48 {
  ret void, !dbg !49
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !50 {
  ret void, !dbg !51
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cs() #0 !dbg !52 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !53
  %2 = add i32 %1, 1, !dbg !53
  store i32 %2, i32* @g_cs_x, align 4, !dbg !53
  %3 = load i32, i32* @g_cs_y, align 4, !dbg !54
  %4 = add i32 %3, 1, !dbg !54
  store i32 %4, i32* @g_cs_y, align 4, !dbg !54
  ret void, !dbg !55
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !56 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !57
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !57
  %3 = icmp eq i32 %1, %2, !dbg !57
  br i1 %3, label %5, label %4, !dbg !60

4:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @.str.1, i64 0, i64 0), i32 noundef 99, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !57
  unreachable, !dbg !57

5:                                                ; preds = %0
  %6 = icmp eq i32 %1, 3, !dbg !61
  br i1 %6, label %8, label %7, !dbg !64

7:                                                ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @.str.1, i64 0, i64 0), i32 noundef 100, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !61
  unreachable, !dbg !61

8:                                                ; preds = %5
  ret void, !dbg !65
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !66 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !70, metadata !DIExpression()), !dbg !76
  call void @init(), !dbg !77
  call void @llvm.dbg.value(metadata i64 0, metadata !78, metadata !DIExpression()), !dbg !80
  call void @llvm.dbg.value(metadata i64 0, metadata !78, metadata !DIExpression()), !dbg !80
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !81
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef null) #6, !dbg !84
  call void @llvm.dbg.value(metadata i64 1, metadata !78, metadata !DIExpression()), !dbg !80
  call void @llvm.dbg.value(metadata i64 1, metadata !78, metadata !DIExpression()), !dbg !80
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !81
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !84
  call void @llvm.dbg.value(metadata i64 2, metadata !78, metadata !DIExpression()), !dbg !80
  call void @llvm.dbg.value(metadata i64 2, metadata !78, metadata !DIExpression()), !dbg !80
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !81
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !84
  call void @llvm.dbg.value(metadata i64 3, metadata !78, metadata !DIExpression()), !dbg !80
  call void @llvm.dbg.value(metadata i64 3, metadata !78, metadata !DIExpression()), !dbg !80
  call void @post(), !dbg !85
  call void @llvm.dbg.value(metadata i64 0, metadata !86, metadata !DIExpression()), !dbg !88
  call void @llvm.dbg.value(metadata i64 0, metadata !86, metadata !DIExpression()), !dbg !88
  %8 = load i64, i64* %2, align 8, !dbg !89
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !92
  call void @llvm.dbg.value(metadata i64 1, metadata !86, metadata !DIExpression()), !dbg !88
  call void @llvm.dbg.value(metadata i64 1, metadata !86, metadata !DIExpression()), !dbg !88
  %10 = load i64, i64* %4, align 8, !dbg !89
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !92
  call void @llvm.dbg.value(metadata i64 2, metadata !86, metadata !DIExpression()), !dbg !88
  call void @llvm.dbg.value(metadata i64 2, metadata !86, metadata !DIExpression()), !dbg !88
  %12 = load i64, i64* %6, align 8, !dbg !89
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !92
  call void @llvm.dbg.value(metadata i64 3, metadata !86, metadata !DIExpression()), !dbg !88
  call void @llvm.dbg.value(metadata i64 3, metadata !86, metadata !DIExpression()), !dbg !88
  call void @check(), !dbg !93
  call void @fini(), !dbg !94
  ret i32 0, !dbg !95
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @run(i8* noundef %0) #0 !dbg !96 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !99, metadata !DIExpression()), !dbg !100
  %2 = ptrtoint i8* %0 to i64, !dbg !101
  %3 = trunc i64 %2 to i32, !dbg !101
  call void @llvm.dbg.value(metadata i32 %3, metadata !102, metadata !DIExpression()), !dbg !100
  call void @verification_loop_bound(i32 noundef 2), !dbg !103
  call void @llvm.dbg.value(metadata i32 0, metadata !104, metadata !DIExpression()), !dbg !106
  br label %4, !dbg !107

4:                                                ; preds = %.critedge7, %1
  %.02 = phi i32 [ 0, %1 ], [ %18, %.critedge7 ], !dbg !106
  call void @llvm.dbg.value(metadata i32 %.02, metadata !104, metadata !DIExpression()), !dbg !106
  switch i32 %.02, label %.critedge5 [
    i32 0, label %.critedge
    i32 1, label %5
  ], !dbg !108

5:                                                ; preds = %4
  %6 = add i32 %3, 1, !dbg !110
  %7 = icmp ult i32 %6, 1, !dbg !110
  br i1 %7, label %.critedge, label %.critedge5, !dbg !111

.critedge:                                        ; preds = %4, %5
  call void @verification_loop_bound(i32 noundef 2), !dbg !112
  call void @llvm.dbg.value(metadata i32 0, metadata !114, metadata !DIExpression()), !dbg !116
  br label %8, !dbg !117

8:                                                ; preds = %.critedge3, %.critedge
  %.01 = phi i32 [ 0, %.critedge ], [ %12, %.critedge3 ], !dbg !116
  call void @llvm.dbg.value(metadata i32 %.01, metadata !114, metadata !DIExpression()), !dbg !116
  switch i32 %.01, label %.critedge6 [
    i32 0, label %.critedge3
    i32 1, label %9
  ], !dbg !118

9:                                                ; preds = %8
  %10 = add i32 %3, 1, !dbg !120
  %11 = icmp ult i32 %10, 1, !dbg !120
  br i1 %11, label %.critedge3, label %.critedge6, !dbg !121

.critedge3:                                       ; preds = %8, %9
  call void @acquire(i32 noundef %3), !dbg !122
  call void @cs(), !dbg !124
  %12 = add nuw nsw i32 %.01, 1, !dbg !125
  call void @llvm.dbg.value(metadata i32 %12, metadata !114, metadata !DIExpression()), !dbg !116
  br label %8, !dbg !126, !llvm.loop !127

.critedge6:                                       ; preds = %8, %9
  call void @verification_loop_bound(i32 noundef 2), !dbg !130
  call void @llvm.dbg.value(metadata i32 0, metadata !131, metadata !DIExpression()), !dbg !133
  br label %13, !dbg !134

13:                                               ; preds = %.critedge4, %.critedge6
  %.0 = phi i32 [ 0, %.critedge6 ], [ %17, %.critedge4 ], !dbg !133
  call void @llvm.dbg.value(metadata i32 %.0, metadata !131, metadata !DIExpression()), !dbg !133
  switch i32 %.0, label %.critedge7 [
    i32 0, label %.critedge4
    i32 1, label %14
  ], !dbg !135

14:                                               ; preds = %13
  %15 = add i32 %3, 1, !dbg !137
  %16 = icmp ult i32 %15, 1, !dbg !137
  br i1 %16, label %.critedge4, label %.critedge7, !dbg !138

.critedge4:                                       ; preds = %13, %14
  call void @release(i32 noundef %3), !dbg !139
  %17 = add nuw nsw i32 %.0, 1, !dbg !141
  call void @llvm.dbg.value(metadata i32 %17, metadata !131, metadata !DIExpression()), !dbg !133
  br label %13, !dbg !142, !llvm.loop !143

.critedge7:                                       ; preds = %13, %14
  %18 = add nuw nsw i32 %.02, 1, !dbg !145
  call void @llvm.dbg.value(metadata i32 %18, metadata !104, metadata !DIExpression()), !dbg !106
  br label %4, !dbg !146, !llvm.loop !147

.critedge5:                                       ; preds = %4, %5
  ret i8* null, !dbg !149
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @acquire(i32 noundef %0) #0 !dbg !150 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !153, metadata !DIExpression()), !dbg !154
  %2 = icmp eq i32 %0, 2, !dbg !155
  br i1 %2, label %3, label %6, !dbg !157

3:                                                ; preds = %3, %1
  %4 = call zeroext i1 @ticketlock_tryacquire(%struct.ticketlock_s* noundef @lock), !dbg !158
  %5 = xor i1 %4, true, !dbg !158
  br i1 %5, label %3, label %7, !dbg !158, !llvm.loop !159

6:                                                ; preds = %1
  call void @ticketlock_acquire(%struct.ticketlock_s* noundef @lock), !dbg !161
  br label %7

7:                                                ; preds = %3, %6
  ret void, !dbg !162
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @ticketlock_tryacquire(%struct.ticketlock_s* noundef %0) #0 !dbg !163 {
  call void @llvm.dbg.value(metadata %struct.ticketlock_s* %0, metadata !169, metadata !DIExpression()), !dbg !170
  %2 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 1, !dbg !171
  %3 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %2), !dbg !172
  call void @llvm.dbg.value(metadata i32 %3, metadata !173, metadata !DIExpression()), !dbg !170
  %4 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 0, !dbg !174
  %5 = add i32 %3, 1, !dbg !175
  %6 = call i32 @vatomic32_cmpxchg_rlx(%struct.vatomic32_s* noundef %4, i32 noundef %3, i32 noundef %5), !dbg !176
  call void @llvm.dbg.value(metadata i32 %6, metadata !177, metadata !DIExpression()), !dbg !170
  %7 = icmp eq i32 %6, %3, !dbg !178
  ret i1 %7, !dbg !179
}

; Function Attrs: noinline nounwind uwtable
define internal void @ticketlock_acquire(%struct.ticketlock_s* noundef %0) #0 !dbg !180 {
  call void @llvm.dbg.value(metadata %struct.ticketlock_s* %0, metadata !183, metadata !DIExpression()), !dbg !184
  %2 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 0, !dbg !185
  %3 = call i32 @vatomic32_get_inc_rlx(%struct.vatomic32_s* noundef %2), !dbg !186
  call void @llvm.dbg.value(metadata i32 %3, metadata !187, metadata !DIExpression()), !dbg !184
  %4 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 1, !dbg !188
  %5 = call i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %4, i32 noundef %3), !dbg !189
  ret void, !dbg !190
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !191 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !192, metadata !DIExpression()), !dbg !193
  call void @ticketlock_release(%struct.ticketlock_s* noundef @lock), !dbg !194
  ret void, !dbg !195
}

; Function Attrs: noinline nounwind uwtable
define internal void @ticketlock_release(%struct.ticketlock_s* noundef %0) #0 !dbg !196 {
  call void @llvm.dbg.value(metadata %struct.ticketlock_s* %0, metadata !197, metadata !DIExpression()), !dbg !198
  %2 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 1, !dbg !199
  %3 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %2), !dbg !200
  call void @llvm.dbg.value(metadata i32 %3, metadata !201, metadata !DIExpression()), !dbg !198
  %4 = add i32 %3, 1, !dbg !202
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %2, i32 noundef %4), !dbg !203
  ret void, !dbg !204
}

; Function Attrs: noinline nounwind uwtable
define internal void @verification_loop_bound(i32 noundef %0) #0 !dbg !205 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !207, metadata !DIExpression()), !dbg !208
  ret void, !dbg !209
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !210 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !215, metadata !DIExpression()), !dbg !216
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !217, !srcloc !218
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !219
  %3 = load atomic i32, i32* %2 acquire, align 4, !dbg !220
  call void @llvm.dbg.value(metadata i32 %3, metadata !221, metadata !DIExpression()), !dbg !216
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !222, !srcloc !223
  ret i32 %3, !dbg !224
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !225 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !228, metadata !DIExpression()), !dbg !229
  call void @llvm.dbg.value(metadata i32 %1, metadata !230, metadata !DIExpression()), !dbg !229
  call void @llvm.dbg.value(metadata i32 %2, metadata !231, metadata !DIExpression()), !dbg !229
  call void @llvm.dbg.value(metadata i32 %1, metadata !232, metadata !DIExpression()), !dbg !229
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !233, !srcloc !234
  %4 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !235
  %5 = cmpxchg i32* %4, i32 %1, i32 %2 monotonic monotonic, align 4, !dbg !236
  %6 = extractvalue { i32, i1 } %5, 0, !dbg !236
  %7 = extractvalue { i32, i1 } %5, 1, !dbg !236
  %spec.select = select i1 %7, i32 %1, i32 %6, !dbg !236
  call void @llvm.dbg.value(metadata i32 %spec.select, metadata !232, metadata !DIExpression()), !dbg !229
  %8 = zext i1 %7 to i8, !dbg !236
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !237, !srcloc !238
  ret i32 %spec.select, !dbg !239
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !240 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !242, metadata !DIExpression()), !dbg !243
  %2 = call i32 @vatomic32_get_add_rlx(%struct.vatomic32_s* noundef %0, i32 noundef 1), !dbg !244
  ret i32 %2, !dbg !245
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !246 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !249, metadata !DIExpression()), !dbg !250
  call void @llvm.dbg.value(metadata i32 %1, metadata !251, metadata !DIExpression()), !dbg !250
  call void @llvm.dbg.value(metadata i32 %1, metadata !252, metadata !DIExpression()), !dbg !250
  call void @llvm.dbg.value(metadata i32 0, metadata !253, metadata !DIExpression()), !dbg !250
  br label %3, !dbg !254

3:                                                ; preds = %3, %2
  %.0 = phi i32 [ %1, %2 ], [ %4, %3 ], !dbg !250
  call void @llvm.dbg.value(metadata i32 %.0, metadata !252, metadata !DIExpression()), !dbg !250
  %4 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0), !dbg !254
  call void @llvm.dbg.value(metadata i32 %4, metadata !253, metadata !DIExpression()), !dbg !250
  %5 = icmp ne i32 %4, %1, !dbg !254
  br i1 %5, label %3, label %6, !dbg !254, !llvm.loop !255

6:                                                ; preds = %3
  ret i32 %.0, !dbg !257
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !258 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !259, metadata !DIExpression()), !dbg !260
  call void @llvm.dbg.value(metadata i32 %1, metadata !261, metadata !DIExpression()), !dbg !260
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !262, !srcloc !263
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !264
  %4 = atomicrmw add i32* %3, i32 %1 monotonic, align 4, !dbg !265
  call void @llvm.dbg.value(metadata i32 %4, metadata !266, metadata !DIExpression()), !dbg !260
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !267, !srcloc !268
  ret i32 %4, !dbg !269
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !270 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !271, metadata !DIExpression()), !dbg !272
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !273, !srcloc !274
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !275
  %3 = load atomic i32, i32* %2 monotonic, align 4, !dbg !276
  call void @llvm.dbg.value(metadata i32 %3, metadata !277, metadata !DIExpression()), !dbg !272
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !278, !srcloc !279
  ret i32 %3, !dbg !280
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !281 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !284, metadata !DIExpression()), !dbg !285
  call void @llvm.dbg.value(metadata i32 %1, metadata !286, metadata !DIExpression()), !dbg !285
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !287, !srcloc !288
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !289
  store atomic i32 %1, i32* %3 release, align 4, !dbg !290
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !291, !srcloc !292
  ret void, !dbg !293
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
!llvm.module.flags = !{!35, !36, !37, !38, !39, !40, !41}
!llvm.ident = !{!42}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !34, line: 87, type: !11, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/libvsync/test/spinlock/ticketlock.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "10658d3294b96dc58a4b6fdbafb3da4d")
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
!17 = !{!18, !0, !32}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !20, line: 8, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "test/spinlock/ticketlock.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "10658d3294b96dc58a4b6fdbafb3da4d")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "ticketlock_t", file: !22, line: 24, baseType: !23)
!22 = !DIFile(filename: "./include/vsync/spinlock/ticketlock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "daf4189859ee3f1df58f186b9f69eee7")
!23 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ticketlock_s", file: !22, line: 21, size: 64, elements: !24)
!24 = !{!25, !31}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !23, file: !22, line: 22, baseType: !26, size: 32, align: 32)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !27, line: 62, baseType: !28)
!27 = !DIFile(filename: "./include/vsync/atomic/core.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "1cc0657a82f0605ef67642f178a77e1c")
!28 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !27, line: 60, size: 32, align: 32, elements: !29)
!29 = !{!30}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !28, file: !27, line: 61, baseType: !11, size: 32)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "owner", scope: !23, file: !22, line: 23, baseType: !26, size: 32, align: 32, offset: 32)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !34, line: 88, type: !11, isLocal: true, isDefinition: true)
!34 = !DIFile(filename: "./include/test/boilerplate/lock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "c9c29de1465ea379ec6432998a180648")
!35 = !{i32 7, !"Dwarf Version", i32 5}
!36 = !{i32 2, !"Debug Info Version", i32 3}
!37 = !{i32 1, !"wchar_size", i32 4}
!38 = !{i32 7, !"PIC Level", i32 2}
!39 = !{i32 7, !"PIE Level", i32 2}
!40 = !{i32 7, !"uwtable", i32 1}
!41 = !{i32 7, !"frame-pointer", i32 2}
!42 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!43 = distinct !DISubprogram(name: "init", scope: !34, file: !34, line: 55, type: !44, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !46)
!44 = !DISubroutineType(types: !45)
!45 = !{null}
!46 = !{}
!47 = !DILocation(line: 57, column: 1, scope: !43)
!48 = distinct !DISubprogram(name: "post", scope: !34, file: !34, line: 64, type: !44, scopeLine: 65, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !46)
!49 = !DILocation(line: 66, column: 1, scope: !48)
!50 = distinct !DISubprogram(name: "fini", scope: !34, file: !34, line: 73, type: !44, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !46)
!51 = !DILocation(line: 75, column: 1, scope: !50)
!52 = distinct !DISubprogram(name: "cs", scope: !34, file: !34, line: 91, type: !44, scopeLine: 92, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !46)
!53 = !DILocation(line: 93, column: 8, scope: !52)
!54 = !DILocation(line: 94, column: 8, scope: !52)
!55 = !DILocation(line: 95, column: 1, scope: !52)
!56 = distinct !DISubprogram(name: "check", scope: !34, file: !34, line: 97, type: !44, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !46)
!57 = !DILocation(line: 99, column: 2, scope: !58)
!58 = distinct !DILexicalBlock(scope: !59, file: !34, line: 99, column: 2)
!59 = distinct !DILexicalBlock(scope: !56, file: !34, line: 99, column: 2)
!60 = !DILocation(line: 99, column: 2, scope: !59)
!61 = !DILocation(line: 100, column: 2, scope: !62)
!62 = distinct !DILexicalBlock(scope: !63, file: !34, line: 100, column: 2)
!63 = distinct !DILexicalBlock(scope: !56, file: !34, line: 100, column: 2)
!64 = !DILocation(line: 100, column: 2, scope: !63)
!65 = !DILocation(line: 101, column: 1, scope: !56)
!66 = distinct !DISubprogram(name: "main", scope: !34, file: !34, line: 136, type: !67, scopeLine: 137, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !46)
!67 = !DISubroutineType(types: !68)
!68 = !{!69}
!69 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!70 = !DILocalVariable(name: "t", scope: !66, file: !34, line: 138, type: !71)
!71 = !DICompositeType(tag: DW_TAG_array_type, baseType: !72, size: 192, elements: !74)
!72 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !73, line: 27, baseType: !10)
!73 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!74 = !{!75}
!75 = !DISubrange(count: 3)
!76 = !DILocation(line: 138, column: 12, scope: !66)
!77 = !DILocation(line: 146, column: 2, scope: !66)
!78 = !DILocalVariable(name: "i", scope: !79, file: !34, line: 148, type: !6)
!79 = distinct !DILexicalBlock(scope: !66, file: !34, line: 148, column: 2)
!80 = !DILocation(line: 0, scope: !79)
!81 = !DILocation(line: 149, column: 25, scope: !82)
!82 = distinct !DILexicalBlock(scope: !83, file: !34, line: 148, column: 44)
!83 = distinct !DILexicalBlock(scope: !79, file: !34, line: 148, column: 2)
!84 = !DILocation(line: 149, column: 9, scope: !82)
!85 = !DILocation(line: 152, column: 2, scope: !66)
!86 = !DILocalVariable(name: "i", scope: !87, file: !34, line: 154, type: !6)
!87 = distinct !DILexicalBlock(scope: !66, file: !34, line: 154, column: 2)
!88 = !DILocation(line: 0, scope: !87)
!89 = !DILocation(line: 155, column: 22, scope: !90)
!90 = distinct !DILexicalBlock(scope: !91, file: !34, line: 154, column: 44)
!91 = distinct !DILexicalBlock(scope: !87, file: !34, line: 154, column: 2)
!92 = !DILocation(line: 155, column: 9, scope: !90)
!93 = !DILocation(line: 163, column: 2, scope: !66)
!94 = !DILocation(line: 164, column: 2, scope: !66)
!95 = !DILocation(line: 166, column: 2, scope: !66)
!96 = distinct !DISubprogram(name: "run", scope: !34, file: !34, line: 111, type: !97, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !46)
!97 = !DISubroutineType(types: !98)
!98 = !{!5, !5}
!99 = !DILocalVariable(name: "arg", arg: 1, scope: !96, file: !34, line: 111, type: !5)
!100 = !DILocation(line: 0, scope: !96)
!101 = !DILocation(line: 113, column: 18, scope: !96)
!102 = !DILocalVariable(name: "tid", scope: !96, file: !34, line: 113, type: !11)
!103 = !DILocation(line: 117, column: 2, scope: !96)
!104 = !DILocalVariable(name: "i", scope: !105, file: !34, line: 118, type: !69)
!105 = distinct !DILexicalBlock(scope: !96, file: !34, line: 118, column: 2)
!106 = !DILocation(line: 0, scope: !105)
!107 = !DILocation(line: 118, column: 7, scope: !105)
!108 = !DILocation(line: 118, column: 25, scope: !109)
!109 = distinct !DILexicalBlock(scope: !105, file: !34, line: 118, column: 2)
!110 = !DILocation(line: 118, column: 28, scope: !109)
!111 = !DILocation(line: 118, column: 2, scope: !105)
!112 = !DILocation(line: 122, column: 3, scope: !113)
!113 = distinct !DILexicalBlock(scope: !109, file: !34, line: 118, column: 60)
!114 = !DILocalVariable(name: "j", scope: !115, file: !34, line: 123, type: !69)
!115 = distinct !DILexicalBlock(scope: !113, file: !34, line: 123, column: 3)
!116 = !DILocation(line: 0, scope: !115)
!117 = !DILocation(line: 123, column: 8, scope: !115)
!118 = !DILocation(line: 123, column: 26, scope: !119)
!119 = distinct !DILexicalBlock(scope: !115, file: !34, line: 123, column: 3)
!120 = !DILocation(line: 123, column: 29, scope: !119)
!121 = !DILocation(line: 123, column: 3, scope: !115)
!122 = !DILocation(line: 124, column: 4, scope: !123)
!123 = distinct !DILexicalBlock(scope: !119, file: !34, line: 123, column: 61)
!124 = !DILocation(line: 125, column: 4, scope: !123)
!125 = !DILocation(line: 123, column: 57, scope: !119)
!126 = !DILocation(line: 123, column: 3, scope: !119)
!127 = distinct !{!127, !121, !128, !129}
!128 = !DILocation(line: 126, column: 3, scope: !115)
!129 = !{!"llvm.loop.mustprogress"}
!130 = !DILocation(line: 127, column: 3, scope: !113)
!131 = !DILocalVariable(name: "j", scope: !132, file: !34, line: 128, type: !69)
!132 = distinct !DILexicalBlock(scope: !113, file: !34, line: 128, column: 3)
!133 = !DILocation(line: 0, scope: !132)
!134 = !DILocation(line: 128, column: 8, scope: !132)
!135 = !DILocation(line: 128, column: 26, scope: !136)
!136 = distinct !DILexicalBlock(scope: !132, file: !34, line: 128, column: 3)
!137 = !DILocation(line: 128, column: 29, scope: !136)
!138 = !DILocation(line: 128, column: 3, scope: !132)
!139 = !DILocation(line: 129, column: 4, scope: !140)
!140 = distinct !DILexicalBlock(scope: !136, file: !34, line: 128, column: 61)
!141 = !DILocation(line: 128, column: 57, scope: !136)
!142 = !DILocation(line: 128, column: 3, scope: !136)
!143 = distinct !{!143, !138, !144, !129}
!144 = !DILocation(line: 130, column: 3, scope: !132)
!145 = !DILocation(line: 118, column: 56, scope: !109)
!146 = !DILocation(line: 118, column: 2, scope: !109)
!147 = distinct !{!147, !111, !148, !129}
!148 = !DILocation(line: 131, column: 2, scope: !105)
!149 = !DILocation(line: 132, column: 2, scope: !96)
!150 = distinct !DISubprogram(name: "acquire", scope: !20, file: !20, line: 11, type: !151, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !46)
!151 = !DISubroutineType(types: !152)
!152 = !{null, !11}
!153 = !DILocalVariable(name: "tid", arg: 1, scope: !150, file: !20, line: 11, type: !11)
!154 = !DILocation(line: 0, scope: !150)
!155 = !DILocation(line: 13, column: 10, scope: !156)
!156 = distinct !DILexicalBlock(scope: !150, file: !20, line: 13, column: 6)
!157 = !DILocation(line: 13, column: 6, scope: !150)
!158 = !DILocation(line: 14, column: 3, scope: !156)
!159 = distinct !{!159, !158, !160, !129}
!160 = !DILocation(line: 15, column: 4, scope: !156)
!161 = !DILocation(line: 17, column: 3, scope: !156)
!162 = !DILocation(line: 18, column: 1, scope: !150)
!163 = distinct !DISubprogram(name: "ticketlock_tryacquire", scope: !22, file: !22, line: 64, type: !164, scopeLine: 65, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !46)
!164 = !DISubroutineType(types: !165)
!165 = !{!166, !168}
!166 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !7, line: 43, baseType: !167)
!167 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!168 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!169 = !DILocalVariable(name: "l", arg: 1, scope: !163, file: !22, line: 64, type: !168)
!170 = !DILocation(line: 0, scope: !163)
!171 = !DILocation(line: 66, column: 39, scope: !163)
!172 = !DILocation(line: 66, column: 16, scope: !163)
!173 = !DILocalVariable(name: "o", scope: !163, file: !22, line: 66, type: !11)
!174 = !DILocation(line: 67, column: 42, scope: !163)
!175 = !DILocation(line: 67, column: 53, scope: !163)
!176 = !DILocation(line: 67, column: 16, scope: !163)
!177 = !DILocalVariable(name: "n", scope: !163, file: !22, line: 67, type: !11)
!178 = !DILocation(line: 68, column: 11, scope: !163)
!179 = !DILocation(line: 68, column: 2, scope: !163)
!180 = distinct !DISubprogram(name: "ticketlock_acquire", scope: !22, file: !22, line: 51, type: !181, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !46)
!181 = !DISubroutineType(types: !182)
!182 = !{null, !168}
!183 = !DILocalVariable(name: "l", arg: 1, scope: !180, file: !22, line: 51, type: !168)
!184 = !DILocation(line: 0, scope: !180)
!185 = !DILocation(line: 53, column: 47, scope: !180)
!186 = !DILocation(line: 53, column: 21, scope: !180)
!187 = !DILocalVariable(name: "ticket", scope: !180, file: !22, line: 53, type: !11)
!188 = !DILocation(line: 54, column: 29, scope: !180)
!189 = !DILocation(line: 54, column: 2, scope: !180)
!190 = !DILocation(line: 55, column: 1, scope: !180)
!191 = distinct !DISubprogram(name: "release", scope: !20, file: !20, line: 21, type: !151, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !46)
!192 = !DILocalVariable(name: "tid", arg: 1, scope: !191, file: !20, line: 21, type: !11)
!193 = !DILocation(line: 0, scope: !191)
!194 = !DILocation(line: 24, column: 2, scope: !191)
!195 = !DILocation(line: 25, column: 1, scope: !191)
!196 = distinct !DISubprogram(name: "ticketlock_release", scope: !22, file: !22, line: 76, type: !181, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !46)
!197 = !DILocalVariable(name: "l", arg: 1, scope: !196, file: !22, line: 76, type: !168)
!198 = !DILocation(line: 0, scope: !196)
!199 = !DILocation(line: 78, column: 43, scope: !196)
!200 = !DILocation(line: 78, column: 20, scope: !196)
!201 = !DILocalVariable(name: "owner", scope: !196, file: !22, line: 78, type: !11)
!202 = !DILocation(line: 79, column: 39, scope: !196)
!203 = !DILocation(line: 79, column: 2, scope: !196)
!204 = !DILocation(line: 80, column: 1, scope: !196)
!205 = distinct !DISubprogram(name: "verification_loop_bound", scope: !206, file: !206, line: 80, type: !151, scopeLine: 81, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !46)
!206 = !DIFile(filename: "./include/vsync/common/verify.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "3a0b94d9e7ec6d94ef39ae9297c4bc2a")
!207 = !DILocalVariable(name: "bound", arg: 1, scope: !205, file: !206, line: 80, type: !11)
!208 = !DILocation(line: 0, scope: !205)
!209 = !DILocation(line: 83, column: 1, scope: !205)
!210 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !211, file: !211, line: 178, type: !212, scopeLine: 179, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !46)
!211 = !DIFile(filename: "./include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "31d9a9647b315cadb2f817a7c8e98ecf")
!212 = !DISubroutineType(types: !213)
!213 = !{!11, !214}
!214 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!215 = !DILocalVariable(name: "a", arg: 1, scope: !210, file: !211, line: 178, type: !214)
!216 = !DILocation(line: 0, scope: !210)
!217 = !DILocation(line: 180, column: 2, scope: !210)
!218 = !{i64 2147851600}
!219 = !DILocation(line: 182, column: 7, scope: !210)
!220 = !DILocation(line: 181, column: 29, scope: !210)
!221 = !DILocalVariable(name: "tmp", scope: !210, file: !211, line: 181, type: !11)
!222 = !DILocation(line: 183, column: 2, scope: !210)
!223 = !{i64 2147851646}
!224 = !DILocation(line: 184, column: 2, scope: !210)
!225 = distinct !DISubprogram(name: "vatomic32_cmpxchg_rlx", scope: !211, file: !211, line: 1136, type: !226, scopeLine: 1137, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !46)
!226 = !DISubroutineType(types: !227)
!227 = !{!11, !214, !11, !11}
!228 = !DILocalVariable(name: "a", arg: 1, scope: !225, file: !211, line: 1136, type: !214)
!229 = !DILocation(line: 0, scope: !225)
!230 = !DILocalVariable(name: "e", arg: 2, scope: !225, file: !211, line: 1136, type: !11)
!231 = !DILocalVariable(name: "v", arg: 3, scope: !225, file: !211, line: 1136, type: !11)
!232 = !DILocalVariable(name: "exp", scope: !225, file: !211, line: 1138, type: !11)
!233 = !DILocation(line: 1139, column: 2, scope: !225)
!234 = !{i64 2147857064}
!235 = !DILocation(line: 1140, column: 34, scope: !225)
!236 = !DILocation(line: 1140, column: 2, scope: !225)
!237 = !DILocation(line: 1143, column: 2, scope: !225)
!238 = !{i64 2147857118}
!239 = !DILocation(line: 1144, column: 2, scope: !225)
!240 = distinct !DISubprogram(name: "vatomic32_get_inc_rlx", scope: !241, file: !241, line: 2516, type: !212, scopeLine: 2517, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !46)
!241 = !DIFile(filename: "./include/vsync/atomic/internal/fallback.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "bfc5d50ad810da3af0d582a48b47498f")
!242 = !DILocalVariable(name: "a", arg: 1, scope: !240, file: !241, line: 2516, type: !214)
!243 = !DILocation(line: 0, scope: !240)
!244 = !DILocation(line: 2518, column: 9, scope: !240)
!245 = !DILocation(line: 2518, column: 2, scope: !240)
!246 = distinct !DISubprogram(name: "vatomic32_await_eq_acq", scope: !241, file: !241, line: 4389, type: !247, scopeLine: 4390, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !46)
!247 = !DISubroutineType(types: !248)
!248 = !{!11, !214, !11}
!249 = !DILocalVariable(name: "a", arg: 1, scope: !246, file: !241, line: 4389, type: !214)
!250 = !DILocation(line: 0, scope: !246)
!251 = !DILocalVariable(name: "c", arg: 2, scope: !246, file: !241, line: 4389, type: !11)
!252 = !DILocalVariable(name: "ret", scope: !246, file: !241, line: 4391, type: !11)
!253 = !DILocalVariable(name: "o", scope: !246, file: !241, line: 4392, type: !11)
!254 = !DILocation(line: 4393, column: 2, scope: !246)
!255 = distinct !{!255, !254, !256, !129}
!256 = !DILocation(line: 4396, column: 2, scope: !246)
!257 = !DILocation(line: 4397, column: 2, scope: !246)
!258 = distinct !DISubprogram(name: "vatomic32_get_add_rlx", scope: !211, file: !211, line: 2438, type: !247, scopeLine: 2439, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !46)
!259 = !DILocalVariable(name: "a", arg: 1, scope: !258, file: !211, line: 2438, type: !214)
!260 = !DILocation(line: 0, scope: !258)
!261 = !DILocalVariable(name: "v", arg: 2, scope: !258, file: !211, line: 2438, type: !11)
!262 = !DILocation(line: 2440, column: 2, scope: !258)
!263 = !{i64 2147864224}
!264 = !DILocation(line: 2442, column: 7, scope: !258)
!265 = !DILocation(line: 2441, column: 29, scope: !258)
!266 = !DILocalVariable(name: "tmp", scope: !258, file: !211, line: 2441, type: !11)
!267 = !DILocation(line: 2443, column: 2, scope: !258)
!268 = !{i64 2147864270}
!269 = !DILocation(line: 2444, column: 2, scope: !258)
!270 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !211, file: !211, line: 193, type: !212, scopeLine: 194, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !46)
!271 = !DILocalVariable(name: "a", arg: 1, scope: !270, file: !211, line: 193, type: !214)
!272 = !DILocation(line: 0, scope: !270)
!273 = !DILocation(line: 195, column: 2, scope: !270)
!274 = !{i64 2147851684}
!275 = !DILocation(line: 197, column: 7, scope: !270)
!276 = !DILocation(line: 196, column: 29, scope: !270)
!277 = !DILocalVariable(name: "tmp", scope: !270, file: !211, line: 196, type: !11)
!278 = !DILocation(line: 198, column: 2, scope: !270)
!279 = !{i64 2147851730}
!280 = !DILocation(line: 199, column: 2, scope: !270)
!281 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !211, file: !211, line: 438, type: !282, scopeLine: 439, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !46)
!282 = !DISubroutineType(types: !283)
!283 = !{null, !214, !11}
!284 = !DILocalVariable(name: "a", arg: 1, scope: !281, file: !211, line: 438, type: !214)
!285 = !DILocation(line: 0, scope: !281)
!286 = !DILocalVariable(name: "v", arg: 2, scope: !281, file: !211, line: 438, type: !11)
!287 = !DILocation(line: 440, column: 2, scope: !281)
!288 = !{i64 2147853112}
!289 = !DILocation(line: 441, column: 23, scope: !281)
!290 = !DILocation(line: 441, column: 2, scope: !281)
!291 = !DILocation(line: 442, column: 2, scope: !281)
!292 = !{i64 2147853158}
!293 = !DILocation(line: 443, column: 1, scope: !281)
