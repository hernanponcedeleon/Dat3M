; ModuleID = 'benchmarks/interrupts/lkmm_with_barrier_dec_barrier.c'
source_filename = "benchmarks/interrupts/lkmm_with_barrier_dec_barrier.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.A = type { i32, i32 }

@cnt = global i32 0, align 4, !dbg !0
@as = global [10 x %struct.A] zeroinitializer, align 4, !dbg !31
@h = global ptr null, align 8, !dbg !42

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !74 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !78, !DIExpression(), !79)
    #dbg_declare(ptr %3, !80, !DIExpression(), !81)
  %5 = load ptr, ptr %2, align 8, !dbg !82
  %6 = ptrtoint ptr %5 to i64, !dbg !83
  %7 = trunc i64 %6 to i32, !dbg !84
  store i32 %7, ptr %3, align 4, !dbg !81
    #dbg_declare(ptr %4, !85, !DIExpression(), !86)
  %8 = load i32, ptr @cnt, align 4, !dbg !87
  %9 = add nsw i32 %8, 1, !dbg !87
  store i32 %9, ptr @cnt, align 4, !dbg !87
  store i32 %8, ptr %4, align 4, !dbg !86
  call void @__LKMM_FENCE(i32 noundef 13), !dbg !88
  %10 = load i32, ptr %3, align 4, !dbg !89
  %11 = load i32, ptr %4, align 4, !dbg !90
  %12 = sext i32 %11 to i64, !dbg !91
  %13 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %12, !dbg !91
  %14 = getelementptr inbounds %struct.A, ptr %13, i32 0, i32 0, !dbg !92
  store volatile i32 %10, ptr %14, align 4, !dbg !93
  %15 = load i32, ptr %3, align 4, !dbg !94
  %16 = load i32, ptr %4, align 4, !dbg !95
  %17 = sext i32 %16 to i64, !dbg !96
  %18 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %17, !dbg !96
  %19 = getelementptr inbounds %struct.A, ptr %18, i32 0, i32 1, !dbg !97
  store volatile i32 %15, ptr %19, align 4, !dbg !98
  %20 = load i32, ptr %4, align 4, !dbg !99
  %21 = sext i32 %20 to i64, !dbg !100
  %22 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %21, !dbg !100
  %23 = getelementptr inbounds %struct.A, ptr %22, i32 0, i32 0, !dbg !101
  %24 = load volatile i32, ptr %23, align 4, !dbg !101
  %25 = load i32, ptr %4, align 4, !dbg !102
  %26 = sext i32 %25 to i64, !dbg !103
  %27 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %26, !dbg !103
  %28 = getelementptr inbounds %struct.A, ptr %27, i32 0, i32 1, !dbg !104
  %29 = load volatile i32, ptr %28, align 4, !dbg !104
  %30 = icmp eq i32 %24, %29, !dbg !105
  %31 = zext i1 %30 to i32, !dbg !105
  call void @__VERIFIER_assert(i32 noundef %31), !dbg !106
  call void @__LKMM_FENCE(i32 noundef 13), !dbg !107
  %32 = load i32, ptr @cnt, align 4, !dbg !108
  %33 = add nsw i32 %32, -1, !dbg !108
  store i32 %33, ptr @cnt, align 4, !dbg !108
  ret ptr null, !dbg !109
}

declare void @__LKMM_FENCE(i32 noundef) #1

