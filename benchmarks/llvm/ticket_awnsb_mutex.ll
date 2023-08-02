; ModuleID = '/home/ponce/git/Dat3M/benchmarks/locks/ticket_awnsb_mutex.c'
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
  %3 = alloca %struct.ticket_awnsb_mutex_t*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.ticket_awnsb_mutex_t* %0, %struct.ticket_awnsb_mutex_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.ticket_awnsb_mutex_t** %3, metadata !68, metadata !DIExpression()), !dbg !69
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !70, metadata !DIExpression()), !dbg !71
  %6 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8, !dbg !72
  %7 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %6, i32 0, i32 0, !dbg !73
  store i32 0, i32* %7, align 4, !dbg !74
  %8 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8, !dbg !75
  %9 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %8, i32 0, i32 2, !dbg !76
  store i32 0, i32* %9, align 4, !dbg !77
  %10 = load i32, i32* %4, align 4, !dbg !78
  %11 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8, !dbg !79
  %12 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %11, i32 0, i32 4, !dbg !80
  store i32 %10, i32* %12, align 8, !dbg !81
  %13 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8, !dbg !82
  %14 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %13, i32 0, i32 4, !dbg !83
  %15 = load i32, i32* %14, align 8, !dbg !83
  %16 = sext i32 %15 to i64, !dbg !82
  %17 = mul i64 %16, 8, !dbg !84
  %18 = call noalias i8* @malloc(i64 noundef %17) #5, !dbg !85
  %19 = bitcast i8* %18 to %struct.awnsb_node_t.0**, !dbg !86
  %20 = bitcast %struct.awnsb_node_t.0** %19 to %struct.awnsb_node_t**, !dbg !86
  %21 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8, !dbg !87
  %22 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %21, i32 0, i32 5, !dbg !88
  store %struct.awnsb_node_t** %20, %struct.awnsb_node_t*** %22, align 8, !dbg !89
  call void @__VERIFIER_loop_bound(i32 noundef 4), !dbg !90
  call void @llvm.dbg.declare(metadata i32* %5, metadata !91, metadata !DIExpression()), !dbg !93
  store i32 0, i32* %5, align 4, !dbg !93
  br label %23, !dbg !94

23:                                               ; preds = %37, %2
  %24 = load i32, i32* %5, align 4, !dbg !95
  %25 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8, !dbg !97
  %26 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %25, i32 0, i32 4, !dbg !98
  %27 = load i32, i32* %26, align 8, !dbg !98
  %28 = icmp slt i32 %24, %27, !dbg !99
  br i1 %28, label %29, label %40, !dbg !100

29:                                               ; preds = %23
  %30 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8, !dbg !101
  %31 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %30, i32 0, i32 5, !dbg !102
  %32 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %31, align 8, !dbg !102
  %33 = load i32, i32* %5, align 4, !dbg !103
  %34 = sext i32 %33 to i64, !dbg !101
  %35 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %32, i64 %34, !dbg !101
  %36 = bitcast %struct.awnsb_node_t** %35 to i64*, !dbg !104
  store atomic i64 0, i64* %36 seq_cst, align 8, !dbg !104
  br label %37, !dbg !101

37:                                               ; preds = %29
  %38 = load i32, i32* %5, align 4, !dbg !105
  %39 = add nsw i32 %38, 1, !dbg !105
  store i32 %39, i32* %5, align 4, !dbg !105
  br label %23, !dbg !106, !llvm.loop !107

40:                                               ; preds = %23
  ret void, !dbg !110
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #2

declare void @__VERIFIER_loop_bound(i32 noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @ticket_awnsb_mutex_destroy(%struct.ticket_awnsb_mutex_t* noundef %0) #0 !dbg !111 {
  %2 = alloca %struct.ticket_awnsb_mutex_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %struct.ticket_awnsb_mutex_t* %0, %struct.ticket_awnsb_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.ticket_awnsb_mutex_t** %2, metadata !114, metadata !DIExpression()), !dbg !115
  %5 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !116
  %6 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %5, i32 0, i32 0, !dbg !116
  store i32 0, i32* %3, align 4, !dbg !116
  %7 = load i32, i32* %3, align 4, !dbg !116
  store atomic i32 %7, i32* %6 seq_cst, align 8, !dbg !116
  %8 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !117
  %9 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %8, i32 0, i32 2, !dbg !117
  store i32 0, i32* %4, align 4, !dbg !117
  %10 = load i32, i32* %4, align 4, !dbg !117
  store atomic i32 %10, i32* %9 seq_cst, align 4, !dbg !117
  %11 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !118
  %12 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %11, i32 0, i32 5, !dbg !119
  %13 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %12, align 8, !dbg !119
  %14 = bitcast %struct.awnsb_node_t** %13 to i8*, !dbg !118
  call void @free(i8* noundef %14) #5, !dbg !120
  ret void, !dbg !121
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @ticket_awnsb_mutex_lock(%struct.ticket_awnsb_mutex_t* noundef %0) #0 !dbg !122 {
  %2 = alloca %struct.ticket_awnsb_mutex_t*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca %struct.awnsb_node_t.0*, align 8
  %11 = alloca i32, align 4
  %12 = alloca %struct.awnsb_node_t*, align 8
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca i32, align 4
  store %struct.ticket_awnsb_mutex_t* %0, %struct.ticket_awnsb_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.ticket_awnsb_mutex_t** %2, metadata !123, metadata !DIExpression()), !dbg !124
  call void @llvm.dbg.declare(metadata i64* %3, metadata !125, metadata !DIExpression()), !dbg !128
  %19 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !129
  %20 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %19, i32 0, i32 0, !dbg !130
  store i32 1, i32* %4, align 4, !dbg !131
  %21 = load i32, i32* %4, align 4, !dbg !131
  %22 = atomicrmw add i32* %20, i32 %21 monotonic, align 4, !dbg !131
  store i32 %22, i32* %5, align 4, !dbg !131
  %23 = load i32, i32* %5, align 4, !dbg !131
  %24 = sext i32 %23 to i64, !dbg !131
  store i64 %24, i64* %3, align 8, !dbg !128
  %25 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !132
  %26 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %25, i32 0, i32 2, !dbg !134
  %27 = load atomic i32, i32* %26 acquire, align 4, !dbg !135
  store i32 %27, i32* %6, align 4, !dbg !135
  %28 = load i32, i32* %6, align 4, !dbg !135
  %29 = sext i32 %28 to i64, !dbg !135
  %30 = load i64, i64* %3, align 8, !dbg !136
  %31 = icmp eq i64 %29, %30, !dbg !137
  br i1 %31, label %32, label %33, !dbg !138

