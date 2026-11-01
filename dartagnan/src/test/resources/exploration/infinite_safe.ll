; ModuleID = 'benchmarks/exploration/infinite_safe.c'
source_filename = "benchmarks/exploration/infinite_safe.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

@x = global i32 0, align 4, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !18
@.str = private unnamed_addr constant [16 x i8] c"infinite_safe.c\00", align 1, !dbg !25
@.str.1 = private unnamed_addr constant [7 x i8] c"r >= 0\00", align 1, !dbg !30
@flag = global i32 0, align 4, !dbg !35

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @writer(ptr noundef %0) #0 !dbg !47 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !51, !DIExpression(), !52)
  br label %5, !dbg !53

5:                                                ; preds = %1, %5
  store i32 1, ptr %3, align 4, !dbg !54
  %6 = load i32, ptr %3, align 4, !dbg !54
  %7 = atomicrmw add ptr @x, i32 %6 monotonic, align 4, !dbg !54
  store i32 %7, ptr %4, align 4, !dbg !54
  %8 = load i32, ptr %4, align 4, !dbg !54
  br label %5, !dbg !53, !llvm.loop !56
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !58 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !61, !DIExpression(), !85)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @writer, ptr noundef null), !dbg !86
    #dbg_declare(ptr %3, !87, !DIExpression(), !88)
  %6 = load atomic i32, ptr @x monotonic, align 4, !dbg !89
  store i32 %6, ptr %4, align 4, !dbg !89
  %7 = load i32, ptr %4, align 4, !dbg !89
  store i32 %7, ptr %3, align 4, !dbg !88
  %8 = load i32, ptr %3, align 4, !dbg !90
  %9 = icmp sge i32 %8, 0, !dbg !91
  %10 = xor i1 %9, true, !dbg !92
  %11 = zext i1 %10 to i32, !dbg !92
  %12 = sext i32 %11 to i64, !dbg !92
  %13 = icmp ne i64 %12, 0, !dbg !92
  br i1 %13, label %14, label %16, !dbg !92

14:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 23, ptr noundef @.str.1) #3, !dbg !92
  unreachable, !dbg !92

15:                                               ; No predecessors!
  br label %17, !dbg !92

16:                                               ; preds = %0
  br label %17, !dbg !92

17:                                               ; preds = %16, %15
  ret i32 0, !dbg !93
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #3 = { cold noreturn }

!llvm.module.flags = !{!40, !41, !42, !43, !44, !45}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!46}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 8, type: !37, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk", sdk: "MacOSX26.sdk")
!3 = !DIFile(filename: "benchmarks/exploration/infinite_safe.c", directory: "", checksumkind: CSK_MD5, checksum: "89baf4d075ce621f57604f374b330edb")
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
!17 = !{!18, !25, !30, !0, !35}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !3, line: 23, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 40, elements: !23)
!21 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !22)
!22 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!23 = !{!24}
!24 = !DISubrange(count: 5)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(scope: null, file: !3, line: 23, type: !27, isLocal: true, isDefinition: true)
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 128, elements: !28)
!28 = !{!29}
!29 = !DISubrange(count: 16)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 23, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 56, elements: !33)
!33 = !{!34}
!34 = !DISubrange(count: 7)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "flag", scope: !2, file: !3, line: 9, type: !37, isLocal: false, isDefinition: true)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 104, baseType: !38)
!38 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !39)
!39 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!40 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 5]}
!41 = !{i32 7, !"Dwarf Version", i32 5}
!42 = !{i32 2, !"Debug Info Version", i32 3}
!43 = !{i32 8, !"PIC Level", i32 2}
!44 = !{i32 7, !"uwtable", i32 1}
!45 = !{i32 7, !"frame-pointer", i32 4}
!46 = !{!"Homebrew clang version 23.1.0"}
!47 = distinct !DISubprogram(name: "writer", scope: !3, file: !3, line: 11, type: !48, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !50)
!48 = !DISubroutineType(types: !49)
!49 = !{!16, !16}
!50 = !{}
!51 = !DILocalVariable(name: "arg", arg: 1, scope: !47, file: !3, line: 11, type: !16)
!52 = !DILocation(line: 11, column: 20, scope: !47)
!53 = !DILocation(line: 13, column: 5, scope: !47)
!54 = !DILocation(line: 14, column: 9, scope: !55)
!55 = distinct !DILexicalBlock(scope: !47, file: !3, line: 13, column: 15)
!56 = distinct !{!56, !53, !57}
!57 = !DILocation(line: 15, column: 5, scope: !47)
!58 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 19, type: !59, scopeLine: 19, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !50)
!59 = !DISubroutineType(types: !60)
!60 = !{!39}
!61 = !DILocalVariable(name: "t", scope: !58, file: !3, line: 20, type: !62)
!62 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !63, line: 31, baseType: !64)
!63 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!64 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !65, line: 118, baseType: !66)
!65 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!67 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !65, line: 103, size: 65536, elements: !68)
!68 = !{!69, !71, !81}
!69 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !67, file: !65, line: 104, baseType: !70, size: 64)
!70 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !67, file: !65, line: 105, baseType: !72, size: 64, offset: 64)
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !73, size: 64)
!73 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !65, line: 57, size: 192, elements: !74)
!74 = !{!75, !79, !80}
!75 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !73, file: !65, line: 58, baseType: !76, size: 64)
!76 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !77, size: 64)
!77 = !DISubroutineType(types: !78)
!78 = !{null, !16}
!79 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !73, file: !65, line: 59, baseType: !16, size: 64, offset: 64)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !73, file: !65, line: 60, baseType: !72, size: 64, offset: 128)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !67, file: !65, line: 106, baseType: !82, size: 65408, offset: 128)
!82 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 65408, elements: !83)
!83 = !{!84}
!84 = !DISubrange(count: 8176)
!85 = !DILocation(line: 20, column: 15, scope: !58)
!86 = !DILocation(line: 21, column: 5, scope: !58)
!87 = !DILocalVariable(name: "r", scope: !58, file: !3, line: 22, type: !39)
!88 = !DILocation(line: 22, column: 9, scope: !58)
!89 = !DILocation(line: 22, column: 13, scope: !58)
!90 = !DILocation(line: 23, column: 12, scope: !58)
!91 = !DILocation(line: 23, column: 14, scope: !58)
!92 = !DILocation(line: 23, column: 5, scope: !58)
!93 = !DILocation(line: 24, column: 5, scope: !58)
