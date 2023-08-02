; ModuleID = '/home/ponce/git/Dat3M/benchmarks/locks/clh_mutex.c'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/clh_mutex.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.clh_mutex_t = type { %struct.clh_mutex_node_*, [64 x i32], %struct.clh_mutex_node_* }
%struct.clh_mutex_node_ = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4, !dbg !0
@lock = dso_local global %struct.clh_mutex_t zeroinitializer, align 8, !dbg !33
@shared = dso_local global i32 0, align 4, !dbg !30
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [51 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/clh_mutex.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @clh_mutex_init(%struct.clh_mutex_t* noundef %0) #0 !dbg !53 {
  %2 = alloca %struct.clh_mutex_t*, align 8
  %3 = alloca %struct.clh_mutex_node_*, align 8
  store %struct.clh_mutex_t* %0, %struct.clh_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.clh_mutex_t** %2, metadata !58, metadata !DIExpression()), !dbg !59
  call void @llvm.dbg.declare(metadata %struct.clh_mutex_node_** %3, metadata !60, metadata !DIExpression()), !dbg !61
  %4 = call %struct.clh_mutex_node_* @clh_mutex_create_node(i32 noundef 0), !dbg !62
  store %struct.clh_mutex_node_* %4, %struct.clh_mutex_node_** %3, align 8, !dbg !61
  %5 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %3, align 8, !dbg !63
  %6 = load %struct.clh_mutex_t*, %struct.clh_mutex_t** %2, align 8, !dbg !64
  %7 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %6, i32 0, i32 0, !dbg !65
  store %struct.clh_mutex_node_* %5, %struct.clh_mutex_node_** %7, align 8, !dbg !66
  %8 = load %struct.clh_mutex_t*, %struct.clh_mutex_t** %2, align 8, !dbg !67
  %9 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %8, i32 0, i32 2, !dbg !68
  %10 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %3, align 8, !dbg !69
  store %struct.clh_mutex_node_* %10, %struct.clh_mutex_node_** %9, align 8, !dbg !70
  ret void, !dbg !71
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal %struct.clh_mutex_node_* @clh_mutex_create_node(i32 noundef %0) #0 !dbg !72 {
  %2 = alloca i32, align 4
  %3 = alloca %struct.clh_mutex_node_*, align 8
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !75, metadata !DIExpression()), !dbg !76
  call void @llvm.dbg.declare(metadata %struct.clh_mutex_node_** %3, metadata !77, metadata !DIExpression()), !dbg !78
  %4 = call noalias i8* @malloc(i64 noundef 4) #5, !dbg !79
  %5 = bitcast i8* %4 to %struct.clh_mutex_node_*, !dbg !80
  store %struct.clh_mutex_node_* %5, %struct.clh_mutex_node_** %3, align 8, !dbg !78
  %6 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %3, align 8, !dbg !81
  %7 = getelementptr inbounds %struct.clh_mutex_node_, %struct.clh_mutex_node_* %6, i32 0, i32 0, !dbg !82
  %8 = load i32, i32* %2, align 4, !dbg !83
  store i32 %8, i32* %7, align 4, !dbg !84
  %9 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %3, align 8, !dbg !85
  ret %struct.clh_mutex_node_* %9, !dbg !86
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @clh_mutex_destroy(%struct.clh_mutex_t* noundef %0) #0 !dbg !87 {
  %2 = alloca %struct.clh_mutex_t*, align 8
  %3 = alloca %struct.clh_mutex_node_*, align 8
  store %struct.clh_mutex_t* %0, %struct.clh_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.clh_mutex_t** %2, metadata !88, metadata !DIExpression()), !dbg !89
  %4 = load %struct.clh_mutex_t*, %struct.clh_mutex_t** %2, align 8, !dbg !90
  %5 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %4, i32 0, i32 2, !dbg !90
  %6 = bitcast %struct.clh_mutex_node_** %5 to i64*, !dbg !90
  %7 = bitcast %struct.clh_mutex_node_** %3 to i64*, !dbg !90
  %8 = load atomic i64, i64* %6 seq_cst, align 8, !dbg !90
  store i64 %8, i64* %7, align 8, !dbg !90
  %9 = bitcast i64* %7 to %struct.clh_mutex_node_**, !dbg !90
  %10 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %9, align 8, !dbg !90
  %11 = bitcast %struct.clh_mutex_node_* %10 to i8*, !dbg !90
  call void @free(i8* noundef %11) #5, !dbg !91
  ret void, !dbg !92
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @clh_mutex_lock(%struct.clh_mutex_t* noundef %0) #0 !dbg !93 {
  %2 = alloca %struct.clh_mutex_t*, align 8
  %3 = alloca %struct.clh_mutex_node_*, align 8
  %4 = alloca %struct.clh_mutex_node_*, align 8
  %5 = alloca %struct.clh_mutex_node_*, align 8
  %6 = alloca %struct.clh_mutex_node_*, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store %struct.clh_mutex_t* %0, %struct.clh_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.clh_mutex_t** %2, metadata !94, metadata !DIExpression()), !dbg !95
  call void @llvm.dbg.declare(metadata %struct.clh_mutex_node_** %3, metadata !96, metadata !DIExpression()), !dbg !97
  %10 = call %struct.clh_mutex_node_* @clh_mutex_create_node(i32 noundef 1), !dbg !98
  store %struct.clh_mutex_node_* %10, %struct.clh_mutex_node_** %3, align 8, !dbg !97
  call void @llvm.dbg.declare(metadata %struct.clh_mutex_node_** %4, metadata !99, metadata !DIExpression()), !dbg !100
  %11 = load %struct.clh_mutex_t*, %struct.clh_mutex_t** %2, align 8, !dbg !101
  %12 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %11, i32 0, i32 2, !dbg !101
  %13 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %3, align 8, !dbg !101
  store %struct.clh_mutex_node_* %13, %struct.clh_mutex_node_** %5, align 8, !dbg !101
  %14 = bitcast %struct.clh_mutex_node_** %12 to i64*, !dbg !101
  %15 = bitcast %struct.clh_mutex_node_** %5 to i64*, !dbg !101
  %16 = bitcast %struct.clh_mutex_node_** %6 to i64*, !dbg !101
  %17 = load i64, i64* %15, align 8, !dbg !101
  %18 = atomicrmw xchg i64* %14, i64 %17 seq_cst, align 8, !dbg !101
  store i64 %18, i64* %16, align 8, !dbg !101
  %19 = bitcast i64* %16 to %struct.clh_mutex_node_**, !dbg !101
  %20 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %19, align 8, !dbg !101
  store %struct.clh_mutex_node_* %20, %struct.clh_mutex_node_** %4, align 8, !dbg !100
  call void @llvm.dbg.declare(metadata i32* %7, metadata !102, metadata !DIExpression()), !dbg !103
  %21 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %4, align 8, !dbg !104
  %22 = getelementptr inbounds %struct.clh_mutex_node_, %struct.clh_mutex_node_* %21, i32 0, i32 0, !dbg !105
  %23 = load atomic i32, i32* %22 acquire, align 4, !dbg !106
  store i32 %23, i32* %8, align 4, !dbg !106
  %24 = load i32, i32* %8, align 4, !dbg !106
  store i32 %24, i32* %7, align 4, !dbg !103
  %25 = load i32, i32* %7, align 4, !dbg !107
  %26 = icmp ne i32 %25, 0, !dbg !107
  br i1 %26, label %27, label %37, !dbg !109

