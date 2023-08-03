; ModuleID = 'output/ticket_awnsb_mutex.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/ticket_awnsb_mutex.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.awnsb_node_t.0 = type { i32 }
%struct.ticket_awnsb_mutex_t = type { i32, [8 x i8], i32, [8 x i8], i32, %struct.awnsb_node_t** }
%struct.awnsb_node_t = type opaque
%union.pthread_attr_t = type { i64, [48 x i8] }

@tlNode = internal thread_local global %struct.awnsb_node_t.0 zeroinitializer, align 4, !dbg !0
@sum = dso_local global i32 0, align 4, !dbg !31
@lock = dso_local global %struct.ticket_awnsb_mutex_t zeroinitializer, align 8, !dbg !36
@shared = dso_local global i32 0, align 4, !dbg !34
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
  %9 = bitcast i8* %8 to %struct.awnsb_node_t.0**, !dbg !80
  %10 = bitcast %struct.awnsb_node_t.0** %9 to %struct.awnsb_node_t**, !dbg !80
  %11 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 5, !dbg !81
  store %struct.awnsb_node_t** %10, %struct.awnsb_node_t*** %11, align 8, !dbg !82
  call void @__VERIFIER_loop_bound(i32 noundef 4), !dbg !83
  call void @llvm.dbg.value(metadata i32 0, metadata !84, metadata !DIExpression()), !dbg !86
  br label %12, !dbg !87

12:                                               ; preds = %16, %2
  %indvars.iv = phi i64 [ %indvars.iv.next, %16 ], [ 0, %2 ], !dbg !86
  call void @llvm.dbg.value(metadata i64 %indvars.iv, metadata !84, metadata !DIExpression()), !dbg !86
  %13 = load i32, i32* %5, align 8, !dbg !88
  %14 = sext i32 %13 to i64, !dbg !90
  %15 = icmp slt i64 %indvars.iv, %14, !dbg !90
  br i1 %15, label %16, label %20, !dbg !91

16:                                               ; preds = %12
  %17 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %11, align 8, !dbg !92
  %18 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %17, i64 %indvars.iv, !dbg !93
  %19 = bitcast %struct.awnsb_node_t** %18 to i64*, !dbg !94
  store atomic i64 0, i64* %19 seq_cst, align 8, !dbg !94
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !95
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next, metadata !84, metadata !DIExpression()), !dbg !86
  br label %12, !dbg !96, !llvm.loop !97

20:                                               ; preds = %12
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
  %4 = sext i32 %3 to i64, !dbg !116
  call void @llvm.dbg.value(metadata i64 %4, metadata !117, metadata !DIExpression()), !dbg !114
  %5 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 2, !dbg !120
  %6 = load atomic i32, i32* %5 acquire, align 4, !dbg !122
  %7 = sext i32 %6 to i64, !dbg !122
  %8 = icmp eq i64 %7, %4, !dbg !123
  br i1 %8, label %53, label %9, !dbg !124

9:                                                ; preds = %1
  %10 = add nsw i64 %4, -1, !dbg !125
  br label %11, !dbg !125

11:                                               ; preds = %16, %9
  %12 = load atomic i32, i32* %5 monotonic, align 4, !dbg !126
  %13 = sext i32 %12 to i64, !dbg !126
  %14 = sub nsw i64 %4, 1, !dbg !127
  %15 = icmp sge i64 %13, %14, !dbg !128
  br i1 %15, label %16, label %._crit_edge, !dbg !125

._crit_edge:                                      ; preds = %11
  %.phi.trans.insert = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 4
  %.pre = load i32, i32* %.phi.trans.insert, align 8, !dbg !129
  br label %20, !dbg !125

16:                                               ; preds = %11
  %17 = load atomic i32, i32* %5 acquire, align 4, !dbg !130
  %18 = sext i32 %17 to i64, !dbg !130
  %19 = icmp eq i64 %18, %4, !dbg !133
  br i1 %19, label %53, label %11, !dbg !134, !llvm.loop !135

20:                                               ; preds = %._crit_edge, %20
  %21 = load atomic i32, i32* %5 monotonic, align 4, !dbg !137
  %22 = sext i32 %21 to i64, !dbg !137
  %23 = sub nsw i64 %4, %22, !dbg !138
  %24 = sub nsw i32 %.pre, 1, !dbg !139
  %25 = sext i32 %24 to i64, !dbg !140
  %26 = icmp sge i64 %23, %25, !dbg !141
  br i1 %26, label %20, label %27, !dbg !142, !llvm.loop !143

