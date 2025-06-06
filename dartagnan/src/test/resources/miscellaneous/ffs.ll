; ModuleID = '/home/drc/git/Dat3M/benchmarks/miscellaneous/ffs.c'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/ffs.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 1, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !5
@w = dso_local global i32 2147483647, align 4, !dbg !14
@z = dso_local global i32 -2147483648, align 4, !dbg !16
@lx = dso_local global i64 1, align 8, !dbg !18
@ly = dso_local global i64 0, align 8, !dbg !22
@lw = dso_local global i64 9223372036854775807, align 8, !dbg !24
@lz = dso_local global i64 -9223372036854775808, align 8, !dbg !26
@u = dso_local global i32 0, align 4, !dbg !61
@.str = private unnamed_addr constant [7 x i8] c"u == 1\00", align 1, !dbg !28
@.str.1 = private unnamed_addr constant [51 x i8] c"/home/drc/git/Dat3M/benchmarks/miscellaneous/ffs.c\00", align 1, !dbg !34
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1, !dbg !39
@.str.2 = private unnamed_addr constant [7 x i8] c"u == 0\00", align 1, !dbg !45
@.str.3 = private unnamed_addr constant [8 x i8] c"u == 32\00", align 1, !dbg !47
@lu = dso_local global i64 0, align 8, !dbg !63
@.str.4 = private unnamed_addr constant [8 x i8] c"lu == 1\00", align 1, !dbg !52
@.str.5 = private unnamed_addr constant [8 x i8] c"lu == 0\00", align 1, !dbg !54
@.str.6 = private unnamed_addr constant [9 x i8] c"lu == 64\00", align 1, !dbg !56

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !73 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %2 = load volatile i32, ptr @x, align 4, !dbg !77
  %3 = call i32 @ffs(i32 noundef %2) #3, !dbg !78
  store volatile i32 %3, ptr @u, align 4, !dbg !79
  %4 = load volatile i32, ptr @u, align 4, !dbg !80
  %5 = icmp eq i32 %4, 1, !dbg !80
  br i1 %5, label %6, label %7, !dbg !83

6:                                                ; preds = %0
  br label %8, !dbg !83

7:                                                ; preds = %0
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 22, ptr noundef @__PRETTY_FUNCTION__.main) #4, !dbg !80
  unreachable, !dbg !80

8:                                                ; preds = %6
  %9 = load volatile i32, ptr @y, align 4, !dbg !84
  %10 = call i32 @ffs(i32 noundef %9) #3, !dbg !85
  store volatile i32 %10, ptr @u, align 4, !dbg !86
  %11 = load volatile i32, ptr @u, align 4, !dbg !87
  %12 = icmp eq i32 %11, 0, !dbg !87
  br i1 %12, label %13, label %14, !dbg !90

13:                                               ; preds = %8
  br label %15, !dbg !90

14:                                               ; preds = %8
  call void @__assert_fail(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 25, ptr noundef @__PRETTY_FUNCTION__.main) #4, !dbg !87
  unreachable, !dbg !87

15:                                               ; preds = %13
  %16 = load volatile i32, ptr @w, align 4, !dbg !91
  %17 = call i32 @ffs(i32 noundef %16) #3, !dbg !92
  store volatile i32 %17, ptr @u, align 4, !dbg !93
  %18 = load volatile i32, ptr @u, align 4, !dbg !94
  %19 = icmp eq i32 %18, 1, !dbg !94
  br i1 %19, label %20, label %21, !dbg !97

20:                                               ; preds = %15
  br label %22, !dbg !97

21:                                               ; preds = %15
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 28, ptr noundef @__PRETTY_FUNCTION__.main) #4, !dbg !94
  unreachable, !dbg !94

22:                                               ; preds = %20
  %23 = load volatile i32, ptr @z, align 4, !dbg !98
  %24 = call i32 @ffs(i32 noundef %23) #3, !dbg !99
  store volatile i32 %24, ptr @u, align 4, !dbg !100
  %25 = load volatile i32, ptr @u, align 4, !dbg !101
  %26 = icmp eq i32 %25, 32, !dbg !101
  br i1 %26, label %27, label %28, !dbg !104

