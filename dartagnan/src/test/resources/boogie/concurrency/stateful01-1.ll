; ModuleID = '/home/ponce/git/Dat3M/output/stateful01-1.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread/stateful01-1.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, %union.anon }
%union.anon = type { %struct.__pthread_internal_slist }
%struct.__pthread_internal_slist = type { %struct.__pthread_internal_slist* }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [15 x i8] c"stateful01-1.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@ma = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !0
@data1 = dso_local global i32 0, align 4, !dbg !43
@data2 = dso_local global i32 0, align 4, !dbg !45
@mb = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !5

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !55 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.1, i64 0, i64 0), i32 noundef 3, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #7, !dbg !59
  unreachable, !dbg !59
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread1(i8* noundef %0) #0 !dbg !62 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !66, metadata !DIExpression()), !dbg !67
  %2 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @ma) #8, !dbg !68
  %3 = load i32, i32* @data1, align 4, !dbg !69
  %4 = add nsw i32 %3, 1, !dbg !69
  store i32 %4, i32* @data1, align 4, !dbg !69
  %5 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @ma) #8, !dbg !70
  %6 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @ma) #8, !dbg !71
  %7 = load i32, i32* @data2, align 4, !dbg !72
  %8 = add nsw i32 %7, 1, !dbg !72
  store i32 %8, i32* @data2, align 4, !dbg !72
  %9 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @ma) #8, !dbg !73
  ret i8* null, !dbg !74
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread2(i8* noundef %0) #0 !dbg !75 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !76, metadata !DIExpression()), !dbg !77
  %2 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @ma) #8, !dbg !78
  %3 = load i32, i32* @data1, align 4, !dbg !79
  %4 = add nsw i32 %3, 5, !dbg !79
  store i32 %4, i32* @data1, align 4, !dbg !79
  %5 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @ma) #8, !dbg !80
  %6 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @ma) #8, !dbg !81
  %7 = load i32, i32* @data2, align 4, !dbg !82
  %8 = add nsw i32 %7, -6, !dbg !82
  store i32 %8, i32* @data2, align 4, !dbg !82
  %9 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @ma) #8, !dbg !83
  ret i8* null, !dbg !84
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !85 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef nonnull @ma, %union.pthread_mutexattr_t* noundef null) #9, !dbg !88
  %4 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef nonnull @mb, %union.pthread_mutexattr_t* noundef null) #9, !dbg !89
  store i32 10, i32* @data1, align 4, !dbg !90
  store i32 10, i32* @data2, align 4, !dbg !91
  call void @llvm.dbg.value(metadata i64* %1, metadata !92, metadata !DIExpression(DW_OP_deref)), !dbg !95
  %5 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread1, i8* noundef null) #8, !dbg !96
  call void @llvm.dbg.value(metadata i64* %2, metadata !97, metadata !DIExpression(DW_OP_deref)), !dbg !95
  %6 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread2, i8* noundef null) #8, !dbg !98
  %7 = load i64, i64* %1, align 8, !dbg !99
  call void @llvm.dbg.value(metadata i64 %7, metadata !92, metadata !DIExpression()), !dbg !95
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null) #8, !dbg !100
  %9 = load i64, i64* %2, align 8, !dbg !101
  call void @llvm.dbg.value(metadata i64 %9, metadata !97, metadata !DIExpression()), !dbg !95
  %10 = call i32 @pthread_join(i64 noundef %9, i8** noundef null) #8, !dbg !102
  %11 = load i32, i32* @data1, align 4, !dbg !103
  %12 = icmp eq i32 %11, 16, !dbg !105
  %13 = load i32, i32* @data2, align 4
  %14 = icmp eq i32 %13, 5
  %or.cond = select i1 %12, i1 %14, i1 false, !dbg !106
  br i1 %or.cond, label %15, label %16, !dbg !106

15:                                               ; preds = %0
  call void @llvm.dbg.label(metadata !107), !dbg !109
  call void @reach_error(), !dbg !110
  call void @abort() #10, !dbg !112
  unreachable, !dbg !112

16:                                               ; preds = %0
  ret i32 0, !dbg !113
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #4

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #5

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #2

