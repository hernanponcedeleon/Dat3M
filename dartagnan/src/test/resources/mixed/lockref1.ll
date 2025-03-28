; ModuleID = '/Users/r/git/dat3m/z_out/lockref1.ll'
source_filename = "/Users/r/git/dat3m/benchmarks/mixed/lockref1.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx14.0.0"

%struct.lockref_t = type { %union.anon }
%union.anon = type { i64 }
%struct.anon = type { i32, i32 }

@shared_lockref = global %struct.lockref_t zeroinitializer, align 8, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !38
@.str = private unnamed_addr constant [11 x i8] c"lockref1.c\00", align 1, !dbg !45
@.str.1 = private unnamed_addr constant [26 x i8] c"shared_lockref.count == 2\00", align 1, !dbg !50

; Function Attrs: noinline nounwind ssp uwtable
define void @spin_lock(ptr noundef %0) #0 !dbg !62 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !67, metadata !DIExpression()), !dbg !68
  br label %5, !dbg !69

5:                                                ; preds = %11, %1
  %6 = load ptr, ptr %2, align 8, !dbg !70
  store i32 1, ptr %3, align 4, !dbg !71
  %7 = load i32, ptr %3, align 4, !dbg !71
  %8 = atomicrmw xchg ptr %6, i32 %7 acquire, align 4, !dbg !71
  store i32 %8, ptr %4, align 4, !dbg !71
  %9 = load i32, ptr %4, align 4, !dbg !71
  %10 = icmp ne i32 %9, 0, !dbg !69
  br i1 %10, label %11, label %12, !dbg !69

11:                                               ; preds = %5
  br label %5, !dbg !69, !llvm.loop !72

12:                                               ; preds = %5
  ret void, !dbg !75
}

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define void @spin_unlock(ptr noundef %0) #0 !dbg !76 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !77, metadata !DIExpression()), !dbg !78
  %4 = load ptr, ptr %2, align 8, !dbg !79
  store i32 0, ptr %3, align 4, !dbg !80
  %5 = load i32, ptr %3, align 4, !dbg !80
  store atomic i32 %5, ptr %4 release, align 4, !dbg !80
  ret void, !dbg !81
}

; Function Attrs: noinline nounwind ssp uwtable
define void @lockref_get(ptr noundef %0) #0 !dbg !82 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !85, metadata !DIExpression()), !dbg !86
  call void @llvm.dbg.declare(metadata ptr %3, metadata !87, metadata !DIExpression()), !dbg !88
  %8 = load ptr, ptr %2, align 8, !dbg !89
  %9 = getelementptr inbounds %struct.lockref_t, ptr %8, i32 0, i32 0, !dbg !90
  %10 = load atomic i64, ptr %9 monotonic, align 8, !dbg !91
  store i64 %10, ptr %4, align 8, !dbg !91
  %11 = load i64, ptr %4, align 8, !dbg !91
  store i64 %11, ptr %3, align 8, !dbg !88
  br label %12, !dbg !92

12:                                               ; preds = %37, %1
  %13 = getelementptr inbounds %struct.lockref_t, ptr %3, i32 0, i32 0, !dbg !93
  %14 = getelementptr inbounds %struct.anon, ptr %13, i32 0, i32 0, !dbg !93
  %15 = load atomic i32, ptr %14 seq_cst, align 4, !dbg !93
  %16 = icmp eq i32 %15, 0, !dbg !94
  br i1 %16, label %17, label %38, !dbg !92

17:                                               ; preds = %12
  call void @llvm.dbg.declare(metadata ptr %5, metadata !95, metadata !DIExpression()), !dbg !97
  %18 = load i64, ptr %3, align 8, !dbg !98
  store i64 %18, ptr %5, align 8, !dbg !97
  %19 = getelementptr inbounds %struct.lockref_t, ptr %5, i32 0, i32 0, !dbg !99
  %20 = getelementptr inbounds %struct.anon, ptr %19, i32 0, i32 1, !dbg !99
  %21 = load i32, ptr %20, align 4, !dbg !100
  %22 = add nsw i32 %21, 1, !dbg !100
  store i32 %22, ptr %20, align 4, !dbg !100
  %23 = load ptr, ptr %2, align 8, !dbg !101
  %24 = getelementptr inbounds %struct.lockref_t, ptr %23, i32 0, i32 0, !dbg !103
  %25 = load i64, ptr %5, align 8, !dbg !104
  store i64 %25, ptr %6, align 8, !dbg !105
  %26 = load i64, ptr %3, align 8, !dbg !105
  %27 = load i64, ptr %6, align 8, !dbg !105
  %28 = cmpxchg ptr %24, i64 %26, i64 %27 monotonic monotonic, align 8, !dbg !105
  %29 = extractvalue { i64, i1 } %28, 0, !dbg !105
  %30 = extractvalue { i64, i1 } %28, 1, !dbg !105
  br i1 %30, label %32, label %31, !dbg !105

