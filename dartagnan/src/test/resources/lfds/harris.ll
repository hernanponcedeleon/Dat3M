; ModuleID = '/home/ponce/git/Dat3M/output/harris-3.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lfds/harris-3.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.list = type { %struct.node*, %struct.node*, i32 }
%struct.node = type { i64, %struct.node* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@the_list = internal global %struct.list* null, align 8, !dbg !0
@.str = private unnamed_addr constant [31 x i8] c"list_contains(the_list, index)\00", align 1
@.str.1 = private unnamed_addr constant [49 x i8] c"/home/ponce/git/Dat3M/benchmarks/lfds/harris-3.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [32 x i8] c"!list_contains(the_list, index)\00", align 1
@.str.3 = private unnamed_addr constant [25 x i8] c"list_size(the_list) == 0\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @list_contains(%struct.list* noundef %0, i64 noundef %1) #0 !dbg !52 {
  call void @llvm.dbg.value(metadata %struct.list* %0, metadata !56, metadata !DIExpression()), !dbg !57
  call void @llvm.dbg.value(metadata i64 %1, metadata !58, metadata !DIExpression()), !dbg !57
  %3 = getelementptr inbounds %struct.list, %struct.list* %0, i32 0, i32 0, !dbg !59
  %4 = load %struct.node*, %struct.node** %3, align 8, !dbg !59
  %5 = getelementptr inbounds %struct.node, %struct.node* %4, i32 0, i32 1, !dbg !60
  %6 = bitcast %struct.node** %5 to i64*, !dbg !60
  %7 = load atomic i64, i64* %6 seq_cst, align 8, !dbg !60
  %8 = inttoptr i64 %7 to %struct.node*, !dbg !60
  %9 = bitcast %struct.node* %8 to i8*, !dbg !61
  %10 = call i8* @get_unmarked_ref(i8* noundef %9), !dbg !62
  %11 = bitcast i8* %10 to %struct.node*, !dbg !62
  call void @llvm.dbg.value(metadata %struct.node* %11, metadata !63, metadata !DIExpression()), !dbg !57
  br label %12, !dbg !64

12:                                               ; preds = %29, %2
  %.01 = phi %struct.node* [ %11, %2 ], [ %34, %29 ], !dbg !57
  call void @llvm.dbg.value(metadata %struct.node* %.01, metadata !63, metadata !DIExpression()), !dbg !57
  %13 = getelementptr inbounds %struct.list, %struct.list* %0, i32 0, i32 1, !dbg !65
  %14 = load %struct.node*, %struct.node** %13, align 8, !dbg !65
  %15 = icmp ne %struct.node* %.01, %14, !dbg !66
  br i1 %15, label %16, label %35, !dbg !64

16:                                               ; preds = %12
  %17 = getelementptr inbounds %struct.node, %struct.node* %.01, i32 0, i32 1, !dbg !67
  %18 = bitcast %struct.node** %17 to i64*, !dbg !67
  %19 = load atomic i64, i64* %18 seq_cst, align 8, !dbg !67
  %20 = inttoptr i64 %19 to %struct.node*, !dbg !67
  %21 = bitcast %struct.node* %20 to i8*, !dbg !70
  %22 = call zeroext i1 @is_marked_ref(i8* noundef %21), !dbg !71
  br i1 %22, label %29, label %23, !dbg !72

23:                                               ; preds = %16
  %24 = getelementptr inbounds %struct.node, %struct.node* %.01, i32 0, i32 0, !dbg !73
  %25 = load i64, i64* %24, align 8, !dbg !73
  %26 = icmp sge i64 %25, %1, !dbg !74
  br i1 %26, label %27, label %29, !dbg !75

27:                                               ; preds = %23
  %28 = icmp eq i64 %25, %1, !dbg !76
  br label %35, !dbg !78

29:                                               ; preds = %23, %16
  %30 = load atomic i64, i64* %18 seq_cst, align 8, !dbg !79
  %31 = inttoptr i64 %30 to %struct.node*, !dbg !79
  %32 = bitcast %struct.node* %31 to i8*, !dbg !80
  %33 = call i8* @get_unmarked_ref(i8* noundef %32), !dbg !81
  %34 = bitcast i8* %33 to %struct.node*, !dbg !81
  call void @llvm.dbg.value(metadata %struct.node* %34, metadata !63, metadata !DIExpression()), !dbg !57
  br label %12, !dbg !64, !llvm.loop !82

35:                                               ; preds = %12, %27
  %.0 = phi i1 [ %28, %27 ], [ false, %12 ], !dbg !57
  ret i1 %.0, !dbg !85
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal i8* @get_unmarked_ref(i8* noundef %0) #0 !dbg !86 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !89, metadata !DIExpression()), !dbg !90
  %2 = ptrtoint i8* %0 to i64, !dbg !91
  %3 = and i64 %2, -2, !dbg !92
  %4 = inttoptr i64 %3 to i8*, !dbg !93
  ret i8* %4, !dbg !94
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @is_marked_ref(i8* noundef %0) #0 !dbg !95 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !98, metadata !DIExpression()), !dbg !99
  %2 = ptrtoint i8* %0 to i64, !dbg !100
  %3 = and i64 %2, 1, !dbg !101
  %4 = icmp ne i64 %3, 0, !dbg !102
  ret i1 %4, !dbg !103
}

