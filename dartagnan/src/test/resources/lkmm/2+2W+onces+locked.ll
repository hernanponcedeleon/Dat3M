; ModuleID = 'benchmarks/lkmm/2+2W+onces+locked.c'
source_filename = "benchmarks/lkmm/2+2W+onces+locked.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.spinlock = type { i32 }

@lock_x = global %struct.spinlock zeroinitializer, align 4, !dbg !0
@x = global i32 0, align 4, !dbg !46
@lock_y = global %struct.spinlock zeroinitializer, align 4, !dbg !50
@y = global i32 0, align 4, !dbg !48
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@.str = private unnamed_addr constant [20 x i8] c"2+2W+onces+locked.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [38 x i8] c"!(READ_ONCE(x)==2 && READ_ONCE(y)==2)\00", align 1, !dbg !41

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_1(ptr noundef %0) #0 !dbg !63 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !67, !DIExpression(), !68)
  %3 = call i32 @__LKMM_SPIN_LOCK(ptr noundef @lock_x), !dbg !69
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !70
  %4 = call i32 @__LKMM_SPIN_UNLOCK(ptr noundef @lock_x), !dbg !71
  %5 = call i32 @__LKMM_SPIN_LOCK(ptr noundef @lock_y), !dbg !72
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !73
  %6 = call i32 @__LKMM_SPIN_UNLOCK(ptr noundef @lock_y), !dbg !74
  ret ptr null, !dbg !75
}

declare i32 @__LKMM_SPIN_LOCK(ptr noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i32 @__LKMM_SPIN_UNLOCK(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_2(ptr noundef %0) #0 !dbg !76 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !77, !DIExpression(), !78)
  %3 = call i32 @__LKMM_SPIN_LOCK(ptr noundef @lock_y), !dbg !79
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !80
  %4 = call i32 @__LKMM_SPIN_UNLOCK(ptr noundef @lock_y), !dbg !81
  %5 = call i32 @__LKMM_SPIN_LOCK(ptr noundef @lock_x), !dbg !82
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !83
  %6 = call i32 @__LKMM_SPIN_UNLOCK(ptr noundef @lock_x), !dbg !84
  ret ptr null, !dbg !85
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !86 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !89, !DIExpression(), !113)
    #dbg_declare(ptr %3, !114, !DIExpression(), !115)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !116
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !117
  %6 = load ptr, ptr %2, align 8, !dbg !118
  %7 = call i32 @"\01_pthread_join"(ptr noundef %6, ptr noundef null), !dbg !119
  %8 = load ptr, ptr %3, align 8, !dbg !120
  %9 = call i32 @"\01_pthread_join"(ptr noundef %8, ptr noundef null), !dbg !121
  %10 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !122
  %11 = trunc i64 %10 to i32, !dbg !122
  %12 = icmp eq i32 %11, 2, !dbg !122
  br i1 %12, label %13, label %17, !dbg !122

13:                                               ; preds = %0
  %14 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !122
  %15 = trunc i64 %14 to i32, !dbg !122
  %16 = icmp eq i32 %15, 2, !dbg !122
  br label %17

17:                                               ; preds = %13, %0
  %18 = phi i1 [ false, %0 ], [ %16, %13 ], !dbg !123
  %19 = xor i1 %18, true, !dbg !122
  %20 = xor i1 %19, true, !dbg !122
  %21 = zext i1 %20 to i32, !dbg !122
  %22 = sext i32 %21 to i64, !dbg !122
  %23 = icmp ne i64 %22, 0, !dbg !122
  br i1 %23, label %24, label %26, !dbg !122

24:                                               ; preds = %17
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 41, ptr noundef @.str.1) #3, !dbg !122
  unreachable, !dbg !122

25:                                               ; No predecessors!
  br label %27, !dbg !122

26:                                               ; preds = %17
  br label %27, !dbg !122

