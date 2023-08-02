; ModuleID = '/home/ponce/git/Dat3M/benchmarks/locks/cna.c'
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
@node = dso_local global [4 x %struct.cna_node] zeroinitializer, align 16, !dbg !49
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
  %2 = alloca %struct.cna_node*, align 8
  %3 = alloca %struct.cna_node*, align 8
  %4 = alloca %struct.cna_node*, align 8
  %5 = alloca %struct.cna_node*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca %struct.cna_node*, align 8
  %10 = alloca %struct.cna_node*, align 8
  %11 = alloca %struct.cna_node*, align 8
  %12 = alloca %struct.cna_node*, align 8
  %13 = alloca i32, align 4
  %14 = alloca i64, align 8
  %15 = alloca %struct.cna_node*, align 8
  %16 = alloca i64, align 8
  %17 = alloca %struct.cna_node*, align 8
  %18 = alloca %struct.cna_node*, align 8
  %19 = alloca %struct.cna_node*, align 8
  %20 = alloca i64, align 8
  %21 = alloca %struct.cna_node*, align 8
  %22 = alloca %struct.cna_node*, align 8
  %23 = alloca i64, align 8
  %24 = alloca %struct.cna_node*, align 8
  %25 = alloca %struct.cna_node*, align 8
  store %struct.cna_node* %0, %struct.cna_node** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.cna_node** %3, metadata !77, metadata !DIExpression()), !dbg !78
  call void @llvm.dbg.declare(metadata %struct.cna_node** %4, metadata !79, metadata !DIExpression()), !dbg !80
  %26 = load %struct.cna_node*, %struct.cna_node** %3, align 8, !dbg !81
  %27 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %26, i32 0, i32 3, !dbg !82
  %28 = bitcast %struct.cna_node** %27 to i64*, !dbg !83
  %29 = bitcast %struct.cna_node** %5 to i64*, !dbg !83
  %30 = load atomic i64, i64* %28 monotonic, align 8, !dbg !83
  store i64 %30, i64* %29, align 8, !dbg !83
  %31 = bitcast i64* %29 to %struct.cna_node**, !dbg !83
  %32 = load %struct.cna_node*, %struct.cna_node** %31, align 8, !dbg !83
  store %struct.cna_node* %32, %struct.cna_node** %4, align 8, !dbg !80
  call void @llvm.dbg.declare(metadata i32* %6, metadata !84, metadata !DIExpression()), !dbg !85
  %33 = load %struct.cna_node*, %struct.cna_node** %3, align 8, !dbg !86
  %34 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %33, i32 0, i32 1, !dbg !87
  %35 = load atomic i32, i32* %34 monotonic, align 8, !dbg !88
  store i32 %35, i32* %7, align 4, !dbg !88
  %36 = load i32, i32* %7, align 4, !dbg !88
  store i32 %36, i32* %6, align 4, !dbg !85
  %37 = load i32, i32* %6, align 4, !dbg !89
  %38 = icmp eq i32 %37, -1, !dbg !91
  br i1 %38, label %39, label %41, !dbg !92

39:                                               ; preds = %1
  %40 = call i32 @current_numa_node(), !dbg !93
  store i32 %40, i32* %6, align 4, !dbg !94
  br label %41, !dbg !95

41:                                               ; preds = %39, %1
  %42 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !96
  %43 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %42, i32 0, i32 1, !dbg !98
  %44 = load atomic i32, i32* %43 monotonic, align 8, !dbg !99
  store i32 %44, i32* %8, align 4, !dbg !99
  %45 = load i32, i32* %8, align 4, !dbg !99
  %46 = load i32, i32* %6, align 4, !dbg !100
  %47 = icmp eq i32 %45, %46, !dbg !101
  br i1 %47, label %48, label %50, !dbg !102

48:                                               ; preds = %41
  %49 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !103
  store %struct.cna_node* %49, %struct.cna_node** %2, align 8, !dbg !104
  br label %129, !dbg !104

50:                                               ; preds = %41
  call void @llvm.dbg.declare(metadata %struct.cna_node** %9, metadata !105, metadata !DIExpression()), !dbg !106
  %51 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !107
  store %struct.cna_node* %51, %struct.cna_node** %9, align 8, !dbg !106
  call void @llvm.dbg.declare(metadata %struct.cna_node** %10, metadata !108, metadata !DIExpression()), !dbg !109
  %52 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !110
  store %struct.cna_node* %52, %struct.cna_node** %10, align 8, !dbg !109
  call void @llvm.dbg.declare(metadata %struct.cna_node** %11, metadata !111, metadata !DIExpression()), !dbg !112
  %53 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !113
  %54 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %53, i32 0, i32 3, !dbg !114
  %55 = bitcast %struct.cna_node** %54 to i64*, !dbg !115
  %56 = bitcast %struct.cna_node** %12 to i64*, !dbg !115
  %57 = load atomic i64, i64* %55 acquire, align 8, !dbg !115
  store i64 %57, i64* %56, align 8, !dbg !115
  %58 = bitcast i64* %56 to %struct.cna_node**, !dbg !115
  %59 = load %struct.cna_node*, %struct.cna_node** %58, align 8, !dbg !115
  store %struct.cna_node* %59, %struct.cna_node** %11, align 8, !dbg !112
  br label %60, !dbg !116

60:                                               ; preds = %119, %50
  %61 = load %struct.cna_node*, %struct.cna_node** %11, align 8, !dbg !117
  %62 = icmp ne %struct.cna_node* %61, null, !dbg !116
  br i1 %62, label %63, label %128, !dbg !116

63:                                               ; preds = %60
  %64 = load %struct.cna_node*, %struct.cna_node** %11, align 8, !dbg !118
  %65 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %64, i32 0, i32 1, !dbg !121
  %66 = load atomic i32, i32* %65 monotonic, align 8, !dbg !122
  store i32 %66, i32* %13, align 4, !dbg !122
  %67 = load i32, i32* %13, align 4, !dbg !122
  %68 = load i32, i32* %6, align 4, !dbg !123
  %69 = icmp eq i32 %67, %68, !dbg !124
  br i1 %69, label %70, label %119, !dbg !125

70:                                               ; preds = %63
  %71 = load %struct.cna_node*, %struct.cna_node** %3, align 8, !dbg !126
  %72 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %71, i32 0, i32 0, !dbg !129
  %73 = load atomic i64, i64* %72 monotonic, align 8, !dbg !130
  store i64 %73, i64* %14, align 8, !dbg !130
  %74 = load i64, i64* %14, align 8, !dbg !130
  %75 = icmp ugt i64 %74, 1, !dbg !131
  br i1 %75, label %76, label %95, !dbg !132

76:                                               ; preds = %70
  call void @llvm.dbg.declare(metadata %struct.cna_node** %15, metadata !133, metadata !DIExpression()), !dbg !135
  %77 = load %struct.cna_node*, %struct.cna_node** %3, align 8, !dbg !136
  %78 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %77, i32 0, i32 0, !dbg !137
  %79 = load atomic i64, i64* %78 monotonic, align 8, !dbg !138
  store i64 %79, i64* %16, align 8, !dbg !138
  %80 = load i64, i64* %16, align 8, !dbg !138
  %81 = inttoptr i64 %80 to %struct.cna_node*, !dbg !139
  store %struct.cna_node* %81, %struct.cna_node** %15, align 8, !dbg !135
  call void @llvm.dbg.declare(metadata %struct.cna_node** %17, metadata !140, metadata !DIExpression()), !dbg !141
  %82 = load %struct.cna_node*, %struct.cna_node** %15, align 8, !dbg !142
  %83 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %82, i32 0, i32 2, !dbg !143
  %84 = bitcast %struct.cna_node** %83 to i64*, !dbg !144
  %85 = bitcast %struct.cna_node** %18 to i64*, !dbg !144
  %86 = load atomic i64, i64* %84 monotonic, align 8, !dbg !144
  store i64 %86, i64* %85, align 8, !dbg !144
  %87 = bitcast i64* %85 to %struct.cna_node**, !dbg !144
  %88 = load %struct.cna_node*, %struct.cna_node** %87, align 8, !dbg !144
  store %struct.cna_node* %88, %struct.cna_node** %17, align 8, !dbg !141
  %89 = load %struct.cna_node*, %struct.cna_node** %17, align 8, !dbg !145
  %90 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %89, i32 0, i32 3, !dbg !146
  %91 = load %struct.cna_node*, %struct.cna_node** %9, align 8, !dbg !147
  store %struct.cna_node* %91, %struct.cna_node** %19, align 8, !dbg !148
  %92 = bitcast %struct.cna_node** %90 to i64*, !dbg !148
  %93 = bitcast %struct.cna_node** %19 to i64*, !dbg !148
  %94 = load i64, i64* %93, align 8, !dbg !148
  store atomic i64 %94, i64* %92 monotonic, align 8, !dbg !148
  br label %101, !dbg !149

