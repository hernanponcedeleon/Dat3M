; ModuleID = 'benchmarks/treiber.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lfds/treiber.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.anon = type { %struct.Node* }
%struct.Node = type { i32, %struct.Node* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@TOP = dso_local global %struct.anon zeroinitializer, align 8, !dbg !0
@.str = private unnamed_addr constant [11 x i8] c"r != EMPTY\00", align 1
@.str.1 = private unnamed_addr constant [48 x i8] c"/home/ponce/git/Dat3M/benchmarks/lfds/treiber.c\00", align 1
@__PRETTY_FUNCTION__.worker = private unnamed_addr constant [21 x i8] c"void *worker(void *)\00", align 1
@.str.2 = private unnamed_addr constant [11 x i8] c"r == EMPTY\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !32 {
  store %struct.Node* null, %struct.Node** getelementptr inbounds (%struct.anon, %struct.anon* @TOP, i32 0, i32 0), align 8, !dbg !36
  ret void, !dbg !37
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @push(i32 noundef %0) #0 !dbg !38 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !41, metadata !DIExpression()), !dbg !42
  %2 = call i8* @malloc(i64 noundef 16), !dbg !43
  %3 = bitcast i8* %2 to %struct.Node*, !dbg !43
  call void @llvm.dbg.value(metadata %struct.Node* %3, metadata !44, metadata !DIExpression()), !dbg !42
  %4 = getelementptr inbounds %struct.Node, %struct.Node* %3, i32 0, i32 0, !dbg !45
  store i32 %0, i32* %4, align 8, !dbg !46
  br label %5, !dbg !47

5:                                                ; preds = %5, %1
  %6 = load atomic i64, i64* bitcast (%struct.anon* @TOP to i64*) acquire, align 8, !dbg !48
  %7 = inttoptr i64 %6 to %struct.Node*, !dbg !48
  call void @llvm.dbg.value(metadata %struct.Node* %7, metadata !50, metadata !DIExpression()), !dbg !42
  %8 = getelementptr inbounds %struct.Node, %struct.Node* %3, i32 0, i32 1, !dbg !51
  %9 = bitcast %struct.Node** %8 to i64*, !dbg !52
  store atomic i64 %6, i64* %9 monotonic, align 8, !dbg !52
  %10 = ptrtoint %struct.Node* %3 to i64, !dbg !53
  %11 = cmpxchg i64* bitcast (%struct.anon* @TOP to i64*), i64 %6, i64 %10 acq_rel monotonic, align 8, !dbg !53
  %12 = extractvalue { i64, i1 } %11, 0, !dbg !53
  %13 = extractvalue { i64, i1 } %11, 1, !dbg !53
  %14 = zext i1 %13 to i8, !dbg !53
  br i1 %13, label %15, label %5, !dbg !55, !llvm.loop !56

15:                                               ; preds = %5
  ret void, !dbg !58
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i8* @malloc(i64 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @pop() #0 !dbg !59 {
  br label %1, !dbg !62

1:                                                ; preds = %5, %0
  %2 = load atomic i64, i64* bitcast (%struct.anon* @TOP to i64*) acquire, align 8, !dbg !63
  %3 = inttoptr i64 %2 to %struct.Node*, !dbg !63
  call void @llvm.dbg.value(metadata %struct.Node* %3, metadata !65, metadata !DIExpression()), !dbg !66
  %4 = icmp eq %struct.Node* %3, null, !dbg !67
  br i1 %4, label %18, label %5, !dbg !69

5:                                                ; preds = %1
  %6 = getelementptr inbounds %struct.Node, %struct.Node* %3, i32 0, i32 1, !dbg !70
  %7 = bitcast %struct.Node** %6 to i64*, !dbg !72
  %8 = load atomic i64, i64* %7 acquire, align 8, !dbg !72
  %9 = inttoptr i64 %8 to %struct.Node*, !dbg !72
  call void @llvm.dbg.value(metadata %struct.Node* %9, metadata !73, metadata !DIExpression()), !dbg !66
  %10 = cmpxchg i64* bitcast (%struct.anon* @TOP to i64*), i64 %2, i64 %8 acq_rel monotonic, align 8, !dbg !74
  %11 = extractvalue { i64, i1 } %10, 0, !dbg !74
  %12 = extractvalue { i64, i1 } %10, 1, !dbg !74
  %13 = inttoptr i64 %11 to %struct.Node*, !dbg !74
  %.06 = select i1 %12, %struct.Node* %3, %struct.Node* %13, !dbg !74
  call void @llvm.dbg.value(metadata %struct.Node* %.06, metadata !65, metadata !DIExpression()), !dbg !66
  %14 = zext i1 %12 to i8, !dbg !74
  br i1 %12, label %15, label %1, !dbg !76, !llvm.loop !77

15:                                               ; preds = %5
  %16 = getelementptr inbounds %struct.Node, %struct.Node* %.06, i32 0, i32 0, !dbg !79
  %17 = load i32, i32* %16, align 8, !dbg !79
  br label %18, !dbg !80

18:                                               ; preds = %1, %15
  %.0 = phi i32 [ %17, %15 ], [ -1, %1 ], !dbg !66
  ret i32 %.0, !dbg !81
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @worker(i8* noundef %0) #0 !dbg !82 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !86, metadata !DIExpression()), !dbg !87
  %2 = ptrtoint i8* %0 to i64, !dbg !88
  call void @llvm.dbg.value(metadata i64 %2, metadata !89, metadata !DIExpression()), !dbg !87
  %3 = trunc i64 %2 to i32, !dbg !90
  call void @push(i32 noundef %3), !dbg !91
  %4 = call i32 @pop(), !dbg !92
  call void @llvm.dbg.value(metadata i32 %4, metadata !93, metadata !DIExpression()), !dbg !87
  %5 = icmp ne i32 %4, -1, !dbg !94
  br i1 %5, label %7, label %6, !dbg !97

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.1, i64 0, i64 0), i32 noundef 17, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.worker, i64 0, i64 0)) #5, !dbg !94
  unreachable, !dbg !94