31:                                               ; preds = %17
  store i64 %29, ptr %3, align 8, !dbg !105
  br label %32, !dbg !105

32:                                               ; preds = %31, %17
  %33 = zext i1 %30 to i8, !dbg !105
  store i8 %33, ptr %7, align 1, !dbg !105
  %34 = load i8, ptr %7, align 1, !dbg !105
  %35 = trunc i8 %34 to i1, !dbg !105
  br i1 %35, label %36, label %37, !dbg !106

36:                                               ; preds = %32
  br label %50, !dbg !107

37:                                               ; preds = %32
  br label %12, !dbg !92, !llvm.loop !109

38:                                               ; preds = %12
  %39 = load ptr, ptr %2, align 8, !dbg !111
  %40 = getelementptr inbounds %struct.lockref_t, ptr %39, i32 0, i32 0, !dbg !112
  %41 = getelementptr inbounds %struct.anon, ptr %40, i32 0, i32 0, !dbg !112
  call void @spin_lock(ptr noundef %41), !dbg !113
  %42 = load ptr, ptr %2, align 8, !dbg !114
  %43 = getelementptr inbounds %struct.lockref_t, ptr %42, i32 0, i32 0, !dbg !115
  %44 = getelementptr inbounds %struct.anon, ptr %43, i32 0, i32 1, !dbg !115
  %45 = load i32, ptr %44, align 4, !dbg !116
  %46 = add nsw i32 %45, 1, !dbg !116
  store i32 %46, ptr %44, align 4, !dbg !116
  %47 = load ptr, ptr %2, align 8, !dbg !117
  %48 = getelementptr inbounds %struct.lockref_t, ptr %47, i32 0, i32 0, !dbg !118
  %49 = getelementptr inbounds %struct.anon, ptr %48, i32 0, i32 0, !dbg !118
  call void @spin_unlock(ptr noundef %49), !dbg !119
  br label %50, !dbg !120

50:                                               ; preds = %38, %36
  ret void, !dbg !120
}

; Function Attrs: noinline nounwind ssp uwtable
define ptr @worker(ptr noundef %0) #0 !dbg !121 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !124, metadata !DIExpression()), !dbg !125
  call void @lockref_get(ptr noundef @shared_lockref), !dbg !126
  ret ptr null, !dbg !127
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !128 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i64, align 8
  store i32 0, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !131, metadata !DIExpression()), !dbg !154
  call void @llvm.dbg.declare(metadata ptr %3, metadata !155, metadata !DIExpression()), !dbg !156
  store i64 0, ptr %4, align 8, !dbg !157
  %5 = load i64, ptr %4, align 8, !dbg !157
  store atomic i64 %5, ptr @shared_lockref seq_cst, align 8, !dbg !157
  %6 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @worker, ptr noundef null), !dbg !158
  %7 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @worker, ptr noundef null), !dbg !159
  %8 = load ptr, ptr %2, align 8, !dbg !160
  %9 = call i32 @"\01_pthread_join"(ptr noundef %8, ptr noundef null), !dbg !161
  %10 = load ptr, ptr %3, align 8, !dbg !162
  %11 = call i32 @"\01_pthread_join"(ptr noundef %10, ptr noundef null), !dbg !163
  %12 = load i32, ptr getelementptr inbounds (%struct.anon, ptr @shared_lockref, i32 0, i32 1), align 4, !dbg !164
  %13 = icmp eq i32 %12, 2, !dbg !164
  %14 = xor i1 %13, true, !dbg !164
  %15 = zext i1 %14 to i32, !dbg !164
  %16 = sext i32 %15 to i64, !dbg !164
  %17 = icmp ne i64 %16, 0, !dbg !164
  br i1 %17, label %18, label %20, !dbg !164

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 59, ptr noundef @.str.1) #4, !dbg !164
  unreachable, !dbg !164

19:                                               ; No predecessors!
  br label %21, !dbg !164

20:                                               ; preds = %0
  br label %21, !dbg !164

