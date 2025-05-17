; ModuleID = 'benchmarks/lkmm/LB+fencembonceonce+ctrlonceonce.c'
source_filename = "benchmarks/lkmm/LB+fencembonceonce+ctrlonceonce.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@r0 = dso_local global i32 0, align 4, !dbg !0
@x = dso_local global i32 0, align 4, !dbg !46
@y = dso_local global i32 0, align 4, !dbg !48
@r1 = dso_local global i32 0, align 4, !dbg !50
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@.str = private unnamed_addr constant [34 x i8] c"LB+fencembonceonce+ctrlonceonce.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [44 x i8] c"!(READ_ONCE(r0) == 1 && READ_ONCE(r1) == 1)\00", align 1, !dbg !41

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !60 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !64, !DIExpression(), !65)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !66
  %4 = trunc i64 %3 to i32, !dbg !66
  %5 = sext i32 %4 to i64, !dbg !66
  call void @__LKMM_store(ptr noundef @r0, i64 noundef 4, i64 noundef %5, i32 noundef 1), !dbg !66
  %6 = call i64 @__LKMM_load(ptr noundef @r0, i64 noundef 4, i32 noundef 1), !dbg !67
  %7 = trunc i64 %6 to i32, !dbg !67
  %8 = icmp ne i32 %7, 0, !dbg !67
  br i1 %8, label %9, label %10, !dbg !69

9:                                                ; preds = %1
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !70
  br label %10, !dbg !70

10:                                               ; preds = %9, %1
  ret ptr null, !dbg !71
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !72 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !73, !DIExpression(), !74)
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !75
  %4 = trunc i64 %3 to i32, !dbg !75
  %5 = sext i32 %4 to i64, !dbg !75
  call void @__LKMM_store(ptr noundef @r1, i64 noundef 4, i64 noundef %5, i32 noundef 1), !dbg !75
  call void @__LKMM_fence(i32 noundef 4), !dbg !76
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !77
  ret ptr null, !dbg !78
}

declare void @__LKMM_fence(i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !79 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !82, !DIExpression(), !106)
    #dbg_declare(ptr %3, !107, !DIExpression(), !108)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !109
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !110
  %6 = load ptr, ptr %2, align 8, !dbg !111
  %7 = call i32 @_pthread_join(ptr noundef %6, ptr noundef null), !dbg !112
  %8 = load ptr, ptr %3, align 8, !dbg !113
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !114
  %10 = call i64 @__LKMM_load(ptr noundef @r0, i64 noundef 4, i32 noundef 1), !dbg !115
  %11 = trunc i64 %10 to i32, !dbg !115
  %12 = icmp eq i32 %11, 1, !dbg !115
  br i1 %12, label %13, label %17, !dbg !115

13:                                               ; preds = %0
  %14 = call i64 @__LKMM_load(ptr noundef @r1, i64 noundef 4, i32 noundef 1), !dbg !115
  %15 = trunc i64 %14 to i32, !dbg !115
  %16 = icmp eq i32 %15, 1, !dbg !115
  br label %17

17:                                               ; preds = %13, %0
  %18 = phi i1 [ false, %0 ], [ %16, %13 ], !dbg !116
  %19 = xor i1 %18, true, !dbg !115
  %20 = xor i1 %19, true, !dbg !115
  %21 = zext i1 %20 to i32, !dbg !115
  %22 = sext i32 %21 to i64, !dbg !115
  %23 = icmp ne i64 %22, 0, !dbg !115
  br i1 %23, label %24, label %26, !dbg !115

24:                                               ; preds = %17
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 37, ptr noundef @.str.1) #3, !dbg !115
  unreachable, !dbg !115

25:                                               ; No predecessors!
  br label %27, !dbg !115

26:                                               ; preds = %17
  br label %27, !dbg !115

