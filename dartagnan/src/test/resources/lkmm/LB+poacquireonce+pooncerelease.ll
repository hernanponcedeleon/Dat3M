; ModuleID = 'benchmarks/lkmm/LB+poacquireonce+pooncerelease.c'
source_filename = "benchmarks/lkmm/LB+poacquireonce+pooncerelease.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0
@r0 = dso_local global i32 0, align 4, !dbg !49
@y = dso_local global i32 0, align 4, !dbg !47
@r1 = dso_local global i32 0, align 4, !dbg !51
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !30
@.str = private unnamed_addr constant [33 x i8] c"LB+poacquireonce+pooncerelease.c\00", align 1, !dbg !37
@.str.1 = private unnamed_addr constant [22 x i8] c"!(r0 == 1 && r1 == 1)\00", align 1, !dbg !42

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !61 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !65, !DIExpression(), !66)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !67
  %4 = trunc i64 %3 to i32, !dbg !67
  store i32 %4, ptr @r0, align 4, !dbg !68
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 2), !dbg !69
  ret ptr null, !dbg !70
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !71 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !72, !DIExpression(), !73)
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !74
  %4 = trunc i64 %3 to i32, !dbg !74
  store i32 %4, ptr @r1, align 4, !dbg !75
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !76
  ret ptr null, !dbg !77
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !78 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !81, !DIExpression(), !104)
    #dbg_declare(ptr %3, !105, !DIExpression(), !106)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !107
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !108
  %6 = load ptr, ptr %2, align 8, !dbg !109
  %7 = call i32 @_pthread_join(ptr noundef %6, ptr noundef null), !dbg !110
  %8 = load ptr, ptr %3, align 8, !dbg !111
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !112
  %10 = load i32, ptr @r0, align 4, !dbg !113
  %11 = icmp eq i32 %10, 1, !dbg !113
  br i1 %11, label %12, label %15, !dbg !113

12:                                               ; preds = %0
  %13 = load i32, ptr @r1, align 4, !dbg !113
  %14 = icmp eq i32 %13, 1, !dbg !113
  br label %15

15:                                               ; preds = %12, %0
  %16 = phi i1 [ false, %0 ], [ %14, %12 ], !dbg !114
  %17 = xor i1 %16, true, !dbg !113
  %18 = xor i1 %17, true, !dbg !113
  %19 = zext i1 %18 to i32, !dbg !113
  %20 = sext i32 %19 to i64, !dbg !113
  %21 = icmp ne i64 %20, 0, !dbg !113
  br i1 %21, label %22, label %24, !dbg !113

22:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 35, ptr noundef @.str.1) #3, !dbg !113
  unreachable, !dbg !113

23:                                               ; No predecessors!
  br label %25, !dbg !113

24:                                               ; preds = %15
  br label %25, !dbg !113

