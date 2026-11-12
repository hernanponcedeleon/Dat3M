; ModuleID = 'benchmarks/miscellaneous/ilp32-nondet-malloc-no-wraparound.c'
source_filename = "benchmarks/miscellaneous/ilp32-nondet-malloc-no-wraparound.c"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@g = dso_local global i32 7, align 4, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !10
@.str = private unnamed_addr constant [36 x i8] c"ilp32-nondet-malloc-no-wraparound.c\00", align 1, !dbg !17
@.str.1 = private unnamed_addr constant [39 x i8] c"(uintptr_t)big < (uintptr_t)big + size\00", align 1, !dbg !22
@.str.2 = private unnamed_addr constant [29 x i8] c"(void *)small != (void *)big\00", align 1, !dbg !27
@.str.3 = private unnamed_addr constant [13 x i8] c"*small == 42\00", align 1, !dbg !32
@.str.4 = private unnamed_addr constant [7 x i8] c"g == 7\00", align 1, !dbg !37

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !51 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !55, !DIExpression(), !61)
  %5 = call i32 @__VERIFIER_nondet_uint(), !dbg !62
  store i32 %5, ptr %2, align 4, !dbg !61
    #dbg_declare(ptr %3, !63, !DIExpression(), !65)
  %6 = load i32, ptr %2, align 4, !dbg !66
  %7 = call ptr @malloc(i32 noundef %6) #4, !dbg !67
  store ptr %7, ptr %3, align 4, !dbg !65
    #dbg_declare(ptr %4, !68, !DIExpression(), !70)
  %8 = call ptr @malloc(i32 noundef 4) #4, !dbg !71
  store ptr %8, ptr %4, align 4, !dbg !70
  %9 = load ptr, ptr %3, align 4, !dbg !72
  %10 = icmp eq ptr %9, null, !dbg !74
  br i1 %10, label %14, label %11, !dbg !75

11:                                               ; preds = %0
  %12 = load ptr, ptr %4, align 4, !dbg !76
  %13 = icmp eq ptr %12, null, !dbg !77
  br i1 %13, label %14, label %15, !dbg !75

14:                                               ; preds = %11, %0
  store i32 0, ptr %1, align 4, !dbg !78
  br label %62, !dbg !78

15:                                               ; preds = %11
  %16 = load ptr, ptr %4, align 4, !dbg !80
  store i32 42, ptr %16, align 4, !dbg !81
  %17 = load i32, ptr %2, align 4, !dbg !82
  %18 = icmp ugt i32 %17, 0, !dbg !84
  br i1 %18, label %19, label %38, !dbg !84

19:                                               ; preds = %15
  %20 = load ptr, ptr %3, align 4, !dbg !85
  %21 = getelementptr inbounds i8, ptr %20, i32 0, !dbg !85
  store i8 0, ptr %21, align 1, !dbg !87
  %22 = load ptr, ptr %3, align 4, !dbg !88
  %23 = load i32, ptr %2, align 4, !dbg !89
  %24 = sub i32 %23, 1, !dbg !90
  %25 = getelementptr inbounds nuw i8, ptr %22, i32 %24, !dbg !88
  store i8 0, ptr %25, align 1, !dbg !91
  %26 = load ptr, ptr %3, align 4, !dbg !92
  %27 = ptrtoint ptr %26 to i32, !dbg !93
  %28 = load ptr, ptr %3, align 4, !dbg !94
  %29 = ptrtoint ptr %28 to i32, !dbg !95
  %30 = load i32, ptr %2, align 4, !dbg !96
  %31 = add i32 %29, %30, !dbg !97
  %32 = icmp ult i32 %27, %31, !dbg !98
  %33 = xor i1 %32, true, !dbg !99
  br i1 %33, label %34, label %36, !dbg !99

34:                                               ; preds = %19
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 30, ptr noundef @.str.1) #5, !dbg !99
  unreachable, !dbg !99

35:                                               ; No predecessors!
  br label %37, !dbg !99

36:                                               ; preds = %19
  br label %37, !dbg !99

37:                                               ; preds = %36, %35
  br label %38, !dbg !100

38:                                               ; preds = %37, %15
  %39 = load ptr, ptr %4, align 4, !dbg !101
  %40 = load ptr, ptr %3, align 4, !dbg !102
  %41 = icmp ne ptr %39, %40, !dbg !103
  %42 = xor i1 %41, true, !dbg !104
  br i1 %42, label %43, label %45, !dbg !104

