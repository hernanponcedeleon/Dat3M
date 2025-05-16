; ModuleID = 'benchmarks/lkmm/C-PaulEMcKenney-MP+o-r+ai-mb-o.c'
source_filename = "benchmarks/lkmm/C-PaulEMcKenney-MP+o-r+ai-mb-o.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }

@x = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !0
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !52
@r0 = dso_local global i32 0, align 4, !dbg !58
@r1 = dso_local global i32 0, align 4, !dbg !60
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !35
@.str = private unnamed_addr constant [33 x i8] c"C-PaulEMcKenney-MP+o-r+ai-mb-o.c\00", align 1, !dbg !42
@.str.1 = private unnamed_addr constant [18 x i8] c"!(r0==0 && r1==0)\00", align 1, !dbg !47

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !70 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !74, !DIExpression(), !75)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !76
  %3 = call i64 @__LKMM_xchg(ptr noundef @y, i64 noundef 4, i64 noundef 5, i32 noundef 3), !dbg !77
  %4 = trunc i64 %3 to i32, !dbg !77
  store i32 %4, ptr @r0, align 4, !dbg !78
  ret ptr null, !dbg !79
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_xchg(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !80 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !81, !DIExpression(), !82)
  call void @__LKMM_atomic_op(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !83
  call void @__LKMM_fence(i32 noundef 4), !dbg !84
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !85
  %4 = trunc i64 %3 to i32, !dbg !85
  store i32 %4, ptr @r1, align 4, !dbg !86
  ret ptr null, !dbg !87
}

declare void @__LKMM_atomic_op(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_fence(i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !88 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !91, !DIExpression(), !115)
    #dbg_declare(ptr %3, !116, !DIExpression(), !117)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !118
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !119
  %6 = load ptr, ptr %2, align 8, !dbg !120
  %7 = call i32 @_pthread_join(ptr noundef %6, ptr noundef null), !dbg !121
  %8 = load ptr, ptr %3, align 8, !dbg !122
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !123
  %10 = load i32, ptr @r0, align 4, !dbg !124
  %11 = icmp eq i32 %10, 0, !dbg !124
  br i1 %11, label %12, label %15, !dbg !124

12:                                               ; preds = %0
  %13 = load i32, ptr @r1, align 4, !dbg !124
  %14 = icmp eq i32 %13, 0, !dbg !124
  br label %15

15:                                               ; preds = %12, %0
  %16 = phi i1 [ false, %0 ], [ %14, %12 ], !dbg !125
  %17 = xor i1 %16, true, !dbg !124
  %18 = xor i1 %17, true, !dbg !124
  %19 = zext i1 %18 to i32, !dbg !124
  %20 = sext i32 %19 to i64, !dbg !124
  %21 = icmp ne i64 %20, 0, !dbg !124
  br i1 %21, label %22, label %24, !dbg !124

22:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 36, ptr noundef @.str.1) #3, !dbg !124
  unreachable, !dbg !124

23:                                               ; No predecessors!
  br label %25, !dbg !124

24:                                               ; preds = %15
  br label %25, !dbg !124