27:                                               ; preds = %1
  br label %28, !dbg !110

28:                                               ; preds = %31, %27
  %29 = load i32, i32* %7, align 4, !dbg !112
  %30 = icmp ne i32 %29, 0, !dbg !110
  br i1 %30, label %31, label %36, !dbg !110

31:                                               ; preds = %28
  %32 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %4, align 8, !dbg !113
  %33 = getelementptr inbounds %struct.clh_mutex_node_, %struct.clh_mutex_node_* %32, i32 0, i32 0, !dbg !115
  %34 = load atomic i32, i32* %33 acquire, align 4, !dbg !116
  store i32 %34, i32* %9, align 4, !dbg !116
  %35 = load i32, i32* %9, align 4, !dbg !116
  store i32 %35, i32* %7, align 4, !dbg !117
  br label %28, !dbg !110, !llvm.loop !118

36:                                               ; preds = %28
  br label %37, !dbg !121

37:                                               ; preds = %36, %1
  %38 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %4, align 8, !dbg !122
  %39 = bitcast %struct.clh_mutex_node_* %38 to i8*, !dbg !122
  call void @free(i8* noundef %39) #5, !dbg !123
  %40 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %3, align 8, !dbg !124
  %41 = load %struct.clh_mutex_t*, %struct.clh_mutex_t** %2, align 8, !dbg !125
  %42 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %41, i32 0, i32 0, !dbg !126
  store %struct.clh_mutex_node_* %40, %struct.clh_mutex_node_** %42, align 8, !dbg !127
  ret void, !dbg !128
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @clh_mutex_unlock(%struct.clh_mutex_t* noundef %0) #0 !dbg !129 {
  %2 = alloca %struct.clh_mutex_t*, align 8
  %3 = alloca i32, align 4
  store %struct.clh_mutex_t* %0, %struct.clh_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.clh_mutex_t** %2, metadata !130, metadata !DIExpression()), !dbg !131
  %4 = load %struct.clh_mutex_t*, %struct.clh_mutex_t** %2, align 8, !dbg !132
  %5 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %4, i32 0, i32 0, !dbg !134
  %6 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %5, align 8, !dbg !134
  %7 = icmp eq %struct.clh_mutex_node_* %6, null, !dbg !135
  br i1 %7, label %8, label %9, !dbg !136

