; ModuleID = '/home/ponce/git/Dat3M/output/race-2_4-container_of.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/ldv-races/race-2_4-container_of.i"
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
@.str.1 = private unnamed_addr constant [24 x i8] c"race-2_4-container_of.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@t1 = dso_local global i64 0, align 8, !dbg !0
@t2 = dso_local global i64 0, align 8, !dbg !58

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !69 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([24 x i8], [24 x i8]* @.str.1, i64 0, i64 0), i32 noundef 14, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #6, !dbg !72
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
  call void @__VERIFIER_atomic_begin() #7, !dbg !105
  %5 = bitcast i8* %0 to i32*, !dbg !106
  store i32 1, i32* %5, align 8, !dbg !107
  call void @__VERIFIER_atomic_end() #7, !dbg !108
  call void @__VERIFIER_atomic_begin() #7, !dbg !109
  %6 = getelementptr inbounds i8, i8* %0, i64 4, !dbg !110
  %7 = bitcast i8* %6 to i32*, !dbg !110
  %8 = load i32, i32* %7, align 4, !dbg !110
  call void @llvm.dbg.value(metadata i32 %8, metadata !111, metadata !DIExpression()), !dbg !94
  call void @__VERIFIER_atomic_end() #7, !dbg !112
  call void @__VERIFIER_atomic_begin() #7, !dbg !113
  %9 = add nsw i32 %8, 1, !dbg !114
  store i32 %9, i32* %7, align 4, !dbg !115
  call void @__VERIFIER_atomic_end() #7, !dbg !116
  %10 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull %3) #7, !dbg !117
  ret i8* null, !dbg !118
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

declare void @__VERIFIER_atomic_begin() #4

declare void @__VERIFIER_atomic_end() #4

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @my_drv_probe(%struct.my_data* noundef %0) #0 !dbg !119 {
  call void @llvm.dbg.value(metadata %struct.my_data* %0, metadata !122, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata %struct.my_data* %0, metadata !124, metadata !DIExpression(DW_OP_plus_uconst, 32, DW_OP_stack_value)), !dbg !123
  %2 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 0, !dbg !125
  %3 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %2, %union.pthread_mutexattr_t* noundef null) #8, !dbg !126
  %4 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 2, i32 0, !dbg !127
  store i32 0, i32* %4, align 8, !dbg !128
  %5 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 2, i32 1, !dbg !129
  store i32 0, i32* %5, align 4, !dbg !130
  %6 = call i32 @__VERIFIER_nondet_int() #7, !dbg !131
  call void @llvm.dbg.value(metadata i32 %6, metadata !132, metadata !DIExpression()), !dbg !123
  %.not = icmp eq i32 %6, 0, !dbg !133
  br i1 %.not, label %7, label %12, !dbg !135

7:                                                ; preds = %1
  %8 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 1, !dbg !136
  call void @llvm.dbg.value(metadata %struct.device* %8, metadata !124, metadata !DIExpression()), !dbg !123
  %9 = bitcast %struct.device* %8 to i8*, !dbg !137
  %10 = call i32 @pthread_create(i64* noundef nonnull @t1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @my_callback, i8* noundef nonnull %9) #7, !dbg !138
  %11 = call i32 @pthread_create(i64* noundef nonnull @t2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @my_callback, i8* noundef nonnull %9) #7, !dbg !139
  br label %14, !dbg !140

12:                                               ; preds = %1
  call void @llvm.dbg.label(metadata !141), !dbg !142
  %13 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef %2) #8, !dbg !143
  br label %14, !dbg !144

14:                                               ; preds = %12, %7
  %.0 = phi i32 [ -1, %12 ], [ 0, %7 ], !dbg !123
  ret i32 %.0, !dbg !145
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #5

declare i32 @__VERIFIER_nondet_int() #4

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef) #5