declare void @__VERIFIER_assert(i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 !dbg !110 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !111, !DIExpression(), !112)
    #dbg_declare(ptr %3, !113, !DIExpression(), !115)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !115
  %7 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !115
  %8 = load ptr, ptr %3, align 8, !dbg !115
  store ptr %8, ptr %4, align 8, !dbg !115
  %9 = load ptr, ptr %4, align 8, !dbg !115
    #dbg_declare(ptr %5, !116, !DIExpression(), !117)
  %10 = load ptr, ptr %2, align 8, !dbg !118
  %11 = ptrtoint ptr %10 to i64, !dbg !119
  %12 = trunc i64 %11 to i32, !dbg !120
  store i32 %12, ptr %5, align 4, !dbg !117
    #dbg_declare(ptr %6, !121, !DIExpression(), !122)
  %13 = load i32, ptr @cnt, align 4, !dbg !123
  %14 = add nsw i32 %13, 1, !dbg !123
  store i32 %14, ptr @cnt, align 4, !dbg !123
  store i32 %13, ptr %6, align 4, !dbg !122
  call void @__LKMM_FENCE(i32 noundef 13), !dbg !124
  %15 = load i32, ptr %5, align 4, !dbg !125
  %16 = load i32, ptr %6, align 4, !dbg !126
  %17 = sext i32 %16 to i64, !dbg !127
  %18 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %17, !dbg !127
  %19 = getelementptr inbounds %struct.A, ptr %18, i32 0, i32 0, !dbg !128
  store volatile i32 %15, ptr %19, align 4, !dbg !129
  %20 = load i32, ptr %5, align 4, !dbg !130
  %21 = load i32, ptr %6, align 4, !dbg !131
  %22 = sext i32 %21 to i64, !dbg !132
  %23 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %22, !dbg !132
  %24 = getelementptr inbounds %struct.A, ptr %23, i32 0, i32 1, !dbg !133
  store volatile i32 %20, ptr %24, align 4, !dbg !134
  %25 = load i32, ptr %6, align 4, !dbg !135
  %26 = sext i32 %25 to i64, !dbg !136
  %27 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %26, !dbg !136
  %28 = getelementptr inbounds %struct.A, ptr %27, i32 0, i32 0, !dbg !137
  %29 = load volatile i32, ptr %28, align 4, !dbg !137
  %30 = load i32, ptr %6, align 4, !dbg !138
  %31 = sext i32 %30 to i64, !dbg !139
  %32 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %31, !dbg !139
  %33 = getelementptr inbounds %struct.A, ptr %32, i32 0, i32 1, !dbg !140
  %34 = load volatile i32, ptr %33, align 4, !dbg !140
  %35 = icmp eq i32 %29, %34, !dbg !141
  %36 = zext i1 %35 to i32, !dbg !141
  call void @__VERIFIER_assert(i32 noundef %36), !dbg !142
  call void @__LKMM_FENCE(i32 noundef 13), !dbg !143
  %37 = load i32, ptr @cnt, align 4, !dbg !144
  %38 = add nsw i32 %37, -1, !dbg !144
  store i32 %38, ptr @cnt, align 4, !dbg !144
  ret ptr null, !dbg !145
}

