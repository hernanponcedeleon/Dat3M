; ModuleID = '/home/ponce/git/Dat3M/output/NVR-RMW+Release.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lkmm/NVR-RMW+Release.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !35
@.str = private unnamed_addr constant [7 x i8] c"x == 1\00", align 1
@.str.1 = private unnamed_addr constant [56 x i8] c"/home/ponce/git/Dat3M/benchmarks/lkmm/NVR-RMW+Release.c\00", align 1
@__PRETTY_FUNCTION__.run = private unnamed_addr constant [18 x i8] c"void *run(void *)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @run(i8* noundef %0) #0 !dbg !51 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !55, metadata !DIExpression()), !dbg !56
  %2 = ptrtoint i8* %0 to i64, !dbg !57
  %3 = trunc i64 %2 to i32, !dbg !58
  call void @llvm.dbg.value(metadata i32 %3, metadata !59, metadata !DIExpression()), !dbg !56
  switch i32 %3, label %12 [
    i32 0, label %4
    i32 1, label %5
    i32 2, label %6
  ], !dbg !60

4:                                                ; preds = %1
  store i32 1, i32* @x, align 4, !dbg !61
  call void @__LKMM_STORE(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @y, i64 0, i32 0), i32 noundef 3, i32 noundef 3) #5, !dbg !63
  br label %12, !dbg !64

5:                                                ; preds = %1
  call void @__LKMM_ATOMIC_OP(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @y, i64 0, i32 0), i32 noundef -3, i32 noundef 2) #5, !dbg !65
  br label %12, !dbg !66

6:                                                ; preds = %1
  %7 = call i32 @__LKMM_LOAD(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @y, i64 0, i32 0), i32 noundef 2) #5, !dbg !67
  %8 = icmp ne i32 %7, 1, !dbg !69
  %9 = load i32, i32* @x, align 4
  %10 = icmp eq i32 %9, 1
  %or.cond = select i1 %8, i1 true, i1 %10, !dbg !70
  br i1 %or.cond, label %12, label %11, !dbg !70

11:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([56 x i8], [56 x i8]* @.str.1, i64 0, i64 0), i32 noundef 28, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #6, !dbg !71
  unreachable, !dbg !71

12:                                               ; preds = %6, %5, %4, %1
  ret i8* null, !dbg !75
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_STORE(i32* noundef, i32 noundef, i32 noundef) #2

declare void @__LKMM_ATOMIC_OP(i32* noundef, i32 noundef, i32 noundef) #2

declare i32 @__LKMM_LOAD(i32* noundef, i32 noundef) #2

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !76 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !79, metadata !DIExpression(DW_OP_deref)), !dbg !83
  %4 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @run, i8* noundef null) #5, !dbg !84
  call void @llvm.dbg.value(metadata i64* %2, metadata !85, metadata !DIExpression(DW_OP_deref)), !dbg !83
  %5 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @run, i8* noundef nonnull inttoptr (i64 1 to i8*)) #5, !dbg !86
  call void @llvm.dbg.value(metadata i64* %3, metadata !87, metadata !DIExpression(DW_OP_deref)), !dbg !83
  %6 = call i32 @pthread_create(i64* noundef nonnull %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @run, i8* noundef nonnull inttoptr (i64 2 to i8*)) #5, !dbg !88
  %7 = load i64, i64* %1, align 8, !dbg !89
  call void @llvm.dbg.value(metadata i64 %7, metadata !79, metadata !DIExpression()), !dbg !83
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null) #5, !dbg !90
  %9 = load i64, i64* %2, align 8, !dbg !91
  call void @llvm.dbg.value(metadata i64 %9, metadata !85, metadata !DIExpression()), !dbg !83
  %10 = call i32 @pthread_join(i64 noundef %9, i8** noundef null) #5, !dbg !92
  %11 = load i64, i64* %3, align 8, !dbg !93
  call void @llvm.dbg.value(metadata i64 %11, metadata !87, metadata !DIExpression()), !dbg !83
  %12 = call i32 @pthread_join(i64 noundef %11, i8** noundef null) #5, !dbg !94
  ret i32 0, !dbg !95
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #4

