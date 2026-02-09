; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/floats.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/floats.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx15.0.0"

%union.anon = type { double }

@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !0
@.str = private unnamed_addr constant [9 x i8] c"floats.c\00", align 1, !dbg !8
@.str.1 = private unnamed_addr constant [27 x i8] c"fmax(d, d2) == fmax(d, d2)\00", align 1, !dbg !13
@.str.2 = private unnamed_addr constant [45 x i8] c"signbit(fmax(d, d2)) == signbit(fmax(d, d2))\00", align 1, !dbg !18
@.str.3 = private unnamed_addr constant [27 x i8] c"fmax(d, d2) == fmax(d2, d)\00", align 1, !dbg !23
@.str.4 = private unnamed_addr constant [45 x i8] c"signbit(fmax(d, d2)) == signbit(fmax(d2, d))\00", align 1, !dbg !25

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !42 {
  %1 = alloca double, align 8
  %2 = alloca %union.anon, align 8
  %3 = alloca double, align 8
  %4 = alloca %union.anon, align 8
  %5 = alloca double, align 8
  %6 = alloca %union.anon, align 8
  %7 = alloca double, align 8
  %8 = alloca %union.anon, align 8
  %9 = alloca double, align 8
  %10 = alloca double, align 8
  %11 = alloca double, align 8
  %12 = alloca double, align 8
  %13 = alloca float, align 4
  %14 = alloca float, align 4
  %15 = alloca i32, align 4
  %16 = alloca float, align 4
  %17 = alloca double, align 8
  %18 = alloca double, align 8
  store i32 0, ptr %15, align 4
  call void @llvm.dbg.declare(metadata ptr %16, metadata !46, metadata !DIExpression()), !dbg !47
  %19 = call float @__VERIFIER_nondet_float(), !dbg !48
  store float %19, ptr %16, align 4, !dbg !47
  call void @llvm.dbg.declare(metadata ptr %17, metadata !49, metadata !DIExpression()), !dbg !50
  %20 = call double @__VERIFIER_nondet_double(), !dbg !51
  store double %20, ptr %17, align 8, !dbg !50
  call void @llvm.dbg.declare(metadata ptr %18, metadata !52, metadata !DIExpression()), !dbg !53
  %21 = call double @__VERIFIER_nondet_double(), !dbg !54
  store double %21, ptr %18, align 8, !dbg !53
  br i1 false, label %22, label %30, !dbg !55

22:                                               ; preds = %0
  %23 = load double, ptr %17, align 8, !dbg !57
  %24 = fptrunc double %23 to float, !dbg !57
  store float %24, ptr %13, align 4
  call void @llvm.dbg.declare(metadata ptr %13, metadata !58, metadata !DIExpression()), !dbg !63
  %25 = load float, ptr %13, align 4, !dbg !65
  %26 = load float, ptr %13, align 4, !dbg !66
  %27 = fcmp une float %25, %26, !dbg !67
  %28 = zext i1 %27 to i32, !dbg !67
  %29 = icmp ne i32 %28, 0, !dbg !57
  br i1 %29, label %146, label %45, !dbg !57

30:                                               ; preds = %0
  br i1 true, label %31, label %38, !dbg !55

31:                                               ; preds = %30
  %32 = load double, ptr %17, align 8, !dbg !57
  store double %32, ptr %11, align 8
  call void @llvm.dbg.declare(metadata ptr %11, metadata !68, metadata !DIExpression()), !dbg !72
  %33 = load double, ptr %11, align 8, !dbg !74
  %34 = load double, ptr %11, align 8, !dbg !75
  %35 = fcmp une double %33, %34, !dbg !76
  %36 = zext i1 %35 to i32, !dbg !76
  %37 = icmp ne i32 %36, 0, !dbg !57
  br i1 %37, label %146, label %45, !dbg !57

38:                                               ; preds = %30
  %39 = load double, ptr %17, align 8, !dbg !57
  store double %39, ptr %9, align 8
  call void @llvm.dbg.declare(metadata ptr %9, metadata !77, metadata !DIExpression()), !dbg !81
  %40 = load double, ptr %9, align 8, !dbg !83
  %41 = load double, ptr %9, align 8, !dbg !84
  %42 = fcmp une double %40, %41, !dbg !85
  %43 = zext i1 %42 to i32, !dbg !85
  %44 = icmp ne i32 %43, 0, !dbg !57
  br i1 %44, label %146, label %45, !dbg !55

45:                                               ; preds = %38, %31, %22
  br i1 false, label %46, label %54, !dbg !86

46:                                               ; preds = %45
  %47 = load double, ptr %18, align 8, !dbg !87
  %48 = fptrunc double %47 to float, !dbg !87
  store float %48, ptr %14, align 4
  call void @llvm.dbg.declare(metadata ptr %14, metadata !58, metadata !DIExpression()), !dbg !88
  %49 = load float, ptr %14, align 4, !dbg !90
  %50 = load float, ptr %14, align 4, !dbg !91
  %51 = fcmp une float %49, %50, !dbg !92
  %52 = zext i1 %51 to i32, !dbg !92
  %53 = icmp ne i32 %52, 0, !dbg !87
  br i1 %53, label %146, label %69, !dbg !87

54:                                               ; preds = %45
  br i1 true, label %55, label %62, !dbg !86

55:                                               ; preds = %54
  %56 = load double, ptr %18, align 8, !dbg !87
  store double %56, ptr %12, align 8
  call void @llvm.dbg.declare(metadata ptr %12, metadata !68, metadata !DIExpression()), !dbg !93
  %57 = load double, ptr %12, align 8, !dbg !95
  %58 = load double, ptr %12, align 8, !dbg !96
  %59 = fcmp une double %57, %58, !dbg !97
  %60 = zext i1 %59 to i32, !dbg !97
  %61 = icmp ne i32 %60, 0, !dbg !87
  br i1 %61, label %146, label %69, !dbg !87

62:                                               ; preds = %54
  %63 = load double, ptr %18, align 8, !dbg !87
  store double %63, ptr %10, align 8
  call void @llvm.dbg.declare(metadata ptr %10, metadata !77, metadata !DIExpression()), !dbg !98
  %64 = load double, ptr %10, align 8, !dbg !100
  %65 = load double, ptr %10, align 8, !dbg !101
  %66 = fcmp une double %64, %65, !dbg !102
  %67 = zext i1 %66 to i32, !dbg !102
  %68 = icmp ne i32 %67, 0, !dbg !87
  br i1 %68, label %146, label %69, !dbg !86

69:                                               ; preds = %62, %55, %46
  %70 = load double, ptr %17, align 8, !dbg !103
  %71 = load double, ptr %18, align 8, !dbg !103
  %72 = call double @llvm.maxnum.f64(double %70, double %71), !dbg !103
  %73 = load double, ptr %17, align 8, !dbg !103
  %74 = load double, ptr %18, align 8, !dbg !103
  %75 = call double @llvm.maxnum.f64(double %73, double %74), !dbg !103
  %76 = fcmp oeq double %72, %75, !dbg !103
  %77 = xor i1 %76, true, !dbg !103
  %78 = zext i1 %77 to i32, !dbg !103
  %79 = sext i32 %78 to i64, !dbg !103
  %80 = icmp ne i64 %79, 0, !dbg !103
  br i1 %80, label %81, label %83, !dbg !103

81:                                               ; preds = %69
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 168, ptr noundef @.str.1) #4, !dbg !103
  unreachable, !dbg !103