; Function Attrs: noinline nounwind uwtable
define dso_local %struct.list* @list_new() #0 !dbg !104 {
  %1 = call noalias i8* @malloc(i64 noundef 24) #5, !dbg !107
  %2 = bitcast i8* %1 to %struct.list*, !dbg !107
  call void @llvm.dbg.value(metadata %struct.list* %2, metadata !108, metadata !DIExpression()), !dbg !109
  %3 = call %struct.node* @new_node(i64 noundef -2147483648, %struct.node* noundef null), !dbg !110
  %4 = getelementptr inbounds %struct.list, %struct.list* %2, i32 0, i32 0, !dbg !111
  store %struct.node* %3, %struct.node** %4, align 8, !dbg !112
  %5 = call %struct.node* @new_node(i64 noundef 2147483647, %struct.node* noundef null), !dbg !113
  %6 = getelementptr inbounds %struct.list, %struct.list* %2, i32 0, i32 1, !dbg !114
  store %struct.node* %5, %struct.node** %6, align 8, !dbg !115
  %7 = getelementptr inbounds %struct.node, %struct.node* %3, i32 0, i32 1, !dbg !116
  %8 = ptrtoint %struct.node* %5 to i64, !dbg !117
  %9 = bitcast %struct.node** %7 to i64*, !dbg !117
  store atomic i64 %8, i64* %9 seq_cst, align 8, !dbg !117
  %10 = getelementptr inbounds %struct.list, %struct.list* %2, i32 0, i32 2, !dbg !118
  store atomic i32 0, i32* %10 seq_cst, align 4, !dbg !119
  ret %struct.list* %2, !dbg !120
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal %struct.node* @new_node(i64 noundef %0, %struct.node* noundef %1) #0 !dbg !121 {
  call void @llvm.dbg.value(metadata i64 %0, metadata !124, metadata !DIExpression()), !dbg !125
  call void @llvm.dbg.value(metadata %struct.node* %1, metadata !126, metadata !DIExpression()), !dbg !125
  %3 = call noalias i8* @malloc(i64 noundef 16) #5, !dbg !127
  %4 = bitcast i8* %3 to %struct.node*, !dbg !127
  call void @llvm.dbg.value(metadata %struct.node* %4, metadata !128, metadata !DIExpression()), !dbg !125
  %5 = getelementptr inbounds %struct.node, %struct.node* %4, i32 0, i32 0, !dbg !129
  store i64 %0, i64* %5, align 8, !dbg !130
  %6 = getelementptr inbounds %struct.node, %struct.node* %4, i32 0, i32 1, !dbg !131
  %7 = ptrtoint %struct.node* %1 to i64, !dbg !132
  %8 = bitcast %struct.node** %6 to i64*, !dbg !132
  store atomic i64 %7, i64* %8 seq_cst, align 8, !dbg !132
  ret %struct.node* %4, !dbg !133
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @list_delete(%struct.list* noundef %0) #0 !dbg !134 {
  call void @llvm.dbg.value(metadata %struct.list* %0, metadata !137, metadata !DIExpression()), !dbg !138
  ret void, !dbg !139
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @list_size(%struct.list* noundef %0) #0 !dbg !140 {
  call void @llvm.dbg.value(metadata %struct.list* %0, metadata !143, metadata !DIExpression()), !dbg !144
  %2 = getelementptr inbounds %struct.list, %struct.list* %0, i32 0, i32 2, !dbg !145
  %3 = load atomic i32, i32* %2 seq_cst, align 4, !dbg !145
  ret i32 %3, !dbg !146
}

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @list_add(%struct.list* noundef %0, i64 noundef %1) #0 !dbg !147 {
  %3 = alloca %struct.node*, align 8
  call void @llvm.dbg.value(metadata %struct.list* %0, metadata !148, metadata !DIExpression()), !dbg !149
  call void @llvm.dbg.value(metadata i64 %1, metadata !150, metadata !DIExpression()), !dbg !149
  call void @llvm.dbg.declare(metadata %struct.node** %3, metadata !151, metadata !DIExpression()), !dbg !152
  store %struct.node* null, %struct.node** %3, align 8, !dbg !152
  %4 = call %struct.node* @new_node(i64 noundef %1, %struct.node* noundef null), !dbg !153
  call void @llvm.dbg.value(metadata %struct.node* %4, metadata !154, metadata !DIExpression()), !dbg !149
  br label %5, !dbg !155

5:                                                ; preds = %14, %2
  %6 = call %struct.node* @list_search(%struct.list* noundef %0, i64 noundef %1, %struct.node** noundef %3), !dbg !156
  call void @llvm.dbg.value(metadata %struct.node* %6, metadata !158, metadata !DIExpression()), !dbg !159
  %7 = getelementptr inbounds %struct.list, %struct.list* %0, i32 0, i32 1, !dbg !160
  %8 = load %struct.node*, %struct.node** %7, align 8, !dbg !160
  %9 = icmp ne %struct.node* %6, %8, !dbg !162
  br i1 %9, label %10, label %14, !dbg !163

10:                                               ; preds = %5
  %11 = getelementptr inbounds %struct.node, %struct.node* %6, i32 0, i32 0, !dbg !164
  %12 = load i64, i64* %11, align 8, !dbg !164
  %13 = icmp eq i64 %12, %1, !dbg !165
  br i1 %13, label %29, label %14, !dbg !166

14:                                               ; preds = %10, %5
  %15 = getelementptr inbounds %struct.node, %struct.node* %4, i32 0, i32 1, !dbg !167
  %16 = ptrtoint %struct.node* %6 to i64, !dbg !168
  %17 = bitcast %struct.node** %15 to i64*, !dbg !168
  store atomic i64 %16, i64* %17 seq_cst, align 8, !dbg !168
  %18 = load %struct.node*, %struct.node** %3, align 8, !dbg !169
  %19 = getelementptr inbounds %struct.node, %struct.node* %18, i32 0, i32 1, !dbg !171
  %20 = bitcast %struct.node** %19 to i64*, !dbg !172
  %21 = ptrtoint %struct.node* %4 to i64, !dbg !172
  %22 = cmpxchg i64* %20, i64 %16, i64 %21 seq_cst seq_cst, align 8, !dbg !172
  %23 = extractvalue { i64, i1 } %22, 0, !dbg !172
  %24 = extractvalue { i64, i1 } %22, 1, !dbg !172
  %25 = zext i1 %24 to i8, !dbg !172
  br i1 %24, label %26, label %5, !dbg !173, !llvm.loop !174

26:                                               ; preds = %14
  %27 = getelementptr inbounds %struct.list, %struct.list* %0, i32 0, i32 2, !dbg !176
  %28 = atomicrmw add i32* %27, i32 1 seq_cst, align 4, !dbg !178
  br label %29, !dbg !179

29:                                               ; preds = %10, %26
  %.0 = phi i1 [ true, %26 ], [ false, %10 ], !dbg !159
  ret i1 %.0, !dbg !180
}

; Function Attrs: noinline nounwind uwtable
define internal %struct.node* @list_search(%struct.list* noundef %0, i64 noundef %1, %struct.node** noundef %2) #0 !dbg !181 {
  call void @llvm.dbg.value(metadata %struct.list* %0, metadata !185, metadata !DIExpression()), !dbg !186
  call void @llvm.dbg.value(metadata i64 %1, metadata !187, metadata !DIExpression()), !dbg !186
  call void @llvm.dbg.value(metadata %struct.node** %2, metadata !188, metadata !DIExpression()), !dbg !186
  call void @llvm.dbg.value(metadata %struct.node* null, metadata !189, metadata !DIExpression()), !dbg !186
  call void @llvm.dbg.value(metadata %struct.node* null, metadata !190, metadata !DIExpression()), !dbg !186
  br label %4, !dbg !191