7:                                                ; preds = %1
  ret i8* null, !dbg !98
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !99 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !100, metadata !DIExpression()), !dbg !107
  call void @init(), !dbg !108
  call void @llvm.dbg.value(metadata i32 0, metadata !109, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i64 0, metadata !109, metadata !DIExpression()), !dbg !111
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !112
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef null) #6, !dbg !114
  call void @llvm.dbg.value(metadata i64 1, metadata !109, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i64 1, metadata !109, metadata !DIExpression()), !dbg !111
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !112
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !114
  call void @llvm.dbg.value(metadata i64 2, metadata !109, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i64 2, metadata !109, metadata !DIExpression()), !dbg !111
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !112
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !114
  call void @llvm.dbg.value(metadata i64 3, metadata !109, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i64 3, metadata !109, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i32 0, metadata !115, metadata !DIExpression()), !dbg !117
  call void @llvm.dbg.value(metadata i64 0, metadata !115, metadata !DIExpression()), !dbg !117
  %8 = load i64, i64* %2, align 8, !dbg !118
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !120
  call void @llvm.dbg.value(metadata i64 1, metadata !115, metadata !DIExpression()), !dbg !117
  call void @llvm.dbg.value(metadata i64 1, metadata !115, metadata !DIExpression()), !dbg !117
  %10 = load i64, i64* %4, align 8, !dbg !118
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !120
  call void @llvm.dbg.value(metadata i64 2, metadata !115, metadata !DIExpression()), !dbg !117
  call void @llvm.dbg.value(metadata i64 2, metadata !115, metadata !DIExpression()), !dbg !117
  %12 = load i64, i64* %6, align 8, !dbg !118
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !120
  call void @llvm.dbg.value(metadata i64 3, metadata !115, metadata !DIExpression()), !dbg !117
  call void @llvm.dbg.value(metadata i64 3, metadata !115, metadata !DIExpression()), !dbg !117
  %14 = call i32 @pop(), !dbg !121
  call void @llvm.dbg.value(metadata i32 %14, metadata !122, metadata !DIExpression()), !dbg !123
  %15 = icmp eq i32 %14, -1, !dbg !124
  br i1 %15, label %17, label %16, !dbg !127

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.1, i64 0, i64 0), i32 noundef 35, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !124
  unreachable, !dbg !124

