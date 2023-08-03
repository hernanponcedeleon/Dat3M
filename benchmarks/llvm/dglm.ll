; ModuleID = 'output/dglm.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lfds/dglm.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Node = type { i32, %struct.Node* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@Head = dso_local global %struct.Node* null, align 8, !dbg !0
@Tail = dso_local global %struct.Node* null, align 8, !dbg !13
@.str = private unnamed_addr constant [13 x i8] c"tail != NULL\00", align 1
@.str.1 = private unnamed_addr constant [45 x i8] c"/home/ponce/git/Dat3M/benchmarks/lfds/dglm.h\00", align 1
@__PRETTY_FUNCTION__.enqueue = private unnamed_addr constant [18 x i8] c"void enqueue(int)\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"head != NULL\00", align 1
@__PRETTY_FUNCTION__.dequeue = private unnamed_addr constant [14 x i8] c"int dequeue()\00", align 1
@.str.3 = private unnamed_addr constant [11 x i8] c"r != EMPTY\00", align 1
@.str.4 = private unnamed_addr constant [45 x i8] c"/home/ponce/git/Dat3M/benchmarks/lfds/dglm.c\00", align 1
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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([45 x i8], [45 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.enqueue, i64 0, i64 0)) #6, !dbg !61
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
  %20 = icmp eq %struct.Node* %15, null, !dbg !72
  br i1 %20, label %21, label %32, !dbg !75

21:                                               ; preds = %19
  %22 = ptrtoint %struct.Node* %3 to i64, !dbg !76
  %23 = cmpxchg i64* %13, i64 %14, i64 %22 acq_rel monotonic, align 8, !dbg !76
  %24 = extractvalue { i64, i1 } %23, 0, !dbg !76
  %25 = extractvalue { i64, i1 } %23, 1, !dbg !76
  %26 = zext i1 %25 to i8, !dbg !76
  br i1 %25, label %27, label %37, !dbg !79

27:                                               ; preds = %21
  %28 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %7, i64 %22 acq_rel monotonic, align 8, !dbg !80
  %29 = extractvalue { i64, i1 } %28, 0, !dbg !80
  %30 = extractvalue { i64, i1 } %28, 1, !dbg !80
  %31 = zext i1 %30 to i8, !dbg !80
  ret void, !dbg !82

32:                                               ; preds = %19
  %33 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %7, i64 %14 acq_rel monotonic, align 8, !dbg !83
  %34 = extractvalue { i64, i1 } %33, 0, !dbg !83
  %35 = extractvalue { i64, i1 } %33, 1, !dbg !83
  %36 = zext i1 %35 to i8, !dbg !83
  br label %37

37:                                               ; preds = %32, %21, %11
  br label %6, !dbg !57, !llvm.loop !85
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @dequeue() #0 !dbg !87 {
  br label %1, !dbg !90

1:                                                ; preds = %36, %0
  %2 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8, !dbg !91
  %3 = inttoptr i64 %2 to %struct.Node*, !dbg !91
  call void @llvm.dbg.value(metadata %struct.Node* %3, metadata !93, metadata !DIExpression()), !dbg !94
  %4 = icmp ne %struct.Node* %3, null, !dbg !95
  br i1 %4, label %6, label %5, !dbg !98

5:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([45 x i8], [45 x i8]* @.str.1, i64 0, i64 0), i32 noundef 61, i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @__PRETTY_FUNCTION__.dequeue, i64 0, i64 0)) #6, !dbg !95
  unreachable, !dbg !95

6:                                                ; preds = %1
  %7 = getelementptr inbounds %struct.Node, %struct.Node* %3, i32 0, i32 1, !dbg !99
  %8 = bitcast %struct.Node** %7 to i64*, !dbg !100
  %9 = load atomic i64, i64* %8 acquire, align 8, !dbg !100
  %10 = inttoptr i64 %9 to %struct.Node*, !dbg !100
  call void @llvm.dbg.value(metadata %struct.Node* %10, metadata !101, metadata !DIExpression()), !dbg !94
  %11 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8, !dbg !102
  %12 = inttoptr i64 %11 to %struct.Node*, !dbg !102
  %13 = icmp eq %struct.Node* %3, %12, !dbg !104
  br i1 %13, label %14, label %36, !dbg !105