25:                                               ; preds = %24, %23
  ret i32 0, !dbg !126
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
!llvm.module.flags = !{!62, !63, !64, !65, !66, !67, !68}
!llvm.ident = !{!69}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 8, type: !54, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !29, globals: !34, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/C-PaulEMcKenney-MP+o-r+ai-mb-o.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "377543d76e9e8d65f8e25797dc3d9ac2")
!4 = !{!5, !23}
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
!23 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_operation", file: !6, line: 20, baseType: !7, size: 32, elements: !24)
!24 = !{!25, !26, !27, !28}
!25 = !DIEnumerator(name: "__LKMM_op_add", value: 0)
!26 = !DIEnumerator(name: "__LKMM_op_sub", value: 1)
!27 = !DIEnumerator(name: "__LKMM_op_and", value: 2)
!28 = !DIEnumerator(name: "__LKMM_op_or", value: 3)
!29 = !{!30, !32, !33}
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !31)
!31 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!32 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!33 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!34 = !{!35, !42, !47, !0, !52, !58, !60}
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(scope: null, file: !3, line: 36, type: !37, isLocal: true, isDefinition: true)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 40, elements: !40)
!38 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !39)
!39 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!40 = !{!41}
!41 = !DISubrange(count: 5)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 36, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 264, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 33)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(scope: null, file: !3, line: 36, type: !49, isLocal: true, isDefinition: true)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 144, elements: !50)
!50 = !{!51}
!51 = !DISubrange(count: 18)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 8, type: !54, isLocal: false, isDefinition: true)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 109, baseType: !55)
!55 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 107, size: 32, elements: !56)
!56 = !{!57}
!57 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !55, file: !6, line: 108, baseType: !32, size: 32)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !3, line: 9, type: !32, isLocal: false, isDefinition: true)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "r1", scope: !2, file: !3, line: 9, type: !32, isLocal: false, isDefinition: true)
!62 = !{i32 7, !"Dwarf Version", i32 5}
!63 = !{i32 2, !"Debug Info Version", i32 3}
!64 = !{i32 1, !"wchar_size", i32 4}
!65 = !{i32 8, !"PIC Level", i32 2}
!66 = !{i32 7, !"PIE Level", i32 2}
!67 = !{i32 7, !"uwtable", i32 2}
!68 = !{i32 7, !"frame-pointer", i32 2}
!69 = !{!"Homebrew clang version 19.1.7"}
!70 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 11, type: !71, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !73)
!71 = !DISubroutineType(types: !72)
!72 = !{!33, !33}
!73 = !{}
!74 = !DILocalVariable(name: "arg", arg: 1, scope: !70, file: !3, line: 11, type: !33)
!75 = !DILocation(line: 11, column: 22, scope: !70)
!76 = !DILocation(line: 13, column: 2, scope: !70)
!77 = !DILocation(line: 14, column: 7, scope: !70)
!78 = !DILocation(line: 14, column: 5, scope: !70)
!79 = !DILocation(line: 15, column: 2, scope: !70)
!80 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 18, type: !71, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !73)
!81 = !DILocalVariable(name: "arg", arg: 1, scope: !80, file: !3, line: 18, type: !33)
!82 = !DILocation(line: 18, column: 22, scope: !80)
!83 = !DILocation(line: 20, column: 2, scope: !80)
!84 = !DILocation(line: 21, column: 2, scope: !80)
!85 = !DILocation(line: 22, column: 7, scope: !80)
!86 = !DILocation(line: 22, column: 5, scope: !80)
!87 = !DILocation(line: 23, column: 2, scope: !80)
!88 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 26, type: !89, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !73)
!89 = !DISubroutineType(types: !90)
!90 = !{!32}
!91 = !DILocalVariable(name: "t1", scope: !88, file: !3, line: 28, type: !92)
!92 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !93, line: 31, baseType: !94)
!93 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !95, line: 118, baseType: !96)
!95 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!96 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64)
!97 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !95, line: 103, size: 65536, elements: !98)
!98 = !{!99, !101, !111}
!99 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !97, file: !95, line: 104, baseType: !100, size: 64)
!100 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !97, file: !95, line: 105, baseType: !102, size: 64, offset: 64)
!102 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64)
!103 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !95, line: 57, size: 192, elements: !104)
!104 = !{!105, !109, !110}
!105 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !103, file: !95, line: 58, baseType: !106, size: 64)
!106 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !107, size: 64)
!107 = !DISubroutineType(types: !108)
!108 = !{null, !33}
!109 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !103, file: !95, line: 59, baseType: !33, size: 64, offset: 64)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !103, file: !95, line: 60, baseType: !102, size: 64, offset: 128)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !97, file: !95, line: 106, baseType: !112, size: 65408, offset: 128)
!112 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 65408, elements: !113)
!113 = !{!114}
!114 = !DISubrange(count: 8176)
!115 = !DILocation(line: 28, column: 15, scope: !88)
!116 = !DILocalVariable(name: "t2", scope: !88, file: !3, line: 28, type: !92)
!117 = !DILocation(line: 28, column: 19, scope: !88)
!118 = !DILocation(line: 30, column: 5, scope: !88)
!119 = !DILocation(line: 31, column: 5, scope: !88)
!120 = !DILocation(line: 33, column: 18, scope: !88)
!121 = !DILocation(line: 33, column: 5, scope: !88)
!122 = !DILocation(line: 34, column: 18, scope: !88)
!123 = !DILocation(line: 34, column: 5, scope: !88)
!124 = !DILocation(line: 36, column: 5, scope: !88)
!125 = !DILocation(line: 0, scope: !88)
!126 = !DILocation(line: 38, column: 5, scope: !88)
