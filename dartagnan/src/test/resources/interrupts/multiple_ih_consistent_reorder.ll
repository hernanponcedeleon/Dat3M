; ModuleID = 'benchmarks/interrupts/misc/multiple_ih_consistent_reorder.c'
source_filename = "benchmarks/interrupts/misc/multiple_ih_consistent_reorder.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@x = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !24
@z = global i32 0, align 4, !dbg !28
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !7
@.str = private unnamed_addr constant [33 x i8] c"multiple_ih_consistent_reorder.c\00", align 1, !dbg !14
@.str.1 = private unnamed_addr constant [7 x i8] c"z != 2\00", align 1, !dbg !19

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !37 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !41, !DIExpression(), !42)
  %3 = load volatile i32, ptr @x, align 4, !dbg !43
  %4 = icmp eq i32 %3, 1, !dbg !45
  br i1 %4, label %5, label %11, !dbg !46

5:                                                ; preds = %1
  %6 = load volatile i32, ptr @y, align 4, !dbg !47
  %7 = icmp eq i32 %6, 0, !dbg !48
  br i1 %7, label %8, label %11, !dbg !49

8:                                                ; preds = %5
  %9 = load volatile i32, ptr @z, align 4, !dbg !50
  %10 = add nsw i32 %9, 1, !dbg !50
  store volatile i32 %10, ptr @z, align 4, !dbg !50
  br label %11, !dbg !52

11:                                               ; preds = %8, %5, %1
  ret ptr null, !dbg !53
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler2(ptr noundef %0) #0 !dbg !54 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !55, !DIExpression(), !56)
  %3 = load volatile i32, ptr @y, align 4, !dbg !57
  %4 = icmp eq i32 %3, 1, !dbg !59
  br i1 %4, label %5, label %11, !dbg !60

5:                                                ; preds = %1
  %6 = load volatile i32, ptr @x, align 4, !dbg !61
  %7 = icmp eq i32 %6, 0, !dbg !62
  br i1 %7, label %8, label %11, !dbg !63

8:                                                ; preds = %5
  %9 = load volatile i32, ptr @z, align 4, !dbg !64
  %10 = add nsw i32 %9, 1, !dbg !64
  store volatile i32 %10, ptr @z, align 4, !dbg !64
  br label %11, !dbg !66

11:                                               ; preds = %8, %5, %1
  ret ptr null, !dbg !67
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !68 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !71, !DIExpression(), !96)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !96
  %6 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !96
  %7 = load ptr, ptr %2, align 8, !dbg !96
  store ptr %7, ptr %3, align 8, !dbg !96
  %8 = load ptr, ptr %3, align 8, !dbg !96
    #dbg_declare(ptr %4, !97, !DIExpression(), !99)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !99
  %9 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @handler2, ptr noundef null), !dbg !99
  %10 = load ptr, ptr %4, align 8, !dbg !99
  store ptr %10, ptr %5, align 8, !dbg !99
  %11 = load ptr, ptr %5, align 8, !dbg !99
  store volatile i32 1, ptr @x, align 4, !dbg !100
  store volatile i32 1, ptr @y, align 4, !dbg !101
  %12 = load volatile i32, ptr @z, align 4, !dbg !102
  %13 = icmp ne i32 %12, 2, !dbg !102
  %14 = xor i1 %13, true, !dbg !102
  %15 = zext i1 %14 to i32, !dbg !102
  %16 = sext i32 %15 to i64, !dbg !102
  %17 = icmp ne i64 %16, 0, !dbg !102
  br i1 %17, label %18, label %20, !dbg !102

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 39, ptr noundef @.str.1) #3, !dbg !102
  unreachable, !dbg !102

19:                                               ; No predecessors!
  br label %21, !dbg !102

20:                                               ; preds = %0
  br label %21, !dbg !102

21:                                               ; preds = %20, %19
  ret i32 0, !dbg !103
}

