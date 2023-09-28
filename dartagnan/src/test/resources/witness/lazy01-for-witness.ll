; ModuleID = '/home/ponce/git/Dat3M/output/lazy01.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread/lazy01.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, %union.anon }
%union.anon = type { %struct.__pthread_internal_slist }
%struct.__pthread_internal_slist = type { %struct.__pthread_internal_slist* }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"lazy01.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@data = dso_local global i32 0, align 4, !dbg !0
@mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !5

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !51 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i64 0, i64 0), i32 noundef 3, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #7, !dbg !55
  unreachable, !dbg !55
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread1(i8* noundef %0) #0 !dbg !58 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !62, metadata !DIExpression()), !dbg !63
  %2 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef @mutex) #8, !dbg !64
  %3 = load i32, i32* @data, align 4, !dbg !65
  %4 = add nsw i32 %3, 1, !dbg !65
  store i32 %4, i32* @data, align 4, !dbg !65
  %5 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef @mutex) #8, !dbg !66
  ret i8* null, !dbg !67
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread2(i8* noundef %0) #0 !dbg !68 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !69, metadata !DIExpression()), !dbg !70
  %2 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef @mutex) #8, !dbg !71
  %3 = load i32, i32* @data, align 4, !dbg !72
  %4 = add nsw i32 %3, 2, !dbg !72
  store i32 %4, i32* @data, align 4, !dbg !72
  %5 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef @mutex) #8, !dbg !73
  ret i8* null, !dbg !74
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread3(i8* noundef %0) #0 !dbg !75 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !76, metadata !DIExpression()), !dbg !77
  %2 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef @mutex) #8, !dbg !78
  %3 = load i32, i32* @data, align 4, !dbg !79
  %4 = icmp sge i32 %3, 3, !dbg !81
  br i1 %4, label %5, label %6, !dbg !82

5:                                                ; preds = %1
  call void @llvm.dbg.label(metadata !83), !dbg !85
  call void @reach_error(), !dbg !86
  call void @abort() #9, !dbg !88
  unreachable, !dbg !88

6:                                                ; preds = %1
  %7 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef @mutex) #8, !dbg !89
  ret i8* null, !dbg !90
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #2

