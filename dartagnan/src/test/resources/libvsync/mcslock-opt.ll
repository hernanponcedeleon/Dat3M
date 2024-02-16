; ModuleID = '/home/drc/git/Dat3M/output/mcslock.ll'
source_filename = "/home/drc/git/libvsync/test/spinlock/mcslock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.mcslock_s = type { %struct.vatomicptr_s }
%struct.vatomicptr_s = type { i8* }
%struct.mcs_node_s = type { %struct.vatomicptr_s, %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !46
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [34 x i8] c"./include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (3 + 1 + 0)\00", align 1
@lock = dso_local global %struct.mcslock_s zeroinitializer, align 8, !dbg !34
@nodes = dso_local global [3 x %struct.mcs_node_s] zeroinitializer, align 16, !dbg !41

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !57 {
  ret void, !dbg !61
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !62 {
  ret void, !dbg !63
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !64 {
  ret void, !dbg !65
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cs() #0 !dbg !66 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !67
  %2 = add i32 %1, 1, !dbg !67
  store i32 %2, i32* @g_cs_x, align 4, !dbg !67
  %3 = load i32, i32* @g_cs_y, align 4, !dbg !68
  %4 = add i32 %3, 1, !dbg !68
  store i32 %4, i32* @g_cs_y, align 4, !dbg !68
  ret void, !dbg !69
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !70 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !71
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !71
  %3 = icmp eq i32 %1, %2, !dbg !71
  br i1 %3, label %5, label %4, !dbg !74

4:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @.str.1, i64 0, i64 0), i32 noundef 99, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !71
  unreachable, !dbg !71

5:                                                ; preds = %0
  %6 = icmp eq i32 %1, 4, !dbg !75
  br i1 %6, label %8, label %7, !dbg !78

7:                                                ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @.str.1, i64 0, i64 0), i32 noundef 100, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !75
  unreachable, !dbg !75

8:                                                ; preds = %5
  ret void, !dbg !79
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !80 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !84, metadata !DIExpression()), !dbg !88
  call void @init(), !dbg !89
  call void @llvm.dbg.value(metadata i64 0, metadata !90, metadata !DIExpression()), !dbg !92
  call void @llvm.dbg.value(metadata i64 0, metadata !90, metadata !DIExpression()), !dbg !92
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !93
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef null) #6, !dbg !96
  call void @llvm.dbg.value(metadata i64 1, metadata !90, metadata !DIExpression()), !dbg !92
  call void @llvm.dbg.value(metadata i64 1, metadata !90, metadata !DIExpression()), !dbg !92
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !93
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !96
  call void @llvm.dbg.value(metadata i64 2, metadata !90, metadata !DIExpression()), !dbg !92
  call void @llvm.dbg.value(metadata i64 2, metadata !90, metadata !DIExpression()), !dbg !92
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !93
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !96
  call void @llvm.dbg.value(metadata i64 3, metadata !90, metadata !DIExpression()), !dbg !92
  call void @llvm.dbg.value(metadata i64 3, metadata !90, metadata !DIExpression()), !dbg !92
  call void @post(), !dbg !97
  call void @llvm.dbg.value(metadata i64 0, metadata !98, metadata !DIExpression()), !dbg !100
  call void @llvm.dbg.value(metadata i64 0, metadata !98, metadata !DIExpression()), !dbg !100
  %8 = load i64, i64* %2, align 8, !dbg !101
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !104
  call void @llvm.dbg.value(metadata i64 1, metadata !98, metadata !DIExpression()), !dbg !100
  call void @llvm.dbg.value(metadata i64 1, metadata !98, metadata !DIExpression()), !dbg !100
  %10 = load i64, i64* %4, align 8, !dbg !101
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !104
  call void @llvm.dbg.value(metadata i64 2, metadata !98, metadata !DIExpression()), !dbg !100
  call void @llvm.dbg.value(metadata i64 2, metadata !98, metadata !DIExpression()), !dbg !100
  %12 = load i64, i64* %6, align 8, !dbg !101
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !104
  call void @llvm.dbg.value(metadata i64 3, metadata !98, metadata !DIExpression()), !dbg !100
  call void @llvm.dbg.value(metadata i64 3, metadata !98, metadata !DIExpression()), !dbg !100
  call void @check(), !dbg !105
  call void @fini(), !dbg !106
  ret i32 0, !dbg !107
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @run(i8* noundef %0) #0 !dbg !108 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !111, metadata !DIExpression()), !dbg !112
  %2 = ptrtoint i8* %0 to i64, !dbg !113
  %3 = trunc i64 %2 to i32, !dbg !113
  call void @llvm.dbg.value(metadata i32 %3, metadata !114, metadata !DIExpression()), !dbg !112
  call void @verification_loop_bound(i32 noundef 3), !dbg !115
  call void @llvm.dbg.value(metadata i32 0, metadata !116, metadata !DIExpression()), !dbg !118
  br label %4, !dbg !119

4:                                                ; preds = %.critedge7, %1
  %.02 = phi i32 [ 0, %1 ], [ %18, %.critedge7 ], !dbg !118
  call void @llvm.dbg.value(metadata i32 %.02, metadata !116, metadata !DIExpression()), !dbg !118
  switch i32 %.02, label %.critedge5 [
    i32 0, label %.critedge
    i32 1, label %5
  ], !dbg !120

5:                                                ; preds = %4
  %6 = add i32 %3, 1, !dbg !122
  %7 = icmp ult i32 %6, 2, !dbg !122
  br i1 %7, label %.critedge, label %.critedge5, !dbg !123

.critedge:                                        ; preds = %4, %5
  call void @verification_loop_bound(i32 noundef 2), !dbg !124
  call void @llvm.dbg.value(metadata i32 0, metadata !126, metadata !DIExpression()), !dbg !128
  br label %8, !dbg !129

8:                                                ; preds = %.critedge3, %.critedge
  %.01 = phi i32 [ 0, %.critedge ], [ %12, %.critedge3 ], !dbg !128
  call void @llvm.dbg.value(metadata i32 %.01, metadata !126, metadata !DIExpression()), !dbg !128
  switch i32 %.01, label %.critedge6 [
    i32 0, label %.critedge3
    i32 1, label %9
  ], !dbg !130

9:                                                ; preds = %8
  %10 = add i32 %3, 1, !dbg !132
  %11 = icmp ult i32 %10, 1, !dbg !132
  br i1 %11, label %.critedge3, label %.critedge6, !dbg !133

.critedge3:                                       ; preds = %8, %9
  call void @acquire(i32 noundef %3), !dbg !134
  call void @cs(), !dbg !136
  %12 = add nuw nsw i32 %.01, 1, !dbg !137
  call void @llvm.dbg.value(metadata i32 %12, metadata !126, metadata !DIExpression()), !dbg !128
  br label %8, !dbg !138, !llvm.loop !139