27:                                               ; preds = %22
  br label %29, !dbg !104

28:                                               ; preds = %22
  call void @__assert_fail(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 31, ptr noundef @__PRETTY_FUNCTION__.main) #4, !dbg !101
  unreachable, !dbg !101

29:                                               ; preds = %27
  %30 = load volatile i64, ptr @lx, align 8, !dbg !105
  %31 = call i32 @ffsl(i64 noundef %30) #3, !dbg !106
  %32 = sext i32 %31 to i64, !dbg !106
  store volatile i64 %32, ptr @lu, align 8, !dbg !107
  %33 = load volatile i64, ptr @lu, align 8, !dbg !108
  %34 = icmp eq i64 %33, 1, !dbg !108
  br i1 %34, label %35, label %36, !dbg !111

35:                                               ; preds = %29
  br label %37, !dbg !111

36:                                               ; preds = %29
  call void @__assert_fail(ptr noundef @.str.4, ptr noundef @.str.1, i32 noundef 35, ptr noundef @__PRETTY_FUNCTION__.main) #4, !dbg !108
  unreachable, !dbg !108

37:                                               ; preds = %35
  %38 = load volatile i64, ptr @ly, align 8, !dbg !112
  %39 = call i32 @ffsl(i64 noundef %38) #3, !dbg !113
  %40 = sext i32 %39 to i64, !dbg !113
  store volatile i64 %40, ptr @lu, align 8, !dbg !114
  %41 = load volatile i64, ptr @lu, align 8, !dbg !115
  %42 = icmp eq i64 %41, 0, !dbg !115
  br i1 %42, label %43, label %44, !dbg !118

43:                                               ; preds = %37
  br label %45, !dbg !118

44:                                               ; preds = %37
  call void @__assert_fail(ptr noundef @.str.5, ptr noundef @.str.1, i32 noundef 38, ptr noundef @__PRETTY_FUNCTION__.main) #4, !dbg !115
  unreachable, !dbg !115

45:                                               ; preds = %43
  %46 = load volatile i64, ptr @lw, align 8, !dbg !119
  %47 = call i32 @ffsl(i64 noundef %46) #3, !dbg !120
  %48 = sext i32 %47 to i64, !dbg !120
  store volatile i64 %48, ptr @lu, align 8, !dbg !121
  %49 = load volatile i64, ptr @lu, align 8, !dbg !122
  %50 = icmp eq i64 %49, 1, !dbg !122
  br i1 %50, label %51, label %52, !dbg !125

51:                                               ; preds = %45
  br label %53, !dbg !125

52:                                               ; preds = %45
  call void @__assert_fail(ptr noundef @.str.4, ptr noundef @.str.1, i32 noundef 41, ptr noundef @__PRETTY_FUNCTION__.main) #4, !dbg !122
  unreachable, !dbg !122

53:                                               ; preds = %51
  %54 = load volatile i64, ptr @lz, align 8, !dbg !126
  %55 = call i32 @ffsl(i64 noundef %54) #3, !dbg !127
  %56 = sext i32 %55 to i64, !dbg !127
  store volatile i64 %56, ptr @lu, align 8, !dbg !128
  %57 = load volatile i64, ptr @lu, align 8, !dbg !129
  %58 = icmp eq i64 %57, 64, !dbg !129
  br i1 %58, label %59, label %60, !dbg !132

59:                                               ; preds = %53
  br label %61, !dbg !132

60:                                               ; preds = %53
  call void @__assert_fail(ptr noundef @.str.6, ptr noundef @.str.1, i32 noundef 44, ptr noundef @__PRETTY_FUNCTION__.main) #4, !dbg !129
  unreachable, !dbg !129

61:                                               ; preds = %59
  ret i32 0, !dbg !133
}

; Function Attrs: nounwind willreturn memory(none)
declare i32 @ffs(i32 noundef) #1

