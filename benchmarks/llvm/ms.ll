; ModuleID = 'output/ms.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lfds/ms.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Node = type { i32, %struct.Node* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@Head = dso_local global %struct.Node* null, align 8, !dbg !0
@Tail = dso_local global %struct.Node* null, align 8, !dbg !13
@.str = private unnamed_addr constant [13 x i8] c"tail != NULL\00", align 1
@.str.1 = private unnamed_addr constant [43 x i8] c"/home/ponce/git/Dat3M/benchmarks/lfds/ms.h\00", align 1
@__PRETTY_FUNCTION__.enqueue = private unnamed_addr constant [18 x i8] c"void enqueue(int)\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"head != NULL\00", align 1
@__PRETTY_FUNCTION__.dequeue = private unnamed_addr constant [14 x i8] c"int dequeue()\00", align 1
@.str.3 = private unnamed_addr constant [11 x i8] c"r != EMPTY\00", align 1
@.str.4 = private unnamed_addr constant [43 x i8] c"/home/ponce/git/Dat3M/benchmarks/lfds/ms.c\00", align 1
@__PRETTY_FUNCTION__.worker = private unnamed_addr constant [21 x i8] c"void *worker(void *)\00", align 1
@.str.5 = private unnamed_addr constant [11 x i8] c"r == EMPTY\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !34 {
  %1 = call noalias i8* @malloc(i64 noundef 16) #5, !dbg !38
  %2 = bitcast i8* %1 to %struct.Node*, !dbg !38
  call void @llvm.dbg.value(metadata %struct.Node* %2, metadata !39, metadata !DIExpression()), !dbg !40
  %3 = getelementptr inbounds %struct.Node, %struct.Node* %2, i32 0, i32 1, !dbg !41
  store %struct.Node* null, %struct.Node** %3, align 8, !dbg !42
  store %struct.Node* %2, %struct.Node** @Head, align 8, !dbg !43
  store %struct.Node* %2, %struct.Node** @Tail, align 8, !dbg !44
  ret void, !dbg !45
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @enqueue(i32 noundef %0) #0 !dbg !46 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !49, metadata !DIExpression()), !dbg !50
  %2 = call noalias i8* @malloc(i64 noundef 16) #5, !dbg !51
  %3 = bitcast i8* %2 to %struct.Node*, !dbg !51
  call void @llvm.dbg.value(metadata %struct.Node* %3, metadata !52, metadata !DIExpression()), !dbg !50
  %4 = getelementptr inbounds %struct.Node, %struct.Node* %3, i32 0, i32 0, !dbg !53
  store i32 %0, i32* %4, align 8, !dbg !54
  %5 = getelementptr inbounds %struct.Node, %struct.Node* %3, i32 0, i32 1, !dbg !55
  store %struct.Node* null, %struct.Node** %5, align 8, !dbg !56
  br label %6, !dbg !57

6:                                                ; preds = %37, %1
  %7 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8, !dbg !58
  %8 = inttoptr i64 %7 to %struct.Node*, !dbg !58
  call void @llvm.dbg.value(metadata %struct.Node* %8, metadata !60, metadata !DIExpression()), !dbg !50
  %9 = icmp ne %struct.Node* %8, null, !dbg !61
  br i1 %9, label %11, label %10, !dbg !64

10:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([43 x i8], [43 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.enqueue, i64 0, i64 0)) #6, !dbg !61
  unreachable, !dbg !61

11:                                               ; preds = %6
  %12 = getelementptr inbounds %struct.Node, %struct.Node* %8, i32 0, i32 1, !dbg !65
  %13 = bitcast %struct.Node** %12 to i64*, !dbg !66
  %14 = load atomic i64, i64* %13 acquire, align 8, !dbg !66
  %15 = inttoptr i64 %14 to %struct.Node*, !dbg !66
  call void @llvm.dbg.value(metadata %struct.Node* %15, metadata !67, metadata !DIExpression()), !dbg !50
  %16 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8, !dbg !68
  %17 = inttoptr i64 %16 to %struct.Node*, !dbg !68
  %18 = icmp eq %struct.Node* %8, %17, !dbg !70
  br i1 %18, label %19, label %37, !dbg !71

19:                                               ; preds = %11
  %20 = icmp ne %struct.Node* %15, null, !dbg !72
  br i1 %20, label %21, label %26, !dbg !75