27:                                               ; preds = %26, %25
  ret i32 0, !dbg !124
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!56, !57, !58, !59, !60, !61}
!llvm.ident = !{!62}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "lock_x", scope: !2, file: !3, line: 7, type: !52, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
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
!60 = !{i32 7, !"uwtable", i32 1}
!61 = !{i32 7, !"frame-pointer", i32 1}
!62 = !{!"Homebrew clang version 19.1.7"}
!63 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 9, type: !64, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !66)
!64 = !DISubroutineType(types: !65)
!65 = !{!26, !26}
!66 = !{}
!67 = !DILocalVariable(name: "arg", arg: 1, scope: !63, file: !3, line: 9, type: !26)
!68 = !DILocation(line: 9, column: 22, scope: !63)
!69 = !DILocation(line: 11, column: 2, scope: !63)
!70 = !DILocation(line: 12, column: 2, scope: !63)
!71 = !DILocation(line: 13, column: 2, scope: !63)
!72 = !DILocation(line: 14, column: 2, scope: !63)
!73 = !DILocation(line: 15, column: 2, scope: !63)
!74 = !DILocation(line: 16, column: 2, scope: !63)
!75 = !DILocation(line: 17, column: 2, scope: !63)
!76 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 20, type: !64, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !66)
!77 = !DILocalVariable(name: "arg", arg: 1, scope: !76, file: !3, line: 20, type: !26)
!78 = !DILocation(line: 20, column: 22, scope: !76)
!79 = !DILocation(line: 22, column: 2, scope: !76)
!80 = !DILocation(line: 23, column: 2, scope: !76)
!81 = !DILocation(line: 24, column: 2, scope: !76)
!82 = !DILocation(line: 25, column: 2, scope: !76)
!83 = !DILocation(line: 26, column: 2, scope: !76)
!84 = !DILocation(line: 27, column: 2, scope: !76)
!85 = !DILocation(line: 28, column: 2, scope: !76)
!86 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 31, type: !87, scopeLine: 32, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !66)
!87 = !DISubroutineType(types: !88)
!88 = !{!27}
!89 = !DILocalVariable(name: "t1", scope: !86, file: !3, line: 33, type: !90)
!90 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !91, line: 31, baseType: !92)
!91 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!92 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !93, line: 118, baseType: !94)
!93 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !95, size: 64)
!95 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !93, line: 103, size: 65536, elements: !96)
!96 = !{!97, !99, !109}
!97 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !95, file: !93, line: 104, baseType: !98, size: 64)
!98 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !95, file: !93, line: 105, baseType: !100, size: 64, offset: 64)
!100 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !101, size: 64)
!101 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !93, line: 57, size: 192, elements: !102)
!102 = !{!103, !107, !108}
!103 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !101, file: !93, line: 58, baseType: !104, size: 64)
!104 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !105, size: 64)
!105 = !DISubroutineType(types: !106)
!106 = !{null, !26}
!107 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !101, file: !93, line: 59, baseType: !26, size: 64, offset: 64)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !101, file: !93, line: 60, baseType: !100, size: 64, offset: 128)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !95, file: !93, line: 106, baseType: !110, size: 65408, offset: 128)
!110 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !111)
!111 = !{!112}
!112 = !DISubrange(count: 8176)
!113 = !DILocation(line: 33, column: 12, scope: !86)
!114 = !DILocalVariable(name: "t2", scope: !86, file: !3, line: 33, type: !90)
!115 = !DILocation(line: 33, column: 16, scope: !86)
!116 = !DILocation(line: 35, column: 2, scope: !86)
!117 = !DILocation(line: 36, column: 2, scope: !86)
!118 = !DILocation(line: 38, column: 15, scope: !86)
!119 = !DILocation(line: 38, column: 2, scope: !86)
!120 = !DILocation(line: 39, column: 15, scope: !86)
!121 = !DILocation(line: 39, column: 2, scope: !86)
!122 = !DILocation(line: 41, column: 2, scope: !86)
!123 = !DILocation(line: 0, scope: !86)
!124 = !DILocation(line: 43, column: 2, scope: !86)
