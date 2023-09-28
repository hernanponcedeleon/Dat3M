; ModuleID = 'output/cna.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/cna.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.cna_lock_t = type { %struct.cna_node* }
%struct.cna_node = type { i64, i32, %struct.cna_node*, %struct.cna_node* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@shared = dso_local global i32 0, align 4, !dbg !0
@sum = dso_local global i32 0, align 4, !dbg !37
@tindex = dso_local thread_local global i64 0, align 8, !dbg !40
@lock = dso_local global %struct.cna_lock_t zeroinitializer, align 8, !dbg !42
@node = dso_local global [3 x %struct.cna_node] zeroinitializer, align 16, !dbg !49
@.str = private unnamed_addr constant [12 x i8] c"r == tindex\00", align 1
@.str.1 = private unnamed_addr constant [45 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/cna.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @current_numa_node() #0 !dbg !62 {
  %1 = call i32 (...) @__VERIFIER_nondet_uint(), !dbg !66
  ret i32 %1, !dbg !67
}

declare i32 @__VERIFIER_nondet_uint(...) #1

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @keep_lock_local() #0 !dbg !68 {
  %1 = call i32 (...) @__VERIFIER_nondet_bool(), !dbg !72
  %2 = icmp ne i32 %1, 0, !dbg !72
  ret i1 %2, !dbg !73
}

declare i32 @__VERIFIER_nondet_bool(...) #1

; Function Attrs: noinline nounwind uwtable
define dso_local %struct.cna_node* @find_successor(%struct.cna_node* noundef %0) #0 !dbg !74 {
  call void @llvm.dbg.value(metadata %struct.cna_node* %0, metadata !77, metadata !DIExpression()), !dbg !78
  %2 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %0, i32 0, i32 3, !dbg !79
  %3 = bitcast %struct.cna_node** %2 to i64*, !dbg !80
  %4 = load atomic i64, i64* %3 monotonic, align 8, !dbg !80
  %5 = inttoptr i64 %4 to %struct.cna_node*, !dbg !80
  call void @llvm.dbg.value(metadata %struct.cna_node* %5, metadata !81, metadata !DIExpression()), !dbg !78
  %6 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %0, i32 0, i32 1, !dbg !82
  %7 = load atomic i32, i32* %6 monotonic, align 8, !dbg !83
  call void @llvm.dbg.value(metadata i32 %7, metadata !84, metadata !DIExpression()), !dbg !78
  %8 = icmp eq i32 %7, -1, !dbg !85
  br i1 %8, label %9, label %11, !dbg !87

9:                                                ; preds = %1
  %10 = call i32 @current_numa_node(), !dbg !88
  call void @llvm.dbg.value(metadata i32 %10, metadata !84, metadata !DIExpression()), !dbg !78
  br label %11, !dbg !89

11:                                               ; preds = %9, %1
  %.03 = phi i32 [ %10, %9 ], [ %7, %1 ], !dbg !78
  call void @llvm.dbg.value(metadata i32 %.03, metadata !84, metadata !DIExpression()), !dbg !78
  %12 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %5, i32 0, i32 1, !dbg !90
  %13 = load atomic i32, i32* %12 monotonic, align 8, !dbg !92
  %14 = icmp eq i32 %13, %.03, !dbg !93
  br i1 %14, label %53, label %15, !dbg !94

15:                                               ; preds = %11
  call void @llvm.dbg.value(metadata %struct.cna_node* %5, metadata !95, metadata !DIExpression()), !dbg !78
  call void @llvm.dbg.value(metadata %struct.cna_node* %5, metadata !96, metadata !DIExpression()), !dbg !78
  %16 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %5, i32 0, i32 3, !dbg !97
  %17 = bitcast %struct.cna_node** %16 to i64*, !dbg !98
  %18 = load atomic i64, i64* %17 acquire, align 8, !dbg !98
  %19 = inttoptr i64 %18 to %struct.cna_node*, !dbg !98
  call void @llvm.dbg.value(metadata %struct.cna_node* %19, metadata !99, metadata !DIExpression()), !dbg !78
  br label %20, !dbg !100

20:                                               ; preds = %48, %15
  %.02 = phi %struct.cna_node* [ %5, %15 ], [ %.01, %48 ], !dbg !78
  %.01 = phi %struct.cna_node* [ %19, %15 ], [ %52, %48 ], !dbg !78
  call void @llvm.dbg.value(metadata %struct.cna_node* %.01, metadata !99, metadata !DIExpression()), !dbg !78
  call void @llvm.dbg.value(metadata %struct.cna_node* %.02, metadata !96, metadata !DIExpression()), !dbg !78
  %21 = icmp ne %struct.cna_node* %.01, null, !dbg !100
  br i1 %21, label %22, label %53, !dbg !100

22:                                               ; preds = %20
  %23 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %.01, i32 0, i32 1, !dbg !101
  %24 = load atomic i32, i32* %23 monotonic, align 8, !dbg !104
  %25 = icmp eq i32 %24, %.03, !dbg !105
  br i1 %25, label %26, label %48, !dbg !106

26:                                               ; preds = %22
  %27 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %0, i32 0, i32 0, !dbg !107
  %28 = load atomic i64, i64* %27 monotonic, align 8, !dbg !110
  %29 = icmp ugt i64 %28, 1, !dbg !111
  br i1 %29, label %30, label %39, !dbg !112

