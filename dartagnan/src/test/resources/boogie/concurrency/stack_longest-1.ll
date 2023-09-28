; ModuleID = '/home/ponce/git/Dat3M/output/stack_longest-1.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread/stack_longest-1.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, %union.anon }
%union.anon = type { %struct.__pthread_internal_slist }
%struct.__pthread_internal_slist = type { %struct.__pthread_internal_slist* }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"stack_longest-1.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@flag = dso_local global i8 0, align 1, !dbg !0
@top = internal global i32 0, align 4, !dbg !50
@.str.2 = private unnamed_addr constant [16 x i8] c"stack overflow\0A\00", align 1
@.str.3 = private unnamed_addr constant [17 x i8] c"stack underflow\0A\00", align 1
@m = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !14
@arr = internal global [800 x i32] zeroinitializer, align 16, !dbg !7
@str = private unnamed_addr constant [15 x i8] c"stack overflow\00", align 1
@str.1 = private unnamed_addr constant [16 x i8] c"stack underflow\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !61 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str.1, i64 0, i64 0), i32 noundef 3, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #8, !dbg !65
  unreachable, !dbg !65
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @assume_abort_if_not(i32 noundef %0) #0 !dbg !68 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !71, metadata !DIExpression()), !dbg !72
  %.not = icmp eq i32 %0, 0, !dbg !73
  br i1 %.not, label %2, label %3, !dbg !75

2:                                                ; preds = %1
  call void @abort() #9, !dbg !76
  unreachable, !dbg !76

3:                                                ; preds = %1
  ret void, !dbg !78
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: noreturn
declare void @abort() #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @error() #0 !dbg !79 {
  call void @llvm.dbg.label(metadata !80), !dbg !81
  call void @reach_error(), !dbg !82
  call void @abort() #9, !dbg !84
  unreachable, !dbg !84
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @inc_top() #0 !dbg !85 {
  %1 = load i32, i32* @top, align 4, !dbg !86
  %2 = add nsw i32 %1, 1, !dbg !86
  store i32 %2, i32* @top, align 4, !dbg !86
  ret void, !dbg !87
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @dec_top() #0 !dbg !88 {
  %1 = load i32, i32* @top, align 4, !dbg !89
  %2 = add nsw i32 %1, -1, !dbg !89
  store i32 %2, i32* @top, align 4, !dbg !89
  ret void, !dbg !90
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @get_top() #0 !dbg !91 {
  %1 = load i32, i32* @top, align 4, !dbg !94
  ret i32 %1, !dbg !95
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @stack_empty() #0 !dbg !96 {
  %1 = load i32, i32* @top, align 4, !dbg !97
  %2 = icmp eq i32 %1, 0, !dbg !98
  %3 = zext i1 %2 to i32, !dbg !99
  ret i32 %3, !dbg !100
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @push(i32* noundef %0, i32 noundef %1) #0 !dbg !101 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !105, metadata !DIExpression()), !dbg !106
  call void @llvm.dbg.value(metadata i32 %1, metadata !107, metadata !DIExpression()), !dbg !106
  %3 = load i32, i32* @top, align 4, !dbg !108
  %4 = icmp eq i32 %3, 800, !dbg !110
  br i1 %4, label %5, label %6, !dbg !111

5:                                                ; preds = %2
  %puts = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @str, i64 0, i64 0)), !dbg !112
  br label %10, !dbg !114

6:                                                ; preds = %2
  %7 = call i32 @get_top(), !dbg !115
  %8 = sext i32 %7 to i64, !dbg !117
  %9 = getelementptr inbounds i32, i32* %0, i64 %8, !dbg !117
  store i32 %1, i32* %9, align 4, !dbg !118
  call void @inc_top(), !dbg !119
  br label %10, !dbg !120

10:                                               ; preds = %6, %5
  %.0 = phi i32 [ -1, %5 ], [ 0, %6 ], !dbg !106
  ret i32 %.0, !dbg !121
}

declare i32 @printf(i8* noundef, ...) #4

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @pop(i32* noundef %0) #0 !dbg !122 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !125, metadata !DIExpression()), !dbg !126
  %2 = call i32 @get_top(), !dbg !127
  %3 = icmp eq i32 %2, 0, !dbg !129
  br i1 %3, label %4, label %5, !dbg !130