.critedge6:                                       ; preds = %8, %9
  call void @verification_loop_bound(i32 noundef 2), !dbg !142
  call void @llvm.dbg.value(metadata i32 0, metadata !143, metadata !DIExpression()), !dbg !145
  br label %13, !dbg !146

13:                                               ; preds = %.critedge4, %.critedge6
  %.0 = phi i32 [ 0, %.critedge6 ], [ %17, %.critedge4 ], !dbg !145
  call void @llvm.dbg.value(metadata i32 %.0, metadata !143, metadata !DIExpression()), !dbg !145
  switch i32 %.0, label %.critedge7 [
    i32 0, label %.critedge4
    i32 1, label %14
  ], !dbg !147

14:                                               ; preds = %13
  %15 = add i32 %3, 1, !dbg !149
  %16 = icmp ult i32 %15, 1, !dbg !149
  br i1 %16, label %.critedge4, label %.critedge7, !dbg !150

.critedge4:                                       ; preds = %13, %14
  call void @release(i32 noundef %3), !dbg !151
  %17 = add nuw nsw i32 %.0, 1, !dbg !153
  call void @llvm.dbg.value(metadata i32 %17, metadata !143, metadata !DIExpression()), !dbg !145
  br label %13, !dbg !154, !llvm.loop !155

.critedge7:                                       ; preds = %13, %14
  %18 = add nuw nsw i32 %.02, 1, !dbg !157
  call void @llvm.dbg.value(metadata i32 %18, metadata !116, metadata !DIExpression()), !dbg !118
  br label %4, !dbg !158, !llvm.loop !159

.critedge5:                                       ; preds = %4, %5
  ret i8* null, !dbg !161
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @acquire(i32 noundef %0) #0 !dbg !162 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !165, metadata !DIExpression()), !dbg !166
  %2 = icmp eq i32 %0, 2, !dbg !167
  br i1 %2, label %3, label %6, !dbg !169

3:                                                ; preds = %3, %1
  %4 = call zeroext i1 @mcslock_tryacquire(%struct.mcslock_s* noundef @lock, %struct.mcs_node_s* noundef getelementptr inbounds ([3 x %struct.mcs_node_s], [3 x %struct.mcs_node_s]* @nodes, i64 0, i64 2)), !dbg !170
  %5 = xor i1 %4, true, !dbg !170
  br i1 %5, label %3, label %9, !dbg !170, !llvm.loop !171

6:                                                ; preds = %1
  %7 = zext i32 %0 to i64, !dbg !173
  %8 = getelementptr inbounds [3 x %struct.mcs_node_s], [3 x %struct.mcs_node_s]* @nodes, i64 0, i64 %7, !dbg !173
  call void @mcslock_acquire(%struct.mcslock_s* noundef @lock, %struct.mcs_node_s* noundef %8), !dbg !174
  br label %9

9:                                                ; preds = %3, %6
  ret void, !dbg !175
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @mcslock_tryacquire(%struct.mcslock_s* noundef %0, %struct.mcs_node_s* noundef %1) #0 !dbg !176 {
  call void @llvm.dbg.value(metadata %struct.mcslock_s* %0, metadata !182, metadata !DIExpression()), !dbg !183
  call void @llvm.dbg.value(metadata %struct.mcs_node_s* %1, metadata !184, metadata !DIExpression()), !dbg !183
  %3 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %1, i32 0, i32 0, !dbg !185
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %3, i8* noundef null), !dbg !186
  %4 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %1, i32 0, i32 1, !dbg !187
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %4, i32 noundef 1), !dbg !188
  %5 = getelementptr inbounds %struct.mcslock_s, %struct.mcslock_s* %0, i32 0, i32 0, !dbg !189
  %6 = bitcast %struct.mcs_node_s* %1 to i8*, !dbg !190
  %7 = call i8* @vatomicptr_cmpxchg(%struct.vatomicptr_s* noundef %5, i8* noundef null, i8* noundef %6), !dbg !191
  %8 = bitcast i8* %7 to %struct.mcs_node_s*, !dbg !192
  call void @llvm.dbg.value(metadata %struct.mcs_node_s* %8, metadata !193, metadata !DIExpression()), !dbg !183
  %9 = icmp eq %struct.mcs_node_s* %8, null, !dbg !194
  ret i1 %9, !dbg !195
}

; Function Attrs: noinline nounwind uwtable
define internal void @mcslock_acquire(%struct.mcslock_s* noundef %0, %struct.mcs_node_s* noundef %1) #0 !dbg !196 {
  call void @llvm.dbg.value(metadata %struct.mcslock_s* %0, metadata !199, metadata !DIExpression()), !dbg !200
  call void @llvm.dbg.value(metadata %struct.mcs_node_s* %1, metadata !201, metadata !DIExpression()), !dbg !200
  %3 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %1, i32 0, i32 0, !dbg !202
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %3, i8* noundef null), !dbg !203
  %4 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %1, i32 0, i32 1, !dbg !204
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %4, i32 noundef 1), !dbg !205
  %5 = getelementptr inbounds %struct.mcslock_s, %struct.mcslock_s* %0, i32 0, i32 0, !dbg !206
  %6 = bitcast %struct.mcs_node_s* %1 to i8*, !dbg !207
  %7 = call i8* @vatomicptr_xchg(%struct.vatomicptr_s* noundef %5, i8* noundef %6), !dbg !208
  %8 = bitcast i8* %7 to %struct.mcs_node_s*, !dbg !209
  call void @llvm.dbg.value(metadata %struct.mcs_node_s* %8, metadata !210, metadata !DIExpression()), !dbg !200
  %9 = icmp ne %struct.mcs_node_s* %8, null, !dbg !211
  br i1 %9, label %10, label %13, !dbg !213

10:                                               ; preds = %2
  %11 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %8, i32 0, i32 0, !dbg !214
  call void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %11, i8* noundef %6), !dbg !216
  %12 = call i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %4, i32 noundef 0), !dbg !217
  br label %13, !dbg !218

13:                                               ; preds = %10, %2
  ret void, !dbg !219
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !220 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !221, metadata !DIExpression()), !dbg !222
  %2 = zext i32 %0 to i64, !dbg !223
  %3 = getelementptr inbounds [3 x %struct.mcs_node_s], [3 x %struct.mcs_node_s]* @nodes, i64 0, i64 %2, !dbg !223
  call void @mcslock_release(%struct.mcslock_s* noundef @lock, %struct.mcs_node_s* noundef %3), !dbg !224
  ret void, !dbg !225
}

; Function Attrs: noinline nounwind uwtable
define internal void @mcslock_release(%struct.mcslock_s* noundef %0, %struct.mcs_node_s* noundef %1) #0 !dbg !226 {
  call void @llvm.dbg.value(metadata %struct.mcslock_s* %0, metadata !227, metadata !DIExpression()), !dbg !228
  call void @llvm.dbg.value(metadata %struct.mcs_node_s* %1, metadata !229, metadata !DIExpression()), !dbg !228
  %3 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %1, i32 0, i32 0, !dbg !230
  %4 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %3), !dbg !232
  %5 = icmp eq i8* %4, null, !dbg !233
  br i1 %5, label %6, label %14, !dbg !234

