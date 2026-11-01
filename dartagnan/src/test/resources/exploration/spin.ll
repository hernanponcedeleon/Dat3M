; ModuleID = 'benchmarks/exploration/spin.c'
source_filename = "benchmarks/exploration/spin.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

@data = global i32 0, align 4, !dbg !0
@flag = global i32 0, align 4, !dbg !35
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !18
@.str = private unnamed_addr constant [7 x i8] c"spin.c\00", align 1, !dbg !25
@.str.1 = private unnamed_addr constant [11 x i8] c"data == 42\00", align 1, !dbg !30

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @producer(ptr noundef %0) #0 !dbg !47 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !51, !DIExpression(), !52)
  store i32 42, ptr @data, align 4, !dbg !53
  store i32 1, ptr %3, align 4, !dbg !54
  %4 = load i32, ptr %3, align 4, !dbg !54
  store atomic i32 %4, ptr @flag release, align 4, !dbg !54
  ret ptr null, !dbg !55
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !56 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !59, !DIExpression(), !83)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @producer, ptr noundef null), !dbg !84
  br label %5, !dbg !85

5:                                                ; preds = %9, %0
  %6 = load atomic i32, ptr @flag acquire, align 4, !dbg !86
  store i32 %6, ptr %3, align 4, !dbg !86
  %7 = load i32, ptr %3, align 4, !dbg !86
  %8 = icmp eq i32 %7, 0, !dbg !87
  br i1 %8, label %9, label %10, !dbg !85

9:                                                ; preds = %5
  br label %5, !dbg !85, !llvm.loop !88

10:                                               ; preds = %5
  %11 = load i32, ptr @data, align 4, !dbg !91
  %12 = icmp eq i32 %11, 42, !dbg !92
  %13 = xor i1 %12, true, !dbg !93
  %14 = zext i1 %13 to i32, !dbg !93
  %15 = sext i32 %14 to i64, !dbg !93
  %16 = icmp ne i64 %15, 0, !dbg !93
  br i1 %16, label %17, label %19, !dbg !93

17:                                               ; preds = %10
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 21, ptr noundef @.str.1) #3, !dbg !93
  unreachable, !dbg !93

18:                                               ; No predecessors!
  br label %20, !dbg !93

19:                                               ; preds = %10
  br label %20, !dbg !93

20:                                               ; preds = %19, %18
  %21 = load ptr, ptr %2, align 8, !dbg !94
  %22 = call i32 @"\01_pthread_join"(ptr noundef %21, ptr noundef null), !dbg !95
  ret i32 0, !dbg !96
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #3 = { cold noreturn }

!llvm.module.flags = !{!40, !41, !42, !43, !44, !45}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!46}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !3, line: 9, type: !39, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk", sdk: "MacOSX26.sdk")
!3 = !DIFile(filename: "benchmarks/exploration/spin.c", directory: "", checksumkind: CSK_MD5, checksum: "b2023fa5712474cd8b7514d052f6e790")
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
!17 = !{!18, !25, !30, !35, !0}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !3, line: 21, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 40, elements: !23)
!21 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !22)
!22 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!23 = !{!24}
!24 = !DISubrange(count: 5)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(scope: null, file: !3, line: 21, type: !27, isLocal: true, isDefinition: true)
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 56, elements: !28)
!28 = !{!29}
!29 = !DISubrange(count: 7)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 21, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 88, elements: !33)
!33 = !{!34}
!34 = !DISubrange(count: 11)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "flag", scope: !2, file: !3, line: 8, type: !37, isLocal: false, isDefinition: true)
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
!47 = distinct !DISubprogram(name: "producer", scope: !3, file: !3, line: 11, type: !48, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !50)
!48 = !DISubroutineType(types: !49)
!49 = !{!16, !16}
!50 = !{}
!51 = !DILocalVariable(name: "arg", arg: 1, scope: !47, file: !3, line: 11, type: !16)
!52 = !DILocation(line: 11, column: 22, scope: !47)
!53 = !DILocation(line: 12, column: 10, scope: !47)
!54 = !DILocation(line: 13, column: 5, scope: !47)
!55 = !DILocation(line: 14, column: 5, scope: !47)
!56 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 17, type: !57, scopeLine: 17, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !50)
!57 = !DISubroutineType(types: !58)
!58 = !{!39}
!59 = !DILocalVariable(name: "t", scope: !56, file: !3, line: 18, type: !60)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !61, line: 31, baseType: !62)
!61 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!62 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !63, line: 118, baseType: !64)
!63 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 64)
!65 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !63, line: 103, size: 65536, elements: !66)
!66 = !{!67, !69, !79}
!67 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !65, file: !63, line: 104, baseType: !68, size: 64)
!68 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !65, file: !63, line: 105, baseType: !70, size: 64, offset: 64)
!70 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !71, size: 64)
!71 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !63, line: 57, size: 192, elements: !72)
!72 = !{!73, !77, !78}
!73 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !71, file: !63, line: 58, baseType: !74, size: 64)
!74 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !75, size: 64)
!75 = !DISubroutineType(types: !76)
!76 = !{null, !16}
!77 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !71, file: !63, line: 59, baseType: !16, size: 64, offset: 64)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !71, file: !63, line: 60, baseType: !70, size: 64, offset: 128)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !65, file: !63, line: 106, baseType: !80, size: 65408, offset: 128)
!80 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 65408, elements: !81)
!81 = !{!82}
!82 = !DISubrange(count: 8176)
!83 = !DILocation(line: 18, column: 15, scope: !56)
!84 = !DILocation(line: 19, column: 5, scope: !56)
!85 = !DILocation(line: 20, column: 5, scope: !56)
!86 = !DILocation(line: 20, column: 12, scope: !56)
!87 = !DILocation(line: 20, column: 62, scope: !56)
!88 = distinct !{!88, !85, !89, !90}
!89 = !DILocation(line: 20, column: 70, scope: !56)
!90 = !{!"llvm.loop.mustprogress"}
!91 = !DILocation(line: 21, column: 12, scope: !56)
!92 = !DILocation(line: 21, column: 17, scope: !56)
!93 = !DILocation(line: 21, column: 5, scope: !56)
!94 = !DILocation(line: 22, column: 18, scope: !56)
!95 = !DILocation(line: 22, column: 5, scope: !56)
!96 = !DILocation(line: 23, column: 5, scope: !56)
