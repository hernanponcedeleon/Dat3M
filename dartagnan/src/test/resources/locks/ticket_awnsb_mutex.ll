; ModuleID = '/home/ponce/git/Dat3M/output/ticket_awnsb_mutex.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/ticket_awnsb_mutex.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.awnsb_node_t = type { i32 }
%struct.ticket_awnsb_mutex_t = type { i32, [8 x i8], i32, [8 x i8], i32, %struct.awnsb_node_t** }
%union.pthread_attr_t = type { i64, [48 x i8] }

@tlNode = internal thread_local global %struct.awnsb_node_t zeroinitializer, align 4, !dbg !0
@sum = dso_local global i32 0, align 4, !dbg !35
@lock = dso_local global %struct.ticket_awnsb_mutex_t zeroinitializer, align 8, !dbg !40
@shared = dso_local global i32 0, align 4, !dbg !38
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [60 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/ticket_awnsb_mutex.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @ticket_awnsb_mutex_init(%struct.ticket_awnsb_mutex_t* noundef %0, i32 noundef %1) #0 !dbg !63 {
  call void @llvm.dbg.value(metadata %struct.ticket_awnsb_mutex_t* %0, metadata !68, metadata !DIExpression()), !dbg !69
  call void @llvm.dbg.value(metadata i32 %1, metadata !70, metadata !DIExpression()), !dbg !69
  %3 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 0, !dbg !71
  store i32 0, i32* %3, align 4, !dbg !72
  %4 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 2, !dbg !73
  store i32 0, i32* %4, align 4, !dbg !74
  %5 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 4, !dbg !75
  store i32 %1, i32* %5, align 8, !dbg !76
  %6 = sext i32 %1 to i64, !dbg !77
  %7 = mul i64 %6, 8, !dbg !78
  %8 = call noalias i8* @malloc(i64 noundef %7) #5, !dbg !79
  %9 = bitcast i8* %8 to %struct.awnsb_node_t**, !dbg !80
  %10 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 5, !dbg !81
  store %struct.awnsb_node_t** %9, %struct.awnsb_node_t*** %10, align 8, !dbg !82
  call void @__VERIFIER_loop_bound(i32 noundef 4), !dbg !83
  call void @llvm.dbg.value(metadata i32 0, metadata !84, metadata !DIExpression()), !dbg !86
  br label %11, !dbg !87

11:                                               ; preds = %15, %2
  %indvars.iv = phi i64 [ %indvars.iv.next, %15 ], [ 0, %2 ], !dbg !86
  call void @llvm.dbg.value(metadata i64 %indvars.iv, metadata !84, metadata !DIExpression()), !dbg !86
  %12 = load i32, i32* %5, align 8, !dbg !88
  %13 = sext i32 %12 to i64, !dbg !90
  %14 = icmp slt i64 %indvars.iv, %13, !dbg !90
  br i1 %14, label %15, label %18, !dbg !91

15:                                               ; preds = %11
  %16 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %10, align 8, !dbg !92
  %17 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %16, i64 %indvars.iv, !dbg !93
  store %struct.awnsb_node_t* null, %struct.awnsb_node_t** %17, align 8, !dbg !94
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !95
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next, metadata !84, metadata !DIExpression()), !dbg !86
  br label %11, !dbg !96, !llvm.loop !97

18:                                               ; preds = %11
  ret void, !dbg !100
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #2