30:                                               ; preds = %26
  %31 = load atomic i64, i64* %27 monotonic, align 8, !dbg !113
  %32 = inttoptr i64 %31 to %struct.cna_node*, !dbg !115
  call void @llvm.dbg.value(metadata %struct.cna_node* %32, metadata !116, metadata !DIExpression()), !dbg !117
  %33 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %32, i32 0, i32 2, !dbg !118
  %34 = bitcast %struct.cna_node** %33 to i64*, !dbg !119
  %35 = load atomic i64, i64* %34 monotonic, align 8, !dbg !119
  %36 = inttoptr i64 %35 to %struct.cna_node*, !dbg !119
  call void @llvm.dbg.value(metadata %struct.cna_node* %36, metadata !120, metadata !DIExpression()), !dbg !117
  %37 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %36, i32 0, i32 3, !dbg !121
  %38 = bitcast %struct.cna_node** %37 to i64*, !dbg !122
  store atomic i64 %4, i64* %38 monotonic, align 8, !dbg !122
  br label %40, !dbg !123

39:                                               ; preds = %26
  store atomic i64 %4, i64* %27 monotonic, align 8, !dbg !124
  br label %40

40:                                               ; preds = %39, %30
  %41 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %.02, i32 0, i32 3, !dbg !126
  %42 = bitcast %struct.cna_node** %41 to i64*, !dbg !127
  store atomic i64 0, i64* %42 monotonic, align 8, !dbg !127
  %43 = load atomic i64, i64* %27 monotonic, align 8, !dbg !128
  %44 = inttoptr i64 %43 to %struct.cna_node*, !dbg !129
  call void @llvm.dbg.value(metadata %struct.cna_node* %44, metadata !130, metadata !DIExpression()), !dbg !131
  %45 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %44, i32 0, i32 2, !dbg !132
  %46 = bitcast %struct.cna_node** %45 to i64*, !dbg !133
  %47 = ptrtoint %struct.cna_node* %.02 to i64, !dbg !133
  store atomic i64 %47, i64* %46 monotonic, align 8, !dbg !133
  br label %53, !dbg !134

48:                                               ; preds = %22
  call void @llvm.dbg.value(metadata %struct.cna_node* %.01, metadata !96, metadata !DIExpression()), !dbg !78
  %49 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %.01, i32 0, i32 3, !dbg !135
  %50 = bitcast %struct.cna_node** %49 to i64*, !dbg !136
  %51 = load atomic i64, i64* %50 acquire, align 8, !dbg !136
  %52 = inttoptr i64 %51 to %struct.cna_node*, !dbg !136
  call void @llvm.dbg.value(metadata %struct.cna_node* %52, metadata !99, metadata !DIExpression()), !dbg !78
  br label %20, !dbg !100, !llvm.loop !137

53:                                               ; preds = %20, %11, %40
  %.0 = phi %struct.cna_node* [ %.01, %40 ], [ %5, %11 ], [ null, %20 ], !dbg !78
  ret %struct.cna_node* %.0, !dbg !140
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !141 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !144, metadata !DIExpression()), !dbg !145
  %2 = ptrtoint i8* %0 to i64, !dbg !146
  store i64 %2, i64* @tindex, align 8, !dbg !147
  %3 = getelementptr inbounds [3 x %struct.cna_node], [3 x %struct.cna_node]* @node, i64 0, i64 %2, !dbg !148
  call void @cna_lock(%struct.cna_lock_t* noundef @lock, %struct.cna_node* noundef %3), !dbg !149
  %4 = load i64, i64* @tindex, align 8, !dbg !150
  %5 = trunc i64 %4 to i32, !dbg !150
  store i32 %5, i32* @shared, align 4, !dbg !151
  call void @llvm.dbg.value(metadata i32 %5, metadata !152, metadata !DIExpression()), !dbg !145
  %6 = sext i32 %5 to i64, !dbg !153
  %7 = icmp eq i64 %6, %4, !dbg !153
  br i1 %7, label %9, label %8, !dbg !156

8:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([45 x i8], [45 x i8]* @.str.1, i64 0, i64 0), i32 noundef 22, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #5, !dbg !153
  unreachable, !dbg !153

9:                                                ; preds = %1
  %10 = load i32, i32* @sum, align 4, !dbg !157
  %11 = add nsw i32 %10, 1, !dbg !157
  store i32 %11, i32* @sum, align 4, !dbg !157
  %12 = getelementptr inbounds [3 x %struct.cna_node], [3 x %struct.cna_node]* @node, i64 0, i64 %4, !dbg !158
  call void @cna_unlock(%struct.cna_lock_t* noundef @lock, %struct.cna_node* noundef %12), !dbg !159
  ret i8* null, !dbg !160
}

; Function Attrs: noinline nounwind uwtable
define internal void @cna_lock(%struct.cna_lock_t* noundef %0, %struct.cna_node* noundef %1) #0 !dbg !161 {
  call void @llvm.dbg.value(metadata %struct.cna_lock_t* %0, metadata !165, metadata !DIExpression()), !dbg !166
  call void @llvm.dbg.value(metadata %struct.cna_node* %1, metadata !167, metadata !DIExpression()), !dbg !166
  %3 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %1, i32 0, i32 3, !dbg !168
  %4 = bitcast %struct.cna_node** %3 to i64*, !dbg !169
  store atomic i64 0, i64* %4 monotonic, align 8, !dbg !169
  %5 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %1, i32 0, i32 1, !dbg !170
  store atomic i32 -1, i32* %5 monotonic, align 8, !dbg !171
  %6 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %1, i32 0, i32 0, !dbg !172
  store atomic i64 0, i64* %6 monotonic, align 8, !dbg !173
  %7 = getelementptr inbounds %struct.cna_lock_t, %struct.cna_lock_t* %0, i32 0, i32 0, !dbg !174
  %8 = bitcast %struct.cna_node** %7 to i64*, !dbg !175
  %9 = ptrtoint %struct.cna_node* %1 to i64, !dbg !175
  %10 = atomicrmw xchg i64* %8, i64 %9 seq_cst, align 8, !dbg !175
  %11 = inttoptr i64 %10 to %struct.cna_node*, !dbg !175
  call void @llvm.dbg.value(metadata %struct.cna_node* %11, metadata !176, metadata !DIExpression()), !dbg !166
  %12 = icmp ne %struct.cna_node* %11, null, !dbg !177
  br i1 %12, label %14, label %13, !dbg !179