6:                                                ; preds = %2
  %7 = getelementptr inbounds %struct.mcslock_s, %struct.mcslock_s* %0, i32 0, i32 0, !dbg !235
  %8 = bitcast %struct.mcs_node_s* %1 to i8*, !dbg !237
  %9 = call i8* @vatomicptr_cmpxchg_rel(%struct.vatomicptr_s* noundef %7, i8* noundef %8, i8* noundef null), !dbg !238
  %10 = bitcast i8* %9 to %struct.mcs_node_s*, !dbg !239
  call void @llvm.dbg.value(metadata %struct.mcs_node_s* %10, metadata !240, metadata !DIExpression()), !dbg !228
  %11 = icmp eq %struct.mcs_node_s* %10, %1, !dbg !241
  br i1 %11, label %18, label %12, !dbg !243

12:                                               ; preds = %6
  %13 = call i8* @vatomicptr_await_neq_rlx(%struct.vatomicptr_s* noundef %3, i8* noundef null), !dbg !244
  br label %14, !dbg !245

14:                                               ; preds = %12, %2
  %15 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %3), !dbg !246
  %16 = bitcast i8* %15 to %struct.mcs_node_s*, !dbg !247
  call void @llvm.dbg.value(metadata %struct.mcs_node_s* %16, metadata !240, metadata !DIExpression()), !dbg !228
  %17 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %16, i32 0, i32 1, !dbg !248
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %17, i32 noundef 0), !dbg !249
  br label %18, !dbg !250

18:                                               ; preds = %6, %14
  ret void, !dbg !250
}

; Function Attrs: noinline nounwind uwtable
define internal void @verification_loop_bound(i32 noundef %0) #0 !dbg !251 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !253, metadata !DIExpression()), !dbg !254
  ret void, !dbg !255
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !256 {
  call void @llvm.dbg.value(metadata %struct.vatomicptr_s* %0, metadata !261, metadata !DIExpression()), !dbg !262
  call void @llvm.dbg.value(metadata i8* %1, metadata !263, metadata !DIExpression()), !dbg !262
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !264, !srcloc !265
  %3 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %0, i32 0, i32 0, !dbg !266
  %4 = bitcast i8** %3 to i64*, !dbg !267
  %5 = ptrtoint i8* %1 to i64, !dbg !267
  store atomic i64 %5, i64* %4 monotonic, align 8, !dbg !267
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !268, !srcloc !269
  ret void, !dbg !270
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !271 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !275, metadata !DIExpression()), !dbg !276
  call void @llvm.dbg.value(metadata i32 %1, metadata !277, metadata !DIExpression()), !dbg !276
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !278, !srcloc !279
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !280
  store atomic i32 %1, i32* %3 monotonic, align 4, !dbg !281
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !282, !srcloc !283
  ret void, !dbg !284
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_cmpxchg(%struct.vatomicptr_s* noundef %0, i8* noundef %1, i8* noundef %2) #0 !dbg !285 {
  call void @llvm.dbg.value(metadata %struct.vatomicptr_s* %0, metadata !288, metadata !DIExpression()), !dbg !289
  call void @llvm.dbg.value(metadata i8* %1, metadata !290, metadata !DIExpression()), !dbg !289
  call void @llvm.dbg.value(metadata i8* %2, metadata !291, metadata !DIExpression()), !dbg !289
  call void @llvm.dbg.value(metadata i8* %1, metadata !292, metadata !DIExpression()), !dbg !289
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !293, !srcloc !294
  %4 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %0, i32 0, i32 0, !dbg !295
  %5 = bitcast i8** %4 to i64*, !dbg !296
  %6 = ptrtoint i8* %1 to i64, !dbg !296
  %7 = ptrtoint i8* %2 to i64, !dbg !296
  %8 = cmpxchg i64* %5, i64 %6, i64 %7 seq_cst seq_cst, align 8, !dbg !296
  %9 = extractvalue { i64, i1 } %8, 0, !dbg !296
  %10 = extractvalue { i64, i1 } %8, 1, !dbg !296
  %11 = inttoptr i64 %9 to i8*, !dbg !296
  %.0 = select i1 %10, i8* %1, i8* %11, !dbg !296
  call void @llvm.dbg.value(metadata i8* %.0, metadata !292, metadata !DIExpression()), !dbg !289
  %12 = zext i1 %10 to i8, !dbg !296
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !297, !srcloc !298
  ret i8* %.0, !dbg !299
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_xchg(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !300 {
  call void @llvm.dbg.value(metadata %struct.vatomicptr_s* %0, metadata !303, metadata !DIExpression()), !dbg !304
  call void @llvm.dbg.value(metadata i8* %1, metadata !305, metadata !DIExpression()), !dbg !304
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !306, !srcloc !307
  %3 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %0, i32 0, i32 0, !dbg !308
  %4 = bitcast i8** %3 to i64*, !dbg !309
  %5 = ptrtoint i8* %1 to i64, !dbg !309
  %6 = atomicrmw xchg i64* %4, i64 %5 seq_cst, align 8, !dbg !309
  %7 = inttoptr i64 %6 to i8*, !dbg !309
  call void @llvm.dbg.value(metadata i8* %7, metadata !310, metadata !DIExpression()), !dbg !304
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !311, !srcloc !312
  ret i8* %7, !dbg !313
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !314 {
  call void @llvm.dbg.value(metadata %struct.vatomicptr_s* %0, metadata !315, metadata !DIExpression()), !dbg !316
  call void @llvm.dbg.value(metadata i8* %1, metadata !317, metadata !DIExpression()), !dbg !316
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !318, !srcloc !319
  %3 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %0, i32 0, i32 0, !dbg !320
  %4 = bitcast i8** %3 to i64*, !dbg !321
  %5 = ptrtoint i8* %1 to i64, !dbg !321
  store atomic i64 %5, i64* %4 release, align 8, !dbg !321
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !322, !srcloc !323
  ret void, !dbg !324
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !325 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !329, metadata !DIExpression()), !dbg !330
  call void @llvm.dbg.value(metadata i32 %1, metadata !331, metadata !DIExpression()), !dbg !330
  call void @llvm.dbg.value(metadata i32 %1, metadata !332, metadata !DIExpression()), !dbg !330
  call void @llvm.dbg.value(metadata i32 0, metadata !333, metadata !DIExpression()), !dbg !330
  br label %3, !dbg !334

3:                                                ; preds = %3, %2
  %.0 = phi i32 [ %1, %2 ], [ %4, %3 ], !dbg !330
  call void @llvm.dbg.value(metadata i32 %.0, metadata !332, metadata !DIExpression()), !dbg !330
  %4 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0), !dbg !334
  call void @llvm.dbg.value(metadata i32 %4, metadata !333, metadata !DIExpression()), !dbg !330
  %5 = icmp ne i32 %4, %1, !dbg !334
  br i1 %5, label %3, label %6, !dbg !334, !llvm.loop !335

6:                                                ; preds = %3
  ret i32 %.0, !dbg !337
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !338 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !341, metadata !DIExpression()), !dbg !342
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !343, !srcloc !344
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !345
  %3 = load atomic i32, i32* %2 acquire, align 4, !dbg !346
  call void @llvm.dbg.value(metadata i32 %3, metadata !347, metadata !DIExpression()), !dbg !342
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !348, !srcloc !349
  ret i32 %3, !dbg !350
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %0) #0 !dbg !351 {
  call void @llvm.dbg.value(metadata %struct.vatomicptr_s* %0, metadata !354, metadata !DIExpression()), !dbg !355
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !356, !srcloc !357
  %2 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %0, i32 0, i32 0, !dbg !358
  %3 = bitcast i8** %2 to i64*, !dbg !359
  %4 = load atomic i64, i64* %3 monotonic, align 8, !dbg !359
  %5 = inttoptr i64 %4 to i8*, !dbg !359
  call void @llvm.dbg.value(metadata i8* %5, metadata !360, metadata !DIExpression()), !dbg !355
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !361, !srcloc !362
  ret i8* %5, !dbg !363
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_cmpxchg_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1, i8* noundef %2) #0 !dbg !364 {
  call void @llvm.dbg.value(metadata %struct.vatomicptr_s* %0, metadata !365, metadata !DIExpression()), !dbg !366
  call void @llvm.dbg.value(metadata i8* %1, metadata !367, metadata !DIExpression()), !dbg !366
  call void @llvm.dbg.value(metadata i8* %2, metadata !368, metadata !DIExpression()), !dbg !366
  call void @llvm.dbg.value(metadata i8* %1, metadata !369, metadata !DIExpression()), !dbg !366
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !370, !srcloc !371
  %4 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %0, i32 0, i32 0, !dbg !372
  %5 = bitcast i8** %4 to i64*, !dbg !373
  %6 = ptrtoint i8* %1 to i64, !dbg !373
  %7 = ptrtoint i8* %2 to i64, !dbg !373
  %8 = cmpxchg i64* %5, i64 %6, i64 %7 release monotonic, align 8, !dbg !373
  %9 = extractvalue { i64, i1 } %8, 0, !dbg !373
  %10 = extractvalue { i64, i1 } %8, 1, !dbg !373
  %11 = inttoptr i64 %9 to i8*, !dbg !373
  %.0 = select i1 %10, i8* %1, i8* %11, !dbg !373
  call void @llvm.dbg.value(metadata i8* %.0, metadata !369, metadata !DIExpression()), !dbg !366
  %12 = zext i1 %10 to i8, !dbg !373
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !374, !srcloc !375
  ret i8* %.0, !dbg !376
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_await_neq_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !377 {
  call void @llvm.dbg.value(metadata %struct.vatomicptr_s* %0, metadata !378, metadata !DIExpression()), !dbg !379
  call void @llvm.dbg.value(metadata i8* %1, metadata !380, metadata !DIExpression()), !dbg !379
  call void @llvm.dbg.value(metadata i8* null, metadata !381, metadata !DIExpression()), !dbg !379
  br label %3, !dbg !382

3:                                                ; preds = %3, %2
  %4 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %0), !dbg !382
  call void @llvm.dbg.value(metadata i8* %4, metadata !381, metadata !DIExpression()), !dbg !379
  %5 = icmp eq i8* %4, %1, !dbg !382
  br i1 %5, label %3, label %6, !dbg !382, !llvm.loop !383

