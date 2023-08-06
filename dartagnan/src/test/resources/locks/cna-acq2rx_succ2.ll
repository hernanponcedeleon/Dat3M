; ModuleID = '/home/ponce/git/Dat3M/output/cna.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/cna.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.cna_lock_t = type { %struct.cna_node* }
%struct.cna_node = type { i64, i32, %struct.cna_node*, %struct.cna_node* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@shared = dso_local global i32 0, align 4, !dbg !0
@sum = dso_local global i32 0, align 4, !dbg !39
@tindex = dso_local thread_local global i64 0, align 8, !dbg !42
@lock = dso_local global %struct.cna_lock_t zeroinitializer, align 8, !dbg !44
@node = dso_local global [3 x %struct.cna_node] zeroinitializer, align 16, !dbg !51
@.str = private unnamed_addr constant [12 x i8] c"r == tindex\00", align 1
@.str.1 = private unnamed_addr constant [45 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/cna.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @current_numa_node() #0 !dbg !64 {
  %1 = call i32 @__VERIFIER_nondet_uint(), !dbg !68
  ret i32 %1, !dbg !69
}

declare i32 @__VERIFIER_nondet_uint() #1

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @keep_lock_local() #0 !dbg !70 {
  %1 = call zeroext i1 @__VERIFIER_nondet_bool(), !dbg !74
  ret i1 %1, !dbg !75
}

declare zeroext i1 @__VERIFIER_nondet_bool() #1

; Function Attrs: noinline nounwind uwtable
define dso_local %struct.cna_node* @find_successor(%struct.cna_node* noundef %0) #0 !dbg !76 {
  call void @llvm.dbg.value(metadata %struct.cna_node* %0, metadata !79, metadata !DIExpression()), !dbg !80
  %2 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %0, i32 0, i32 3, !dbg !81
  %3 = bitcast %struct.cna_node** %2 to i64*, !dbg !82
  %4 = load atomic i64, i64* %3 monotonic, align 8, !dbg !82
  %5 = inttoptr i64 %4 to %struct.cna_node*, !dbg !82
  call void @llvm.dbg.value(metadata %struct.cna_node* %5, metadata !83, metadata !DIExpression()), !dbg !80
  %6 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %0, i32 0, i32 1, !dbg !84
  %7 = load atomic i32, i32* %6 monotonic, align 8, !dbg !85
  call void @llvm.dbg.value(metadata i32 %7, metadata !86, metadata !DIExpression()), !dbg !80
  %8 = icmp eq i32 %7, -1, !dbg !87
  br i1 %8, label %9, label %11, !dbg !89

9:                                                ; preds = %1
  %10 = call i32 @current_numa_node(), !dbg !90
  call void @llvm.dbg.value(metadata i32 %10, metadata !86, metadata !DIExpression()), !dbg !80
  br label %11, !dbg !91

11:                                               ; preds = %9, %1
  %.03 = phi i32 [ %10, %9 ], [ %7, %1 ], !dbg !80
  call void @llvm.dbg.value(metadata i32 %.03, metadata !86, metadata !DIExpression()), !dbg !80
  %12 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %5, i32 0, i32 1, !dbg !92
  %13 = load atomic i32, i32* %12 monotonic, align 8, !dbg !94
  %14 = icmp eq i32 %13, %.03, !dbg !95
  br i1 %14, label %53, label %15, !dbg !96

15:                                               ; preds = %11
  call void @llvm.dbg.value(metadata %struct.cna_node* %5, metadata !97, metadata !DIExpression()), !dbg !80
  call void @llvm.dbg.value(metadata %struct.cna_node* %5, metadata !98, metadata !DIExpression()), !dbg !80
  %16 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %5, i32 0, i32 3, !dbg !99
  %17 = bitcast %struct.cna_node** %16 to i64*, !dbg !100
  %18 = load atomic i64, i64* %17 acquire, align 8, !dbg !100
  %19 = inttoptr i64 %18 to %struct.cna_node*, !dbg !100
  call void @llvm.dbg.value(metadata %struct.cna_node* %19, metadata !101, metadata !DIExpression()), !dbg !80
  br label %20, !dbg !102

20:                                               ; preds = %48, %15
  %.02 = phi %struct.cna_node* [ %5, %15 ], [ %.01, %48 ], !dbg !80
  %.01 = phi %struct.cna_node* [ %19, %15 ], [ %52, %48 ], !dbg !80
  call void @llvm.dbg.value(metadata %struct.cna_node* %.01, metadata !101, metadata !DIExpression()), !dbg !80
  call void @llvm.dbg.value(metadata %struct.cna_node* %.02, metadata !98, metadata !DIExpression()), !dbg !80
  %21 = icmp ne %struct.cna_node* %.01, null, !dbg !102
  br i1 %21, label %22, label %53, !dbg !102

22:                                               ; preds = %20
  %23 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %.01, i32 0, i32 1, !dbg !103
  %24 = load atomic i32, i32* %23 monotonic, align 8, !dbg !106
  %25 = icmp eq i32 %24, %.03, !dbg !107
  br i1 %25, label %26, label %48, !dbg !108

26:                                               ; preds = %22
  %27 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %0, i32 0, i32 0, !dbg !109
  %28 = load atomic i64, i64* %27 monotonic, align 8, !dbg !112
  %29 = icmp ugt i64 %28, 1, !dbg !113
  br i1 %29, label %30, label %39, !dbg !114

