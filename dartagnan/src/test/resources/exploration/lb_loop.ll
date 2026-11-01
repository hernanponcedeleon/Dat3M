; ModuleID = 'benchmarks/exploration/lb_loop.c'
source_filename = "benchmarks/exploration/lb_loop.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

@x = global i32 0, align 4, !dbg !0
@r0 = global i32 0, align 4, !dbg !40
@y = global i32 0, align 4, !dbg !35
@r1 = global i32 0, align 4, !dbg !42
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !18
@.str = private unnamed_addr constant [10 x i8] c"lb_loop.c\00", align 1, !dbg !25
@.str.1 = private unnamed_addr constant [22 x i8] c"!(r0 == 1 && r1 == 1)\00", align 1, !dbg !30

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread0(ptr noundef %0) #0 !dbg !51 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !55, !DIExpression(), !56)
    #dbg_declare(ptr %3, !57, !DIExpression(), !59)
  store i32 0, ptr %3, align 4, !dbg !59
  br label %6, !dbg !60

6:                                                ; preds = %12, %1
  %7 = load i32, ptr %3, align 4, !dbg !61
  %8 = icmp slt i32 %7, 2, !dbg !63
  br i1 %8, label %9, label %15, !dbg !64

9:                                                ; preds = %6
  %10 = load atomic i32, ptr @x monotonic, align 4, !dbg !65
  store i32 %10, ptr %4, align 4, !dbg !65
  %11 = load i32, ptr %4, align 4, !dbg !65
  store i32 %11, ptr @r0, align 4, !dbg !67
  br label %12, !dbg !68

12:                                               ; preds = %9
  %13 = load i32, ptr %3, align 4, !dbg !69
  %14 = add nsw i32 %13, 1, !dbg !69
  store i32 %14, ptr %3, align 4, !dbg !69
  br label %6, !dbg !70, !llvm.loop !71

15:                                               ; preds = %6
  store i32 1, ptr %5, align 4, !dbg !74
  %16 = load i32, ptr %5, align 4, !dbg !74
  store atomic i32 %16, ptr @y monotonic, align 4, !dbg !74
  ret ptr null, !dbg !75
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread1(ptr noundef %0) #0 !dbg !76 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !77, !DIExpression(), !78)
  %5 = load atomic i32, ptr @y monotonic, align 4, !dbg !79
  store i32 %5, ptr %3, align 4, !dbg !79
  %6 = load i32, ptr %3, align 4, !dbg !79
  store i32 %6, ptr @r1, align 4, !dbg !80
  store i32 1, ptr %4, align 4, !dbg !81
  %7 = load i32, ptr %4, align 4, !dbg !81
  store atomic i32 %7, ptr @x monotonic, align 4, !dbg !81
  ret ptr null, !dbg !82
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !83 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !86, !DIExpression(), !110)
    #dbg_declare(ptr %3, !111, !DIExpression(), !112)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread0, ptr noundef null), !dbg !113
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread1, ptr noundef null), !dbg !114
  %6 = load ptr, ptr %2, align 8, !dbg !115
  %7 = call i32 @"\01_pthread_join"(ptr noundef %6, ptr noundef null), !dbg !116
  %8 = load ptr, ptr %3, align 8, !dbg !117
  %9 = call i32 @"\01_pthread_join"(ptr noundef %8, ptr noundef null), !dbg !118
  %10 = load i32, ptr @r0, align 4, !dbg !119
  %11 = icmp eq i32 %10, 1, !dbg !120
  br i1 %11, label %12, label %15, !dbg !121

12:                                               ; preds = %0
  %13 = load i32, ptr @r1, align 4, !dbg !122
  %14 = icmp eq i32 %13, 1, !dbg !123
  br label %15

15:                                               ; preds = %12, %0
  %16 = phi i1 [ false, %0 ], [ %14, %12 ], !dbg !124
  %17 = xor i1 %16, true, !dbg !125
  %18 = xor i1 %17, true, !dbg !126
  %19 = zext i1 %18 to i32, !dbg !126
  %20 = sext i32 %19 to i64, !dbg !126
  %21 = icmp ne i64 %20, 0, !dbg !126
  br i1 %21, label %22, label %24, !dbg !126

22:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 33, ptr noundef @.str.1) #3, !dbg !126
  unreachable, !dbg !126

23:                                               ; No predecessors!
  br label %25, !dbg !126

24:                                               ; preds = %15
  br label %25, !dbg !126

25:                                               ; preds = %24, %23
  ret i32 0, !dbg !127
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #3 = { cold noreturn }

