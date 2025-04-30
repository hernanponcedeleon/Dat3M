; ModuleID = 'benchmarks/interrupts/misc/ih_disabled_forever_v1.c'
source_filename = "benchmarks/interrupts/misc/ih_disabled_forever_v1.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@__func__.handler = private unnamed_addr constant [8 x i8] c"handler\00", align 1, !dbg !0
@.str = private unnamed_addr constant [25 x i8] c"ih_disabled_forever_v1.c\00", align 1, !dbg !8
@.str.1 = private unnamed_addr constant [2 x i8] c"0\00", align 1, !dbg !13

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !29 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !33, !DIExpression(), !34)
  call void @__assert_rtn(ptr noundef @__func__.handler, ptr noundef @.str, i32 noundef 12, ptr noundef @.str.1) #3, !dbg !35
  unreachable, !dbg !35
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !36 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
  call void @__VERIFIER_disable_irq(), !dbg !40
    #dbg_declare(ptr %2, !41, !DIExpression(), !66)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !66
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !66
  %5 = load ptr, ptr %2, align 8, !dbg !66
  store ptr %5, ptr %3, align 8, !dbg !66
  %6 = load ptr, ptr %3, align 8, !dbg !66
  ret i32 0, !dbg !67
}

declare void @__VERIFIER_disable_irq() #2

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!18}
!llvm.module.flags = !{!22, !23, !24, !25, !26, !27}
!llvm.ident = !{!28}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 12, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "benchmarks/interrupts/misc/ih_disabled_forever_v1.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "adf0984dcb76955f8ac5be25fd60a578")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 64, elements: !6)
!4 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !5)
!5 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!6 = !{!7}
!7 = !DISubrange(count: 8)
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(scope: null, file: !2, line: 12, type: !10, isLocal: true, isDefinition: true)
!10 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 200, elements: !11)
!11 = !{!12}
!12 = !DISubrange(count: 25)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(scope: null, file: !2, line: 12, type: !15, isLocal: true, isDefinition: true)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 16, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 2)
!18 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !19, globals: !21, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!19 = !{!20}
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!21 = !{!0, !8, !13}
!22 = !{i32 7, !"Dwarf Version", i32 5}
!23 = !{i32 2, !"Debug Info Version", i32 3}
!24 = !{i32 1, !"wchar_size", i32 4}
!25 = !{i32 8, !"PIC Level", i32 2}
!26 = !{i32 7, !"uwtable", i32 1}
!27 = !{i32 7, !"frame-pointer", i32 1}
!28 = !{!"Homebrew clang version 19.1.7"}
!29 = distinct !DISubprogram(name: "handler", scope: !2, file: !2, line: 10, type: !30, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !18, retainedNodes: !32)
!30 = !DISubroutineType(types: !31)
!31 = !{!20, !20}
!32 = !{}
!33 = !DILocalVariable(name: "arg", arg: 1, scope: !29, file: !2, line: 10, type: !20)
!34 = !DILocation(line: 10, column: 21, scope: !29)
!35 = !DILocation(line: 12, column: 5, scope: !29)
!36 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 15, type: !37, scopeLine: 16, spFlags: DISPFlagDefinition, unit: !18, retainedNodes: !32)
!37 = !DISubroutineType(types: !38)
!38 = !{!39}
!39 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!40 = !DILocation(line: 17, column: 5, scope: !36)
!41 = !DILocalVariable(name: "h", scope: !42, file: !2, line: 18, type: !43)
!42 = distinct !DILexicalBlock(scope: !36, file: !2, line: 18, column: 5)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !44, line: 31, baseType: !45)
!44 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !46, line: 118, baseType: !47)
!46 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!48 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !46, line: 103, size: 65536, elements: !49)
!49 = !{!50, !52, !62}
!50 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !48, file: !46, line: 104, baseType: !51, size: 64)
!51 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !48, file: !46, line: 105, baseType: !53, size: 64, offset: 64)
!53 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !54, size: 64)
!54 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !46, line: 57, size: 192, elements: !55)
!55 = !{!56, !60, !61}
!56 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !54, file: !46, line: 58, baseType: !57, size: 64)
!57 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !58, size: 64)
!58 = !DISubroutineType(types: !59)
!59 = !{null, !20}
!60 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !54, file: !46, line: 59, baseType: !20, size: 64, offset: 64)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !54, file: !46, line: 60, baseType: !53, size: 64, offset: 128)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !48, file: !46, line: 106, baseType: !63, size: 65408, offset: 128)
!63 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 65408, elements: !64)
!64 = !{!65}
!65 = !DISubrange(count: 8176)
!66 = !DILocation(line: 18, column: 5, scope: !42)
!67 = !DILocation(line: 20, column: 5, scope: !36)