95:                                               ; preds = %70
  %96 = load %struct.cna_node*, %struct.cna_node** %3, align 8, !dbg !150
  %97 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %96, i32 0, i32 0, !dbg !152
  %98 = load %struct.cna_node*, %struct.cna_node** %9, align 8, !dbg !153
  %99 = ptrtoint %struct.cna_node* %98 to i64, !dbg !154
  store i64 %99, i64* %20, align 8, !dbg !155
  %100 = load i64, i64* %20, align 8, !dbg !155
  store atomic i64 %100, i64* %97 monotonic, align 8, !dbg !155
  br label %101

101:                                              ; preds = %95, %76
  %102 = load %struct.cna_node*, %struct.cna_node** %10, align 8, !dbg !156
  %103 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %102, i32 0, i32 3, !dbg !157
  store %struct.cna_node* null, %struct.cna_node** %21, align 8, !dbg !158
  %104 = bitcast %struct.cna_node** %103 to i64*, !dbg !158
  %105 = bitcast %struct.cna_node** %21 to i64*, !dbg !158
  %106 = load i64, i64* %105, align 8, !dbg !158
  store atomic i64 %106, i64* %104 monotonic, align 8, !dbg !158
  call void @llvm.dbg.declare(metadata %struct.cna_node** %22, metadata !159, metadata !DIExpression()), !dbg !160
  %107 = load %struct.cna_node*, %struct.cna_node** %3, align 8, !dbg !161
  %108 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %107, i32 0, i32 0, !dbg !162
  %109 = load atomic i64, i64* %108 monotonic, align 8, !dbg !163
  store i64 %109, i64* %23, align 8, !dbg !163
  %110 = load i64, i64* %23, align 8, !dbg !163
  %111 = inttoptr i64 %110 to %struct.cna_node*, !dbg !164
  store %struct.cna_node* %111, %struct.cna_node** %22, align 8, !dbg !160
  %112 = load %struct.cna_node*, %struct.cna_node** %22, align 8, !dbg !165
  %113 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %112, i32 0, i32 2, !dbg !166
  %114 = load %struct.cna_node*, %struct.cna_node** %10, align 8, !dbg !167
  store %struct.cna_node* %114, %struct.cna_node** %24, align 8, !dbg !168
  %115 = bitcast %struct.cna_node** %113 to i64*, !dbg !168
  %116 = bitcast %struct.cna_node** %24 to i64*, !dbg !168
  %117 = load i64, i64* %116, align 8, !dbg !168
  store atomic i64 %117, i64* %115 monotonic, align 8, !dbg !168
  %118 = load %struct.cna_node*, %struct.cna_node** %11, align 8, !dbg !169
  store %struct.cna_node* %118, %struct.cna_node** %2, align 8, !dbg !170
  br label %129, !dbg !170

119:                                              ; preds = %63
  %120 = load %struct.cna_node*, %struct.cna_node** %11, align 8, !dbg !171
  store %struct.cna_node* %120, %struct.cna_node** %10, align 8, !dbg !172
  %121 = load %struct.cna_node*, %struct.cna_node** %11, align 8, !dbg !173
  %122 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %121, i32 0, i32 3, !dbg !174
  %123 = bitcast %struct.cna_node** %122 to i64*, !dbg !175
  %124 = bitcast %struct.cna_node** %25 to i64*, !dbg !175
  %125 = load atomic i64, i64* %123 acquire, align 8, !dbg !175
  store i64 %125, i64* %124, align 8, !dbg !175
  %126 = bitcast i64* %124 to %struct.cna_node**, !dbg !175
  %127 = load %struct.cna_node*, %struct.cna_node** %126, align 8, !dbg !175
  store %struct.cna_node* %127, %struct.cna_node** %11, align 8, !dbg !176
  br label %60, !dbg !116, !llvm.loop !177

128:                                              ; preds = %60
  store %struct.cna_node* null, %struct.cna_node** %2, align 8, !dbg !180
  br label %129, !dbg !180

129:                                              ; preds = %128, %101, %48
  %130 = load %struct.cna_node*, %struct.cna_node** %2, align 8, !dbg !181
  ret %struct.cna_node* %130, !dbg !181
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !182 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !185, metadata !DIExpression()), !dbg !186
  %4 = load i8*, i8** %2, align 8, !dbg !187
  %5 = ptrtoint i8* %4 to i64, !dbg !188
  store i64 %5, i64* @tindex, align 8, !dbg !189
  %6 = load i64, i64* @tindex, align 8, !dbg !190
  %7 = getelementptr inbounds [4 x %struct.cna_node], [4 x %struct.cna_node]* @node, i64 0, i64 %6, !dbg !191
  call void @cna_lock(%struct.cna_lock_t* noundef @lock, %struct.cna_node* noundef %7), !dbg !192
  %8 = load i64, i64* @tindex, align 8, !dbg !193
  %9 = trunc i64 %8 to i32, !dbg !193
  store i32 %9, i32* @shared, align 4, !dbg !194
  call void @llvm.dbg.declare(metadata i32* %3, metadata !195, metadata !DIExpression()), !dbg !196
  %10 = load i32, i32* @shared, align 4, !dbg !197
  store i32 %10, i32* %3, align 4, !dbg !196
  %11 = load i32, i32* %3, align 4, !dbg !198
  %12 = sext i32 %11 to i64, !dbg !198
  %13 = load i64, i64* @tindex, align 8, !dbg !198
  %14 = icmp eq i64 %12, %13, !dbg !198
  br i1 %14, label %15, label %16, !dbg !201

15:                                               ; preds = %1
  br label %17, !dbg !201

16:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([45 x i8], [45 x i8]* @.str.1, i64 0, i64 0), i32 noundef 22, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #5, !dbg !198
  unreachable, !dbg !198

17:                                               ; preds = %15
  %18 = load i32, i32* @sum, align 4, !dbg !202
  %19 = add nsw i32 %18, 1, !dbg !202
  store i32 %19, i32* @sum, align 4, !dbg !202
  %20 = load i64, i64* @tindex, align 8, !dbg !203
  %21 = getelementptr inbounds [4 x %struct.cna_node], [4 x %struct.cna_node]* @node, i64 0, i64 %20, !dbg !204
  call void @cna_unlock(%struct.cna_lock_t* noundef @lock, %struct.cna_node* noundef %21), !dbg !205
  ret i8* null, !dbg !206
}