13:                                               ; preds = %2
  store atomic i64 1, i64* %6 monotonic, align 8, !dbg !180
  br label %.loopexit, !dbg !182

14:                                               ; preds = %2
  %15 = call i32 @current_numa_node(), !dbg !183
  store atomic i32 %15, i32* %5 monotonic, align 8, !dbg !184
  %16 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %11, i32 0, i32 3, !dbg !185
  %17 = bitcast %struct.cna_node** %16 to i64*, !dbg !186
  store atomic i64 %9, i64* %17 release, align 8, !dbg !186
  call void @__VERIFIER_loop_begin(), !dbg !187
  call void @llvm.dbg.value(metadata i32 0, metadata !189, metadata !DIExpression()), !dbg !190
  br label %18, !dbg !187

18:                                               ; preds = %18, %14
  call void @__VERIFIER_spin_start(), !dbg !191
  %19 = load atomic i64, i64* %6 acquire, align 8, !dbg !191
  %20 = icmp ne i64 %19, 0, !dbg !191
  %21 = xor i1 %20, true, !dbg !191
  %22 = zext i1 %21 to i32, !dbg !191
  call void @llvm.dbg.value(metadata i32 %22, metadata !189, metadata !DIExpression()), !dbg !190
  %23 = zext i1 %20 to i32, !dbg !191
  call void @__VERIFIER_spin_end(i32 noundef %23), !dbg !191
  br i1 %21, label %18, label %.loopexit, !dbg !187, !llvm.loop !193

.loopexit:                                        ; preds = %18, %13
  ret void, !dbg !195
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @cna_unlock(%struct.cna_lock_t* noundef %0, %struct.cna_node* noundef %1) #0 !dbg !196 {
  call void @llvm.dbg.value(metadata %struct.cna_lock_t* %0, metadata !197, metadata !DIExpression()), !dbg !198
  call void @llvm.dbg.value(metadata %struct.cna_node* %1, metadata !199, metadata !DIExpression()), !dbg !198
  %3 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %1, i32 0, i32 3, !dbg !200
  %4 = bitcast %struct.cna_node** %3 to i64*, !dbg !202
  %5 = load atomic i64, i64* %4 acquire, align 8, !dbg !202
  %6 = inttoptr i64 %5 to %struct.cna_node*, !dbg !202
  %7 = icmp ne %struct.cna_node* %6, null, !dbg !202
  br i1 %7, label %44, label %8, !dbg !203

8:                                                ; preds = %2
  %9 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %1, i32 0, i32 0, !dbg !204
  %10 = load atomic i64, i64* %9 monotonic, align 8, !dbg !207
  %11 = icmp eq i64 %10, 1, !dbg !208
  br i1 %11, label %12, label %20, !dbg !209

12:                                               ; preds = %8
  call void @llvm.dbg.value(metadata %struct.cna_node* %1, metadata !210, metadata !DIExpression()), !dbg !212
  %13 = getelementptr inbounds %struct.cna_lock_t, %struct.cna_lock_t* %0, i32 0, i32 0, !dbg !213
  %14 = bitcast %struct.cna_node** %13 to i64*, !dbg !215
  %15 = ptrtoint %struct.cna_node* %1 to i64, !dbg !215
  %16 = cmpxchg i64* %14, i64 %15, i64 0 seq_cst seq_cst, align 8, !dbg !215
  %17 = extractvalue { i64, i1 } %16, 0, !dbg !215
  %18 = extractvalue { i64, i1 } %16, 1, !dbg !215
  %19 = zext i1 %18 to i8, !dbg !215
  br i1 %18, label %73, label %36, !dbg !216

20:                                               ; preds = %8
  %21 = load atomic i64, i64* %9 monotonic, align 8, !dbg !217
  %22 = inttoptr i64 %21 to %struct.cna_node*, !dbg !219
  call void @llvm.dbg.value(metadata %struct.cna_node* %22, metadata !220, metadata !DIExpression()), !dbg !221
  call void @llvm.dbg.value(metadata %struct.cna_node* %1, metadata !222, metadata !DIExpression()), !dbg !221
  %23 = getelementptr inbounds %struct.cna_lock_t, %struct.cna_lock_t* %0, i32 0, i32 0, !dbg !223
  %24 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %22, i32 0, i32 2, !dbg !225
  %25 = bitcast %struct.cna_node** %24 to i64*, !dbg !226
  %26 = load atomic i64, i64* %25 monotonic, align 8, !dbg !226
  %27 = inttoptr i64 %26 to %struct.cna_node*, !dbg !226
  %28 = bitcast %struct.cna_node** %23 to i64*, !dbg !227
  %29 = ptrtoint %struct.cna_node* %1 to i64, !dbg !227
  %30 = cmpxchg i64* %28, i64 %29, i64 %26 seq_cst seq_cst, align 8, !dbg !227
  %31 = extractvalue { i64, i1 } %30, 0, !dbg !227
  %32 = extractvalue { i64, i1 } %30, 1, !dbg !227
  %33 = zext i1 %32 to i8, !dbg !227
  br i1 %32, label %34, label %36, !dbg !228