43:                                               ; preds = %38
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 33, ptr noundef @.str.2) #5, !dbg !104
  unreachable, !dbg !104

44:                                               ; No predecessors!
  br label %46, !dbg !104

45:                                               ; preds = %38
  br label %46, !dbg !104

46:                                               ; preds = %45, %44
  %47 = load ptr, ptr %4, align 4, !dbg !105
  %48 = load i32, ptr %47, align 4, !dbg !106
  %49 = icmp eq i32 %48, 42, !dbg !107
  %50 = xor i1 %49, true, !dbg !108
  br i1 %50, label %51, label %53, !dbg !108

51:                                               ; preds = %46
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 34, ptr noundef @.str.3) #5, !dbg !108
  unreachable, !dbg !108

52:                                               ; No predecessors!
  br label %54, !dbg !108

53:                                               ; preds = %46
  br label %54, !dbg !108

54:                                               ; preds = %53, %52
  %55 = load i32, ptr @g, align 4, !dbg !109
  %56 = icmp eq i32 %55, 7, !dbg !110
  %57 = xor i1 %56, true, !dbg !111
  br i1 %57, label %58, label %60, !dbg !111

58:                                               ; preds = %54
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 35, ptr noundef @.str.4) #5, !dbg !111
  unreachable, !dbg !111

59:                                               ; No predecessors!
  br label %61, !dbg !111

60:                                               ; preds = %54
  br label %61, !dbg !111

61:                                               ; preds = %60, %59
  store i32 0, ptr %1, align 4, !dbg !112
  br label %62, !dbg !112

62:                                               ; preds = %61, %14
  %63 = load i32, ptr %1, align 4, !dbg !113
  ret i32 %63, !dbg !113
}

declare i32 @__VERIFIER_nondet_uint() #1