; Function Attrs: noinline nounwind uwtable
define internal void @cna_lock(%struct.cna_lock_t* noundef %0, %struct.cna_node* noundef %1) #0 !dbg !207 {
  %3 = alloca %struct.cna_lock_t*, align 8
  %4 = alloca %struct.cna_node*, align 8
  %5 = alloca %struct.cna_node*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i64, align 8
  %8 = alloca %struct.cna_node*, align 8
  %9 = alloca %struct.cna_node*, align 8
  %10 = alloca %struct.cna_node*, align 8
  %11 = alloca i64, align 8
  %12 = alloca i32, align 4
  %13 = alloca %struct.cna_node*, align 8
  %14 = alloca i32, align 4
  %15 = alloca i64, align 8
  store %struct.cna_lock_t* %0, %struct.cna_lock_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.cna_lock_t** %3, metadata !211, metadata !DIExpression()), !dbg !212
  store %struct.cna_node* %1, %struct.cna_node** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.cna_node** %4, metadata !213, metadata !DIExpression()), !dbg !214
  %16 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !215
  %17 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %16, i32 0, i32 3, !dbg !216
  store %struct.cna_node* null, %struct.cna_node** %5, align 8, !dbg !217
  %18 = bitcast %struct.cna_node** %17 to i64*, !dbg !217
  %19 = bitcast %struct.cna_node** %5 to i64*, !dbg !217
  %20 = load i64, i64* %19, align 8, !dbg !217
  store atomic i64 %20, i64* %18 monotonic, align 8, !dbg !217
  %21 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !218
  %22 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %21, i32 0, i32 1, !dbg !219
  store i32 -1, i32* %6, align 4, !dbg !220
  %23 = load i32, i32* %6, align 4, !dbg !220
  store atomic i32 %23, i32* %22 monotonic, align 8, !dbg !220
  %24 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !221
  %25 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %24, i32 0, i32 0, !dbg !222
  store i64 0, i64* %7, align 8, !dbg !223
  %26 = load i64, i64* %7, align 8, !dbg !223
  store atomic i64 %26, i64* %25 monotonic, align 8, !dbg !223
  call void @llvm.dbg.declare(metadata %struct.cna_node** %8, metadata !224, metadata !DIExpression()), !dbg !225
  %27 = load %struct.cna_lock_t*, %struct.cna_lock_t** %3, align 8, !dbg !226
  %28 = getelementptr inbounds %struct.cna_lock_t, %struct.cna_lock_t* %27, i32 0, i32 0, !dbg !227
  %29 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !228
  store %struct.cna_node* %29, %struct.cna_node** %9, align 8, !dbg !229
  %30 = bitcast %struct.cna_node** %28 to i64*, !dbg !229
  %31 = bitcast %struct.cna_node** %9 to i64*, !dbg !229
  %32 = bitcast %struct.cna_node** %10 to i64*, !dbg !229
  %33 = load i64, i64* %31, align 8, !dbg !229
  %34 = atomicrmw xchg i64* %30, i64 %33 seq_cst, align 8, !dbg !229
  store i64 %34, i64* %32, align 8, !dbg !229
  %35 = bitcast i64* %32 to %struct.cna_node**, !dbg !229
  %36 = load %struct.cna_node*, %struct.cna_node** %35, align 8, !dbg !229
  store %struct.cna_node* %36, %struct.cna_node** %8, align 8, !dbg !225
  %37 = load %struct.cna_node*, %struct.cna_node** %8, align 8, !dbg !230
  %38 = icmp ne %struct.cna_node* %37, null, !dbg !230
  br i1 %38, label %43, label %39, !dbg !232

39:                                               ; preds = %2
  %40 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !233
  %41 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %40, i32 0, i32 0, !dbg !235
  store i64 1, i64* %11, align 8, !dbg !236
  %42 = load i64, i64* %11, align 8, !dbg !236
  store atomic i64 %42, i64* %41 monotonic, align 8, !dbg !236
  br label %69, !dbg !237

43:                                               ; preds = %2
  %44 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !238
  %45 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %44, i32 0, i32 1, !dbg !239
  %46 = call i32 @current_numa_node(), !dbg !240
  store i32 %46, i32* %12, align 4, !dbg !241
  %47 = load i32, i32* %12, align 4, !dbg !241
  store atomic i32 %47, i32* %45 monotonic, align 8, !dbg !241
  %48 = load %struct.cna_node*, %struct.cna_node** %8, align 8, !dbg !242
  %49 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %48, i32 0, i32 3, !dbg !243
  %50 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !244
  store %struct.cna_node* %50, %struct.cna_node** %13, align 8, !dbg !245
  %51 = bitcast %struct.cna_node** %49 to i64*, !dbg !245
  %52 = bitcast %struct.cna_node** %13 to i64*, !dbg !245
  %53 = load i64, i64* %52, align 8, !dbg !245
  store atomic i64 %53, i64* %51 release, align 8, !dbg !245
  call void @llvm.dbg.declare(metadata i32* %14, metadata !246, metadata !DIExpression()), !dbg !248
  call void @__VERIFIER_loop_begin(), !dbg !248
  store i32 0, i32* %14, align 4, !dbg !248
  br label %54, !dbg !248

54:                                               ; preds = %68, %43
  call void @__VERIFIER_spin_start(), !dbg !249
  %55 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !249
  %56 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %55, i32 0, i32 0, !dbg !249
  %57 = load atomic i64, i64* %56 acquire, align 8, !dbg !249
  store i64 %57, i64* %15, align 8, !dbg !249
  %58 = load i64, i64* %15, align 8, !dbg !249
  %59 = icmp ne i64 %58, 0, !dbg !249
  %60 = xor i1 %59, true, !dbg !249
  %61 = zext i1 %60 to i32, !dbg !249
  store i32 %61, i32* %14, align 4, !dbg !249
  %62 = load i32, i32* %14, align 4, !dbg !249
  %63 = icmp ne i32 %62, 0, !dbg !249
  %64 = xor i1 %63, true, !dbg !249
  %65 = zext i1 %64 to i32, !dbg !249
  call void @__VERIFIER_spin_end(i32 noundef %65), !dbg !249
  %66 = load i32, i32* %14, align 4, !dbg !249
  %67 = icmp ne i32 %66, 0, !dbg !248
  br i1 %67, label %68, label %69, !dbg !248

68:                                               ; preds = %54
  br label %54, !dbg !249, !llvm.loop !251

69:                                               ; preds = %39, %54
  ret void, !dbg !253
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @cna_unlock(%struct.cna_lock_t* noundef %0, %struct.cna_node* noundef %1) #0 !dbg !254 {
  %3 = alloca %struct.cna_lock_t*, align 8
  %4 = alloca %struct.cna_node*, align 8
  %5 = alloca %struct.cna_node*, align 8
  %6 = alloca i64, align 8
  %7 = alloca %struct.cna_node*, align 8
  %8 = alloca %struct.cna_node*, align 8
  %9 = alloca i8, align 1
  %10 = alloca %struct.cna_node*, align 8
  %11 = alloca i64, align 8
  %12 = alloca %struct.cna_node*, align 8
  %13 = alloca %struct.cna_node*, align 8
  %14 = alloca %struct.cna_node*, align 8
  %15 = alloca i8, align 1
  %16 = alloca i64, align 8
  %17 = alloca i32, align 4
  %18 = alloca %struct.cna_node*, align 8
  %19 = alloca %struct.cna_node*, align 8
  %20 = alloca i64, align 8
  %21 = alloca i64, align 8
  %22 = alloca i64, align 8
  %23 = alloca i64, align 8
  %24 = alloca %struct.cna_node*, align 8
  %25 = alloca %struct.cna_node*, align 8
  %26 = alloca %struct.cna_node*, align 8
  %27 = alloca i64, align 8
  %28 = alloca %struct.cna_node*, align 8
  %29 = alloca i64, align 8
  store %struct.cna_lock_t* %0, %struct.cna_lock_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.cna_lock_t** %3, metadata !255, metadata !DIExpression()), !dbg !256
  store %struct.cna_node* %1, %struct.cna_node** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.cna_node** %4, metadata !257, metadata !DIExpression()), !dbg !258
  %30 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !259
  %31 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %30, i32 0, i32 3, !dbg !261
  %32 = bitcast %struct.cna_node** %31 to i64*, !dbg !262
  %33 = bitcast %struct.cna_node** %5 to i64*, !dbg !262
  %34 = load atomic i64, i64* %32 acquire, align 8, !dbg !262
  store i64 %34, i64* %33, align 8, !dbg !262
  %35 = bitcast i64* %33 to %struct.cna_node**, !dbg !262
  %36 = load %struct.cna_node*, %struct.cna_node** %35, align 8, !dbg !262
  %37 = icmp ne %struct.cna_node* %36, null, !dbg !262
  br i1 %37, label %116, label %38, !dbg !263

38:                                               ; preds = %2
  %39 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !264
  %40 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %39, i32 0, i32 0, !dbg !267
  %41 = load atomic i64, i64* %40 monotonic, align 8, !dbg !268
  store i64 %41, i64* %6, align 8, !dbg !268
  %42 = load i64, i64* %6, align 8, !dbg !268
  %43 = icmp eq i64 %42, 1, !dbg !269
  br i1 %43, label %44, label %63, !dbg !270

