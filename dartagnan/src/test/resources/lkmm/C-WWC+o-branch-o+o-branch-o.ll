; ModuleID = 'benchmarks/lkmm/C-WWC+o-branch-o+o-branch-o.c'
source_filename = "benchmarks/lkmm/C-WWC+o-branch-o+o-branch-o.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.atomic_t = type { i32 }

@x = global %struct.atomic_t zeroinitializer, align 4, !dbg !0
@r1_0 = global i32 0, align 4, !dbg !52
@r3_0 = global i32 0, align 4, !dbg !54
@y = global %struct.atomic_t zeroinitializer, align 4, !dbg !46
@r2_1 = global i32 0, align 4, !dbg !56
@r4_1 = global i32 0, align 4, !dbg !58
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@.str = private unnamed_addr constant [30 x i8] c"C-WWC+o-branch-o+o-branch-o.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [50 x i8] c"!(r1_0 == 2 && r2_1 == 1 && atomic_read(&x) == 2)\00", align 1, !dbg !41

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_1(ptr noundef %0) #0 !dbg !67 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !71, !DIExpression(), !72)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !73
  %4 = trunc i64 %3 to i32, !dbg !73
  store i32 %4, ptr @r1_0, align 4, !dbg !74
  %5 = load i32, ptr @r1_0, align 4, !dbg !75
  %6 = icmp ne i32 %5, 0, !dbg !76
  %7 = zext i1 %6 to i32, !dbg !76
  store i32 %7, ptr @r3_0, align 4, !dbg !77
  %8 = load i32, ptr @r3_0, align 4, !dbg !78
  %9 = icmp ne i32 %8, 0, !dbg !78
  br i1 %9, label %10, label %11, !dbg !80

10:                                               ; preds = %1
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !81
  br label %11, !dbg !83

11:                                               ; preds = %10, %1
  ret ptr null, !dbg !84
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_2(ptr noundef %0) #0 !dbg !85 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !86, !DIExpression(), !87)
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !88
  %4 = trunc i64 %3 to i32, !dbg !88
  store i32 %4, ptr @r2_1, align 4, !dbg !89
  %5 = load i32, ptr @r2_1, align 4, !dbg !90
  %6 = icmp ne i32 %5, 0, !dbg !91
  %7 = zext i1 %6 to i32, !dbg !91
  store i32 %7, ptr @r4_1, align 4, !dbg !92
  %8 = load i32, ptr @r4_1, align 4, !dbg !93
  %9 = icmp ne i32 %8, 0, !dbg !93
  br i1 %9, label %10, label %11, !dbg !95

10:                                               ; preds = %1
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !96
  br label %11, !dbg !98

11:                                               ; preds = %10, %1
  ret ptr null, !dbg !99
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_3(ptr noundef %0) #0 !dbg !100 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !101, !DIExpression(), !102)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !103
  ret ptr null, !dbg !104
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !105 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !108, !DIExpression(), !132)
    #dbg_declare(ptr %3, !133, !DIExpression(), !134)
    #dbg_declare(ptr %4, !135, !DIExpression(), !136)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !137
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !138
  %7 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @thread_3, ptr noundef null), !dbg !139
  %8 = load ptr, ptr %2, align 8, !dbg !140
  %9 = call i32 @"\01_pthread_join"(ptr noundef %8, ptr noundef null), !dbg !141
  %10 = load ptr, ptr %3, align 8, !dbg !142
  %11 = call i32 @"\01_pthread_join"(ptr noundef %10, ptr noundef null), !dbg !143
  %12 = load ptr, ptr %4, align 8, !dbg !144
  %13 = call i32 @"\01_pthread_join"(ptr noundef %12, ptr noundef null), !dbg !145
  %14 = load i32, ptr @r1_0, align 4, !dbg !146
  %15 = icmp eq i32 %14, 2, !dbg !146
  br i1 %15, label %16, label %23, !dbg !146

16:                                               ; preds = %0
  %17 = load i32, ptr @r2_1, align 4, !dbg !146
  %18 = icmp eq i32 %17, 1, !dbg !146
  br i1 %18, label %19, label %23, !dbg !146