; Function Attrs: noreturn
declare void @abort() #4

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !91 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef @mutex, %union.pthread_mutexattr_t* noundef null) #10, !dbg !94
  call void @llvm.dbg.declare(metadata i64* %1, metadata !95, metadata !DIExpression()), !dbg !98
  call void @llvm.dbg.declare(metadata i64* %2, metadata !99, metadata !DIExpression()), !dbg !100
  call void @llvm.dbg.declare(metadata i64* %3, metadata !101, metadata !DIExpression()), !dbg !102
  %5 = call i32 @pthread_create(i64* noundef %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread1, i8* noundef null) #8, !dbg !103
  %6 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread2, i8* noundef null) #8, !dbg !104
  %7 = call i32 @pthread_create(i64* noundef %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread3, i8* noundef null) #8, !dbg !105
  %8 = load i64, i64* %1, align 8, !dbg !106
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !107
  %10 = load i64, i64* %2, align 8, !dbg !108
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !109
  %12 = load i64, i64* %3, align 8, !dbg !110
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !111
  ret i32 0, !dbg !112
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #5

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #6

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nocallback nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { nocallback noreturn nounwind }
attributes #8 = { nounwind }
attributes #9 = { noreturn }
attributes #10 = { nocallback nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!43, !44, !45, !46, !47, !48, !49}
!llvm.ident = !{!50}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !7, line: 703, type: !15, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread/lazy01.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "82c405c2d7b237b2297380ee8685b7d8")
!4 = !{!0, !5}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !7, line: 702, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "../sv-benchmarks/c/pthread/lazy01.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "82c405c2d7b237b2297380ee8685b7d8")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !7, line: 312, baseType: !9)
!9 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !7, line: 307, size: 256, elements: !10)
!10 = !{!11, !36, !41}
!11 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !9, file: !7, line: 309, baseType: !12, size: 256)
!12 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !7, line: 247, size: 256, elements: !13)
!13 = !{!14, !16, !18, !19, !20, !21}
!14 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !12, file: !7, line: 249, baseType: !15, size: 32)
!15 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !12, file: !7, line: 250, baseType: !17, size: 32, offset: 32)
!17 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !12, file: !7, line: 251, baseType: !15, size: 32, offset: 64)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !12, file: !7, line: 252, baseType: !15, size: 32, offset: 96)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !12, file: !7, line: 254, baseType: !17, size: 32, offset: 128)
!21 = !DIDerivedType(tag: DW_TAG_member, scope: !12, file: !7, line: 255, baseType: !22, size: 64, offset: 192)
!22 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !12, file: !7, line: 255, size: 64, elements: !23)
!23 = !{!24, !30}
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__elision_data", scope: !22, file: !7, line: 257, baseType: !25, size: 32)
!25 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !22, file: !7, line: 257, size: 32, elements: !26)
!26 = !{!27, !29}
!27 = !DIDerivedType(tag: DW_TAG_member, name: "__espins", scope: !25, file: !7, line: 257, baseType: !28, size: 16)
!28 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "__eelision", scope: !25, file: !7, line: 257, baseType: !28, size: 16, offset: 16)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !22, file: !7, line: 258, baseType: !31, size: 64)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_slist_t", file: !7, line: 246, baseType: !32)
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_slist", file: !7, line: 243, size: 64, elements: !33)
!33 = !{!34}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !32, file: !7, line: 245, baseType: !35, size: 64)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !9, file: !7, line: 310, baseType: !37, size: 192)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 192, elements: !39)
!38 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!39 = !{!40}
!40 = !DISubrange(count: 24)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !9, file: !7, line: 311, baseType: !42, size: 64)
!42 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!43 = !{i32 7, !"Dwarf Version", i32 5}
!44 = !{i32 2, !"Debug Info Version", i32 3}
!45 = !{i32 1, !"wchar_size", i32 4}
!46 = !{i32 7, !"PIC Level", i32 2}
!47 = !{i32 7, !"PIE Level", i32 2}
!48 = !{i32 7, !"uwtable", i32 1}
!49 = !{i32 7, !"frame-pointer", i32 2}
!50 = !{!"Ubuntu clang version 14.0.6"}
!51 = distinct !DISubprogram(name: "reach_error", scope: !7, file: !7, line: 20, type: !52, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!52 = !DISubroutineType(types: !53)
!53 = !{null}
!54 = !{}
!55 = !DILocation(line: 20, column: 83, scope: !56)
!56 = distinct !DILexicalBlock(scope: !57, file: !7, line: 20, column: 73)
!57 = distinct !DILexicalBlock(scope: !51, file: !7, line: 20, column: 67)
!58 = distinct !DISubprogram(name: "thread1", scope: !7, file: !7, line: 704, type: !59, scopeLine: 705, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!59 = !DISubroutineType(types: !60)
!60 = !{!61, !61}
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!62 = !DILocalVariable(name: "arg", arg: 1, scope: !58, file: !7, line: 704, type: !61)
!63 = !DILocation(line: 0, scope: !58)
!64 = !DILocation(line: 706, column: 3, scope: !58)
!65 = !DILocation(line: 707, column: 7, scope: !58)
!66 = !DILocation(line: 708, column: 3, scope: !58)
!67 = !DILocation(line: 709, column: 3, scope: !58)
!68 = distinct !DISubprogram(name: "thread2", scope: !7, file: !7, line: 711, type: !59, scopeLine: 712, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!69 = !DILocalVariable(name: "arg", arg: 1, scope: !68, file: !7, line: 711, type: !61)
!70 = !DILocation(line: 0, scope: !68)
!71 = !DILocation(line: 713, column: 3, scope: !68)
!72 = !DILocation(line: 714, column: 7, scope: !68)
!73 = !DILocation(line: 715, column: 3, scope: !68)
!74 = !DILocation(line: 716, column: 3, scope: !68)
!75 = distinct !DISubprogram(name: "thread3", scope: !7, file: !7, line: 718, type: !59, scopeLine: 719, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!76 = !DILocalVariable(name: "arg", arg: 1, scope: !75, file: !7, line: 718, type: !61)
!77 = !DILocation(line: 0, scope: !75)
!78 = !DILocation(line: 720, column: 3, scope: !75)
!79 = !DILocation(line: 721, column: 7, scope: !80)
!80 = distinct !DILexicalBlock(scope: !75, file: !7, line: 721, column: 7)
!81 = !DILocation(line: 721, column: 12, scope: !80)
!82 = !DILocation(line: 721, column: 7, scope: !75)
!83 = !DILabel(scope: !84, name: "ERROR", file: !7, line: 722)
!84 = distinct !DILexicalBlock(scope: !80, file: !7, line: 721, column: 17)
!85 = !DILocation(line: 722, column: 5, scope: !84)
!86 = !DILocation(line: 722, column: 13, scope: !87)
!87 = distinct !DILexicalBlock(scope: !84, file: !7, line: 722, column: 12)
!88 = !DILocation(line: 722, column: 27, scope: !87)
!89 = !DILocation(line: 725, column: 3, scope: !75)
!90 = !DILocation(line: 726, column: 3, scope: !75)
!91 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 728, type: !92, scopeLine: 729, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!92 = !DISubroutineType(types: !93)
!93 = !{!15}
!94 = !DILocation(line: 730, column: 3, scope: !91)
!95 = !DILocalVariable(name: "t1", scope: !91, file: !7, line: 731, type: !96)
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !7, line: 288, baseType: !97)
!97 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!98 = !DILocation(line: 731, column: 13, scope: !91)
!99 = !DILocalVariable(name: "t2", scope: !91, file: !7, line: 731, type: !96)
!100 = !DILocation(line: 731, column: 17, scope: !91)
!101 = !DILocalVariable(name: "t3", scope: !91, file: !7, line: 731, type: !96)
!102 = !DILocation(line: 731, column: 21, scope: !91)
!103 = !DILocation(line: 732, column: 3, scope: !91)
!104 = !DILocation(line: 733, column: 3, scope: !91)
!105 = !DILocation(line: 734, column: 3, scope: !91)
!106 = !DILocation(line: 735, column: 16, scope: !91)
!107 = !DILocation(line: 735, column: 3, scope: !91)
!108 = !DILocation(line: 736, column: 16, scope: !91)
!109 = !DILocation(line: 736, column: 3, scope: !91)
!110 = !DILocation(line: 737, column: 16, scope: !91)
!111 = !DILocation(line: 737, column: 3, scope: !91)
!112 = !DILocation(line: 738, column: 3, scope: !91)