4:                                                ; preds = %57, %3
  %.0 = phi %struct.node* [ null, %3 ], [ %.5, %57 ], !dbg !192
  call void @llvm.dbg.value(metadata %struct.node* %.0, metadata !190, metadata !DIExpression()), !dbg !186
  %5 = getelementptr inbounds %struct.list, %struct.list* %0, i32 0, i32 0, !dbg !193
  %6 = load %struct.node*, %struct.node** %5, align 8, !dbg !193
  call void @llvm.dbg.value(metadata %struct.node* %6, metadata !195, metadata !DIExpression()), !dbg !196
  %7 = getelementptr inbounds %struct.node, %struct.node* %6, i32 0, i32 1, !dbg !197
  %8 = bitcast %struct.node** %7 to i64*, !dbg !197
  %9 = load atomic i64, i64* %8 seq_cst, align 8, !dbg !197
  %10 = inttoptr i64 %9 to %struct.node*, !dbg !197
  call void @llvm.dbg.value(metadata %struct.node* %10, metadata !198, metadata !DIExpression()), !dbg !196
  br label %11, !dbg !199

11:                                               ; preds = %26, %4
  %.14 = phi %struct.node* [ %.0, %4 ], [ %.2, %26 ], !dbg !192
  %.02 = phi %struct.node* [ %6, %4 ], [ %22, %26 ], !dbg !196
  %.01 = phi %struct.node* [ %10, %4 ], [ %30, %26 ], !dbg !196
  call void @llvm.dbg.value(metadata %struct.node* %.14, metadata !190, metadata !DIExpression()), !dbg !186
  call void @llvm.dbg.value(metadata %struct.node* %.01, metadata !198, metadata !DIExpression()), !dbg !196
  call void @llvm.dbg.value(metadata %struct.node* %.02, metadata !195, metadata !DIExpression()), !dbg !196
  %12 = bitcast %struct.node* %.01 to i8*, !dbg !200
  %13 = call zeroext i1 @is_marked_ref(i8* noundef %12), !dbg !201
  br i1 %13, label %.critedge, label %14, !dbg !202

14:                                               ; preds = %11
  %15 = getelementptr inbounds %struct.node, %struct.node* %.02, i32 0, i32 0, !dbg !203
  %16 = load i64, i64* %15, align 8, !dbg !203
  %17 = icmp slt i64 %16, %1, !dbg !204
  br i1 %17, label %.critedge, label %.loopexit, !dbg !199

.critedge:                                        ; preds = %11, %14
  %18 = call zeroext i1 @is_marked_ref(i8* noundef %12), !dbg !205
  br i1 %18, label %20, label %19, !dbg !208

19:                                               ; preds = %.critedge
  store %struct.node* %.02, %struct.node** %2, align 8, !dbg !209
  call void @llvm.dbg.value(metadata %struct.node* %.01, metadata !190, metadata !DIExpression()), !dbg !186
  br label %20, !dbg !211

20:                                               ; preds = %19, %.critedge
  %.2 = phi %struct.node* [ %.14, %.critedge ], [ %.01, %19 ], !dbg !186
  call void @llvm.dbg.value(metadata %struct.node* %.2, metadata !190, metadata !DIExpression()), !dbg !186
  %21 = call i8* @get_unmarked_ref(i8* noundef %12), !dbg !212
  %22 = bitcast i8* %21 to %struct.node*, !dbg !212
  call void @llvm.dbg.value(metadata %struct.node* %22, metadata !195, metadata !DIExpression()), !dbg !196
  %23 = getelementptr inbounds %struct.list, %struct.list* %0, i32 0, i32 1, !dbg !213
  %24 = load %struct.node*, %struct.node** %23, align 8, !dbg !213
  %25 = icmp eq %struct.node* %22, %24, !dbg !215
  br i1 %25, label %.loopexit, label %26, !dbg !216

26:                                               ; preds = %20
  %27 = getelementptr inbounds %struct.node, %struct.node* %22, i32 0, i32 1, !dbg !217
  %28 = bitcast %struct.node** %27 to i64*, !dbg !217
  %29 = load atomic i64, i64* %28 seq_cst, align 8, !dbg !217
  %30 = inttoptr i64 %29 to %struct.node*, !dbg !217
  call void @llvm.dbg.value(metadata %struct.node* %30, metadata !198, metadata !DIExpression()), !dbg !196
  br label %11, !dbg !199, !llvm.loop !218

.loopexit:                                        ; preds = %14, %20
  %.3 = phi %struct.node* [ %.2, %20 ], [ %.14, %14 ], !dbg !192
  %.1 = phi %struct.node* [ %22, %20 ], [ %.02, %14 ], !dbg !196
  call void @llvm.dbg.value(metadata %struct.node* %.3, metadata !190, metadata !DIExpression()), !dbg !186
  call void @llvm.dbg.value(metadata %struct.node* %.1, metadata !195, metadata !DIExpression()), !dbg !196
  call void @llvm.dbg.value(metadata %struct.node* %.1, metadata !189, metadata !DIExpression()), !dbg !186
  %31 = icmp eq %struct.node* %.3, %.1, !dbg !220
  br i1 %31, label %32, label %39, !dbg !222

32:                                               ; preds = %.loopexit
  %33 = getelementptr inbounds %struct.node, %struct.node* %.3, i32 0, i32 1, !dbg !223
  %34 = bitcast %struct.node** %33 to i64*, !dbg !223
  %35 = load atomic i64, i64* %34 seq_cst, align 8, !dbg !223
  %36 = inttoptr i64 %35 to %struct.node*, !dbg !223
  %37 = bitcast %struct.node* %36 to i8*, !dbg !226
  %38 = call zeroext i1 @is_marked_ref(i8* noundef %37), !dbg !227
  br i1 %38, label %57, label %58, !dbg !228

