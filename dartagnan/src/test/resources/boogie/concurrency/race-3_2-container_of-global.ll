; ModuleID = '/home/ponce/git/Dat3M/output/race-3_2-container_of-global.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/ldv-races/race-3_2-container_of-global.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.device = type {}
%struct.A = type { i32, i32 }
%struct.my_data = type { %union.pthread_mutex_t, %struct.device, %struct.A }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, %union.anon }
%union.anon = type { %struct.__pthread_internal_slist }
%struct.__pthread_internal_slist = type { %struct.__pthread_internal_slist* }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [31 x i8] c"race-3_2-container_of-global.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@my_dev = dso_local global %struct.device* null, align 8, !dbg !0
@t1 = dso_local global i64 0, align 8, !dbg !57
@t2 = dso_local global i64 0, align 8, !dbg !60

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !71 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str.1, i64 0, i64 0), i32 noundef 14, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #6, !dbg !74
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
  %2 = load %struct.A*, %struct.A** bitcast (%struct.device** @my_dev to %struct.A**), align 8, !dbg !97
  call void @llvm.dbg.value(metadata %struct.device* undef, metadata !99, metadata !DIExpression()), !dbg !102
  call void @llvm.dbg.value(metadata i8* undef, metadata !103, metadata !DIExpression(DW_OP_constu, 32, DW_OP_minus, DW_OP_stack_value)), !dbg !96
  call void @__VERIFIER_atomic_begin() #7, !dbg !104
  %3 = getelementptr inbounds %struct.A, %struct.A* %2, i64 0, i32 0, !dbg !105
  store i32 1, i32* %3, align 8, !dbg !106
  call void @__VERIFIER_atomic_end() #7, !dbg !107
  call void @__VERIFIER_atomic_begin() #7, !dbg !108
  %4 = getelementptr inbounds %struct.A, %struct.A* %2, i64 0, i32 1, !dbg !109
  %5 = load i32, i32* %4, align 4, !dbg !109
  call void @llvm.dbg.value(metadata i32 %5, metadata !110, metadata !DIExpression()), !dbg !96
  call void @__VERIFIER_atomic_end() #7, !dbg !111
  call void @__VERIFIER_atomic_begin() #7, !dbg !112
  %6 = add nsw i32 %5, 1, !dbg !113
  store i32 %6, i32* %4, align 4, !dbg !114
  call void @__VERIFIER_atomic_end() #7, !dbg !115
  ret i8* null, !dbg !116
}

declare void @__VERIFIER_atomic_begin() #3

declare void @__VERIFIER_atomic_end() #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @my_drv_probe(%struct.my_data* noundef %0) #0 !dbg !117 {
  call void @llvm.dbg.value(metadata %struct.my_data* %0, metadata !120, metadata !DIExpression()), !dbg !121
  %2 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 0, !dbg !122
  %3 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %2, %union.pthread_mutexattr_t* noundef null) #8, !dbg !123
  %4 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 2, i32 0, !dbg !124
  store i32 0, i32* %4, align 8, !dbg !125
  %5 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 2, i32 1, !dbg !126
  store i32 0, i32* %5, align 4, !dbg !127
  call void @ldv_assert(i32 noundef 1), !dbg !128
  %6 = load i32, i32* %5, align 4, !dbg !129
  %7 = icmp eq i32 %6, 0, !dbg !130
  %8 = zext i1 %7 to i32, !dbg !130
  call void @ldv_assert(i32 noundef %8), !dbg !131
  %9 = call i32 @__VERIFIER_nondet_int() #7, !dbg !132
  call void @llvm.dbg.value(metadata i32 %9, metadata !133, metadata !DIExpression()), !dbg !121
  %.not = icmp eq i32 %9, 0, !dbg !134
  br i1 %.not, label %10, label %14, !dbg !136

10:                                               ; preds = %1
  %11 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 1, !dbg !137
  store %struct.device* %11, %struct.device** @my_dev, align 8, !dbg !138
  %12 = call i32 @pthread_create(i64* noundef nonnull @t1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @my_callback, i8* noundef null) #7, !dbg !139
  %13 = call i32 @pthread_create(i64* noundef nonnull @t2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @my_callback, i8* noundef null) #7, !dbg !140
  br label %16, !dbg !141

14:                                               ; preds = %1
  call void @llvm.dbg.label(metadata !142), !dbg !143
  %15 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef %2) #8, !dbg !144
  br label %16, !dbg !145

16:                                               ; preds = %14, %10
  %.0 = phi i32 [ -1, %14 ], [ 0, %10 ], !dbg !121
  ret i32 %.0, !dbg !146
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #4

