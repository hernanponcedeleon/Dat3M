; ModuleID = 'benchmarks/lkmm/LB+poacquireonce+pooncerelease.c'
source_filename = "benchmarks/lkmm/LB+poacquireonce+pooncerelease.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0
@r0 = dso_local global i32 0, align 4, !dbg !50
@y = dso_local global i32 0, align 4, !dbg !48
@r1 = dso_local global i32 0, align 4, !dbg !52
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !31
@.str = private unnamed_addr constant [33 x i8] c"LB+poacquireonce+pooncerelease.c\00", align 1, !dbg !38
@.str.1 = private unnamed_addr constant [22 x i8] c"!(r0 == 1 && r1 == 1)\00", align 1, !dbg !43

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !62 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !66, !DIExpression(), !67)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !68
  %4 = trunc i64 %3 to i32, !dbg !68
  store i32 %4, ptr @r0, align 4, !dbg !69
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 3), !dbg !70
  ret ptr null, !dbg !71
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !72 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !73, !DIExpression(), !74)
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 2), !dbg !75
  %4 = trunc i64 %3 to i32, !dbg !75
  store i32 %4, ptr @r1, align 4, !dbg !76
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !77
  ret ptr null, !dbg !78
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !79 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !82, !DIExpression(), !105)
    #dbg_declare(ptr %3, !106, !DIExpression(), !107)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !108
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !109
  %6 = load ptr, ptr %2, align 8, !dbg !110
  %7 = call i32 @_pthread_join(ptr noundef %6, ptr noundef null), !dbg !111
  %8 = load ptr, ptr %3, align 8, !dbg !112
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !113
  %10 = load i32, ptr @r0, align 4, !dbg !114
  %11 = icmp eq i32 %10, 1, !dbg !114
  br i1 %11, label %12, label %15, !dbg !114

12:                                               ; preds = %0
  %13 = load i32, ptr @r1, align 4, !dbg !114
  %14 = icmp eq i32 %13, 1, !dbg !114
  br label %15

15:                                               ; preds = %12, %0
  %16 = phi i1 [ false, %0 ], [ %14, %12 ], !dbg !115
  %17 = xor i1 %16, true, !dbg !114
  %18 = xor i1 %17, true, !dbg !114
  %19 = zext i1 %18 to i32, !dbg !114
  %20 = sext i32 %19 to i64, !dbg !114
  %21 = icmp ne i64 %20, 0, !dbg !114
  br i1 %21, label %22, label %24, !dbg !114

22:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 35, ptr noundef @.str.1) #3, !dbg !114
  unreachable, !dbg !114

23:                                               ; No predecessors!
  br label %25, !dbg !114

24:                                               ; preds = %15
  br label %25, !dbg !114

