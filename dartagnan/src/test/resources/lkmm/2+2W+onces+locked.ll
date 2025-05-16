; ModuleID = 'benchmarks/lkmm/2+2W+onces+locked.c'
source_filename = "benchmarks/lkmm/2+2W+onces+locked.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.spinlock = type { i32 }

@lock_x = dso_local global %struct.spinlock zeroinitializer, align 4, !dbg !0
@x = dso_local global i32 0, align 4, !dbg !46
@lock_y = dso_local global %struct.spinlock zeroinitializer, align 4, !dbg !50
@y = dso_local global i32 0, align 4, !dbg !48
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@.str = private unnamed_addr constant [20 x i8] c"2+2W+onces+locked.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [38 x i8] c"!(READ_ONCE(x)==2 && READ_ONCE(y)==2)\00", align 1, !dbg !41

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !64 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !68, !DIExpression(), !69)
  %3 = call i32 @__LKMM_SPIN_LOCK(ptr noundef @lock_x), !dbg !70
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !71
  %4 = call i32 @__LKMM_SPIN_UNLOCK(ptr noundef @lock_x), !dbg !72
  %5 = call i32 @__LKMM_SPIN_LOCK(ptr noundef @lock_y), !dbg !73
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !74
  %6 = call i32 @__LKMM_SPIN_UNLOCK(ptr noundef @lock_y), !dbg !75
  ret ptr null, !dbg !76
}

declare i32 @__LKMM_SPIN_LOCK(ptr noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i32 @__LKMM_SPIN_UNLOCK(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !77 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !78, !DIExpression(), !79)
  %3 = call i32 @__LKMM_SPIN_LOCK(ptr noundef @lock_y), !dbg !80
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !81
  %4 = call i32 @__LKMM_SPIN_UNLOCK(ptr noundef @lock_y), !dbg !82
  %5 = call i32 @__LKMM_SPIN_LOCK(ptr noundef @lock_x), !dbg !83
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !84
  %6 = call i32 @__LKMM_SPIN_UNLOCK(ptr noundef @lock_x), !dbg !85
  ret ptr null, !dbg !86
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !87 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !90, !DIExpression(), !114)
    #dbg_declare(ptr %3, !115, !DIExpression(), !116)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !117
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !118
  %6 = load ptr, ptr %2, align 8, !dbg !119
  %7 = call i32 @_pthread_join(ptr noundef %6, ptr noundef null), !dbg !120
  %8 = load ptr, ptr %3, align 8, !dbg !121
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !122
  %10 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !123
  %11 = trunc i64 %10 to i32, !dbg !123
  %12 = icmp eq i32 %11, 2, !dbg !123
  br i1 %12, label %13, label %17, !dbg !123