34:                                               ; preds = %20
  %35 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %22, i32 0, i32 0, !dbg !229
  store atomic i64 1, i64* %35 release, align 8, !dbg !231
  br label %73, !dbg !232

36:                                               ; preds = %20, %12
  call void @__VERIFIER_loop_begin(), !dbg !233
  call void @llvm.dbg.value(metadata i32 0, metadata !235, metadata !DIExpression()), !dbg !236
  br label %37, !dbg !233

37:                                               ; preds = %37, %36
  call void @__VERIFIER_spin_start(), !dbg !237
  %38 = load atomic i64, i64* %4 monotonic, align 8, !dbg !237
  %39 = inttoptr i64 %38 to %struct.cna_node*, !dbg !237
  %40 = icmp eq %struct.cna_node* %39, null, !dbg !237
  %41 = zext i1 %40 to i32, !dbg !237
  call void @llvm.dbg.value(metadata i32 %41, metadata !235, metadata !DIExpression()), !dbg !236
  %42 = xor i1 %40, true, !dbg !237
  %43 = zext i1 %42 to i32, !dbg !237
  call void @__VERIFIER_spin_end(i32 noundef %43), !dbg !237
  br i1 %40, label %37, label %44, !dbg !233, !llvm.loop !239

44:                                               ; preds = %37, %2
  call void @llvm.dbg.value(metadata %struct.cna_node* null, metadata !241, metadata !DIExpression()), !dbg !198
  %45 = call zeroext i1 @keep_lock_local(), !dbg !242
  br i1 %45, label %46, label %53, !dbg !244

46:                                               ; preds = %44
  %47 = call %struct.cna_node* @find_successor(%struct.cna_node* noundef %1), !dbg !245
  call void @llvm.dbg.value(metadata %struct.cna_node* %47, metadata !241, metadata !DIExpression()), !dbg !198
  %48 = icmp ne %struct.cna_node* %47, null, !dbg !246
  br i1 %48, label %49, label %53, !dbg !247

49:                                               ; preds = %46
  %50 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %47, i32 0, i32 0, !dbg !248
  %51 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %1, i32 0, i32 0, !dbg !250
  %52 = load atomic i64, i64* %51 monotonic, align 8, !dbg !251
  store atomic i64 %52, i64* %50 release, align 8, !dbg !252
  br label %73, !dbg !253

53:                                               ; preds = %46, %44
  %54 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %1, i32 0, i32 0, !dbg !254
  %55 = load atomic i64, i64* %54 monotonic, align 8, !dbg !256
  %56 = icmp ugt i64 %55, 1, !dbg !257
  br i1 %56, label %57, label %69, !dbg !258

57:                                               ; preds = %53
  %58 = load atomic i64, i64* %54 monotonic, align 8, !dbg !259
  %59 = inttoptr i64 %58 to %struct.cna_node*, !dbg !261
  call void @llvm.dbg.value(metadata %struct.cna_node* %59, metadata !241, metadata !DIExpression()), !dbg !198
  %60 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %59, i32 0, i32 2, !dbg !262
  %61 = bitcast %struct.cna_node** %60 to i64*, !dbg !263
  %62 = load atomic i64, i64* %61 monotonic, align 8, !dbg !263
  %63 = inttoptr i64 %62 to %struct.cna_node*, !dbg !263
  %64 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %63, i32 0, i32 3, !dbg !264
  %65 = load atomic i64, i64* %4 monotonic, align 8, !dbg !265
  %66 = inttoptr i64 %65 to %struct.cna_node*, !dbg !265
  %67 = bitcast %struct.cna_node** %64 to i64*, !dbg !266
  store atomic i64 %65, i64* %67 monotonic, align 8, !dbg !266
  %68 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %59, i32 0, i32 0, !dbg !267
  store atomic i64 1, i64* %68 release, align 8, !dbg !268
  br label %73, !dbg !269

69:                                               ; preds = %53
  %70 = load atomic i64, i64* %4 monotonic, align 8, !dbg !270
  %71 = inttoptr i64 %70 to %struct.cna_node*, !dbg !270
  call void @llvm.dbg.value(metadata %struct.cna_node* %71, metadata !241, metadata !DIExpression()), !dbg !198
  %72 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %71, i32 0, i32 0, !dbg !272
  store atomic i64 1, i64* %72 release, align 8, !dbg !273
  br label %73

