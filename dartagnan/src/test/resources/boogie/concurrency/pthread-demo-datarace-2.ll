; ModuleID = '/home/ponce/git/Dat3M/output/pthread-demo-datarace-2.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-C-DAC/pthread-demo-datarace-2.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.anon = type { i16, i16 }
%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [26 x i8] c"pthread-demo-datarace-2.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@mymutex = dso_local global { { i32, i32, i32, i32, i32, [4 x i8], { %struct.anon, [4 x i8] } } } { { i32, i32, i32, i32, i32, [4 x i8], { %struct.anon, [4 x i8] } } { i32 0, i32 0, i32 0, i32 0, i32 0, [4 x i8] undef, { %struct.anon, [4 x i8] } { %struct.anon zeroinitializer, [4 x i8] undef } } }, align 8, !dbg !0
@myglobal = dso_local global i32 0, align 4, !dbg !7
@.str.2 = private unnamed_addr constant [32 x i8] c"\0AIn thread_function_datarace..\09\00", align 1
@.str.3 = private unnamed_addr constant [79 x i8] c"\0A\09\09---------------------------------------------------------------------------\00", align 1
@.str.4 = private unnamed_addr constant [57 x i8] c"\0A\09\09 Centre for Development of Advanced Computing (C-DAC)\00", align 1
@.str.5 = private unnamed_addr constant [27 x i8] c"\0A\09\09 Email : hpcfte@cdac.in\00", align 1
@.str.6 = private unnamed_addr constant [83 x i8] c"\0A\09\09 Objective : Pthread code to illustrate data race condition and its solution \0A \00", align 1
@.str.7 = private unnamed_addr constant [79 x i8] c"\0A\09\09..........................................................................\0A\00", align 1
@.str.8 = private unnamed_addr constant [57 x i8] c"\0AValue of myglobal in thread_function_datarace is :  %d\0A\00", align 1
@.str.9 = private unnamed_addr constant [104 x i8] c"\0A ----------------------------------------------------------------------------------------------------\0A\00", align 1
@str = private unnamed_addr constant [78 x i8] c"\0A\09\09..........................................................................\00", align 1
@str.1 = private unnamed_addr constant [103 x i8] c"\0A ----------------------------------------------------------------------------------------------------\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !53 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @.str.1, i64 0, i64 0), i32 noundef 25, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #7, !dbg !57
  unreachable, !dbg !57
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_assert(i32 noundef %0) #0 !dbg !60 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !63, metadata !DIExpression()), !dbg !64
  %.not = icmp eq i32 %0, 0, !dbg !65
  br i1 %.not, label %2, label %3, !dbg !67

2:                                                ; preds = %1
  call void @llvm.dbg.label(metadata !68), !dbg !70
  call void @reach_error(), !dbg !71
  call void @abort() #8, !dbg !73
  unreachable, !dbg !73

3:                                                ; preds = %1
  ret void, !dbg !74
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #2

; Function Attrs: noreturn
declare void @abort() #3

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_function_datarace(i8* noundef %0) #0 !dbg !75 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !78, metadata !DIExpression()), !dbg !79
  call void @llvm.dbg.value(metadata i32 0, metadata !80, metadata !DIExpression()), !dbg !79
  br label %2, !dbg !81

2:                                                ; preds = %3, %1
  %.0 = phi i32 [ 0, %1 ], [ %7, %3 ], !dbg !83
  call void @llvm.dbg.value(metadata i32 %.0, metadata !80, metadata !DIExpression()), !dbg !79
  %exitcond.not = icmp eq i32 %.0, 20, !dbg !84
  br i1 %exitcond.not, label %8, label %3, !dbg !86

3:                                                ; preds = %2
  %4 = load i32, i32* @myglobal, align 4, !dbg !87
  call void @llvm.dbg.value(metadata i32 %4, metadata !89, metadata !DIExpression()), !dbg !79
  %5 = add nsw i32 %4, 1, !dbg !90
  call void @llvm.dbg.value(metadata i32 %5, metadata !89, metadata !DIExpression()), !dbg !79
  %6 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([32 x i8], [32 x i8]* @.str.2, i64 0, i64 0)) #9, !dbg !91
  store i32 %5, i32* @myglobal, align 4, !dbg !92
  %7 = add nuw nsw i32 %.0, 1, !dbg !93
  call void @llvm.dbg.value(metadata i32 %7, metadata !80, metadata !DIExpression()), !dbg !79
  br label %2, !dbg !94, !llvm.loop !95

