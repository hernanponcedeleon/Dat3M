; ModuleID = 'benchmarks/interrupts/c11_with_barrier_inc_split.c'
source_filename = "benchmarks/interrupts/c11_with_barrier_inc_split.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.A = type { i32, i32 }

@cnt = global i32 0, align 4, !dbg !0
@as = global [10 x %struct.A] zeroinitializer, align 4, !dbg !12
@h = global ptr null, align 8, !dbg !23

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !55 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !59, !DIExpression(), !60)
    #dbg_declare(ptr %3, !61, !DIExpression(), !62)
  %5 = load ptr, ptr %2, align 8, !dbg !63
  %6 = ptrtoint ptr %5 to i64, !dbg !64
  %7 = trunc i64 %6 to i32, !dbg !65
  store i32 %7, ptr %3, align 4, !dbg !62
    #dbg_declare(ptr %4, !66, !DIExpression(), !67)
  %8 = load i32, ptr @cnt, align 4, !dbg !68
  %9 = add nsw i32 %8, 1, !dbg !68
  store i32 %9, ptr @cnt, align 4, !dbg !68
  store i32 %8, ptr %4, align 4, !dbg !67
  call void @__VERIFIER_make_cb(), !dbg !69
  %10 = load i32, ptr %3, align 4, !dbg !70
  %11 = load i32, ptr %4, align 4, !dbg !71
  %12 = sext i32 %11 to i64, !dbg !72
  %13 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %12, !dbg !72
  %14 = getelementptr inbounds %struct.A, ptr %13, i32 0, i32 0, !dbg !73
  store volatile i32 %10, ptr %14, align 4, !dbg !74
  %15 = load i32, ptr %3, align 4, !dbg !75
  %16 = load i32, ptr %4, align 4, !dbg !76
  %17 = sext i32 %16 to i64, !dbg !77
  %18 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %17, !dbg !77
  %19 = getelementptr inbounds %struct.A, ptr %18, i32 0, i32 1, !dbg !78
  store volatile i32 %15, ptr %19, align 4, !dbg !79
  %20 = load i32, ptr %4, align 4, !dbg !80
  %21 = sext i32 %20 to i64, !dbg !81
  %22 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %21, !dbg !81
  %23 = getelementptr inbounds %struct.A, ptr %22, i32 0, i32 0, !dbg !82
  %24 = load volatile i32, ptr %23, align 4, !dbg !82
  %25 = load i32, ptr %4, align 4, !dbg !83
  %26 = sext i32 %25 to i64, !dbg !84
  %27 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %26, !dbg !84
  %28 = getelementptr inbounds %struct.A, ptr %27, i32 0, i32 1, !dbg !85
  %29 = load volatile i32, ptr %28, align 4, !dbg !85
  %30 = icmp eq i32 %24, %29, !dbg !86
  %31 = zext i1 %30 to i32, !dbg !86
  call void @__VERIFIER_assert(i32 noundef %31), !dbg !87
  ret ptr null, !dbg !88
}

declare void @__VERIFIER_make_cb() #1

declare void @__VERIFIER_assert(i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 !dbg !89 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !90, !DIExpression(), !91)
    #dbg_declare(ptr %3, !92, !DIExpression(), !94)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !94
  %7 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !94
  %8 = load ptr, ptr %3, align 8, !dbg !94
  store ptr %8, ptr %4, align 8, !dbg !94
  %9 = load ptr, ptr %4, align 8, !dbg !94
    #dbg_declare(ptr %5, !95, !DIExpression(), !96)
  %10 = load ptr, ptr %2, align 8, !dbg !97
  %11 = ptrtoint ptr %10 to i64, !dbg !98
  %12 = trunc i64 %11 to i32, !dbg !99
  store i32 %12, ptr %5, align 4, !dbg !96
    #dbg_declare(ptr %6, !100, !DIExpression(), !101)
  %13 = load i32, ptr @cnt, align 4, !dbg !102
  store i32 %13, ptr %6, align 4, !dbg !101
  call void @__VERIFIER_make_cb(), !dbg !103
  %14 = load i32, ptr %6, align 4, !dbg !104
  %15 = add nsw i32 %14, 1, !dbg !105
  store i32 %15, ptr @cnt, align 4, !dbg !106
  %16 = load i32, ptr %5, align 4, !dbg !107
  %17 = load i32, ptr %6, align 4, !dbg !108
  %18 = sext i32 %17 to i64, !dbg !109
  %19 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %18, !dbg !109
  %20 = getelementptr inbounds %struct.A, ptr %19, i32 0, i32 0, !dbg !110
  store volatile i32 %16, ptr %20, align 4, !dbg !111
  %21 = load i32, ptr %5, align 4, !dbg !112
  %22 = load i32, ptr %6, align 4, !dbg !113
  %23 = sext i32 %22 to i64, !dbg !114
  %24 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %23, !dbg !114
  %25 = getelementptr inbounds %struct.A, ptr %24, i32 0, i32 1, !dbg !115
  store volatile i32 %21, ptr %25, align 4, !dbg !116
  %26 = load i32, ptr %6, align 4, !dbg !117
  %27 = sext i32 %26 to i64, !dbg !118
  %28 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %27, !dbg !118
  %29 = getelementptr inbounds %struct.A, ptr %28, i32 0, i32 0, !dbg !119
  %30 = load volatile i32, ptr %29, align 4, !dbg !119
  %31 = load i32, ptr %6, align 4, !dbg !120
  %32 = sext i32 %31 to i64, !dbg !121
  %33 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %32, !dbg !121
  %34 = getelementptr inbounds %struct.A, ptr %33, i32 0, i32 1, !dbg !122
  %35 = load volatile i32, ptr %34, align 4, !dbg !122
  %36 = icmp eq i32 %30, %35, !dbg !123
  %37 = zext i1 %36 to i32, !dbg !123
  call void @__VERIFIER_assert(i32 noundef %37), !dbg !124
  ret ptr null, !dbg !125
}