44:                                               ; preds = %38
  call void @llvm.dbg.declare(metadata %struct.cna_node** %7, metadata !271, metadata !DIExpression()), !dbg !273
  %45 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !274
  store %struct.cna_node* %45, %struct.cna_node** %7, align 8, !dbg !273
  %46 = load %struct.cna_lock_t*, %struct.cna_lock_t** %3, align 8, !dbg !275
  %47 = getelementptr inbounds %struct.cna_lock_t, %struct.cna_lock_t* %46, i32 0, i32 0, !dbg !277
  store %struct.cna_node* null, %struct.cna_node** %8, align 8, !dbg !278
  %48 = bitcast %struct.cna_node** %47 to i64*, !dbg !278
  %49 = bitcast %struct.cna_node** %7 to i64*, !dbg !278
  %50 = bitcast %struct.cna_node** %8 to i64*, !dbg !278
  %51 = load i64, i64* %49, align 8, !dbg !278
  %52 = load i64, i64* %50, align 8, !dbg !278
  %53 = cmpxchg i64* %48, i64 %51, i64 %52 seq_cst seq_cst, align 8, !dbg !278
  %54 = extractvalue { i64, i1 } %53, 0, !dbg !278
  %55 = extractvalue { i64, i1 } %53, 1, !dbg !278
  br i1 %55, label %57, label %56, !dbg !278

56:                                               ; preds = %44
  store i64 %54, i64* %49, align 8, !dbg !278
  br label %57, !dbg !278

57:                                               ; preds = %56, %44
  %58 = zext i1 %55 to i8, !dbg !278
  store i8 %58, i8* %9, align 1, !dbg !278
  %59 = load i8, i8* %9, align 1, !dbg !278
  %60 = trunc i8 %59 to i1, !dbg !278
  br i1 %60, label %61, label %62, !dbg !279

61:                                               ; preds = %57
  br label %175, !dbg !280

62:                                               ; preds = %57
  br label %97, !dbg !282

63:                                               ; preds = %38
  call void @llvm.dbg.declare(metadata %struct.cna_node** %10, metadata !283, metadata !DIExpression()), !dbg !285
  %64 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !286
  %65 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %64, i32 0, i32 0, !dbg !287
  %66 = load atomic i64, i64* %65 monotonic, align 8, !dbg !288
  store i64 %66, i64* %11, align 8, !dbg !288
  %67 = load i64, i64* %11, align 8, !dbg !288
  %68 = inttoptr i64 %67 to %struct.cna_node*, !dbg !289
  store %struct.cna_node* %68, %struct.cna_node** %10, align 8, !dbg !285
  call void @llvm.dbg.declare(metadata %struct.cna_node** %12, metadata !290, metadata !DIExpression()), !dbg !291
  %69 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !292
  store %struct.cna_node* %69, %struct.cna_node** %12, align 8, !dbg !291
  %70 = load %struct.cna_lock_t*, %struct.cna_lock_t** %3, align 8, !dbg !293
  %71 = getelementptr inbounds %struct.cna_lock_t, %struct.cna_lock_t* %70, i32 0, i32 0, !dbg !295
  %72 = load %struct.cna_node*, %struct.cna_node** %10, align 8, !dbg !296
  %73 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %72, i32 0, i32 2, !dbg !297
  %74 = bitcast %struct.cna_node** %73 to i64*, !dbg !298
  %75 = bitcast %struct.cna_node** %14 to i64*, !dbg !298
  %76 = load atomic i64, i64* %74 monotonic, align 8, !dbg !298
  store i64 %76, i64* %75, align 8, !dbg !298
  %77 = bitcast i64* %75 to %struct.cna_node**, !dbg !298
  %78 = load %struct.cna_node*, %struct.cna_node** %77, align 8, !dbg !298
  store %struct.cna_node* %78, %struct.cna_node** %13, align 8, !dbg !299
  %79 = bitcast %struct.cna_node** %71 to i64*, !dbg !299
  %80 = bitcast %struct.cna_node** %12 to i64*, !dbg !299
  %81 = bitcast %struct.cna_node** %13 to i64*, !dbg !299
  %82 = load i64, i64* %80, align 8, !dbg !299
  %83 = load i64, i64* %81, align 8, !dbg !299
  %84 = cmpxchg i64* %79, i64 %82, i64 %83 seq_cst seq_cst, align 8, !dbg !299
  %85 = extractvalue { i64, i1 } %84, 0, !dbg !299
  %86 = extractvalue { i64, i1 } %84, 1, !dbg !299
  br i1 %86, label %88, label %87, !dbg !299

87:                                               ; preds = %63
  store i64 %85, i64* %80, align 8, !dbg !299
  br label %88, !dbg !299

88:                                               ; preds = %87, %63
  %89 = zext i1 %86 to i8, !dbg !299
  store i8 %89, i8* %15, align 1, !dbg !299
  %90 = load i8, i8* %15, align 1, !dbg !299
  %91 = trunc i8 %90 to i1, !dbg !299
  br i1 %91, label %92, label %96, !dbg !300

92:                                               ; preds = %88
  %93 = load %struct.cna_node*, %struct.cna_node** %10, align 8, !dbg !301
  %94 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %93, i32 0, i32 0, !dbg !303
  store i64 1, i64* %16, align 8, !dbg !304
  %95 = load i64, i64* %16, align 8, !dbg !304
  store atomic i64 %95, i64* %94 release, align 8, !dbg !304
  br label %175, !dbg !305

96:                                               ; preds = %88
  br label %97

97:                                               ; preds = %96, %62
  call void @llvm.dbg.declare(metadata i32* %17, metadata !306, metadata !DIExpression()), !dbg !308
  call void @__VERIFIER_loop_begin(), !dbg !308
  store i32 0, i32* %17, align 4, !dbg !308
  br label %98, !dbg !308

98:                                               ; preds = %114, %97
  call void @__VERIFIER_spin_start(), !dbg !309
  %99 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !309
  %100 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %99, i32 0, i32 3, !dbg !309
  %101 = bitcast %struct.cna_node** %100 to i64*, !dbg !309
  %102 = bitcast %struct.cna_node** %18 to i64*, !dbg !309
  %103 = load atomic i64, i64* %101 monotonic, align 8, !dbg !309
  store i64 %103, i64* %102, align 8, !dbg !309
  %104 = bitcast i64* %102 to %struct.cna_node**, !dbg !309
  %105 = load %struct.cna_node*, %struct.cna_node** %104, align 8, !dbg !309
  %106 = icmp eq %struct.cna_node* %105, null, !dbg !309
  %107 = zext i1 %106 to i32, !dbg !309
  store i32 %107, i32* %17, align 4, !dbg !309
  %108 = load i32, i32* %17, align 4, !dbg !309
  %109 = icmp ne i32 %108, 0, !dbg !309
  %110 = xor i1 %109, true, !dbg !309
  %111 = zext i1 %110 to i32, !dbg !309
  call void @__VERIFIER_spin_end(i32 noundef %111), !dbg !309
  %112 = load i32, i32* %17, align 4, !dbg !309
  %113 = icmp ne i32 %112, 0, !dbg !308
  br i1 %113, label %114, label %115, !dbg !308

114:                                              ; preds = %98
  br label %98, !dbg !309, !llvm.loop !311

115:                                              ; preds = %98
  br label %116, !dbg !313

116:                                              ; preds = %115, %2
  call void @llvm.dbg.declare(metadata %struct.cna_node** %19, metadata !314, metadata !DIExpression()), !dbg !315
  store %struct.cna_node* null, %struct.cna_node** %19, align 8, !dbg !315
  %117 = call zeroext i1 @keep_lock_local(), !dbg !316
  br i1 %117, label %118, label %130, !dbg !318

118:                                              ; preds = %116
  %119 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !319
  %120 = call %struct.cna_node* @find_successor(%struct.cna_node* noundef %119), !dbg !320
  store %struct.cna_node* %120, %struct.cna_node** %19, align 8, !dbg !321
  %121 = icmp ne %struct.cna_node* %120, null, !dbg !321
  br i1 %121, label %122, label %130, !dbg !322