4:                                                ; preds = %1
  %puts = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @str.1, i64 0, i64 0)), !dbg !131
  br label %10, !dbg !133

5:                                                ; preds = %1
  call void @dec_top(), !dbg !134
  %6 = call i32 @get_top(), !dbg !136
  %7 = sext i32 %6 to i64, !dbg !137
  %8 = getelementptr inbounds i32, i32* %0, i64 %7, !dbg !137
  %9 = load i32, i32* %8, align 4, !dbg !137
  br label %10, !dbg !138

10:                                               ; preds = %5, %4
  %.0 = phi i32 [ -2, %4 ], [ %9, %5 ], !dbg !139
  ret i32 %.0, !dbg !140
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @t1(i8* noundef %0) #0 !dbg !141 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !144, metadata !DIExpression()), !dbg !145
  call void @llvm.dbg.value(metadata i32 0, metadata !146, metadata !DIExpression()), !dbg !145
  br label %2, !dbg !147

2:                                                ; preds = %11, %1
  %.0 = phi i32 [ 0, %1 ], [ %13, %11 ], !dbg !149
  call void @llvm.dbg.value(metadata i32 %.0, metadata !146, metadata !DIExpression()), !dbg !145
  %exitcond.not = icmp eq i32 %.0, 800, !dbg !150
  br i1 %exitcond.not, label %14, label %3, !dbg !152

3:                                                ; preds = %2
  %4 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !153
  %5 = call i32 (...) @__VERIFIER_nondet_uint() #10, !dbg !155
  call void @llvm.dbg.value(metadata i32 %5, metadata !156, metadata !DIExpression()), !dbg !145
  %6 = icmp ult i32 %5, 800, !dbg !157
  %7 = zext i1 %6 to i32, !dbg !157
  call void @assume_abort_if_not(i32 noundef %7), !dbg !158
  %8 = call i32 @push(i32* noundef getelementptr inbounds ([800 x i32], [800 x i32]* @arr, i64 0, i64 0), i32 noundef %5), !dbg !159
  %9 = icmp eq i32 %8, -1, !dbg !161
  br i1 %9, label %10, label %11, !dbg !162

10:                                               ; preds = %3
  call void @error(), !dbg !163
  br label %11, !dbg !163

11:                                               ; preds = %10, %3
  store i8 1, i8* @flag, align 1, !dbg !164
  %12 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !165
  %13 = add nuw nsw i32 %.0, 1, !dbg !166
  call void @llvm.dbg.value(metadata i32 %13, metadata !146, metadata !DIExpression()), !dbg !145
  br label %2, !dbg !167, !llvm.loop !168

14:                                               ; preds = %2
  ret i8* null, !dbg !171
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #5

declare i32 @__VERIFIER_nondet_uint(...) #4

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #5

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @t2(i8* noundef %0) #0 !dbg !172 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !173, metadata !DIExpression()), !dbg !174
  call void @llvm.dbg.value(metadata i32 0, metadata !175, metadata !DIExpression()), !dbg !174
  br label %2, !dbg !176

2:                                                ; preds = %10, %1
  %.0 = phi i32 [ 0, %1 ], [ %12, %10 ], !dbg !178
  call void @llvm.dbg.value(metadata i32 %.0, metadata !175, metadata !DIExpression()), !dbg !174
  %exitcond.not = icmp eq i32 %.0, 800, !dbg !179
  br i1 %exitcond.not, label %13, label %3, !dbg !181

3:                                                ; preds = %2
  %4 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !182
  %5 = load i8, i8* @flag, align 1, !dbg !184
  %6 = and i8 %5, 1, !dbg !184
  %.not = icmp eq i8 %6, 0, !dbg !184
  br i1 %.not, label %10, label %7, !dbg !186

7:                                                ; preds = %3
  %8 = call i32 @pop(i32* noundef getelementptr inbounds ([800 x i32], [800 x i32]* @arr, i64 0, i64 0)), !dbg !187
  %.not1 = icmp eq i32 %8, -2, !dbg !190
  br i1 %.not1, label %9, label %10, !dbg !191