27:                                               ; preds = %26, %25
  ret i32 0, !dbg !117
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
!llvm.module.flags = !{!52, !53, !54, !55, !56, !57, !58}
!llvm.ident = !{!59}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !3, line: 9, type: !26, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/LB+fencembonceonce+ctrlonceonce.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "e04735b1ad6e052c08fd1ecbe5dcff13")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "27b8121cb2c90fe5c99c4b3e89c9755e")
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
!23 = !{!24, !26, !27}
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !25)
!25 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!26 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!28 = !{!29, !36, !41, !46, !48, !0, !50}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 37, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 40, elements: !34)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!33 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!34 = !{!35}
!35 = !DISubrange(count: 5)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 37, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 272, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 34)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !3, line: 37, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 352, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 44)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !26, isLocal: false, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !26, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "r1", scope: !2, file: !3, line: 9, type: !26, isLocal: false, isDefinition: true)
!52 = !{i32 7, !"Dwarf Version", i32 5}
!53 = !{i32 2, !"Debug Info Version", i32 3}
!54 = !{i32 1, !"wchar_size", i32 4}
!55 = !{i32 8, !"PIC Level", i32 2}
!56 = !{i32 7, !"PIE Level", i32 2}
!57 = !{i32 7, !"uwtable", i32 2}
!58 = !{i32 7, !"frame-pointer", i32 2}
!59 = !{!"Homebrew clang version 19.1.7"}
!60 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 11, type: !61, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!61 = !DISubroutineType(types: !62)
!62 = !{!27, !27}
!63 = !{}
!64 = !DILocalVariable(name: "unused", arg: 1, scope: !60, file: !3, line: 11, type: !27)
!65 = !DILocation(line: 11, column: 22, scope: !60)
!66 = !DILocation(line: 13, column: 2, scope: !60)
!67 = !DILocation(line: 14, column: 6, scope: !68)
!68 = distinct !DILexicalBlock(scope: !60, file: !3, line: 14, column: 6)
!69 = !DILocation(line: 14, column: 6, scope: !60)
!70 = !DILocation(line: 15, column: 3, scope: !68)
!71 = !DILocation(line: 16, column: 2, scope: !60)
!72 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 19, type: !61, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!73 = !DILocalVariable(name: "unused", arg: 1, scope: !72, file: !3, line: 19, type: !27)
!74 = !DILocation(line: 19, column: 22, scope: !72)
!75 = !DILocation(line: 21, column: 2, scope: !72)
!76 = !DILocation(line: 22, column: 2, scope: !72)
!77 = !DILocation(line: 23, column: 2, scope: !72)
!78 = !DILocation(line: 24, column: 2, scope: !72)
!79 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 27, type: !80, scopeLine: 28, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!80 = !DISubroutineType(types: !81)
!81 = !{!26}
!82 = !DILocalVariable(name: "t1", scope: !79, file: !3, line: 29, type: !83)
!83 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !84, line: 31, baseType: !85)
!84 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!85 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !86, line: 118, baseType: !87)
!86 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !86, line: 103, size: 65536, elements: !89)
!89 = !{!90, !92, !102}
!90 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !88, file: !86, line: 104, baseType: !91, size: 64)
!91 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !88, file: !86, line: 105, baseType: !93, size: 64, offset: 64)
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!94 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !86, line: 57, size: 192, elements: !95)
!95 = !{!96, !100, !101}
!96 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !94, file: !86, line: 58, baseType: !97, size: 64)
!97 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!98 = !DISubroutineType(types: !99)
!99 = !{null, !27}
!100 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !94, file: !86, line: 59, baseType: !27, size: 64, offset: 64)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !94, file: !86, line: 60, baseType: !93, size: 64, offset: 128)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !88, file: !86, line: 106, baseType: !103, size: 65408, offset: 128)
!103 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !104)
!104 = !{!105}
!105 = !DISubrange(count: 8176)
!106 = !DILocation(line: 29, column: 12, scope: !79)
!107 = !DILocalVariable(name: "t2", scope: !79, file: !3, line: 29, type: !83)
!108 = !DILocation(line: 29, column: 16, scope: !79)
!109 = !DILocation(line: 31, column: 2, scope: !79)
!110 = !DILocation(line: 32, column: 2, scope: !79)
!111 = !DILocation(line: 34, column: 15, scope: !79)
!112 = !DILocation(line: 34, column: 2, scope: !79)
!113 = !DILocation(line: 35, column: 15, scope: !79)
!114 = !DILocation(line: 35, column: 2, scope: !79)
!115 = !DILocation(line: 37, column: 2, scope: !79)
!116 = !DILocation(line: 0, scope: !79)
!117 = !DILocation(line: 39, column: 2, scope: !79)
