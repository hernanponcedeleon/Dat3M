; ModuleID = '/home/ponce/git/Dat3M/output/rcu-gp20.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lkmm/rcu-gp20.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@r_x = dso_local global i32 0, align 4, !dbg !30
@y = dso_local global i32 0, align 4, !dbg !26
@r_y = dso_local global i32 0, align 4, !dbg !32
@.str = private unnamed_addr constant [24 x i8] c"!(r_x == 0 && r_y == 1)\00", align 1
@.str.1 = private unnamed_addr constant [49 x i8] c"/home/ponce/git/Dat3M/benchmarks/lkmm/rcu-gp20.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P0(i8* noundef %0) #0 !dbg !42 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !46, metadata !DIExpression()), !dbg !47
  call void @__LKMM_FENCE(i32 noundef 7) #5, !dbg !48
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1) #5, !dbg !49
  store i32 %2, i32* @r_x, align 4, !dbg !50
  %3 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @y to i8*), i32 noundef 1) #5, !dbg !51
  store i32 %3, i32* @r_y, align 4, !dbg !52
  call void @__LKMM_FENCE(i32 noundef 8) #5, !dbg !53
  ret i8* null, !dbg !54
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_FENCE(i32 noundef) #2

declare i32 @__LKMM_LOAD(i8* noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P1(i8* noundef %0) #0 !dbg !55 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !56, metadata !DIExpression()), !dbg !57
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !58
  call void @__LKMM_FENCE(i32 noundef 9) #5, !dbg !59
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @y to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !60
  ret i8* null, !dbg !61
}

declare void @__LKMM_STORE(i8* noundef, i32 noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !62 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !65, metadata !DIExpression(DW_OP_deref)), !dbg !69
  %3 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P0, i8* noundef null) #5, !dbg !70
  call void @llvm.dbg.value(metadata i64* %2, metadata !71, metadata !DIExpression(DW_OP_deref)), !dbg !69
  %4 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P1, i8* noundef null) #5, !dbg !72
  %5 = load i64, i64* %1, align 8, !dbg !73
  call void @llvm.dbg.value(metadata i64 %5, metadata !65, metadata !DIExpression()), !dbg !69
  %6 = call i32 @pthread_join(i64 noundef %5, i8** noundef null) #5, !dbg !74
  %7 = load i64, i64* %2, align 8, !dbg !75
  call void @llvm.dbg.value(metadata i64 %7, metadata !71, metadata !DIExpression()), !dbg !69
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null) #5, !dbg !76
  %9 = load i32, i32* @r_x, align 4, !dbg !77
  %10 = icmp eq i32 %9, 0, !dbg !77
  %11 = load i32, i32* @r_y, align 4, !dbg !77
  %12 = icmp eq i32 %11, 1, !dbg !77
  %or.cond = select i1 %10, i1 %12, i1 false, !dbg !77
  br i1 %or.cond, label %13, label %14, !dbg !77

13:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([49 x i8], [49 x i8]* @.str.1, i64 0, i64 0), i32 noundef 43, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !77
  unreachable, !dbg !77

14:                                               ; preds = %0
  ret i32 0, !dbg !80
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
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lkmm/rcu-gp20.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "b0caa70c4bd139823f22290f84c5437c")
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
!27 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!28 = !DIFile(filename: "benchmarks/lkmm/rcu-gp20.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "b0caa70c4bd139823f22290f84c5437c")
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "r_x", scope: !2, file: !28, line: 10, type: !29, isLocal: false, isDefinition: true)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "r_y", scope: !2, file: !28, line: 11, type: !29, isLocal: false, isDefinition: true)
!34 = !{i32 7, !"Dwarf Version", i32 5}
!35 = !{i32 2, !"Debug Info Version", i32 3}
!36 = !{i32 1, !"wchar_size", i32 4}
!37 = !{i32 7, !"PIC Level", i32 2}
!38 = !{i32 7, !"PIE Level", i32 2}
!39 = !{i32 7, !"uwtable", i32 1}
!40 = !{i32 7, !"frame-pointer", i32 2}
!41 = !{!"Ubuntu clang version 14.0.6"}
!42 = distinct !DISubprogram(name: "P0", scope: !28, file: !28, line: 13, type: !43, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!43 = !DISubroutineType(types: !44)
!44 = !{!24, !24}
!45 = !{}
!46 = !DILocalVariable(name: "unused", arg: 1, scope: !42, file: !28, line: 13, type: !24)
!47 = !DILocation(line: 0, scope: !42)
!48 = !DILocation(line: 15, column: 2, scope: !42)
!49 = !DILocation(line: 16, column: 8, scope: !42)
!50 = !DILocation(line: 16, column: 6, scope: !42)
!51 = !DILocation(line: 17, column: 8, scope: !42)
!52 = !DILocation(line: 17, column: 6, scope: !42)
!53 = !DILocation(line: 18, column: 2, scope: !42)
!54 = !DILocation(line: 19, column: 2, scope: !42)
!55 = distinct !DISubprogram(name: "P1", scope: !28, file: !28, line: 22, type: !43, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!56 = !DILocalVariable(name: "unused", arg: 1, scope: !55, file: !28, line: 22, type: !24)
!57 = !DILocation(line: 0, scope: !55)
!58 = !DILocation(line: 24, column: 2, scope: !55)
!59 = !DILocation(line: 25, column: 2, scope: !55)
!60 = !DILocation(line: 26, column: 2, scope: !55)
!61 = !DILocation(line: 27, column: 2, scope: !55)
!62 = distinct !DISubprogram(name: "main", scope: !28, file: !28, line: 30, type: !63, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!63 = !DISubroutineType(types: !64)
!64 = !{!29}
!65 = !DILocalVariable(name: "t1", scope: !62, file: !28, line: 35, type: !66)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !67, line: 27, baseType: !68)
!67 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!68 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!69 = !DILocation(line: 0, scope: !62)
!70 = !DILocation(line: 37, column: 2, scope: !62)
!71 = !DILocalVariable(name: "t2", scope: !62, file: !28, line: 35, type: !66)
!72 = !DILocation(line: 38, column: 2, scope: !62)
!73 = !DILocation(line: 40, column: 15, scope: !62)
!74 = !DILocation(line: 40, column: 2, scope: !62)
!75 = !DILocation(line: 41, column: 15, scope: !62)
!76 = !DILocation(line: 41, column: 2, scope: !62)
!77 = !DILocation(line: 43, column: 2, scope: !78)
!78 = distinct !DILexicalBlock(scope: !79, file: !28, line: 43, column: 2)
!79 = distinct !DILexicalBlock(scope: !62, file: !28, line: 43, column: 2)
!80 = !DILocation(line: 45, column: 2, scope: !62)
