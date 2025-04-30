; ModuleID = 'benchmarks/interrupts/misc/ih_disabled_forever_v2.c'
source_filename = "benchmarks/interrupts/misc/ih_disabled_forever_v2.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@x = global i32 0, align 4, !dbg !0
@__func__.handler = private unnamed_addr constant [8 x i8] c"handler\00", align 1, !dbg !7
@.str = private unnamed_addr constant [25 x i8] c"ih_disabled_forever_v2.c\00", align 1, !dbg !14
@.str.1 = private unnamed_addr constant [7 x i8] c"x != 1\00", align 1, !dbg !19

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !33 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !37, !DIExpression(), !38)
  %3 = load volatile i32, ptr @x, align 4, !dbg !39
  %4 = icmp ne i32 %3, 1, !dbg !39
  %5 = xor i1 %4, true, !dbg !39
  %6 = zext i1 %5 to i32, !dbg !39
  %7 = sext i32 %6 to i64, !dbg !39
  %8 = icmp ne i64 %7, 0, !dbg !39
  br i1 %8, label %9, label %11, !dbg !39

9:                                                ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.handler, ptr noundef @.str, i32 noundef 13, ptr noundef @.str.1) #3, !dbg !39
  unreachable, !dbg !39

10:                                               ; No predecessors!
  br label %12, !dbg !39

11:                                               ; preds = %1
  br label %12, !dbg !39

12:                                               ; preds = %11, %10
  ret ptr null, !dbg !40
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !41 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !44, !DIExpression(), !69)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !69
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !69
  %5 = load ptr, ptr %2, align 8, !dbg !69
  store ptr %5, ptr %3, align 8, !dbg !69
  %6 = load ptr, ptr %3, align 8, !dbg !69
  call void @__VERIFIER_disable_irq(), !dbg !70
  store volatile i32 1, ptr @x, align 4, !dbg !71
  ret i32 0, !dbg !72
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare void @__VERIFIER_disable_irq() #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!26, !27, !28, !29, !30, !31}
!llvm.ident = !{!32}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 9, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/interrupts/misc/ih_disabled_forever_v2.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "f680209b3f53c3fe2aced002a4a7f4af")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !14, !19, !0}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 64, elements: !12)
!10 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!11 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!12 = !{!13}
!13 = !DISubrange(count: 8)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !16, isLocal: true, isDefinition: true)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 200, elements: !17)
!17 = !{!18}
!18 = !DISubrange(count: 25)
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !21, isLocal: true, isDefinition: true)
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 56, elements: !22)
!22 = !{!23}
!23 = !DISubrange(count: 7)
!24 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !25)
!25 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!26 = !{i32 7, !"Dwarf Version", i32 5}
!27 = !{i32 2, !"Debug Info Version", i32 3}
!28 = !{i32 1, !"wchar_size", i32 4}
!29 = !{i32 8, !"PIC Level", i32 2}
!30 = !{i32 7, !"uwtable", i32 1}
!31 = !{i32 7, !"frame-pointer", i32 1}
!32 = !{!"Homebrew clang version 19.1.7"}
!33 = distinct !DISubprogram(name: "handler", scope: !3, file: !3, line: 11, type: !34, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !36)
!34 = !DISubroutineType(types: !35)
!35 = !{!5, !5}
!36 = !{}
!37 = !DILocalVariable(name: "arg", arg: 1, scope: !33, file: !3, line: 11, type: !5)
!38 = !DILocation(line: 11, column: 21, scope: !33)
!39 = !DILocation(line: 13, column: 5, scope: !33)
!40 = !DILocation(line: 14, column: 5, scope: !33)
!41 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 17, type: !42, scopeLine: 18, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !36)
!42 = !DISubroutineType(types: !43)
!43 = !{!25}
!44 = !DILocalVariable(name: "h", scope: !45, file: !3, line: 19, type: !46)
!45 = distinct !DILexicalBlock(scope: !41, file: !3, line: 19, column: 5)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !47, line: 31, baseType: !48)
!47 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !49, line: 118, baseType: !50)
!49 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!51 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !49, line: 103, size: 65536, elements: !52)
!52 = !{!53, !55, !65}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !51, file: !49, line: 104, baseType: !54, size: 64)
!54 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !51, file: !49, line: 105, baseType: !56, size: 64, offset: 64)
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !57, size: 64)
!57 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !49, line: 57, size: 192, elements: !58)
!58 = !{!59, !63, !64}
!59 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !57, file: !49, line: 58, baseType: !60, size: 64)
!60 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!61 = !DISubroutineType(types: !62)
!62 = !{null, !5}
!63 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !57, file: !49, line: 59, baseType: !5, size: 64, offset: 64)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !57, file: !49, line: 60, baseType: !56, size: 64, offset: 128)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !51, file: !49, line: 106, baseType: !66, size: 65408, offset: 128)
!66 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 65408, elements: !67)
!67 = !{!68}
!68 = !DISubrange(count: 8176)
!69 = !DILocation(line: 19, column: 5, scope: !45)
!70 = !DILocation(line: 20, column: 5, scope: !41)
!71 = !DILocation(line: 21, column: 7, scope: !41)
!72 = !DILocation(line: 23, column: 5, scope: !41)
