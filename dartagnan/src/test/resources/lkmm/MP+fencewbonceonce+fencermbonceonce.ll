; ModuleID = '/home/ponce/git/Dat3M/output/MP+fencewbonceonce+fencermbonceonce.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lkmm/MP+fencewbonceonce+fencermbonceonce.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !26
@r0 = dso_local global i32 0, align 4, !dbg !30
@r1 = dso_local global i32 0, align 4, !dbg !32
@.str = private unnamed_addr constant [22 x i8] c"!(r0 == 1 && r1 == 0)\00", align 1
@.str.1 = private unnamed_addr constant [76 x i8] c"/home/ponce/git/Dat3M/benchmarks/lkmm/MP+fencewbonceonce+fencermbonceonce.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P0(i8* noundef %0) #0 !dbg !42 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !46, metadata !DIExpression()), !dbg !47
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !48
  call void @__LKMM_FENCE(i32 noundef 5) #5, !dbg !49
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @y to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !50
  ret i8* null, !dbg !51
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_STORE(i8* noundef, i32 noundef, i32 noundef) #2

declare void @__LKMM_FENCE(i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P1(i8* noundef %0) #0 !dbg !52 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !53, metadata !DIExpression()), !dbg !54
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @y to i8*), i32 noundef 1) #5, !dbg !55
  store i32 %2, i32* @r0, align 4, !dbg !56
  call void @__LKMM_FENCE(i32 noundef 6) #5, !dbg !57
  %3 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1) #5, !dbg !58
  store i32 %3, i32* @r1, align 4, !dbg !59
  ret i8* null, !dbg !60
}

declare i32 @__LKMM_LOAD(i8* noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !61 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !64, metadata !DIExpression(DW_OP_deref)), !dbg !68
  %3 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P0, i8* noundef null) #5, !dbg !69
  call void @llvm.dbg.value(metadata i64* %2, metadata !70, metadata !DIExpression(DW_OP_deref)), !dbg !68
  %4 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P1, i8* noundef null) #5, !dbg !71
  %5 = load i64, i64* %1, align 8, !dbg !72
  call void @llvm.dbg.value(metadata i64 %5, metadata !64, metadata !DIExpression()), !dbg !68
  %6 = call i32 @pthread_join(i64 noundef %5, i8** noundef null) #5, !dbg !73
  %7 = load i64, i64* %2, align 8, !dbg !74
  call void @llvm.dbg.value(metadata i64 %7, metadata !70, metadata !DIExpression()), !dbg !68
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null) #5, !dbg !75
  %9 = load i32, i32* @r0, align 4, !dbg !76
  %10 = icmp eq i32 %9, 1, !dbg !76
  %11 = load i32, i32* @r1, align 4, !dbg !76
  %12 = icmp eq i32 %11, 0, !dbg !76
  %or.cond = select i1 %10, i1 %12, i1 false, !dbg !76
  br i1 %or.cond, label %13, label %14, !dbg !76

13:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @.str.1, i64 0, i64 0), i32 noundef 37, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !76
  unreachable, !dbg !76

14:                                               ; preds = %0
  ret i32 0, !dbg !79
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
!llvm.module.flags = !{!34, !35, !36, !37, !38, !39, !40}
!llvm.ident = !{!41}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !28, line: 6, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lkmm/MP+fencewbonceonce+fencermbonceonce.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "2b7c98fd1e06930505446ce803f974f8")
!4 = !{!5}
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
!23 = !{!24}
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!25 = !{!0, !26, !30, !32}
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!28 = !DIFile(filename: "benchmarks/lkmm/MP+fencewbonceonce+fencermbonceonce.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "2b7c98fd1e06930505446ce803f974f8")
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !28, line: 9, type: !29, isLocal: false, isDefinition: true)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "r1", scope: !2, file: !28, line: 9, type: !29, isLocal: false, isDefinition: true)
!34 = !{i32 7, !"Dwarf Version", i32 5}
!35 = !{i32 2, !"Debug Info Version", i32 3}
!36 = !{i32 1, !"wchar_size", i32 4}
!37 = !{i32 7, !"PIC Level", i32 2}
!38 = !{i32 7, !"PIE Level", i32 2}
!39 = !{i32 7, !"uwtable", i32 1}
!40 = !{i32 7, !"frame-pointer", i32 2}
!41 = !{!"Ubuntu clang version 14.0.6"}
!42 = distinct !DISubprogram(name: "P0", scope: !28, file: !28, line: 11, type: !43, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!43 = !DISubroutineType(types: !44)
!44 = !{!24, !24}
!45 = !{}
!46 = !DILocalVariable(name: "unused", arg: 1, scope: !42, file: !28, line: 11, type: !24)
!47 = !DILocation(line: 0, scope: !42)
!48 = !DILocation(line: 13, column: 2, scope: !42)
!49 = !DILocation(line: 14, column: 2, scope: !42)
!50 = !DILocation(line: 15, column: 2, scope: !42)
!51 = !DILocation(line: 16, column: 2, scope: !42)
!52 = distinct !DISubprogram(name: "P1", scope: !28, file: !28, line: 19, type: !43, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!53 = !DILocalVariable(name: "unused", arg: 1, scope: !52, file: !28, line: 19, type: !24)
!54 = !DILocation(line: 0, scope: !52)
!55 = !DILocation(line: 21, column: 7, scope: !52)
!56 = !DILocation(line: 21, column: 5, scope: !52)
!57 = !DILocation(line: 22, column: 2, scope: !52)
!58 = !DILocation(line: 23, column: 7, scope: !52)
!59 = !DILocation(line: 23, column: 5, scope: !52)
!60 = !DILocation(line: 24, column: 2, scope: !52)
!61 = distinct !DISubprogram(name: "main", scope: !28, file: !28, line: 27, type: !62, scopeLine: 28, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!62 = !DISubroutineType(types: !63)
!63 = !{!29}
!64 = !DILocalVariable(name: "t1", scope: !61, file: !28, line: 29, type: !65)
!65 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !66, line: 27, baseType: !67)
!66 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!67 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!68 = !DILocation(line: 0, scope: !61)
!69 = !DILocation(line: 31, column: 2, scope: !61)
!70 = !DILocalVariable(name: "t2", scope: !61, file: !28, line: 29, type: !65)
!71 = !DILocation(line: 32, column: 2, scope: !61)
!72 = !DILocation(line: 34, column: 15, scope: !61)
!73 = !DILocation(line: 34, column: 2, scope: !61)
!74 = !DILocation(line: 35, column: 15, scope: !61)
!75 = !DILocation(line: 35, column: 2, scope: !61)
!76 = !DILocation(line: 37, column: 2, scope: !77)
!77 = distinct !DILexicalBlock(scope: !78, file: !28, line: 37, column: 2)
!78 = distinct !DILexicalBlock(scope: !61, file: !28, line: 37, column: 2)
!79 = !DILocation(line: 39, column: 2, scope: !61)
