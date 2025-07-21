; ModuleID = 'benchmarks/mixed/store-to-load-forwarding1.c'
source_filename = "benchmarks/mixed/store-to-load-forwarding1.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%union.anon = type { i16 }

@lock = global %union.anon zeroinitializer, align 2, !dbg !0
@__func__.thread3 = private unnamed_addr constant [8 x i8] c"thread3\00", align 1, !dbg !16
@.str = private unnamed_addr constant [28 x i8] c"store-to-load-forwarding1.c\00", align 1, !dbg !23
@.str.1 = private unnamed_addr constant [14 x i8] c"val != 0xffff\00", align 1, !dbg !28

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread1(ptr noundef %0) #0 !dbg !54 {
  %2 = alloca ptr, align 8
  %3 = alloca i16, align 2
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !59, !DIExpression(), !60)
  store i16 -256, ptr %3, align 2, !dbg !61
  %4 = load i16, ptr %3, align 2, !dbg !61
  store atomic i16 %4, ptr @lock monotonic, align 2, !dbg !61
  ret ptr null, !dbg !62
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread2(ptr noundef %0) #0 !dbg !63 {
  %2 = alloca ptr, align 8
  %3 = alloca i16, align 2
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !64, !DIExpression(), !65)
  store i16 255, ptr %3, align 2, !dbg !66
  %4 = load i16, ptr %3, align 2, !dbg !66
  store atomic i16 %4, ptr @lock monotonic, align 2, !dbg !66
  ret ptr null, !dbg !67
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread3(ptr noundef %0) #0 !dbg !68 {
  %2 = alloca ptr, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  %5 = alloca i16, align 2
  %6 = alloca i16, align 2
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !69, !DIExpression(), !70)
  store i8 0, ptr %3, align 1, !dbg !71
  %7 = load i8, ptr %3, align 1, !dbg !71
  %8 = atomicrmw add ptr @lock, i8 %7 monotonic, align 2, !dbg !71
  store i8 %8, ptr %4, align 1, !dbg !71
  %9 = load i8, ptr %4, align 1, !dbg !71
    #dbg_declare(ptr %5, !72, !DIExpression(), !73)
  %10 = load atomic i16, ptr @lock monotonic, align 2, !dbg !74
  store i16 %10, ptr %6, align 2, !dbg !74
  %11 = load i16, ptr %6, align 2, !dbg !74
  store i16 %11, ptr %5, align 2, !dbg !73
  %12 = load i16, ptr %5, align 2, !dbg !75
  %13 = zext i16 %12 to i32, !dbg !75
  %14 = icmp ne i32 %13, 65535, !dbg !75
  %15 = xor i1 %14, true, !dbg !75
  %16 = zext i1 %15 to i32, !dbg !75
  %17 = sext i32 %16 to i64, !dbg !75
  %18 = icmp ne i64 %17, 0, !dbg !75
  br i1 %18, label %19, label %21, !dbg !75

19:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.thread3, ptr noundef @.str, i32 noundef 26, ptr noundef @.str.1) #3, !dbg !75
  unreachable, !dbg !75

20:                                               ; No predecessors!
  br label %22, !dbg !75

21:                                               ; preds = %1
  br label %22, !dbg !75

