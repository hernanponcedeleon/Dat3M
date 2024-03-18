; ModuleID = '/home/drc/git/Dat3M/output/bounded_mpmc_check_empty.ll'
source_filename = "/home/drc/git/libvsync/test/queue/bounded_mpmc_check_empty.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bounded_mpmc_s = type { %struct.vatomic32_s, %struct.vatomic32_s, %struct.vatomic32_s, %struct.vatomic32_s, i8**, i32 }
%struct.vatomic32_s = type { i32 }
%struct.xbo_s = type { i32, i32, i32, i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_val = dso_local global [4 x i64] zeroinitializer, align 16, !dbg !0
@g_queue = dso_local global %struct.bounded_mpmc_s zeroinitializer, align 8, !dbg !36
@g_cs_x = dso_local global %struct.vatomic32_s zeroinitializer, align 4, !dbg !57
@.str = private unnamed_addr constant [14 x i8] c"idx < (2 * 2)\00", align 1
@.str.1 = private unnamed_addr constant [61 x i8] c"/home/drc/git/libvsync/test/queue/bounded_mpmc_check_empty.c\00", align 1
@__PRETTY_FUNCTION__.reader = private unnamed_addr constant [21 x i8] c"void *reader(void *)\00", align 1
@g_ret = dso_local global [4 x i64] zeroinitializer, align 16, !dbg !54
@.str.2 = private unnamed_addr constant [16 x i8] c"g_ret[idx] != 0\00", align 1
@g_buf = dso_local global [4 x i8*] zeroinitializer, align 16, !dbg !30
@.str.3 = private unnamed_addr constant [17 x i8] c"found == (2 * 2)\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.4 = private unnamed_addr constant [13 x i8] c"x == (2 * 2)\00", align 1
@.str.5 = private unnamed_addr constant [27 x i8] c"ret == QUEUE_BOUNDED_EMPTY\00", align 1
@.str.6 = private unnamed_addr constant [15 x i8] c"buffer is NULL\00", align 1
@.str.7 = private unnamed_addr constant [22 x i8] c"b && \22buffer is NULL\22\00", align 1
@.str.8 = private unnamed_addr constant [37 x i8] c"./include/vsync/queue/bounded_mpmc.h\00", align 1
@__PRETTY_FUNCTION__.bounded_mpmc_init = private unnamed_addr constant [61 x i8] c"void bounded_mpmc_init(bounded_mpmc_t *, void **, vuint32_t)\00", align 1
@.str.9 = private unnamed_addr constant [19 x i8] c"buffer with 0 size\00", align 1
@.str.10 = private unnamed_addr constant [31 x i8] c"s != 0 && \22buffer with 0 size\22\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @sched_yield() #0 !dbg !67 {
  ret i32 0, !dbg !72
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @writer(i8* noundef %0) #0 !dbg !73 {
  %2 = alloca %struct.xbo_s, align 4
  call void @llvm.dbg.value(metadata i8* %0, metadata !76, metadata !DIExpression()), !dbg !77
  %3 = ptrtoint i8* %0 to i64, !dbg !78
  call void @llvm.dbg.value(metadata i64 %3, metadata !79, metadata !DIExpression()), !dbg !77
  call void @llvm.dbg.declare(metadata %struct.xbo_s* %2, metadata !80, metadata !DIExpression()), !dbg !89
  call void @xbo_init(%struct.xbo_s* noundef %2, i32 noundef 0, i32 noundef 100, i32 noundef 2), !dbg !90
  call void @llvm.dbg.value(metadata i64 0, metadata !91, metadata !DIExpression()), !dbg !93
  call void @llvm.dbg.value(metadata i64 0, metadata !91, metadata !DIExpression()), !dbg !93
  %4 = mul i64 %3, 2, !dbg !94
  call void @llvm.dbg.value(metadata i64 %4, metadata !97, metadata !DIExpression()), !dbg !98
  %5 = mul i64 %3, 10, !dbg !99
  %6 = add i64 %5, 1, !dbg !100
  %7 = getelementptr inbounds [4 x i64], [4 x i64]* @g_val, i64 0, i64 %4, !dbg !101
  store i64 %6, i64* %7, align 8, !dbg !102
  br label %8, !dbg !103

8:                                                ; preds = %12, %1
  %9 = bitcast i64* %7 to i8*, !dbg !104
  %10 = call i32 @bounded_mpmc_enq(%struct.bounded_mpmc_s* noundef @g_queue, i8* noundef %9), !dbg !105
  %11 = icmp ne i32 %10, 0, !dbg !106
  br i1 %11, label %12, label %13, !dbg !103

12:                                               ; preds = %8
  call void @verification_ignore(), !dbg !107
  br label %8, !dbg !103, !llvm.loop !109

13:                                               ; preds = %8
  call void @xbo_reset(%struct.xbo_s* noundef %2), !dbg !112
  call void @llvm.dbg.value(metadata i64 1, metadata !91, metadata !DIExpression()), !dbg !93
  call void @llvm.dbg.value(metadata i64 1, metadata !91, metadata !DIExpression()), !dbg !93
  %14 = add i64 %4, 1, !dbg !113
  call void @llvm.dbg.value(metadata i64 %14, metadata !97, metadata !DIExpression()), !dbg !98
  %15 = add i64 %6, 1, !dbg !100
  %16 = getelementptr inbounds [4 x i64], [4 x i64]* @g_val, i64 0, i64 %14, !dbg !101
  store i64 %15, i64* %16, align 8, !dbg !102
  br label %17, !dbg !103

17:                                               ; preds = %22, %13
  %18 = bitcast i64* %16 to i8*, !dbg !104
  %19 = call i32 @bounded_mpmc_enq(%struct.bounded_mpmc_s* noundef @g_queue, i8* noundef %18), !dbg !105
  %20 = icmp ne i32 %19, 0, !dbg !106
  br i1 %20, label %22, label %21, !dbg !103

21:                                               ; preds = %17
  call void @xbo_reset(%struct.xbo_s* noundef %2), !dbg !112
  call void @llvm.dbg.value(metadata i64 2, metadata !91, metadata !DIExpression()), !dbg !93
  call void @llvm.dbg.value(metadata i64 2, metadata !91, metadata !DIExpression()), !dbg !93
  ret i8* null, !dbg !114

22:                                               ; preds = %17
  call void @verification_ignore(), !dbg !107
  br label %17, !dbg !103, !llvm.loop !109
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @xbo_init(%struct.xbo_s* noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) #0 !dbg !115 {
  call void @llvm.dbg.value(metadata %struct.xbo_s* %0, metadata !119, metadata !DIExpression()), !dbg !120
  call void @llvm.dbg.value(metadata i32 %1, metadata !121, metadata !DIExpression()), !dbg !120
  call void @llvm.dbg.value(metadata i32 %2, metadata !122, metadata !DIExpression()), !dbg !120
  call void @llvm.dbg.value(metadata i32 %3, metadata !123, metadata !DIExpression()), !dbg !120
  ret void, !dbg !124
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @bounded_mpmc_enq(%struct.bounded_mpmc_s* noundef %0, i8* noundef %1) #0 !dbg !125 {
  call void @llvm.dbg.value(metadata %struct.bounded_mpmc_s* %0, metadata !130, metadata !DIExpression()), !dbg !131
  call void @llvm.dbg.value(metadata i8* %1, metadata !132, metadata !DIExpression()), !dbg !131
  %3 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 0, !dbg !133
  %4 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %3), !dbg !134
  call void @llvm.dbg.value(metadata i32 %4, metadata !135, metadata !DIExpression()), !dbg !131
  %5 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 3, !dbg !136
  %6 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %5), !dbg !138
  %7 = sub i32 %4, %6, !dbg !139
  %8 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 5, !dbg !140
  %9 = load i32, i32* %8, align 8, !dbg !140
  %10 = icmp eq i32 %7, %9, !dbg !141
  br i1 %10, label %24, label %11, !dbg !142

11:                                               ; preds = %2
  %12 = add i32 %4, 1, !dbg !143
  call void @llvm.dbg.value(metadata i32 %12, metadata !144, metadata !DIExpression()), !dbg !131
  %13 = call i32 @vatomic32_cmpxchg_rel(%struct.vatomic32_s* noundef %3, i32 noundef %4, i32 noundef %12), !dbg !145
  %14 = icmp ne i32 %13, %4, !dbg !147
  br i1 %14, label %24, label %15, !dbg !148

15:                                               ; preds = %11
  %16 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 4, !dbg !149
  %17 = load i8**, i8*** %16, align 8, !dbg !149
  %18 = load i32, i32* %8, align 8, !dbg !150
  %19 = urem i32 %4, %18, !dbg !151
  %20 = zext i32 %19 to i64, !dbg !152
  %21 = getelementptr inbounds i8*, i8** %17, i64 %20, !dbg !152
  store i8* %1, i8** %21, align 8, !dbg !153
  %22 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 1, !dbg !154
  %23 = call i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %22, i32 noundef %4), !dbg !155
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %22, i32 noundef %12), !dbg !156
  br label %24, !dbg !157

24:                                               ; preds = %11, %2, %15
  %.0 = phi i32 [ 0, %15 ], [ 1, %2 ], [ 3, %11 ], !dbg !131
  ret i32 %.0, !dbg !158
}

