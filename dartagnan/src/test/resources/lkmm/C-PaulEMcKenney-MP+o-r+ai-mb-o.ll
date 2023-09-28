; ModuleID = '/home/ponce/git/Dat3M/output/C-PaulEMcKenney-MP+o-r+ai-mb-o.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lkmm/C-PaulEMcKenney-MP+o-r+ai-mb-o.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !0
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !32
@r0 = dso_local global i32 0, align 4, !dbg !40
@r1 = dso_local global i32 0, align 4, !dbg !42
@.str = private unnamed_addr constant [18 x i8] c"!(r0==0 && r1==0)\00", align 1
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/ponce/git/Dat3M/benchmarks/lkmm/C-PaulEMcKenney-MP+o-r+ai-mb-o.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !52 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !56, metadata !DIExpression()), !dbg !57
  call void @__LKMM_STORE(i8* noundef bitcast (%struct.atomic_t* @x to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !58
  %2 = call i32 @__LKMM_XCHG(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @y, i64 0, i32 0), i32 noundef 5, i32 noundef 3) #5, !dbg !59
  store i32 %2, i32* @r0, align 4, !dbg !60
  ret i8* null, !dbg !61
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_STORE(i8* noundef, i32 noundef, i32 noundef) #2

declare i32 @__LKMM_XCHG(i32* noundef, i32 noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !62 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !63, metadata !DIExpression()), !dbg !64
  call void @__LKMM_ATOMIC_OP(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @y, i64 0, i32 0), i32 noundef 1, i32 noundef 0) #5, !dbg !65
  call void @__LKMM_FENCE(i32 noundef 4) #5, !dbg !66
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (%struct.atomic_t* @x to i8*), i32 noundef 1) #5, !dbg !67
  store i32 %2, i32* @r1, align 4, !dbg !68
  ret i8* null, !dbg !69
}

declare void @__LKMM_ATOMIC_OP(i32* noundef, i32 noundef, i32 noundef) #2

declare void @__LKMM_FENCE(i32 noundef) #2

declare i32 @__LKMM_LOAD(i8* noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !70 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !73, metadata !DIExpression(DW_OP_deref)), !dbg !77
  %3 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_1, i8* noundef null) #5, !dbg !78
  call void @llvm.dbg.value(metadata i64* %2, metadata !79, metadata !DIExpression(DW_OP_deref)), !dbg !77
  %4 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_2, i8* noundef null) #5, !dbg !80
  %5 = load i64, i64* %1, align 8, !dbg !81
  call void @llvm.dbg.value(metadata i64 %5, metadata !73, metadata !DIExpression()), !dbg !77
  %6 = call i32 @pthread_join(i64 noundef %5, i8** noundef null) #5, !dbg !82
  %7 = load i64, i64* %2, align 8, !dbg !83
  call void @llvm.dbg.value(metadata i64 %7, metadata !79, metadata !DIExpression()), !dbg !77
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null) #5, !dbg !84
  %9 = load i32, i32* @r0, align 4, !dbg !85
  %10 = icmp eq i32 %9, 0, !dbg !85
  %11 = load i32, i32* @r1, align 4, !dbg !85
  %12 = icmp eq i32 %11, 0, !dbg !85
  %or.cond = select i1 %10, i1 %12, i1 false, !dbg !85
  br i1 %or.cond, label %13, label %14, !dbg !85

13:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i64 0, i64 0), i32 noundef 36, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !85
  unreachable, !dbg !85

14:                                               ; preds = %0
  ret i32 0, !dbg !88
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #2

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!44, !45, !46, !47, !48, !49, !50}
!llvm.ident = !{!51}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !34, line: 8, type: !35, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !29, globals: !31, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lkmm/C-PaulEMcKenney-MP+o-r+ai-mb-o.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "1308844795e51ccd8aeabdd44c0d7613")
!4 = !{!5, !23}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "f219e5a4f2482585588927d06bb5e5c6")
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
!29 = !{!30}
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!31 = !{!0, !32, !40, !42}
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !34, line: 8, type: !35, isLocal: false, isDefinition: true)
!34 = !DIFile(filename: "benchmarks/lkmm/C-PaulEMcKenney-MP+o-r+ai-mb-o.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "1308844795e51ccd8aeabdd44c0d7613")
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 95, baseType: !36)
!36 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 93, size: 32, elements: !37)
!37 = !{!38}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !36, file: !6, line: 94, baseType: !39, size: 32)
!39 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !34, line: 9, type: !39, isLocal: false, isDefinition: true)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "r1", scope: !2, file: !34, line: 9, type: !39, isLocal: false, isDefinition: true)
!44 = !{i32 7, !"Dwarf Version", i32 5}
!45 = !{i32 2, !"Debug Info Version", i32 3}
!46 = !{i32 1, !"wchar_size", i32 4}
!47 = !{i32 7, !"PIC Level", i32 2}
!48 = !{i32 7, !"PIE Level", i32 2}
!49 = !{i32 7, !"uwtable", i32 1}
!50 = !{i32 7, !"frame-pointer", i32 2}
!51 = !{!"Ubuntu clang version 14.0.6"}
!52 = distinct !DISubprogram(name: "thread_1", scope: !34, file: !34, line: 11, type: !53, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!53 = !DISubroutineType(types: !54)
!54 = !{!30, !30}
!55 = !{}
!56 = !DILocalVariable(name: "arg", arg: 1, scope: !52, file: !34, line: 11, type: !30)
!57 = !DILocation(line: 0, scope: !52)
!58 = !DILocation(line: 13, column: 2, scope: !52)
!59 = !DILocation(line: 14, column: 7, scope: !52)
!60 = !DILocation(line: 14, column: 5, scope: !52)
!61 = !DILocation(line: 15, column: 2, scope: !52)
!62 = distinct !DISubprogram(name: "thread_2", scope: !34, file: !34, line: 18, type: !53, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!63 = !DILocalVariable(name: "arg", arg: 1, scope: !62, file: !34, line: 18, type: !30)
!64 = !DILocation(line: 0, scope: !62)
!65 = !DILocation(line: 20, column: 2, scope: !62)
!66 = !DILocation(line: 21, column: 2, scope: !62)
!67 = !DILocation(line: 22, column: 7, scope: !62)
!68 = !DILocation(line: 22, column: 5, scope: !62)
!69 = !DILocation(line: 23, column: 2, scope: !62)
!70 = distinct !DISubprogram(name: "main", scope: !34, file: !34, line: 26, type: !71, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!71 = !DISubroutineType(types: !72)
!72 = !{!39}
!73 = !DILocalVariable(name: "t1", scope: !70, file: !34, line: 28, type: !74)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !75, line: 27, baseType: !76)
!75 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!76 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!77 = !DILocation(line: 0, scope: !70)
!78 = !DILocation(line: 30, column: 5, scope: !70)
!79 = !DILocalVariable(name: "t2", scope: !70, file: !34, line: 28, type: !74)
!80 = !DILocation(line: 31, column: 5, scope: !70)
!81 = !DILocation(line: 33, column: 18, scope: !70)
!82 = !DILocation(line: 33, column: 5, scope: !70)
!83 = !DILocation(line: 34, column: 18, scope: !70)
!84 = !DILocation(line: 34, column: 5, scope: !70)
!85 = !DILocation(line: 36, column: 5, scope: !86)
!86 = distinct !DILexicalBlock(scope: !87, file: !34, line: 36, column: 5)
!87 = distinct !DILexicalBlock(scope: !70, file: !34, line: 36, column: 5)
!88 = !DILocation(line: 38, column: 5, scope: !70)
