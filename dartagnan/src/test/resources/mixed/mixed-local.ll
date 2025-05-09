; ModuleID = 'benchmarks/mixed/mixed-local.c'
source_filename = "benchmarks/mixed/mixed-local.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%union.anon = type { i32 }

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !9 {
  %1 = alloca i32, align 4
  %2 = alloca %union.anon, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !14, !DIExpression(), !20)
  store i32 123456, ptr %2, align 4, !dbg !21
  store i16 0, ptr %2, align 4, !dbg !22
  %3 = load i32, ptr %2, align 4, !dbg !23
  %4 = icmp eq i32 %3, 65536, !dbg !24
  %5 = zext i1 %4 to i32, !dbg !24
  call void @__VERIFIER_assert(i32 noundef %5), !dbg !25
  ret i32 0, !dbg !26
}

declare void @__VERIFIER_assert(i32 noundef) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!1 = !DIFile(filename: "benchmarks/mixed/mixed-local.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "3a96abc50d1e64ca7d565550c00d8707")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 8, !"PIC Level", i32 2}
!6 = !{i32 7, !"uwtable", i32 1}
!7 = !{i32 7, !"frame-pointer", i32 1}
!8 = !{!"Homebrew clang version 19.1.7"}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 5, type: !10, scopeLine: 6, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !13)
!10 = !DISubroutineType(types: !11)
!11 = !{!12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !{}
!14 = !DILocalVariable(name: "x", scope: !9, file: !1, line: 7, type: !15)
!15 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !9, file: !1, line: 7, size: 32, elements: !16)
!16 = !{!17, !18}
!17 = !DIDerivedType(tag: DW_TAG_member, name: "as_int", scope: !15, file: !1, line: 7, baseType: !12, size: 32)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "as_short", scope: !15, file: !1, line: 7, baseType: !19, size: 16)
!19 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!20 = !DILocation(line: 7, column: 43, scope: !9)
!21 = !DILocation(line: 8, column: 14, scope: !9)
!22 = !DILocation(line: 9, column: 16, scope: !9)
!23 = !DILocation(line: 11, column: 25, scope: !9)
!24 = !DILocation(line: 11, column: 32, scope: !9)
!25 = !DILocation(line: 11, column: 5, scope: !9)
!26 = !DILocation(line: 19, column: 5, scope: !9)
