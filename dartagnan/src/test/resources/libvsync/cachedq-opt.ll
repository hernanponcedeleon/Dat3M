; ModuleID = '/home/drc/git/huawei/libvsync/datastruct/queue/cachedq/verify/cachedq_verify.c'
source_filename = "/home/drc/git/huawei/libvsync/datastruct/queue/cachedq/verify/cachedq_verify.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.cachedq_s = type { %struct.vatomic64_s, %struct.vatomic64_s, %struct.vatomic64_s, %struct.vatomic64_s, %struct.vatomic64_s, %struct.vatomic64_s, i64, [0 x i64] }
%struct.vatomic64_s = type { i64 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@write_total = dso_local global [1 x i64] zeroinitializer, align 8, !dbg !0
@read_total = dso_local global [2 x i64] zeroinitializer, align 16, !dbg !40
@q = dso_local global %struct.cachedq_s* null, align 8, !dbg !46
@.str = private unnamed_addr constant [34 x i8] c"write_total_sum == read_total_sum\00", align 1
@.str.1 = private unnamed_addr constant [79 x i8] c"/home/drc/git/huawei/libvsync/datastruct/queue/cachedq/verify/cachedq_verify.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"cachedq_count(q) == 0\00", align 1
@.str.3 = private unnamed_addr constant [43 x i8] c"(cnext - chead) < (18446744073709551615UL)\00", align 1
@.str.4 = private unnamed_addr constant [85 x i8] c"/home/drc/git/huawei/libvsync/datastruct/queue/cachedq/include/vsync/queue/cachedq.h\00", align 1
@__PRETTY_FUNCTION__.cachedq_dequeue = private unnamed_addr constant [59 x i8] c"vsize_t cachedq_dequeue(cachedq_t *, vuint64_t *, vsize_t)\00", align 1
@.str.5 = private unnamed_addr constant [35 x i8] c"(p - c) < (18446744073709551615UL)\00", align 1
@__PRETTY_FUNCTION__.cachedq_count = private unnamed_addr constant [35 x i8] c"vsize_t cachedq_count(cachedq_t *)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @writer(i8* noundef %0) #0 !dbg !60 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca [1 x i64], align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i64, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !64, metadata !DIExpression()), !dbg !65
  call void @llvm.dbg.declare(metadata i32* %3, metadata !66, metadata !DIExpression()), !dbg !67
  %10 = load i8*, i8** %2, align 8, !dbg !68
  %11 = bitcast i8* %10 to i32*, !dbg !69
  %12 = load i32, i32* %11, align 4, !dbg !70
  store i32 %12, i32* %3, align 4, !dbg !67
  call void @llvm.dbg.declare(metadata [1 x i64]* %4, metadata !71, metadata !DIExpression()), !dbg !73
  call void @llvm.dbg.declare(metadata i32* %5, metadata !74, metadata !DIExpression()), !dbg !76
  store i32 0, i32* %5, align 4, !dbg !76
  br label %13, !dbg !77

13:                                               ; preds = %59, %1
  %14 = load i32, i32* %5, align 4, !dbg !78
  %15 = icmp slt i32 %14, 2, !dbg !80
  br i1 %15, label %16, label %62, !dbg !81

16:                                               ; preds = %13
  call void @llvm.dbg.declare(metadata i32* %6, metadata !82, metadata !DIExpression()), !dbg !85
  store i32 0, i32* %6, align 4, !dbg !85
  br label %17, !dbg !86

17:                                               ; preds = %35, %16
  %18 = load i32, i32* %6, align 4, !dbg !87
  %19 = icmp slt i32 %18, 1, !dbg !89
  br i1 %19, label %20, label %38, !dbg !90

20:                                               ; preds = %17
  call void @llvm.dbg.declare(metadata i64* %7, metadata !91, metadata !DIExpression()), !dbg !93
  %21 = load i32, i32* %3, align 4, !dbg !94
  %22 = mul nsw i32 %21, 2, !dbg !95
  %23 = mul nsw i32 %22, 1, !dbg !96
  %24 = load i32, i32* %5, align 4, !dbg !97
  %25 = mul nsw i32 %24, 1, !dbg !98
  %26 = add nsw i32 %23, %25, !dbg !99
  %27 = load i32, i32* %6, align 4, !dbg !100
  %28 = add nsw i32 %26, %27, !dbg !101
  %29 = sext i32 %28 to i64, !dbg !94
  store i64 %29, i64* %7, align 8, !dbg !93
  %30 = load i64, i64* %7, align 8, !dbg !102
  %31 = shl i64 1, %30, !dbg !103
  %32 = load i32, i32* %6, align 4, !dbg !104
  %33 = sext i32 %32 to i64, !dbg !105
  %34 = getelementptr inbounds [1 x i64], [1 x i64]* %4, i64 0, i64 %33, !dbg !105
  store i64 %31, i64* %34, align 8, !dbg !106
  br label %35, !dbg !107

35:                                               ; preds = %20
  %36 = load i32, i32* %6, align 4, !dbg !108
  %37 = add nsw i32 %36, 1, !dbg !108
  store i32 %37, i32* %6, align 4, !dbg !108
  br label %17, !dbg !109, !llvm.loop !110

38:                                               ; preds = %17
  call void @llvm.dbg.declare(metadata i64* %8, metadata !113, metadata !DIExpression()), !dbg !114
  %39 = load %struct.cachedq_s*, %struct.cachedq_s** @q, align 8, !dbg !115
  %40 = getelementptr inbounds [1 x i64], [1 x i64]* %4, i64 0, i64 0, !dbg !116
  %41 = call i64 @cachedq_enqueue(%struct.cachedq_s* noundef %39, i64* noundef %40, i64 noundef 1), !dbg !117
  store i64 %41, i64* %8, align 8, !dbg !114
  call void @llvm.dbg.declare(metadata i64* %9, metadata !118, metadata !DIExpression()), !dbg !120
  store i64 0, i64* %9, align 8, !dbg !120
  br label %42, !dbg !121

42:                                               ; preds = %55, %38
  %43 = load i64, i64* %9, align 8, !dbg !122
  %44 = load i64, i64* %8, align 8, !dbg !124
  %45 = icmp ult i64 %43, %44, !dbg !125
  br i1 %45, label %46, label %58, !dbg !126

46:                                               ; preds = %42
  %47 = load i64, i64* %9, align 8, !dbg !127
  %48 = getelementptr inbounds [1 x i64], [1 x i64]* %4, i64 0, i64 %47, !dbg !129
  %49 = load i64, i64* %48, align 8, !dbg !129
  %50 = load i32, i32* %3, align 4, !dbg !130
  %51 = sext i32 %50 to i64, !dbg !131
  %52 = getelementptr inbounds [1 x i64], [1 x i64]* @write_total, i64 0, i64 %51, !dbg !131
  %53 = load i64, i64* %52, align 8, !dbg !132
  %54 = add i64 %53, %49, !dbg !132
  store i64 %54, i64* %52, align 8, !dbg !132
  br label %55, !dbg !133

55:                                               ; preds = %46
  %56 = load i64, i64* %9, align 8, !dbg !134
  %57 = add i64 %56, 1, !dbg !134
  store i64 %57, i64* %9, align 8, !dbg !134
  br label %42, !dbg !135, !llvm.loop !136

58:                                               ; preds = %42
  br label %59, !dbg !138

59:                                               ; preds = %58
  %60 = load i32, i32* %5, align 4, !dbg !139
  %61 = add nsw i32 %60, 1, !dbg !139
  store i32 %61, i32* %5, align 4, !dbg !139
  br label %13, !dbg !140, !llvm.loop !141

62:                                               ; preds = %13
  %63 = load i8*, i8** %2, align 8, !dbg !143
  call void @free(i8* noundef %63) #7, !dbg !144
  ret i8* null, !dbg !145
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal i64 @cachedq_enqueue(%struct.cachedq_s* noundef %0, i64* noundef %1, i64 noundef %2) #0 !dbg !146 {
  %4 = alloca i64, align 8
  %5 = alloca %struct.cachedq_s*, align 8
  %6 = alloca i64*, align 8
  %7 = alloca i64, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca i64, align 8
  %11 = alloca i64, align 8
  %12 = alloca i64, align 8
  %13 = alloca i64, align 8
  store %struct.cachedq_s* %0, %struct.cachedq_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.cachedq_s** %5, metadata !150, metadata !DIExpression()), !dbg !151
  store i64* %1, i64** %6, align 8
  call void @llvm.dbg.declare(metadata i64** %6, metadata !152, metadata !DIExpression()), !dbg !153
  store i64 %2, i64* %7, align 8
  call void @llvm.dbg.declare(metadata i64* %7, metadata !154, metadata !DIExpression()), !dbg !155
  br label %14, !dbg !156

14:                                               ; preds = %95, %39, %3
  call void @llvm.dbg.label(metadata !157), !dbg !158
  call void @llvm.dbg.declare(metadata i64* %8, metadata !159, metadata !DIExpression()), !dbg !160
  %15 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !161
  %16 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %15, i32 0, i32 0, !dbg !162
  %17 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef %16), !dbg !163
  store i64 %17, i64* %8, align 8, !dbg !160
  call void @llvm.dbg.declare(metadata i64* %9, metadata !164, metadata !DIExpression()), !dbg !165
  %18 = load i64, i64* %8, align 8, !dbg !166
  %19 = load i64, i64* %7, align 8, !dbg !167
  %20 = add i64 %18, %19, !dbg !168
  store i64 %20, i64* %9, align 8, !dbg !165
  call void @llvm.dbg.declare(metadata i64* %10, metadata !169, metadata !DIExpression()), !dbg !170
  %21 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !171
  %22 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %21, i32 0, i32 5, !dbg !172
  %23 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef %22), !dbg !173
  store i64 %23, i64* %10, align 8, !dbg !170
  %24 = load i64, i64* %9, align 8, !dbg !174
  %25 = load i64, i64* %10, align 8, !dbg !176
  %26 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !177
  %27 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %26, i32 0, i32 6, !dbg !178
  %28 = load i64, i64* %27, align 8, !dbg !178
  %29 = add i64 %25, %28, !dbg !179
  %30 = icmp ule i64 %24, %29, !dbg !180
  br i1 %30, label %31, label %76, !dbg !181

31:                                               ; preds = %14
  %32 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !182
  %33 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %32, i32 0, i32 0, !dbg !185
  %34 = load i64, i64* %8, align 8, !dbg !186
  %35 = load i64, i64* %9, align 8, !dbg !187
  %36 = call i64 @vatomic64_cmpxchg_rlx(%struct.vatomic64_s* noundef %33, i64 noundef %34, i64 noundef %35), !dbg !188
  %37 = load i64, i64* %8, align 8, !dbg !189
  %38 = icmp ne i64 %36, %37, !dbg !190
  br i1 %38, label %39, label %40, !dbg !191

39:                                               ; preds = %31
  br label %14, !dbg !192

40:                                               ; preds = %31
  call void @llvm.dbg.declare(metadata i64* %11, metadata !194, metadata !DIExpression()), !dbg !196
  store i64 0, i64* %11, align 8, !dbg !196
  br label %41, !dbg !197

41:                                               ; preds = %60, %40
  %42 = load i64, i64* %11, align 8, !dbg !198
  %43 = load i64, i64* %7, align 8, !dbg !200
  %44 = icmp ult i64 %42, %43, !dbg !201
  br i1 %44, label %45, label %63, !dbg !202

45:                                               ; preds = %41
  %46 = load i64*, i64** %6, align 8, !dbg !203
  %47 = load i64, i64* %11, align 8, !dbg !205
  %48 = getelementptr inbounds i64, i64* %46, i64 %47, !dbg !203
  %49 = load i64, i64* %48, align 8, !dbg !203
  %50 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !206
  %51 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %50, i32 0, i32 7, !dbg !207
  %52 = load i64, i64* %8, align 8, !dbg !208
  %53 = load i64, i64* %11, align 8, !dbg !209
  %54 = add i64 %52, %53, !dbg !210
  %55 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !211
  %56 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %55, i32 0, i32 6, !dbg !212
  %57 = load i64, i64* %56, align 8, !dbg !212
  %58 = urem i64 %54, %57, !dbg !213
  %59 = getelementptr inbounds [0 x i64], [0 x i64]* %51, i64 0, i64 %58, !dbg !206
  store i64 %49, i64* %59, align 8, !dbg !214
  br label %60, !dbg !215

60:                                               ; preds = %45
  %61 = load i64, i64* %11, align 8, !dbg !216
  %62 = add i64 %61, 1, !dbg !216
  store i64 %62, i64* %11, align 8, !dbg !216
  br label %41, !dbg !217, !llvm.loop !218

63:                                               ; preds = %41
  br label %64, !dbg !220

64:                                               ; preds = %70, %63
  %65 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !220
  %66 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %65, i32 0, i32 1, !dbg !220
  %67 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef %66), !dbg !220
  %68 = load i64, i64* %8, align 8, !dbg !220
  %69 = icmp ne i64 %67, %68, !dbg !220
  br i1 %69, label %70, label %71, !dbg !220

70:                                               ; preds = %64
  br label %64, !dbg !220, !llvm.loop !221

71:                                               ; preds = %64
  %72 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !223
  %73 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %72, i32 0, i32 1, !dbg !224
  %74 = load i64, i64* %9, align 8, !dbg !225
  call void @vatomic64_write_rel(%struct.vatomic64_s* noundef %73, i64 noundef %74), !dbg !226
  %75 = load i64, i64* %7, align 8, !dbg !227
  store i64 %75, i64* %4, align 8, !dbg !228
  br label %136, !dbg !228

76:                                               ; preds = %14
  call void @llvm.dbg.declare(metadata i64* %12, metadata !229, metadata !DIExpression()), !dbg !231
  %77 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !232
  %78 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %77, i32 0, i32 4, !dbg !233
  %79 = call i64 @vatomic64_read_acq(%struct.vatomic64_s* noundef %78), !dbg !234
  store i64 %79, i64* %12, align 8, !dbg !231
  %80 = load i64, i64* %9, align 8, !dbg !235
  %81 = load i64, i64* %12, align 8, !dbg !237
  %82 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !238
  %83 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %82, i32 0, i32 6, !dbg !239
  %84 = load i64, i64* %83, align 8, !dbg !239
  %85 = add i64 %81, %84, !dbg !240
  %86 = icmp ule i64 %80, %85, !dbg !241
  br i1 %86, label %87, label %135, !dbg !242

87:                                               ; preds = %76
  %88 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !243
  %89 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %88, i32 0, i32 0, !dbg !246
  %90 = load i64, i64* %8, align 8, !dbg !247
  %91 = load i64, i64* %9, align 8, !dbg !248
  %92 = call i64 @vatomic64_cmpxchg_rlx(%struct.vatomic64_s* noundef %89, i64 noundef %90, i64 noundef %91), !dbg !249
  %93 = load i64, i64* %8, align 8, !dbg !250
  %94 = icmp ne i64 %92, %93, !dbg !251
  br i1 %94, label %95, label %96, !dbg !252

95:                                               ; preds = %87
  br label %14, !dbg !253

96:                                               ; preds = %87
  %97 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !255
  %98 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %97, i32 0, i32 5, !dbg !256
  %99 = load i64, i64* %12, align 8, !dbg !257
  call void @vatomic64_write_rlx(%struct.vatomic64_s* noundef %98, i64 noundef %99), !dbg !258
  call void @llvm.dbg.declare(metadata i64* %13, metadata !259, metadata !DIExpression()), !dbg !261
  store i64 0, i64* %13, align 8, !dbg !261
  br label %100, !dbg !262

100:                                              ; preds = %119, %96
  %101 = load i64, i64* %13, align 8, !dbg !263
  %102 = load i64, i64* %7, align 8, !dbg !265
  %103 = icmp ult i64 %101, %102, !dbg !266
  br i1 %103, label %104, label %122, !dbg !267

104:                                              ; preds = %100
  %105 = load i64*, i64** %6, align 8, !dbg !268
  %106 = load i64, i64* %13, align 8, !dbg !270
  %107 = getelementptr inbounds i64, i64* %105, i64 %106, !dbg !268
  %108 = load i64, i64* %107, align 8, !dbg !268
  %109 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !271
  %110 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %109, i32 0, i32 7, !dbg !272
  %111 = load i64, i64* %8, align 8, !dbg !273
  %112 = load i64, i64* %13, align 8, !dbg !274
  %113 = add i64 %111, %112, !dbg !275
  %114 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !276
  %115 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %114, i32 0, i32 6, !dbg !277
  %116 = load i64, i64* %115, align 8, !dbg !277
  %117 = urem i64 %113, %116, !dbg !278
  %118 = getelementptr inbounds [0 x i64], [0 x i64]* %110, i64 0, i64 %117, !dbg !271
  store i64 %108, i64* %118, align 8, !dbg !279
  br label %119, !dbg !280

