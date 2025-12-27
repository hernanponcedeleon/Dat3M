; ModuleID = '/home/drc/git/Dat3M/benchmarks/miscellaneous/zero-extension.c'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/zero-extension.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = dso_local global i8 -128, align 1, !dbg !0
@b = dso_local global i8 -128, align 1, !dbg !5
@c = dso_local global i8 -128, align 1, !dbg !9
@.str = private unnamed_addr constant [9 x i8] c"a == 128\00", align 1
@.str.1 = private unnamed_addr constant [62 x i8] c"/home/drc/git/Dat3M/benchmarks/miscellaneous/zero-extension.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@.str.2 = private unnamed_addr constant [10 x i8] c"b == -128\00", align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"c == -128\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !20 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %2 = load i8, i8* @a, align 1, !dbg !25
  %3 = zext i8 %2 to i32, !dbg !25
  %4 = icmp eq i32 %3, 128, !dbg !25
  br i1 %4, label %5, label %6, !dbg !28

5:                                                ; preds = %0
  br label %7, !dbg !28

6:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([62 x i8], [62 x i8]* @.str.1, i64 0, i64 0), i32 noundef 8, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #2, !dbg !25
  unreachable, !dbg !25

7:                                                ; preds = %5
  %8 = load i8, i8* @b, align 1, !dbg !29
  %9 = sext i8 %8 to i32, !dbg !29
  %10 = icmp eq i32 %9, -128, !dbg !29
  br i1 %10, label %11, label %12, !dbg !32

11:                                               ; preds = %7
  br label %13, !dbg !32

12:                                               ; preds = %7
  call void @__assert_fail(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([62 x i8], [62 x i8]* @.str.1, i64 0, i64 0), i32 noundef 9, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #2, !dbg !29
  unreachable, !dbg !29

13:                                               ; preds = %11
  %14 = load i8, i8* @c, align 1, !dbg !33
  %15 = sext i8 %14 to i32, !dbg !33
  %16 = icmp eq i32 %15, -128, !dbg !33
  br i1 %16, label %17, label %18, !dbg !36

17:                                               ; preds = %13
  br label %19, !dbg !36

18:                                               ; preds = %13
  call void @__assert_fail(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([62 x i8], [62 x i8]* @.str.1, i64 0, i64 0), i32 noundef 10, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #2, !dbg !33
  unreachable, !dbg !33

19:                                               ; preds = %17
  ret i32 0, !dbg !37
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!12, !13, !14, !15, !16, !17, !18}
!llvm.ident = !{!19}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !7, line: 3, type: !11, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/Dat3M/benchmarks/miscellaneous/zero-extension.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "28ccfba3c22d4192486b14f19d27de2d")
!4 = !{!0, !5, !9}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !7, line: 4, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "benchmarks/miscellaneous/zero-extension.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "28ccfba3c22d4192486b14f19d27de2d")
!8 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!9 = !DIGlobalVariableExpression(var: !10, expr: !DIExpression())
!10 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !7, line: 5, type: !8, isLocal: false, isDefinition: true)
!11 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!12 = !{i32 7, !"Dwarf Version", i32 5}
!13 = !{i32 2, !"Debug Info Version", i32 3}
!14 = !{i32 1, !"wchar_size", i32 4}
!15 = !{i32 7, !"PIC Level", i32 2}
!16 = !{i32 7, !"PIE Level", i32 2}
!17 = !{i32 7, !"uwtable", i32 1}
!18 = !{i32 7, !"frame-pointer", i32 2}
!19 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!20 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 7, type: !21, scopeLine: 7, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!21 = !DISubroutineType(types: !22)
!22 = !{!23}
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !{}
!25 = !DILocation(line: 8, column: 5, scope: !26)
!26 = distinct !DILexicalBlock(scope: !27, file: !7, line: 8, column: 5)
!27 = distinct !DILexicalBlock(scope: !20, file: !7, line: 8, column: 5)
!28 = !DILocation(line: 8, column: 5, scope: !27)
!29 = !DILocation(line: 9, column: 5, scope: !30)
!30 = distinct !DILexicalBlock(scope: !31, file: !7, line: 9, column: 5)
!31 = distinct !DILexicalBlock(scope: !20, file: !7, line: 9, column: 5)
!32 = !DILocation(line: 9, column: 5, scope: !31)
!33 = !DILocation(line: 10, column: 5, scope: !34)
!34 = distinct !DILexicalBlock(scope: !35, file: !7, line: 10, column: 5)
!35 = distinct !DILexicalBlock(scope: !20, file: !7, line: 10, column: 5)
!36 = !DILocation(line: 10, column: 5, scope: !35)
!37 = !DILocation(line: 11, column: 5, scope: !20)
