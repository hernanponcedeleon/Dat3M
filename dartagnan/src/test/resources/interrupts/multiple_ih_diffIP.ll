; ModuleID = 'benchmarks/interrupts/misc/multiple_ih_diffIP.c'
source_filename = "benchmarks/interrupts/misc/multiple_ih_diffIP.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@x = global i32 0, align 4, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !7
@.str = private unnamed_addr constant [21 x i8] c"multiple_ih_diffIP.c\00", align 1, !dbg !14
@.str.1 = private unnamed_addr constant [35 x i8] c"(r1 == 0 || r2 == 0) || (r1 == r2)\00", align 1, !dbg !19

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !33 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !37, !DIExpression(), !38)
  store volatile i32 1, ptr @x, align 4, !dbg !39
  ret ptr null, !dbg !40
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler2(ptr noundef %0) #0 !dbg !41 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !42, !DIExpression(), !43)
  store volatile i32 2, ptr @x, align 4, !dbg !44
  ret ptr null, !dbg !45
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !46 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !49, !DIExpression(), !74)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !74
  %8 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !74
  %9 = load ptr, ptr %2, align 8, !dbg !74
  store ptr %9, ptr %3, align 8, !dbg !74
  %10 = load ptr, ptr %3, align 8, !dbg !74
    #dbg_declare(ptr %4, !75, !DIExpression(), !77)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !77
  %11 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @handler2, ptr noundef null), !dbg !77
  %12 = load ptr, ptr %4, align 8, !dbg !77
  store ptr %12, ptr %5, align 8, !dbg !77
  %13 = load ptr, ptr %5, align 8, !dbg !77
    #dbg_declare(ptr %6, !78, !DIExpression(), !79)
  %14 = load volatile i32, ptr @x, align 4, !dbg !80
  store i32 %14, ptr %6, align 4, !dbg !79
    #dbg_declare(ptr %7, !81, !DIExpression(), !82)
  %15 = load volatile i32, ptr @x, align 4, !dbg !83
  store i32 %15, ptr %7, align 4, !dbg !82
  %16 = load i32, ptr %6, align 4, !dbg !84
  %17 = icmp eq i32 %16, 0, !dbg !84
  br i1 %17, label %25, label %18, !dbg !84

18:                                               ; preds = %0
  %19 = load i32, ptr %7, align 4, !dbg !84
  %20 = icmp eq i32 %19, 0, !dbg !84
  br i1 %20, label %25, label %21, !dbg !84

21:                                               ; preds = %18
  %22 = load i32, ptr %6, align 4, !dbg !84
  %23 = load i32, ptr %7, align 4, !dbg !84
  %24 = icmp eq i32 %22, %23, !dbg !84
  br label %25, !dbg !84

25:                                               ; preds = %21, %18, %0
  %26 = phi i1 [ true, %18 ], [ true, %0 ], [ %24, %21 ]
  %27 = xor i1 %26, true, !dbg !84
  %28 = zext i1 %27 to i32, !dbg !84
  %29 = sext i32 %28 to i64, !dbg !84
  %30 = icmp ne i64 %29, 0, !dbg !84
  br i1 %30, label %31, label %33, !dbg !84

31:                                               ; preds = %25
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 36, ptr noundef @.str.1) #3, !dbg !84
  unreachable, !dbg !84

32:                                               ; No predecessors!
  br label %34, !dbg !84

33:                                               ; preds = %25
  br label %34, !dbg !84

