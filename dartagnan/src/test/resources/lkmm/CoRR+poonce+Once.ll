; ModuleID = 'benchmarks/lkmm/CoRR+poonce+Once.c'
source_filename = "benchmarks/lkmm/CoRR+poonce+Once.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@x = global i32 0, align 4, !dbg !0
@r0 = global i32 0, align 4, !dbg !46
@r1 = global i32 0, align 4, !dbg !48
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@.str = private unnamed_addr constant [19 x i8] c"CoRR+poonce+Once.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [22 x i8] c"!(r0 == 1 && r1 == 0)\00", align 1, !dbg !41

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_1(ptr noundef %0) #0 !dbg !57 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !61, !DIExpression(), !62)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !63
  ret ptr null, !dbg !64
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_2(ptr noundef %0) #0 !dbg !65 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !66, !DIExpression(), !67)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !68
  %4 = trunc i64 %3 to i32, !dbg !68
  store i32 %4, ptr @r0, align 4, !dbg !69
  %5 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !70
  %6 = trunc i64 %5 to i32, !dbg !70
  store i32 %6, ptr @r1, align 4, !dbg !71
  ret ptr null, !dbg !72
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !73 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !76, !DIExpression(), !100)
    #dbg_declare(ptr %3, !101, !DIExpression(), !102)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !103
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !104
  %6 = load ptr, ptr %2, align 8, !dbg !105
  %7 = call i32 @"\01_pthread_join"(ptr noundef %6, ptr noundef null), !dbg !106
  %8 = load ptr, ptr %3, align 8, !dbg !107
  %9 = call i32 @"\01_pthread_join"(ptr noundef %8, ptr noundef null), !dbg !108
  %10 = load i32, ptr @r0, align 4, !dbg !109
  %11 = icmp eq i32 %10, 1, !dbg !109
  br i1 %11, label %12, label %15, !dbg !109

12:                                               ; preds = %0
  %13 = load i32, ptr @r1, align 4, !dbg !109
  %14 = icmp eq i32 %13, 0, !dbg !109
  br label %15

15:                                               ; preds = %12, %0
  %16 = phi i1 [ false, %0 ], [ %14, %12 ], !dbg !110
  %17 = xor i1 %16, true, !dbg !109
  %18 = xor i1 %17, true, !dbg !109
  %19 = zext i1 %18 to i32, !dbg !109
  %20 = sext i32 %19 to i64, !dbg !109
  %21 = icmp ne i64 %20, 0, !dbg !109
  br i1 %21, label %22, label %24, !dbg !109

22:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 33, ptr noundef @.str.1) #3, !dbg !109
  unreachable, !dbg !109

23:                                               ; No predecessors!
  br label %25, !dbg !109

24:                                               ; preds = %15
  br label %25, !dbg !109

25:                                               ; preds = %24, %23
  ret i32 0, !dbg !111
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!50, !51, !52, !53, !54, !55}
!llvm.ident = !{!56}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !27, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/lkmm/CoRR+poonce+Once.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "973bb56baa7a0c404651e434a54de408")
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
!28 = !{!29, !36, !41, !0, !46, !48}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 33, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 40, elements: !34)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!33 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!34 = !{!35}
!35 = !DISubrange(count: 5)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 33, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 152, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 19)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !3, line: 33, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 176, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 22)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !3, line: 8, type: !27, isLocal: false, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "r1", scope: !2, file: !3, line: 8, type: !27, isLocal: false, isDefinition: true)
!50 = !{i32 7, !"Dwarf Version", i32 5}
!51 = !{i32 2, !"Debug Info Version", i32 3}
!52 = !{i32 1, !"wchar_size", i32 4}
!53 = !{i32 8, !"PIC Level", i32 2}
!54 = !{i32 7, !"uwtable", i32 1}
!55 = !{i32 7, !"frame-pointer", i32 1}
!56 = !{!"Homebrew clang version 19.1.7"}
!57 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 10, type: !58, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!58 = !DISubroutineType(types: !59)
!59 = !{!26, !26}
!60 = !{}
!61 = !DILocalVariable(name: "unused", arg: 1, scope: !57, file: !3, line: 10, type: !26)
!62 = !DILocation(line: 10, column: 22, scope: !57)
!63 = !DILocation(line: 12, column: 2, scope: !57)
!64 = !DILocation(line: 13, column: 2, scope: !57)
!65 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 16, type: !58, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!66 = !DILocalVariable(name: "unused", arg: 1, scope: !65, file: !3, line: 16, type: !26)
!67 = !DILocation(line: 16, column: 22, scope: !65)
!68 = !DILocation(line: 18, column: 7, scope: !65)
!69 = !DILocation(line: 18, column: 5, scope: !65)
!70 = !DILocation(line: 19, column: 7, scope: !65)
!71 = !DILocation(line: 19, column: 5, scope: !65)
!72 = !DILocation(line: 20, column: 2, scope: !65)
!73 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 23, type: !74, scopeLine: 24, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!74 = !DISubroutineType(types: !75)
!75 = !{!27}
!76 = !DILocalVariable(name: "t1", scope: !73, file: !3, line: 25, type: !77)
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !78, line: 31, baseType: !79)
!78 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !80, line: 118, baseType: !81)
!80 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !82, size: 64)
!82 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !80, line: 103, size: 65536, elements: !83)
!83 = !{!84, !86, !96}
!84 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !82, file: !80, line: 104, baseType: !85, size: 64)
!85 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !82, file: !80, line: 105, baseType: !87, size: 64, offset: 64)
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !80, line: 57, size: 192, elements: !89)
!89 = !{!90, !94, !95}
!90 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !88, file: !80, line: 58, baseType: !91, size: 64)
!91 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !92, size: 64)
!92 = !DISubroutineType(types: !93)
!93 = !{null, !26}
!94 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !88, file: !80, line: 59, baseType: !26, size: 64, offset: 64)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !88, file: !80, line: 60, baseType: !87, size: 64, offset: 128)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !82, file: !80, line: 106, baseType: !97, size: 65408, offset: 128)
!97 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !98)
!98 = !{!99}
!99 = !DISubrange(count: 8176)
!100 = !DILocation(line: 25, column: 12, scope: !73)
!101 = !DILocalVariable(name: "t2", scope: !73, file: !3, line: 25, type: !77)
!102 = !DILocation(line: 25, column: 16, scope: !73)
!103 = !DILocation(line: 27, column: 2, scope: !73)
!104 = !DILocation(line: 28, column: 2, scope: !73)
!105 = !DILocation(line: 30, column: 15, scope: !73)
!106 = !DILocation(line: 30, column: 2, scope: !73)
!107 = !DILocation(line: 31, column: 15, scope: !73)
!108 = !DILocation(line: 31, column: 2, scope: !73)
!109 = !DILocation(line: 33, column: 2, scope: !73)
!110 = !DILocation(line: 0, scope: !73)
!111 = !DILocation(line: 35, column: 2, scope: !73)