14:                                               ; preds = %6
  %15 = icmp eq %struct.Node* %10, null, !dbg !106
  br i1 %15, label %37, label %16, !dbg !109

16:                                               ; preds = %14
  %17 = getelementptr inbounds %struct.Node, %struct.Node* %10, i32 0, i32 0, !dbg !110
  %18 = load i32, i32* %17, align 8, !dbg !110
  call void @llvm.dbg.value(metadata i32 %18, metadata !112, metadata !DIExpression()), !dbg !94
  %19 = cmpxchg i64* bitcast (%struct.Node** @Head to i64*), i64 %2, i64 %9 acq_rel monotonic, align 8, !dbg !113
  %20 = extractvalue { i64, i1 } %19, 0, !dbg !113
  %21 = extractvalue { i64, i1 } %19, 1, !dbg !113
  %22 = inttoptr i64 %20 to %struct.Node*, !dbg !113
  %.013 = select i1 %21, %struct.Node* %3, %struct.Node* %22, !dbg !113
  call void @llvm.dbg.value(metadata %struct.Node* %.013, metadata !93, metadata !DIExpression()), !dbg !94
  %23 = zext i1 %21 to i8, !dbg !113
  br i1 %21, label %24, label %36, !dbg !115

24:                                               ; preds = %16
  %25 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8, !dbg !116
  %26 = inttoptr i64 %25 to %struct.Node*, !dbg !116
  call void @llvm.dbg.value(metadata %struct.Node* %26, metadata !118, metadata !DIExpression()), !dbg !94
  %27 = icmp ne %struct.Node* %26, null, !dbg !119
  br i1 %27, label %29, label %28, !dbg !122

28:                                               ; preds = %24
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([45 x i8], [45 x i8]* @.str.1, i64 0, i64 0), i32 noundef 73, i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @__PRETTY_FUNCTION__.dequeue, i64 0, i64 0)) #6, !dbg !119
  unreachable, !dbg !119

29:                                               ; preds = %24
  %30 = icmp eq %struct.Node* %.013, %26, !dbg !123
  br i1 %30, label %31, label %37, !dbg !125

31:                                               ; preds = %29
  %32 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %25, i64 %9 acq_rel monotonic, align 8, !dbg !126
  %33 = extractvalue { i64, i1 } %32, 0, !dbg !126
  %34 = extractvalue { i64, i1 } %32, 1, !dbg !126
  %35 = zext i1 %34 to i8, !dbg !126
  br label %37, !dbg !128

36:                                               ; preds = %16, %6
  br label %1, !dbg !90, !llvm.loop !129

37:                                               ; preds = %29, %31, %14
  %.0 = phi i32 [ -1, %14 ], [ %18, %31 ], [ %18, %29 ], !dbg !131
  call void @llvm.dbg.value(metadata i32 %.0, metadata !112, metadata !DIExpression()), !dbg !94
  ret i32 %.0, !dbg !132
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @worker(i8* noundef %0) #0 !dbg !133 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !137, metadata !DIExpression()), !dbg !138
  %2 = ptrtoint i8* %0 to i64, !dbg !139
  call void @llvm.dbg.value(metadata i64 %2, metadata !140, metadata !DIExpression()), !dbg !138
  %3 = trunc i64 %2 to i32, !dbg !141
  call void @enqueue(i32 noundef %3), !dbg !142
  %4 = call i32 @dequeue(), !dbg !143
  call void @llvm.dbg.value(metadata i32 %4, metadata !144, metadata !DIExpression()), !dbg !138
  %5 = icmp ne i32 %4, -1, !dbg !145
  br i1 %5, label %7, label %6, !dbg !148

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([45 x i8], [45 x i8]* @.str.4, i64 0, i64 0), i32 noundef 17, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.worker, i64 0, i64 0)) #6, !dbg !145
  unreachable, !dbg !145

