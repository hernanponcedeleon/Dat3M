; ModuleID = '/home/ponce/git/Dat3M/output/ctlz.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/ctlz.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 1, align 4, !dbg !0
@y = dso_local global i32 2147483647, align 4, !dbg !6
@z = dso_local global i32 -2147483648, align 4, !dbg !15
@u = dso_local global i32 0, align 4, !dbg !17
@.str = private unnamed_addr constant [8 x i8] c"u == 31\00", align 1
@.str.1 = private unnamed_addr constant [56 x i8] c"/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/ctlz.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"u == 1\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"u == 0\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !23 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %2 = load volatile i32, i32* @x, align 4, !dbg !26
  %3 = call i32 @llvm.ctlz.i32(i32 %2, i1 true), !dbg !27
  store volatile i32 %3, i32* @u, align 4, !dbg !28
  %4 = load volatile i32, i32* @u, align 4, !dbg !29
  %5 = icmp eq i32 %4, 31, !dbg !29
  br i1 %5, label %6, label %7, !dbg !32

6:                                                ; preds = %0
  br label %8, !dbg !32

7:                                                ; preds = %0
  call void @__assert_fail(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([56 x i8], [56 x i8]* @.str.1, i64 0, i64 0), i32 13, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #3, !dbg !29
  unreachable, !dbg !29

8:                                                ; preds = %6
  %9 = load volatile i32, i32* @y, align 4, !dbg !33
  %10 = call i32 @llvm.ctlz.i32(i32 %9, i1 true), !dbg !34
  store volatile i32 %10, i32* @u, align 4, !dbg !35
  %11 = load volatile i32, i32* @u, align 4, !dbg !36
  %12 = icmp eq i32 %11, 1, !dbg !36
  br i1 %12, label %13, label %14, !dbg !39

13:                                               ; preds = %8
  br label %15, !dbg !39

14:                                               ; preds = %8
  call void @__assert_fail(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i64 0, i64 0), i8* getelementptr inbounds ([56 x i8], [56 x i8]* @.str.1, i64 0, i64 0), i32 16, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #3, !dbg !36
  unreachable, !dbg !36

15:                                               ; preds = %13
  %16 = load volatile i32, i32* @z, align 4, !dbg !40
  %17 = call i32 @llvm.ctlz.i32(i32 %16, i1 true), !dbg !41
  store volatile i32 %17, i32* @u, align 4, !dbg !42
  %18 = load volatile i32, i32* @u, align 4, !dbg !43
  %19 = icmp eq i32 %18, 0, !dbg !43
  br i1 %19, label %20, label %21, !dbg !46

20:                                               ; preds = %15
  br label %22, !dbg !46

21:                                               ; preds = %15
  call void @__assert_fail(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i64 0, i64 0), i8* getelementptr inbounds ([56 x i8], [56 x i8]* @.str.1, i64 0, i64 0), i32 19, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #3, !dbg !43
  unreachable, !dbg !43

22:                                               ; preds = %20
  ret i32 0, !dbg !47
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare i32 @llvm.ctlz.i32(i32, i1 immarg) #1

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #2

attributes #0 = { noinline nounwind uwtable "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!19, !20, !21}
!llvm.ident = !{!22}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !8, line: 4, type: !9, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 12.0.0-3ubuntu1~20.04.5", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/ctlz.c", directory: "/home/ponce/git/Dat3M")
!4 = !{}
!5 = !{!0, !6, !15, !17}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !8, line: 5, type: !9, isLocal: false, isDefinition: true)
!8 = !DIFile(filename: "benchmarks/c/miscellaneous/ctlz.c", directory: "/home/ponce/git/Dat3M")
!9 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !10)
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !11, line: 26, baseType: !12)
!11 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !13, line: 41, baseType: !14)
!13 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !DIGlobalVariableExpression(var: !16, expr: !DIExpression())
!16 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !8, line: 6, type: !9, isLocal: false, isDefinition: true)
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(name: "u", scope: !2, file: !8, line: 7, type: !9, isLocal: false, isDefinition: true)
!19 = !{i32 7, !"Dwarf Version", i32 4}
!20 = !{i32 2, !"Debug Info Version", i32 3}
!21 = !{i32 1, !"wchar_size", i32 4}
!22 = !{!"Ubuntu clang version 12.0.0-3ubuntu1~20.04.5"}
!23 = distinct !DISubprogram(name: "main", scope: !8, file: !8, line: 9, type: !24, scopeLine: 10, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!24 = !DISubroutineType(types: !25)
!25 = !{!14}
!26 = !DILocation(line: 12, column: 23, scope: !23)
!27 = !DILocation(line: 12, column: 9, scope: !23)
!28 = !DILocation(line: 12, column: 7, scope: !23)
!29 = !DILocation(line: 13, column: 2, scope: !30)
!30 = distinct !DILexicalBlock(scope: !31, file: !8, line: 13, column: 2)
!31 = distinct !DILexicalBlock(scope: !23, file: !8, line: 13, column: 2)
!32 = !DILocation(line: 13, column: 2, scope: !31)
!33 = !DILocation(line: 15, column: 23, scope: !23)
!34 = !DILocation(line: 15, column: 9, scope: !23)
!35 = !DILocation(line: 15, column: 7, scope: !23)
!36 = !DILocation(line: 16, column: 2, scope: !37)
!37 = distinct !DILexicalBlock(scope: !38, file: !8, line: 16, column: 2)
!38 = distinct !DILexicalBlock(scope: !23, file: !8, line: 16, column: 2)
!39 = !DILocation(line: 16, column: 2, scope: !38)
!40 = !DILocation(line: 18, column: 23, scope: !23)
!41 = !DILocation(line: 18, column: 9, scope: !23)
!42 = !DILocation(line: 18, column: 7, scope: !23)
!43 = !DILocation(line: 19, column: 2, scope: !44)
!44 = distinct !DILexicalBlock(scope: !45, file: !8, line: 19, column: 2)
!45 = distinct !DILexicalBlock(scope: !23, file: !8, line: 19, column: 2)
!46 = !DILocation(line: 19, column: 2, scope: !45)
!47 = !DILocation(line: 21, column: 2, scope: !23)
