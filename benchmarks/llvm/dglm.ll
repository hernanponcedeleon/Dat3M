; ModuleID = 'output/dglm.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lfds/dglm.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Node = type { i32, %struct.Node* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@Head = dso_local global %struct.Node* null, align 8, !dbg !0
@Tail = dso_local global %struct.Node* null, align 8, !dbg !10
@.str = private unnamed_addr constant [11 x i8] c"r != EMPTY\00", align 1
@.str.1 = private unnamed_addr constant [45 x i8] c"/home/ponce/git/Dat3M/benchmarks/lfds/dglm.c\00", align 1
@__PRETTY_FUNCTION__.worker = private unnamed_addr constant [21 x i8] c"void *worker(void *)\00", align 1
@.str.2 = private unnamed_addr constant [11 x i8] c"r == EMPTY\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !31 {
  %1 = call i8* @malloc(i64 noundef 16), !dbg !35
  %2 = bitcast i8* %1 to %struct.Node*, !dbg !35
  call void @llvm.dbg.value(metadata %struct.Node* %2, metadata !36, metadata !DIExpression()), !dbg !37
  %3 = getelementptr inbounds %struct.Node, %struct.Node* %2, i32 0, i32 1, !dbg !38
  store %struct.Node* null, %struct.Node** %3, align 8, !dbg !39
  store %struct.Node* %2, %struct.Node** @Head, align 8, !dbg !40
  store %struct.Node* %2, %struct.Node** @Tail, align 8, !dbg !41
  ret void, !dbg !42
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i8* @malloc(i64 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @enqueue(i32 noundef %0) #0 !dbg !43 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !46, metadata !DIExpression()), !dbg !47
  %2 = call i8* @malloc(i64 noundef 16), !dbg !48
  %3 = bitcast i8* %2 to %struct.Node*, !dbg !48
  call void @llvm.dbg.value(metadata %struct.Node* %3, metadata !49, metadata !DIExpression()), !dbg !47
  %4 = getelementptr inbounds %struct.Node, %struct.Node* %3, i32 0, i32 0, !dbg !50
  store i32 %0, i32* %4, align 8, !dbg !51
  %5 = getelementptr inbounds %struct.Node, %struct.Node* %3, i32 0, i32 1, !dbg !52
  store %struct.Node* null, %struct.Node** %5, align 8, !dbg !53
  br label %6, !dbg !54

6:                                                ; preds = %37, %1
  %7 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8, !dbg !55
  %8 = inttoptr i64 %7 to %struct.Node*, !dbg !55
  call void @llvm.dbg.value(metadata %struct.Node* %8, metadata !57, metadata !DIExpression()), !dbg !47
  %9 = icmp ne %struct.Node* %8, null, !dbg !58
  %10 = zext i1 %9 to i32, !dbg !58
  %11 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 noundef %10), !dbg !59
  %12 = getelementptr inbounds %struct.Node, %struct.Node* %8, i32 0, i32 1, !dbg !60
  %13 = bitcast %struct.Node** %12 to i64*, !dbg !61
  %14 = load atomic i64, i64* %13 acquire, align 8, !dbg !61
  %15 = inttoptr i64 %14 to %struct.Node*, !dbg !61
  call void @llvm.dbg.value(metadata %struct.Node* %15, metadata !62, metadata !DIExpression()), !dbg !47
  %16 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8, !dbg !63
  %17 = inttoptr i64 %16 to %struct.Node*, !dbg !63
  %18 = icmp eq %struct.Node* %8, %17, !dbg !65
  br i1 %18, label %19, label %37, !dbg !66

19:                                               ; preds = %6
  %20 = icmp eq %struct.Node* %15, null, !dbg !67
  br i1 %20, label %21, label %32, !dbg !70

21:                                               ; preds = %19
  %22 = ptrtoint %struct.Node* %3 to i64, !dbg !71
  %23 = cmpxchg i64* %13, i64 %14, i64 %22 acq_rel monotonic, align 8, !dbg !71
  %24 = extractvalue { i64, i1 } %23, 0, !dbg !71
  %25 = extractvalue { i64, i1 } %23, 1, !dbg !71
  %26 = zext i1 %25 to i8, !dbg !71
  br i1 %25, label %27, label %37, !dbg !74

