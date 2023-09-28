; ModuleID = '/home/ponce/git/Dat3M/output/race-3_1-container_of-global.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/ldv-races/race-3_1-container_of-global.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.device = type {}
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, %union.anon }
%union.anon = type { %struct.__pthread_internal_slist }
%struct.__pthread_internal_slist = type { %struct.__pthread_internal_slist* }
%struct.my_data = type { %union.pthread_mutex_t, %struct.device, %struct.A }
%struct.A = type { i32, i32 }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [31 x i8] c"race-3_1-container_of-global.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@my_dev = dso_local global %struct.device* null, align 8, !dbg !0
@t1 = dso_local global i64 0, align 8, !dbg !57
@t2 = dso_local global i64 0, align 8, !dbg !60

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !71 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str.1, i64 0, i64 0), i32 noundef 18, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #6, !dbg !74
  unreachable, !dbg !74
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @ldv_assert(i32 noundef %0) #0 !dbg !77 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !80, metadata !DIExpression()), !dbg !81
  %.not = icmp eq i32 %0, 0, !dbg !82
  br i1 %.not, label %2, label %3, !dbg !84

2:                                                ; preds = %1
  call void @llvm.dbg.label(metadata !85), !dbg !87
  call void @reach_error(), !dbg !88
  call void @abort() #6, !dbg !90
  unreachable, !dbg !90

3:                                                ; preds = %1
  ret void, !dbg !91
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #2

; Function Attrs: nocallback noreturn nounwind
declare void @abort() #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @my_callback(i8* noundef %0) #0 !dbg !92 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !95, metadata !DIExpression()), !dbg !96
  %2 = load i8*, i8** bitcast (%struct.device** @my_dev to i8**), align 8, !dbg !97
  call void @llvm.dbg.value(metadata %struct.device* undef, metadata !99, metadata !DIExpression()), !dbg !102
  %3 = getelementptr inbounds i8, i8* %2, i64 -32, !dbg !103
  call void @llvm.dbg.value(metadata i8* %3, metadata !104, metadata !DIExpression()), !dbg !96
  %4 = bitcast i8* %3 to %union.pthread_mutex_t*, !dbg !105
  %5 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull %4) #7, !dbg !106
  %6 = bitcast i8* %2 to i32*, !dbg !107
  store i32 1, i32* %6, align 8, !dbg !108
  %7 = getelementptr inbounds i8, i8* %2, i64 4, !dbg !109
  %8 = bitcast i8* %7 to i32*, !dbg !109
  %9 = load i32, i32* %8, align 4, !dbg !109
  %10 = add nsw i32 %9, 1, !dbg !110
  store i32 %10, i32* %8, align 4, !dbg !111
  %11 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull %4) #7, !dbg !112
  ret i8* null, !dbg !113
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @my_drv_probe(%struct.my_data* noundef %0) #0 !dbg !114 {
  call void @llvm.dbg.value(metadata %struct.my_data* %0, metadata !117, metadata !DIExpression()), !dbg !118
  %2 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 0, !dbg !119
  %3 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %2, %union.pthread_mutexattr_t* noundef null) #8, !dbg !120
  %4 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 2, i32 0, !dbg !121
  store i32 0, i32* %4, align 8, !dbg !122
  %5 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 2, i32 1, !dbg !123
  store i32 0, i32* %5, align 4, !dbg !124
  call void @ldv_assert(i32 noundef 1), !dbg !125
  %6 = load i32, i32* %5, align 4, !dbg !126
  %7 = icmp eq i32 %6, 0, !dbg !127
  %8 = zext i1 %7 to i32, !dbg !127
  call void @ldv_assert(i32 noundef %8), !dbg !128
  %9 = call i32 @__VERIFIER_nondet_int() #7, !dbg !129
  call void @llvm.dbg.value(metadata i32 %9, metadata !130, metadata !DIExpression()), !dbg !118
  %.not = icmp eq i32 %9, 0, !dbg !131
  br i1 %.not, label %10, label %14, !dbg !133

10:                                               ; preds = %1
  %11 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 1, !dbg !134
  store %struct.device* %11, %struct.device** @my_dev, align 8, !dbg !135
  %12 = call i32 @pthread_create(i64* noundef nonnull @t1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @my_callback, i8* noundef null) #7, !dbg !136
  %13 = call i32 @pthread_create(i64* noundef nonnull @t2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @my_callback, i8* noundef null) #7, !dbg !137
  br label %16, !dbg !138

