; ModuleID = '/home/ponce/git/Dat3M/output/time_var_mutex.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-atomic/time_var_mutex.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, %union.anon }
%union.anon = type { %struct.__pthread_internal_slist }
%struct.__pthread_internal_slist = type { %struct.__pthread_internal_slist* }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [17 x i8] c"time_var_mutex.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@m_inode = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !0
@inode = dso_local global i32 0, align 4, !dbg !13
@m_busy = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !15
@busy = dso_local global i32 0, align 4, !dbg !11
@block = dso_local global i32 0, align 4, !dbg !7

; Function Attrs: noinline nounwind uwtable
define dso_local void @assume_abort_if_not(i32 noundef %0) #0 !dbg !59 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !63, metadata !DIExpression()), !dbg !64
  %.not = icmp eq i32 %0, 0, !dbg !65
  br i1 %.not, label %2, label %3, !dbg !67

2:                                                ; preds = %1
  call void @abort() #7, !dbg !68
  unreachable, !dbg !68

3:                                                ; preds = %1
  ret void, !dbg !70
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noreturn
declare void @abort() #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !71 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.1, i64 0, i64 0), i32 noundef 7, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #8, !dbg !74
  unreachable, !dbg !74
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @allocator(i8* noundef %0) #0 !dbg !77 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !80, metadata !DIExpression()), !dbg !81
  %2 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @m_inode) #9, !dbg !82
  %3 = load i32, i32* @inode, align 4, !dbg !83
  %4 = icmp eq i32 %3, 0, !dbg !85
  br i1 %4, label %5, label %8, !dbg !86

5:                                                ; preds = %1
  %6 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @m_busy) #9, !dbg !87
  store i32 1, i32* @busy, align 4, !dbg !89
  %7 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @m_busy) #9, !dbg !90
  store i32 1, i32* @inode, align 4, !dbg !91
  br label %8, !dbg !92

8:                                                ; preds = %5, %1
  store i32 1, i32* @block, align 4, !dbg !93
  %9 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @m_inode) #9, !dbg !94
  ret i8* null, !dbg !95
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #4

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @de_allocator(i8* noundef %0) #0 !dbg !96 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !97, metadata !DIExpression()), !dbg !98
  %2 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @m_busy) #9, !dbg !99
  %3 = load i32, i32* @busy, align 4, !dbg !100
  %4 = icmp eq i32 %3, 0, !dbg !102
  br i1 %4, label %5, label %6, !dbg !103

5:                                                ; preds = %1
  store i32 0, i32* @block, align 4, !dbg !104
  br label %6, !dbg !106

6:                                                ; preds = %5, %1
  %7 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @m_busy) #9, !dbg !107
  ret i8* null, !dbg !108
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !109 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = load i32, i32* @inode, align 4, !dbg !112
  %4 = load i32, i32* @busy, align 4, !dbg !113
  %5 = icmp eq i32 %3, %4, !dbg !114
  %6 = zext i1 %5 to i32, !dbg !114
  call void @assume_abort_if_not(i32 noundef %6), !dbg !115
  %7 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef nonnull @m_inode, %union.pthread_mutexattr_t* noundef null) #10, !dbg !116
  %8 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef nonnull @m_busy, %union.pthread_mutexattr_t* noundef null) #10, !dbg !117
  call void @llvm.dbg.value(metadata i64* %1, metadata !118, metadata !DIExpression(DW_OP_deref)), !dbg !121
  %9 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @allocator, i8* noundef null) #9, !dbg !122
  call void @llvm.dbg.value(metadata i64* %2, metadata !123, metadata !DIExpression(DW_OP_deref)), !dbg !121
  %10 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @de_allocator, i8* noundef null) #9, !dbg !124
  %11 = load i64, i64* %1, align 8, !dbg !125
  call void @llvm.dbg.value(metadata i64 %11, metadata !118, metadata !DIExpression()), !dbg !121
  %12 = call i32 @pthread_join(i64 noundef %11, i8** noundef null) #9, !dbg !126
  %13 = load i64, i64* %2, align 8, !dbg !127
  call void @llvm.dbg.value(metadata i64 %13, metadata !123, metadata !DIExpression()), !dbg !121
  %14 = call i32 @pthread_join(i64 noundef %13, i8** noundef null) #9, !dbg !128
  %15 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef nonnull @m_inode) #10, !dbg !129
  %16 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef nonnull @m_busy) #10, !dbg !130
  ret i32 0, !dbg !131
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #5

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #4

