; ModuleID = 'benchmarks/miscellaneous/dataRaceFreeChain.c'
source_filename = "benchmarks/miscellaneous/dataRaceFreeChain.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

@data = global i32 0, align 4, !dbg !0
@f1 = global i32 0, align 4, !dbg !18
@f2 = global i32 0, align 4, !dbg !23

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @first(ptr noundef %0) #0 !dbg !32 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !36, !DIExpression(), !37)
  store i32 1, ptr @data, align 4, !dbg !38
  store i32 1, ptr %3, align 4, !dbg !39
  %4 = load i32, ptr %3, align 4, !dbg !39
  store atomic i32 %4, ptr @f1 release, align 4, !dbg !39
  ret ptr null, !dbg !40
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @second(ptr noundef %0) #0 !dbg !41 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !42, !DIExpression(), !43)
  %5 = load atomic i32, ptr @f1 acquire, align 4, !dbg !44
  store i32 %5, ptr %3, align 4, !dbg !44
  %6 = load i32, ptr %3, align 4, !dbg !44
  %7 = icmp eq i32 %6, 1, !dbg !46
  br i1 %7, label %8, label %10, !dbg !46

8:                                                ; preds = %1
  store i32 1, ptr %4, align 4, !dbg !47
  %9 = load i32, ptr %4, align 4, !dbg !47
  store atomic i32 %9, ptr @f2 release, align 4, !dbg !47
  br label %10, !dbg !49

10:                                               ; preds = %8, %1
  ret ptr null, !dbg !50
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @third(ptr noundef %0) #0 !dbg !51 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !52, !DIExpression(), !53)
  %5 = load atomic i32, ptr @f2 acquire, align 4, !dbg !54
  store i32 %5, ptr %3, align 4, !dbg !54
  %6 = load i32, ptr %3, align 4, !dbg !54
  %7 = icmp eq i32 %6, 1, !dbg !56
  br i1 %7, label %8, label %11, !dbg !56

8:                                                ; preds = %1
    #dbg_declare(ptr %4, !57, !DIExpression(), !59)
  %9 = load i32, ptr @data, align 4, !dbg !60
  store i32 %9, ptr %4, align 4, !dbg !59
  %10 = load i32, ptr %4, align 4, !dbg !61
  br label %11, !dbg !62

11:                                               ; preds = %8, %1
  ret ptr null, !dbg !63
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !64 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !67, !DIExpression(), !92)
    #dbg_declare(ptr %3, !93, !DIExpression(), !94)
    #dbg_declare(ptr %4, !95, !DIExpression(), !96)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @first, ptr noundef null), !dbg !97
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @second, ptr noundef null), !dbg !98
  %7 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @third, ptr noundef null), !dbg !99
  %8 = load ptr, ptr %2, align 8, !dbg !100
  %9 = call i32 @"\01_pthread_join"(ptr noundef %8, ptr noundef null), !dbg !101
  %10 = load ptr, ptr %3, align 8, !dbg !102
  %11 = call i32 @"\01_pthread_join"(ptr noundef %10, ptr noundef null), !dbg !103
  %12 = load ptr, ptr %4, align 8, !dbg !104
  %13 = call i32 @"\01_pthread_join"(ptr noundef %12, ptr noundef null), !dbg !105
  ret i32 0, !dbg !106
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }

