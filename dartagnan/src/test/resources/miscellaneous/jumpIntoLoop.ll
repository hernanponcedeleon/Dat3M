; ModuleID = '/home/ponce/git/Dat3M/output/jumpIntoLoop.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/miscellaneous/jumpIntoLoop.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0
@.str = private unnamed_addr constant [54 x i8] c"(!jumpIntoLoop || x == 5) && (jumpIntoLoop || x == 4)\00", align 1
@.str.1 = private unnamed_addr constant [62 x i8] c"/home/ponce/git/Dat3M/benchmarks/miscellaneous/jumpIntoLoop.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !17 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !20, metadata !DIExpression()), !dbg !21
  store i32 0, i32* %2, align 4, !dbg !21
  call void @llvm.dbg.declare(metadata i32* %3, metadata !22, metadata !DIExpression()), !dbg !23
  %4 = call zeroext i1 @__VERIFIER_nondet_bool(), !dbg !24
  %5 = zext i1 %4 to i32, !dbg !24
  store i32 %5, i32* %3, align 4, !dbg !23
  %6 = load i32, i32* %3, align 4, !dbg !25
  %7 = icmp ne i32 %6, 0, !dbg !25
  br i1 %7, label %8, label %9, !dbg !27

8:                                                ; preds = %0
  br label %14, !dbg !28

9:                                                ; preds = %0
  store i32 1, i32* %2, align 4, !dbg !29
  br label %10, !dbg !31

10:                                               ; preds = %17, %9
  %11 = load i32, i32* %2, align 4, !dbg !32
  %12 = icmp slt i32 %11, 5, !dbg !34
  br i1 %12, label %13, label %20, !dbg !35

13:                                               ; preds = %10
  br label %14, !dbg !36

14:                                               ; preds = %13, %8
  call void @llvm.dbg.label(metadata !37), !dbg !39
  %15 = load volatile i32, i32* @x, align 4, !dbg !40
  %16 = add nsw i32 %15, 1, !dbg !40
  store volatile i32 %16, i32* @x, align 4, !dbg !40
  br label %17, !dbg !41

17:                                               ; preds = %14
  %18 = load i32, i32* %2, align 4, !dbg !42
  %19 = add nsw i32 %18, 1, !dbg !42
  store i32 %19, i32* %2, align 4, !dbg !42
  br label %10, !dbg !43, !llvm.loop !44

20:                                               ; preds = %10
  %21 = load i32, i32* %3, align 4, !dbg !47
  %22 = icmp ne i32 %21, 0, !dbg !47
  br i1 %22, label %23, label %26, !dbg !47

23:                                               ; preds = %20
  %24 = load volatile i32, i32* @x, align 4, !dbg !47
  %25 = icmp eq i32 %24, 5, !dbg !47
  br i1 %25, label %26, label %33, !dbg !47

26:                                               ; preds = %23, %20
  %27 = load i32, i32* %3, align 4, !dbg !47
  %28 = icmp ne i32 %27, 0, !dbg !47
  br i1 %28, label %32, label %29, !dbg !47

29:                                               ; preds = %26
  %30 = load volatile i32, i32* @x, align 4, !dbg !47
  %31 = icmp eq i32 %30, 4, !dbg !47
  br i1 %31, label %32, label %33, !dbg !50

32:                                               ; preds = %29, %26
  br label %34, !dbg !50

33:                                               ; preds = %29, %23
  call void @__assert_fail(i8* getelementptr inbounds ([54 x i8], [54 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([62 x i8], [62 x i8]* @.str.1, i64 0, i64 0), i32 18, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !47
  unreachable, !dbg !47

34:                                               ; preds = %32
  ret i32 0, !dbg !51
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local zeroext i1 @__VERIFIER_nondet_bool() #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #3

attributes #0 = { noinline nounwind uwtable "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!13, !14, !15}
!llvm.ident = !{!16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !6, line: 5, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 12.0.0-3ubuntu1~20.04.5", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/miscellaneous/jumpIntoLoop.c", directory: "/home/ponce/git/Dat3M")
!4 = !{}
!5 = !{!0}
!6 = !DIFile(filename: "benchmarks/miscellaneous/jumpIntoLoop.c", directory: "/home/ponce/git/Dat3M")
!7 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !8)
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !9, line: 26, baseType: !10)
!9 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !11, line: 41, baseType: !12)
!11 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !{i32 7, !"Dwarf Version", i32 4}
!14 = !{i32 2, !"Debug Info Version", i32 3}
!15 = !{i32 1, !"wchar_size", i32 4}
!16 = !{!"Ubuntu clang version 12.0.0-3ubuntu1~20.04.5"}
!17 = distinct !DISubprogram(name: "main", scope: !6, file: !6, line: 7, type: !18, scopeLine: 8, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!18 = !DISubroutineType(types: !19)
!19 = !{!12}
!20 = !DILocalVariable(name: "i", scope: !17, file: !6, line: 9, type: !12)
!21 = !DILocation(line: 9, column: 9, scope: !17)
!22 = !DILocalVariable(name: "jumpIntoLoop", scope: !17, file: !6, line: 10, type: !12)
!23 = !DILocation(line: 10, column: 9, scope: !17)
!24 = !DILocation(line: 10, column: 24, scope: !17)
!25 = !DILocation(line: 11, column: 9, scope: !26)
!26 = distinct !DILexicalBlock(scope: !17, file: !6, line: 11, column: 9)
!27 = !DILocation(line: 11, column: 9, scope: !17)
!28 = !DILocation(line: 11, column: 23, scope: !26)
!29 = !DILocation(line: 13, column: 12, scope: !30)
!30 = distinct !DILexicalBlock(scope: !17, file: !6, line: 13, column: 5)
!31 = !DILocation(line: 13, column: 10, scope: !30)
!32 = !DILocation(line: 13, column: 17, scope: !33)
!33 = distinct !DILexicalBlock(scope: !30, file: !6, line: 13, column: 5)
!34 = !DILocation(line: 13, column: 19, scope: !33)
!35 = !DILocation(line: 13, column: 5, scope: !30)
!36 = !DILocation(line: 13, column: 29, scope: !33)
!37 = !DILabel(scope: !38, name: "L", file: !6, line: 14)
!38 = distinct !DILexicalBlock(scope: !33, file: !6, line: 13, column: 29)
!39 = !DILocation(line: 14, column: 1, scope: !38)
!40 = !DILocation(line: 15, column: 10, scope: !38)
!41 = !DILocation(line: 16, column: 5, scope: !38)
!42 = !DILocation(line: 13, column: 25, scope: !33)
!43 = !DILocation(line: 13, column: 5, scope: !33)
!44 = distinct !{!44, !35, !45, !46}
!45 = !DILocation(line: 16, column: 5, scope: !30)
!46 = !{!"llvm.loop.mustprogress"}
!47 = !DILocation(line: 18, column: 5, scope: !48)
!48 = distinct !DILexicalBlock(scope: !49, file: !6, line: 18, column: 5)
!49 = distinct !DILexicalBlock(scope: !17, file: !6, line: 18, column: 5)
!50 = !DILocation(line: 18, column: 5, scope: !49)
!51 = !DILocation(line: 19, column: 5, scope: !17)