82:                                               ; No predecessors!
  br label %84, !dbg !103

83:                                               ; preds = %69
  br label %84, !dbg !103

84:                                               ; preds = %83, %82
  %85 = load double, ptr %17, align 8, !dbg !105
  %86 = load double, ptr %18, align 8, !dbg !105
  %87 = call double @llvm.maxnum.f64(double %85, double %86), !dbg !105
  store double %87, ptr %1, align 8
  call void @llvm.dbg.declare(metadata ptr %1, metadata !106, metadata !DIExpression()), !dbg !108
  call void @llvm.dbg.declare(metadata ptr %2, metadata !110, metadata !DIExpression()), !dbg !116
  %88 = load double, ptr %1, align 8, !dbg !117
  store double %88, ptr %2, align 8, !dbg !118
  %89 = load i64, ptr %2, align 8, !dbg !119
  %90 = lshr i64 %89, 63, !dbg !120
  %91 = trunc i64 %90 to i32, !dbg !121
  %92 = load double, ptr %17, align 8, !dbg !105
  %93 = load double, ptr %18, align 8, !dbg !105
  %94 = call double @llvm.maxnum.f64(double %92, double %93), !dbg !105
  store double %94, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !106, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.declare(metadata ptr %4, metadata !110, metadata !DIExpression()), !dbg !124
  %95 = load double, ptr %3, align 8, !dbg !125
  store double %95, ptr %4, align 8, !dbg !126
  %96 = load i64, ptr %4, align 8, !dbg !127
  %97 = lshr i64 %96, 63, !dbg !128
  %98 = trunc i64 %97 to i32, !dbg !129
  %99 = icmp eq i32 %91, %98, !dbg !105
  %100 = xor i1 %99, true, !dbg !105
  %101 = zext i1 %100 to i32, !dbg !105
  %102 = sext i32 %101 to i64, !dbg !105
  %103 = icmp ne i64 %102, 0, !dbg !105
  br i1 %103, label %104, label %106, !dbg !105