119:                                              ; preds = %104
  %120 = load i64, i64* %13, align 8, !dbg !281
  %121 = add i64 %120, 1, !dbg !281
  store i64 %121, i64* %13, align 8, !dbg !281
  br label %100, !dbg !282, !llvm.loop !283

122:                                              ; preds = %100
  br label %123, !dbg !285

123:                                              ; preds = %129, %122
  %124 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !285
  %125 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %124, i32 0, i32 1, !dbg !285
  %126 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef %125), !dbg !285
  %127 = load i64, i64* %8, align 8, !dbg !285
  %128 = icmp ne i64 %126, %127, !dbg !285
  br i1 %128, label %129, label %130, !dbg !285

129:                                              ; preds = %123
  br label %123, !dbg !285, !llvm.loop !286

130:                                              ; preds = %123
  %131 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !288
  %132 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %131, i32 0, i32 1, !dbg !289
  %133 = load i64, i64* %9, align 8, !dbg !290
  call void @vatomic64_write_rel(%struct.vatomic64_s* noundef %132, i64 noundef %133), !dbg !291
  %134 = load i64, i64* %7, align 8, !dbg !292
  store i64 %134, i64* %4, align 8, !dbg !293
  br label %136, !dbg !293

135:                                              ; preds = %76
  store i64 0, i64* %4, align 8, !dbg !294
  br label %136, !dbg !294

136:                                              ; preds = %135, %130, %71
  %137 = load i64, i64* %4, align 8, !dbg !296
  ret i64 %137, !dbg !296
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @reader(i8* noundef %0) #0 !dbg !297 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca [1 x i64], align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !298, metadata !DIExpression()), !dbg !299
  call void @llvm.dbg.declare(metadata i32* %3, metadata !300, metadata !DIExpression()), !dbg !301
  %8 = load i8*, i8** %2, align 8, !dbg !302
  %9 = bitcast i8* %8 to i32*, !dbg !303
  %10 = load i32, i32* %9, align 4, !dbg !304
  store i32 %10, i32* %3, align 4, !dbg !301
  call void @llvm.dbg.declare(metadata i32* %4, metadata !305, metadata !DIExpression()), !dbg !307
  store i32 0, i32* %4, align 4, !dbg !307
  br label %11, !dbg !308

11:                                               ; preds = %36, %1
  %12 = load i32, i32* %4, align 4, !dbg !309
  %13 = icmp slt i32 %12, 2, !dbg !311
  br i1 %13, label %14, label %39, !dbg !312

14:                                               ; preds = %11
  call void @llvm.dbg.declare(metadata [1 x i64]* %5, metadata !313, metadata !DIExpression()), !dbg !315
  %15 = bitcast [1 x i64]* %5 to i8*, !dbg !315
  call void @llvm.memset.p0i8.i64(i8* align 8 %15, i8 0, i64 8, i1 false), !dbg !315
  call void @llvm.dbg.declare(metadata i64* %6, metadata !316, metadata !DIExpression()), !dbg !317
  %16 = load %struct.cachedq_s*, %struct.cachedq_s** @q, align 8, !dbg !318
  %17 = getelementptr inbounds [1 x i64], [1 x i64]* %5, i64 0, i64 0, !dbg !319
  %18 = call i64 @cachedq_dequeue(%struct.cachedq_s* noundef %16, i64* noundef %17, i64 noundef 1), !dbg !320
  store i64 %18, i64* %6, align 8, !dbg !317
  call void @llvm.dbg.declare(metadata i64* %7, metadata !321, metadata !DIExpression()), !dbg !323
  store i64 0, i64* %7, align 8, !dbg !323
  br label %19, !dbg !324

19:                                               ; preds = %32, %14
  %20 = load i64, i64* %7, align 8, !dbg !325
  %21 = load i64, i64* %6, align 8, !dbg !327
  %22 = icmp ult i64 %20, %21, !dbg !328
  br i1 %22, label %23, label %35, !dbg !329

23:                                               ; preds = %19
  %24 = load i64, i64* %7, align 8, !dbg !330
  %25 = getelementptr inbounds [1 x i64], [1 x i64]* %5, i64 0, i64 %24, !dbg !332
  %26 = load i64, i64* %25, align 8, !dbg !332
  %27 = load i32, i32* %3, align 4, !dbg !333
  %28 = sext i32 %27 to i64, !dbg !334
  %29 = getelementptr inbounds [2 x i64], [2 x i64]* @read_total, i64 0, i64 %28, !dbg !334
  %30 = load i64, i64* %29, align 8, !dbg !335
  %31 = add i64 %30, %26, !dbg !335
  store i64 %31, i64* %29, align 8, !dbg !335
  br label %32, !dbg !336

32:                                               ; preds = %23
  %33 = load i64, i64* %7, align 8, !dbg !337
  %34 = add i64 %33, 1, !dbg !337
  store i64 %34, i64* %7, align 8, !dbg !337
  br label %19, !dbg !338, !llvm.loop !339

35:                                               ; preds = %19
  br label %36, !dbg !341

36:                                               ; preds = %35
  %37 = load i32, i32* %4, align 4, !dbg !342
  %38 = add nsw i32 %37, 1, !dbg !342
  store i32 %38, i32* %4, align 4, !dbg !342
  br label %11, !dbg !343, !llvm.loop !344

39:                                               ; preds = %11
  %40 = load i8*, i8** %2, align 8, !dbg !346
  call void @free(i8* noundef %40) #7, !dbg !347
  ret i8* null, !dbg !348
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: noinline nounwind uwtable
define internal i64 @cachedq_dequeue(%struct.cachedq_s* noundef %0, i64* noundef %1, i64 noundef %2) #0 !dbg !349 {
  %4 = alloca i64, align 8
  %5 = alloca %struct.cachedq_s*, align 8
  %6 = alloca i64*, align 8
  %7 = alloca i64, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca i64, align 8
  %11 = alloca i64, align 8
  %12 = alloca i64, align 8
  %13 = alloca i64, align 8
  %14 = alloca i64, align 8
  store %struct.cachedq_s* %0, %struct.cachedq_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.cachedq_s** %5, metadata !350, metadata !DIExpression()), !dbg !351
  store i64* %1, i64** %6, align 8
  call void @llvm.dbg.declare(metadata i64** %6, metadata !352, metadata !DIExpression()), !dbg !353
  store i64 %2, i64* %7, align 8
  call void @llvm.dbg.declare(metadata i64* %7, metadata !354, metadata !DIExpression()), !dbg !355
  br label %15, !dbg !356

15:                                               ; preds = %151, %88, %36, %3
  call void @llvm.dbg.label(metadata !357), !dbg !358
  call void @llvm.dbg.declare(metadata i64* %8, metadata !359, metadata !DIExpression()), !dbg !360
  %16 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !361
  %17 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %16, i32 0, i32 3, !dbg !362
  %18 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef %17), !dbg !363
  store i64 %18, i64* %8, align 8, !dbg !360
  call void @llvm.dbg.declare(metadata i64* %9, metadata !364, metadata !DIExpression()), !dbg !365
  %19 = load i64, i64* %8, align 8, !dbg !366
  %20 = load i64, i64* %7, align 8, !dbg !367
  %21 = add i64 %19, %20, !dbg !368
  store i64 %21, i64* %9, align 8, !dbg !365
  call void @llvm.dbg.declare(metadata i64* %10, metadata !369, metadata !DIExpression()), !dbg !370
  %22 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !371
  %23 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %22, i32 0, i32 2, !dbg !372
  %24 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef %23), !dbg !373
  store i64 %24, i64* %10, align 8, !dbg !370
  %25 = load i64, i64* %9, align 8, !dbg !374
  %26 = load i64, i64* %10, align 8, !dbg !376
  %27 = icmp ule i64 %25, %26, !dbg !377
  br i1 %27, label %28, label %73, !dbg !378

28:                                               ; preds = %15
  %29 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !379
  %30 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %29, i32 0, i32 3, !dbg !382
  %31 = load i64, i64* %8, align 8, !dbg !383
  %32 = load i64, i64* %9, align 8, !dbg !384
  %33 = call i64 @vatomic64_cmpxchg_rlx(%struct.vatomic64_s* noundef %30, i64 noundef %31, i64 noundef %32), !dbg !385
  %34 = load i64, i64* %8, align 8, !dbg !386
  %35 = icmp ne i64 %33, %34, !dbg !387
  br i1 %35, label %36, label %37, !dbg !388

36:                                               ; preds = %28
  br label %15, !dbg !389

37:                                               ; preds = %28
  call void @llvm.dbg.declare(metadata i64* %11, metadata !391, metadata !DIExpression()), !dbg !393
  store i64 0, i64* %11, align 8, !dbg !393
  br label %38, !dbg !394

38:                                               ; preds = %57, %37
  %39 = load i64, i64* %11, align 8, !dbg !395
  %40 = load i64, i64* %7, align 8, !dbg !397
  %41 = icmp ult i64 %39, %40, !dbg !398
  br i1 %41, label %42, label %60, !dbg !399

42:                                               ; preds = %38
  %43 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !400
  %44 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %43, i32 0, i32 7, !dbg !402
  %45 = load i64, i64* %8, align 8, !dbg !403
  %46 = load i64, i64* %11, align 8, !dbg !404
  %47 = add i64 %45, %46, !dbg !405
  %48 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !406
  %49 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %48, i32 0, i32 6, !dbg !407
  %50 = load i64, i64* %49, align 8, !dbg !407
  %51 = urem i64 %47, %50, !dbg !408
  %52 = getelementptr inbounds [0 x i64], [0 x i64]* %44, i64 0, i64 %51, !dbg !400
  %53 = load i64, i64* %52, align 8, !dbg !400
  %54 = load i64*, i64** %6, align 8, !dbg !409
  %55 = load i64, i64* %11, align 8, !dbg !410
  %56 = getelementptr inbounds i64, i64* %54, i64 %55, !dbg !409
  store i64 %53, i64* %56, align 8, !dbg !411
  br label %57, !dbg !412

57:                                               ; preds = %42
  %58 = load i64, i64* %11, align 8, !dbg !413
  %59 = add i64 %58, 1, !dbg !413
  store i64 %59, i64* %11, align 8, !dbg !413
  br label %38, !dbg !414, !llvm.loop !415

60:                                               ; preds = %38
  br label %61, !dbg !417

61:                                               ; preds = %67, %60
  %62 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !417
  %63 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %62, i32 0, i32 4, !dbg !417
  %64 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef %63), !dbg !417
  %65 = load i64, i64* %8, align 8, !dbg !417
  %66 = icmp ne i64 %64, %65, !dbg !417
  br i1 %66, label %67, label %68, !dbg !417

67:                                               ; preds = %61
  br label %61, !dbg !417, !llvm.loop !418

68:                                               ; preds = %61
  %69 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !420
  %70 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %69, i32 0, i32 4, !dbg !421
  %71 = load i64, i64* %9, align 8, !dbg !422
  call void @vatomic64_write_rel(%struct.vatomic64_s* noundef %70, i64 noundef %71), !dbg !423
  %72 = load i64, i64* %7, align 8, !dbg !424
  store i64 %72, i64* %4, align 8, !dbg !425
  br label %192, !dbg !425

73:                                               ; preds = %15
  call void @llvm.dbg.declare(metadata i64* %12, metadata !426, metadata !DIExpression()), !dbg !428
  %74 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !429
  %75 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %74, i32 0, i32 1, !dbg !430
  %76 = call i64 @vatomic64_read_acq(%struct.vatomic64_s* noundef %75), !dbg !431
  store i64 %76, i64* %12, align 8, !dbg !428
  %77 = load i64, i64* %9, align 8, !dbg !432
  %78 = load i64, i64* %12, align 8, !dbg !434
  %79 = icmp ule i64 %77, %78, !dbg !435
  br i1 %79, label %80, label %128, !dbg !436

80:                                               ; preds = %73
  %81 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !437
  %82 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %81, i32 0, i32 3, !dbg !440
  %83 = load i64, i64* %8, align 8, !dbg !441
  %84 = load i64, i64* %9, align 8, !dbg !442
  %85 = call i64 @vatomic64_cmpxchg_rlx(%struct.vatomic64_s* noundef %82, i64 noundef %83, i64 noundef %84), !dbg !443
  %86 = load i64, i64* %8, align 8, !dbg !444
  %87 = icmp ne i64 %85, %86, !dbg !445
  br i1 %87, label %88, label %89, !dbg !446

88:                                               ; preds = %80
  br label %15, !dbg !447

89:                                               ; preds = %80
  %90 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !449
  %91 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %90, i32 0, i32 2, !dbg !450
  %92 = load i64, i64* %12, align 8, !dbg !451
  call void @vatomic64_write_rlx(%struct.vatomic64_s* noundef %91, i64 noundef %92), !dbg !452
  call void @llvm.dbg.declare(metadata i64* %13, metadata !453, metadata !DIExpression()), !dbg !455
  store i64 0, i64* %13, align 8, !dbg !455
  br label %93, !dbg !456

93:                                               ; preds = %112, %89
  %94 = load i64, i64* %13, align 8, !dbg !457
  %95 = load i64, i64* %7, align 8, !dbg !459
  %96 = icmp ult i64 %94, %95, !dbg !460
  br i1 %96, label %97, label %115, !dbg !461

97:                                               ; preds = %93
  %98 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !462
  %99 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %98, i32 0, i32 7, !dbg !464
  %100 = load i64, i64* %8, align 8, !dbg !465
  %101 = load i64, i64* %13, align 8, !dbg !466
  %102 = add i64 %100, %101, !dbg !467
  %103 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !468
  %104 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %103, i32 0, i32 6, !dbg !469
  %105 = load i64, i64* %104, align 8, !dbg !469
  %106 = urem i64 %102, %105, !dbg !470
  %107 = getelementptr inbounds [0 x i64], [0 x i64]* %99, i64 0, i64 %106, !dbg !462
  %108 = load i64, i64* %107, align 8, !dbg !462
  %109 = load i64*, i64** %6, align 8, !dbg !471
  %110 = load i64, i64* %13, align 8, !dbg !472
  %111 = getelementptr inbounds i64, i64* %109, i64 %110, !dbg !471
  store i64 %108, i64* %111, align 8, !dbg !473
  br label %112, !dbg !474

112:                                              ; preds = %97
  %113 = load i64, i64* %13, align 8, !dbg !475
  %114 = add i64 %113, 1, !dbg !475
  store i64 %114, i64* %13, align 8, !dbg !475
  br label %93, !dbg !476, !llvm.loop !477

115:                                              ; preds = %93
  br label %116, !dbg !479

116:                                              ; preds = %122, %115
  %117 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !479
  %118 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %117, i32 0, i32 4, !dbg !479
  %119 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef %118), !dbg !479
  %120 = load i64, i64* %8, align 8, !dbg !479
  %121 = icmp ne i64 %119, %120, !dbg !479
  br i1 %121, label %122, label %123, !dbg !479

122:                                              ; preds = %116
  br label %116, !dbg !479, !llvm.loop !480

123:                                              ; preds = %116
  %124 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !482
  %125 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %124, i32 0, i32 4, !dbg !483
  %126 = load i64, i64* %9, align 8, !dbg !484
  call void @vatomic64_write_rel(%struct.vatomic64_s* noundef %125, i64 noundef %126), !dbg !485
  %127 = load i64, i64* %7, align 8, !dbg !486
  store i64 %127, i64* %4, align 8, !dbg !487
  br label %192, !dbg !487

128:                                              ; preds = %73
  %129 = load i64, i64* %8, align 8, !dbg !488
  %130 = load i64, i64* %12, align 8, !dbg !490
  %131 = icmp ult i64 %129, %130, !dbg !491
  br i1 %131, label %132, label %191, !dbg !492

132:                                              ; preds = %128
  %133 = load i64, i64* %12, align 8, !dbg !493
  store i64 %133, i64* %9, align 8, !dbg !495
  %134 = load i64, i64* %9, align 8, !dbg !496
  %135 = load i64, i64* %8, align 8, !dbg !496
  %136 = sub i64 %134, %135, !dbg !496
  %137 = icmp ult i64 %136, -1, !dbg !496
  br i1 %137, label %138, label %139, !dbg !499