9:                                                ; preds = %7
  call void @error(), !dbg !192
  br label %10, !dbg !192

10:                                               ; preds = %7, %9, %3
  %11 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !193
  %12 = add nuw nsw i32 %.0, 1, !dbg !194
  call void @llvm.dbg.value(metadata i32 %12, metadata !175, metadata !DIExpression()), !dbg !174
  br label %2, !dbg !195, !llvm.loop !196

13:                                               ; preds = %2
  ret i8* null, !dbg !198
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !199 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef nonnull @m, %union.pthread_mutexattr_t* noundef null) #11, !dbg !200
  call void @llvm.dbg.value(metadata i64* %1, metadata !201, metadata !DIExpression(DW_OP_deref)), !dbg !204
  %4 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @t1, i8* noundef null) #10, !dbg !205
  call void @llvm.dbg.value(metadata i64* %2, metadata !206, metadata !DIExpression(DW_OP_deref)), !dbg !204
  %5 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @t2, i8* noundef null) #10, !dbg !207
  %6 = load i64, i64* %1, align 8, !dbg !208
  call void @llvm.dbg.value(metadata i64 %6, metadata !201, metadata !DIExpression()), !dbg !204
  %7 = call i32 @pthread_join(i64 noundef %6, i8** noundef null) #10, !dbg !209
  %8 = load i64, i64* %2, align 8, !dbg !210
  call void @llvm.dbg.value(metadata i64 %8, metadata !206, metadata !DIExpression()), !dbg !204
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null) #10, !dbg !211
  ret i32 0, !dbg !212
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #6

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #5

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

