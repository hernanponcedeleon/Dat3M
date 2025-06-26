; ModuleID = 'benchmarks/lkmm/C-PaulEMcKenney-MP+o-r+ai-mb-o.c'
source_filename = "benchmarks/lkmm/C-PaulEMcKenney-MP+o-r+ai-mb-o.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }

@x = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !0
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !53
@r0 = dso_local global i32 0, align 4, !dbg !59
@r1 = dso_local global i32 0, align 4, !dbg !61
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !36
@.str = private unnamed_addr constant [33 x i8] c"C-PaulEMcKenney-MP+o-r+ai-mb-o.c\00", align 1, !dbg !43
@.str.1 = private unnamed_addr constant [18 x i8] c"!(r0==0 && r1==0)\00", align 1, !dbg !48

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !71 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !75, !DIExpression(), !76)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !77
  %3 = call i64 @__LKMM_xchg(ptr noundef @y, i64 noundef 4, i64 noundef 5, i32 noundef 2), !dbg !78
  %4 = trunc i64 %3 to i32, !dbg !78
  store i32 %4, ptr @r0, align 4, !dbg !79
  ret ptr null, !dbg !80
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_xchg(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !81 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !82, !DIExpression(), !83)
  call void @__LKMM_atomic_op(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !84
  call void @__LKMM_fence(i32 noundef 3), !dbg !85
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !86
  %4 = trunc i64 %3 to i32, !dbg !86
  store i32 %4, ptr @r1, align 4, !dbg !87
  ret ptr null, !dbg !88
}

declare void @__LKMM_atomic_op(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_fence(i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !89 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !92, !DIExpression(), !115)
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
!llvm.module.flags = !{!63, !64, !65, !66, !67, !68, !69}
!llvm.ident = !{!70}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 8, type: !55, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !28, globals: !35, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/C-PaulEMcKenney-MP+o-r+ai-mb-o.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "377543d76e9e8d65f8e25797dc3d9ac2")
!4 = !{!5, !22}
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
!22 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_operation", file: !6, line: 19, baseType: !7, size: 32, elements: !23)
!23 = !{!24, !25, !26, !27}
!24 = !DIEnumerator(name: "__LKMM_op_add", value: 0)
!25 = !DIEnumerator(name: "__LKMM_op_sub", value: 1)
!26 = !DIEnumerator(name: "__LKMM_op_and", value: 2)
!27 = !DIEnumerator(name: "__LKMM_op_or", value: 3)
!28 = !{!29, !33, !34}
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 27, baseType: !30)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !31, line: 32, baseType: !32)
!31 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!32 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!33 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!35 = !{!36, !43, !48, !0, !53, !59, !61}
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 36, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 40, elements: !41)
!39 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !40)
!40 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!41 = !{!42}
!42 = !DISubrange(count: 5)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !3, line: 36, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 264, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 33)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(scope: null, file: !3, line: 36, type: !50, isLocal: true, isDefinition: true)
!50 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 144, elements: !51)
!51 = !{!52}
!52 = !DISubrange(count: 18)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 8, type: !55, isLocal: false, isDefinition: true)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 108, baseType: !56)
!56 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 106, size: 32, elements: !57)
!57 = !{!58}
!58 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !56, file: !6, line: 107, baseType: !33, size: 32)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !3, line: 9, type: !33, isLocal: false, isDefinition: true)
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(name: "r1", scope: !2, file: !3, line: 9, type: !33, isLocal: false, isDefinition: true)
!63 = !{i32 7, !"Dwarf Version", i32 5}
!64 = !{i32 2, !"Debug Info Version", i32 3}
!65 = !{i32 1, !"wchar_size", i32 4}
!66 = !{i32 8, !"PIC Level", i32 2}
!67 = !{i32 7, !"PIE Level", i32 2}
!68 = !{i32 7, !"uwtable", i32 2}
!69 = !{i32 7, !"frame-pointer", i32 2}
!70 = !{!"Homebrew clang version 19.1.7"}
!71 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 11, type: !72, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!72 = !DISubroutineType(types: !73)
!73 = !{!34, !34}
!74 = !{}
!75 = !DILocalVariable(name: "arg", arg: 1, scope: !71, file: !3, line: 11, type: !34)
!76 = !DILocation(line: 11, column: 22, scope: !71)
!77 = !DILocation(line: 13, column: 2, scope: !71)
!78 = !DILocation(line: 14, column: 7, scope: !71)
!79 = !DILocation(line: 14, column: 5, scope: !71)
!80 = !DILocation(line: 15, column: 2, scope: !71)
!81 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 18, type: !72, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!82 = !DILocalVariable(name: "arg", arg: 1, scope: !81, file: !3, line: 18, type: !34)
!83 = !DILocation(line: 18, column: 22, scope: !81)
!84 = !DILocation(line: 20, column: 2, scope: !81)
!85 = !DILocation(line: 21, column: 2, scope: !81)
!86 = !DILocation(line: 22, column: 7, scope: !81)
!87 = !DILocation(line: 22, column: 5, scope: !81)
!88 = !DILocation(line: 23, column: 2, scope: !81)
!89 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 26, type: !90, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!90 = !DISubroutineType(types: !91)
!91 = !{!33}
!92 = !DILocalVariable(name: "t1", scope: !89, file: !3, line: 28, type: !93)
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !94, line: 31, baseType: !95)
!94 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!95 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !96, line: 118, baseType: !97)
!96 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!97 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!98 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !96, line: 103, size: 65536, elements: !99)
!99 = !{!100, !101, !111}
!100 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !98, file: !96, line: 104, baseType: !32, size: 64)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !98, file: !96, line: 105, baseType: !102, size: 64, offset: 64)
!102 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64)
!103 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !96, line: 57, size: 192, elements: !104)
!104 = !{!105, !109, !110}
!105 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !103, file: !96, line: 58, baseType: !106, size: 64)
!106 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !107, size: 64)
!107 = !DISubroutineType(types: !108)
!108 = !{null, !34}
!109 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !103, file: !96, line: 59, baseType: !34, size: 64, offset: 64)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !103, file: !96, line: 60, baseType: !102, size: 64, offset: 128)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !98, file: !96, line: 106, baseType: !112, size: 65408, offset: 128)
!112 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 65408, elements: !113)
!113 = !{!114}
!114 = !DISubrange(count: 8176)
!115 = !DILocation(line: 28, column: 15, scope: !89)
!116 = !DILocalVariable(name: "t2", scope: !89, file: !3, line: 28, type: !93)
!117 = !DILocation(line: 28, column: 19, scope: !89)
!118 = !DILocation(line: 30, column: 5, scope: !89)
!119 = !DILocation(line: 31, column: 5, scope: !89)
!120 = !DILocation(line: 33, column: 18, scope: !89)
!121 = !DILocation(line: 33, column: 5, scope: !89)
!122 = !DILocation(line: 34, column: 18, scope: !89)
!123 = !DILocation(line: 34, column: 5, scope: !89)
!124 = !DILocation(line: 36, column: 5, scope: !89)
!125 = !DILocation(line: 0, scope: !89)
!126 = !DILocation(line: 38, column: 5, scope: !89)