25:                                               ; preds = %24, %23
  ret i32 0, !dbg !116
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
!llvm.module.flags = !{!54, !55, !56, !57, !58, !59, !60}
!llvm.ident = !{!61}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !30, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/LB+poacquireonce+pooncerelease.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "273f0308996bdd503c288ed473fb0e4c")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "09faa2df2f4b7a5b710a8844ff483434")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22}
!9 = !DIEnumerator(name: "__LKMM_relaxed", value: 0)
!10 = !DIEnumerator(name: "__LKMM_once", value: 1)
!11 = !DIEnumerator(name: "__LKMM_acquire", value: 2)
!12 = !DIEnumerator(name: "__LKMM_release", value: 3)
!13 = !DIEnumerator(name: "__LKMM_mb", value: 4)
!14 = !DIEnumerator(name: "__LKMM_wmb", value: 5)
!15 = !DIEnumerator(name: "__LKMM_rmb", value: 6)
!16 = !DIEnumerator(name: "__LKMM_rcu_lock", value: 7)
!17 = !DIEnumerator(name: "__LKMM_rcu_unlock", value: 8)
!18 = !DIEnumerator(name: "__LKMM_rcu_sync", value: 9)
!19 = !DIEnumerator(name: "__LKMM_before_atomic", value: 10)
!20 = !DIEnumerator(name: "__LKMM_after_atomic", value: 11)
!21 = !DIEnumerator(name: "__LKMM_after_spinlock", value: 12)
!22 = !DIEnumerator(name: "__LKMM_barrier", value: 13)
!23 = !{!24, !25, !29}
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !26)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !27, line: 32, baseType: !28)
!27 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!28 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!30 = !{!31, !38, !43, !0, !48, !50, !52}
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 35, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 40, elements: !36)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !35)
!35 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!36 = !{!37}
!37 = !DISubrange(count: 5)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !3, line: 35, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 264, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 33)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !3, line: 35, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 176, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 22)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !24, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !3, line: 9, type: !24, isLocal: false, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "r1", scope: !2, file: !3, line: 9, type: !24, isLocal: false, isDefinition: true)
!54 = !{i32 7, !"Dwarf Version", i32 5}
!55 = !{i32 2, !"Debug Info Version", i32 3}
!56 = !{i32 1, !"wchar_size", i32 4}
!57 = !{i32 8, !"PIC Level", i32 2}
!58 = !{i32 7, !"PIE Level", i32 2}
!59 = !{i32 7, !"uwtable", i32 2}
!60 = !{i32 7, !"frame-pointer", i32 2}
!61 = !{!"Homebrew clang version 19.1.7"}
!62 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 11, type: !63, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!63 = !DISubroutineType(types: !64)
!64 = !{!29, !29}
!65 = !{}
!66 = !DILocalVariable(name: "unused", arg: 1, scope: !62, file: !3, line: 11, type: !29)
!67 = !DILocation(line: 11, column: 22, scope: !62)
!68 = !DILocation(line: 13, column: 7, scope: !62)
!69 = !DILocation(line: 13, column: 5, scope: !62)
!70 = !DILocation(line: 14, column: 2, scope: !62)
!71 = !DILocation(line: 15, column: 2, scope: !62)
!72 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 18, type: !63, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!73 = !DILocalVariable(name: "unused", arg: 1, scope: !72, file: !3, line: 18, type: !29)
!74 = !DILocation(line: 18, column: 22, scope: !72)
!75 = !DILocation(line: 20, column: 7, scope: !72)
!76 = !DILocation(line: 20, column: 5, scope: !72)
!77 = !DILocation(line: 21, column: 2, scope: !72)
!78 = !DILocation(line: 22, column: 2, scope: !72)
!79 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 25, type: !80, scopeLine: 26, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!80 = !DISubroutineType(types: !81)
!81 = !{!24}
!82 = !DILocalVariable(name: "t1", scope: !79, file: !3, line: 27, type: !83)
!83 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !84, line: 31, baseType: !85)
!84 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!85 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !86, line: 118, baseType: !87)
!86 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !86, line: 103, size: 65536, elements: !89)
!89 = !{!90, !91, !101}
!90 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !88, file: !86, line: 104, baseType: !28, size: 64)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !88, file: !86, line: 105, baseType: !92, size: 64, offset: 64)
!92 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !93, size: 64)
!93 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !86, line: 57, size: 192, elements: !94)
!94 = !{!95, !99, !100}
!95 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !93, file: !86, line: 58, baseType: !96, size: 64)
!96 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64)
!97 = !DISubroutineType(types: !98)
!98 = !{null, !29}
!99 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !93, file: !86, line: 59, baseType: !29, size: 64, offset: 64)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !93, file: !86, line: 60, baseType: !92, size: 64, offset: 128)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !88, file: !86, line: 106, baseType: !102, size: 65408, offset: 128)
!102 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 65408, elements: !103)
!103 = !{!104}
!104 = !DISubrange(count: 8176)
!105 = !DILocation(line: 27, column: 12, scope: !79)
!106 = !DILocalVariable(name: "t2", scope: !79, file: !3, line: 27, type: !83)
!107 = !DILocation(line: 27, column: 16, scope: !79)
!108 = !DILocation(line: 29, column: 2, scope: !79)
!109 = !DILocation(line: 30, column: 2, scope: !79)
!110 = !DILocation(line: 32, column: 15, scope: !79)
!111 = !DILocation(line: 32, column: 2, scope: !79)
!112 = !DILocation(line: 33, column: 15, scope: !79)
!113 = !DILocation(line: 33, column: 2, scope: !79)
!114 = !DILocation(line: 35, column: 2, scope: !79)
!115 = !DILocation(line: 0, scope: !79)
!116 = !DILocation(line: 37, column: 2, scope: !79)