7:                                                ; preds = %1
  ret i8* null, !dbg !149
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !150 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !151, metadata !DIExpression()), !dbg !157
  call void @init(), !dbg !158
  call void @llvm.dbg.value(metadata i32 0, metadata !159, metadata !DIExpression()), !dbg !161
  call void @llvm.dbg.value(metadata i64 0, metadata !159, metadata !DIExpression()), !dbg !161
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !162
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef null) #5, !dbg !164
  call void @llvm.dbg.value(metadata i64 1, metadata !159, metadata !DIExpression()), !dbg !161
  call void @llvm.dbg.value(metadata i64 1, metadata !159, metadata !DIExpression()), !dbg !161
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !162
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef inttoptr (i64 1 to i8*)) #5, !dbg !164
  call void @llvm.dbg.value(metadata i64 2, metadata !159, metadata !DIExpression()), !dbg !161
  call void @llvm.dbg.value(metadata i64 2, metadata !159, metadata !DIExpression()), !dbg !161
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !162
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef inttoptr (i64 2 to i8*)) #5, !dbg !164
  call void @llvm.dbg.value(metadata i64 3, metadata !159, metadata !DIExpression()), !dbg !161
  call void @llvm.dbg.value(metadata i64 3, metadata !159, metadata !DIExpression()), !dbg !161
  call void @llvm.dbg.value(metadata i32 0, metadata !165, metadata !DIExpression()), !dbg !167
  call void @llvm.dbg.value(metadata i64 0, metadata !165, metadata !DIExpression()), !dbg !167
  %8 = load i64, i64* %2, align 8, !dbg !168
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !170
  call void @llvm.dbg.value(metadata i64 1, metadata !165, metadata !DIExpression()), !dbg !167
  call void @llvm.dbg.value(metadata i64 1, metadata !165, metadata !DIExpression()), !dbg !167
  %10 = load i64, i64* %4, align 8, !dbg !168
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !170
  call void @llvm.dbg.value(metadata i64 2, metadata !165, metadata !DIExpression()), !dbg !167
  call void @llvm.dbg.value(metadata i64 2, metadata !165, metadata !DIExpression()), !dbg !167
  %12 = load i64, i64* %6, align 8, !dbg !168
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !170
  call void @llvm.dbg.value(metadata i64 3, metadata !165, metadata !DIExpression()), !dbg !167
  call void @llvm.dbg.value(metadata i64 3, metadata !165, metadata !DIExpression()), !dbg !167
  %14 = call i32 @dequeue(), !dbg !171
  call void @llvm.dbg.value(metadata i32 %14, metadata !172, metadata !DIExpression()), !dbg !173
  %15 = icmp eq i32 %14, -1, !dbg !174
  br i1 %15, label %17, label %16, !dbg !177

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([45 x i8], [45 x i8]* @.str.4, i64 0, i64 0), i32 noundef 35, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !174
  unreachable, !dbg !174

