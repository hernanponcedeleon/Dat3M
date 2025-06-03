; ModuleID = '/home/drc/git/Dat3M/output/ffs.ll'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/ffs.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 1, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !5
@w = dso_local global i32 2147483647, align 4, !dbg !14
@z = dso_local global i32 -2147483648, align 4, !dbg !16
@u = dso_local global i32 0, align 4, !dbg !18
@.str = private unnamed_addr constant [7 x i8] c"u == 1\00", align 1
@.str.1 = private unnamed_addr constant [51 x i8] c"/home/drc/git/Dat3M/benchmarks/miscellaneous/ffs.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"u == 0\00", align 1
@.str.3 = private unnamed_addr constant [8 x i8] c"u == 32\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !28 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %2 = load volatile i32, i32* @x, align 4, !dbg !32
  %3 = call i32 @ffs(i32 noundef %2) #3, !dbg !33
  store volatile i32 %3, i32* @u, align 4, !dbg !34
  %4 = load volatile i32, i32* @u, align 4, !dbg !35
  %5 = icmp eq i32 %4, 1, !dbg !35
  br i1 %5, label %6, label %7, !dbg !38

6:                                                ; preds = %0
  br label %8, !dbg !38

7:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 15, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !35
  unreachable, !dbg !35

8:                                                ; preds = %6
  %9 = load volatile i32, i32* @y, align 4, !dbg !39
  %10 = call i32 @ffs(i32 noundef %9) #3, !dbg !40
  store volatile i32 %10, i32* @u, align 4, !dbg !41
  %11 = load volatile i32, i32* @u, align 4, !dbg !42
  %12 = icmp eq i32 %11, 0, !dbg !42
  br i1 %12, label %13, label %14, !dbg !45

13:                                               ; preds = %8
  br label %15, !dbg !45

14:                                               ; preds = %8
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 18, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !42
  unreachable, !dbg !42

15:                                               ; preds = %13
  %16 = load volatile i32, i32* @w, align 4, !dbg !46
  %17 = call i32 @ffs(i32 noundef %16) #3, !dbg !47
  store volatile i32 %17, i32* @u, align 4, !dbg !48
  %18 = load volatile i32, i32* @u, align 4, !dbg !49
  %19 = icmp eq i32 %18, 1, !dbg !49
  br i1 %19, label %20, label %21, !dbg !52

20:                                               ; preds = %15
  br label %22, !dbg !52

21:                                               ; preds = %15
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 21, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !49
  unreachable, !dbg !49

22:                                               ; preds = %20
  %23 = load volatile i32, i32* @z, align 4, !dbg !53
  %24 = call i32 @ffs(i32 noundef %23) #3, !dbg !54
  store volatile i32 %24, i32* @u, align 4, !dbg !55
  %25 = load volatile i32, i32* @u, align 4, !dbg !56
  %26 = icmp eq i32 %25, 32, !dbg !56
  br i1 %26, label %27, label %28, !dbg !59

27:                                               ; preds = %22
  br label %29, !dbg !59

28:                                               ; preds = %22
  call void @__assert_fail(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 24, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !56
  unreachable, !dbg !56

29:                                               ; preds = %27
  ret i32 0, !dbg !60
}

; Function Attrs: nounwind readnone willreturn
declare i32 @ffs(i32 noundef) #1

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind readnone willreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind readnone willreturn }
attributes #4 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!20, !21, !22, !23, !24, !25, !26}
!llvm.ident = !{!27}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !7, line: 5, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/Dat3M/benchmarks/miscellaneous/ffs.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "e5aaf5d1c77cc4cde61616b5253cb54f")
!4 = !{!0, !5, !14, !16, !18}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !7, line: 6, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "benchmarks/miscellaneous/ffs.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "e5aaf5d1c77cc4cde61616b5253cb54f")
!8 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !9)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !10, line: 26, baseType: !11)
!10 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "", checksumkind: CSK_MD5, checksum: "55bcbdc3159515ebd91d351a70d505f4")
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !12, line: 41, baseType: !13)
!12 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(name: "w", scope: !2, file: !7, line: 7, type: !8, isLocal: false, isDefinition: true)
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !7, line: 8, type: !8, isLocal: false, isDefinition: true)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "u", scope: !2, file: !7, line: 9, type: !8, isLocal: false, isDefinition: true)
!20 = !{i32 7, !"Dwarf Version", i32 5}
!21 = !{i32 2, !"Debug Info Version", i32 3}
!22 = !{i32 1, !"wchar_size", i32 4}
!23 = !{i32 7, !"PIC Level", i32 2}
!24 = !{i32 7, !"PIE Level", i32 2}
!25 = !{i32 7, !"uwtable", i32 1}
!26 = !{i32 7, !"frame-pointer", i32 2}
!27 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!28 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 11, type: !29, scopeLine: 12, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !31)
!29 = !DISubroutineType(types: !30)
!30 = !{!13}
!31 = !{}
!32 = !DILocation(line: 14, column: 13, scope: !28)
!33 = !DILocation(line: 14, column: 9, scope: !28)
!34 = !DILocation(line: 14, column: 7, scope: !28)
!35 = !DILocation(line: 15, column: 2, scope: !36)
!36 = distinct !DILexicalBlock(scope: !37, file: !7, line: 15, column: 2)
!37 = distinct !DILexicalBlock(scope: !28, file: !7, line: 15, column: 2)
!38 = !DILocation(line: 15, column: 2, scope: !37)
!39 = !DILocation(line: 17, column: 13, scope: !28)
!40 = !DILocation(line: 17, column: 9, scope: !28)
!41 = !DILocation(line: 17, column: 7, scope: !28)
!42 = !DILocation(line: 18, column: 2, scope: !43)
!43 = distinct !DILexicalBlock(scope: !44, file: !7, line: 18, column: 2)
!44 = distinct !DILexicalBlock(scope: !28, file: !7, line: 18, column: 2)
!45 = !DILocation(line: 18, column: 2, scope: !44)
!46 = !DILocation(line: 20, column: 13, scope: !28)
!47 = !DILocation(line: 20, column: 9, scope: !28)
!48 = !DILocation(line: 20, column: 7, scope: !28)
!49 = !DILocation(line: 21, column: 2, scope: !50)
!50 = distinct !DILexicalBlock(scope: !51, file: !7, line: 21, column: 2)
!51 = distinct !DILexicalBlock(scope: !28, file: !7, line: 21, column: 2)
!52 = !DILocation(line: 21, column: 2, scope: !51)
!53 = !DILocation(line: 23, column: 13, scope: !28)
!54 = !DILocation(line: 23, column: 9, scope: !28)
!55 = !DILocation(line: 23, column: 7, scope: !28)
!56 = !DILocation(line: 24, column: 2, scope: !57)
!57 = distinct !DILexicalBlock(scope: !58, file: !7, line: 24, column: 2)
!58 = distinct !DILexicalBlock(scope: !28, file: !7, line: 24, column: 2)
!59 = !DILocation(line: 24, column: 2, scope: !58)
!60 = !DILocation(line: 26, column: 2, scope: !28)
