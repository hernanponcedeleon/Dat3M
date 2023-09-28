; ModuleID = '/home/ponce/git/Dat3M/output/treiber.ll'
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
define dso_local void @init() #0 !dbg !35 {
  store %struct.Node* null, %struct.Node** getelementptr inbounds (%struct.anon, %struct.anon* @TOP, i32 0, i32 0), align 8, !dbg !39
  ret void, !dbg !40
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @push(i32 noundef %0) #0 !dbg !41 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !44, metadata !DIExpression()), !dbg !45
  %2 = call noalias i8* @malloc(i64 noundef 16) #5, !dbg !46
  %3 = bitcast i8* %2 to %struct.Node*, !dbg !46
  call void @llvm.dbg.value(metadata %struct.Node* %3, metadata !47, metadata !DIExpression()), !dbg !45
  %4 = getelementptr inbounds %struct.Node, %struct.Node* %3, i32 0, i32 0, !dbg !48
  store i32 %0, i32* %4, align 8, !dbg !49
  br label %5, !dbg !50

5:                                                ; preds = %5, %1
  %6 = load atomic i64, i64* bitcast (%struct.anon* @TOP to i64*) acquire, align 8, !dbg !51
  %7 = inttoptr i64 %6 to %struct.Node*, !dbg !51
  call void @llvm.dbg.value(metadata %struct.Node* %7, metadata !53, metadata !DIExpression()), !dbg !45
  %8 = getelementptr inbounds %struct.Node, %struct.Node* %3, i32 0, i32 1, !dbg !54
  %9 = bitcast %struct.Node** %8 to i64*, !dbg !55
  store atomic i64 %6, i64* %9 monotonic, align 8, !dbg !55
  %10 = ptrtoint %struct.Node* %3 to i64, !dbg !56
  %11 = cmpxchg i64* bitcast (%struct.anon* @TOP to i64*), i64 %6, i64 %10 acq_rel monotonic, align 8, !dbg !56
  %12 = extractvalue { i64, i1 } %11, 0, !dbg !56
  %13 = extractvalue { i64, i1 } %11, 1, !dbg !56
  %14 = zext i1 %13 to i8, !dbg !56
  br i1 %13, label %15, label %5, !dbg !58, !llvm.loop !59

15:                                               ; preds = %5
  ret void, !dbg !61
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @pop() #0 !dbg !62 {
  br label %1, !dbg !65

1:                                                ; preds = %5, %0
  %2 = load atomic i64, i64* bitcast (%struct.anon* @TOP to i64*) acquire, align 8, !dbg !66
  %3 = inttoptr i64 %2 to %struct.Node*, !dbg !66
  call void @llvm.dbg.value(metadata %struct.Node* %3, metadata !68, metadata !DIExpression()), !dbg !69
  %4 = icmp eq %struct.Node* %3, null, !dbg !70
  br i1 %4, label %18, label %5, !dbg !72

5:                                                ; preds = %1
  %6 = getelementptr inbounds %struct.Node, %struct.Node* %3, i32 0, i32 1, !dbg !73
  %7 = bitcast %struct.Node** %6 to i64*, !dbg !75
  %8 = load atomic i64, i64* %7 acquire, align 8, !dbg !75
  %9 = inttoptr i64 %8 to %struct.Node*, !dbg !75
  call void @llvm.dbg.value(metadata %struct.Node* %9, metadata !76, metadata !DIExpression()), !dbg !69
  %10 = cmpxchg i64* bitcast (%struct.anon* @TOP to i64*), i64 %2, i64 %8 acq_rel monotonic, align 8, !dbg !77
  %11 = extractvalue { i64, i1 } %10, 0, !dbg !77
  %12 = extractvalue { i64, i1 } %10, 1, !dbg !77
  %13 = inttoptr i64 %11 to %struct.Node*, !dbg !77
  %.06 = select i1 %12, %struct.Node* %3, %struct.Node* %13, !dbg !77
  call void @llvm.dbg.value(metadata %struct.Node* %.06, metadata !68, metadata !DIExpression()), !dbg !69
  %14 = zext i1 %12 to i8, !dbg !77
  br i1 %12, label %15, label %1, !dbg !79, !llvm.loop !80

