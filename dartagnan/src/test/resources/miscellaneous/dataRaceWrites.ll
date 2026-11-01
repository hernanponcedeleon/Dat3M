; ModuleID = 'benchmarks/miscellaneous/dataRaceWrites.c'
source_filename = "benchmarks/miscellaneous/dataRaceWrites.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

@x = global i32 0, align 4, !dbg !0

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @writer(ptr noundef %0) #0 !dbg !15 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !19, !DIExpression(), !20)
  store i32 1, ptr @x, align 4, !dbg !21
  ret ptr null, !dbg !22
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !23 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !26, !DIExpression(), !51)
    #dbg_declare(ptr %3, !52, !DIExpression(), !53)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @writer, ptr noundef null), !dbg !54
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @writer, ptr noundef null), !dbg !55
  %6 = load ptr, ptr %2, align 8, !dbg !56
  %7 = call i32 @"\01_pthread_join"(ptr noundef %6, ptr noundef null), !dbg !57
  %8 = load ptr, ptr %3, align 8, !dbg !58
  %9 = call i32 @"\01_pthread_join"(ptr noundef %8, ptr noundef null), !dbg !59
  ret i32 0, !dbg !60
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }

!llvm.module.flags = !{!8, !9, !10, !11, !12, !13}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!14}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 8, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk", sdk: "MacOSX26.sdk")
!3 = !DIFile(filename: "benchmarks/miscellaneous/dataRaceWrites.c", directory: "/private/tmp/claude-501/-Users-hponcedeleon-git-Dat3M/b624805e-6c49-4d05-b9a2-c91e1b4fbbcb/scratchpad/wt-final", checksumkind: CSK_MD5, checksum: "eb5ff6bd03c6c5b899e26e967be8eae3")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0}
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 5]}
!9 = !{i32 7, !"Dwarf Version", i32 5}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 8, !"PIC Level", i32 2}
!12 = !{i32 7, !"uwtable", i32 1}
!13 = !{i32 7, !"frame-pointer", i32 4}
!14 = !{!"Homebrew clang version 23.1.0"}
!15 = distinct !DISubprogram(name: "writer", scope: !3, file: !3, line: 10, type: !16, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !18)
!16 = !DISubroutineType(types: !17)
!17 = !{!5, !5}
!18 = !{}
!19 = !DILocalVariable(name: "arg", arg: 1, scope: !15, file: !3, line: 10, type: !5)
!20 = !DILocation(line: 10, column: 20, scope: !15)
!21 = !DILocation(line: 12, column: 7, scope: !15)
!22 = !DILocation(line: 13, column: 5, scope: !15)
!23 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 16, type: !24, scopeLine: 17, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !18)
!24 = !DISubroutineType(types: !25)
!25 = !{!7}
!26 = !DILocalVariable(name: "t1", scope: !23, file: !3, line: 18, type: !27)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !28, line: 31, baseType: !29)
!28 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !30, line: 118, baseType: !31)
!30 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !30, line: 103, size: 65536, elements: !33)
!33 = !{!34, !36, !46}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !32, file: !30, line: 104, baseType: !35, size: 64)
!35 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !32, file: !30, line: 105, baseType: !37, size: 64, offset: 64)
!37 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!38 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !30, line: 57, size: 192, elements: !39)
!39 = !{!40, !44, !45}
!40 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !38, file: !30, line: 58, baseType: !41, size: 64)
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!42 = !DISubroutineType(types: !43)
!43 = !{null, !5}
!44 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !38, file: !30, line: 59, baseType: !5, size: 64, offset: 64)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !38, file: !30, line: 60, baseType: !37, size: 64, offset: 128)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !32, file: !30, line: 106, baseType: !47, size: 65408, offset: 128)
!47 = !DICompositeType(tag: DW_TAG_array_type, baseType: !48, size: 65408, elements: !49)
!48 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!49 = !{!50}
!50 = !DISubrange(count: 8176)
!51 = !DILocation(line: 18, column: 15, scope: !23)
!52 = !DILocalVariable(name: "t2", scope: !23, file: !3, line: 18, type: !27)
!53 = !DILocation(line: 18, column: 19, scope: !23)
!54 = !DILocation(line: 19, column: 5, scope: !23)
!55 = !DILocation(line: 20, column: 5, scope: !23)
!56 = !DILocation(line: 21, column: 18, scope: !23)
!57 = !DILocation(line: 21, column: 5, scope: !23)
!58 = !DILocation(line: 22, column: 18, scope: !23)
!59 = !DILocation(line: 22, column: 5, scope: !23)
!60 = !DILocation(line: 23, column: 5, scope: !23)
