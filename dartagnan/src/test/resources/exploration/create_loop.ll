; ModuleID = 'benchmarks/exploration/create_loop.c'
source_filename = "benchmarks/exploration/create_loop.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

@counter = global i32 0, align 4, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !23
@.str = private unnamed_addr constant [14 x i8] c"create_loop.c\00", align 1, !dbg !30
@.str.1 = private unnamed_addr constant [23 x i8] c"sum == N * (N - 1) / 2\00", align 1, !dbg !35
@.str.2 = private unnamed_addr constant [58 x i8] c"atomic_load_explicit(&counter, memory_order_relaxed) == N\00", align 1, !dbg !40

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @worker(ptr noundef %0) #0 !dbg !55 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !59, !DIExpression(), !60)
  store i32 1, ptr %3, align 4, !dbg !61
  %5 = load i32, ptr %3, align 4, !dbg !61
  %6 = atomicrmw add ptr @counter, i32 %5 monotonic, align 4, !dbg !61
  store i32 %6, ptr %4, align 4, !dbg !61
  %7 = load i32, ptr %4, align 4, !dbg !61
  %8 = load ptr, ptr %2, align 8, !dbg !62
  ret ptr %8, !dbg !63
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 !dbg !64 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !67, !DIExpression(), !93)
    #dbg_declare(ptr %3, !94, !DIExpression(), !96)
  store i64 0, ptr %3, align 8, !dbg !96
  br label %8, !dbg !97

8:                                                ; preds = %17, %0
  %9 = load i64, ptr %3, align 8, !dbg !98
  %10 = icmp slt i64 %9, 3, !dbg !100
  br i1 %10, label %11, label %20, !dbg !101

11:                                               ; preds = %8
  %12 = load i64, ptr %3, align 8, !dbg !102
  %13 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %12, !dbg !104
  %14 = load i64, ptr %3, align 8, !dbg !105
  %15 = inttoptr i64 %14 to ptr, !dbg !106
  %16 = call i32 @pthread_create(ptr noundef %13, ptr noundef null, ptr noundef @worker, ptr noundef %15), !dbg !107
  br label %17, !dbg !108

17:                                               ; preds = %11
  %18 = load i64, ptr %3, align 8, !dbg !109
  %19 = add nsw i64 %18, 1, !dbg !109
  store i64 %19, ptr %3, align 8, !dbg !109
  br label %8, !dbg !110, !llvm.loop !111

20:                                               ; preds = %8
    #dbg_declare(ptr %4, !114, !DIExpression(), !115)
  store i64 0, ptr %4, align 8, !dbg !115
    #dbg_declare(ptr %5, !116, !DIExpression(), !118)
  store i32 0, ptr %5, align 4, !dbg !118
  br label %21, !dbg !119

21:                                               ; preds = %34, %20
  %22 = load i32, ptr %5, align 4, !dbg !120
  %23 = icmp slt i32 %22, 3, !dbg !122
  br i1 %23, label %24, label %37, !dbg !123

24:                                               ; preds = %21
    #dbg_declare(ptr %6, !124, !DIExpression(), !126)
  %25 = load i32, ptr %5, align 4, !dbg !127
  %26 = sext i32 %25 to i64, !dbg !128
  %27 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %26, !dbg !128
  %28 = load ptr, ptr %27, align 8, !dbg !128
  %29 = call i32 @"\01_pthread_join"(ptr noundef %28, ptr noundef %6), !dbg !129
  %30 = load ptr, ptr %6, align 8, !dbg !130
  %31 = ptrtoint ptr %30 to i64, !dbg !131
  %32 = load i64, ptr %4, align 8, !dbg !132
  %33 = add nsw i64 %32, %31, !dbg !132
  store i64 %33, ptr %4, align 8, !dbg !132
  br label %34, !dbg !133

34:                                               ; preds = %24
  %35 = load i32, ptr %5, align 4, !dbg !134
  %36 = add nsw i32 %35, 1, !dbg !134
  store i32 %36, ptr %5, align 4, !dbg !134
  br label %21, !dbg !135, !llvm.loop !136

37:                                               ; preds = %21
  %38 = load i64, ptr %4, align 8, !dbg !138
  %39 = icmp eq i64 %38, 3, !dbg !139
  %40 = xor i1 %39, true, !dbg !140
  %41 = zext i1 %40 to i32, !dbg !140
  %42 = sext i32 %41 to i64, !dbg !140
  %43 = icmp ne i64 %42, 0, !dbg !140
  br i1 %43, label %44, label %46, !dbg !140

