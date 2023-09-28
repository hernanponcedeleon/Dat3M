; ModuleID = '/home/ponce/git/Dat3M/output/race-2_1-container_of.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/ldv-races/race-2_1-container_of.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, %union.anon }
%union.anon = type { %struct.__pthread_internal_slist }
%struct.__pthread_internal_slist = type { %struct.__pthread_internal_slist* }
%struct.my_data = type { %union.pthread_mutex_t, %struct.device, %struct.A }
%struct.device = type {}
%struct.A = type { i32, i32 }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [24 x i8] c"race-2_1-container_of.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@t1 = dso_local global i64 0, align 8, !dbg !0
@t2 = dso_local global i64 0, align 8, !dbg !58

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !69 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([24 x i8], [24 x i8]* @.str.1, i64 0, i64 0), i32 noundef 18, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #6, !dbg !72
  unreachable, !dbg !72
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @ldv_assert(i32 noundef %0) #0 !dbg !75 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !78, metadata !DIExpression()), !dbg !79
  %.not = icmp eq i32 %0, 0, !dbg !80
  br i1 %.not, label %2, label %3, !dbg !82

2:                                                ; preds = %1
  call void @llvm.dbg.label(metadata !83), !dbg !85
  call void @reach_error(), !dbg !86
  call void @abort() #6, !dbg !88
  unreachable, !dbg !88

3:                                                ; preds = %1
  ret void, !dbg !89
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #2

; Function Attrs: nocallback noreturn nounwind
declare void @abort() #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @my_callback(i8* noundef %0) #0 !dbg !90 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !93, metadata !DIExpression()), !dbg !94
  call void @llvm.dbg.value(metadata i8* %0, metadata !95, metadata !DIExpression()), !dbg !94
  call void @llvm.dbg.value(metadata i8* %0, metadata !96, metadata !DIExpression()), !dbg !100
  %2 = getelementptr inbounds i8, i8* %0, i64 -32, !dbg !101
  call void @llvm.dbg.value(metadata i8* %2, metadata !102, metadata !DIExpression()), !dbg !94
  %3 = bitcast i8* %2 to %union.pthread_mutex_t*, !dbg !103
  %4 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull %3) #7, !dbg !104
  %5 = bitcast i8* %0 to i32*, !dbg !105
  store i32 1, i32* %5, align 8, !dbg !106
  %6 = getelementptr inbounds i8, i8* %0, i64 4, !dbg !107
  %7 = bitcast i8* %6 to i32*, !dbg !107
  %8 = load i32, i32* %7, align 4, !dbg !107
  %9 = add nsw i32 %8, 1, !dbg !108
  store i32 %9, i32* %7, align 4, !dbg !109
  %10 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull %3) #7, !dbg !110
  ret i8* null, !dbg !111
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @my_drv_probe(%struct.my_data* noundef %0) #0 !dbg !112 {
  call void @llvm.dbg.value(metadata %struct.my_data* %0, metadata !115, metadata !DIExpression()), !dbg !116
  call void @llvm.dbg.value(metadata %struct.my_data* %0, metadata !117, metadata !DIExpression(DW_OP_plus_uconst, 32, DW_OP_stack_value)), !dbg !116
  %2 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 0, !dbg !118
  %3 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %2, %union.pthread_mutexattr_t* noundef null) #8, !dbg !119
  %4 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 2, i32 0, !dbg !120
  store i32 0, i32* %4, align 8, !dbg !121
  %5 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 2, i32 1, !dbg !122
  store i32 0, i32* %5, align 4, !dbg !123
  call void @ldv_assert(i32 noundef 1), !dbg !124
  %6 = load i32, i32* %5, align 4, !dbg !125
  %7 = icmp eq i32 %6, 0, !dbg !126
  %8 = zext i1 %7 to i32, !dbg !126
  call void @ldv_assert(i32 noundef %8), !dbg !127
  %9 = call i32 @__VERIFIER_nondet_int() #7, !dbg !128
  call void @llvm.dbg.value(metadata i32 %9, metadata !129, metadata !DIExpression()), !dbg !116
  %.not = icmp eq i32 %9, 0, !dbg !130
  br i1 %.not, label %10, label %15, !dbg !132