34:                                               ; preds = %33, %32
  ret i32 0, !dbg !85
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
!llvm.module.flags = !{!26, !27, !28, !29, !30, !31}
!llvm.ident = !{!32}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 10, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/interrupts/misc/multiple_ih_diffIP.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "60aee09eab70a799004c08da25fd11f3")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !14, !19, !0}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !3, line: 36, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 40, elements: !12)
!10 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!11 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!12 = !{!13}
!13 = !DISubrange(count: 5)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(scope: null, file: !3, line: 36, type: !16, isLocal: true, isDefinition: true)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 168, elements: !17)
!17 = !{!18}
!18 = !DISubrange(count: 21)
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(scope: null, file: !3, line: 36, type: !21, isLocal: true, isDefinition: true)
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 280, elements: !22)
!22 = !{!23}
!23 = !DISubrange(count: 35)
!24 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !25)
!25 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!26 = !{i32 7, !"Dwarf Version", i32 5}
!27 = !{i32 2, !"Debug Info Version", i32 3}
!28 = !{i32 1, !"wchar_size", i32 4}
!29 = !{i32 8, !"PIC Level", i32 2}
!30 = !{i32 7, !"uwtable", i32 1}
!31 = !{i32 7, !"frame-pointer", i32 1}
!32 = !{!"Homebrew clang version 19.1.7"}
!33 = distinct !DISubprogram(name: "handler", scope: !3, file: !3, line: 12, type: !34, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !36)
!34 = !DISubroutineType(types: !35)
!35 = !{!5, !5}
!36 = !{}
!37 = !DILocalVariable(name: "arg", arg: 1, scope: !33, file: !3, line: 12, type: !5)
!38 = !DILocation(line: 12, column: 21, scope: !33)
!39 = !DILocation(line: 14, column: 7, scope: !33)
!40 = !DILocation(line: 16, column: 5, scope: !33)
!41 = distinct !DISubprogram(name: "handler2", scope: !3, file: !3, line: 19, type: !34, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !36)
!42 = !DILocalVariable(name: "arg", arg: 1, scope: !41, file: !3, line: 19, type: !5)
!43 = !DILocation(line: 19, column: 22, scope: !41)
!44 = !DILocation(line: 21, column: 7, scope: !41)
!45 = !DILocation(line: 23, column: 5, scope: !41)
!46 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 26, type: !47, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !36)
!47 = !DISubroutineType(types: !48)
!48 = !{!25}
!49 = !DILocalVariable(name: "h", scope: !50, file: !3, line: 28, type: !51)
!50 = distinct !DILexicalBlock(scope: !46, file: !3, line: 28, column: 5)
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !52, line: 31, baseType: !53)
!52 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!53 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !54, line: 118, baseType: !55)
!54 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!56 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !54, line: 103, size: 65536, elements: !57)
!57 = !{!58, !60, !70}
!58 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !56, file: !54, line: 104, baseType: !59, size: 64)
!59 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !56, file: !54, line: 105, baseType: !61, size: 64, offset: 64)
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!62 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !54, line: 57, size: 192, elements: !63)
!63 = !{!64, !68, !69}
!64 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !62, file: !54, line: 58, baseType: !65, size: 64)
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!66 = !DISubroutineType(types: !67)
!67 = !{null, !5}
!68 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !62, file: !54, line: 59, baseType: !5, size: 64, offset: 64)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !62, file: !54, line: 60, baseType: !61, size: 64, offset: 128)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !56, file: !54, line: 106, baseType: !71, size: 65408, offset: 128)
!71 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 65408, elements: !72)
!72 = !{!73}
!73 = !DISubrange(count: 8176)
!74 = !DILocation(line: 28, column: 5, scope: !50)
!75 = !DILocalVariable(name: "h", scope: !76, file: !3, line: 29, type: !51)
!76 = distinct !DILexicalBlock(scope: !46, file: !3, line: 29, column: 5)
!77 = !DILocation(line: 29, column: 5, scope: !76)
!78 = !DILocalVariable(name: "r1", scope: !46, file: !3, line: 31, type: !25)
!79 = !DILocation(line: 31, column: 9, scope: !46)
!80 = !DILocation(line: 31, column: 14, scope: !46)
!81 = !DILocalVariable(name: "r2", scope: !46, file: !3, line: 33, type: !25)
!82 = !DILocation(line: 33, column: 9, scope: !46)
!83 = !DILocation(line: 33, column: 14, scope: !46)
!84 = !DILocation(line: 36, column: 5, scope: !46)
!85 = !DILocation(line: 38, column: 5, scope: !46)
