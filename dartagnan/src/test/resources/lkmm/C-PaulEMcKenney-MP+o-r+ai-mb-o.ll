; ModuleID = 'benchmarks/lkmm/C-PaulEMcKenney-MP+o-r+ai-mb-o.c'
source_filename = "benchmarks/lkmm/C-PaulEMcKenney-MP+o-r+ai-mb-o.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }

@x = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !0
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !54
@r0 = dso_local global i32 0, align 4, !dbg !60
@r1 = dso_local global i32 0, align 4, !dbg !62
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !37
@.str = private unnamed_addr constant [33 x i8] c"C-PaulEMcKenney-MP+o-r+ai-mb-o.c\00", align 1, !dbg !44
@.str.1 = private unnamed_addr constant [18 x i8] c"!(r0==0 && r1==0)\00", align 1, !dbg !49

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !72 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !76, !DIExpression(), !77)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !78
  %3 = call i64 @__LKMM_xchg(ptr noundef @y, i64 noundef 4, i64 noundef 5, i32 noundef 3), !dbg !79
  %4 = trunc i64 %3 to i32, !dbg !79
  store i32 %4, ptr @r0, align 4, !dbg !80
  ret ptr null, !dbg !81
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_xchg(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !82 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !83, !DIExpression(), !84)
  call void @__LKMM_atomic_op(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !85
  call void @__LKMM_fence(i32 noundef 4), !dbg !86
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !87
  %4 = trunc i64 %3 to i32, !dbg !87
  store i32 %4, ptr @r1, align 4, !dbg !88
  ret ptr null, !dbg !89
}

declare void @__LKMM_atomic_op(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_fence(i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !90 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !93, !DIExpression(), !116)
    #dbg_declare(ptr %3, !117, !DIExpression(), !118)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !119
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !120
  %6 = load ptr, ptr %2, align 8, !dbg !121
  %7 = call i32 @_pthread_join(ptr noundef %6, ptr noundef null), !dbg !122
  %8 = load ptr, ptr %3, align 8, !dbg !123
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !124
  %10 = load i32, ptr @r0, align 4, !dbg !125
  %11 = icmp eq i32 %10, 0, !dbg !125
  br i1 %11, label %12, label %15, !dbg !125

12:                                               ; preds = %0
  %13 = load i32, ptr @r1, align 4, !dbg !125
  %14 = icmp eq i32 %13, 0, !dbg !125
  br label %15

15:                                               ; preds = %12, %0
  %16 = phi i1 [ false, %0 ], [ %14, %12 ], !dbg !126
  %17 = xor i1 %16, true, !dbg !125
  %18 = xor i1 %17, true, !dbg !125
  %19 = zext i1 %18 to i32, !dbg !125
  %20 = sext i32 %19 to i64, !dbg !125
  %21 = icmp ne i64 %20, 0, !dbg !125
  br i1 %21, label %22, label %24, !dbg !125

22:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 36, ptr noundef @.str.1) #3, !dbg !125
  unreachable, !dbg !125

23:                                               ; No predecessors!
  br label %25, !dbg !125

24:                                               ; preds = %15
  br label %25, !dbg !125

