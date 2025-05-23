; ModuleID = 'benchmarks/mixed/mixed-local.c'
source_filename = "benchmarks/mixed/mixed-local.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%union.anon = type { i32 }

@x = global %union.anon zeroinitializer, align 4, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !5
@.str = private unnamed_addr constant [14 x i8] c"mixed-local.c\00", align 1, !dbg !12
@.str.1 = private unnamed_addr constant [20 x i8] c"x.as_int == 0x10000\00", align 1, !dbg !17

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !36 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  store volatile i32 123456, ptr @x, align 4, !dbg !39
  store volatile i16 0, ptr @x, align 4, !dbg !40
  %2 = load volatile i32, ptr @x, align 4, !dbg !41
  %3 = icmp eq i32 %2, 65536, !dbg !41
  %4 = xor i1 %3, true, !dbg !41
  %5 = zext i1 %4 to i32, !dbg !41
  %6 = sext i32 %5 to i64, !dbg !41
  %7 = icmp ne i64 %6, 0, !dbg !41
  br i1 %7, label %8, label %10, !dbg !41

8:                                                ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 13, ptr noundef @.str.1) #2, !dbg !41
  unreachable, !dbg !41

9:                                                ; No predecessors!
  br label %11, !dbg !41

10:                                               ; preds = %0
  br label %11, !dbg !41

11:                                               ; preds = %10, %9
  ret i32 0, !dbg !42
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!29, !30, !31, !32, !33, !34}
!llvm.ident = !{!35}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !22, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/mixed/mixed-local.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "ab0496daf8f76f6d8c8d3a268afaaeb4")
!4 = !{!5, !12, !17, !0}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !7, isLocal: true, isDefinition: true)
!7 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 40, elements: !10)
!8 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !9)
!9 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!10 = !{!11}
!11 = !DISubrange(count: 5)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 112, elements: !15)
!15 = !{!16}
!16 = !DISubrange(count: 14)
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !19, isLocal: true, isDefinition: true)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 160, elements: !20)
!20 = !{!21}
!21 = !DISubrange(count: 20)
!22 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !23)
!23 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !3, line: 6, size: 32, elements: !24)
!24 = !{!25, !27}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "as_int", scope: !23, file: !3, line: 6, baseType: !26, size: 32)
!26 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "as_short", scope: !23, file: !3, line: 6, baseType: !28, size: 16)
!28 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!29 = !{i32 7, !"Dwarf Version", i32 5}
!30 = !{i32 2, !"Debug Info Version", i32 3}
!31 = !{i32 1, !"wchar_size", i32 4}
!32 = !{i32 8, !"PIC Level", i32 2}
!33 = !{i32 7, !"uwtable", i32 1}
!34 = !{i32 7, !"frame-pointer", i32 1}
!35 = !{!"Homebrew clang version 19.1.7"}
!36 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 8, type: !37, scopeLine: 9, spFlags: DISPFlagDefinition, unit: !2)
!37 = !DISubroutineType(types: !38)
!38 = !{!26}
!39 = !DILocation(line: 10, column: 14, scope: !36)
!40 = !DILocation(line: 11, column: 16, scope: !36)
!41 = !DILocation(line: 13, column: 5, scope: !36)
!42 = !DILocation(line: 21, column: 5, scope: !36)
