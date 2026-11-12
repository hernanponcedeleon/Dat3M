; ModuleID = 'benchmarks/mem-safety/ilp32-malloc-wraparound.c'
source_filename = "benchmarks/mem-safety/ilp32-malloc-wraparound.c"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@g = dso_local global i32 7, align 4, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !10
@.str = private unnamed_addr constant [26 x i8] c"ilp32-malloc-wraparound.c\00", align 1, !dbg !17
@.str.1 = private unnamed_addr constant [29 x i8] c"big != NULL && small != NULL\00", align 1, !dbg !22
@.str.2 = private unnamed_addr constant [39 x i8] c"(uintptr_t)big < (uintptr_t)big + size\00", align 1, !dbg !27
@.str.3 = private unnamed_addr constant [29 x i8] c"(void *)small != (void *)big\00", align 1, !dbg !32
@.str.4 = private unnamed_addr constant [13 x i8] c"*small == 42\00", align 1, !dbg !34
@.str.5 = private unnamed_addr constant [7 x i8] c"g == 7\00", align 1, !dbg !39

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !53 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !57, !DIExpression(), !63)
  %5 = call i32 @__VERIFIER_nondet_uint(), !dbg !64
  store i32 %5, ptr %2, align 4, !dbg !63
    #dbg_declare(ptr %3, !65, !DIExpression(), !67)
  %6 = load i32, ptr %2, align 4, !dbg !68
  %7 = call ptr @malloc(i32 noundef %6) #4, !dbg !69
  store ptr %7, ptr %3, align 4, !dbg !67
    #dbg_declare(ptr %4, !70, !DIExpression(), !72)
  %8 = call ptr @malloc(i32 noundef 4) #4, !dbg !73
  store ptr %8, ptr %4, align 4, !dbg !72
  %9 = load ptr, ptr %3, align 4, !dbg !74
  %10 = icmp ne ptr %9, null, !dbg !75
  br i1 %10, label %11, label %14, !dbg !76

11:                                               ; preds = %0
  %12 = load ptr, ptr %4, align 4, !dbg !77
  %13 = icmp ne ptr %12, null, !dbg !78
  br label %14

14:                                               ; preds = %11, %0
  %15 = phi i1 [ false, %0 ], [ %13, %11 ], !dbg !79
  %16 = xor i1 %15, true, !dbg !80
  br i1 %16, label %17, label %19, !dbg !80

17:                                               ; preds = %14
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 27, ptr noundef @.str.1) #5, !dbg !80
  unreachable, !dbg !80

18:                                               ; No predecessors!
  br label %20, !dbg !80

19:                                               ; preds = %14
  br label %20, !dbg !80

20:                                               ; preds = %19, %18
  %21 = load ptr, ptr %3, align 4, !dbg !81
  %22 = icmp eq ptr %21, null, !dbg !83
  br i1 %22, label %26, label %23, !dbg !84

23:                                               ; preds = %20
  %24 = load ptr, ptr %4, align 4, !dbg !85
  %25 = icmp eq ptr %24, null, !dbg !86
  br i1 %25, label %26, label %27, !dbg !84

26:                                               ; preds = %23, %20
  store i32 0, ptr %1, align 4, !dbg !87
  br label %74, !dbg !87

27:                                               ; preds = %23
  %28 = load ptr, ptr %4, align 4, !dbg !89
  store i32 42, ptr %28, align 4, !dbg !90
  %29 = load i32, ptr %2, align 4, !dbg !91
  %30 = icmp ugt i32 %29, 0, !dbg !93
  br i1 %30, label %31, label %50, !dbg !93

31:                                               ; preds = %27
  %32 = load ptr, ptr %3, align 4, !dbg !94
  %33 = getelementptr inbounds i8, ptr %32, i32 0, !dbg !94
  store i8 0, ptr %33, align 1, !dbg !96
  %34 = load ptr, ptr %3, align 4, !dbg !97
  %35 = load i32, ptr %2, align 4, !dbg !98
  %36 = sub i32 %35, 1, !dbg !99
  %37 = getelementptr inbounds nuw i8, ptr %34, i32 %36, !dbg !97
  store i8 0, ptr %37, align 1, !dbg !100
  %38 = load ptr, ptr %3, align 4, !dbg !101
  %39 = ptrtoint ptr %38 to i32, !dbg !102
  %40 = load ptr, ptr %3, align 4, !dbg !103
  %41 = ptrtoint ptr %40 to i32, !dbg !104
  %42 = load i32, ptr %2, align 4, !dbg !105
  %43 = add i32 %41, %42, !dbg !106
  %44 = icmp ult i32 %39, %43, !dbg !107
  %45 = xor i1 %44, true, !dbg !108
  br i1 %45, label %46, label %48, !dbg !108

