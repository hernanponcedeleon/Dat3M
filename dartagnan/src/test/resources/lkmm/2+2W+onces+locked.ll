; ModuleID = 'benchmarks/lkmm/2+2W+onces+locked.c'
source_filename = "benchmarks/lkmm/2+2W+onces+locked.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.spinlock = type { i32 }

@lock_x = dso_local global %struct.spinlock zeroinitializer, align 4, !dbg !0
@x = dso_local global i32 0, align 4, !dbg !47
@lock_y = dso_local global %struct.spinlock zeroinitializer, align 4, !dbg !51
@y = dso_local global i32 0, align 4, !dbg !49
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !30
@.str = private unnamed_addr constant [20 x i8] c"2+2W+onces+locked.c\00", align 1, !dbg !37
@.str.1 = private unnamed_addr constant [38 x i8] c"!(READ_ONCE(x)==2 && READ_ONCE(y)==2)\00", align 1, !dbg !42

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !65 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !69, !DIExpression(), !70)
  %3 = call i32 @__LKMM_SPIN_LOCK(ptr noundef @lock_x), !dbg !71
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 2, i32 noundef 0), !dbg !72
  %4 = call i32 @__LKMM_SPIN_UNLOCK(ptr noundef @lock_x), !dbg !73
  %5 = call i32 @__LKMM_SPIN_LOCK(ptr noundef @lock_y), !dbg !74
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !75
  %6 = call i32 @__LKMM_SPIN_UNLOCK(ptr noundef @lock_y), !dbg !76
  ret ptr null, !dbg !77
}

declare i32 @__LKMM_SPIN_LOCK(ptr noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i32 @__LKMM_SPIN_UNLOCK(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !78 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !79, !DIExpression(), !80)
  %3 = call i32 @__LKMM_SPIN_LOCK(ptr noundef @lock_y), !dbg !81
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 2, i32 noundef 0), !dbg !82
  %4 = call i32 @__LKMM_SPIN_UNLOCK(ptr noundef @lock_y), !dbg !83
  %5 = call i32 @__LKMM_SPIN_LOCK(ptr noundef @lock_x), !dbg !84
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !85
  %6 = call i32 @__LKMM_SPIN_UNLOCK(ptr noundef @lock_x), !dbg !86
  ret ptr null, !dbg !87
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !88 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !91, !DIExpression(), !114)
    #dbg_declare(ptr %3, !115, !DIExpression(), !116)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !117
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !118
  %6 = load ptr, ptr %2, align 8, !dbg !119
  %7 = call i32 @_pthread_join(ptr noundef %6, ptr noundef null), !dbg !120
  %8 = load ptr, ptr %3, align 8, !dbg !121
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !122
  %10 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !123
  %11 = trunc i64 %10 to i32, !dbg !123
  %12 = icmp eq i32 %11, 2, !dbg !123
  br i1 %12, label %13, label %17, !dbg !123

13:                                               ; preds = %0
  %14 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 0), !dbg !123
  %15 = trunc i64 %14 to i32, !dbg !123
  %16 = icmp eq i32 %15, 2, !dbg !123
  br label %17

17:                                               ; preds = %13, %0
  %18 = phi i1 [ false, %0 ], [ %16, %13 ], !dbg !124
  %19 = xor i1 %18, true, !dbg !123
  %20 = xor i1 %19, true, !dbg !123
  %21 = zext i1 %20 to i32, !dbg !123
  %22 = sext i32 %21 to i64, !dbg !123
  %23 = icmp ne i64 %22, 0, !dbg !123
  br i1 %23, label %24, label %26, !dbg !123

24:                                               ; preds = %17
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 41, ptr noundef @.str.1) #3, !dbg !123
  unreachable, !dbg !123

25:                                               ; No predecessors!
  br label %27, !dbg !123

26:                                               ; preds = %17
  br label %27, !dbg !123