39:                                               ; preds = %.loopexit
  %40 = load %struct.node*, %struct.node** %2, align 8, !dbg !229
  %41 = getelementptr inbounds %struct.node, %struct.node* %40, i32 0, i32 1, !dbg !232
  %42 = bitcast %struct.node** %41 to i64*, !dbg !233
  %43 = ptrtoint %struct.node* %.3 to i64, !dbg !233
  %44 = ptrtoint %struct.node* %.1 to i64, !dbg !233
  %45 = cmpxchg i64* %42, i64 %43, i64 %44 seq_cst seq_cst, align 8, !dbg !233
  %46 = extractvalue { i64, i1 } %45, 0, !dbg !233
  %47 = extractvalue { i64, i1 } %45, 1, !dbg !233
  %48 = inttoptr i64 %46 to %struct.node*, !dbg !233
  %.4 = select i1 %47, %struct.node* %.3, %struct.node* %48, !dbg !233
  call void @llvm.dbg.value(metadata %struct.node* %.4, metadata !190, metadata !DIExpression()), !dbg !186
  %49 = zext i1 %47 to i8, !dbg !233
  br i1 %47, label %50, label %57, !dbg !234

50:                                               ; preds = %39
  %51 = getelementptr inbounds %struct.node, %struct.node* %.1, i32 0, i32 1, !dbg !235
  %52 = bitcast %struct.node** %51 to i64*, !dbg !235
  %53 = load atomic i64, i64* %52 seq_cst, align 8, !dbg !235
  %54 = inttoptr i64 %53 to %struct.node*, !dbg !235
  %55 = bitcast %struct.node* %54 to i8*, !dbg !238
  %56 = call zeroext i1 @is_marked_ref(i8* noundef %55), !dbg !239
  br i1 %56, label %57, label %58, !dbg !240

57:                                               ; preds = %39, %50, %32
  %.5 = phi %struct.node* [ %.3, %32 ], [ %.4, %50 ], [ %.4, %39 ], !dbg !192
  call void @llvm.dbg.value(metadata %struct.node* %.5, metadata !190, metadata !DIExpression()), !dbg !186
  br label %4, !dbg !191, !llvm.loop !241

58:                                               ; preds = %50, %32
  %.18 = phi %struct.node* [ %.3, %32 ], [ %.1, %50 ]
  ret %struct.node* %.18, !dbg !243
}

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @list_remove(%struct.list* noundef %0, i64 noundef %1) #0 !dbg !244 {
  %3 = alloca %struct.node*, align 8
  call void @llvm.dbg.value(metadata %struct.list* %0, metadata !245, metadata !DIExpression()), !dbg !246
  call void @llvm.dbg.value(metadata i64 %1, metadata !247, metadata !DIExpression()), !dbg !246
  call void @llvm.dbg.declare(metadata %struct.node** %3, metadata !248, metadata !DIExpression()), !dbg !249
  store %struct.node* null, %struct.node** %3, align 8, !dbg !249
  br label %4, !dbg !250

4:                                                ; preds = %31, %2
  %5 = call %struct.node* @list_search(%struct.list* noundef %0, i64 noundef %1, %struct.node** noundef %3), !dbg !251
  call void @llvm.dbg.value(metadata %struct.node* %5, metadata !253, metadata !DIExpression()), !dbg !254
  %6 = getelementptr inbounds %struct.list, %struct.list* %0, i32 0, i32 1, !dbg !255
  %7 = load %struct.node*, %struct.node** %6, align 8, !dbg !255
  %8 = icmp eq %struct.node* %5, %7, !dbg !257
  br i1 %8, label %32, label %9, !dbg !258

9:                                                ; preds = %4
  %10 = getelementptr inbounds %struct.node, %struct.node* %5, i32 0, i32 0, !dbg !259
  %11 = load i64, i64* %10, align 8, !dbg !259
  %12 = icmp ne i64 %11, %1, !dbg !260
  br i1 %12, label %32, label %13, !dbg !261

13:                                               ; preds = %9
  %14 = getelementptr inbounds %struct.node, %struct.node* %5, i32 0, i32 1, !dbg !262
  %15 = bitcast %struct.node** %14 to i64*, !dbg !262
  %16 = load atomic i64, i64* %15 seq_cst, align 8, !dbg !262
  %17 = inttoptr i64 %16 to %struct.node*, !dbg !262
  call void @llvm.dbg.value(metadata %struct.node* %17, metadata !263, metadata !DIExpression()), !dbg !254
  %18 = bitcast %struct.node* %17 to i8*, !dbg !264
  %19 = call zeroext i1 @is_marked_ref(i8* noundef %18), !dbg !266
  br i1 %19, label %31, label %20, !dbg !267

20:                                               ; preds = %13
  %21 = call i8* @get_marked_ref(i8* noundef %18), !dbg !268
  %22 = bitcast i8* %21 to %struct.node*, !dbg !268
  %23 = ptrtoint %struct.node* %22 to i64, !dbg !271
  %24 = cmpxchg i64* %15, i64 %16, i64 %23 seq_cst seq_cst, align 8, !dbg !271
  %25 = extractvalue { i64, i1 } %24, 0, !dbg !271
  %26 = extractvalue { i64, i1 } %24, 1, !dbg !271
  %27 = zext i1 %26 to i8, !dbg !271
  br i1 %26, label %28, label %31, !dbg !272

28:                                               ; preds = %20
  %29 = getelementptr inbounds %struct.list, %struct.list* %0, i32 0, i32 2, !dbg !273
  %30 = atomicrmw sub i32* %29, i32 1 seq_cst, align 4, !dbg !275
  br label %32, !dbg !276

31:                                               ; preds = %20, %13
  br label %4, !dbg !250, !llvm.loop !277

32:                                               ; preds = %4, %9, %28
  %.0 = phi i1 [ true, %28 ], [ false, %9 ], [ false, %4 ], !dbg !254
  ret i1 %.0, !dbg !279
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @get_marked_ref(i8* noundef %0) #0 !dbg !280 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !281, metadata !DIExpression()), !dbg !282
  %2 = ptrtoint i8* %0 to i64, !dbg !283
  %3 = or i64 %2, 1, !dbg !284
  %4 = inttoptr i64 %3 to i8*, !dbg !285
  ret i8* %4, !dbg !286
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !287 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !288, metadata !DIExpression()), !dbg !289
  %2 = ptrtoint i8* %0 to i64, !dbg !290
  call void @llvm.dbg.value(metadata i64 %2, metadata !291, metadata !DIExpression()), !dbg !289
  %3 = load %struct.list*, %struct.list** @the_list, align 8, !dbg !292
  %4 = call zeroext i1 @list_add(%struct.list* noundef %3, i64 noundef %2), !dbg !293
  %5 = load %struct.list*, %struct.list** @the_list, align 8, !dbg !294
  %6 = call zeroext i1 @list_contains(%struct.list* noundef %5, i64 noundef %2), !dbg !294
  br i1 %6, label %8, label %7, !dbg !297

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([49 x i8], [49 x i8]* @.str.1, i64 0, i64 0), i32 noundef 210, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #6, !dbg !294
  unreachable, !dbg !294