46:                                               ; preds = %31
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 38, ptr noundef @.str.2) #5, !dbg !108
  unreachable, !dbg !108

47:                                               ; No predecessors!
  br label %49, !dbg !108

48:                                               ; preds = %31
  br label %49, !dbg !108

49:                                               ; preds = %48, %47
  br label %50, !dbg !109

50:                                               ; preds = %49, %27
  %51 = load ptr, ptr %4, align 4, !dbg !110
  %52 = load ptr, ptr %3, align 4, !dbg !111
  %53 = icmp ne ptr %51, %52, !dbg !112
  %54 = xor i1 %53, true, !dbg !113
  br i1 %54, label %55, label %57, !dbg !113

55:                                               ; preds = %50
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 41, ptr noundef @.str.3) #5, !dbg !113
  unreachable, !dbg !113

56:                                               ; No predecessors!
  br label %58, !dbg !113

57:                                               ; preds = %50
  br label %58, !dbg !113

58:                                               ; preds = %57, %56
  %59 = load ptr, ptr %4, align 4, !dbg !114
  %60 = load i32, ptr %59, align 4, !dbg !115
  %61 = icmp eq i32 %60, 42, !dbg !116
  %62 = xor i1 %61, true, !dbg !117
  br i1 %62, label %63, label %65, !dbg !117

63:                                               ; preds = %58
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 42, ptr noundef @.str.4) #5, !dbg !117
  unreachable, !dbg !117

64:                                               ; No predecessors!
  br label %66, !dbg !117

65:                                               ; preds = %58
  br label %66, !dbg !117

66:                                               ; preds = %65, %64
  %67 = load i32, ptr @g, align 4, !dbg !118
  %68 = icmp eq i32 %67, 7, !dbg !119
  %69 = xor i1 %68, true, !dbg !120
  br i1 %69, label %70, label %72, !dbg !120

70:                                               ; preds = %66
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 43, ptr noundef @.str.5) #5, !dbg !120
  unreachable, !dbg !120

71:                                               ; No predecessors!
  br label %73, !dbg !120

72:                                               ; preds = %66
  br label %73, !dbg !120

73:                                               ; preds = %72, %71
  store i32 0, ptr %1, align 4, !dbg !121
  br label %74, !dbg !121