6:                                                ; preds = %3
  ret i8* %4, !dbg !385
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %0) #0 !dbg !386 {
  call void @llvm.dbg.value(metadata %struct.vatomicptr_s* %0, metadata !387, metadata !DIExpression()), !dbg !388
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !389, !srcloc !390
  %2 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %0, i32 0, i32 0, !dbg !391
  %3 = bitcast i8** %2 to i64*, !dbg !392
  %4 = load atomic i64, i64* %3 acquire, align 8, !dbg !392
  %5 = inttoptr i64 %4 to i8*, !dbg !392
  call void @llvm.dbg.value(metadata i8* %5, metadata !393, metadata !DIExpression()), !dbg !388
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !394, !srcloc !395
  ret i8* %5, !dbg !396
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !397 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !398, metadata !DIExpression()), !dbg !399
  call void @llvm.dbg.value(metadata i32 %1, metadata !400, metadata !DIExpression()), !dbg !399
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !401, !srcloc !402
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !403
  store atomic i32 %1, i32* %3 release, align 4, !dbg !404
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !405, !srcloc !406
  ret void, !dbg !407
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
!llvm.module.flags = !{!49, !50, !51, !52, !53, !54, !55}
!llvm.ident = !{!56}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !48, line: 87, type: !27, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !33, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/libvsync/test/spinlock/mcslock.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "552b6400f9385bc00cb17b9555edb18b")
!4 = !{!5, !6, !11, !27}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !7, line: 36, baseType: !8)
!7 = !DIFile(filename: "./include/vsync/vtypes.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "6ac6784bf37e03e28013e7eed706797e")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !9, line: 90, baseType: !10)
!9 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!10 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "mcs_node_t", file: !13, line: 34, baseType: !14)
!13 = !DIFile(filename: "./include/vsync/spinlock/mcslock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "cb771bc86e8152f0a21a438d4f799bda")
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "mcs_node_s", file: !13, line: 31, size: 128, elements: !15)
!15 = !{!16, !22}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !14, file: !13, line: 32, baseType: !17, size: 64, align: 64)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomicptr_t", file: !18, line: 72, baseType: !19)
!18 = !DIFile(filename: "./include/vsync/atomic/core.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "1cc0657a82f0605ef67642f178a77e1c")
!19 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomicptr_s", file: !18, line: 70, size: 64, align: 64, elements: !20)
!20 = !{!21}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !19, file: !18, line: 71, baseType: !5, size: 64)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "locked", scope: !14, file: !13, line: 33, baseType: !23, size: 32, align: 32, offset: 64)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !18, line: 62, baseType: !24)
!24 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !18, line: 60, size: 32, align: 32, elements: !25)
!25 = !{!26}
!26 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !24, file: !18, line: 61, baseType: !27, size: 32)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !7, line: 34, baseType: !28)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !29, line: 26, baseType: !30)
!29 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !31, line: 42, baseType: !32)
!31 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!32 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!33 = !{!34, !41, !0, !46}
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !36, line: 10, type: !37, isLocal: false, isDefinition: true)
!36 = !DIFile(filename: "test/spinlock/mcslock.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "552b6400f9385bc00cb17b9555edb18b")
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "mcslock_t", file: !13, line: 39, baseType: !38)
!38 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "mcslock_s", file: !13, line: 37, size: 64, elements: !39)
!39 = !{!40}
!40 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !38, file: !13, line: 38, baseType: !17, size: 64, align: 64)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(name: "nodes", scope: !2, file: !36, line: 11, type: !43, isLocal: false, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 384, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 3)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !48, line: 88, type: !27, isLocal: true, isDefinition: true)
!48 = !DIFile(filename: "./include/test/boilerplate/lock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "c9c29de1465ea379ec6432998a180648")
!49 = !{i32 7, !"Dwarf Version", i32 5}
!50 = !{i32 2, !"Debug Info Version", i32 3}
!51 = !{i32 1, !"wchar_size", i32 4}
!52 = !{i32 7, !"PIC Level", i32 2}
!53 = !{i32 7, !"PIE Level", i32 2}
!54 = !{i32 7, !"uwtable", i32 1}
!55 = !{i32 7, !"frame-pointer", i32 2}
!56 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!57 = distinct !DISubprogram(name: "init", scope: !48, file: !48, line: 55, type: !58, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!58 = !DISubroutineType(types: !59)
!59 = !{null}
!60 = !{}
!61 = !DILocation(line: 57, column: 1, scope: !57)
!62 = distinct !DISubprogram(name: "post", scope: !48, file: !48, line: 64, type: !58, scopeLine: 65, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!63 = !DILocation(line: 66, column: 1, scope: !62)
!64 = distinct !DISubprogram(name: "fini", scope: !48, file: !48, line: 73, type: !58, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!65 = !DILocation(line: 75, column: 1, scope: !64)
!66 = distinct !DISubprogram(name: "cs", scope: !48, file: !48, line: 91, type: !58, scopeLine: 92, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!67 = !DILocation(line: 93, column: 8, scope: !66)
!68 = !DILocation(line: 94, column: 8, scope: !66)
!69 = !DILocation(line: 95, column: 1, scope: !66)
!70 = distinct !DISubprogram(name: "check", scope: !48, file: !48, line: 97, type: !58, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!71 = !DILocation(line: 99, column: 2, scope: !72)
!72 = distinct !DILexicalBlock(scope: !73, file: !48, line: 99, column: 2)
!73 = distinct !DILexicalBlock(scope: !70, file: !48, line: 99, column: 2)
!74 = !DILocation(line: 99, column: 2, scope: !73)
!75 = !DILocation(line: 100, column: 2, scope: !76)
!76 = distinct !DILexicalBlock(scope: !77, file: !48, line: 100, column: 2)
!77 = distinct !DILexicalBlock(scope: !70, file: !48, line: 100, column: 2)
!78 = !DILocation(line: 100, column: 2, scope: !77)
!79 = !DILocation(line: 101, column: 1, scope: !70)
!80 = distinct !DISubprogram(name: "main", scope: !48, file: !48, line: 136, type: !81, scopeLine: 137, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!81 = !DISubroutineType(types: !82)
!82 = !{!83}
!83 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!84 = !DILocalVariable(name: "t", scope: !80, file: !48, line: 138, type: !85)
!85 = !DICompositeType(tag: DW_TAG_array_type, baseType: !86, size: 192, elements: !44)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !87, line: 27, baseType: !10)
!87 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!88 = !DILocation(line: 138, column: 12, scope: !80)
!89 = !DILocation(line: 146, column: 2, scope: !80)
!90 = !DILocalVariable(name: "i", scope: !91, file: !48, line: 148, type: !6)
!91 = distinct !DILexicalBlock(scope: !80, file: !48, line: 148, column: 2)
!92 = !DILocation(line: 0, scope: !91)
!93 = !DILocation(line: 149, column: 25, scope: !94)
!94 = distinct !DILexicalBlock(scope: !95, file: !48, line: 148, column: 44)
!95 = distinct !DILexicalBlock(scope: !91, file: !48, line: 148, column: 2)
!96 = !DILocation(line: 149, column: 9, scope: !94)
!97 = !DILocation(line: 152, column: 2, scope: !80)
!98 = !DILocalVariable(name: "i", scope: !99, file: !48, line: 154, type: !6)
!99 = distinct !DILexicalBlock(scope: !80, file: !48, line: 154, column: 2)
!100 = !DILocation(line: 0, scope: !99)
!101 = !DILocation(line: 155, column: 22, scope: !102)
!102 = distinct !DILexicalBlock(scope: !103, file: !48, line: 154, column: 44)
!103 = distinct !DILexicalBlock(scope: !99, file: !48, line: 154, column: 2)
!104 = !DILocation(line: 155, column: 9, scope: !102)
!105 = !DILocation(line: 163, column: 2, scope: !80)
!106 = !DILocation(line: 164, column: 2, scope: !80)
!107 = !DILocation(line: 166, column: 2, scope: !80)
!108 = distinct !DISubprogram(name: "run", scope: !48, file: !48, line: 111, type: !109, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!109 = !DISubroutineType(types: !110)
!110 = !{!5, !5}
!111 = !DILocalVariable(name: "arg", arg: 1, scope: !108, file: !48, line: 111, type: !5)
!112 = !DILocation(line: 0, scope: !108)
!113 = !DILocation(line: 113, column: 18, scope: !108)
!114 = !DILocalVariable(name: "tid", scope: !108, file: !48, line: 113, type: !27)
!115 = !DILocation(line: 117, column: 2, scope: !108)
!116 = !DILocalVariable(name: "i", scope: !117, file: !48, line: 118, type: !83)
!117 = distinct !DILexicalBlock(scope: !108, file: !48, line: 118, column: 2)
!118 = !DILocation(line: 0, scope: !117)
!119 = !DILocation(line: 118, column: 7, scope: !117)
!120 = !DILocation(line: 118, column: 25, scope: !121)
!121 = distinct !DILexicalBlock(scope: !117, file: !48, line: 118, column: 2)
!122 = !DILocation(line: 118, column: 28, scope: !121)
!123 = !DILocation(line: 118, column: 2, scope: !117)
!124 = !DILocation(line: 122, column: 3, scope: !125)
!125 = distinct !DILexicalBlock(scope: !121, file: !48, line: 118, column: 60)
!126 = !DILocalVariable(name: "j", scope: !127, file: !48, line: 123, type: !83)
!127 = distinct !DILexicalBlock(scope: !125, file: !48, line: 123, column: 3)
!128 = !DILocation(line: 0, scope: !127)
!129 = !DILocation(line: 123, column: 8, scope: !127)
!130 = !DILocation(line: 123, column: 26, scope: !131)
!131 = distinct !DILexicalBlock(scope: !127, file: !48, line: 123, column: 3)
!132 = !DILocation(line: 123, column: 29, scope: !131)
!133 = !DILocation(line: 123, column: 3, scope: !127)
!134 = !DILocation(line: 124, column: 4, scope: !135)
!135 = distinct !DILexicalBlock(scope: !131, file: !48, line: 123, column: 61)
!136 = !DILocation(line: 125, column: 4, scope: !135)
!137 = !DILocation(line: 123, column: 57, scope: !131)
!138 = !DILocation(line: 123, column: 3, scope: !131)
!139 = distinct !{!139, !133, !140, !141}
!140 = !DILocation(line: 126, column: 3, scope: !127)
!141 = !{!"llvm.loop.mustprogress"}
!142 = !DILocation(line: 127, column: 3, scope: !125)
!143 = !DILocalVariable(name: "j", scope: !144, file: !48, line: 128, type: !83)
!144 = distinct !DILexicalBlock(scope: !125, file: !48, line: 128, column: 3)
!145 = !DILocation(line: 0, scope: !144)
!146 = !DILocation(line: 128, column: 8, scope: !144)
!147 = !DILocation(line: 128, column: 26, scope: !148)
!148 = distinct !DILexicalBlock(scope: !144, file: !48, line: 128, column: 3)
!149 = !DILocation(line: 128, column: 29, scope: !148)
!150 = !DILocation(line: 128, column: 3, scope: !144)
!151 = !DILocation(line: 129, column: 4, scope: !152)
!152 = distinct !DILexicalBlock(scope: !148, file: !48, line: 128, column: 61)
!153 = !DILocation(line: 128, column: 57, scope: !148)
!154 = !DILocation(line: 128, column: 3, scope: !148)
!155 = distinct !{!155, !150, !156, !141}
!156 = !DILocation(line: 130, column: 3, scope: !144)
!157 = !DILocation(line: 118, column: 56, scope: !121)
!158 = !DILocation(line: 118, column: 2, scope: !121)
!159 = distinct !{!159, !123, !160, !141}
!160 = !DILocation(line: 131, column: 2, scope: !117)
!161 = !DILocation(line: 132, column: 2, scope: !108)
!162 = distinct !DISubprogram(name: "acquire", scope: !36, file: !36, line: 14, type: !163, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!163 = !DISubroutineType(types: !164)
!164 = !{null, !27}
!165 = !DILocalVariable(name: "tid", arg: 1, scope: !162, file: !36, line: 14, type: !27)
!166 = !DILocation(line: 0, scope: !162)
!167 = !DILocation(line: 16, column: 10, scope: !168)
!168 = distinct !DILexicalBlock(scope: !162, file: !36, line: 16, column: 6)
!169 = !DILocation(line: 16, column: 6, scope: !162)
!170 = !DILocation(line: 17, column: 3, scope: !168)
!171 = distinct !{!171, !170, !172, !141}
!172 = !DILocation(line: 18, column: 4, scope: !168)
!173 = !DILocation(line: 20, column: 27, scope: !168)
!174 = !DILocation(line: 20, column: 3, scope: !168)
!175 = !DILocation(line: 21, column: 1, scope: !162)
!176 = distinct !DISubprogram(name: "mcslock_tryacquire", scope: !13, file: !13, line: 69, type: !177, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!177 = !DISubroutineType(types: !178)
!178 = !{!179, !181, !11}
!179 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !7, line: 43, baseType: !180)
!180 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!181 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!182 = !DILocalVariable(name: "l", arg: 1, scope: !176, file: !13, line: 69, type: !181)
!183 = !DILocation(line: 0, scope: !176)
!184 = !DILocalVariable(name: "node", arg: 2, scope: !176, file: !13, line: 69, type: !11)
!185 = !DILocation(line: 73, column: 30, scope: !176)
!186 = !DILocation(line: 73, column: 2, scope: !176)
!187 = !DILocation(line: 74, column: 29, scope: !176)
!188 = !DILocation(line: 74, column: 2, scope: !176)
!189 = !DILocation(line: 76, column: 46, scope: !176)
!190 = !DILocation(line: 76, column: 58, scope: !176)
!191 = !DILocation(line: 76, column: 23, scope: !176)
!192 = !DILocation(line: 76, column: 9, scope: !176)
!193 = !DILocalVariable(name: "pred", scope: !176, file: !13, line: 71, type: !11)
!194 = !DILocation(line: 78, column: 14, scope: !176)
!195 = !DILocation(line: 78, column: 2, scope: !176)
!196 = distinct !DISubprogram(name: "mcslock_acquire", scope: !13, file: !13, line: 88, type: !197, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!197 = !DISubroutineType(types: !198)
!198 = !{null, !181, !11}
!199 = !DILocalVariable(name: "l", arg: 1, scope: !196, file: !13, line: 88, type: !181)
!200 = !DILocation(line: 0, scope: !196)
!201 = !DILocalVariable(name: "node", arg: 2, scope: !196, file: !13, line: 88, type: !11)
!202 = !DILocation(line: 92, column: 30, scope: !196)
!203 = !DILocation(line: 92, column: 2, scope: !196)
!204 = !DILocation(line: 93, column: 29, scope: !196)
!205 = !DILocation(line: 93, column: 2, scope: !196)
!206 = !DILocation(line: 95, column: 43, scope: !196)
!207 = !DILocation(line: 95, column: 49, scope: !196)
!208 = !DILocation(line: 95, column: 23, scope: !196)
!209 = !DILocation(line: 95, column: 9, scope: !196)
!210 = !DILocalVariable(name: "pred", scope: !196, file: !13, line: 90, type: !11)
!211 = !DILocation(line: 96, column: 6, scope: !212)
!212 = distinct !DILexicalBlock(scope: !196, file: !13, line: 96, column: 6)
!213 = !DILocation(line: 96, column: 6, scope: !196)
!214 = !DILocation(line: 97, column: 31, scope: !215)
!215 = distinct !DILexicalBlock(scope: !212, file: !13, line: 96, column: 12)
!216 = !DILocation(line: 97, column: 3, scope: !215)
!217 = !DILocation(line: 98, column: 3, scope: !215)
!218 = !DILocation(line: 99, column: 2, scope: !215)
!219 = !DILocation(line: 100, column: 1, scope: !196)
!220 = distinct !DISubprogram(name: "release", scope: !36, file: !36, line: 24, type: !163, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!221 = !DILocalVariable(name: "tid", arg: 1, scope: !220, file: !36, line: 24, type: !27)
!222 = !DILocation(line: 0, scope: !220)
!223 = !DILocation(line: 26, column: 26, scope: !220)
!224 = !DILocation(line: 26, column: 2, scope: !220)
!225 = !DILocation(line: 27, column: 1, scope: !220)
!226 = distinct !DISubprogram(name: "mcslock_release", scope: !13, file: !13, line: 109, type: !197, scopeLine: 110, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!227 = !DILocalVariable(name: "l", arg: 1, scope: !226, file: !13, line: 109, type: !181)
!228 = !DILocation(line: 0, scope: !226)
!229 = !DILocalVariable(name: "node", arg: 2, scope: !226, file: !13, line: 109, type: !11)
!230 = !DILocation(line: 113, column: 33, scope: !231)
!231 = distinct !DILexicalBlock(scope: !226, file: !13, line: 113, column: 6)
!232 = !DILocation(line: 113, column: 6, scope: !231)
!233 = !DILocation(line: 113, column: 39, scope: !231)
!234 = !DILocation(line: 113, column: 6, scope: !226)
!235 = !DILocation(line: 114, column: 51, scope: !236)
!236 = distinct !DILexicalBlock(scope: !231, file: !13, line: 113, column: 48)
!237 = !DILocation(line: 114, column: 57, scope: !236)
!238 = !DILocation(line: 114, column: 24, scope: !236)
!239 = !DILocation(line: 114, column: 10, scope: !236)
!240 = !DILocalVariable(name: "next", scope: !226, file: !13, line: 111, type: !11)
!241 = !DILocation(line: 115, column: 12, scope: !242)
!242 = distinct !DILexicalBlock(scope: !236, file: !13, line: 115, column: 7)
!243 = !DILocation(line: 115, column: 7, scope: !236)
!244 = !DILocation(line: 118, column: 3, scope: !236)
!245 = !DILocation(line: 119, column: 2, scope: !236)
!246 = !DILocation(line: 120, column: 23, scope: !226)
!247 = !DILocation(line: 120, column: 9, scope: !226)
!248 = !DILocation(line: 121, column: 29, scope: !226)
!249 = !DILocation(line: 121, column: 2, scope: !226)
!250 = !DILocation(line: 122, column: 1, scope: !226)
!251 = distinct !DISubprogram(name: "verification_loop_bound", scope: !252, file: !252, line: 80, type: !163, scopeLine: 81, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!252 = !DIFile(filename: "./include/vsync/common/verify.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "3a0b94d9e7ec6d94ef39ae9297c4bc2a")
!253 = !DILocalVariable(name: "bound", arg: 1, scope: !251, file: !252, line: 80, type: !27)
!254 = !DILocation(line: 0, scope: !251)
!255 = !DILocation(line: 83, column: 1, scope: !251)
!256 = distinct !DISubprogram(name: "vatomicptr_write_rlx", scope: !257, file: !257, line: 568, type: !258, scopeLine: 569, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!257 = !DIFile(filename: "./include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "31d9a9647b315cadb2f817a7c8e98ecf")
!258 = !DISubroutineType(types: !259)
!259 = !{null, !260, !5}
!260 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!261 = !DILocalVariable(name: "a", arg: 1, scope: !256, file: !257, line: 568, type: !260)
!262 = !DILocation(line: 0, scope: !256)
!263 = !DILocalVariable(name: "v", arg: 2, scope: !256, file: !257, line: 568, type: !5)
!264 = !DILocation(line: 570, column: 2, scope: !256)
!265 = !{i64 2147855365}
!266 = !DILocation(line: 571, column: 23, scope: !256)
!267 = !DILocation(line: 571, column: 2, scope: !256)
!268 = !DILocation(line: 572, column: 2, scope: !256)
!269 = !{i64 2147855411}
!270 = !DILocation(line: 573, column: 1, scope: !256)
!271 = distinct !DISubprogram(name: "vatomic32_write_rlx", scope: !257, file: !257, line: 451, type: !272, scopeLine: 452, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!272 = !DISubroutineType(types: !273)
!273 = !{null, !274, !27}
!274 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!275 = !DILocalVariable(name: "a", arg: 1, scope: !271, file: !257, line: 451, type: !274)
!276 = !DILocation(line: 0, scope: !271)
!277 = !DILocalVariable(name: "v", arg: 2, scope: !271, file: !257, line: 451, type: !27)
!278 = !DILocation(line: 453, column: 2, scope: !271)
!279 = !{i64 2147854609}
!280 = !DILocation(line: 454, column: 23, scope: !271)
!281 = !DILocation(line: 454, column: 2, scope: !271)
!282 = !DILocation(line: 455, column: 2, scope: !271)
!283 = !{i64 2147854655}
!284 = !DILocation(line: 456, column: 1, scope: !271)
!285 = distinct !DISubprogram(name: "vatomicptr_cmpxchg", scope: !257, file: !257, line: 1289, type: !286, scopeLine: 1290, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!286 = !DISubroutineType(types: !287)
!287 = !{!5, !260, !5, !5}
!288 = !DILocalVariable(name: "a", arg: 1, scope: !285, file: !257, line: 1289, type: !260)
!289 = !DILocation(line: 0, scope: !285)
!290 = !DILocalVariable(name: "e", arg: 2, scope: !285, file: !257, line: 1289, type: !5)
!291 = !DILocalVariable(name: "v", arg: 3, scope: !285, file: !257, line: 1289, type: !5)
!292 = !DILocalVariable(name: "exp", scope: !285, file: !257, line: 1291, type: !5)
!293 = !DILocation(line: 1292, column: 2, scope: !285)
!294 = !{i64 2147859305}
!295 = !DILocation(line: 1293, column: 34, scope: !285)
!296 = !DILocation(line: 1293, column: 2, scope: !285)
!297 = !DILocation(line: 1296, column: 2, scope: !285)
!298 = !{i64 2147859359}
!299 = !DILocation(line: 1297, column: 2, scope: !285)
!300 = distinct !DISubprogram(name: "vatomicptr_xchg", scope: !257, file: !257, line: 885, type: !301, scopeLine: 886, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!301 = !DISubroutineType(types: !302)
!302 = !{!5, !260, !5}
!303 = !DILocalVariable(name: "a", arg: 1, scope: !300, file: !257, line: 885, type: !260)
!304 = !DILocation(line: 0, scope: !300)
!305 = !DILocalVariable(name: "v", arg: 2, scope: !300, file: !257, line: 885, type: !5)
!306 = !DILocation(line: 887, column: 2, scope: !300)
!307 = !{i64 2147857129}
!308 = !DILocation(line: 889, column: 7, scope: !300)
!309 = !DILocation(line: 888, column: 22, scope: !300)
!310 = !DILocalVariable(name: "tmp", scope: !300, file: !257, line: 888, type: !5)
!311 = !DILocation(line: 890, column: 2, scope: !300)
!312 = !{i64 2147857175}
!313 = !DILocation(line: 891, column: 2, scope: !300)
!314 = distinct !DISubprogram(name: "vatomicptr_write_rel", scope: !257, file: !257, line: 555, type: !258, scopeLine: 556, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!315 = !DILocalVariable(name: "a", arg: 1, scope: !314, file: !257, line: 555, type: !260)
!316 = !DILocation(line: 0, scope: !314)
!317 = !DILocalVariable(name: "v", arg: 2, scope: !314, file: !257, line: 555, type: !5)
!318 = !DILocation(line: 557, column: 2, scope: !314)
!319 = !{i64 2147855281}
!320 = !DILocation(line: 558, column: 23, scope: !314)
!321 = !DILocation(line: 558, column: 2, scope: !314)
!322 = !DILocation(line: 559, column: 2, scope: !314)
!323 = !{i64 2147855327}
!324 = !DILocation(line: 560, column: 1, scope: !314)
!325 = distinct !DISubprogram(name: "vatomic32_await_eq_acq", scope: !326, file: !326, line: 4389, type: !327, scopeLine: 4390, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!326 = !DIFile(filename: "./include/vsync/atomic/internal/fallback.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "bfc5d50ad810da3af0d582a48b47498f")
!327 = !DISubroutineType(types: !328)
!328 = !{!27, !274, !27}
!329 = !DILocalVariable(name: "a", arg: 1, scope: !325, file: !326, line: 4389, type: !274)
!330 = !DILocation(line: 0, scope: !325)
!331 = !DILocalVariable(name: "c", arg: 2, scope: !325, file: !326, line: 4389, type: !27)
!332 = !DILocalVariable(name: "ret", scope: !325, file: !326, line: 4391, type: !27)
!333 = !DILocalVariable(name: "o", scope: !325, file: !326, line: 4392, type: !27)
!334 = !DILocation(line: 4393, column: 2, scope: !325)
!335 = distinct !{!335, !334, !336, !141}
!336 = !DILocation(line: 4396, column: 2, scope: !325)
!337 = !DILocation(line: 4397, column: 2, scope: !325)
!338 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !257, file: !257, line: 178, type: !339, scopeLine: 179, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!339 = !DISubroutineType(types: !340)
!340 = !{!27, !274}
!341 = !DILocalVariable(name: "a", arg: 1, scope: !338, file: !257, line: 178, type: !274)
!342 = !DILocation(line: 0, scope: !338)
!343 = !DILocation(line: 180, column: 2, scope: !338)
!344 = !{i64 2147853013}
!345 = !DILocation(line: 182, column: 7, scope: !338)
!346 = !DILocation(line: 181, column: 29, scope: !338)
!347 = !DILocalVariable(name: "tmp", scope: !338, file: !257, line: 181, type: !27)
!348 = !DILocation(line: 183, column: 2, scope: !338)
!349 = !{i64 2147853059}
!350 = !DILocation(line: 184, column: 2, scope: !338)
!351 = distinct !DISubprogram(name: "vatomicptr_read_rlx", scope: !257, file: !257, line: 328, type: !352, scopeLine: 329, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!352 = !DISubroutineType(types: !353)
!353 = !{!5, !260}
!354 = !DILocalVariable(name: "a", arg: 1, scope: !351, file: !257, line: 328, type: !260)
!355 = !DILocation(line: 0, scope: !351)
!356 = !DILocation(line: 330, column: 2, scope: !351)
!357 = !{i64 2147853853}
!358 = !DILocation(line: 332, column: 7, scope: !351)
!359 = !DILocation(line: 331, column: 22, scope: !351)
!360 = !DILocalVariable(name: "tmp", scope: !351, file: !257, line: 331, type: !5)
!361 = !DILocation(line: 333, column: 2, scope: !351)
!362 = !{i64 2147853899}
!363 = !DILocation(line: 334, column: 2, scope: !351)
!364 = distinct !DISubprogram(name: "vatomicptr_cmpxchg_rel", scope: !257, file: !257, line: 1323, type: !286, scopeLine: 1324, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!365 = !DILocalVariable(name: "a", arg: 1, scope: !364, file: !257, line: 1323, type: !260)
!366 = !DILocation(line: 0, scope: !364)
!367 = !DILocalVariable(name: "e", arg: 2, scope: !364, file: !257, line: 1323, type: !5)
!368 = !DILocalVariable(name: "v", arg: 3, scope: !364, file: !257, line: 1323, type: !5)
!369 = !DILocalVariable(name: "exp", scope: !364, file: !257, line: 1325, type: !5)
!370 = !DILocation(line: 1326, column: 2, scope: !364)
!371 = !{i64 2147859489}
!372 = !DILocation(line: 1327, column: 34, scope: !364)
!373 = !DILocation(line: 1327, column: 2, scope: !364)
!374 = !DILocation(line: 1330, column: 2, scope: !364)
!375 = !{i64 2147859543}
!376 = !DILocation(line: 1331, column: 2, scope: !364)
!377 = distinct !DISubprogram(name: "vatomicptr_await_neq_rlx", scope: !326, file: !326, line: 4357, type: !301, scopeLine: 4358, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!378 = !DILocalVariable(name: "a", arg: 1, scope: !377, file: !326, line: 4357, type: !260)
!379 = !DILocation(line: 0, scope: !377)
!380 = !DILocalVariable(name: "c", arg: 2, scope: !377, file: !326, line: 4357, type: !5)
!381 = !DILocalVariable(name: "cur", scope: !377, file: !326, line: 4359, type: !5)
!382 = !DILocation(line: 4360, column: 2, scope: !377)
!383 = distinct !{!383, !382, !384, !141}
!384 = !DILocation(line: 4362, column: 2, scope: !377)
!385 = !DILocation(line: 4363, column: 2, scope: !377)
!386 = distinct !DISubprogram(name: "vatomicptr_read_acq", scope: !257, file: !257, line: 313, type: !352, scopeLine: 314, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!387 = !DILocalVariable(name: "a", arg: 1, scope: !386, file: !257, line: 313, type: !260)
!388 = !DILocation(line: 0, scope: !386)
!389 = !DILocation(line: 315, column: 2, scope: !386)
!390 = !{i64 2147853769}
!391 = !DILocation(line: 317, column: 7, scope: !386)
!392 = !DILocation(line: 316, column: 22, scope: !386)
!393 = !DILocalVariable(name: "tmp", scope: !386, file: !257, line: 316, type: !5)
!394 = !DILocation(line: 318, column: 2, scope: !386)
!395 = !{i64 2147853815}
!396 = !DILocation(line: 319, column: 2, scope: !386)
!397 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !257, file: !257, line: 438, type: !272, scopeLine: 439, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!398 = !DILocalVariable(name: "a", arg: 1, scope: !397, file: !257, line: 438, type: !274)
!399 = !DILocation(line: 0, scope: !397)
!400 = !DILocalVariable(name: "v", arg: 2, scope: !397, file: !257, line: 438, type: !27)
!401 = !DILocation(line: 440, column: 2, scope: !397)
!402 = !{i64 2147854525}
!403 = !DILocation(line: 441, column: 23, scope: !397)
!404 = !DILocation(line: 441, column: 2, scope: !397)
!405 = !DILocation(line: 442, column: 2, scope: !397)
!406 = !{i64 2147854571}
!407 = !DILocation(line: 443, column: 1, scope: !397)