21:                                               ; preds = %20, %19
  ret i32 0, !dbg !165
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #4 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!55, !56, !57, !58, !59, !60}
!llvm.ident = !{!61}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "shared_lockref", scope: !2, file: !18, line: 41, type: !17, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 15.0.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !37, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk", sdk: "MacOSX14.sdk")
!3 = !DIFile(filename: "/Users/r/git/dat3m/benchmarks/mixed/lockref1.c", directory: "/Users/r/git/dat3m")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 57, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: ".local/universal/llvm-15.0.7/lib/clang/15.0.7/include/stdatomic.h", directory: "/Users/r")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16, !36}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "lockref_t", file: !18, line: 13, baseType: !19)
!18 = !DIFile(filename: "benchmarks/mixed/lockref1.c", directory: "/Users/r/git/dat3m")
!19 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !18, line: 5, size: 64, elements: !20)
!20 = !{!21}
!21 = !DIDerivedType(tag: DW_TAG_member, scope: !19, file: !18, line: 6, baseType: !22, size: 64)
!22 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !19, file: !18, line: 6, size: 64, elements: !23)
!23 = !{!24, !32}
!24 = !DIDerivedType(tag: DW_TAG_member, scope: !22, file: !18, line: 7, baseType: !25, size: 64)
!25 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !22, file: !18, line: 7, size: 64, elements: !26)
!26 = !{!27, !31}
!27 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !25, file: !18, line: 8, baseType: !28, size: 32)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 93, baseType: !29)
!29 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !30)
!30 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !25, file: !18, line: 9, baseType: !30, size: 32, offset: 32)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "lock_count", scope: !22, file: !18, line: 11, baseType: !33, size: 64)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_long", file: !6, line: 95, baseType: !34)
!34 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !35)
!35 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!37 = !{!38, !45, !50, !0}
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !18, line: 59, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 40, elements: !43)
!41 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !42)
!42 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!43 = !{!44}
!44 = !DISubrange(count: 5)
!45 = !DIGlobalVariableExpression(var: !46, expr: !DIExpression())
!46 = distinct !DIGlobalVariable(scope: null, file: !18, line: 59, type: !47, isLocal: true, isDefinition: true)
!47 = !DICompositeType(tag: DW_TAG_array_type, baseType: !42, size: 88, elements: !48)
!48 = !{!49}
!49 = !DISubrange(count: 11)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(scope: null, file: !18, line: 59, type: !52, isLocal: true, isDefinition: true)
!52 = !DICompositeType(tag: DW_TAG_array_type, baseType: !42, size: 208, elements: !53)
!53 = !{!54}
!54 = !DISubrange(count: 26)
!55 = !{i32 7, !"Dwarf Version", i32 4}
!56 = !{i32 2, !"Debug Info Version", i32 3}
!57 = !{i32 1, !"wchar_size", i32 4}
!58 = !{i32 7, !"PIC Level", i32 2}
!59 = !{i32 7, !"uwtable", i32 2}
!60 = !{i32 7, !"frame-pointer", i32 2}
!61 = !{!"Homebrew clang version 15.0.7"}
!62 = distinct !DISubprogram(name: "spin_lock", scope: !18, file: !18, line: 15, type: !63, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !66)
!63 = !DISubroutineType(types: !64)
!64 = !{null, !65}
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!66 = !{}
!67 = !DILocalVariable(name: "lock", arg: 1, scope: !62, file: !18, line: 15, type: !65)
!68 = !DILocation(line: 15, column: 28, scope: !62)
!69 = !DILocation(line: 16, column: 5, scope: !62)
!70 = !DILocation(line: 16, column: 37, scope: !62)
!71 = !DILocation(line: 16, column: 12, scope: !62)
!72 = distinct !{!72, !69, !73, !74}
!73 = !DILocation(line: 16, column: 70, scope: !62)
!74 = !{!"llvm.loop.mustprogress"}
!75 = !DILocation(line: 17, column: 1, scope: !62)
!76 = distinct !DISubprogram(name: "spin_unlock", scope: !18, file: !18, line: 19, type: !63, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !66)
!77 = !DILocalVariable(name: "lock", arg: 1, scope: !76, file: !18, line: 19, type: !65)
!78 = !DILocation(line: 19, column: 30, scope: !76)
!79 = !DILocation(line: 20, column: 27, scope: !76)
!80 = !DILocation(line: 20, column: 5, scope: !76)
!81 = !DILocation(line: 21, column: 1, scope: !76)
!82 = distinct !DISubprogram(name: "lockref_get", scope: !18, file: !18, line: 23, type: !83, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !66)
!83 = !DISubroutineType(types: !84)
!84 = !{null, !16}
!85 = !DILocalVariable(name: "lockref", arg: 1, scope: !82, file: !18, line: 23, type: !16)
!86 = !DILocation(line: 23, column: 29, scope: !82)
!87 = !DILocalVariable(name: "old_val", scope: !82, file: !18, line: 24, type: !35)
!88 = !DILocation(line: 24, column: 10, scope: !82)
!89 = !DILocation(line: 24, column: 42, scope: !82)
!90 = !DILocation(line: 24, column: 51, scope: !82)
!91 = !DILocation(line: 24, column: 20, scope: !82)
!92 = !DILocation(line: 26, column: 5, scope: !82)
!93 = !DILocation(line: 26, column: 37, scope: !82)
!94 = !DILocation(line: 26, column: 42, scope: !82)
!95 = !DILocalVariable(name: "new_val", scope: !96, file: !18, line: 27, type: !35)
!96 = distinct !DILexicalBlock(scope: !82, file: !18, line: 26, column: 48)
!97 = !DILocation(line: 27, column: 14, scope: !96)
!98 = !DILocation(line: 27, column: 24, scope: !96)
!99 = !DILocation(line: 28, column: 34, scope: !96)
!100 = !DILocation(line: 28, column: 39, scope: !96)
!101 = !DILocation(line: 30, column: 18, scope: !102)
!102 = distinct !DILexicalBlock(scope: !96, file: !18, line: 29, column: 13)
!103 = !DILocation(line: 30, column: 27, scope: !102)
!104 = !DILocation(line: 30, column: 49, scope: !102)
!105 = !DILocation(line: 29, column: 13, scope: !102)
!106 = !DILocation(line: 29, column: 13, scope: !96)
!107 = !DILocation(line: 32, column: 13, scope: !108)
!108 = distinct !DILexicalBlock(scope: !102, file: !18, line: 31, column: 62)
!109 = distinct !{!109, !92, !110, !74}
!110 = !DILocation(line: 34, column: 5, scope: !82)
!111 = !DILocation(line: 36, column: 16, scope: !82)
!112 = !DILocation(line: 36, column: 25, scope: !82)
!113 = !DILocation(line: 36, column: 5, scope: !82)
!114 = !DILocation(line: 37, column: 5, scope: !82)
!115 = !DILocation(line: 37, column: 14, scope: !82)
!116 = !DILocation(line: 37, column: 19, scope: !82)
!117 = !DILocation(line: 38, column: 18, scope: !82)
!118 = !DILocation(line: 38, column: 27, scope: !82)
!119 = !DILocation(line: 38, column: 5, scope: !82)
!120 = !DILocation(line: 39, column: 1, scope: !82)
!121 = distinct !DISubprogram(name: "worker", scope: !18, file: !18, line: 43, type: !122, scopeLine: 43, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !66)
!122 = !DISubroutineType(types: !123)
!123 = !{!36, !36}
!124 = !DILocalVariable(name: "unsued", arg: 1, scope: !121, file: !18, line: 43, type: !36)
!125 = !DILocation(line: 43, column: 20, scope: !121)
!126 = !DILocation(line: 44, column: 5, scope: !121)
!127 = !DILocation(line: 45, column: 5, scope: !121)
!128 = distinct !DISubprogram(name: "main", scope: !18, file: !18, line: 48, type: !129, scopeLine: 48, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !66)
!129 = !DISubroutineType(types: !130)
!130 = !{!30}
!131 = !DILocalVariable(name: "t1", scope: !128, file: !18, line: 49, type: !132)
!132 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !133, line: 31, baseType: !134)
!133 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!134 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !135, line: 118, baseType: !136)
!135 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!136 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !137, size: 64)
!137 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !135, line: 103, size: 65536, elements: !138)
!138 = !{!139, !140, !150}
!139 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !137, file: !135, line: 104, baseType: !35, size: 64)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !137, file: !135, line: 105, baseType: !141, size: 64, offset: 64)
!141 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !142, size: 64)
!142 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !135, line: 57, size: 192, elements: !143)
!143 = !{!144, !148, !149}
!144 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !142, file: !135, line: 58, baseType: !145, size: 64)
!145 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !146, size: 64)
!146 = !DISubroutineType(types: !147)
!147 = !{null, !36}
!148 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !142, file: !135, line: 59, baseType: !36, size: 64, offset: 64)
!149 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !142, file: !135, line: 60, baseType: !141, size: 64, offset: 128)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !137, file: !135, line: 106, baseType: !151, size: 65408, offset: 128)
!151 = !DICompositeType(tag: DW_TAG_array_type, baseType: !42, size: 65408, elements: !152)
!152 = !{!153}
!153 = !DISubrange(count: 8176)
!154 = !DILocation(line: 49, column: 15, scope: !128)
!155 = !DILocalVariable(name: "t2", scope: !128, file: !18, line: 49, type: !132)
!156 = !DILocation(line: 49, column: 19, scope: !128)
!157 = !DILocation(line: 51, column: 5, scope: !128)
!158 = !DILocation(line: 53, column: 5, scope: !128)
!159 = !DILocation(line: 54, column: 5, scope: !128)
!160 = !DILocation(line: 56, column: 18, scope: !128)
!161 = !DILocation(line: 56, column: 5, scope: !128)
!162 = !DILocation(line: 57, column: 18, scope: !128)
!163 = !DILocation(line: 57, column: 5, scope: !128)
!164 = !DILocation(line: 59, column: 5, scope: !128)
!165 = !DILocation(line: 60, column: 5, scope: !128)