32:                                               ; preds = %1
  br label %136, !dbg !139

33:                                               ; preds = %1
  br label %34, !dbg !140

34:                                               ; preds = %52, %33
  %35 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !141
  %36 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %35, i32 0, i32 2, !dbg !142
  %37 = load atomic i32, i32* %36 monotonic, align 4, !dbg !143
  store i32 %37, i32* %7, align 4, !dbg !143
  %38 = load i32, i32* %7, align 4, !dbg !143
  %39 = sext i32 %38 to i64, !dbg !143
  %40 = load i64, i64* %3, align 8, !dbg !144
  %41 = sub nsw i64 %40, 1, !dbg !145
  %42 = icmp sge i64 %39, %41, !dbg !146
  br i1 %42, label %43, label %53, !dbg !140

43:                                               ; preds = %34
  %44 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !147
  %45 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %44, i32 0, i32 2, !dbg !150
  %46 = load atomic i32, i32* %45 acquire, align 4, !dbg !151
  store i32 %46, i32* %8, align 4, !dbg !151
  %47 = load i32, i32* %8, align 4, !dbg !151
  %48 = sext i32 %47 to i64, !dbg !151
  %49 = load i64, i64* %3, align 8, !dbg !152
  %50 = icmp eq i64 %48, %49, !dbg !153
  br i1 %50, label %51, label %52, !dbg !154

51:                                               ; preds = %43
  br label %136, !dbg !155

52:                                               ; preds = %43
  br label %34, !dbg !140, !llvm.loop !156

53:                                               ; preds = %34
  br label %54, !dbg !158

54:                                               ; preds = %68, %53
  %55 = load i64, i64* %3, align 8, !dbg !159
  %56 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !160
  %57 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %56, i32 0, i32 2, !dbg !161
  %58 = load atomic i32, i32* %57 monotonic, align 4, !dbg !162
  store i32 %58, i32* %9, align 4, !dbg !162
  %59 = load i32, i32* %9, align 4, !dbg !162
  %60 = sext i32 %59 to i64, !dbg !162
  %61 = sub nsw i64 %55, %60, !dbg !163
  %62 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !164
  %63 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %62, i32 0, i32 4, !dbg !165
  %64 = load i32, i32* %63, align 8, !dbg !165
  %65 = sub nsw i32 %64, 1, !dbg !166
  %66 = sext i32 %65 to i64, !dbg !167
  %67 = icmp sge i64 %61, %66, !dbg !168
  br i1 %67, label %68, label %69, !dbg !158

68:                                               ; preds = %54
  br label %54, !dbg !158, !llvm.loop !169

69:                                               ; preds = %54
  call void @llvm.dbg.declare(metadata %struct.awnsb_node_t.0** %10, metadata !171, metadata !DIExpression()), !dbg !172
  store %struct.awnsb_node_t.0* @tlNode, %struct.awnsb_node_t.0** %10, align 8, !dbg !172
  %70 = load %struct.awnsb_node_t.0*, %struct.awnsb_node_t.0** %10, align 8, !dbg !173
  %71 = getelementptr inbounds %struct.awnsb_node_t.0, %struct.awnsb_node_t.0* %70, i32 0, i32 0, !dbg !174
  store i32 0, i32* %11, align 4, !dbg !175
  %72 = load i32, i32* %11, align 4, !dbg !175
  store atomic i32 %72, i32* %71 monotonic, align 4, !dbg !175
  %73 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !176
  %74 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %73, i32 0, i32 5, !dbg !177
  %75 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %74, align 8, !dbg !177
  %76 = load i64, i64* %3, align 8, !dbg !178
  %77 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !179
  %78 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %77, i32 0, i32 4, !dbg !180
  %79 = load i32, i32* %78, align 8, !dbg !180
  %80 = sext i32 %79 to i64, !dbg !179
  %81 = srem i64 %76, %80, !dbg !181
  %82 = trunc i64 %81 to i32, !dbg !182
  %83 = sext i32 %82 to i64, !dbg !176
  %84 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %75, i64 %83, !dbg !176
  %85 = load %struct.awnsb_node_t.0*, %struct.awnsb_node_t.0** %10, align 8, !dbg !183
  %86 = bitcast %struct.awnsb_node_t.0* %85 to %struct.awnsb_node_t*, !dbg !183
  store %struct.awnsb_node_t* %86, %struct.awnsb_node_t** %12, align 8, !dbg !184
  %87 = bitcast %struct.awnsb_node_t** %84 to i64*, !dbg !184
  %88 = bitcast %struct.awnsb_node_t** %12 to i64*, !dbg !184
  %89 = load i64, i64* %88, align 8, !dbg !184
  store atomic i64 %89, i64* %87 release, align 8, !dbg !184
  %90 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !185
  %91 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %90, i32 0, i32 2, !dbg !187
  %92 = load atomic i32, i32* %91 monotonic, align 4, !dbg !188
  store i32 %92, i32* %13, align 4, !dbg !188
  %93 = load i32, i32* %13, align 4, !dbg !188
  %94 = sext i32 %93 to i64, !dbg !188
  %95 = load i64, i64* %3, align 8, !dbg !189
  %96 = sub nsw i64 %95, 1, !dbg !190
  %97 = icmp slt i64 %94, %96, !dbg !191
  br i1 %97, label %98, label %113, !dbg !192

98:                                               ; preds = %69
  br label %99, !dbg !193

99:                                               ; preds = %106, %98
  %100 = load %struct.awnsb_node_t.0*, %struct.awnsb_node_t.0** %10, align 8, !dbg !195
  %101 = getelementptr inbounds %struct.awnsb_node_t.0, %struct.awnsb_node_t.0* %100, i32 0, i32 0, !dbg !196
  %102 = load atomic i32, i32* %101 monotonic, align 4, !dbg !197
  store i32 %102, i32* %14, align 4, !dbg !197
  %103 = load i32, i32* %14, align 4, !dbg !197
  %104 = icmp ne i32 %103, 0, !dbg !198
  %105 = xor i1 %104, true, !dbg !198
  br i1 %105, label %106, label %107, !dbg !193