; Function Attrs: noinline nounwind uwtable
define internal void @verification_ignore() #0 !dbg !159 {
  %1 = call i32 (i32, ...) bitcast (i32 (...)* @__VERIFIER_assume to i32 (i32, ...)*)(i32 noundef 0), !dbg !163
  ret void, !dbg !164
}

; Function Attrs: noinline nounwind uwtable
define internal void @xbo_reset(%struct.xbo_s* noundef %0) #0 !dbg !165 {
  call void @llvm.dbg.value(metadata %struct.xbo_s* %0, metadata !168, metadata !DIExpression()), !dbg !169
  ret void, !dbg !170
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @reader(i8* noundef %0) #0 !dbg !171 {
  %2 = alloca %struct.xbo_s, align 4
  %3 = alloca i8*, align 8
  call void @llvm.dbg.value(metadata i8* %0, metadata !172, metadata !DIExpression()), !dbg !173
  call void @llvm.dbg.value(metadata i8* %0, metadata !174, metadata !DIExpression()), !dbg !173
  call void @llvm.dbg.declare(metadata %struct.xbo_s* %2, metadata !175, metadata !DIExpression()), !dbg !176
  call void @xbo_init(%struct.xbo_s* noundef %2, i32 noundef 0, i32 noundef 100, i32 noundef 2), !dbg !177
  br label %4, !dbg !178

4:                                                ; preds = %20, %1
  call void @llvm.dbg.declare(metadata i8** %3, metadata !179, metadata !DIExpression()), !dbg !181
  store i8* null, i8** %3, align 8, !dbg !181
  %5 = call i32 @bounded_mpmc_deq(%struct.bounded_mpmc_s* noundef @g_queue, i8** noundef %3), !dbg !182
  %6 = icmp eq i32 %5, 0, !dbg !184
  br i1 %6, label %7, label %19, !dbg !185

7:                                                ; preds = %4
  %8 = call i32 @vatomic32_get_inc_rlx(%struct.vatomic32_s* noundef @g_cs_x), !dbg !186
  call void @llvm.dbg.value(metadata i32 %8, metadata !188, metadata !DIExpression()), !dbg !189
  %9 = icmp ult i32 %8, 4, !dbg !190
  br i1 %9, label %11, label %10, !dbg !193

10:                                               ; preds = %7
  call void @__assert_fail(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @.str.1, i64 0, i64 0), i32 noundef 86, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.reader, i64 0, i64 0)) #5, !dbg !190
  unreachable, !dbg !190

11:                                               ; preds = %7
  %12 = load i8*, i8** %3, align 8, !dbg !194
  %13 = bitcast i8* %12 to i64*, !dbg !195
  %14 = load i64, i64* %13, align 8, !dbg !196
  %15 = zext i32 %8 to i64, !dbg !197
  %16 = getelementptr inbounds [4 x i64], [4 x i64]* @g_ret, i64 0, i64 %15, !dbg !197
  store i64 %14, i64* %16, align 8, !dbg !198
  %17 = icmp ne i64 %14, 0, !dbg !199
  br i1 %17, label %20, label %18, !dbg !202

18:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @.str.1, i64 0, i64 0), i32 noundef 88, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.reader, i64 0, i64 0)) #5, !dbg !199
  unreachable, !dbg !199

19:                                               ; preds = %4
  call void @verification_ignore(), !dbg !203
  br label %20

20:                                               ; preds = %11, %19
  call void @xbo_reset(%struct.xbo_s* noundef %2), !dbg !205
  %21 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef @g_cs_x), !dbg !206
  %22 = icmp ne i32 %21, 4, !dbg !207
  br i1 %22, label %4, label %23, !dbg !208, !llvm.loop !209

23:                                               ; preds = %20
  ret i8* null, !dbg !211
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @bounded_mpmc_deq(%struct.bounded_mpmc_s* noundef %0, i8** noundef %1) #0 !dbg !212 {
  call void @llvm.dbg.value(metadata %struct.bounded_mpmc_s* %0, metadata !215, metadata !DIExpression()), !dbg !216
  call void @llvm.dbg.value(metadata i8** %1, metadata !217, metadata !DIExpression()), !dbg !216
  %3 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 2, !dbg !218
  %4 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %3), !dbg !219
  call void @llvm.dbg.value(metadata i32 %4, metadata !220, metadata !DIExpression()), !dbg !216
  %5 = add i32 %4, 1, !dbg !221
  call void @llvm.dbg.value(metadata i32 %5, metadata !222, metadata !DIExpression()), !dbg !216
  %6 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 1, !dbg !223
  %7 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %6), !dbg !225
  %8 = icmp eq i32 %4, %7, !dbg !226
  br i1 %8, label %23, label %9, !dbg !227

9:                                                ; preds = %2
  %10 = call i32 @vatomic32_cmpxchg_rel(%struct.vatomic32_s* noundef %3, i32 noundef %4, i32 noundef %5), !dbg !228
  %11 = icmp ne i32 %10, %4, !dbg !230
  br i1 %11, label %23, label %12, !dbg !231

12:                                               ; preds = %9
  %13 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 4, !dbg !232
  %14 = load i8**, i8*** %13, align 8, !dbg !232
  %15 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 5, !dbg !233
  %16 = load i32, i32* %15, align 8, !dbg !233
  %17 = urem i32 %4, %16, !dbg !234
  %18 = zext i32 %17 to i64, !dbg !235
  %19 = getelementptr inbounds i8*, i8** %14, i64 %18, !dbg !235
  %20 = load i8*, i8** %19, align 8, !dbg !235
  store i8* %20, i8** %1, align 8, !dbg !236
  %21 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 3, !dbg !237
  %22 = call i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %21, i32 noundef %4), !dbg !238
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %21, i32 noundef %5), !dbg !239
  br label %23, !dbg !240

23:                                               ; preds = %9, %2, %12
  %.0 = phi i32 [ 0, %12 ], [ 2, %2 ], [ 3, %9 ], !dbg !216
  ret i32 %.0, !dbg !241
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !242 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !247, metadata !DIExpression()), !dbg !248
  %2 = call i32 @vatomic32_get_add_rlx(%struct.vatomic32_s* noundef %0, i32 noundef 1), !dbg !249
  ret i32 %2, !dbg !250
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !251 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !253, metadata !DIExpression()), !dbg !254
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !255, !srcloc !256
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !257
  %3 = load atomic i32, i32* %2 monotonic, align 4, !dbg !258
  call void @llvm.dbg.value(metadata i32 %3, metadata !259, metadata !DIExpression()), !dbg !254
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !260, !srcloc !261
  ret i32 %3, !dbg !262
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !263 {
  %1 = alloca [4 x i64], align 16
  %2 = alloca i8*, align 8
  call void @bounded_mpmc_init(%struct.bounded_mpmc_s* noundef @g_queue, i8** noundef getelementptr inbounds ([4 x i8*], [4 x i8*]* @g_buf, i64 0, i64 0), i32 noundef 4), !dbg !264
  call void @llvm.dbg.declare(metadata [4 x i64]* %1, metadata !265, metadata !DIExpression()), !dbg !269
  call void @llvm.dbg.value(metadata i64 0, metadata !270, metadata !DIExpression()), !dbg !272
  call void @llvm.dbg.value(metadata i64 0, metadata !270, metadata !DIExpression()), !dbg !272
  %3 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 0, !dbg !273
  %4 = call i32 @pthread_create(i64* noundef %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer, i8* noundef null) #6, !dbg !276
  call void @llvm.dbg.value(metadata i64 1, metadata !270, metadata !DIExpression()), !dbg !272
  call void @llvm.dbg.value(metadata i64 1, metadata !270, metadata !DIExpression()), !dbg !272
  %5 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 1, !dbg !273
  %6 = call i32 @pthread_create(i64* noundef %5, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !276
  call void @llvm.dbg.value(metadata i64 2, metadata !270, metadata !DIExpression()), !dbg !272
  call void @llvm.dbg.value(metadata i64 2, metadata !270, metadata !DIExpression()), !dbg !272
  call void @llvm.dbg.value(metadata i64 0, metadata !277, metadata !DIExpression()), !dbg !279
  call void @llvm.dbg.value(metadata i64 0, metadata !277, metadata !DIExpression()), !dbg !279
  %7 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 2, !dbg !280
  %8 = call i32 @pthread_create(i64* noundef %7, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef null) #6, !dbg !283
  call void @llvm.dbg.value(metadata i64 1, metadata !277, metadata !DIExpression()), !dbg !279
  call void @llvm.dbg.value(metadata i64 1, metadata !277, metadata !DIExpression()), !dbg !279
  %9 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 3, !dbg !280
  %10 = call i32 @pthread_create(i64* noundef %9, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !283
  call void @llvm.dbg.value(metadata i64 2, metadata !277, metadata !DIExpression()), !dbg !279
  call void @llvm.dbg.value(metadata i64 2, metadata !277, metadata !DIExpression()), !dbg !279
  call void @llvm.dbg.value(metadata i64 0, metadata !284, metadata !DIExpression()), !dbg !286
  call void @llvm.dbg.value(metadata i64 0, metadata !284, metadata !DIExpression()), !dbg !286
  %11 = load i64, i64* %3, align 8, !dbg !287
  %12 = call i32 @pthread_join(i64 noundef %11, i8** noundef null), !dbg !290
  call void @llvm.dbg.value(metadata i64 1, metadata !284, metadata !DIExpression()), !dbg !286
  call void @llvm.dbg.value(metadata i64 1, metadata !284, metadata !DIExpression()), !dbg !286
  %13 = load i64, i64* %5, align 8, !dbg !287
  %14 = call i32 @pthread_join(i64 noundef %13, i8** noundef null), !dbg !290
  call void @llvm.dbg.value(metadata i64 2, metadata !284, metadata !DIExpression()), !dbg !286
  call void @llvm.dbg.value(metadata i64 2, metadata !284, metadata !DIExpression()), !dbg !286
  %15 = load i64, i64* %7, align 8, !dbg !287
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null), !dbg !290
  call void @llvm.dbg.value(metadata i64 3, metadata !284, metadata !DIExpression()), !dbg !286
  call void @llvm.dbg.value(metadata i64 3, metadata !284, metadata !DIExpression()), !dbg !286
  %17 = load i64, i64* %9, align 8, !dbg !287
  %18 = call i32 @pthread_join(i64 noundef %17, i8** noundef null), !dbg !290
  call void @llvm.dbg.value(metadata i64 4, metadata !284, metadata !DIExpression()), !dbg !286
  call void @llvm.dbg.value(metadata i64 4, metadata !284, metadata !DIExpression()), !dbg !286
  call void @llvm.dbg.value(metadata i32 0, metadata !291, metadata !DIExpression()), !dbg !292
  call void @llvm.dbg.value(metadata i32 0, metadata !293, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i32 0, metadata !291, metadata !DIExpression()), !dbg !292
  call void @llvm.dbg.value(metadata i64 0, metadata !293, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i32 0, metadata !296, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata i64 0, metadata !296, metadata !DIExpression()), !dbg !300
  %19 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_val, i64 0, i64 0), align 8, !dbg !301
  %20 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_ret, i64 0, i64 0), align 8, !dbg !305
  %21 = icmp eq i64 %19, %20, !dbg !306
  br i1 %21, label %22, label %23, !dbg !307

