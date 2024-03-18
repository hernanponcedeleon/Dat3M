; ModuleID = '/home/drc/git/Dat3M/output/rec_mcslock.ll'
source_filename = "/home/drc/git/libvsync/test/spinlock/rec_mcslock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.rec_mcslock_s = type { %struct.mcslock_s, %struct.vatomic32_s, i32 }
%struct.mcslock_s = type { %struct.vatomicptr_s }
%struct.vatomicptr_s = type { i8* }
%struct.vatomic32_s = type { i32 }
%struct.mcs_node_s = type { %struct.vatomicptr_s, %struct.vatomic32_s }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !53
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [34 x i8] c"./include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (3 + 0 + 1)\00", align 1
@lock = dso_local global %struct.rec_mcslock_s { %struct.mcslock_s zeroinitializer, %struct.vatomic32_s { i32 -1 }, i32 0 }, align 8, !dbg !34
@nodes = dso_local global [3 x %struct.mcs_node_s] zeroinitializer, align 16, !dbg !48
@.str.3 = private unnamed_addr constant [23 x i8] c"this value is reserved\00", align 1
@.str.4 = private unnamed_addr constant [48 x i8] c"id != (4294967295U) && \22this value is reserved\22\00", align 1
@.str.5 = private unnamed_addr constant [39 x i8] c"./include/vsync/spinlock/rec_mcslock.h\00", align 1
@__PRETTY_FUNCTION__.rec_mcslock_acquire = private unnamed_addr constant [67 x i8] c"void rec_mcslock_acquire(rec_mcslock_t *, vuint32_t, mcs_node_t *)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !64 {
  ret void, !dbg !68
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !69 {
  ret void, !dbg !70
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !71 {
  ret void, !dbg !72
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cs() #0 !dbg !73 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !74
  %2 = add i32 %1, 1, !dbg !74
  store i32 %2, i32* @g_cs_x, align 4, !dbg !74
  %3 = load i32, i32* @g_cs_y, align 4, !dbg !75
  %4 = add i32 %3, 1, !dbg !75
  store i32 %4, i32* @g_cs_y, align 4, !dbg !75
  ret void, !dbg !76
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !77 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !78
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !78
  %3 = icmp eq i32 %1, %2, !dbg !78
  br i1 %3, label %5, label %4, !dbg !81

4:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @.str.1, i64 0, i64 0), i32 noundef 99, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !78
  unreachable, !dbg !78

5:                                                ; preds = %0
  %6 = icmp eq i32 %1, 4, !dbg !82
  br i1 %6, label %8, label %7, !dbg !85

7:                                                ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @.str.1, i64 0, i64 0), i32 noundef 100, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !82
  unreachable, !dbg !82

8:                                                ; preds = %5
  ret void, !dbg !86
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !87 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !91, metadata !DIExpression()), !dbg !95
  call void @init(), !dbg !96
  call void @llvm.dbg.value(metadata i64 0, metadata !97, metadata !DIExpression()), !dbg !99
  call void @llvm.dbg.value(metadata i64 0, metadata !97, metadata !DIExpression()), !dbg !99
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !100
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef null) #6, !dbg !103
  call void @llvm.dbg.value(metadata i64 1, metadata !97, metadata !DIExpression()), !dbg !99
  call void @llvm.dbg.value(metadata i64 1, metadata !97, metadata !DIExpression()), !dbg !99
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !100
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !103
  call void @llvm.dbg.value(metadata i64 2, metadata !97, metadata !DIExpression()), !dbg !99
  call void @llvm.dbg.value(metadata i64 2, metadata !97, metadata !DIExpression()), !dbg !99
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !100
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !103
  call void @llvm.dbg.value(metadata i64 3, metadata !97, metadata !DIExpression()), !dbg !99
  call void @llvm.dbg.value(metadata i64 3, metadata !97, metadata !DIExpression()), !dbg !99
  call void @post(), !dbg !104
  call void @llvm.dbg.value(metadata i64 0, metadata !105, metadata !DIExpression()), !dbg !107
  call void @llvm.dbg.value(metadata i64 0, metadata !105, metadata !DIExpression()), !dbg !107
  %8 = load i64, i64* %2, align 8, !dbg !108
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !111
  call void @llvm.dbg.value(metadata i64 1, metadata !105, metadata !DIExpression()), !dbg !107
  call void @llvm.dbg.value(metadata i64 1, metadata !105, metadata !DIExpression()), !dbg !107
  %10 = load i64, i64* %4, align 8, !dbg !108
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !111
  call void @llvm.dbg.value(metadata i64 2, metadata !105, metadata !DIExpression()), !dbg !107
  call void @llvm.dbg.value(metadata i64 2, metadata !105, metadata !DIExpression()), !dbg !107
  %12 = load i64, i64* %6, align 8, !dbg !108
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !111
  call void @llvm.dbg.value(metadata i64 3, metadata !105, metadata !DIExpression()), !dbg !107
  call void @llvm.dbg.value(metadata i64 3, metadata !105, metadata !DIExpression()), !dbg !107
  call void @check(), !dbg !112
  call void @fini(), !dbg !113
  ret i32 0, !dbg !114
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @run(i8* noundef %0) #0 !dbg !115 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !118, metadata !DIExpression()), !dbg !119
  %2 = ptrtoint i8* %0 to i64, !dbg !120
  %3 = trunc i64 %2 to i32, !dbg !120
  call void @llvm.dbg.value(metadata i32 %3, metadata !121, metadata !DIExpression()), !dbg !119
  call void @verification_loop_bound(i32 noundef 2), !dbg !122
  call void @llvm.dbg.value(metadata i32 0, metadata !123, metadata !DIExpression()), !dbg !125
  br label %4, !dbg !126

4:                                                ; preds = %.critedge7, %1
  %.02 = phi i32 [ 0, %1 ], [ %18, %.critedge7 ], !dbg !125
  call void @llvm.dbg.value(metadata i32 %.02, metadata !123, metadata !DIExpression()), !dbg !125
  switch i32 %.02, label %.critedge5 [
    i32 0, label %.critedge
    i32 1, label %5
  ], !dbg !127

5:                                                ; preds = %4
  %6 = add i32 %3, 1, !dbg !129
  %7 = icmp ult i32 %6, 1, !dbg !129
  br i1 %7, label %.critedge, label %.critedge5, !dbg !130

.critedge:                                        ; preds = %4, %5
  call void @verification_loop_bound(i32 noundef 3), !dbg !131
  call void @llvm.dbg.value(metadata i32 0, metadata !133, metadata !DIExpression()), !dbg !135
  br label %8, !dbg !136

8:                                                ; preds = %.critedge3, %.critedge
  %.01 = phi i32 [ 0, %.critedge ], [ %12, %.critedge3 ], !dbg !135
  call void @llvm.dbg.value(metadata i32 %.01, metadata !133, metadata !DIExpression()), !dbg !135
  switch i32 %.01, label %.critedge6 [
    i32 0, label %.critedge3
    i32 1, label %9
  ], !dbg !137