106:                                              ; preds = %99
  br label %99, !dbg !193, !llvm.loop !199

107:                                              ; preds = %99
  %108 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !201
  %109 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %108, i32 0, i32 2, !dbg !202
  %110 = load i64, i64* %3, align 8, !dbg !203
  %111 = trunc i64 %110 to i32, !dbg !203
  store i32 %111, i32* %15, align 4, !dbg !204
  %112 = load i32, i32* %15, align 4, !dbg !204
  store atomic i32 %112, i32* %109 monotonic, align 4, !dbg !204
  br label %136, !dbg !205

113:                                              ; preds = %69
  br label %114, !dbg !206

114:                                              ; preds = %134, %113
  %115 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !208
  %116 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %115, i32 0, i32 2, !dbg !209
  %117 = load atomic i32, i32* %116 acquire, align 4, !dbg !210
  store i32 %117, i32* %16, align 4, !dbg !210
  %118 = load i32, i32* %16, align 4, !dbg !210
  %119 = sext i32 %118 to i64, !dbg !210
  %120 = load i64, i64* %3, align 8, !dbg !211
  %121 = icmp ne i64 %119, %120, !dbg !212
  br i1 %121, label %122, label %135, !dbg !206

122:                                              ; preds = %114
  %123 = load %struct.awnsb_node_t.0*, %struct.awnsb_node_t.0** %10, align 8, !dbg !213
  %124 = getelementptr inbounds %struct.awnsb_node_t.0, %struct.awnsb_node_t.0* %123, i32 0, i32 0, !dbg !216
  %125 = load atomic i32, i32* %124 acquire, align 4, !dbg !217
  store i32 %125, i32* %17, align 4, !dbg !217
  %126 = load i32, i32* %17, align 4, !dbg !217
  %127 = icmp ne i32 %126, 0, !dbg !217
  br i1 %127, label %128, label %134, !dbg !218

128:                                              ; preds = %122
  %129 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !219
  %130 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %129, i32 0, i32 2, !dbg !221
  %131 = load i64, i64* %3, align 8, !dbg !222
  %132 = trunc i64 %131 to i32, !dbg !222
  store i32 %132, i32* %18, align 4, !dbg !223
  %133 = load i32, i32* %18, align 4, !dbg !223
  store atomic i32 %133, i32* %130 monotonic, align 4, !dbg !223
  br label %136, !dbg !224

134:                                              ; preds = %122
  br label %114, !dbg !206, !llvm.loop !225

135:                                              ; preds = %114
  br label %136

136:                                              ; preds = %32, %51, %128, %135, %107
  ret void, !dbg !227
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @ticket_awnsb_mutex_unlock(%struct.ticket_awnsb_mutex_t* noundef %0) #0 !dbg !228 {
  %2 = alloca %struct.ticket_awnsb_mutex_t*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  %5 = alloca %struct.awnsb_node_t*, align 8
  %6 = alloca %struct.awnsb_node_t.0*, align 8
  %7 = alloca %struct.awnsb_node_t*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store %struct.ticket_awnsb_mutex_t* %0, %struct.ticket_awnsb_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.ticket_awnsb_mutex_t** %2, metadata !229, metadata !DIExpression()), !dbg !230
  call void @llvm.dbg.declare(metadata i64* %3, metadata !231, metadata !DIExpression()), !dbg !232
  %10 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !233
  %11 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %10, i32 0, i32 2, !dbg !234
  %12 = load atomic i32, i32* %11 monotonic, align 4, !dbg !235
  store i32 %12, i32* %4, align 4, !dbg !235
  %13 = load i32, i32* %4, align 4, !dbg !235
  %14 = sext i32 %13 to i64, !dbg !235
  store i64 %14, i64* %3, align 8, !dbg !232
  %15 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !236
  %16 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %15, i32 0, i32 5, !dbg !237
  %17 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %16, align 8, !dbg !237
  %18 = load i64, i64* %3, align 8, !dbg !238
  %19 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !239
  %20 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %19, i32 0, i32 4, !dbg !240
  %21 = load i32, i32* %20, align 8, !dbg !240
  %22 = sext i32 %21 to i64, !dbg !239
  %23 = srem i64 %18, %22, !dbg !241
  %24 = trunc i64 %23 to i32, !dbg !242
  %25 = sext i32 %24 to i64, !dbg !236
  %26 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %17, i64 %25, !dbg !236
  store %struct.awnsb_node_t* null, %struct.awnsb_node_t** %5, align 8, !dbg !243
  %27 = bitcast %struct.awnsb_node_t** %26 to i64*, !dbg !243
  %28 = bitcast %struct.awnsb_node_t** %5 to i64*, !dbg !243
  %29 = load i64, i64* %28, align 8, !dbg !243
  store atomic i64 %29, i64* %27 monotonic, align 8, !dbg !243
  call void @llvm.dbg.declare(metadata %struct.awnsb_node_t.0** %6, metadata !244, metadata !DIExpression()), !dbg !245
  %30 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !246
  %31 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %30, i32 0, i32 5, !dbg !247
  %32 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %31, align 8, !dbg !247
  %33 = load i64, i64* %3, align 8, !dbg !248
  %34 = add nsw i64 %33, 1, !dbg !249
  %35 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !250
  %36 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %35, i32 0, i32 4, !dbg !251
  %37 = load i32, i32* %36, align 8, !dbg !251
  %38 = sext i32 %37 to i64, !dbg !250
  %39 = srem i64 %34, %38, !dbg !252
  %40 = trunc i64 %39 to i32, !dbg !253
  %41 = sext i32 %40 to i64, !dbg !246
  %42 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %32, i64 %41, !dbg !246
  %43 = bitcast %struct.awnsb_node_t** %42 to i64*, !dbg !254
  %44 = bitcast %struct.awnsb_node_t** %7 to i64*, !dbg !254
  %45 = load atomic i64, i64* %43 acquire, align 8, !dbg !254
  store i64 %45, i64* %44, align 8, !dbg !254
  %46 = bitcast i64* %44 to %struct.awnsb_node_t**, !dbg !254
  %47 = load %struct.awnsb_node_t*, %struct.awnsb_node_t** %46, align 8, !dbg !254
  %48 = bitcast %struct.awnsb_node_t* %47 to %struct.awnsb_node_t.0*, !dbg !254
  store %struct.awnsb_node_t.0* %48, %struct.awnsb_node_t.0** %6, align 8, !dbg !245
  %49 = load %struct.awnsb_node_t.0*, %struct.awnsb_node_t.0** %6, align 8, !dbg !255
  %50 = icmp ne %struct.awnsb_node_t.0* %49, null, !dbg !257
  br i1 %50, label %51, label %55, !dbg !258