; Function Attrs: nofree nounwind
declare noundef i32 @puts(i8* nocapture noundef readonly) #7

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nocallback nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { nofree nounwind }
attributes #8 = { nocallback noreturn nounwind }
attributes #9 = { noreturn nounwind }
attributes #10 = { nounwind }
attributes #11 = { nocallback nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!53, !54, !55, !56, !57, !58, !59}
!llvm.ident = !{!60}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "flag", scope: !2, file: !9, line: 938, type: !52, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread/stack_longest-1.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "3fb2209450f1de26ce6a41a6c2e25081")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !14, !50}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "arr", scope: !2, file: !9, line: 936, type: !10, isLocal: true, isDefinition: true)
!9 = !DIFile(filename: "../sv-benchmarks/c/pthread/stack_longest-1.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "3fb2209450f1de26ce6a41a6c2e25081")
!10 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 25600, elements: !12)
!11 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!12 = !{!13}
!13 = !DISubrange(count: 800)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(name: "m", scope: !2, file: !9, line: 937, type: !16, isLocal: false, isDefinition: true)
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !9, line: 316, baseType: !17)
!17 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !9, line: 311, size: 256, elements: !18)
!18 = !{!19, !43, !48}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !17, file: !9, line: 313, baseType: !20, size: 256)
!20 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !9, line: 251, size: 256, elements: !21)
!21 = !{!22, !24, !25, !26, !27, !28}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !20, file: !9, line: 253, baseType: !23, size: 32)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !20, file: !9, line: 254, baseType: !11, size: 32, offset: 32)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !20, file: !9, line: 255, baseType: !23, size: 32, offset: 64)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !20, file: !9, line: 256, baseType: !23, size: 32, offset: 96)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !20, file: !9, line: 258, baseType: !11, size: 32, offset: 128)
!28 = !DIDerivedType(tag: DW_TAG_member, scope: !20, file: !9, line: 259, baseType: !29, size: 64, offset: 192)
!29 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !20, file: !9, line: 259, size: 64, elements: !30)
!30 = !{!31, !37}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "__elision_data", scope: !29, file: !9, line: 261, baseType: !32, size: 32)
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !29, file: !9, line: 261, size: 32, elements: !33)
!33 = !{!34, !36}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "__espins", scope: !32, file: !9, line: 261, baseType: !35, size: 16)
!35 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__eelision", scope: !32, file: !9, line: 261, baseType: !35, size: 16, offset: 16)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !29, file: !9, line: 262, baseType: !38, size: 64)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_slist_t", file: !9, line: 250, baseType: !39)
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_slist", file: !9, line: 247, size: 64, elements: !40)
!40 = !{!41}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !39, file: !9, line: 249, baseType: !42, size: 64)
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !17, file: !9, line: 314, baseType: !44, size: 192)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !45, size: 192, elements: !46)
!45 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!46 = !{!47}
!47 = !DISubrange(count: 24)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !17, file: !9, line: 315, baseType: !49, size: 64)
!49 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "top", scope: !2, file: !9, line: 935, type: !23, isLocal: true, isDefinition: true)
!52 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!53 = !{i32 7, !"Dwarf Version", i32 5}
!54 = !{i32 2, !"Debug Info Version", i32 3}
!55 = !{i32 1, !"wchar_size", i32 4}
!56 = !{i32 7, !"PIC Level", i32 2}
!57 = !{i32 7, !"PIE Level", i32 2}
!58 = !{i32 7, !"uwtable", i32 1}
!59 = !{i32 7, !"frame-pointer", i32 2}
!60 = !{!"Ubuntu clang version 14.0.6"}
!61 = distinct !DISubprogram(name: "reach_error", scope: !9, file: !9, line: 20, type: !62, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!62 = !DISubroutineType(types: !63)
!63 = !{null}
!64 = !{}
!65 = !DILocation(line: 20, column: 83, scope: !66)
!66 = distinct !DILexicalBlock(scope: !67, file: !9, line: 20, column: 73)
!67 = distinct !DILexicalBlock(scope: !61, file: !9, line: 20, column: 67)
!68 = distinct !DISubprogram(name: "assume_abort_if_not", scope: !9, file: !9, line: 22, type: !69, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!69 = !DISubroutineType(types: !70)
!70 = !{null, !23}
!71 = !DILocalVariable(name: "cond", arg: 1, scope: !68, file: !9, line: 22, type: !23)
!72 = !DILocation(line: 0, scope: !68)
!73 = !DILocation(line: 23, column: 7, scope: !74)
!74 = distinct !DILexicalBlock(scope: !68, file: !9, line: 23, column: 6)
!75 = !DILocation(line: 23, column: 6, scope: !68)
!76 = !DILocation(line: 23, column: 14, scope: !77)
!77 = distinct !DILexicalBlock(scope: !74, file: !9, line: 23, column: 13)
!78 = !DILocation(line: 24, column: 1, scope: !68)
!79 = distinct !DISubprogram(name: "error", scope: !9, file: !9, line: 939, type: !62, scopeLine: 940, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!80 = !DILabel(scope: !79, name: "ERROR", file: !9, line: 941)
!81 = !DILocation(line: 941, column: 3, scope: !79)
!82 = !DILocation(line: 941, column: 11, scope: !83)
!83 = distinct !DILexicalBlock(scope: !79, file: !9, line: 941, column: 10)
!84 = !DILocation(line: 941, column: 25, scope: !83)
!85 = distinct !DISubprogram(name: "inc_top", scope: !9, file: !9, line: 943, type: !62, scopeLine: 944, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!86 = !DILocation(line: 945, column: 6, scope: !85)
!87 = !DILocation(line: 946, column: 1, scope: !85)
!88 = distinct !DISubprogram(name: "dec_top", scope: !9, file: !9, line: 947, type: !62, scopeLine: 948, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!89 = !DILocation(line: 949, column: 6, scope: !88)
!90 = !DILocation(line: 950, column: 1, scope: !88)
!91 = distinct !DISubprogram(name: "get_top", scope: !9, file: !9, line: 951, type: !92, scopeLine: 952, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!92 = !DISubroutineType(types: !93)
!93 = !{!23}
!94 = !DILocation(line: 953, column: 10, scope: !91)
!95 = !DILocation(line: 953, column: 3, scope: !91)
!96 = distinct !DISubprogram(name: "stack_empty", scope: !9, file: !9, line: 955, type: !92, scopeLine: 956, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!97 = !DILocation(line: 957, column: 11, scope: !96)
!98 = !DILocation(line: 957, column: 14, scope: !96)
!99 = !DILocation(line: 957, column: 10, scope: !96)
!100 = !DILocation(line: 957, column: 3, scope: !96)
!101 = distinct !DISubprogram(name: "push", scope: !9, file: !9, line: 959, type: !102, scopeLine: 960, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!102 = !DISubroutineType(types: !103)
!103 = !{!23, !104, !23}
!104 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!105 = !DILocalVariable(name: "stack", arg: 1, scope: !101, file: !9, line: 959, type: !104)
!106 = !DILocation(line: 0, scope: !101)
!107 = !DILocalVariable(name: "x", arg: 2, scope: !101, file: !9, line: 959, type: !23)
!108 = !DILocation(line: 961, column: 7, scope: !109)
!109 = distinct !DILexicalBlock(scope: !101, file: !9, line: 961, column: 7)
!110 = !DILocation(line: 961, column: 10, scope: !109)
!111 = !DILocation(line: 961, column: 7, scope: !101)
!112 = !DILocation(line: 963, column: 5, scope: !113)
!113 = distinct !DILexicalBlock(scope: !109, file: !9, line: 962, column: 3)
!114 = !DILocation(line: 964, column: 5, scope: !113)
!115 = !DILocation(line: 968, column: 11, scope: !116)
!116 = distinct !DILexicalBlock(scope: !109, file: !9, line: 967, column: 3)
!117 = !DILocation(line: 968, column: 5, scope: !116)
!118 = !DILocation(line: 968, column: 22, scope: !116)
!119 = !DILocation(line: 969, column: 5, scope: !116)
!120 = !DILocation(line: 971, column: 3, scope: !101)
!121 = !DILocation(line: 972, column: 1, scope: !101)
!122 = distinct !DISubprogram(name: "pop", scope: !9, file: !9, line: 973, type: !123, scopeLine: 974, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!123 = !DISubroutineType(types: !124)
!124 = !{!23, !104}
!125 = !DILocalVariable(name: "stack", arg: 1, scope: !122, file: !9, line: 973, type: !104)
!126 = !DILocation(line: 0, scope: !122)
!127 = !DILocation(line: 975, column: 7, scope: !128)
!128 = distinct !DILexicalBlock(scope: !122, file: !9, line: 975, column: 7)
!129 = !DILocation(line: 975, column: 16, scope: !128)
!130 = !DILocation(line: 975, column: 7, scope: !122)
!131 = !DILocation(line: 977, column: 5, scope: !132)
!132 = distinct !DILexicalBlock(scope: !128, file: !9, line: 976, column: 3)
!133 = !DILocation(line: 978, column: 5, scope: !132)
!134 = !DILocation(line: 982, column: 5, scope: !135)
!135 = distinct !DILexicalBlock(scope: !128, file: !9, line: 981, column: 3)
!136 = !DILocation(line: 983, column: 18, scope: !135)
!137 = !DILocation(line: 983, column: 12, scope: !135)
!138 = !DILocation(line: 983, column: 5, scope: !135)
!139 = !DILocation(line: 0, scope: !128)
!140 = !DILocation(line: 986, column: 1, scope: !122)
!141 = distinct !DISubprogram(name: "t1", scope: !9, file: !9, line: 987, type: !142, scopeLine: 988, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!142 = !DISubroutineType(types: !143)
!143 = !{!5, !5}
!144 = !DILocalVariable(name: "arg", arg: 1, scope: !141, file: !9, line: 987, type: !5)
!145 = !DILocation(line: 0, scope: !141)
!146 = !DILocalVariable(name: "i", scope: !141, file: !9, line: 989, type: !23)
!147 = !DILocation(line: 991, column: 7, scope: !148)
!148 = distinct !DILexicalBlock(scope: !141, file: !9, line: 991, column: 3)
!149 = !DILocation(line: 0, scope: !148)
!150 = !DILocation(line: 991, column: 13, scope: !151)
!151 = distinct !DILexicalBlock(scope: !148, file: !9, line: 991, column: 3)
!152 = !DILocation(line: 991, column: 3, scope: !148)
!153 = !DILocation(line: 993, column: 5, scope: !154)
!154 = distinct !DILexicalBlock(scope: !151, file: !9, line: 992, column: 3)
!155 = !DILocation(line: 994, column: 11, scope: !154)
!156 = !DILocalVariable(name: "tmp", scope: !141, file: !9, line: 990, type: !11)
!157 = !DILocation(line: 995, column: 29, scope: !154)
!158 = !DILocation(line: 995, column: 5, scope: !154)
!159 = !DILocation(line: 996, column: 9, scope: !160)
!160 = distinct !DILexicalBlock(scope: !154, file: !9, line: 996, column: 9)
!161 = !DILocation(line: 996, column: 22, scope: !160)
!162 = !DILocation(line: 996, column: 9, scope: !154)
!163 = !DILocation(line: 997, column: 7, scope: !160)
!164 = !DILocation(line: 998, column: 9, scope: !154)
!165 = !DILocation(line: 999, column: 5, scope: !154)
!166 = !DILocation(line: 991, column: 22, scope: !151)
!167 = !DILocation(line: 991, column: 3, scope: !151)
!168 = distinct !{!168, !152, !169, !170}
!169 = !DILocation(line: 1000, column: 3, scope: !148)
!170 = !{!"llvm.loop.mustprogress"}
!171 = !DILocation(line: 1001, column: 3, scope: !141)
!172 = distinct !DISubprogram(name: "t2", scope: !9, file: !9, line: 1003, type: !142, scopeLine: 1004, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!173 = !DILocalVariable(name: "arg", arg: 1, scope: !172, file: !9, line: 1003, type: !5)
!174 = !DILocation(line: 0, scope: !172)
!175 = !DILocalVariable(name: "i", scope: !172, file: !9, line: 1005, type: !23)
!176 = !DILocation(line: 1006, column: 7, scope: !177)
!177 = distinct !DILexicalBlock(scope: !172, file: !9, line: 1006, column: 3)
!178 = !DILocation(line: 0, scope: !177)
!179 = !DILocation(line: 1006, column: 13, scope: !180)
!180 = distinct !DILexicalBlock(scope: !177, file: !9, line: 1006, column: 3)
!181 = !DILocation(line: 1006, column: 3, scope: !177)
!182 = !DILocation(line: 1008, column: 5, scope: !183)
!183 = distinct !DILexicalBlock(scope: !180, file: !9, line: 1007, column: 3)
!184 = !DILocation(line: 1009, column: 9, scope: !185)
!185 = distinct !DILexicalBlock(scope: !183, file: !9, line: 1009, column: 9)
!186 = !DILocation(line: 1009, column: 9, scope: !183)
!187 = !DILocation(line: 1011, column: 13, scope: !188)
!188 = distinct !DILexicalBlock(scope: !189, file: !9, line: 1011, column: 11)
!189 = distinct !DILexicalBlock(scope: !185, file: !9, line: 1010, column: 5)
!190 = !DILocation(line: 1011, column: 21, scope: !188)
!191 = !DILocation(line: 1011, column: 11, scope: !189)
!192 = !DILocation(line: 1012, column: 9, scope: !188)
!193 = !DILocation(line: 1014, column: 5, scope: !183)
!194 = !DILocation(line: 1006, column: 22, scope: !180)
!195 = !DILocation(line: 1006, column: 3, scope: !180)
!196 = distinct !{!196, !181, !197, !170}
!197 = !DILocation(line: 1015, column: 3, scope: !177)
!198 = !DILocation(line: 1016, column: 3, scope: !172)
!199 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 1018, type: !92, scopeLine: 1019, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!200 = !DILocation(line: 1021, column: 3, scope: !199)
!201 = !DILocalVariable(name: "id1", scope: !199, file: !9, line: 1020, type: !202)
!202 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !9, line: 292, baseType: !203)
!203 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!204 = !DILocation(line: 0, scope: !199)
!205 = !DILocation(line: 1022, column: 3, scope: !199)
!206 = !DILocalVariable(name: "id2", scope: !199, file: !9, line: 1020, type: !202)
!207 = !DILocation(line: 1023, column: 3, scope: !199)
!208 = !DILocation(line: 1024, column: 16, scope: !199)
!209 = !DILocation(line: 1024, column: 3, scope: !199)
!210 = !DILocation(line: 1025, column: 16, scope: !199)
!211 = !DILocation(line: 1025, column: 3, scope: !199)
!212 = !DILocation(line: 1026, column: 3, scope: !199)
