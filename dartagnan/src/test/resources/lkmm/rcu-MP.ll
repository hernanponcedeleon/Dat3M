; ModuleID = 'benchmarks/lkmm/rcu-MP.c'
source_filename = "benchmarks/lkmm/rcu-MP.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@x = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !46
@__func__.P1 = private unnamed_addr constant [3 x i8] c"P1\00", align 1, !dbg !29
@.str = private unnamed_addr constant [9 x i8] c"rcu-MP.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [24 x i8] c"!(r_y == 1 && r_x == 0)\00", align 1, !dbg !41

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @P0(ptr noundef %0) #0 !dbg !55 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !59, !DIExpression(), !60)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !61
  call void @__LKMM_fence(i32 noundef 9), !dbg !62
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !63
  ret ptr null, !dbg !64
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_fence(i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @P1(ptr noundef %0) #0 !dbg !65 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !66, !DIExpression(), !67)
  call void @__LKMM_fence(i32 noundef 7), !dbg !68
    #dbg_declare(ptr %3, !69, !DIExpression(), !70)
  %5 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !71
  %6 = trunc i64 %5 to i32, !dbg !71
  store i32 %6, ptr %3, align 4, !dbg !70
    #dbg_declare(ptr %4, !72, !DIExpression(), !73)
  %7 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !74
  %8 = trunc i64 %7 to i32, !dbg !74
  store i32 %8, ptr %4, align 4, !dbg !73
  call void @__LKMM_fence(i32 noundef 8), !dbg !75
  %9 = load i32, ptr %3, align 4, !dbg !76
  %10 = icmp eq i32 %9, 1, !dbg !76
  br i1 %10, label %11, label %14, !dbg !76

11:                                               ; preds = %1
  %12 = load i32, ptr %4, align 4, !dbg !76
  %13 = icmp eq i32 %12, 0, !dbg !76
  br label %14

14:                                               ; preds = %11, %1
  %15 = phi i1 [ false, %1 ], [ %13, %11 ], !dbg !77
  %16 = xor i1 %15, true, !dbg !76
  %17 = xor i1 %16, true, !dbg !76
  %18 = zext i1 %17 to i32, !dbg !76
  %19 = sext i32 %18 to i64, !dbg !76
  %20 = icmp ne i64 %19, 0, !dbg !76
  br i1 %20, label %21, label %23, !dbg !76

21:                                               ; preds = %14
  call void @__assert_rtn(ptr noundef @__func__.P1, ptr noundef @.str, i32 noundef 24, ptr noundef @.str.1) #3, !dbg !76
  unreachable, !dbg !76

22:                                               ; No predecessors!
  br label %24, !dbg !76

23:                                               ; preds = %14
  br label %24, !dbg !76

24:                                               ; preds = %23, %22
  ret ptr null, !dbg !78
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !79 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !82, !DIExpression(), !106)
    #dbg_declare(ptr %3, !107, !DIExpression(), !108)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @P0, ptr noundef null), !dbg !109
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @P1, ptr noundef null), !dbg !110
  ret i32 0, !dbg !111
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!48, !49, !50, !51, !52, !53}
!llvm.ident = !{!54}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 7, type: !27, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/lkmm/rcu-MP.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "ee7d341ab9b618f6b5d9b52d690bd6c4")
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
!28 = !{!29, !36, !41, !0, !46}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 24, elements: !34)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!33 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!34 = !{!35}
!35 = !DISubrange(count: 3)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 72, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 9)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 192, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 24)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 8, type: !27, isLocal: false, isDefinition: true)
!48 = !{i32 7, !"Dwarf Version", i32 5}
!49 = !{i32 2, !"Debug Info Version", i32 3}
!50 = !{i32 1, !"wchar_size", i32 4}
!51 = !{i32 8, !"PIC Level", i32 2}
!52 = !{i32 7, !"uwtable", i32 1}
!53 = !{i32 7, !"frame-pointer", i32 1}
!54 = !{!"Homebrew clang version 19.1.7"}
!55 = distinct !DISubprogram(name: "P0", scope: !3, file: !3, line: 10, type: !56, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!56 = !DISubroutineType(types: !57)
!57 = !{!26, !26}
!58 = !{}
!59 = !DILocalVariable(name: "arg", arg: 1, scope: !55, file: !3, line: 10, type: !26)
!60 = !DILocation(line: 10, column: 16, scope: !55)
!61 = !DILocation(line: 12, column: 2, scope: !55)
!62 = !DILocation(line: 13, column: 2, scope: !55)
!63 = !DILocation(line: 14, column: 2, scope: !55)
!64 = !DILocation(line: 15, column: 2, scope: !55)
!65 = distinct !DISubprogram(name: "P1", scope: !3, file: !3, line: 18, type: !56, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!66 = !DILocalVariable(name: "arg", arg: 1, scope: !65, file: !3, line: 18, type: !26)
!67 = !DILocation(line: 18, column: 16, scope: !65)
!68 = !DILocation(line: 20, column: 2, scope: !65)
!69 = !DILocalVariable(name: "r_y", scope: !65, file: !3, line: 21, type: !27)
!70 = !DILocation(line: 21, column: 6, scope: !65)
!71 = !DILocation(line: 21, column: 12, scope: !65)
!72 = !DILocalVariable(name: "r_x", scope: !65, file: !3, line: 22, type: !27)
!73 = !DILocation(line: 22, column: 6, scope: !65)
!74 = !DILocation(line: 22, column: 12, scope: !65)
!75 = !DILocation(line: 23, column: 2, scope: !65)
!76 = !DILocation(line: 24, column: 5, scope: !65)
!77 = !DILocation(line: 0, scope: !65)
!78 = !DILocation(line: 25, column: 2, scope: !65)
!79 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 29, type: !80, scopeLine: 30, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!80 = !DISubroutineType(types: !81)
!81 = !{!27}
!82 = !DILocalVariable(name: "t1", scope: !79, file: !3, line: 34, type: !83)
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
!99 = !{null, !26}
!100 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !94, file: !86, line: 59, baseType: !26, size: 64, offset: 64)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !94, file: !86, line: 60, baseType: !93, size: 64, offset: 128)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !88, file: !86, line: 106, baseType: !103, size: 65408, offset: 128)
!103 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !104)
!104 = !{!105}
!105 = !DISubrange(count: 8176)
!106 = !DILocation(line: 34, column: 12, scope: !79)
!107 = !DILocalVariable(name: "t2", scope: !79, file: !3, line: 34, type: !83)
!108 = !DILocation(line: 34, column: 16, scope: !79)
!109 = !DILocation(line: 36, column: 2, scope: !79)
!110 = !DILocation(line: 37, column: 2, scope: !79)
!111 = !DILocation(line: 39, column: 2, scope: !79)