declare void @__VERIFIER_loop_bound(i32 noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @ticket_awnsb_mutex_destroy(%struct.ticket_awnsb_mutex_t* noundef %0) #0 !dbg !101 {
  call void @llvm.dbg.value(metadata %struct.ticket_awnsb_mutex_t* %0, metadata !104, metadata !DIExpression()), !dbg !105
  %2 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 0, !dbg !106
  store atomic i32 0, i32* %2 seq_cst, align 8, !dbg !106
  %3 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 2, !dbg !107
  store atomic i32 0, i32* %3 seq_cst, align 4, !dbg !107
  %4 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 5, !dbg !108
  %5 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %4, align 8, !dbg !108
  %6 = bitcast %struct.awnsb_node_t** %5 to i8*, !dbg !109
  call void @free(i8* noundef %6) #5, !dbg !110
  ret void, !dbg !111
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @ticket_awnsb_mutex_lock(%struct.ticket_awnsb_mutex_t* noundef %0) #0 !dbg !112 {
  call void @llvm.dbg.value(metadata %struct.ticket_awnsb_mutex_t* %0, metadata !113, metadata !DIExpression()), !dbg !114
  %2 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 0, !dbg !115
  %3 = atomicrmw add i32* %2, i32 1 monotonic, align 4, !dbg !116
  call void @llvm.dbg.value(metadata i32 %3, metadata !117, metadata !DIExpression()), !dbg !114
  %4 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 2, !dbg !119
  %5 = load atomic i32, i32* %4 acquire, align 4, !dbg !121
  %6 = icmp eq i32 %5, %3, !dbg !122
  br i1 %6, label %43, label %7, !dbg !123

7:                                                ; preds = %1
  %8 = add i32 %3, -1, !dbg !124
  br label %9, !dbg !124

9:                                                ; preds = %13, %7
  %10 = load atomic i32, i32* %4 monotonic, align 4, !dbg !125
  %11 = sub nsw i32 %3, 1, !dbg !126
  %12 = icmp sge i32 %10, %11, !dbg !127
  br i1 %12, label %13, label %._crit_edge, !dbg !124

._crit_edge:                                      ; preds = %9
  %.phi.trans.insert = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 4
  %.pre = load i32, i32* %.phi.trans.insert, align 8, !dbg !128
  br label %16, !dbg !124

13:                                               ; preds = %9
  %14 = load atomic i32, i32* %4 acquire, align 4, !dbg !129
  %15 = icmp eq i32 %14, %3, !dbg !132
  br i1 %15, label %43, label %9, !dbg !133, !llvm.loop !134

16:                                               ; preds = %._crit_edge, %16
  %17 = load atomic i32, i32* %4 monotonic, align 4, !dbg !136
  %18 = sub nsw i32 %3, %17, !dbg !137
  %19 = sub nsw i32 %.pre, 1, !dbg !138
  %20 = icmp sge i32 %18, %19, !dbg !139
  br i1 %20, label %16, label %21, !dbg !140, !llvm.loop !141

21:                                               ; preds = %16
  %scevgep = getelementptr %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i64 0, i32 4, !dbg !140
  call void @llvm.dbg.value(metadata %struct.awnsb_node_t* @tlNode, metadata !143, metadata !DIExpression()), !dbg !114
  store atomic i32 0, i32* getelementptr inbounds (%struct.awnsb_node_t, %struct.awnsb_node_t* @tlNode, i64 0, i32 0) monotonic, align 4, !dbg !144
  %22 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 5, !dbg !145
  %23 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %22, align 8, !dbg !145
  %24 = load i32, i32* %scevgep, align 8, !dbg !146
  %25 = srem i32 %3, %24, !dbg !147
  %26 = sext i32 %25 to i64, !dbg !148
  %27 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %23, i64 %26, !dbg !148
  %28 = bitcast %struct.awnsb_node_t** %27 to i64*, !dbg !149
  store atomic i64 ptrtoint (%struct.awnsb_node_t* @tlNode to i64), i64* %28 release, align 8, !dbg !149
  %29 = load atomic i32, i32* %4 monotonic, align 4, !dbg !150
  %30 = icmp slt i32 %29, %8, !dbg !152
  br i1 %30, label %31, label %36, !dbg !153

31:                                               ; preds = %31, %21
  %32 = load atomic i32, i32* getelementptr inbounds (%struct.awnsb_node_t, %struct.awnsb_node_t* @tlNode, i64 0, i32 0) monotonic, align 4, !dbg !154
  %33 = icmp ne i32 %32, 0, !dbg !156
  %34 = xor i1 %33, true, !dbg !156
  br i1 %34, label %31, label %35, !dbg !157, !llvm.loop !158

35:                                               ; preds = %31
  store atomic i32 %3, i32* %4 monotonic, align 4, !dbg !160
  br label %43, !dbg !161

36:                                               ; preds = %39, %21
  %37 = load atomic i32, i32* %4 acquire, align 4, !dbg !162
  %38 = icmp ne i32 %37, %3, !dbg !164
  br i1 %38, label %39, label %43, !dbg !165

39:                                               ; preds = %36
  %40 = load atomic i32, i32* getelementptr inbounds (%struct.awnsb_node_t, %struct.awnsb_node_t* @tlNode, i64 0, i32 0) acquire, align 4, !dbg !166
  %41 = icmp ne i32 %40, 0, !dbg !166
  br i1 %41, label %42, label %36, !dbg !169, !llvm.loop !170

42:                                               ; preds = %39
  store atomic i32 %3, i32* %4 monotonic, align 4, !dbg !172
  br label %43, !dbg !174

43:                                               ; preds = %36, %13, %1, %42, %35
  ret void, !dbg !175
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @ticket_awnsb_mutex_unlock(%struct.ticket_awnsb_mutex_t* noundef %0) #0 !dbg !176 {
  call void @llvm.dbg.value(metadata %struct.ticket_awnsb_mutex_t* %0, metadata !177, metadata !DIExpression()), !dbg !178
  %2 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 2, !dbg !179
  %3 = load atomic i32, i32* %2 monotonic, align 4, !dbg !180
  call void @llvm.dbg.value(metadata i32 %3, metadata !181, metadata !DIExpression()), !dbg !178
  %4 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 5, !dbg !182
  %5 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %4, align 8, !dbg !182
  %6 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 4, !dbg !183
  %7 = load i32, i32* %6, align 8, !dbg !183
  %8 = srem i32 %3, %7, !dbg !184
  %9 = sext i32 %8 to i64, !dbg !185
  %10 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %5, i64 %9, !dbg !185
  %11 = bitcast %struct.awnsb_node_t** %10 to i64*, !dbg !186
  store atomic i64 0, i64* %11 monotonic, align 8, !dbg !186
  %12 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %4, align 8, !dbg !187
  %13 = add nsw i32 %3, 1, !dbg !188
  %14 = load i32, i32* %6, align 8, !dbg !189
  %15 = srem i32 %13, %14, !dbg !190
  %16 = sext i32 %15 to i64, !dbg !191
  %17 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %12, i64 %16, !dbg !191
  %18 = bitcast %struct.awnsb_node_t** %17 to i64*, !dbg !192
  %19 = load atomic i64, i64* %18 acquire, align 8, !dbg !192
  %20 = inttoptr i64 %19 to %struct.awnsb_node_t*, !dbg !192
  call void @llvm.dbg.value(metadata %struct.awnsb_node_t* %20, metadata !193, metadata !DIExpression()), !dbg !178
  %21 = icmp ne %struct.awnsb_node_t* %20, null, !dbg !194
  br i1 %21, label %22, label %24, !dbg !196

22:                                               ; preds = %1
  %23 = getelementptr inbounds %struct.awnsb_node_t, %struct.awnsb_node_t* %20, i32 0, i32 0, !dbg !197
  store atomic i32 1, i32* %23 release, align 4, !dbg !199
  br label %25, !dbg !200

24:                                               ; preds = %1
  store atomic i32 %13, i32* %2 release, align 4, !dbg !201
  br label %25

25:                                               ; preds = %24, %22
  ret void, !dbg !203
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @ticket_awnsb_mutex_trylock(%struct.ticket_awnsb_mutex_t* noundef %0) #0 !dbg !204 {
  call void @llvm.dbg.value(metadata %struct.ticket_awnsb_mutex_t* %0, metadata !207, metadata !DIExpression()), !dbg !208
  %2 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 2, !dbg !209
  %3 = load atomic i32, i32* %2 seq_cst, align 4, !dbg !209
  call void @llvm.dbg.value(metadata i32 %3, metadata !210, metadata !DIExpression()), !dbg !208
  %4 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 0, !dbg !211
  %5 = load atomic i32, i32* %4 monotonic, align 8, !dbg !212
  call void @llvm.dbg.value(metadata i32 %5, metadata !213, metadata !DIExpression()), !dbg !208
  %6 = icmp ne i32 %3, %5, !dbg !214
  br i1 %6, label %13, label %7, !dbg !216

7:                                                ; preds = %1
  %8 = load atomic i32, i32* %4 seq_cst, align 4, !dbg !217
  %9 = add nsw i32 %8, 1, !dbg !217
  %10 = cmpxchg i32* %4, i32 %3, i32 %9 seq_cst seq_cst, align 4, !dbg !217
  %11 = extractvalue { i32, i1 } %10, 1, !dbg !217
  %12 = zext i1 %11 to i8, !dbg !217
  %spec.select = select i1 %11, i32 0, i32 16, !dbg !219
  br label %13, !dbg !219

13:                                               ; preds = %7, %1
  %.0 = phi i32 [ 16, %1 ], [ %spec.select, %7 ], !dbg !208
  ret i32 %.0, !dbg !220
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !221 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !224, metadata !DIExpression()), !dbg !225
  %2 = ptrtoint i8* %0 to i64, !dbg !226
  call void @llvm.dbg.value(metadata i64 %2, metadata !227, metadata !DIExpression()), !dbg !225
  call void @ticket_awnsb_mutex_lock(%struct.ticket_awnsb_mutex_t* noundef @lock), !dbg !228
  %3 = trunc i64 %2 to i32, !dbg !229
  store i32 %3, i32* @shared, align 4, !dbg !230
  call void @llvm.dbg.value(metadata i32 %3, metadata !231, metadata !DIExpression()), !dbg !225
  %4 = sext i32 %3 to i64, !dbg !232
  %5 = icmp eq i64 %4, %2, !dbg !232
  br i1 %5, label %7, label %6, !dbg !235

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #6, !dbg !232
  unreachable, !dbg !232