; Function Attrs: noinline nounwind uwtable
define dso_local void @my_drv_disconnect(%struct.my_data* noundef %0) #0 !dbg !146 {
  %2 = alloca i8*, align 8
  call void @llvm.dbg.value(metadata %struct.my_data* %0, metadata !149, metadata !DIExpression()), !dbg !150
  call void @__VERIFIER_atomic_begin() #7, !dbg !151
  %3 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 2, i32 0, !dbg !152
  store i32 3, i32* %3, align 8, !dbg !153
  call void @__VERIFIER_atomic_end() #7, !dbg !154
  call void @__VERIFIER_atomic_begin() #7, !dbg !155
  %4 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 2, i32 1, !dbg !156
  store i32 3, i32* %4, align 4, !dbg !157
  call void @__VERIFIER_atomic_end() #7, !dbg !158
  call void @__VERIFIER_atomic_begin() #7, !dbg !159
  %5 = load i32, i32* %3, align 8, !dbg !160
  %6 = icmp eq i32 %5, 3, !dbg !161
  %7 = zext i1 %6 to i32, !dbg !161
  call void @ldv_assert(i32 noundef %7), !dbg !162
  call void @__VERIFIER_atomic_end() #7, !dbg !163
  call void @__VERIFIER_atomic_begin() #7, !dbg !164
  %8 = load i32, i32* %4, align 4, !dbg !165
  %9 = icmp eq i32 %8, 3, !dbg !166
  %10 = zext i1 %9 to i32, !dbg !166
  call void @ldv_assert(i32 noundef %10), !dbg !167
  call void @__VERIFIER_atomic_end() #7, !dbg !168
  %11 = load i64, i64* @t1, align 8, !dbg !169
  call void @llvm.dbg.value(metadata i8** %2, metadata !170, metadata !DIExpression(DW_OP_deref)), !dbg !150
  %12 = call i32 @pthread_join(i64 noundef %11, i8** noundef nonnull %2) #7, !dbg !171
  %13 = load i64, i64* @t2, align 8, !dbg !172
  %14 = call i32 @pthread_join(i64 noundef %13, i8** noundef nonnull %2) #7, !dbg !173
  %15 = getelementptr inbounds %struct.my_data, %struct.my_data* %0, i64 0, i32 0, !dbg !174
  %16 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef %15) #8, !dbg !175
  ret void, !dbg !176
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @my_drv_init() #0 !dbg !177 {
  ret i32 0, !dbg !180
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @my_drv_cleanup() #0 !dbg !181 {
  ret void, !dbg !182
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !183 {
  %1 = alloca %struct.my_data, align 8
  %2 = call i32 @my_drv_init(), !dbg !184
  call void @llvm.dbg.value(metadata i32 %2, metadata !185, metadata !DIExpression()), !dbg !186
  %3 = icmp eq i32 %2, 0, !dbg !187
  br i1 %3, label %4, label %22, !dbg !189

4:                                                ; preds = %0
  call void @llvm.dbg.declare(metadata %struct.my_data* %1, metadata !190, metadata !DIExpression()), !dbg !192
  %5 = call i32 @my_drv_probe(%struct.my_data* noundef nonnull %1), !dbg !193
  call void @llvm.dbg.value(metadata i32 %5, metadata !194, metadata !DIExpression()), !dbg !195
  %6 = icmp eq i32 %5, 0, !dbg !196
  br i1 %6, label %7, label %16, !dbg !198

7:                                                ; preds = %4
  call void @my_drv_disconnect(%struct.my_data* noundef nonnull %1), !dbg !199
  %8 = getelementptr inbounds %struct.my_data, %struct.my_data* %1, i64 0, i32 2, i32 0, !dbg !201
  %9 = load i32, i32* %8, align 8, !dbg !201
  %10 = icmp eq i32 %9, 1, !dbg !202
  %11 = zext i1 %10 to i32, !dbg !202
  call void @ldv_assert(i32 noundef %11), !dbg !203
  %12 = getelementptr inbounds %struct.my_data, %struct.my_data* %1, i64 0, i32 2, i32 1, !dbg !204
  %13 = load i32, i32* %12, align 4, !dbg !204
  %14 = icmp eq i32 %13, 2, !dbg !205
  %15 = zext i1 %14 to i32, !dbg !205
  call void @ldv_assert(i32 noundef %15), !dbg !206
  br label %16, !dbg !207

16:                                               ; preds = %7, %4
  call void @my_drv_cleanup(), !dbg !208
  %17 = getelementptr inbounds %struct.my_data, %struct.my_data* %1, i64 0, i32 2, i32 0, !dbg !209
  store i32 -1, i32* %17, align 8, !dbg !210
  %18 = getelementptr inbounds %struct.my_data, %struct.my_data* %1, i64 0, i32 2, i32 1, !dbg !211
  store i32 -1, i32* %18, align 4, !dbg !212
  call void @ldv_assert(i32 noundef 1), !dbg !213
  %19 = load i32, i32* %18, align 4, !dbg !214
  %20 = icmp eq i32 %19, -1, !dbg !215
  %21 = zext i1 %20 to i32, !dbg !215
  call void @ldv_assert(i32 noundef %21), !dbg !216
  br label %22, !dbg !217

22:                                               ; preds = %16, %0
  ret i32 0, !dbg !218
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nocallback nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nocallback noreturn nounwind }
attributes #7 = { nounwind }
attributes #8 = { nocallback nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!61, !62, !63, !64, !65, !66, !67}
!llvm.ident = !{!68}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "t1", scope: !2, file: !7, line: 1676, type: !60, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !57, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/ldv-races/race-2_4-container_of.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "78ca5a3018964385b3dd435533e0d9a1")
!4 = !{!5, !9, !54, !55, !56}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "device", file: !7, line: 1677, elements: !8)
!7 = !DIFile(filename: "../sv-benchmarks/c/ldv-races/race-2_4-container_of.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "78ca5a3018964385b3dd435533e0d9a1")
!8 = !{}
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!10 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "my_data", file: !7, line: 1683, size: 320, elements: !11)
!11 = !{!12, !48, !49}
!12 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !10, file: !7, line: 1684, baseType: !13, size: 256)
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !7, line: 306, baseType: !14)
!14 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !7, line: 301, size: 256, elements: !15)
!15 = !{!16, !41, !46}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !14, file: !7, line: 303, baseType: !17, size: 256)
!17 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !7, line: 241, size: 256, elements: !18)
!18 = !{!19, !21, !23, !24, !25, !26}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !17, file: !7, line: 243, baseType: !20, size: 32)
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !17, file: !7, line: 244, baseType: !22, size: 32, offset: 32)
!22 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !17, file: !7, line: 245, baseType: !20, size: 32, offset: 64)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !17, file: !7, line: 246, baseType: !20, size: 32, offset: 96)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !17, file: !7, line: 248, baseType: !22, size: 32, offset: 128)
!26 = !DIDerivedType(tag: DW_TAG_member, scope: !17, file: !7, line: 249, baseType: !27, size: 64, offset: 192)
!27 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !17, file: !7, line: 249, size: 64, elements: !28)
!28 = !{!29, !35}
!29 = !DIDerivedType(tag: DW_TAG_member, name: "__elision_data", scope: !27, file: !7, line: 251, baseType: !30, size: 32)
!30 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !27, file: !7, line: 251, size: 32, elements: !31)
!31 = !{!32, !34}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "__espins", scope: !30, file: !7, line: 251, baseType: !33, size: 16)
!33 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "__eelision", scope: !30, file: !7, line: 251, baseType: !33, size: 16, offset: 16)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !27, file: !7, line: 252, baseType: !36, size: 64)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_slist_t", file: !7, line: 240, baseType: !37)
!37 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_slist", file: !7, line: 237, size: 64, elements: !38)
!38 = !{!39}
!39 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !37, file: !7, line: 239, baseType: !40, size: 64)
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !14, file: !7, line: 304, baseType: !42, size: 192)
!42 = !DICompositeType(tag: DW_TAG_array_type, baseType: !43, size: 192, elements: !44)
!43 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!44 = !{!45}
!45 = !DISubrange(count: 24)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !14, file: !7, line: 305, baseType: !47, size: 64)
!47 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "dev", scope: !10, file: !7, line: 1685, baseType: !6, offset: 256)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "shared", scope: !10, file: !7, line: 1686, baseType: !50, size: 64, offset: 256)
!50 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "A", file: !7, line: 1679, size: 64, elements: !51)
!51 = !{!52, !53}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !50, file: !7, line: 1680, baseType: !20, size: 32)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !50, file: !7, line: 1681, baseType: !20, size: 32, offset: 32)
!54 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!55 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!57 = !{!0, !58}
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "t2", scope: !2, file: !7, line: 1676, type: !60, isLocal: false, isDefinition: true)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !7, line: 282, baseType: !55)
!61 = !{i32 7, !"Dwarf Version", i32 5}
!62 = !{i32 2, !"Debug Info Version", i32 3}
!63 = !{i32 1, !"wchar_size", i32 4}
!64 = !{i32 7, !"PIC Level", i32 2}
!65 = !{i32 7, !"PIE Level", i32 2}
!66 = !{i32 7, !"uwtable", i32 1}
!67 = !{i32 7, !"frame-pointer", i32 2}
!68 = !{!"Ubuntu clang version 14.0.6"}
!69 = distinct !DISubprogram(name: "reach_error", scope: !7, file: !7, line: 1671, type: !70, scopeLine: 1671, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !8)
!70 = !DISubroutineType(types: !71)
!71 = !{null}
!72 = !DILocation(line: 1671, column: 83, scope: !73)
!73 = distinct !DILexicalBlock(scope: !74, file: !7, line: 1671, column: 73)
!74 = distinct !DILexicalBlock(scope: !69, file: !7, line: 1671, column: 67)
!75 = distinct !DISubprogram(name: "ldv_assert", scope: !7, file: !7, line: 1675, type: !76, scopeLine: 1675, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !8)
!76 = !DISubroutineType(types: !77)
!77 = !{null, !20}
!78 = !DILocalVariable(name: "expression", arg: 1, scope: !75, file: !7, line: 1675, type: !20)
!79 = !DILocation(line: 0, scope: !75)
!80 = !DILocation(line: 1675, column: 40, scope: !81)
!81 = distinct !DILexicalBlock(scope: !75, file: !7, line: 1675, column: 39)
!82 = !DILocation(line: 1675, column: 39, scope: !75)
!83 = !DILabel(scope: !84, name: "ERROR", file: !7, line: 1675)
!84 = distinct !DILexicalBlock(scope: !81, file: !7, line: 1675, column: 52)
!85 = !DILocation(line: 1675, column: 54, scope: !84)
!86 = !DILocation(line: 1675, column: 62, scope: !87)
!87 = distinct !DILexicalBlock(scope: !84, file: !7, line: 1675, column: 61)
!88 = !DILocation(line: 1675, column: 76, scope: !87)
!89 = !DILocation(line: 1675, column: 88, scope: !75)
!90 = distinct !DISubprogram(name: "my_callback", scope: !7, file: !7, line: 1688, type: !91, scopeLine: 1688, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !8)
!91 = !DISubroutineType(types: !92)
!92 = !{!56, !56}
!93 = !DILocalVariable(name: "arg", arg: 1, scope: !90, file: !7, line: 1688, type: !56)
!94 = !DILocation(line: 0, scope: !90)
!95 = !DILocalVariable(name: "dev", scope: !90, file: !7, line: 1689, type: !5)
!96 = !DILocalVariable(name: "__mptr", scope: !97, file: !7, line: 1691, type: !98)
!97 = distinct !DILexicalBlock(scope: !90, file: !7, line: 1691, column: 10)
!98 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64)
!99 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!100 = !DILocation(line: 0, scope: !97)
!101 = !DILocation(line: 1691, column: 107, scope: !97)
!102 = !DILocalVariable(name: "data", scope: !90, file: !7, line: 1690, type: !9)
!103 = !DILocation(line: 1692, column: 29, scope: !90)
!104 = !DILocation(line: 1692, column: 2, scope: !90)
!105 = !DILocation(line: 1693, column: 2, scope: !90)
!106 = !DILocation(line: 1694, column: 15, scope: !90)
!107 = !DILocation(line: 1694, column: 17, scope: !90)
!108 = !DILocation(line: 1695, column: 2, scope: !90)
!109 = !DILocation(line: 1696, column: 2, scope: !90)
!110 = !DILocation(line: 1697, column: 24, scope: !90)
!111 = !DILocalVariable(name: "lb", scope: !90, file: !7, line: 1697, type: !20)
!112 = !DILocation(line: 1698, column: 2, scope: !90)
!113 = !DILocation(line: 1699, column: 2, scope: !90)
!114 = !DILocation(line: 1700, column: 22, scope: !90)
!115 = !DILocation(line: 1700, column: 17, scope: !90)
!116 = !DILocation(line: 1701, column: 2, scope: !90)
!117 = !DILocation(line: 1702, column: 2, scope: !90)
!118 = !DILocation(line: 1703, column: 2, scope: !90)
!119 = distinct !DISubprogram(name: "my_drv_probe", scope: !7, file: !7, line: 1705, type: !120, scopeLine: 1705, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !8)
!120 = !DISubroutineType(types: !121)
!121 = !{!20, !9}
!122 = !DILocalVariable(name: "data", arg: 1, scope: !119, file: !7, line: 1705, type: !9)
!123 = !DILocation(line: 0, scope: !119)
!124 = !DILocalVariable(name: "d", scope: !119, file: !7, line: 1706, type: !5)
!125 = !DILocation(line: 1707, column: 28, scope: !119)
!126 = !DILocation(line: 1707, column: 2, scope: !119)
!127 = !DILocation(line: 1708, column: 15, scope: !119)
!128 = !DILocation(line: 1708, column: 17, scope: !119)
!129 = !DILocation(line: 1709, column: 15, scope: !119)
!130 = !DILocation(line: 1709, column: 17, scope: !119)
!131 = !DILocation(line: 1710, column: 12, scope: !119)
!132 = !DILocalVariable(name: "res", scope: !119, file: !7, line: 1710, type: !20)
!133 = !DILocation(line: 1711, column: 5, scope: !134)
!134 = distinct !DILexicalBlock(scope: !119, file: !7, line: 1711, column: 5)
!135 = !DILocation(line: 1711, column: 5, scope: !119)
!136 = !DILocation(line: 1706, column: 28, scope: !119)
!137 = !DILocation(line: 1713, column: 48, scope: !119)
!138 = !DILocation(line: 1713, column: 2, scope: !119)
!139 = !DILocation(line: 1714, column: 2, scope: !119)
!140 = !DILocation(line: 1715, column: 2, scope: !119)
!141 = !DILabel(scope: !119, name: "exit", file: !7, line: 1716)
!142 = !DILocation(line: 1716, column: 1, scope: !119)
!143 = !DILocation(line: 1717, column: 2, scope: !119)
!144 = !DILocation(line: 1718, column: 2, scope: !119)
!145 = !DILocation(line: 1719, column: 1, scope: !119)
!146 = distinct !DISubprogram(name: "my_drv_disconnect", scope: !7, file: !7, line: 1720, type: !147, scopeLine: 1720, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !8)
!147 = !DISubroutineType(types: !148)
!148 = !{null, !9}
!149 = !DILocalVariable(name: "data", arg: 1, scope: !146, file: !7, line: 1720, type: !9)
!150 = !DILocation(line: 0, scope: !146)
!151 = !DILocation(line: 1722, column: 5, scope: !146)
!152 = !DILocation(line: 1723, column: 18, scope: !146)
!153 = !DILocation(line: 1723, column: 20, scope: !146)
!154 = !DILocation(line: 1724, column: 5, scope: !146)
!155 = !DILocation(line: 1725, column: 5, scope: !146)
!156 = !DILocation(line: 1726, column: 18, scope: !146)
!157 = !DILocation(line: 1726, column: 20, scope: !146)
!158 = !DILocation(line: 1727, column: 5, scope: !146)
!159 = !DILocation(line: 1728, column: 5, scope: !146)
!160 = !DILocation(line: 1729, column: 29, scope: !146)
!161 = !DILocation(line: 1729, column: 30, scope: !146)
!162 = !DILocation(line: 1729, column: 5, scope: !146)
!163 = !DILocation(line: 1730, column: 5, scope: !146)
!164 = !DILocation(line: 1731, column: 5, scope: !146)
!165 = !DILocation(line: 1732, column: 29, scope: !146)
!166 = !DILocation(line: 1732, column: 30, scope: !146)
!167 = !DILocation(line: 1732, column: 5, scope: !146)
!168 = !DILocation(line: 1733, column: 5, scope: !146)
!169 = !DILocation(line: 1734, column: 15, scope: !146)
!170 = !DILocalVariable(name: "status", scope: !146, file: !7, line: 1721, type: !56)
!171 = !DILocation(line: 1734, column: 2, scope: !146)
!172 = !DILocation(line: 1735, column: 15, scope: !146)
!173 = !DILocation(line: 1735, column: 2, scope: !146)
!174 = !DILocation(line: 1736, column: 31, scope: !146)
!175 = !DILocation(line: 1736, column: 2, scope: !146)
!176 = !DILocation(line: 1737, column: 1, scope: !146)
!177 = distinct !DISubprogram(name: "my_drv_init", scope: !7, file: !7, line: 1738, type: !178, scopeLine: 1738, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !8)
!178 = !DISubroutineType(types: !179)
!179 = !{!20}
!180 = !DILocation(line: 1739, column: 2, scope: !177)
!181 = distinct !DISubprogram(name: "my_drv_cleanup", scope: !7, file: !7, line: 1741, type: !70, scopeLine: 1741, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !8)
!182 = !DILocation(line: 1742, column: 2, scope: !181)
!183 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 1744, type: !178, scopeLine: 1744, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !8)
!184 = !DILocation(line: 1745, column: 12, scope: !183)
!185 = !DILocalVariable(name: "ret", scope: !183, file: !7, line: 1745, type: !20)
!186 = !DILocation(line: 0, scope: !183)
!187 = !DILocation(line: 1746, column: 8, scope: !188)
!188 = distinct !DILexicalBlock(scope: !183, file: !7, line: 1746, column: 5)
!189 = !DILocation(line: 1746, column: 5, scope: !183)
!190 = !DILocalVariable(name: "data", scope: !191, file: !7, line: 1748, type: !10)
!191 = distinct !DILexicalBlock(scope: !188, file: !7, line: 1746, column: 13)
!192 = !DILocation(line: 1748, column: 18, scope: !191)
!193 = !DILocation(line: 1749, column: 15, scope: !191)
!194 = !DILocalVariable(name: "probe_ret", scope: !191, file: !7, line: 1747, type: !20)
!195 = !DILocation(line: 0, scope: !191)
!196 = !DILocation(line: 1750, column: 15, scope: !197)
!197 = distinct !DILexicalBlock(scope: !191, file: !7, line: 1750, column: 6)
!198 = !DILocation(line: 1750, column: 6, scope: !191)
!199 = !DILocation(line: 1751, column: 4, scope: !200)
!200 = distinct !DILexicalBlock(scope: !197, file: !7, line: 1750, column: 20)
!201 = !DILocation(line: 1752, column: 27, scope: !200)
!202 = !DILocation(line: 1752, column: 28, scope: !200)
!203 = !DILocation(line: 1752, column: 4, scope: !200)
!204 = !DILocation(line: 1753, column: 27, scope: !200)
!205 = !DILocation(line: 1753, column: 28, scope: !200)
!206 = !DILocation(line: 1753, column: 4, scope: !200)
!207 = !DILocation(line: 1754, column: 3, scope: !200)
!208 = !DILocation(line: 1755, column: 3, scope: !191)
!209 = !DILocation(line: 1756, column: 15, scope: !191)
!210 = !DILocation(line: 1756, column: 17, scope: !191)
!211 = !DILocation(line: 1757, column: 15, scope: !191)
!212 = !DILocation(line: 1757, column: 17, scope: !191)
!213 = !DILocation(line: 1758, column: 3, scope: !191)
!214 = !DILocation(line: 1759, column: 26, scope: !191)
!215 = !DILocation(line: 1759, column: 27, scope: !191)
!216 = !DILocation(line: 1759, column: 3, scope: !191)
!217 = !DILocation(line: 1760, column: 2, scope: !191)
!218 = !DILocation(line: 1761, column: 2, scope: !183)