22:                                               ; preds = %29, %26, %23, %0
  store i64 16777215, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_val, i64 0, i64 0), align 8, !dbg !308
  call void @llvm.dbg.value(metadata i32 1, metadata !291, metadata !DIExpression()), !dbg !292
  br label %.loopexit, !dbg !310

23:                                               ; preds = %0
  call void @llvm.dbg.value(metadata i64 1, metadata !296, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata i64 1, metadata !296, metadata !DIExpression()), !dbg !300
  %24 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_ret, i64 0, i64 1), align 8, !dbg !305
  %25 = icmp eq i64 %19, %24, !dbg !306
  br i1 %25, label %22, label %26, !dbg !307

26:                                               ; preds = %23
  call void @llvm.dbg.value(metadata i64 2, metadata !296, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata i64 2, metadata !296, metadata !DIExpression()), !dbg !300
  %27 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_ret, i64 0, i64 2), align 8, !dbg !305
  %28 = icmp eq i64 %19, %27, !dbg !306
  br i1 %28, label %22, label %29, !dbg !307

29:                                               ; preds = %26
  call void @llvm.dbg.value(metadata i64 3, metadata !296, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata i64 3, metadata !296, metadata !DIExpression()), !dbg !300
  %30 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_ret, i64 0, i64 3), align 8, !dbg !305
  %31 = icmp eq i64 %19, %30, !dbg !306
  br i1 %31, label %22, label %.loopexit, !dbg !307

.loopexit:                                        ; preds = %29, %22
  %.1 = phi i32 [ 1, %22 ], [ 0, %29 ], !dbg !292
  call void @llvm.dbg.value(metadata i32 %.1, metadata !291, metadata !DIExpression()), !dbg !292
  call void @llvm.dbg.value(metadata i64 1, metadata !293, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i32 %.1, metadata !291, metadata !DIExpression()), !dbg !292
  call void @llvm.dbg.value(metadata i64 1, metadata !293, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i32 0, metadata !296, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata i64 0, metadata !296, metadata !DIExpression()), !dbg !300
  %32 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_val, i64 0, i64 1), align 8, !dbg !301
  %33 = icmp eq i64 %32, %20, !dbg !306
  br i1 %33, label %43, label %34, !dbg !307

34:                                               ; preds = %.loopexit
  call void @llvm.dbg.value(metadata i64 1, metadata !296, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata i64 1, metadata !296, metadata !DIExpression()), !dbg !300
  %35 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_ret, i64 0, i64 1), align 8, !dbg !305
  %36 = icmp eq i64 %32, %35, !dbg !306
  br i1 %36, label %43, label %37, !dbg !307

37:                                               ; preds = %34
  call void @llvm.dbg.value(metadata i64 2, metadata !296, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata i64 2, metadata !296, metadata !DIExpression()), !dbg !300
  %38 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_ret, i64 0, i64 2), align 8, !dbg !305
  %39 = icmp eq i64 %32, %38, !dbg !306
  br i1 %39, label %43, label %40, !dbg !307

40:                                               ; preds = %37
  call void @llvm.dbg.value(metadata i64 3, metadata !296, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata i64 3, metadata !296, metadata !DIExpression()), !dbg !300
  %41 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_ret, i64 0, i64 3), align 8, !dbg !305
  %42 = icmp eq i64 %32, %41, !dbg !306
  br i1 %42, label %43, label %.loopexit.1, !dbg !307

43:                                               ; preds = %40, %37, %34, %.loopexit
  store i64 16777215, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_val, i64 0, i64 1), align 8, !dbg !308
  %44 = add nsw i32 %.1, 1, !dbg !311
  call void @llvm.dbg.value(metadata i32 %44, metadata !291, metadata !DIExpression()), !dbg !292
  br label %.loopexit.1, !dbg !310

.loopexit.1:                                      ; preds = %40, %43
  %.1.1 = phi i32 [ %44, %43 ], [ %.1, %40 ], !dbg !292
  call void @llvm.dbg.value(metadata i32 %.1.1, metadata !291, metadata !DIExpression()), !dbg !292
  call void @llvm.dbg.value(metadata i64 2, metadata !293, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i32 %.1.1, metadata !291, metadata !DIExpression()), !dbg !292
  call void @llvm.dbg.value(metadata i64 2, metadata !293, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i32 0, metadata !296, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata i64 0, metadata !296, metadata !DIExpression()), !dbg !300
  %45 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_val, i64 0, i64 2), align 8, !dbg !301
  %46 = icmp eq i64 %45, %20, !dbg !306
  br i1 %46, label %56, label %47, !dbg !307

47:                                               ; preds = %.loopexit.1
  call void @llvm.dbg.value(metadata i64 1, metadata !296, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata i64 1, metadata !296, metadata !DIExpression()), !dbg !300
  %48 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_ret, i64 0, i64 1), align 8, !dbg !305
  %49 = icmp eq i64 %45, %48, !dbg !306
  br i1 %49, label %56, label %50, !dbg !307

50:                                               ; preds = %47
  call void @llvm.dbg.value(metadata i64 2, metadata !296, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata i64 2, metadata !296, metadata !DIExpression()), !dbg !300
  %51 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_ret, i64 0, i64 2), align 8, !dbg !305
  %52 = icmp eq i64 %45, %51, !dbg !306
  br i1 %52, label %56, label %53, !dbg !307

53:                                               ; preds = %50
  call void @llvm.dbg.value(metadata i64 3, metadata !296, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata i64 3, metadata !296, metadata !DIExpression()), !dbg !300
  %54 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_ret, i64 0, i64 3), align 8, !dbg !305
  %55 = icmp eq i64 %45, %54, !dbg !306
  br i1 %55, label %56, label %.loopexit.2, !dbg !307

56:                                               ; preds = %53, %50, %47, %.loopexit.1
  store i64 16777215, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_val, i64 0, i64 2), align 8, !dbg !308
  %57 = add nsw i32 %.1.1, 1, !dbg !311
  call void @llvm.dbg.value(metadata i32 %57, metadata !291, metadata !DIExpression()), !dbg !292
  br label %.loopexit.2, !dbg !310

.loopexit.2:                                      ; preds = %53, %56
  %.1.2 = phi i32 [ %57, %56 ], [ %.1.1, %53 ], !dbg !292
  call void @llvm.dbg.value(metadata i32 %.1.2, metadata !291, metadata !DIExpression()), !dbg !292
  call void @llvm.dbg.value(metadata i64 3, metadata !293, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i32 %.1.2, metadata !291, metadata !DIExpression()), !dbg !292
  call void @llvm.dbg.value(metadata i64 3, metadata !293, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i32 0, metadata !296, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata i64 0, metadata !296, metadata !DIExpression()), !dbg !300
  %58 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_val, i64 0, i64 3), align 8, !dbg !301
  %59 = icmp eq i64 %58, %20, !dbg !306
  br i1 %59, label %69, label %60, !dbg !307