30:                                               ; preds = %26
  %31 = load atomic i64, i64* %27 monotonic, align 8, !dbg !115
  %32 = inttoptr i64 %31 to %struct.cna_node*, !dbg !117
  call void @llvm.dbg.value(metadata %struct.cna_node* %32, metadata !118, metadata !DIExpression()), !dbg !119
  %33 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %32, i32 0, i32 2, !dbg !120
  %34 = bitcast %struct.cna_node** %33 to i64*, !dbg !121
  %35 = load atomic i64, i64* %34 monotonic, align 8, !dbg !121
  %36 = inttoptr i64 %35 to %struct.cna_node*, !dbg !121
  call void @llvm.dbg.value(metadata %struct.cna_node* %36, metadata !122, metadata !DIExpression()), !dbg !119
  %37 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %36, i32 0, i32 3, !dbg !123
  %38 = bitcast %struct.cna_node** %37 to i64*, !dbg !124
  store atomic i64 %4, i64* %38 monotonic, align 8, !dbg !124
  br label %40, !dbg !125

39:                                               ; preds = %26
  store atomic i64 %4, i64* %27 monotonic, align 8, !dbg !126
  br label %40

40:                                               ; preds = %39, %30
  %41 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %.02, i32 0, i32 3, !dbg !128
  %42 = bitcast %struct.cna_node** %41 to i64*, !dbg !129
  store atomic i64 0, i64* %42 monotonic, align 8, !dbg !129
  %43 = load atomic i64, i64* %27 monotonic, align 8, !dbg !130
  %44 = inttoptr i64 %43 to %struct.cna_node*, !dbg !131
  call void @llvm.dbg.value(metadata %struct.cna_node* %44, metadata !132, metadata !DIExpression()), !dbg !133
  %45 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %44, i32 0, i32 2, !dbg !134
  %46 = bitcast %struct.cna_node** %45 to i64*, !dbg !135
  %47 = ptrtoint %struct.cna_node* %.02 to i64, !dbg !135
  store atomic i64 %47, i64* %46 monotonic, align 8, !dbg !135
  br label %53, !dbg !136

48:                                               ; preds = %22
  call void @llvm.dbg.value(metadata %struct.cna_node* %.01, metadata !98, metadata !DIExpression()), !dbg !80
  %49 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %.01, i32 0, i32 3, !dbg !137
  %50 = bitcast %struct.cna_node** %49 to i64*, !dbg !138
  %51 = load atomic i64, i64* %50 monotonic, align 8, !dbg !138
  %52 = inttoptr i64 %51 to %struct.cna_node*, !dbg !138
  call void @llvm.dbg.value(metadata %struct.cna_node* %52, metadata !101, metadata !DIExpression()), !dbg !80
  br label %20, !dbg !102, !llvm.loop !139

53:                                               ; preds = %20, %11, %40
  %.0 = phi %struct.cna_node* [ %.01, %40 ], [ %5, %11 ], [ null, %20 ], !dbg !80
  ret %struct.cna_node* %.0, !dbg !142
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !143 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !146, metadata !DIExpression()), !dbg !147
  %2 = ptrtoint i8* %0 to i64, !dbg !148
  store i64 %2, i64* @tindex, align 8, !dbg !149
  %3 = getelementptr inbounds [3 x %struct.cna_node], [3 x %struct.cna_node]* @node, i64 0, i64 %2, !dbg !150
  call void @cna_lock(%struct.cna_lock_t* noundef @lock, %struct.cna_node* noundef %3), !dbg !151
  %4 = load i64, i64* @tindex, align 8, !dbg !152
  %5 = trunc i64 %4 to i32, !dbg !152
  store i32 %5, i32* @shared, align 4, !dbg !153
  call void @llvm.dbg.value(metadata i32 %5, metadata !154, metadata !DIExpression()), !dbg !147
  %6 = sext i32 %5 to i64, !dbg !155
  %7 = icmp eq i64 %6, %4, !dbg !155
  br i1 %7, label %9, label %8, !dbg !158

8:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([45 x i8], [45 x i8]* @.str.1, i64 0, i64 0), i32 noundef 22, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #5, !dbg !155
  unreachable, !dbg !155

9:                                                ; preds = %1
  %10 = load i32, i32* @sum, align 4, !dbg !159
  %11 = add nsw i32 %10, 1, !dbg !159
  store i32 %11, i32* @sum, align 4, !dbg !159
  %12 = getelementptr inbounds [3 x %struct.cna_node], [3 x %struct.cna_node]* @node, i64 0, i64 %4, !dbg !160
  call void @cna_unlock(%struct.cna_lock_t* noundef @lock, %struct.cna_node* noundef %12), !dbg !161
  ret i8* null, !dbg !162
}