9:                                                ; preds = %8
  %10 = add i32 %3, 1, !dbg !139
  %11 = icmp ult i32 %10, 2, !dbg !139
  br i1 %11, label %.critedge3, label %.critedge6, !dbg !140

.critedge3:                                       ; preds = %8, %9
  call void @acquire(i32 noundef %3), !dbg !141
  call void @cs(), !dbg !143
  %12 = add nuw nsw i32 %.01, 1, !dbg !144
  call void @llvm.dbg.value(metadata i32 %12, metadata !133, metadata !DIExpression()), !dbg !135
  br label %8, !dbg !145, !llvm.loop !146

.critedge6:                                       ; preds = %8, %9
  call void @verification_loop_bound(i32 noundef 3), !dbg !149
  call void @llvm.dbg.value(metadata i32 0, metadata !150, metadata !DIExpression()), !dbg !152
  br label %13, !dbg !153

13:                                               ; preds = %.critedge4, %.critedge6
  %.0 = phi i32 [ 0, %.critedge6 ], [ %17, %.critedge4 ], !dbg !152
  call void @llvm.dbg.value(metadata i32 %.0, metadata !150, metadata !DIExpression()), !dbg !152
  switch i32 %.0, label %.critedge7 [
    i32 0, label %.critedge4
    i32 1, label %14
  ], !dbg !154

14:                                               ; preds = %13
  %15 = add i32 %3, 1, !dbg !156
  %16 = icmp ult i32 %15, 2, !dbg !156
  br i1 %16, label %.critedge4, label %.critedge7, !dbg !157

.critedge4:                                       ; preds = %13, %14
  call void @release(i32 noundef %3), !dbg !158
  %17 = add nuw nsw i32 %.0, 1, !dbg !160
  call void @llvm.dbg.value(metadata i32 %17, metadata !150, metadata !DIExpression()), !dbg !152
  br label %13, !dbg !161, !llvm.loop !162

.critedge7:                                       ; preds = %13, %14
  %18 = add nuw nsw i32 %.02, 1, !dbg !164
  call void @llvm.dbg.value(metadata i32 %18, metadata !123, metadata !DIExpression()), !dbg !125
  br label %4, !dbg !165, !llvm.loop !166

.critedge5:                                       ; preds = %4, %5
  ret i8* null, !dbg !168
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @acquire(i32 noundef %0) #0 !dbg !169 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !172, metadata !DIExpression()), !dbg !173
  %2 = zext i32 %0 to i64, !dbg !174
  %3 = getelementptr inbounds [3 x %struct.mcs_node_s], [3 x %struct.mcs_node_s]* @nodes, i64 0, i64 %2, !dbg !174
  call void @rec_mcslock_acquire(%struct.rec_mcslock_s* noundef @lock, i32 noundef %0, %struct.mcs_node_s* noundef %3), !dbg !175
  ret void, !dbg !176
}

; Function Attrs: noinline nounwind uwtable
define internal void @rec_mcslock_acquire(%struct.rec_mcslock_s* noundef %0, i32 noundef %1, %struct.mcs_node_s* noundef %2) #0 !dbg !177 {
  call void @llvm.dbg.value(metadata %struct.rec_mcslock_s* %0, metadata !181, metadata !DIExpression()), !dbg !182
  call void @llvm.dbg.value(metadata i32 %1, metadata !183, metadata !DIExpression()), !dbg !182
  call void @llvm.dbg.value(metadata %struct.mcs_node_s* %2, metadata !184, metadata !DIExpression()), !dbg !182
  %4 = icmp ne i32 %1, -1, !dbg !185
  br i1 %4, label %6, label %5, !dbg !185

5:                                                ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([39 x i8], [39 x i8]* @.str.5, i64 0, i64 0), i32 noundef 27, i8* noundef getelementptr inbounds ([67 x i8], [67 x i8]* @__PRETTY_FUNCTION__.rec_mcslock_acquire, i64 0, i64 0)) #5, !dbg !185
  unreachable, !dbg !185

6:                                                ; preds = %3
  %7 = getelementptr inbounds %struct.rec_mcslock_s, %struct.rec_mcslock_s* %0, i32 0, i32 1, !dbg !188
  %8 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %7), !dbg !188
  %9 = icmp eq i32 %8, %1, !dbg !188
  br i1 %9, label %10, label %14, !dbg !190

10:                                               ; preds = %6
  %11 = getelementptr inbounds %struct.rec_mcslock_s, %struct.rec_mcslock_s* %0, i32 0, i32 2, !dbg !191
  %12 = load i32, i32* %11, align 4, !dbg !191
  %13 = add i32 %12, 1, !dbg !191
  store i32 %13, i32* %11, align 4, !dbg !191
  br label %16, !dbg !191

14:                                               ; preds = %6
  %15 = getelementptr inbounds %struct.rec_mcslock_s, %struct.rec_mcslock_s* %0, i32 0, i32 0, !dbg !190
  call void @mcslock_acquire(%struct.mcslock_s* noundef %15, %struct.mcs_node_s* noundef %2), !dbg !190
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %7, i32 noundef %1), !dbg !190
  br label %16, !dbg !190

16:                                               ; preds = %14, %10
  ret void, !dbg !190
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !193 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !194, metadata !DIExpression()), !dbg !195
  %2 = zext i32 %0 to i64, !dbg !196
  %3 = getelementptr inbounds [3 x %struct.mcs_node_s], [3 x %struct.mcs_node_s]* @nodes, i64 0, i64 %2, !dbg !196
  call void @rec_mcslock_release(%struct.rec_mcslock_s* noundef @lock, %struct.mcs_node_s* noundef %3), !dbg !197
  ret void, !dbg !198
}

; Function Attrs: noinline nounwind uwtable
define internal void @rec_mcslock_release(%struct.rec_mcslock_s* noundef %0, %struct.mcs_node_s* noundef %1) #0 !dbg !199 {
  call void @llvm.dbg.value(metadata %struct.rec_mcslock_s* %0, metadata !202, metadata !DIExpression()), !dbg !203
  call void @llvm.dbg.value(metadata %struct.mcs_node_s* %1, metadata !204, metadata !DIExpression()), !dbg !203
  %3 = getelementptr inbounds %struct.rec_mcslock_s, %struct.rec_mcslock_s* %0, i32 0, i32 2, !dbg !205
  %4 = load i32, i32* %3, align 4, !dbg !205
  %5 = icmp eq i32 %4, 0, !dbg !205
  br i1 %5, label %6, label %9, !dbg !207

6:                                                ; preds = %2
  %7 = getelementptr inbounds %struct.rec_mcslock_s, %struct.rec_mcslock_s* %0, i32 0, i32 1, !dbg !208
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %7, i32 noundef -1), !dbg !208
  %8 = getelementptr inbounds %struct.rec_mcslock_s, %struct.rec_mcslock_s* %0, i32 0, i32 0, !dbg !208
  call void @mcslock_release(%struct.mcslock_s* noundef %8, %struct.mcs_node_s* noundef %1), !dbg !208
  br label %11, !dbg !208

9:                                                ; preds = %2
  %10 = add i32 %4, -1, !dbg !210
  store i32 %10, i32* %3, align 4, !dbg !210
  br label %11