27:                                               ; preds = %20
  %scevgep = getelementptr %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i64 0, i32 4, !dbg !142
  call void @llvm.dbg.value(metadata %struct.awnsb_node_t.0* @tlNode, metadata !145, metadata !DIExpression()), !dbg !114
  store atomic i32 0, i32* getelementptr inbounds (%struct.awnsb_node_t.0, %struct.awnsb_node_t.0* @tlNode, i64 0, i32 0) monotonic, align 4, !dbg !146
  %28 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 5, !dbg !147
  %29 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %28, align 8, !dbg !147
  %30 = load i32, i32* %scevgep, align 8, !dbg !148
  %31 = sext i32 %30 to i64, !dbg !149
  %32 = srem i64 %4, %31, !dbg !150
  %33 = trunc i64 %32 to i32, !dbg !151
  %34 = sext i32 %33 to i64, !dbg !152
  %35 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %29, i64 %34, !dbg !152
  %36 = bitcast %struct.awnsb_node_t** %35 to i64*, !dbg !153
  store atomic i64 ptrtoint (%struct.awnsb_node_t.0* @tlNode to i64), i64* %36 release, align 8, !dbg !153
  %37 = load atomic i32, i32* %5 monotonic, align 4, !dbg !154
  %38 = sext i32 %37 to i64, !dbg !154
  %39 = icmp slt i64 %38, %10, !dbg !156
  br i1 %39, label %40, label %45, !dbg !157

40:                                               ; preds = %40, %27
  %41 = load atomic i32, i32* getelementptr inbounds (%struct.awnsb_node_t.0, %struct.awnsb_node_t.0* @tlNode, i64 0, i32 0) monotonic, align 4, !dbg !158
  %42 = icmp ne i32 %41, 0, !dbg !160
  %43 = xor i1 %42, true, !dbg !160
  br i1 %43, label %40, label %44, !dbg !161, !llvm.loop !162

44:                                               ; preds = %40
  store atomic i32 %3, i32* %5 monotonic, align 4, !dbg !164
  br label %53, !dbg !165

45:                                               ; preds = %49, %27
  %46 = load atomic i32, i32* %5 acquire, align 4, !dbg !166
  %47 = sext i32 %46 to i64, !dbg !166
  %48 = icmp ne i64 %47, %4, !dbg !168
  br i1 %48, label %49, label %53, !dbg !169

49:                                               ; preds = %45
  %50 = load atomic i32, i32* getelementptr inbounds (%struct.awnsb_node_t.0, %struct.awnsb_node_t.0* @tlNode, i64 0, i32 0) acquire, align 4, !dbg !170
  %51 = icmp ne i32 %50, 0, !dbg !170
  br i1 %51, label %52, label %45, !dbg !173, !llvm.loop !174

52:                                               ; preds = %49
  store atomic i32 %3, i32* %5 monotonic, align 4, !dbg !176
  br label %53, !dbg !178

53:                                               ; preds = %45, %16, %1, %52, %44
  ret void, !dbg !179
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @ticket_awnsb_mutex_unlock(%struct.ticket_awnsb_mutex_t* noundef %0) #0 !dbg !180 {
  call void @llvm.dbg.value(metadata %struct.ticket_awnsb_mutex_t* %0, metadata !181, metadata !DIExpression()), !dbg !182
  %2 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 2, !dbg !183
  %3 = load atomic i32, i32* %2 monotonic, align 4, !dbg !184
  %4 = sext i32 %3 to i64, !dbg !184
  call void @llvm.dbg.value(metadata i64 %4, metadata !185, metadata !DIExpression()), !dbg !182
  %5 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 5, !dbg !186
  %6 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %5, align 8, !dbg !186
  %7 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 4, !dbg !187
  %8 = load i32, i32* %7, align 8, !dbg !187
  %9 = sext i32 %8 to i64, !dbg !188
  %10 = srem i64 %4, %9, !dbg !189
  %11 = trunc i64 %10 to i32, !dbg !190
  %12 = sext i32 %11 to i64, !dbg !191
  %13 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %6, i64 %12, !dbg !191
  %14 = bitcast %struct.awnsb_node_t** %13 to i64*, !dbg !192
  store atomic i64 0, i64* %14 monotonic, align 8, !dbg !192
  %15 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %5, align 8, !dbg !193
  %16 = add nsw i64 %4, 1, !dbg !194
  %17 = load i32, i32* %7, align 8, !dbg !195
  %18 = sext i32 %17 to i64, !dbg !196
  %19 = srem i64 %16, %18, !dbg !197
  %20 = trunc i64 %19 to i32, !dbg !198
  %21 = sext i32 %20 to i64, !dbg !199
  %22 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %15, i64 %21, !dbg !199
  %23 = bitcast %struct.awnsb_node_t** %22 to i64*, !dbg !200
  %24 = load atomic i64, i64* %23 acquire, align 8, !dbg !200
  %25 = inttoptr i64 %24 to %struct.awnsb_node_t*, !dbg !200
  %26 = bitcast %struct.awnsb_node_t* %25 to %struct.awnsb_node_t.0*, !dbg !200
  call void @llvm.dbg.value(metadata %struct.awnsb_node_t.0* %26, metadata !201, metadata !DIExpression()), !dbg !182
  %27 = icmp ne %struct.awnsb_node_t.0* %26, null, !dbg !202
  br i1 %27, label %28, label %30, !dbg !204