; Function Attrs: noinline nounwind uwtable
define internal void @cna_lock(%struct.cna_lock_t* noundef %0, %struct.cna_node* noundef %1) #0 !dbg !163 {
  call void @llvm.dbg.value(metadata %struct.cna_lock_t* %0, metadata !167, metadata !DIExpression()), !dbg !168
  call void @llvm.dbg.value(metadata %struct.cna_node* %1, metadata !169, metadata !DIExpression()), !dbg !168
  %3 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %1, i32 0, i32 3, !dbg !170
  %4 = bitcast %struct.cna_node** %3 to i64*, !dbg !171
  store atomic i64 0, i64* %4 monotonic, align 8, !dbg !171
  %5 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %1, i32 0, i32 1, !dbg !172
  store atomic i32 -1, i32* %5 monotonic, align 8, !dbg !173
  %6 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %1, i32 0, i32 0, !dbg !174
  store atomic i64 0, i64* %6 monotonic, align 8, !dbg !175
  %7 = getelementptr inbounds %struct.cna_lock_t, %struct.cna_lock_t* %0, i32 0, i32 0, !dbg !176
  %8 = bitcast %struct.cna_node** %7 to i64*, !dbg !177
  %9 = ptrtoint %struct.cna_node* %1 to i64, !dbg !177
  %10 = atomicrmw xchg i64* %8, i64 %9 seq_cst, align 8, !dbg !177
  %11 = inttoptr i64 %10 to %struct.cna_node*, !dbg !177
  call void @llvm.dbg.value(metadata %struct.cna_node* %11, metadata !178, metadata !DIExpression()), !dbg !168
  %12 = icmp ne %struct.cna_node* %11, null, !dbg !179
  br i1 %12, label %14, label %13, !dbg !181

13:                                               ; preds = %2
  store atomic i64 1, i64* %6 monotonic, align 8, !dbg !182
  br label %.loopexit, !dbg !184

14:                                               ; preds = %2
  %15 = call i32 @current_numa_node(), !dbg !185
  store atomic i32 %15, i32* %5 monotonic, align 8, !dbg !186
  %16 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %11, i32 0, i32 3, !dbg !187
  %17 = bitcast %struct.cna_node** %16 to i64*, !dbg !188
  store atomic i64 %9, i64* %17 release, align 8, !dbg !188
  call void @__VERIFIER_loop_begin(), !dbg !189
  call void @llvm.dbg.value(metadata i32 0, metadata !191, metadata !DIExpression()), !dbg !192
  br label %18, !dbg !189

18:                                               ; preds = %18, %14
  call void @__VERIFIER_spin_start(), !dbg !193
  %19 = load atomic i64, i64* %6 acquire, align 8, !dbg !193
  %20 = icmp ne i64 %19, 0, !dbg !193
  %21 = xor i1 %20, true, !dbg !193
  %22 = zext i1 %21 to i32, !dbg !193
  call void @llvm.dbg.value(metadata i32 %22, metadata !191, metadata !DIExpression()), !dbg !192
  %23 = zext i1 %20 to i32, !dbg !193
  call void @__VERIFIER_spin_end(i32 noundef %23), !dbg !193
  br i1 %21, label %18, label %.loopexit, !dbg !189, !llvm.loop !195

.loopexit:                                        ; preds = %18, %13
  ret void, !dbg !197
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @cna_unlock(%struct.cna_lock_t* noundef %0, %struct.cna_node* noundef %1) #0 !dbg !198 {
  call void @llvm.dbg.value(metadata %struct.cna_lock_t* %0, metadata !199, metadata !DIExpression()), !dbg !200
  call void @llvm.dbg.value(metadata %struct.cna_node* %1, metadata !201, metadata !DIExpression()), !dbg !200
  %3 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %1, i32 0, i32 3, !dbg !202
  %4 = bitcast %struct.cna_node** %3 to i64*, !dbg !204
  %5 = load atomic i64, i64* %4 acquire, align 8, !dbg !204
  %6 = inttoptr i64 %5 to %struct.cna_node*, !dbg !204
  %7 = icmp ne %struct.cna_node* %6, null, !dbg !204
  br i1 %7, label %44, label %8, !dbg !205

8:                                                ; preds = %2
  %9 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %1, i32 0, i32 0, !dbg !206
  %10 = load atomic i64, i64* %9 monotonic, align 8, !dbg !209
  %11 = icmp eq i64 %10, 1, !dbg !210
  br i1 %11, label %12, label %20, !dbg !211

12:                                               ; preds = %8
  call void @llvm.dbg.value(metadata %struct.cna_node* %1, metadata !212, metadata !DIExpression()), !dbg !214
  %13 = getelementptr inbounds %struct.cna_lock_t, %struct.cna_lock_t* %0, i32 0, i32 0, !dbg !215
  %14 = bitcast %struct.cna_node** %13 to i64*, !dbg !217
  %15 = ptrtoint %struct.cna_node* %1 to i64, !dbg !217
  %16 = cmpxchg i64* %14, i64 %15, i64 0 seq_cst seq_cst, align 8, !dbg !217
  %17 = extractvalue { i64, i1 } %16, 0, !dbg !217
  %18 = extractvalue { i64, i1 } %16, 1, !dbg !217
  %19 = zext i1 %18 to i8, !dbg !217
  br i1 %18, label %73, label %36, !dbg !218

20:                                               ; preds = %8
  %21 = load atomic i64, i64* %9 monotonic, align 8, !dbg !219
  %22 = inttoptr i64 %21 to %struct.cna_node*, !dbg !221
  call void @llvm.dbg.value(metadata %struct.cna_node* %22, metadata !222, metadata !DIExpression()), !dbg !223
  call void @llvm.dbg.value(metadata %struct.cna_node* %1, metadata !224, metadata !DIExpression()), !dbg !223
  %23 = getelementptr inbounds %struct.cna_lock_t, %struct.cna_lock_t* %0, i32 0, i32 0, !dbg !225
  %24 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %22, i32 0, i32 2, !dbg !227
  %25 = bitcast %struct.cna_node** %24 to i64*, !dbg !228
  %26 = load atomic i64, i64* %25 monotonic, align 8, !dbg !228
  %27 = inttoptr i64 %26 to %struct.cna_node*, !dbg !228
  %28 = bitcast %struct.cna_node** %23 to i64*, !dbg !229
  %29 = ptrtoint %struct.cna_node* %1 to i64, !dbg !229
  %30 = cmpxchg i64* %28, i64 %29, i64 %26 seq_cst seq_cst, align 8, !dbg !229
  %31 = extractvalue { i64, i1 } %30, 0, !dbg !229
  %32 = extractvalue { i64, i1 } %30, 1, !dbg !229
  %33 = zext i1 %32 to i8, !dbg !229
  br i1 %32, label %34, label %36, !dbg !230

