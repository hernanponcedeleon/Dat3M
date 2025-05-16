; ModuleID = 'benchmarks/lkmm/CoWR+poonceonce+Once.c'
source_filename = "benchmarks/lkmm/CoWR+poonceonce+Once.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0
@r0 = dso_local global i32 0, align 4, !dbg !46
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@.str = private unnamed_addr constant [23 x i8] c"CoWR+poonceonce+Once.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [32 x i8] c"!(READ_ONCE(x) == 1 && r0 == 2)\00", align 1, !dbg !41

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !56 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !60, !DIExpression(), !61)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !62
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !63
  %4 = trunc i64 %3 to i32, !dbg !63
  store i32 %4, ptr @r0, align 4, !dbg !64
  ret ptr null, !dbg !65
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !66 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !67, !DIExpression(), !68)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !69
  ret ptr null, !dbg !70
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !71 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !74, !DIExpression(), !98)
    #dbg_declare(ptr %3, !99, !DIExpression(), !100)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !101
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !102
  %6 = load ptr, ptr %2, align 8, !dbg !103
  %7 = call i32 @_pthread_join(ptr noundef %6, ptr noundef null), !dbg !104
  %8 = load ptr, ptr %3, align 8, !dbg !105
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !106
  %10 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !107
  %11 = trunc i64 %10 to i32, !dbg !107
  %12 = icmp eq i32 %11, 1, !dbg !107
  br i1 %12, label %13, label %16, !dbg !107

13:                                               ; preds = %0
  %14 = load i32, ptr @r0, align 4, !dbg !107
  %15 = icmp eq i32 %14, 2, !dbg !107
  br label %16

16:                                               ; preds = %13, %0
  %17 = phi i1 [ false, %0 ], [ %15, %13 ], !dbg !108
  %18 = xor i1 %17, true, !dbg !107
  %19 = xor i1 %18, true, !dbg !107
  %20 = zext i1 %19 to i32, !dbg !107
  %21 = sext i32 %20 to i64, !dbg !107
  %22 = icmp ne i64 %21, 0, !dbg !107
  br i1 %22, label %23, label %25, !dbg !107

23:                                               ; preds = %16
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 32, ptr noundef @.str.1) #3, !dbg !107
  unreachable, !dbg !107

24:                                               ; No predecessors!
  br label %26, !dbg !107

25:                                               ; preds = %16
  br label %26, !dbg !107

26:                                               ; preds = %25, %24
  ret i32 0, !dbg !109
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
!llvm.module.flags = !{!48, !49, !50, !51, !52, !53, !54}
!llvm.ident = !{!55}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !26, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/CoWR+poonceonce+Once.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "d522da5fecbd37dabc41d97e03f28b0d")
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
!28 = !{!29, !36, !41, !0, !46}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 32, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 40, elements: !34)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!33 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!34 = !{!35}
!35 = !DISubrange(count: 5)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 32, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 184, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 23)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !3, line: 32, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 256, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 32)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !3, line: 7, type: !26, isLocal: false, isDefinition: true)
!48 = !{i32 7, !"Dwarf Version", i32 5}
!49 = !{i32 2, !"Debug Info Version", i32 3}
!50 = !{i32 1, !"wchar_size", i32 4}
!51 = !{i32 8, !"PIC Level", i32 2}
!52 = !{i32 7, !"PIE Level", i32 2}
!53 = !{i32 7, !"uwtable", i32 2}
!54 = !{i32 7, !"frame-pointer", i32 2}
!55 = !{!"Homebrew clang version 19.1.7"}
!56 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 9, type: !57, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !59)
!57 = !DISubroutineType(types: !58)
!58 = !{!27, !27}
!59 = !{}
!60 = !DILocalVariable(name: "unused", arg: 1, scope: !56, file: !3, line: 9, type: !27)
!61 = !DILocation(line: 9, column: 22, scope: !56)
!62 = !DILocation(line: 11, column: 2, scope: !56)
!63 = !DILocation(line: 12, column: 7, scope: !56)
!64 = !DILocation(line: 12, column: 5, scope: !56)
!65 = !DILocation(line: 13, column: 2, scope: !56)
!66 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 16, type: !57, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !59)
!67 = !DILocalVariable(name: "unused", arg: 1, scope: !66, file: !3, line: 16, type: !27)
!68 = !DILocation(line: 16, column: 22, scope: !66)
!69 = !DILocation(line: 18, column: 2, scope: !66)
!70 = !DILocation(line: 19, column: 2, scope: !66)
!71 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 22, type: !72, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !59)
!72 = !DISubroutineType(types: !73)
!73 = !{!26}
!74 = !DILocalVariable(name: "t1", scope: !71, file: !3, line: 24, type: !75)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !76, line: 31, baseType: !77)
!76 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !78, line: 118, baseType: !79)
!78 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!80 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !78, line: 103, size: 65536, elements: !81)
!81 = !{!82, !84, !94}
!82 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !80, file: !78, line: 104, baseType: !83, size: 64)
!83 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !80, file: !78, line: 105, baseType: !85, size: 64, offset: 64)
!85 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !86, size: 64)
!86 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !78, line: 57, size: 192, elements: !87)
!87 = !{!88, !92, !93}
!88 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !86, file: !78, line: 58, baseType: !89, size: 64)
!89 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !90, size: 64)
!90 = !DISubroutineType(types: !91)
!91 = !{null, !27}
!92 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !86, file: !78, line: 59, baseType: !27, size: 64, offset: 64)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !86, file: !78, line: 60, baseType: !85, size: 64, offset: 128)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !80, file: !78, line: 106, baseType: !95, size: 65408, offset: 128)
!95 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !96)
!96 = !{!97}
!97 = !DISubrange(count: 8176)
!98 = !DILocation(line: 24, column: 12, scope: !71)
!99 = !DILocalVariable(name: "t2", scope: !71, file: !3, line: 24, type: !75)
!100 = !DILocation(line: 24, column: 16, scope: !71)
!101 = !DILocation(line: 26, column: 2, scope: !71)
!102 = !DILocation(line: 27, column: 2, scope: !71)
!103 = !DILocation(line: 29, column: 15, scope: !71)
!104 = !DILocation(line: 29, column: 2, scope: !71)
!105 = !DILocation(line: 30, column: 15, scope: !71)
!106 = !DILocation(line: 30, column: 2, scope: !71)
!107 = !DILocation(line: 32, column: 2, scope: !71)
!108 = !DILocation(line: 0, scope: !71)
!109 = !DILocation(line: 34, column: 2, scope: !71)