15:                                               ; preds = %5
  %16 = getelementptr inbounds %struct.Node, %struct.Node* %.06, i32 0, i32 0, !dbg !82
  %17 = load i32, i32* %16, align 8, !dbg !82
  br label %18, !dbg !83

18:                                               ; preds = %1, %15
  %.0 = phi i32 [ %17, %15 ], [ -1, %1 ], !dbg !69
  ret i32 %.0, !dbg !84
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @worker(i8* noundef %0) #0 !dbg !85 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !89, metadata !DIExpression()), !dbg !90
  %2 = ptrtoint i8* %0 to i64, !dbg !91
  call void @llvm.dbg.value(metadata i64 %2, metadata !92, metadata !DIExpression()), !dbg !90
  %3 = trunc i64 %2 to i32, !dbg !93
  call void @push(i32 noundef %3), !dbg !94
  %4 = call i32 @pop(), !dbg !95
  call void @llvm.dbg.value(metadata i32 %4, metadata !96, metadata !DIExpression()), !dbg !90
  %5 = icmp ne i32 %4, -1, !dbg !97
  br i1 %5, label %7, label %6, !dbg !100

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.1, i64 0, i64 0), i32 noundef 17, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.worker, i64 0, i64 0)) #6, !dbg !97
  unreachable, !dbg !97