; Function Attrs: allocsize(0)
declare ptr @malloc(i32 noundef) #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { allocsize(0) }
attributes #5 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!43, !44, !45, !46, !47, !48, !49}
!llvm.ident = !{!50}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g", scope: !2, file: !3, line: 15, type: !42, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !9, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/miscellaneous/ilp32-nondet-malloc-no-wraparound.c", directory: ".", checksumkind: CSK_MD5, checksum: "13bf0acfbad60567fbf7b6a9d246163c")
!4 = !{!5, !6}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !7, line: 34, baseType: !8)
!7 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_types/_uintptr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e70ae655dd1b9d4ae0b1dcc073f5b7e4")
!8 = !DIBasicType(name: "unsigned long", size: 32, encoding: DW_ATE_unsigned)
!9 = !{!0, !10, !17, !22, !27, !32, !37}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(scope: null, file: !3, line: 30, type: !12, isLocal: true, isDefinition: true)
!12 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 40, elements: !15)
!13 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !14)
!14 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!15 = !{!16}
!16 = !DISubrange(count: 5)
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(scope: null, file: !3, line: 30, type: !19, isLocal: true, isDefinition: true)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 288, elements: !20)
!20 = !{!21}
!21 = !DISubrange(count: 36)
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(scope: null, file: !3, line: 30, type: !24, isLocal: true, isDefinition: true)
!24 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 312, elements: !25)
!25 = !{!26}
!26 = !DISubrange(count: 39)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(scope: null, file: !3, line: 33, type: !29, isLocal: true, isDefinition: true)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 232, elements: !30)
!30 = !{!31}
!31 = !DISubrange(count: 29)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(scope: null, file: !3, line: 34, type: !34, isLocal: true, isDefinition: true)
!34 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 104, elements: !35)
!35 = !{!36}
!36 = !DISubrange(count: 13)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 35, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 56, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 7)
!42 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!43 = !{i32 1, !"NumRegisterParameters", i32 0}
!44 = !{i32 7, !"Dwarf Version", i32 5}
!45 = !{i32 2, !"Debug Info Version", i32 3}
!46 = !{i32 8, !"PIC Level", i32 2}
!47 = !{i32 7, !"PIE Level", i32 2}
!48 = !{i32 7, !"uwtable", i32 2}
!49 = !{i32 7, !"frame-pointer", i32 2}
!50 = !{!"Homebrew clang version 23.1.3"}
!51 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 17, type: !52, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!52 = !DISubroutineType(types: !53)
!53 = !{!42}
!54 = !{}
!55 = !DILocalVariable(name: "size", scope: !51, file: !3, line: 18, type: !56)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !57, line: 50, baseType: !58)
!57 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_types/_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "f7981334d28e0c246f35cd24042aa2a4")
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_size_t", file: !59, line: 111, baseType: !60)
!59 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/i386/_types.h", directory: "", checksumkind: CSK_MD5, checksum: "eb9e401b3b97107c79f668bcc91916e5")
!60 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!61 = !DILocation(line: 18, column: 12, scope: !51)
!62 = !DILocation(line: 18, column: 19, scope: !51)
!63 = !DILocalVariable(name: "big", scope: !51, file: !3, line: 19, type: !64)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 32)
!65 = !DILocation(line: 19, column: 11, scope: !51)
!66 = !DILocation(line: 19, column: 24, scope: !51)
!67 = !DILocation(line: 19, column: 17, scope: !51)
!68 = !DILocalVariable(name: "small", scope: !51, file: !3, line: 20, type: !69)
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 32)
!70 = !DILocation(line: 20, column: 10, scope: !51)
!71 = !DILocation(line: 20, column: 18, scope: !51)
!72 = !DILocation(line: 21, column: 9, scope: !73)
!73 = distinct !DILexicalBlock(scope: !51, file: !3, line: 21, column: 9)
!74 = !DILocation(line: 21, column: 13, scope: !73)
!75 = !DILocation(line: 21, column: 21, scope: !73)
!76 = !DILocation(line: 21, column: 24, scope: !73)
!77 = !DILocation(line: 21, column: 30, scope: !73)
!78 = !DILocation(line: 22, column: 9, scope: !79)
!79 = distinct !DILexicalBlock(scope: !73, file: !3, line: 21, column: 39)
!80 = !DILocation(line: 25, column: 6, scope: !51)
!81 = !DILocation(line: 25, column: 12, scope: !51)
!82 = !DILocation(line: 26, column: 9, scope: !83)
!83 = distinct !DILexicalBlock(scope: !51, file: !3, line: 26, column: 9)
!84 = !DILocation(line: 26, column: 14, scope: !83)
!85 = !DILocation(line: 27, column: 9, scope: !86)
!86 = distinct !DILexicalBlock(scope: !83, file: !3, line: 26, column: 19)
!87 = !DILocation(line: 27, column: 16, scope: !86)
!88 = !DILocation(line: 28, column: 9, scope: !86)
!89 = !DILocation(line: 28, column: 13, scope: !86)
!90 = !DILocation(line: 28, column: 18, scope: !86)
!91 = !DILocation(line: 28, column: 23, scope: !86)
!92 = !DILocation(line: 30, column: 27, scope: !86)
!93 = !DILocation(line: 30, column: 16, scope: !86)
!94 = !DILocation(line: 30, column: 44, scope: !86)
!95 = !DILocation(line: 30, column: 33, scope: !86)
!96 = !DILocation(line: 30, column: 50, scope: !86)
!97 = !DILocation(line: 30, column: 48, scope: !86)
!98 = !DILocation(line: 30, column: 31, scope: !86)
!99 = !DILocation(line: 30, column: 9, scope: !86)
!100 = !DILocation(line: 31, column: 5, scope: !86)
!101 = !DILocation(line: 33, column: 20, scope: !51)
!102 = !DILocation(line: 33, column: 37, scope: !51)
!103 = !DILocation(line: 33, column: 26, scope: !51)
!104 = !DILocation(line: 33, column: 5, scope: !51)
!105 = !DILocation(line: 34, column: 13, scope: !51)
!106 = !DILocation(line: 34, column: 12, scope: !51)
!107 = !DILocation(line: 34, column: 19, scope: !51)
!108 = !DILocation(line: 34, column: 5, scope: !51)
!109 = !DILocation(line: 35, column: 12, scope: !51)
!110 = !DILocation(line: 35, column: 14, scope: !51)
!111 = !DILocation(line: 35, column: 5, scope: !51)
!112 = !DILocation(line: 36, column: 5, scope: !51)
!113 = !DILocation(line: 37, column: 1, scope: !51)