27:                                               ; preds = %26, %25
  ret i32 0, !dbg !125
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @_pthread_join(ptr noundef, ptr noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!57, !58, !59, !60, !61, !62, !63}
!llvm.ident = !{!64}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "lock_x", scope: !2, file: !3, line: 7, type: !53, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !22, globals: !29, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/2+2W+onces+locked.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "06899129241a51c8f91baae86bd7c164")
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
!22 = !{!23, !27, !28}
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 27, baseType: !24)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !25, line: 32, baseType: !26)
!25 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!26 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !{!30, !37, !42, !47, !49, !0, !51}
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 41, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 40, elements: !35)
!33 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!34 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!35 = !{!36}
!36 = !DISubrange(count: 5)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 41, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 160, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 20)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 41, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 304, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 38)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !28, isLocal: false, isDefinition: true)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 6, type: !28, isLocal: false, isDefinition: true)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(name: "lock_y", scope: !2, file: !3, line: 7, type: !53, isLocal: false, isDefinition: true)
!53 = !DIDerivedType(tag: DW_TAG_typedef, name: "spinlock_t", file: !6, line: 290, baseType: !54)
!54 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "spinlock", file: !6, line: 288, size: 32, elements: !55)
!55 = !{!56}
!56 = !DIDerivedType(tag: DW_TAG_member, name: "unused", scope: !54, file: !6, line: 289, baseType: !28, size: 32)
!57 = !{i32 7, !"Dwarf Version", i32 5}
!58 = !{i32 2, !"Debug Info Version", i32 3}
!59 = !{i32 1, !"wchar_size", i32 4}
!60 = !{i32 8, !"PIC Level", i32 2}
!61 = !{i32 7, !"PIE Level", i32 2}
!62 = !{i32 7, !"uwtable", i32 2}
!63 = !{i32 7, !"frame-pointer", i32 2}
!64 = !{!"Homebrew clang version 19.1.7"}
!65 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 9, type: !66, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!66 = !DISubroutineType(types: !67)
!67 = !{!27, !27}
!68 = !{}
!69 = !DILocalVariable(name: "arg", arg: 1, scope: !65, file: !3, line: 9, type: !27)
!70 = !DILocation(line: 9, column: 22, scope: !65)
!71 = !DILocation(line: 11, column: 2, scope: !65)
!72 = !DILocation(line: 12, column: 2, scope: !65)
!73 = !DILocation(line: 13, column: 2, scope: !65)
!74 = !DILocation(line: 14, column: 2, scope: !65)
!75 = !DILocation(line: 15, column: 2, scope: !65)
!76 = !DILocation(line: 16, column: 2, scope: !65)
!77 = !DILocation(line: 17, column: 2, scope: !65)
!78 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 20, type: !66, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!79 = !DILocalVariable(name: "arg", arg: 1, scope: !78, file: !3, line: 20, type: !27)
!80 = !DILocation(line: 20, column: 22, scope: !78)
!81 = !DILocation(line: 22, column: 2, scope: !78)
!82 = !DILocation(line: 23, column: 2, scope: !78)
!83 = !DILocation(line: 24, column: 2, scope: !78)
!84 = !DILocation(line: 25, column: 2, scope: !78)
!85 = !DILocation(line: 26, column: 2, scope: !78)
!86 = !DILocation(line: 27, column: 2, scope: !78)
!87 = !DILocation(line: 28, column: 2, scope: !78)
!88 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 31, type: !89, scopeLine: 32, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!89 = !DISubroutineType(types: !90)
!90 = !{!28}
!91 = !DILocalVariable(name: "t1", scope: !88, file: !3, line: 33, type: !92)
!92 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !93, line: 31, baseType: !94)
!93 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !95, line: 118, baseType: !96)
!95 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!96 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64)
!97 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !95, line: 103, size: 65536, elements: !98)
!98 = !{!99, !100, !110}
!99 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !97, file: !95, line: 104, baseType: !26, size: 64)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !97, file: !95, line: 105, baseType: !101, size: 64, offset: 64)
!101 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !102, size: 64)
!102 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !95, line: 57, size: 192, elements: !103)
!103 = !{!104, !108, !109}
!104 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !102, file: !95, line: 58, baseType: !105, size: 64)
!105 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !106, size: 64)
!106 = !DISubroutineType(types: !107)
!107 = !{null, !27}
!108 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !102, file: !95, line: 59, baseType: !27, size: 64, offset: 64)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !102, file: !95, line: 60, baseType: !101, size: 64, offset: 128)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !97, file: !95, line: 106, baseType: !111, size: 65408, offset: 128)
!111 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 65408, elements: !112)
!112 = !{!113}
!113 = !DISubrange(count: 8176)
!114 = !DILocation(line: 33, column: 12, scope: !88)
!115 = !DILocalVariable(name: "t2", scope: !88, file: !3, line: 33, type: !92)
!116 = !DILocation(line: 33, column: 16, scope: !88)
!117 = !DILocation(line: 35, column: 2, scope: !88)
!118 = !DILocation(line: 36, column: 2, scope: !88)
!119 = !DILocation(line: 38, column: 15, scope: !88)
!120 = !DILocation(line: 38, column: 2, scope: !88)
!121 = !DILocation(line: 39, column: 15, scope: !88)
!122 = !DILocation(line: 39, column: 2, scope: !88)
!123 = !DILocation(line: 41, column: 2, scope: !88)
!124 = !DILocation(line: 0, scope: !88)
!125 = !DILocation(line: 43, column: 2, scope: !88)