13:                                               ; preds = %0
  %14 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !123
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
!llvm.module.flags = !{!56, !57, !58, !59, !60, !61, !62}
!llvm.ident = !{!63}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "lock_x", scope: !2, file: !3, line: 7, type: !52, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/2+2W+onces+locked.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "06899129241a51c8f91baae86bd7c164")
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
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!27 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!28 = !{!29, !36, !41, !46, !48, !0, !50}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 41, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 40, elements: !34)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!33 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!34 = !{!35}
!35 = !DISubrange(count: 5)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 41, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 160, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 20)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !3, line: 41, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 304, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 38)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !27, isLocal: false, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 6, type: !27, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "lock_y", scope: !2, file: !3, line: 7, type: !52, isLocal: false, isDefinition: true)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "spinlock_t", file: !6, line: 291, baseType: !53)
!53 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "spinlock", file: !6, line: 289, size: 32, elements: !54)
!54 = !{!55}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "unused", scope: !53, file: !6, line: 290, baseType: !27, size: 32)
!56 = !{i32 7, !"Dwarf Version", i32 5}
!57 = !{i32 2, !"Debug Info Version", i32 3}
!58 = !{i32 1, !"wchar_size", i32 4}
!59 = !{i32 8, !"PIC Level", i32 2}
!60 = !{i32 7, !"PIE Level", i32 2}
!61 = !{i32 7, !"uwtable", i32 2}
!62 = !{i32 7, !"frame-pointer", i32 2}
!63 = !{!"Homebrew clang version 19.1.7"}
!64 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 9, type: !65, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!65 = !DISubroutineType(types: !66)
!66 = !{!26, !26}
!67 = !{}
!68 = !DILocalVariable(name: "arg", arg: 1, scope: !64, file: !3, line: 9, type: !26)
!69 = !DILocation(line: 9, column: 22, scope: !64)
!70 = !DILocation(line: 11, column: 2, scope: !64)
!71 = !DILocation(line: 12, column: 2, scope: !64)
!72 = !DILocation(line: 13, column: 2, scope: !64)
!73 = !DILocation(line: 14, column: 2, scope: !64)
!74 = !DILocation(line: 15, column: 2, scope: !64)
!75 = !DILocation(line: 16, column: 2, scope: !64)
!76 = !DILocation(line: 17, column: 2, scope: !64)
!77 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 20, type: !65, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!78 = !DILocalVariable(name: "arg", arg: 1, scope: !77, file: !3, line: 20, type: !26)
!79 = !DILocation(line: 20, column: 22, scope: !77)
!80 = !DILocation(line: 22, column: 2, scope: !77)
!81 = !DILocation(line: 23, column: 2, scope: !77)
!82 = !DILocation(line: 24, column: 2, scope: !77)
!83 = !DILocation(line: 25, column: 2, scope: !77)
!84 = !DILocation(line: 26, column: 2, scope: !77)
!85 = !DILocation(line: 27, column: 2, scope: !77)
!86 = !DILocation(line: 28, column: 2, scope: !77)
!87 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 31, type: !88, scopeLine: 32, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!88 = !DISubroutineType(types: !89)
!89 = !{!27}
!90 = !DILocalVariable(name: "t1", scope: !87, file: !3, line: 33, type: !91)
!91 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !92, line: 31, baseType: !93)
!92 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !94, line: 118, baseType: !95)
!94 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!95 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !96, size: 64)
!96 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !94, line: 103, size: 65536, elements: !97)
!97 = !{!98, !100, !110}
!98 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !96, file: !94, line: 104, baseType: !99, size: 64)
!99 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !96, file: !94, line: 105, baseType: !101, size: 64, offset: 64)
!101 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !102, size: 64)
!102 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !94, line: 57, size: 192, elements: !103)
!103 = !{!104, !108, !109}
!104 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !102, file: !94, line: 58, baseType: !105, size: 64)
!105 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !106, size: 64)
!106 = !DISubroutineType(types: !107)
!107 = !{null, !26}
!108 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !102, file: !94, line: 59, baseType: !26, size: 64, offset: 64)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !102, file: !94, line: 60, baseType: !101, size: 64, offset: 128)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !96, file: !94, line: 106, baseType: !111, size: 65408, offset: 128)
!111 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !112)
!112 = !{!113}
!113 = !DISubrange(count: 8176)
!114 = !DILocation(line: 33, column: 12, scope: !87)
!115 = !DILocalVariable(name: "t2", scope: !87, file: !3, line: 33, type: !91)
!116 = !DILocation(line: 33, column: 16, scope: !87)
!117 = !DILocation(line: 35, column: 2, scope: !87)
!118 = !DILocation(line: 36, column: 2, scope: !87)
!119 = !DILocation(line: 38, column: 15, scope: !87)
!120 = !DILocation(line: 38, column: 2, scope: !87)
!121 = !DILocation(line: 39, column: 15, scope: !87)
!122 = !DILocation(line: 39, column: 2, scope: !87)
!123 = !DILocation(line: 41, column: 2, scope: !87)
!124 = !DILocation(line: 0, scope: !87)
!125 = !DILocation(line: 43, column: 2, scope: !87)