21:                                               ; preds = %19
  %22 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %7, i64 %14 acq_rel monotonic, align 8, !dbg !76
  %23 = extractvalue { i64, i1 } %22, 0, !dbg !76
  %24 = extractvalue { i64, i1 } %22, 1, !dbg !76
  %25 = zext i1 %24 to i8, !dbg !76
  br label %37, !dbg !78

26:                                               ; preds = %19
  %27 = ptrtoint %struct.Node* %3 to i64, !dbg !79
  %28 = cmpxchg i64* %13, i64 %14, i64 %27 acq_rel monotonic, align 8, !dbg !79
  %29 = extractvalue { i64, i1 } %28, 0, !dbg !79
  %30 = extractvalue { i64, i1 } %28, 1, !dbg !79
  %31 = zext i1 %30 to i8, !dbg !79
  br i1 %30, label %32, label %37, !dbg !82

32:                                               ; preds = %26
  %33 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %7, i64 %27 acq_rel monotonic, align 8, !dbg !83
  %34 = extractvalue { i64, i1 } %33, 0, !dbg !83
  %35 = extractvalue { i64, i1 } %33, 1, !dbg !83
  %36 = zext i1 %35 to i8, !dbg !83
  ret void, !dbg !85

37:                                               ; preds = %21, %26, %11
  br label %6, !dbg !57, !llvm.loop !86
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @dequeue() #0 !dbg !88 {
  br label %1, !dbg !91

1:                                                ; preds = %35, %0
  %2 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8, !dbg !92
  %3 = inttoptr i64 %2 to %struct.Node*, !dbg !92
  call void @llvm.dbg.value(metadata %struct.Node* %3, metadata !94, metadata !DIExpression()), !dbg !95
  %4 = icmp ne %struct.Node* %3, null, !dbg !96
  br i1 %4, label %6, label %5, !dbg !99

5:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([43 x i8], [43 x i8]* @.str.1, i64 0, i64 0), i32 noundef 60, i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @__PRETTY_FUNCTION__.dequeue, i64 0, i64 0)) #6, !dbg !96
  unreachable, !dbg !96

6:                                                ; preds = %1
  %7 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8, !dbg !100
  %8 = inttoptr i64 %7 to %struct.Node*, !dbg !100
  call void @llvm.dbg.value(metadata %struct.Node* %8, metadata !101, metadata !DIExpression()), !dbg !95
  %9 = icmp ne %struct.Node* %8, null, !dbg !102
  br i1 %9, label %11, label %10, !dbg !105

10:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([43 x i8], [43 x i8]* @.str.1, i64 0, i64 0), i32 noundef 62, i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @__PRETTY_FUNCTION__.dequeue, i64 0, i64 0)) #6, !dbg !102
  unreachable, !dbg !102

11:                                               ; preds = %6
  %12 = getelementptr inbounds %struct.Node, %struct.Node* %3, i32 0, i32 1, !dbg !106
  %13 = bitcast %struct.Node** %12 to i64*, !dbg !107
  %14 = load atomic i64, i64* %13 acquire, align 8, !dbg !107
  %15 = inttoptr i64 %14 to %struct.Node*, !dbg !107
  call void @llvm.dbg.value(metadata %struct.Node* %15, metadata !108, metadata !DIExpression()), !dbg !95
  %16 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8, !dbg !109
  %17 = inttoptr i64 %16 to %struct.Node*, !dbg !109
  %18 = icmp eq %struct.Node* %3, %17, !dbg !111
  br i1 %18, label %19, label %35, !dbg !112

19:                                               ; preds = %11
  %20 = icmp eq %struct.Node* %15, null, !dbg !113
  br i1 %20, label %36, label %21, !dbg !116

21:                                               ; preds = %19
  %22 = icmp eq %struct.Node* %3, %8, !dbg !117
  br i1 %22, label %23, label %28, !dbg !120

23:                                               ; preds = %21
  %24 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %7, i64 %14 acq_rel monotonic, align 8, !dbg !121
  %25 = extractvalue { i64, i1 } %24, 0, !dbg !121
  %26 = extractvalue { i64, i1 } %24, 1, !dbg !121
  %27 = zext i1 %26 to i8, !dbg !121
  br label %35, !dbg !123