!llvm.module.flags = !{!44, !45, !46, !47, !48, !49}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!50}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 9, type: !37, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk", sdk: "MacOSX26.sdk")
!3 = !DIFile(filename: "benchmarks/exploration/lb_loop.c", directory: "", checksumkind: CSK_MD5, checksum: "3bfd28ad9b0a7340b788a89fbbbc0c63")
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
!17 = !{!18, !25, !30, !0, !35, !40, !42}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !3, line: 33, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 40, elements: !23)
!21 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !22)
!22 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!23 = !{!24}
!24 = !DISubrange(count: 5)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(scope: null, file: !3, line: 33, type: !27, isLocal: true, isDefinition: true)
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 80, elements: !28)
!28 = !{!29}
!29 = !DISubrange(count: 10)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 33, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 176, elements: !33)
!33 = !{!34}
!34 = !DISubrange(count: 22)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 10, type: !37, isLocal: false, isDefinition: true)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 104, baseType: !38)
!38 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !39)
!39 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !3, line: 11, type: !39, isLocal: false, isDefinition: true)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "r1", scope: !2, file: !3, line: 11, type: !39, isLocal: false, isDefinition: true)
!44 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 5]}
!45 = !{i32 7, !"Dwarf Version", i32 5}
!46 = !{i32 2, !"Debug Info Version", i32 3}
!47 = !{i32 8, !"PIC Level", i32 2}
!48 = !{i32 7, !"uwtable", i32 1}
!49 = !{i32 7, !"frame-pointer", i32 4}
!50 = !{!"Homebrew clang version 23.1.0"}
!51 = distinct !DISubprogram(name: "thread0", scope: !3, file: !3, line: 13, type: !52, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!52 = !DISubroutineType(types: !53)
!53 = !{!16, !16}
!54 = !{}
!55 = !DILocalVariable(name: "arg", arg: 1, scope: !51, file: !3, line: 13, type: !16)
!56 = !DILocation(line: 13, column: 21, scope: !51)
!57 = !DILocalVariable(name: "i", scope: !58, file: !3, line: 14, type: !39)
!58 = distinct !DILexicalBlock(scope: !51, file: !3, line: 14, column: 5)
!59 = !DILocation(line: 14, column: 14, scope: !58)
!60 = !DILocation(line: 14, column: 10, scope: !58)
!61 = !DILocation(line: 14, column: 21, scope: !62)
!62 = distinct !DILexicalBlock(scope: !58, file: !3, line: 14, column: 5)
!63 = !DILocation(line: 14, column: 23, scope: !62)
!64 = !DILocation(line: 14, column: 5, scope: !58)
!65 = !DILocation(line: 15, column: 14, scope: !66)
!66 = distinct !DILexicalBlock(scope: !62, file: !3, line: 14, column: 33)
!67 = !DILocation(line: 15, column: 12, scope: !66)
!68 = !DILocation(line: 16, column: 5, scope: !66)
!69 = !DILocation(line: 14, column: 29, scope: !62)
!70 = !DILocation(line: 14, column: 5, scope: !62)
!71 = distinct !{!71, !64, !72, !73}
!72 = !DILocation(line: 16, column: 5, scope: !58)
!73 = !{!"llvm.loop.mustprogress"}
!74 = !DILocation(line: 17, column: 5, scope: !51)
!75 = !DILocation(line: 18, column: 5, scope: !51)
!76 = distinct !DISubprogram(name: "thread1", scope: !3, file: !3, line: 21, type: !52, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!77 = !DILocalVariable(name: "arg", arg: 1, scope: !76, file: !3, line: 21, type: !16)
!78 = !DILocation(line: 21, column: 21, scope: !76)
!79 = !DILocation(line: 22, column: 10, scope: !76)
!80 = !DILocation(line: 22, column: 8, scope: !76)
!81 = !DILocation(line: 23, column: 5, scope: !76)
!82 = !DILocation(line: 24, column: 5, scope: !76)
!83 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 27, type: !84, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!84 = !DISubroutineType(types: !85)
!85 = !{!39}
!86 = !DILocalVariable(name: "t0", scope: !83, file: !3, line: 28, type: !87)
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !88, line: 31, baseType: !89)
!88 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!89 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !90, line: 118, baseType: !91)
!90 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!91 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !92, size: 64)
!92 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !90, line: 103, size: 65536, elements: !93)
!93 = !{!94, !96, !106}
!94 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !92, file: !90, line: 104, baseType: !95, size: 64)
!95 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !92, file: !90, line: 105, baseType: !97, size: 64, offset: 64)
!97 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!98 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !90, line: 57, size: 192, elements: !99)
!99 = !{!100, !104, !105}
!100 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !98, file: !90, line: 58, baseType: !101, size: 64)
!101 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !102, size: 64)
!102 = !DISubroutineType(types: !103)
!103 = !{null, !16}
!104 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !98, file: !90, line: 59, baseType: !16, size: 64, offset: 64)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !98, file: !90, line: 60, baseType: !97, size: 64, offset: 128)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !92, file: !90, line: 106, baseType: !107, size: 65408, offset: 128)
!107 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 65408, elements: !108)
!108 = !{!109}
!109 = !DISubrange(count: 8176)
!110 = !DILocation(line: 28, column: 15, scope: !83)
!111 = !DILocalVariable(name: "t1", scope: !83, file: !3, line: 28, type: !87)
!112 = !DILocation(line: 28, column: 19, scope: !83)
!113 = !DILocation(line: 29, column: 5, scope: !83)
!114 = !DILocation(line: 30, column: 5, scope: !83)
!115 = !DILocation(line: 31, column: 18, scope: !83)
!116 = !DILocation(line: 31, column: 5, scope: !83)
!117 = !DILocation(line: 32, column: 18, scope: !83)
!118 = !DILocation(line: 32, column: 5, scope: !83)
!119 = !DILocation(line: 33, column: 14, scope: !83)
!120 = !DILocation(line: 33, column: 17, scope: !83)
!121 = !DILocation(line: 33, column: 22, scope: !83)
!122 = !DILocation(line: 33, column: 25, scope: !83)
!123 = !DILocation(line: 33, column: 28, scope: !83)
!124 = !DILocation(line: 0, scope: !83)
!125 = !DILocation(line: 33, column: 12, scope: !83)
!126 = !DILocation(line: 33, column: 5, scope: !83)
!127 = !DILocation(line: 34, column: 5, scope: !83)