declare void @__VERIFIER_make_interrupt_handler() #1

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !146 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !149, !DIExpression(), !150)
  %3 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @run, ptr noundef inttoptr (i64 1 to ptr)), !dbg !151
  ret i32 0, !dbg !152
}

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!67, !68, !69, !70, !71, !72}
!llvm.ident = !{!73}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "cnt", scope: !2, file: !3, line: 13, type: !38, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !30, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/interrupts/lkmm_with_barrier_dec_barrier.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "10c25f2f9326a4975d232138325b4f86")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "f219e5a4f2482585588927d06bb5e5c6")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_once", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "mb", value: 4)
!14 = !DIEnumerator(name: "wmb", value: 5)
!15 = !DIEnumerator(name: "rmb", value: 6)
!16 = !DIEnumerator(name: "rcu_lock", value: 7)
!17 = !DIEnumerator(name: "rcu_unlock", value: 8)
!18 = !DIEnumerator(name: "rcu_sync", value: 9)
!19 = !DIEnumerator(name: "before_atomic", value: 10)
!20 = !DIEnumerator(name: "after_atomic", value: 11)
!21 = !DIEnumerator(name: "after_spinlock", value: 12)
!22 = !DIEnumerator(name: "barrier", value: 13)
!23 = !{!24, !29}
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !25, line: 32, baseType: !26)
!25 = !DIFile(filename: "/usr/local/include/sys/_types/_intptr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e478ba47270923b1cca6659f19f02db1")
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_intptr_t", file: !27, line: 40, baseType: !28)
!27 = !DIFile(filename: "/usr/local/include/arm/_types.h", directory: "", checksumkind: CSK_MD5, checksum: "b270144f57ae258d0ce80b8f87be068c")
!28 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!30 = !{!0, !31, !42}
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "as", scope: !2, file: !3, line: 12, type: !33, isLocal: false, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 640, elements: !40)
!34 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "A", file: !3, line: 11, size: 64, elements: !35)
!35 = !{!36, !39}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !34, file: !3, line: 11, baseType: !37, size: 32)
!37 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !38)
!38 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !34, file: !3, line: 11, baseType: !37, size: 32, offset: 32)
!40 = !{!41}
!41 = !DISubrange(count: 10)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !3, line: 15, type: !44, isLocal: false, isDefinition: true)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !45, line: 31, baseType: !46)
!45 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !47, line: 118, baseType: !48)
!47 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!48 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !49, size: 64)
!49 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !47, line: 103, size: 65536, elements: !50)
!50 = !{!51, !52, !62}
!51 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !49, file: !47, line: 104, baseType: !28, size: 64)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !49, file: !47, line: 105, baseType: !53, size: 64, offset: 64)
!53 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !54, size: 64)
!54 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !47, line: 57, size: 192, elements: !55)
!55 = !{!56, !60, !61}
!56 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !54, file: !47, line: 58, baseType: !57, size: 64)
!57 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !58, size: 64)
!58 = !DISubroutineType(types: !59)
!59 = !{null, !29}
!60 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !54, file: !47, line: 59, baseType: !29, size: 64, offset: 64)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !54, file: !47, line: 60, baseType: !53, size: 64, offset: 128)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !49, file: !47, line: 106, baseType: !63, size: 65408, offset: 128)
!63 = !DICompositeType(tag: DW_TAG_array_type, baseType: !64, size: 65408, elements: !65)
!64 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!65 = !{!66}
!66 = !DISubrange(count: 8176)
!67 = !{i32 7, !"Dwarf Version", i32 5}
!68 = !{i32 2, !"Debug Info Version", i32 3}
!69 = !{i32 1, !"wchar_size", i32 4}
!70 = !{i32 8, !"PIC Level", i32 2}
!71 = !{i32 7, !"uwtable", i32 1}
!72 = !{i32 7, !"frame-pointer", i32 1}
!73 = !{!"Homebrew clang version 19.1.7"}
!74 = distinct !DISubprogram(name: "handler", scope: !3, file: !3, line: 16, type: !75, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !77)
!75 = !DISubroutineType(types: !76)
!76 = !{!29, !29}
!77 = !{}
!78 = !DILocalVariable(name: "arg", arg: 1, scope: !74, file: !3, line: 16, type: !29)
!79 = !DILocation(line: 16, column: 21, scope: !74)
!80 = !DILocalVariable(name: "tindex", scope: !74, file: !3, line: 18, type: !38)
!81 = !DILocation(line: 18, column: 9, scope: !74)
!82 = !DILocation(line: 18, column: 30, scope: !74)
!83 = !DILocation(line: 18, column: 19, scope: !74)
!84 = !DILocation(line: 18, column: 18, scope: !74)
!85 = !DILocalVariable(name: "i", scope: !74, file: !3, line: 19, type: !38)
!86 = !DILocation(line: 19, column: 9, scope: !74)
!87 = !DILocation(line: 19, column: 16, scope: !74)
!88 = !DILocation(line: 20, column: 5, scope: !74)
!89 = !DILocation(line: 21, column: 15, scope: !74)
!90 = !DILocation(line: 21, column: 8, scope: !74)
!91 = !DILocation(line: 21, column: 5, scope: !74)
!92 = !DILocation(line: 21, column: 11, scope: !74)
!93 = !DILocation(line: 21, column: 13, scope: !74)
!94 = !DILocation(line: 22, column: 15, scope: !74)
!95 = !DILocation(line: 22, column: 8, scope: !74)
!96 = !DILocation(line: 22, column: 5, scope: !74)
!97 = !DILocation(line: 22, column: 11, scope: !74)
!98 = !DILocation(line: 22, column: 13, scope: !74)
!99 = !DILocation(line: 23, column: 26, scope: !74)
!100 = !DILocation(line: 23, column: 23, scope: !74)
!101 = !DILocation(line: 23, column: 29, scope: !74)
!102 = !DILocation(line: 23, column: 37, scope: !74)
!103 = !DILocation(line: 23, column: 34, scope: !74)
!104 = !DILocation(line: 23, column: 40, scope: !74)
!105 = !DILocation(line: 23, column: 31, scope: !74)
!106 = !DILocation(line: 23, column: 5, scope: !74)
!107 = !DILocation(line: 25, column: 5, scope: !74)
!108 = !DILocation(line: 26, column: 8, scope: !74)
!109 = !DILocation(line: 28, column: 5, scope: !74)
!110 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 31, type: !75, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !77)
!111 = !DILocalVariable(name: "arg", arg: 1, scope: !110, file: !3, line: 31, type: !29)
!112 = !DILocation(line: 31, column: 17, scope: !110)
!113 = !DILocalVariable(name: "h", scope: !114, file: !3, line: 33, type: !44)
!114 = distinct !DILexicalBlock(scope: !110, file: !3, line: 33, column: 5)
!115 = !DILocation(line: 33, column: 5, scope: !114)
!116 = !DILocalVariable(name: "tindex", scope: !110, file: !3, line: 35, type: !38)
!117 = !DILocation(line: 35, column: 9, scope: !110)
!118 = !DILocation(line: 35, column: 30, scope: !110)
!119 = !DILocation(line: 35, column: 19, scope: !110)
!120 = !DILocation(line: 35, column: 18, scope: !110)
!121 = !DILocalVariable(name: "i", scope: !110, file: !3, line: 36, type: !38)
!122 = !DILocation(line: 36, column: 9, scope: !110)
!123 = !DILocation(line: 36, column: 16, scope: !110)
!124 = !DILocation(line: 37, column: 5, scope: !110)
!125 = !DILocation(line: 38, column: 15, scope: !110)
!126 = !DILocation(line: 38, column: 8, scope: !110)
!127 = !DILocation(line: 38, column: 5, scope: !110)
!128 = !DILocation(line: 38, column: 11, scope: !110)
!129 = !DILocation(line: 38, column: 13, scope: !110)
!130 = !DILocation(line: 39, column: 15, scope: !110)
!131 = !DILocation(line: 39, column: 8, scope: !110)
!132 = !DILocation(line: 39, column: 5, scope: !110)
!133 = !DILocation(line: 39, column: 11, scope: !110)
!134 = !DILocation(line: 39, column: 13, scope: !110)
!135 = !DILocation(line: 40, column: 26, scope: !110)
!136 = !DILocation(line: 40, column: 23, scope: !110)
!137 = !DILocation(line: 40, column: 29, scope: !110)
!138 = !DILocation(line: 40, column: 37, scope: !110)
!139 = !DILocation(line: 40, column: 34, scope: !110)
!140 = !DILocation(line: 40, column: 40, scope: !110)
!141 = !DILocation(line: 40, column: 31, scope: !110)
!142 = !DILocation(line: 40, column: 5, scope: !110)
!143 = !DILocation(line: 42, column: 5, scope: !110)
!144 = !DILocation(line: 43, column: 8, scope: !110)
!145 = !DILocation(line: 45, column: 5, scope: !110)
!146 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 48, type: !147, scopeLine: 49, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !77)
!147 = !DISubroutineType(types: !148)
!148 = !{!38}
!149 = !DILocalVariable(name: "t", scope: !146, file: !3, line: 50, type: !44)
!150 = !DILocation(line: 50, column: 15, scope: !146)
!151 = !DILocation(line: 51, column: 5, scope: !146)
!152 = !DILocation(line: 53, column: 5, scope: !146)