60:                                               ; preds = %.loopexit.2
  call void @llvm.dbg.value(metadata i64 1, metadata !296, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata i64 1, metadata !296, metadata !DIExpression()), !dbg !300
  %61 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_ret, i64 0, i64 1), align 8, !dbg !305
  %62 = icmp eq i64 %58, %61, !dbg !306
  br i1 %62, label %69, label %63, !dbg !307

63:                                               ; preds = %60
  call void @llvm.dbg.value(metadata i64 2, metadata !296, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata i64 2, metadata !296, metadata !DIExpression()), !dbg !300
  %64 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_ret, i64 0, i64 2), align 8, !dbg !305
  %65 = icmp eq i64 %58, %64, !dbg !306
  br i1 %65, label %69, label %66, !dbg !307

66:                                               ; preds = %63
  call void @llvm.dbg.value(metadata i64 3, metadata !296, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata i64 3, metadata !296, metadata !DIExpression()), !dbg !300
  %67 = load i64, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_ret, i64 0, i64 3), align 8, !dbg !305
  %68 = icmp eq i64 %58, %67, !dbg !306
  br i1 %68, label %69, label %.loopexit.3, !dbg !307

69:                                               ; preds = %66, %63, %60, %.loopexit.2
  store i64 16777215, i64* getelementptr inbounds ([4 x i64], [4 x i64]* @g_val, i64 0, i64 3), align 8, !dbg !308
  %70 = add nsw i32 %.1.2, 1, !dbg !311
  call void @llvm.dbg.value(metadata i32 %70, metadata !291, metadata !DIExpression()), !dbg !292
  br label %.loopexit.3, !dbg !310

.loopexit.3:                                      ; preds = %66, %69
  %.04.lcssa = phi i32 [ %70, %69 ], [ %.1.2, %66 ], !dbg !292
  call void @llvm.dbg.value(metadata i32 %.04.lcssa, metadata !291, metadata !DIExpression()), !dbg !292
  call void @llvm.dbg.value(metadata i64 4, metadata !293, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i32 %.04.lcssa, metadata !291, metadata !DIExpression()), !dbg !292
  call void @llvm.dbg.value(metadata i64 4, metadata !293, metadata !DIExpression()), !dbg !295
  %71 = icmp eq i32 %.04.lcssa, 4, !dbg !312
  br i1 %71, label %73, label %72, !dbg !315

72:                                               ; preds = %.loopexit.3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @.str.1, i64 0, i64 0), i32 noundef 128, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !312
  unreachable, !dbg !312

73:                                               ; preds = %.loopexit.3
  %74 = call i32 @vatomic32_read(%struct.vatomic32_s* noundef @g_cs_x), !dbg !316
  call void @llvm.dbg.value(metadata i32 %74, metadata !317, metadata !DIExpression()), !dbg !292
  %75 = icmp eq i32 %74, 4, !dbg !318
  br i1 %75, label %77, label %76, !dbg !321

76:                                               ; preds = %73
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @.str.1, i64 0, i64 0), i32 noundef 130, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !318
  unreachable, !dbg !318

77:                                               ; preds = %73
  call void @llvm.dbg.declare(metadata i8** %2, metadata !322, metadata !DIExpression()), !dbg !323
  store i8* null, i8** %2, align 8, !dbg !323
  %78 = call i32 @bounded_mpmc_deq(%struct.bounded_mpmc_s* noundef @g_queue, i8** noundef %2), !dbg !324
  call void @llvm.dbg.value(metadata i32 %78, metadata !325, metadata !DIExpression()), !dbg !292
  %79 = icmp eq i32 %78, 2, !dbg !326
  br i1 %79, label %81, label %80, !dbg !329

80:                                               ; preds = %77
  call void @__assert_fail(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @.str.1, i64 0, i64 0), i32 noundef 134, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !326
  unreachable, !dbg !326

81:                                               ; preds = %77
  ret i32 0, !dbg !330
}

; Function Attrs: noinline nounwind uwtable
define internal void @bounded_mpmc_init(%struct.bounded_mpmc_s* noundef %0, i8** noundef %1, i32 noundef %2) #0 !dbg !331 {
  call void @llvm.dbg.value(metadata %struct.bounded_mpmc_s* %0, metadata !334, metadata !DIExpression()), !dbg !335
  call void @llvm.dbg.value(metadata i8** %1, metadata !336, metadata !DIExpression()), !dbg !335
  call void @llvm.dbg.value(metadata i32 %2, metadata !337, metadata !DIExpression()), !dbg !335
  %4 = icmp ne i8** %1, null, !dbg !338
  br i1 %4, label %6, label %5, !dbg !338

5:                                                ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.7, i64 0, i64 0), i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @.str.8, i64 0, i64 0), i32 noundef 51, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__.bounded_mpmc_init, i64 0, i64 0)) #5, !dbg !338
  unreachable, !dbg !338

6:                                                ; preds = %3
  %7 = icmp ne i32 %2, 0, !dbg !341
  br i1 %7, label %9, label %8, !dbg !341

8:                                                ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str.10, i64 0, i64 0), i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @.str.8, i64 0, i64 0), i32 noundef 52, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__.bounded_mpmc_init, i64 0, i64 0)) #5, !dbg !341
  unreachable, !dbg !341

9:                                                ; preds = %6
  %10 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 4, !dbg !344
  store i8** %1, i8*** %10, align 8, !dbg !345
  %11 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 5, !dbg !346
  store i32 %2, i32* %11, align 8, !dbg !347
  %12 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 2, !dbg !348
  call void @vatomic32_init(%struct.vatomic32_s* noundef %12, i32 noundef 0), !dbg !349
  %13 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 3, !dbg !350
  call void @vatomic32_init(%struct.vatomic32_s* noundef %13, i32 noundef 0), !dbg !351
  %14 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 0, !dbg !352
  call void @vatomic32_init(%struct.vatomic32_s* noundef %14, i32 noundef 0), !dbg !353
  %15 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 1, !dbg !354
  call void @vatomic32_init(%struct.vatomic32_s* noundef %15, i32 noundef 0), !dbg !355
  ret void, !dbg !356
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read(%struct.vatomic32_s* noundef %0) #0 !dbg !357 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !358, metadata !DIExpression()), !dbg !359
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !360, !srcloc !361
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !362
  %3 = load atomic i32, i32* %2 seq_cst, align 4, !dbg !363
  call void @llvm.dbg.value(metadata i32 %3, metadata !364, metadata !DIExpression()), !dbg !359
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !365, !srcloc !366
  ret i32 %3, !dbg !367
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !368 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !369, metadata !DIExpression()), !dbg !370
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !371, !srcloc !372
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !373
  %3 = load atomic i32, i32* %2 acquire, align 4, !dbg !374
  call void @llvm.dbg.value(metadata i32 %3, metadata !375, metadata !DIExpression()), !dbg !370
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !376, !srcloc !377
  ret i32 %3, !dbg !378
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !379 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !382, metadata !DIExpression()), !dbg !383
  call void @llvm.dbg.value(metadata i32 %1, metadata !384, metadata !DIExpression()), !dbg !383
  call void @llvm.dbg.value(metadata i32 %2, metadata !385, metadata !DIExpression()), !dbg !383
  call void @llvm.dbg.value(metadata i32 %1, metadata !386, metadata !DIExpression()), !dbg !383
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !387, !srcloc !388
  %4 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !389
  %5 = cmpxchg i32* %4, i32 %1, i32 %2 release monotonic, align 4, !dbg !390
  %6 = extractvalue { i32, i1 } %5, 0, !dbg !390
  %7 = extractvalue { i32, i1 } %5, 1, !dbg !390
  %spec.select = select i1 %7, i32 %1, i32 %6, !dbg !390
  call void @llvm.dbg.value(metadata i32 %spec.select, metadata !386, metadata !DIExpression()), !dbg !383
  %8 = zext i1 %7 to i8, !dbg !390
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !391, !srcloc !392
  ret i32 %spec.select, !dbg !393
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !394 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !397, metadata !DIExpression()), !dbg !398
  call void @llvm.dbg.value(metadata i32 %1, metadata !399, metadata !DIExpression()), !dbg !398
  call void @llvm.dbg.value(metadata i32 %1, metadata !400, metadata !DIExpression()), !dbg !398
  call void @llvm.dbg.value(metadata i32 0, metadata !401, metadata !DIExpression()), !dbg !398
  br label %3, !dbg !402

3:                                                ; preds = %3, %2
  %.0 = phi i32 [ %1, %2 ], [ %4, %3 ], !dbg !398
  call void @llvm.dbg.value(metadata i32 %.0, metadata !400, metadata !DIExpression()), !dbg !398
  %4 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0), !dbg !402
  call void @llvm.dbg.value(metadata i32 %4, metadata !401, metadata !DIExpression()), !dbg !398
  %5 = icmp ne i32 %4, %1, !dbg !402
  br i1 %5, label %3, label %6, !dbg !402, !llvm.loop !403