34:                                               ; preds = %20
  %35 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %22, i32 0, i32 0, !dbg !231
  store atomic i64 1, i64* %35 release, align 8, !dbg !233
  br label %73, !dbg !234

36:                                               ; preds = %20, %12
  call void @__VERIFIER_loop_begin(), !dbg !235
  call void @llvm.dbg.value(metadata i32 0, metadata !237, metadata !DIExpression()), !dbg !238
  br label %37, !dbg !235

37:                                               ; preds = %37, %36
  call void @__VERIFIER_spin_start(), !dbg !239
  %38 = load atomic i64, i64* %4 monotonic, align 8, !dbg !239
  %39 = inttoptr i64 %38 to %struct.cna_node*, !dbg !239
  %40 = icmp eq %struct.cna_node* %39, null, !dbg !239
  %41 = zext i1 %40 to i32, !dbg !239
  call void @llvm.dbg.value(metadata i32 %41, metadata !237, metadata !DIExpression()), !dbg !238
  %42 = xor i1 %40, true, !dbg !239
  %43 = zext i1 %42 to i32, !dbg !239
  call void @__VERIFIER_spin_end(i32 noundef %43), !dbg !239
  br i1 %40, label %37, label %44, !dbg !235, !llvm.loop !241

44:                                               ; preds = %37, %2
  call void @llvm.dbg.value(metadata %struct.cna_node* null, metadata !243, metadata !DIExpression()), !dbg !200
  %45 = call zeroext i1 @keep_lock_local(), !dbg !244
  br i1 %45, label %46, label %53, !dbg !246

46:                                               ; preds = %44
  %47 = call %struct.cna_node* @find_successor(%struct.cna_node* noundef %1), !dbg !247
  call void @llvm.dbg.value(metadata %struct.cna_node* %47, metadata !243, metadata !DIExpression()), !dbg !200
  %48 = icmp ne %struct.cna_node* %47, null, !dbg !248
  br i1 %48, label %49, label %53, !dbg !249

49:                                               ; preds = %46
  %50 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %47, i32 0, i32 0, !dbg !250
  %51 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %1, i32 0, i32 0, !dbg !252
  %52 = load atomic i64, i64* %51 monotonic, align 8, !dbg !253
  store atomic i64 %52, i64* %50 release, align 8, !dbg !254
  br label %73, !dbg !255

53:                                               ; preds = %46, %44
  %54 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %1, i32 0, i32 0, !dbg !256
  %55 = load atomic i64, i64* %54 monotonic, align 8, !dbg !258
  %56 = icmp ugt i64 %55, 1, !dbg !259
  br i1 %56, label %57, label %69, !dbg !260

57:                                               ; preds = %53
  %58 = load atomic i64, i64* %54 monotonic, align 8, !dbg !261
  %59 = inttoptr i64 %58 to %struct.cna_node*, !dbg !263
  call void @llvm.dbg.value(metadata %struct.cna_node* %59, metadata !243, metadata !DIExpression()), !dbg !200
  %60 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %59, i32 0, i32 2, !dbg !264
  %61 = bitcast %struct.cna_node** %60 to i64*, !dbg !265
  %62 = load atomic i64, i64* %61 monotonic, align 8, !dbg !265
  %63 = inttoptr i64 %62 to %struct.cna_node*, !dbg !265
  %64 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %63, i32 0, i32 3, !dbg !266
  %65 = load atomic i64, i64* %4 monotonic, align 8, !dbg !267
  %66 = inttoptr i64 %65 to %struct.cna_node*, !dbg !267
  %67 = bitcast %struct.cna_node** %64 to i64*, !dbg !268
  store atomic i64 %65, i64* %67 monotonic, align 8, !dbg !268
  %68 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %59, i32 0, i32 0, !dbg !269
  store atomic i64 1, i64* %68 release, align 8, !dbg !270
  br label %73, !dbg !271

69:                                               ; preds = %53
  %70 = load atomic i64, i64* %4 monotonic, align 8, !dbg !272
  %71 = inttoptr i64 %70 to %struct.cna_node*, !dbg !272
  call void @llvm.dbg.value(metadata %struct.cna_node* %71, metadata !243, metadata !DIExpression()), !dbg !200
  %72 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %71, i32 0, i32 0, !dbg !274
  store atomic i64 1, i64* %72 release, align 8, !dbg !275
  br label %73