; Function Attrs: noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: nounwind willreturn memory(none)
declare i32 @ffsl(i64 noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind willreturn memory(none) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind willreturn memory(none) }
attributes #4 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!65, !66, !67, !68, !69, !70, !71}
!llvm.ident = !{!72}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !7, line: 6, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 16.0.6 (++20231112100510+7cbf1a259152-1~exp1~20231112100554.106)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/Dat3M/benchmarks/miscellaneous/ffs.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "7c960e583bef7d9b3537bfc8365ae351")
!4 = !{!0, !5, !14, !16, !18, !22, !24, !26, !28, !34, !39, !45, !47, !52, !54, !56, !61, !63}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !7, line: 7, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "benchmarks/miscellaneous/ffs.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "7c960e583bef7d9b3537bfc8365ae351")
!8 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !9)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !10, line: 26, baseType: !11)
!10 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "", checksumkind: CSK_MD5, checksum: "55bcbdc3159515ebd91d351a70d505f4")
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !12, line: 41, baseType: !13)
!12 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(name: "w", scope: !2, file: !7, line: 8, type: !8, isLocal: false, isDefinition: true)
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !7, line: 9, type: !8, isLocal: false, isDefinition: true)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "lx", scope: !2, file: !7, line: 12, type: !20, isLocal: false, isDefinition: true)
!20 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !21)
!21 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(name: "ly", scope: !2, file: !7, line: 13, type: !20, isLocal: false, isDefinition: true)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "lw", scope: !2, file: !7, line: 14, type: !20, isLocal: false, isDefinition: true)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "lz", scope: !2, file: !7, line: 15, type: !20, isLocal: false, isDefinition: true)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(scope: null, file: !7, line: 22, type: !30, isLocal: true, isDefinition: true)
!30 = !DICompositeType(tag: DW_TAG_array_type, baseType: !31, size: 56, elements: !32)
!31 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!32 = !{!33}
!33 = !DISubrange(count: 7)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(scope: null, file: !7, line: 22, type: !36, isLocal: true, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !31, size: 408, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: 51)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(scope: null, file: !7, line: 22, type: !41, isLocal: true, isDefinition: true)
!41 = !DICompositeType(tag: DW_TAG_array_type, baseType: !42, size: 88, elements: !43)
!42 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !31)
!43 = !{!44}
!44 = !DISubrange(count: 11)
!45 = !DIGlobalVariableExpression(var: !46, expr: !DIExpression())
!46 = distinct !DIGlobalVariable(scope: null, file: !7, line: 25, type: !30, isLocal: true, isDefinition: true)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(scope: null, file: !7, line: 31, type: !49, isLocal: true, isDefinition: true)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !31, size: 64, elements: !50)
!50 = !{!51}
!51 = !DISubrange(count: 8)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(scope: null, file: !7, line: 35, type: !49, isLocal: true, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(scope: null, file: !7, line: 38, type: !49, isLocal: true, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(scope: null, file: !7, line: 44, type: !58, isLocal: true, isDefinition: true)
!58 = !DICompositeType(tag: DW_TAG_array_type, baseType: !31, size: 72, elements: !59)
!59 = !{!60}
!60 = !DISubrange(count: 9)
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(name: "u", scope: !2, file: !7, line: 10, type: !8, isLocal: false, isDefinition: true)
!63 = !DIGlobalVariableExpression(var: !64, expr: !DIExpression())
!64 = distinct !DIGlobalVariable(name: "lu", scope: !2, file: !7, line: 16, type: !20, isLocal: false, isDefinition: true)
!65 = !{i32 7, !"Dwarf Version", i32 5}
!66 = !{i32 2, !"Debug Info Version", i32 3}
!67 = !{i32 1, !"wchar_size", i32 4}
!68 = !{i32 8, !"PIC Level", i32 2}
!69 = !{i32 7, !"PIE Level", i32 2}
!70 = !{i32 7, !"uwtable", i32 2}
!71 = !{i32 7, !"frame-pointer", i32 2}
!72 = !{!"Ubuntu clang version 16.0.6 (++20231112100510+7cbf1a259152-1~exp1~20231112100554.106)"}
!73 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 18, type: !74, scopeLine: 19, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !76)
!74 = !DISubroutineType(types: !75)
!75 = !{!13}
!76 = !{}
!77 = !DILocation(line: 21, column: 13, scope: !73)
!78 = !DILocation(line: 21, column: 9, scope: !73)
!79 = !DILocation(line: 21, column: 7, scope: !73)
!80 = !DILocation(line: 22, column: 5, scope: !81)
!81 = distinct !DILexicalBlock(scope: !82, file: !7, line: 22, column: 5)
!82 = distinct !DILexicalBlock(scope: !73, file: !7, line: 22, column: 5)
!83 = !DILocation(line: 22, column: 5, scope: !82)
!84 = !DILocation(line: 24, column: 13, scope: !73)
!85 = !DILocation(line: 24, column: 9, scope: !73)
!86 = !DILocation(line: 24, column: 7, scope: !73)
!87 = !DILocation(line: 25, column: 5, scope: !88)
!88 = distinct !DILexicalBlock(scope: !89, file: !7, line: 25, column: 5)
!89 = distinct !DILexicalBlock(scope: !73, file: !7, line: 25, column: 5)
!90 = !DILocation(line: 25, column: 5, scope: !89)
!91 = !DILocation(line: 27, column: 13, scope: !73)
!92 = !DILocation(line: 27, column: 9, scope: !73)
!93 = !DILocation(line: 27, column: 7, scope: !73)
!94 = !DILocation(line: 28, column: 5, scope: !95)
!95 = distinct !DILexicalBlock(scope: !96, file: !7, line: 28, column: 5)
!96 = distinct !DILexicalBlock(scope: !73, file: !7, line: 28, column: 5)
!97 = !DILocation(line: 28, column: 5, scope: !96)
!98 = !DILocation(line: 30, column: 13, scope: !73)
!99 = !DILocation(line: 30, column: 9, scope: !73)
!100 = !DILocation(line: 30, column: 7, scope: !73)
!101 = !DILocation(line: 31, column: 5, scope: !102)
!102 = distinct !DILexicalBlock(scope: !103, file: !7, line: 31, column: 5)
!103 = distinct !DILexicalBlock(scope: !73, file: !7, line: 31, column: 5)
!104 = !DILocation(line: 31, column: 5, scope: !103)
!105 = !DILocation(line: 34, column: 15, scope: !73)
!106 = !DILocation(line: 34, column: 10, scope: !73)
!107 = !DILocation(line: 34, column: 8, scope: !73)
!108 = !DILocation(line: 35, column: 5, scope: !109)
!109 = distinct !DILexicalBlock(scope: !110, file: !7, line: 35, column: 5)
!110 = distinct !DILexicalBlock(scope: !73, file: !7, line: 35, column: 5)
!111 = !DILocation(line: 35, column: 5, scope: !110)
!112 = !DILocation(line: 37, column: 15, scope: !73)
!113 = !DILocation(line: 37, column: 10, scope: !73)
!114 = !DILocation(line: 37, column: 8, scope: !73)
!115 = !DILocation(line: 38, column: 5, scope: !116)
!116 = distinct !DILexicalBlock(scope: !117, file: !7, line: 38, column: 5)
!117 = distinct !DILexicalBlock(scope: !73, file: !7, line: 38, column: 5)
!118 = !DILocation(line: 38, column: 5, scope: !117)
!119 = !DILocation(line: 40, column: 15, scope: !73)
!120 = !DILocation(line: 40, column: 10, scope: !73)
!121 = !DILocation(line: 40, column: 8, scope: !73)
!122 = !DILocation(line: 41, column: 5, scope: !123)
!123 = distinct !DILexicalBlock(scope: !124, file: !7, line: 41, column: 5)
!124 = distinct !DILexicalBlock(scope: !73, file: !7, line: 41, column: 5)
!125 = !DILocation(line: 41, column: 5, scope: !124)
!126 = !DILocation(line: 43, column: 15, scope: !73)
!127 = !DILocation(line: 43, column: 10, scope: !73)
!128 = !DILocation(line: 43, column: 8, scope: !73)
!129 = !DILocation(line: 44, column: 5, scope: !130)
!130 = distinct !DILexicalBlock(scope: !131, file: !7, line: 44, column: 5)
!131 = distinct !DILexicalBlock(scope: !73, file: !7, line: 44, column: 5)
!132 = !DILocation(line: 44, column: 5, scope: !131)
!133 = !DILocation(line: 46, column: 5, scope: !73)
