; ModuleID = 'benchmarks/interrupts/misc/multiple_ih_sameIP.c'
source_filename = "benchmarks/interrupts/misc/multiple_ih_sameIP.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@x = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !24
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !7
@.str = private unnamed_addr constant [21 x i8] c"multiple_ih_sameIP.c\00", align 1, !dbg !14
@.str.1 = private unnamed_addr constant [7 x i8] c"y != 2\00", align 1, !dbg !19

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !35 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !39, !DIExpression(), !40)
  %3 = load volatile i32, ptr @x, align 4, !dbg !41
  %4 = icmp eq i32 %3, 1, !dbg !43
  br i1 %4, label %5, label %8, !dbg !44

5:                                                ; preds = %1
  %6 = load volatile i32, ptr @y, align 4, !dbg !45
  %7 = add nsw i32 %6, 1, !dbg !45
  store volatile i32 %7, ptr @y, align 4, !dbg !45
  br label %8, !dbg !47

8:                                                ; preds = %5, %1
  ret ptr null, !dbg !48
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler2(ptr noundef %0) #0 !dbg !49 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !50, !DIExpression(), !51)
  %3 = load volatile i32, ptr @x, align 4, !dbg !52
  %4 = icmp eq i32 %3, 1, !dbg !54
  br i1 %4, label %5, label %8, !dbg !55

5:                                                ; preds = %1
  %6 = load volatile i32, ptr @y, align 4, !dbg !56
  %7 = add nsw i32 %6, 1, !dbg !56
  store volatile i32 %7, ptr @y, align 4, !dbg !56
  br label %8, !dbg !58

8:                                                ; preds = %5, %1
  ret ptr null, !dbg !59
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !60 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !63, !DIExpression(), !88)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !88
  %6 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !88
  %7 = load ptr, ptr %2, align 8, !dbg !88
  store ptr %7, ptr %3, align 8, !dbg !88
  %8 = load ptr, ptr %3, align 8, !dbg !88
    #dbg_declare(ptr %4, !89, !DIExpression(), !91)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !91
  %9 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @handler2, ptr noundef null), !dbg !91
  %10 = load ptr, ptr %4, align 8, !dbg !91
  store ptr %10, ptr %5, align 8, !dbg !91
  %11 = load ptr, ptr %5, align 8, !dbg !91
  store volatile i32 1, ptr @x, align 4, !dbg !92
  store volatile i32 2, ptr @x, align 4, !dbg !93
  %12 = load volatile i32, ptr @y, align 4, !dbg !94
  %13 = icmp ne i32 %12, 2, !dbg !94
  %14 = xor i1 %13, true, !dbg !94
  %15 = zext i1 %14 to i32, !dbg !94
  %16 = sext i32 %15 to i64, !dbg !94
  %17 = icmp ne i64 %16, 0, !dbg !94
  br i1 %17, label %18, label %20, !dbg !94

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 39, ptr noundef @.str.1) #3, !dbg !94
  unreachable, !dbg !94

19:                                               ; No predecessors!
  br label %21, !dbg !94

20:                                               ; preds = %0
  br label %21, !dbg !94

21:                                               ; preds = %20, %19
  ret i32 0, !dbg !95
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
!llvm.module.flags = !{!28, !29, !30, !31, !32, !33}
!llvm.ident = !{!34}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 10, type: !26, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/interrupts/misc/multiple_ih_sameIP.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "bee4b13f755682fbcd5f4329d0d64ce9")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !14, !19, !0, !24}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !3, line: 39, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 40, elements: !12)
!10 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!11 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!12 = !{!13}
!13 = !DISubrange(count: 5)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(scope: null, file: !3, line: 39, type: !16, isLocal: true, isDefinition: true)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 168, elements: !17)
!17 = !{!18}
!18 = !DISubrange(count: 21)
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(scope: null, file: !3, line: 39, type: !21, isLocal: true, isDefinition: true)
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 56, elements: !22)
!22 = !{!23}
!23 = !DISubrange(count: 7)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 10, type: !26, isLocal: false, isDefinition: true)
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
!41 = !DILocation(line: 14, column: 9, scope: !42)
!42 = distinct !DILexicalBlock(scope: !35, file: !3, line: 14, column: 9)
!43 = !DILocation(line: 14, column: 11, scope: !42)
!44 = !DILocation(line: 14, column: 9, scope: !35)
!45 = !DILocation(line: 15, column: 10, scope: !46)
!46 = distinct !DILexicalBlock(scope: !42, file: !3, line: 14, column: 17)
!47 = !DILocation(line: 16, column: 5, scope: !46)
!48 = !DILocation(line: 18, column: 5, scope: !35)
!49 = distinct !DISubprogram(name: "handler2", scope: !3, file: !3, line: 21, type: !36, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !38)
!50 = !DILocalVariable(name: "arg", arg: 1, scope: !49, file: !3, line: 21, type: !5)
!51 = !DILocation(line: 21, column: 22, scope: !49)
!52 = !DILocation(line: 23, column: 9, scope: !53)
!53 = distinct !DILexicalBlock(scope: !49, file: !3, line: 23, column: 9)
!54 = !DILocation(line: 23, column: 11, scope: !53)
!55 = !DILocation(line: 23, column: 9, scope: !49)
!56 = !DILocation(line: 24, column: 10, scope: !57)
!57 = distinct !DILexicalBlock(scope: !53, file: !3, line: 23, column: 17)
!58 = !DILocation(line: 25, column: 5, scope: !57)
!59 = !DILocation(line: 27, column: 5, scope: !49)
!60 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 30, type: !61, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !38)
!61 = !DISubroutineType(types: !62)
!62 = !{!27}
!63 = !DILocalVariable(name: "h", scope: !64, file: !3, line: 32, type: !65)
!64 = distinct !DILexicalBlock(scope: !60, file: !3, line: 32, column: 5)
!65 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !66, line: 31, baseType: !67)
!66 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !68, line: 118, baseType: !69)
!68 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 64)
!70 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !68, line: 103, size: 65536, elements: !71)
!71 = !{!72, !74, !84}
!72 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !70, file: !68, line: 104, baseType: !73, size: 64)
!73 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !70, file: !68, line: 105, baseType: !75, size: 64, offset: 64)
!75 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 64)
!76 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !68, line: 57, size: 192, elements: !77)
!77 = !{!78, !82, !83}
!78 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !76, file: !68, line: 58, baseType: !79, size: 64)
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!80 = !DISubroutineType(types: !81)
!81 = !{null, !5}
!82 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !76, file: !68, line: 59, baseType: !5, size: 64, offset: 64)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !76, file: !68, line: 60, baseType: !75, size: 64, offset: 128)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !70, file: !68, line: 106, baseType: !85, size: 65408, offset: 128)
!85 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 65408, elements: !86)
!86 = !{!87}
!87 = !DISubrange(count: 8176)
!88 = !DILocation(line: 32, column: 5, scope: !64)
!89 = !DILocalVariable(name: "h", scope: !90, file: !3, line: 33, type: !65)
!90 = distinct !DILexicalBlock(scope: !60, file: !3, line: 33, column: 5)
!91 = !DILocation(line: 33, column: 5, scope: !90)
!92 = !DILocation(line: 35, column: 7, scope: !60)
!93 = !DILocation(line: 37, column: 7, scope: !60)
!94 = !DILocation(line: 39, column: 5, scope: !60)
!95 = !DILocation(line: 41, column: 5, scope: !60)