28:                                               ; preds = %1
  %29 = getelementptr inbounds %struct.awnsb_node_t.0, %struct.awnsb_node_t.0* %26, i32 0, i32 0, !dbg !205
  store atomic i32 1, i32* %29 release, align 4, !dbg !207
  br label %32, !dbg !208

30:                                               ; preds = %1
  %31 = trunc i64 %16 to i32, !dbg !209
  store atomic i32 %31, i32* %2 release, align 4, !dbg !211
  br label %32

32:                                               ; preds = %30, %28
  ret void, !dbg !212
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @ticket_awnsb_mutex_trylock(%struct.ticket_awnsb_mutex_t* noundef %0) #0 !dbg !213 {
  call void @llvm.dbg.value(metadata %struct.ticket_awnsb_mutex_t* %0, metadata !216, metadata !DIExpression()), !dbg !217
  %2 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 2, !dbg !218
  %3 = load atomic i32, i32* %2 seq_cst, align 4, !dbg !218
  %4 = sext i32 %3 to i64, !dbg !218
  call void @llvm.dbg.value(metadata i64 %4, metadata !219, metadata !DIExpression()), !dbg !217
  %5 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %0, i32 0, i32 0, !dbg !220
  %6 = load atomic i32, i32* %5 monotonic, align 8, !dbg !221
  %7 = sext i32 %6 to i64, !dbg !221
  call void @llvm.dbg.value(metadata i32 %6, metadata !222, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !217
  %.sroa.4.0.extract.shift = lshr i64 %7, 32, !dbg !223
  %.sroa.4.0.extract.trunc = trunc i64 %.sroa.4.0.extract.shift to i32, !dbg !223
  call void @llvm.dbg.value(metadata i32 %.sroa.4.0.extract.trunc, metadata !222, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !217
  %.sroa.4.0.insert.ext = zext i32 %.sroa.4.0.extract.trunc to i64, !dbg !224
  %.sroa.4.0.insert.shift = shl i64 %.sroa.4.0.insert.ext, 32, !dbg !224
  %.sroa.0.0.insert.ext = zext i32 %6 to i64, !dbg !224
  %.sroa.0.0.insert.insert = or i64 %.sroa.4.0.insert.shift, %.sroa.0.0.insert.ext, !dbg !224
  %8 = icmp ne i64 %4, %.sroa.0.0.insert.insert, !dbg !224
  br i1 %8, label %15, label %9, !dbg !226

9:                                                ; preds = %1
  %10 = load atomic i32, i32* %5 seq_cst, align 4, !dbg !227
  %11 = add nsw i32 %10, 1, !dbg !227
  %12 = cmpxchg i32* %5, i32 %6, i32 %11 seq_cst seq_cst, align 4, !dbg !227
  %13 = extractvalue { i32, i1 } %12, 1, !dbg !227
  %14 = zext i1 %13 to i8, !dbg !227
  %spec.select = select i1 %13, i32 0, i32 16, !dbg !229
  br label %15, !dbg !229

15:                                               ; preds = %9, %1
  %.0 = phi i32 [ 16, %1 ], [ %spec.select, %9 ], !dbg !217
  ret i32 %.0, !dbg !230
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !231 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !234, metadata !DIExpression()), !dbg !235
  %2 = ptrtoint i8* %0 to i64, !dbg !236
  call void @llvm.dbg.value(metadata i64 %2, metadata !237, metadata !DIExpression()), !dbg !235
  call void @ticket_awnsb_mutex_lock(%struct.ticket_awnsb_mutex_t* noundef @lock), !dbg !238
  %3 = trunc i64 %2 to i32, !dbg !239
  store i32 %3, i32* @shared, align 4, !dbg !240
  call void @llvm.dbg.value(metadata i32 %3, metadata !241, metadata !DIExpression()), !dbg !235
  %4 = sext i32 %3 to i64, !dbg !242
  %5 = icmp eq i64 %4, %2, !dbg !242
  br i1 %5, label %7, label %6, !dbg !245

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #6, !dbg !242
  unreachable, !dbg !242

7:                                                ; preds = %1
  %8 = load i32, i32* @sum, align 4, !dbg !246
  %9 = add nsw i32 %8, 1, !dbg !246
  store i32 %9, i32* @sum, align 4, !dbg !246
  call void @ticket_awnsb_mutex_unlock(%struct.ticket_awnsb_mutex_t* noundef @lock), !dbg !247
  ret i8* null, !dbg !248
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !249 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !252, metadata !DIExpression()), !dbg !259
  call void @ticket_awnsb_mutex_init(%struct.ticket_awnsb_mutex_t* noundef @lock, i32 noundef 3), !dbg !260
  call void @llvm.dbg.value(metadata i32 0, metadata !261, metadata !DIExpression()), !dbg !263
  call void @llvm.dbg.value(metadata i64 0, metadata !261, metadata !DIExpression()), !dbg !263
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !264
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef null) #5, !dbg !266
  call void @llvm.dbg.value(metadata i64 1, metadata !261, metadata !DIExpression()), !dbg !263
  call void @llvm.dbg.value(metadata i64 1, metadata !261, metadata !DIExpression()), !dbg !263
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !264
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 1 to i8*)) #5, !dbg !266
  call void @llvm.dbg.value(metadata i64 2, metadata !261, metadata !DIExpression()), !dbg !263
  call void @llvm.dbg.value(metadata i64 2, metadata !261, metadata !DIExpression()), !dbg !263
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !264
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 2 to i8*)) #5, !dbg !266
  call void @llvm.dbg.value(metadata i64 3, metadata !261, metadata !DIExpression()), !dbg !263
  call void @llvm.dbg.value(metadata i64 3, metadata !261, metadata !DIExpression()), !dbg !263
  call void @llvm.dbg.value(metadata i32 0, metadata !267, metadata !DIExpression()), !dbg !269
  call void @llvm.dbg.value(metadata i64 0, metadata !267, metadata !DIExpression()), !dbg !269
  %8 = load i64, i64* %2, align 8, !dbg !270
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !272
  call void @llvm.dbg.value(metadata i64 1, metadata !267, metadata !DIExpression()), !dbg !269
  call void @llvm.dbg.value(metadata i64 1, metadata !267, metadata !DIExpression()), !dbg !269
  %10 = load i64, i64* %4, align 8, !dbg !270
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !272
  call void @llvm.dbg.value(metadata i64 2, metadata !267, metadata !DIExpression()), !dbg !269
  call void @llvm.dbg.value(metadata i64 2, metadata !267, metadata !DIExpression()), !dbg !269
  %12 = load i64, i64* %6, align 8, !dbg !270
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !272
  call void @llvm.dbg.value(metadata i64 3, metadata !267, metadata !DIExpression()), !dbg !269
  call void @llvm.dbg.value(metadata i64 3, metadata !267, metadata !DIExpression()), !dbg !269
  %14 = load i32, i32* @sum, align 4, !dbg !273
  %15 = icmp eq i32 %14, 3, !dbg !273
  br i1 %15, label %17, label %16, !dbg !276

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !273
  unreachable, !dbg !273