7:                                                ; preds = %1
  ret i8* null, !dbg !101
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !102 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !103, metadata !DIExpression()), !dbg !109
  call void @init(), !dbg !110
  call void @llvm.dbg.value(metadata i32 0, metadata !111, metadata !DIExpression()), !dbg !113
  call void @llvm.dbg.value(metadata i64 0, metadata !111, metadata !DIExpression()), !dbg !113
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !114
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef null) #5, !dbg !116
  call void @llvm.dbg.value(metadata i64 1, metadata !111, metadata !DIExpression()), !dbg !113
  call void @llvm.dbg.value(metadata i64 1, metadata !111, metadata !DIExpression()), !dbg !113
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !114
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef inttoptr (i64 1 to i8*)) #5, !dbg !116
  call void @llvm.dbg.value(metadata i64 2, metadata !111, metadata !DIExpression()), !dbg !113
  call void @llvm.dbg.value(metadata i64 2, metadata !111, metadata !DIExpression()), !dbg !113
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !114
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef inttoptr (i64 2 to i8*)) #5, !dbg !116
  call void @llvm.dbg.value(metadata i64 3, metadata !111, metadata !DIExpression()), !dbg !113
  call void @llvm.dbg.value(metadata i64 3, metadata !111, metadata !DIExpression()), !dbg !113
  call void @llvm.dbg.value(metadata i32 0, metadata !117, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.value(metadata i64 0, metadata !117, metadata !DIExpression()), !dbg !119
  %8 = load i64, i64* %2, align 8, !dbg !120
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !122
  call void @llvm.dbg.value(metadata i64 1, metadata !117, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.value(metadata i64 1, metadata !117, metadata !DIExpression()), !dbg !119
  %10 = load i64, i64* %4, align 8, !dbg !120
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !122
  call void @llvm.dbg.value(metadata i64 2, metadata !117, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.value(metadata i64 2, metadata !117, metadata !DIExpression()), !dbg !119
  %12 = load i64, i64* %6, align 8, !dbg !120
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !122
  call void @llvm.dbg.value(metadata i64 3, metadata !117, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.value(metadata i64 3, metadata !117, metadata !DIExpression()), !dbg !119
  %14 = call i32 @pop(), !dbg !123
  call void @llvm.dbg.value(metadata i32 %14, metadata !124, metadata !DIExpression()), !dbg !125
  %15 = icmp eq i32 %14, -1, !dbg !126
  br i1 %15, label %17, label %16, !dbg !129

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.1, i64 0, i64 0), i32 noundef 35, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !126
  unreachable, !dbg !126

17:                                               ; preds = %0
  ret i32 0, !dbg !130
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
!llvm.module.flags = !{!27, !28, !29, !30, !31, !32, !33}
!llvm.ident = !{!34}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "TOP", scope: !2, file: !13, line: 19, type: !14, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !12, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lfds/treiber.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "6374e26f9e48e84c9da108eff1ccfc9b")
!4 = !{!5, !6, !9}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !7, line: 87, baseType: !8)
!7 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!8 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !10, line: 46, baseType: !11)
!10 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!11 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!12 = !{!0}
!13 = !DIFile(filename: "benchmarks/lfds/treiber.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "a4031056245a21941de5af4b4e486aa2")
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !13, line: 17, size: 64, elements: !15)
!15 = !{!16}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "node", scope: !14, file: !13, line: 18, baseType: !17, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !18)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "Node", file: !13, line: 15, baseType: !20)
!20 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Node", file: !13, line: 12, size: 128, elements: !21)
!21 = !{!22, !24}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "val", scope: !20, file: !13, line: 13, baseType: !23, size: 32)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !20, file: !13, line: 14, baseType: !25, size: 64, offset: 64)
!25 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !26)
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!27 = !{i32 7, !"Dwarf Version", i32 5}
!28 = !{i32 2, !"Debug Info Version", i32 3}
!29 = !{i32 1, !"wchar_size", i32 4}
!30 = !{i32 7, !"PIC Level", i32 2}
!31 = !{i32 7, !"PIE Level", i32 2}
!32 = !{i32 7, !"uwtable", i32 1}
!33 = !{i32 7, !"frame-pointer", i32 2}
!34 = !{!"Ubuntu clang version 14.0.6"}
!35 = distinct !DISubprogram(name: "init", scope: !13, file: !13, line: 21, type: !36, scopeLine: 21, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !38)
!36 = !DISubroutineType(types: !37)
!37 = !{null}
!38 = !{}
!39 = !DILocation(line: 22, column: 5, scope: !35)
!40 = !DILocation(line: 23, column: 1, scope: !35)
!41 = distinct !DISubprogram(name: "push", scope: !13, file: !13, line: 25, type: !42, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !38)
!42 = !DISubroutineType(types: !43)
!43 = !{null, !23}
!44 = !DILocalVariable(name: "e", arg: 1, scope: !41, file: !13, line: 25, type: !23)
!45 = !DILocation(line: 0, scope: !41)
!46 = !DILocation(line: 27, column: 9, scope: !41)
!47 = !DILocalVariable(name: "y", scope: !41, file: !13, line: 26, type: !18)
!48 = !DILocation(line: 28, column: 8, scope: !41)
!49 = !DILocation(line: 28, column: 12, scope: !41)
!50 = !DILocation(line: 30, column: 5, scope: !41)
!51 = !DILocation(line: 31, column: 13, scope: !52)
!52 = distinct !DILexicalBlock(scope: !41, file: !13, line: 30, column: 14)
!53 = !DILocalVariable(name: "n", scope: !41, file: !13, line: 26, type: !18)
!54 = !DILocation(line: 32, column: 35, scope: !52)
!55 = !DILocation(line: 32, column: 9, scope: !52)
!56 = !DILocation(line: 34, column: 13, scope: !57)
!57 = distinct !DILexicalBlock(scope: !52, file: !13, line: 34, column: 13)
!58 = !DILocation(line: 34, column: 13, scope: !52)
!59 = distinct !{!59, !50, !60}
!60 = !DILocation(line: 37, column: 5, scope: !41)
!61 = !DILocation(line: 38, column: 1, scope: !41)
!62 = distinct !DISubprogram(name: "pop", scope: !13, file: !13, line: 40, type: !63, scopeLine: 40, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !38)
!63 = !DISubroutineType(types: !64)
!64 = !{!23}
!65 = !DILocation(line: 43, column: 5, scope: !62)
!66 = !DILocation(line: 44, column: 13, scope: !67)
!67 = distinct !DILexicalBlock(scope: !62, file: !13, line: 43, column: 15)
!68 = !DILocalVariable(name: "y", scope: !62, file: !13, line: 41, type: !18)
!69 = !DILocation(line: 0, scope: !62)
!70 = !DILocation(line: 45, column: 15, scope: !71)
!71 = distinct !DILexicalBlock(scope: !67, file: !13, line: 45, column: 13)
!72 = !DILocation(line: 45, column: 13, scope: !67)
!73 = !DILocation(line: 48, column: 42, scope: !74)
!74 = distinct !DILexicalBlock(scope: !71, file: !13, line: 47, column: 16)
!75 = !DILocation(line: 48, column: 17, scope: !74)
!76 = !DILocalVariable(name: "z", scope: !62, file: !13, line: 41, type: !18)
!77 = !DILocation(line: 49, column: 17, scope: !78)
!78 = distinct !DILexicalBlock(scope: !74, file: !13, line: 49, column: 17)
!79 = !DILocation(line: 49, column: 17, scope: !74)
!80 = distinct !{!80, !65, !81}
!81 = !DILocation(line: 54, column: 5, scope: !62)
!82 = !DILocation(line: 55, column: 15, scope: !62)
!83 = !DILocation(line: 55, column: 5, scope: !62)
!84 = !DILocation(line: 56, column: 1, scope: !62)
!85 = distinct !DISubprogram(name: "worker", scope: !86, file: !86, line: 9, type: !87, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !38)
!86 = !DIFile(filename: "benchmarks/lfds/treiber.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "6374e26f9e48e84c9da108eff1ccfc9b")
!87 = !DISubroutineType(types: !88)
!88 = !{!5, !5}
!89 = !DILocalVariable(name: "arg", arg: 1, scope: !85, file: !86, line: 9, type: !5)
!90 = !DILocation(line: 0, scope: !85)
!91 = !DILocation(line: 12, column: 23, scope: !85)
!92 = !DILocalVariable(name: "index", scope: !85, file: !86, line: 12, type: !6)
!93 = !DILocation(line: 14, column: 7, scope: !85)
!94 = !DILocation(line: 14, column: 2, scope: !85)
!95 = !DILocation(line: 15, column: 13, scope: !85)
!96 = !DILocalVariable(name: "r", scope: !85, file: !86, line: 15, type: !23)
!97 = !DILocation(line: 17, column: 2, scope: !98)
!98 = distinct !DILexicalBlock(scope: !99, file: !86, line: 17, column: 2)
!99 = distinct !DILexicalBlock(scope: !85, file: !86, line: 17, column: 2)
!100 = !DILocation(line: 17, column: 2, scope: !99)
!101 = !DILocation(line: 19, column: 2, scope: !85)
!102 = distinct !DISubprogram(name: "main", scope: !86, file: !86, line: 22, type: !63, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !38)
!103 = !DILocalVariable(name: "t", scope: !102, file: !86, line: 24, type: !104)
!104 = !DICompositeType(tag: DW_TAG_array_type, baseType: !105, size: 192, elements: !107)
!105 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !106, line: 27, baseType: !11)
!106 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!107 = !{!108}
!108 = !DISubrange(count: 3)
!109 = !DILocation(line: 24, column: 15, scope: !102)
!110 = !DILocation(line: 26, column: 5, scope: !102)
!111 = !DILocalVariable(name: "i", scope: !112, file: !86, line: 28, type: !23)
!112 = distinct !DILexicalBlock(scope: !102, file: !86, line: 28, column: 5)
!113 = !DILocation(line: 0, scope: !112)
!114 = !DILocation(line: 29, column: 25, scope: !115)
!115 = distinct !DILexicalBlock(scope: !112, file: !86, line: 28, column: 5)
!116 = !DILocation(line: 29, column: 9, scope: !115)
!117 = !DILocalVariable(name: "i", scope: !118, file: !86, line: 31, type: !23)
!118 = distinct !DILexicalBlock(scope: !102, file: !86, line: 31, column: 5)
!119 = !DILocation(line: 0, scope: !118)
!120 = !DILocation(line: 32, column: 22, scope: !121)
!121 = distinct !DILexicalBlock(scope: !118, file: !86, line: 31, column: 5)
!122 = !DILocation(line: 32, column: 9, scope: !121)
!123 = !DILocation(line: 34, column: 13, scope: !102)
!124 = !DILocalVariable(name: "r", scope: !102, file: !86, line: 34, type: !23)
!125 = !DILocation(line: 0, scope: !102)
!126 = !DILocation(line: 35, column: 5, scope: !127)
!127 = distinct !DILexicalBlock(scope: !128, file: !86, line: 35, column: 5)
!128 = distinct !DILexicalBlock(scope: !102, file: !86, line: 35, column: 5)
!129 = !DILocation(line: 35, column: 5, scope: !128)
!130 = !DILocation(line: 37, column: 5, scope: !102)