declare i32 @pthread_join(i64 noundef, i8** noundef) #6

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef) #5

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nocallback nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { noreturn nounwind }
attributes #8 = { nocallback noreturn nounwind }
attributes #9 = { nounwind }
attributes #10 = { nocallback nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!51, !52, !53, !54, !55, !56, !57}
!llvm.ident = !{!58}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "m_inode", scope: !2, file: !9, line: 691, type: !17, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-atomic/time_var_mutex.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "64dca4a0c2daca2ca1f955af8b428f35")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !11, !13, !0, !15}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "block", scope: !2, file: !9, line: 688, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "../sv-benchmarks/c/pthread-atomic/time_var_mutex.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "64dca4a0c2daca2ca1f955af8b428f35")
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "busy", scope: !2, file: !9, line: 689, type: !10, isLocal: false, isDefinition: true)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(name: "inode", scope: !2, file: !9, line: 690, type: !10, isLocal: false, isDefinition: true)
!15 = !DIGlobalVariableExpression(var: !16, expr: !DIExpression())
!16 = distinct !DIGlobalVariable(name: "m_busy", scope: !2, file: !9, line: 692, type: !17, isLocal: false, isDefinition: true)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !9, line: 308, baseType: !18)
!18 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !9, line: 303, size: 256, elements: !19)
!19 = !{!20, !44, !49}
!20 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !18, file: !9, line: 305, baseType: !21, size: 256)
!21 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !9, line: 243, size: 256, elements: !22)
!22 = !{!23, !24, !26, !27, !28, !29}
!23 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !21, file: !9, line: 245, baseType: !10, size: 32)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !21, file: !9, line: 246, baseType: !25, size: 32, offset: 32)
!25 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !21, file: !9, line: 247, baseType: !10, size: 32, offset: 64)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !21, file: !9, line: 248, baseType: !10, size: 32, offset: 96)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !21, file: !9, line: 250, baseType: !25, size: 32, offset: 128)
!29 = !DIDerivedType(tag: DW_TAG_member, scope: !21, file: !9, line: 251, baseType: !30, size: 64, offset: 192)
!30 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !21, file: !9, line: 251, size: 64, elements: !31)
!31 = !{!32, !38}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "__elision_data", scope: !30, file: !9, line: 253, baseType: !33, size: 32)
!33 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !30, file: !9, line: 253, size: 32, elements: !34)
!34 = !{!35, !37}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__espins", scope: !33, file: !9, line: 253, baseType: !36, size: 16)
!36 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "__eelision", scope: !33, file: !9, line: 253, baseType: !36, size: 16, offset: 16)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !30, file: !9, line: 254, baseType: !39, size: 64)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_slist_t", file: !9, line: 242, baseType: !40)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_slist", file: !9, line: 239, size: 64, elements: !41)
!41 = !{!42}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !40, file: !9, line: 241, baseType: !43, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !18, file: !9, line: 306, baseType: !45, size: 192)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 192, elements: !47)
!46 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!47 = !{!48}
!48 = !DISubrange(count: 24)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !18, file: !9, line: 307, baseType: !50, size: 64)
!50 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!51 = !{i32 7, !"Dwarf Version", i32 5}
!52 = !{i32 2, !"Debug Info Version", i32 3}
!53 = !{i32 1, !"wchar_size", i32 4}
!54 = !{i32 7, !"PIC Level", i32 2}
!55 = !{i32 7, !"PIE Level", i32 2}
!56 = !{i32 7, !"uwtable", i32 1}
!57 = !{i32 7, !"frame-pointer", i32 2}
!58 = !{!"Ubuntu clang version 14.0.6"}
!59 = distinct !DISubprogram(name: "assume_abort_if_not", scope: !9, file: !9, line: 2, type: !60, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!60 = !DISubroutineType(types: !61)
!61 = !{null, !10}
!62 = !{}
!63 = !DILocalVariable(name: "cond", arg: 1, scope: !59, file: !9, line: 2, type: !10)
!64 = !DILocation(line: 0, scope: !59)
!65 = !DILocation(line: 3, column: 7, scope: !66)
!66 = distinct !DILexicalBlock(scope: !59, file: !9, line: 3, column: 6)
!67 = !DILocation(line: 3, column: 6, scope: !59)
!68 = !DILocation(line: 3, column: 14, scope: !69)
!69 = distinct !DILexicalBlock(scope: !66, file: !9, line: 3, column: 13)
!70 = !DILocation(line: 4, column: 1, scope: !59)
!71 = distinct !DISubprogram(name: "reach_error", scope: !9, file: !9, line: 16, type: !72, scopeLine: 16, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!72 = !DISubroutineType(types: !73)
!73 = !{null}
!74 = !DILocation(line: 16, column: 83, scope: !75)
!75 = distinct !DILexicalBlock(scope: !76, file: !9, line: 16, column: 73)
!76 = distinct !DILexicalBlock(scope: !71, file: !9, line: 16, column: 67)
!77 = distinct !DISubprogram(name: "allocator", scope: !9, file: !9, line: 693, type: !78, scopeLine: 693, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!78 = !DISubroutineType(types: !79)
!79 = !{!5, !5}
!80 = !DILocalVariable(name: "_", arg: 1, scope: !77, file: !9, line: 693, type: !5)
!81 = !DILocation(line: 0, scope: !77)
!82 = !DILocation(line: 694, column: 3, scope: !77)
!83 = !DILocation(line: 695, column: 6, scope: !84)
!84 = distinct !DILexicalBlock(scope: !77, file: !9, line: 695, column: 6)
!85 = !DILocation(line: 695, column: 12, scope: !84)
!86 = !DILocation(line: 695, column: 6, scope: !77)
!87 = !DILocation(line: 696, column: 5, scope: !88)
!88 = distinct !DILexicalBlock(scope: !84, file: !9, line: 695, column: 17)
!89 = !DILocation(line: 697, column: 10, scope: !88)
!90 = !DILocation(line: 698, column: 5, scope: !88)
!91 = !DILocation(line: 699, column: 11, scope: !88)
!92 = !DILocation(line: 700, column: 3, scope: !88)
!93 = !DILocation(line: 701, column: 9, scope: !77)
!94 = !DILocation(line: 703, column: 3, scope: !77)
!95 = !DILocation(line: 704, column: 3, scope: !77)
!96 = distinct !DISubprogram(name: "de_allocator", scope: !9, file: !9, line: 706, type: !78, scopeLine: 706, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!97 = !DILocalVariable(name: "_", arg: 1, scope: !96, file: !9, line: 706, type: !5)
!98 = !DILocation(line: 0, scope: !96)
!99 = !DILocation(line: 707, column: 3, scope: !96)
!100 = !DILocation(line: 708, column: 6, scope: !101)
!101 = distinct !DILexicalBlock(scope: !96, file: !9, line: 708, column: 6)
!102 = !DILocation(line: 708, column: 11, scope: !101)
!103 = !DILocation(line: 708, column: 6, scope: !96)
!104 = !DILocation(line: 709, column: 11, scope: !105)
!105 = distinct !DILexicalBlock(scope: !101, file: !9, line: 708, column: 16)
!106 = !DILocation(line: 711, column: 3, scope: !105)
!107 = !DILocation(line: 712, column: 3, scope: !96)
!108 = !DILocation(line: 713, column: 3, scope: !96)
!109 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 715, type: !110, scopeLine: 715, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!110 = !DISubroutineType(types: !111)
!111 = !{!10}
!112 = !DILocation(line: 717, column: 23, scope: !109)
!113 = !DILocation(line: 717, column: 32, scope: !109)
!114 = !DILocation(line: 717, column: 29, scope: !109)
!115 = !DILocation(line: 717, column: 3, scope: !109)
!116 = !DILocation(line: 718, column: 3, scope: !109)
!117 = !DILocation(line: 719, column: 3, scope: !109)
!118 = !DILocalVariable(name: "t1", scope: !109, file: !9, line: 716, type: !119)
!119 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !9, line: 284, baseType: !120)
!120 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!121 = !DILocation(line: 0, scope: !109)
!122 = !DILocation(line: 720, column: 3, scope: !109)
!123 = !DILocalVariable(name: "t2", scope: !109, file: !9, line: 716, type: !119)
!124 = !DILocation(line: 721, column: 3, scope: !109)
!125 = !DILocation(line: 722, column: 16, scope: !109)
!126 = !DILocation(line: 722, column: 3, scope: !109)
!127 = !DILocation(line: 723, column: 16, scope: !109)
!128 = !DILocation(line: 723, column: 3, scope: !109)
!129 = !DILocation(line: 724, column: 3, scope: !109)
!130 = !DILocation(line: 725, column: 3, scope: !109)
!131 = !DILocation(line: 726, column: 3, scope: !109)