17:                                               ; preds = %0
  ret i32 0, !dbg !277
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
!1 = distinct !DIGlobalVariable(name: "tlNode", scope: !2, file: !19, line: 143, type: !18, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !30, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/ticket_awnsb_mutex.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "8c886d2126b7a75c6a6126eef55af894")
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
!15 = !{!16, !26, !25, !27}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "awnsb_node_t", file: !19, line: 125, baseType: !20)
!19 = !DIFile(filename: "benchmarks/locks/ticket_awnsb_mutex.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "716d3c4ee38f78bfba639449ab728256")
!20 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !19, line: 123, size: 32, elements: !21)
!21 = !{!22}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "lockIsMine", scope: !20, file: !19, line: 124, baseType: !23, size: 32)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !24)
!24 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !25)
!25 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !28, line: 87, baseType: !29)
!28 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!29 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!30 = !{!31, !0, !34, !36}
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !33, line: 11, type: !25, isLocal: false, isDefinition: true)
!33 = !DIFile(filename: "benchmarks/locks/ticket_awnsb_mutex.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "8c886d2126b7a75c6a6126eef55af894")
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "shared", scope: !2, file: !33, line: 9, type: !25, isLocal: false, isDefinition: true)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !33, line: 10, type: !38, isLocal: false, isDefinition: true)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "ticket_awnsb_mutex_t", file: !19, line: 135, baseType: !39)
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !19, line: 127, size: 320, elements: !40)
!40 = !{!41, !42, !47, !48, !49, !50}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "ingress", scope: !39, file: !19, line: 129, baseType: !23, size: 32)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "padding1", scope: !39, file: !19, line: 130, baseType: !43, size: 64, offset: 32)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !44, size: 64, elements: !45)
!44 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!45 = !{!46}
!46 = !DISubrange(count: 8)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "egress", scope: !39, file: !19, line: 131, baseType: !23, size: 32, offset: 96)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "padding2", scope: !39, file: !19, line: 132, baseType: !43, size: 64, offset: 128)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "maxArrayWaiters", scope: !39, file: !19, line: 133, baseType: !25, size: 32, offset: 192)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "waitersArray", scope: !39, file: !19, line: 134, baseType: !51, size: 64, offset: 256)
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !52, size: 64)
!52 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !53)
!53 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !54, size: 64)
!54 = !DICompositeType(tag: DW_TAG_structure_type, name: "awnsb_node_t", file: !19, line: 134, flags: DIFlagFwdDecl)
!55 = !{i32 7, !"Dwarf Version", i32 5}
!56 = !{i32 2, !"Debug Info Version", i32 3}
!57 = !{i32 1, !"wchar_size", i32 4}
!58 = !{i32 7, !"PIC Level", i32 2}
!59 = !{i32 7, !"PIE Level", i32 2}
!60 = !{i32 7, !"uwtable", i32 1}
!61 = !{i32 7, !"frame-pointer", i32 2}
!62 = !{!"Ubuntu clang version 14.0.6"}
!63 = distinct !DISubprogram(name: "ticket_awnsb_mutex_init", scope: !19, file: !19, line: 153, type: !64, scopeLine: 154, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!64 = !DISubroutineType(types: !65)
!65 = !{null, !66, !25}
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!67 = !{}
!68 = !DILocalVariable(name: "self", arg: 1, scope: !63, file: !19, line: 153, type: !66)
!69 = !DILocation(line: 0, scope: !63)
!70 = !DILocalVariable(name: "maxArrayWaiters", arg: 2, scope: !63, file: !19, line: 153, type: !25)
!71 = !DILocation(line: 155, column: 24, scope: !63)
!72 = !DILocation(line: 155, column: 5, scope: !63)
!73 = !DILocation(line: 156, column: 24, scope: !63)
!74 = !DILocation(line: 156, column: 5, scope: !63)
!75 = !DILocation(line: 157, column: 11, scope: !63)
!76 = !DILocation(line: 157, column: 27, scope: !63)
!77 = !DILocation(line: 158, column: 50, scope: !63)
!78 = !DILocation(line: 158, column: 71, scope: !63)
!79 = !DILocation(line: 158, column: 43, scope: !63)
!80 = !DILocation(line: 158, column: 26, scope: !63)
!81 = !DILocation(line: 158, column: 11, scope: !63)
!82 = !DILocation(line: 158, column: 24, scope: !63)
!83 = !DILocation(line: 159, column: 5, scope: !63)
!84 = !DILocalVariable(name: "i", scope: !85, file: !19, line: 160, type: !25)
!85 = distinct !DILexicalBlock(scope: !63, file: !19, line: 160, column: 5)
!86 = !DILocation(line: 0, scope: !85)
!87 = !DILocation(line: 160, column: 10, scope: !85)
!88 = !DILocation(line: 160, column: 31, scope: !89)
!89 = distinct !DILexicalBlock(scope: !85, file: !19, line: 160, column: 5)
!90 = !DILocation(line: 160, column: 23, scope: !89)
!91 = !DILocation(line: 160, column: 5, scope: !85)
!92 = !DILocation(line: 160, column: 59, scope: !89)
!93 = !DILocation(line: 160, column: 53, scope: !89)
!94 = !DILocation(line: 160, column: 75, scope: !89)
!95 = !DILocation(line: 160, column: 49, scope: !89)
!96 = !DILocation(line: 160, column: 5, scope: !89)
!97 = distinct !{!97, !91, !98, !99}
!98 = !DILocation(line: 160, column: 77, scope: !85)
!99 = !{!"llvm.loop.mustprogress"}
!100 = !DILocation(line: 161, column: 1, scope: !63)
!101 = distinct !DISubprogram(name: "ticket_awnsb_mutex_destroy", scope: !19, file: !19, line: 164, type: !102, scopeLine: 165, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!102 = !DISubroutineType(types: !103)
!103 = !{null, !66}
!104 = !DILocalVariable(name: "self", arg: 1, scope: !101, file: !19, line: 164, type: !66)
!105 = !DILocation(line: 0, scope: !101)
!106 = !DILocation(line: 166, column: 5, scope: !101)
!107 = !DILocation(line: 167, column: 5, scope: !101)
!108 = !DILocation(line: 168, column: 16, scope: !101)
!109 = !DILocation(line: 168, column: 10, scope: !101)
!110 = !DILocation(line: 168, column: 5, scope: !101)
!111 = !DILocation(line: 169, column: 1, scope: !101)
!112 = distinct !DISubprogram(name: "ticket_awnsb_mutex_lock", scope: !19, file: !19, line: 179, type: !102, scopeLine: 180, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!113 = !DILocalVariable(name: "self", arg: 1, scope: !112, file: !19, line: 179, type: !66)
!114 = !DILocation(line: 0, scope: !112)
!115 = !DILocation(line: 181, column: 63, scope: !112)
!116 = !DILocation(line: 181, column: 30, scope: !112)
!117 = !DILocalVariable(name: "ticket", scope: !112, file: !19, line: 181, type: !118)
!118 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !119)
!119 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!120 = !DILocation(line: 185, column: 37, scope: !121)
!121 = distinct !DILexicalBlock(scope: !112, file: !19, line: 185, column: 9)
!122 = !DILocation(line: 185, column: 9, scope: !121)
!123 = !DILocation(line: 185, column: 67, scope: !121)
!124 = !DILocation(line: 185, column: 9, scope: !112)
!125 = !DILocation(line: 187, column: 5, scope: !112)
!126 = !DILocation(line: 187, column: 12, scope: !112)
!127 = !DILocation(line: 187, column: 79, scope: !112)
!128 = !DILocation(line: 187, column: 70, scope: !112)
!129 = !DILocation(line: 191, column: 87, scope: !112)
!130 = !DILocation(line: 188, column: 13, scope: !131)
!131 = distinct !DILexicalBlock(scope: !132, file: !19, line: 188, column: 13)
!132 = distinct !DILexicalBlock(scope: !112, file: !19, line: 187, column: 83)
!133 = !DILocation(line: 188, column: 71, scope: !131)
!134 = !DILocation(line: 188, column: 13, scope: !132)
!135 = distinct !{!135, !125, !136, !99}
!136 = !DILocation(line: 189, column: 5, scope: !112)
!137 = !DILocation(line: 191, column: 19, scope: !112)
!138 = !DILocation(line: 191, column: 18, scope: !112)
!139 = !DILocation(line: 191, column: 102, scope: !112)
!140 = !DILocation(line: 191, column: 80, scope: !112)
!141 = !DILocation(line: 191, column: 77, scope: !112)
!142 = !DILocation(line: 191, column: 5, scope: !112)
!143 = distinct !{!143, !142, !144, !99}
!144 = !DILocation(line: 191, column: 106, scope: !112)
!145 = !DILocalVariable(name: "wnode", scope: !112, file: !19, line: 194, type: !17)
!146 = !DILocation(line: 196, column: 5, scope: !112)
!147 = !DILocation(line: 197, column: 34, scope: !112)
!148 = !DILocation(line: 197, column: 68, scope: !112)
!149 = !DILocation(line: 197, column: 62, scope: !112)
!150 = !DILocation(line: 197, column: 60, scope: !112)
!151 = !DILocation(line: 197, column: 47, scope: !112)
!152 = !DILocation(line: 197, column: 28, scope: !112)
!153 = !DILocation(line: 197, column: 5, scope: !112)
!154 = !DILocation(line: 199, column: 9, scope: !155)
!155 = distinct !DILexicalBlock(scope: !112, file: !19, line: 199, column: 9)
!156 = !DILocation(line: 199, column: 67, scope: !155)
!157 = !DILocation(line: 199, column: 9, scope: !112)
!158 = !DILocation(line: 201, column: 17, scope: !159)
!159 = distinct !DILexicalBlock(scope: !155, file: !19, line: 199, column: 79)
!160 = !DILocation(line: 201, column: 16, scope: !159)
!161 = !DILocation(line: 201, column: 9, scope: !159)
!162 = distinct !{!162, !161, !163, !99}
!163 = !DILocation(line: 201, column: 80, scope: !159)
!164 = !DILocation(line: 202, column: 9, scope: !159)
!165 = !DILocation(line: 203, column: 5, scope: !159)
!166 = !DILocation(line: 205, column: 16, scope: !167)
!167 = distinct !DILexicalBlock(scope: !155, file: !19, line: 203, column: 12)
!168 = !DILocation(line: 205, column: 74, scope: !167)
!169 = !DILocation(line: 205, column: 9, scope: !167)
!170 = !DILocation(line: 206, column: 17, scope: !171)
!171 = distinct !DILexicalBlock(scope: !172, file: !19, line: 206, column: 17)
!172 = distinct !DILexicalBlock(scope: !167, file: !19, line: 205, column: 85)
!173 = !DILocation(line: 206, column: 17, scope: !172)
!174 = distinct !{!174, !169, !175, !99}
!175 = !DILocation(line: 210, column: 9, scope: !167)
!176 = !DILocation(line: 207, column: 17, scope: !177)
!177 = distinct !DILexicalBlock(scope: !171, file: !19, line: 206, column: 81)
!178 = !DILocation(line: 208, column: 17, scope: !177)
!179 = !DILocation(line: 213, column: 1, scope: !112)
!180 = distinct !DISubprogram(name: "ticket_awnsb_mutex_unlock", scope: !19, file: !19, line: 222, type: !102, scopeLine: 223, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!181 = !DILocalVariable(name: "self", arg: 1, scope: !180, file: !19, line: 222, type: !66)
!182 = !DILocation(line: 0, scope: !180)
!183 = !DILocation(line: 224, column: 52, scope: !180)
!184 = !DILocation(line: 224, column: 24, scope: !180)
!185 = !DILocalVariable(name: "ticket", scope: !180, file: !19, line: 224, type: !119)
!186 = !DILocation(line: 226, column: 34, scope: !180)
!187 = !DILocation(line: 226, column: 68, scope: !180)
!188 = !DILocation(line: 226, column: 62, scope: !180)
!189 = !DILocation(line: 226, column: 60, scope: !180)
!190 = !DILocation(line: 226, column: 47, scope: !180)
!191 = !DILocation(line: 226, column: 28, scope: !180)
!192 = !DILocation(line: 226, column: 5, scope: !180)
!193 = !DILocation(line: 228, column: 56, scope: !180)
!194 = !DILocation(line: 228, column: 82, scope: !180)
!195 = !DILocation(line: 228, column: 94, scope: !180)
!196 = !DILocation(line: 228, column: 88, scope: !180)
!197 = !DILocation(line: 228, column: 86, scope: !180)
!198 = !DILocation(line: 228, column: 69, scope: !180)
!199 = !DILocation(line: 228, column: 50, scope: !180)
!200 = !DILocation(line: 228, column: 28, scope: !180)
!201 = !DILocalVariable(name: "wnode", scope: !180, file: !19, line: 228, type: !17)
!202 = !DILocation(line: 229, column: 15, scope: !203)
!203 = distinct !DILexicalBlock(scope: !180, file: !19, line: 229, column: 9)
!204 = !DILocation(line: 229, column: 9, scope: !180)
!205 = !DILocation(line: 231, column: 39, scope: !206)
!206 = distinct !DILexicalBlock(scope: !203, file: !19, line: 229, column: 24)
!207 = !DILocation(line: 231, column: 9, scope: !206)
!208 = !DILocation(line: 232, column: 5, scope: !206)
!209 = !DILocation(line: 233, column: 46, scope: !210)
!210 = distinct !DILexicalBlock(scope: !203, file: !19, line: 232, column: 12)
!211 = !DILocation(line: 233, column: 9, scope: !210)
!212 = !DILocation(line: 235, column: 1, scope: !180)
!213 = distinct !DISubprogram(name: "ticket_awnsb_mutex_trylock", scope: !19, file: !19, line: 243, type: !214, scopeLine: 244, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!214 = !DISubroutineType(types: !215)
!215 = !{!25, !66}
!216 = !DILocalVariable(name: "self", arg: 1, scope: !213, file: !19, line: 243, type: !66)
!217 = !DILocation(line: 0, scope: !213)
!218 = !DILocation(line: 245, column: 24, scope: !213)
!219 = !DILocalVariable(name: "localE", scope: !213, file: !19, line: 245, type: !119)
!220 = !DILocation(line: 246, column: 52, scope: !213)
!221 = !DILocation(line: 246, column: 24, scope: !213)
!222 = !DILocalVariable(name: "localI", scope: !213, file: !19, line: 246, type: !119)
!223 = !DILocation(line: 246, column: 15, scope: !213)
!224 = !DILocation(line: 247, column: 16, scope: !225)
!225 = distinct !DILexicalBlock(scope: !213, file: !19, line: 247, column: 9)
!226 = !DILocation(line: 247, column: 9, scope: !213)
!227 = !DILocation(line: 248, column: 10, scope: !228)
!228 = distinct !DILexicalBlock(scope: !213, file: !19, line: 248, column: 9)
!229 = !DILocation(line: 248, column: 9, scope: !213)
!230 = !DILocation(line: 251, column: 1, scope: !213)
!231 = distinct !DISubprogram(name: "thread_n", scope: !33, file: !33, line: 13, type: !232, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!232 = !DISubroutineType(types: !233)
!233 = !{!26, !26}
!234 = !DILocalVariable(name: "arg", arg: 1, scope: !231, file: !33, line: 13, type: !26)
!235 = !DILocation(line: 0, scope: !231)
!236 = !DILocation(line: 15, column: 23, scope: !231)
!237 = !DILocalVariable(name: "index", scope: !231, file: !33, line: 15, type: !27)
!238 = !DILocation(line: 17, column: 5, scope: !231)
!239 = !DILocation(line: 18, column: 14, scope: !231)
!240 = !DILocation(line: 18, column: 12, scope: !231)
!241 = !DILocalVariable(name: "r", scope: !231, file: !33, line: 19, type: !25)
!242 = !DILocation(line: 20, column: 5, scope: !243)
!243 = distinct !DILexicalBlock(scope: !244, file: !33, line: 20, column: 5)
!244 = distinct !DILexicalBlock(scope: !231, file: !33, line: 20, column: 5)
!245 = !DILocation(line: 20, column: 5, scope: !244)
!246 = !DILocation(line: 21, column: 8, scope: !231)
!247 = !DILocation(line: 22, column: 5, scope: !231)
!248 = !DILocation(line: 23, column: 5, scope: !231)
!249 = distinct !DISubprogram(name: "main", scope: !33, file: !33, line: 26, type: !250, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!250 = !DISubroutineType(types: !251)
!251 = !{!25}
!252 = !DILocalVariable(name: "t", scope: !249, file: !33, line: 28, type: !253)
!253 = !DICompositeType(tag: DW_TAG_array_type, baseType: !254, size: 192, elements: !257)
!254 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !255, line: 27, baseType: !256)
!255 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!256 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!257 = !{!258}
!258 = !DISubrange(count: 3)
!259 = !DILocation(line: 28, column: 15, scope: !249)
!260 = !DILocation(line: 30, column: 5, scope: !249)
!261 = !DILocalVariable(name: "i", scope: !262, file: !33, line: 32, type: !25)
!262 = distinct !DILexicalBlock(scope: !249, file: !33, line: 32, column: 5)
!263 = !DILocation(line: 0, scope: !262)
!264 = !DILocation(line: 33, column: 25, scope: !265)
!265 = distinct !DILexicalBlock(scope: !262, file: !33, line: 32, column: 5)
!266 = !DILocation(line: 33, column: 9, scope: !265)
!267 = !DILocalVariable(name: "i", scope: !268, file: !33, line: 35, type: !25)
!268 = distinct !DILexicalBlock(scope: !249, file: !33, line: 35, column: 5)
!269 = !DILocation(line: 0, scope: !268)
!270 = !DILocation(line: 36, column: 22, scope: !271)
!271 = distinct !DILexicalBlock(scope: !268, file: !33, line: 35, column: 5)
!272 = !DILocation(line: 36, column: 9, scope: !271)
!273 = !DILocation(line: 38, column: 5, scope: !274)
!274 = distinct !DILexicalBlock(scope: !275, file: !33, line: 38, column: 5)
!275 = distinct !DILexicalBlock(scope: !249, file: !33, line: 38, column: 5)
!276 = !DILocation(line: 38, column: 5, scope: !275)
!277 = !DILocation(line: 40, column: 5, scope: !249)