17:                                               ; preds = %0
  ret i32 0, !dbg !178
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
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lfds/dglm.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "a693c0962bd04be2842ef6194eaef76a")
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
!15 = !DIFile(filename: "benchmarks/lfds/dglm.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "d2c8ac1ddb110333ba951dd99299d9b5")
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
!61 = !DILocation(line: 38, column: 9, scope: !62)
!62 = distinct !DILexicalBlock(scope: !63, file: !15, line: 38, column: 9)
!63 = distinct !DILexicalBlock(scope: !59, file: !15, line: 38, column: 9)
!64 = !DILocation(line: 38, column: 9, scope: !63)
!65 = !DILocation(line: 39, column: 38, scope: !59)
!66 = !DILocation(line: 39, column: 10, scope: !59)
!67 = !DILocalVariable(name: "next", scope: !46, file: !15, line: 30, type: !17)
!68 = !DILocation(line: 41, column: 21, scope: !69)
!69 = distinct !DILexicalBlock(scope: !59, file: !15, line: 41, column: 13)
!70 = !DILocation(line: 41, column: 18, scope: !69)
!71 = !DILocation(line: 41, column: 13, scope: !59)
!72 = !DILocation(line: 42, column: 22, scope: !73)
!73 = distinct !DILexicalBlock(scope: !74, file: !15, line: 42, column: 17)
!74 = distinct !DILexicalBlock(scope: !69, file: !15, line: 41, column: 68)
!75 = !DILocation(line: 42, column: 17, scope: !74)
!76 = !DILocation(line: 43, column: 9, scope: !77)
!77 = distinct !DILexicalBlock(scope: !78, file: !15, line: 43, column: 9)
!78 = distinct !DILexicalBlock(scope: !73, file: !15, line: 42, column: 31)
!79 = !DILocation(line: 43, column: 9, scope: !78)
!80 = !DILocation(line: 44, column: 9, scope: !81)
!81 = distinct !DILexicalBlock(scope: !77, file: !15, line: 43, column: 40)
!82 = !DILocation(line: 53, column: 1, scope: !46)
!83 = !DILocation(line: 48, column: 5, scope: !84)
!84 = distinct !DILexicalBlock(scope: !73, file: !15, line: 47, column: 20)
!85 = distinct !{!85, !57, !86}
!86 = !DILocation(line: 52, column: 2, scope: !46)
!87 = distinct !DISubprogram(name: "dequeue", scope: !15, file: !15, line: 55, type: !88, scopeLine: 55, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !37)
!88 = !DISubroutineType(types: !89)
!89 = !{!22}
!90 = !DILocation(line: 59, column: 2, scope: !87)
!91 = !DILocation(line: 60, column: 10, scope: !92)
!92 = distinct !DILexicalBlock(scope: !87, file: !15, line: 59, column: 12)
!93 = !DILocalVariable(name: "head", scope: !87, file: !15, line: 56, type: !17)
!94 = !DILocation(line: 0, scope: !87)
!95 = !DILocation(line: 61, column: 9, scope: !96)
!96 = distinct !DILexicalBlock(scope: !97, file: !15, line: 61, column: 9)
!97 = distinct !DILexicalBlock(scope: !92, file: !15, line: 61, column: 9)
!98 = !DILocation(line: 61, column: 9, scope: !97)
!99 = !DILocation(line: 62, column: 38, scope: !92)
!100 = !DILocation(line: 62, column: 10, scope: !92)
!101 = !DILocalVariable(name: "next", scope: !87, file: !15, line: 56, type: !17)
!102 = !DILocation(line: 64, column: 15, scope: !103)
!103 = distinct !DILexicalBlock(scope: !92, file: !15, line: 64, column: 7)
!104 = !DILocation(line: 64, column: 12, scope: !103)
!105 = !DILocation(line: 64, column: 7, scope: !92)
!106 = !DILocation(line: 65, column: 13, scope: !107)
!107 = distinct !DILexicalBlock(scope: !108, file: !15, line: 65, column: 8)
!108 = distinct !DILexicalBlock(scope: !103, file: !15, line: 64, column: 62)
!109 = !DILocation(line: 65, column: 8, scope: !108)
!110 = !DILocation(line: 70, column: 32, scope: !111)
!111 = distinct !DILexicalBlock(scope: !107, file: !15, line: 69, column: 11)
!112 = !DILocalVariable(name: "result", scope: !87, file: !15, line: 57, type: !22)
!113 = !DILocation(line: 71, column: 21, scope: !114)
!114 = distinct !DILexicalBlock(scope: !111, file: !15, line: 71, column: 21)
!115 = !DILocation(line: 71, column: 21, scope: !111)
!116 = !DILocation(line: 72, column: 28, scope: !117)
!117 = distinct !DILexicalBlock(scope: !114, file: !15, line: 71, column: 46)
!118 = !DILocalVariable(name: "tail", scope: !87, file: !15, line: 56, type: !17)
!119 = !DILocation(line: 73, column: 21, scope: !120)
!120 = distinct !DILexicalBlock(scope: !121, file: !15, line: 73, column: 21)
!121 = distinct !DILexicalBlock(scope: !117, file: !15, line: 73, column: 21)
!122 = !DILocation(line: 73, column: 21, scope: !121)
!123 = !DILocation(line: 74, column: 30, scope: !124)
!124 = distinct !DILexicalBlock(scope: !117, file: !15, line: 74, column: 25)
!125 = !DILocation(line: 74, column: 25, scope: !117)
!126 = !DILocation(line: 75, column: 25, scope: !127)
!127 = distinct !DILexicalBlock(scope: !124, file: !15, line: 74, column: 39)
!128 = !DILocation(line: 76, column: 21, scope: !127)
!129 = distinct !{!129, !90, !130}
!130 = !DILocation(line: 81, column: 2, scope: !87)
!131 = !DILocation(line: 0, scope: !107)
!132 = !DILocation(line: 83, column: 2, scope: !87)
!133 = distinct !DISubprogram(name: "worker", scope: !134, file: !134, line: 9, type: !135, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !37)
!134 = !DIFile(filename: "benchmarks/lfds/dglm.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "a693c0962bd04be2842ef6194eaef76a")
!135 = !DISubroutineType(types: !136)
!136 = !{!5, !5}
!137 = !DILocalVariable(name: "arg", arg: 1, scope: !133, file: !134, line: 9, type: !5)
!138 = !DILocation(line: 0, scope: !133)
!139 = !DILocation(line: 12, column: 23, scope: !133)
!140 = !DILocalVariable(name: "index", scope: !133, file: !134, line: 12, type: !6)
!141 = !DILocation(line: 14, column: 10, scope: !133)
!142 = !DILocation(line: 14, column: 2, scope: !133)
!143 = !DILocation(line: 15, column: 13, scope: !133)
!144 = !DILocalVariable(name: "r", scope: !133, file: !134, line: 15, type: !22)
!145 = !DILocation(line: 17, column: 2, scope: !146)
!146 = distinct !DILexicalBlock(scope: !147, file: !134, line: 17, column: 2)
!147 = distinct !DILexicalBlock(scope: !133, file: !134, line: 17, column: 2)
!148 = !DILocation(line: 17, column: 2, scope: !147)
!149 = !DILocation(line: 19, column: 2, scope: !133)
!150 = distinct !DISubprogram(name: "main", scope: !134, file: !134, line: 22, type: !88, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !37)
!151 = !DILocalVariable(name: "t", scope: !150, file: !134, line: 24, type: !152)
!152 = !DICompositeType(tag: DW_TAG_array_type, baseType: !153, size: 192, elements: !155)
!153 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !154, line: 27, baseType: !11)
!154 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!155 = !{!156}
!156 = !DISubrange(count: 3)
!157 = !DILocation(line: 24, column: 15, scope: !150)
!158 = !DILocation(line: 26, column: 5, scope: !150)
!159 = !DILocalVariable(name: "i", scope: !160, file: !134, line: 28, type: !22)
!160 = distinct !DILexicalBlock(scope: !150, file: !134, line: 28, column: 5)
!161 = !DILocation(line: 0, scope: !160)
!162 = !DILocation(line: 29, column: 25, scope: !163)
!163 = distinct !DILexicalBlock(scope: !160, file: !134, line: 28, column: 5)
!164 = !DILocation(line: 29, column: 9, scope: !163)
!165 = !DILocalVariable(name: "i", scope: !166, file: !134, line: 31, type: !22)
!166 = distinct !DILexicalBlock(scope: !150, file: !134, line: 31, column: 5)
!167 = !DILocation(line: 0, scope: !166)
!168 = !DILocation(line: 32, column: 22, scope: !169)
!169 = distinct !DILexicalBlock(scope: !166, file: !134, line: 31, column: 5)
!170 = !DILocation(line: 32, column: 9, scope: !169)
!171 = !DILocation(line: 34, column: 13, scope: !150)
!172 = !DILocalVariable(name: "r", scope: !150, file: !134, line: 34, type: !22)
!173 = !DILocation(line: 0, scope: !150)
!174 = !DILocation(line: 35, column: 5, scope: !175)
!175 = distinct !DILexicalBlock(scope: !176, file: !134, line: 35, column: 5)
!176 = distinct !DILexicalBlock(scope: !150, file: !134, line: 35, column: 5)
!177 = !DILocation(line: 35, column: 5, scope: !176)
!178 = !DILocation(line: 37, column: 5, scope: !150)