138:                                              ; preds = %132
  br label %140, !dbg !499

139:                                              ; preds = %132
  call void @__assert_fail(i8* noundef getelementptr inbounds ([43 x i8], [43 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([85 x i8], [85 x i8]* @.str.4, i64 0, i64 0), i32 noundef 163, i8* noundef getelementptr inbounds ([59 x i8], [59 x i8]* @__PRETTY_FUNCTION__.cachedq_dequeue, i64 0, i64 0)) #8, !dbg !496
  unreachable, !dbg !496

140:                                              ; preds = %138
  %141 = load i64, i64* %9, align 8, !dbg !500
  %142 = load i64, i64* %8, align 8, !dbg !501
  %143 = sub i64 %141, %142, !dbg !502
  store i64 %143, i64* %7, align 8, !dbg !503
  %144 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !504
  %145 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %144, i32 0, i32 3, !dbg !506
  %146 = load i64, i64* %8, align 8, !dbg !507
  %147 = load i64, i64* %9, align 8, !dbg !508
  %148 = call i64 @vatomic64_cmpxchg_rlx(%struct.vatomic64_s* noundef %145, i64 noundef %146, i64 noundef %147), !dbg !509
  %149 = load i64, i64* %8, align 8, !dbg !510
  %150 = icmp ne i64 %148, %149, !dbg !511
  br i1 %150, label %151, label %152, !dbg !512

151:                                              ; preds = %140
  br label %15, !dbg !513

152:                                              ; preds = %140
  %153 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !515
  %154 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %153, i32 0, i32 2, !dbg !516
  %155 = load i64, i64* %12, align 8, !dbg !517
  call void @vatomic64_write_rlx(%struct.vatomic64_s* noundef %154, i64 noundef %155), !dbg !518
  call void @llvm.dbg.declare(metadata i64* %14, metadata !519, metadata !DIExpression()), !dbg !521
  store i64 0, i64* %14, align 8, !dbg !521
  br label %156, !dbg !522

156:                                              ; preds = %175, %152
  %157 = load i64, i64* %14, align 8, !dbg !523
  %158 = load i64, i64* %7, align 8, !dbg !525
  %159 = icmp ult i64 %157, %158, !dbg !526
  br i1 %159, label %160, label %178, !dbg !527

160:                                              ; preds = %156
  %161 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !528
  %162 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %161, i32 0, i32 7, !dbg !530
  %163 = load i64, i64* %8, align 8, !dbg !531
  %164 = load i64, i64* %14, align 8, !dbg !532
  %165 = add i64 %163, %164, !dbg !533
  %166 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !534
  %167 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %166, i32 0, i32 6, !dbg !535
  %168 = load i64, i64* %167, align 8, !dbg !535
  %169 = urem i64 %165, %168, !dbg !536
  %170 = getelementptr inbounds [0 x i64], [0 x i64]* %162, i64 0, i64 %169, !dbg !528
  %171 = load i64, i64* %170, align 8, !dbg !528
  %172 = load i64*, i64** %6, align 8, !dbg !537
  %173 = load i64, i64* %14, align 8, !dbg !538
  %174 = getelementptr inbounds i64, i64* %172, i64 %173, !dbg !537
  store i64 %171, i64* %174, align 8, !dbg !539
  br label %175, !dbg !540

175:                                              ; preds = %160
  %176 = load i64, i64* %14, align 8, !dbg !541
  %177 = add i64 %176, 1, !dbg !541
  store i64 %177, i64* %14, align 8, !dbg !541
  br label %156, !dbg !542, !llvm.loop !543

178:                                              ; preds = %156
  br label %179, !dbg !545

179:                                              ; preds = %185, %178
  %180 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !545
  %181 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %180, i32 0, i32 4, !dbg !545
  %182 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef %181), !dbg !545
  %183 = load i64, i64* %8, align 8, !dbg !545
  %184 = icmp ne i64 %182, %183, !dbg !545
  br i1 %184, label %185, label %186, !dbg !545

185:                                              ; preds = %179
  br label %179, !dbg !545, !llvm.loop !546

186:                                              ; preds = %179
  %187 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !548
  %188 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %187, i32 0, i32 4, !dbg !549
  %189 = load i64, i64* %9, align 8, !dbg !550
  call void @vatomic64_write_rel(%struct.vatomic64_s* noundef %188, i64 noundef %189), !dbg !551
  %190 = load i64, i64* %7, align 8, !dbg !552
  store i64 %190, i64* %4, align 8, !dbg !553
  br label %192, !dbg !553

191:                                              ; preds = %128
  store i64 0, i64* %4, align 8, !dbg !554
  br label %192, !dbg !554

192:                                              ; preds = %191, %186, %123, %68
  %193 = load i64, i64* %4, align 8, !dbg !556
  ret i64 %193, !dbg !556
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !557 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i8*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32*, align 8
  %9 = alloca i32, align 4
  %10 = alloca i64, align 8
  %11 = alloca i32, align 4
  %12 = alloca i32*, align 8
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i64, align 8
  %16 = alloca i32, align 4
  %17 = alloca i32*, align 8
  %18 = alloca i64, align 8
  %19 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i64* %2, metadata !560, metadata !DIExpression()), !dbg !561
  %20 = call i64 @cachedq_memsize(i64 noundef 1), !dbg !562
  store i64 %20, i64* %2, align 8, !dbg !561
  call void @llvm.dbg.declare(metadata i8** %3, metadata !563, metadata !DIExpression()), !dbg !564
  %21 = load i64, i64* %2, align 8, !dbg !565
  %22 = call noalias i8* @malloc(i64 noundef %21) #7, !dbg !566
  store i8* %22, i8** %3, align 8, !dbg !564
  %23 = load i8*, i8** %3, align 8, !dbg !567
  %24 = load i64, i64* %2, align 8, !dbg !568
  %25 = call %struct.cachedq_s* @cachedq_init(i8* noundef %23, i64 noundef %24), !dbg !569
  store %struct.cachedq_s* %25, %struct.cachedq_s** @q, align 8, !dbg !570
  %26 = load %struct.cachedq_s*, %struct.cachedq_s** @q, align 8, !dbg !571
  %27 = icmp eq %struct.cachedq_s* %26, null, !dbg !573
  br i1 %27, label %28, label %29, !dbg !574

28:                                               ; preds = %0
  call void @exit(i32 noundef 1) #8, !dbg !575
  unreachable, !dbg !575

29:                                               ; preds = %0
  call void @llvm.dbg.declare(metadata i32* %4, metadata !576, metadata !DIExpression()), !dbg !577
  store i32 1, i32* %4, align 4, !dbg !577
  %30 = load i32, i32* %4, align 4, !dbg !578
  %31 = zext i32 %30 to i64, !dbg !579
  %32 = call i8* @llvm.stacksave(), !dbg !579
  store i8* %32, i8** %5, align 8, !dbg !579
  %33 = alloca i64, i64 %31, align 16, !dbg !579
  store i64 %31, i64* %6, align 8, !dbg !579
  call void @llvm.dbg.declare(metadata i64* %6, metadata !580, metadata !DIExpression()), !dbg !581
  call void @llvm.dbg.declare(metadata i64* %33, metadata !582, metadata !DIExpression()), !dbg !588
  call void @llvm.dbg.declare(metadata i32* %7, metadata !589, metadata !DIExpression()), !dbg !591
  store i32 0, i32* %7, align 4, !dbg !591
  br label %34, !dbg !592

34:                                               ; preds = %49, %29
  %35 = load i32, i32* %7, align 4, !dbg !593
  %36 = load i32, i32* %4, align 4, !dbg !595
  %37 = icmp slt i32 %35, %36, !dbg !596
  br i1 %37, label %38, label %52, !dbg !597

38:                                               ; preds = %34
  call void @llvm.dbg.declare(metadata i32** %8, metadata !598, metadata !DIExpression()), !dbg !600
  %39 = call noalias i8* @malloc(i64 noundef 4) #7, !dbg !601
  %40 = bitcast i8* %39 to i32*, !dbg !602
  store i32* %40, i32** %8, align 8, !dbg !600
  %41 = load i32, i32* %7, align 4, !dbg !603
  %42 = load i32*, i32** %8, align 8, !dbg !604
  store i32 %41, i32* %42, align 4, !dbg !605
  %43 = load i32, i32* %7, align 4, !dbg !606
  %44 = sext i32 %43 to i64, !dbg !607
  %45 = getelementptr inbounds i64, i64* %33, i64 %44, !dbg !607
  %46 = load i32*, i32** %8, align 8, !dbg !608
  %47 = bitcast i32* %46 to i8*, !dbg !609
  %48 = call i32 @pthread_create(i64* noundef %45, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer, i8* noundef %47) #7, !dbg !610
  br label %49, !dbg !611

49:                                               ; preds = %38
  %50 = load i32, i32* %7, align 4, !dbg !612
  %51 = add nsw i32 %50, 1, !dbg !612
  store i32 %51, i32* %7, align 4, !dbg !612
  br label %34, !dbg !613, !llvm.loop !614

52:                                               ; preds = %34
  call void @llvm.dbg.declare(metadata i32* %9, metadata !616, metadata !DIExpression()), !dbg !617
  store i32 1, i32* %9, align 4, !dbg !617
  %53 = load i32, i32* %9, align 4, !dbg !618
  %54 = add nsw i32 %53, 1, !dbg !619
  %55 = zext i32 %54 to i64, !dbg !620
  %56 = alloca i64, i64 %55, align 16, !dbg !620
  store i64 %55, i64* %10, align 8, !dbg !620
  call void @llvm.dbg.declare(metadata i64* %10, metadata !621, metadata !DIExpression()), !dbg !581
  call void @llvm.dbg.declare(metadata i64* %56, metadata !622, metadata !DIExpression()), !dbg !626
  call void @llvm.dbg.declare(metadata i32* %11, metadata !627, metadata !DIExpression()), !dbg !629
  store i32 0, i32* %11, align 4, !dbg !629
  br label %57, !dbg !630

57:                                               ; preds = %72, %52
  %58 = load i32, i32* %11, align 4, !dbg !631
  %59 = load i32, i32* %9, align 4, !dbg !633
  %60 = icmp slt i32 %58, %59, !dbg !634
  br i1 %60, label %61, label %75, !dbg !635

61:                                               ; preds = %57
  call void @llvm.dbg.declare(metadata i32** %12, metadata !636, metadata !DIExpression()), !dbg !638
  %62 = call noalias i8* @malloc(i64 noundef 4) #7, !dbg !639
  %63 = bitcast i8* %62 to i32*, !dbg !640
  store i32* %63, i32** %12, align 8, !dbg !638
  %64 = load i32, i32* %11, align 4, !dbg !641
  %65 = load i32*, i32** %12, align 8, !dbg !642
  store i32 %64, i32* %65, align 4, !dbg !643
  %66 = load i32, i32* %11, align 4, !dbg !644
  %67 = sext i32 %66 to i64, !dbg !645
  %68 = getelementptr inbounds i64, i64* %56, i64 %67, !dbg !645
  %69 = load i32*, i32** %12, align 8, !dbg !646
  %70 = bitcast i32* %69 to i8*, !dbg !647
  %71 = call i32 @pthread_create(i64* noundef %68, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef %70) #7, !dbg !648
  br label %72, !dbg !649

72:                                               ; preds = %61
  %73 = load i32, i32* %11, align 4, !dbg !650
  %74 = add nsw i32 %73, 1, !dbg !650
  store i32 %74, i32* %11, align 4, !dbg !650
  br label %57, !dbg !651, !llvm.loop !652

75:                                               ; preds = %57
  call void @llvm.dbg.declare(metadata i32* %13, metadata !654, metadata !DIExpression()), !dbg !656
  store i32 0, i32* %13, align 4, !dbg !656
  br label %76, !dbg !657

76:                                               ; preds = %86, %75
  %77 = load i32, i32* %13, align 4, !dbg !658
  %78 = load i32, i32* %4, align 4, !dbg !660
  %79 = icmp slt i32 %77, %78, !dbg !661
  br i1 %79, label %80, label %89, !dbg !662

80:                                               ; preds = %76
  %81 = load i32, i32* %13, align 4, !dbg !663
  %82 = sext i32 %81 to i64, !dbg !664
  %83 = getelementptr inbounds i64, i64* %33, i64 %82, !dbg !664
  %84 = load i64, i64* %83, align 8, !dbg !664
  %85 = call i32 @pthread_join(i64 noundef %84, i8** noundef null), !dbg !665
  br label %86, !dbg !665

86:                                               ; preds = %80
  %87 = load i32, i32* %13, align 4, !dbg !666
  %88 = add nsw i32 %87, 1, !dbg !666
  store i32 %88, i32* %13, align 4, !dbg !666
  br label %76, !dbg !667, !llvm.loop !668

89:                                               ; preds = %76
  call void @llvm.dbg.declare(metadata i32* %14, metadata !670, metadata !DIExpression()), !dbg !672
  store i32 0, i32* %14, align 4, !dbg !672
  br label %90, !dbg !673

90:                                               ; preds = %100, %89
  %91 = load i32, i32* %14, align 4, !dbg !674
  %92 = load i32, i32* %9, align 4, !dbg !676
  %93 = icmp slt i32 %91, %92, !dbg !677
  br i1 %93, label %94, label %103, !dbg !678

94:                                               ; preds = %90
  %95 = load i32, i32* %14, align 4, !dbg !679
  %96 = sext i32 %95 to i64, !dbg !680
  %97 = getelementptr inbounds i64, i64* %56, i64 %96, !dbg !680
  %98 = load i64, i64* %97, align 8, !dbg !680
  %99 = call i32 @pthread_join(i64 noundef %98, i8** noundef null), !dbg !681
  br label %100, !dbg !681

100:                                              ; preds = %94
  %101 = load i32, i32* %14, align 4, !dbg !682
  %102 = add nsw i32 %101, 1, !dbg !682
  store i32 %102, i32* %14, align 4, !dbg !682
  br label %90, !dbg !683, !llvm.loop !684

103:                                              ; preds = %90
  call void @llvm.dbg.declare(metadata i64* %15, metadata !686, metadata !DIExpression()), !dbg !687
  store i64 0, i64* %15, align 8, !dbg !687
  call void @llvm.dbg.declare(metadata i32* %16, metadata !688, metadata !DIExpression()), !dbg !690
  store i32 0, i32* %16, align 4, !dbg !690
  br label %104, !dbg !691

104:                                              ; preds = %114, %103
  %105 = load i32, i32* %16, align 4, !dbg !692
  %106 = icmp slt i32 %105, 1, !dbg !694
  br i1 %106, label %107, label %117, !dbg !695

107:                                              ; preds = %104
  %108 = load i32, i32* %16, align 4, !dbg !696
  %109 = sext i32 %108 to i64, !dbg !698
  %110 = getelementptr inbounds [1 x i64], [1 x i64]* @write_total, i64 0, i64 %109, !dbg !698
  %111 = load i64, i64* %110, align 8, !dbg !698
  %112 = load i64, i64* %15, align 8, !dbg !699
  %113 = add i64 %112, %111, !dbg !699
  store i64 %113, i64* %15, align 8, !dbg !699
  br label %114, !dbg !700

114:                                              ; preds = %107
  %115 = load i32, i32* %16, align 4, !dbg !701
  %116 = add nsw i32 %115, 1, !dbg !701
  store i32 %116, i32* %16, align 4, !dbg !701
  br label %104, !dbg !702, !llvm.loop !703

117:                                              ; preds = %104
  call void @llvm.dbg.declare(metadata i32** %17, metadata !705, metadata !DIExpression()), !dbg !707
  %118 = call noalias i8* @malloc(i64 noundef 4) #7, !dbg !708
  %119 = bitcast i8* %118 to i32*, !dbg !709
  store i32* %119, i32** %17, align 8, !dbg !707
  %120 = load i32, i32* %9, align 4, !dbg !710
  %121 = load i32*, i32** %17, align 8, !dbg !711
  store i32 %120, i32* %121, align 4, !dbg !712
  %122 = load i32, i32* %9, align 4, !dbg !713
  %123 = sext i32 %122 to i64, !dbg !714
  %124 = getelementptr inbounds i64, i64* %56, i64 %123, !dbg !714
  %125 = load i32*, i32** %17, align 8, !dbg !715
  %126 = bitcast i32* %125 to i8*, !dbg !716
  %127 = call i32 @pthread_create(i64* noundef %124, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef %126) #7, !dbg !717
  %128 = load i32, i32* %9, align 4, !dbg !718
  %129 = sext i32 %128 to i64, !dbg !719
  %130 = getelementptr inbounds i64, i64* %56, i64 %129, !dbg !719
  %131 = load i64, i64* %130, align 8, !dbg !719
  %132 = call i32 @pthread_join(i64 noundef %131, i8** noundef null), !dbg !720
  call void @llvm.dbg.declare(metadata i64* %18, metadata !721, metadata !DIExpression()), !dbg !722
  store i64 0, i64* %18, align 8, !dbg !722
  call void @llvm.dbg.declare(metadata i32* %19, metadata !723, metadata !DIExpression()), !dbg !725
  store i32 0, i32* %19, align 4, !dbg !725
  br label %133, !dbg !726