74:                                               ; preds = %73, %26
  %75 = load i32, ptr %1, align 4, !dbg !122
  ret i32 %75, !dbg !122
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
!llvm.module.flags = !{!45, !46, !47, !48, !49, !50, !51}
!llvm.ident = !{!52}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g", scope: !2, file: !3, line: 20, type: !44, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !9, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/mem-safety/ilp32-malloc-wraparound.c", directory: ".", checksumkind: CSK_MD5, checksum: "59087e2d2293463eedfa956168bd3762")
!4 = !{!5, !6}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !7, line: 34, baseType: !8)
!7 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_types/_uintptr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e70ae655dd1b9d4ae0b1dcc073f5b7e4")
!8 = !DIBasicType(name: "unsigned long", size: 32, encoding: DW_ATE_unsigned)
!9 = !{!0, !10, !17, !22, !27, !32, !34, !39}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(scope: null, file: !3, line: 27, type: !12, isLocal: true, isDefinition: true)
!12 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 40, elements: !15)
!13 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !14)
!14 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!15 = !{!16}
!16 = !DISubrange(count: 5)
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(scope: null, file: !3, line: 27, type: !19, isLocal: true, isDefinition: true)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 208, elements: !20)
!20 = !{!21}
!21 = !DISubrange(count: 26)
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(scope: null, file: !3, line: 27, type: !24, isLocal: true, isDefinition: true)
!24 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 232, elements: !25)
!25 = !{!26}
!26 = !DISubrange(count: 29)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(scope: null, file: !3, line: 38, type: !29, isLocal: true, isDefinition: true)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 312, elements: !30)
!30 = !{!31}
!31 = !DISubrange(count: 39)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(scope: null, file: !3, line: 41, type: !24, isLocal: true, isDefinition: true)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(scope: null, file: !3, line: 42, type: !36, isLocal: true, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 104, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: 13)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(scope: null, file: !3, line: 43, type: !41, isLocal: true, isDefinition: true)
!41 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 56, elements: !42)
!42 = !{!43}
!43 = !DISubrange(count: 7)
!44 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!45 = !{i32 1, !"NumRegisterParameters", i32 0}
!46 = !{i32 7, !"Dwarf Version", i32 5}
!47 = !{i32 2, !"Debug Info Version", i32 3}
!48 = !{i32 8, !"PIC Level", i32 2}
!49 = !{i32 7, !"PIE Level", i32 2}
!50 = !{i32 7, !"uwtable", i32 2}
!51 = !{i32 7, !"frame-pointer", i32 2}
!52 = !{!"Homebrew clang version 23.1.3"}
!53 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 22, type: !54, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!54 = !DISubroutineType(types: !55)
!55 = !{!44}
!56 = !{}
!57 = !DILocalVariable(name: "size", scope: !53, file: !3, line: 23, type: !58)
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !59, line: 50, baseType: !60)
!59 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_types/_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "f7981334d28e0c246f35cd24042aa2a4")
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_size_t", file: !61, line: 111, baseType: !62)
!61 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/i386/_types.h", directory: "", checksumkind: CSK_MD5, checksum: "eb9e401b3b97107c79f668bcc91916e5")
!62 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!63 = !DILocation(line: 23, column: 12, scope: !53)
!64 = !DILocation(line: 23, column: 19, scope: !53)
!65 = !DILocalVariable(name: "big", scope: !53, file: !3, line: 24, type: !66)
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 32)
!67 = !DILocation(line: 24, column: 11, scope: !53)
!68 = !DILocation(line: 24, column: 24, scope: !53)
!69 = !DILocation(line: 24, column: 17, scope: !53)
!70 = !DILocalVariable(name: "small", scope: !53, file: !3, line: 25, type: !71)
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 32)
!72 = !DILocation(line: 25, column: 10, scope: !53)
!73 = !DILocation(line: 25, column: 18, scope: !53)
!74 = !DILocation(line: 27, column: 12, scope: !53)
!75 = !DILocation(line: 27, column: 16, scope: !53)
!76 = !DILocation(line: 27, column: 24, scope: !53)
!77 = !DILocation(line: 27, column: 27, scope: !53)
!78 = !DILocation(line: 27, column: 33, scope: !53)
!79 = !DILocation(line: 0, scope: !53)
!80 = !DILocation(line: 27, column: 5, scope: !53)
!81 = !DILocation(line: 29, column: 9, scope: !82)
!82 = distinct !DILexicalBlock(scope: !53, file: !3, line: 29, column: 9)
!83 = !DILocation(line: 29, column: 13, scope: !82)
!84 = !DILocation(line: 29, column: 21, scope: !82)
!85 = !DILocation(line: 29, column: 24, scope: !82)
!86 = !DILocation(line: 29, column: 30, scope: !82)
!87 = !DILocation(line: 30, column: 9, scope: !88)
!88 = distinct !DILexicalBlock(scope: !82, file: !3, line: 29, column: 39)
!89 = !DILocation(line: 33, column: 6, scope: !53)
!90 = !DILocation(line: 33, column: 12, scope: !53)
!91 = !DILocation(line: 34, column: 9, scope: !92)
!92 = distinct !DILexicalBlock(scope: !53, file: !3, line: 34, column: 9)
!93 = !DILocation(line: 34, column: 14, scope: !92)
!94 = !DILocation(line: 35, column: 9, scope: !95)
!95 = distinct !DILexicalBlock(scope: !92, file: !3, line: 34, column: 19)
!96 = !DILocation(line: 35, column: 16, scope: !95)
!97 = !DILocation(line: 36, column: 9, scope: !95)
!98 = !DILocation(line: 36, column: 13, scope: !95)
!99 = !DILocation(line: 36, column: 18, scope: !95)
!100 = !DILocation(line: 36, column: 23, scope: !95)
!101 = !DILocation(line: 38, column: 27, scope: !95)
!102 = !DILocation(line: 38, column: 16, scope: !95)
!103 = !DILocation(line: 38, column: 44, scope: !95)
!104 = !DILocation(line: 38, column: 33, scope: !95)
!105 = !DILocation(line: 38, column: 50, scope: !95)
!106 = !DILocation(line: 38, column: 48, scope: !95)
!107 = !DILocation(line: 38, column: 31, scope: !95)
!108 = !DILocation(line: 38, column: 9, scope: !95)
!109 = !DILocation(line: 39, column: 5, scope: !95)
!110 = !DILocation(line: 41, column: 20, scope: !53)
!111 = !DILocation(line: 41, column: 37, scope: !53)
!112 = !DILocation(line: 41, column: 26, scope: !53)
!113 = !DILocation(line: 41, column: 5, scope: !53)
!114 = !DILocation(line: 42, column: 13, scope: !53)
!115 = !DILocation(line: 42, column: 12, scope: !53)
!116 = !DILocation(line: 42, column: 19, scope: !53)
!117 = !DILocation(line: 42, column: 5, scope: !53)
!118 = !DILocation(line: 43, column: 12, scope: !53)
!119 = !DILocation(line: 43, column: 14, scope: !53)
!120 = !DILocation(line: 43, column: 5, scope: !53)
!121 = !DILocation(line: 44, column: 5, scope: !53)
!122 = !DILocation(line: 45, column: 1, scope: !53)