51:                                               ; preds = %1
  %52 = load %struct.awnsb_node_t.0*, %struct.awnsb_node_t.0** %6, align 8, !dbg !259
  %53 = getelementptr inbounds %struct.awnsb_node_t.0, %struct.awnsb_node_t.0* %52, i32 0, i32 0, !dbg !261
  store i32 1, i32* %8, align 4, !dbg !262
  %54 = load i32, i32* %8, align 4, !dbg !262
  store atomic i32 %54, i32* %53 release, align 4, !dbg !262
  br label %62, !dbg !263

55:                                               ; preds = %1
  %56 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8, !dbg !264
  %57 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %56, i32 0, i32 2, !dbg !266
  %58 = load i64, i64* %3, align 8, !dbg !267
  %59 = add nsw i64 %58, 1, !dbg !268
  %60 = trunc i64 %59 to i32, !dbg !267
  store i32 %60, i32* %9, align 4, !dbg !269
  %61 = load i32, i32* %9, align 4, !dbg !269
  store atomic i32 %61, i32* %57 release, align 4, !dbg !269
  br label %62

62:                                               ; preds = %55, %51
  ret void, !dbg !270
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @ticket_awnsb_mutex_trylock(%struct.ticket_awnsb_mutex_t* noundef %0) #0 !dbg !271 {
  %2 = alloca i32, align 4
  %3 = alloca %struct.ticket_awnsb_mutex_t*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  %6 = alloca i64, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i8, align 1
  store %struct.ticket_awnsb_mutex_t* %0, %struct.ticket_awnsb_mutex_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.ticket_awnsb_mutex_t** %3, metadata !274, metadata !DIExpression()), !dbg !275
  call void @llvm.dbg.declare(metadata i64* %4, metadata !276, metadata !DIExpression()), !dbg !277
  %10 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8, !dbg !278
  %11 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %10, i32 0, i32 2, !dbg !278
  %12 = load atomic i32, i32* %11 seq_cst, align 4, !dbg !278
  store i32 %12, i32* %5, align 4, !dbg !278
  %13 = load i32, i32* %5, align 4, !dbg !278
  %14 = sext i32 %13 to i64, !dbg !278
  store i64 %14, i64* %4, align 8, !dbg !277
  call void @llvm.dbg.declare(metadata i64* %6, metadata !279, metadata !DIExpression()), !dbg !280
  %15 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8, !dbg !281
  %16 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %15, i32 0, i32 0, !dbg !282
  %17 = load atomic i32, i32* %16 monotonic, align 8, !dbg !283
  store i32 %17, i32* %7, align 4, !dbg !283
  %18 = load i32, i32* %7, align 4, !dbg !283
  %19 = sext i32 %18 to i64, !dbg !283
  store i64 %19, i64* %6, align 8, !dbg !280
  %20 = load i64, i64* %4, align 8, !dbg !284
  %21 = load i64, i64* %6, align 8, !dbg !286
  %22 = icmp ne i64 %20, %21, !dbg !287
  br i1 %22, label %23, label %24, !dbg !288

23:                                               ; preds = %1
  store i32 16, i32* %2, align 4, !dbg !289
  br label %44, !dbg !289

24:                                               ; preds = %1
  %25 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8, !dbg !290
  %26 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %25, i32 0, i32 0, !dbg !290
  %27 = bitcast i64* %6 to i32*, !dbg !290
  %28 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8, !dbg !290
  %29 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %28, i32 0, i32 0, !dbg !290
  %30 = load atomic i32, i32* %29 seq_cst, align 4, !dbg !290
  %31 = add nsw i32 %30, 1, !dbg !290
  store i32 %31, i32* %8, align 4, !dbg !290
  %32 = load i32, i32* %27, align 8, !dbg !290
  %33 = load i32, i32* %8, align 4, !dbg !290
  %34 = cmpxchg i32* %26, i32 %32, i32 %33 seq_cst seq_cst, align 4, !dbg !290
  %35 = extractvalue { i32, i1 } %34, 0, !dbg !290
  %36 = extractvalue { i32, i1 } %34, 1, !dbg !290
  br i1 %36, label %38, label %37, !dbg !290

37:                                               ; preds = %24
  store i32 %35, i32* %27, align 8, !dbg !290
  br label %38, !dbg !290

38:                                               ; preds = %37, %24
  %39 = zext i1 %36 to i8, !dbg !290
  store i8 %39, i8* %9, align 1, !dbg !290
  %40 = load i8, i8* %9, align 1, !dbg !290
  %41 = trunc i8 %40 to i1, !dbg !290
  br i1 %41, label %43, label %42, !dbg !292

42:                                               ; preds = %38
  store i32 16, i32* %2, align 4, !dbg !293
  br label %44, !dbg !293

43:                                               ; preds = %38
  store i32 0, i32* %2, align 4, !dbg !294
  br label %44, !dbg !294

44:                                               ; preds = %43, %42, %23
  %45 = load i32, i32* %2, align 4, !dbg !295
  ret i32 %45, !dbg !295
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !296 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !299, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.declare(metadata i64* %3, metadata !301, metadata !DIExpression()), !dbg !302
  %5 = load i8*, i8** %2, align 8, !dbg !303
  %6 = ptrtoint i8* %5 to i64, !dbg !304
  store i64 %6, i64* %3, align 8, !dbg !302
  call void @ticket_awnsb_mutex_lock(%struct.ticket_awnsb_mutex_t* noundef @lock), !dbg !305
  %7 = load i64, i64* %3, align 8, !dbg !306
  %8 = trunc i64 %7 to i32, !dbg !306
  store i32 %8, i32* @shared, align 4, !dbg !307
  call void @llvm.dbg.declare(metadata i32* %4, metadata !308, metadata !DIExpression()), !dbg !309
  %9 = load i32, i32* @shared, align 4, !dbg !310
  store i32 %9, i32* %4, align 4, !dbg !309
  %10 = load i32, i32* %4, align 4, !dbg !311
  %11 = sext i32 %10 to i64, !dbg !311
  %12 = load i64, i64* %3, align 8, !dbg !311
  %13 = icmp eq i64 %11, %12, !dbg !311
  br i1 %13, label %14, label %15, !dbg !314

