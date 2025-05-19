; ModuleID = 'benchmarks/lkmm/rcu-MP.c'
source_filename = "benchmarks/lkmm/rcu-MP.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !48
@__func__.P1 = private unnamed_addr constant [3 x i8] c"P1\00", align 1, !dbg !31
@.str = private unnamed_addr constant [9 x i8] c"rcu-MP.c\00", align 1, !dbg !38
@.str.1 = private unnamed_addr constant [24 x i8] c"!(r_y == 1 && r_x == 0)\00", align 1, !dbg !43

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P0(ptr noundef %0) #0 !dbg !58 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !62, !DIExpression(), !63)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !64
  call void @__LKMM_fence(i32 noundef 9), !dbg !65
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !66
  ret ptr null, !dbg !67
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_fence(i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P1(ptr noundef %0) #0 !dbg !68 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !69, !DIExpression(), !70)
  call void @__LKMM_fence(i32 noundef 7), !dbg !71
    #dbg_declare(ptr %3, !72, !DIExpression(), !73)
  %5 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !74
  %6 = trunc i64 %5 to i32, !dbg !74
  store i32 %6, ptr %3, align 4, !dbg !73
    #dbg_declare(ptr %4, !75, !DIExpression(), !76)
  %7 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !77
  %8 = trunc i64 %7 to i32, !dbg !77
  store i32 %8, ptr %4, align 4, !dbg !76
  call void @__LKMM_fence(i32 noundef 8), !dbg !78
  %9 = load i32, ptr %3, align 4, !dbg !79
  %10 = icmp eq i32 %9, 1, !dbg !79
  br i1 %10, label %11, label %14, !dbg !79

11:                                               ; preds = %1
  %12 = load i32, ptr %4, align 4, !dbg !79
  %13 = icmp eq i32 %12, 0, !dbg !79
  br label %14

14:                                               ; preds = %11, %1
  %15 = phi i1 [ false, %1 ], [ %13, %11 ], !dbg !80
  %16 = xor i1 %15, true, !dbg !79
  %17 = xor i1 %16, true, !dbg !79
  %18 = zext i1 %17 to i32, !dbg !79
  %19 = sext i32 %18 to i64, !dbg !79
  %20 = icmp ne i64 %19, 0, !dbg !79
  br i1 %20, label %21, label %23, !dbg !79

21:                                               ; preds = %14
  call void @__assert_rtn(ptr noundef @__func__.P1, ptr noundef @.str, i32 noundef 24, ptr noundef @.str.1) #3, !dbg !79
  unreachable, !dbg !79

22:                                               ; No predecessors!
  br label %24, !dbg !79

23:                                               ; preds = %14
  br label %24, !dbg !79

24:                                               ; preds = %23, %22
  ret ptr null, !dbg !81
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !82 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !85, !DIExpression(), !108)
    #dbg_declare(ptr %3, !109, !DIExpression(), !110)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @P0, ptr noundef null), !dbg !111
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @P1, ptr noundef null), !dbg !112
  ret i32 0, !dbg !113
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!50, !51, !52, !53, !54, !55, !56}
!llvm.ident = !{!57}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 7, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !30, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/rcu-MP.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "ee7d341ab9b618f6b5d9b52d690bd6c4")
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
!23 = !{!24, !28, !29}
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !25)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !26, line: 32, baseType: !27)
!26 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!27 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !{!31, !38, !43, !0, !48}
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 24, elements: !36)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !35)
!35 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!36 = !{!37}
!37 = !DISubrange(count: 3)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 72, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 9)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 192, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 24)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 8, type: !29, isLocal: false, isDefinition: true)
!50 = !{i32 7, !"Dwarf Version", i32 5}
!51 = !{i32 2, !"Debug Info Version", i32 3}
!52 = !{i32 1, !"wchar_size", i32 4}
!53 = !{i32 8, !"PIC Level", i32 2}
!54 = !{i32 7, !"PIE Level", i32 2}
!55 = !{i32 7, !"uwtable", i32 2}
!56 = !{i32 7, !"frame-pointer", i32 2}
!57 = !{!"Homebrew clang version 19.1.7"}
!58 = distinct !DISubprogram(name: "P0", scope: !3, file: !3, line: 10, type: !59, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !61)
!59 = !DISubroutineType(types: !60)
!60 = !{!28, !28}
!61 = !{}
!62 = !DILocalVariable(name: "arg", arg: 1, scope: !58, file: !3, line: 10, type: !28)
!63 = !DILocation(line: 10, column: 16, scope: !58)
!64 = !DILocation(line: 12, column: 2, scope: !58)
!65 = !DILocation(line: 13, column: 2, scope: !58)
!66 = !DILocation(line: 14, column: 2, scope: !58)
!67 = !DILocation(line: 15, column: 2, scope: !58)
!68 = distinct !DISubprogram(name: "P1", scope: !3, file: !3, line: 18, type: !59, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !61)
!69 = !DILocalVariable(name: "arg", arg: 1, scope: !68, file: !3, line: 18, type: !28)
!70 = !DILocation(line: 18, column: 16, scope: !68)
!71 = !DILocation(line: 20, column: 2, scope: !68)
!72 = !DILocalVariable(name: "r_y", scope: !68, file: !3, line: 21, type: !29)
!73 = !DILocation(line: 21, column: 6, scope: !68)
!74 = !DILocation(line: 21, column: 12, scope: !68)
!75 = !DILocalVariable(name: "r_x", scope: !68, file: !3, line: 22, type: !29)
!76 = !DILocation(line: 22, column: 6, scope: !68)
!77 = !DILocation(line: 22, column: 12, scope: !68)
!78 = !DILocation(line: 23, column: 2, scope: !68)
!79 = !DILocation(line: 24, column: 5, scope: !68)
!80 = !DILocation(line: 0, scope: !68)
!81 = !DILocation(line: 25, column: 2, scope: !68)
!82 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 29, type: !83, scopeLine: 30, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !61)
!83 = !DISubroutineType(types: !84)
!84 = !{!29}
!85 = !DILocalVariable(name: "t1", scope: !82, file: !3, line: 34, type: !86)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !87, line: 31, baseType: !88)
!87 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !89, line: 118, baseType: !90)
!89 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !91, size: 64)
!91 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !89, line: 103, size: 65536, elements: !92)
!92 = !{!93, !94, !104}
!93 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !91, file: !89, line: 104, baseType: !27, size: 64)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !91, file: !89, line: 105, baseType: !95, size: 64, offset: 64)
!95 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !96, size: 64)
!96 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !89, line: 57, size: 192, elements: !97)
!97 = !{!98, !102, !103}
!98 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !96, file: !89, line: 58, baseType: !99, size: 64)
!99 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !100, size: 64)
!100 = !DISubroutineType(types: !101)
!101 = !{null, !28}
!102 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !96, file: !89, line: 59, baseType: !28, size: 64, offset: 64)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !96, file: !89, line: 60, baseType: !95, size: 64, offset: 128)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !91, file: !89, line: 106, baseType: !105, size: 65408, offset: 128)
!105 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 65408, elements: !106)
!106 = !{!107}
!107 = !DISubrange(count: 8176)
!108 = !DILocation(line: 34, column: 12, scope: !82)
!109 = !DILocalVariable(name: "t2", scope: !82, file: !3, line: 34, type: !86)
!110 = !DILocation(line: 34, column: 16, scope: !82)
!111 = !DILocation(line: 36, column: 2, scope: !82)
!112 = !DILocation(line: 37, column: 2, scope: !82)
!113 = !DILocation(line: 39, column: 2, scope: !82)