10:                                               ; preds = %1
  %11 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 1, !dbg !133
  call void @llvm.dbg.value(metadata %struct.device* %11, metadata !117, metadata !DIExpression()), !dbg !116
  %12 = bitcast %struct.device* %11 to i8*, !dbg !134
  %13 = call i32 @pthread_create(i64* noundef nonnull @t1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @my_callback, i8* noundef nonnull %12) #7, !dbg !135
  %14 = call i32 @pthread_create(i64* noundef nonnull @t2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @my_callback, i8* noundef nonnull %12) #7, !dbg !136
  br label %17, !dbg !137

15:                                               ; preds = %1
  call void @llvm.dbg.label(metadata !138), !dbg !139
  %16 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef %2) #8, !dbg !140
  br label %17, !dbg !141

17:                                               ; preds = %15, %10
  %.0 = phi i32 [ -1, %15 ], [ 0, %10 ], !dbg !116
  ret i32 %.0, !dbg !142
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #4

declare i32 @__VERIFIER_nondet_int() #5

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @my_drv_disconnect(%struct.my_data* noundef %0) #0 !dbg !143 {
  %2 = alloca i8*, align 8
  call void @llvm.dbg.value(metadata %struct.my_data* %0, metadata !146, metadata !DIExpression()), !dbg !147
  %3 = load i64, i64* @t1, align 8, !dbg !148
  call void @llvm.dbg.value(metadata i8** %2, metadata !149, metadata !DIExpression(DW_OP_deref)), !dbg !147
  %4 = call i32 @pthread_join(i64 noundef %3, i8** noundef nonnull %2) #7, !dbg !150
  %5 = load i64, i64* @t2, align 8, !dbg !151
  %6 = call i32 @pthread_join(i64 noundef %5, i8** noundef nonnull %2) #7, !dbg !152
  %7 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 0, !dbg !153
  %8 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef %7) #8, !dbg !154
  ret void, !dbg !155
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #5

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @my_drv_init() #0 !dbg !156 {
  ret i32 0, !dbg !159
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @my_drv_cleanup() #0 !dbg !160 {
  ret void, !dbg !161
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !162 {
  %1 = alloca %struct.my_data, align 8
  %2 = call i32 @my_drv_init(), !dbg !163
  call void @llvm.dbg.value(metadata i32 %2, metadata !164, metadata !DIExpression()), !dbg !165
  %3 = icmp eq i32 %2, 0, !dbg !166
  br i1 %3, label %4, label %22, !dbg !168

4:                                                ; preds = %0
  call void @llvm.dbg.declare(metadata %struct.my_data* %1, metadata !169, metadata !DIExpression()), !dbg !171
  %5 = call i32 @my_drv_probe(%struct.my_data* noundef nonnull %1), !dbg !172
  call void @llvm.dbg.value(metadata i32 %5, metadata !173, metadata !DIExpression()), !dbg !174
  %6 = icmp eq i32 %5, 0, !dbg !175
  br i1 %6, label %7, label %16, !dbg !177

7:                                                ; preds = %4
  call void @my_drv_disconnect(%struct.my_data* noundef nonnull %1), !dbg !178
  %8 = getelementptr inbounds %struct.my_data, %struct.my_data* %1, i64 0, i32 2, i32 0, !dbg !180
  %9 = load i32, i32* %8, align 8, !dbg !180
  %10 = icmp eq i32 %9, 1, !dbg !181
  %11 = zext i1 %10 to i32, !dbg !181
  call void @ldv_assert(i32 noundef %11), !dbg !182
  %12 = getelementptr inbounds %struct.my_data, %struct.my_data* %1, i64 0, i32 2, i32 1, !dbg !183
  %13 = load i32, i32* %12, align 4, !dbg !183
  %14 = icmp eq i32 %13, 2, !dbg !184
  %15 = zext i1 %14 to i32, !dbg !184
  call void @ldv_assert(i32 noundef %15), !dbg !185
  br label %16, !dbg !186

16:                                               ; preds = %7, %4
  call void @my_drv_cleanup(), !dbg !187
  %17 = getelementptr inbounds %struct.my_data, %struct.my_data* %1, i64 0, i32 2, i32 0, !dbg !188
  store i32 -1, i32* %17, align 8, !dbg !189
  %18 = getelementptr inbounds %struct.my_data, %struct.my_data* %1, i64 0, i32 2, i32 1, !dbg !190
  store i32 -1, i32* %18, align 4, !dbg !191
  call void @ldv_assert(i32 noundef 1), !dbg !192
  %19 = load i32, i32* %18, align 4, !dbg !193
  %20 = icmp eq i32 %19, -1, !dbg !194
  %21 = zext i1 %20 to i32, !dbg !194
  call void @ldv_assert(i32 noundef %21), !dbg !195
  br label %22, !dbg !196

22:                                               ; preds = %16, %0
  ret i32 0, !dbg !197
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nocallback nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nocallback noreturn nounwind }
attributes #7 = { nounwind }
attributes #8 = { nocallback nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!61, !62, !63, !64, !65, !66, !67}
!llvm.ident = !{!68}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "t1", scope: !2, file: !7, line: 1694, type: !60, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !57, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/ldv-races/race-2_1-container_of.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "64956b198d63362f8847cfe1df5ade88")
!4 = !{!5, !9, !54, !55, !56}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "device", file: !7, line: 1695, elements: !8)
!7 = !DIFile(filename: "../sv-benchmarks/c/ldv-races/race-2_1-container_of.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "64956b198d63362f8847cfe1df5ade88")
!8 = !{}
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!10 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "my_data", file: !7, line: 1701, size: 320, elements: !11)
!11 = !{!12, !48, !49}
!12 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !10, file: !7, line: 1702, baseType: !13, size: 256)
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !7, line: 292, baseType: !14)
!14 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !7, line: 287, size: 256, elements: !15)
!15 = !{!16, !41, !46}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !14, file: !7, line: 289, baseType: !17, size: 256)
!17 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !7, line: 227, size: 256, elements: !18)
!18 = !{!19, !21, !23, !24, !25, !26}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !17, file: !7, line: 229, baseType: !20, size: 32)
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !17, file: !7, line: 230, baseType: !22, size: 32, offset: 32)
!22 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !17, file: !7, line: 231, baseType: !20, size: 32, offset: 64)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !17, file: !7, line: 232, baseType: !20, size: 32, offset: 96)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !17, file: !7, line: 234, baseType: !22, size: 32, offset: 128)
!26 = !DIDerivedType(tag: DW_TAG_member, scope: !17, file: !7, line: 235, baseType: !27, size: 64, offset: 192)
!27 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !17, file: !7, line: 235, size: 64, elements: !28)
!28 = !{!29, !35}
!29 = !DIDerivedType(tag: DW_TAG_member, name: "__elision_data", scope: !27, file: !7, line: 237, baseType: !30, size: 32)
!30 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !27, file: !7, line: 237, size: 32, elements: !31)
!31 = !{!32, !34}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "__espins", scope: !30, file: !7, line: 237, baseType: !33, size: 16)
!33 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "__eelision", scope: !30, file: !7, line: 237, baseType: !33, size: 16, offset: 16)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !27, file: !7, line: 238, baseType: !36, size: 64)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_slist_t", file: !7, line: 226, baseType: !37)
!37 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_slist", file: !7, line: 223, size: 64, elements: !38)
!38 = !{!39}
!39 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !37, file: !7, line: 225, baseType: !40, size: 64)
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !14, file: !7, line: 290, baseType: !42, size: 192)
!42 = !DICompositeType(tag: DW_TAG_array_type, baseType: !43, size: 192, elements: !44)
!43 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!44 = !{!45}
!45 = !DISubrange(count: 24)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !14, file: !7, line: 291, baseType: !47, size: 64)
!47 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "dev", scope: !10, file: !7, line: 1703, baseType: !6, offset: 256)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "shared", scope: !10, file: !7, line: 1704, baseType: !50, size: 64, offset: 256)
!50 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "A", file: !7, line: 1697, size: 64, elements: !51)
!51 = !{!52, !53}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !50, file: !7, line: 1698, baseType: !20, size: 32)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !50, file: !7, line: 1699, baseType: !20, size: 32, offset: 32)
!54 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!55 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!57 = !{!0, !58}
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "t2", scope: !2, file: !7, line: 1694, type: !60, isLocal: false, isDefinition: true)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !7, line: 268, baseType: !55)
!61 = !{i32 7, !"Dwarf Version", i32 5}
!62 = !{i32 2, !"Debug Info Version", i32 3}
!63 = !{i32 1, !"wchar_size", i32 4}
!64 = !{i32 7, !"PIC Level", i32 2}
!65 = !{i32 7, !"PIE Level", i32 2}
!66 = !{i32 7, !"uwtable", i32 1}
!67 = !{i32 7, !"frame-pointer", i32 2}
!68 = !{!"Ubuntu clang version 14.0.6"}
!69 = distinct !DISubprogram(name: "reach_error", scope: !7, file: !7, line: 1691, type: !70, scopeLine: 1691, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !8)
!70 = !DISubroutineType(types: !71)
!71 = !{null}
!72 = !DILocation(line: 1691, column: 83, scope: !73)
!73 = distinct !DILexicalBlock(scope: !74, file: !7, line: 1691, column: 73)
!74 = distinct !DILexicalBlock(scope: !69, file: !7, line: 1691, column: 67)
!75 = distinct !DISubprogram(name: "ldv_assert", scope: !7, file: !7, line: 1693, type: !76, scopeLine: 1693, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !8)
!76 = !DISubroutineType(types: !77)
!77 = !{null, !20}
!78 = !DILocalVariable(name: "expression", arg: 1, scope: !75, file: !7, line: 1693, type: !20)
!79 = !DILocation(line: 0, scope: !75)
!80 = !DILocation(line: 1693, column: 40, scope: !81)
!81 = distinct !DILexicalBlock(scope: !75, file: !7, line: 1693, column: 39)
!82 = !DILocation(line: 1693, column: 39, scope: !75)
!83 = !DILabel(scope: !84, name: "ERROR", file: !7, line: 1693)
!84 = distinct !DILexicalBlock(scope: !81, file: !7, line: 1693, column: 52)
!85 = !DILocation(line: 1693, column: 54, scope: !84)
!86 = !DILocation(line: 1693, column: 62, scope: !87)
!87 = distinct !DILexicalBlock(scope: !84, file: !7, line: 1693, column: 61)
!88 = !DILocation(line: 1693, column: 76, scope: !87)
!89 = !DILocation(line: 1693, column: 88, scope: !75)
!90 = distinct !DISubprogram(name: "my_callback", scope: !7, file: !7, line: 1706, type: !91, scopeLine: 1706, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !8)
!91 = !DISubroutineType(types: !92)
!92 = !{!56, !56}
!93 = !DILocalVariable(name: "arg", arg: 1, scope: !90, file: !7, line: 1706, type: !56)
!94 = !DILocation(line: 0, scope: !90)
!95 = !DILocalVariable(name: "dev", scope: !90, file: !7, line: 1707, type: !5)
!96 = !DILocalVariable(name: "__mptr", scope: !97, file: !7, line: 1709, type: !98)
!97 = distinct !DILexicalBlock(scope: !90, file: !7, line: 1709, column: 10)
!98 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64)
!99 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!100 = !DILocation(line: 0, scope: !97)
!101 = !DILocation(line: 1709, column: 107, scope: !97)
!102 = !DILocalVariable(name: "data", scope: !90, file: !7, line: 1708, type: !9)
!103 = !DILocation(line: 1710, column: 29, scope: !90)
!104 = !DILocation(line: 1710, column: 2, scope: !90)
!105 = !DILocation(line: 1711, column: 15, scope: !90)
!106 = !DILocation(line: 1711, column: 17, scope: !90)
!107 = !DILocation(line: 1712, column: 32, scope: !90)
!108 = !DILocation(line: 1712, column: 34, scope: !90)
!109 = !DILocation(line: 1712, column: 17, scope: !90)
!110 = !DILocation(line: 1713, column: 2, scope: !90)
!111 = !DILocation(line: 1714, column: 2, scope: !90)
!112 = distinct !DISubprogram(name: "my_drv_probe", scope: !7, file: !7, line: 1716, type: !113, scopeLine: 1716, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !8)
!113 = !DISubroutineType(types: !114)
!114 = !{!20, !9}
!115 = !DILocalVariable(name: "data", arg: 1, scope: !112, file: !7, line: 1716, type: !9)
!116 = !DILocation(line: 0, scope: !112)
!117 = !DILocalVariable(name: "d", scope: !112, file: !7, line: 1717, type: !5)
!118 = !DILocation(line: 1718, column: 28, scope: !112)
!119 = !DILocation(line: 1718, column: 2, scope: !112)
!120 = !DILocation(line: 1719, column: 15, scope: !112)
!121 = !DILocation(line: 1719, column: 17, scope: !112)
!122 = !DILocation(line: 1720, column: 15, scope: !112)
!123 = !DILocation(line: 1720, column: 17, scope: !112)
!124 = !DILocation(line: 1721, column: 2, scope: !112)
!125 = !DILocation(line: 1722, column: 26, scope: !112)
!126 = !DILocation(line: 1722, column: 27, scope: !112)
!127 = !DILocation(line: 1722, column: 2, scope: !112)
!128 = !DILocation(line: 1723, column: 12, scope: !112)
!129 = !DILocalVariable(name: "res", scope: !112, file: !7, line: 1723, type: !20)
!130 = !DILocation(line: 1724, column: 5, scope: !131)
!131 = distinct !DILexicalBlock(scope: !112, file: !7, line: 1724, column: 5)
!132 = !DILocation(line: 1724, column: 5, scope: !112)
!133 = !DILocation(line: 1717, column: 28, scope: !112)
!134 = !DILocation(line: 1726, column: 48, scope: !112)
!135 = !DILocation(line: 1726, column: 2, scope: !112)
!136 = !DILocation(line: 1727, column: 2, scope: !112)
!137 = !DILocation(line: 1728, column: 2, scope: !112)
!138 = !DILabel(scope: !112, name: "exit", file: !7, line: 1729)
!139 = !DILocation(line: 1729, column: 1, scope: !112)
!140 = !DILocation(line: 1730, column: 2, scope: !112)
!141 = !DILocation(line: 1731, column: 2, scope: !112)
!142 = !DILocation(line: 1732, column: 1, scope: !112)
!143 = distinct !DISubprogram(name: "my_drv_disconnect", scope: !7, file: !7, line: 1733, type: !144, scopeLine: 1733, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !8)
!144 = !DISubroutineType(types: !145)
!145 = !{null, !9}
!146 = !DILocalVariable(name: "data", arg: 1, scope: !143, file: !7, line: 1733, type: !9)
!147 = !DILocation(line: 0, scope: !143)
!148 = !DILocation(line: 1735, column: 15, scope: !143)
!149 = !DILocalVariable(name: "status", scope: !143, file: !7, line: 1734, type: !56)
!150 = !DILocation(line: 1735, column: 2, scope: !143)
!151 = !DILocation(line: 1736, column: 15, scope: !143)
!152 = !DILocation(line: 1736, column: 2, scope: !143)
!153 = !DILocation(line: 1737, column: 31, scope: !143)
!154 = !DILocation(line: 1737, column: 2, scope: !143)
!155 = !DILocation(line: 1738, column: 1, scope: !143)
!156 = distinct !DISubprogram(name: "my_drv_init", scope: !7, file: !7, line: 1739, type: !157, scopeLine: 1739, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !8)
!157 = !DISubroutineType(types: !158)
!158 = !{!20}
!159 = !DILocation(line: 1740, column: 2, scope: !156)
!160 = distinct !DISubprogram(name: "my_drv_cleanup", scope: !7, file: !7, line: 1742, type: !70, scopeLine: 1742, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !8)
!161 = !DILocation(line: 1743, column: 2, scope: !160)
!162 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 1745, type: !157, scopeLine: 1745, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !8)
!163 = !DILocation(line: 1746, column: 12, scope: !162)
!164 = !DILocalVariable(name: "ret", scope: !162, file: !7, line: 1746, type: !20)
!165 = !DILocation(line: 0, scope: !162)
!166 = !DILocation(line: 1747, column: 8, scope: !167)
!167 = distinct !DILexicalBlock(scope: !162, file: !7, line: 1747, column: 5)
!168 = !DILocation(line: 1747, column: 5, scope: !162)
!169 = !DILocalVariable(name: "data", scope: !170, file: !7, line: 1749, type: !10)
!170 = distinct !DILexicalBlock(scope: !167, file: !7, line: 1747, column: 13)
!171 = !DILocation(line: 1749, column: 18, scope: !170)
!172 = !DILocation(line: 1750, column: 15, scope: !170)
!173 = !DILocalVariable(name: "probe_ret", scope: !170, file: !7, line: 1748, type: !20)
!174 = !DILocation(line: 0, scope: !170)
!175 = !DILocation(line: 1751, column: 15, scope: !176)
!176 = distinct !DILexicalBlock(scope: !170, file: !7, line: 1751, column: 6)
!177 = !DILocation(line: 1751, column: 6, scope: !170)
!178 = !DILocation(line: 1752, column: 4, scope: !179)
!179 = distinct !DILexicalBlock(scope: !176, file: !7, line: 1751, column: 20)
!180 = !DILocation(line: 1753, column: 27, scope: !179)
!181 = !DILocation(line: 1753, column: 28, scope: !179)
!182 = !DILocation(line: 1753, column: 4, scope: !179)
!183 = !DILocation(line: 1754, column: 27, scope: !179)
!184 = !DILocation(line: 1754, column: 28, scope: !179)
!185 = !DILocation(line: 1754, column: 4, scope: !179)
!186 = !DILocation(line: 1755, column: 3, scope: !179)
!187 = !DILocation(line: 1756, column: 3, scope: !170)
!188 = !DILocation(line: 1757, column: 15, scope: !170)
!189 = !DILocation(line: 1757, column: 17, scope: !170)
!190 = !DILocation(line: 1758, column: 15, scope: !170)
!191 = !DILocation(line: 1758, column: 17, scope: !170)
!192 = !DILocation(line: 1759, column: 3, scope: !170)
!193 = !DILocation(line: 1760, column: 26, scope: !170)
!194 = !DILocation(line: 1760, column: 27, scope: !170)
!195 = !DILocation(line: 1760, column: 3, scope: !170)
!196 = !DILocation(line: 1761, column: 2, scope: !170)
!197 = !DILocation(line: 1762, column: 2, scope: !162)
