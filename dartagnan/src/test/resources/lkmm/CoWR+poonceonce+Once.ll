; ModuleID = 'benchmarks/lkmm/CoWR+poonceonce+Once.c'
source_filename = "benchmarks/lkmm/CoWR+poonceonce+Once.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@x = global i32 0, align 4, !dbg !0
@r0 = global i32 0, align 4, !dbg !46
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@.str = private unnamed_addr constant [23 x i8] c"CoWR+poonceonce+Once.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [32 x i8] c"!(READ_ONCE(x) == 1 && r0 == 2)\00", align 1, !dbg !41

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_1(ptr noundef %0) #0 !dbg !55 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !59, !DIExpression(), !60)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !61
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !62
  %4 = trunc i64 %3 to i32, !dbg !62
  store i32 %4, ptr @r0, align 4, !dbg !63
  ret ptr null, !dbg !64
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_2(ptr noundef %0) #0 !dbg !65 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !66, !DIExpression(), !67)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !68
  ret ptr null, !dbg !69
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !70 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !73, !DIExpression(), !97)
    #dbg_declare(ptr %3, !98, !DIExpression(), !99)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !100
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !101
  %6 = load ptr, ptr %2, align 8, !dbg !102
  %7 = call i32 @"\01_pthread_join"(ptr noundef %6, ptr noundef null), !dbg !103
  %8 = load ptr, ptr %3, align 8, !dbg !104
  %9 = call i32 @"\01_pthread_join"(ptr noundef %8, ptr noundef null), !dbg !105
  %10 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !106
  %11 = trunc i64 %10 to i32, !dbg !106
  %12 = icmp eq i32 %11, 1, !dbg !106
  br i1 %12, label %13, label %16, !dbg !106

13:                                               ; preds = %0
  %14 = load i32, ptr @r0, align 4, !dbg !106
  %15 = icmp eq i32 %14, 2, !dbg !106
  br label %16

16:                                               ; preds = %13, %0
  %17 = phi i1 [ false, %0 ], [ %15, %13 ], !dbg !107
  %18 = xor i1 %17, true, !dbg !106
  %19 = xor i1 %18, true, !dbg !106
  %20 = zext i1 %19 to i32, !dbg !106
  %21 = sext i32 %20 to i64, !dbg !106
  %22 = icmp ne i64 %21, 0, !dbg !106
  br i1 %22, label %23, label %25, !dbg !106

23:                                               ; preds = %16
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 32, ptr noundef @.str.1) #3, !dbg !106
  unreachable, !dbg !106

24:                                               ; No predecessors!
  br label %26, !dbg !106

25:                                               ; preds = %16
  br label %26, !dbg !106

26:                                               ; preds = %25, %24
  ret i32 0, !dbg !108
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
!llvm.module.flags = !{!48, !49, !50, !51, !52, !53}
!llvm.ident = !{!54}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !26, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
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
!52 = !{i32 7, !"uwtable", i32 1}
!53 = !{i32 7, !"frame-pointer", i32 1}
!54 = !{!"Homebrew clang version 19.1.7"}
!55 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 9, type: !56, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!56 = !DISubroutineType(types: !57)
!57 = !{!27, !27}
!58 = !{}
!59 = !DILocalVariable(name: "unused", arg: 1, scope: !55, file: !3, line: 9, type: !27)
!60 = !DILocation(line: 9, column: 22, scope: !55)
!61 = !DILocation(line: 11, column: 2, scope: !55)
!62 = !DILocation(line: 12, column: 7, scope: !55)
!63 = !DILocation(line: 12, column: 5, scope: !55)
!64 = !DILocation(line: 13, column: 2, scope: !55)
!65 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 16, type: !56, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!66 = !DILocalVariable(name: "unused", arg: 1, scope: !65, file: !3, line: 16, type: !27)
!67 = !DILocation(line: 16, column: 22, scope: !65)
!68 = !DILocation(line: 18, column: 2, scope: !65)
!69 = !DILocation(line: 19, column: 2, scope: !65)
!70 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 22, type: !71, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!71 = !DISubroutineType(types: !72)
!72 = !{!26}
!73 = !DILocalVariable(name: "t1", scope: !70, file: !3, line: 24, type: !74)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !75, line: 31, baseType: !76)
!75 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !77, line: 118, baseType: !78)
!77 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!78 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !79, size: 64)
!79 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !77, line: 103, size: 65536, elements: !80)
!80 = !{!81, !83, !93}
!81 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !79, file: !77, line: 104, baseType: !82, size: 64)
!82 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !79, file: !77, line: 105, baseType: !84, size: 64, offset: 64)
!84 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !85, size: 64)
!85 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !77, line: 57, size: 192, elements: !86)
!86 = !{!87, !91, !92}
!87 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !85, file: !77, line: 58, baseType: !88, size: 64)
!88 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !89, size: 64)
!89 = !DISubroutineType(types: !90)
!90 = !{null, !27}
!91 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !85, file: !77, line: 59, baseType: !27, size: 64, offset: 64)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !85, file: !77, line: 60, baseType: !84, size: 64, offset: 128)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !79, file: !77, line: 106, baseType: !94, size: 65408, offset: 128)
!94 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !95)
!95 = !{!96}
!96 = !DISubrange(count: 8176)
!97 = !DILocation(line: 24, column: 12, scope: !70)
!98 = !DILocalVariable(name: "t2", scope: !70, file: !3, line: 24, type: !74)
!99 = !DILocation(line: 24, column: 16, scope: !70)
!100 = !DILocation(line: 26, column: 2, scope: !70)
!101 = !DILocation(line: 27, column: 2, scope: !70)
!102 = !DILocation(line: 29, column: 15, scope: !70)
!103 = !DILocation(line: 29, column: 2, scope: !70)
!104 = !DILocation(line: 30, column: 15, scope: !70)
!105 = !DILocation(line: 30, column: 2, scope: !70)
!106 = !DILocation(line: 32, column: 2, scope: !70)
!107 = !DILocation(line: 0, scope: !70)
!108 = !DILocation(line: 34, column: 2, scope: !70)