73:                                               ; preds = %57, %69, %12, %49, %34
  ret void, !dbg !274
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !275 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !276, metadata !DIExpression()), !dbg !280
  call void @llvm.dbg.value(metadata i32 0, metadata !281, metadata !DIExpression()), !dbg !283
  call void @llvm.dbg.value(metadata i64 0, metadata !281, metadata !DIExpression()), !dbg !283
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !284
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef null) #6, !dbg !286
  call void @llvm.dbg.value(metadata i64 1, metadata !281, metadata !DIExpression()), !dbg !283
  call void @llvm.dbg.value(metadata i64 1, metadata !281, metadata !DIExpression()), !dbg !283
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !284
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !286
  call void @llvm.dbg.value(metadata i64 2, metadata !281, metadata !DIExpression()), !dbg !283
  call void @llvm.dbg.value(metadata i64 2, metadata !281, metadata !DIExpression()), !dbg !283
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !284
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !286
  call void @llvm.dbg.value(metadata i64 3, metadata !281, metadata !DIExpression()), !dbg !283
  call void @llvm.dbg.value(metadata i64 3, metadata !281, metadata !DIExpression()), !dbg !283
  call void @llvm.dbg.value(metadata i32 0, metadata !287, metadata !DIExpression()), !dbg !289
  call void @llvm.dbg.value(metadata i64 0, metadata !287, metadata !DIExpression()), !dbg !289
  %8 = load i64, i64* %2, align 8, !dbg !290
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !292
  call void @llvm.dbg.value(metadata i64 1, metadata !287, metadata !DIExpression()), !dbg !289
  call void @llvm.dbg.value(metadata i64 1, metadata !287, metadata !DIExpression()), !dbg !289
  %10 = load i64, i64* %4, align 8, !dbg !290
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !292
  call void @llvm.dbg.value(metadata i64 2, metadata !287, metadata !DIExpression()), !dbg !289
  call void @llvm.dbg.value(metadata i64 2, metadata !287, metadata !DIExpression()), !dbg !289
  %12 = load i64, i64* %6, align 8, !dbg !290
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !292
  call void @llvm.dbg.value(metadata i64 3, metadata !287, metadata !DIExpression()), !dbg !289
  call void @llvm.dbg.value(metadata i64 3, metadata !287, metadata !DIExpression()), !dbg !289
  %14 = load i32, i32* @sum, align 4, !dbg !293
  %15 = icmp eq i32 %14, 3, !dbg !293
  br i1 %15, label %17, label %16, !dbg !296

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([45 x i8], [45 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !293
  unreachable, !dbg !293

17:                                               ; preds = %0
  ret i32 0, !dbg !297
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #4

declare i32 @pthread_join(i64 noundef, i8** noundef) #1

declare void @__VERIFIER_loop_begin() #1

declare void @__VERIFIER_spin_start() #1

declare void @__VERIFIER_spin_end(i32 noundef) #1

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!54, !55, !56, !57, !58, !59, !60}
!llvm.ident = !{!61}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "shared", scope: !2, file: !39, line: 13, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !36, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/cna.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "bef3aefedc92e84fd6c74ebd3d4c5c89")
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
!15 = !{!16, !23, !33, !35}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "cna_node_t", file: !18, line: 63, baseType: !19)
!18 = !DIFile(filename: "benchmarks/locks/cna.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "4fcf13899aa69f8f0573d110459f83d0")
!19 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "cna_node", file: !18, line: 58, size: 256, elements: !20)
!20 = !{!21, !26, !29, !32}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "spin", scope: !19, file: !18, line: 59, baseType: !22, size: 64)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !24, line: 90, baseType: !25)
!24 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!25 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "socket", scope: !19, file: !18, line: 60, baseType: !27, size: 32, offset: 64)
!27 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !28)
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "secTail", scope: !19, file: !18, line: 61, baseType: !30, size: 64, offset: 128)
!30 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !31)
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !19, file: !18, line: 62, baseType: !30, size: 64, offset: 192)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !24, line: 87, baseType: !34)
!34 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!36 = !{!0, !37, !40, !42, !49}
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !39, line: 14, type: !28, isLocal: false, isDefinition: true)
!39 = !DIFile(filename: "benchmarks/locks/cna.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "bef3aefedc92e84fd6c74ebd3d4c5c89")
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "tindex", scope: !2, file: !39, line: 9, type: !33, isLocal: false, isDefinition: true)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !39, line: 11, type: !44, isLocal: false, isDefinition: true)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "cna_lock_t", file: !18, line: 67, baseType: !45)
!45 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !18, line: 65, size: 64, elements: !46)
!46 = !{!47}
!47 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !45, file: !18, line: 66, baseType: !48, size: 64)
!48 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !16)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(name: "node", scope: !2, file: !39, line: 12, type: !51, isLocal: false, isDefinition: true)
!51 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 768, elements: !52)
!52 = !{!53}
!53 = !DISubrange(count: 3)
!54 = !{i32 7, !"Dwarf Version", i32 5}
!55 = !{i32 2, !"Debug Info Version", i32 3}
!56 = !{i32 1, !"wchar_size", i32 4}
!57 = !{i32 7, !"PIC Level", i32 2}
!58 = !{i32 7, !"PIE Level", i32 2}
!59 = !{i32 7, !"uwtable", i32 1}
!60 = !{i32 7, !"frame-pointer", i32 2}
!61 = !{!"Ubuntu clang version 14.0.6"}
!62 = distinct !DISubprogram(name: "current_numa_node", scope: !18, file: !18, line: 50, type: !63, scopeLine: 50, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!63 = !DISubroutineType(types: !64)
!64 = !{!28}
!65 = !{}
!66 = !DILocation(line: 51, column: 12, scope: !62)
!67 = !DILocation(line: 51, column: 5, scope: !62)
!68 = distinct !DISubprogram(name: "keep_lock_local", scope: !18, file: !18, line: 54, type: !69, scopeLine: 54, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!69 = !DISubroutineType(types: !70)
!70 = !{!71}
!71 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!72 = !DILocation(line: 55, column: 12, scope: !68)
!73 = !DILocation(line: 55, column: 5, scope: !68)
!74 = distinct !DISubprogram(name: "find_successor", scope: !18, file: !18, line: 69, type: !75, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!75 = !DISubroutineType(types: !76)
!76 = !{!16, !16}
!77 = !DILocalVariable(name: "me", arg: 1, scope: !74, file: !18, line: 69, type: !16)
!78 = !DILocation(line: 0, scope: !74)
!79 = !DILocation(line: 70, column: 50, scope: !74)
!80 = !DILocation(line: 70, column: 24, scope: !74)
!81 = !DILocalVariable(name: "next", scope: !74, file: !18, line: 70, type: !16)
!82 = !DILocation(line: 71, column: 46, scope: !74)
!83 = !DILocation(line: 71, column: 20, scope: !74)
!84 = !DILocalVariable(name: "mySocket", scope: !74, file: !18, line: 71, type: !28)
!85 = !DILocation(line: 73, column: 18, scope: !86)
!86 = distinct !DILexicalBlock(scope: !74, file: !18, line: 73, column: 9)
!87 = !DILocation(line: 73, column: 9, scope: !74)
!88 = !DILocation(line: 73, column: 36, scope: !86)
!89 = !DILocation(line: 73, column: 25, scope: !86)
!90 = !DILocation(line: 74, column: 37, scope: !91)
!91 = distinct !DILexicalBlock(scope: !74, file: !18, line: 74, column: 9)
!92 = !DILocation(line: 74, column: 9, scope: !91)
!93 = !DILocation(line: 74, column: 67, scope: !91)
!94 = !DILocation(line: 74, column: 9, scope: !74)
!95 = !DILocalVariable(name: "secHead", scope: !74, file: !18, line: 76, type: !16)
!96 = !DILocalVariable(name: "secTail", scope: !74, file: !18, line: 77, type: !16)
!97 = !DILocation(line: 78, column: 51, scope: !74)
!98 = !DILocation(line: 78, column: 23, scope: !74)
!99 = !DILocalVariable(name: "cur", scope: !74, file: !18, line: 78, type: !16)
!100 = !DILocation(line: 80, column: 5, scope: !74)
!101 = !DILocation(line: 81, column: 39, scope: !102)
!102 = distinct !DILexicalBlock(scope: !103, file: !18, line: 81, column: 12)
!103 = distinct !DILexicalBlock(scope: !74, file: !18, line: 80, column: 16)
!104 = !DILocation(line: 81, column: 12, scope: !102)
!105 = !DILocation(line: 81, column: 69, scope: !102)
!106 = !DILocation(line: 81, column: 12, scope: !103)
!107 = !DILocation(line: 82, column: 42, scope: !108)
!108 = distinct !DILexicalBlock(scope: !109, file: !18, line: 82, column: 16)
!109 = distinct !DILexicalBlock(scope: !102, file: !18, line: 81, column: 82)
!110 = !DILocation(line: 82, column: 16, scope: !108)
!111 = !DILocation(line: 82, column: 70, scope: !108)
!112 = !DILocation(line: 82, column: 16, scope: !109)
!113 = !DILocation(line: 83, column: 51, scope: !114)
!114 = distinct !DILexicalBlock(scope: !108, file: !18, line: 82, column: 75)
!115 = !DILocation(line: 83, column: 37, scope: !114)
!116 = !DILocalVariable(name: "_spin", scope: !114, file: !18, line: 83, type: !16)
!117 = !DILocation(line: 0, scope: !114)
!118 = !DILocation(line: 84, column: 69, scope: !114)
!119 = !DILocation(line: 84, column: 40, scope: !114)
!120 = !DILocalVariable(name: "_secTail", scope: !114, file: !18, line: 84, type: !16)
!121 = !DILocation(line: 85, column: 50, scope: !114)
!122 = !DILocation(line: 85, column: 17, scope: !114)
!123 = !DILocation(line: 86, column: 13, scope: !114)
!124 = !DILocation(line: 87, column: 17, scope: !125)
!125 = distinct !DILexicalBlock(scope: !108, file: !18, line: 86, column: 20)
!126 = !DILocation(line: 89, column: 45, scope: !109)
!127 = !DILocation(line: 89, column: 13, scope: !109)
!128 = !DILocation(line: 90, column: 47, scope: !109)
!129 = !DILocation(line: 90, column: 33, scope: !109)
!130 = !DILocalVariable(name: "_spin", scope: !109, file: !18, line: 90, type: !16)
!131 = !DILocation(line: 0, scope: !109)
!132 = !DILocation(line: 91, column: 43, scope: !109)
!133 = !DILocation(line: 91, column: 13, scope: !109)
!134 = !DILocation(line: 92, column: 13, scope: !109)
!135 = !DILocation(line: 95, column: 42, scope: !103)
!136 = !DILocation(line: 95, column: 15, scope: !103)
!137 = distinct !{!137, !100, !138, !139}
!138 = !DILocation(line: 96, column: 5, scope: !74)
!139 = !{!"llvm.loop.mustprogress"}
!140 = !DILocation(line: 98, column: 1, scope: !74)
!141 = distinct !DISubprogram(name: "thread_n", scope: !39, file: !39, line: 16, type: !142, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!142 = !DISubroutineType(types: !143)
!143 = !{!35, !35}
!144 = !DILocalVariable(name: "arg", arg: 1, scope: !141, file: !39, line: 16, type: !35)
!145 = !DILocation(line: 0, scope: !141)
!146 = !DILocation(line: 18, column: 15, scope: !141)
!147 = !DILocation(line: 18, column: 12, scope: !141)
!148 = !DILocation(line: 19, column: 22, scope: !141)
!149 = !DILocation(line: 19, column: 5, scope: !141)
!150 = !DILocation(line: 20, column: 14, scope: !141)
!151 = !DILocation(line: 20, column: 12, scope: !141)
!152 = !DILocalVariable(name: "r", scope: !141, file: !39, line: 21, type: !28)
!153 = !DILocation(line: 22, column: 5, scope: !154)
!154 = distinct !DILexicalBlock(scope: !155, file: !39, line: 22, column: 5)
!155 = distinct !DILexicalBlock(scope: !141, file: !39, line: 22, column: 5)
!156 = !DILocation(line: 22, column: 5, scope: !155)
!157 = !DILocation(line: 23, column: 8, scope: !141)
!158 = !DILocation(line: 24, column: 24, scope: !141)
!159 = !DILocation(line: 24, column: 5, scope: !141)
!160 = !DILocation(line: 25, column: 5, scope: !141)
!161 = distinct !DISubprogram(name: "cna_lock", scope: !18, file: !18, line: 100, type: !162, scopeLine: 101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !65)
!162 = !DISubroutineType(types: !163)
!163 = !{null, !164, !16}
!164 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!165 = !DILocalVariable(name: "lock", arg: 1, scope: !161, file: !18, line: 100, type: !164)
!166 = !DILocation(line: 0, scope: !161)
!167 = !DILocalVariable(name: "me", arg: 2, scope: !161, file: !18, line: 100, type: !16)
!168 = !DILocation(line: 102, column: 32, scope: !161)
!169 = !DILocation(line: 102, column: 5, scope: !161)
!170 = !DILocation(line: 103, column: 32, scope: !161)
!171 = !DILocation(line: 103, column: 5, scope: !161)
!172 = !DILocation(line: 104, column: 32, scope: !161)
!173 = !DILocation(line: 104, column: 5, scope: !161)
!174 = !DILocation(line: 107, column: 56, scope: !161)
!175 = !DILocation(line: 107, column: 24, scope: !161)
!176 = !DILocalVariable(name: "tail", scope: !161, file: !18, line: 107, type: !16)
!177 = !DILocation(line: 110, column: 9, scope: !178)
!178 = distinct !DILexicalBlock(scope: !161, file: !18, line: 110, column: 8)
!179 = !DILocation(line: 110, column: 8, scope: !161)
!180 = !DILocation(line: 111, column: 9, scope: !181)
!181 = distinct !DILexicalBlock(scope: !178, file: !18, line: 110, column: 15)
!182 = !DILocation(line: 112, column: 9, scope: !181)
!183 = !DILocation(line: 116, column: 40, scope: !161)
!184 = !DILocation(line: 116, column: 5, scope: !161)
!185 = !DILocation(line: 117, column: 34, scope: !161)
!186 = !DILocation(line: 117, column: 5, scope: !161)
!187 = !DILocation(line: 120, column: 5, scope: !188)
!188 = distinct !DILexicalBlock(scope: !161, file: !18, line: 120, column: 5)
!189 = !DILocalVariable(name: "tmp", scope: !188, file: !18, line: 120, type: !28)
!190 = !DILocation(line: 0, scope: !188)
!191 = !DILocation(line: 120, column: 5, scope: !192)
!192 = distinct !DILexicalBlock(scope: !188, file: !18, line: 120, column: 5)
!193 = distinct !{!193, !187, !194, !139}
!194 = !DILocation(line: 122, column: 5, scope: !188)
!195 = !DILocation(line: 123, column: 1, scope: !161)
!196 = distinct !DISubprogram(name: "cna_unlock", scope: !18, file: !18, line: 125, type: !162, scopeLine: 126, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !65)
!197 = !DILocalVariable(name: "lock", arg: 1, scope: !196, file: !18, line: 125, type: !164)
!198 = !DILocation(line: 0, scope: !196)
!199 = !DILocalVariable(name: "me", arg: 2, scope: !196, file: !18, line: 125, type: !16)
!200 = !DILocation(line: 128, column: 35, scope: !201)
!201 = distinct !DILexicalBlock(scope: !196, file: !18, line: 128, column: 8)
!202 = !DILocation(line: 128, column: 9, scope: !201)
!203 = !DILocation(line: 128, column: 8, scope: !196)
!204 = !DILocation(line: 130, column: 38, scope: !205)
!205 = distinct !DILexicalBlock(scope: !206, file: !18, line: 130, column: 12)
!206 = distinct !DILexicalBlock(scope: !201, file: !18, line: 128, column: 60)
!207 = !DILocation(line: 130, column: 12, scope: !205)
!208 = !DILocation(line: 130, column: 66, scope: !205)
!209 = !DILocation(line: 130, column: 12, scope: !206)
!210 = !DILocalVariable(name: "local_me", scope: !211, file: !18, line: 132, type: !16)
!211 = distinct !DILexicalBlock(scope: !205, file: !18, line: 130, column: 72)
!212 = !DILocation(line: 0, scope: !211)
!213 = !DILocation(line: 133, column: 63, scope: !214)
!214 = distinct !DILexicalBlock(scope: !211, file: !18, line: 133, column: 16)
!215 = !DILocation(line: 133, column: 16, scope: !214)
!216 = !DILocation(line: 133, column: 16, scope: !211)
!217 = !DILocation(line: 138, column: 50, scope: !218)
!218 = distinct !DILexicalBlock(scope: !205, file: !18, line: 136, column: 16)
!219 = !DILocation(line: 138, column: 35, scope: !218)
!220 = !DILocalVariable(name: "secHead", scope: !218, file: !18, line: 138, type: !16)
!221 = !DILocation(line: 0, scope: !218)
!222 = !DILocalVariable(name: "local_me", scope: !218, file: !18, line: 139, type: !16)
!223 = !DILocation(line: 140, column: 63, scope: !224)
!224 = distinct !DILexicalBlock(scope: !218, file: !18, line: 140, column: 16)
!225 = !DILocation(line: 141, column: 48, scope: !224)
!226 = !DILocation(line: 141, column: 17, scope: !224)
!227 = !DILocation(line: 140, column: 16, scope: !224)
!228 = !DILocation(line: 140, column: 16, scope: !218)
!229 = !DILocation(line: 144, column: 49, scope: !230)
!230 = distinct !DILexicalBlock(scope: !224, file: !18, line: 142, column: 62)
!231 = !DILocation(line: 144, column: 17, scope: !230)
!232 = !DILocation(line: 145, column: 17, scope: !230)
!233 = !DILocation(line: 149, column: 9, scope: !234)
!234 = distinct !DILexicalBlock(scope: !206, file: !18, line: 149, column: 9)
!235 = !DILocalVariable(name: "tmp", scope: !234, file: !18, line: 149, type: !28)
!236 = !DILocation(line: 0, scope: !234)
!237 = !DILocation(line: 149, column: 9, scope: !238)
!238 = distinct !DILexicalBlock(scope: !234, file: !18, line: 149, column: 9)
!239 = distinct !{!239, !233, !240, !139}
!240 = !DILocation(line: 151, column: 9, scope: !234)
!241 = !DILocalVariable(name: "succ", scope: !196, file: !18, line: 154, type: !16)
!242 = !DILocation(line: 155, column: 9, scope: !243)
!243 = distinct !DILexicalBlock(scope: !196, file: !18, line: 155, column: 9)
!244 = !DILocation(line: 155, column: 27, scope: !243)
!245 = !DILocation(line: 155, column: 38, scope: !243)
!246 = !DILocation(line: 155, column: 36, scope: !243)
!247 = !DILocation(line: 155, column: 9, scope: !196)
!248 = !DILocation(line: 156, column: 38, scope: !249)
!249 = distinct !DILexicalBlock(scope: !243, file: !18, line: 155, column: 59)
!250 = !DILocation(line: 157, column: 39, scope: !249)
!251 = !DILocation(line: 157, column: 13, scope: !249)
!252 = !DILocation(line: 156, column: 9, scope: !249)
!253 = !DILocation(line: 159, column: 5, scope: !249)
!254 = !DILocation(line: 159, column: 41, scope: !255)
!255 = distinct !DILexicalBlock(scope: !243, file: !18, line: 159, column: 15)
!256 = !DILocation(line: 159, column: 15, scope: !255)
!257 = !DILocation(line: 159, column: 69, scope: !255)
!258 = !DILocation(line: 159, column: 15, scope: !243)
!259 = !DILocation(line: 160, column: 31, scope: !260)
!260 = distinct !DILexicalBlock(scope: !255, file: !18, line: 159, column: 74)
!261 = !DILocation(line: 160, column: 16, scope: !260)
!262 = !DILocation(line: 162, column: 57, scope: !260)
!263 = !DILocation(line: 162, column: 29, scope: !260)
!264 = !DILocation(line: 162, column: 90, scope: !260)
!265 = !DILocation(line: 163, column: 13, scope: !260)
!266 = !DILocation(line: 161, column: 9, scope: !260)
!267 = !DILocation(line: 165, column: 38, scope: !260)
!268 = !DILocation(line: 165, column: 9, scope: !260)
!269 = !DILocation(line: 166, column: 5, scope: !260)
!270 = !DILocation(line: 167, column: 30, scope: !271)
!271 = distinct !DILexicalBlock(scope: !255, file: !18, line: 166, column: 12)
!272 = !DILocation(line: 168, column: 38, scope: !271)
!273 = !DILocation(line: 168, column: 9, scope: !271)
!274 = !DILocation(line: 170, column: 1, scope: !196)
!275 = distinct !DISubprogram(name: "main", scope: !39, file: !39, line: 28, type: !63, scopeLine: 29, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!276 = !DILocalVariable(name: "t", scope: !275, file: !39, line: 30, type: !277)
!277 = !DICompositeType(tag: DW_TAG_array_type, baseType: !278, size: 192, elements: !52)
!278 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !279, line: 27, baseType: !25)
!279 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!280 = !DILocation(line: 30, column: 15, scope: !275)
!281 = !DILocalVariable(name: "i", scope: !282, file: !39, line: 32, type: !28)
!282 = distinct !DILexicalBlock(scope: !275, file: !39, line: 32, column: 5)
!283 = !DILocation(line: 0, scope: !282)
!284 = !DILocation(line: 33, column: 25, scope: !285)
!285 = distinct !DILexicalBlock(scope: !282, file: !39, line: 32, column: 5)
!286 = !DILocation(line: 33, column: 9, scope: !285)
!287 = !DILocalVariable(name: "i", scope: !288, file: !39, line: 35, type: !28)
!288 = distinct !DILexicalBlock(scope: !275, file: !39, line: 35, column: 5)
!289 = !DILocation(line: 0, scope: !288)
!290 = !DILocation(line: 36, column: 22, scope: !291)
!291 = distinct !DILexicalBlock(scope: !288, file: !39, line: 35, column: 5)
!292 = !DILocation(line: 36, column: 9, scope: !291)
!293 = !DILocation(line: 38, column: 5, scope: !294)
!294 = distinct !DILexicalBlock(scope: !295, file: !39, line: 38, column: 5)
!295 = distinct !DILexicalBlock(scope: !275, file: !39, line: 38, column: 5)
!296 = !DILocation(line: 38, column: 5, scope: !295)
!297 = !DILocation(line: 40, column: 5, scope: !275)