27:                                               ; preds = %21
  %28 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %7, i64 %22 acq_rel monotonic, align 8, !dbg !75
  %29 = extractvalue { i64, i1 } %28, 0, !dbg !75
  %30 = extractvalue { i64, i1 } %28, 1, !dbg !75
  %31 = zext i1 %30 to i8, !dbg !75
  ret void, !dbg !77

32:                                               ; preds = %19
  %33 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %7, i64 %14 acq_rel monotonic, align 8, !dbg !78
  %34 = extractvalue { i64, i1 } %33, 0, !dbg !78
  %35 = extractvalue { i64, i1 } %33, 1, !dbg !78
  %36 = zext i1 %35 to i8, !dbg !78
  br label %37

37:                                               ; preds = %32, %21, %6
  br label %6, !dbg !54, !llvm.loop !80
}

declare i32 @assert(...) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @dequeue() #0 !dbg !82 {
  br label %1, !dbg !85

1:                                                ; preds = %36, %0
  %2 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8, !dbg !86
  %3 = inttoptr i64 %2 to %struct.Node*, !dbg !86
  call void @llvm.dbg.value(metadata %struct.Node* %3, metadata !88, metadata !DIExpression()), !dbg !89
  %4 = icmp ne %struct.Node* %3, null, !dbg !90
  %5 = zext i1 %4 to i32, !dbg !90
  %6 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 noundef %5), !dbg !91
  %7 = getelementptr inbounds %struct.Node, %struct.Node* %3, i32 0, i32 1, !dbg !92
  %8 = bitcast %struct.Node** %7 to i64*, !dbg !93
  %9 = load atomic i64, i64* %8 acquire, align 8, !dbg !93
  %10 = inttoptr i64 %9 to %struct.Node*, !dbg !93
  call void @llvm.dbg.value(metadata %struct.Node* %10, metadata !94, metadata !DIExpression()), !dbg !89
  %11 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8, !dbg !95
  %12 = inttoptr i64 %11 to %struct.Node*, !dbg !95
  %13 = icmp eq %struct.Node* %3, %12, !dbg !97
  br i1 %13, label %14, label %36, !dbg !98

14:                                               ; preds = %1
  %15 = icmp eq %struct.Node* %10, null, !dbg !99
  br i1 %15, label %37, label %16, !dbg !102

16:                                               ; preds = %14
  %17 = getelementptr inbounds %struct.Node, %struct.Node* %10, i32 0, i32 0, !dbg !103
  %18 = load i32, i32* %17, align 8, !dbg !103
  call void @llvm.dbg.value(metadata i32 %18, metadata !105, metadata !DIExpression()), !dbg !89
  %19 = cmpxchg i64* bitcast (%struct.Node** @Head to i64*), i64 %2, i64 %9 acq_rel monotonic, align 8, !dbg !106
  %20 = extractvalue { i64, i1 } %19, 0, !dbg !106
  %21 = extractvalue { i64, i1 } %19, 1, !dbg !106
  %22 = inttoptr i64 %20 to %struct.Node*, !dbg !106
  %.013 = select i1 %21, %struct.Node* %3, %struct.Node* %22, !dbg !106
  call void @llvm.dbg.value(metadata %struct.Node* %.013, metadata !88, metadata !DIExpression()), !dbg !89
  %23 = zext i1 %21 to i8, !dbg !106
  br i1 %21, label %24, label %36, !dbg !108

24:                                               ; preds = %16
  %25 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8, !dbg !109
  %26 = inttoptr i64 %25 to %struct.Node*, !dbg !109
  call void @llvm.dbg.value(metadata %struct.Node* %26, metadata !111, metadata !DIExpression()), !dbg !89
  %27 = icmp ne %struct.Node* %26, null, !dbg !112
  %28 = zext i1 %27 to i32, !dbg !112
  %29 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 noundef %28), !dbg !113
  %30 = icmp eq %struct.Node* %.013, %26, !dbg !114
  br i1 %30, label %31, label %37, !dbg !116