28:                                               ; preds = %21
  %29 = getelementptr inbounds %struct.Node, %struct.Node* %15, i32 0, i32 0, !dbg !124
  %30 = load i32, i32* %29, align 8, !dbg !124
  call void @llvm.dbg.value(metadata i32 %30, metadata !126, metadata !DIExpression()), !dbg !95
  %31 = cmpxchg i64* bitcast (%struct.Node** @Head to i64*), i64 %2, i64 %14 acq_rel monotonic, align 8, !dbg !127
  %32 = extractvalue { i64, i1 } %31, 0, !dbg !127
  %33 = extractvalue { i64, i1 } %31, 1, !dbg !127
  %34 = zext i1 %33 to i8, !dbg !127
  br i1 %33, label %36, label %35, !dbg !129

35:                                               ; preds = %28, %23, %11
  br label %1, !dbg !91, !llvm.loop !130

36:                                               ; preds = %28, %19
  %.0 = phi i32 [ -1, %19 ], [ %30, %28 ], !dbg !132
  call void @llvm.dbg.value(metadata i32 %.0, metadata !126, metadata !DIExpression()), !dbg !95
  ret i32 %.0, !dbg !133
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @worker(i8* noundef %0) #0 !dbg !134 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !138, metadata !DIExpression()), !dbg !139
  %2 = ptrtoint i8* %0 to i64, !dbg !140
  call void @llvm.dbg.value(metadata i64 %2, metadata !141, metadata !DIExpression()), !dbg !139
  %3 = trunc i64 %2 to i32, !dbg !142
  call void @enqueue(i32 noundef %3), !dbg !143
  %4 = call i32 @dequeue(), !dbg !144
  call void @llvm.dbg.value(metadata i32 %4, metadata !145, metadata !DIExpression()), !dbg !139
  %5 = icmp ne i32 %4, -1, !dbg !146
  br i1 %5, label %7, label %6, !dbg !149

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([43 x i8], [43 x i8]* @.str.4, i64 0, i64 0), i32 noundef 16, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.worker, i64 0, i64 0)) #6, !dbg !146
  unreachable, !dbg !146

7:                                                ; preds = %1
  ret i8* null, !dbg !150
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !151 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !152, metadata !DIExpression()), !dbg !158
  call void @init(), !dbg !159
  call void @llvm.dbg.value(metadata i32 0, metadata !160, metadata !DIExpression()), !dbg !162
  call void @llvm.dbg.value(metadata i64 0, metadata !160, metadata !DIExpression()), !dbg !162
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !163
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef null) #5, !dbg !165
  call void @llvm.dbg.value(metadata i64 1, metadata !160, metadata !DIExpression()), !dbg !162
  call void @llvm.dbg.value(metadata i64 1, metadata !160, metadata !DIExpression()), !dbg !162
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !163
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef inttoptr (i64 1 to i8*)) #5, !dbg !165
  call void @llvm.dbg.value(metadata i64 2, metadata !160, metadata !DIExpression()), !dbg !162
  call void @llvm.dbg.value(metadata i64 2, metadata !160, metadata !DIExpression()), !dbg !162
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !163
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef inttoptr (i64 2 to i8*)) #5, !dbg !165
  call void @llvm.dbg.value(metadata i64 3, metadata !160, metadata !DIExpression()), !dbg !162
  call void @llvm.dbg.value(metadata i64 3, metadata !160, metadata !DIExpression()), !dbg !162
  call void @llvm.dbg.value(metadata i32 0, metadata !166, metadata !DIExpression()), !dbg !168
  call void @llvm.dbg.value(metadata i64 0, metadata !166, metadata !DIExpression()), !dbg !168
  %8 = load i64, i64* %2, align 8, !dbg !169
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !171
  call void @llvm.dbg.value(metadata i64 1, metadata !166, metadata !DIExpression()), !dbg !168
  call void @llvm.dbg.value(metadata i64 1, metadata !166, metadata !DIExpression()), !dbg !168
  %10 = load i64, i64* %4, align 8, !dbg !169
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !171
  call void @llvm.dbg.value(metadata i64 2, metadata !166, metadata !DIExpression()), !dbg !168
  call void @llvm.dbg.value(metadata i64 2, metadata !166, metadata !DIExpression()), !dbg !168
  %12 = load i64, i64* %6, align 8, !dbg !169
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !171
  call void @llvm.dbg.value(metadata i64 3, metadata !166, metadata !DIExpression()), !dbg !168
  call void @llvm.dbg.value(metadata i64 3, metadata !166, metadata !DIExpression()), !dbg !168
  %14 = call i32 @dequeue(), !dbg !172
  call void @llvm.dbg.value(metadata i32 %14, metadata !173, metadata !DIExpression()), !dbg !174
  %15 = icmp eq i32 %14, -1, !dbg !175
  br i1 %15, label %17, label %16, !dbg !178

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([43 x i8], [43 x i8]* @.str.4, i64 0, i64 0), i32 noundef 34, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !175
  unreachable, !dbg !175

