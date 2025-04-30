; ModuleID = 'benchmarks/interrupts/misc/reorder_same_loc.c'
source_filename = "benchmarks/interrupts/misc/reorder_same_loc.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@x = global i32 0, align 4, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !7
@.str = private unnamed_addr constant [19 x i8] c"reorder_same_loc.c\00", align 1, !dbg !14
@.str.1 = private unnamed_addr constant [7 x i8] c"x == 2\00", align 1, !dbg !19

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !33 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !37, !DIExpression(), !38)
  ret ptr null, !dbg !39
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !40 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !43, !DIExpression(), !68)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !68
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !68
  %5 = load ptr, ptr %2, align 8, !dbg !68
  store ptr %5, ptr %3, align 8, !dbg !68
  %6 = load ptr, ptr %3, align 8, !dbg !68
  store volatile i32 1, ptr @x, align 4, !dbg !69
  store volatile i32 2, ptr @x, align 4, !dbg !70
  %7 = load volatile i32, ptr @x, align 4, !dbg !71
  %8 = icmp eq i32 %7, 2, !dbg !71
  %9 = xor i1 %8, true, !dbg !71
  %10 = zext i1 %9 to i32, !dbg !71
  %11 = sext i32 %10 to i64, !dbg !71
  %12 = icmp ne i64 %11, 0, !dbg !71
  br i1 %12, label %13, label %15, !dbg !71

13:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 24, ptr noundef @.str.1) #3, !dbg !71
  unreachable, !dbg !71

14:                                               ; No predecessors!
  br label %16, !dbg !71

15:                                               ; preds = %0
  br label %16, !dbg !71

16:                                               ; preds = %15, %14
  ret i32 0, !dbg !72
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
!3 = !DIFile(filename: "benchmarks/interrupts/misc/reorder_same_loc.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "c01ce7442142d5ee5e938dd8267bb2dd")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !14, !19, !0}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 40, elements: !12)
!10 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!11 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!12 = !{!13}
!13 = !DISubrange(count: 5)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !16, isLocal: true, isDefinition: true)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 152, elements: !17)
!17 = !{!18}
!18 = !DISubrange(count: 19)
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !21, isLocal: true, isDefinition: true)
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
!33 = distinct !DISubprogram(name: "handler", scope: !3, file: !3, line: 12, type: !34, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !36)
!34 = !DISubroutineType(types: !35)
!35 = !{!5, !5}
!36 = !{}
!37 = !DILocalVariable(name: "arg", arg: 1, scope: !33, file: !3, line: 12, type: !5)
!38 = !DILocation(line: 12, column: 21, scope: !33)
!39 = !DILocation(line: 14, column: 5, scope: !33)
!40 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 17, type: !41, scopeLine: 18, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !36)
!41 = !DISubroutineType(types: !42)
!42 = !{!25}
!43 = !DILocalVariable(name: "h", scope: !44, file: !3, line: 19, type: !45)
!44 = distinct !DILexicalBlock(scope: !40, file: !3, line: 19, column: 5)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !46, line: 31, baseType: !47)
!46 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!47 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !48, line: 118, baseType: !49)
!48 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!50 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !48, line: 103, size: 65536, elements: !51)
!51 = !{!52, !54, !64}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !50, file: !48, line: 104, baseType: !53, size: 64)
!53 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !50, file: !48, line: 105, baseType: !55, size: 64, offset: 64)
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!56 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !48, line: 57, size: 192, elements: !57)
!57 = !{!58, !62, !63}
!58 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !56, file: !48, line: 58, baseType: !59, size: 64)
!59 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!60 = !DISubroutineType(types: !61)
!61 = !{null, !5}
!62 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !56, file: !48, line: 59, baseType: !5, size: 64, offset: 64)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !56, file: !48, line: 60, baseType: !55, size: 64, offset: 128)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !50, file: !48, line: 106, baseType: !65, size: 65408, offset: 128)
!65 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 65408, elements: !66)
!66 = !{!67}
!67 = !DISubrange(count: 8176)
!68 = !DILocation(line: 19, column: 5, scope: !44)
!69 = !DILocation(line: 21, column: 7, scope: !40)
!70 = !DILocation(line: 22, column: 7, scope: !40)
!71 = !DILocation(line: 24, column: 5, scope: !40)
!72 = !DILocation(line: 26, column: 5, scope: !40)