8:                                                ; preds = %2
  ret i8* null, !dbg !98
}

declare i32 @printf(i8* noundef, ...) #4

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !99 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !102, metadata !DIExpression(DW_OP_deref)), !dbg !105
  %2 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_function_datarace, i8* noundef null) #9, !dbg !106
  %.not = icmp eq i32 %2, 0, !dbg !106
  br i1 %.not, label %4, label %3, !dbg !108

3:                                                ; preds = %0
  call void @exit(i32 noundef -1) #7, !dbg !109
  unreachable, !dbg !109

4:                                                ; preds = %0
  %5 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([79 x i8], [79 x i8]* @.str.3, i64 0, i64 0)) #9, !dbg !111
  %6 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([57 x i8], [57 x i8]* @.str.4, i64 0, i64 0)) #9, !dbg !112
  %7 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([27 x i8], [27 x i8]* @.str.5, i64 0, i64 0)) #9, !dbg !113
  %8 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([79 x i8], [79 x i8]* @.str.3, i64 0, i64 0)) #9, !dbg !114
  %9 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([83 x i8], [83 x i8]* @.str.6, i64 0, i64 0)) #9, !dbg !115
  %puts = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([78 x i8], [78 x i8]* @str, i64 0, i64 0)), !dbg !116
  call void @llvm.dbg.value(metadata i32 0, metadata !117, metadata !DIExpression()), !dbg !105
  %10 = load i32, i32* @myglobal, align 4, !dbg !118
  call void @llvm.dbg.value(metadata i32 1, metadata !117, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 2, metadata !117, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 3, metadata !117, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 4, metadata !117, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 5, metadata !117, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 6, metadata !117, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 7, metadata !117, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 8, metadata !117, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 9, metadata !117, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 10, metadata !117, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 11, metadata !117, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 12, metadata !117, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 13, metadata !117, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 14, metadata !117, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 15, metadata !117, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 16, metadata !117, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 17, metadata !117, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 18, metadata !117, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 19, metadata !117, metadata !DIExpression()), !dbg !105
  %11 = add nsw i32 %10, 20, !dbg !122
  store i32 %11, i32* @myglobal, align 4, !dbg !123
  call void @llvm.dbg.value(metadata i32 20, metadata !117, metadata !DIExpression()), !dbg !105
  %12 = load i64, i64* %1, align 8, !dbg !124
  call void @llvm.dbg.value(metadata i64 %12, metadata !102, metadata !DIExpression()), !dbg !105
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null) #9, !dbg !126
  %.not1 = icmp eq i32 %13, 0, !dbg !126
  br i1 %.not1, label %15, label %14, !dbg !127

14:                                               ; preds = %4
  call void @exit(i32 noundef -1) #7, !dbg !128
  unreachable, !dbg !128

15:                                               ; preds = %4
  %16 = load i32, i32* @myglobal, align 4, !dbg !130
  %17 = icmp ne i32 %16, 40, !dbg !131
  %18 = zext i1 %17 to i32, !dbg !131
  call void @__VERIFIER_assert(i32 noundef %18), !dbg !132
  %19 = load i32, i32* @myglobal, align 4, !dbg !133
  %20 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([57 x i8], [57 x i8]* @.str.8, i64 0, i64 0), i32 noundef %19) #9, !dbg !134
  %puts2 = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([103 x i8], [103 x i8]* @str.1, i64 0, i64 0)), !dbg !135
  call void @exit(i32 noundef 0) #7, !dbg !136
  unreachable, !dbg !136
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #5

; Function Attrs: nocallback noreturn nounwind
declare void @exit(i32 noundef) #1

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