19:                                               ; preds = %16
  %20 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !146
  %21 = trunc i64 %20 to i32, !dbg !146
  %22 = icmp eq i32 %21, 2, !dbg !146
  br label %23

23:                                               ; preds = %19, %16, %0
  %24 = phi i1 [ false, %16 ], [ false, %0 ], [ %22, %19 ], !dbg !147
  %25 = xor i1 %24, true, !dbg !146
  %26 = xor i1 %25, true, !dbg !146
  %27 = zext i1 %26 to i32, !dbg !146
  %28 = sext i32 %27 to i64, !dbg !146
  %29 = icmp ne i64 %28, 0, !dbg !146
  br i1 %29, label %30, label %32, !dbg !146

30:                                               ; preds = %23
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 53, ptr noundef @.str.1) #3, !dbg !146
  unreachable, !dbg !146

31:                                               ; No predecessors!
  br label %33, !dbg !146

32:                                               ; preds = %23
  br label %33, !dbg !146

33:                                               ; preds = %32, %31
  ret i32 0, !dbg !148
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
!llvm.module.flags = !{!60, !61, !62, !63, !64, !65}
!llvm.ident = !{!66}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !48, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/lkmm/C-WWC+o-branch-o+o-branch-o.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "16822ca6ae1b393a6d3981b1314a6e62")
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
!23 = !{!24, !25, !27}
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !26)
!26 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!28 = !{!29, !36, !41, !0, !46, !52, !54, !56, !58}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 53, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 40, elements: !34)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!33 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!34 = !{!35}
!35 = !DISubrange(count: 5)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 53, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 240, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 30)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !3, line: 53, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 400, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 50)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !48, isLocal: false, isDefinition: true)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 109, baseType: !49)
!49 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 107, size: 32, elements: !50)
!50 = !{!51}
!51 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !49, file: !6, line: 108, baseType: !24, size: 32)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "r1_0", scope: !2, file: !3, line: 9, type: !24, isLocal: false, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "r3_0", scope: !2, file: !3, line: 10, type: !24, isLocal: false, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "r2_1", scope: !2, file: !3, line: 12, type: !24, isLocal: false, isDefinition: true)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "r4_1", scope: !2, file: !3, line: 13, type: !24, isLocal: false, isDefinition: true)
!60 = !{i32 7, !"Dwarf Version", i32 5}
!61 = !{i32 2, !"Debug Info Version", i32 3}
!62 = !{i32 1, !"wchar_size", i32 4}
!63 = !{i32 8, !"PIC Level", i32 2}
!64 = !{i32 7, !"uwtable", i32 1}
!65 = !{i32 7, !"frame-pointer", i32 1}
!66 = !{!"Homebrew clang version 19.1.7"}
!67 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 15, type: !68, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !70)
!68 = !DISubroutineType(types: !69)
!69 = !{!27, !27}
!70 = !{}
!71 = !DILocalVariable(name: "unused", arg: 1, scope: !67, file: !3, line: 15, type: !27)
!72 = !DILocation(line: 15, column: 22, scope: !67)
!73 = !DILocation(line: 17, column: 9, scope: !67)
!74 = !DILocation(line: 17, column: 7, scope: !67)
!75 = !DILocation(line: 18, column: 10, scope: !67)
!76 = !DILocation(line: 18, column: 15, scope: !67)
!77 = !DILocation(line: 18, column: 7, scope: !67)
!78 = !DILocation(line: 19, column: 6, scope: !79)
!79 = distinct !DILexicalBlock(scope: !67, file: !3, line: 19, column: 6)
!80 = !DILocation(line: 19, column: 6, scope: !67)
!81 = !DILocation(line: 20, column: 3, scope: !82)
!82 = distinct !DILexicalBlock(scope: !79, file: !3, line: 19, column: 12)
!83 = !DILocation(line: 21, column: 2, scope: !82)
!84 = !DILocation(line: 22, column: 5, scope: !67)
!85 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 25, type: !68, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !70)
!86 = !DILocalVariable(name: "unused", arg: 1, scope: !85, file: !3, line: 25, type: !27)
!87 = !DILocation(line: 25, column: 22, scope: !85)
!88 = !DILocation(line: 27, column: 9, scope: !85)
!89 = !DILocation(line: 27, column: 7, scope: !85)
!90 = !DILocation(line: 28, column: 10, scope: !85)
!91 = !DILocation(line: 28, column: 15, scope: !85)
!92 = !DILocation(line: 28, column: 7, scope: !85)
!93 = !DILocation(line: 29, column: 6, scope: !94)
!94 = distinct !DILexicalBlock(scope: !85, file: !3, line: 29, column: 6)
!95 = !DILocation(line: 29, column: 6, scope: !85)
!96 = !DILocation(line: 30, column: 3, scope: !97)
!97 = distinct !DILexicalBlock(scope: !94, file: !3, line: 29, column: 12)
!98 = !DILocation(line: 31, column: 2, scope: !97)
!99 = !DILocation(line: 32, column: 5, scope: !85)
!100 = distinct !DISubprogram(name: "thread_3", scope: !3, file: !3, line: 35, type: !68, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !70)
!101 = !DILocalVariable(name: "unused", arg: 1, scope: !100, file: !3, line: 35, type: !27)
!102 = !DILocation(line: 35, column: 22, scope: !100)
!103 = !DILocation(line: 37, column: 2, scope: !100)
!104 = !DILocation(line: 38, column: 5, scope: !100)
!105 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 41, type: !106, scopeLine: 42, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !70)
!106 = !DISubroutineType(types: !107)
!107 = !{!24}
!108 = !DILocalVariable(name: "t1", scope: !105, file: !3, line: 43, type: !109)
!109 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !110, line: 31, baseType: !111)
!110 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!111 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !112, line: 118, baseType: !113)
!112 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!114 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !112, line: 103, size: 65536, elements: !115)
!115 = !{!116, !118, !128}
!116 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !114, file: !112, line: 104, baseType: !117, size: 64)
!117 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !114, file: !112, line: 105, baseType: !119, size: 64, offset: 64)
!119 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !120, size: 64)
!120 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !112, line: 57, size: 192, elements: !121)
!121 = !{!122, !126, !127}
!122 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !120, file: !112, line: 58, baseType: !123, size: 64)
!123 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !124, size: 64)
!124 = !DISubroutineType(types: !125)
!125 = !{null, !27}
!126 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !120, file: !112, line: 59, baseType: !27, size: 64, offset: 64)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !120, file: !112, line: 60, baseType: !119, size: 64, offset: 128)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !114, file: !112, line: 106, baseType: !129, size: 65408, offset: 128)
!129 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !130)
!130 = !{!131}
!131 = !DISubrange(count: 8176)
!132 = !DILocation(line: 43, column: 12, scope: !105)
!133 = !DILocalVariable(name: "t2", scope: !105, file: !3, line: 43, type: !109)
!134 = !DILocation(line: 43, column: 16, scope: !105)
!135 = !DILocalVariable(name: "t3", scope: !105, file: !3, line: 43, type: !109)
!136 = !DILocation(line: 43, column: 20, scope: !105)
!137 = !DILocation(line: 45, column: 2, scope: !105)
!138 = !DILocation(line: 46, column: 2, scope: !105)
!139 = !DILocation(line: 47, column: 2, scope: !105)
!140 = !DILocation(line: 49, column: 15, scope: !105)
!141 = !DILocation(line: 49, column: 2, scope: !105)
!142 = !DILocation(line: 50, column: 15, scope: !105)
!143 = !DILocation(line: 50, column: 2, scope: !105)
!144 = !DILocation(line: 51, column: 15, scope: !105)
!145 = !DILocation(line: 51, column: 2, scope: !105)
!146 = !DILocation(line: 53, column: 2, scope: !105)
!147 = !DILocation(line: 0, scope: !105)
!148 = !DILocation(line: 55, column: 2, scope: !105)
