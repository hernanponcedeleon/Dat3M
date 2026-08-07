; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/zext.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/zext.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx16.0.0"

@n = global i32 -858993459, align 4, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !5
@.str = private unnamed_addr constant [7 x i8] c"zext.c\00", align 1, !dbg !13
@.str.1 = private unnamed_addr constant [24 x i8] c"!(n < (4294967296 / 5))\00", align 1, !dbg !18

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !31 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %2 = load i32, ptr @n, align 4, !dbg !36
  %3 = zext i32 %2 to i64, !dbg !36
  %4 = icmp slt i64 %3, 858993459, !dbg !36
  %5 = xor i1 %4, true, !dbg !36
  %6 = xor i1 %5, true, !dbg !36
  %7 = zext i1 %6 to i32, !dbg !36
  %8 = sext i32 %7 to i64, !dbg !36
  %9 = icmp ne i64 %8, 0, !dbg !36
  br i1 %9, label %10, label %12, !dbg !36

10:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 7, ptr noundef @.str.1) #2, !dbg !36
  unreachable, !dbg !36

11:                                               ; No predecessors!
  br label %13, !dbg !36

12:                                               ; preds = %0
  br label %13, !dbg !36

13:                                               ; preds = %12, %11
  ret i32 0, !dbg !37
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #2 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!24, !25, !26, !27, !28, !29}
!llvm.ident = !{!30}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "n", scope: !2, file: !7, line: 4, type: !23, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 16.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/zext.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!0, !5, !13, !18}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(scope: null, file: !7, line: 7, type: !8, isLocal: true, isDefinition: true)
!7 = !DIFile(filename: "benchmarks/miscellaneous/zext.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!8 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 40, elements: !11)
!9 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !10)
!10 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!11 = !{!12}
!12 = !DISubrange(count: 5)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(scope: null, file: !7, line: 7, type: !15, isLocal: true, isDefinition: true)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 56, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 7)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !7, line: 7, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 192, elements: !21)
!21 = !{!22}
!22 = !DISubrange(count: 24)
!23 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!24 = !{i32 7, !"Dwarf Version", i32 4}
!25 = !{i32 2, !"Debug Info Version", i32 3}
!26 = !{i32 1, !"wchar_size", i32 4}
!27 = !{i32 8, !"PIC Level", i32 2}
!28 = !{i32 7, !"uwtable", i32 1}
!29 = !{i32 7, !"frame-pointer", i32 1}
!30 = !{!"Homebrew clang version 16.0.6"}
!31 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 6, type: !32, scopeLine: 6, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !35)
!32 = !DISubroutineType(types: !33)
!33 = !{!34}
!34 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!35 = !{}
!36 = !DILocation(line: 7, column: 3, scope: !31)
!37 = !DILocation(line: 8, column: 3, scope: !31)