133:                                              ; preds = %143, %117
  %134 = load i32, i32* %19, align 4, !dbg !727
  %135 = icmp slt i32 %134, 2, !dbg !729
  br i1 %135, label %136, label %146, !dbg !730

136:                                              ; preds = %133
  %137 = load i32, i32* %19, align 4, !dbg !731
  %138 = sext i32 %137 to i64, !dbg !733
  %139 = getelementptr inbounds [2 x i64], [2 x i64]* @read_total, i64 0, i64 %138, !dbg !733
  %140 = load i64, i64* %139, align 8, !dbg !733
  %141 = load i64, i64* %18, align 8, !dbg !734
  %142 = add i64 %141, %140, !dbg !734
  store i64 %142, i64* %18, align 8, !dbg !734
  br label %143, !dbg !735

143:                                              ; preds = %136
  %144 = load i32, i32* %19, align 4, !dbg !736
  %145 = add nsw i32 %144, 1, !dbg !736
  store i32 %145, i32* %19, align 4, !dbg !736
  br label %133, !dbg !737, !llvm.loop !738

146:                                              ; preds = %133
  %147 = load i64, i64* %15, align 8, !dbg !740
  %148 = load i64, i64* %18, align 8, !dbg !740
  %149 = icmp eq i64 %147, %148, !dbg !740
  br i1 %149, label %150, label %151, !dbg !743

150:                                              ; preds = %146
  br label %152, !dbg !743

151:                                              ; preds = %146
  call void @__assert_fail(i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([79 x i8], [79 x i8]* @.str.1, i64 0, i64 0), i32 noundef 122, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #8, !dbg !740
  unreachable, !dbg !740

152:                                              ; preds = %150
  %153 = load %struct.cachedq_s*, %struct.cachedq_s** @q, align 8, !dbg !744
  %154 = call i64 @cachedq_count(%struct.cachedq_s* noundef %153), !dbg !744
  %155 = icmp eq i64 %154, 0, !dbg !744
  br i1 %155, label %156, label %157, !dbg !747

156:                                              ; preds = %152
  br label %158, !dbg !747

157:                                              ; preds = %152
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([79 x i8], [79 x i8]* @.str.1, i64 0, i64 0), i32 noundef 123, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #8, !dbg !744
  unreachable, !dbg !744

158:                                              ; preds = %156
  %159 = load i8*, i8** %3, align 8, !dbg !748
  call void @free(i8* noundef %159) #7, !dbg !749
  store i32 0, i32* %1, align 4, !dbg !750
  %160 = load i8*, i8** %5, align 8, !dbg !751
  call void @llvm.stackrestore(i8* %160), !dbg !751
  %161 = load i32, i32* %1, align 4, !dbg !751
  ret i32 %161, !dbg !751
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @cachedq_memsize(i64 noundef %0) #0 !dbg !752 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !755, metadata !DIExpression()), !dbg !756
  %3 = load i64, i64* %2, align 8, !dbg !757
  %4 = mul i64 8, %3, !dbg !758
  %5 = add i64 56, %4, !dbg !759
  %6 = add i64 %5, 128, !dbg !760
  ret i64 %6, !dbg !761
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal %struct.cachedq_s* @cachedq_init(i8* noundef %0, i64 noundef %1) #0 !dbg !762 {
  %3 = alloca i8*, align 8
  %4 = alloca i64, align 8
  %5 = alloca %struct.cachedq_s*, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !765, metadata !DIExpression()), !dbg !766
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !767, metadata !DIExpression()), !dbg !768
  call void @llvm.dbg.declare(metadata %struct.cachedq_s** %5, metadata !769, metadata !DIExpression()), !dbg !770
  %6 = load i8*, i8** %3, align 8, !dbg !771
  %7 = bitcast i8* %6 to %struct.cachedq_s*, !dbg !772
  store %struct.cachedq_s* %7, %struct.cachedq_s** %5, align 8, !dbg !770
  %8 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !773
  %9 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %8, i32 0, i32 0, !dbg !774
  call void @vatomic64_init(%struct.vatomic64_s* noundef %9, i64 noundef 0), !dbg !775
  %10 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !776
  %11 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %10, i32 0, i32 1, !dbg !777
  call void @vatomic64_init(%struct.vatomic64_s* noundef %11, i64 noundef 0), !dbg !778
  %12 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !779
  %13 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %12, i32 0, i32 2, !dbg !780
  call void @vatomic64_init(%struct.vatomic64_s* noundef %13, i64 noundef 0), !dbg !781
  %14 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !782
  %15 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %14, i32 0, i32 3, !dbg !783
  call void @vatomic64_init(%struct.vatomic64_s* noundef %15, i64 noundef 0), !dbg !784
  %16 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !785
  %17 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %16, i32 0, i32 4, !dbg !786
  call void @vatomic64_init(%struct.vatomic64_s* noundef %17, i64 noundef 0), !dbg !787
  %18 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !788
  %19 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %18, i32 0, i32 5, !dbg !789
  call void @vatomic64_init(%struct.vatomic64_s* noundef %19, i64 noundef 0), !dbg !790
  %20 = load i64, i64* %4, align 8, !dbg !791
  %21 = sub i64 %20, 128, !dbg !792
  %22 = sub i64 %21, 56, !dbg !793
  %23 = udiv i64 %22, 8, !dbg !794
  %24 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !795
  %25 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %24, i32 0, i32 6, !dbg !796
  store i64 %23, i64* %25, align 8, !dbg !797
  %26 = load %struct.cachedq_s*, %struct.cachedq_s** %5, align 8, !dbg !798
  ret %struct.cachedq_s* %26, !dbg !799
}

; Function Attrs: noreturn nounwind
declare void @exit(i32 noundef) #4

; Function Attrs: nofree nosync nounwind willreturn
declare i8* @llvm.stacksave() #5

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #6

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal i64 @cachedq_count(%struct.cachedq_s* noundef %0) #0 !dbg !800 {
  %2 = alloca %struct.cachedq_s*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store %struct.cachedq_s* %0, %struct.cachedq_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.cachedq_s** %2, metadata !803, metadata !DIExpression()), !dbg !804
  call void @llvm.dbg.declare(metadata i64* %3, metadata !805, metadata !DIExpression()), !dbg !806
  %5 = load %struct.cachedq_s*, %struct.cachedq_s** %2, align 8, !dbg !807
  %6 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %5, i32 0, i32 4, !dbg !808
  %7 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef %6), !dbg !809
  store i64 %7, i64* %3, align 8, !dbg !806
  call void @llvm.dbg.declare(metadata i64* %4, metadata !810, metadata !DIExpression()), !dbg !811
  %8 = load %struct.cachedq_s*, %struct.cachedq_s** %2, align 8, !dbg !812
  %9 = getelementptr inbounds %struct.cachedq_s, %struct.cachedq_s* %8, i32 0, i32 1, !dbg !813
  %10 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef %9), !dbg !814
  store i64 %10, i64* %4, align 8, !dbg !811
  %11 = load i64, i64* %4, align 8, !dbg !815
  %12 = load i64, i64* %3, align 8, !dbg !815
  %13 = sub i64 %11, %12, !dbg !815
  %14 = icmp ult i64 %13, -1, !dbg !815
  br i1 %14, label %15, label %16, !dbg !818

15:                                               ; preds = %1
  br label %17, !dbg !818

16:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([35 x i8], [35 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([85 x i8], [85 x i8]* @.str.4, i64 0, i64 0), i32 noundef 191, i8* noundef getelementptr inbounds ([35 x i8], [35 x i8]* @__PRETTY_FUNCTION__.cachedq_count, i64 0, i64 0)) #8, !dbg !815
  unreachable, !dbg !815

17:                                               ; preds = %15
  %18 = load i64, i64* %4, align 8, !dbg !819
  %19 = load i64, i64* %3, align 8, !dbg !820
  %20 = sub i64 %18, %19, !dbg !821
  ret i64 %20, !dbg !822
}

; Function Attrs: nofree nosync nounwind willreturn
declare void @llvm.stackrestore(i8*) #5

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !823 {
  %2 = alloca %struct.vatomic64_s*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !829, metadata !DIExpression()), !dbg !830
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #7, !dbg !831, !srcloc !832
  call void @llvm.dbg.declare(metadata i64* %3, metadata !833, metadata !DIExpression()), !dbg !834
  %5 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !835
  %6 = getelementptr inbounds %struct.vatomic64_s, %struct.vatomic64_s* %5, i32 0, i32 0, !dbg !836
  %7 = load atomic i64, i64* %6 monotonic, align 8, !dbg !837
  store i64 %7, i64* %4, align 8, !dbg !837
  %8 = load i64, i64* %4, align 8, !dbg !837
  store i64 %8, i64* %3, align 8, !dbg !834
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #7, !dbg !838, !srcloc !839
  %9 = load i64, i64* %3, align 8, !dbg !840
  ret i64 %9, !dbg !841
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_cmpxchg_rlx(%struct.vatomic64_s* noundef %0, i64 noundef %1, i64 noundef %2) #0 !dbg !842 {
  %4 = alloca %struct.vatomic64_s*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i64, align 8
  %9 = alloca i8, align 1
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %4, metadata !846, metadata !DIExpression()), !dbg !847
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !848, metadata !DIExpression()), !dbg !849
  store i64 %2, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !850, metadata !DIExpression()), !dbg !851
  call void @llvm.dbg.declare(metadata i64* %7, metadata !852, metadata !DIExpression()), !dbg !853
  %10 = load i64, i64* %5, align 8, !dbg !854
  store i64 %10, i64* %7, align 8, !dbg !853
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #7, !dbg !855, !srcloc !856
  %11 = load %struct.vatomic64_s*, %struct.vatomic64_s** %4, align 8, !dbg !857
  %12 = getelementptr inbounds %struct.vatomic64_s, %struct.vatomic64_s* %11, i32 0, i32 0, !dbg !858
  %13 = load i64, i64* %6, align 8, !dbg !859
  store i64 %13, i64* %8, align 8, !dbg !860
  %14 = load i64, i64* %7, align 8, !dbg !860
  %15 = load i64, i64* %8, align 8, !dbg !860
  %16 = cmpxchg i64* %12, i64 %14, i64 %15 monotonic monotonic, align 8, !dbg !860
  %17 = extractvalue { i64, i1 } %16, 0, !dbg !860
  %18 = extractvalue { i64, i1 } %16, 1, !dbg !860
  br i1 %18, label %20, label %19, !dbg !860

19:                                               ; preds = %3
  store i64 %17, i64* %7, align 8, !dbg !860
  br label %20, !dbg !860

