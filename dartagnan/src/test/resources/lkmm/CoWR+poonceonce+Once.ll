; ModuleID = 'benchmarks/lkmm/CoWR+poonceonce+Once.c'
source_filename = "benchmarks/lkmm/CoWR+poonceonce+Once.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0
@r0 = dso_local global i32 0, align 4, !dbg !48
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !31
@.str = private unnamed_addr constant [23 x i8] c"CoWR+poonceonce+Once.c\00", align 1, !dbg !38
@.str.1 = private unnamed_addr constant [32 x i8] c"!(READ_ONCE(x) == 1 && r0 == 2)\00", align 1, !dbg !43

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !58 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !62, !DIExpression(), !63)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !64
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !65
  %4 = trunc i64 %3 to i32, !dbg !65
  store i32 %4, ptr @r0, align 4, !dbg !66
  ret ptr null, !dbg !67
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !68 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !69, !DIExpression(), !70)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !71
  ret ptr null, !dbg !72
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !73 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !76, !DIExpression(), !99)
    #dbg_declare(ptr %3, !100, !DIExpression(), !101)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !102
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !103
  %6 = load ptr, ptr %2, align 8, !dbg !104
  %7 = call i32 @_pthread_join(ptr noundef %6, ptr noundef null), !dbg !105
  %8 = load ptr, ptr %3, align 8, !dbg !106
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !107
  %10 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !108
  %11 = trunc i64 %10 to i32, !dbg !108
  %12 = icmp eq i32 %11, 1, !dbg !108
  br i1 %12, label %13, label %16, !dbg !108

13:                                               ; preds = %0
  %14 = load i32, ptr @r0, align 4, !dbg !108
  %15 = icmp eq i32 %14, 2, !dbg !108
  br label %16

16:                                               ; preds = %13, %0
  %17 = phi i1 [ false, %0 ], [ %15, %13 ], !dbg !109
  %18 = xor i1 %17, true, !dbg !108
  %19 = xor i1 %18, true, !dbg !108
  %20 = zext i1 %19 to i32, !dbg !108
  %21 = sext i32 %20 to i64, !dbg !108
  %22 = icmp ne i64 %21, 0, !dbg !108
  br i1 %22, label %23, label %25, !dbg !108

23:                                               ; preds = %16
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 32, ptr noundef @.str.1) #3, !dbg !108
  unreachable, !dbg !108

24:                                               ; No predecessors!
  br label %26, !dbg !108

25:                                               ; preds = %16
  br label %26, !dbg !108

26:                                               ; preds = %25, %24
  ret i32 0, !dbg !110
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
!llvm.module.flags = !{!50, !51, !52, !53, !54, !55, !56}
!llvm.ident = !{!57}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !30, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/CoWR+poonceonce+Once.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "d522da5fecbd37dabc41d97e03f28b0d")
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
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!30 = !{!31, !38, !43, !0, !48}
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 32, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 40, elements: !36)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !35)
!35 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!36 = !{!37}
!37 = !DISubrange(count: 5)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !3, line: 32, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 184, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 23)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !3, line: 32, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 256, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 32)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !3, line: 7, type: !28, isLocal: false, isDefinition: true)
!50 = !{i32 7, !"Dwarf Version", i32 5}
!51 = !{i32 2, !"Debug Info Version", i32 3}
!52 = !{i32 1, !"wchar_size", i32 4}
!53 = !{i32 8, !"PIC Level", i32 2}
!54 = !{i32 7, !"PIE Level", i32 2}
!55 = !{i32 7, !"uwtable", i32 2}
!56 = !{i32 7, !"frame-pointer", i32 2}
!57 = !{!"Homebrew clang version 19.1.7"}
!58 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 9, type: !59, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !61)
!59 = !DISubroutineType(types: !60)
!60 = !{!29, !29}
!61 = !{}
!62 = !DILocalVariable(name: "unused", arg: 1, scope: !58, file: !3, line: 9, type: !29)
!63 = !DILocation(line: 9, column: 22, scope: !58)
!64 = !DILocation(line: 11, column: 2, scope: !58)
!65 = !DILocation(line: 12, column: 7, scope: !58)
!66 = !DILocation(line: 12, column: 5, scope: !58)
!67 = !DILocation(line: 13, column: 2, scope: !58)
!68 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 16, type: !59, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !61)
!69 = !DILocalVariable(name: "unused", arg: 1, scope: !68, file: !3, line: 16, type: !29)
!70 = !DILocation(line: 16, column: 22, scope: !68)
!71 = !DILocation(line: 18, column: 2, scope: !68)
!72 = !DILocation(line: 19, column: 2, scope: !68)
!73 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 22, type: !74, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !61)
!74 = !DISubroutineType(types: !75)
!75 = !{!28}
!76 = !DILocalVariable(name: "t1", scope: !73, file: !3, line: 24, type: !77)
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !78, line: 31, baseType: !79)
!78 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !80, line: 118, baseType: !81)
!80 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !82, size: 64)
!82 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !80, line: 103, size: 65536, elements: !83)
!83 = !{!84, !85, !95}
!84 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !82, file: !80, line: 104, baseType: !27, size: 64)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !82, file: !80, line: 105, baseType: !86, size: 64, offset: 64)
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !87, size: 64)
!87 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !80, line: 57, size: 192, elements: !88)
!88 = !{!89, !93, !94}
!89 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !87, file: !80, line: 58, baseType: !90, size: 64)
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !91, size: 64)
!91 = !DISubroutineType(types: !92)
!92 = !{null, !29}
!93 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !87, file: !80, line: 59, baseType: !29, size: 64, offset: 64)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !87, file: !80, line: 60, baseType: !86, size: 64, offset: 128)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !82, file: !80, line: 106, baseType: !96, size: 65408, offset: 128)
!96 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 65408, elements: !97)
!97 = !{!98}
!98 = !DISubrange(count: 8176)
!99 = !DILocation(line: 24, column: 12, scope: !73)
!100 = !DILocalVariable(name: "t2", scope: !73, file: !3, line: 24, type: !77)
!101 = !DILocation(line: 24, column: 16, scope: !73)
!102 = !DILocation(line: 26, column: 2, scope: !73)
!103 = !DILocation(line: 27, column: 2, scope: !73)
!104 = !DILocation(line: 29, column: 15, scope: !73)
!105 = !DILocation(line: 29, column: 2, scope: !73)
!106 = !DILocation(line: 30, column: 15, scope: !73)
!107 = !DILocation(line: 30, column: 2, scope: !73)
!108 = !DILocation(line: 32, column: 2, scope: !73)
!109 = !DILocation(line: 0, scope: !73)
!110 = !DILocation(line: 34, column: 2, scope: !73)