; Function Attrs: noreturn
declare void @abort() #6

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nocallback nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { nocallback noreturn nounwind }
attributes #8 = { nounwind }
attributes #9 = { nocallback nounwind }
attributes #10 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!47, !48, !49, !50, !51, !52, !53}
!llvm.ident = !{!54}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "ma", scope: !2, file: !7, line: 692, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread/stateful01-1.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "8f609d8ad0383d7dbf910b2c2b108c6c")
!4 = !{!0, !5, !43, !45}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "mb", scope: !2, file: !7, line: 692, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "../sv-benchmarks/c/pthread/stateful01-1.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "8f609d8ad0383d7dbf910b2c2b108c6c")
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
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(name: "data1", scope: !2, file: !7, line: 693, type: !15, isLocal: false, isDefinition: true)
!45 = !DIGlobalVariableExpression(var: !46, expr: !DIExpression())
!46 = distinct !DIGlobalVariable(name: "data2", scope: !2, file: !7, line: 693, type: !15, isLocal: false, isDefinition: true)
!47 = !{i32 7, !"Dwarf Version", i32 5}
!48 = !{i32 2, !"Debug Info Version", i32 3}
!49 = !{i32 1, !"wchar_size", i32 4}
!50 = !{i32 7, !"PIC Level", i32 2}
!51 = !{i32 7, !"PIE Level", i32 2}
!52 = !{i32 7, !"uwtable", i32 1}
!53 = !{i32 7, !"frame-pointer", i32 2}
!54 = !{!"Ubuntu clang version 14.0.6"}
!55 = distinct !DISubprogram(name: "reach_error", scope: !7, file: !7, line: 20, type: !56, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!56 = !DISubroutineType(types: !57)
!57 = !{null}
!58 = !{}
!59 = !DILocation(line: 20, column: 83, scope: !60)
!60 = distinct !DILexicalBlock(scope: !61, file: !7, line: 20, column: 73)
!61 = distinct !DILexicalBlock(scope: !55, file: !7, line: 20, column: 67)
!62 = distinct !DISubprogram(name: "thread1", scope: !7, file: !7, line: 694, type: !63, scopeLine: 695, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!63 = !DISubroutineType(types: !64)
!64 = !{!65, !65}
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!66 = !DILocalVariable(name: "arg", arg: 1, scope: !62, file: !7, line: 694, type: !65)
!67 = !DILocation(line: 0, scope: !62)
!68 = !DILocation(line: 696, column: 3, scope: !62)
!69 = !DILocation(line: 697, column: 8, scope: !62)
!70 = !DILocation(line: 698, column: 3, scope: !62)
!71 = !DILocation(line: 699, column: 3, scope: !62)
!72 = !DILocation(line: 700, column: 8, scope: !62)
!73 = !DILocation(line: 701, column: 3, scope: !62)
!74 = !DILocation(line: 702, column: 3, scope: !62)
!75 = distinct !DISubprogram(name: "thread2", scope: !7, file: !7, line: 704, type: !63, scopeLine: 705, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!76 = !DILocalVariable(name: "arg", arg: 1, scope: !75, file: !7, line: 704, type: !65)
!77 = !DILocation(line: 0, scope: !75)
!78 = !DILocation(line: 706, column: 3, scope: !75)
!79 = !DILocation(line: 707, column: 8, scope: !75)
!80 = !DILocation(line: 708, column: 3, scope: !75)
!81 = !DILocation(line: 709, column: 3, scope: !75)
!82 = !DILocation(line: 710, column: 8, scope: !75)
!83 = !DILocation(line: 711, column: 3, scope: !75)
!84 = !DILocation(line: 712, column: 3, scope: !75)
!85 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 714, type: !86, scopeLine: 715, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!86 = !DISubroutineType(types: !87)
!87 = !{!15}
!88 = !DILocation(line: 717, column: 3, scope: !85)
!89 = !DILocation(line: 718, column: 3, scope: !85)
!90 = !DILocation(line: 719, column: 9, scope: !85)
!91 = !DILocation(line: 720, column: 9, scope: !85)
!92 = !DILocalVariable(name: "t1", scope: !85, file: !7, line: 716, type: !93)
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !7, line: 288, baseType: !94)
!94 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!95 = !DILocation(line: 0, scope: !85)
!96 = !DILocation(line: 721, column: 3, scope: !85)
!97 = !DILocalVariable(name: "t2", scope: !85, file: !7, line: 716, type: !93)
!98 = !DILocation(line: 722, column: 3, scope: !85)
!99 = !DILocation(line: 723, column: 16, scope: !85)
!100 = !DILocation(line: 723, column: 3, scope: !85)
!101 = !DILocation(line: 724, column: 16, scope: !85)
!102 = !DILocation(line: 724, column: 3, scope: !85)
!103 = !DILocation(line: 725, column: 7, scope: !104)
!104 = distinct !DILexicalBlock(scope: !85, file: !7, line: 725, column: 7)
!105 = !DILocation(line: 725, column: 12, scope: !104)
!106 = !DILocation(line: 725, column: 17, scope: !104)
!107 = !DILabel(scope: !108, name: "ERROR", file: !7, line: 727)
!108 = distinct !DILexicalBlock(scope: !104, file: !7, line: 726, column: 3)
!109 = !DILocation(line: 727, column: 5, scope: !108)
!110 = !DILocation(line: 727, column: 13, scope: !111)
!111 = distinct !DILexicalBlock(scope: !108, file: !7, line: 727, column: 12)
!112 = !DILocation(line: 727, column: 27, scope: !111)
!113 = !DILocation(line: 730, column: 3, scope: !85)