8:                                                ; preds = %1
  br label %15, !dbg !137

9:                                                ; preds = %1
  %10 = load %struct.clh_mutex_t*, %struct.clh_mutex_t** %2, align 8, !dbg !139
  %11 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %10, i32 0, i32 0, !dbg !140
  %12 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %11, align 8, !dbg !140
  %13 = getelementptr inbounds %struct.clh_mutex_node_, %struct.clh_mutex_node_* %12, i32 0, i32 0, !dbg !141
  store i32 0, i32* %3, align 4, !dbg !142
  %14 = load i32, i32* %3, align 4, !dbg !142
  store atomic i32 %14, i32* %13 release, align 4, !dbg !142
  br label %15, !dbg !143

15:                                               ; preds = %9, %8
  ret void, !dbg !143
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !144 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !147, metadata !DIExpression()), !dbg !148
  call void @llvm.dbg.declare(metadata i64* %3, metadata !149, metadata !DIExpression()), !dbg !150
  %5 = load i8*, i8** %2, align 8, !dbg !151
  %6 = ptrtoint i8* %5 to i64, !dbg !152
  store i64 %6, i64* %3, align 8, !dbg !150
  call void @clh_mutex_lock(%struct.clh_mutex_t* noundef @lock), !dbg !153
  %7 = load i64, i64* %3, align 8, !dbg !154
  %8 = trunc i64 %7 to i32, !dbg !154
  store i32 %8, i32* @shared, align 4, !dbg !155
  call void @llvm.dbg.declare(metadata i32* %4, metadata !156, metadata !DIExpression()), !dbg !157
  %9 = load i32, i32* @shared, align 4, !dbg !158
  store i32 %9, i32* %4, align 4, !dbg !157
  %10 = load i32, i32* %4, align 4, !dbg !159
  %11 = sext i32 %10 to i64, !dbg !159
  %12 = load i64, i64* %3, align 8, !dbg !159
  %13 = icmp eq i64 %11, %12, !dbg !159
  br i1 %13, label %14, label %15, !dbg !162

14:                                               ; preds = %1
  br label %16, !dbg !162

15:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #6, !dbg !159
  unreachable, !dbg !159

16:                                               ; preds = %14
  %17 = load i32, i32* @sum, align 4, !dbg !163
  %18 = add nsw i32 %17, 1, !dbg !163
  store i32 %18, i32* @sum, align 4, !dbg !163
  call void @clh_mutex_unlock(%struct.clh_mutex_t* noundef @lock), !dbg !164
  ret i8* null, !dbg !165
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !166 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i64]* %2, metadata !169, metadata !DIExpression()), !dbg !176
  call void @clh_mutex_init(%struct.clh_mutex_t* noundef @lock), !dbg !177
  call void @llvm.dbg.declare(metadata i32* %3, metadata !178, metadata !DIExpression()), !dbg !180
  store i32 0, i32* %3, align 4, !dbg !180
  br label %5, !dbg !181