11:                                               ; preds = %9, %6
  ret void, !dbg !207
}

; Function Attrs: noinline nounwind uwtable
define internal void @verification_loop_bound(i32 noundef %0) #0 !dbg !212 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !214, metadata !DIExpression()), !dbg !215
  ret void, !dbg !216
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !217 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !222, metadata !DIExpression()), !dbg !223
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !224, !srcloc !225
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !226
  %3 = load atomic i32, i32* %2 monotonic, align 4, !dbg !227
  call void @llvm.dbg.value(metadata i32 %3, metadata !228, metadata !DIExpression()), !dbg !223
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !229, !srcloc !230
  ret i32 %3, !dbg !231
}

; Function Attrs: noinline nounwind uwtable
define internal void @mcslock_acquire(%struct.mcslock_s* noundef %0, %struct.mcs_node_s* noundef %1) #0 !dbg !232 {
  call void @llvm.dbg.value(metadata %struct.mcslock_s* %0, metadata !236, metadata !DIExpression()), !dbg !237
  call void @llvm.dbg.value(metadata %struct.mcs_node_s* %1, metadata !238, metadata !DIExpression()), !dbg !237
  %3 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %1, i32 0, i32 0, !dbg !239
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %3, i8* noundef null), !dbg !240
  %4 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %1, i32 0, i32 1, !dbg !241
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %4, i32 noundef 1), !dbg !242
  %5 = getelementptr inbounds %struct.mcslock_s, %struct.mcslock_s* %0, i32 0, i32 0, !dbg !243
  %6 = bitcast %struct.mcs_node_s* %1 to i8*, !dbg !244
  %7 = call i8* @vatomicptr_xchg(%struct.vatomicptr_s* noundef %5, i8* noundef %6), !dbg !245
  %8 = bitcast i8* %7 to %struct.mcs_node_s*, !dbg !246
  call void @llvm.dbg.value(metadata %struct.mcs_node_s* %8, metadata !247, metadata !DIExpression()), !dbg !237
  %9 = icmp ne %struct.mcs_node_s* %8, null, !dbg !248
  br i1 %9, label %10, label %13, !dbg !250

10:                                               ; preds = %2
  %11 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %8, i32 0, i32 0, !dbg !251
  call void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %11, i8* noundef %6), !dbg !253
  %12 = call i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %4, i32 noundef 0), !dbg !254
  br label %13, !dbg !255

13:                                               ; preds = %10, %2
  ret void, !dbg !256
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !257 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !260, metadata !DIExpression()), !dbg !261
  call void @llvm.dbg.value(metadata i32 %1, metadata !262, metadata !DIExpression()), !dbg !261
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !263, !srcloc !264
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !265
  store atomic i32 %1, i32* %3 monotonic, align 4, !dbg !266
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !267, !srcloc !268
  ret void, !dbg !269
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !270 {
  call void @llvm.dbg.value(metadata %struct.vatomicptr_s* %0, metadata !274, metadata !DIExpression()), !dbg !275
  call void @llvm.dbg.value(metadata i8* %1, metadata !276, metadata !DIExpression()), !dbg !275
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !277, !srcloc !278
  %3 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %0, i32 0, i32 0, !dbg !279
  %4 = bitcast i8** %3 to i64*, !dbg !280
  %5 = ptrtoint i8* %1 to i64, !dbg !280
  store atomic i64 %5, i64* %4 monotonic, align 8, !dbg !280
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !281, !srcloc !282
  ret void, !dbg !283
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_xchg(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !284 {
  call void @llvm.dbg.value(metadata %struct.vatomicptr_s* %0, metadata !287, metadata !DIExpression()), !dbg !288
  call void @llvm.dbg.value(metadata i8* %1, metadata !289, metadata !DIExpression()), !dbg !288
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !290, !srcloc !291
  %3 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %0, i32 0, i32 0, !dbg !292
  %4 = bitcast i8** %3 to i64*, !dbg !293
  %5 = ptrtoint i8* %1 to i64, !dbg !293
  %6 = atomicrmw xchg i64* %4, i64 %5 seq_cst, align 8, !dbg !293
  %7 = inttoptr i64 %6 to i8*, !dbg !293
  call void @llvm.dbg.value(metadata i8* %7, metadata !294, metadata !DIExpression()), !dbg !288
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !295, !srcloc !296
  ret i8* %7, !dbg !297
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !298 {
  call void @llvm.dbg.value(metadata %struct.vatomicptr_s* %0, metadata !299, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata i8* %1, metadata !301, metadata !DIExpression()), !dbg !300
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !302, !srcloc !303
  %3 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %0, i32 0, i32 0, !dbg !304
  %4 = bitcast i8** %3 to i64*, !dbg !305
  %5 = ptrtoint i8* %1 to i64, !dbg !305
  store atomic i64 %5, i64* %4 release, align 8, !dbg !305
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !306, !srcloc !307
  ret void, !dbg !308
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !309 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !313, metadata !DIExpression()), !dbg !314
  call void @llvm.dbg.value(metadata i32 %1, metadata !315, metadata !DIExpression()), !dbg !314
  call void @llvm.dbg.value(metadata i32 %1, metadata !316, metadata !DIExpression()), !dbg !314
  call void @llvm.dbg.value(metadata i32 0, metadata !317, metadata !DIExpression()), !dbg !314
  br label %3, !dbg !318

3:                                                ; preds = %3, %2
  %.0 = phi i32 [ %1, %2 ], [ %4, %3 ], !dbg !314
  call void @llvm.dbg.value(metadata i32 %.0, metadata !316, metadata !DIExpression()), !dbg !314
  %4 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0), !dbg !318
  call void @llvm.dbg.value(metadata i32 %4, metadata !317, metadata !DIExpression()), !dbg !314
  %5 = icmp ne i32 %4, %1, !dbg !318
  br i1 %5, label %3, label %6, !dbg !318, !llvm.loop !319

6:                                                ; preds = %3
  ret i32 %.0, !dbg !321
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !322 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !323, metadata !DIExpression()), !dbg !324
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !325, !srcloc !326
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !327
  %3 = load atomic i32, i32* %2 acquire, align 4, !dbg !328
  call void @llvm.dbg.value(metadata i32 %3, metadata !329, metadata !DIExpression()), !dbg !324
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !330, !srcloc !331
  ret i32 %3, !dbg !332
}

; Function Attrs: noinline nounwind uwtable
define internal void @mcslock_release(%struct.mcslock_s* noundef %0, %struct.mcs_node_s* noundef %1) #0 !dbg !333 {
  call void @llvm.dbg.value(metadata %struct.mcslock_s* %0, metadata !334, metadata !DIExpression()), !dbg !335
  call void @llvm.dbg.value(metadata %struct.mcs_node_s* %1, metadata !336, metadata !DIExpression()), !dbg !335
  %3 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %1, i32 0, i32 0, !dbg !337
  %4 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %3), !dbg !339
  %5 = icmp eq i8* %4, null, !dbg !340
  br i1 %5, label %6, label %14, !dbg !341

