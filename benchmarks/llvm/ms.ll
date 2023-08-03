; ModuleID = 'output/ms.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lfds/ms.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Node = type { i32, %struct.Node* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@Head = dso_local global %struct.Node* null, align 8, !dbg !0
@Tail = dso_local global %struct.Node* null, align 8, !dbg !10

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
  %20 = icmp ne %struct.Node* %15, null, !dbg !67
  br i1 %20, label %21, label %26, !dbg !70

21:                                               ; preds = %19
  %22 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %7, i64 %14 acq_rel monotonic, align 8, !dbg !71
  %23 = extractvalue { i64, i1 } %22, 0, !dbg !71
  %24 = extractvalue { i64, i1 } %22, 1, !dbg !71
  %25 = zext i1 %24 to i8, !dbg !71
  br label %37, !dbg !73

26:                                               ; preds = %19
  %27 = ptrtoint %struct.Node* %3 to i64, !dbg !74
  %28 = cmpxchg i64* %13, i64 %14, i64 %27 acq_rel monotonic, align 8, !dbg !74
  %29 = extractvalue { i64, i1 } %28, 0, !dbg !74
  %30 = extractvalue { i64, i1 } %28, 1, !dbg !74
  %31 = zext i1 %30 to i8, !dbg !74
  br i1 %30, label %32, label %37, !dbg !77

32:                                               ; preds = %26
  %33 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %7, i64 %27 acq_rel monotonic, align 8, !dbg !78
  %34 = extractvalue { i64, i1 } %33, 0, !dbg !78
  %35 = extractvalue { i64, i1 } %33, 1, !dbg !78
  %36 = zext i1 %35 to i8, !dbg !78
  ret void, !dbg !80

37:                                               ; preds = %21, %26, %6
  br label %6, !dbg !54, !llvm.loop !81
}

declare i32 @assert(...) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @dequeue() #0 !dbg !83 {
  br label %1, !dbg !86

1:                                                ; preds = %35, %0
  %2 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8, !dbg !87
  %3 = inttoptr i64 %2 to %struct.Node*, !dbg !87
  call void @llvm.dbg.value(metadata %struct.Node* %3, metadata !89, metadata !DIExpression()), !dbg !90
  %4 = icmp ne %struct.Node* %3, null, !dbg !91
  %5 = zext i1 %4 to i32, !dbg !91
  %6 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 noundef %5), !dbg !92
  %7 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8, !dbg !93
  %8 = inttoptr i64 %7 to %struct.Node*, !dbg !93
  call void @llvm.dbg.value(metadata %struct.Node* %8, metadata !94, metadata !DIExpression()), !dbg !90
  %9 = icmp ne %struct.Node* %8, null, !dbg !95
  %10 = zext i1 %9 to i32, !dbg !95
  %11 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 noundef %10), !dbg !96
  %12 = getelementptr inbounds %struct.Node, %struct.Node* %3, i32 0, i32 1, !dbg !97
  %13 = bitcast %struct.Node** %12 to i64*, !dbg !98
  %14 = load atomic i64, i64* %13 acquire, align 8, !dbg !98
  %15 = inttoptr i64 %14 to %struct.Node*, !dbg !98
  call void @llvm.dbg.value(metadata %struct.Node* %15, metadata !99, metadata !DIExpression()), !dbg !90
  %16 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8, !dbg !100
  %17 = inttoptr i64 %16 to %struct.Node*, !dbg !100
  %18 = icmp eq %struct.Node* %3, %17, !dbg !102
  br i1 %18, label %19, label %35, !dbg !103

19:                                               ; preds = %1
  %20 = icmp eq %struct.Node* %15, null, !dbg !104
  br i1 %20, label %36, label %21, !dbg !107

21:                                               ; preds = %19
  %22 = icmp eq %struct.Node* %3, %8, !dbg !108
  br i1 %22, label %23, label %28, !dbg !111

23:                                               ; preds = %21
  %24 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %7, i64 %14 acq_rel monotonic, align 8, !dbg !112
  %25 = extractvalue { i64, i1 } %24, 0, !dbg !112
  %26 = extractvalue { i64, i1 } %24, 1, !dbg !112
  %27 = zext i1 %26 to i8, !dbg !112
  br label %35, !dbg !114