5:                                                ; preds = %16, %0
  %6 = load i32, i32* %3, align 4, !dbg !182
  %7 = icmp slt i32 %6, 3, !dbg !184
  br i1 %7, label %8, label %19, !dbg !185

8:                                                ; preds = %5
  %9 = load i32, i32* %3, align 4, !dbg !186
  %10 = sext i32 %9 to i64, !dbg !187
  %11 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %10, !dbg !187
  %12 = load i32, i32* %3, align 4, !dbg !188
  %13 = sext i32 %12 to i64, !dbg !189
  %14 = inttoptr i64 %13 to i8*, !dbg !189
  %15 = call i32 @pthread_create(i64* noundef %11, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef %14) #5, !dbg !190
  br label %16, !dbg !190

16:                                               ; preds = %8
  %17 = load i32, i32* %3, align 4, !dbg !191
  %18 = add nsw i32 %17, 1, !dbg !191
  store i32 %18, i32* %3, align 4, !dbg !191
  br label %5, !dbg !192, !llvm.loop !193

19:                                               ; preds = %5
  call void @llvm.dbg.declare(metadata i32* %4, metadata !195, metadata !DIExpression()), !dbg !197
  store i32 0, i32* %4, align 4, !dbg !197
  br label %20, !dbg !198

20:                                               ; preds = %29, %19
  %21 = load i32, i32* %4, align 4, !dbg !199
  %22 = icmp slt i32 %21, 3, !dbg !201
  br i1 %22, label %23, label %32, !dbg !202

23:                                               ; preds = %20
  %24 = load i32, i32* %4, align 4, !dbg !203
  %25 = sext i32 %24 to i64, !dbg !204
  %26 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %25, !dbg !204
  %27 = load i64, i64* %26, align 8, !dbg !204
  %28 = call i32 @pthread_join(i64 noundef %27, i8** noundef null), !dbg !205
  br label %29, !dbg !205

29:                                               ; preds = %23
  %30 = load i32, i32* %4, align 4, !dbg !206
  %31 = add nsw i32 %30, 1, !dbg !206
  store i32 %31, i32* %4, align 4, !dbg !206
  br label %20, !dbg !207, !llvm.loop !208

32:                                               ; preds = %20
  %33 = load i32, i32* @sum, align 4, !dbg !210
  %34 = icmp eq i32 %33, 3, !dbg !210
  br i1 %34, label %35, label %36, !dbg !213

35:                                               ; preds = %32
  br label %37, !dbg !213

36:                                               ; preds = %32
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !210
  unreachable, !dbg !210