6:                                                ; preds = %2
  %7 = getelementptr inbounds %struct.mcslock_s, %struct.mcslock_s* %0, i32 0, i32 0, !dbg !342
  %8 = bitcast %struct.mcs_node_s* %1 to i8*, !dbg !344
  %9 = call i8* @vatomicptr_cmpxchg_rel(%struct.vatomicptr_s* noundef %7, i8* noundef %8, i8* noundef null), !dbg !345
  %10 = bitcast i8* %9 to %struct.mcs_node_s*, !dbg !346
  call void @llvm.dbg.value(metadata %struct.mcs_node_s* %10, metadata !347, metadata !DIExpression()), !dbg !335
  %11 = icmp eq %struct.mcs_node_s* %10, %1, !dbg !348
  br i1 %11, label %18, label %12, !dbg !350

12:                                               ; preds = %6
  %13 = call i8* @vatomicptr_await_neq_rlx(%struct.vatomicptr_s* noundef %3, i8* noundef null), !dbg !351
  br label %14, !dbg !352

14:                                               ; preds = %12, %2
  %15 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %3), !dbg !353
  %16 = bitcast i8* %15 to %struct.mcs_node_s*, !dbg !354
  call void @llvm.dbg.value(metadata %struct.mcs_node_s* %16, metadata !347, metadata !DIExpression()), !dbg !335
  %17 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %16, i32 0, i32 1, !dbg !355
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %17, i32 noundef 0), !dbg !356
  br label %18, !dbg !357

18:                                               ; preds = %6, %14
  ret void, !dbg !357
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %0) #0 !dbg !358 {
  call void @llvm.dbg.value(metadata %struct.vatomicptr_s* %0, metadata !361, metadata !DIExpression()), !dbg !362
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !363, !srcloc !364
  %2 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %0, i32 0, i32 0, !dbg !365
  %3 = bitcast i8** %2 to i64*, !dbg !366
  %4 = load atomic i64, i64* %3 monotonic, align 8, !dbg !366
  %5 = inttoptr i64 %4 to i8*, !dbg !366
  call void @llvm.dbg.value(metadata i8* %5, metadata !367, metadata !DIExpression()), !dbg !362
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !368, !srcloc !369
  ret i8* %5, !dbg !370
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_cmpxchg_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1, i8* noundef %2) #0 !dbg !371 {
  call void @llvm.dbg.value(metadata %struct.vatomicptr_s* %0, metadata !374, metadata !DIExpression()), !dbg !375
  call void @llvm.dbg.value(metadata i8* %1, metadata !376, metadata !DIExpression()), !dbg !375
  call void @llvm.dbg.value(metadata i8* %2, metadata !377, metadata !DIExpression()), !dbg !375
  call void @llvm.dbg.value(metadata i8* %1, metadata !378, metadata !DIExpression()), !dbg !375
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !379, !srcloc !380
  %4 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %0, i32 0, i32 0, !dbg !381
  %5 = bitcast i8** %4 to i64*, !dbg !382
  %6 = ptrtoint i8* %1 to i64, !dbg !382
  %7 = ptrtoint i8* %2 to i64, !dbg !382
  %8 = cmpxchg i64* %5, i64 %6, i64 %7 release monotonic, align 8, !dbg !382
  %9 = extractvalue { i64, i1 } %8, 0, !dbg !382
  %10 = extractvalue { i64, i1 } %8, 1, !dbg !382
  %11 = inttoptr i64 %9 to i8*, !dbg !382
  %.0 = select i1 %10, i8* %1, i8* %11, !dbg !382
  call void @llvm.dbg.value(metadata i8* %.0, metadata !378, metadata !DIExpression()), !dbg !375
  %12 = zext i1 %10 to i8, !dbg !382
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !383, !srcloc !384
  ret i8* %.0, !dbg !385
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_await_neq_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !386 {
  call void @llvm.dbg.value(metadata %struct.vatomicptr_s* %0, metadata !387, metadata !DIExpression()), !dbg !388
  call void @llvm.dbg.value(metadata i8* %1, metadata !389, metadata !DIExpression()), !dbg !388
  call void @llvm.dbg.value(metadata i8* null, metadata !390, metadata !DIExpression()), !dbg !388
  br label %3, !dbg !391

3:                                                ; preds = %3, %2
  %4 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %0), !dbg !391
  call void @llvm.dbg.value(metadata i8* %4, metadata !390, metadata !DIExpression()), !dbg !388
  %5 = icmp eq i8* %4, %1, !dbg !391
  br i1 %5, label %3, label %6, !dbg !391, !llvm.loop !392