73:                                               ; preds = %57, %69, %12, %49, %34
  ret void, !dbg !276
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !277 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !278, metadata !DIExpression()), !dbg !282
  call void @llvm.dbg.value(metadata i32 0, metadata !283, metadata !DIExpression()), !dbg !285
  call void @llvm.dbg.value(metadata i64 0, metadata !283, metadata !DIExpression()), !dbg !285
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !286
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef null) #6, !dbg !288
  call void @llvm.dbg.value(metadata i64 1, metadata !283, metadata !DIExpression()), !dbg !285
  call void @llvm.dbg.value(metadata i64 1, metadata !283, metadata !DIExpression()), !dbg !285
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !286
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !288
  call void @llvm.dbg.value(metadata i64 2, metadata !283, metadata !DIExpression()), !dbg !285
  call void @llvm.dbg.value(metadata i64 2, metadata !283, metadata !DIExpression()), !dbg !285
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !286
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !288
  call void @llvm.dbg.value(metadata i64 3, metadata !283, metadata !DIExpression()), !dbg !285
  call void @llvm.dbg.value(metadata i64 3, metadata !283, metadata !DIExpression()), !dbg !285
  call void @llvm.dbg.value(metadata i32 0, metadata !289, metadata !DIExpression()), !dbg !291
  call void @llvm.dbg.value(metadata i64 0, metadata !289, metadata !DIExpression()), !dbg !291
  %8 = load i64, i64* %2, align 8, !dbg !292
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !294
  call void @llvm.dbg.value(metadata i64 1, metadata !289, metadata !DIExpression()), !dbg !291
  call void @llvm.dbg.value(metadata i64 1, metadata !289, metadata !DIExpression()), !dbg !291
  %10 = load i64, i64* %4, align 8, !dbg !292
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !294
  call void @llvm.dbg.value(metadata i64 2, metadata !289, metadata !DIExpression()), !dbg !291
  call void @llvm.dbg.value(metadata i64 2, metadata !289, metadata !DIExpression()), !dbg !291
  %12 = load i64, i64* %6, align 8, !dbg !292
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !294
  call void @llvm.dbg.value(metadata i64 3, metadata !289, metadata !DIExpression()), !dbg !291
  call void @llvm.dbg.value(metadata i64 3, metadata !289, metadata !DIExpression()), !dbg !291
  %14 = load i32, i32* @sum, align 4, !dbg !295
  %15 = icmp eq i32 %14, 3, !dbg !295
  br i1 %15, label %17, label %16, !dbg !298

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([45 x i8], [45 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !295
  unreachable, !dbg !295

17:                                               ; preds = %0
  ret i32 0, !dbg !299
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
!llvm.module.flags = !{!56, !57, !58, !59, !60, !61, !62}
!llvm.ident = !{!63}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "shared", scope: !2, file: !41, line: 13, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !38, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/cna.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "0506e3ca3274e1e6a11dbba6ba8a7670")
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
!15 = !{!16, !23, !33, !35, !36}
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
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !37, line: 46, baseType: !25)
!37 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!38 = !{!0, !39, !42, !44, !51}
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !41, line: 14, type: !28, isLocal: false, isDefinition: true)
!41 = !DIFile(filename: "benchmarks/locks/cna.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "0506e3ca3274e1e6a11dbba6ba8a7670")
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "tindex", scope: !2, file: !41, line: 9, type: !33, isLocal: false, isDefinition: true)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !41, line: 11, type: !46, isLocal: false, isDefinition: true)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "cna_lock_t", file: !18, line: 67, baseType: !47)
!47 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !18, line: 65, size: 64, elements: !48)
!48 = !{!49}
!49 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !47, file: !18, line: 66, baseType: !50, size: 64)
!50 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !16)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(name: "node", scope: !2, file: !41, line: 12, type: !53, isLocal: false, isDefinition: true)
!53 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 768, elements: !54)
!54 = !{!55}
!55 = !DISubrange(count: 3)
!56 = !{i32 7, !"Dwarf Version", i32 5}
!57 = !{i32 2, !"Debug Info Version", i32 3}
!58 = !{i32 1, !"wchar_size", i32 4}
!59 = !{i32 7, !"PIC Level", i32 2}
!60 = !{i32 7, !"PIE Level", i32 2}
!61 = !{i32 7, !"uwtable", i32 1}
!62 = !{i32 7, !"frame-pointer", i32 2}
!63 = !{!"Ubuntu clang version 14.0.6"}
!64 = distinct !DISubprogram(name: "current_numa_node", scope: !18, file: !18, line: 50, type: !65, scopeLine: 50, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!65 = !DISubroutineType(types: !66)
!66 = !{!28}
!67 = !{}
!68 = !DILocation(line: 51, column: 12, scope: !64)
!69 = !DILocation(line: 51, column: 5, scope: !64)
!70 = distinct !DISubprogram(name: "keep_lock_local", scope: !18, file: !18, line: 54, type: !71, scopeLine: 54, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!71 = !DISubroutineType(types: !72)
!72 = !{!73}
!73 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!74 = !DILocation(line: 55, column: 12, scope: !70)
!75 = !DILocation(line: 55, column: 5, scope: !70)
!76 = distinct !DISubprogram(name: "find_successor", scope: !18, file: !18, line: 69, type: !77, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!77 = !DISubroutineType(types: !78)
!78 = !{!16, !16}
!79 = !DILocalVariable(name: "me", arg: 1, scope: !76, file: !18, line: 69, type: !16)
!80 = !DILocation(line: 0, scope: !76)
!81 = !DILocation(line: 70, column: 50, scope: !76)
!82 = !DILocation(line: 70, column: 24, scope: !76)
!83 = !DILocalVariable(name: "next", scope: !76, file: !18, line: 70, type: !16)
!84 = !DILocation(line: 71, column: 46, scope: !76)
!85 = !DILocation(line: 71, column: 20, scope: !76)
!86 = !DILocalVariable(name: "mySocket", scope: !76, file: !18, line: 71, type: !28)
!87 = !DILocation(line: 73, column: 18, scope: !88)
!88 = distinct !DILexicalBlock(scope: !76, file: !18, line: 73, column: 9)
!89 = !DILocation(line: 73, column: 9, scope: !76)
!90 = !DILocation(line: 73, column: 36, scope: !88)
!91 = !DILocation(line: 73, column: 25, scope: !88)
!92 = !DILocation(line: 74, column: 37, scope: !93)
!93 = distinct !DILexicalBlock(scope: !76, file: !18, line: 74, column: 9)
!94 = !DILocation(line: 74, column: 9, scope: !93)
!95 = !DILocation(line: 74, column: 67, scope: !93)
!96 = !DILocation(line: 74, column: 9, scope: !76)
!97 = !DILocalVariable(name: "secHead", scope: !76, file: !18, line: 76, type: !16)
!98 = !DILocalVariable(name: "secTail", scope: !76, file: !18, line: 77, type: !16)
!99 = !DILocation(line: 78, column: 51, scope: !76)
!100 = !DILocation(line: 78, column: 23, scope: !76)
!101 = !DILocalVariable(name: "cur", scope: !76, file: !18, line: 78, type: !16)
!102 = !DILocation(line: 80, column: 5, scope: !76)
!103 = !DILocation(line: 81, column: 39, scope: !104)
!104 = distinct !DILexicalBlock(scope: !105, file: !18, line: 81, column: 12)
!105 = distinct !DILexicalBlock(scope: !76, file: !18, line: 80, column: 16)
!106 = !DILocation(line: 81, column: 12, scope: !104)
!107 = !DILocation(line: 81, column: 69, scope: !104)
!108 = !DILocation(line: 81, column: 12, scope: !105)
!109 = !DILocation(line: 82, column: 42, scope: !110)
!110 = distinct !DILexicalBlock(scope: !111, file: !18, line: 82, column: 16)
!111 = distinct !DILexicalBlock(scope: !104, file: !18, line: 81, column: 82)
!112 = !DILocation(line: 82, column: 16, scope: !110)
!113 = !DILocation(line: 82, column: 70, scope: !110)
!114 = !DILocation(line: 82, column: 16, scope: !111)
!115 = !DILocation(line: 83, column: 51, scope: !116)
!116 = distinct !DILexicalBlock(scope: !110, file: !18, line: 82, column: 75)
!117 = !DILocation(line: 83, column: 37, scope: !116)
!118 = !DILocalVariable(name: "_spin", scope: !116, file: !18, line: 83, type: !16)
!119 = !DILocation(line: 0, scope: !116)
!120 = !DILocation(line: 84, column: 69, scope: !116)
!121 = !DILocation(line: 84, column: 40, scope: !116)
!122 = !DILocalVariable(name: "_secTail", scope: !116, file: !18, line: 84, type: !16)
!123 = !DILocation(line: 85, column: 50, scope: !116)
!124 = !DILocation(line: 85, column: 17, scope: !116)
!125 = !DILocation(line: 86, column: 13, scope: !116)
!126 = !DILocation(line: 87, column: 17, scope: !127)
!127 = distinct !DILexicalBlock(scope: !110, file: !18, line: 86, column: 20)
!128 = !DILocation(line: 89, column: 45, scope: !111)
!129 = !DILocation(line: 89, column: 13, scope: !111)
!130 = !DILocation(line: 90, column: 47, scope: !111)
!131 = !DILocation(line: 90, column: 33, scope: !111)
!132 = !DILocalVariable(name: "_spin", scope: !111, file: !18, line: 90, type: !16)
!133 = !DILocation(line: 0, scope: !111)
!134 = !DILocation(line: 91, column: 43, scope: !111)
!135 = !DILocation(line: 91, column: 13, scope: !111)
!136 = !DILocation(line: 92, column: 13, scope: !111)
!137 = !DILocation(line: 95, column: 42, scope: !105)
!138 = !DILocation(line: 95, column: 15, scope: !105)
!139 = distinct !{!139, !102, !140, !141}
!140 = !DILocation(line: 96, column: 5, scope: !76)
!141 = !{!"llvm.loop.mustprogress"}
!142 = !DILocation(line: 98, column: 1, scope: !76)
!143 = distinct !DISubprogram(name: "thread_n", scope: !41, file: !41, line: 16, type: !144, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!144 = !DISubroutineType(types: !145)
!145 = !{!35, !35}
!146 = !DILocalVariable(name: "arg", arg: 1, scope: !143, file: !41, line: 16, type: !35)
!147 = !DILocation(line: 0, scope: !143)
!148 = !DILocation(line: 18, column: 15, scope: !143)
!149 = !DILocation(line: 18, column: 12, scope: !143)
!150 = !DILocation(line: 19, column: 22, scope: !143)
!151 = !DILocation(line: 19, column: 5, scope: !143)
!152 = !DILocation(line: 20, column: 14, scope: !143)
!153 = !DILocation(line: 20, column: 12, scope: !143)
!154 = !DILocalVariable(name: "r", scope: !143, file: !41, line: 21, type: !28)
!155 = !DILocation(line: 22, column: 5, scope: !156)
!156 = distinct !DILexicalBlock(scope: !157, file: !41, line: 22, column: 5)
!157 = distinct !DILexicalBlock(scope: !143, file: !41, line: 22, column: 5)
!158 = !DILocation(line: 22, column: 5, scope: !157)
!159 = !DILocation(line: 23, column: 8, scope: !143)
!160 = !DILocation(line: 24, column: 24, scope: !143)
!161 = !DILocation(line: 24, column: 5, scope: !143)
!162 = !DILocation(line: 25, column: 5, scope: !143)
!163 = distinct !DISubprogram(name: "cna_lock", scope: !18, file: !18, line: 100, type: !164, scopeLine: 101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!164 = !DISubroutineType(types: !165)
!165 = !{null, !166, !16}
!166 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!167 = !DILocalVariable(name: "lock", arg: 1, scope: !163, file: !18, line: 100, type: !166)
!168 = !DILocation(line: 0, scope: !163)
!169 = !DILocalVariable(name: "me", arg: 2, scope: !163, file: !18, line: 100, type: !16)
!170 = !DILocation(line: 102, column: 32, scope: !163)
!171 = !DILocation(line: 102, column: 5, scope: !163)
!172 = !DILocation(line: 103, column: 32, scope: !163)
!173 = !DILocation(line: 103, column: 5, scope: !163)
!174 = !DILocation(line: 104, column: 32, scope: !163)
!175 = !DILocation(line: 104, column: 5, scope: !163)
!176 = !DILocation(line: 107, column: 56, scope: !163)
!177 = !DILocation(line: 107, column: 24, scope: !163)
!178 = !DILocalVariable(name: "tail", scope: !163, file: !18, line: 107, type: !16)
!179 = !DILocation(line: 110, column: 9, scope: !180)
!180 = distinct !DILexicalBlock(scope: !163, file: !18, line: 110, column: 8)
!181 = !DILocation(line: 110, column: 8, scope: !163)
!182 = !DILocation(line: 111, column: 9, scope: !183)
!183 = distinct !DILexicalBlock(scope: !180, file: !18, line: 110, column: 15)
!184 = !DILocation(line: 112, column: 9, scope: !183)
!185 = !DILocation(line: 116, column: 40, scope: !163)
!186 = !DILocation(line: 116, column: 5, scope: !163)
!187 = !DILocation(line: 117, column: 34, scope: !163)
!188 = !DILocation(line: 117, column: 5, scope: !163)
!189 = !DILocation(line: 120, column: 5, scope: !190)
!190 = distinct !DILexicalBlock(scope: !163, file: !18, line: 120, column: 5)
!191 = !DILocalVariable(name: "tmp", scope: !190, file: !18, line: 120, type: !28)
!192 = !DILocation(line: 0, scope: !190)
!193 = !DILocation(line: 120, column: 5, scope: !194)
!194 = distinct !DILexicalBlock(scope: !190, file: !18, line: 120, column: 5)
!195 = distinct !{!195, !189, !196, !141}
!196 = !DILocation(line: 122, column: 5, scope: !190)
!197 = !DILocation(line: 123, column: 1, scope: !163)
!198 = distinct !DISubprogram(name: "cna_unlock", scope: !18, file: !18, line: 125, type: !164, scopeLine: 126, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!199 = !DILocalVariable(name: "lock", arg: 1, scope: !198, file: !18, line: 125, type: !166)
!200 = !DILocation(line: 0, scope: !198)
!201 = !DILocalVariable(name: "me", arg: 2, scope: !198, file: !18, line: 125, type: !16)
!202 = !DILocation(line: 128, column: 35, scope: !203)
!203 = distinct !DILexicalBlock(scope: !198, file: !18, line: 128, column: 8)
!204 = !DILocation(line: 128, column: 9, scope: !203)
!205 = !DILocation(line: 128, column: 8, scope: !198)
!206 = !DILocation(line: 130, column: 38, scope: !207)
!207 = distinct !DILexicalBlock(scope: !208, file: !18, line: 130, column: 12)
!208 = distinct !DILexicalBlock(scope: !203, file: !18, line: 128, column: 60)
!209 = !DILocation(line: 130, column: 12, scope: !207)
!210 = !DILocation(line: 130, column: 66, scope: !207)
!211 = !DILocation(line: 130, column: 12, scope: !208)
!212 = !DILocalVariable(name: "local_me", scope: !213, file: !18, line: 132, type: !16)
!213 = distinct !DILexicalBlock(scope: !207, file: !18, line: 130, column: 72)
!214 = !DILocation(line: 0, scope: !213)
!215 = !DILocation(line: 133, column: 63, scope: !216)
!216 = distinct !DILexicalBlock(scope: !213, file: !18, line: 133, column: 16)
!217 = !DILocation(line: 133, column: 16, scope: !216)
!218 = !DILocation(line: 133, column: 16, scope: !213)
!219 = !DILocation(line: 138, column: 50, scope: !220)
!220 = distinct !DILexicalBlock(scope: !207, file: !18, line: 136, column: 16)
!221 = !DILocation(line: 138, column: 35, scope: !220)
!222 = !DILocalVariable(name: "secHead", scope: !220, file: !18, line: 138, type: !16)
!223 = !DILocation(line: 0, scope: !220)
!224 = !DILocalVariable(name: "local_me", scope: !220, file: !18, line: 139, type: !16)
!225 = !DILocation(line: 140, column: 63, scope: !226)
!226 = distinct !DILexicalBlock(scope: !220, file: !18, line: 140, column: 16)
!227 = !DILocation(line: 141, column: 48, scope: !226)
!228 = !DILocation(line: 141, column: 17, scope: !226)
!229 = !DILocation(line: 140, column: 16, scope: !226)
!230 = !DILocation(line: 140, column: 16, scope: !220)
!231 = !DILocation(line: 144, column: 49, scope: !232)
!232 = distinct !DILexicalBlock(scope: !226, file: !18, line: 142, column: 62)
!233 = !DILocation(line: 144, column: 17, scope: !232)
!234 = !DILocation(line: 145, column: 17, scope: !232)
!235 = !DILocation(line: 149, column: 9, scope: !236)
!236 = distinct !DILexicalBlock(scope: !208, file: !18, line: 149, column: 9)
!237 = !DILocalVariable(name: "tmp", scope: !236, file: !18, line: 149, type: !28)
!238 = !DILocation(line: 0, scope: !236)
!239 = !DILocation(line: 149, column: 9, scope: !240)
!240 = distinct !DILexicalBlock(scope: !236, file: !18, line: 149, column: 9)
!241 = distinct !{!241, !235, !242, !141}
!242 = !DILocation(line: 151, column: 9, scope: !236)
!243 = !DILocalVariable(name: "succ", scope: !198, file: !18, line: 154, type: !16)
!244 = !DILocation(line: 155, column: 9, scope: !245)
!245 = distinct !DILexicalBlock(scope: !198, file: !18, line: 155, column: 9)
!246 = !DILocation(line: 155, column: 27, scope: !245)
!247 = !DILocation(line: 155, column: 38, scope: !245)
!248 = !DILocation(line: 155, column: 36, scope: !245)
!249 = !DILocation(line: 155, column: 9, scope: !198)
!250 = !DILocation(line: 156, column: 38, scope: !251)
!251 = distinct !DILexicalBlock(scope: !245, file: !18, line: 155, column: 59)
!252 = !DILocation(line: 157, column: 39, scope: !251)
!253 = !DILocation(line: 157, column: 13, scope: !251)
!254 = !DILocation(line: 156, column: 9, scope: !251)
!255 = !DILocation(line: 159, column: 5, scope: !251)
!256 = !DILocation(line: 159, column: 41, scope: !257)
!257 = distinct !DILexicalBlock(scope: !245, file: !18, line: 159, column: 15)
!258 = !DILocation(line: 159, column: 15, scope: !257)
!259 = !DILocation(line: 159, column: 69, scope: !257)
!260 = !DILocation(line: 159, column: 15, scope: !245)
!261 = !DILocation(line: 160, column: 31, scope: !262)
!262 = distinct !DILexicalBlock(scope: !257, file: !18, line: 159, column: 74)
!263 = !DILocation(line: 160, column: 16, scope: !262)
!264 = !DILocation(line: 162, column: 57, scope: !262)
!265 = !DILocation(line: 162, column: 29, scope: !262)
!266 = !DILocation(line: 162, column: 90, scope: !262)
!267 = !DILocation(line: 163, column: 13, scope: !262)
!268 = !DILocation(line: 161, column: 9, scope: !262)
!269 = !DILocation(line: 165, column: 38, scope: !262)
!270 = !DILocation(line: 165, column: 9, scope: !262)
!271 = !DILocation(line: 166, column: 5, scope: !262)
!272 = !DILocation(line: 167, column: 30, scope: !273)
!273 = distinct !DILexicalBlock(scope: !257, file: !18, line: 166, column: 12)
!274 = !DILocation(line: 168, column: 38, scope: !273)
!275 = !DILocation(line: 168, column: 9, scope: !273)
!276 = !DILocation(line: 170, column: 1, scope: !198)
!277 = distinct !DISubprogram(name: "main", scope: !41, file: !41, line: 28, type: !65, scopeLine: 29, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!278 = !DILocalVariable(name: "t", scope: !277, file: !41, line: 30, type: !279)
!279 = !DICompositeType(tag: DW_TAG_array_type, baseType: !280, size: 192, elements: !54)
!280 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !281, line: 27, baseType: !25)
!281 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!282 = !DILocation(line: 30, column: 15, scope: !277)
!283 = !DILocalVariable(name: "i", scope: !284, file: !41, line: 32, type: !28)
!284 = distinct !DILexicalBlock(scope: !277, file: !41, line: 32, column: 5)
!285 = !DILocation(line: 0, scope: !284)
!286 = !DILocation(line: 33, column: 25, scope: !287)
!287 = distinct !DILexicalBlock(scope: !284, file: !41, line: 32, column: 5)
!288 = !DILocation(line: 33, column: 9, scope: !287)
!289 = !DILocalVariable(name: "i", scope: !290, file: !41, line: 35, type: !28)
!290 = distinct !DILexicalBlock(scope: !277, file: !41, line: 35, column: 5)
!291 = !DILocation(line: 0, scope: !290)
!292 = !DILocation(line: 36, column: 22, scope: !293)
!293 = distinct !DILexicalBlock(scope: !290, file: !41, line: 35, column: 5)
!294 = !DILocation(line: 36, column: 9, scope: !293)
!295 = !DILocation(line: 38, column: 5, scope: !296)
!296 = distinct !DILexicalBlock(scope: !297, file: !41, line: 38, column: 5)
!297 = distinct !DILexicalBlock(scope: !277, file: !41, line: 38, column: 5)
!298 = !DILocation(line: 38, column: 5, scope: !297)
!299 = !DILocation(line: 40, column: 5, scope: !277)
