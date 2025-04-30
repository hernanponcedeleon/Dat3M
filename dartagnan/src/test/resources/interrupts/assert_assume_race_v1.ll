; ModuleID = 'benchmarks/interrupts/assert_assume_race_v1.c'
source_filename = "benchmarks/interrupts/assert_assume_race_v1.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !11 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !15, !DIExpression(), !16)
  call void @__VERIFIER_assert(i32 noundef 0), !dbg !17
  ret ptr null, !dbg !18
}

declare void @__VERIFIER_assert(i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !19 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !23, !DIExpression(), !49)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !49
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !49
  %5 = load ptr, ptr %2, align 8, !dbg !49
  store ptr %5, ptr %3, align 8, !dbg !49
  %6 = load ptr, ptr %3, align 8, !dbg !49
  call void @__VERIFIER_assume(i32 noundef 0), !dbg !50
  ret i32 0, !dbg !51
}

declare void @__VERIFIER_make_interrupt_handler() #1

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare void @__VERIFIER_assume(i32 noundef) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!4, !5, !6, !7, !8, !9}
!llvm.ident = !{!10}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!1 = !DIFile(filename: "benchmarks/interrupts/assert_assume_race_v1.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "436c47fc142405f7d8368d05ccb2eef1")
!2 = !{!3}
!3 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!4 = !{i32 7, !"Dwarf Version", i32 5}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = !{i32 8, !"PIC Level", i32 2}
!8 = !{i32 7, !"uwtable", i32 1}
!9 = !{i32 7, !"frame-pointer", i32 1}
!10 = !{!"Homebrew clang version 19.1.7"}
!11 = distinct !DISubprogram(name: "handler", scope: !1, file: !1, line: 10, type: !12, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !14)
!12 = !DISubroutineType(types: !13)
!13 = !{!3, !3}
!14 = !{}
!15 = !DILocalVariable(name: "arg", arg: 1, scope: !11, file: !1, line: 10, type: !3)
!16 = !DILocation(line: 10, column: 21, scope: !11)
!17 = !DILocation(line: 13, column: 5, scope: !11)
!18 = !DILocation(line: 14, column: 5, scope: !11)
!19 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 17, type: !20, scopeLine: 18, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !14)
!20 = !DISubroutineType(types: !21)
!21 = !{!22}
!22 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!23 = !DILocalVariable(name: "h", scope: !24, file: !1, line: 19, type: !25)
!24 = distinct !DILexicalBlock(scope: !19, file: !1, line: 19, column: 5)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !26, line: 31, baseType: !27)
!26 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !28, line: 118, baseType: !29)
!28 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!30 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !28, line: 103, size: 65536, elements: !31)
!31 = !{!32, !34, !44}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !30, file: !28, line: 104, baseType: !33, size: 64)
!33 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !30, file: !28, line: 105, baseType: !35, size: 64, offset: 64)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !36, size: 64)
!36 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !28, line: 57, size: 192, elements: !37)
!37 = !{!38, !42, !43}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !36, file: !28, line: 58, baseType: !39, size: 64)
!39 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!40 = !DISubroutineType(types: !41)
!41 = !{null, !3}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !36, file: !28, line: 59, baseType: !3, size: 64, offset: 64)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !36, file: !28, line: 60, baseType: !35, size: 64, offset: 128)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !30, file: !28, line: 106, baseType: !45, size: 65408, offset: 128)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 65408, elements: !47)
!46 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!47 = !{!48}
!48 = !DISubrange(count: 8176)
!49 = !DILocation(line: 19, column: 5, scope: !24)
!50 = !DILocation(line: 21, column: 5, scope: !19)
!51 = !DILocation(line: 23, column: 5, scope: !19)