8:                                                ; preds = %1
  %9 = load %struct.list*, %struct.list** @the_list, align 8, !dbg !298
  %10 = call zeroext i1 @list_remove(%struct.list* noundef %9, i64 noundef %2), !dbg !299
  %11 = load %struct.list*, %struct.list** @the_list, align 8, !dbg !300
  %12 = call zeroext i1 @list_contains(%struct.list* noundef %11, i64 noundef %2), !dbg !300
  br i1 %12, label %13, label %14, !dbg !303

13:                                               ; preds = %8
  call void @__assert_fail(i8* noundef getelementptr inbounds ([32 x i8], [32 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([49 x i8], [49 x i8]* @.str.1, i64 0, i64 0), i32 noundef 212, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #6, !dbg !300
  unreachable, !dbg !300

14:                                               ; preds = %8
  ret i8* null, !dbg !304
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !305 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !308, metadata !DIExpression()), !dbg !311
  call void @llvm.dbg.declare(metadata i64* %2, metadata !312, metadata !DIExpression()), !dbg !313
  call void @llvm.dbg.declare(metadata i64* %3, metadata !314, metadata !DIExpression()), !dbg !315
  %4 = call %struct.list* @list_new(), !dbg !316
  store %struct.list* %4, %struct.list** @the_list, align 8, !dbg !317
  %5 = call i32 @pthread_create(i64* noundef %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef null) #5, !dbg !318
  %6 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 1 to i8*)) #5, !dbg !319
  %7 = call i32 @pthread_create(i64* noundef %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 2 to i8*)) #5, !dbg !320
  %8 = load i64, i64* %1, align 8, !dbg !321
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !322
  %10 = load i64, i64* %2, align 8, !dbg !323
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !324
  %12 = load i64, i64* %3, align 8, !dbg !325
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !326
  %14 = load %struct.list*, %struct.list** @the_list, align 8, !dbg !327
  %15 = call i32 @list_size(%struct.list* noundef %14), !dbg !327
  %16 = icmp eq i32 %15, 0, !dbg !327
  br i1 %16, label %18, label %17, !dbg !330

17:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([49 x i8], [49 x i8]* @.str.1, i64 0, i64 0), i32 noundef 232, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !327
  unreachable, !dbg !327