25:                                               ; preds = %24, %23
  ret i32 0, !dbg !127
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
!llvm.module.flags = !{!64, !65, !66, !67, !68, !69, !70}
!llvm.ident = !{!71}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 8, type: !56, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !29, globals: !36, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/C-PaulEMcKenney-MP+o-r+ai-mb-o.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "377543d76e9e8d65f8e25797dc3d9ac2")
!4 = !{!5, !23}
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
!23 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_operation", file: !6, line: 20, baseType: !7, size: 32, elements: !24)
!24 = !{!25, !26, !27, !28}
!25 = !DIEnumerator(name: "__LKMM_op_add", value: 0)
!26 = !DIEnumerator(name: "__LKMM_op_sub", value: 1)
!27 = !DIEnumerator(name: "__LKMM_op_and", value: 2)
!28 = !DIEnumerator(name: "__LKMM_op_or", value: 3)
!29 = !{!30, !34, !35}
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !31)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !32, line: 32, baseType: !33)
!32 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!33 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!34 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!36 = !{!37, !44, !49, !0, !54, !60, !62}
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 36, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 40, elements: !42)
!40 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !41)
!41 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!42 = !{!43}
!43 = !DISubrange(count: 5)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(scope: null, file: !3, line: 36, type: !46, isLocal: true, isDefinition: true)
!46 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 264, elements: !47)
!47 = !{!48}
!48 = !DISubrange(count: 33)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(scope: null, file: !3, line: 36, type: !51, isLocal: true, isDefinition: true)
!51 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 144, elements: !52)
!52 = !{!53}
!53 = !DISubrange(count: 18)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 8, type: !56, isLocal: false, isDefinition: true)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 109, baseType: !57)
!57 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 107, size: 32, elements: !58)
!58 = !{!59}
!59 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !57, file: !6, line: 108, baseType: !34, size: 32)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !3, line: 9, type: !34, isLocal: false, isDefinition: true)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "r1", scope: !2, file: !3, line: 9, type: !34, isLocal: false, isDefinition: true)
!64 = !{i32 7, !"Dwarf Version", i32 5}
!65 = !{i32 2, !"Debug Info Version", i32 3}
!66 = !{i32 1, !"wchar_size", i32 4}
!67 = !{i32 8, !"PIC Level", i32 2}
!68 = !{i32 7, !"PIE Level", i32 2}
!69 = !{i32 7, !"uwtable", i32 2}
!70 = !{i32 7, !"frame-pointer", i32 2}
!71 = !{!"Homebrew clang version 19.1.7"}
!72 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 11, type: !73, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !75)
!73 = !DISubroutineType(types: !74)
!74 = !{!35, !35}
!75 = !{}
!76 = !DILocalVariable(name: "arg", arg: 1, scope: !72, file: !3, line: 11, type: !35)
!77 = !DILocation(line: 11, column: 22, scope: !72)
!78 = !DILocation(line: 13, column: 2, scope: !72)
!79 = !DILocation(line: 14, column: 7, scope: !72)
!80 = !DILocation(line: 14, column: 5, scope: !72)
!81 = !DILocation(line: 15, column: 2, scope: !72)
!82 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 18, type: !73, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !75)
!83 = !DILocalVariable(name: "arg", arg: 1, scope: !82, file: !3, line: 18, type: !35)
!84 = !DILocation(line: 18, column: 22, scope: !82)
!85 = !DILocation(line: 20, column: 2, scope: !82)
!86 = !DILocation(line: 21, column: 2, scope: !82)
!87 = !DILocation(line: 22, column: 7, scope: !82)
!88 = !DILocation(line: 22, column: 5, scope: !82)
!89 = !DILocation(line: 23, column: 2, scope: !82)
!90 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 26, type: !91, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !75)
!91 = !DISubroutineType(types: !92)
!92 = !{!34}
!93 = !DILocalVariable(name: "t1", scope: !90, file: !3, line: 28, type: !94)
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !95, line: 31, baseType: !96)
!95 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !97, line: 118, baseType: !98)
!97 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!98 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64)
!99 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !97, line: 103, size: 65536, elements: !100)
!100 = !{!101, !102, !112}
!101 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !99, file: !97, line: 104, baseType: !33, size: 64)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !99, file: !97, line: 105, baseType: !103, size: 64, offset: 64)
!103 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !104, size: 64)
!104 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !97, line: 57, size: 192, elements: !105)
!105 = !{!106, !110, !111}
!106 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !104, file: !97, line: 58, baseType: !107, size: 64)
!107 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !108, size: 64)
!108 = !DISubroutineType(types: !109)
!109 = !{null, !35}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !104, file: !97, line: 59, baseType: !35, size: 64, offset: 64)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !104, file: !97, line: 60, baseType: !103, size: 64, offset: 128)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !99, file: !97, line: 106, baseType: !113, size: 65408, offset: 128)
!113 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 65408, elements: !114)
!114 = !{!115}
!115 = !DISubrange(count: 8176)
!116 = !DILocation(line: 28, column: 15, scope: !90)
!117 = !DILocalVariable(name: "t2", scope: !90, file: !3, line: 28, type: !94)
!118 = !DILocation(line: 28, column: 19, scope: !90)
!119 = !DILocation(line: 30, column: 5, scope: !90)
!120 = !DILocation(line: 31, column: 5, scope: !90)
!121 = !DILocation(line: 33, column: 18, scope: !90)
!122 = !DILocation(line: 33, column: 5, scope: !90)
!123 = !DILocation(line: 34, column: 18, scope: !90)
!124 = !DILocation(line: 34, column: 5, scope: !90)
!125 = !DILocation(line: 36, column: 5, scope: !90)
!126 = !DILocation(line: 0, scope: !90)
!127 = !DILocation(line: 38, column: 5, scope: !90)