122:                                              ; preds = %118
  %123 = load %struct.cna_node*, %struct.cna_node** %19, align 8, !dbg !323
  %124 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %123, i32 0, i32 0, !dbg !325
  %125 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !326
  %126 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %125, i32 0, i32 0, !dbg !327
  %127 = load atomic i64, i64* %126 monotonic, align 8, !dbg !328
  store i64 %127, i64* %21, align 8, !dbg !328
  %128 = load i64, i64* %21, align 8, !dbg !328
  store i64 %128, i64* %20, align 8, !dbg !329
  %129 = load i64, i64* %20, align 8, !dbg !329
  store atomic i64 %129, i64* %124 release, align 8, !dbg !329
  br label %175, !dbg !330

130:                                              ; preds = %118, %116
  %131 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !331
  %132 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %131, i32 0, i32 0, !dbg !333
  %133 = load atomic i64, i64* %132 monotonic, align 8, !dbg !334
  store i64 %133, i64* %22, align 8, !dbg !334
  %134 = load i64, i64* %22, align 8, !dbg !334
  %135 = icmp ugt i64 %134, 1, !dbg !335
  br i1 %135, label %136, label %163, !dbg !336

136:                                              ; preds = %130
  %137 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !337
  %138 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %137, i32 0, i32 0, !dbg !339
  %139 = load atomic i64, i64* %138 monotonic, align 8, !dbg !340
  store i64 %139, i64* %23, align 8, !dbg !340
  %140 = load i64, i64* %23, align 8, !dbg !340
  %141 = inttoptr i64 %140 to %struct.cna_node*, !dbg !341
  store %struct.cna_node* %141, %struct.cna_node** %19, align 8, !dbg !342
  %142 = load %struct.cna_node*, %struct.cna_node** %19, align 8, !dbg !343
  %143 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %142, i32 0, i32 2, !dbg !344
  %144 = bitcast %struct.cna_node** %143 to i64*, !dbg !345
  %145 = bitcast %struct.cna_node** %24 to i64*, !dbg !345
  %146 = load atomic i64, i64* %144 monotonic, align 8, !dbg !345
  store i64 %146, i64* %145, align 8, !dbg !345
  %147 = bitcast i64* %145 to %struct.cna_node**, !dbg !345
  %148 = load %struct.cna_node*, %struct.cna_node** %147, align 8, !dbg !345
  %149 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %148, i32 0, i32 3, !dbg !346
  %150 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !347
  %151 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %150, i32 0, i32 3, !dbg !348
  %152 = bitcast %struct.cna_node** %151 to i64*, !dbg !349
  %153 = bitcast %struct.cna_node** %26 to i64*, !dbg !349
  %154 = load atomic i64, i64* %152 monotonic, align 8, !dbg !349
  store i64 %154, i64* %153, align 8, !dbg !349
  %155 = bitcast i64* %153 to %struct.cna_node**, !dbg !349
  %156 = load %struct.cna_node*, %struct.cna_node** %155, align 8, !dbg !349
  store %struct.cna_node* %156, %struct.cna_node** %25, align 8, !dbg !350
  %157 = bitcast %struct.cna_node** %149 to i64*, !dbg !350
  %158 = bitcast %struct.cna_node** %25 to i64*, !dbg !350
  %159 = load i64, i64* %158, align 8, !dbg !350
  store atomic i64 %159, i64* %157 monotonic, align 8, !dbg !350
  %160 = load %struct.cna_node*, %struct.cna_node** %19, align 8, !dbg !351
  %161 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %160, i32 0, i32 0, !dbg !352
  store i64 1, i64* %27, align 8, !dbg !353
  %162 = load i64, i64* %27, align 8, !dbg !353
  store atomic i64 %162, i64* %161 release, align 8, !dbg !353
  br label %174, !dbg !354

163:                                              ; preds = %130
  %164 = load %struct.cna_node*, %struct.cna_node** %4, align 8, !dbg !355
  %165 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %164, i32 0, i32 3, !dbg !357
  %166 = bitcast %struct.cna_node** %165 to i64*, !dbg !358
  %167 = bitcast %struct.cna_node** %28 to i64*, !dbg !358
  %168 = load atomic i64, i64* %166 monotonic, align 8, !dbg !358
  store i64 %168, i64* %167, align 8, !dbg !358
  %169 = bitcast i64* %167 to %struct.cna_node**, !dbg !358
  %170 = load %struct.cna_node*, %struct.cna_node** %169, align 8, !dbg !358
  store %struct.cna_node* %170, %struct.cna_node** %19, align 8, !dbg !359
  %171 = load %struct.cna_node*, %struct.cna_node** %19, align 8, !dbg !360
  %172 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %171, i32 0, i32 0, !dbg !361
  store i64 1, i64* %29, align 8, !dbg !362
  %173 = load i64, i64* %29, align 8, !dbg !362
  store atomic i64 %173, i64* %172 release, align 8, !dbg !362
  br label %174

174:                                              ; preds = %163, %136
  br label %175

175:                                              ; preds = %61, %92, %174, %122
  ret void, !dbg !363
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !364 {
  %1 = alloca i32, align 4
  %2 = alloca [4 x i64], align 16
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [4 x i64]* %2, metadata !365, metadata !DIExpression()), !dbg !369
  call void @llvm.dbg.declare(metadata i32* %3, metadata !370, metadata !DIExpression()), !dbg !372
  store i32 0, i32* %3, align 4, !dbg !372
  br label %5, !dbg !373

5:                                                ; preds = %16, %0
  %6 = load i32, i32* %3, align 4, !dbg !374
  %7 = icmp slt i32 %6, 4, !dbg !376
  br i1 %7, label %8, label %19, !dbg !377

8:                                                ; preds = %5
  %9 = load i32, i32* %3, align 4, !dbg !378
  %10 = sext i32 %9 to i64, !dbg !379
  %11 = getelementptr inbounds [4 x i64], [4 x i64]* %2, i64 0, i64 %10, !dbg !379
  %12 = load i32, i32* %3, align 4, !dbg !380
  %13 = sext i32 %12 to i64, !dbg !381
  %14 = inttoptr i64 %13 to i8*, !dbg !381
  %15 = call i32 @pthread_create(i64* noundef %11, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef %14) #6, !dbg !382
  br label %16, !dbg !382

16:                                               ; preds = %8
  %17 = load i32, i32* %3, align 4, !dbg !383
  %18 = add nsw i32 %17, 1, !dbg !383
  store i32 %18, i32* %3, align 4, !dbg !383
  br label %5, !dbg !384, !llvm.loop !385

19:                                               ; preds = %5
  call void @llvm.dbg.declare(metadata i32* %4, metadata !387, metadata !DIExpression()), !dbg !389
  store i32 0, i32* %4, align 4, !dbg !389
  br label %20, !dbg !390

20:                                               ; preds = %29, %19
  %21 = load i32, i32* %4, align 4, !dbg !391
  %22 = icmp slt i32 %21, 4, !dbg !393
  br i1 %22, label %23, label %32, !dbg !394

23:                                               ; preds = %20
  %24 = load i32, i32* %4, align 4, !dbg !395
  %25 = sext i32 %24 to i64, !dbg !396
  %26 = getelementptr inbounds [4 x i64], [4 x i64]* %2, i64 0, i64 %25, !dbg !396
  %27 = load i64, i64* %26, align 8, !dbg !396
  %28 = call i32 @pthread_join(i64 noundef %27, i8** noundef null), !dbg !397
  br label %29, !dbg !397

29:                                               ; preds = %23
  %30 = load i32, i32* %4, align 4, !dbg !398
  %31 = add nsw i32 %30, 1, !dbg !398
  store i32 %31, i32* %4, align 4, !dbg !398
  br label %20, !dbg !399, !llvm.loop !400

32:                                               ; preds = %20
  %33 = load i32, i32* @sum, align 4, !dbg !402
  %34 = icmp eq i32 %33, 4, !dbg !402
  br i1 %34, label %35, label %36, !dbg !405

35:                                               ; preds = %32
  br label %37, !dbg !405