31:                                               ; preds = %24
  %32 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %25, i64 %9 acq_rel monotonic, align 8, !dbg !117
  %33 = extractvalue { i64, i1 } %32, 0, !dbg !117
  %34 = extractvalue { i64, i1 } %32, 1, !dbg !117
  %35 = zext i1 %34 to i8, !dbg !117
  br label %37, !dbg !119

36:                                               ; preds = %16, %1
  br label %1, !dbg !85, !llvm.loop !120

37:                                               ; preds = %24, %31, %14
  %.0 = phi i32 [ -1, %14 ], [ %18, %31 ], [ %18, %24 ], !dbg !122
  call void @llvm.dbg.value(metadata i32 %.0, metadata !105, metadata !DIExpression()), !dbg !89
  ret i32 %.0, !dbg !123
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @worker(i8* noundef %0) #0 !dbg !124 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !128, metadata !DIExpression()), !dbg !129
  %2 = ptrtoint i8* %0 to i64, !dbg !130
  call void @llvm.dbg.value(metadata i64 %2, metadata !131, metadata !DIExpression()), !dbg !129
  %3 = trunc i64 %2 to i32, !dbg !132
  call void @enqueue(i32 noundef %3), !dbg !133
  %4 = call i32 @dequeue(), !dbg !134
  call void @llvm.dbg.value(metadata i32 %4, metadata !135, metadata !DIExpression()), !dbg !129
  %5 = icmp ne i32 %4, -1, !dbg !136
  br i1 %5, label %7, label %6, !dbg !139

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([45 x i8], [45 x i8]* @.str.1, i64 0, i64 0), i32 noundef 17, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.worker, i64 0, i64 0)) #5, !dbg !136
  unreachable, !dbg !136

7:                                                ; preds = %1
  ret i8* null, !dbg !140
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !141 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !142, metadata !DIExpression()), !dbg !149
  call void @init(), !dbg !150
  call void @llvm.dbg.value(metadata i32 0, metadata !151, metadata !DIExpression()), !dbg !153
  call void @llvm.dbg.value(metadata i64 0, metadata !151, metadata !DIExpression()), !dbg !153
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !154
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef null) #6, !dbg !156
  call void @llvm.dbg.value(metadata i64 1, metadata !151, metadata !DIExpression()), !dbg !153
  call void @llvm.dbg.value(metadata i64 1, metadata !151, metadata !DIExpression()), !dbg !153
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !154
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !156
  call void @llvm.dbg.value(metadata i64 2, metadata !151, metadata !DIExpression()), !dbg !153
  call void @llvm.dbg.value(metadata i64 2, metadata !151, metadata !DIExpression()), !dbg !153
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !154
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !156
  call void @llvm.dbg.value(metadata i64 3, metadata !151, metadata !DIExpression()), !dbg !153
  call void @llvm.dbg.value(metadata i64 3, metadata !151, metadata !DIExpression()), !dbg !153
  call void @llvm.dbg.value(metadata i32 0, metadata !157, metadata !DIExpression()), !dbg !159
  call void @llvm.dbg.value(metadata i64 0, metadata !157, metadata !DIExpression()), !dbg !159
  %8 = load i64, i64* %2, align 8, !dbg !160
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !162
  call void @llvm.dbg.value(metadata i64 1, metadata !157, metadata !DIExpression()), !dbg !159
  call void @llvm.dbg.value(metadata i64 1, metadata !157, metadata !DIExpression()), !dbg !159
  %10 = load i64, i64* %4, align 8, !dbg !160
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !162
  call void @llvm.dbg.value(metadata i64 2, metadata !157, metadata !DIExpression()), !dbg !159
  call void @llvm.dbg.value(metadata i64 2, metadata !157, metadata !DIExpression()), !dbg !159
  %12 = load i64, i64* %6, align 8, !dbg !160
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !162
  call void @llvm.dbg.value(metadata i64 3, metadata !157, metadata !DIExpression()), !dbg !159
  call void @llvm.dbg.value(metadata i64 3, metadata !157, metadata !DIExpression()), !dbg !159
  %14 = call i32 @dequeue(), !dbg !163
  call void @llvm.dbg.value(metadata i32 %14, metadata !164, metadata !DIExpression()), !dbg !165
  %15 = icmp eq i32 %14, -1, !dbg !166
  br i1 %15, label %17, label %16, !dbg !169

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([45 x i8], [45 x i8]* @.str.1, i64 0, i64 0), i32 noundef 35, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !166
  unreachable, !dbg !166