28:                                               ; preds = %21
  %29 = getelementptr inbounds %struct.Node, %struct.Node* %15, i32 0, i32 0, !dbg !115
  %30 = load i32, i32* %29, align 8, !dbg !115
  call void @llvm.dbg.value(metadata i32 %30, metadata !117, metadata !DIExpression()), !dbg !90
  %31 = cmpxchg i64* bitcast (%struct.Node** @Head to i64*), i64 %2, i64 %14 acq_rel monotonic, align 8, !dbg !118
  %32 = extractvalue { i64, i1 } %31, 0, !dbg !118
  %33 = extractvalue { i64, i1 } %31, 1, !dbg !118
  %34 = zext i1 %33 to i8, !dbg !118
  br i1 %33, label %36, label %35, !dbg !120

35:                                               ; preds = %28, %23, %1
  br label %1, !dbg !86, !llvm.loop !121

36:                                               ; preds = %28, %19
  %.0 = phi i32 [ -1, %19 ], [ %30, %28 ], !dbg !123
  call void @llvm.dbg.value(metadata i32 %.0, metadata !117, metadata !DIExpression()), !dbg !90
  ret i32 %.0, !dbg !124
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @worker(i8* noundef %0) #0 !dbg !125 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !129, metadata !DIExpression()), !dbg !130
  %2 = ptrtoint i8* %0 to i64, !dbg !131
  call void @llvm.dbg.value(metadata i64 %2, metadata !132, metadata !DIExpression()), !dbg !130
  %3 = trunc i64 %2 to i32, !dbg !133
  call void @enqueue(i32 noundef %3), !dbg !134
  %4 = call i32 @dequeue(), !dbg !135
  call void @llvm.dbg.value(metadata i32 %4, metadata !136, metadata !DIExpression()), !dbg !130
  %5 = icmp ne i32 %4, -1, !dbg !137
  %6 = zext i1 %5 to i32, !dbg !137
  %7 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 noundef %6), !dbg !138
  ret i8* null, !dbg !139
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !140 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !141, metadata !DIExpression()), !dbg !148
  call void @init(), !dbg !149
  call void @llvm.dbg.value(metadata i32 0, metadata !150, metadata !DIExpression()), !dbg !152
  call void @llvm.dbg.value(metadata i64 0, metadata !150, metadata !DIExpression()), !dbg !152
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !153
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef null) #4, !dbg !155
  call void @llvm.dbg.value(metadata i64 1, metadata !150, metadata !DIExpression()), !dbg !152
  call void @llvm.dbg.value(metadata i64 1, metadata !150, metadata !DIExpression()), !dbg !152
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !153
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef inttoptr (i64 1 to i8*)) #4, !dbg !155
  call void @llvm.dbg.value(metadata i64 2, metadata !150, metadata !DIExpression()), !dbg !152
  call void @llvm.dbg.value(metadata i64 2, metadata !150, metadata !DIExpression()), !dbg !152
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !153
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef inttoptr (i64 2 to i8*)) #4, !dbg !155
  call void @llvm.dbg.value(metadata i64 3, metadata !150, metadata !DIExpression()), !dbg !152
  call void @llvm.dbg.value(metadata i64 3, metadata !150, metadata !DIExpression()), !dbg !152
  call void @llvm.dbg.value(metadata i32 0, metadata !156, metadata !DIExpression()), !dbg !158
  call void @llvm.dbg.value(metadata i64 0, metadata !156, metadata !DIExpression()), !dbg !158
  %8 = load i64, i64* %2, align 8, !dbg !159
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !161
  call void @llvm.dbg.value(metadata i64 1, metadata !156, metadata !DIExpression()), !dbg !158
  call void @llvm.dbg.value(metadata i64 1, metadata !156, metadata !DIExpression()), !dbg !158
  %10 = load i64, i64* %4, align 8, !dbg !159
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !161
  call void @llvm.dbg.value(metadata i64 2, metadata !156, metadata !DIExpression()), !dbg !158
  call void @llvm.dbg.value(metadata i64 2, metadata !156, metadata !DIExpression()), !dbg !158
  %12 = load i64, i64* %6, align 8, !dbg !159
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !161
  call void @llvm.dbg.value(metadata i64 3, metadata !156, metadata !DIExpression()), !dbg !158
  call void @llvm.dbg.value(metadata i64 3, metadata !156, metadata !DIExpression()), !dbg !158
  %14 = call i32 @dequeue(), !dbg !162
  call void @llvm.dbg.value(metadata i32 %14, metadata !163, metadata !DIExpression()), !dbg !164
  %15 = icmp eq i32 %14, -1, !dbg !165
  %16 = zext i1 %15 to i32, !dbg !165
  %17 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 noundef %16), !dbg !166
  ret i32 0, !dbg !167
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!23, !24, !25, !26, !27, !28, !29}
!llvm.ident = !{!30}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "Head", scope: !2, file: !12, line: 17, type: !13, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !9, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lfds/ms.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "d23562d2138b1dedd8c3cc53b77c5c63")
!4 = !{!5, !6}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !7, line: 87, baseType: !8)
!7 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!8 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!9 = !{!10, !0}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "Tail", scope: !2, file: !12, line: 16, type: !13, isLocal: false, isDefinition: true)
!12 = !DIFile(filename: "benchmarks/lfds/ms.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "99ecdb5ca305fa4819f6b59868786edc")
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
!58 = !DILocation(line: 36, column: 15, scope: !56)
!59 = !DILocation(line: 36, column: 3, scope: !56)
!60 = !DILocation(line: 37, column: 38, scope: !56)
!61 = !DILocation(line: 37, column: 10, scope: !56)
!62 = !DILocalVariable(name: "next", scope: !43, file: !12, line: 28, type: !14)
!63 = !DILocation(line: 39, column: 15, scope: !64)
!64 = distinct !DILexicalBlock(scope: !56, file: !12, line: 39, column: 7)
!65 = !DILocation(line: 39, column: 12, scope: !64)
!66 = !DILocation(line: 39, column: 7, scope: !56)
!67 = !DILocation(line: 40, column: 13, scope: !68)
!68 = distinct !DILexicalBlock(scope: !69, file: !12, line: 40, column: 8)
!69 = distinct !DILexicalBlock(scope: !64, file: !12, line: 39, column: 62)
!70 = !DILocation(line: 40, column: 8, scope: !69)
!71 = !DILocation(line: 41, column: 5, scope: !72)
!72 = distinct !DILexicalBlock(scope: !68, file: !12, line: 40, column: 22)
!73 = !DILocation(line: 42, column: 4, scope: !72)
!74 = !DILocation(line: 43, column: 9, scope: !75)
!75 = distinct !DILexicalBlock(scope: !76, file: !12, line: 43, column: 9)
!76 = distinct !DILexicalBlock(scope: !68, file: !12, line: 42, column: 11)
!77 = !DILocation(line: 43, column: 9, scope: !76)
!78 = !DILocation(line: 44, column: 9, scope: !79)
!79 = distinct !DILexicalBlock(scope: !75, file: !12, line: 43, column: 40)
!80 = !DILocation(line: 50, column: 1, scope: !43)
!81 = distinct !{!81, !54, !82}
!82 = !DILocation(line: 49, column: 2, scope: !43)
!83 = distinct !DISubprogram(name: "dequeue", scope: !12, file: !12, line: 52, type: !84, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!84 = !DISubroutineType(types: !85)
!85 = !{!19}
!86 = !DILocation(line: 56, column: 2, scope: !83)
!87 = !DILocation(line: 57, column: 10, scope: !88)
!88 = distinct !DILexicalBlock(scope: !83, file: !12, line: 56, column: 12)
!89 = !DILocalVariable(name: "head", scope: !83, file: !12, line: 53, type: !14)
!90 = !DILocation(line: 0, scope: !83)
!91 = !DILocation(line: 58, column: 15, scope: !88)
!92 = !DILocation(line: 58, column: 3, scope: !88)
!93 = !DILocation(line: 59, column: 10, scope: !88)
!94 = !DILocalVariable(name: "tail", scope: !83, file: !12, line: 53, type: !14)
!95 = !DILocation(line: 60, column: 15, scope: !88)
!96 = !DILocation(line: 60, column: 3, scope: !88)
!97 = !DILocation(line: 61, column: 38, scope: !88)
!98 = !DILocation(line: 61, column: 10, scope: !88)
!99 = !DILocalVariable(name: "next", scope: !83, file: !12, line: 53, type: !14)
!100 = !DILocation(line: 63, column: 15, scope: !101)
!101 = distinct !DILexicalBlock(scope: !88, file: !12, line: 63, column: 7)
!102 = !DILocation(line: 63, column: 12, scope: !101)
!103 = !DILocation(line: 63, column: 7, scope: !88)
!104 = !DILocation(line: 64, column: 13, scope: !105)
!105 = distinct !DILexicalBlock(scope: !106, file: !12, line: 64, column: 8)
!106 = distinct !DILexicalBlock(scope: !101, file: !12, line: 63, column: 62)
!107 = !DILocation(line: 64, column: 8, scope: !106)
!108 = !DILocation(line: 68, column: 14, scope: !109)
!109 = distinct !DILexicalBlock(scope: !110, file: !12, line: 68, column: 9)
!110 = distinct !DILexicalBlock(scope: !105, file: !12, line: 67, column: 11)
!111 = !DILocation(line: 68, column: 9, scope: !110)
!112 = !DILocation(line: 69, column: 6, scope: !113)
!113 = distinct !DILexicalBlock(scope: !109, file: !12, line: 68, column: 23)
!114 = !DILocation(line: 70, column: 5, scope: !113)
!115 = !DILocation(line: 71, column: 21, scope: !116)
!116 = distinct !DILexicalBlock(scope: !109, file: !12, line: 70, column: 12)
!117 = !DILocalVariable(name: "result", scope: !83, file: !12, line: 54, type: !19)
!118 = !DILocation(line: 72, column: 10, scope: !119)
!119 = distinct !DILexicalBlock(scope: !116, file: !12, line: 72, column: 10)
!120 = !DILocation(line: 72, column: 10, scope: !116)
!121 = distinct !{!121, !86, !122}
!122 = !DILocation(line: 79, column: 2, scope: !83)
!123 = !DILocation(line: 0, scope: !105)
!124 = !DILocation(line: 81, column: 2, scope: !83)
!125 = distinct !DISubprogram(name: "worker", scope: !126, file: !126, line: 8, type: !127, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!126 = !DIFile(filename: "benchmarks/lfds/ms.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "d23562d2138b1dedd8c3cc53b77c5c63")
!127 = !DISubroutineType(types: !128)
!128 = !{!5, !5}
!129 = !DILocalVariable(name: "arg", arg: 1, scope: !125, file: !126, line: 8, type: !5)
!130 = !DILocation(line: 0, scope: !125)
!131 = !DILocation(line: 11, column: 23, scope: !125)
!132 = !DILocalVariable(name: "index", scope: !125, file: !126, line: 11, type: !6)
!133 = !DILocation(line: 13, column: 10, scope: !125)
!134 = !DILocation(line: 13, column: 2, scope: !125)
!135 = !DILocation(line: 14, column: 13, scope: !125)
!136 = !DILocalVariable(name: "r", scope: !125, file: !126, line: 14, type: !19)
!137 = !DILocation(line: 16, column: 11, scope: !125)
!138 = !DILocation(line: 16, column: 2, scope: !125)
!139 = !DILocation(line: 18, column: 2, scope: !125)
!140 = distinct !DISubprogram(name: "main", scope: !126, file: !126, line: 21, type: !84, scopeLine: 22, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!141 = !DILocalVariable(name: "t", scope: !140, file: !126, line: 23, type: !142)
!142 = !DICompositeType(tag: DW_TAG_array_type, baseType: !143, size: 192, elements: !146)
!143 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !144, line: 27, baseType: !145)
!144 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!145 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!146 = !{!147}
!147 = !DISubrange(count: 3)
!148 = !DILocation(line: 23, column: 15, scope: !140)
!149 = !DILocation(line: 25, column: 5, scope: !140)
!150 = !DILocalVariable(name: "i", scope: !151, file: !126, line: 27, type: !19)
!151 = distinct !DILexicalBlock(scope: !140, file: !126, line: 27, column: 5)
!152 = !DILocation(line: 0, scope: !151)
!153 = !DILocation(line: 28, column: 25, scope: !154)
!154 = distinct !DILexicalBlock(scope: !151, file: !126, line: 27, column: 5)
!155 = !DILocation(line: 28, column: 9, scope: !154)
!156 = !DILocalVariable(name: "i", scope: !157, file: !126, line: 30, type: !19)
!157 = distinct !DILexicalBlock(scope: !140, file: !126, line: 30, column: 5)
!158 = !DILocation(line: 0, scope: !157)
!159 = !DILocation(line: 31, column: 22, scope: !160)
!160 = distinct !DILexicalBlock(scope: !157, file: !126, line: 30, column: 5)
!161 = !DILocation(line: 31, column: 9, scope: !160)
!162 = !DILocation(line: 33, column: 13, scope: !140)
!163 = !DILocalVariable(name: "r", scope: !140, file: !126, line: 33, type: !19)
!164 = !DILocation(line: 0, scope: !140)
!165 = !DILocation(line: 34, column: 14, scope: !140)
!166 = !DILocation(line: 34, column: 5, scope: !140)
!167 = !DILocation(line: 36, column: 5, scope: !140)