declare void @__VERIFIER_make_interrupt_handler() #1

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!30, !31, !32, !33, !34, !35}
!llvm.ident = !{!36}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 10, type: !26, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/interrupts/misc/multiple_ih_consistent_reorder.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "cd96fe1cc2ecfb3f4039f7d85107a401")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !14, !19, !0, !24, !28}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !3, line: 39, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 40, elements: !12)
!10 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!11 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!12 = !{!13}
!13 = !DISubrange(count: 5)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(scope: null, file: !3, line: 39, type: !16, isLocal: true, isDefinition: true)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 264, elements: !17)
!17 = !{!18}
!18 = !DISubrange(count: 33)
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(scope: null, file: !3, line: 39, type: !21, isLocal: true, isDefinition: true)
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 56, elements: !22)
!22 = !{!23}
!23 = !DISubrange(count: 7)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 10, type: !26, isLocal: false, isDefinition: true)
!26 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !27)
!27 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !3, line: 10, type: !26, isLocal: false, isDefinition: true)
!30 = !{i32 7, !"Dwarf Version", i32 5}
!31 = !{i32 2, !"Debug Info Version", i32 3}
!32 = !{i32 1, !"wchar_size", i32 4}
!33 = !{i32 8, !"PIC Level", i32 2}
!34 = !{i32 7, !"uwtable", i32 1}
!35 = !{i32 7, !"frame-pointer", i32 1}
!36 = !{!"Homebrew clang version 19.1.7"}
!37 = distinct !DISubprogram(name: "handler", scope: !3, file: !3, line: 13, type: !38, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !40)
!38 = !DISubroutineType(types: !39)
!39 = !{!5, !5}
!40 = !{}
!41 = !DILocalVariable(name: "arg", arg: 1, scope: !37, file: !3, line: 13, type: !5)
!42 = !DILocation(line: 13, column: 21, scope: !37)
!43 = !DILocation(line: 15, column: 9, scope: !44)
!44 = distinct !DILexicalBlock(scope: !37, file: !3, line: 15, column: 9)
!45 = !DILocation(line: 15, column: 11, scope: !44)
!46 = !DILocation(line: 15, column: 16, scope: !44)
!47 = !DILocation(line: 15, column: 19, scope: !44)
!48 = !DILocation(line: 15, column: 21, scope: !44)
!49 = !DILocation(line: 15, column: 9, scope: !37)
!50 = !DILocation(line: 16, column: 10, scope: !51)
!51 = distinct !DILexicalBlock(scope: !44, file: !3, line: 15, column: 27)
!52 = !DILocation(line: 17, column: 5, scope: !51)
!53 = !DILocation(line: 19, column: 5, scope: !37)
!54 = distinct !DISubprogram(name: "handler2", scope: !3, file: !3, line: 22, type: !38, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !40)
!55 = !DILocalVariable(name: "arg", arg: 1, scope: !54, file: !3, line: 22, type: !5)
!56 = !DILocation(line: 22, column: 22, scope: !54)
!57 = !DILocation(line: 24, column: 9, scope: !58)
!58 = distinct !DILexicalBlock(scope: !54, file: !3, line: 24, column: 9)
!59 = !DILocation(line: 24, column: 11, scope: !58)
!60 = !DILocation(line: 24, column: 16, scope: !58)
!61 = !DILocation(line: 24, column: 19, scope: !58)
!62 = !DILocation(line: 24, column: 21, scope: !58)
!63 = !DILocation(line: 24, column: 9, scope: !54)
!64 = !DILocation(line: 25, column: 10, scope: !65)
!65 = distinct !DILexicalBlock(scope: !58, file: !3, line: 24, column: 27)
!66 = !DILocation(line: 26, column: 5, scope: !65)
!67 = !DILocation(line: 28, column: 5, scope: !54)
!68 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 31, type: !69, scopeLine: 32, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !40)
!69 = !DISubroutineType(types: !70)
!70 = !{!27}
!71 = !DILocalVariable(name: "h", scope: !72, file: !3, line: 33, type: !73)
!72 = distinct !DILexicalBlock(scope: !68, file: !3, line: 33, column: 5)
!73 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !74, line: 31, baseType: !75)
!74 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !76, line: 118, baseType: !77)
!76 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!77 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !78, size: 64)
!78 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !76, line: 103, size: 65536, elements: !79)
!79 = !{!80, !82, !92}
!80 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !78, file: !76, line: 104, baseType: !81, size: 64)
!81 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !78, file: !76, line: 105, baseType: !83, size: 64, offset: 64)
!83 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !84, size: 64)
!84 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !76, line: 57, size: 192, elements: !85)
!85 = !{!86, !90, !91}
!86 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !84, file: !76, line: 58, baseType: !87, size: 64)
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = !DISubroutineType(types: !89)
!89 = !{null, !5}
!90 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !84, file: !76, line: 59, baseType: !5, size: 64, offset: 64)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !84, file: !76, line: 60, baseType: !83, size: 64, offset: 128)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !78, file: !76, line: 106, baseType: !93, size: 65408, offset: 128)
!93 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 65408, elements: !94)
!94 = !{!95}
!95 = !DISubrange(count: 8176)
!96 = !DILocation(line: 33, column: 5, scope: !72)
!97 = !DILocalVariable(name: "h", scope: !98, file: !3, line: 34, type: !73)
!98 = distinct !DILexicalBlock(scope: !68, file: !3, line: 34, column: 5)
!99 = !DILocation(line: 34, column: 5, scope: !98)
!100 = !DILocation(line: 36, column: 7, scope: !68)
!101 = !DILocation(line: 37, column: 7, scope: !68)
!102 = !DILocation(line: 39, column: 5, scope: !68)
!103 = !DILocation(line: 41, column: 5, scope: !68)