17:                                               ; preds = %0
  ret i32 0, !dbg !170
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #4

declare i32 @pthread_join(i64 noundef, i8** noundef) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!23, !24, !25, !26, !27, !28, !29}
!llvm.ident = !{!30}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "Head", scope: !2, file: !12, line: 17, type: !13, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !9, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lfds/dglm.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "6b485fb7cdb48c80a032b3c95cfcf353")
!4 = !{!5, !6}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !7, line: 87, baseType: !8)
!7 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!8 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!9 = !{!10, !0}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "Tail", scope: !2, file: !12, line: 16, type: !13, isLocal: false, isDefinition: true)
!12 = !DIFile(filename: "benchmarks/lfds/dglm.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "8f7f9677d8d1f9a479f463c79cfeab2e")
!13 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !14)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "Node", file: !12, line: 14, baseType: !16)
!16 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Node", file: !12, line: 11, size: 128, elements: !17)
!17 = !{!18, !20}
!18 = !DIDerivedType(tag: DW_TAG_member, name: "val", scope: !16, file: !12, line: 12, baseType: !19, size: 32)
!19 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !16, file: !12, line: 13, baseType: !21, size: 64, offset: 64)
!21 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!23 = !{i32 7, !"Dwarf Version", i32 5}
!24 = !{i32 2, !"Debug Info Version", i32 3}
!25 = !{i32 1, !"wchar_size", i32 4}
!26 = !{i32 7, !"PIC Level", i32 2}
!27 = !{i32 7, !"PIE Level", i32 2}
!28 = !{i32 7, !"uwtable", i32 1}
!29 = !{i32 7, !"frame-pointer", i32 2}
!30 = !{!"Ubuntu clang version 14.0.6"}
!31 = distinct !DISubprogram(name: "init", scope: !12, file: !12, line: 20, type: !32, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!32 = !DISubroutineType(types: !33)
!33 = !{null}
!34 = !{}
!35 = !DILocation(line: 21, column: 15, scope: !31)
!36 = !DILocalVariable(name: "node", scope: !31, file: !12, line: 21, type: !14)
!37 = !DILocation(line: 0, scope: !31)
!38 = !DILocation(line: 22, column: 21, scope: !31)
!39 = !DILocation(line: 22, column: 2, scope: !31)
!40 = !DILocation(line: 23, column: 2, scope: !31)
!41 = !DILocation(line: 24, column: 2, scope: !31)
!42 = !DILocation(line: 25, column: 1, scope: !31)
!43 = distinct !DISubprogram(name: "enqueue", scope: !12, file: !12, line: 27, type: !44, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!44 = !DISubroutineType(types: !45)
!45 = !{null, !19}
!46 = !DILocalVariable(name: "value", arg: 1, scope: !43, file: !12, line: 27, type: !19)
!47 = !DILocation(line: 0, scope: !43)
!48 = !DILocation(line: 30, column: 12, scope: !43)
!49 = !DILocalVariable(name: "node", scope: !43, file: !12, line: 28, type: !14)
!50 = !DILocation(line: 31, column: 8, scope: !43)
!51 = !DILocation(line: 31, column: 12, scope: !43)
!52 = !DILocation(line: 32, column: 21, scope: !43)
!53 = !DILocation(line: 32, column: 2, scope: !43)
!54 = !DILocation(line: 34, column: 2, scope: !43)
!55 = !DILocation(line: 35, column: 10, scope: !56)
!56 = distinct !DILexicalBlock(scope: !43, file: !12, line: 34, column: 12)
!57 = !DILocalVariable(name: "tail", scope: !43, file: !12, line: 28, type: !14)
!58 = !DILocation(line: 36, column: 21, scope: !56)
!59 = !DILocation(line: 36, column: 9, scope: !56)
!60 = !DILocation(line: 37, column: 38, scope: !56)
!61 = !DILocation(line: 37, column: 10, scope: !56)
!62 = !DILocalVariable(name: "next", scope: !43, file: !12, line: 28, type: !14)
!63 = !DILocation(line: 39, column: 21, scope: !64)
!64 = distinct !DILexicalBlock(scope: !56, file: !12, line: 39, column: 13)
!65 = !DILocation(line: 39, column: 18, scope: !64)
!66 = !DILocation(line: 39, column: 13, scope: !56)
!67 = !DILocation(line: 40, column: 22, scope: !68)
!68 = distinct !DILexicalBlock(scope: !69, file: !12, line: 40, column: 17)
!69 = distinct !DILexicalBlock(scope: !64, file: !12, line: 39, column: 68)
!70 = !DILocation(line: 40, column: 17, scope: !69)
!71 = !DILocation(line: 41, column: 9, scope: !72)
!72 = distinct !DILexicalBlock(scope: !73, file: !12, line: 41, column: 9)
!73 = distinct !DILexicalBlock(scope: !68, file: !12, line: 40, column: 31)
!74 = !DILocation(line: 41, column: 9, scope: !73)
!75 = !DILocation(line: 42, column: 9, scope: !76)
!76 = distinct !DILexicalBlock(scope: !72, file: !12, line: 41, column: 40)
!77 = !DILocation(line: 51, column: 1, scope: !43)
!78 = !DILocation(line: 46, column: 5, scope: !79)
!79 = distinct !DILexicalBlock(scope: !68, file: !12, line: 45, column: 20)
!80 = distinct !{!80, !54, !81}
!81 = !DILocation(line: 50, column: 2, scope: !43)
!82 = distinct !DISubprogram(name: "dequeue", scope: !12, file: !12, line: 53, type: !83, scopeLine: 53, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!83 = !DISubroutineType(types: !84)
!84 = !{!19}
!85 = !DILocation(line: 57, column: 2, scope: !82)
!86 = !DILocation(line: 58, column: 10, scope: !87)
!87 = distinct !DILexicalBlock(scope: !82, file: !12, line: 57, column: 12)
!88 = !DILocalVariable(name: "head", scope: !82, file: !12, line: 54, type: !14)
!89 = !DILocation(line: 0, scope: !82)
!90 = !DILocation(line: 59, column: 21, scope: !87)
!91 = !DILocation(line: 59, column: 9, scope: !87)
!92 = !DILocation(line: 60, column: 38, scope: !87)
!93 = !DILocation(line: 60, column: 10, scope: !87)
!94 = !DILocalVariable(name: "next", scope: !82, file: !12, line: 54, type: !14)
!95 = !DILocation(line: 62, column: 15, scope: !96)
!96 = distinct !DILexicalBlock(scope: !87, file: !12, line: 62, column: 7)
!97 = !DILocation(line: 62, column: 12, scope: !96)
!98 = !DILocation(line: 62, column: 7, scope: !87)
!99 = !DILocation(line: 63, column: 13, scope: !100)
!100 = distinct !DILexicalBlock(scope: !101, file: !12, line: 63, column: 8)
!101 = distinct !DILexicalBlock(scope: !96, file: !12, line: 62, column: 62)
!102 = !DILocation(line: 63, column: 8, scope: !101)
!103 = !DILocation(line: 68, column: 32, scope: !104)
!104 = distinct !DILexicalBlock(scope: !100, file: !12, line: 67, column: 11)
!105 = !DILocalVariable(name: "result", scope: !82, file: !12, line: 55, type: !19)
!106 = !DILocation(line: 69, column: 21, scope: !107)
!107 = distinct !DILexicalBlock(scope: !104, file: !12, line: 69, column: 21)
!108 = !DILocation(line: 69, column: 21, scope: !104)
!109 = !DILocation(line: 70, column: 28, scope: !110)
!110 = distinct !DILexicalBlock(scope: !107, file: !12, line: 69, column: 46)
!111 = !DILocalVariable(name: "tail", scope: !82, file: !12, line: 54, type: !14)
!112 = !DILocation(line: 71, column: 33, scope: !110)
!113 = !DILocation(line: 71, column: 21, scope: !110)
!114 = !DILocation(line: 72, column: 30, scope: !115)
!115 = distinct !DILexicalBlock(scope: !110, file: !12, line: 72, column: 25)
!116 = !DILocation(line: 72, column: 25, scope: !110)
!117 = !DILocation(line: 73, column: 25, scope: !118)
!118 = distinct !DILexicalBlock(scope: !115, file: !12, line: 72, column: 39)
!119 = !DILocation(line: 74, column: 21, scope: !118)
!120 = distinct !{!120, !85, !121}
!121 = !DILocation(line: 79, column: 2, scope: !82)
!122 = !DILocation(line: 0, scope: !100)
!123 = !DILocation(line: 81, column: 2, scope: !82)
!124 = distinct !DISubprogram(name: "worker", scope: !125, file: !125, line: 9, type: !126, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!125 = !DIFile(filename: "benchmarks/lfds/dglm.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "6b485fb7cdb48c80a032b3c95cfcf353")
!126 = !DISubroutineType(types: !127)
!127 = !{!5, !5}
!128 = !DILocalVariable(name: "arg", arg: 1, scope: !124, file: !125, line: 9, type: !5)
!129 = !DILocation(line: 0, scope: !124)
!130 = !DILocation(line: 12, column: 23, scope: !124)
!131 = !DILocalVariable(name: "index", scope: !124, file: !125, line: 12, type: !6)
!132 = !DILocation(line: 14, column: 10, scope: !124)
!133 = !DILocation(line: 14, column: 2, scope: !124)
!134 = !DILocation(line: 15, column: 13, scope: !124)
!135 = !DILocalVariable(name: "r", scope: !124, file: !125, line: 15, type: !19)
!136 = !DILocation(line: 17, column: 2, scope: !137)
!137 = distinct !DILexicalBlock(scope: !138, file: !125, line: 17, column: 2)
!138 = distinct !DILexicalBlock(scope: !124, file: !125, line: 17, column: 2)
!139 = !DILocation(line: 17, column: 2, scope: !138)
!140 = !DILocation(line: 19, column: 2, scope: !124)
!141 = distinct !DISubprogram(name: "main", scope: !125, file: !125, line: 22, type: !83, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!142 = !DILocalVariable(name: "t", scope: !141, file: !125, line: 24, type: !143)
!143 = !DICompositeType(tag: DW_TAG_array_type, baseType: !144, size: 192, elements: !147)
!144 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !145, line: 27, baseType: !146)
!145 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!146 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!147 = !{!148}
!148 = !DISubrange(count: 3)
!149 = !DILocation(line: 24, column: 15, scope: !141)
!150 = !DILocation(line: 26, column: 5, scope: !141)
!151 = !DILocalVariable(name: "i", scope: !152, file: !125, line: 28, type: !19)
!152 = distinct !DILexicalBlock(scope: !141, file: !125, line: 28, column: 5)
!153 = !DILocation(line: 0, scope: !152)
!154 = !DILocation(line: 29, column: 25, scope: !155)
!155 = distinct !DILexicalBlock(scope: !152, file: !125, line: 28, column: 5)
!156 = !DILocation(line: 29, column: 9, scope: !155)
!157 = !DILocalVariable(name: "i", scope: !158, file: !125, line: 31, type: !19)
!158 = distinct !DILexicalBlock(scope: !141, file: !125, line: 31, column: 5)
!159 = !DILocation(line: 0, scope: !158)
!160 = !DILocation(line: 32, column: 22, scope: !161)
!161 = distinct !DILexicalBlock(scope: !158, file: !125, line: 31, column: 5)
!162 = !DILocation(line: 32, column: 9, scope: !161)
!163 = !DILocation(line: 34, column: 13, scope: !141)
!164 = !DILocalVariable(name: "r", scope: !141, file: !125, line: 34, type: !19)
!165 = !DILocation(line: 0, scope: !141)
!166 = !DILocation(line: 35, column: 5, scope: !167)
!167 = distinct !DILexicalBlock(scope: !168, file: !125, line: 35, column: 5)
!168 = distinct !DILexicalBlock(scope: !141, file: !125, line: 35, column: 5)
!169 = !DILocation(line: 35, column: 5, scope: !168)
!170 = !DILocation(line: 37, column: 5, scope: !141)