22:                                               ; preds = %21, %20
  ret ptr null, !dbg !76
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !77 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !81, !DIExpression(), !105)
    #dbg_declare(ptr %3, !106, !DIExpression(), !107)
    #dbg_declare(ptr %4, !108, !DIExpression(), !109)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread1, ptr noundef null), !dbg !110
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread2, ptr noundef null), !dbg !111
  %7 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @thread3, ptr noundef null), !dbg !112
  ret i32 0, !dbg !113
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!47, !48, !49, !50, !51, !52}
!llvm.ident = !{!53}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 8, type: !33, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !15, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/mixed/store-to-load-forwarding1.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "fe5f71554f9ba8a009b20de9a8ddb01f")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 68, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: ".local/universal/llvm-19.1.7/lib/clang/19/include/stdatomic.h", directory: "/Users/r", checksumkind: CSK_MD5, checksum: "f17199a988fe91afffaf0f943ef87096")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16, !23, !28, !0}
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !18, isLocal: true, isDefinition: true)
!18 = !DICompositeType(tag: DW_TAG_array_type, baseType: !19, size: 64, elements: !21)
!19 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !20)
!20 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!21 = !{!22}
!22 = !DISubrange(count: 8)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !25, isLocal: true, isDefinition: true)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 224, elements: !26)
!26 = !{!27}
!27 = !DISubrange(count: 28)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !30, isLocal: true, isDefinition: true)
!30 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 112, elements: !31)
!31 = !{!32}
!32 = !DISubrange(count: 14)
!33 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !3, line: 8, size: 16, elements: !34)
!34 = !{!35, !39}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "full", scope: !33, file: !3, line: 8, baseType: !36, size: 16)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_ushort", file: !6, line: 103, baseType: !37)
!37 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !38)
!38 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!39 = !DIDerivedType(tag: DW_TAG_member, scope: !33, file: !3, line: 8, baseType: !40, size: 16)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !33, file: !3, line: 8, size: 16, elements: !41)
!41 = !{!42, !46}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "half0", scope: !40, file: !3, line: 8, baseType: !43, size: 8)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_uchar", file: !6, line: 101, baseType: !44)
!44 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !45)
!45 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "half1", scope: !40, file: !3, line: 8, baseType: !43, size: 8, offset: 8)
!47 = !{i32 7, !"Dwarf Version", i32 5}
!48 = !{i32 2, !"Debug Info Version", i32 3}
!49 = !{i32 1, !"wchar_size", i32 4}
!50 = !{i32 8, !"PIC Level", i32 2}
!51 = !{i32 7, !"uwtable", i32 1}
!52 = !{i32 7, !"frame-pointer", i32 1}
!53 = !{!"Homebrew clang version 19.1.7"}
!54 = distinct !DISubprogram(name: "thread1", scope: !3, file: !3, line: 10, type: !55, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!55 = !DISubroutineType(types: !56)
!56 = !{!57, !57}
!57 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!58 = !{}
!59 = !DILocalVariable(name: "arg", arg: 1, scope: !54, file: !3, line: 10, type: !57)
!60 = !DILocation(line: 10, column: 21, scope: !54)
!61 = !DILocation(line: 12, column: 5, scope: !54)
!62 = !DILocation(line: 13, column: 5, scope: !54)
!63 = distinct !DISubprogram(name: "thread2", scope: !3, file: !3, line: 16, type: !55, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!64 = !DILocalVariable(name: "arg", arg: 1, scope: !63, file: !3, line: 16, type: !57)
!65 = !DILocation(line: 16, column: 21, scope: !63)
!66 = !DILocation(line: 18, column: 5, scope: !63)
!67 = !DILocation(line: 19, column: 5, scope: !63)
!68 = distinct !DISubprogram(name: "thread3", scope: !3, file: !3, line: 22, type: !55, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!69 = !DILocalVariable(name: "arg", arg: 1, scope: !68, file: !3, line: 22, type: !57)
!70 = !DILocation(line: 22, column: 21, scope: !68)
!71 = !DILocation(line: 24, column: 5, scope: !68)
!72 = !DILocalVariable(name: "val", scope: !68, file: !3, line: 25, type: !38)
!73 = !DILocation(line: 25, column: 20, scope: !68)
!74 = !DILocation(line: 25, column: 26, scope: !68)
!75 = !DILocation(line: 26, column: 5, scope: !68)
!76 = !DILocation(line: 27, column: 5, scope: !68)
!77 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 30, type: !78, scopeLine: 30, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!78 = !DISubroutineType(types: !79)
!79 = !{!80}
!80 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!81 = !DILocalVariable(name: "t1", scope: !77, file: !3, line: 32, type: !82)
!82 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !83, line: 31, baseType: !84)
!83 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !85, line: 118, baseType: !86)
!85 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !87, size: 64)
!87 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !85, line: 103, size: 65536, elements: !88)
!88 = !{!89, !91, !101}
!89 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !87, file: !85, line: 104, baseType: !90, size: 64)
!90 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !87, file: !85, line: 105, baseType: !92, size: 64, offset: 64)
!92 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !93, size: 64)
!93 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !85, line: 57, size: 192, elements: !94)
!94 = !{!95, !99, !100}
!95 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !93, file: !85, line: 58, baseType: !96, size: 64)
!96 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64)
!97 = !DISubroutineType(types: !98)
!98 = !{null, !57}
!99 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !93, file: !85, line: 59, baseType: !57, size: 64, offset: 64)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !93, file: !85, line: 60, baseType: !92, size: 64, offset: 128)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !87, file: !85, line: 106, baseType: !102, size: 65408, offset: 128)
!102 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 65408, elements: !103)
!103 = !{!104}
!104 = !DISubrange(count: 8176)
!105 = !DILocation(line: 32, column: 15, scope: !77)
!106 = !DILocalVariable(name: "t2", scope: !77, file: !3, line: 32, type: !82)
!107 = !DILocation(line: 32, column: 19, scope: !77)
!108 = !DILocalVariable(name: "t3", scope: !77, file: !3, line: 32, type: !82)
!109 = !DILocation(line: 32, column: 23, scope: !77)
!110 = !DILocation(line: 34, column: 5, scope: !77)
!111 = !DILocation(line: 35, column: 5, scope: !77)
!112 = !DILocation(line: 36, column: 5, scope: !77)
!113 = !DILocation(line: 38, column: 5, scope: !77)
