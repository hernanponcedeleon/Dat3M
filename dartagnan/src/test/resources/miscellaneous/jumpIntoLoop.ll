; ModuleID = '/home/drc/git/Dat3M/output/jumpIntoLoop.ll'
source_filename = "/home/drc/git/Dat3M/benchmarks/c/miscellaneous/jumpIntoLoop.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"x <= 5\00", align 1
@.str.1 = private unnamed_addr constant [62 x i8] c"/home/drc/git/Dat3M/benchmarks/c/miscellaneous/jumpIntoLoop.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !20 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !24, metadata !DIExpression()), !dbg !25
  %3 = call i32 @__VERIFIER_nondet_int(), !dbg !26
  store i32 %3, i32* %2, align 4, !dbg !25
  %4 = load i32, i32* %2, align 4, !dbg !27
  %5 = icmp eq i32 %4, 42, !dbg !29
  br i1 %5, label %6, label %7, !dbg !30

6:                                                ; preds = %0
  br label %12, !dbg !31

7:                                                ; preds = %0
  store i32 0, i32* %2, align 4, !dbg !32
  br label %8, !dbg !34

8:                                                ; preds = %15, %7
  %9 = load i32, i32* %2, align 4, !dbg !35
  %10 = icmp slt i32 %9, 5, !dbg !37
  br i1 %10, label %11, label %18, !dbg !38

11:                                               ; preds = %8
  br label %12, !dbg !39

12:                                               ; preds = %11, %6
  call void @llvm.dbg.label(metadata !40), !dbg !42
  %13 = load volatile i32, i32* @x, align 4, !dbg !43
  %14 = add nsw i32 %13, 1, !dbg !43
  store volatile i32 %14, i32* @x, align 4, !dbg !43
  br label %15, !dbg !44

15:                                               ; preds = %12
  %16 = load i32, i32* %2, align 4, !dbg !45
  %17 = add nsw i32 %16, 1, !dbg !45
  store i32 %17, i32* %2, align 4, !dbg !45
  br label %8, !dbg !46, !llvm.loop !47

18:                                               ; preds = %8
  %19 = load volatile i32, i32* @x, align 4, !dbg !50
  %20 = icmp sle i32 %19, 5, !dbg !50
  br i1 %20, label %21, label %22, !dbg !53

21:                                               ; preds = %18
  br label %23, !dbg !53

22:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([62 x i8], [62 x i8]* @.str.1, i64 0, i64 0), i32 noundef 17, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !50
  unreachable, !dbg !50

23:                                               ; preds = %21
  ret i32 0, !dbg !54
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @__VERIFIER_nondet_int() #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!12, !13, !14, !15, !16, !17, !18}
!llvm.ident = !{!19}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !5, line: 5, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/Dat3M/benchmarks/c/miscellaneous/jumpIntoLoop.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "f0dc8ee3df8cc5d1d11ba0339e7a8a1b")
!4 = !{!0}
!5 = !DIFile(filename: "benchmarks/c/miscellaneous/jumpIntoLoop.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "f0dc8ee3df8cc5d1d11ba0339e7a8a1b")
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
!24 = !DILocalVariable(name: "i", scope: !20, file: !5, line: 9, type: !11)
!25 = !DILocation(line: 9, column: 9, scope: !20)
!26 = !DILocation(line: 9, column: 13, scope: !20)
!27 = !DILocation(line: 10, column: 9, scope: !28)
!28 = distinct !DILexicalBlock(scope: !20, file: !5, line: 10, column: 9)
!29 = !DILocation(line: 10, column: 11, scope: !28)
!30 = !DILocation(line: 10, column: 9, scope: !20)
!31 = !DILocation(line: 10, column: 18, scope: !28)
!32 = !DILocation(line: 12, column: 12, scope: !33)
!33 = distinct !DILexicalBlock(scope: !20, file: !5, line: 12, column: 5)
!34 = !DILocation(line: 12, column: 10, scope: !33)
!35 = !DILocation(line: 12, column: 17, scope: !36)
!36 = distinct !DILexicalBlock(scope: !33, file: !5, line: 12, column: 5)
!37 = !DILocation(line: 12, column: 19, scope: !36)
!38 = !DILocation(line: 12, column: 5, scope: !33)
!39 = !DILocation(line: 12, column: 29, scope: !36)
!40 = !DILabel(scope: !41, name: "L", file: !5, line: 13)
!41 = distinct !DILexicalBlock(scope: !36, file: !5, line: 12, column: 29)
!42 = !DILocation(line: 13, column: 1, scope: !41)
!43 = !DILocation(line: 14, column: 6, scope: !41)
!44 = !DILocation(line: 15, column: 5, scope: !41)
!45 = !DILocation(line: 12, column: 25, scope: !36)
!46 = !DILocation(line: 12, column: 5, scope: !36)
!47 = distinct !{!47, !38, !48, !49}
!48 = !DILocation(line: 15, column: 5, scope: !33)
!49 = !{!"llvm.loop.mustprogress"}
!50 = !DILocation(line: 17, column: 5, scope: !51)
!51 = distinct !DILexicalBlock(scope: !52, file: !5, line: 17, column: 5)
!52 = distinct !DILexicalBlock(scope: !20, file: !5, line: 17, column: 5)
!53 = !DILocation(line: 17, column: 5, scope: !52)
!54 = !DILocation(line: 18, column: 2, scope: !20)