!llvm.module.flags = !{!25, !26, !27, !28, !29, !30}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!31}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !3, line: 10, type: !22, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk", sdk: "MacOSX26.sdk")
!3 = !DIFile(filename: "benchmarks/miscellaneous/dataRaceFreeChain.c", directory: "/private/tmp/claude-501/-Users-hponcedeleon-git-Dat3M/b624805e-6c49-4d05-b9a2-c91e1b4fbbcb/scratchpad/wt-final", checksumkind: CSK_MD5, checksum: "02f9a216881ab4894df03c6f039d779b")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 68, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/opt/homebrew/Cellar/llvm/23.1.0/lib/clang/23/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "f17199a988fe91afffaf0f943ef87096")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !{!0, !18, !23}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "f1", scope: !2, file: !3, line: 11, type: !20, isLocal: false, isDefinition: true)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 104, baseType: !21)
!21 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !22)
!22 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(name: "f2", scope: !2, file: !3, line: 12, type: !20, isLocal: false, isDefinition: true)
!25 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 5]}
!26 = !{i32 7, !"Dwarf Version", i32 5}
!27 = !{i32 2, !"Debug Info Version", i32 3}
!28 = !{i32 8, !"PIC Level", i32 2}
!29 = !{i32 7, !"uwtable", i32 1}
!30 = !{i32 7, !"frame-pointer", i32 4}
!31 = !{!"Homebrew clang version 23.1.0"}
!32 = distinct !DISubprogram(name: "first", scope: !3, file: !3, line: 14, type: !33, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !35)
!33 = !DISubroutineType(types: !34)
!34 = !{!16, !16}
!35 = !{}
!36 = !DILocalVariable(name: "arg", arg: 1, scope: !32, file: !3, line: 14, type: !16)
!37 = !DILocation(line: 14, column: 19, scope: !32)
!38 = !DILocation(line: 16, column: 10, scope: !32)
!39 = !DILocation(line: 17, column: 5, scope: !32)
!40 = !DILocation(line: 18, column: 5, scope: !32)
!41 = distinct !DISubprogram(name: "second", scope: !3, file: !3, line: 21, type: !33, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !35)
!42 = !DILocalVariable(name: "arg", arg: 1, scope: !41, file: !3, line: 21, type: !16)
!43 = !DILocation(line: 21, column: 20, scope: !41)
!44 = !DILocation(line: 23, column: 9, scope: !45)
!45 = distinct !DILexicalBlock(scope: !41, file: !3, line: 23, column: 9)
!46 = !DILocation(line: 23, column: 57, scope: !45)
!47 = !DILocation(line: 24, column: 9, scope: !48)
!48 = distinct !DILexicalBlock(scope: !45, file: !3, line: 23, column: 63)
!49 = !DILocation(line: 25, column: 5, scope: !48)
!50 = !DILocation(line: 26, column: 5, scope: !41)
!51 = distinct !DISubprogram(name: "third", scope: !3, file: !3, line: 29, type: !33, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !35)
!52 = !DILocalVariable(name: "arg", arg: 1, scope: !51, file: !3, line: 29, type: !16)
!53 = !DILocation(line: 29, column: 19, scope: !51)
!54 = !DILocation(line: 31, column: 9, scope: !55)
!55 = distinct !DILexicalBlock(scope: !51, file: !3, line: 31, column: 9)
!56 = !DILocation(line: 31, column: 57, scope: !55)
!57 = !DILocalVariable(name: "r", scope: !58, file: !3, line: 32, type: !22)
!58 = distinct !DILexicalBlock(scope: !55, file: !3, line: 31, column: 63)
!59 = !DILocation(line: 32, column: 13, scope: !58)
!60 = !DILocation(line: 32, column: 17, scope: !58)
!61 = !DILocation(line: 33, column: 16, scope: !58)
!62 = !DILocation(line: 34, column: 5, scope: !58)
!63 = !DILocation(line: 35, column: 5, scope: !51)
!64 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 38, type: !65, scopeLine: 39, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !35)
!65 = !DISubroutineType(types: !66)
!66 = !{!22}
!67 = !DILocalVariable(name: "t1", scope: !64, file: !3, line: 40, type: !68)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !69, line: 31, baseType: !70)
!69 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !71, line: 118, baseType: !72)
!71 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !73, size: 64)
!73 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !71, line: 103, size: 65536, elements: !74)
!74 = !{!75, !77, !87}
!75 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !73, file: !71, line: 104, baseType: !76, size: 64)
!76 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !73, file: !71, line: 105, baseType: !78, size: 64, offset: 64)
!78 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !79, size: 64)
!79 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !71, line: 57, size: 192, elements: !80)
!80 = !{!81, !85, !86}
!81 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !79, file: !71, line: 58, baseType: !82, size: 64)
!82 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !83, size: 64)
!83 = !DISubroutineType(types: !84)
!84 = !{null, !16}
!85 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !79, file: !71, line: 59, baseType: !16, size: 64, offset: 64)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !79, file: !71, line: 60, baseType: !78, size: 64, offset: 128)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !73, file: !71, line: 106, baseType: !88, size: 65408, offset: 128)
!88 = !DICompositeType(tag: DW_TAG_array_type, baseType: !89, size: 65408, elements: !90)
!89 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!90 = !{!91}
!91 = !DISubrange(count: 8176)
!92 = !DILocation(line: 40, column: 15, scope: !64)
!93 = !DILocalVariable(name: "t2", scope: !64, file: !3, line: 40, type: !68)
!94 = !DILocation(line: 40, column: 19, scope: !64)
!95 = !DILocalVariable(name: "t3", scope: !64, file: !3, line: 40, type: !68)
!96 = !DILocation(line: 40, column: 23, scope: !64)
!97 = !DILocation(line: 41, column: 5, scope: !64)
!98 = !DILocation(line: 42, column: 5, scope: !64)
!99 = !DILocation(line: 43, column: 5, scope: !64)
!100 = !DILocation(line: 44, column: 18, scope: !64)
!101 = !DILocation(line: 44, column: 5, scope: !64)
!102 = !DILocation(line: 45, column: 18, scope: !64)
!103 = !DILocation(line: 45, column: 5, scope: !64)
!104 = !DILocation(line: 46, column: 18, scope: !64)
!105 = !DILocation(line: 46, column: 5, scope: !64)
!106 = !DILocation(line: 47, column: 5, scope: !64)