36:                                               ; preds = %32
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([45 x i8], [45 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !402
  unreachable, !dbg !402

37:                                               ; preds = %35
  ret i32 0, !dbg !406
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #4

declare i32 @pthread_join(i64 noundef, i8** noundef) #1

declare void @__VERIFIER_loop_begin() #1

declare void @__VERIFIER_spin_start() #1

declare void @__VERIFIER_spin_end(i32 noundef) #1

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
!51 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 1024, elements: !52)
!52 = !{!53}
!53 = !DISubrange(count: 4)
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
!78 = !DILocation(line: 69, column: 40, scope: !74)
!79 = !DILocalVariable(name: "next", scope: !74, file: !18, line: 70, type: !16)
!80 = !DILocation(line: 70, column: 17, scope: !74)
!81 = !DILocation(line: 70, column: 46, scope: !74)
!82 = !DILocation(line: 70, column: 50, scope: !74)
!83 = !DILocation(line: 70, column: 24, scope: !74)
!84 = !DILocalVariable(name: "mySocket", scope: !74, file: !18, line: 71, type: !28)
!85 = !DILocation(line: 71, column: 9, scope: !74)
!86 = !DILocation(line: 71, column: 42, scope: !74)
!87 = !DILocation(line: 71, column: 46, scope: !74)
!88 = !DILocation(line: 71, column: 20, scope: !74)
!89 = !DILocation(line: 73, column: 9, scope: !90)
!90 = distinct !DILexicalBlock(scope: !74, file: !18, line: 73, column: 9)
!91 = !DILocation(line: 73, column: 18, scope: !90)
!92 = !DILocation(line: 73, column: 9, scope: !74)
!93 = !DILocation(line: 73, column: 36, scope: !90)
!94 = !DILocation(line: 73, column: 34, scope: !90)
!95 = !DILocation(line: 73, column: 25, scope: !90)
!96 = !DILocation(line: 74, column: 31, scope: !97)
!97 = distinct !DILexicalBlock(scope: !74, file: !18, line: 74, column: 9)
!98 = !DILocation(line: 74, column: 37, scope: !97)
!99 = !DILocation(line: 74, column: 9, scope: !97)
!100 = !DILocation(line: 74, column: 70, scope: !97)
!101 = !DILocation(line: 74, column: 67, scope: !97)
!102 = !DILocation(line: 74, column: 9, scope: !74)
!103 = !DILocation(line: 74, column: 87, scope: !97)
!104 = !DILocation(line: 74, column: 80, scope: !97)
!105 = !DILocalVariable(name: "secHead", scope: !74, file: !18, line: 76, type: !16)
!106 = !DILocation(line: 76, column: 17, scope: !74)
!107 = !DILocation(line: 76, column: 27, scope: !74)
!108 = !DILocalVariable(name: "secTail", scope: !74, file: !18, line: 77, type: !16)
!109 = !DILocation(line: 77, column: 17, scope: !74)
!110 = !DILocation(line: 77, column: 27, scope: !74)
!111 = !DILocalVariable(name: "cur", scope: !74, file: !18, line: 78, type: !16)
!112 = !DILocation(line: 78, column: 17, scope: !74)
!113 = !DILocation(line: 78, column: 45, scope: !74)
!114 = !DILocation(line: 78, column: 51, scope: !74)
!115 = !DILocation(line: 78, column: 23, scope: !74)
!116 = !DILocation(line: 80, column: 5, scope: !74)
!117 = !DILocation(line: 80, column: 11, scope: !74)
!118 = !DILocation(line: 81, column: 34, scope: !119)
!119 = distinct !DILexicalBlock(scope: !120, file: !18, line: 81, column: 12)
!120 = distinct !DILexicalBlock(scope: !74, file: !18, line: 80, column: 16)
!121 = !DILocation(line: 81, column: 39, scope: !119)
!122 = !DILocation(line: 81, column: 12, scope: !119)
!123 = !DILocation(line: 81, column: 72, scope: !119)
!124 = !DILocation(line: 81, column: 69, scope: !119)
!125 = !DILocation(line: 81, column: 12, scope: !120)
!126 = !DILocation(line: 82, column: 38, scope: !127)
!127 = distinct !DILexicalBlock(scope: !128, file: !18, line: 82, column: 16)
!128 = distinct !DILexicalBlock(scope: !119, file: !18, line: 81, column: 82)
!129 = !DILocation(line: 82, column: 42, scope: !127)
!130 = !DILocation(line: 82, column: 16, scope: !127)
!131 = !DILocation(line: 82, column: 70, scope: !127)
!132 = !DILocation(line: 82, column: 16, scope: !128)
!133 = !DILocalVariable(name: "_spin", scope: !134, file: !18, line: 83, type: !16)
!134 = distinct !DILexicalBlock(scope: !127, file: !18, line: 82, column: 75)
!135 = !DILocation(line: 83, column: 29, scope: !134)
!136 = !DILocation(line: 83, column: 73, scope: !134)
!137 = !DILocation(line: 83, column: 77, scope: !134)
!138 = !DILocation(line: 83, column: 51, scope: !134)
!139 = !DILocation(line: 83, column: 37, scope: !134)
!140 = !DILocalVariable(name: "_secTail", scope: !134, file: !18, line: 84, type: !16)
!141 = !DILocation(line: 84, column: 29, scope: !134)
!142 = !DILocation(line: 84, column: 62, scope: !134)
!143 = !DILocation(line: 84, column: 69, scope: !134)
!144 = !DILocation(line: 84, column: 40, scope: !134)
!145 = !DILocation(line: 85, column: 40, scope: !134)
!146 = !DILocation(line: 85, column: 50, scope: !134)
!147 = !DILocation(line: 85, column: 56, scope: !134)
!148 = !DILocation(line: 85, column: 17, scope: !134)
!149 = !DILocation(line: 86, column: 13, scope: !134)
!150 = !DILocation(line: 87, column: 40, scope: !151)
!151 = distinct !DILexicalBlock(scope: !127, file: !18, line: 86, column: 20)
!152 = !DILocation(line: 87, column: 44, scope: !151)
!153 = !DILocation(line: 87, column: 62, scope: !151)
!154 = !DILocation(line: 87, column: 50, scope: !151)
!155 = !DILocation(line: 87, column: 17, scope: !151)
!156 = !DILocation(line: 89, column: 36, scope: !128)
!157 = !DILocation(line: 89, column: 45, scope: !128)
!158 = !DILocation(line: 89, column: 13, scope: !128)
!159 = !DILocalVariable(name: "_spin", scope: !128, file: !18, line: 90, type: !16)
!160 = !DILocation(line: 90, column: 25, scope: !128)
!161 = !DILocation(line: 90, column: 69, scope: !128)
!162 = !DILocation(line: 90, column: 73, scope: !128)
!163 = !DILocation(line: 90, column: 47, scope: !128)
!164 = !DILocation(line: 90, column: 33, scope: !128)
!165 = !DILocation(line: 91, column: 36, scope: !128)
!166 = !DILocation(line: 91, column: 43, scope: !128)
!167 = !DILocation(line: 91, column: 52, scope: !128)
!168 = !DILocation(line: 91, column: 13, scope: !128)
!169 = !DILocation(line: 92, column: 20, scope: !128)
!170 = !DILocation(line: 92, column: 13, scope: !128)
!171 = !DILocation(line: 94, column: 19, scope: !120)
!172 = !DILocation(line: 94, column: 17, scope: !120)
!173 = !DILocation(line: 95, column: 37, scope: !120)
!174 = !DILocation(line: 95, column: 42, scope: !120)
!175 = !DILocation(line: 95, column: 15, scope: !120)
!176 = !DILocation(line: 95, column: 13, scope: !120)
!177 = distinct !{!177, !116, !178, !179}
!178 = !DILocation(line: 96, column: 5, scope: !74)
!179 = !{!"llvm.loop.mustprogress"}
!180 = !DILocation(line: 97, column: 5, scope: !74)
!181 = !DILocation(line: 98, column: 1, scope: !74)
!182 = distinct !DISubprogram(name: "thread_n", scope: !39, file: !39, line: 16, type: !183, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!183 = !DISubroutineType(types: !184)
!184 = !{!35, !35}
!185 = !DILocalVariable(name: "arg", arg: 1, scope: !182, file: !39, line: 16, type: !35)
!186 = !DILocation(line: 16, column: 22, scope: !182)
!187 = !DILocation(line: 18, column: 26, scope: !182)
!188 = !DILocation(line: 18, column: 15, scope: !182)
!189 = !DILocation(line: 18, column: 12, scope: !182)
!190 = !DILocation(line: 19, column: 27, scope: !182)
!191 = !DILocation(line: 19, column: 22, scope: !182)
!192 = !DILocation(line: 19, column: 5, scope: !182)
!193 = !DILocation(line: 20, column: 14, scope: !182)
!194 = !DILocation(line: 20, column: 12, scope: !182)
!195 = !DILocalVariable(name: "r", scope: !182, file: !39, line: 21, type: !28)
!196 = !DILocation(line: 21, column: 9, scope: !182)
!197 = !DILocation(line: 21, column: 13, scope: !182)
!198 = !DILocation(line: 22, column: 5, scope: !199)
!199 = distinct !DILexicalBlock(scope: !200, file: !39, line: 22, column: 5)
!200 = distinct !DILexicalBlock(scope: !182, file: !39, line: 22, column: 5)
!201 = !DILocation(line: 22, column: 5, scope: !200)
!202 = !DILocation(line: 23, column: 8, scope: !182)
!203 = !DILocation(line: 24, column: 29, scope: !182)
!204 = !DILocation(line: 24, column: 24, scope: !182)
!205 = !DILocation(line: 24, column: 5, scope: !182)
!206 = !DILocation(line: 25, column: 5, scope: !182)
!207 = distinct !DISubprogram(name: "cna_lock", scope: !18, file: !18, line: 100, type: !208, scopeLine: 101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !65)
!208 = !DISubroutineType(types: !209)
!209 = !{null, !210, !16}
!210 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!211 = !DILocalVariable(name: "lock", arg: 1, scope: !207, file: !18, line: 100, type: !210)
!212 = !DILocation(line: 100, column: 41, scope: !207)
!213 = !DILocalVariable(name: "me", arg: 2, scope: !207, file: !18, line: 100, type: !16)
!214 = !DILocation(line: 100, column: 59, scope: !207)
!215 = !DILocation(line: 102, column: 28, scope: !207)
!216 = !DILocation(line: 102, column: 32, scope: !207)
!217 = !DILocation(line: 102, column: 5, scope: !207)
!218 = !DILocation(line: 103, column: 28, scope: !207)
!219 = !DILocation(line: 103, column: 32, scope: !207)
!220 = !DILocation(line: 103, column: 5, scope: !207)
!221 = !DILocation(line: 104, column: 28, scope: !207)
!222 = !DILocation(line: 104, column: 32, scope: !207)
!223 = !DILocation(line: 104, column: 5, scope: !207)
!224 = !DILocalVariable(name: "tail", scope: !207, file: !18, line: 107, type: !16)
!225 = !DILocation(line: 107, column: 17, scope: !207)
!226 = !DILocation(line: 107, column: 50, scope: !207)
!227 = !DILocation(line: 107, column: 56, scope: !207)
!228 = !DILocation(line: 107, column: 62, scope: !207)
!229 = !DILocation(line: 107, column: 24, scope: !207)
!230 = !DILocation(line: 110, column: 9, scope: !231)
!231 = distinct !DILexicalBlock(scope: !207, file: !18, line: 110, column: 8)
!232 = !DILocation(line: 110, column: 8, scope: !207)
!233 = !DILocation(line: 111, column: 32, scope: !234)
!234 = distinct !DILexicalBlock(scope: !231, file: !18, line: 110, column: 15)
!235 = !DILocation(line: 111, column: 36, scope: !234)
!236 = !DILocation(line: 111, column: 9, scope: !234)
!237 = !DILocation(line: 112, column: 9, scope: !234)
!238 = !DILocation(line: 116, column: 28, scope: !207)
!239 = !DILocation(line: 116, column: 32, scope: !207)
!240 = !DILocation(line: 116, column: 40, scope: !207)
!241 = !DILocation(line: 116, column: 5, scope: !207)
!242 = !DILocation(line: 117, column: 28, scope: !207)
!243 = !DILocation(line: 117, column: 34, scope: !207)
!244 = !DILocation(line: 117, column: 40, scope: !207)
!245 = !DILocation(line: 117, column: 5, scope: !207)
!246 = !DILocalVariable(name: "tmp", scope: !247, file: !18, line: 120, type: !28)
!247 = distinct !DILexicalBlock(scope: !207, file: !18, line: 120, column: 5)
!248 = !DILocation(line: 120, column: 5, scope: !247)
!249 = !DILocation(line: 120, column: 5, scope: !250)
!250 = distinct !DILexicalBlock(scope: !247, file: !18, line: 120, column: 5)
!251 = distinct !{!251, !248, !252, !179}
!252 = !DILocation(line: 122, column: 5, scope: !247)
!253 = !DILocation(line: 123, column: 1, scope: !207)
!254 = distinct !DISubprogram(name: "cna_unlock", scope: !18, file: !18, line: 125, type: !208, scopeLine: 126, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !65)
!255 = !DILocalVariable(name: "lock", arg: 1, scope: !254, file: !18, line: 125, type: !210)
!256 = !DILocation(line: 125, column: 43, scope: !254)
!257 = !DILocalVariable(name: "me", arg: 2, scope: !254, file: !18, line: 125, type: !16)
!258 = !DILocation(line: 125, column: 61, scope: !254)
!259 = !DILocation(line: 128, column: 31, scope: !260)
!260 = distinct !DILexicalBlock(scope: !254, file: !18, line: 128, column: 8)
!261 = !DILocation(line: 128, column: 35, scope: !260)
!262 = !DILocation(line: 128, column: 9, scope: !260)
!263 = !DILocation(line: 128, column: 8, scope: !254)
!264 = !DILocation(line: 130, column: 34, scope: !265)
!265 = distinct !DILexicalBlock(scope: !266, file: !18, line: 130, column: 12)
!266 = distinct !DILexicalBlock(scope: !260, file: !18, line: 128, column: 60)
!267 = !DILocation(line: 130, column: 38, scope: !265)
!268 = !DILocation(line: 130, column: 12, scope: !265)
!269 = !DILocation(line: 130, column: 66, scope: !265)
!270 = !DILocation(line: 130, column: 12, scope: !266)
!271 = !DILocalVariable(name: "local_me", scope: !272, file: !18, line: 132, type: !16)
!272 = distinct !DILexicalBlock(scope: !265, file: !18, line: 130, column: 72)
!273 = !DILocation(line: 132, column: 25, scope: !272)
!274 = !DILocation(line: 132, column: 36, scope: !272)
!275 = !DILocation(line: 133, column: 57, scope: !276)
!276 = distinct !DILexicalBlock(scope: !272, file: !18, line: 133, column: 16)
!277 = !DILocation(line: 133, column: 63, scope: !276)
!278 = !DILocation(line: 133, column: 16, scope: !276)
!279 = !DILocation(line: 133, column: 16, scope: !272)
!280 = !DILocation(line: 134, column: 17, scope: !281)
!281 = distinct !DILexicalBlock(scope: !276, file: !18, line: 133, column: 131)
!282 = !DILocation(line: 136, column: 9, scope: !272)
!283 = !DILocalVariable(name: "secHead", scope: !284, file: !18, line: 138, type: !16)
!284 = distinct !DILexicalBlock(scope: !265, file: !18, line: 136, column: 16)
!285 = !DILocation(line: 138, column: 25, scope: !284)
!286 = !DILocation(line: 138, column: 72, scope: !284)
!287 = !DILocation(line: 138, column: 76, scope: !284)
!288 = !DILocation(line: 138, column: 50, scope: !284)
!289 = !DILocation(line: 138, column: 35, scope: !284)
!290 = !DILocalVariable(name: "local_me", scope: !284, file: !18, line: 139, type: !16)
!291 = !DILocation(line: 139, column: 25, scope: !284)
!292 = !DILocation(line: 139, column: 36, scope: !284)
!293 = !DILocation(line: 140, column: 57, scope: !294)
!294 = distinct !DILexicalBlock(scope: !284, file: !18, line: 140, column: 16)
!295 = !DILocation(line: 140, column: 63, scope: !294)
!296 = !DILocation(line: 141, column: 39, scope: !294)
!297 = !DILocation(line: 141, column: 48, scope: !294)
!298 = !DILocation(line: 141, column: 17, scope: !294)
!299 = !DILocation(line: 140, column: 16, scope: !294)
!300 = !DILocation(line: 140, column: 16, scope: !284)
!301 = !DILocation(line: 144, column: 40, scope: !302)
!302 = distinct !DILexicalBlock(scope: !294, file: !18, line: 142, column: 62)
!303 = !DILocation(line: 144, column: 49, scope: !302)
!304 = !DILocation(line: 144, column: 17, scope: !302)
!305 = !DILocation(line: 145, column: 17, scope: !302)
!306 = !DILocalVariable(name: "tmp", scope: !307, file: !18, line: 149, type: !28)
!307 = distinct !DILexicalBlock(scope: !266, file: !18, line: 149, column: 9)
!308 = !DILocation(line: 149, column: 9, scope: !307)
!309 = !DILocation(line: 149, column: 9, scope: !310)
!310 = distinct !DILexicalBlock(scope: !307, file: !18, line: 149, column: 9)
!311 = distinct !{!311, !308, !312, !179}
!312 = !DILocation(line: 151, column: 9, scope: !307)
!313 = !DILocation(line: 152, column: 5, scope: !266)
!314 = !DILocalVariable(name: "succ", scope: !254, file: !18, line: 154, type: !16)
!315 = !DILocation(line: 154, column: 17, scope: !254)
!316 = !DILocation(line: 155, column: 9, scope: !317)
!317 = distinct !DILexicalBlock(scope: !254, file: !18, line: 155, column: 9)
!318 = !DILocation(line: 155, column: 27, scope: !317)
!319 = !DILocation(line: 155, column: 53, scope: !317)
!320 = !DILocation(line: 155, column: 38, scope: !317)
!321 = !DILocation(line: 155, column: 36, scope: !317)
!322 = !DILocation(line: 155, column: 9, scope: !254)
!323 = !DILocation(line: 156, column: 32, scope: !324)
!324 = distinct !DILexicalBlock(scope: !317, file: !18, line: 155, column: 59)
!325 = !DILocation(line: 156, column: 38, scope: !324)
!326 = !DILocation(line: 157, column: 35, scope: !324)
!327 = !DILocation(line: 157, column: 39, scope: !324)
!328 = !DILocation(line: 157, column: 13, scope: !324)
!329 = !DILocation(line: 156, column: 9, scope: !324)
!330 = !DILocation(line: 159, column: 5, scope: !324)
!331 = !DILocation(line: 159, column: 37, scope: !332)
!332 = distinct !DILexicalBlock(scope: !317, file: !18, line: 159, column: 15)
!333 = !DILocation(line: 159, column: 41, scope: !332)
!334 = !DILocation(line: 159, column: 15, scope: !332)
!335 = !DILocation(line: 159, column: 69, scope: !332)
!336 = !DILocation(line: 159, column: 15, scope: !317)
!337 = !DILocation(line: 160, column: 53, scope: !338)
!338 = distinct !DILexicalBlock(scope: !332, file: !18, line: 159, column: 74)
!339 = !DILocation(line: 160, column: 57, scope: !338)
!340 = !DILocation(line: 160, column: 31, scope: !338)
!341 = !DILocation(line: 160, column: 16, scope: !338)
!342 = !DILocation(line: 160, column: 14, scope: !338)
!343 = !DILocation(line: 162, column: 51, scope: !338)
!344 = !DILocation(line: 162, column: 57, scope: !338)
!345 = !DILocation(line: 162, column: 29, scope: !338)
!346 = !DILocation(line: 162, column: 90, scope: !338)
!347 = !DILocation(line: 163, column: 35, scope: !338)
!348 = !DILocation(line: 163, column: 39, scope: !338)
!349 = !DILocation(line: 163, column: 13, scope: !338)
!350 = !DILocation(line: 161, column: 9, scope: !338)
!351 = !DILocation(line: 165, column: 32, scope: !338)
!352 = !DILocation(line: 165, column: 38, scope: !338)
!353 = !DILocation(line: 165, column: 9, scope: !338)
!354 = !DILocation(line: 166, column: 5, scope: !338)
!355 = !DILocation(line: 167, column: 52, scope: !356)
!356 = distinct !DILexicalBlock(scope: !332, file: !18, line: 166, column: 12)
!357 = !DILocation(line: 167, column: 56, scope: !356)
!358 = !DILocation(line: 167, column: 30, scope: !356)
!359 = !DILocation(line: 167, column: 14, scope: !356)
!360 = !DILocation(line: 168, column: 32, scope: !356)
!361 = !DILocation(line: 168, column: 38, scope: !356)
!362 = !DILocation(line: 168, column: 9, scope: !356)
!363 = !DILocation(line: 170, column: 1, scope: !254)
!364 = distinct !DISubprogram(name: "main", scope: !39, file: !39, line: 28, type: !63, scopeLine: 29, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!365 = !DILocalVariable(name: "t", scope: !364, file: !39, line: 30, type: !366)
!366 = !DICompositeType(tag: DW_TAG_array_type, baseType: !367, size: 256, elements: !52)
!367 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !368, line: 27, baseType: !25)
!368 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!369 = !DILocation(line: 30, column: 15, scope: !364)
!370 = !DILocalVariable(name: "i", scope: !371, file: !39, line: 32, type: !28)
!371 = distinct !DILexicalBlock(scope: !364, file: !39, line: 32, column: 5)
!372 = !DILocation(line: 32, column: 14, scope: !371)
!373 = !DILocation(line: 32, column: 10, scope: !371)
!374 = !DILocation(line: 32, column: 21, scope: !375)
!375 = distinct !DILexicalBlock(scope: !371, file: !39, line: 32, column: 5)
!376 = !DILocation(line: 32, column: 23, scope: !375)
!377 = !DILocation(line: 32, column: 5, scope: !371)
!378 = !DILocation(line: 33, column: 27, scope: !375)
!379 = !DILocation(line: 33, column: 25, scope: !375)
!380 = !DILocation(line: 33, column: 52, scope: !375)
!381 = !DILocation(line: 33, column: 44, scope: !375)
!382 = !DILocation(line: 33, column: 9, scope: !375)
!383 = !DILocation(line: 32, column: 36, scope: !375)
!384 = !DILocation(line: 32, column: 5, scope: !375)
!385 = distinct !{!385, !377, !386, !179}
!386 = !DILocation(line: 33, column: 53, scope: !371)
!387 = !DILocalVariable(name: "i", scope: !388, file: !39, line: 35, type: !28)
!388 = distinct !DILexicalBlock(scope: !364, file: !39, line: 35, column: 5)
!389 = !DILocation(line: 35, column: 14, scope: !388)
!390 = !DILocation(line: 35, column: 10, scope: !388)
!391 = !DILocation(line: 35, column: 21, scope: !392)
!392 = distinct !DILexicalBlock(scope: !388, file: !39, line: 35, column: 5)
!393 = !DILocation(line: 35, column: 23, scope: !392)
!394 = !DILocation(line: 35, column: 5, scope: !388)
!395 = !DILocation(line: 36, column: 24, scope: !392)
!396 = !DILocation(line: 36, column: 22, scope: !392)
!397 = !DILocation(line: 36, column: 9, scope: !392)
!398 = !DILocation(line: 35, column: 36, scope: !392)
!399 = !DILocation(line: 35, column: 5, scope: !392)
!400 = distinct !{!400, !394, !401, !179}
!401 = !DILocation(line: 36, column: 29, scope: !388)
!402 = !DILocation(line: 38, column: 5, scope: !403)
!403 = distinct !DILexicalBlock(scope: !404, file: !39, line: 38, column: 5)
!404 = distinct !DILexicalBlock(scope: !364, file: !39, line: 38, column: 5)
!405 = !DILocation(line: 38, column: 5, scope: !404)
!406 = !DILocation(line: 40, column: 5, scope: !364)