17:                                               ; preds = %0
  ret i32 0, !dbg !179
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
!llvm.module.flags = !{!26, !27, !28, !29, !30, !31, !32}
!llvm.ident = !{!33}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "Head", scope: !2, file: !15, line: 19, type: !16, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !12, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lfds/ms.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "7e6a31b1f215ca043da6dae63284f84e")
!4 = !{!5, !6, !9}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !7, line: 87, baseType: !8)
!7 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!8 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !10, line: 46, baseType: !11)
!10 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!11 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!12 = !{!13, !0}
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(name: "Tail", scope: !2, file: !15, line: 18, type: !16, isLocal: false, isDefinition: true)
!15 = !DIFile(filename: "benchmarks/lfds/ms.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "65dcb47a3cacb398e048973e28881a59")
!16 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !17)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "Node", file: !15, line: 16, baseType: !19)
!19 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Node", file: !15, line: 13, size: 128, elements: !20)
!20 = !{!21, !23}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "val", scope: !19, file: !15, line: 14, baseType: !22, size: 32)
!22 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !19, file: !15, line: 15, baseType: !24, size: 64, offset: 64)
!24 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !25)
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!26 = !{i32 7, !"Dwarf Version", i32 5}
!27 = !{i32 2, !"Debug Info Version", i32 3}
!28 = !{i32 1, !"wchar_size", i32 4}
!29 = !{i32 7, !"PIC Level", i32 2}
!30 = !{i32 7, !"PIE Level", i32 2}
!31 = !{i32 7, !"uwtable", i32 1}
!32 = !{i32 7, !"frame-pointer", i32 2}
!33 = !{!"Ubuntu clang version 14.0.6"}
!34 = distinct !DISubprogram(name: "init", scope: !15, file: !15, line: 22, type: !35, scopeLine: 22, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !37)
!35 = !DISubroutineType(types: !36)
!36 = !{null}
!37 = !{}
!38 = !DILocation(line: 23, column: 15, scope: !34)
!39 = !DILocalVariable(name: "node", scope: !34, file: !15, line: 23, type: !17)
!40 = !DILocation(line: 0, scope: !34)
!41 = !DILocation(line: 24, column: 21, scope: !34)
!42 = !DILocation(line: 24, column: 2, scope: !34)
!43 = !DILocation(line: 25, column: 2, scope: !34)
!44 = !DILocation(line: 26, column: 2, scope: !34)
!45 = !DILocation(line: 27, column: 1, scope: !34)
!46 = distinct !DISubprogram(name: "enqueue", scope: !15, file: !15, line: 29, type: !47, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !37)
!47 = !DISubroutineType(types: !48)
!48 = !{null, !22}
!49 = !DILocalVariable(name: "value", arg: 1, scope: !46, file: !15, line: 29, type: !22)
!50 = !DILocation(line: 0, scope: !46)
!51 = !DILocation(line: 32, column: 12, scope: !46)
!52 = !DILocalVariable(name: "node", scope: !46, file: !15, line: 30, type: !17)
!53 = !DILocation(line: 33, column: 8, scope: !46)
!54 = !DILocation(line: 33, column: 12, scope: !46)
!55 = !DILocation(line: 34, column: 21, scope: !46)
!56 = !DILocation(line: 34, column: 2, scope: !46)
!57 = !DILocation(line: 36, column: 2, scope: !46)
!58 = !DILocation(line: 37, column: 10, scope: !59)
!59 = distinct !DILexicalBlock(scope: !46, file: !15, line: 36, column: 12)
!60 = !DILocalVariable(name: "tail", scope: !46, file: !15, line: 30, type: !17)
!61 = !DILocation(line: 38, column: 3, scope: !62)
!62 = distinct !DILexicalBlock(scope: !63, file: !15, line: 38, column: 3)
!63 = distinct !DILexicalBlock(scope: !59, file: !15, line: 38, column: 3)
!64 = !DILocation(line: 38, column: 3, scope: !63)
!65 = !DILocation(line: 39, column: 38, scope: !59)
!66 = !DILocation(line: 39, column: 10, scope: !59)
!67 = !DILocalVariable(name: "next", scope: !46, file: !15, line: 30, type: !17)
!68 = !DILocation(line: 41, column: 15, scope: !69)
!69 = distinct !DILexicalBlock(scope: !59, file: !15, line: 41, column: 7)
!70 = !DILocation(line: 41, column: 12, scope: !69)
!71 = !DILocation(line: 41, column: 7, scope: !59)
!72 = !DILocation(line: 42, column: 13, scope: !73)
!73 = distinct !DILexicalBlock(scope: !74, file: !15, line: 42, column: 8)
!74 = distinct !DILexicalBlock(scope: !69, file: !15, line: 41, column: 62)
!75 = !DILocation(line: 42, column: 8, scope: !74)
!76 = !DILocation(line: 43, column: 5, scope: !77)
!77 = distinct !DILexicalBlock(scope: !73, file: !15, line: 42, column: 22)
!78 = !DILocation(line: 44, column: 4, scope: !77)
!79 = !DILocation(line: 45, column: 9, scope: !80)
!80 = distinct !DILexicalBlock(scope: !81, file: !15, line: 45, column: 9)
!81 = distinct !DILexicalBlock(scope: !73, file: !15, line: 44, column: 11)
!82 = !DILocation(line: 45, column: 9, scope: !81)
!83 = !DILocation(line: 46, column: 9, scope: !84)
!84 = distinct !DILexicalBlock(scope: !80, file: !15, line: 45, column: 40)
!85 = !DILocation(line: 52, column: 1, scope: !46)
!86 = distinct !{!86, !57, !87}
!87 = !DILocation(line: 51, column: 2, scope: !46)
!88 = distinct !DISubprogram(name: "dequeue", scope: !15, file: !15, line: 54, type: !89, scopeLine: 54, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !37)
!89 = !DISubroutineType(types: !90)
!90 = !{!22}
!91 = !DILocation(line: 58, column: 2, scope: !88)
!92 = !DILocation(line: 59, column: 10, scope: !93)
!93 = distinct !DILexicalBlock(scope: !88, file: !15, line: 58, column: 12)
!94 = !DILocalVariable(name: "head", scope: !88, file: !15, line: 55, type: !17)
!95 = !DILocation(line: 0, scope: !88)
!96 = !DILocation(line: 60, column: 3, scope: !97)
!97 = distinct !DILexicalBlock(scope: !98, file: !15, line: 60, column: 3)
!98 = distinct !DILexicalBlock(scope: !93, file: !15, line: 60, column: 3)
!99 = !DILocation(line: 60, column: 3, scope: !98)
!100 = !DILocation(line: 61, column: 10, scope: !93)
!101 = !DILocalVariable(name: "tail", scope: !88, file: !15, line: 55, type: !17)
!102 = !DILocation(line: 62, column: 3, scope: !103)
!103 = distinct !DILexicalBlock(scope: !104, file: !15, line: 62, column: 3)
!104 = distinct !DILexicalBlock(scope: !93, file: !15, line: 62, column: 3)
!105 = !DILocation(line: 62, column: 3, scope: !104)
!106 = !DILocation(line: 63, column: 38, scope: !93)
!107 = !DILocation(line: 63, column: 10, scope: !93)
!108 = !DILocalVariable(name: "next", scope: !88, file: !15, line: 55, type: !17)
!109 = !DILocation(line: 65, column: 15, scope: !110)
!110 = distinct !DILexicalBlock(scope: !93, file: !15, line: 65, column: 7)
!111 = !DILocation(line: 65, column: 12, scope: !110)
!112 = !DILocation(line: 65, column: 7, scope: !93)
!113 = !DILocation(line: 66, column: 13, scope: !114)
!114 = distinct !DILexicalBlock(scope: !115, file: !15, line: 66, column: 8)
!115 = distinct !DILexicalBlock(scope: !110, file: !15, line: 65, column: 62)
!116 = !DILocation(line: 66, column: 8, scope: !115)
!117 = !DILocation(line: 70, column: 14, scope: !118)
!118 = distinct !DILexicalBlock(scope: !119, file: !15, line: 70, column: 9)
!119 = distinct !DILexicalBlock(scope: !114, file: !15, line: 69, column: 11)
!120 = !DILocation(line: 70, column: 9, scope: !119)
!121 = !DILocation(line: 71, column: 6, scope: !122)
!122 = distinct !DILexicalBlock(scope: !118, file: !15, line: 70, column: 23)
!123 = !DILocation(line: 72, column: 5, scope: !122)
!124 = !DILocation(line: 73, column: 21, scope: !125)
!125 = distinct !DILexicalBlock(scope: !118, file: !15, line: 72, column: 12)
!126 = !DILocalVariable(name: "result", scope: !88, file: !15, line: 56, type: !22)
!127 = !DILocation(line: 74, column: 10, scope: !128)
!128 = distinct !DILexicalBlock(scope: !125, file: !15, line: 74, column: 10)
!129 = !DILocation(line: 74, column: 10, scope: !125)
!130 = distinct !{!130, !91, !131}
!131 = !DILocation(line: 81, column: 2, scope: !88)
!132 = !DILocation(line: 0, scope: !114)
!133 = !DILocation(line: 83, column: 2, scope: !88)
!134 = distinct !DISubprogram(name: "worker", scope: !135, file: !135, line: 8, type: !136, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !37)
!135 = !DIFile(filename: "benchmarks/lfds/ms.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "7e6a31b1f215ca043da6dae63284f84e")
!136 = !DISubroutineType(types: !137)
!137 = !{!5, !5}
!138 = !DILocalVariable(name: "arg", arg: 1, scope: !134, file: !135, line: 8, type: !5)
!139 = !DILocation(line: 0, scope: !134)
!140 = !DILocation(line: 11, column: 23, scope: !134)
!141 = !DILocalVariable(name: "index", scope: !134, file: !135, line: 11, type: !6)
!142 = !DILocation(line: 13, column: 10, scope: !134)
!143 = !DILocation(line: 13, column: 2, scope: !134)
!144 = !DILocation(line: 14, column: 13, scope: !134)
!145 = !DILocalVariable(name: "r", scope: !134, file: !135, line: 14, type: !22)
!146 = !DILocation(line: 16, column: 2, scope: !147)
!147 = distinct !DILexicalBlock(scope: !148, file: !135, line: 16, column: 2)
!148 = distinct !DILexicalBlock(scope: !134, file: !135, line: 16, column: 2)
!149 = !DILocation(line: 16, column: 2, scope: !148)
!150 = !DILocation(line: 18, column: 2, scope: !134)
!151 = distinct !DISubprogram(name: "main", scope: !135, file: !135, line: 21, type: !89, scopeLine: 22, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !37)
!152 = !DILocalVariable(name: "t", scope: !151, file: !135, line: 23, type: !153)
!153 = !DICompositeType(tag: DW_TAG_array_type, baseType: !154, size: 192, elements: !156)
!154 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !155, line: 27, baseType: !11)
!155 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!156 = !{!157}
!157 = !DISubrange(count: 3)
!158 = !DILocation(line: 23, column: 15, scope: !151)
!159 = !DILocation(line: 25, column: 5, scope: !151)
!160 = !DILocalVariable(name: "i", scope: !161, file: !135, line: 27, type: !22)
!161 = distinct !DILexicalBlock(scope: !151, file: !135, line: 27, column: 5)
!162 = !DILocation(line: 0, scope: !161)
!163 = !DILocation(line: 28, column: 25, scope: !164)
!164 = distinct !DILexicalBlock(scope: !161, file: !135, line: 27, column: 5)
!165 = !DILocation(line: 28, column: 9, scope: !164)
!166 = !DILocalVariable(name: "i", scope: !167, file: !135, line: 30, type: !22)
!167 = distinct !DILexicalBlock(scope: !151, file: !135, line: 30, column: 5)
!168 = !DILocation(line: 0, scope: !167)
!169 = !DILocation(line: 31, column: 22, scope: !170)
!170 = distinct !DILexicalBlock(scope: !167, file: !135, line: 30, column: 5)
!171 = !DILocation(line: 31, column: 9, scope: !170)
!172 = !DILocation(line: 33, column: 13, scope: !151)
!173 = !DILocalVariable(name: "r", scope: !151, file: !135, line: 33, type: !22)
!174 = !DILocation(line: 0, scope: !151)
!175 = !DILocation(line: 34, column: 5, scope: !176)
!176 = distinct !DILexicalBlock(scope: !177, file: !135, line: 34, column: 5)
!177 = distinct !DILexicalBlock(scope: !151, file: !135, line: 34, column: 5)
!178 = !DILocation(line: 34, column: 5, scope: !177)
!179 = !DILocation(line: 36, column: 5, scope: !151)