6:                                                ; preds = %3
  ret i8* %4, !dbg !394
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %0) #0 !dbg !395 {
  call void @llvm.dbg.value(metadata %struct.vatomicptr_s* %0, metadata !396, metadata !DIExpression()), !dbg !397
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !398, !srcloc !399
  %2 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %0, i32 0, i32 0, !dbg !400
  %3 = bitcast i8** %2 to i64*, !dbg !401
  %4 = load atomic i64, i64* %3 acquire, align 8, !dbg !401
  %5 = inttoptr i64 %4 to i8*, !dbg !401
  call void @llvm.dbg.value(metadata i8* %5, metadata !402, metadata !DIExpression()), !dbg !397
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !403, !srcloc !404
  ret i8* %5, !dbg !405
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !406 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !407, metadata !DIExpression()), !dbg !408
  call void @llvm.dbg.value(metadata i32 %1, metadata !409, metadata !DIExpression()), !dbg !408
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !410, !srcloc !411
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !412
  store atomic i32 %1, i32* %3 release, align 4, !dbg !413
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !414, !srcloc !415
  ret void, !dbg !416
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
!llvm.module.flags = !{!56, !57, !58, !59, !60, !61, !62}
!llvm.ident = !{!63}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !55, line: 87, type: !11, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !33, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/libvsync/test/spinlock/rec_mcslock.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "d3b9f95ed66ef78f7a4c2c16d1e1a92b")
!4 = !{!5, !6, !11, !17}
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
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "mcs_node_t", file: !19, line: 34, baseType: !20)
!19 = !DIFile(filename: "./include/vsync/spinlock/mcslock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "cb771bc86e8152f0a21a438d4f799bda")
!20 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "mcs_node_s", file: !19, line: 31, size: 128, elements: !21)
!21 = !{!22, !28}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !20, file: !19, line: 32, baseType: !23, size: 64, align: 64)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomicptr_t", file: !24, line: 72, baseType: !25)
!24 = !DIFile(filename: "./include/vsync/atomic/core.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "1cc0657a82f0605ef67642f178a77e1c")
!25 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomicptr_s", file: !24, line: 70, size: 64, align: 64, elements: !26)
!26 = !{!27}
!27 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !25, file: !24, line: 71, baseType: !5, size: 64)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "locked", scope: !20, file: !19, line: 33, baseType: !29, size: 32, align: 32, offset: 64)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !24, line: 62, baseType: !30)
!30 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !24, line: 60, size: 32, align: 32, elements: !31)
!31 = !{!32}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !30, file: !24, line: 61, baseType: !11, size: 32)
!33 = !{!34, !48, !0, !53}
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !36, line: 10, type: !37, isLocal: false, isDefinition: true)
!36 = !DIFile(filename: "test/spinlock/rec_mcslock.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "d3b9f95ed66ef78f7a4c2c16d1e1a92b")
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "rec_mcslock_t", file: !38, line: 25, baseType: !39)
!38 = !DIFile(filename: "./include/vsync/spinlock/rec_mcslock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "5502d220c225313a819dd3d9b0150cd4")
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "rec_mcslock_s", file: !38, line: 25, size: 128, elements: !40)
!40 = !{!41, !46, !47}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !39, file: !38, line: 25, baseType: !42, size: 64)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "mcslock_t", file: !19, line: 39, baseType: !43)
!43 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "mcslock_s", file: !19, line: 37, size: 64, elements: !44)
!44 = !{!45}
!45 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !43, file: !19, line: 38, baseType: !23, size: 64, align: 64)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "owner", scope: !39, file: !38, line: 25, baseType: !29, size: 32, align: 32, offset: 64)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !39, file: !38, line: 25, baseType: !11, size: 32, offset: 96)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "nodes", scope: !2, file: !36, line: 11, type: !50, isLocal: false, isDefinition: true)
!50 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 384, elements: !51)
!51 = !{!52}
!52 = !DISubrange(count: 3)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !55, line: 88, type: !11, isLocal: true, isDefinition: true)
!55 = !DIFile(filename: "./include/test/boilerplate/lock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "c9c29de1465ea379ec6432998a180648")
!56 = !{i32 7, !"Dwarf Version", i32 5}
!57 = !{i32 2, !"Debug Info Version", i32 3}
!58 = !{i32 1, !"wchar_size", i32 4}
!59 = !{i32 7, !"PIC Level", i32 2}
!60 = !{i32 7, !"PIE Level", i32 2}
!61 = !{i32 7, !"uwtable", i32 1}
!62 = !{i32 7, !"frame-pointer", i32 2}
!63 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!64 = distinct !DISubprogram(name: "init", scope: !55, file: !55, line: 55, type: !65, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!65 = !DISubroutineType(types: !66)
!66 = !{null}
!67 = !{}
!68 = !DILocation(line: 57, column: 1, scope: !64)
!69 = distinct !DISubprogram(name: "post", scope: !55, file: !55, line: 64, type: !65, scopeLine: 65, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!70 = !DILocation(line: 66, column: 1, scope: !69)
!71 = distinct !DISubprogram(name: "fini", scope: !55, file: !55, line: 73, type: !65, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!72 = !DILocation(line: 75, column: 1, scope: !71)
!73 = distinct !DISubprogram(name: "cs", scope: !55, file: !55, line: 91, type: !65, scopeLine: 92, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!74 = !DILocation(line: 93, column: 8, scope: !73)
!75 = !DILocation(line: 94, column: 8, scope: !73)
!76 = !DILocation(line: 95, column: 1, scope: !73)
!77 = distinct !DISubprogram(name: "check", scope: !55, file: !55, line: 97, type: !65, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!78 = !DILocation(line: 99, column: 2, scope: !79)
!79 = distinct !DILexicalBlock(scope: !80, file: !55, line: 99, column: 2)
!80 = distinct !DILexicalBlock(scope: !77, file: !55, line: 99, column: 2)
!81 = !DILocation(line: 99, column: 2, scope: !80)
!82 = !DILocation(line: 100, column: 2, scope: !83)
!83 = distinct !DILexicalBlock(scope: !84, file: !55, line: 100, column: 2)
!84 = distinct !DILexicalBlock(scope: !77, file: !55, line: 100, column: 2)
!85 = !DILocation(line: 100, column: 2, scope: !84)
!86 = !DILocation(line: 101, column: 1, scope: !77)
!87 = distinct !DISubprogram(name: "main", scope: !55, file: !55, line: 136, type: !88, scopeLine: 137, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!88 = !DISubroutineType(types: !89)
!89 = !{!90}
!90 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!91 = !DILocalVariable(name: "t", scope: !87, file: !55, line: 138, type: !92)
!92 = !DICompositeType(tag: DW_TAG_array_type, baseType: !93, size: 192, elements: !51)
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !94, line: 27, baseType: !10)
!94 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!95 = !DILocation(line: 138, column: 12, scope: !87)
!96 = !DILocation(line: 146, column: 2, scope: !87)
!97 = !DILocalVariable(name: "i", scope: !98, file: !55, line: 148, type: !6)
!98 = distinct !DILexicalBlock(scope: !87, file: !55, line: 148, column: 2)
!99 = !DILocation(line: 0, scope: !98)
!100 = !DILocation(line: 149, column: 25, scope: !101)
!101 = distinct !DILexicalBlock(scope: !102, file: !55, line: 148, column: 44)
!102 = distinct !DILexicalBlock(scope: !98, file: !55, line: 148, column: 2)
!103 = !DILocation(line: 149, column: 9, scope: !101)
!104 = !DILocation(line: 152, column: 2, scope: !87)
!105 = !DILocalVariable(name: "i", scope: !106, file: !55, line: 154, type: !6)
!106 = distinct !DILexicalBlock(scope: !87, file: !55, line: 154, column: 2)
!107 = !DILocation(line: 0, scope: !106)
!108 = !DILocation(line: 155, column: 22, scope: !109)
!109 = distinct !DILexicalBlock(scope: !110, file: !55, line: 154, column: 44)
!110 = distinct !DILexicalBlock(scope: !106, file: !55, line: 154, column: 2)
!111 = !DILocation(line: 155, column: 9, scope: !109)
!112 = !DILocation(line: 163, column: 2, scope: !87)
!113 = !DILocation(line: 164, column: 2, scope: !87)
!114 = !DILocation(line: 166, column: 2, scope: !87)
!115 = distinct !DISubprogram(name: "run", scope: !55, file: !55, line: 111, type: !116, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!116 = !DISubroutineType(types: !117)
!117 = !{!5, !5}
!118 = !DILocalVariable(name: "arg", arg: 1, scope: !115, file: !55, line: 111, type: !5)
!119 = !DILocation(line: 0, scope: !115)
!120 = !DILocation(line: 113, column: 18, scope: !115)
!121 = !DILocalVariable(name: "tid", scope: !115, file: !55, line: 113, type: !11)
!122 = !DILocation(line: 117, column: 2, scope: !115)
!123 = !DILocalVariable(name: "i", scope: !124, file: !55, line: 118, type: !90)
!124 = distinct !DILexicalBlock(scope: !115, file: !55, line: 118, column: 2)
!125 = !DILocation(line: 0, scope: !124)
!126 = !DILocation(line: 118, column: 7, scope: !124)
!127 = !DILocation(line: 118, column: 25, scope: !128)
!128 = distinct !DILexicalBlock(scope: !124, file: !55, line: 118, column: 2)
!129 = !DILocation(line: 118, column: 28, scope: !128)
!130 = !DILocation(line: 118, column: 2, scope: !124)
!131 = !DILocation(line: 122, column: 3, scope: !132)
!132 = distinct !DILexicalBlock(scope: !128, file: !55, line: 118, column: 60)
!133 = !DILocalVariable(name: "j", scope: !134, file: !55, line: 123, type: !90)
!134 = distinct !DILexicalBlock(scope: !132, file: !55, line: 123, column: 3)
!135 = !DILocation(line: 0, scope: !134)
!136 = !DILocation(line: 123, column: 8, scope: !134)
!137 = !DILocation(line: 123, column: 26, scope: !138)
!138 = distinct !DILexicalBlock(scope: !134, file: !55, line: 123, column: 3)
!139 = !DILocation(line: 123, column: 29, scope: !138)
!140 = !DILocation(line: 123, column: 3, scope: !134)
!141 = !DILocation(line: 124, column: 4, scope: !142)
!142 = distinct !DILexicalBlock(scope: !138, file: !55, line: 123, column: 61)
!143 = !DILocation(line: 125, column: 4, scope: !142)
!144 = !DILocation(line: 123, column: 57, scope: !138)
!145 = !DILocation(line: 123, column: 3, scope: !138)
!146 = distinct !{!146, !140, !147, !148}
!147 = !DILocation(line: 126, column: 3, scope: !134)
!148 = !{!"llvm.loop.mustprogress"}
!149 = !DILocation(line: 127, column: 3, scope: !132)
!150 = !DILocalVariable(name: "j", scope: !151, file: !55, line: 128, type: !90)
!151 = distinct !DILexicalBlock(scope: !132, file: !55, line: 128, column: 3)
!152 = !DILocation(line: 0, scope: !151)
!153 = !DILocation(line: 128, column: 8, scope: !151)
!154 = !DILocation(line: 128, column: 26, scope: !155)
!155 = distinct !DILexicalBlock(scope: !151, file: !55, line: 128, column: 3)
!156 = !DILocation(line: 128, column: 29, scope: !155)
!157 = !DILocation(line: 128, column: 3, scope: !151)
!158 = !DILocation(line: 129, column: 4, scope: !159)
!159 = distinct !DILexicalBlock(scope: !155, file: !55, line: 128, column: 61)
!160 = !DILocation(line: 128, column: 57, scope: !155)
!161 = !DILocation(line: 128, column: 3, scope: !155)
!162 = distinct !{!162, !157, !163, !148}
!163 = !DILocation(line: 130, column: 3, scope: !151)
!164 = !DILocation(line: 118, column: 56, scope: !128)
!165 = !DILocation(line: 118, column: 2, scope: !128)
!166 = distinct !{!166, !130, !167, !148}
!167 = !DILocation(line: 131, column: 2, scope: !124)
!168 = !DILocation(line: 132, column: 2, scope: !115)
!169 = distinct !DISubprogram(name: "acquire", scope: !36, file: !36, line: 14, type: !170, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!170 = !DISubroutineType(types: !171)
!171 = !{null, !11}
!172 = !DILocalVariable(name: "tid", arg: 1, scope: !169, file: !36, line: 14, type: !11)
!173 = !DILocation(line: 0, scope: !169)
!174 = !DILocation(line: 16, column: 35, scope: !169)
!175 = !DILocation(line: 16, column: 2, scope: !169)
!176 = !DILocation(line: 17, column: 1, scope: !169)
!177 = distinct !DISubprogram(name: "rec_mcslock_acquire", scope: !38, file: !38, line: 25, type: !178, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!178 = !DISubroutineType(types: !179)
!179 = !{null, !180, !11, !17}
!180 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!181 = !DILocalVariable(name: "l", arg: 1, scope: !177, file: !38, line: 25, type: !180)
!182 = !DILocation(line: 0, scope: !177)
!183 = !DILocalVariable(name: "id", arg: 2, scope: !177, file: !38, line: 25, type: !11)
!184 = !DILocalVariable(name: "ctx", arg: 3, scope: !177, file: !38, line: 25, type: !17)
!185 = !DILocation(line: 25, column: 1, scope: !186)
!186 = distinct !DILexicalBlock(scope: !187, file: !38, line: 25, column: 1)
!187 = distinct !DILexicalBlock(scope: !177, file: !38, line: 25, column: 1)
!188 = !DILocation(line: 25, column: 1, scope: !189)
!189 = distinct !DILexicalBlock(scope: !177, file: !38, line: 25, column: 1)
!190 = !DILocation(line: 25, column: 1, scope: !177)
!191 = !DILocation(line: 25, column: 1, scope: !192)
!192 = distinct !DILexicalBlock(scope: !189, file: !38, line: 25, column: 1)
!193 = distinct !DISubprogram(name: "release", scope: !36, file: !36, line: 20, type: !170, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!194 = !DILocalVariable(name: "tid", arg: 1, scope: !193, file: !36, line: 20, type: !11)
!195 = !DILocation(line: 0, scope: !193)
!196 = !DILocation(line: 22, column: 30, scope: !193)
!197 = !DILocation(line: 22, column: 2, scope: !193)
!198 = !DILocation(line: 23, column: 1, scope: !193)
!199 = distinct !DISubprogram(name: "rec_mcslock_release", scope: !38, file: !38, line: 25, type: !200, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!200 = !DISubroutineType(types: !201)
!201 = !{null, !180, !17}
!202 = !DILocalVariable(name: "l", arg: 1, scope: !199, file: !38, line: 25, type: !180)
!203 = !DILocation(line: 0, scope: !199)
!204 = !DILocalVariable(name: "ctx", arg: 2, scope: !199, file: !38, line: 25, type: !17)
!205 = !DILocation(line: 25, column: 1, scope: !206)
!206 = distinct !DILexicalBlock(scope: !199, file: !38, line: 25, column: 1)
!207 = !DILocation(line: 25, column: 1, scope: !199)
!208 = !DILocation(line: 25, column: 1, scope: !209)
!209 = distinct !DILexicalBlock(scope: !206, file: !38, line: 25, column: 1)
!210 = !DILocation(line: 25, column: 1, scope: !211)
!211 = distinct !DILexicalBlock(scope: !206, file: !38, line: 25, column: 1)
!212 = distinct !DISubprogram(name: "verification_loop_bound", scope: !213, file: !213, line: 80, type: !170, scopeLine: 81, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!213 = !DIFile(filename: "./include/vsync/common/verify.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "3a0b94d9e7ec6d94ef39ae9297c4bc2a")
!214 = !DILocalVariable(name: "bound", arg: 1, scope: !212, file: !213, line: 80, type: !11)
!215 = !DILocation(line: 0, scope: !212)
!216 = !DILocation(line: 83, column: 1, scope: !212)
!217 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !218, file: !218, line: 193, type: !219, scopeLine: 194, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!218 = !DIFile(filename: "./include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "31d9a9647b315cadb2f817a7c8e98ecf")
!219 = !DISubroutineType(types: !220)
!220 = !{!11, !221}
!221 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!222 = !DILocalVariable(name: "a", arg: 1, scope: !217, file: !218, line: 193, type: !221)
!223 = !DILocation(line: 0, scope: !217)
!224 = !DILocation(line: 195, column: 2, scope: !217)
!225 = !{i64 2147851670}
!226 = !DILocation(line: 197, column: 7, scope: !217)
!227 = !DILocation(line: 196, column: 29, scope: !217)
!228 = !DILocalVariable(name: "tmp", scope: !217, file: !218, line: 196, type: !11)
!229 = !DILocation(line: 198, column: 2, scope: !217)
!230 = !{i64 2147851716}
!231 = !DILocation(line: 199, column: 2, scope: !217)
!232 = distinct !DISubprogram(name: "mcslock_acquire", scope: !19, file: !19, line: 88, type: !233, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!233 = !DISubroutineType(types: !234)
!234 = !{null, !235, !17}
!235 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!236 = !DILocalVariable(name: "l", arg: 1, scope: !232, file: !19, line: 88, type: !235)
!237 = !DILocation(line: 0, scope: !232)
!238 = !DILocalVariable(name: "node", arg: 2, scope: !232, file: !19, line: 88, type: !17)
!239 = !DILocation(line: 92, column: 30, scope: !232)
!240 = !DILocation(line: 92, column: 2, scope: !232)
!241 = !DILocation(line: 93, column: 29, scope: !232)
!242 = !DILocation(line: 93, column: 2, scope: !232)
!243 = !DILocation(line: 95, column: 43, scope: !232)
!244 = !DILocation(line: 95, column: 49, scope: !232)
!245 = !DILocation(line: 95, column: 23, scope: !232)
!246 = !DILocation(line: 95, column: 9, scope: !232)
!247 = !DILocalVariable(name: "pred", scope: !232, file: !19, line: 90, type: !17)
!248 = !DILocation(line: 96, column: 6, scope: !249)
!249 = distinct !DILexicalBlock(scope: !232, file: !19, line: 96, column: 6)
!250 = !DILocation(line: 96, column: 6, scope: !232)
!251 = !DILocation(line: 97, column: 31, scope: !252)
!252 = distinct !DILexicalBlock(scope: !249, file: !19, line: 96, column: 12)
!253 = !DILocation(line: 97, column: 3, scope: !252)
!254 = !DILocation(line: 98, column: 3, scope: !252)
!255 = !DILocation(line: 99, column: 2, scope: !252)
!256 = !DILocation(line: 100, column: 1, scope: !232)
!257 = distinct !DISubprogram(name: "vatomic32_write_rlx", scope: !218, file: !218, line: 451, type: !258, scopeLine: 452, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!258 = !DISubroutineType(types: !259)
!259 = !{null, !221, !11}
!260 = !DILocalVariable(name: "a", arg: 1, scope: !257, file: !218, line: 451, type: !221)
!261 = !DILocation(line: 0, scope: !257)
!262 = !DILocalVariable(name: "v", arg: 2, scope: !257, file: !218, line: 451, type: !11)
!263 = !DILocation(line: 453, column: 2, scope: !257)
!264 = !{i64 2147853182}
!265 = !DILocation(line: 454, column: 23, scope: !257)
!266 = !DILocation(line: 454, column: 2, scope: !257)
!267 = !DILocation(line: 455, column: 2, scope: !257)
!268 = !{i64 2147853228}
!269 = !DILocation(line: 456, column: 1, scope: !257)
!270 = distinct !DISubprogram(name: "vatomicptr_write_rlx", scope: !218, file: !218, line: 568, type: !271, scopeLine: 569, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!271 = !DISubroutineType(types: !272)
!272 = !{null, !273, !5}
!273 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!274 = !DILocalVariable(name: "a", arg: 1, scope: !270, file: !218, line: 568, type: !273)
!275 = !DILocation(line: 0, scope: !270)
!276 = !DILocalVariable(name: "v", arg: 2, scope: !270, file: !218, line: 568, type: !5)
!277 = !DILocation(line: 570, column: 2, scope: !270)
!278 = !{i64 2147853938}
!279 = !DILocation(line: 571, column: 23, scope: !270)
!280 = !DILocation(line: 571, column: 2, scope: !270)
!281 = !DILocation(line: 572, column: 2, scope: !270)
!282 = !{i64 2147853984}
!283 = !DILocation(line: 573, column: 1, scope: !270)
!284 = distinct !DISubprogram(name: "vatomicptr_xchg", scope: !218, file: !218, line: 885, type: !285, scopeLine: 886, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!285 = !DISubroutineType(types: !286)
!286 = !{!5, !273, !5}
!287 = !DILocalVariable(name: "a", arg: 1, scope: !284, file: !218, line: 885, type: !273)
!288 = !DILocation(line: 0, scope: !284)
!289 = !DILocalVariable(name: "v", arg: 2, scope: !284, file: !218, line: 885, type: !5)
!290 = !DILocation(line: 887, column: 2, scope: !284)
!291 = !{i64 2147855702}
!292 = !DILocation(line: 889, column: 7, scope: !284)
!293 = !DILocation(line: 888, column: 22, scope: !284)
!294 = !DILocalVariable(name: "tmp", scope: !284, file: !218, line: 888, type: !5)
!295 = !DILocation(line: 890, column: 2, scope: !284)
!296 = !{i64 2147855748}
!297 = !DILocation(line: 891, column: 2, scope: !284)
!298 = distinct !DISubprogram(name: "vatomicptr_write_rel", scope: !218, file: !218, line: 555, type: !271, scopeLine: 556, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!299 = !DILocalVariable(name: "a", arg: 1, scope: !298, file: !218, line: 555, type: !273)
!300 = !DILocation(line: 0, scope: !298)
!301 = !DILocalVariable(name: "v", arg: 2, scope: !298, file: !218, line: 555, type: !5)
!302 = !DILocation(line: 557, column: 2, scope: !298)
!303 = !{i64 2147853854}
!304 = !DILocation(line: 558, column: 23, scope: !298)
!305 = !DILocation(line: 558, column: 2, scope: !298)
!306 = !DILocation(line: 559, column: 2, scope: !298)
!307 = !{i64 2147853900}
!308 = !DILocation(line: 560, column: 1, scope: !298)
!309 = distinct !DISubprogram(name: "vatomic32_await_eq_acq", scope: !310, file: !310, line: 4389, type: !311, scopeLine: 4390, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!310 = !DIFile(filename: "./include/vsync/atomic/internal/fallback.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "bfc5d50ad810da3af0d582a48b47498f")
!311 = !DISubroutineType(types: !312)
!312 = !{!11, !221, !11}
!313 = !DILocalVariable(name: "a", arg: 1, scope: !309, file: !310, line: 4389, type: !221)
!314 = !DILocation(line: 0, scope: !309)
!315 = !DILocalVariable(name: "c", arg: 2, scope: !309, file: !310, line: 4389, type: !11)
!316 = !DILocalVariable(name: "ret", scope: !309, file: !310, line: 4391, type: !11)
!317 = !DILocalVariable(name: "o", scope: !309, file: !310, line: 4392, type: !11)
!318 = !DILocation(line: 4393, column: 2, scope: !309)
!319 = distinct !{!319, !318, !320, !148}
!320 = !DILocation(line: 4396, column: 2, scope: !309)
!321 = !DILocation(line: 4397, column: 2, scope: !309)
!322 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !218, file: !218, line: 178, type: !219, scopeLine: 179, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!323 = !DILocalVariable(name: "a", arg: 1, scope: !322, file: !218, line: 178, type: !221)
!324 = !DILocation(line: 0, scope: !322)
!325 = !DILocation(line: 180, column: 2, scope: !322)
!326 = !{i64 2147851586}
!327 = !DILocation(line: 182, column: 7, scope: !322)
!328 = !DILocation(line: 181, column: 29, scope: !322)
!329 = !DILocalVariable(name: "tmp", scope: !322, file: !218, line: 181, type: !11)
!330 = !DILocation(line: 183, column: 2, scope: !322)
!331 = !{i64 2147851632}
!332 = !DILocation(line: 184, column: 2, scope: !322)
!333 = distinct !DISubprogram(name: "mcslock_release", scope: !19, file: !19, line: 109, type: !233, scopeLine: 110, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!334 = !DILocalVariable(name: "l", arg: 1, scope: !333, file: !19, line: 109, type: !235)
!335 = !DILocation(line: 0, scope: !333)
!336 = !DILocalVariable(name: "node", arg: 2, scope: !333, file: !19, line: 109, type: !17)
!337 = !DILocation(line: 113, column: 33, scope: !338)
!338 = distinct !DILexicalBlock(scope: !333, file: !19, line: 113, column: 6)
!339 = !DILocation(line: 113, column: 6, scope: !338)
!340 = !DILocation(line: 113, column: 39, scope: !338)
!341 = !DILocation(line: 113, column: 6, scope: !333)
!342 = !DILocation(line: 114, column: 51, scope: !343)
!343 = distinct !DILexicalBlock(scope: !338, file: !19, line: 113, column: 48)
!344 = !DILocation(line: 114, column: 57, scope: !343)
!345 = !DILocation(line: 114, column: 24, scope: !343)
!346 = !DILocation(line: 114, column: 10, scope: !343)
!347 = !DILocalVariable(name: "next", scope: !333, file: !19, line: 111, type: !17)
!348 = !DILocation(line: 115, column: 12, scope: !349)
!349 = distinct !DILexicalBlock(scope: !343, file: !19, line: 115, column: 7)
!350 = !DILocation(line: 115, column: 7, scope: !343)
!351 = !DILocation(line: 118, column: 3, scope: !343)
!352 = !DILocation(line: 119, column: 2, scope: !343)
!353 = !DILocation(line: 120, column: 23, scope: !333)
!354 = !DILocation(line: 120, column: 9, scope: !333)
!355 = !DILocation(line: 121, column: 29, scope: !333)
!356 = !DILocation(line: 121, column: 2, scope: !333)
!357 = !DILocation(line: 122, column: 1, scope: !333)
!358 = distinct !DISubprogram(name: "vatomicptr_read_rlx", scope: !218, file: !218, line: 328, type: !359, scopeLine: 329, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!359 = !DISubroutineType(types: !360)
!360 = !{!5, !273}
!361 = !DILocalVariable(name: "a", arg: 1, scope: !358, file: !218, line: 328, type: !273)
!362 = !DILocation(line: 0, scope: !358)
!363 = !DILocation(line: 330, column: 2, scope: !358)
!364 = !{i64 2147852426}
!365 = !DILocation(line: 332, column: 7, scope: !358)
!366 = !DILocation(line: 331, column: 22, scope: !358)
!367 = !DILocalVariable(name: "tmp", scope: !358, file: !218, line: 331, type: !5)
!368 = !DILocation(line: 333, column: 2, scope: !358)
!369 = !{i64 2147852472}
!370 = !DILocation(line: 334, column: 2, scope: !358)
!371 = distinct !DISubprogram(name: "vatomicptr_cmpxchg_rel", scope: !218, file: !218, line: 1323, type: !372, scopeLine: 1324, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!372 = !DISubroutineType(types: !373)
!373 = !{!5, !273, !5, !5}
!374 = !DILocalVariable(name: "a", arg: 1, scope: !371, file: !218, line: 1323, type: !273)
!375 = !DILocation(line: 0, scope: !371)
!376 = !DILocalVariable(name: "e", arg: 2, scope: !371, file: !218, line: 1323, type: !5)
!377 = !DILocalVariable(name: "v", arg: 3, scope: !371, file: !218, line: 1323, type: !5)
!378 = !DILocalVariable(name: "exp", scope: !371, file: !218, line: 1325, type: !5)
!379 = !DILocation(line: 1326, column: 2, scope: !371)
!380 = !{i64 2147858062}
!381 = !DILocation(line: 1327, column: 34, scope: !371)
!382 = !DILocation(line: 1327, column: 2, scope: !371)
!383 = !DILocation(line: 1330, column: 2, scope: !371)
!384 = !{i64 2147858116}
!385 = !DILocation(line: 1331, column: 2, scope: !371)
!386 = distinct !DISubprogram(name: "vatomicptr_await_neq_rlx", scope: !310, file: !310, line: 4357, type: !285, scopeLine: 4358, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!387 = !DILocalVariable(name: "a", arg: 1, scope: !386, file: !310, line: 4357, type: !273)
!388 = !DILocation(line: 0, scope: !386)
!389 = !DILocalVariable(name: "c", arg: 2, scope: !386, file: !310, line: 4357, type: !5)
!390 = !DILocalVariable(name: "cur", scope: !386, file: !310, line: 4359, type: !5)
!391 = !DILocation(line: 4360, column: 2, scope: !386)
!392 = distinct !{!392, !391, !393, !148}
!393 = !DILocation(line: 4362, column: 2, scope: !386)
!394 = !DILocation(line: 4363, column: 2, scope: !386)
!395 = distinct !DISubprogram(name: "vatomicptr_read_acq", scope: !218, file: !218, line: 313, type: !359, scopeLine: 314, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!396 = !DILocalVariable(name: "a", arg: 1, scope: !395, file: !218, line: 313, type: !273)
!397 = !DILocation(line: 0, scope: !395)
!398 = !DILocation(line: 315, column: 2, scope: !395)
!399 = !{i64 2147852342}
!400 = !DILocation(line: 317, column: 7, scope: !395)
!401 = !DILocation(line: 316, column: 22, scope: !395)
!402 = !DILocalVariable(name: "tmp", scope: !395, file: !218, line: 316, type: !5)
!403 = !DILocation(line: 318, column: 2, scope: !395)
!404 = !{i64 2147852388}
!405 = !DILocation(line: 319, column: 2, scope: !395)
!406 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !218, file: !218, line: 438, type: !258, scopeLine: 439, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!407 = !DILocalVariable(name: "a", arg: 1, scope: !406, file: !218, line: 438, type: !221)
!408 = !DILocation(line: 0, scope: !406)
!409 = !DILocalVariable(name: "v", arg: 2, scope: !406, file: !218, line: 438, type: !11)
!410 = !DILocation(line: 440, column: 2, scope: !406)
!411 = !{i64 2147853098}
!412 = !DILocation(line: 441, column: 23, scope: !406)
!413 = !DILocation(line: 441, column: 2, scope: !406)
!414 = !DILocation(line: 442, column: 2, scope: !406)
!415 = !{i64 2147853144}
!416 = !DILocation(line: 443, column: 1, scope: !406)