20:                                               ; preds = %19, %3
  %21 = zext i1 %18 to i8, !dbg !860
  store i8 %21, i8* %9, align 1, !dbg !860
  %22 = load i8, i8* %9, align 1, !dbg !860
  %23 = trunc i8 %22 to i1, !dbg !860
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #7, !dbg !861, !srcloc !862
  %24 = load i64, i64* %7, align 8, !dbg !863
  ret i64 %24, !dbg !864
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic64_write_rel(%struct.vatomic64_s* noundef %0, i64 noundef %1) #0 !dbg !865 {
  %3 = alloca %struct.vatomic64_s*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %3, metadata !868, metadata !DIExpression()), !dbg !869
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !870, metadata !DIExpression()), !dbg !871
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #7, !dbg !872, !srcloc !873
  %6 = load %struct.vatomic64_s*, %struct.vatomic64_s** %3, align 8, !dbg !874
  %7 = getelementptr inbounds %struct.vatomic64_s, %struct.vatomic64_s* %6, i32 0, i32 0, !dbg !875
  %8 = load i64, i64* %4, align 8, !dbg !876
  store i64 %8, i64* %5, align 8, !dbg !877
  %9 = load i64, i64* %5, align 8, !dbg !877
  store atomic i64 %9, i64* %7 release, align 8, !dbg !877
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #7, !dbg !878, !srcloc !879
  ret void, !dbg !880
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_read_acq(%struct.vatomic64_s* noundef %0) #0 !dbg !881 {
  %2 = alloca %struct.vatomic64_s*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !882, metadata !DIExpression()), !dbg !883
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #7, !dbg !884, !srcloc !885
  call void @llvm.dbg.declare(metadata i64* %3, metadata !886, metadata !DIExpression()), !dbg !887
  %5 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !888
  %6 = getelementptr inbounds %struct.vatomic64_s, %struct.vatomic64_s* %5, i32 0, i32 0, !dbg !889
  %7 = load atomic i64, i64* %6 acquire, align 8, !dbg !890
  store i64 %7, i64* %4, align 8, !dbg !890
  %8 = load i64, i64* %4, align 8, !dbg !890
  store i64 %8, i64* %3, align 8, !dbg !887
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #7, !dbg !891, !srcloc !892
  %9 = load i64, i64* %3, align 8, !dbg !893
  ret i64 %9, !dbg !894
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic64_write_rlx(%struct.vatomic64_s* noundef %0, i64 noundef %1) #0 !dbg !895 {
  %3 = alloca %struct.vatomic64_s*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %3, metadata !896, metadata !DIExpression()), !dbg !897
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !898, metadata !DIExpression()), !dbg !899
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #7, !dbg !900, !srcloc !901
  %6 = load %struct.vatomic64_s*, %struct.vatomic64_s** %3, align 8, !dbg !902
  %7 = getelementptr inbounds %struct.vatomic64_s, %struct.vatomic64_s* %6, i32 0, i32 0, !dbg !903
  %8 = load i64, i64* %4, align 8, !dbg !904
  store i64 %8, i64* %5, align 8, !dbg !905
  %9 = load i64, i64* %5, align 8, !dbg !905
  store atomic i64 %9, i64* %7 monotonic, align 8, !dbg !905
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #7, !dbg !906, !srcloc !907
  ret void, !dbg !908
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic64_init(%struct.vatomic64_s* noundef %0, i64 noundef %1) #0 !dbg !909 {
  %3 = alloca %struct.vatomic64_s*, align 8
  %4 = alloca i64, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %3, metadata !911, metadata !DIExpression()), !dbg !912
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !913, metadata !DIExpression()), !dbg !914
  %5 = load %struct.vatomic64_s*, %struct.vatomic64_s** %3, align 8, !dbg !915
  %6 = load i64, i64* %4, align 8, !dbg !916
  call void @vatomic64_write(%struct.vatomic64_s* noundef %5, i64 noundef %6), !dbg !917
  ret void, !dbg !918
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic64_write(%struct.vatomic64_s* noundef %0, i64 noundef %1) #0 !dbg !919 {
  %3 = alloca %struct.vatomic64_s*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %3, metadata !920, metadata !DIExpression()), !dbg !921
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !922, metadata !DIExpression()), !dbg !923
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #7, !dbg !924, !srcloc !925
  %6 = load %struct.vatomic64_s*, %struct.vatomic64_s** %3, align 8, !dbg !926
  %7 = getelementptr inbounds %struct.vatomic64_s, %struct.vatomic64_s* %6, i32 0, i32 0, !dbg !927
  %8 = load i64, i64* %4, align 8, !dbg !928
  store i64 %8, i64* %5, align 8, !dbg !929
  %9 = load i64, i64* %5, align 8, !dbg !929
  store atomic i64 %9, i64* %7 seq_cst, align 8, !dbg !929
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #7, !dbg !930, !srcloc !931
  ret void, !dbg !932
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { argmemonly nofree nounwind willreturn writeonly }
attributes #4 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nofree nosync nounwind willreturn }
attributes #6 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { nounwind }
attributes #8 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!52, !53, !54, !55, !56, !57, !58}
!llvm.ident = !{!59}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "write_total", scope: !2, file: !42, line: 33, type: !49, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !39, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/huawei/libvsync/datastruct/queue/cachedq/verify/cachedq_verify.c", directory: "/home/drc/git/huawei/libvsync", checksumkind: CSK_MD5, checksum: "e5ea1598f13f66e0208545cab90bb185")
!4 = !{!5, !7, !8, !15, !18}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint64_t", file: !9, line: 36, baseType: !10)
!9 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/drc/git/huawei/libvsync", checksumkind: CSK_MD5, checksum: "30c0f104aa172a4b60a16abfb81c4535")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !11, line: 27, baseType: !12)
!11 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !13, line: 45, baseType: !14)
!13 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!14 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsize_t", file: !9, line: 43, baseType: !16)
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !17, line: 46, baseType: !14)
!17 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "cachedq_t", file: !20, line: 33, baseType: !21)
!20 = !DIFile(filename: "datastruct/queue/cachedq/include/vsync/queue/cachedq.h", directory: "/home/drc/git/huawei/libvsync", checksumkind: CSK_MD5, checksum: "b3f27f33422c7a9a097815b4e7b602d2")
!21 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "cachedq_s", file: !20, line: 24, size: 448, elements: !22)
!22 = !{!23, !29, !30, !31, !32, !33, !34, !35}
!23 = !DIDerivedType(tag: DW_TAG_member, name: "phead", scope: !21, file: !20, line: 25, baseType: !24, size: 64, align: 64)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic64_t", file: !25, line: 39, baseType: !26)
!25 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/drc/git/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!26 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic64_s", file: !25, line: 37, size: 64, align: 64, elements: !27)
!27 = !{!28}
!28 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !26, file: !25, line: 38, baseType: !8, size: 64)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "ptail", scope: !21, file: !20, line: 26, baseType: !24, size: 64, align: 64, offset: 64)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "ptail_cached", scope: !21, file: !20, line: 27, baseType: !24, size: 64, align: 64, offset: 128)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "chead", scope: !21, file: !20, line: 28, baseType: !24, size: 64, align: 64, offset: 192)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "ctail", scope: !21, file: !20, line: 29, baseType: !24, size: 64, align: 64, offset: 256)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "ctail_cached", scope: !21, file: !20, line: 30, baseType: !24, size: 64, align: 64, offset: 320)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !21, file: !20, line: 31, baseType: !8, size: 64, offset: 384)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "entry", scope: !21, file: !20, line: 32, baseType: !36, offset: 448)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: -1)
!39 = !{!0, !40, !46}
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "read_total", scope: !2, file: !42, line: 34, type: !43, isLocal: false, isDefinition: true)
!42 = !DIFile(filename: "datastruct/queue/cachedq/verify/cachedq_verify.c", directory: "/home/drc/git/huawei/libvsync", checksumkind: CSK_MD5, checksum: "e5ea1598f13f66e0208545cab90bb185")
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 128, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 2)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "q", scope: !2, file: !42, line: 32, type: !48, isLocal: false, isDefinition: true)
!48 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 64, elements: !50)
!50 = !{!51}
!51 = !DISubrange(count: 1)
!52 = !{i32 7, !"Dwarf Version", i32 5}
!53 = !{i32 2, !"Debug Info Version", i32 3}
!54 = !{i32 1, !"wchar_size", i32 4}
!55 = !{i32 7, !"PIC Level", i32 2}
!56 = !{i32 7, !"PIE Level", i32 2}
!57 = !{i32 7, !"uwtable", i32 1}
!58 = !{i32 7, !"frame-pointer", i32 2}
!59 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!60 = distinct !DISubprogram(name: "writer", scope: !42, file: !42, line: 37, type: !61, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!61 = !DISubroutineType(types: !62)
!62 = !{!7, !7}
!63 = !{}
!64 = !DILocalVariable(name: "data", arg: 1, scope: !60, file: !42, line: 37, type: !7)
!65 = !DILocation(line: 37, column: 14, scope: !60)
!66 = !DILocalVariable(name: "id", scope: !60, file: !42, line: 39, type: !6)
!67 = !DILocation(line: 39, column: 9, scope: !60)
!68 = !DILocation(line: 39, column: 22, scope: !60)
!69 = !DILocation(line: 39, column: 15, scope: !60)
!70 = !DILocation(line: 39, column: 14, scope: !60)
!71 = !DILocalVariable(name: "buf", scope: !60, file: !42, line: 40, type: !72)
!72 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 64, elements: !50)
!73 = !DILocation(line: 40, column: 15, scope: !60)
!74 = !DILocalVariable(name: "i", scope: !75, file: !42, line: 41, type: !6)
!75 = distinct !DILexicalBlock(scope: !60, file: !42, line: 41, column: 5)
!76 = !DILocation(line: 41, column: 14, scope: !75)
!77 = !DILocation(line: 41, column: 10, scope: !75)
!78 = !DILocation(line: 41, column: 21, scope: !79)
!79 = distinct !DILexicalBlock(scope: !75, file: !42, line: 41, column: 5)
!80 = !DILocation(line: 41, column: 23, scope: !79)
!81 = !DILocation(line: 41, column: 5, scope: !75)
!82 = !DILocalVariable(name: "j", scope: !83, file: !42, line: 42, type: !6)
!83 = distinct !DILexicalBlock(scope: !84, file: !42, line: 42, column: 9)
!84 = distinct !DILexicalBlock(scope: !79, file: !42, line: 41, column: 74)
!85 = !DILocation(line: 42, column: 18, scope: !83)
!86 = !DILocation(line: 42, column: 14, scope: !83)
!87 = !DILocation(line: 42, column: 25, scope: !88)
!88 = distinct !DILexicalBlock(scope: !83, file: !42, line: 42, column: 9)
!89 = !DILocation(line: 42, column: 27, scope: !88)
!90 = !DILocation(line: 42, column: 9, scope: !83)
!91 = !DILocalVariable(name: "offset", scope: !92, file: !42, line: 43, type: !8)
!92 = distinct !DILexicalBlock(scope: !88, file: !42, line: 42, column: 49)
!93 = !DILocation(line: 43, column: 23, scope: !92)
!94 = !DILocation(line: 44, column: 17, scope: !92)
!95 = !DILocation(line: 44, column: 20, scope: !92)
!96 = !DILocation(line: 44, column: 33, scope: !92)
!97 = !DILocation(line: 44, column: 51, scope: !92)
!98 = !DILocation(line: 44, column: 53, scope: !92)
!99 = !DILocation(line: 44, column: 49, scope: !92)
!100 = !DILocation(line: 44, column: 71, scope: !92)
!101 = !DILocation(line: 44, column: 69, scope: !92)
!102 = !DILocation(line: 45, column: 29, scope: !92)
!103 = !DILocation(line: 45, column: 26, scope: !92)
!104 = !DILocation(line: 45, column: 17, scope: !92)
!105 = !DILocation(line: 45, column: 13, scope: !92)
!106 = !DILocation(line: 45, column: 20, scope: !92)
!107 = !DILocation(line: 46, column: 9, scope: !92)
!108 = !DILocation(line: 42, column: 45, scope: !88)
!109 = !DILocation(line: 42, column: 9, scope: !88)
!110 = distinct !{!110, !90, !111, !112}
!111 = !DILocation(line: 46, column: 9, scope: !83)
!112 = !{!"llvm.loop.mustprogress"}
!113 = !DILocalVariable(name: "num", scope: !84, file: !42, line: 47, type: !8)
!114 = !DILocation(line: 47, column: 19, scope: !84)
!115 = !DILocation(line: 47, column: 41, scope: !84)
!116 = !DILocation(line: 47, column: 44, scope: !84)
!117 = !DILocation(line: 47, column: 25, scope: !84)
!118 = !DILocalVariable(name: "k", scope: !119, file: !42, line: 48, type: !8)
!119 = distinct !DILexicalBlock(scope: !84, file: !42, line: 48, column: 9)
!120 = !DILocation(line: 48, column: 24, scope: !119)
!121 = !DILocation(line: 48, column: 14, scope: !119)
!122 = !DILocation(line: 48, column: 31, scope: !123)
!123 = distinct !DILexicalBlock(scope: !119, file: !42, line: 48, column: 9)
!124 = !DILocation(line: 48, column: 35, scope: !123)
!125 = !DILocation(line: 48, column: 33, scope: !123)
!126 = !DILocation(line: 48, column: 9, scope: !119)
!127 = !DILocation(line: 49, column: 36, scope: !128)
!128 = distinct !DILexicalBlock(scope: !123, file: !42, line: 48, column: 45)
!129 = !DILocation(line: 49, column: 32, scope: !128)
!130 = !DILocation(line: 49, column: 25, scope: !128)
!131 = !DILocation(line: 49, column: 13, scope: !128)
!132 = !DILocation(line: 49, column: 29, scope: !128)
!133 = !DILocation(line: 50, column: 9, scope: !128)
!134 = !DILocation(line: 48, column: 41, scope: !123)
!135 = !DILocation(line: 48, column: 9, scope: !123)
!136 = distinct !{!136, !126, !137, !112}
!137 = !DILocation(line: 50, column: 9, scope: !119)
!138 = !DILocation(line: 51, column: 5, scope: !84)
!139 = !DILocation(line: 41, column: 70, scope: !79)
!140 = !DILocation(line: 41, column: 5, scope: !79)
!141 = distinct !{!141, !81, !142, !112}
!142 = !DILocation(line: 51, column: 5, scope: !75)
!143 = !DILocation(line: 52, column: 10, scope: !60)
!144 = !DILocation(line: 52, column: 5, scope: !60)
!145 = !DILocation(line: 53, column: 5, scope: !60)
!146 = distinct !DISubprogram(name: "cachedq_enqueue", scope: !20, file: !20, line: 84, type: !147, scopeLine: 85, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!147 = !DISubroutineType(types: !148)
!148 = !{!15, !18, !149, !15}
!149 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!150 = !DILocalVariable(name: "q", arg: 1, scope: !146, file: !20, line: 84, type: !18)
!151 = !DILocation(line: 84, column: 28, scope: !146)
!152 = !DILocalVariable(name: "buf", arg: 2, scope: !146, file: !20, line: 84, type: !149)
!153 = !DILocation(line: 84, column: 42, scope: !146)
!154 = !DILocalVariable(name: "count", arg: 3, scope: !146, file: !20, line: 84, type: !15)
!155 = !DILocation(line: 84, column: 55, scope: !146)
!156 = !DILocation(line: 85, column: 1, scope: !146)
!157 = !DILabel(scope: !146, name: "again", file: !20, line: 86)
!158 = !DILocation(line: 86, column: 1, scope: !146)
!159 = !DILocalVariable(name: "phead", scope: !146, file: !20, line: 87, type: !8)
!160 = !DILocation(line: 87, column: 15, scope: !146)
!161 = !DILocation(line: 87, column: 50, scope: !146)
!162 = !DILocation(line: 87, column: 53, scope: !146)
!163 = !DILocation(line: 87, column: 30, scope: !146)
!164 = !DILocalVariable(name: "pnext", scope: !146, file: !20, line: 88, type: !8)
!165 = !DILocation(line: 88, column: 15, scope: !146)
!166 = !DILocation(line: 88, column: 30, scope: !146)
!167 = !DILocation(line: 88, column: 38, scope: !146)
!168 = !DILocation(line: 88, column: 36, scope: !146)
!169 = !DILocalVariable(name: "ctail_cached", scope: !146, file: !20, line: 89, type: !8)
!170 = !DILocation(line: 89, column: 15, scope: !146)
!171 = !DILocation(line: 89, column: 50, scope: !146)
!172 = !DILocation(line: 89, column: 53, scope: !146)
!173 = !DILocation(line: 89, column: 30, scope: !146)
!174 = !DILocation(line: 91, column: 9, scope: !175)
!175 = distinct !DILexicalBlock(scope: !146, file: !20, line: 91, column: 9)
!176 = !DILocation(line: 91, column: 18, scope: !175)
!177 = !DILocation(line: 91, column: 33, scope: !175)
!178 = !DILocation(line: 91, column: 36, scope: !175)
!179 = !DILocation(line: 91, column: 31, scope: !175)
!180 = !DILocation(line: 91, column: 15, scope: !175)
!181 = !DILocation(line: 91, column: 9, scope: !146)
!182 = !DILocation(line: 92, column: 36, scope: !183)
!183 = distinct !DILexicalBlock(scope: !184, file: !20, line: 92, column: 13)
!184 = distinct !DILexicalBlock(scope: !175, file: !20, line: 91, column: 42)
!185 = !DILocation(line: 92, column: 39, scope: !183)
!186 = !DILocation(line: 92, column: 46, scope: !183)
!187 = !DILocation(line: 92, column: 53, scope: !183)
!188 = !DILocation(line: 92, column: 13, scope: !183)
!189 = !DILocation(line: 92, column: 63, scope: !183)
!190 = !DILocation(line: 92, column: 60, scope: !183)
!191 = !DILocation(line: 92, column: 13, scope: !184)
!192 = !DILocation(line: 93, column: 13, scope: !193)
!193 = distinct !DILexicalBlock(scope: !183, file: !20, line: 92, column: 70)
!194 = !DILocalVariable(name: "i", scope: !195, file: !20, line: 95, type: !15)
!195 = distinct !DILexicalBlock(scope: !184, file: !20, line: 95, column: 9)
!196 = !DILocation(line: 95, column: 22, scope: !195)
!197 = !DILocation(line: 95, column: 14, scope: !195)
!198 = !DILocation(line: 95, column: 29, scope: !199)
!199 = distinct !DILexicalBlock(scope: !195, file: !20, line: 95, column: 9)
!200 = !DILocation(line: 95, column: 33, scope: !199)
!201 = !DILocation(line: 95, column: 31, scope: !199)
!202 = !DILocation(line: 95, column: 9, scope: !195)
!203 = !DILocation(line: 96, column: 47, scope: !204)
!204 = distinct !DILexicalBlock(scope: !199, file: !20, line: 95, column: 45)
!205 = !DILocation(line: 96, column: 51, scope: !204)
!206 = !DILocation(line: 96, column: 13, scope: !204)
!207 = !DILocation(line: 96, column: 16, scope: !204)
!208 = !DILocation(line: 96, column: 23, scope: !204)
!209 = !DILocation(line: 96, column: 31, scope: !204)
!210 = !DILocation(line: 96, column: 29, scope: !204)
!211 = !DILocation(line: 96, column: 36, scope: !204)
!212 = !DILocation(line: 96, column: 39, scope: !204)
!213 = !DILocation(line: 96, column: 34, scope: !204)
!214 = !DILocation(line: 96, column: 45, scope: !204)
!215 = !DILocation(line: 97, column: 9, scope: !204)
!216 = !DILocation(line: 95, column: 41, scope: !199)
!217 = !DILocation(line: 95, column: 9, scope: !199)
!218 = distinct !{!218, !202, !219, !112}
!219 = !DILocation(line: 97, column: 9, scope: !195)
!220 = !DILocation(line: 98, column: 9, scope: !184)
!221 = distinct !{!221, !220, !222, !112}
!222 = !DILocation(line: 98, column: 63, scope: !184)
!223 = !DILocation(line: 99, column: 30, scope: !184)
!224 = !DILocation(line: 99, column: 33, scope: !184)
!225 = !DILocation(line: 99, column: 40, scope: !184)
!226 = !DILocation(line: 99, column: 9, scope: !184)
!227 = !DILocation(line: 100, column: 16, scope: !184)
!228 = !DILocation(line: 100, column: 9, scope: !184)
!229 = !DILocalVariable(name: "ctail", scope: !230, file: !20, line: 102, type: !8)
!230 = distinct !DILexicalBlock(scope: !175, file: !20, line: 101, column: 12)
!231 = !DILocation(line: 102, column: 19, scope: !230)
!232 = !DILocation(line: 102, column: 47, scope: !230)
!233 = !DILocation(line: 102, column: 50, scope: !230)
!234 = !DILocation(line: 102, column: 27, scope: !230)
!235 = !DILocation(line: 103, column: 13, scope: !236)
!236 = distinct !DILexicalBlock(scope: !230, file: !20, line: 103, column: 13)
!237 = !DILocation(line: 103, column: 22, scope: !236)
!238 = !DILocation(line: 103, column: 30, scope: !236)
!239 = !DILocation(line: 103, column: 33, scope: !236)
!240 = !DILocation(line: 103, column: 28, scope: !236)
!241 = !DILocation(line: 103, column: 19, scope: !236)
!242 = !DILocation(line: 103, column: 13, scope: !230)
!243 = !DILocation(line: 104, column: 40, scope: !244)
!244 = distinct !DILexicalBlock(scope: !245, file: !20, line: 104, column: 17)
!245 = distinct !DILexicalBlock(scope: !236, file: !20, line: 103, column: 39)
!246 = !DILocation(line: 104, column: 43, scope: !244)
!247 = !DILocation(line: 104, column: 50, scope: !244)
!248 = !DILocation(line: 104, column: 57, scope: !244)
!249 = !DILocation(line: 104, column: 17, scope: !244)
!250 = !DILocation(line: 104, column: 67, scope: !244)
!251 = !DILocation(line: 104, column: 64, scope: !244)
!252 = !DILocation(line: 104, column: 17, scope: !245)
!253 = !DILocation(line: 105, column: 17, scope: !254)
!254 = distinct !DILexicalBlock(scope: !244, file: !20, line: 104, column: 74)
!255 = !DILocation(line: 107, column: 34, scope: !245)
!256 = !DILocation(line: 107, column: 37, scope: !245)
!257 = !DILocation(line: 107, column: 51, scope: !245)
!258 = !DILocation(line: 107, column: 13, scope: !245)
!259 = !DILocalVariable(name: "i", scope: !260, file: !20, line: 108, type: !15)
!260 = distinct !DILexicalBlock(scope: !245, file: !20, line: 108, column: 13)
!261 = !DILocation(line: 108, column: 26, scope: !260)
!262 = !DILocation(line: 108, column: 18, scope: !260)
!263 = !DILocation(line: 108, column: 33, scope: !264)
!264 = distinct !DILexicalBlock(scope: !260, file: !20, line: 108, column: 13)
!265 = !DILocation(line: 108, column: 37, scope: !264)
!266 = !DILocation(line: 108, column: 35, scope: !264)
!267 = !DILocation(line: 108, column: 13, scope: !260)
!268 = !DILocation(line: 109, column: 51, scope: !269)
!269 = distinct !DILexicalBlock(scope: !264, file: !20, line: 108, column: 49)
!270 = !DILocation(line: 109, column: 55, scope: !269)
!271 = !DILocation(line: 109, column: 17, scope: !269)
!272 = !DILocation(line: 109, column: 20, scope: !269)
!273 = !DILocation(line: 109, column: 27, scope: !269)
!274 = !DILocation(line: 109, column: 35, scope: !269)
!275 = !DILocation(line: 109, column: 33, scope: !269)
!276 = !DILocation(line: 109, column: 40, scope: !269)
!277 = !DILocation(line: 109, column: 43, scope: !269)
!278 = !DILocation(line: 109, column: 38, scope: !269)
!279 = !DILocation(line: 109, column: 49, scope: !269)
!280 = !DILocation(line: 110, column: 13, scope: !269)
!281 = !DILocation(line: 108, column: 45, scope: !264)
!282 = !DILocation(line: 108, column: 13, scope: !264)
!283 = distinct !{!283, !267, !284, !112}
!284 = !DILocation(line: 110, column: 13, scope: !260)
!285 = !DILocation(line: 111, column: 13, scope: !245)
!286 = distinct !{!286, !285, !287, !112}
!287 = !DILocation(line: 111, column: 67, scope: !245)
!288 = !DILocation(line: 112, column: 34, scope: !245)
!289 = !DILocation(line: 112, column: 37, scope: !245)
!290 = !DILocation(line: 112, column: 44, scope: !245)
!291 = !DILocation(line: 112, column: 13, scope: !245)
!292 = !DILocation(line: 113, column: 20, scope: !245)
!293 = !DILocation(line: 113, column: 13, scope: !245)
!294 = !DILocation(line: 115, column: 13, scope: !295)
!295 = distinct !DILexicalBlock(scope: !236, file: !20, line: 114, column: 16)
!296 = !DILocation(line: 118, column: 1, scope: !146)
!297 = distinct !DISubprogram(name: "reader", scope: !42, file: !42, line: 57, type: !61, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!298 = !DILocalVariable(name: "data", arg: 1, scope: !297, file: !42, line: 57, type: !7)
!299 = !DILocation(line: 57, column: 14, scope: !297)
!300 = !DILocalVariable(name: "id", scope: !297, file: !42, line: 59, type: !6)
!301 = !DILocation(line: 59, column: 9, scope: !297)
!302 = !DILocation(line: 59, column: 22, scope: !297)
!303 = !DILocation(line: 59, column: 15, scope: !297)
!304 = !DILocation(line: 59, column: 14, scope: !297)
!305 = !DILocalVariable(name: "i", scope: !306, file: !42, line: 60, type: !6)
!306 = distinct !DILexicalBlock(scope: !297, file: !42, line: 60, column: 5)
!307 = !DILocation(line: 60, column: 14, scope: !306)
!308 = !DILocation(line: 60, column: 10, scope: !306)
!309 = !DILocation(line: 60, column: 21, scope: !310)
!310 = distinct !DILexicalBlock(scope: !306, file: !42, line: 60, column: 5)
!311 = !DILocation(line: 60, column: 23, scope: !310)
!312 = !DILocation(line: 60, column: 5, scope: !306)
!313 = !DILocalVariable(name: "buf", scope: !314, file: !42, line: 61, type: !72)
!314 = distinct !DILexicalBlock(scope: !310, file: !42, line: 60, column: 74)
!315 = !DILocation(line: 61, column: 19, scope: !314)
!316 = !DILocalVariable(name: "num", scope: !314, file: !42, line: 62, type: !8)
!317 = !DILocation(line: 62, column: 19, scope: !314)
!318 = !DILocation(line: 62, column: 56, scope: !314)
!319 = !DILocation(line: 62, column: 59, scope: !314)
!320 = !DILocation(line: 62, column: 40, scope: !314)
!321 = !DILocalVariable(name: "k", scope: !322, file: !42, line: 63, type: !8)
!322 = distinct !DILexicalBlock(scope: !314, file: !42, line: 63, column: 9)
!323 = !DILocation(line: 63, column: 24, scope: !322)
!324 = !DILocation(line: 63, column: 14, scope: !322)
!325 = !DILocation(line: 63, column: 31, scope: !326)
!326 = distinct !DILexicalBlock(scope: !322, file: !42, line: 63, column: 9)
!327 = !DILocation(line: 63, column: 35, scope: !326)
!328 = !DILocation(line: 63, column: 33, scope: !326)
!329 = !DILocation(line: 63, column: 9, scope: !322)
!330 = !DILocation(line: 64, column: 35, scope: !331)
!331 = distinct !DILexicalBlock(scope: !326, file: !42, line: 63, column: 45)
!332 = !DILocation(line: 64, column: 31, scope: !331)
!333 = !DILocation(line: 64, column: 24, scope: !331)
!334 = !DILocation(line: 64, column: 13, scope: !331)
!335 = !DILocation(line: 64, column: 28, scope: !331)
!336 = !DILocation(line: 65, column: 9, scope: !331)
!337 = !DILocation(line: 63, column: 41, scope: !326)
!338 = !DILocation(line: 63, column: 9, scope: !326)
!339 = distinct !{!339, !329, !340, !112}
!340 = !DILocation(line: 65, column: 9, scope: !322)
!341 = !DILocation(line: 66, column: 5, scope: !314)
!342 = !DILocation(line: 60, column: 70, scope: !310)
!343 = !DILocation(line: 60, column: 5, scope: !310)
!344 = distinct !{!344, !312, !345, !112}
!345 = !DILocation(line: 66, column: 5, scope: !306)
!346 = !DILocation(line: 67, column: 10, scope: !297)
!347 = !DILocation(line: 67, column: 5, scope: !297)
!348 = !DILocation(line: 68, column: 5, scope: !297)
!349 = distinct !DISubprogram(name: "cachedq_dequeue", scope: !20, file: !20, line: 131, type: !147, scopeLine: 132, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!350 = !DILocalVariable(name: "q", arg: 1, scope: !349, file: !20, line: 131, type: !18)
!351 = !DILocation(line: 131, column: 28, scope: !349)
!352 = !DILocalVariable(name: "buf", arg: 2, scope: !349, file: !20, line: 131, type: !149)
!353 = !DILocation(line: 131, column: 42, scope: !349)
!354 = !DILocalVariable(name: "count", arg: 3, scope: !349, file: !20, line: 131, type: !15)
!355 = !DILocation(line: 131, column: 55, scope: !349)
!356 = !DILocation(line: 132, column: 1, scope: !349)
!357 = !DILabel(scope: !349, name: "again", file: !20, line: 133)
!358 = !DILocation(line: 133, column: 1, scope: !349)
!359 = !DILocalVariable(name: "chead", scope: !349, file: !20, line: 134, type: !8)
!360 = !DILocation(line: 134, column: 15, scope: !349)
!361 = !DILocation(line: 134, column: 50, scope: !349)
!362 = !DILocation(line: 134, column: 53, scope: !349)
!363 = !DILocation(line: 134, column: 30, scope: !349)
!364 = !DILocalVariable(name: "cnext", scope: !349, file: !20, line: 135, type: !8)
!365 = !DILocation(line: 135, column: 15, scope: !349)
!366 = !DILocation(line: 135, column: 30, scope: !349)
!367 = !DILocation(line: 135, column: 38, scope: !349)
!368 = !DILocation(line: 135, column: 36, scope: !349)
!369 = !DILocalVariable(name: "ptail_cached", scope: !349, file: !20, line: 136, type: !8)
!370 = !DILocation(line: 136, column: 15, scope: !349)
!371 = !DILocation(line: 136, column: 50, scope: !349)
!372 = !DILocation(line: 136, column: 53, scope: !349)
!373 = !DILocation(line: 136, column: 30, scope: !349)
!374 = !DILocation(line: 138, column: 9, scope: !375)
!375 = distinct !DILexicalBlock(scope: !349, file: !20, line: 138, column: 9)
!376 = !DILocation(line: 138, column: 18, scope: !375)
!377 = !DILocation(line: 138, column: 15, scope: !375)
!378 = !DILocation(line: 138, column: 9, scope: !349)
!379 = !DILocation(line: 139, column: 36, scope: !380)
!380 = distinct !DILexicalBlock(scope: !381, file: !20, line: 139, column: 13)
!381 = distinct !DILexicalBlock(scope: !375, file: !20, line: 138, column: 32)
!382 = !DILocation(line: 139, column: 39, scope: !380)
!383 = !DILocation(line: 139, column: 46, scope: !380)
!384 = !DILocation(line: 139, column: 53, scope: !380)
!385 = !DILocation(line: 139, column: 13, scope: !380)
!386 = !DILocation(line: 139, column: 63, scope: !380)
!387 = !DILocation(line: 139, column: 60, scope: !380)
!388 = !DILocation(line: 139, column: 13, scope: !381)
!389 = !DILocation(line: 140, column: 13, scope: !390)
!390 = distinct !DILexicalBlock(scope: !380, file: !20, line: 139, column: 70)
!391 = !DILocalVariable(name: "i", scope: !392, file: !20, line: 142, type: !15)
!392 = distinct !DILexicalBlock(scope: !381, file: !20, line: 142, column: 9)
!393 = !DILocation(line: 142, column: 22, scope: !392)
!394 = !DILocation(line: 142, column: 14, scope: !392)
!395 = !DILocation(line: 142, column: 29, scope: !396)
!396 = distinct !DILexicalBlock(scope: !392, file: !20, line: 142, column: 9)
!397 = !DILocation(line: 142, column: 33, scope: !396)
!398 = !DILocation(line: 142, column: 31, scope: !396)
!399 = !DILocation(line: 142, column: 9, scope: !392)
!400 = !DILocation(line: 143, column: 22, scope: !401)
!401 = distinct !DILexicalBlock(scope: !396, file: !20, line: 142, column: 45)
!402 = !DILocation(line: 143, column: 25, scope: !401)
!403 = !DILocation(line: 143, column: 32, scope: !401)
!404 = !DILocation(line: 143, column: 40, scope: !401)
!405 = !DILocation(line: 143, column: 38, scope: !401)
!406 = !DILocation(line: 143, column: 45, scope: !401)
!407 = !DILocation(line: 143, column: 48, scope: !401)
!408 = !DILocation(line: 143, column: 43, scope: !401)
!409 = !DILocation(line: 143, column: 13, scope: !401)
!410 = !DILocation(line: 143, column: 17, scope: !401)
!411 = !DILocation(line: 143, column: 20, scope: !401)
!412 = !DILocation(line: 144, column: 9, scope: !401)
!413 = !DILocation(line: 142, column: 41, scope: !396)
!414 = !DILocation(line: 142, column: 9, scope: !396)
!415 = distinct !{!415, !399, !416, !112}
!416 = !DILocation(line: 144, column: 9, scope: !392)
!417 = !DILocation(line: 145, column: 9, scope: !381)
!418 = distinct !{!418, !417, !419, !112}
!419 = !DILocation(line: 145, column: 63, scope: !381)
!420 = !DILocation(line: 146, column: 30, scope: !381)
!421 = !DILocation(line: 146, column: 33, scope: !381)
!422 = !DILocation(line: 146, column: 40, scope: !381)
!423 = !DILocation(line: 146, column: 9, scope: !381)
!424 = !DILocation(line: 147, column: 16, scope: !381)
!425 = !DILocation(line: 147, column: 9, scope: !381)
!426 = !DILocalVariable(name: "ptail", scope: !427, file: !20, line: 149, type: !8)
!427 = distinct !DILexicalBlock(scope: !375, file: !20, line: 148, column: 12)
!428 = !DILocation(line: 149, column: 19, scope: !427)
!429 = !DILocation(line: 149, column: 47, scope: !427)
!430 = !DILocation(line: 149, column: 50, scope: !427)
!431 = !DILocation(line: 149, column: 27, scope: !427)
!432 = !DILocation(line: 150, column: 13, scope: !433)
!433 = distinct !DILexicalBlock(scope: !427, file: !20, line: 150, column: 13)
!434 = !DILocation(line: 150, column: 22, scope: !433)
!435 = !DILocation(line: 150, column: 19, scope: !433)
!436 = !DILocation(line: 150, column: 13, scope: !427)
!437 = !DILocation(line: 151, column: 40, scope: !438)
!438 = distinct !DILexicalBlock(scope: !439, file: !20, line: 151, column: 17)
!439 = distinct !DILexicalBlock(scope: !433, file: !20, line: 150, column: 29)
!440 = !DILocation(line: 151, column: 43, scope: !438)
!441 = !DILocation(line: 151, column: 50, scope: !438)
!442 = !DILocation(line: 151, column: 57, scope: !438)
!443 = !DILocation(line: 151, column: 17, scope: !438)
!444 = !DILocation(line: 151, column: 67, scope: !438)
!445 = !DILocation(line: 151, column: 64, scope: !438)
!446 = !DILocation(line: 151, column: 17, scope: !439)
!447 = !DILocation(line: 152, column: 17, scope: !448)
!448 = distinct !DILexicalBlock(scope: !438, file: !20, line: 151, column: 74)
!449 = !DILocation(line: 154, column: 34, scope: !439)
!450 = !DILocation(line: 154, column: 37, scope: !439)
!451 = !DILocation(line: 154, column: 51, scope: !439)
!452 = !DILocation(line: 154, column: 13, scope: !439)
!453 = !DILocalVariable(name: "i", scope: !454, file: !20, line: 155, type: !15)
!454 = distinct !DILexicalBlock(scope: !439, file: !20, line: 155, column: 13)
!455 = !DILocation(line: 155, column: 26, scope: !454)
!456 = !DILocation(line: 155, column: 18, scope: !454)
!457 = !DILocation(line: 155, column: 33, scope: !458)
!458 = distinct !DILexicalBlock(scope: !454, file: !20, line: 155, column: 13)
!459 = !DILocation(line: 155, column: 37, scope: !458)
!460 = !DILocation(line: 155, column: 35, scope: !458)
!461 = !DILocation(line: 155, column: 13, scope: !454)
!462 = !DILocation(line: 156, column: 26, scope: !463)
!463 = distinct !DILexicalBlock(scope: !458, file: !20, line: 155, column: 49)
!464 = !DILocation(line: 156, column: 29, scope: !463)
!465 = !DILocation(line: 156, column: 36, scope: !463)
!466 = !DILocation(line: 156, column: 44, scope: !463)
!467 = !DILocation(line: 156, column: 42, scope: !463)
!468 = !DILocation(line: 156, column: 49, scope: !463)
!469 = !DILocation(line: 156, column: 52, scope: !463)
!470 = !DILocation(line: 156, column: 47, scope: !463)
!471 = !DILocation(line: 156, column: 17, scope: !463)
!472 = !DILocation(line: 156, column: 21, scope: !463)
!473 = !DILocation(line: 156, column: 24, scope: !463)
!474 = !DILocation(line: 157, column: 13, scope: !463)
!475 = !DILocation(line: 155, column: 45, scope: !458)
!476 = !DILocation(line: 155, column: 13, scope: !458)
!477 = distinct !{!477, !461, !478, !112}
!478 = !DILocation(line: 157, column: 13, scope: !454)
!479 = !DILocation(line: 158, column: 13, scope: !439)
!480 = distinct !{!480, !479, !481, !112}
!481 = !DILocation(line: 158, column: 67, scope: !439)
!482 = !DILocation(line: 159, column: 34, scope: !439)
!483 = !DILocation(line: 159, column: 37, scope: !439)
!484 = !DILocation(line: 159, column: 44, scope: !439)
!485 = !DILocation(line: 159, column: 13, scope: !439)
!486 = !DILocation(line: 160, column: 20, scope: !439)
!487 = !DILocation(line: 160, column: 13, scope: !439)
!488 = !DILocation(line: 161, column: 20, scope: !489)
!489 = distinct !DILexicalBlock(scope: !433, file: !20, line: 161, column: 20)
!490 = !DILocation(line: 161, column: 28, scope: !489)
!491 = !DILocation(line: 161, column: 26, scope: !489)
!492 = !DILocation(line: 161, column: 20, scope: !433)
!493 = !DILocation(line: 162, column: 21, scope: !494)
!494 = distinct !DILexicalBlock(scope: !489, file: !20, line: 161, column: 35)
!495 = !DILocation(line: 162, column: 19, scope: !494)
!496 = !DILocation(line: 163, column: 13, scope: !497)
!497 = distinct !DILexicalBlock(scope: !498, file: !20, line: 163, column: 13)
!498 = distinct !DILexicalBlock(scope: !494, file: !20, line: 163, column: 13)
!499 = !DILocation(line: 163, column: 13, scope: !498)
!500 = !DILocation(line: 164, column: 31, scope: !494)
!501 = !DILocation(line: 164, column: 39, scope: !494)
!502 = !DILocation(line: 164, column: 37, scope: !494)
!503 = !DILocation(line: 164, column: 19, scope: !494)
!504 = !DILocation(line: 165, column: 40, scope: !505)
!505 = distinct !DILexicalBlock(scope: !494, file: !20, line: 165, column: 17)
!506 = !DILocation(line: 165, column: 43, scope: !505)
!507 = !DILocation(line: 165, column: 50, scope: !505)
!508 = !DILocation(line: 165, column: 57, scope: !505)
!509 = !DILocation(line: 165, column: 17, scope: !505)
!510 = !DILocation(line: 165, column: 67, scope: !505)
!511 = !DILocation(line: 165, column: 64, scope: !505)
!512 = !DILocation(line: 165, column: 17, scope: !494)
!513 = !DILocation(line: 166, column: 17, scope: !514)
!514 = distinct !DILexicalBlock(scope: !505, file: !20, line: 165, column: 74)
!515 = !DILocation(line: 168, column: 34, scope: !494)
!516 = !DILocation(line: 168, column: 37, scope: !494)
!517 = !DILocation(line: 168, column: 51, scope: !494)
!518 = !DILocation(line: 168, column: 13, scope: !494)
!519 = !DILocalVariable(name: "i", scope: !520, file: !20, line: 169, type: !15)
!520 = distinct !DILexicalBlock(scope: !494, file: !20, line: 169, column: 13)
!521 = !DILocation(line: 169, column: 26, scope: !520)
!522 = !DILocation(line: 169, column: 18, scope: !520)
!523 = !DILocation(line: 169, column: 33, scope: !524)
!524 = distinct !DILexicalBlock(scope: !520, file: !20, line: 169, column: 13)
!525 = !DILocation(line: 169, column: 37, scope: !524)
!526 = !DILocation(line: 169, column: 35, scope: !524)
!527 = !DILocation(line: 169, column: 13, scope: !520)
!528 = !DILocation(line: 170, column: 26, scope: !529)
!529 = distinct !DILexicalBlock(scope: !524, file: !20, line: 169, column: 49)
!530 = !DILocation(line: 170, column: 29, scope: !529)
!531 = !DILocation(line: 170, column: 36, scope: !529)
!532 = !DILocation(line: 170, column: 44, scope: !529)
!533 = !DILocation(line: 170, column: 42, scope: !529)
!534 = !DILocation(line: 170, column: 49, scope: !529)
!535 = !DILocation(line: 170, column: 52, scope: !529)
!536 = !DILocation(line: 170, column: 47, scope: !529)
!537 = !DILocation(line: 170, column: 17, scope: !529)
!538 = !DILocation(line: 170, column: 21, scope: !529)
!539 = !DILocation(line: 170, column: 24, scope: !529)
!540 = !DILocation(line: 171, column: 13, scope: !529)
!541 = !DILocation(line: 169, column: 45, scope: !524)
!542 = !DILocation(line: 169, column: 13, scope: !524)
!543 = distinct !{!543, !527, !544, !112}
!544 = !DILocation(line: 171, column: 13, scope: !520)
!545 = !DILocation(line: 172, column: 13, scope: !494)
!546 = distinct !{!546, !545, !547, !112}
!547 = !DILocation(line: 172, column: 67, scope: !494)
!548 = !DILocation(line: 173, column: 34, scope: !494)
!549 = !DILocation(line: 173, column: 37, scope: !494)
!550 = !DILocation(line: 173, column: 44, scope: !494)
!551 = !DILocation(line: 173, column: 13, scope: !494)
!552 = !DILocation(line: 174, column: 20, scope: !494)
!553 = !DILocation(line: 174, column: 13, scope: !494)
!554 = !DILocation(line: 176, column: 13, scope: !555)
!555 = distinct !DILexicalBlock(scope: !489, file: !20, line: 175, column: 16)
!556 = !DILocation(line: 179, column: 1, scope: !349)
!557 = distinct !DISubprogram(name: "main", scope: !42, file: !42, line: 72, type: !558, scopeLine: 73, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!558 = !DISubroutineType(types: !559)
!559 = !{!6}
!560 = !DILocalVariable(name: "buf_size", scope: !557, file: !42, line: 78, type: !15)
!561 = !DILocation(line: 78, column: 13, scope: !557)
!562 = !DILocation(line: 78, column: 24, scope: !557)
!563 = !DILocalVariable(name: "buf", scope: !557, file: !42, line: 79, type: !7)
!564 = !DILocation(line: 79, column: 11, scope: !557)
!565 = !DILocation(line: 79, column: 31, scope: !557)
!566 = !DILocation(line: 79, column: 24, scope: !557)
!567 = !DILocation(line: 80, column: 37, scope: !557)
!568 = !DILocation(line: 80, column: 42, scope: !557)
!569 = !DILocation(line: 80, column: 24, scope: !557)
!570 = !DILocation(line: 80, column: 22, scope: !557)
!571 = !DILocation(line: 81, column: 9, scope: !572)
!572 = distinct !DILexicalBlock(scope: !557, file: !42, line: 81, column: 9)
!573 = !DILocation(line: 81, column: 11, scope: !572)
!574 = !DILocation(line: 81, column: 9, scope: !557)
!575 = !DILocation(line: 82, column: 9, scope: !572)
!576 = !DILocalVariable(name: "TW", scope: !557, file: !42, line: 84, type: !6)
!577 = !DILocation(line: 84, column: 9, scope: !557)
!578 = !DILocation(line: 85, column: 24, scope: !557)
!579 = !DILocation(line: 85, column: 5, scope: !557)
!580 = !DILocalVariable(name: "__vla_expr0", scope: !557, type: !14, flags: DIFlagArtificial)
!581 = !DILocation(line: 0, scope: !557)
!582 = !DILocalVariable(name: "thread_w", scope: !557, file: !42, line: 85, type: !583)
!583 = !DICompositeType(tag: DW_TAG_array_type, baseType: !584, elements: !586)
!584 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !585, line: 27, baseType: !14)
!585 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!586 = !{!587}
!587 = !DISubrange(count: !580)
!588 = !DILocation(line: 85, column: 15, scope: !557)
!589 = !DILocalVariable(name: "i", scope: !590, file: !42, line: 86, type: !6)
!590 = distinct !DILexicalBlock(scope: !557, file: !42, line: 86, column: 5)
!591 = !DILocation(line: 86, column: 14, scope: !590)
!592 = !DILocation(line: 86, column: 10, scope: !590)
!593 = !DILocation(line: 86, column: 21, scope: !594)
!594 = distinct !DILexicalBlock(scope: !590, file: !42, line: 86, column: 5)
!595 = !DILocation(line: 86, column: 25, scope: !594)
!596 = !DILocation(line: 86, column: 23, scope: !594)
!597 = !DILocation(line: 86, column: 5, scope: !590)
!598 = !DILocalVariable(name: "arg", scope: !599, file: !42, line: 87, type: !5)
!599 = distinct !DILexicalBlock(scope: !594, file: !42, line: 86, column: 34)
!600 = !DILocation(line: 87, column: 14, scope: !599)
!601 = !DILocation(line: 87, column: 27, scope: !599)
!602 = !DILocation(line: 87, column: 20, scope: !599)
!603 = !DILocation(line: 88, column: 20, scope: !599)
!604 = !DILocation(line: 88, column: 10, scope: !599)
!605 = !DILocation(line: 88, column: 18, scope: !599)
!606 = !DILocation(line: 89, column: 34, scope: !599)
!607 = !DILocation(line: 89, column: 25, scope: !599)
!608 = !DILocation(line: 89, column: 60, scope: !599)
!609 = !DILocation(line: 89, column: 52, scope: !599)
!610 = !DILocation(line: 89, column: 9, scope: !599)
!611 = !DILocation(line: 90, column: 5, scope: !599)
!612 = !DILocation(line: 86, column: 30, scope: !594)
!613 = !DILocation(line: 86, column: 5, scope: !594)
!614 = distinct !{!614, !597, !615, !112}
!615 = !DILocation(line: 90, column: 5, scope: !590)
!616 = !DILocalVariable(name: "TR", scope: !557, file: !42, line: 92, type: !6)
!617 = !DILocation(line: 92, column: 9, scope: !557)
!618 = !DILocation(line: 93, column: 24, scope: !557)
!619 = !DILocation(line: 93, column: 27, scope: !557)
!620 = !DILocation(line: 93, column: 5, scope: !557)
!621 = !DILocalVariable(name: "__vla_expr1", scope: !557, type: !14, flags: DIFlagArtificial)
!622 = !DILocalVariable(name: "thread_r", scope: !557, file: !42, line: 93, type: !623)
!623 = !DICompositeType(tag: DW_TAG_array_type, baseType: !584, elements: !624)
!624 = !{!625}
!625 = !DISubrange(count: !621)
!626 = !DILocation(line: 93, column: 15, scope: !557)
!627 = !DILocalVariable(name: "i", scope: !628, file: !42, line: 94, type: !6)
!628 = distinct !DILexicalBlock(scope: !557, file: !42, line: 94, column: 5)
!629 = !DILocation(line: 94, column: 14, scope: !628)
!630 = !DILocation(line: 94, column: 10, scope: !628)
!631 = !DILocation(line: 94, column: 21, scope: !632)
!632 = distinct !DILexicalBlock(scope: !628, file: !42, line: 94, column: 5)
!633 = !DILocation(line: 94, column: 25, scope: !632)
!634 = !DILocation(line: 94, column: 23, scope: !632)
!635 = !DILocation(line: 94, column: 5, scope: !628)
!636 = !DILocalVariable(name: "arg", scope: !637, file: !42, line: 95, type: !5)
!637 = distinct !DILexicalBlock(scope: !632, file: !42, line: 94, column: 34)
!638 = !DILocation(line: 95, column: 14, scope: !637)
!639 = !DILocation(line: 95, column: 27, scope: !637)
!640 = !DILocation(line: 95, column: 20, scope: !637)
!641 = !DILocation(line: 96, column: 20, scope: !637)
!642 = !DILocation(line: 96, column: 10, scope: !637)
!643 = !DILocation(line: 96, column: 18, scope: !637)
!644 = !DILocation(line: 97, column: 34, scope: !637)
!645 = !DILocation(line: 97, column: 25, scope: !637)
!646 = !DILocation(line: 97, column: 60, scope: !637)
!647 = !DILocation(line: 97, column: 52, scope: !637)
!648 = !DILocation(line: 97, column: 9, scope: !637)
!649 = !DILocation(line: 98, column: 5, scope: !637)
!650 = !DILocation(line: 94, column: 30, scope: !632)
!651 = !DILocation(line: 94, column: 5, scope: !632)
!652 = distinct !{!652, !635, !653, !112}
!653 = !DILocation(line: 98, column: 5, scope: !628)
!654 = !DILocalVariable(name: "i", scope: !655, file: !42, line: 100, type: !6)
!655 = distinct !DILexicalBlock(scope: !557, file: !42, line: 100, column: 5)
!656 = !DILocation(line: 100, column: 14, scope: !655)
!657 = !DILocation(line: 100, column: 10, scope: !655)
!658 = !DILocation(line: 100, column: 21, scope: !659)
!659 = distinct !DILexicalBlock(scope: !655, file: !42, line: 100, column: 5)
!660 = !DILocation(line: 100, column: 25, scope: !659)
!661 = !DILocation(line: 100, column: 23, scope: !659)
!662 = !DILocation(line: 100, column: 5, scope: !655)
!663 = !DILocation(line: 101, column: 31, scope: !659)
!664 = !DILocation(line: 101, column: 22, scope: !659)
!665 = !DILocation(line: 101, column: 9, scope: !659)
!666 = !DILocation(line: 100, column: 30, scope: !659)
!667 = !DILocation(line: 100, column: 5, scope: !659)
!668 = distinct !{!668, !662, !669, !112}
!669 = !DILocation(line: 101, column: 39, scope: !655)
!670 = !DILocalVariable(name: "i", scope: !671, file: !42, line: 102, type: !6)
!671 = distinct !DILexicalBlock(scope: !557, file: !42, line: 102, column: 5)
!672 = !DILocation(line: 102, column: 14, scope: !671)
!673 = !DILocation(line: 102, column: 10, scope: !671)
!674 = !DILocation(line: 102, column: 21, scope: !675)
!675 = distinct !DILexicalBlock(scope: !671, file: !42, line: 102, column: 5)
!676 = !DILocation(line: 102, column: 25, scope: !675)
!677 = !DILocation(line: 102, column: 23, scope: !675)
!678 = !DILocation(line: 102, column: 5, scope: !671)
!679 = !DILocation(line: 103, column: 31, scope: !675)
!680 = !DILocation(line: 103, column: 22, scope: !675)
!681 = !DILocation(line: 103, column: 9, scope: !675)
!682 = !DILocation(line: 102, column: 30, scope: !675)
!683 = !DILocation(line: 102, column: 5, scope: !675)
!684 = distinct !{!684, !678, !685, !112}
!685 = !DILocation(line: 103, column: 39, scope: !671)
!686 = !DILocalVariable(name: "write_total_sum", scope: !557, file: !42, line: 105, type: !8)
!687 = !DILocation(line: 105, column: 15, scope: !557)
!688 = !DILocalVariable(name: "i", scope: !689, file: !42, line: 106, type: !6)
!689 = distinct !DILexicalBlock(scope: !557, file: !42, line: 106, column: 5)
!690 = !DILocation(line: 106, column: 14, scope: !689)
!691 = !DILocation(line: 106, column: 10, scope: !689)
!692 = !DILocation(line: 106, column: 21, scope: !693)
!693 = distinct !DILexicalBlock(scope: !689, file: !42, line: 106, column: 5)
!694 = !DILocation(line: 106, column: 23, scope: !693)
!695 = !DILocation(line: 106, column: 5, scope: !689)
!696 = !DILocation(line: 107, column: 40, scope: !697)
!697 = distinct !DILexicalBlock(scope: !693, file: !42, line: 106, column: 45)
!698 = !DILocation(line: 107, column: 28, scope: !697)
!699 = !DILocation(line: 107, column: 25, scope: !697)
!700 = !DILocation(line: 108, column: 5, scope: !697)
!701 = !DILocation(line: 106, column: 41, scope: !693)
!702 = !DILocation(line: 106, column: 5, scope: !693)
!703 = distinct !{!703, !695, !704, !112}
!704 = !DILocation(line: 108, column: 5, scope: !689)
!705 = !DILocalVariable(name: "arg", scope: !706, file: !42, line: 111, type: !5)
!706 = distinct !DILexicalBlock(scope: !557, file: !42, line: 110, column: 5)
!707 = !DILocation(line: 111, column: 14, scope: !706)
!708 = !DILocation(line: 111, column: 27, scope: !706)
!709 = !DILocation(line: 111, column: 20, scope: !706)
!710 = !DILocation(line: 112, column: 20, scope: !706)
!711 = !DILocation(line: 112, column: 10, scope: !706)
!712 = !DILocation(line: 112, column: 18, scope: !706)
!713 = !DILocation(line: 113, column: 34, scope: !706)
!714 = !DILocation(line: 113, column: 25, scope: !706)
!715 = !DILocation(line: 113, column: 61, scope: !706)
!716 = !DILocation(line: 113, column: 53, scope: !706)
!717 = !DILocation(line: 113, column: 9, scope: !706)
!718 = !DILocation(line: 114, column: 31, scope: !706)
!719 = !DILocation(line: 114, column: 22, scope: !706)
!720 = !DILocation(line: 114, column: 9, scope: !706)
!721 = !DILocalVariable(name: "read_total_sum", scope: !557, file: !42, line: 117, type: !8)
!722 = !DILocation(line: 117, column: 15, scope: !557)
!723 = !DILocalVariable(name: "i", scope: !724, file: !42, line: 118, type: !6)
!724 = distinct !DILexicalBlock(scope: !557, file: !42, line: 118, column: 5)
!725 = !DILocation(line: 118, column: 14, scope: !724)
!726 = !DILocation(line: 118, column: 10, scope: !724)
!727 = !DILocation(line: 118, column: 21, scope: !728)
!728 = distinct !DILexicalBlock(scope: !724, file: !42, line: 118, column: 5)
!729 = !DILocation(line: 118, column: 23, scope: !728)
!730 = !DILocation(line: 118, column: 5, scope: !724)
!731 = !DILocation(line: 119, column: 38, scope: !732)
!732 = distinct !DILexicalBlock(scope: !728, file: !42, line: 118, column: 49)
!733 = !DILocation(line: 119, column: 27, scope: !732)
!734 = !DILocation(line: 119, column: 24, scope: !732)
!735 = !DILocation(line: 120, column: 5, scope: !732)
!736 = !DILocation(line: 118, column: 45, scope: !728)
!737 = !DILocation(line: 118, column: 5, scope: !728)
!738 = distinct !{!738, !730, !739, !112}
!739 = !DILocation(line: 120, column: 5, scope: !724)
!740 = !DILocation(line: 122, column: 5, scope: !741)
!741 = distinct !DILexicalBlock(scope: !742, file: !42, line: 122, column: 5)
!742 = distinct !DILexicalBlock(scope: !557, file: !42, line: 122, column: 5)
!743 = !DILocation(line: 122, column: 5, scope: !742)
!744 = !DILocation(line: 123, column: 5, scope: !745)
!745 = distinct !DILexicalBlock(scope: !746, file: !42, line: 123, column: 5)
!746 = distinct !DILexicalBlock(scope: !557, file: !42, line: 123, column: 5)
!747 = !DILocation(line: 123, column: 5, scope: !746)
!748 = !DILocation(line: 124, column: 10, scope: !557)
!749 = !DILocation(line: 124, column: 5, scope: !557)
!750 = !DILocation(line: 125, column: 5, scope: !557)
!751 = !DILocation(line: 126, column: 1, scope: !557)
!752 = distinct !DISubprogram(name: "cachedq_memsize", scope: !20, file: !20, line: 42, type: !753, scopeLine: 43, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!753 = !DISubroutineType(types: !754)
!754 = !{!15, !15}
!755 = !DILocalVariable(name: "capacity", arg: 1, scope: !752, file: !20, line: 42, type: !15)
!756 = !DILocation(line: 42, column: 25, scope: !752)
!757 = !DILocation(line: 44, column: 52, scope: !752)
!758 = !DILocation(line: 44, column: 50, scope: !752)
!759 = !DILocation(line: 44, column: 30, scope: !752)
!760 = !DILocation(line: 44, column: 61, scope: !752)
!761 = !DILocation(line: 44, column: 5, scope: !752)
!762 = distinct !DISubprogram(name: "cachedq_init", scope: !20, file: !20, line: 58, type: !763, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!763 = !DISubroutineType(types: !764)
!764 = !{!18, !7, !15}
!765 = !DILocalVariable(name: "buf", arg: 1, scope: !762, file: !20, line: 58, type: !7)
!766 = !DILocation(line: 58, column: 20, scope: !762)
!767 = !DILocalVariable(name: "capacity", arg: 2, scope: !762, file: !20, line: 58, type: !15)
!768 = !DILocation(line: 58, column: 33, scope: !762)
!769 = !DILocalVariable(name: "q", scope: !762, file: !20, line: 60, type: !18)
!770 = !DILocation(line: 60, column: 16, scope: !762)
!771 = !DILocation(line: 60, column: 33, scope: !762)
!772 = !DILocation(line: 60, column: 20, scope: !762)
!773 = !DILocation(line: 61, column: 21, scope: !762)
!774 = !DILocation(line: 61, column: 24, scope: !762)
!775 = !DILocation(line: 61, column: 5, scope: !762)
!776 = !DILocation(line: 62, column: 21, scope: !762)
!777 = !DILocation(line: 62, column: 24, scope: !762)
!778 = !DILocation(line: 62, column: 5, scope: !762)
!779 = !DILocation(line: 63, column: 21, scope: !762)
!780 = !DILocation(line: 63, column: 24, scope: !762)
!781 = !DILocation(line: 63, column: 5, scope: !762)
!782 = !DILocation(line: 64, column: 21, scope: !762)
!783 = !DILocation(line: 64, column: 24, scope: !762)
!784 = !DILocation(line: 64, column: 5, scope: !762)
!785 = !DILocation(line: 65, column: 21, scope: !762)
!786 = !DILocation(line: 65, column: 24, scope: !762)
!787 = !DILocation(line: 65, column: 5, scope: !762)
!788 = !DILocation(line: 66, column: 21, scope: !762)
!789 = !DILocation(line: 66, column: 24, scope: !762)
!790 = !DILocation(line: 66, column: 5, scope: !762)
!791 = !DILocation(line: 67, column: 16, scope: !762)
!792 = !DILocation(line: 67, column: 25, scope: !762)
!793 = !DILocation(line: 67, column: 48, scope: !762)
!794 = !DILocation(line: 67, column: 69, scope: !762)
!795 = !DILocation(line: 67, column: 5, scope: !762)
!796 = !DILocation(line: 67, column: 8, scope: !762)
!797 = !DILocation(line: 67, column: 13, scope: !762)
!798 = !DILocation(line: 69, column: 12, scope: !762)
!799 = !DILocation(line: 69, column: 5, scope: !762)
!800 = distinct !DISubprogram(name: "cachedq_count", scope: !20, file: !20, line: 187, type: !801, scopeLine: 188, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!801 = !DISubroutineType(types: !802)
!802 = !{!15, !18}
!803 = !DILocalVariable(name: "q", arg: 1, scope: !800, file: !20, line: 187, type: !18)
!804 = !DILocation(line: 187, column: 26, scope: !800)
!805 = !DILocalVariable(name: "c", scope: !800, file: !20, line: 189, type: !8)
!806 = !DILocation(line: 189, column: 15, scope: !800)
!807 = !DILocation(line: 189, column: 39, scope: !800)
!808 = !DILocation(line: 189, column: 42, scope: !800)
!809 = !DILocation(line: 189, column: 19, scope: !800)
!810 = !DILocalVariable(name: "p", scope: !800, file: !20, line: 190, type: !8)
!811 = !DILocation(line: 190, column: 15, scope: !800)
!812 = !DILocation(line: 190, column: 39, scope: !800)
!813 = !DILocation(line: 190, column: 42, scope: !800)
!814 = !DILocation(line: 190, column: 19, scope: !800)
!815 = !DILocation(line: 191, column: 5, scope: !816)
!816 = distinct !DILexicalBlock(scope: !817, file: !20, line: 191, column: 5)
!817 = distinct !DILexicalBlock(scope: !800, file: !20, line: 191, column: 5)
!818 = !DILocation(line: 191, column: 5, scope: !817)
!819 = !DILocation(line: 192, column: 22, scope: !800)
!820 = !DILocation(line: 192, column: 26, scope: !800)
!821 = !DILocation(line: 192, column: 24, scope: !800)
!822 = !DILocation(line: 192, column: 5, scope: !800)
!823 = distinct !DISubprogram(name: "vatomic64_read_rlx", scope: !824, file: !824, line: 234, type: !825, scopeLine: 235, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!824 = !DIFile(filename: "atomics/include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/huawei/libvsync", checksumkind: CSK_MD5, checksum: "388436b7ba51a9f45a141a76df6f4faa")
!825 = !DISubroutineType(types: !826)
!826 = !{!8, !827}
!827 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !828, size: 64)
!828 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!829 = !DILocalVariable(name: "a", arg: 1, scope: !823, file: !824, line: 234, type: !827)
!830 = !DILocation(line: 234, column: 39, scope: !823)
!831 = !DILocation(line: 236, column: 5, scope: !823)
!832 = !{i64 2148379628}
!833 = !DILocalVariable(name: "tmp", scope: !823, file: !824, line: 237, type: !8)
!834 = !DILocation(line: 237, column: 15, scope: !823)
!835 = !DILocation(line: 237, column: 49, scope: !823)
!836 = !DILocation(line: 237, column: 52, scope: !823)
!837 = !DILocation(line: 237, column: 32, scope: !823)
!838 = !DILocation(line: 238, column: 5, scope: !823)
!839 = !{i64 2148379668}
!840 = !DILocation(line: 239, column: 12, scope: !823)
!841 = !DILocation(line: 239, column: 5, scope: !823)
!842 = distinct !DISubprogram(name: "vatomic64_cmpxchg_rlx", scope: !824, file: !824, line: 1178, type: !843, scopeLine: 1179, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!843 = !DISubroutineType(types: !844)
!844 = !{!8, !845, !8, !8}
!845 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!846 = !DILocalVariable(name: "a", arg: 1, scope: !842, file: !824, line: 1178, type: !845)
!847 = !DILocation(line: 1178, column: 36, scope: !842)
!848 = !DILocalVariable(name: "e", arg: 2, scope: !842, file: !824, line: 1178, type: !8)
!849 = !DILocation(line: 1178, column: 49, scope: !842)
!850 = !DILocalVariable(name: "v", arg: 3, scope: !842, file: !824, line: 1178, type: !8)
!851 = !DILocation(line: 1178, column: 62, scope: !842)
!852 = !DILocalVariable(name: "exp", scope: !842, file: !824, line: 1180, type: !8)
!853 = !DILocation(line: 1180, column: 15, scope: !842)
!854 = !DILocation(line: 1180, column: 32, scope: !842)
!855 = !DILocation(line: 1181, column: 5, scope: !842)
!856 = !{i64 2148384650}
!857 = !DILocation(line: 1182, column: 34, scope: !842)
!858 = !DILocation(line: 1182, column: 37, scope: !842)
!859 = !DILocation(line: 1182, column: 58, scope: !842)
!860 = !DILocation(line: 1182, column: 5, scope: !842)
!861 = !DILocation(line: 1184, column: 5, scope: !842)
!862 = !{i64 2148384692}
!863 = !DILocation(line: 1185, column: 12, scope: !842)
!864 = !DILocation(line: 1185, column: 5, scope: !842)
!865 = distinct !DISubprogram(name: "vatomic64_write_rel", scope: !824, file: !824, line: 466, type: !866, scopeLine: 467, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!866 = !DISubroutineType(types: !867)
!867 = !{null, !845, !8}
!868 = !DILocalVariable(name: "a", arg: 1, scope: !865, file: !824, line: 466, type: !845)
!869 = !DILocation(line: 466, column: 34, scope: !865)
!870 = !DILocalVariable(name: "v", arg: 2, scope: !865, file: !824, line: 466, type: !8)
!871 = !DILocation(line: 466, column: 47, scope: !865)
!872 = !DILocation(line: 468, column: 5, scope: !865)
!873 = !{i64 2148380954}
!874 = !DILocation(line: 469, column: 23, scope: !865)
!875 = !DILocation(line: 469, column: 26, scope: !865)
!876 = !DILocation(line: 469, column: 30, scope: !865)
!877 = !DILocation(line: 469, column: 5, scope: !865)
!878 = !DILocation(line: 470, column: 5, scope: !865)
!879 = !{i64 2148380994}
!880 = !DILocation(line: 471, column: 1, scope: !865)
!881 = distinct !DISubprogram(name: "vatomic64_read_acq", scope: !824, file: !824, line: 220, type: !825, scopeLine: 221, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!882 = !DILocalVariable(name: "a", arg: 1, scope: !881, file: !824, line: 220, type: !827)
!883 = !DILocation(line: 220, column: 39, scope: !881)
!884 = !DILocation(line: 222, column: 5, scope: !881)
!885 = !{i64 2148379550}
!886 = !DILocalVariable(name: "tmp", scope: !881, file: !824, line: 223, type: !8)
!887 = !DILocation(line: 223, column: 15, scope: !881)
!888 = !DILocation(line: 223, column: 49, scope: !881)
!889 = !DILocation(line: 223, column: 52, scope: !881)
!890 = !DILocation(line: 223, column: 32, scope: !881)
!891 = !DILocation(line: 224, column: 5, scope: !881)
!892 = !{i64 2148379590}
!893 = !DILocation(line: 225, column: 12, scope: !881)
!894 = !DILocation(line: 225, column: 5, scope: !881)
!895 = distinct !DISubprogram(name: "vatomic64_write_rlx", scope: !824, file: !824, line: 479, type: !866, scopeLine: 480, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!896 = !DILocalVariable(name: "a", arg: 1, scope: !895, file: !824, line: 479, type: !845)
!897 = !DILocation(line: 479, column: 34, scope: !895)
!898 = !DILocalVariable(name: "v", arg: 2, scope: !895, file: !824, line: 479, type: !8)
!899 = !DILocation(line: 479, column: 47, scope: !895)
!900 = !DILocation(line: 481, column: 5, scope: !895)
!901 = !{i64 2148381032}
!902 = !DILocation(line: 482, column: 23, scope: !895)
!903 = !DILocation(line: 482, column: 26, scope: !895)
!904 = !DILocation(line: 482, column: 30, scope: !895)
!905 = !DILocation(line: 482, column: 5, scope: !895)
!906 = !DILocation(line: 483, column: 5, scope: !895)
!907 = !{i64 2148381072}
!908 = !DILocation(line: 484, column: 1, scope: !895)
!909 = distinct !DISubprogram(name: "vatomic64_init", scope: !910, file: !910, line: 4200, type: !866, scopeLine: 4201, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!910 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/drc/git/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!911 = !DILocalVariable(name: "a", arg: 1, scope: !909, file: !910, line: 4200, type: !845)
!912 = !DILocation(line: 4200, column: 29, scope: !909)
!913 = !DILocalVariable(name: "v", arg: 2, scope: !909, file: !910, line: 4200, type: !8)
!914 = !DILocation(line: 4200, column: 42, scope: !909)
!915 = !DILocation(line: 4202, column: 21, scope: !909)
!916 = !DILocation(line: 4202, column: 24, scope: !909)
!917 = !DILocation(line: 4202, column: 5, scope: !909)
!918 = !DILocation(line: 4203, column: 1, scope: !909)
!919 = distinct !DISubprogram(name: "vatomic64_write", scope: !824, file: !824, line: 453, type: !866, scopeLine: 454, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!920 = !DILocalVariable(name: "a", arg: 1, scope: !919, file: !824, line: 453, type: !845)
!921 = !DILocation(line: 453, column: 30, scope: !919)
!922 = !DILocalVariable(name: "v", arg: 2, scope: !919, file: !824, line: 453, type: !8)
!923 = !DILocation(line: 453, column: 43, scope: !919)
!924 = !DILocation(line: 455, column: 5, scope: !919)
!925 = !{i64 2148380876}
!926 = !DILocation(line: 456, column: 23, scope: !919)
!927 = !DILocation(line: 456, column: 26, scope: !919)
!928 = !DILocation(line: 456, column: 30, scope: !919)
!929 = !DILocation(line: 456, column: 5, scope: !919)
!930 = !DILocation(line: 457, column: 5, scope: !919)
!931 = !{i64 2148380916}
!932 = !DILocation(line: 458, column: 1, scope: !919)