6:                                                ; preds = %3
  ret i32 %.0, !dbg !405
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !406 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !409, metadata !DIExpression()), !dbg !410
  call void @llvm.dbg.value(metadata i32 %1, metadata !411, metadata !DIExpression()), !dbg !410
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !412, !srcloc !413
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !414
  store atomic i32 %1, i32* %3 release, align 4, !dbg !415
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !416, !srcloc !417
  ret void, !dbg !418
}

declare i32 @__VERIFIER_assume(...) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !419 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !420, metadata !DIExpression()), !dbg !421
  call void @llvm.dbg.value(metadata i32 %1, metadata !422, metadata !DIExpression()), !dbg !421
  call void @llvm.dbg.value(metadata i32 %1, metadata !423, metadata !DIExpression()), !dbg !421
  call void @llvm.dbg.value(metadata i32 0, metadata !424, metadata !DIExpression()), !dbg !421
  br label %3, !dbg !425

3:                                                ; preds = %3, %2
  %.0 = phi i32 [ %1, %2 ], [ %4, %3 ], !dbg !421
  call void @llvm.dbg.value(metadata i32 %.0, metadata !423, metadata !DIExpression()), !dbg !421
  %4 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0), !dbg !425
  call void @llvm.dbg.value(metadata i32 %4, metadata !424, metadata !DIExpression()), !dbg !421
  %5 = icmp ne i32 %4, %1, !dbg !425
  br i1 %5, label %3, label %6, !dbg !425, !llvm.loop !426