104:                                              ; preds = %84
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 169, ptr noundef @.str.2) #4, !dbg !105
  unreachable, !dbg !105

105:                                              ; No predecessors!
  br label %107, !dbg !105

106:                                              ; preds = %84
  br label %107, !dbg !105

107:                                              ; preds = %106, %105
  %108 = load double, ptr %17, align 8, !dbg !130
  %109 = load double, ptr %18, align 8, !dbg !130
  %110 = call double @llvm.maxnum.f64(double %108, double %109), !dbg !130
  %111 = load double, ptr %18, align 8, !dbg !130
  %112 = load double, ptr %17, align 8, !dbg !130
  %113 = call double @llvm.maxnum.f64(double %111, double %112), !dbg !130
  %114 = fcmp oeq double %110, %113, !dbg !130
  %115 = xor i1 %114, true, !dbg !130
  %116 = zext i1 %115 to i32, !dbg !130
  %117 = sext i32 %116 to i64, !dbg !130
  %118 = icmp ne i64 %117, 0, !dbg !130
  br i1 %118, label %119, label %121, !dbg !130

119:                                              ; preds = %107
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 171, ptr noundef @.str.3) #4, !dbg !130
  unreachable, !dbg !130

120:                                              ; No predecessors!
  br label %122, !dbg !130

121:                                              ; preds = %107
  br label %122, !dbg !130

122:                                              ; preds = %121, %120
  %123 = load double, ptr %17, align 8, !dbg !131
  %124 = load double, ptr %18, align 8, !dbg !131
  %125 = call double @llvm.maxnum.f64(double %123, double %124), !dbg !131
  store double %125, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !106, metadata !DIExpression()), !dbg !132
  call void @llvm.dbg.declare(metadata ptr %6, metadata !110, metadata !DIExpression()), !dbg !134
  %126 = load double, ptr %5, align 8, !dbg !135
  store double %126, ptr %6, align 8, !dbg !136
  %127 = load i64, ptr %6, align 8, !dbg !137
  %128 = lshr i64 %127, 63, !dbg !138
  %129 = trunc i64 %128 to i32, !dbg !139
  %130 = load double, ptr %18, align 8, !dbg !131
  %131 = load double, ptr %17, align 8, !dbg !131
  %132 = call double @llvm.maxnum.f64(double %130, double %131), !dbg !131
  store double %132, ptr %7, align 8
  call void @llvm.dbg.declare(metadata ptr %7, metadata !106, metadata !DIExpression()), !dbg !140
  call void @llvm.dbg.declare(metadata ptr %8, metadata !110, metadata !DIExpression()), !dbg !142
  %133 = load double, ptr %7, align 8, !dbg !143
  store double %133, ptr %8, align 8, !dbg !144
  %134 = load i64, ptr %8, align 8, !dbg !145
  %135 = lshr i64 %134, 63, !dbg !146
  %136 = trunc i64 %135 to i32, !dbg !147
  %137 = icmp eq i32 %129, %136, !dbg !131
  %138 = xor i1 %137, true, !dbg !131
  %139 = zext i1 %138 to i32, !dbg !131
  %140 = sext i32 %139 to i64, !dbg !131
  %141 = icmp ne i64 %140, 0, !dbg !131
  br i1 %141, label %142, label %144, !dbg !131