; Function Attrs: nofree nounwind
declare noundef i32 @puts(i8* nocapture noundef readonly) #6

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nofree nounwind }
attributes #7 = { nocallback noreturn nounwind }
attributes #8 = { noreturn nounwind }
attributes #9 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!45, !46, !47, !48, !49, !50, !51}
!llvm.ident = !{!52}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "mymutex", scope: !2, file: !9, line: 1319, type: !11, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-C-DAC/pthread-demo-datarace-2.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "1ad0ef3eb5a20df0b1a768f7959eba87")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "myglobal", scope: !2, file: !9, line: 1318, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "../sv-benchmarks/c/pthread-C-DAC/pthread-demo-datarace-2.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "1ad0ef3eb5a20df0b1a768f7959eba87")
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !9, line: 253, baseType: !12)
!12 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !9, line: 232, size: 256, elements: !13)
!13 = !{!14, !38, !43}
!14 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !12, file: !9, line: 250, baseType: !15, size: 256)
!15 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !9, line: 234, size: 256, elements: !16)
!16 = !{!17, !18, !20, !21, !22, !23}
!17 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !15, file: !9, line: 236, baseType: !10, size: 32)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !15, file: !9, line: 237, baseType: !19, size: 32, offset: 32)
!19 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !15, file: !9, line: 238, baseType: !10, size: 32, offset: 64)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !15, file: !9, line: 239, baseType: !10, size: 32, offset: 96)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !15, file: !9, line: 240, baseType: !19, size: 32, offset: 128)
!23 = !DIDerivedType(tag: DW_TAG_member, scope: !15, file: !9, line: 241, baseType: !24, size: 64, offset: 192)
!24 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !15, file: !9, line: 241, size: 64, elements: !25)
!25 = !{!26, !32}
!26 = !DIDerivedType(tag: DW_TAG_member, name: "d", scope: !24, file: !9, line: 247, baseType: !27, size: 32)
!27 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !24, file: !9, line: 243, size: 32, elements: !28)
!28 = !{!29, !31}
!29 = !DIDerivedType(tag: DW_TAG_member, name: "__espins", scope: !27, file: !9, line: 245, baseType: !30, size: 16)
!30 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !27, file: !9, line: 246, baseType: !30, size: 16, offset: 16)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !24, file: !9, line: 248, baseType: !33, size: 64)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_slist_t", file: !9, line: 231, baseType: !34)
!34 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_slist", file: !9, line: 228, size: 64, elements: !35)
!35 = !{!36}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !34, file: !9, line: 230, baseType: !37, size: 64)
!37 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !12, file: !9, line: 251, baseType: !39, size: 192)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 192, elements: !41)
!40 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!41 = !{!42}
!42 = !DISubrange(count: 24)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !12, file: !9, line: 252, baseType: !44, size: 64)
!44 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!45 = !{i32 7, !"Dwarf Version", i32 5}
!46 = !{i32 2, !"Debug Info Version", i32 3}
!47 = !{i32 1, !"wchar_size", i32 4}
!48 = !{i32 7, !"PIC Level", i32 2}
!49 = !{i32 7, !"PIE Level", i32 2}
!50 = !{i32 7, !"uwtable", i32 1}
!51 = !{i32 7, !"frame-pointer", i32 2}
!52 = !{!"Ubuntu clang version 14.0.6"}
!53 = distinct !DISubprogram(name: "reach_error", scope: !9, file: !9, line: 12, type: !54, scopeLine: 12, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!54 = !DISubroutineType(types: !55)
!55 = !{null}
!56 = !{}
!57 = !DILocation(line: 12, column: 83, scope: !58)
!58 = distinct !DILexicalBlock(scope: !59, file: !9, line: 12, column: 73)
!59 = distinct !DILexicalBlock(scope: !53, file: !9, line: 12, column: 67)
!60 = distinct !DISubprogram(name: "__VERIFIER_assert", scope: !9, file: !9, line: 13, type: !61, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!61 = !DISubroutineType(types: !62)
!62 = !{null, !10}
!63 = !DILocalVariable(name: "cond", arg: 1, scope: !60, file: !9, line: 13, type: !10)
!64 = !DILocation(line: 0, scope: !60)
!65 = !DILocation(line: 13, column: 41, scope: !66)
!66 = distinct !DILexicalBlock(scope: !60, file: !9, line: 13, column: 40)
!67 = !DILocation(line: 13, column: 40, scope: !60)
!68 = !DILabel(scope: !69, name: "ERROR", file: !9, line: 13)
!69 = distinct !DILexicalBlock(scope: !66, file: !9, line: 13, column: 49)
!70 = !DILocation(line: 13, column: 51, scope: !69)
!71 = !DILocation(line: 13, column: 59, scope: !72)
!72 = distinct !DILexicalBlock(scope: !69, file: !9, line: 13, column: 58)
!73 = !DILocation(line: 13, column: 73, scope: !72)
!74 = !DILocation(line: 13, column: 85, scope: !60)
!75 = distinct !DISubprogram(name: "thread_function_datarace", scope: !9, file: !9, line: 1320, type: !76, scopeLine: 1321, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!76 = !DISubroutineType(types: !77)
!77 = !{!5, !5}
!78 = !DILocalVariable(name: "arg", arg: 1, scope: !75, file: !9, line: 1320, type: !5)
!79 = !DILocation(line: 0, scope: !75)
!80 = !DILocalVariable(name: "i", scope: !75, file: !9, line: 1322, type: !10)
!81 = !DILocation(line: 1323, column: 11, scope: !82)
!82 = distinct !DILexicalBlock(scope: !75, file: !9, line: 1323, column: 5)
!83 = !DILocation(line: 0, scope: !82)
!84 = !DILocation(line: 1323, column: 17, scope: !85)
!85 = distinct !DILexicalBlock(scope: !82, file: !9, line: 1323, column: 5)
!86 = !DILocation(line: 1323, column: 5, scope: !82)
!87 = !DILocation(line: 1325, column: 11, scope: !88)
!88 = distinct !DILexicalBlock(scope: !85, file: !9, line: 1324, column: 5)
!89 = !DILocalVariable(name: "j", scope: !75, file: !9, line: 1322, type: !10)
!90 = !DILocation(line: 1326, column: 12, scope: !88)
!91 = !DILocation(line: 1327, column: 9, scope: !88)
!92 = !DILocation(line: 1328, column: 17, scope: !88)
!93 = !DILocation(line: 1323, column: 23, scope: !85)
!94 = !DILocation(line: 1323, column: 5, scope: !85)
!95 = distinct !{!95, !86, !96, !97}
!96 = !DILocation(line: 1329, column: 5, scope: !82)
!97 = !{!"llvm.loop.mustprogress"}
!98 = !DILocation(line: 1330, column: 5, scope: !75)
!99 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 1332, type: !100, scopeLine: 1333, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!100 = !DISubroutineType(types: !101)
!101 = !{!10}
!102 = !DILocalVariable(name: "mythread", scope: !99, file: !9, line: 1334, type: !103)
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !9, line: 221, baseType: !104)
!104 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!105 = !DILocation(line: 0, scope: !99)
!106 = !DILocation(line: 1336, column: 10, scope: !107)
!107 = distinct !DILexicalBlock(scope: !99, file: !9, line: 1336, column: 10)
!108 = !DILocation(line: 1336, column: 10, scope: !99)
!109 = !DILocation(line: 1338, column: 7, scope: !110)
!110 = distinct !DILexicalBlock(scope: !107, file: !9, line: 1337, column: 5)
!111 = !DILocation(line: 1340, column: 5, scope: !99)
!112 = !DILocation(line: 1341, column: 5, scope: !99)
!113 = !DILocation(line: 1342, column: 5, scope: !99)
!114 = !DILocation(line: 1343, column: 5, scope: !99)
!115 = !DILocation(line: 1344, column: 5, scope: !99)
!116 = !DILocation(line: 1345, column: 5, scope: !99)
!117 = !DILocalVariable(name: "i", scope: !99, file: !9, line: 1335, type: !10)
!118 = !DILocation(line: 1348, column: 18, scope: !119)
!119 = distinct !DILexicalBlock(scope: !120, file: !9, line: 1347, column: 5)
!120 = distinct !DILexicalBlock(scope: !121, file: !9, line: 1346, column: 5)
!121 = distinct !DILexicalBlock(scope: !99, file: !9, line: 1346, column: 5)
!122 = !DILocation(line: 1348, column: 26, scope: !119)
!123 = !DILocation(line: 1348, column: 17, scope: !119)
!124 = !DILocation(line: 1350, column: 25, scope: !125)
!125 = distinct !DILexicalBlock(scope: !99, file: !9, line: 1350, column: 10)
!126 = !DILocation(line: 1350, column: 10, scope: !125)
!127 = !DILocation(line: 1350, column: 10, scope: !99)
!128 = !DILocation(line: 1352, column: 7, scope: !129)
!129 = distinct !DILexicalBlock(scope: !125, file: !9, line: 1351, column: 5)
!130 = !DILocation(line: 1354, column: 23, scope: !99)
!131 = !DILocation(line: 1354, column: 32, scope: !99)
!132 = !DILocation(line: 1354, column: 5, scope: !99)
!133 = !DILocation(line: 1355, column: 73, scope: !99)
!134 = !DILocation(line: 1355, column: 5, scope: !99)
!135 = !DILocation(line: 1356, column: 5, scope: !99)
!136 = !DILocation(line: 1357, column: 5, scope: !99)