declare void @__VERIFIER_make_interrupt_handler() #1

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !126 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !129, !DIExpression(), !130)
  %3 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @run, ptr noundef inttoptr (i64 1 to ptr)), !dbg !131
  ret i32 0, !dbg !132
}

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!48, !49, !50, !51, !52, !53}
!llvm.ident = !{!54}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "cnt", scope: !2, file: !3, line: 13, type: !19, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !11, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/interrupts/c11_with_barrier_inc_split.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "bac7fa3cc5b461674e97729cf72f13aa")
!4 = !{!5, !10}
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !6, line: 32, baseType: !7)
!6 = !DIFile(filename: "/usr/local/include/sys/_types/_intptr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e478ba47270923b1cca6659f19f02db1")
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_intptr_t", file: !8, line: 40, baseType: !9)
!8 = !DIFile(filename: "/usr/local/include/arm/_types.h", directory: "", checksumkind: CSK_MD5, checksum: "b270144f57ae258d0ce80b8f87be068c")
!9 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!11 = !{!0, !12, !23}
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "as", scope: !2, file: !3, line: 12, type: !14, isLocal: false, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 640, elements: !21)
!15 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "A", file: !3, line: 11, size: 64, elements: !16)
!16 = !{!17, !20}
!17 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !15, file: !3, line: 11, baseType: !18, size: 32)
!18 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !19)
!19 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !15, file: !3, line: 11, baseType: !18, size: 32, offset: 32)
!21 = !{!22}
!22 = !DISubrange(count: 10)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !3, line: 15, type: !25, isLocal: false, isDefinition: true)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !26, line: 31, baseType: !27)
!26 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !28, line: 118, baseType: !29)
!28 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!30 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !28, line: 103, size: 65536, elements: !31)
!31 = !{!32, !33, !43}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !30, file: !28, line: 104, baseType: !9, size: 64)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !30, file: !28, line: 105, baseType: !34, size: 64, offset: 64)
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!35 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !28, line: 57, size: 192, elements: !36)
!36 = !{!37, !41, !42}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !35, file: !28, line: 58, baseType: !38, size: 64)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!39 = !DISubroutineType(types: !40)
!40 = !{null, !10}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !35, file: !28, line: 59, baseType: !10, size: 64, offset: 64)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !35, file: !28, line: 60, baseType: !34, size: 64, offset: 128)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !30, file: !28, line: 106, baseType: !44, size: 65408, offset: 128)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !45, size: 65408, elements: !46)
!45 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!46 = !{!47}
!47 = !DISubrange(count: 8176)
!48 = !{i32 7, !"Dwarf Version", i32 5}
!49 = !{i32 2, !"Debug Info Version", i32 3}
!50 = !{i32 1, !"wchar_size", i32 4}
!51 = !{i32 8, !"PIC Level", i32 2}
!52 = !{i32 7, !"uwtable", i32 1}
!53 = !{i32 7, !"frame-pointer", i32 1}
!54 = !{!"Homebrew clang version 19.1.7"}
!55 = distinct !DISubprogram(name: "handler", scope: !3, file: !3, line: 16, type: !56, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!56 = !DISubroutineType(types: !57)
!57 = !{!10, !10}
!58 = !{}
!59 = !DILocalVariable(name: "arg", arg: 1, scope: !55, file: !3, line: 16, type: !10)
!60 = !DILocation(line: 16, column: 21, scope: !55)
!61 = !DILocalVariable(name: "tindex", scope: !55, file: !3, line: 18, type: !19)
!62 = !DILocation(line: 18, column: 9, scope: !55)
!63 = !DILocation(line: 18, column: 30, scope: !55)
!64 = !DILocation(line: 18, column: 19, scope: !55)
!65 = !DILocation(line: 18, column: 18, scope: !55)
!66 = !DILocalVariable(name: "i", scope: !55, file: !3, line: 19, type: !19)
!67 = !DILocation(line: 19, column: 9, scope: !55)
!68 = !DILocation(line: 19, column: 16, scope: !55)
!69 = !DILocation(line: 20, column: 5, scope: !55)
!70 = !DILocation(line: 21, column: 15, scope: !55)
!71 = !DILocation(line: 21, column: 8, scope: !55)
!72 = !DILocation(line: 21, column: 5, scope: !55)
!73 = !DILocation(line: 21, column: 11, scope: !55)
!74 = !DILocation(line: 21, column: 13, scope: !55)
!75 = !DILocation(line: 22, column: 15, scope: !55)
!76 = !DILocation(line: 22, column: 8, scope: !55)
!77 = !DILocation(line: 22, column: 5, scope: !55)
!78 = !DILocation(line: 22, column: 11, scope: !55)
!79 = !DILocation(line: 22, column: 13, scope: !55)
!80 = !DILocation(line: 23, column: 26, scope: !55)
!81 = !DILocation(line: 23, column: 23, scope: !55)
!82 = !DILocation(line: 23, column: 29, scope: !55)
!83 = !DILocation(line: 23, column: 37, scope: !55)
!84 = !DILocation(line: 23, column: 34, scope: !55)
!85 = !DILocation(line: 23, column: 40, scope: !55)
!86 = !DILocation(line: 23, column: 31, scope: !55)
!87 = !DILocation(line: 23, column: 5, scope: !55)
!88 = !DILocation(line: 25, column: 5, scope: !55)
!89 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 28, type: !56, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!90 = !DILocalVariable(name: "arg", arg: 1, scope: !89, file: !3, line: 28, type: !10)
!91 = !DILocation(line: 28, column: 17, scope: !89)
!92 = !DILocalVariable(name: "h", scope: !93, file: !3, line: 30, type: !25)
!93 = distinct !DILexicalBlock(scope: !89, file: !3, line: 30, column: 5)
!94 = !DILocation(line: 30, column: 5, scope: !93)
!95 = !DILocalVariable(name: "tindex", scope: !89, file: !3, line: 32, type: !19)
!96 = !DILocation(line: 32, column: 9, scope: !89)
!97 = !DILocation(line: 32, column: 30, scope: !89)
!98 = !DILocation(line: 32, column: 19, scope: !89)
!99 = !DILocation(line: 32, column: 18, scope: !89)
!100 = !DILocalVariable(name: "i", scope: !89, file: !3, line: 33, type: !19)
!101 = !DILocation(line: 33, column: 9, scope: !89)
!102 = !DILocation(line: 33, column: 13, scope: !89)
!103 = !DILocation(line: 34, column: 5, scope: !89)
!104 = !DILocation(line: 35, column: 11, scope: !89)
!105 = !DILocation(line: 35, column: 12, scope: !89)
!106 = !DILocation(line: 35, column: 9, scope: !89)
!107 = !DILocation(line: 36, column: 15, scope: !89)
!108 = !DILocation(line: 36, column: 8, scope: !89)
!109 = !DILocation(line: 36, column: 5, scope: !89)
!110 = !DILocation(line: 36, column: 11, scope: !89)
!111 = !DILocation(line: 36, column: 13, scope: !89)
!112 = !DILocation(line: 37, column: 15, scope: !89)
!113 = !DILocation(line: 37, column: 8, scope: !89)
!114 = !DILocation(line: 37, column: 5, scope: !89)
!115 = !DILocation(line: 37, column: 11, scope: !89)
!116 = !DILocation(line: 37, column: 13, scope: !89)
!117 = !DILocation(line: 38, column: 26, scope: !89)
!118 = !DILocation(line: 38, column: 23, scope: !89)
!119 = !DILocation(line: 38, column: 29, scope: !89)
!120 = !DILocation(line: 38, column: 37, scope: !89)
!121 = !DILocation(line: 38, column: 34, scope: !89)
!122 = !DILocation(line: 38, column: 40, scope: !89)
!123 = !DILocation(line: 38, column: 31, scope: !89)
!124 = !DILocation(line: 38, column: 5, scope: !89)
!125 = !DILocation(line: 40, column: 5, scope: !89)
!126 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 43, type: !127, scopeLine: 44, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!127 = !DISubroutineType(types: !128)
!128 = !{!19}
!129 = !DILocalVariable(name: "t", scope: !126, file: !3, line: 45, type: !25)
!130 = !DILocation(line: 45, column: 15, scope: !126)
!131 = !DILocation(line: 46, column: 5, scope: !126)
!132 = !DILocation(line: 48, column: 5, scope: !126)