17:                                               ; preds = %0
  ret i32 0, !dbg !128
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
!llvm.module.flags = !{!24, !25, !26, !27, !28, !29, !30}
!llvm.ident = !{!31}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "TOP", scope: !2, file: !10, line: 18, type: !11, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !9, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lfds/treiber.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "9afc53ec170e54014fad2d2b7902d1d1")
!4 = !{!5, !6}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !7, line: 87, baseType: !8)
!7 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!8 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!9 = !{!0}
!10 = !DIFile(filename: "benchmarks/lfds/treiber.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "88b078f8fcab2c4a9b6600d977ffba0d")
!11 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !10, line: 16, size: 64, elements: !12)
!12 = !{!13}
!13 = !DIDerivedType(tag: DW_TAG_member, name: "node", scope: !11, file: !10, line: 17, baseType: !14, size: 64)
!14 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !15)
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "Node", file: !10, line: 14, baseType: !17)
!17 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Node", file: !10, line: 11, size: 128, elements: !18)
!18 = !{!19, !21}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "val", scope: !17, file: !10, line: 12, baseType: !20, size: 32)
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !17, file: !10, line: 13, baseType: !22, size: 64, offset: 64)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!24 = !{i32 7, !"Dwarf Version", i32 5}
!25 = !{i32 2, !"Debug Info Version", i32 3}
!26 = !{i32 1, !"wchar_size", i32 4}
!27 = !{i32 7, !"PIC Level", i32 2}
!28 = !{i32 7, !"PIE Level", i32 2}
!29 = !{i32 7, !"uwtable", i32 1}
!30 = !{i32 7, !"frame-pointer", i32 2}
!31 = !{!"Ubuntu clang version 14.0.6"}
!32 = distinct !DISubprogram(name: "init", scope: !10, file: !10, line: 20, type: !33, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !35)
!33 = !DISubroutineType(types: !34)
!34 = !{null}
!35 = !{}
!36 = !DILocation(line: 21, column: 5, scope: !32)
!37 = !DILocation(line: 22, column: 1, scope: !32)
!38 = distinct !DISubprogram(name: "push", scope: !10, file: !10, line: 24, type: !39, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !35)
!39 = !DISubroutineType(types: !40)
!40 = !{null, !20}
!41 = !DILocalVariable(name: "e", arg: 1, scope: !38, file: !10, line: 24, type: !20)
!42 = !DILocation(line: 0, scope: !38)
!43 = !DILocation(line: 26, column: 9, scope: !38)
!44 = !DILocalVariable(name: "y", scope: !38, file: !10, line: 25, type: !15)
!45 = !DILocation(line: 27, column: 8, scope: !38)
!46 = !DILocation(line: 27, column: 12, scope: !38)
!47 = !DILocation(line: 29, column: 5, scope: !38)
!48 = !DILocation(line: 30, column: 13, scope: !49)
!49 = distinct !DILexicalBlock(scope: !38, file: !10, line: 29, column: 14)
!50 = !DILocalVariable(name: "n", scope: !38, file: !10, line: 25, type: !15)
!51 = !DILocation(line: 31, column: 35, scope: !49)
!52 = !DILocation(line: 31, column: 9, scope: !49)
!53 = !DILocation(line: 33, column: 13, scope: !54)
!54 = distinct !DILexicalBlock(scope: !49, file: !10, line: 33, column: 13)
!55 = !DILocation(line: 33, column: 13, scope: !49)
!56 = distinct !{!56, !47, !57}
!57 = !DILocation(line: 36, column: 5, scope: !38)
!58 = !DILocation(line: 37, column: 1, scope: !38)
!59 = distinct !DISubprogram(name: "pop", scope: !10, file: !10, line: 39, type: !60, scopeLine: 39, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !35)
!60 = !DISubroutineType(types: !61)
!61 = !{!20}
!62 = !DILocation(line: 42, column: 5, scope: !59)
!63 = !DILocation(line: 43, column: 13, scope: !64)
!64 = distinct !DILexicalBlock(scope: !59, file: !10, line: 42, column: 15)
!65 = !DILocalVariable(name: "y", scope: !59, file: !10, line: 40, type: !15)
!66 = !DILocation(line: 0, scope: !59)
!67 = !DILocation(line: 44, column: 15, scope: !68)
!68 = distinct !DILexicalBlock(scope: !64, file: !10, line: 44, column: 13)
!69 = !DILocation(line: 44, column: 13, scope: !64)
!70 = !DILocation(line: 47, column: 42, scope: !71)
!71 = distinct !DILexicalBlock(scope: !68, file: !10, line: 46, column: 16)
!72 = !DILocation(line: 47, column: 17, scope: !71)
!73 = !DILocalVariable(name: "z", scope: !59, file: !10, line: 40, type: !15)
!74 = !DILocation(line: 48, column: 17, scope: !75)
!75 = distinct !DILexicalBlock(scope: !71, file: !10, line: 48, column: 17)
!76 = !DILocation(line: 48, column: 17, scope: !71)
!77 = distinct !{!77, !62, !78}
!78 = !DILocation(line: 53, column: 5, scope: !59)
!79 = !DILocation(line: 54, column: 15, scope: !59)
!80 = !DILocation(line: 54, column: 5, scope: !59)
!81 = !DILocation(line: 55, column: 1, scope: !59)
!82 = distinct !DISubprogram(name: "worker", scope: !83, file: !83, line: 9, type: !84, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !35)
!83 = !DIFile(filename: "benchmarks/lfds/treiber.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "9afc53ec170e54014fad2d2b7902d1d1")
!84 = !DISubroutineType(types: !85)
!85 = !{!5, !5}
!86 = !DILocalVariable(name: "arg", arg: 1, scope: !82, file: !83, line: 9, type: !5)
!87 = !DILocation(line: 0, scope: !82)
!88 = !DILocation(line: 12, column: 23, scope: !82)
!89 = !DILocalVariable(name: "index", scope: !82, file: !83, line: 12, type: !6)
!90 = !DILocation(line: 14, column: 7, scope: !82)
!91 = !DILocation(line: 14, column: 2, scope: !82)
!92 = !DILocation(line: 15, column: 13, scope: !82)
!93 = !DILocalVariable(name: "r", scope: !82, file: !83, line: 15, type: !20)
!94 = !DILocation(line: 17, column: 2, scope: !95)
!95 = distinct !DILexicalBlock(scope: !96, file: !83, line: 17, column: 2)
!96 = distinct !DILexicalBlock(scope: !82, file: !83, line: 17, column: 2)
!97 = !DILocation(line: 17, column: 2, scope: !96)
!98 = !DILocation(line: 19, column: 2, scope: !82)
!99 = distinct !DISubprogram(name: "main", scope: !83, file: !83, line: 22, type: !60, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !35)
!100 = !DILocalVariable(name: "t", scope: !99, file: !83, line: 24, type: !101)
!101 = !DICompositeType(tag: DW_TAG_array_type, baseType: !102, size: 192, elements: !105)
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !103, line: 27, baseType: !104)
!103 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!104 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!105 = !{!106}
!106 = !DISubrange(count: 3)
!107 = !DILocation(line: 24, column: 15, scope: !99)
!108 = !DILocation(line: 26, column: 5, scope: !99)
!109 = !DILocalVariable(name: "i", scope: !110, file: !83, line: 28, type: !20)
!110 = distinct !DILexicalBlock(scope: !99, file: !83, line: 28, column: 5)
!111 = !DILocation(line: 0, scope: !110)
!112 = !DILocation(line: 29, column: 25, scope: !113)
!113 = distinct !DILexicalBlock(scope: !110, file: !83, line: 28, column: 5)
!114 = !DILocation(line: 29, column: 9, scope: !113)
!115 = !DILocalVariable(name: "i", scope: !116, file: !83, line: 31, type: !20)
!116 = distinct !DILexicalBlock(scope: !99, file: !83, line: 31, column: 5)
!117 = !DILocation(line: 0, scope: !116)
!118 = !DILocation(line: 32, column: 22, scope: !119)
!119 = distinct !DILexicalBlock(scope: !116, file: !83, line: 31, column: 5)
!120 = !DILocation(line: 32, column: 9, scope: !119)
!121 = !DILocation(line: 34, column: 13, scope: !99)
!122 = !DILocalVariable(name: "r", scope: !99, file: !83, line: 34, type: !20)
!123 = !DILocation(line: 0, scope: !99)
!124 = !DILocation(line: 35, column: 5, scope: !125)
!125 = distinct !DILexicalBlock(scope: !126, file: !83, line: 35, column: 5)
!126 = distinct !DILexicalBlock(scope: !99, file: !83, line: 35, column: 5)
!127 = !DILocation(line: 35, column: 5, scope: !126)
!128 = !DILocation(line: 37, column: 5, scope: !99)