14:                                               ; preds = %1
  br label %16, !dbg !314

15:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #6, !dbg !311
  unreachable, !dbg !311

16:                                               ; preds = %14
  %17 = load i32, i32* @sum, align 4, !dbg !315
  %18 = add nsw i32 %17, 1, !dbg !315
  store i32 %18, i32* @sum, align 4, !dbg !315
  call void @ticket_awnsb_mutex_unlock(%struct.ticket_awnsb_mutex_t* noundef @lock), !dbg !316
  ret i8* null, !dbg !317
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !318 {
  %1 = alloca i32, align 4
  %2 = alloca [5 x i64], align 16
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [5 x i64]* %2, metadata !321, metadata !DIExpression()), !dbg !328
  call void @ticket_awnsb_mutex_init(%struct.ticket_awnsb_mutex_t* noundef @lock, i32 noundef 3), !dbg !329
  call void @llvm.dbg.declare(metadata i32* %3, metadata !330, metadata !DIExpression()), !dbg !332
  store i32 0, i32* %3, align 4, !dbg !332
  br label %5, !dbg !333

5:                                                ; preds = %16, %0
  %6 = load i32, i32* %3, align 4, !dbg !334
  %7 = icmp slt i32 %6, 5, !dbg !336
  br i1 %7, label %8, label %19, !dbg !337

8:                                                ; preds = %5
  %9 = load i32, i32* %3, align 4, !dbg !338
  %10 = sext i32 %9 to i64, !dbg !339
  %11 = getelementptr inbounds [5 x i64], [5 x i64]* %2, i64 0, i64 %10, !dbg !339
  %12 = load i32, i32* %3, align 4, !dbg !340
  %13 = sext i32 %12 to i64, !dbg !341
  %14 = inttoptr i64 %13 to i8*, !dbg !341
  %15 = call i32 @pthread_create(i64* noundef %11, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef %14) #5, !dbg !342
  br label %16, !dbg !342

16:                                               ; preds = %8
  %17 = load i32, i32* %3, align 4, !dbg !343
  %18 = add nsw i32 %17, 1, !dbg !343
  store i32 %18, i32* %3, align 4, !dbg !343
  br label %5, !dbg !344, !llvm.loop !345

19:                                               ; preds = %5
  call void @llvm.dbg.declare(metadata i32* %4, metadata !347, metadata !DIExpression()), !dbg !349
  store i32 0, i32* %4, align 4, !dbg !349
  br label %20, !dbg !350

20:                                               ; preds = %29, %19
  %21 = load i32, i32* %4, align 4, !dbg !351
  %22 = icmp slt i32 %21, 5, !dbg !353
  br i1 %22, label %23, label %32, !dbg !354

23:                                               ; preds = %20
  %24 = load i32, i32* %4, align 4, !dbg !355
  %25 = sext i32 %24 to i64, !dbg !356
  %26 = getelementptr inbounds [5 x i64], [5 x i64]* %2, i64 0, i64 %25, !dbg !356
  %27 = load i64, i64* %26, align 8, !dbg !356
  %28 = call i32 @pthread_join(i64 noundef %27, i8** noundef null), !dbg !357
  br label %29, !dbg !357

29:                                               ; preds = %23
  %30 = load i32, i32* %4, align 4, !dbg !358
  %31 = add nsw i32 %30, 1, !dbg !358
  store i32 %31, i32* %4, align 4, !dbg !358
  br label %20, !dbg !359, !llvm.loop !360

32:                                               ; preds = %20
  %33 = load i32, i32* @sum, align 4, !dbg !362
  %34 = icmp eq i32 %33, 5, !dbg !362
  br i1 %34, label %35, label %36, !dbg !365

35:                                               ; preds = %32
  br label %37, !dbg !365

36:                                               ; preds = %32
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !362
  unreachable, !dbg !362

