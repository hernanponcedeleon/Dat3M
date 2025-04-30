; ModuleID = 'benchmarks/interrupts/misc/safety_multiple-ih.c'
source_filename = "benchmarks/interrupts/misc/safety_multiple-ih.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@y = global i32 0, align 4, !dbg !0
@__func__.handler = private unnamed_addr constant [8 x i8] c"handler\00", align 1, !dbg !7
@.str = private unnamed_addr constant [21 x i8] c"safety_multiple-ih.c\00", align 1, !dbg !14
@.str.1 = private unnamed_addr constant [7 x i8] c"y != 1\00", align 1, !dbg !19
@x = global i32 0, align 4, !dbg !24

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !35 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !39, !DIExpression(), !40)
  %3 = load volatile i32, ptr @y, align 4, !dbg !41
  %4 = icmp ne i32 %3, 1, !dbg !41
  %5 = xor i1 %4, true, !dbg !41
  %6 = zext i1 %5 to i32, !dbg !41
  %7 = sext i32 %6 to i64, !dbg !41
  %8 = icmp ne i64 %7, 0, !dbg !41
  br i1 %8, label %9, label %11, !dbg !41

9:                                                ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.handler, ptr noundef @.str, i32 noundef 14, ptr noundef @.str.1) #3, !dbg !41
  unreachable, !dbg !41

10:                                               ; No predecessors!
  br label %12, !dbg !41

11:                                               ; preds = %1
  br label %12, !dbg !41

12:                                               ; preds = %11, %10
  ret ptr null, !dbg !42
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler2(ptr noundef %0) #0 !dbg !43 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !44, !DIExpression(), !45)
  store volatile i32 1, ptr @y, align 4, !dbg !46
  br label %3, !dbg !47

3:                                                ; preds = %6, %1
  %4 = load volatile i32, ptr @x, align 4, !dbg !48
  %5 = icmp ne i32 %4, 1, !dbg !49
  br i1 %5, label %6, label %7, !dbg !47

6:                                                ; preds = %3
  br label %3, !dbg !47, !llvm.loop !50

7:                                                ; preds = %3
  ret ptr null, !dbg !53
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !54 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !57, !DIExpression(), !82)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !82
  %6 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !82
  %7 = load ptr, ptr %2, align 8, !dbg !82
  store ptr %7, ptr %3, align 8, !dbg !82
  %8 = load ptr, ptr %3, align 8, !dbg !82
    #dbg_declare(ptr %4, !83, !DIExpression(), !85)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !85
  %9 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @handler2, ptr noundef null), !dbg !85
  %10 = load ptr, ptr %4, align 8, !dbg !85
  store ptr %10, ptr %5, align 8, !dbg !85
  %11 = load ptr, ptr %5, align 8, !dbg !85
  ret i32 0, !dbg !86
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!28, !29, !30, !31, !32, !33}
!llvm.ident = !{!34}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 10, type: !26, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/interrupts/misc/safety_multiple-ih.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "669222630ff8fa45ebbf1073917bbac2")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !14, !19, !24, !0}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !3, line: 14, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 64, elements: !12)
!10 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!11 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!12 = !{!13}
!13 = !DISubrange(count: 8)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(scope: null, file: !3, line: 14, type: !16, isLocal: true, isDefinition: true)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 168, elements: !17)
!17 = !{!18}
!18 = !DISubrange(count: 21)
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(scope: null, file: !3, line: 14, type: !21, isLocal: true, isDefinition: true)
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 56, elements: !22)
!22 = !{!23}
!23 = !DISubrange(count: 7)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 10, type: !26, isLocal: false, isDefinition: true)
!26 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !27)
!27 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!28 = !{i32 7, !"Dwarf Version", i32 5}
!29 = !{i32 2, !"Debug Info Version", i32 3}
!30 = !{i32 1, !"wchar_size", i32 4}
!31 = !{i32 8, !"PIC Level", i32 2}
!32 = !{i32 7, !"uwtable", i32 1}
!33 = !{i32 7, !"frame-pointer", i32 1}
!34 = !{!"Homebrew clang version 19.1.7"}
!35 = distinct !DISubprogram(name: "handler", scope: !3, file: !3, line: 12, type: !36, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !38)
!36 = !DISubroutineType(types: !37)
!37 = !{!5, !5}
!38 = !{}
!39 = !DILocalVariable(name: "arg", arg: 1, scope: !35, file: !3, line: 12, type: !5)
!40 = !DILocation(line: 12, column: 21, scope: !35)
!41 = !DILocation(line: 14, column: 5, scope: !35)
!42 = !DILocation(line: 15, column: 5, scope: !35)
!43 = distinct !DISubprogram(name: "handler2", scope: !3, file: !3, line: 18, type: !36, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !38)
!44 = !DILocalVariable(name: "arg", arg: 1, scope: !43, file: !3, line: 18, type: !5)
!45 = !DILocation(line: 18, column: 22, scope: !43)
!46 = !DILocation(line: 20, column: 7, scope: !43)
!47 = !DILocation(line: 21, column: 5, scope: !43)
!48 = !DILocation(line: 21, column: 12, scope: !43)
!49 = !DILocation(line: 21, column: 14, scope: !43)
!50 = distinct !{!50, !47, !51, !52}
!51 = !DILocation(line: 21, column: 19, scope: !43)
!52 = !{!"llvm.loop.mustprogress"}
!53 = !DILocation(line: 23, column: 5, scope: !43)
!54 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 26, type: !55, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !38)
!55 = !DISubroutineType(types: !56)
!56 = !{!27}
!57 = !DILocalVariable(name: "h", scope: !58, file: !3, line: 28, type: !59)
!58 = distinct !DILexicalBlock(scope: !54, file: !3, line: 28, column: 5)
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !60, line: 31, baseType: !61)
!60 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !62, line: 118, baseType: !63)
!62 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!63 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !64, size: 64)
!64 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !62, line: 103, size: 65536, elements: !65)
!65 = !{!66, !68, !78}
!66 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !64, file: !62, line: 104, baseType: !67, size: 64)
!67 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !64, file: !62, line: 105, baseType: !69, size: 64, offset: 64)
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 64)
!70 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !62, line: 57, size: 192, elements: !71)
!71 = !{!72, !76, !77}
!72 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !70, file: !62, line: 58, baseType: !73, size: 64)
!73 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !74, size: 64)
!74 = !DISubroutineType(types: !75)
!75 = !{null, !5}
!76 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !70, file: !62, line: 59, baseType: !5, size: 64, offset: 64)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !70, file: !62, line: 60, baseType: !69, size: 64, offset: 128)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !64, file: !62, line: 106, baseType: !79, size: 65408, offset: 128)
!79 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 65408, elements: !80)
!80 = !{!81}
!81 = !DISubrange(count: 8176)
!82 = !DILocation(line: 28, column: 5, scope: !58)
!83 = !DILocalVariable(name: "h", scope: !84, file: !3, line: 29, type: !59)
!84 = distinct !DILexicalBlock(scope: !54, file: !3, line: 29, column: 5)
!85 = !DILocation(line: 29, column: 5, scope: !84)
!86 = !DILocation(line: 31, column: 5, scope: !54)