7:                                                ; preds = %1
  %8 = load i32, i32* @sum, align 4, !dbg !236
  %9 = add nsw i32 %8, 1, !dbg !236
  store i32 %9, i32* @sum, align 4, !dbg !236
  call void @ticket_awnsb_mutex_unlock(%struct.ticket_awnsb_mutex_t* noundef @lock), !dbg !237
  ret i8* null, !dbg !238
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !239 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !242, metadata !DIExpression()), !dbg !248
  call void @ticket_awnsb_mutex_init(%struct.ticket_awnsb_mutex_t* noundef @lock, i32 noundef 3), !dbg !249
  call void @llvm.dbg.value(metadata i32 0, metadata !250, metadata !DIExpression()), !dbg !252
  call void @llvm.dbg.value(metadata i64 0, metadata !250, metadata !DIExpression()), !dbg !252
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !253
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef null) #5, !dbg !255
  call void @llvm.dbg.value(metadata i64 1, metadata !250, metadata !DIExpression()), !dbg !252
  call void @llvm.dbg.value(metadata i64 1, metadata !250, metadata !DIExpression()), !dbg !252
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !253
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 1 to i8*)) #5, !dbg !255
  call void @llvm.dbg.value(metadata i64 2, metadata !250, metadata !DIExpression()), !dbg !252
  call void @llvm.dbg.value(metadata i64 2, metadata !250, metadata !DIExpression()), !dbg !252
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !253
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 2 to i8*)) #5, !dbg !255
  call void @llvm.dbg.value(metadata i64 3, metadata !250, metadata !DIExpression()), !dbg !252
  call void @llvm.dbg.value(metadata i64 3, metadata !250, metadata !DIExpression()), !dbg !252
  call void @llvm.dbg.value(metadata i32 0, metadata !256, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.value(metadata i64 0, metadata !256, metadata !DIExpression()), !dbg !258
  %8 = load i64, i64* %2, align 8, !dbg !259
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !261
  call void @llvm.dbg.value(metadata i64 1, metadata !256, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.value(metadata i64 1, metadata !256, metadata !DIExpression()), !dbg !258
  %10 = load i64, i64* %4, align 8, !dbg !259
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !261
  call void @llvm.dbg.value(metadata i64 2, metadata !256, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.value(metadata i64 2, metadata !256, metadata !DIExpression()), !dbg !258
  %12 = load i64, i64* %6, align 8, !dbg !259
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !261
  call void @llvm.dbg.value(metadata i64 3, metadata !256, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.value(metadata i64 3, metadata !256, metadata !DIExpression()), !dbg !258
  %14 = load i32, i32* @sum, align 4, !dbg !262
  %15 = icmp eq i32 %14, 3, !dbg !262
  br i1 %15, label %17, label %16, !dbg !265

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !262
  unreachable, !dbg !262

17:                                               ; preds = %0
  ret i32 0, !dbg !266
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!55, !56, !57, !58, !59, !60, !61}
!llvm.ident = !{!62}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "tlNode", scope: !2, file: !20, line: 143, type: !19, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !34, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/ticket_awnsb_mutex.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "20563f8b3b1d8adf516623558b564708")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 56, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "de5d66a1ef2f5448cc1919ff39db92bc")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16, !26, !27, !28, !31}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !18)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "awnsb_node_t", file: !20, line: 125, baseType: !21)
!20 = !DIFile(filename: "benchmarks/locks/ticket_awnsb_mutex.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "03045fdddbaf6ab40e7d6c6e55719514")
!21 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !20, line: 123, size: 32, elements: !22)
!22 = !{!23}
!23 = !DIDerivedType(tag: DW_TAG_member, name: "lockIsMine", scope: !21, file: !20, line: 124, baseType: !24, size: 32)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !25)
!25 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !26)
!26 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !29, line: 87, baseType: !30)
!29 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!30 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !32, line: 46, baseType: !33)
!32 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!33 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!34 = !{!35, !0, !38, !40}
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !37, line: 11, type: !26, isLocal: false, isDefinition: true)
!37 = !DIFile(filename: "benchmarks/locks/ticket_awnsb_mutex.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "20563f8b3b1d8adf516623558b564708")
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "shared", scope: !2, file: !37, line: 9, type: !26, isLocal: false, isDefinition: true)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !37, line: 10, type: !42, isLocal: false, isDefinition: true)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "ticket_awnsb_mutex_t", file: !20, line: 135, baseType: !43)
!43 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !20, line: 127, size: 320, elements: !44)
!44 = !{!45, !46, !51, !52, !53, !54}
!45 = !DIDerivedType(tag: DW_TAG_member, name: "ingress", scope: !43, file: !20, line: 129, baseType: !24, size: 32)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "padding1", scope: !43, file: !20, line: 130, baseType: !47, size: 64, offset: 32)
!47 = !DICompositeType(tag: DW_TAG_array_type, baseType: !48, size: 64, elements: !49)
!48 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!49 = !{!50}
!50 = !DISubrange(count: 8)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "egress", scope: !43, file: !20, line: 131, baseType: !24, size: 32, offset: 96)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "padding2", scope: !43, file: !20, line: 132, baseType: !47, size: 64, offset: 128)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "maxArrayWaiters", scope: !43, file: !20, line: 133, baseType: !26, size: 32, offset: 192)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "waitersArray", scope: !43, file: !20, line: 134, baseType: !16, size: 64, offset: 256)
!55 = !{i32 7, !"Dwarf Version", i32 5}
!56 = !{i32 2, !"Debug Info Version", i32 3}
!57 = !{i32 1, !"wchar_size", i32 4}
!58 = !{i32 7, !"PIC Level", i32 2}
!59 = !{i32 7, !"PIE Level", i32 2}
!60 = !{i32 7, !"uwtable", i32 1}
!61 = !{i32 7, !"frame-pointer", i32 2}
!62 = !{!"Ubuntu clang version 14.0.6"}
!63 = distinct !DISubprogram(name: "ticket_awnsb_mutex_init", scope: !20, file: !20, line: 153, type: !64, scopeLine: 154, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!64 = !DISubroutineType(types: !65)
!65 = !{null, !66, !26}
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!67 = !{}
!68 = !DILocalVariable(name: "self", arg: 1, scope: !63, file: !20, line: 153, type: !66)
!69 = !DILocation(line: 0, scope: !63)
!70 = !DILocalVariable(name: "maxArrayWaiters", arg: 2, scope: !63, file: !20, line: 153, type: !26)
!71 = !DILocation(line: 155, column: 24, scope: !63)
!72 = !DILocation(line: 155, column: 5, scope: !63)
!73 = !DILocation(line: 156, column: 24, scope: !63)
!74 = !DILocation(line: 156, column: 5, scope: !63)
!75 = !DILocation(line: 157, column: 11, scope: !63)
!76 = !DILocation(line: 157, column: 27, scope: !63)
!77 = !DILocation(line: 158, column: 59, scope: !63)
!78 = !DILocation(line: 158, column: 80, scope: !63)
!79 = !DILocation(line: 158, column: 52, scope: !63)
!80 = !DILocation(line: 158, column: 26, scope: !63)
!81 = !DILocation(line: 158, column: 11, scope: !63)
!82 = !DILocation(line: 158, column: 24, scope: !63)
!83 = !DILocation(line: 159, column: 5, scope: !63)
!84 = !DILocalVariable(name: "i", scope: !85, file: !20, line: 160, type: !26)
!85 = distinct !DILexicalBlock(scope: !63, file: !20, line: 160, column: 5)
!86 = !DILocation(line: 0, scope: !85)
!87 = !DILocation(line: 160, column: 10, scope: !85)
!88 = !DILocation(line: 160, column: 31, scope: !89)
!89 = distinct !DILexicalBlock(scope: !85, file: !20, line: 160, column: 5)
!90 = !DILocation(line: 160, column: 23, scope: !89)
!91 = !DILocation(line: 160, column: 5, scope: !85)
!92 = !DILocation(line: 160, column: 72, scope: !89)
!93 = !DILocation(line: 160, column: 66, scope: !89)
!94 = !DILocation(line: 160, column: 53, scope: !89)
!95 = !DILocation(line: 160, column: 49, scope: !89)
!96 = !DILocation(line: 160, column: 5, scope: !89)
!97 = distinct !{!97, !91, !98, !99}
!98 = !DILocation(line: 160, column: 93, scope: !85)
!99 = !{!"llvm.loop.mustprogress"}
!100 = !DILocation(line: 161, column: 1, scope: !63)
!101 = distinct !DISubprogram(name: "ticket_awnsb_mutex_destroy", scope: !20, file: !20, line: 164, type: !102, scopeLine: 165, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!102 = !DISubroutineType(types: !103)
!103 = !{null, !66}
!104 = !DILocalVariable(name: "self", arg: 1, scope: !101, file: !20, line: 164, type: !66)
!105 = !DILocation(line: 0, scope: !101)
!106 = !DILocation(line: 166, column: 5, scope: !101)
!107 = !DILocation(line: 167, column: 5, scope: !101)
!108 = !DILocation(line: 168, column: 16, scope: !101)
!109 = !DILocation(line: 168, column: 10, scope: !101)
!110 = !DILocation(line: 168, column: 5, scope: !101)
!111 = !DILocation(line: 169, column: 1, scope: !101)
!112 = distinct !DISubprogram(name: "ticket_awnsb_mutex_lock", scope: !20, file: !20, line: 179, type: !102, scopeLine: 180, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!113 = !DILocalVariable(name: "self", arg: 1, scope: !112, file: !20, line: 179, type: !66)
!114 = !DILocation(line: 0, scope: !112)
!115 = !DILocation(line: 181, column: 57, scope: !112)
!116 = !DILocation(line: 181, column: 24, scope: !112)
!117 = !DILocalVariable(name: "ticket", scope: !112, file: !20, line: 181, type: !118)
!118 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !26)
!119 = !DILocation(line: 185, column: 37, scope: !120)
!120 = distinct !DILexicalBlock(scope: !112, file: !20, line: 185, column: 9)
!121 = !DILocation(line: 185, column: 9, scope: !120)
!122 = !DILocation(line: 185, column: 67, scope: !120)
!123 = !DILocation(line: 185, column: 9, scope: !112)
!124 = !DILocation(line: 187, column: 5, scope: !112)
!125 = !DILocation(line: 187, column: 12, scope: !112)
!126 = !DILocation(line: 187, column: 79, scope: !112)
!127 = !DILocation(line: 187, column: 70, scope: !112)
!128 = !DILocation(line: 191, column: 87, scope: !112)
!129 = !DILocation(line: 188, column: 13, scope: !130)
!130 = distinct !DILexicalBlock(scope: !131, file: !20, line: 188, column: 13)
!131 = distinct !DILexicalBlock(scope: !112, file: !20, line: 187, column: 83)
!132 = !DILocation(line: 188, column: 71, scope: !130)
!133 = !DILocation(line: 188, column: 13, scope: !131)
!134 = distinct !{!134, !124, !135, !99}
!135 = !DILocation(line: 189, column: 5, scope: !112)
!136 = !DILocation(line: 191, column: 19, scope: !112)
!137 = !DILocation(line: 191, column: 18, scope: !112)
!138 = !DILocation(line: 191, column: 102, scope: !112)
!139 = !DILocation(line: 191, column: 77, scope: !112)
!140 = !DILocation(line: 191, column: 5, scope: !112)
!141 = distinct !{!141, !140, !142, !99}
!142 = !DILocation(line: 191, column: 106, scope: !112)
!143 = !DILocalVariable(name: "wnode", scope: !112, file: !20, line: 194, type: !18)
!144 = !DILocation(line: 196, column: 5, scope: !112)
!145 = !DILocation(line: 197, column: 34, scope: !112)
!146 = !DILocation(line: 197, column: 68, scope: !112)
!147 = !DILocation(line: 197, column: 60, scope: !112)
!148 = !DILocation(line: 197, column: 28, scope: !112)
!149 = !DILocation(line: 197, column: 5, scope: !112)
!150 = !DILocation(line: 199, column: 9, scope: !151)
!151 = distinct !DILexicalBlock(scope: !112, file: !20, line: 199, column: 9)
!152 = !DILocation(line: 199, column: 67, scope: !151)
!153 = !DILocation(line: 199, column: 9, scope: !112)
!154 = !DILocation(line: 201, column: 17, scope: !155)
!155 = distinct !DILexicalBlock(scope: !151, file: !20, line: 199, column: 79)
!156 = !DILocation(line: 201, column: 16, scope: !155)
!157 = !DILocation(line: 201, column: 9, scope: !155)
!158 = distinct !{!158, !157, !159, !99}
!159 = !DILocation(line: 201, column: 80, scope: !155)
!160 = !DILocation(line: 202, column: 9, scope: !155)
!161 = !DILocation(line: 203, column: 5, scope: !155)
!162 = !DILocation(line: 205, column: 16, scope: !163)
!163 = distinct !DILexicalBlock(scope: !151, file: !20, line: 203, column: 12)
!164 = !DILocation(line: 205, column: 74, scope: !163)
!165 = !DILocation(line: 205, column: 9, scope: !163)
!166 = !DILocation(line: 206, column: 17, scope: !167)
!167 = distinct !DILexicalBlock(scope: !168, file: !20, line: 206, column: 17)
!168 = distinct !DILexicalBlock(scope: !163, file: !20, line: 205, column: 85)
!169 = !DILocation(line: 206, column: 17, scope: !168)
!170 = distinct !{!170, !165, !171, !99}
!171 = !DILocation(line: 210, column: 9, scope: !163)
!172 = !DILocation(line: 207, column: 17, scope: !173)
!173 = distinct !DILexicalBlock(scope: !167, file: !20, line: 206, column: 81)
!174 = !DILocation(line: 208, column: 17, scope: !173)
!175 = !DILocation(line: 213, column: 1, scope: !112)
!176 = distinct !DISubprogram(name: "ticket_awnsb_mutex_unlock", scope: !20, file: !20, line: 222, type: !102, scopeLine: 223, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!177 = !DILocalVariable(name: "self", arg: 1, scope: !176, file: !20, line: 222, type: !66)
!178 = !DILocation(line: 0, scope: !176)
!179 = !DILocation(line: 224, column: 46, scope: !176)
!180 = !DILocation(line: 224, column: 18, scope: !176)
!181 = !DILocalVariable(name: "ticket", scope: !176, file: !20, line: 224, type: !26)
!182 = !DILocation(line: 226, column: 34, scope: !176)
!183 = !DILocation(line: 226, column: 68, scope: !176)
!184 = !DILocation(line: 226, column: 60, scope: !176)
!185 = !DILocation(line: 226, column: 28, scope: !176)
!186 = !DILocation(line: 226, column: 5, scope: !176)
!187 = !DILocation(line: 228, column: 56, scope: !176)
!188 = !DILocation(line: 228, column: 82, scope: !176)
!189 = !DILocation(line: 228, column: 94, scope: !176)
!190 = !DILocation(line: 228, column: 86, scope: !176)
!191 = !DILocation(line: 228, column: 50, scope: !176)
!192 = !DILocation(line: 228, column: 28, scope: !176)
!193 = !DILocalVariable(name: "wnode", scope: !176, file: !20, line: 228, type: !18)
!194 = !DILocation(line: 229, column: 15, scope: !195)
!195 = distinct !DILexicalBlock(scope: !176, file: !20, line: 229, column: 9)
!196 = !DILocation(line: 229, column: 9, scope: !176)
!197 = !DILocation(line: 231, column: 39, scope: !198)
!198 = distinct !DILexicalBlock(scope: !195, file: !20, line: 229, column: 24)
!199 = !DILocation(line: 231, column: 9, scope: !198)
!200 = !DILocation(line: 232, column: 5, scope: !198)
!201 = !DILocation(line: 233, column: 9, scope: !202)
!202 = distinct !DILexicalBlock(scope: !195, file: !20, line: 232, column: 12)
!203 = !DILocation(line: 235, column: 1, scope: !176)
!204 = distinct !DISubprogram(name: "ticket_awnsb_mutex_trylock", scope: !20, file: !20, line: 243, type: !205, scopeLine: 244, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!205 = !DISubroutineType(types: !206)
!206 = !{!26, !66}
!207 = !DILocalVariable(name: "self", arg: 1, scope: !204, file: !20, line: 243, type: !66)
!208 = !DILocation(line: 0, scope: !204)
!209 = !DILocation(line: 245, column: 18, scope: !204)
!210 = !DILocalVariable(name: "localE", scope: !204, file: !20, line: 245, type: !26)
!211 = !DILocation(line: 246, column: 46, scope: !204)
!212 = !DILocation(line: 246, column: 18, scope: !204)
!213 = !DILocalVariable(name: "localI", scope: !204, file: !20, line: 246, type: !26)
!214 = !DILocation(line: 247, column: 16, scope: !215)
!215 = distinct !DILexicalBlock(scope: !204, file: !20, line: 247, column: 9)
!216 = !DILocation(line: 247, column: 9, scope: !204)
!217 = !DILocation(line: 248, column: 10, scope: !218)
!218 = distinct !DILexicalBlock(scope: !204, file: !20, line: 248, column: 9)
!219 = !DILocation(line: 248, column: 9, scope: !204)
!220 = !DILocation(line: 251, column: 1, scope: !204)
!221 = distinct !DISubprogram(name: "thread_n", scope: !37, file: !37, line: 13, type: !222, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!222 = !DISubroutineType(types: !223)
!223 = !{!27, !27}
!224 = !DILocalVariable(name: "arg", arg: 1, scope: !221, file: !37, line: 13, type: !27)
!225 = !DILocation(line: 0, scope: !221)
!226 = !DILocation(line: 15, column: 23, scope: !221)
!227 = !DILocalVariable(name: "index", scope: !221, file: !37, line: 15, type: !28)
!228 = !DILocation(line: 17, column: 5, scope: !221)
!229 = !DILocation(line: 18, column: 14, scope: !221)
!230 = !DILocation(line: 18, column: 12, scope: !221)
!231 = !DILocalVariable(name: "r", scope: !221, file: !37, line: 19, type: !26)
!232 = !DILocation(line: 20, column: 5, scope: !233)
!233 = distinct !DILexicalBlock(scope: !234, file: !37, line: 20, column: 5)
!234 = distinct !DILexicalBlock(scope: !221, file: !37, line: 20, column: 5)
!235 = !DILocation(line: 20, column: 5, scope: !234)
!236 = !DILocation(line: 21, column: 8, scope: !221)
!237 = !DILocation(line: 22, column: 5, scope: !221)
!238 = !DILocation(line: 23, column: 5, scope: !221)
!239 = distinct !DISubprogram(name: "main", scope: !37, file: !37, line: 26, type: !240, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!240 = !DISubroutineType(types: !241)
!241 = !{!26}
!242 = !DILocalVariable(name: "t", scope: !239, file: !37, line: 28, type: !243)
!243 = !DICompositeType(tag: DW_TAG_array_type, baseType: !244, size: 192, elements: !246)
!244 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !245, line: 27, baseType: !33)
!245 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!246 = !{!247}
!247 = !DISubrange(count: 3)
!248 = !DILocation(line: 28, column: 15, scope: !239)
!249 = !DILocation(line: 30, column: 5, scope: !239)
!250 = !DILocalVariable(name: "i", scope: !251, file: !37, line: 32, type: !26)
!251 = distinct !DILexicalBlock(scope: !239, file: !37, line: 32, column: 5)
!252 = !DILocation(line: 0, scope: !251)
!253 = !DILocation(line: 33, column: 25, scope: !254)
!254 = distinct !DILexicalBlock(scope: !251, file: !37, line: 32, column: 5)
!255 = !DILocation(line: 33, column: 9, scope: !254)
!256 = !DILocalVariable(name: "i", scope: !257, file: !37, line: 35, type: !26)
!257 = distinct !DILexicalBlock(scope: !239, file: !37, line: 35, column: 5)
!258 = !DILocation(line: 0, scope: !257)
!259 = !DILocation(line: 36, column: 22, scope: !260)
!260 = distinct !DILexicalBlock(scope: !257, file: !37, line: 35, column: 5)
!261 = !DILocation(line: 36, column: 9, scope: !260)
!262 = !DILocation(line: 38, column: 5, scope: !263)
!263 = distinct !DILexicalBlock(scope: !264, file: !37, line: 38, column: 5)
!264 = distinct !DILexicalBlock(scope: !239, file: !37, line: 38, column: 5)
!265 = !DILocation(line: 38, column: 5, scope: !264)
!266 = !DILocation(line: 40, column: 5, scope: !239)