25:                                               ; preds = %24, %23
  ret i32 0, !dbg !115
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @_pthread_join(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!53, !54, !55, !56, !57, !58, !59}
!llvm.ident = !{!60}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !23, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !22, globals: !29, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/LB+poacquireonce+pooncerelease.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "273f0308996bdd503c288ed473fb0e4c")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "26457005f8f39b3952d279119fb45118")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21}
!9 = !DIEnumerator(name: "__LKMM_once", value: 0)
!10 = !DIEnumerator(name: "__LKMM_acquire", value: 1)
!11 = !DIEnumerator(name: "__LKMM_release", value: 2)
!12 = !DIEnumerator(name: "__LKMM_mb", value: 3)
!13 = !DIEnumerator(name: "__LKMM_wmb", value: 4)
!14 = !DIEnumerator(name: "__LKMM_rmb", value: 5)
!15 = !DIEnumerator(name: "__LKMM_rcu_lock", value: 6)
!16 = !DIEnumerator(name: "__LKMM_rcu_unlock", value: 7)
!17 = !DIEnumerator(name: "__LKMM_rcu_sync", value: 8)
!18 = !DIEnumerator(name: "__LKMM_before_atomic", value: 9)
!19 = !DIEnumerator(name: "__LKMM_after_atomic", value: 10)
!20 = !DIEnumerator(name: "__LKMM_after_spinlock", value: 11)
!21 = !DIEnumerator(name: "__LKMM_barrier", value: 12)
!22 = !{!23, !24, !28}
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 27, baseType: !25)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !26, line: 32, baseType: !27)
!26 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!27 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!29 = !{!30, !37, !42, !0, !47, !49, !51}
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 35, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 40, elements: !35)
!33 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!34 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!35 = !{!36}
!36 = !DISubrange(count: 5)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 35, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 264, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 33)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 35, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 176, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 22)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !23, isLocal: false, isDefinition: true)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !3, line: 9, type: !23, isLocal: false, isDefinition: true)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(name: "r1", scope: !2, file: !3, line: 9, type: !23, isLocal: false, isDefinition: true)
!53 = !{i32 7, !"Dwarf Version", i32 5}
!54 = !{i32 2, !"Debug Info Version", i32 3}
!55 = !{i32 1, !"wchar_size", i32 4}
!56 = !{i32 8, !"PIC Level", i32 2}
!57 = !{i32 7, !"PIE Level", i32 2}
!58 = !{i32 7, !"uwtable", i32 2}
!59 = !{i32 7, !"frame-pointer", i32 2}
!60 = !{!"Homebrew clang version 19.1.7"}
!61 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 11, type: !62, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!62 = !DISubroutineType(types: !63)
!63 = !{!28, !28}
!64 = !{}
!65 = !DILocalVariable(name: "unused", arg: 1, scope: !61, file: !3, line: 11, type: !28)
!66 = !DILocation(line: 11, column: 22, scope: !61)
!67 = !DILocation(line: 13, column: 7, scope: !61)
!68 = !DILocation(line: 13, column: 5, scope: !61)
!69 = !DILocation(line: 14, column: 2, scope: !61)
!70 = !DILocation(line: 15, column: 2, scope: !61)
!71 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 18, type: !62, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!72 = !DILocalVariable(name: "unused", arg: 1, scope: !71, file: !3, line: 18, type: !28)
!73 = !DILocation(line: 18, column: 22, scope: !71)
!74 = !DILocation(line: 20, column: 7, scope: !71)
!75 = !DILocation(line: 20, column: 5, scope: !71)
!76 = !DILocation(line: 21, column: 2, scope: !71)
!77 = !DILocation(line: 22, column: 2, scope: !71)
!78 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 25, type: !79, scopeLine: 26, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!79 = !DISubroutineType(types: !80)
!80 = !{!23}
!81 = !DILocalVariable(name: "t1", scope: !78, file: !3, line: 27, type: !82)
!82 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !83, line: 31, baseType: !84)
!83 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !85, line: 118, baseType: !86)
!85 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !87, size: 64)
!87 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !85, line: 103, size: 65536, elements: !88)
!88 = !{!89, !90, !100}
!89 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !87, file: !85, line: 104, baseType: !27, size: 64)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !87, file: !85, line: 105, baseType: !91, size: 64, offset: 64)
!91 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !92, size: 64)
!92 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !85, line: 57, size: 192, elements: !93)
!93 = !{!94, !98, !99}
!94 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !92, file: !85, line: 58, baseType: !95, size: 64)
!95 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !96, size: 64)
!96 = !DISubroutineType(types: !97)
!97 = !{null, !28}
!98 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !92, file: !85, line: 59, baseType: !28, size: 64, offset: 64)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !92, file: !85, line: 60, baseType: !91, size: 64, offset: 128)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !87, file: !85, line: 106, baseType: !101, size: 65408, offset: 128)
!101 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 65408, elements: !102)
!102 = !{!103}
!103 = !DISubrange(count: 8176)
!104 = !DILocation(line: 27, column: 12, scope: !78)
!105 = !DILocalVariable(name: "t2", scope: !78, file: !3, line: 27, type: !82)
!106 = !DILocation(line: 27, column: 16, scope: !78)
!107 = !DILocation(line: 29, column: 2, scope: !78)
!108 = !DILocation(line: 30, column: 2, scope: !78)
!109 = !DILocation(line: 32, column: 15, scope: !78)
!110 = !DILocation(line: 32, column: 2, scope: !78)
!111 = !DILocation(line: 33, column: 15, scope: !78)
!112 = !DILocation(line: 33, column: 2, scope: !78)
!113 = !DILocation(line: 35, column: 2, scope: !78)
!114 = !DILocation(line: 0, scope: !78)
!115 = !DILocation(line: 37, column: 2, scope: !78)