14:                                               ; preds = %1
  call void @llvm.dbg.label(metadata !139), !dbg !140
  %15 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef %2) #8, !dbg !141
  br label %16, !dbg !142

16:                                               ; preds = %14, %10
  %.0 = phi i32 [ -1, %14 ], [ 0, %10 ], !dbg !118
  ret i32 %.0, !dbg !143
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #4

declare i32 @__VERIFIER_nondet_int() #5

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @my_drv_disconnect(%struct.my_data* noundef %0) #0 !dbg !144 {
  %2 = alloca i8*, align 8
  call void @llvm.dbg.value(metadata %struct.my_data* %0, metadata !147, metadata !DIExpression()), !dbg !148
  %3 = load i64, i64* @t1, align 8, !dbg !149
  call void @llvm.dbg.value(metadata i8** %2, metadata !150, metadata !DIExpression(DW_OP_deref)), !dbg !148
  %4 = call i32 @pthread_join(i64 noundef %3, i8** noundef nonnull %2) #7, !dbg !151
  %5 = load i64, i64* @t2, align 8, !dbg !152
  %6 = call i32 @pthread_join(i64 noundef %5, i8** noundef nonnull %2) #7, !dbg !153
  %7 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 0, !dbg !154
  %8 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef %7) #8, !dbg !155
  ret void, !dbg !156
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #5

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @my_drv_init() #0 !dbg !157 {
  ret i32 0, !dbg !160
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @my_drv_cleanup() #0 !dbg !161 {
  ret void, !dbg !162
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !163 {
  %1 = alloca %struct.my_data, align 8
  %2 = call i32 @my_drv_init(), !dbg !164
  call void @llvm.dbg.value(metadata i32 %2, metadata !165, metadata !DIExpression()), !dbg !166
  %3 = icmp eq i32 %2, 0, !dbg !167
  br i1 %3, label %4, label %22, !dbg !169

4:                                                ; preds = %0
  call void @llvm.dbg.declare(metadata %struct.my_data* %1, metadata !170, metadata !DIExpression()), !dbg !172
  %5 = call i32 @my_drv_probe(%struct.my_data* noundef nonnull %1), !dbg !173
  call void @llvm.dbg.value(metadata i32 %5, metadata !174, metadata !DIExpression()), !dbg !175
  %6 = icmp eq i32 %5, 0, !dbg !176
  br i1 %6, label %7, label %16, !dbg !178

7:                                                ; preds = %4
  call void @my_drv_disconnect(%struct.my_data* noundef nonnull %1), !dbg !179
  %8 = getelementptr inbounds %struct.my_data, %struct.my_data* %1, i64 0, i32 2, i32 0, !dbg !181
  %9 = load i32, i32* %8, align 8, !dbg !181
  %10 = icmp eq i32 %9, 1, !dbg !182
  %11 = zext i1 %10 to i32, !dbg !182
  call void @ldv_assert(i32 noundef %11), !dbg !183
  %12 = getelementptr inbounds %struct.my_data, %struct.my_data* %1, i64 0, i32 2, i32 1, !dbg !184
  %13 = load i32, i32* %12, align 4, !dbg !184
  %14 = icmp eq i32 %13, 2, !dbg !185
  %15 = zext i1 %14 to i32, !dbg !185
  call void @ldv_assert(i32 noundef %15), !dbg !186
  br label %16, !dbg !187

16:                                               ; preds = %7, %4
  call void @my_drv_cleanup(), !dbg !188
  %17 = getelementptr inbounds %struct.my_data, %struct.my_data* %1, i64 0, i32 2, i32 0, !dbg !189
  store i32 -1, i32* %17, align 8, !dbg !190
  %18 = getelementptr inbounds %struct.my_data, %struct.my_data* %1, i64 0, i32 2, i32 1, !dbg !191
  store i32 -1, i32* %18, align 4, !dbg !192
  call void @ldv_assert(i32 noundef 1), !dbg !193
  %19 = load i32, i32* %18, align 4, !dbg !194
  %20 = icmp eq i32 %19, -1, !dbg !195
  %21 = zext i1 %20 to i32, !dbg !195
  call void @ldv_assert(i32 noundef %21), !dbg !196
  br label %22, !dbg !197

22:                                               ; preds = %16, %0
  ret i32 0, !dbg !198
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
!llvm.module.flags = !{!63, !64, !65, !66, !67, !68, !69}
!llvm.ident = !{!70}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "my_dev", scope: !2, file: !7, line: 1706, type: !62, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !56, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/ldv-races/race-3_1-container_of-global.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "c4d06f4dcb954dfb42c3cf9e0f8bcb92")
!4 = !{!5, !53, !54, !55}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "my_data", file: !7, line: 1701, size: 320, elements: !8)
!7 = !DIFile(filename: "../sv-benchmarks/c/ldv-races/race-3_1-container_of-global.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "c4d06f4dcb954dfb42c3cf9e0f8bcb92")
!8 = !{!9, !45, !48}
!9 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !6, file: !7, line: 1702, baseType: !10, size: 256)
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !7, line: 292, baseType: !11)
!11 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !7, line: 287, size: 256, elements: !12)
!12 = !{!13, !38, !43}
!13 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !11, file: !7, line: 289, baseType: !14, size: 256)
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !7, line: 227, size: 256, elements: !15)
!15 = !{!16, !18, !20, !21, !22, !23}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !14, file: !7, line: 229, baseType: !17, size: 32)
!17 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !14, file: !7, line: 230, baseType: !19, size: 32, offset: 32)
!19 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !14, file: !7, line: 231, baseType: !17, size: 32, offset: 64)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !14, file: !7, line: 232, baseType: !17, size: 32, offset: 96)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !14, file: !7, line: 234, baseType: !19, size: 32, offset: 128)
!23 = !DIDerivedType(tag: DW_TAG_member, scope: !14, file: !7, line: 235, baseType: !24, size: 64, offset: 192)
!24 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !14, file: !7, line: 235, size: 64, elements: !25)
!25 = !{!26, !32}
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__elision_data", scope: !24, file: !7, line: 237, baseType: !27, size: 32)
!27 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !24, file: !7, line: 237, size: 32, elements: !28)
!28 = !{!29, !31}
!29 = !DIDerivedType(tag: DW_TAG_member, name: "__espins", scope: !27, file: !7, line: 237, baseType: !30, size: 16)
!30 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "__eelision", scope: !27, file: !7, line: 237, baseType: !30, size: 16, offset: 16)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !24, file: !7, line: 238, baseType: !33, size: 64)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_slist_t", file: !7, line: 226, baseType: !34)
!34 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_slist", file: !7, line: 223, size: 64, elements: !35)
!35 = !{!36}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !34, file: !7, line: 225, baseType: !37, size: 64)
!37 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !11, file: !7, line: 290, baseType: !39, size: 192)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 192, elements: !41)
!40 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!41 = !{!42}
!42 = !DISubrange(count: 24)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !11, file: !7, line: 291, baseType: !44, size: 64)
!44 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "dev", scope: !6, file: !7, line: 1703, baseType: !46, offset: 256)
!46 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "device", file: !7, line: 1695, elements: !47)
!47 = !{}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "shared", scope: !6, file: !7, line: 1704, baseType: !49, size: 64, offset: 256)
!49 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "A", file: !7, line: 1697, size: 64, elements: !50)
!50 = !{!51, !52}
!51 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !49, file: !7, line: 1698, baseType: !17, size: 32)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !49, file: !7, line: 1699, baseType: !17, size: 32, offset: 32)
!53 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!54 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!56 = !{!57, !60, !0}
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(name: "t1", scope: !2, file: !7, line: 1694, type: !59, isLocal: false, isDefinition: true)
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !7, line: 268, baseType: !54)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "t2", scope: !2, file: !7, line: 1694, type: !59, isLocal: false, isDefinition: true)
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!63 = !{i32 7, !"Dwarf Version", i32 5}
!64 = !{i32 2, !"Debug Info Version", i32 3}
!65 = !{i32 1, !"wchar_size", i32 4}
!66 = !{i32 7, !"PIC Level", i32 2}
!67 = !{i32 7, !"PIE Level", i32 2}
!68 = !{i32 7, !"uwtable", i32 1}
!69 = !{i32 7, !"frame-pointer", i32 2}
!70 = !{!"Ubuntu clang version 14.0.6"}
!71 = distinct !DISubprogram(name: "reach_error", scope: !7, file: !7, line: 1691, type: !72, scopeLine: 1691, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!72 = !DISubroutineType(types: !73)
!73 = !{null}
!74 = !DILocation(line: 1691, column: 83, scope: !75)
!75 = distinct !DILexicalBlock(scope: !76, file: !7, line: 1691, column: 73)
!76 = distinct !DILexicalBlock(scope: !71, file: !7, line: 1691, column: 67)
!77 = distinct !DISubprogram(name: "ldv_assert", scope: !7, file: !7, line: 1693, type: !78, scopeLine: 1693, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!78 = !DISubroutineType(types: !79)
!79 = !{null, !17}
!80 = !DILocalVariable(name: "expression", arg: 1, scope: !77, file: !7, line: 1693, type: !17)
!81 = !DILocation(line: 0, scope: !77)
!82 = !DILocation(line: 1693, column: 40, scope: !83)
!83 = distinct !DILexicalBlock(scope: !77, file: !7, line: 1693, column: 39)
!84 = !DILocation(line: 1693, column: 39, scope: !77)
!85 = !DILabel(scope: !86, name: "ERROR", file: !7, line: 1693)
!86 = distinct !DILexicalBlock(scope: !83, file: !7, line: 1693, column: 52)
!87 = !DILocation(line: 1693, column: 54, scope: !86)
!88 = !DILocation(line: 1693, column: 62, scope: !89)
!89 = distinct !DILexicalBlock(scope: !86, file: !7, line: 1693, column: 61)
!90 = !DILocation(line: 1693, column: 76, scope: !89)
!91 = !DILocation(line: 1693, column: 88, scope: !77)
!92 = distinct !DISubprogram(name: "my_callback", scope: !7, file: !7, line: 1707, type: !93, scopeLine: 1707, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!93 = !DISubroutineType(types: !94)
!94 = !{!55, !55}
!95 = !DILocalVariable(name: "arg", arg: 1, scope: !92, file: !7, line: 1707, type: !55)
!96 = !DILocation(line: 0, scope: !92)
!97 = !DILocation(line: 1709, column: 66, scope: !98)
!98 = distinct !DILexicalBlock(scope: !92, file: !7, line: 1709, column: 10)
!99 = !DILocalVariable(name: "__mptr", scope: !98, file: !7, line: 1709, type: !100)
!100 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !101, size: 64)
!101 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !46)
!102 = !DILocation(line: 0, scope: !98)
!103 = !DILocation(line: 1709, column: 110, scope: !98)
!104 = !DILocalVariable(name: "data", scope: !92, file: !7, line: 1708, type: !5)
!105 = !DILocation(line: 1710, column: 29, scope: !92)
!106 = !DILocation(line: 1710, column: 2, scope: !92)
!107 = !DILocation(line: 1711, column: 15, scope: !92)
!108 = !DILocation(line: 1711, column: 17, scope: !92)
!109 = !DILocation(line: 1712, column: 32, scope: !92)
!110 = !DILocation(line: 1712, column: 34, scope: !92)
!111 = !DILocation(line: 1712, column: 17, scope: !92)
!112 = !DILocation(line: 1713, column: 2, scope: !92)
!113 = !DILocation(line: 1714, column: 2, scope: !92)
!114 = distinct !DISubprogram(name: "my_drv_probe", scope: !7, file: !7, line: 1716, type: !115, scopeLine: 1716, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!115 = !DISubroutineType(types: !116)
!116 = !{!17, !5}
!117 = !DILocalVariable(name: "data", arg: 1, scope: !114, file: !7, line: 1716, type: !5)
!118 = !DILocation(line: 0, scope: !114)
!119 = !DILocation(line: 1717, column: 28, scope: !114)
!120 = !DILocation(line: 1717, column: 2, scope: !114)
!121 = !DILocation(line: 1718, column: 15, scope: !114)
!122 = !DILocation(line: 1718, column: 17, scope: !114)
!123 = !DILocation(line: 1719, column: 15, scope: !114)
!124 = !DILocation(line: 1719, column: 17, scope: !114)
!125 = !DILocation(line: 1720, column: 2, scope: !114)
!126 = !DILocation(line: 1721, column: 26, scope: !114)
!127 = !DILocation(line: 1721, column: 27, scope: !114)
!128 = !DILocation(line: 1721, column: 2, scope: !114)
!129 = !DILocation(line: 1722, column: 12, scope: !114)
!130 = !DILocalVariable(name: "res", scope: !114, file: !7, line: 1722, type: !17)
!131 = !DILocation(line: 1723, column: 5, scope: !132)
!132 = distinct !DILexicalBlock(scope: !114, file: !7, line: 1723, column: 5)
!133 = !DILocation(line: 1723, column: 5, scope: !114)
!134 = !DILocation(line: 1725, column: 18, scope: !114)
!135 = !DILocation(line: 1725, column: 9, scope: !114)
!136 = !DILocation(line: 1726, column: 2, scope: !114)
!137 = !DILocation(line: 1727, column: 2, scope: !114)
!138 = !DILocation(line: 1728, column: 2, scope: !114)
!139 = !DILabel(scope: !114, name: "exit", file: !7, line: 1729)
!140 = !DILocation(line: 1729, column: 1, scope: !114)
!141 = !DILocation(line: 1730, column: 2, scope: !114)
!142 = !DILocation(line: 1731, column: 2, scope: !114)
!143 = !DILocation(line: 1732, column: 1, scope: !114)
!144 = distinct !DISubprogram(name: "my_drv_disconnect", scope: !7, file: !7, line: 1733, type: !145, scopeLine: 1733, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!145 = !DISubroutineType(types: !146)
!146 = !{null, !5}
!147 = !DILocalVariable(name: "data", arg: 1, scope: !144, file: !7, line: 1733, type: !5)
!148 = !DILocation(line: 0, scope: !144)
!149 = !DILocation(line: 1735, column: 15, scope: !144)
!150 = !DILocalVariable(name: "status", scope: !144, file: !7, line: 1734, type: !55)
!151 = !DILocation(line: 1735, column: 2, scope: !144)
!152 = !DILocation(line: 1736, column: 15, scope: !144)
!153 = !DILocation(line: 1736, column: 2, scope: !144)
!154 = !DILocation(line: 1737, column: 31, scope: !144)
!155 = !DILocation(line: 1737, column: 2, scope: !144)
!156 = !DILocation(line: 1738, column: 1, scope: !144)
!157 = distinct !DISubprogram(name: "my_drv_init", scope: !7, file: !7, line: 1739, type: !158, scopeLine: 1739, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!158 = !DISubroutineType(types: !159)
!159 = !{!17}
!160 = !DILocation(line: 1740, column: 2, scope: !157)
!161 = distinct !DISubprogram(name: "my_drv_cleanup", scope: !7, file: !7, line: 1742, type: !72, scopeLine: 1742, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!162 = !DILocation(line: 1743, column: 2, scope: !161)
!163 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 1745, type: !158, scopeLine: 1745, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!164 = !DILocation(line: 1746, column: 12, scope: !163)
!165 = !DILocalVariable(name: "ret", scope: !163, file: !7, line: 1746, type: !17)
!166 = !DILocation(line: 0, scope: !163)
!167 = !DILocation(line: 1747, column: 8, scope: !168)
!168 = distinct !DILexicalBlock(scope: !163, file: !7, line: 1747, column: 5)
!169 = !DILocation(line: 1747, column: 5, scope: !163)
!170 = !DILocalVariable(name: "data", scope: !171, file: !7, line: 1749, type: !6)
!171 = distinct !DILexicalBlock(scope: !168, file: !7, line: 1747, column: 13)
!172 = !DILocation(line: 1749, column: 18, scope: !171)
!173 = !DILocation(line: 1750, column: 15, scope: !171)
!174 = !DILocalVariable(name: "probe_ret", scope: !171, file: !7, line: 1748, type: !17)
!175 = !DILocation(line: 0, scope: !171)
!176 = !DILocation(line: 1751, column: 15, scope: !177)
!177 = distinct !DILexicalBlock(scope: !171, file: !7, line: 1751, column: 6)
!178 = !DILocation(line: 1751, column: 6, scope: !171)
!179 = !DILocation(line: 1752, column: 4, scope: !180)
!180 = distinct !DILexicalBlock(scope: !177, file: !7, line: 1751, column: 20)
!181 = !DILocation(line: 1753, column: 27, scope: !180)
!182 = !DILocation(line: 1753, column: 28, scope: !180)
!183 = !DILocation(line: 1753, column: 4, scope: !180)
!184 = !DILocation(line: 1754, column: 27, scope: !180)
!185 = !DILocation(line: 1754, column: 28, scope: !180)
!186 = !DILocation(line: 1754, column: 4, scope: !180)
!187 = !DILocation(line: 1755, column: 3, scope: !180)
!188 = !DILocation(line: 1756, column: 3, scope: !171)
!189 = !DILocation(line: 1757, column: 15, scope: !171)
!190 = !DILocation(line: 1757, column: 17, scope: !171)
!191 = !DILocation(line: 1758, column: 15, scope: !171)
!192 = !DILocation(line: 1758, column: 17, scope: !171)
!193 = !DILocation(line: 1759, column: 3, scope: !171)
!194 = !DILocation(line: 1760, column: 26, scope: !171)
!195 = !DILocation(line: 1760, column: 27, scope: !171)
!196 = !DILocation(line: 1760, column: 3, scope: !171)
!197 = !DILocation(line: 1761, column: 2, scope: !171)
!198 = !DILocation(line: 1762, column: 2, scope: !163)