6:                                                ; preds = %3
  ret i32 %.0, !dbg !428
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !429 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !430, metadata !DIExpression()), !dbg !431
  call void @llvm.dbg.value(metadata i32 %1, metadata !432, metadata !DIExpression()), !dbg !431
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !433, !srcloc !434
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !435
  %4 = atomicrmw add i32* %3, i32 %1 monotonic, align 4, !dbg !436
  call void @llvm.dbg.value(metadata i32 %4, metadata !437, metadata !DIExpression()), !dbg !431
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !438, !srcloc !439
  ret i32 %4, !dbg !440
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_init(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !441 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !442, metadata !DIExpression()), !dbg !443
  call void @llvm.dbg.value(metadata i32 %1, metadata !444, metadata !DIExpression()), !dbg !443
  call void @vatomic32_write(%struct.vatomic32_s* noundef %0, i32 noundef %1), !dbg !445
  ret void, !dbg !446
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !447 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !448, metadata !DIExpression()), !dbg !449
  call void @llvm.dbg.value(metadata i32 %1, metadata !450, metadata !DIExpression()), !dbg !449
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !451, !srcloc !452
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !453
  store atomic i32 %1, i32* %3 seq_cst, align 4, !dbg !454
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !455, !srcloc !456
  ret void, !dbg !457
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!59, !60, !61, !62, !63, !64, !65}
!llvm.ident = !{!66}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_val", scope: !2, file: !32, line: 49, type: !56, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !13, globals: !29, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/libvsync/test/queue/bounded_mpmc_check_empty.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "ed4542782c13f0479c0d03705375d1ad")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 8, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "./include/vsync/queue/internal/bounded_ret.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "c46e1376bff92f38e6ff9a1c56080188")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12}
!9 = !DIEnumerator(name: "QUEUE_BOUNDED_OK", value: 0)
!10 = !DIEnumerator(name: "QUEUE_BOUNDED_FULL", value: 1)
!11 = !DIEnumerator(name: "QUEUE_BOUNDED_EMPTY", value: 2)
!12 = !DIEnumerator(name: "QUEUE_BOUNDED_AGAIN", value: 3)
!13 = !{!14, !19, !20, !24}
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !15, line: 36, baseType: !16)
!15 = !DIFile(filename: "./include/vsync/vtypes.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "6ac6784bf37e03e28013e7eed706797e")
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !17, line: 90, baseType: !18)
!17 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!18 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsize_t", file: !15, line: 42, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !23, line: 46, baseType: !18)
!23 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !15, line: 34, baseType: !25)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !26, line: 26, baseType: !27)
!26 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !28, line: 42, baseType: !7)
!28 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!29 = !{!30, !36, !0, !54, !57}
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "g_buf", scope: !2, file: !32, line: 46, type: !33, isLocal: false, isDefinition: true)
!32 = !DIFile(filename: "test/queue/bounded_mpmc_check_empty.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "ed4542782c13f0479c0d03705375d1ad")
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !19, size: 256, elements: !34)
!34 = !{!35}
!35 = !DISubrange(count: 4)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "g_queue", scope: !2, file: !32, line: 47, type: !38, isLocal: false, isDefinition: true)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "bounded_mpmc_t", file: !39, line: 39, baseType: !40)
!39 = !DIFile(filename: "./include/vsync/queue/bounded_mpmc.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "ae97e0b4a2e991e85ba75388249cbc94")
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bounded_mpmc_s", file: !39, line: 30, size: 256, elements: !41)
!41 = !{!42, !48, !49, !50, !51, !53}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "phead", scope: !40, file: !39, line: 31, baseType: !43, size: 32, align: 32)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !44, line: 62, baseType: !45)
!44 = !DIFile(filename: "./include/vsync/atomic/core.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "1cc0657a82f0605ef67642f178a77e1c")
!45 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !44, line: 60, size: 32, align: 32, elements: !46)
!46 = !{!47}
!47 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !45, file: !44, line: 61, baseType: !24, size: 32)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "ptail", scope: !40, file: !39, line: 32, baseType: !43, size: 32, align: 32, offset: 32)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "chead", scope: !40, file: !39, line: 34, baseType: !43, size: 32, align: 32, offset: 64)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "ctail", scope: !40, file: !39, line: 35, baseType: !43, size: 32, align: 32, offset: 96)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "buf", scope: !40, file: !39, line: 37, baseType: !52, size: 64, offset: 128)
!52 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !40, file: !39, line: 38, baseType: !24, size: 32, offset: 192)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "g_ret", scope: !2, file: !32, line: 50, type: !56, isLocal: false, isDefinition: true)
!56 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 256, elements: !34)
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !32, line: 51, type: !43, isLocal: false, isDefinition: true)
!59 = !{i32 7, !"Dwarf Version", i32 5}
!60 = !{i32 2, !"Debug Info Version", i32 3}
!61 = !{i32 1, !"wchar_size", i32 4}
!62 = !{i32 7, !"PIC Level", i32 2}
!63 = !{i32 7, !"PIE Level", i32 2}
!64 = !{i32 7, !"uwtable", i32 1}
!65 = !{i32 7, !"frame-pointer", i32 2}
!66 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!67 = distinct !DISubprogram(name: "sched_yield", scope: !32, file: !32, line: 23, type: !68, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !71)
!68 = !DISubroutineType(types: !69)
!69 = !{!70}
!70 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!71 = !{}
!72 = !DILocation(line: 25, column: 2, scope: !67)
!73 = distinct !DISubprogram(name: "writer", scope: !32, file: !32, line: 54, type: !74, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !71)
!74 = !DISubroutineType(types: !75)
!75 = !{!19, !19}
!76 = !DILocalVariable(name: "arg", arg: 1, scope: !73, file: !32, line: 54, type: !19)
!77 = !DILocation(line: 0, scope: !73)
!78 = !DILocation(line: 56, column: 19, scope: !73)
!79 = !DILocalVariable(name: "tid", scope: !73, file: !32, line: 56, type: !14)
!80 = !DILocalVariable(name: "xbo", scope: !73, file: !32, line: 58, type: !81)
!81 = !DIDerivedType(tag: DW_TAG_typedef, name: "xbo_t", file: !82, line: 48, baseType: !83)
!82 = !DIFile(filename: "./include/vsync/utils/xbo.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "f587429cfeb993858d7ede0d279131f0")
!83 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xbo_s", file: !82, line: 44, size: 128, elements: !84)
!84 = !{!85, !86, !87, !88}
!85 = !DIDerivedType(tag: DW_TAG_member, name: "min", scope: !83, file: !82, line: 45, baseType: !24, size: 32)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "max", scope: !83, file: !82, line: 45, baseType: !24, size: 32, offset: 32)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "factor", scope: !83, file: !82, line: 46, baseType: !24, size: 32, offset: 64)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !83, file: !82, line: 47, baseType: !24, size: 32, offset: 96)
!89 = !DILocation(line: 58, column: 8, scope: !73)
!90 = !DILocation(line: 59, column: 2, scope: !73)
!91 = !DILocalVariable(name: "i", scope: !92, file: !32, line: 61, type: !21)
!92 = distinct !DILexicalBlock(scope: !73, file: !32, line: 61, column: 2)
!93 = !DILocation(line: 0, scope: !92)
!94 = !DILocation(line: 62, column: 21, scope: !95)
!95 = distinct !DILexicalBlock(scope: !96, file: !32, line: 61, column: 39)
!96 = distinct !DILexicalBlock(scope: !92, file: !32, line: 61, column: 2)
!97 = !DILocalVariable(name: "idx", scope: !95, file: !32, line: 62, type: !21)
!98 = !DILocation(line: 0, scope: !95)
!99 = !DILocation(line: 63, column: 20, scope: !95)
!100 = !DILocation(line: 63, column: 37, scope: !95)
!101 = !DILocation(line: 63, column: 3, scope: !95)
!102 = !DILocation(line: 63, column: 14, scope: !95)
!103 = !DILocation(line: 64, column: 3, scope: !95)
!104 = !DILocation(line: 64, column: 37, scope: !95)
!105 = !DILocation(line: 64, column: 10, scope: !95)
!106 = !DILocation(line: 64, column: 50, scope: !95)
!107 = !DILocation(line: 66, column: 4, scope: !108)
!108 = distinct !DILexicalBlock(scope: !95, file: !32, line: 64, column: 71)
!109 = distinct !{!109, !103, !110, !111}
!110 = !DILocation(line: 67, column: 3, scope: !95)
!111 = !{!"llvm.loop.mustprogress"}
!112 = !DILocation(line: 68, column: 3, scope: !95)
!113 = !DILocation(line: 62, column: 30, scope: !95)
!114 = !DILocation(line: 70, column: 2, scope: !73)
!115 = distinct !DISubprogram(name: "xbo_init", scope: !82, file: !82, line: 64, type: !116, scopeLine: 65, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!116 = !DISubroutineType(types: !117)
!117 = !{null, !118, !24, !24, !24}
!118 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!119 = !DILocalVariable(name: "xbo", arg: 1, scope: !115, file: !82, line: 64, type: !118)
!120 = !DILocation(line: 0, scope: !115)
!121 = !DILocalVariable(name: "min", arg: 2, scope: !115, file: !82, line: 64, type: !24)
!122 = !DILocalVariable(name: "max", arg: 3, scope: !115, file: !82, line: 64, type: !24)
!123 = !DILocalVariable(name: "factor", arg: 4, scope: !115, file: !82, line: 64, type: !24)
!124 = !DILocation(line: 71, column: 1, scope: !115)
!125 = distinct !DISubprogram(name: "bounded_mpmc_enq", scope: !39, file: !39, line: 73, type: !126, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!126 = !DISubroutineType(types: !127)
!127 = !{!128, !129, !19}
!128 = !DIDerivedType(tag: DW_TAG_typedef, name: "bounded_ret_t", file: !6, line: 13, baseType: !5)
!129 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!130 = !DILocalVariable(name: "q", arg: 1, scope: !125, file: !39, line: 73, type: !129)
!131 = !DILocation(line: 0, scope: !125)
!132 = !DILocalVariable(name: "v", arg: 2, scope: !125, file: !39, line: 73, type: !19)
!133 = !DILocation(line: 78, column: 32, scope: !125)
!134 = !DILocation(line: 78, column: 9, scope: !125)
!135 = !DILocalVariable(name: "curr", scope: !125, file: !39, line: 75, type: !24)
!136 = !DILocation(line: 79, column: 36, scope: !137)
!137 = distinct !DILexicalBlock(scope: !125, file: !39, line: 79, column: 6)
!138 = !DILocation(line: 79, column: 13, scope: !137)
!139 = !DILocation(line: 79, column: 11, scope: !137)
!140 = !DILocation(line: 79, column: 49, scope: !137)
!141 = !DILocation(line: 79, column: 43, scope: !137)
!142 = !DILocation(line: 79, column: 6, scope: !125)
!143 = !DILocation(line: 82, column: 14, scope: !125)
!144 = !DILocalVariable(name: "next", scope: !125, file: !39, line: 75, type: !24)
!145 = !DILocation(line: 83, column: 6, scope: !146)
!146 = distinct !DILexicalBlock(scope: !125, file: !39, line: 83, column: 6)
!147 = !DILocation(line: 83, column: 51, scope: !146)
!148 = !DILocation(line: 83, column: 6, scope: !125)
!149 = !DILocation(line: 87, column: 5, scope: !125)
!150 = !DILocation(line: 87, column: 19, scope: !125)
!151 = !DILocation(line: 87, column: 14, scope: !125)
!152 = !DILocation(line: 87, column: 2, scope: !125)
!153 = !DILocation(line: 87, column: 25, scope: !125)
!154 = !DILocation(line: 90, column: 29, scope: !125)
!155 = !DILocation(line: 90, column: 2, scope: !125)
!156 = !DILocation(line: 91, column: 2, scope: !125)
!157 = !DILocation(line: 93, column: 2, scope: !125)
!158 = !DILocation(line: 94, column: 1, scope: !125)
!159 = distinct !DISubprogram(name: "verification_ignore", scope: !160, file: !160, line: 13, type: !161, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!160 = !DIFile(filename: "./include/vsync/common/verify.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "3a0b94d9e7ec6d94ef39ae9297c4bc2a")
!161 = !DISubroutineType(types: !162)
!162 = !{null}
!163 = !DILocation(line: 15, column: 2, scope: !159)
!164 = !DILocation(line: 16, column: 1, scope: !159)
!165 = distinct !DISubprogram(name: "xbo_reset", scope: !82, file: !82, line: 104, type: !166, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!166 = !DISubroutineType(types: !167)
!167 = !{null, !118}
!168 = !DILocalVariable(name: "xbo", arg: 1, scope: !165, file: !82, line: 104, type: !118)
!169 = !DILocation(line: 0, scope: !165)
!170 = !DILocation(line: 109, column: 1, scope: !165)
!171 = distinct !DISubprogram(name: "reader", scope: !32, file: !32, line: 74, type: !74, scopeLine: 75, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !71)
!172 = !DILocalVariable(name: "arg", arg: 1, scope: !171, file: !32, line: 74, type: !19)
!173 = !DILocation(line: 0, scope: !171)
!174 = !DILocalVariable(name: "tid", scope: !171, file: !32, line: 76, type: !14)
!175 = !DILocalVariable(name: "xbo", scope: !171, file: !32, line: 79, type: !81)
!176 = !DILocation(line: 79, column: 8, scope: !171)
!177 = !DILocation(line: 80, column: 2, scope: !171)
!178 = !DILocation(line: 82, column: 2, scope: !171)
!179 = !DILocalVariable(name: "r", scope: !180, file: !32, line: 83, type: !19)
!180 = distinct !DILexicalBlock(scope: !171, file: !32, line: 82, column: 5)
!181 = !DILocation(line: 83, column: 9, scope: !180)
!182 = !DILocation(line: 84, column: 7, scope: !183)
!183 = distinct !DILexicalBlock(scope: !180, file: !32, line: 84, column: 7)
!184 = !DILocation(line: 84, column: 38, scope: !183)
!185 = !DILocation(line: 84, column: 7, scope: !180)
!186 = !DILocation(line: 85, column: 20, scope: !187)
!187 = distinct !DILexicalBlock(scope: !183, file: !32, line: 84, column: 59)
!188 = !DILocalVariable(name: "idx", scope: !187, file: !32, line: 85, type: !24)
!189 = !DILocation(line: 0, scope: !187)
!190 = !DILocation(line: 86, column: 4, scope: !191)
!191 = distinct !DILexicalBlock(scope: !192, file: !32, line: 86, column: 4)
!192 = distinct !DILexicalBlock(scope: !187, file: !32, line: 86, column: 4)
!193 = !DILocation(line: 86, column: 4, scope: !192)
!194 = !DILocation(line: 87, column: 29, scope: !187)
!195 = !DILocation(line: 87, column: 18, scope: !187)
!196 = !DILocation(line: 87, column: 17, scope: !187)
!197 = !DILocation(line: 87, column: 4, scope: !187)
!198 = !DILocation(line: 87, column: 15, scope: !187)
!199 = !DILocation(line: 88, column: 4, scope: !200)
!200 = distinct !DILexicalBlock(scope: !201, file: !32, line: 88, column: 4)
!201 = distinct !DILexicalBlock(scope: !187, file: !32, line: 88, column: 4)
!202 = !DILocation(line: 88, column: 4, scope: !201)
!203 = !DILocation(line: 91, column: 4, scope: !204)
!204 = distinct !DILexicalBlock(scope: !183, file: !32, line: 89, column: 10)
!205 = !DILocation(line: 93, column: 3, scope: !180)
!206 = !DILocation(line: 94, column: 11, scope: !171)
!207 = !DILocation(line: 94, column: 39, scope: !171)
!208 = !DILocation(line: 94, column: 2, scope: !180)
!209 = distinct !{!209, !178, !210, !111}
!210 = !DILocation(line: 94, column: 54, scope: !171)
!211 = !DILocation(line: 96, column: 2, scope: !171)
!212 = distinct !DISubprogram(name: "bounded_mpmc_deq", scope: !39, file: !39, line: 108, type: !213, scopeLine: 109, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!213 = !DISubroutineType(types: !214)
!214 = !{!128, !129, !52}
!215 = !DILocalVariable(name: "q", arg: 1, scope: !212, file: !39, line: 108, type: !129)
!216 = !DILocation(line: 0, scope: !212)
!217 = !DILocalVariable(name: "v", arg: 2, scope: !212, file: !39, line: 108, type: !52)
!218 = !DILocation(line: 113, column: 32, scope: !212)
!219 = !DILocation(line: 113, column: 9, scope: !212)
!220 = !DILocalVariable(name: "curr", scope: !212, file: !39, line: 110, type: !24)
!221 = !DILocation(line: 114, column: 14, scope: !212)
!222 = !DILocalVariable(name: "next", scope: !212, file: !39, line: 110, type: !24)
!223 = !DILocation(line: 115, column: 37, scope: !224)
!224 = distinct !DILexicalBlock(scope: !212, file: !39, line: 115, column: 6)
!225 = !DILocation(line: 115, column: 14, scope: !224)
!226 = !DILocation(line: 115, column: 11, scope: !224)
!227 = !DILocation(line: 115, column: 6, scope: !212)
!228 = !DILocation(line: 118, column: 6, scope: !229)
!229 = distinct !DILexicalBlock(scope: !212, file: !39, line: 118, column: 6)
!230 = !DILocation(line: 118, column: 51, scope: !229)
!231 = !DILocation(line: 118, column: 6, scope: !212)
!232 = !DILocation(line: 122, column: 10, scope: !212)
!233 = !DILocation(line: 122, column: 24, scope: !212)
!234 = !DILocation(line: 122, column: 19, scope: !212)
!235 = !DILocation(line: 122, column: 7, scope: !212)
!236 = !DILocation(line: 122, column: 5, scope: !212)
!237 = !DILocation(line: 125, column: 29, scope: !212)
!238 = !DILocation(line: 125, column: 2, scope: !212)
!239 = !DILocation(line: 126, column: 2, scope: !212)
!240 = !DILocation(line: 128, column: 2, scope: !212)
!241 = !DILocation(line: 129, column: 1, scope: !212)
!242 = distinct !DISubprogram(name: "vatomic32_get_inc_rlx", scope: !243, file: !243, line: 2516, type: !244, scopeLine: 2517, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!243 = !DIFile(filename: "./include/vsync/atomic/internal/fallback.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "bfc5d50ad810da3af0d582a48b47498f")
!244 = !DISubroutineType(types: !245)
!245 = !{!24, !246}
!246 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!247 = !DILocalVariable(name: "a", arg: 1, scope: !242, file: !243, line: 2516, type: !246)
!248 = !DILocation(line: 0, scope: !242)
!249 = !DILocation(line: 2518, column: 9, scope: !242)
!250 = !DILocation(line: 2518, column: 2, scope: !242)
!251 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !252, file: !252, line: 193, type: !244, scopeLine: 194, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!252 = !DIFile(filename: "./include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "31d9a9647b315cadb2f817a7c8e98ecf")
!253 = !DILocalVariable(name: "a", arg: 1, scope: !251, file: !252, line: 193, type: !246)
!254 = !DILocation(line: 0, scope: !251)
!255 = !DILocation(line: 195, column: 2, scope: !251)
!256 = !{i64 2148056205}
!257 = !DILocation(line: 197, column: 7, scope: !251)
!258 = !DILocation(line: 196, column: 29, scope: !251)
!259 = !DILocalVariable(name: "tmp", scope: !251, file: !252, line: 196, type: !24)
!260 = !DILocation(line: 198, column: 2, scope: !251)
!261 = !{i64 2148056251}
!262 = !DILocation(line: 199, column: 2, scope: !251)
!263 = distinct !DISubprogram(name: "main", scope: !32, file: !32, line: 100, type: !68, scopeLine: 101, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !71)
!264 = !DILocation(line: 102, column: 2, scope: !263)
!265 = !DILocalVariable(name: "t", scope: !263, file: !32, line: 104, type: !266)
!266 = !DICompositeType(tag: DW_TAG_array_type, baseType: !267, size: 256, elements: !34)
!267 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !268, line: 27, baseType: !18)
!268 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!269 = !DILocation(line: 104, column: 12, scope: !263)
!270 = !DILocalVariable(name: "i", scope: !271, file: !32, line: 106, type: !14)
!271 = distinct !DILexicalBlock(scope: !263, file: !32, line: 106, column: 2)
!272 = !DILocation(line: 0, scope: !271)
!273 = !DILocation(line: 107, column: 25, scope: !274)
!274 = distinct !DILexicalBlock(scope: !275, file: !32, line: 106, column: 44)
!275 = distinct !DILexicalBlock(scope: !271, file: !32, line: 106, column: 2)
!276 = !DILocation(line: 107, column: 9, scope: !274)
!277 = !DILocalVariable(name: "i", scope: !278, file: !32, line: 109, type: !14)
!278 = distinct !DILexicalBlock(scope: !263, file: !32, line: 109, column: 2)
!279 = !DILocation(line: 0, scope: !278)
!280 = !DILocation(line: 110, column: 25, scope: !281)
!281 = distinct !DILexicalBlock(scope: !282, file: !32, line: 109, column: 44)
!282 = distinct !DILexicalBlock(scope: !278, file: !32, line: 109, column: 2)
!283 = !DILocation(line: 110, column: 9, scope: !281)
!284 = !DILocalVariable(name: "i", scope: !285, file: !32, line: 113, type: !14)
!285 = distinct !DILexicalBlock(scope: !263, file: !32, line: 113, column: 2)
!286 = !DILocation(line: 0, scope: !285)
!287 = !DILocation(line: 114, column: 22, scope: !288)
!288 = distinct !DILexicalBlock(scope: !289, file: !32, line: 113, column: 44)
!289 = distinct !DILexicalBlock(scope: !285, file: !32, line: 113, column: 2)
!290 = !DILocation(line: 114, column: 9, scope: !288)
!291 = !DILocalVariable(name: "found", scope: !263, file: !32, line: 118, type: !70)
!292 = !DILocation(line: 0, scope: !263)
!293 = !DILocalVariable(name: "i", scope: !294, file: !32, line: 119, type: !70)
!294 = distinct !DILexicalBlock(scope: !263, file: !32, line: 119, column: 2)
!295 = !DILocation(line: 0, scope: !294)
!296 = !DILocalVariable(name: "j", scope: !297, file: !32, line: 120, type: !70)
!297 = distinct !DILexicalBlock(scope: !298, file: !32, line: 120, column: 3)
!298 = distinct !DILexicalBlock(scope: !299, file: !32, line: 119, column: 41)
!299 = distinct !DILexicalBlock(scope: !294, file: !32, line: 119, column: 2)
!300 = !DILocation(line: 0, scope: !297)
!301 = !DILocation(line: 121, column: 8, scope: !302)
!302 = distinct !DILexicalBlock(scope: !303, file: !32, line: 121, column: 8)
!303 = distinct !DILexicalBlock(scope: !304, file: !32, line: 120, column: 42)
!304 = distinct !DILexicalBlock(scope: !297, file: !32, line: 120, column: 3)
!305 = !DILocation(line: 121, column: 20, scope: !302)
!306 = !DILocation(line: 121, column: 17, scope: !302)
!307 = !DILocation(line: 121, column: 8, scope: !303)
!308 = !DILocation(line: 122, column: 14, scope: !309)
!309 = distinct !DILexicalBlock(scope: !302, file: !32, line: 121, column: 30)
!310 = !DILocation(line: 124, column: 5, scope: !309)
!311 = !DILocation(line: 123, column: 10, scope: !309)
!312 = !DILocation(line: 128, column: 2, scope: !313)
!313 = distinct !DILexicalBlock(scope: !314, file: !32, line: 128, column: 2)
!314 = distinct !DILexicalBlock(scope: !263, file: !32, line: 128, column: 2)
!315 = !DILocation(line: 128, column: 2, scope: !314)
!316 = !DILocation(line: 129, column: 16, scope: !263)
!317 = !DILocalVariable(name: "x", scope: !263, file: !32, line: 129, type: !24)
!318 = !DILocation(line: 130, column: 2, scope: !319)
!319 = distinct !DILexicalBlock(scope: !320, file: !32, line: 130, column: 2)
!320 = distinct !DILexicalBlock(scope: !263, file: !32, line: 130, column: 2)
!321 = !DILocation(line: 130, column: 2, scope: !320)
!322 = !DILocalVariable(name: "r", scope: !263, file: !32, line: 132, type: !19)
!323 = !DILocation(line: 132, column: 8, scope: !263)
!324 = !DILocation(line: 133, column: 22, scope: !263)
!325 = !DILocalVariable(name: "ret", scope: !263, file: !32, line: 133, type: !128)
!326 = !DILocation(line: 134, column: 2, scope: !327)
!327 = distinct !DILexicalBlock(scope: !328, file: !32, line: 134, column: 2)
!328 = distinct !DILexicalBlock(scope: !263, file: !32, line: 134, column: 2)
!329 = !DILocation(line: 134, column: 2, scope: !328)
!330 = !DILocation(line: 138, column: 2, scope: !263)
!331 = distinct !DISubprogram(name: "bounded_mpmc_init", scope: !39, file: !39, line: 49, type: !332, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!332 = !DISubroutineType(types: !333)
!333 = !{null, !129, !52, !24}
!334 = !DILocalVariable(name: "q", arg: 1, scope: !331, file: !39, line: 49, type: !129)
!335 = !DILocation(line: 0, scope: !331)
!336 = !DILocalVariable(name: "b", arg: 2, scope: !331, file: !39, line: 49, type: !52)
!337 = !DILocalVariable(name: "s", arg: 3, scope: !331, file: !39, line: 49, type: !24)
!338 = !DILocation(line: 51, column: 2, scope: !339)
!339 = distinct !DILexicalBlock(scope: !340, file: !39, line: 51, column: 2)
!340 = distinct !DILexicalBlock(scope: !331, file: !39, line: 51, column: 2)
!341 = !DILocation(line: 52, column: 2, scope: !342)
!342 = distinct !DILexicalBlock(scope: !343, file: !39, line: 52, column: 2)
!343 = distinct !DILexicalBlock(scope: !331, file: !39, line: 52, column: 2)
!344 = !DILocation(line: 54, column: 5, scope: !331)
!345 = !DILocation(line: 54, column: 9, scope: !331)
!346 = !DILocation(line: 55, column: 5, scope: !331)
!347 = !DILocation(line: 55, column: 10, scope: !331)
!348 = !DILocation(line: 56, column: 21, scope: !331)
!349 = !DILocation(line: 56, column: 2, scope: !331)
!350 = !DILocation(line: 57, column: 21, scope: !331)
!351 = !DILocation(line: 57, column: 2, scope: !331)
!352 = !DILocation(line: 58, column: 21, scope: !331)
!353 = !DILocation(line: 58, column: 2, scope: !331)
!354 = !DILocation(line: 59, column: 21, scope: !331)
!355 = !DILocation(line: 59, column: 2, scope: !331)
!356 = !DILocation(line: 60, column: 1, scope: !331)
!357 = distinct !DISubprogram(name: "vatomic32_read", scope: !252, file: !252, line: 163, type: !244, scopeLine: 164, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!358 = !DILocalVariable(name: "a", arg: 1, scope: !357, file: !252, line: 163, type: !246)
!359 = !DILocation(line: 0, scope: !357)
!360 = !DILocation(line: 165, column: 2, scope: !357)
!361 = !{i64 2148056037}
!362 = !DILocation(line: 167, column: 7, scope: !357)
!363 = !DILocation(line: 166, column: 29, scope: !357)
!364 = !DILocalVariable(name: "tmp", scope: !357, file: !252, line: 166, type: !24)
!365 = !DILocation(line: 168, column: 2, scope: !357)
!366 = !{i64 2148056083}
!367 = !DILocation(line: 169, column: 2, scope: !357)
!368 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !252, file: !252, line: 178, type: !244, scopeLine: 179, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!369 = !DILocalVariable(name: "a", arg: 1, scope: !368, file: !252, line: 178, type: !246)
!370 = !DILocation(line: 0, scope: !368)
!371 = !DILocation(line: 180, column: 2, scope: !368)
!372 = !{i64 2148056121}
!373 = !DILocation(line: 182, column: 7, scope: !368)
!374 = !DILocation(line: 181, column: 29, scope: !368)
!375 = !DILocalVariable(name: "tmp", scope: !368, file: !252, line: 181, type: !24)
!376 = !DILocation(line: 183, column: 2, scope: !368)
!377 = !{i64 2148056167}
!378 = !DILocation(line: 184, column: 2, scope: !368)
!379 = distinct !DISubprogram(name: "vatomic32_cmpxchg_rel", scope: !252, file: !252, line: 1119, type: !380, scopeLine: 1120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!380 = !DISubroutineType(types: !381)
!381 = !{!24, !246, !24, !24}
!382 = !DILocalVariable(name: "a", arg: 1, scope: !379, file: !252, line: 1119, type: !246)
!383 = !DILocation(line: 0, scope: !379)
!384 = !DILocalVariable(name: "e", arg: 2, scope: !379, file: !252, line: 1119, type: !24)
!385 = !DILocalVariable(name: "v", arg: 3, scope: !379, file: !252, line: 1119, type: !24)
!386 = !DILocalVariable(name: "exp", scope: !379, file: !252, line: 1121, type: !24)
!387 = !DILocation(line: 1122, column: 2, scope: !379)
!388 = !{i64 2148061493}
!389 = !DILocation(line: 1123, column: 34, scope: !379)
!390 = !DILocation(line: 1123, column: 2, scope: !379)
!391 = !DILocation(line: 1126, column: 2, scope: !379)
!392 = !{i64 2148061547}
!393 = !DILocation(line: 1127, column: 2, scope: !379)
!394 = distinct !DISubprogram(name: "vatomic32_await_eq_acq", scope: !243, file: !243, line: 4389, type: !395, scopeLine: 4390, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!395 = !DISubroutineType(types: !396)
!396 = !{!24, !246, !24}
!397 = !DILocalVariable(name: "a", arg: 1, scope: !394, file: !243, line: 4389, type: !246)
!398 = !DILocation(line: 0, scope: !394)
!399 = !DILocalVariable(name: "c", arg: 2, scope: !394, file: !243, line: 4389, type: !24)
!400 = !DILocalVariable(name: "ret", scope: !394, file: !243, line: 4391, type: !24)
!401 = !DILocalVariable(name: "o", scope: !394, file: !243, line: 4392, type: !24)
!402 = !DILocation(line: 4393, column: 2, scope: !394)
!403 = distinct !{!403, !402, !404, !111}
!404 = !DILocation(line: 4396, column: 2, scope: !394)
!405 = !DILocation(line: 4397, column: 2, scope: !394)
!406 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !252, file: !252, line: 438, type: !407, scopeLine: 439, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!407 = !DISubroutineType(types: !408)
!408 = !{null, !246, !24}
!409 = !DILocalVariable(name: "a", arg: 1, scope: !406, file: !252, line: 438, type: !246)
!410 = !DILocation(line: 0, scope: !406)
!411 = !DILocalVariable(name: "v", arg: 2, scope: !406, file: !252, line: 438, type: !24)
!412 = !DILocation(line: 440, column: 2, scope: !406)
!413 = !{i64 2148057633}
!414 = !DILocation(line: 441, column: 23, scope: !406)
!415 = !DILocation(line: 441, column: 2, scope: !406)
!416 = !DILocation(line: 442, column: 2, scope: !406)
!417 = !{i64 2148057679}
!418 = !DILocation(line: 443, column: 1, scope: !406)
!419 = distinct !DISubprogram(name: "vatomic32_await_eq_rlx", scope: !243, file: !243, line: 4406, type: !395, scopeLine: 4407, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!420 = !DILocalVariable(name: "a", arg: 1, scope: !419, file: !243, line: 4406, type: !246)
!421 = !DILocation(line: 0, scope: !419)
!422 = !DILocalVariable(name: "c", arg: 2, scope: !419, file: !243, line: 4406, type: !24)
!423 = !DILocalVariable(name: "ret", scope: !419, file: !243, line: 4408, type: !24)
!424 = !DILocalVariable(name: "o", scope: !419, file: !243, line: 4409, type: !24)
!425 = !DILocation(line: 4410, column: 2, scope: !419)
!426 = distinct !{!426, !425, !427, !111}
!427 = !DILocation(line: 4413, column: 2, scope: !419)
!428 = !DILocation(line: 4414, column: 2, scope: !419)
!429 = distinct !DISubprogram(name: "vatomic32_get_add_rlx", scope: !252, file: !252, line: 2438, type: !395, scopeLine: 2439, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!430 = !DILocalVariable(name: "a", arg: 1, scope: !429, file: !252, line: 2438, type: !246)
!431 = !DILocation(line: 0, scope: !429)
!432 = !DILocalVariable(name: "v", arg: 2, scope: !429, file: !252, line: 2438, type: !24)
!433 = !DILocation(line: 2440, column: 2, scope: !429)
!434 = !{i64 2148068745}
!435 = !DILocation(line: 2442, column: 7, scope: !429)
!436 = !DILocation(line: 2441, column: 29, scope: !429)
!437 = !DILocalVariable(name: "tmp", scope: !429, file: !252, line: 2441, type: !24)
!438 = !DILocation(line: 2443, column: 2, scope: !429)
!439 = !{i64 2148068791}
!440 = !DILocation(line: 2444, column: 2, scope: !429)
!441 = distinct !DISubprogram(name: "vatomic32_init", scope: !243, file: !243, line: 4189, type: !407, scopeLine: 4190, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!442 = !DILocalVariable(name: "a", arg: 1, scope: !441, file: !243, line: 4189, type: !246)
!443 = !DILocation(line: 0, scope: !441)
!444 = !DILocalVariable(name: "v", arg: 2, scope: !441, file: !243, line: 4189, type: !24)
!445 = !DILocation(line: 4191, column: 2, scope: !441)
!446 = !DILocation(line: 4192, column: 1, scope: !441)
!447 = distinct !DISubprogram(name: "vatomic32_write", scope: !252, file: !252, line: 425, type: !407, scopeLine: 426, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!448 = !DILocalVariable(name: "a", arg: 1, scope: !447, file: !252, line: 425, type: !246)
!449 = !DILocation(line: 0, scope: !447)
!450 = !DILocalVariable(name: "v", arg: 2, scope: !447, file: !252, line: 425, type: !24)
!451 = !DILocation(line: 427, column: 2, scope: !447)
!452 = !{i64 2148057549}
!453 = !DILocation(line: 428, column: 23, scope: !447)
!454 = !DILocation(line: 428, column: 2, scope: !447)
!455 = !DILocation(line: 429, column: 2, scope: !447)
!456 = !{i64 2148057595}
!457 = !DILocation(line: 430, column: 1, scope: !447)