37:                                               ; preds = %35
  ret i32 0, !dbg !214
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!45, !46, !47, !48, !49, !50, !51}
!llvm.ident = !{!52}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !32, line: 11, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !29, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/clh_mutex.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "51cac0d4cd603dc7c2f7485c0bafbfbf")
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
!15 = !{!16, !17, !20}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !18, line: 87, baseType: !19)
!18 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!19 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "clh_mutex_node_t", file: !22, line: 74, baseType: !23)
!22 = !DIFile(filename: "benchmarks/locks/clh_mutex.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "d88c40a0440b1421c9a593b20ac5ab10")
!23 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "clh_mutex_node_", file: !22, line: 76, size: 32, elements: !24)
!24 = !{!25}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "succ_must_wait", scope: !23, file: !22, line: 78, baseType: !26, size: 32)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !27)
!27 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !28)
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !{!0, !30, !33}
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "shared", scope: !2, file: !32, line: 9, type: !28, isLocal: false, isDefinition: true)
!32 = !DIFile(filename: "benchmarks/locks/clh_mutex.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "51cac0d4cd603dc7c2f7485c0bafbfbf")
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !32, line: 10, type: !35, isLocal: false, isDefinition: true)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "clh_mutex_t", file: !22, line: 86, baseType: !36)
!36 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !22, line: 81, size: 2176, elements: !37)
!37 = !{!38, !39, !43}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "mynode", scope: !36, file: !22, line: 83, baseType: !20, size: 64)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "padding", scope: !36, file: !22, line: 84, baseType: !40, size: 2048, offset: 64)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !28, size: 2048, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 64)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !36, file: !22, line: 85, baseType: !44, size: 64, offset: 2112)
!44 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !20)
!45 = !{i32 7, !"Dwarf Version", i32 5}
!46 = !{i32 2, !"Debug Info Version", i32 3}
!47 = !{i32 1, !"wchar_size", i32 4}
!48 = !{i32 7, !"PIC Level", i32 2}
!49 = !{i32 7, !"PIE Level", i32 2}
!50 = !{i32 7, !"uwtable", i32 1}
!51 = !{i32 7, !"frame-pointer", i32 2}
!52 = !{!"Ubuntu clang version 14.0.6"}
!53 = distinct !DISubprogram(name: "clh_mutex_init", scope: !22, file: !22, line: 101, type: !54, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !57)
!54 = !DISubroutineType(types: !55)
!55 = !{null, !56}
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!57 = !{}
!58 = !DILocalVariable(name: "self", arg: 1, scope: !53, file: !22, line: 101, type: !56)
!59 = !DILocation(line: 101, column: 35, scope: !53)
!60 = !DILocalVariable(name: "node", scope: !53, file: !22, line: 104, type: !20)
!61 = !DILocation(line: 104, column: 24, scope: !53)
!62 = !DILocation(line: 104, column: 31, scope: !53)
!63 = !DILocation(line: 105, column: 20, scope: !53)
!64 = !DILocation(line: 105, column: 5, scope: !53)
!65 = !DILocation(line: 105, column: 11, scope: !53)
!66 = !DILocation(line: 105, column: 18, scope: !53)
!67 = !DILocation(line: 106, column: 18, scope: !53)
!68 = !DILocation(line: 106, column: 24, scope: !53)
!69 = !DILocation(line: 106, column: 30, scope: !53)
!70 = !DILocation(line: 106, column: 5, scope: !53)
!71 = !DILocation(line: 107, column: 1, scope: !53)
!72 = distinct !DISubprogram(name: "clh_mutex_create_node", scope: !22, file: !22, line: 88, type: !73, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !57)
!73 = !DISubroutineType(types: !74)
!74 = !{!20, !28}
!75 = !DILocalVariable(name: "islocked", arg: 1, scope: !72, file: !22, line: 88, type: !28)
!76 = !DILocation(line: 88, column: 53, scope: !72)
!77 = !DILocalVariable(name: "new_node", scope: !72, file: !22, line: 90, type: !20)
!78 = !DILocation(line: 90, column: 24, scope: !72)
!79 = !DILocation(line: 90, column: 55, scope: !72)
!80 = !DILocation(line: 90, column: 35, scope: !72)
!81 = !DILocation(line: 91, column: 18, scope: !72)
!82 = !DILocation(line: 91, column: 28, scope: !72)
!83 = !DILocation(line: 91, column: 44, scope: !72)
!84 = !DILocation(line: 91, column: 5, scope: !72)
!85 = !DILocation(line: 92, column: 12, scope: !72)
!86 = !DILocation(line: 92, column: 5, scope: !72)
!87 = distinct !DISubprogram(name: "clh_mutex_destroy", scope: !22, file: !22, line: 117, type: !54, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !57)
!88 = !DILocalVariable(name: "self", arg: 1, scope: !87, file: !22, line: 117, type: !56)
!89 = !DILocation(line: 117, column: 38, scope: !87)
!90 = !DILocation(line: 119, column: 10, scope: !87)
!91 = !DILocation(line: 119, column: 5, scope: !87)
!92 = !DILocation(line: 120, column: 1, scope: !87)
!93 = distinct !DISubprogram(name: "clh_mutex_lock", scope: !22, file: !22, line: 129, type: !54, scopeLine: 130, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !57)
!94 = !DILocalVariable(name: "self", arg: 1, scope: !93, file: !22, line: 129, type: !56)
!95 = !DILocation(line: 129, column: 35, scope: !93)
!96 = !DILocalVariable(name: "mynode", scope: !93, file: !22, line: 132, type: !20)
!97 = !DILocation(line: 132, column: 23, scope: !93)
!98 = !DILocation(line: 132, column: 32, scope: !93)
!99 = !DILocalVariable(name: "prev", scope: !93, file: !22, line: 133, type: !20)
!100 = !DILocation(line: 133, column: 23, scope: !93)
!101 = !DILocation(line: 133, column: 30, scope: !93)
!102 = !DILocalVariable(name: "prev_islocked", scope: !93, file: !22, line: 140, type: !28)
!103 = !DILocation(line: 140, column: 9, scope: !93)
!104 = !DILocation(line: 140, column: 47, scope: !93)
!105 = !DILocation(line: 140, column: 53, scope: !93)
!106 = !DILocation(line: 140, column: 25, scope: !93)
!107 = !DILocation(line: 142, column: 9, scope: !108)
!108 = distinct !DILexicalBlock(scope: !93, file: !22, line: 142, column: 9)
!109 = !DILocation(line: 142, column: 9, scope: !93)
!110 = !DILocation(line: 143, column: 9, scope: !111)
!111 = distinct !DILexicalBlock(scope: !108, file: !22, line: 142, column: 24)
!112 = !DILocation(line: 143, column: 16, scope: !111)
!113 = !DILocation(line: 144, column: 51, scope: !114)
!114 = distinct !DILexicalBlock(scope: !111, file: !22, line: 143, column: 31)
!115 = !DILocation(line: 144, column: 57, scope: !114)
!116 = !DILocation(line: 144, column: 29, scope: !114)
!117 = !DILocation(line: 144, column: 27, scope: !114)
!118 = distinct !{!118, !110, !119, !120}
!119 = !DILocation(line: 145, column: 9, scope: !111)
!120 = !{!"llvm.loop.mustprogress"}
!121 = !DILocation(line: 146, column: 5, scope: !111)
!122 = !DILocation(line: 149, column: 10, scope: !93)
!123 = !DILocation(line: 149, column: 5, scope: !93)
!124 = !DILocation(line: 153, column: 20, scope: !93)
!125 = !DILocation(line: 153, column: 5, scope: !93)
!126 = !DILocation(line: 153, column: 11, scope: !93)
!127 = !DILocation(line: 153, column: 18, scope: !93)
!128 = !DILocation(line: 154, column: 1, scope: !93)
!129 = distinct !DISubprogram(name: "clh_mutex_unlock", scope: !22, file: !22, line: 163, type: !54, scopeLine: 164, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !57)
!130 = !DILocalVariable(name: "self", arg: 1, scope: !129, file: !22, line: 163, type: !56)
!131 = !DILocation(line: 163, column: 37, scope: !129)
!132 = !DILocation(line: 168, column: 9, scope: !133)
!133 = distinct !DILexicalBlock(scope: !129, file: !22, line: 168, column: 9)
!134 = !DILocation(line: 168, column: 15, scope: !133)
!135 = !DILocation(line: 168, column: 22, scope: !133)
!136 = !DILocation(line: 168, column: 9, scope: !129)
!137 = !DILocation(line: 170, column: 9, scope: !138)
!138 = distinct !DILexicalBlock(scope: !133, file: !22, line: 168, column: 31)
!139 = !DILocation(line: 172, column: 28, scope: !129)
!140 = !DILocation(line: 172, column: 34, scope: !129)
!141 = !DILocation(line: 172, column: 42, scope: !129)
!142 = !DILocation(line: 172, column: 5, scope: !129)
!143 = !DILocation(line: 173, column: 1, scope: !129)
!144 = distinct !DISubprogram(name: "thread_n", scope: !32, file: !32, line: 13, type: !145, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !57)
!145 = !DISubroutineType(types: !146)
!146 = !{!16, !16}
!147 = !DILocalVariable(name: "arg", arg: 1, scope: !144, file: !32, line: 13, type: !16)
!148 = !DILocation(line: 13, column: 22, scope: !144)
!149 = !DILocalVariable(name: "index", scope: !144, file: !32, line: 15, type: !17)
!150 = !DILocation(line: 15, column: 14, scope: !144)
!151 = !DILocation(line: 15, column: 34, scope: !144)
!152 = !DILocation(line: 15, column: 23, scope: !144)
!153 = !DILocation(line: 17, column: 5, scope: !144)
!154 = !DILocation(line: 18, column: 14, scope: !144)
!155 = !DILocation(line: 18, column: 12, scope: !144)
!156 = !DILocalVariable(name: "r", scope: !144, file: !32, line: 19, type: !28)
!157 = !DILocation(line: 19, column: 9, scope: !144)
!158 = !DILocation(line: 19, column: 13, scope: !144)
!159 = !DILocation(line: 20, column: 5, scope: !160)
!160 = distinct !DILexicalBlock(scope: !161, file: !32, line: 20, column: 5)
!161 = distinct !DILexicalBlock(scope: !144, file: !32, line: 20, column: 5)
!162 = !DILocation(line: 20, column: 5, scope: !161)
!163 = !DILocation(line: 21, column: 8, scope: !144)
!164 = !DILocation(line: 22, column: 5, scope: !144)
!165 = !DILocation(line: 23, column: 5, scope: !144)
!166 = distinct !DISubprogram(name: "main", scope: !32, file: !32, line: 26, type: !167, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !57)
!167 = !DISubroutineType(types: !168)
!168 = !{!28}
!169 = !DILocalVariable(name: "t", scope: !166, file: !32, line: 28, type: !170)
!170 = !DICompositeType(tag: DW_TAG_array_type, baseType: !171, size: 192, elements: !174)
!171 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !172, line: 27, baseType: !173)
!172 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!173 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!174 = !{!175}
!175 = !DISubrange(count: 3)
!176 = !DILocation(line: 28, column: 15, scope: !166)
!177 = !DILocation(line: 30, column: 5, scope: !166)
!178 = !DILocalVariable(name: "i", scope: !179, file: !32, line: 32, type: !28)
!179 = distinct !DILexicalBlock(scope: !166, file: !32, line: 32, column: 5)
!180 = !DILocation(line: 32, column: 14, scope: !179)
!181 = !DILocation(line: 32, column: 10, scope: !179)
!182 = !DILocation(line: 32, column: 21, scope: !183)
!183 = distinct !DILexicalBlock(scope: !179, file: !32, line: 32, column: 5)
!184 = !DILocation(line: 32, column: 23, scope: !183)
!185 = !DILocation(line: 32, column: 5, scope: !179)
!186 = !DILocation(line: 33, column: 27, scope: !183)
!187 = !DILocation(line: 33, column: 25, scope: !183)
!188 = !DILocation(line: 33, column: 52, scope: !183)
!189 = !DILocation(line: 33, column: 44, scope: !183)
!190 = !DILocation(line: 33, column: 9, scope: !183)
!191 = !DILocation(line: 32, column: 36, scope: !183)
!192 = !DILocation(line: 32, column: 5, scope: !183)
!193 = distinct !{!193, !185, !194, !120}
!194 = !DILocation(line: 33, column: 53, scope: !179)
!195 = !DILocalVariable(name: "i", scope: !196, file: !32, line: 35, type: !28)
!196 = distinct !DILexicalBlock(scope: !166, file: !32, line: 35, column: 5)
!197 = !DILocation(line: 35, column: 14, scope: !196)
!198 = !DILocation(line: 35, column: 10, scope: !196)
!199 = !DILocation(line: 35, column: 21, scope: !200)
!200 = distinct !DILexicalBlock(scope: !196, file: !32, line: 35, column: 5)
!201 = !DILocation(line: 35, column: 23, scope: !200)
!202 = !DILocation(line: 35, column: 5, scope: !196)
!203 = !DILocation(line: 36, column: 24, scope: !200)
!204 = !DILocation(line: 36, column: 22, scope: !200)
!205 = !DILocation(line: 36, column: 9, scope: !200)
!206 = !DILocation(line: 35, column: 36, scope: !200)
!207 = !DILocation(line: 35, column: 5, scope: !200)
!208 = distinct !{!208, !202, !209, !120}
!209 = !DILocation(line: 36, column: 29, scope: !196)
!210 = !DILocation(line: 38, column: 5, scope: !211)
!211 = distinct !DILexicalBlock(scope: !212, file: !32, line: 38, column: 5)
!212 = distinct !DILexicalBlock(scope: !166, file: !32, line: 38, column: 5)
!213 = !DILocation(line: 38, column: 5, scope: !212)
!214 = !DILocation(line: 40, column: 5, scope: !166)
