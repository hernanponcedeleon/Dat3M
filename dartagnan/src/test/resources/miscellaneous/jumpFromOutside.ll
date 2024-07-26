; ModuleID = '/home/drc/git/Dat3M/output/jumpFromOutside.ll'
source_filename = "/home/drc/git/Dat3M/benchmarks/c/miscellaneous/jumpFromOutside.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !20 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !24, metadata !DIExpression()), !dbg !25
  %3 = call i32 @__VERIFIER_nondet_uint(), !dbg !26
  store i32 %3, i32* %2, align 4, !dbg !25
  %4 = load i32, i32* %2, align 4, !dbg !27
  %5 = icmp sle i32 %4, 0, !dbg !29
  br i1 %5, label %6, label %7, !dbg !30

6:                                                ; preds = %0
  store i32 0, i32* %1, align 4, !dbg !31
  br label %21, !dbg !31

7:                                                ; preds = %0
  br label %8, !dbg !33

8:                                                ; preds = %7
  call void @llvm.dbg.label(metadata !34), !dbg !35
  %9 = load i32, i32* %2, align 4, !dbg !36
  %10 = icmp sge i32 %9, 10, !dbg !38
  br i1 %10, label %11, label %12, !dbg !39

11:                                               ; preds = %8
  store i32 5, i32* %2, align 4, !dbg !40
  br label %16, !dbg !42

12:                                               ; preds = %8
  br label %13, !dbg !43

13:                                               ; preds = %19, %12
  call void @llvm.dbg.label(metadata !44), !dbg !45
  %14 = load i32, i32* %2, align 4, !dbg !46
  %15 = add nsw i32 %14, 1, !dbg !47
  store i32 %15, i32* %2, align 4, !dbg !48
  br label %16, !dbg !49

16:                                               ; preds = %13, %11
  call void @llvm.dbg.label(metadata !50), !dbg !51
  %17 = load i32, i32* %2, align 4, !dbg !52
  %18 = icmp slt i32 %17, 10, !dbg !54
  br i1 %18, label %19, label %20, !dbg !55

19:                                               ; preds = %16
  br label %13, !dbg !56

20:                                               ; preds = %16
  store i32 0, i32* %1, align 4, !dbg !58
  br label %21, !dbg !58

21:                                               ; preds = %20, %6
  %22 = load i32, i32* %1, align 4, !dbg !59
  ret i32 %22, !dbg !59
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @__VERIFIER_nondet_uint() #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!12, !13, !14, !15, !16, !17, !18}
!llvm.ident = !{!19}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !5, line: 5, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/Dat3M/benchmarks/c/miscellaneous/jumpFromOutside.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "93cac12dbf00c291fa6fe587b400c1e8")
!4 = !{!0}
!5 = !DIFile(filename: "benchmarks/c/miscellaneous/jumpFromOutside.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "93cac12dbf00c291fa6fe587b400c1e8")
!6 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !7)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !8, line: 26, baseType: !9)
!8 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "", checksumkind: CSK_MD5, checksum: "55bcbdc3159515ebd91d351a70d505f4")
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !10, line: 41, baseType: !11)
!10 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !{i32 7, !"Dwarf Version", i32 5}
!13 = !{i32 2, !"Debug Info Version", i32 3}
!14 = !{i32 1, !"wchar_size", i32 4}
!15 = !{i32 7, !"PIC Level", i32 2}
!16 = !{i32 7, !"PIE Level", i32 2}
!17 = !{i32 7, !"uwtable", i32 1}
!18 = !{i32 7, !"frame-pointer", i32 2}
!19 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!20 = distinct !DISubprogram(name: "main", scope: !5, file: !5, line: 7, type: !21, scopeLine: 8, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!21 = !DISubroutineType(types: !22)
!22 = !{!11}
!23 = !{}
!24 = !DILocalVariable(name: "x", scope: !20, file: !5, line: 9, type: !11)
!25 = !DILocation(line: 9, column: 9, scope: !20)
!26 = !DILocation(line: 9, column: 13, scope: !20)
!27 = !DILocation(line: 11, column: 9, scope: !28)
!28 = distinct !DILexicalBlock(scope: !20, file: !5, line: 11, column: 9)
!29 = !DILocation(line: 11, column: 11, scope: !28)
!30 = !DILocation(line: 11, column: 9, scope: !20)
!31 = !DILocation(line: 12, column: 9, scope: !32)
!32 = distinct !DILexicalBlock(scope: !28, file: !5, line: 11, column: 17)
!33 = !DILocation(line: 11, column: 14, scope: !28)
!34 = !DILabel(scope: !20, name: "A", file: !5, line: 15)
!35 = !DILocation(line: 15, column: 1, scope: !20)
!36 = !DILocation(line: 16, column: 9, scope: !37)
!37 = distinct !DILexicalBlock(scope: !20, file: !5, line: 16, column: 9)
!38 = !DILocation(line: 16, column: 11, scope: !37)
!39 = !DILocation(line: 16, column: 9, scope: !20)
!40 = !DILocation(line: 17, column: 11, scope: !41)
!41 = distinct !DILexicalBlock(scope: !37, file: !5, line: 16, column: 18)
!42 = !DILocation(line: 18, column: 9, scope: !41)
!43 = !DILocation(line: 16, column: 14, scope: !37)
!44 = !DILabel(scope: !20, name: "B", file: !5, line: 20)
!45 = !DILocation(line: 20, column: 1, scope: !20)
!46 = !DILocation(line: 21, column: 9, scope: !20)
!47 = !DILocation(line: 21, column: 11, scope: !20)
!48 = !DILocation(line: 21, column: 7, scope: !20)
!49 = !DILocation(line: 21, column: 5, scope: !20)
!50 = !DILabel(scope: !20, name: "C", file: !5, line: 22)
!51 = !DILocation(line: 22, column: 1, scope: !20)
!52 = !DILocation(line: 23, column: 9, scope: !53)
!53 = distinct !DILexicalBlock(scope: !20, file: !5, line: 23, column: 9)
!54 = !DILocation(line: 23, column: 11, scope: !53)
!55 = !DILocation(line: 23, column: 9, scope: !20)
!56 = !DILocation(line: 24, column: 9, scope: !57)
!57 = distinct !DILexicalBlock(scope: !53, file: !5, line: 23, column: 17)
!58 = !DILocation(line: 27, column: 2, scope: !20)
!59 = !DILocation(line: 28, column: 1, scope: !20)