18:                                               ; preds = %0
  ret i32 0, !dbg !331
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!44, !45, !46, !47, !48, !49, !50}
!llvm.ident = !{!51}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "the_list", scope: !2, file: !24, line: 203, type: !25, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !23, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lfds/harris-3.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "8e987e9271467abdd2fd26d99e461bee")
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
!15 = !{!16, !19, !20, !22}
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !17, line: 87, baseType: !18)
!17 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!18 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !17, line: 90, baseType: !21)
!21 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!22 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!23 = !{!0}
!24 = !DIFile(filename: "benchmarks/lfds/harris-3.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "8e987e9271467abdd2fd26d99e461bee")
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "list_t", file: !24, line: 19, baseType: !27)
!27 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "list", file: !24, line: 47, size: 192, elements: !28)
!28 = !{!29, !39, !40}
!29 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !27, file: !24, line: 48, baseType: !30, size: 64)
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "node_t", file: !24, line: 18, baseType: !32)
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "node", file: !24, line: 42, size: 128, elements: !33)
!33 = !{!34, !36}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !32, file: !24, line: 43, baseType: !35, size: 64)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "val_t", file: !24, line: 16, baseType: !16)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !32, file: !24, line: 44, baseType: !37, size: 64, offset: 64)
!37 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !38)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !27, file: !24, line: 48, baseType: !30, size: 64, offset: 64)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !27, file: !24, line: 49, baseType: !41, size: 32, offset: 128)
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !42)
!42 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !43)
!43 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!44 = !{i32 7, !"Dwarf Version", i32 5}
!45 = !{i32 2, !"Debug Info Version", i32 3}
!46 = !{i32 1, !"wchar_size", i32 4}
!47 = !{i32 7, !"PIC Level", i32 2}
!48 = !{i32 7, !"PIE Level", i32 2}
!49 = !{i32 7, !"uwtable", i32 1}
!50 = !{i32 7, !"frame-pointer", i32 2}
!51 = !{!"Ubuntu clang version 14.0.6"}
!52 = distinct !DISubprogram(name: "list_contains", scope: !24, file: !24, line: 116, type: !53, scopeLine: 117, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!53 = !DISubroutineType(types: !54)
!54 = !{!22, !25, !35}
!55 = !{}
!56 = !DILocalVariable(name: "the_list", arg: 1, scope: !52, file: !24, line: 116, type: !25)
!57 = !DILocation(line: 0, scope: !52)
!58 = !DILocalVariable(name: "val", arg: 2, scope: !52, file: !24, line: 116, type: !35)
!59 = !DILocation(line: 118, column: 51, scope: !52)
!60 = !DILocation(line: 118, column: 57, scope: !52)
!61 = !DILocation(line: 118, column: 41, scope: !52)
!62 = !DILocation(line: 118, column: 24, scope: !52)
!63 = !DILocalVariable(name: "iterator", scope: !52, file: !24, line: 118, type: !30)
!64 = !DILocation(line: 119, column: 5, scope: !52)
!65 = !DILocation(line: 119, column: 34, scope: !52)
!66 = !DILocation(line: 119, column: 21, scope: !52)
!67 = !DILocation(line: 120, column: 38, scope: !68)
!68 = distinct !DILexicalBlock(scope: !69, file: !24, line: 120, column: 13)
!69 = distinct !DILexicalBlock(scope: !52, file: !24, line: 119, column: 40)
!70 = !DILocation(line: 120, column: 28, scope: !68)
!71 = !DILocation(line: 120, column: 14, scope: !68)
!72 = !DILocation(line: 120, column: 44, scope: !68)
!73 = !DILocation(line: 120, column: 57, scope: !68)
!74 = !DILocation(line: 120, column: 62, scope: !68)
!75 = !DILocation(line: 120, column: 13, scope: !69)
!76 = !DILocation(line: 122, column: 35, scope: !77)
!77 = distinct !DILexicalBlock(scope: !68, file: !24, line: 120, column: 70)
!78 = !DILocation(line: 122, column: 13, scope: !77)
!79 = !DILocation(line: 126, column: 47, scope: !69)
!80 = !DILocation(line: 126, column: 37, scope: !69)
!81 = !DILocation(line: 126, column: 20, scope: !69)
!82 = distinct !{!82, !64, !83, !84}
!83 = !DILocation(line: 127, column: 5, scope: !52)
!84 = !{!"llvm.loop.mustprogress"}
!85 = !DILocation(line: 129, column: 1, scope: !52)
!86 = distinct !DISubprogram(name: "get_unmarked_ref", scope: !24, file: !24, line: 63, type: !87, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!87 = !DISubroutineType(types: !88)
!88 = !{!19, !19}
!89 = !DILocalVariable(name: "w", arg: 1, scope: !86, file: !24, line: 63, type: !19)
!90 = !DILocation(line: 0, scope: !86)
!91 = !DILocation(line: 65, column: 22, scope: !86)
!92 = !DILocation(line: 65, column: 36, scope: !86)
!93 = !DILocation(line: 65, column: 12, scope: !86)
!94 = !DILocation(line: 65, column: 5, scope: !86)
!95 = distinct !DISubprogram(name: "is_marked_ref", scope: !24, file: !24, line: 58, type: !96, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!96 = !DISubroutineType(types: !97)
!97 = !{!22, !19}
!98 = !DILocalVariable(name: "i", arg: 1, scope: !95, file: !24, line: 58, type: !19)
!99 = !DILocation(line: 0, scope: !95)
!100 = !DILocation(line: 60, column: 20, scope: !95)
!101 = !DILocation(line: 60, column: 34, scope: !95)
!102 = !DILocation(line: 60, column: 12, scope: !95)
!103 = !DILocation(line: 60, column: 5, scope: !95)
!104 = distinct !DISubprogram(name: "list_new", scope: !24, file: !24, line: 139, type: !105, scopeLine: 140, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!105 = !DISubroutineType(types: !106)
!106 = !{!25}
!107 = !DILocation(line: 142, column: 24, scope: !104)
!108 = !DILocalVariable(name: "the_list", scope: !104, file: !24, line: 142, type: !25)
!109 = !DILocation(line: 0, scope: !104)
!110 = !DILocation(line: 145, column: 22, scope: !104)
!111 = !DILocation(line: 145, column: 15, scope: !104)
!112 = !DILocation(line: 145, column: 20, scope: !104)
!113 = !DILocation(line: 146, column: 22, scope: !104)
!114 = !DILocation(line: 146, column: 15, scope: !104)
!115 = !DILocation(line: 146, column: 20, scope: !104)
!116 = !DILocation(line: 147, column: 21, scope: !104)
!117 = !DILocation(line: 147, column: 26, scope: !104)
!118 = !DILocation(line: 148, column: 15, scope: !104)
!119 = !DILocation(line: 148, column: 20, scope: !104)
!120 = !DILocation(line: 149, column: 5, scope: !104)
!121 = distinct !DISubprogram(name: "new_node", scope: !24, file: !24, line: 131, type: !122, scopeLine: 132, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!122 = !DISubroutineType(types: !123)
!123 = !{!30, !35, !30}
!124 = !DILocalVariable(name: "val", arg: 1, scope: !121, file: !24, line: 131, type: !35)
!125 = !DILocation(line: 0, scope: !121)
!126 = !DILocalVariable(name: "next", arg: 2, scope: !121, file: !24, line: 131, type: !30)
!127 = !DILocation(line: 133, column: 20, scope: !121)
!128 = !DILocalVariable(name: "node", scope: !121, file: !24, line: 133, type: !30)
!129 = !DILocation(line: 134, column: 11, scope: !121)
!130 = !DILocation(line: 134, column: 16, scope: !121)
!131 = !DILocation(line: 135, column: 11, scope: !121)
!132 = !DILocation(line: 135, column: 16, scope: !121)
!133 = !DILocation(line: 136, column: 5, scope: !121)
!134 = distinct !DISubprogram(name: "list_delete", scope: !24, file: !24, line: 152, type: !135, scopeLine: 153, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!135 = !DISubroutineType(types: !136)
!136 = !{null, !25}
!137 = !DILocalVariable(name: "the_list", arg: 1, scope: !134, file: !24, line: 152, type: !25)
!138 = !DILocation(line: 0, scope: !134)
!139 = !DILocation(line: 155, column: 1, scope: !134)
!140 = distinct !DISubprogram(name: "list_size", scope: !24, file: !24, line: 157, type: !141, scopeLine: 158, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!141 = !DISubroutineType(types: !142)
!142 = !{!43, !25}
!143 = !DILocalVariable(name: "the_list", arg: 1, scope: !140, file: !24, line: 157, type: !25)
!144 = !DILocation(line: 0, scope: !140)
!145 = !DILocation(line: 159, column: 22, scope: !140)
!146 = !DILocation(line: 159, column: 5, scope: !140)
!147 = distinct !DISubprogram(name: "list_add", scope: !24, file: !24, line: 162, type: !53, scopeLine: 163, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!148 = !DILocalVariable(name: "the_list", arg: 1, scope: !147, file: !24, line: 162, type: !25)
!149 = !DILocation(line: 0, scope: !147)
!150 = !DILocalVariable(name: "val", arg: 2, scope: !147, file: !24, line: 162, type: !35)
!151 = !DILocalVariable(name: "left", scope: !147, file: !24, line: 164, type: !30)
!152 = !DILocation(line: 164, column: 13, scope: !147)
!153 = !DILocation(line: 165, column: 24, scope: !147)
!154 = !DILocalVariable(name: "new_elem", scope: !147, file: !24, line: 165, type: !30)
!155 = !DILocation(line: 166, column: 5, scope: !147)
!156 = !DILocation(line: 167, column: 25, scope: !157)
!157 = distinct !DILexicalBlock(scope: !147, file: !24, line: 166, column: 15)
!158 = !DILocalVariable(name: "right", scope: !157, file: !24, line: 167, type: !30)
!159 = !DILocation(line: 0, scope: !157)
!160 = !DILocation(line: 168, column: 32, scope: !161)
!161 = distinct !DILexicalBlock(scope: !157, file: !24, line: 168, column: 13)
!162 = !DILocation(line: 168, column: 19, scope: !161)
!163 = !DILocation(line: 168, column: 37, scope: !161)
!164 = !DILocation(line: 168, column: 47, scope: !161)
!165 = !DILocation(line: 168, column: 52, scope: !161)
!166 = !DILocation(line: 168, column: 13, scope: !157)
!167 = !DILocation(line: 172, column: 19, scope: !157)
!168 = !DILocation(line: 172, column: 24, scope: !157)
!169 = !DILocation(line: 173, column: 55, scope: !170)
!170 = distinct !DILexicalBlock(scope: !157, file: !24, line: 173, column: 13)
!171 = !DILocation(line: 173, column: 61, scope: !170)
!172 = !DILocation(line: 173, column: 13, scope: !170)
!173 = !DILocation(line: 173, column: 13, scope: !157)
!174 = distinct !{!174, !155, !175}
!175 = !DILocation(line: 177, column: 5, scope: !147)
!176 = !DILocation(line: 174, column: 51, scope: !177)
!177 = distinct !DILexicalBlock(scope: !170, file: !24, line: 173, column: 131)
!178 = !DILocation(line: 174, column: 13, scope: !177)
!179 = !DILocation(line: 175, column: 13, scope: !177)
!180 = !DILocation(line: 178, column: 1, scope: !147)
!181 = distinct !DISubprogram(name: "list_search", scope: !24, file: !24, line: 81, type: !182, scopeLine: 82, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!182 = !DISubroutineType(types: !183)
!183 = !{!30, !25, !35, !184}
!184 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!185 = !DILocalVariable(name: "set", arg: 1, scope: !181, file: !24, line: 81, type: !25)
!186 = !DILocation(line: 0, scope: !181)
!187 = !DILocalVariable(name: "val", arg: 2, scope: !181, file: !24, line: 81, type: !35)
!188 = !DILocalVariable(name: "left_node", arg: 3, scope: !181, file: !24, line: 81, type: !184)
!189 = !DILocalVariable(name: "right_node", scope: !181, file: !24, line: 83, type: !30)
!190 = !DILocalVariable(name: "left_node_next", scope: !181, file: !24, line: 83, type: !30)
!191 = !DILocation(line: 85, column: 5, scope: !181)
!192 = !DILocation(line: 84, column: 20, scope: !181)
!193 = !DILocation(line: 86, column: 26, scope: !194)
!194 = distinct !DILexicalBlock(scope: !181, file: !24, line: 85, column: 15)
!195 = !DILocalVariable(name: "t", scope: !194, file: !24, line: 86, type: !30)
!196 = !DILocation(line: 0, scope: !194)
!197 = !DILocation(line: 87, column: 37, scope: !194)
!198 = !DILocalVariable(name: "t_next", scope: !194, file: !24, line: 87, type: !30)
!199 = !DILocation(line: 88, column: 9, scope: !194)
!200 = !DILocation(line: 88, column: 30, scope: !194)
!201 = !DILocation(line: 88, column: 16, scope: !194)
!202 = !DILocation(line: 88, column: 38, scope: !194)
!203 = !DILocation(line: 88, column: 45, scope: !194)
!204 = !DILocation(line: 88, column: 50, scope: !194)
!205 = !DILocation(line: 89, column: 18, scope: !206)
!206 = distinct !DILexicalBlock(scope: !207, file: !24, line: 89, column: 17)
!207 = distinct !DILexicalBlock(scope: !194, file: !24, line: 88, column: 58)
!208 = !DILocation(line: 89, column: 17, scope: !207)
!209 = !DILocation(line: 90, column: 30, scope: !210)
!210 = distinct !DILexicalBlock(scope: !206, file: !24, line: 89, column: 41)
!211 = !DILocation(line: 92, column: 13, scope: !210)
!212 = !DILocation(line: 93, column: 17, scope: !207)
!213 = !DILocation(line: 94, column: 27, scope: !214)
!214 = distinct !DILexicalBlock(scope: !207, file: !24, line: 94, column: 17)
!215 = !DILocation(line: 94, column: 19, scope: !214)
!216 = !DILocation(line: 94, column: 17, scope: !207)
!217 = !DILocation(line: 97, column: 25, scope: !207)
!218 = distinct !{!218, !199, !219, !84}
!219 = !DILocation(line: 98, column: 9, scope: !194)
!220 = !DILocation(line: 101, column: 28, scope: !221)
!221 = distinct !DILexicalBlock(scope: !194, file: !24, line: 101, column: 13)
!222 = !DILocation(line: 101, column: 13, scope: !194)
!223 = !DILocation(line: 102, column: 44, scope: !224)
!224 = distinct !DILexicalBlock(scope: !225, file: !24, line: 102, column: 17)
!225 = distinct !DILexicalBlock(scope: !221, file: !24, line: 101, column: 43)
!226 = !DILocation(line: 102, column: 32, scope: !224)
!227 = !DILocation(line: 102, column: 18, scope: !224)
!228 = !DILocation(line: 102, column: 17, scope: !225)
!229 = !DILocation(line: 106, column: 60, scope: !230)
!230 = distinct !DILexicalBlock(scope: !231, file: !24, line: 106, column: 17)
!231 = distinct !DILexicalBlock(scope: !221, file: !24, line: 105, column: 16)
!232 = !DILocation(line: 106, column: 73, scope: !230)
!233 = !DILocation(line: 106, column: 17, scope: !230)
!234 = !DILocation(line: 106, column: 17, scope: !231)
!235 = !DILocation(line: 107, column: 48, scope: !236)
!236 = distinct !DILexicalBlock(scope: !237, file: !24, line: 107, column: 21)
!237 = distinct !DILexicalBlock(scope: !230, file: !24, line: 106, column: 154)
!238 = !DILocation(line: 107, column: 36, scope: !236)
!239 = !DILocation(line: 107, column: 22, scope: !236)
!240 = !DILocation(line: 107, column: 21, scope: !237)
!241 = distinct !{!241, !191, !242}
!242 = !DILocation(line: 112, column: 5, scope: !181)
!243 = !DILocation(line: 113, column: 1, scope: !181)
!244 = distinct !DISubprogram(name: "list_remove", scope: !24, file: !24, line: 181, type: !53, scopeLine: 182, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!245 = !DILocalVariable(name: "the_list", arg: 1, scope: !244, file: !24, line: 181, type: !25)
!246 = !DILocation(line: 0, scope: !244)
!247 = !DILocalVariable(name: "val", arg: 2, scope: !244, file: !24, line: 181, type: !35)
!248 = !DILocalVariable(name: "left", scope: !244, file: !24, line: 183, type: !30)
!249 = !DILocation(line: 183, column: 13, scope: !244)
!250 = !DILocation(line: 184, column: 5, scope: !244)
!251 = !DILocation(line: 185, column: 25, scope: !252)
!252 = distinct !DILexicalBlock(scope: !244, file: !24, line: 184, column: 15)
!253 = !DILocalVariable(name: "right", scope: !252, file: !24, line: 185, type: !30)
!254 = !DILocation(line: 0, scope: !252)
!255 = !DILocation(line: 187, column: 33, scope: !256)
!256 = distinct !DILexicalBlock(scope: !252, file: !24, line: 187, column: 13)
!257 = !DILocation(line: 187, column: 20, scope: !256)
!258 = !DILocation(line: 187, column: 39, scope: !256)
!259 = !DILocation(line: 187, column: 50, scope: !256)
!260 = !DILocation(line: 187, column: 55, scope: !256)
!261 = !DILocation(line: 187, column: 13, scope: !252)
!262 = !DILocation(line: 191, column: 37, scope: !252)
!263 = !DILocalVariable(name: "right_succ", scope: !252, file: !24, line: 191, type: !30)
!264 = !DILocation(line: 192, column: 28, scope: !265)
!265 = distinct !DILexicalBlock(scope: !252, file: !24, line: 192, column: 13)
!266 = !DILocation(line: 192, column: 14, scope: !265)
!267 = !DILocation(line: 192, column: 13, scope: !252)
!268 = !DILocation(line: 194, column: 25, scope: !269)
!269 = distinct !DILexicalBlock(scope: !270, file: !24, line: 193, column: 17)
!270 = distinct !DILexicalBlock(scope: !265, file: !24, line: 192, column: 41)
!271 = !DILocation(line: 193, column: 17, scope: !269)
!272 = !DILocation(line: 193, column: 17, scope: !270)
!273 = !DILocation(line: 195, column: 55, scope: !274)
!274 = distinct !DILexicalBlock(scope: !269, file: !24, line: 194, column: 98)
!275 = !DILocation(line: 195, column: 17, scope: !274)
!276 = !DILocation(line: 196, column: 17, scope: !274)
!277 = distinct !{!277, !250, !278}
!278 = !DILocation(line: 199, column: 5, scope: !244)
!279 = !DILocation(line: 200, column: 1, scope: !244)
!280 = distinct !DISubprogram(name: "get_marked_ref", scope: !24, file: !24, line: 68, type: !87, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!281 = !DILocalVariable(name: "w", arg: 1, scope: !280, file: !24, line: 68, type: !19)
!282 = !DILocation(line: 0, scope: !280)
!283 = !DILocation(line: 70, column: 22, scope: !280)
!284 = !DILocation(line: 70, column: 36, scope: !280)
!285 = !DILocation(line: 70, column: 12, scope: !280)
!286 = !DILocation(line: 70, column: 5, scope: !280)
!287 = distinct !DISubprogram(name: "thread_n", scope: !24, file: !24, line: 205, type: !87, scopeLine: 206, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!288 = !DILocalVariable(name: "arg", arg: 1, scope: !287, file: !24, line: 205, type: !19)
!289 = !DILocation(line: 0, scope: !287)
!290 = !DILocation(line: 207, column: 23, scope: !287)
!291 = !DILocalVariable(name: "index", scope: !287, file: !24, line: 207, type: !16)
!292 = !DILocation(line: 209, column: 14, scope: !287)
!293 = !DILocation(line: 209, column: 5, scope: !287)
!294 = !DILocation(line: 210, column: 5, scope: !295)
!295 = distinct !DILexicalBlock(scope: !296, file: !24, line: 210, column: 5)
!296 = distinct !DILexicalBlock(scope: !287, file: !24, line: 210, column: 5)
!297 = !DILocation(line: 210, column: 5, scope: !296)
!298 = !DILocation(line: 211, column: 17, scope: !287)
!299 = !DILocation(line: 211, column: 5, scope: !287)
!300 = !DILocation(line: 212, column: 5, scope: !301)
!301 = distinct !DILexicalBlock(scope: !302, file: !24, line: 212, column: 5)
!302 = distinct !DILexicalBlock(scope: !287, file: !24, line: 212, column: 5)
!303 = !DILocation(line: 212, column: 5, scope: !302)
!304 = !DILocation(line: 214, column: 5, scope: !287)
!305 = distinct !DISubprogram(name: "main", scope: !24, file: !24, line: 217, type: !306, scopeLine: 218, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!306 = !DISubroutineType(types: !307)
!307 = !{!43}
!308 = !DILocalVariable(name: "t1", scope: !305, file: !24, line: 219, type: !309)
!309 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !310, line: 27, baseType: !21)
!310 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!311 = !DILocation(line: 219, column: 15, scope: !305)
!312 = !DILocalVariable(name: "t2", scope: !305, file: !24, line: 219, type: !309)
!313 = !DILocation(line: 219, column: 19, scope: !305)
!314 = !DILocalVariable(name: "t3", scope: !305, file: !24, line: 219, type: !309)
!315 = !DILocation(line: 219, column: 23, scope: !305)
!316 = !DILocation(line: 222, column: 16, scope: !305)
!317 = !DILocation(line: 222, column: 14, scope: !305)
!318 = !DILocation(line: 224, column: 5, scope: !305)
!319 = !DILocation(line: 225, column: 5, scope: !305)
!320 = !DILocation(line: 226, column: 5, scope: !305)
!321 = !DILocation(line: 228, column: 18, scope: !305)
!322 = !DILocation(line: 228, column: 5, scope: !305)
!323 = !DILocation(line: 229, column: 18, scope: !305)
!324 = !DILocation(line: 229, column: 5, scope: !305)
!325 = !DILocation(line: 230, column: 18, scope: !305)
!326 = !DILocation(line: 230, column: 5, scope: !305)
!327 = !DILocation(line: 232, column: 5, scope: !328)
!328 = distinct !DILexicalBlock(scope: !329, file: !24, line: 232, column: 5)
!329 = distinct !DILexicalBlock(scope: !305, file: !24, line: 232, column: 5)
!330 = !DILocation(line: 232, column: 5, scope: !329)
!331 = !DILocation(line: 234, column: 5, scope: !305)