declare i32 @__VERIFIER_nondet_int() #3

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #5

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @my_drv_disconnect(%struct.my_data* noundef %0) #0 !dbg !147 {
  %2 = alloca i8*, align 8
  call void @llvm.dbg.value(metadata %struct.my_data* %0, metadata !150, metadata !DIExpression()), !dbg !151
  %3 = load i64, i64* @t1, align 8, !dbg !152
  call void @llvm.dbg.value(metadata i8** %2, metadata !153, metadata !DIExpression(DW_OP_deref)), !dbg !151
  %4 = call i32 @pthread_join(i64 noundef %3, i8** noundef nonnull %2) #7, !dbg !154
  %5 = load i64, i64* @t2, align 8, !dbg !155
  %6 = call i32 @pthread_join(i64 noundef %5, i8** noundef nonnull %2) #7, !dbg !156
  %7 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 0, !dbg !157
  %8 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef %7) #8, !dbg !158
  ret void, !dbg !159
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @my_drv_init() #0 !dbg !160 {
  ret i32 0, !dbg !163
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @my_drv_cleanup() #0 !dbg !164 {
  ret void, !dbg !165
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !166 {
  %1 = alloca %struct.my_data, align 8
  %2 = call i32 @my_drv_init(), !dbg !167
  call void @llvm.dbg.value(metadata i32 %2, metadata !168, metadata !DIExpression()), !dbg !169
  %3 = icmp eq i32 %2, 0, !dbg !170
  br i1 %3, label %4, label %22, !dbg !172

4:                                                ; preds = %0
  call void @llvm.dbg.declare(metadata %struct.my_data* %1, metadata !173, metadata !DIExpression()), !dbg !175
  %5 = call i32 @my_drv_probe(%struct.my_data* noundef nonnull %1), !dbg !176
  call void @llvm.dbg.value(metadata i32 %5, metadata !177, metadata !DIExpression()), !dbg !178
  %6 = icmp eq i32 %5, 0, !dbg !179
  br i1 %6, label %7, label %16, !dbg !181

7:                                                ; preds = %4
  call void @my_drv_disconnect(%struct.my_data* noundef nonnull %1), !dbg !182
  %8 = getelementptr inbounds %struct.my_data, %struct.my_data* %1, i64 0, i32 2, i32 0, !dbg !184
  %9 = load i32, i32* %8, align 8, !dbg !184
  %10 = icmp eq i32 %9, 1, !dbg !185
  %11 = zext i1 %10 to i32, !dbg !185
  call void @ldv_assert(i32 noundef %11), !dbg !186
  %12 = getelementptr inbounds %struct.my_data, %struct.my_data* %1, i64 0, i32 2, i32 1, !dbg !187
  %13 = load i32, i32* %12, align 4, !dbg !187
  %14 = icmp eq i32 %13, 2, !dbg !188
  %15 = zext i1 %14 to i32, !dbg !188
  call void @ldv_assert(i32 noundef %15), !dbg !189
  br label %16, !dbg !190

16:                                               ; preds = %7, %4
  call void @my_drv_cleanup(), !dbg !191
  %17 = getelementptr inbounds %struct.my_data, %struct.my_data* %1, i64 0, i32 2, i32 0, !dbg !192
  store i32 -1, i32* %17, align 8, !dbg !193
  %18 = getelementptr inbounds %struct.my_data, %struct.my_data* %1, i64 0, i32 2, i32 1, !dbg !194
  store i32 -1, i32* %18, align 4, !dbg !195
  call void @ldv_assert(i32 noundef 1), !dbg !196
  %19 = load i32, i32* %18, align 4, !dbg !197
  %20 = icmp eq i32 %19, -1, !dbg !198
  %21 = zext i1 %20 to i32, !dbg !198
  call void @ldv_assert(i32 noundef %21), !dbg !199
  br label %22, !dbg !200

22:                                               ; preds = %16, %0
  ret i32 0, !dbg !201
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nocallback nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nocallback noreturn nounwind }
attributes #7 = { nounwind }
attributes #8 = { nocallback nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!63, !64, !65, !66, !67, !68, !69}
!llvm.ident = !{!70}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "my_dev", scope: !2, file: !7, line: 1688, type: !62, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !56, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/ldv-races/race-3_2-container_of-global.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "b75de761f460ce8c5878aa29e403a1a3")
!4 = !{!5, !53, !54, !55}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "my_data", file: !7, line: 1683, size: 320, elements: !8)
!7 = !DIFile(filename: "../sv-benchmarks/c/ldv-races/race-3_2-container_of-global.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "b75de761f460ce8c5878aa29e403a1a3")
!8 = !{!9, !45, !48}
!9 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !6, file: !7, line: 1684, baseType: !10, size: 256)
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !7, line: 306, baseType: !11)
!11 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !7, line: 301, size: 256, elements: !12)
!12 = !{!13, !38, !43}
!13 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !11, file: !7, line: 303, baseType: !14, size: 256)
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !7, line: 241, size: 256, elements: !15)
!15 = !{!16, !18, !20, !21, !22, !23}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !14, file: !7, line: 243, baseType: !17, size: 32)
!17 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !14, file: !7, line: 244, baseType: !19, size: 32, offset: 32)
!19 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !14, file: !7, line: 245, baseType: !17, size: 32, offset: 64)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !14, file: !7, line: 246, baseType: !17, size: 32, offset: 96)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !14, file: !7, line: 248, baseType: !19, size: 32, offset: 128)
!23 = !DIDerivedType(tag: DW_TAG_member, scope: !14, file: !7, line: 249, baseType: !24, size: 64, offset: 192)
!24 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !14, file: !7, line: 249, size: 64, elements: !25)
!25 = !{!26, !32}
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__elision_data", scope: !24, file: !7, line: 251, baseType: !27, size: 32)
!27 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !24, file: !7, line: 251, size: 32, elements: !28)
!28 = !{!29, !31}
!29 = !DIDerivedType(tag: DW_TAG_member, name: "__espins", scope: !27, file: !7, line: 251, baseType: !30, size: 16)
!30 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "__eelision", scope: !27, file: !7, line: 251, baseType: !30, size: 16, offset: 16)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !24, file: !7, line: 252, baseType: !33, size: 64)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_slist_t", file: !7, line: 240, baseType: !34)
!34 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_slist", file: !7, line: 237, size: 64, elements: !35)
!35 = !{!36}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !34, file: !7, line: 239, baseType: !37, size: 64)
!37 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !11, file: !7, line: 304, baseType: !39, size: 192)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 192, elements: !41)
!40 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!41 = !{!42}
!42 = !DISubrange(count: 24)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !11, file: !7, line: 305, baseType: !44, size: 64)
!44 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "dev", scope: !6, file: !7, line: 1685, baseType: !46, offset: 256)
!46 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "device", file: !7, line: 1677, elements: !47)
!47 = !{}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "shared", scope: !6, file: !7, line: 1686, baseType: !49, size: 64, offset: 256)
!49 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "A", file: !7, line: 1679, size: 64, elements: !50)
!50 = !{!51, !52}
!51 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !49, file: !7, line: 1680, baseType: !17, size: 32)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !49, file: !7, line: 1681, baseType: !17, size: 32, offset: 32)
!53 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!54 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!56 = !{!57, !60, !0}
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(name: "t1", scope: !2, file: !7, line: 1676, type: !59, isLocal: false, isDefinition: true)
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !7, line: 282, baseType: !54)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "t2", scope: !2, file: !7, line: 1676, type: !59, isLocal: false, isDefinition: true)
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!63 = !{i32 7, !"Dwarf Version", i32 5}
!64 = !{i32 2, !"Debug Info Version", i32 3}
!65 = !{i32 1, !"wchar_size", i32 4}
!66 = !{i32 7, !"PIC Level", i32 2}
!67 = !{i32 7, !"PIE Level", i32 2}
!68 = !{i32 7, !"uwtable", i32 1}
!69 = !{i32 7, !"frame-pointer", i32 2}
!70 = !{!"Ubuntu clang version 14.0.6"}
!71 = distinct !DISubprogram(name: "reach_error", scope: !7, file: !7, line: 1671, type: !72, scopeLine: 1671, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!72 = !DISubroutineType(types: !73)
!73 = !{null}
!74 = !DILocation(line: 1671, column: 83, scope: !75)
!75 = distinct !DILexicalBlock(scope: !76, file: !7, line: 1671, column: 73)
!76 = distinct !DILexicalBlock(scope: !71, file: !7, line: 1671, column: 67)
!77 = distinct !DISubprogram(name: "ldv_assert", scope: !7, file: !7, line: 1675, type: !78, scopeLine: 1675, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!78 = !DISubroutineType(types: !79)
!79 = !{null, !17}
!80 = !DILocalVariable(name: "expression", arg: 1, scope: !77, file: !7, line: 1675, type: !17)
!81 = !DILocation(line: 0, scope: !77)
!82 = !DILocation(line: 1675, column: 40, scope: !83)
!83 = distinct !DILexicalBlock(scope: !77, file: !7, line: 1675, column: 39)
!84 = !DILocation(line: 1675, column: 39, scope: !77)
!85 = !DILabel(scope: !86, name: "ERROR", file: !7, line: 1675)
!86 = distinct !DILexicalBlock(scope: !83, file: !7, line: 1675, column: 52)
!87 = !DILocation(line: 1675, column: 54, scope: !86)
!88 = !DILocation(line: 1675, column: 62, scope: !89)
!89 = distinct !DILexicalBlock(scope: !86, file: !7, line: 1675, column: 61)
!90 = !DILocation(line: 1675, column: 76, scope: !89)
!91 = !DILocation(line: 1675, column: 88, scope: !77)
!92 = distinct !DISubprogram(name: "my_callback", scope: !7, file: !7, line: 1689, type: !93, scopeLine: 1689, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!93 = !DISubroutineType(types: !94)
!94 = !{!55, !55}
!95 = !DILocalVariable(name: "arg", arg: 1, scope: !92, file: !7, line: 1689, type: !55)
!96 = !DILocation(line: 0, scope: !92)
!97 = !DILocation(line: 1691, column: 66, scope: !98)
!98 = distinct !DILexicalBlock(scope: !92, file: !7, line: 1691, column: 10)
!99 = !DILocalVariable(name: "__mptr", scope: !98, file: !7, line: 1691, type: !100)
!100 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !101, size: 64)
!101 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !46)
!102 = !DILocation(line: 0, scope: !98)
!103 = !DILocalVariable(name: "data", scope: !92, file: !7, line: 1690, type: !5)
!104 = !DILocation(line: 1692, column: 5, scope: !92)
!105 = !DILocation(line: 1693, column: 18, scope: !92)
!106 = !DILocation(line: 1693, column: 20, scope: !92)
!107 = !DILocation(line: 1694, column: 5, scope: !92)
!108 = !DILocation(line: 1695, column: 5, scope: !92)
!109 = !DILocation(line: 1696, column: 27, scope: !92)
!110 = !DILocalVariable(name: "lb", scope: !92, file: !7, line: 1696, type: !17)
!111 = !DILocation(line: 1697, column: 5, scope: !92)
!112 = !DILocation(line: 1698, column: 5, scope: !92)
!113 = !DILocation(line: 1699, column: 25, scope: !92)
!114 = !DILocation(line: 1699, column: 20, scope: !92)
!115 = !DILocation(line: 1700, column: 5, scope: !92)
!116 = !DILocation(line: 1701, column: 2, scope: !92)
!117 = distinct !DISubprogram(name: "my_drv_probe", scope: !7, file: !7, line: 1703, type: !118, scopeLine: 1703, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!118 = !DISubroutineType(types: !119)
!119 = !{!17, !5}
!120 = !DILocalVariable(name: "data", arg: 1, scope: !117, file: !7, line: 1703, type: !5)
!121 = !DILocation(line: 0, scope: !117)
!122 = !DILocation(line: 1704, column: 28, scope: !117)
!123 = !DILocation(line: 1704, column: 2, scope: !117)
!124 = !DILocation(line: 1705, column: 15, scope: !117)
!125 = !DILocation(line: 1705, column: 17, scope: !117)
!126 = !DILocation(line: 1706, column: 15, scope: !117)
!127 = !DILocation(line: 1706, column: 17, scope: !117)
!128 = !DILocation(line: 1707, column: 2, scope: !117)
!129 = !DILocation(line: 1708, column: 26, scope: !117)
!130 = !DILocation(line: 1708, column: 27, scope: !117)
!131 = !DILocation(line: 1708, column: 2, scope: !117)
!132 = !DILocation(line: 1709, column: 12, scope: !117)
!133 = !DILocalVariable(name: "res", scope: !117, file: !7, line: 1709, type: !17)
!134 = !DILocation(line: 1710, column: 5, scope: !135)
!135 = distinct !DILexicalBlock(scope: !117, file: !7, line: 1710, column: 5)
!136 = !DILocation(line: 1710, column: 5, scope: !117)
!137 = !DILocation(line: 1712, column: 18, scope: !117)
!138 = !DILocation(line: 1712, column: 9, scope: !117)
!139 = !DILocation(line: 1713, column: 2, scope: !117)
!140 = !DILocation(line: 1714, column: 2, scope: !117)
!141 = !DILocation(line: 1715, column: 2, scope: !117)
!142 = !DILabel(scope: !117, name: "exit", file: !7, line: 1716)
!143 = !DILocation(line: 1716, column: 1, scope: !117)
!144 = !DILocation(line: 1717, column: 2, scope: !117)
!145 = !DILocation(line: 1718, column: 2, scope: !117)
!146 = !DILocation(line: 1719, column: 1, scope: !117)
!147 = distinct !DISubprogram(name: "my_drv_disconnect", scope: !7, file: !7, line: 1720, type: !148, scopeLine: 1720, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!148 = !DISubroutineType(types: !149)
!149 = !{null, !5}
!150 = !DILocalVariable(name: "data", arg: 1, scope: !147, file: !7, line: 1720, type: !5)
!151 = !DILocation(line: 0, scope: !147)
!152 = !DILocation(line: 1722, column: 15, scope: !147)
!153 = !DILocalVariable(name: "status", scope: !147, file: !7, line: 1721, type: !55)
!154 = !DILocation(line: 1722, column: 2, scope: !147)
!155 = !DILocation(line: 1723, column: 15, scope: !147)
!156 = !DILocation(line: 1723, column: 2, scope: !147)
!157 = !DILocation(line: 1724, column: 31, scope: !147)
!158 = !DILocation(line: 1724, column: 2, scope: !147)
!159 = !DILocation(line: 1725, column: 1, scope: !147)
!160 = distinct !DISubprogram(name: "my_drv_init", scope: !7, file: !7, line: 1726, type: !161, scopeLine: 1726, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!161 = !DISubroutineType(types: !162)
!162 = !{!17}
!163 = !DILocation(line: 1727, column: 2, scope: !160)
!164 = distinct !DISubprogram(name: "my_drv_cleanup", scope: !7, file: !7, line: 1729, type: !72, scopeLine: 1729, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!165 = !DILocation(line: 1730, column: 2, scope: !164)
!166 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 1732, type: !161, scopeLine: 1732, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!167 = !DILocation(line: 1733, column: 12, scope: !166)
!168 = !DILocalVariable(name: "ret", scope: !166, file: !7, line: 1733, type: !17)
!169 = !DILocation(line: 0, scope: !166)
!170 = !DILocation(line: 1734, column: 8, scope: !171)
!171 = distinct !DILexicalBlock(scope: !166, file: !7, line: 1734, column: 5)
!172 = !DILocation(line: 1734, column: 5, scope: !166)
!173 = !DILocalVariable(name: "data", scope: !174, file: !7, line: 1736, type: !6)
!174 = distinct !DILexicalBlock(scope: !171, file: !7, line: 1734, column: 13)
!175 = !DILocation(line: 1736, column: 18, scope: !174)
!176 = !DILocation(line: 1737, column: 15, scope: !174)
!177 = !DILocalVariable(name: "probe_ret", scope: !174, file: !7, line: 1735, type: !17)
!178 = !DILocation(line: 0, scope: !174)
!179 = !DILocation(line: 1738, column: 15, scope: !180)
!180 = distinct !DILexicalBlock(scope: !174, file: !7, line: 1738, column: 6)
!181 = !DILocation(line: 1738, column: 6, scope: !174)
!182 = !DILocation(line: 1739, column: 4, scope: !183)
!183 = distinct !DILexicalBlock(scope: !180, file: !7, line: 1738, column: 20)
!184 = !DILocation(line: 1740, column: 27, scope: !183)
!185 = !DILocation(line: 1740, column: 28, scope: !183)
!186 = !DILocation(line: 1740, column: 4, scope: !183)
!187 = !DILocation(line: 1741, column: 27, scope: !183)
!188 = !DILocation(line: 1741, column: 28, scope: !183)
!189 = !DILocation(line: 1741, column: 4, scope: !183)
!190 = !DILocation(line: 1742, column: 3, scope: !183)
!191 = !DILocation(line: 1743, column: 3, scope: !174)
!192 = !DILocation(line: 1744, column: 15, scope: !174)
!193 = !DILocation(line: 1744, column: 17, scope: !174)
!194 = !DILocation(line: 1745, column: 15, scope: !174)
!195 = !DILocation(line: 1745, column: 17, scope: !174)
!196 = !DILocation(line: 1746, column: 3, scope: !174)
!197 = !DILocation(line: 1747, column: 26, scope: !174)
!198 = !DILocation(line: 1747, column: 27, scope: !174)
!199 = !DILocation(line: 1747, column: 3, scope: !174)
!200 = !DILocation(line: 1748, column: 2, scope: !174)
!201 = !DILocation(line: 1749, column: 2, scope: !166)