142:                                              ; preds = %122
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 173, ptr noundef @.str.4) #4, !dbg !131
  unreachable, !dbg !131

143:                                              ; No predecessors!
  br label %145, !dbg !131

144:                                              ; preds = %122
  br label %145, !dbg !131

145:                                              ; preds = %144, %143
  br label %146, !dbg !148

146:                                              ; preds = %145, %62, %55, %46, %38, %31, %22
  ret i32 0, !dbg !149
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare float @__VERIFIER_nondet_float() #2

declare double @__VERIFIER_nondet_double() #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.maxnum.f64(double, double) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #4 = { cold noreturn }

!llvm.dbg.cu = !{!27}
!llvm.module.flags = !{!35, !36, !37, !38, !39, !40}
!llvm.ident = !{!41}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 168, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "benchmarks/miscellaneous/floats.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 40, elements: !6)
!4 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !5)
!5 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!6 = !{!7}
!7 = !DISubrange(count: 5)
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(scope: null, file: !2, line: 168, type: !10, isLocal: true, isDefinition: true)
!10 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 72, elements: !11)
!11 = !{!12}
!12 = !DISubrange(count: 9)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(scope: null, file: !2, line: 168, type: !15, isLocal: true, isDefinition: true)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 216, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 27)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !2, line: 169, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 360, elements: !21)
!21 = !{!22}
!22 = !DISubrange(count: 45)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(scope: null, file: !2, line: 171, type: !15, isLocal: true, isDefinition: true)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(scope: null, file: !2, line: 173, type: !20, isLocal: true, isDefinition: true)
!27 = distinct !DICompileUnit(language: DW_LANG_C11, file: !28, producer: "Homebrew clang version 16.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !29, globals: !34, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!28 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/floats.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!29 = !{!30, !31, !32, !33}
!30 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!31 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!32 = !DIBasicType(name: "long double", size: 64, encoding: DW_ATE_float)
!33 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!34 = !{!0, !8, !13, !18, !23, !25}
!35 = !{i32 7, !"Dwarf Version", i32 4}
!36 = !{i32 2, !"Debug Info Version", i32 3}
!37 = !{i32 1, !"wchar_size", i32 4}
!38 = !{i32 8, !"PIC Level", i32 2}
!39 = !{i32 7, !"uwtable", i32 1}
!40 = !{i32 7, !"frame-pointer", i32 1}
!41 = !{!"Homebrew clang version 16.0.6"}
!42 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 13, type: !43, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !27, retainedNodes: !45)
!43 = !DISubroutineType(types: !44)
!44 = !{!33}
!45 = !{}
!46 = !DILocalVariable(name: "f", scope: !42, file: !2, line: 14, type: !30)
!47 = !DILocation(line: 14, column: 12, scope: !42)
!48 = !DILocation(line: 14, column: 16, scope: !42)
!49 = !DILocalVariable(name: "d", scope: !42, file: !2, line: 15, type: !31)
!50 = !DILocation(line: 15, column: 12, scope: !42)
!51 = !DILocation(line: 15, column: 16, scope: !42)
!52 = !DILocalVariable(name: "d2", scope: !42, file: !2, line: 166, type: !31)
!53 = !DILocation(line: 166, column: 12, scope: !42)
!54 = !DILocation(line: 166, column: 17, scope: !42)
!55 = !DILocation(line: 167, column: 19, scope: !56)
!56 = distinct !DILexicalBlock(scope: !42, file: !2, line: 167, column: 9)
!57 = !DILocation(line: 167, column: 10, scope: !56)
!58 = !DILocalVariable(name: "__x", arg: 1, scope: !59, file: !60, line: 214, type: !30)
!59 = distinct !DISubprogram(name: "__inline_isnanf", scope: !60, file: !60, line: 214, type: !61, scopeLine: 214, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !27, retainedNodes: !45)
!60 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/math.h", directory: "")
!61 = !DISubroutineType(types: !62)
!62 = !{!33, !30}
!63 = !DILocation(line: 214, column: 50, scope: !59, inlinedAt: !64)
!64 = distinct !DILocation(line: 167, column: 10, scope: !56)
!65 = !DILocation(line: 215, column: 12, scope: !59, inlinedAt: !64)
!66 = !DILocation(line: 215, column: 19, scope: !59, inlinedAt: !64)
!67 = !DILocation(line: 215, column: 16, scope: !59, inlinedAt: !64)
!68 = !DILocalVariable(name: "__x", arg: 1, scope: !69, file: !60, line: 217, type: !31)
!69 = distinct !DISubprogram(name: "__inline_isnand", scope: !60, file: !60, line: 217, type: !70, scopeLine: 217, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !27, retainedNodes: !45)
!70 = !DISubroutineType(types: !71)
!71 = !{!33, !31}
!72 = !DILocation(line: 217, column: 51, scope: !69, inlinedAt: !73)
!73 = distinct !DILocation(line: 167, column: 10, scope: !56)
!74 = !DILocation(line: 218, column: 12, scope: !69, inlinedAt: !73)
!75 = !DILocation(line: 218, column: 19, scope: !69, inlinedAt: !73)
!76 = !DILocation(line: 218, column: 16, scope: !69, inlinedAt: !73)
!77 = !DILocalVariable(name: "__x", arg: 1, scope: !78, file: !60, line: 220, type: !32)
!78 = distinct !DISubprogram(name: "__inline_isnanl", scope: !60, file: !60, line: 220, type: !79, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !27, retainedNodes: !45)
!79 = !DISubroutineType(types: !80)
!80 = !{!33, !32}
!81 = !DILocation(line: 220, column: 56, scope: !78, inlinedAt: !82)
!82 = distinct !DILocation(line: 167, column: 10, scope: !56)
!83 = !DILocation(line: 221, column: 12, scope: !78, inlinedAt: !82)
!84 = !DILocation(line: 221, column: 19, scope: !78, inlinedAt: !82)
!85 = !DILocation(line: 221, column: 16, scope: !78, inlinedAt: !82)
!86 = !DILocation(line: 167, column: 9, scope: !42)
!87 = !DILocation(line: 167, column: 23, scope: !56)
!88 = !DILocation(line: 214, column: 50, scope: !59, inlinedAt: !89)
!89 = distinct !DILocation(line: 167, column: 23, scope: !56)
!90 = !DILocation(line: 215, column: 12, scope: !59, inlinedAt: !89)
!91 = !DILocation(line: 215, column: 19, scope: !59, inlinedAt: !89)
!92 = !DILocation(line: 215, column: 16, scope: !59, inlinedAt: !89)
!93 = !DILocation(line: 217, column: 51, scope: !69, inlinedAt: !94)
!94 = distinct !DILocation(line: 167, column: 23, scope: !56)
!95 = !DILocation(line: 218, column: 12, scope: !69, inlinedAt: !94)
!96 = !DILocation(line: 218, column: 19, scope: !69, inlinedAt: !94)
!97 = !DILocation(line: 218, column: 16, scope: !69, inlinedAt: !94)
!98 = !DILocation(line: 220, column: 56, scope: !78, inlinedAt: !99)
!99 = distinct !DILocation(line: 167, column: 23, scope: !56)
!100 = !DILocation(line: 221, column: 12, scope: !78, inlinedAt: !99)
!101 = !DILocation(line: 221, column: 19, scope: !78, inlinedAt: !99)
!102 = !DILocation(line: 221, column: 16, scope: !78, inlinedAt: !99)
!103 = !DILocation(line: 168, column: 9, scope: !104)
!104 = distinct !DILexicalBlock(scope: !56, file: !2, line: 167, column: 34)
!105 = !DILocation(line: 169, column: 9, scope: !104)
!106 = !DILocalVariable(name: "__x", arg: 1, scope: !107, file: !60, line: 228, type: !31)
!107 = distinct !DISubprogram(name: "__inline_signbitd", scope: !60, file: !60, line: 228, type: !70, scopeLine: 228, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !27, retainedNodes: !45)
!108 = !DILocation(line: 228, column: 53, scope: !107, inlinedAt: !109)
!109 = distinct !DILocation(line: 169, column: 9, scope: !104)
!110 = !DILocalVariable(name: "__u", scope: !107, file: !60, line: 229, type: !111)
!111 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !107, file: !60, line: 229, size: 64, elements: !112)
!112 = !{!113, !114}
!113 = !DIDerivedType(tag: DW_TAG_member, name: "__f", scope: !111, file: !60, line: 229, baseType: !31, size: 64)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "__u", scope: !111, file: !60, line: 229, baseType: !115, size: 64)
!115 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!116 = !DILocation(line: 229, column: 51, scope: !107, inlinedAt: !109)
!117 = !DILocation(line: 230, column: 15, scope: !107, inlinedAt: !109)
!118 = !DILocation(line: 230, column: 13, scope: !107, inlinedAt: !109)
!119 = !DILocation(line: 231, column: 22, scope: !107, inlinedAt: !109)
!120 = !DILocation(line: 231, column: 26, scope: !107, inlinedAt: !109)
!121 = !DILocation(line: 231, column: 12, scope: !107, inlinedAt: !109)
!122 = !DILocation(line: 228, column: 53, scope: !107, inlinedAt: !123)
!123 = distinct !DILocation(line: 169, column: 9, scope: !104)
!124 = !DILocation(line: 229, column: 51, scope: !107, inlinedAt: !123)
!125 = !DILocation(line: 230, column: 15, scope: !107, inlinedAt: !123)
!126 = !DILocation(line: 230, column: 13, scope: !107, inlinedAt: !123)
!127 = !DILocation(line: 231, column: 22, scope: !107, inlinedAt: !123)
!128 = !DILocation(line: 231, column: 26, scope: !107, inlinedAt: !123)
!129 = !DILocation(line: 231, column: 12, scope: !107, inlinedAt: !123)
!130 = !DILocation(line: 171, column: 9, scope: !104)
!131 = !DILocation(line: 173, column: 9, scope: !104)
!132 = !DILocation(line: 228, column: 53, scope: !107, inlinedAt: !133)
!133 = distinct !DILocation(line: 173, column: 9, scope: !104)
!134 = !DILocation(line: 229, column: 51, scope: !107, inlinedAt: !133)
!135 = !DILocation(line: 230, column: 15, scope: !107, inlinedAt: !133)
!136 = !DILocation(line: 230, column: 13, scope: !107, inlinedAt: !133)
!137 = !DILocation(line: 231, column: 22, scope: !107, inlinedAt: !133)
!138 = !DILocation(line: 231, column: 26, scope: !107, inlinedAt: !133)
!139 = !DILocation(line: 231, column: 12, scope: !107, inlinedAt: !133)
!140 = !DILocation(line: 228, column: 53, scope: !107, inlinedAt: !141)
!141 = distinct !DILocation(line: 173, column: 9, scope: !104)
!142 = !DILocation(line: 229, column: 51, scope: !107, inlinedAt: !141)
!143 = !DILocation(line: 230, column: 15, scope: !107, inlinedAt: !141)
!144 = !DILocation(line: 230, column: 13, scope: !107, inlinedAt: !141)
!145 = !DILocation(line: 231, column: 22, scope: !107, inlinedAt: !141)
!146 = !DILocation(line: 231, column: 26, scope: !107, inlinedAt: !141)
!147 = !DILocation(line: 231, column: 12, scope: !107, inlinedAt: !141)
!148 = !DILocation(line: 175, column: 5, scope: !104)
!149 = !DILocation(line: 182, column: 5, scope: !42)
