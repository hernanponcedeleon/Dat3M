; ModuleID = 'benchmarks/interrupts/misc/multiple_ih_ordered_ihs.c'
source_filename = "benchmarks/interrupts/misc/multiple_ih_ordered_ihs.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@x = global i32 0, align 4, !dbg !0
@z = global i32 0, align 4, !dbg !28
@y = global i32 0, align 4, !dbg !24
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !7
@.str = private unnamed_addr constant [26 x i8] c"multiple_ih_ordered_ihs.c\00", align 1, !dbg !14
@.str.1 = private unnamed_addr constant [7 x i8] c"x == 2\00", align 1, !dbg !19

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !37 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !41, !DIExpression(), !42)
  %3 = load volatile i32, ptr @x, align 4, !dbg !43
  %4 = add nsw i32 %3, 1, !dbg !43
  store volatile i32 %4, ptr @x, align 4, !dbg !43
  store volatile i32 1, ptr @z, align 4, !dbg !44
  ret ptr null, !dbg !45
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler2(ptr noundef %0) #0 !dbg !46 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !47, !DIExpression(), !48)
  %3 = load volatile i32, ptr @x, align 4, !dbg !49
  %4 = add nsw i32 %3, 1, !dbg !49
  store volatile i32 %4, ptr @x, align 4, !dbg !49
  store volatile i32 1, ptr @y, align 4, !dbg !50
  ret ptr null, !dbg !51
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !52 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !55, !DIExpression(), !80)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !80
  %6 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !80
  %7 = load ptr, ptr %2, align 8, !dbg !80
  store ptr %7, ptr %3, align 8, !dbg !80
  %8 = load ptr, ptr %3, align 8, !dbg !80
    #dbg_declare(ptr %4, !81, !DIExpression(), !83)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !83
  %9 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @handler2, ptr noundef null), !dbg !83
  %10 = load ptr, ptr %4, align 8, !dbg !83
  store ptr %10, ptr %5, align 8, !dbg !83
  %11 = load ptr, ptr %5, align 8, !dbg !83
  %12 = load volatile i32, ptr @y, align 4, !dbg !84
  %13 = icmp eq i32 %12, 1, !dbg !86
  br i1 %13, label %14, label %28, !dbg !87

14:                                               ; preds = %0
  %15 = load volatile i32, ptr @z, align 4, !dbg !88
  %16 = icmp eq i32 %15, 1, !dbg !89
  br i1 %16, label %17, label %28, !dbg !90

17:                                               ; preds = %14
  %18 = load volatile i32, ptr @x, align 4, !dbg !91
  %19 = icmp eq i32 %18, 2, !dbg !91
  %20 = xor i1 %19, true, !dbg !91
  %21 = zext i1 %20 to i32, !dbg !91
  %22 = sext i32 %21 to i64, !dbg !91
  %23 = icmp ne i64 %22, 0, !dbg !91
  br i1 %23, label %24, label %26, !dbg !91

24:                                               ; preds = %17
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 35, ptr noundef @.str.1) #3, !dbg !91
  unreachable, !dbg !91

25:                                               ; No predecessors!
  br label %27, !dbg !91

26:                                               ; preds = %17
  br label %27, !dbg !91

27:                                               ; preds = %26, %25
  br label %28, !dbg !93

28:                                               ; preds = %27, %14, %0
  ret i32 0, !dbg !94
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
!3 = !DIFile(filename: "benchmarks/interrupts/misc/multiple_ih_ordered_ihs.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "deb04864b8ef1e79bdd7aa6076f11cb6")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !14, !19, !0, !24, !28}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !3, line: 35, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 40, elements: !12)
!10 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!11 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!12 = !{!13}
!13 = !DISubrange(count: 5)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(scope: null, file: !3, line: 35, type: !16, isLocal: true, isDefinition: true)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 208, elements: !17)
!17 = !{!18}
!18 = !DISubrange(count: 26)
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(scope: null, file: !3, line: 35, type: !21, isLocal: true, isDefinition: true)
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
!37 = distinct !DISubprogram(name: "handler", scope: !3, file: !3, line: 12, type: !38, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !40)
!38 = !DISubroutineType(types: !39)
!39 = !{!5, !5}
!40 = !{}
!41 = !DILocalVariable(name: "arg", arg: 1, scope: !37, file: !3, line: 12, type: !5)
!42 = !DILocation(line: 12, column: 21, scope: !37)
!43 = !DILocation(line: 14, column: 6, scope: !37)
!44 = !DILocation(line: 15, column: 7, scope: !37)
!45 = !DILocation(line: 17, column: 5, scope: !37)
!46 = distinct !DISubprogram(name: "handler2", scope: !3, file: !3, line: 20, type: !38, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !40)
!47 = !DILocalVariable(name: "arg", arg: 1, scope: !46, file: !3, line: 20, type: !5)
!48 = !DILocation(line: 20, column: 22, scope: !46)
!49 = !DILocation(line: 22, column: 6, scope: !46)
!50 = !DILocation(line: 23, column: 7, scope: !46)
!51 = !DILocation(line: 25, column: 5, scope: !46)
!52 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 28, type: !53, scopeLine: 29, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !40)
!53 = !DISubroutineType(types: !54)
!54 = !{!27}
!55 = !DILocalVariable(name: "h", scope: !56, file: !3, line: 30, type: !57)
!56 = distinct !DILexicalBlock(scope: !52, file: !3, line: 30, column: 5)
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !58, line: 31, baseType: !59)
!58 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !60, line: 118, baseType: !61)
!60 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!62 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !60, line: 103, size: 65536, elements: !63)
!63 = !{!64, !66, !76}
!64 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !62, file: !60, line: 104, baseType: !65, size: 64)
!65 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !62, file: !60, line: 105, baseType: !67, size: 64, offset: 64)
!67 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !68, size: 64)
!68 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !60, line: 57, size: 192, elements: !69)
!69 = !{!70, !74, !75}
!70 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !68, file: !60, line: 58, baseType: !71, size: 64)
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !72, size: 64)
!72 = !DISubroutineType(types: !73)
!73 = !{null, !5}
!74 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !68, file: !60, line: 59, baseType: !5, size: 64, offset: 64)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !68, file: !60, line: 60, baseType: !67, size: 64, offset: 128)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !62, file: !60, line: 106, baseType: !77, size: 65408, offset: 128)
!77 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 65408, elements: !78)
!78 = !{!79}
!79 = !DISubrange(count: 8176)
!80 = !DILocation(line: 30, column: 5, scope: !56)
!81 = !DILocalVariable(name: "h", scope: !82, file: !3, line: 31, type: !57)
!82 = distinct !DILexicalBlock(scope: !52, file: !3, line: 31, column: 5)
!83 = !DILocation(line: 31, column: 5, scope: !82)
!84 = !DILocation(line: 33, column: 9, scope: !85)
!85 = distinct !DILexicalBlock(scope: !52, file: !3, line: 33, column: 9)
!86 = !DILocation(line: 33, column: 11, scope: !85)
!87 = !DILocation(line: 33, column: 16, scope: !85)
!88 = !DILocation(line: 33, column: 19, scope: !85)
!89 = !DILocation(line: 33, column: 21, scope: !85)
!90 = !DILocation(line: 33, column: 9, scope: !52)
!91 = !DILocation(line: 35, column: 9, scope: !92)
!92 = distinct !DILexicalBlock(scope: !85, file: !3, line: 33, column: 27)
!93 = !DILocation(line: 36, column: 5, scope: !92)
!94 = !DILocation(line: 38, column: 5, scope: !52)