37:                                               ; preds = %35
  ret i32 0, !dbg !366
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

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
!69 = !DILocation(line: 153, column: 53, scope: !63)
!70 = !DILocalVariable(name: "maxArrayWaiters", arg: 2, scope: !63, file: !19, line: 153, type: !25)
!71 = !DILocation(line: 153, column: 63, scope: !63)
!72 = !DILocation(line: 155, column: 18, scope: !63)
!73 = !DILocation(line: 155, column: 24, scope: !63)
!74 = !DILocation(line: 155, column: 5, scope: !63)
!75 = !DILocation(line: 156, column: 18, scope: !63)
!76 = !DILocation(line: 156, column: 24, scope: !63)
!77 = !DILocation(line: 156, column: 5, scope: !63)
!78 = !DILocation(line: 157, column: 29, scope: !63)
!79 = !DILocation(line: 157, column: 5, scope: !63)
!80 = !DILocation(line: 157, column: 11, scope: !63)
!81 = !DILocation(line: 157, column: 27, scope: !63)
!82 = !DILocation(line: 158, column: 50, scope: !63)
!83 = !DILocation(line: 158, column: 56, scope: !63)
!84 = !DILocation(line: 158, column: 71, scope: !63)
!85 = !DILocation(line: 158, column: 43, scope: !63)
!86 = !DILocation(line: 158, column: 26, scope: !63)
!87 = !DILocation(line: 158, column: 5, scope: !63)
!88 = !DILocation(line: 158, column: 11, scope: !63)
!89 = !DILocation(line: 158, column: 24, scope: !63)
!90 = !DILocation(line: 159, column: 5, scope: !63)
!91 = !DILocalVariable(name: "i", scope: !92, file: !19, line: 160, type: !25)
!92 = distinct !DILexicalBlock(scope: !63, file: !19, line: 160, column: 5)
!93 = !DILocation(line: 160, column: 14, scope: !92)
!94 = !DILocation(line: 160, column: 10, scope: !92)
!95 = !DILocation(line: 160, column: 21, scope: !96)
!96 = distinct !DILexicalBlock(scope: !92, file: !19, line: 160, column: 5)
!97 = !DILocation(line: 160, column: 25, scope: !96)
!98 = !DILocation(line: 160, column: 31, scope: !96)
!99 = !DILocation(line: 160, column: 23, scope: !96)
!100 = !DILocation(line: 160, column: 5, scope: !92)
!101 = !DILocation(line: 160, column: 53, scope: !96)
!102 = !DILocation(line: 160, column: 59, scope: !96)
!103 = !DILocation(line: 160, column: 72, scope: !96)
!104 = !DILocation(line: 160, column: 75, scope: !96)
!105 = !DILocation(line: 160, column: 49, scope: !96)
!106 = !DILocation(line: 160, column: 5, scope: !96)
!107 = distinct !{!107, !100, !108, !109}
!108 = !DILocation(line: 160, column: 77, scope: !92)
!109 = !{!"llvm.loop.mustprogress"}
!110 = !DILocation(line: 161, column: 1, scope: !63)
!111 = distinct !DISubprogram(name: "ticket_awnsb_mutex_destroy", scope: !19, file: !19, line: 164, type: !112, scopeLine: 165, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!112 = !DISubroutineType(types: !113)
!113 = !{null, !66}
!114 = !DILocalVariable(name: "self", arg: 1, scope: !111, file: !19, line: 164, type: !66)
!115 = !DILocation(line: 164, column: 56, scope: !111)
!116 = !DILocation(line: 166, column: 5, scope: !111)
!117 = !DILocation(line: 167, column: 5, scope: !111)
!118 = !DILocation(line: 168, column: 10, scope: !111)
!119 = !DILocation(line: 168, column: 16, scope: !111)
!120 = !DILocation(line: 168, column: 5, scope: !111)
!121 = !DILocation(line: 169, column: 1, scope: !111)
!122 = distinct !DISubprogram(name: "ticket_awnsb_mutex_lock", scope: !19, file: !19, line: 179, type: !112, scopeLine: 180, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!123 = !DILocalVariable(name: "self", arg: 1, scope: !122, file: !19, line: 179, type: !66)
!124 = !DILocation(line: 179, column: 53, scope: !122)
!125 = !DILocalVariable(name: "ticket", scope: !122, file: !19, line: 181, type: !126)
!126 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !127)
!127 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!128 = !DILocation(line: 181, column: 21, scope: !122)
!129 = !DILocation(line: 181, column: 57, scope: !122)
!130 = !DILocation(line: 181, column: 63, scope: !122)
!131 = !DILocation(line: 181, column: 30, scope: !122)
!132 = !DILocation(line: 185, column: 31, scope: !133)
!133 = distinct !DILexicalBlock(scope: !122, file: !19, line: 185, column: 9)
!134 = !DILocation(line: 185, column: 37, scope: !133)
!135 = !DILocation(line: 185, column: 9, scope: !133)
!136 = !DILocation(line: 185, column: 70, scope: !133)
!137 = !DILocation(line: 185, column: 67, scope: !133)
!138 = !DILocation(line: 185, column: 9, scope: !122)
!139 = !DILocation(line: 185, column: 78, scope: !133)
!140 = !DILocation(line: 187, column: 5, scope: !122)
!141 = !DILocation(line: 187, column: 34, scope: !122)
!142 = !DILocation(line: 187, column: 40, scope: !122)
!143 = !DILocation(line: 187, column: 12, scope: !122)
!144 = !DILocation(line: 187, column: 73, scope: !122)
!145 = !DILocation(line: 187, column: 79, scope: !122)
!146 = !DILocation(line: 187, column: 70, scope: !122)
!147 = !DILocation(line: 188, column: 35, scope: !148)
!148 = distinct !DILexicalBlock(scope: !149, file: !19, line: 188, column: 13)
!149 = distinct !DILexicalBlock(scope: !122, file: !19, line: 187, column: 83)
!150 = !DILocation(line: 188, column: 41, scope: !148)
!151 = !DILocation(line: 188, column: 13, scope: !148)
!152 = !DILocation(line: 188, column: 74, scope: !148)
!153 = !DILocation(line: 188, column: 71, scope: !148)
!154 = !DILocation(line: 188, column: 13, scope: !149)
!155 = !DILocation(line: 188, column: 82, scope: !148)
!156 = distinct !{!156, !140, !157, !109}
!157 = !DILocation(line: 189, column: 5, scope: !122)
!158 = !DILocation(line: 191, column: 5, scope: !122)
!159 = !DILocation(line: 191, column: 12, scope: !122)
!160 = !DILocation(line: 191, column: 41, scope: !122)
!161 = !DILocation(line: 191, column: 47, scope: !122)
!162 = !DILocation(line: 191, column: 19, scope: !122)
!163 = !DILocation(line: 191, column: 18, scope: !122)
!164 = !DILocation(line: 191, column: 81, scope: !122)
!165 = !DILocation(line: 191, column: 87, scope: !122)
!166 = !DILocation(line: 191, column: 102, scope: !122)
!167 = !DILocation(line: 191, column: 80, scope: !122)
!168 = !DILocation(line: 191, column: 77, scope: !122)
!169 = distinct !{!169, !158, !170, !109}
!170 = !DILocation(line: 191, column: 106, scope: !122)
!171 = !DILocalVariable(name: "wnode", scope: !122, file: !19, line: 194, type: !17)
!172 = !DILocation(line: 194, column: 20, scope: !122)
!173 = !DILocation(line: 196, column: 28, scope: !122)
!174 = !DILocation(line: 196, column: 35, scope: !122)
!175 = !DILocation(line: 196, column: 5, scope: !122)
!176 = !DILocation(line: 197, column: 28, scope: !122)
!177 = !DILocation(line: 197, column: 34, scope: !122)
!178 = !DILocation(line: 197, column: 53, scope: !122)
!179 = !DILocation(line: 197, column: 62, scope: !122)
!180 = !DILocation(line: 197, column: 68, scope: !122)
!181 = !DILocation(line: 197, column: 60, scope: !122)
!182 = !DILocation(line: 197, column: 47, scope: !122)
!183 = !DILocation(line: 197, column: 87, scope: !122)
!184 = !DILocation(line: 197, column: 5, scope: !122)
!185 = !DILocation(line: 199, column: 31, scope: !186)
!186 = distinct !DILexicalBlock(scope: !122, file: !19, line: 199, column: 9)
!187 = !DILocation(line: 199, column: 37, scope: !186)
!188 = !DILocation(line: 199, column: 9, scope: !186)
!189 = !DILocation(line: 199, column: 69, scope: !186)
!190 = !DILocation(line: 199, column: 75, scope: !186)
!191 = !DILocation(line: 199, column: 67, scope: !186)
!192 = !DILocation(line: 199, column: 9, scope: !122)
!193 = !DILocation(line: 201, column: 9, scope: !194)
!194 = distinct !DILexicalBlock(scope: !186, file: !19, line: 199, column: 79)
!195 = !DILocation(line: 201, column: 39, scope: !194)
!196 = !DILocation(line: 201, column: 46, scope: !194)
!197 = !DILocation(line: 201, column: 17, scope: !194)
!198 = !DILocation(line: 201, column: 16, scope: !194)
!199 = distinct !{!199, !193, !200, !109}
!200 = !DILocation(line: 201, column: 80, scope: !194)
!201 = !DILocation(line: 202, column: 32, scope: !194)
!202 = !DILocation(line: 202, column: 38, scope: !194)
!203 = !DILocation(line: 202, column: 46, scope: !194)
!204 = !DILocation(line: 202, column: 9, scope: !194)
!205 = !DILocation(line: 203, column: 5, scope: !194)
!206 = !DILocation(line: 205, column: 9, scope: !207)
!207 = distinct !DILexicalBlock(scope: !186, file: !19, line: 203, column: 12)
!208 = !DILocation(line: 205, column: 38, scope: !207)
!209 = !DILocation(line: 205, column: 44, scope: !207)
!210 = !DILocation(line: 205, column: 16, scope: !207)
!211 = !DILocation(line: 205, column: 77, scope: !207)
!212 = !DILocation(line: 205, column: 74, scope: !207)
!213 = !DILocation(line: 206, column: 39, scope: !214)
!214 = distinct !DILexicalBlock(scope: !215, file: !19, line: 206, column: 17)
!215 = distinct !DILexicalBlock(scope: !207, file: !19, line: 205, column: 85)
!216 = !DILocation(line: 206, column: 46, scope: !214)
!217 = !DILocation(line: 206, column: 17, scope: !214)
!218 = !DILocation(line: 206, column: 17, scope: !215)
!219 = !DILocation(line: 207, column: 40, scope: !220)
!220 = distinct !DILexicalBlock(scope: !214, file: !19, line: 206, column: 81)
!221 = !DILocation(line: 207, column: 46, scope: !220)
!222 = !DILocation(line: 207, column: 54, scope: !220)
!223 = !DILocation(line: 207, column: 17, scope: !220)
!224 = !DILocation(line: 208, column: 17, scope: !220)
!225 = distinct !{!225, !206, !226, !109}
!226 = !DILocation(line: 210, column: 9, scope: !207)
!227 = !DILocation(line: 213, column: 1, scope: !122)
!228 = distinct !DISubprogram(name: "ticket_awnsb_mutex_unlock", scope: !19, file: !19, line: 222, type: !112, scopeLine: 223, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!229 = !DILocalVariable(name: "self", arg: 1, scope: !228, file: !19, line: 222, type: !66)
!230 = !DILocation(line: 222, column: 55, scope: !228)
!231 = !DILocalVariable(name: "ticket", scope: !228, file: !19, line: 224, type: !127)
!232 = !DILocation(line: 224, column: 15, scope: !228)
!233 = !DILocation(line: 224, column: 46, scope: !228)
!234 = !DILocation(line: 224, column: 52, scope: !228)
!235 = !DILocation(line: 224, column: 24, scope: !228)
!236 = !DILocation(line: 226, column: 28, scope: !228)
!237 = !DILocation(line: 226, column: 34, scope: !228)
!238 = !DILocation(line: 226, column: 53, scope: !228)
!239 = !DILocation(line: 226, column: 62, scope: !228)
!240 = !DILocation(line: 226, column: 68, scope: !228)
!241 = !DILocation(line: 226, column: 60, scope: !228)
!242 = !DILocation(line: 226, column: 47, scope: !228)
!243 = !DILocation(line: 226, column: 5, scope: !228)
!244 = !DILocalVariable(name: "wnode", scope: !228, file: !19, line: 228, type: !17)
!245 = !DILocation(line: 228, column: 20, scope: !228)
!246 = !DILocation(line: 228, column: 50, scope: !228)
!247 = !DILocation(line: 228, column: 56, scope: !228)
!248 = !DILocation(line: 228, column: 76, scope: !228)
!249 = !DILocation(line: 228, column: 82, scope: !228)
!250 = !DILocation(line: 228, column: 88, scope: !228)
!251 = !DILocation(line: 228, column: 94, scope: !228)
!252 = !DILocation(line: 228, column: 86, scope: !228)
!253 = !DILocation(line: 228, column: 69, scope: !228)
!254 = !DILocation(line: 228, column: 28, scope: !228)
!255 = !DILocation(line: 229, column: 9, scope: !256)
!256 = distinct !DILexicalBlock(scope: !228, file: !19, line: 229, column: 9)
!257 = !DILocation(line: 229, column: 15, scope: !256)
!258 = !DILocation(line: 229, column: 9, scope: !228)
!259 = !DILocation(line: 231, column: 32, scope: !260)
!260 = distinct !DILexicalBlock(scope: !256, file: !19, line: 229, column: 24)
!261 = !DILocation(line: 231, column: 39, scope: !260)
!262 = !DILocation(line: 231, column: 9, scope: !260)
!263 = !DILocation(line: 232, column: 5, scope: !260)
!264 = !DILocation(line: 233, column: 32, scope: !265)
!265 = distinct !DILexicalBlock(scope: !256, file: !19, line: 232, column: 12)
!266 = !DILocation(line: 233, column: 38, scope: !265)
!267 = !DILocation(line: 233, column: 46, scope: !265)
!268 = !DILocation(line: 233, column: 52, scope: !265)
!269 = !DILocation(line: 233, column: 9, scope: !265)
!270 = !DILocation(line: 235, column: 1, scope: !228)
!271 = distinct !DISubprogram(name: "ticket_awnsb_mutex_trylock", scope: !19, file: !19, line: 243, type: !272, scopeLine: 244, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!272 = !DISubroutineType(types: !273)
!273 = !{!25, !66}
!274 = !DILocalVariable(name: "self", arg: 1, scope: !271, file: !19, line: 243, type: !66)
!275 = !DILocation(line: 243, column: 55, scope: !271)
!276 = !DILocalVariable(name: "localE", scope: !271, file: !19, line: 245, type: !127)
!277 = !DILocation(line: 245, column: 15, scope: !271)
!278 = !DILocation(line: 245, column: 24, scope: !271)
!279 = !DILocalVariable(name: "localI", scope: !271, file: !19, line: 246, type: !127)
!280 = !DILocation(line: 246, column: 15, scope: !271)
!281 = !DILocation(line: 246, column: 46, scope: !271)
!282 = !DILocation(line: 246, column: 52, scope: !271)
!283 = !DILocation(line: 246, column: 24, scope: !271)
!284 = !DILocation(line: 247, column: 9, scope: !285)
!285 = distinct !DILexicalBlock(scope: !271, file: !19, line: 247, column: 9)
!286 = !DILocation(line: 247, column: 19, scope: !285)
!287 = !DILocation(line: 247, column: 16, scope: !285)
!288 = !DILocation(line: 247, column: 9, scope: !271)
!289 = !DILocation(line: 247, column: 27, scope: !285)
!290 = !DILocation(line: 248, column: 10, scope: !291)
!291 = distinct !DILexicalBlock(scope: !271, file: !19, line: 248, column: 9)
!292 = !DILocation(line: 248, column: 9, scope: !271)
!293 = !DILocation(line: 248, column: 84, scope: !291)
!294 = !DILocation(line: 250, column: 5, scope: !271)
!295 = !DILocation(line: 251, column: 1, scope: !271)
!296 = distinct !DISubprogram(name: "thread_n", scope: !33, file: !33, line: 13, type: !297, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!297 = !DISubroutineType(types: !298)
!298 = !{!26, !26}
!299 = !DILocalVariable(name: "arg", arg: 1, scope: !296, file: !33, line: 13, type: !26)
!300 = !DILocation(line: 13, column: 22, scope: !296)
!301 = !DILocalVariable(name: "index", scope: !296, file: !33, line: 15, type: !27)
!302 = !DILocation(line: 15, column: 14, scope: !296)
!303 = !DILocation(line: 15, column: 34, scope: !296)
!304 = !DILocation(line: 15, column: 23, scope: !296)
!305 = !DILocation(line: 17, column: 5, scope: !296)
!306 = !DILocation(line: 18, column: 14, scope: !296)
!307 = !DILocation(line: 18, column: 12, scope: !296)
!308 = !DILocalVariable(name: "r", scope: !296, file: !33, line: 19, type: !25)
!309 = !DILocation(line: 19, column: 9, scope: !296)
!310 = !DILocation(line: 19, column: 13, scope: !296)
!311 = !DILocation(line: 20, column: 5, scope: !312)
!312 = distinct !DILexicalBlock(scope: !313, file: !33, line: 20, column: 5)
!313 = distinct !DILexicalBlock(scope: !296, file: !33, line: 20, column: 5)
!314 = !DILocation(line: 20, column: 5, scope: !313)
!315 = !DILocation(line: 21, column: 8, scope: !296)
!316 = !DILocation(line: 22, column: 5, scope: !296)
!317 = !DILocation(line: 23, column: 5, scope: !296)
!318 = distinct !DISubprogram(name: "main", scope: !33, file: !33, line: 26, type: !319, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!319 = !DISubroutineType(types: !320)
!320 = !{!25}
!321 = !DILocalVariable(name: "t", scope: !318, file: !33, line: 28, type: !322)
!322 = !DICompositeType(tag: DW_TAG_array_type, baseType: !323, size: 320, elements: !326)
!323 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !324, line: 27, baseType: !325)
!324 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!325 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!326 = !{!327}
!327 = !DISubrange(count: 5)
!328 = !DILocation(line: 28, column: 15, scope: !318)
!329 = !DILocation(line: 30, column: 5, scope: !318)
!330 = !DILocalVariable(name: "i", scope: !331, file: !33, line: 32, type: !25)
!331 = distinct !DILexicalBlock(scope: !318, file: !33, line: 32, column: 5)
!332 = !DILocation(line: 32, column: 14, scope: !331)
!333 = !DILocation(line: 32, column: 10, scope: !331)
!334 = !DILocation(line: 32, column: 21, scope: !335)
!335 = distinct !DILexicalBlock(scope: !331, file: !33, line: 32, column: 5)
!336 = !DILocation(line: 32, column: 23, scope: !335)
!337 = !DILocation(line: 32, column: 5, scope: !331)
!338 = !DILocation(line: 33, column: 27, scope: !335)
!339 = !DILocation(line: 33, column: 25, scope: !335)
!340 = !DILocation(line: 33, column: 52, scope: !335)
!341 = !DILocation(line: 33, column: 44, scope: !335)
!342 = !DILocation(line: 33, column: 9, scope: !335)
!343 = !DILocation(line: 32, column: 36, scope: !335)
!344 = !DILocation(line: 32, column: 5, scope: !335)
!345 = distinct !{!345, !337, !346, !109}
!346 = !DILocation(line: 33, column: 53, scope: !331)
!347 = !DILocalVariable(name: "i", scope: !348, file: !33, line: 35, type: !25)
!348 = distinct !DILexicalBlock(scope: !318, file: !33, line: 35, column: 5)
!349 = !DILocation(line: 35, column: 14, scope: !348)
!350 = !DILocation(line: 35, column: 10, scope: !348)
!351 = !DILocation(line: 35, column: 21, scope: !352)
!352 = distinct !DILexicalBlock(scope: !348, file: !33, line: 35, column: 5)
!353 = !DILocation(line: 35, column: 23, scope: !352)
!354 = !DILocation(line: 35, column: 5, scope: !348)
!355 = !DILocation(line: 36, column: 24, scope: !352)
!356 = !DILocation(line: 36, column: 22, scope: !352)
!357 = !DILocation(line: 36, column: 9, scope: !352)
!358 = !DILocation(line: 35, column: 36, scope: !352)
!359 = !DILocation(line: 35, column: 5, scope: !352)
!360 = distinct !{!360, !354, !361, !109}
!361 = !DILocation(line: 36, column: 29, scope: !348)
!362 = !DILocation(line: 38, column: 5, scope: !363)
!363 = distinct !DILexicalBlock(scope: !364, file: !33, line: 38, column: 5)
!364 = distinct !DILexicalBlock(scope: !318, file: !33, line: 38, column: 5)
!365 = !DILocation(line: 38, column: 5, scope: !364)
!366 = !DILocation(line: 40, column: 5, scope: !318)