declare i32 @pthread_join(i64 noundef, i8** noundef) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!43, !44, !45, !46, !47, !48, !49}
!llvm.ident = !{!50}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !37, line: 5, type: !42, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !29, globals: !34, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lkmm/NVR-RMW+Release.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "288212c519a14c4a96e909a8b480bc52")
!4 = !{!5, !23}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "f05598c4633ab3767f78c4bb572c0073")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_once", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "mb", value: 4)
!14 = !DIEnumerator(name: "wmb", value: 5)
!15 = !DIEnumerator(name: "rmb", value: 6)
!16 = !DIEnumerator(name: "rcu_lock", value: 7)
!17 = !DIEnumerator(name: "rcu_unlock", value: 8)
!18 = !DIEnumerator(name: "rcu_sync", value: 9)
!19 = !DIEnumerator(name: "before_atomic", value: 10)
!20 = !DIEnumerator(name: "after_atomic", value: 11)
!21 = !DIEnumerator(name: "after_spinlock", value: 12)
!22 = !DIEnumerator(name: "barrier", value: 13)
!23 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "operation", file: !6, line: 20, baseType: !7, size: 32, elements: !24)
!24 = !{!25, !26, !27, !28}
!25 = !DIEnumerator(name: "op_add", value: 0)
!26 = !DIEnumerator(name: "op_sub", value: 1)
!27 = !DIEnumerator(name: "op_and", value: 2)
!28 = !DIEnumerator(name: "op_or", value: 3)
!29 = !{!30, !33}
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !31, line: 87, baseType: !32)
!31 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!32 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!33 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!34 = !{!0, !35}
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !37, line: 6, type: !38, isLocal: false, isDefinition: true)
!37 = !DIFile(filename: "benchmarks/lkmm/NVR-RMW+Release.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "288212c519a14c4a96e909a8b480bc52")
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 95, baseType: !39)
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 93, size: 32, elements: !40)
!40 = !{!41}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !39, file: !6, line: 94, baseType: !42, size: 32)
!42 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!43 = !{i32 7, !"Dwarf Version", i32 5}
!44 = !{i32 2, !"Debug Info Version", i32 3}
!45 = !{i32 1, !"wchar_size", i32 4}
!46 = !{i32 7, !"PIC Level", i32 2}
!47 = !{i32 7, !"PIE Level", i32 2}
!48 = !{i32 7, !"uwtable", i32 1}
!49 = !{i32 7, !"frame-pointer", i32 2}
!50 = !{!"Ubuntu clang version 14.0.6"}
!51 = distinct !DISubprogram(name: "run", scope: !37, file: !37, line: 15, type: !52, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!52 = !DISubroutineType(types: !53)
!53 = !{!33, !33}
!54 = !{}
!55 = !DILocalVariable(name: "arg", arg: 1, scope: !51, file: !37, line: 15, type: !33)
!56 = !DILocation(line: 0, scope: !51)
!57 = !DILocation(line: 17, column: 16, scope: !51)
!58 = !DILocation(line: 17, column: 15, scope: !51)
!59 = !DILocalVariable(name: "tid", scope: !51, file: !37, line: 17, type: !42)
!60 = !DILocation(line: 18, column: 5, scope: !51)
!61 = !DILocation(line: 20, column: 11, scope: !62)
!62 = distinct !DILexicalBlock(scope: !51, file: !37, line: 18, column: 18)
!63 = !DILocation(line: 21, column: 9, scope: !62)
!64 = !DILocation(line: 22, column: 9, scope: !62)
!65 = !DILocation(line: 24, column: 9, scope: !62)
!66 = !DILocation(line: 25, column: 9, scope: !62)
!67 = !DILocation(line: 27, column: 13, scope: !68)
!68 = distinct !DILexicalBlock(scope: !62, file: !37, line: 27, column: 13)
!69 = !DILocation(line: 27, column: 42, scope: !68)
!70 = !DILocation(line: 27, column: 13, scope: !62)
!71 = !DILocation(line: 28, column: 13, scope: !72)
!72 = distinct !DILexicalBlock(scope: !73, file: !37, line: 28, column: 13)
!73 = distinct !DILexicalBlock(scope: !74, file: !37, line: 28, column: 13)
!74 = distinct !DILexicalBlock(scope: !68, file: !37, line: 27, column: 50)
!75 = !DILocation(line: 32, column: 5, scope: !51)
!76 = distinct !DISubprogram(name: "main", scope: !37, file: !37, line: 34, type: !77, scopeLine: 35, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!77 = !DISubroutineType(types: !78)
!78 = !{!42}
!79 = !DILocalVariable(name: "t0", scope: !76, file: !37, line: 36, type: !80)
!80 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !81, line: 27, baseType: !82)
!81 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!82 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!83 = !DILocation(line: 0, scope: !76)
!84 = !DILocation(line: 37, column: 5, scope: !76)
!85 = !DILocalVariable(name: "t1", scope: !76, file: !37, line: 36, type: !80)
!86 = !DILocation(line: 38, column: 5, scope: !76)
!87 = !DILocalVariable(name: "t2", scope: !76, file: !37, line: 36, type: !80)
!88 = !DILocation(line: 39, column: 5, scope: !76)
!89 = !DILocation(line: 41, column: 18, scope: !76)
!90 = !DILocation(line: 41, column: 5, scope: !76)
!91 = !DILocation(line: 42, column: 18, scope: !76)
!92 = !DILocation(line: 42, column: 5, scope: !76)
!93 = !DILocation(line: 43, column: 18, scope: !76)
!94 = !DILocation(line: 43, column: 5, scope: !76)
!95 = !DILocation(line: 45, column: 5, scope: !76)