44:                                               ; preds = %37
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 31, ptr noundef @.str.1) #3, !dbg !140
  unreachable, !dbg !140

45:                                               ; No predecessors!
  br label %47, !dbg !140

46:                                               ; preds = %37
  br label %47, !dbg !140

47:                                               ; preds = %46, %45
  %48 = load atomic i32, ptr @counter monotonic, align 4, !dbg !141
  store i32 %48, ptr %7, align 4, !dbg !141
  %49 = load i32, ptr %7, align 4, !dbg !141
  %50 = icmp eq i32 %49, 3, !dbg !142
  %51 = xor i1 %50, true, !dbg !143
  %52 = zext i1 %51 to i32, !dbg !143
  %53 = sext i32 %52 to i64, !dbg !143
  %54 = icmp ne i64 %53, 0, !dbg !143
  br i1 %54, label %55, label %57, !dbg !143

55:                                               ; preds = %47
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 32, ptr noundef @.str.2) #3, !dbg !143
  unreachable, !dbg !143

56:                                               ; No predecessors!
  br label %58, !dbg !143

57:                                               ; preds = %47
  br label %58, !dbg !143

58:                                               ; preds = %57, %56
  ret i32 0, !dbg !144
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #3 = { cold noreturn }

!llvm.module.flags = !{!48, !49, !50, !51, !52, !53}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!54}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "counter", scope: !2, file: !3, line: 13, type: !45, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !22, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk", sdk: "MacOSX26.sdk")
!3 = !DIFile(filename: "benchmarks/exploration/create_loop.c", directory: "/Users/hponcedeleon/git/agent-4/Dat3M", checksumkind: CSK_MD5, checksum: "5a7ec873c15a5fcd356c5ade2c578834")
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
!15 = !{!16, !17}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !18, line: 32, baseType: !19)
!18 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_types/_intptr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e478ba47270923b1cca6659f19f02db1")
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_intptr_t", file: !20, line: 40, baseType: !21)
!20 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/arm/_types.h", directory: "", checksumkind: CSK_MD5, checksum: "b270144f57ae258d0ce80b8f87be068c")
!21 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!22 = !{!23, !30, !35, !40, !0}
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(scope: null, file: !3, line: 31, type: !25, isLocal: true, isDefinition: true)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 40, elements: !28)
!26 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !27)
!27 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!28 = !{!29}
!29 = !DISubrange(count: 5)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 31, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 112, elements: !33)
!33 = !{!34}
!34 = !DISubrange(count: 14)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(scope: null, file: !3, line: 31, type: !37, isLocal: true, isDefinition: true)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 184, elements: !38)
!38 = !{!39}
!39 = !DISubrange(count: 23)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(scope: null, file: !3, line: 32, type: !42, isLocal: true, isDefinition: true)
!42 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 464, elements: !43)
!43 = !{!44}
!44 = !DISubrange(count: 58)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 104, baseType: !46)
!46 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !47)
!47 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!48 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 5]}
!49 = !{i32 7, !"Dwarf Version", i32 5}
!50 = !{i32 2, !"Debug Info Version", i32 3}
!51 = !{i32 8, !"PIC Level", i32 2}
!52 = !{i32 7, !"uwtable", i32 1}
!53 = !{i32 7, !"frame-pointer", i32 4}
!54 = !{!"Homebrew clang version 23.1.0"}
!55 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 15, type: !56, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!56 = !DISubroutineType(types: !57)
!57 = !{!16, !16}
!58 = !{}
!59 = !DILocalVariable(name: "arg", arg: 1, scope: !55, file: !3, line: 15, type: !16)
!60 = !DILocation(line: 15, column: 20, scope: !55)
!61 = !DILocation(line: 16, column: 5, scope: !55)
!62 = !DILocation(line: 17, column: 12, scope: !55)
!63 = !DILocation(line: 17, column: 5, scope: !55)
!64 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 20, type: !65, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!65 = !DISubroutineType(types: !66)
!66 = !{!47}
!67 = !DILocalVariable(name: "t", scope: !64, file: !3, line: 21, type: !68)
!68 = !DICompositeType(tag: DW_TAG_array_type, baseType: !69, size: 192, elements: !91)
!69 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !70, line: 31, baseType: !71)
!70 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !72, line: 118, baseType: !73)
!72 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!73 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !74, size: 64)
!74 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !72, line: 103, size: 65536, elements: !75)
!75 = !{!76, !77, !87}
!76 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !74, file: !72, line: 104, baseType: !21, size: 64)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !74, file: !72, line: 105, baseType: !78, size: 64, offset: 64)
!78 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !79, size: 64)
!79 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !72, line: 57, size: 192, elements: !80)
!80 = !{!81, !85, !86}
!81 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !79, file: !72, line: 58, baseType: !82, size: 64)
!82 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !83, size: 64)
!83 = !DISubroutineType(types: !84)
!84 = !{null, !16}
!85 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !79, file: !72, line: 59, baseType: !16, size: 64, offset: 64)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !79, file: !72, line: 60, baseType: !78, size: 64, offset: 128)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !74, file: !72, line: 106, baseType: !88, size: 65408, offset: 128)
!88 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 65408, elements: !89)
!89 = !{!90}
!90 = !DISubrange(count: 8176)
!91 = !{!92}
!92 = !DISubrange(count: 3)
!93 = !DILocation(line: 21, column: 15, scope: !64)
!94 = !DILocalVariable(name: "i", scope: !95, file: !3, line: 22, type: !17)
!95 = distinct !DILexicalBlock(scope: !64, file: !3, line: 22, column: 5)
!96 = !DILocation(line: 22, column: 19, scope: !95)
!97 = !DILocation(line: 22, column: 10, scope: !95)
!98 = !DILocation(line: 22, column: 26, scope: !99)
!99 = distinct !DILexicalBlock(scope: !95, file: !3, line: 22, column: 5)
!100 = !DILocation(line: 22, column: 28, scope: !99)
!101 = !DILocation(line: 22, column: 5, scope: !95)
!102 = !DILocation(line: 23, column: 27, scope: !103)
!103 = distinct !DILexicalBlock(scope: !99, file: !3, line: 22, column: 38)
!104 = !DILocation(line: 23, column: 25, scope: !103)
!105 = !DILocation(line: 23, column: 54, scope: !103)
!106 = !DILocation(line: 23, column: 45, scope: !103)
!107 = !DILocation(line: 23, column: 9, scope: !103)
!108 = !DILocation(line: 24, column: 5, scope: !103)
!109 = !DILocation(line: 22, column: 34, scope: !99)
!110 = !DILocation(line: 22, column: 5, scope: !99)
!111 = distinct !{!111, !101, !112, !113}
!112 = !DILocation(line: 24, column: 5, scope: !95)
!113 = !{!"llvm.loop.mustprogress"}
!114 = !DILocalVariable(name: "sum", scope: !64, file: !3, line: 25, type: !17)
!115 = !DILocation(line: 25, column: 14, scope: !64)
!116 = !DILocalVariable(name: "i", scope: !117, file: !3, line: 26, type: !47)
!117 = distinct !DILexicalBlock(scope: !64, file: !3, line: 26, column: 5)
!118 = !DILocation(line: 26, column: 14, scope: !117)
!119 = !DILocation(line: 26, column: 10, scope: !117)
!120 = !DILocation(line: 26, column: 21, scope: !121)
!121 = distinct !DILexicalBlock(scope: !117, file: !3, line: 26, column: 5)
!122 = !DILocation(line: 26, column: 23, scope: !121)
!123 = !DILocation(line: 26, column: 5, scope: !117)
!124 = !DILocalVariable(name: "ret", scope: !125, file: !3, line: 27, type: !16)
!125 = distinct !DILexicalBlock(scope: !121, file: !3, line: 26, column: 33)
!126 = !DILocation(line: 27, column: 15, scope: !125)
!127 = !DILocation(line: 28, column: 24, scope: !125)
!128 = !DILocation(line: 28, column: 22, scope: !125)
!129 = !DILocation(line: 28, column: 9, scope: !125)
!130 = !DILocation(line: 29, column: 27, scope: !125)
!131 = !DILocation(line: 29, column: 16, scope: !125)
!132 = !DILocation(line: 29, column: 13, scope: !125)
!133 = !DILocation(line: 30, column: 5, scope: !125)
!134 = !DILocation(line: 26, column: 29, scope: !121)
!135 = !DILocation(line: 26, column: 5, scope: !121)
!136 = distinct !{!136, !123, !137, !113}
!137 = !DILocation(line: 30, column: 5, scope: !117)
!138 = !DILocation(line: 31, column: 12, scope: !64)
!139 = !DILocation(line: 31, column: 16, scope: !64)
!140 = !DILocation(line: 31, column: 5, scope: !64)
!141 = !DILocation(line: 32, column: 12, scope: !64)
!142 = !DILocation(line: 32, column: 65, scope: !64)
!143 = !DILocation(line: 32, column: 5, scope: !64)
!144 = !DILocation(line: 33, column: 5, scope: !64)
