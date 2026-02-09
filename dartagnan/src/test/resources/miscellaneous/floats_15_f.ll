; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/floats.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/floats.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx15.0.0"

%union.anon.1 = type { double }
%union.anon.0 = type { double }
%union.anon = type { float }

@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !0
@.str = private unnamed_addr constant [9 x i8] c"floats.c\00", align 1, !dbg !8
@.str.1 = private unnamed_addr constant [11 x i8] c"min <= max\00", align 1, !dbg !13
@.str.2 = private unnamed_addr constant [32 x i8] c"min == 0 || maxNegImpliesMinNeg\00", align 1, !dbg !18
@.str.3 = private unnamed_addr constant [20 x i8] c"maxNegImpliesMinNeg\00", align 1, !dbg !23

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !43 {
  %1 = alloca double, align 8
  %2 = alloca %union.anon.1, align 8
  %3 = alloca double, align 8
  %4 = alloca %union.anon.0, align 8
  %5 = alloca double, align 8
  %6 = alloca %union.anon.0, align 8
  %7 = alloca float, align 4
  %8 = alloca %union.anon, align 4
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
  %19 = alloca double, align 8
  %20 = alloca double, align 8
  %21 = alloca i32, align 4
  store i32 0, ptr %15, align 4
  call void @llvm.dbg.declare(metadata ptr %16, metadata !47, metadata !DIExpression()), !dbg !48
  %22 = call float @__VERIFIER_nondet_float(), !dbg !49
  store float %22, ptr %16, align 4, !dbg !48
  call void @llvm.dbg.declare(metadata ptr %17, metadata !50, metadata !DIExpression()), !dbg !51
  %23 = call double @__VERIFIER_nondet_double(), !dbg !52
  store double %23, ptr %17, align 8, !dbg !51
  call void @llvm.dbg.declare(metadata ptr %18, metadata !53, metadata !DIExpression()), !dbg !54
  %24 = call double @__VERIFIER_nondet_double(), !dbg !55
  store double %24, ptr %18, align 8, !dbg !54
  br i1 false, label %25, label %33, !dbg !56

25:                                               ; preds = %0
  %26 = load double, ptr %17, align 8, !dbg !58
  %27 = fptrunc double %26 to float, !dbg !58
  store float %27, ptr %13, align 4
  call void @llvm.dbg.declare(metadata ptr %13, metadata !59, metadata !DIExpression()), !dbg !64
  %28 = load float, ptr %13, align 4, !dbg !66
  %29 = load float, ptr %13, align 4, !dbg !67
  %30 = fcmp une float %28, %29, !dbg !68
  %31 = zext i1 %30 to i32, !dbg !68
  %32 = icmp ne i32 %31, 0, !dbg !58
  br i1 %32, label %147, label %48, !dbg !58

33:                                               ; preds = %0
  br i1 true, label %34, label %41, !dbg !56

34:                                               ; preds = %33
  %35 = load double, ptr %17, align 8, !dbg !58
  store double %35, ptr %11, align 8
  call void @llvm.dbg.declare(metadata ptr %11, metadata !69, metadata !DIExpression()), !dbg !73
  %36 = load double, ptr %11, align 8, !dbg !75
  %37 = load double, ptr %11, align 8, !dbg !76
  %38 = fcmp une double %36, %37, !dbg !77
  %39 = zext i1 %38 to i32, !dbg !77
  %40 = icmp ne i32 %39, 0, !dbg !58
  br i1 %40, label %147, label %48, !dbg !58

41:                                               ; preds = %33
  %42 = load double, ptr %17, align 8, !dbg !58
  store double %42, ptr %9, align 8
  call void @llvm.dbg.declare(metadata ptr %9, metadata !78, metadata !DIExpression()), !dbg !82
  %43 = load double, ptr %9, align 8, !dbg !84
  %44 = load double, ptr %9, align 8, !dbg !85
  %45 = fcmp une double %43, %44, !dbg !86
  %46 = zext i1 %45 to i32, !dbg !86
  %47 = icmp ne i32 %46, 0, !dbg !58
  br i1 %47, label %147, label %48, !dbg !56

48:                                               ; preds = %41, %34, %25
  br i1 false, label %49, label %57, !dbg !87

49:                                               ; preds = %48
  %50 = load double, ptr %18, align 8, !dbg !88
  %51 = fptrunc double %50 to float, !dbg !88
  store float %51, ptr %14, align 4
  call void @llvm.dbg.declare(metadata ptr %14, metadata !59, metadata !DIExpression()), !dbg !89
  %52 = load float, ptr %14, align 4, !dbg !91
  %53 = load float, ptr %14, align 4, !dbg !92
  %54 = fcmp une float %52, %53, !dbg !93
  %55 = zext i1 %54 to i32, !dbg !93
  %56 = icmp ne i32 %55, 0, !dbg !88
  br i1 %56, label %147, label %72, !dbg !88

57:                                               ; preds = %48
  br i1 true, label %58, label %65, !dbg !87

58:                                               ; preds = %57
  %59 = load double, ptr %18, align 8, !dbg !88
  store double %59, ptr %12, align 8
  call void @llvm.dbg.declare(metadata ptr %12, metadata !69, metadata !DIExpression()), !dbg !94
  %60 = load double, ptr %12, align 8, !dbg !96
  %61 = load double, ptr %12, align 8, !dbg !97
  %62 = fcmp une double %60, %61, !dbg !98
  %63 = zext i1 %62 to i32, !dbg !98
  %64 = icmp ne i32 %63, 0, !dbg !88
  br i1 %64, label %147, label %72, !dbg !88

65:                                               ; preds = %57
  %66 = load double, ptr %18, align 8, !dbg !88
  store double %66, ptr %10, align 8
  call void @llvm.dbg.declare(metadata ptr %10, metadata !78, metadata !DIExpression()), !dbg !99
  %67 = load double, ptr %10, align 8, !dbg !101
  %68 = load double, ptr %10, align 8, !dbg !102
  %69 = fcmp une double %67, %68, !dbg !103
  %70 = zext i1 %69 to i32, !dbg !103
  %71 = icmp ne i32 %70, 0, !dbg !88
  br i1 %71, label %147, label %72, !dbg !87

72:                                               ; preds = %65, %58, %49
  call void @llvm.dbg.declare(metadata ptr %19, metadata !104, metadata !DIExpression()), !dbg !106
  %73 = load double, ptr %17, align 8, !dbg !107
  %74 = load double, ptr %18, align 8, !dbg !108
  %75 = call double @llvm.minnum.f64(double %73, double %74), !dbg !109
  store double %75, ptr %19, align 8, !dbg !106
  call void @llvm.dbg.declare(metadata ptr %20, metadata !110, metadata !DIExpression()), !dbg !111
  %76 = load double, ptr %17, align 8, !dbg !112
  %77 = load double, ptr %18, align 8, !dbg !113
  %78 = call double @llvm.maxnum.f64(double %76, double %77), !dbg !114
  store double %78, ptr %20, align 8, !dbg !111
  %79 = load double, ptr %19, align 8, !dbg !115
  %80 = load double, ptr %20, align 8, !dbg !115
  %81 = fcmp ole double %79, %80, !dbg !115
  %82 = xor i1 %81, true, !dbg !115
  %83 = zext i1 %82 to i32, !dbg !115
  %84 = sext i32 %83 to i64, !dbg !115
  %85 = icmp ne i64 %84, 0, !dbg !115
  br i1 %85, label %86, label %88, !dbg !115

86:                                               ; preds = %72
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 155, ptr noundef @.str.1) #4, !dbg !115
  unreachable, !dbg !115

87:                                               ; No predecessors!
  br label %89, !dbg !115

88:                                               ; preds = %72
  br label %89, !dbg !115

89:                                               ; preds = %88, %87
  call void @llvm.dbg.declare(metadata ptr %21, metadata !116, metadata !DIExpression()), !dbg !117
  br i1 false, label %90, label %97, !dbg !118

90:                                               ; preds = %89
  %91 = load double, ptr %20, align 8, !dbg !119
  %92 = fptrunc double %91 to float, !dbg !119
  store float %92, ptr %7, align 4
  call void @llvm.dbg.declare(metadata ptr %7, metadata !120, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.declare(metadata ptr %8, metadata !124, metadata !DIExpression()), !dbg !130
  %93 = load float, ptr %7, align 4, !dbg !131
  store float %93, ptr %8, align 4, !dbg !132
  %94 = load i32, ptr %8, align 4, !dbg !133
  %95 = lshr i32 %94, 31, !dbg !134
  %96 = icmp ne i32 %95, 0, !dbg !119
  br i1 %96, label %112, label %119, !dbg !119

97:                                               ; preds = %89
  br i1 true, label %98, label %105, !dbg !118

98:                                               ; preds = %97
  %99 = load double, ptr %20, align 8, !dbg !119
  store double %99, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !135, metadata !DIExpression()), !dbg !137
  call void @llvm.dbg.declare(metadata ptr %4, metadata !139, metadata !DIExpression()), !dbg !145
  %100 = load double, ptr %3, align 8, !dbg !146
  store double %100, ptr %4, align 8, !dbg !147
  %101 = load i64, ptr %4, align 8, !dbg !148
  %102 = lshr i64 %101, 63, !dbg !149
  %103 = trunc i64 %102 to i32, !dbg !150
  %104 = icmp ne i32 %103, 0, !dbg !119
  br i1 %104, label %112, label %119, !dbg !119

105:                                              ; preds = %97
  %106 = load double, ptr %20, align 8, !dbg !119
  store double %106, ptr %1, align 8
  call void @llvm.dbg.declare(metadata ptr %1, metadata !151, metadata !DIExpression()), !dbg !153
  call void @llvm.dbg.declare(metadata ptr %2, metadata !155, metadata !DIExpression()), !dbg !160
  %107 = load double, ptr %1, align 8, !dbg !161
  store double %107, ptr %2, align 8, !dbg !162
  %108 = load i64, ptr %2, align 8, !dbg !163
  %109 = lshr i64 %108, 63, !dbg !164
  %110 = trunc i64 %109 to i32, !dbg !165
  %111 = icmp ne i32 %110, 0, !dbg !119
  br i1 %111, label %112, label %119, !dbg !118

112:                                              ; preds = %105, %98, %90
  %113 = load double, ptr %19, align 8, !dbg !166
  store double %113, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !135, metadata !DIExpression()), !dbg !167
  call void @llvm.dbg.declare(metadata ptr %6, metadata !139, metadata !DIExpression()), !dbg !169
  %114 = load double, ptr %5, align 8, !dbg !170
  store double %114, ptr %6, align 8, !dbg !171
  %115 = load i64, ptr %6, align 8, !dbg !172
  %116 = lshr i64 %115, 63, !dbg !173
  %117 = trunc i64 %116 to i32, !dbg !174
  %118 = icmp ne i32 %117, 0, !dbg !118
  br label %119, !dbg !118

119:                                              ; preds = %112, %105, %98, %90
  %120 = phi i1 [ true, %105 ], [ true, %98 ], [ true, %90 ], [ %118, %112 ]
  %121 = zext i1 %120 to i32, !dbg !118
  store i32 %121, ptr %21, align 4, !dbg !117
  %122 = load double, ptr %19, align 8, !dbg !175
  %123 = fcmp oeq double %122, 0.000000e+00, !dbg !175
  br i1 %123, label %127, label %124, !dbg !175

124:                                              ; preds = %119
  %125 = load i32, ptr %21, align 4, !dbg !175
  %126 = icmp ne i32 %125, 0, !dbg !175
  br label %127, !dbg !175

127:                                              ; preds = %124, %119
  %128 = phi i1 [ true, %119 ], [ %126, %124 ]
  %129 = xor i1 %128, true, !dbg !175
  %130 = zext i1 %129 to i32, !dbg !175
  %131 = sext i32 %130 to i64, !dbg !175
  %132 = icmp ne i64 %131, 0, !dbg !175
  br i1 %132, label %133, label %135, !dbg !175

133:                                              ; preds = %127
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 158, ptr noundef @.str.2) #4, !dbg !175
  unreachable, !dbg !175

134:                                              ; No predecessors!
  br label %136, !dbg !175

135:                                              ; preds = %127
  br label %136, !dbg !175

136:                                              ; preds = %135, %134
  %137 = load i32, ptr %21, align 4, !dbg !176
  %138 = icmp ne i32 %137, 0, !dbg !176
  %139 = xor i1 %138, true, !dbg !176
  %140 = zext i1 %139 to i32, !dbg !176
  %141 = sext i32 %140 to i64, !dbg !176
  %142 = icmp ne i64 %141, 0, !dbg !176
  br i1 %142, label %143, label %145, !dbg !176

143:                                              ; preds = %136
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 160, ptr noundef @.str.3) #4, !dbg !176
  unreachable, !dbg !176

144:                                              ; No predecessors!
  br label %146, !dbg !176

145:                                              ; preds = %136
  br label %146, !dbg !176

146:                                              ; preds = %145, %144
  br label %147, !dbg !177

147:                                              ; preds = %146, %65, %58, %49, %41, %34, %25
  ret i32 0, !dbg !178
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare float @__VERIFIER_nondet_float() #2

declare double @__VERIFIER_nondet_double() #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.minnum.f64(double, double) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.maxnum.f64(double, double) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #4 = { cold noreturn }

!llvm.dbg.cu = !{!28}
!llvm.module.flags = !{!36, !37, !38, !39, !40, !41}
!llvm.ident = !{!42}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 155, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "benchmarks/miscellaneous/floats.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 40, elements: !6)
!4 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !5)
!5 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!6 = !{!7}
!7 = !DISubrange(count: 5)
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(scope: null, file: !2, line: 155, type: !10, isLocal: true, isDefinition: true)
!10 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 72, elements: !11)
!11 = !{!12}
!12 = !DISubrange(count: 9)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(scope: null, file: !2, line: 155, type: !15, isLocal: true, isDefinition: true)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 88, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 11)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !2, line: 158, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 256, elements: !21)
!21 = !{!22}
!22 = !DISubrange(count: 32)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(scope: null, file: !2, line: 160, type: !25, isLocal: true, isDefinition: true)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 160, elements: !26)
!26 = !{!27}
!27 = !DISubrange(count: 20)
!28 = distinct !DICompileUnit(language: DW_LANG_C11, file: !29, producer: "Homebrew clang version 16.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !30, globals: !35, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!29 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/floats.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!30 = !{!31, !32, !33, !34}
!31 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!32 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!33 = !DIBasicType(name: "long double", size: 64, encoding: DW_ATE_float)
!34 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!35 = !{!0, !8, !13, !18, !23}
!36 = !{i32 7, !"Dwarf Version", i32 4}
!37 = !{i32 2, !"Debug Info Version", i32 3}
!38 = !{i32 1, !"wchar_size", i32 4}
!39 = !{i32 8, !"PIC Level", i32 2}
!40 = !{i32 7, !"uwtable", i32 1}
!41 = !{i32 7, !"frame-pointer", i32 1}
!42 = !{!"Homebrew clang version 16.0.6"}
!43 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 13, type: !44, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !28, retainedNodes: !46)
!44 = !DISubroutineType(types: !45)
!45 = !{!34}
!46 = !{}
!47 = !DILocalVariable(name: "f", scope: !43, file: !2, line: 14, type: !31)
!48 = !DILocation(line: 14, column: 12, scope: !43)
!49 = !DILocation(line: 14, column: 16, scope: !43)
!50 = !DILocalVariable(name: "d", scope: !43, file: !2, line: 15, type: !32)
!51 = !DILocation(line: 15, column: 12, scope: !43)
!52 = !DILocation(line: 15, column: 16, scope: !43)
!53 = !DILocalVariable(name: "d2", scope: !43, file: !2, line: 151, type: !32)
!54 = !DILocation(line: 151, column: 13, scope: !43)
!55 = !DILocation(line: 151, column: 18, scope: !43)
!56 = !DILocation(line: 152, column: 20, scope: !57)
!57 = distinct !DILexicalBlock(scope: !43, file: !2, line: 152, column: 10)
!58 = !DILocation(line: 152, column: 11, scope: !57)
!59 = !DILocalVariable(name: "__x", arg: 1, scope: !60, file: !61, line: 214, type: !31)
!60 = distinct !DISubprogram(name: "__inline_isnanf", scope: !61, file: !61, line: 214, type: !62, scopeLine: 214, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !28, retainedNodes: !46)
!61 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/math.h", directory: "")
!62 = !DISubroutineType(types: !63)
!63 = !{!34, !31}
!64 = !DILocation(line: 214, column: 50, scope: !60, inlinedAt: !65)
!65 = distinct !DILocation(line: 152, column: 11, scope: !57)
!66 = !DILocation(line: 215, column: 12, scope: !60, inlinedAt: !65)
!67 = !DILocation(line: 215, column: 19, scope: !60, inlinedAt: !65)
!68 = !DILocation(line: 215, column: 16, scope: !60, inlinedAt: !65)
!69 = !DILocalVariable(name: "__x", arg: 1, scope: !70, file: !61, line: 217, type: !32)
!70 = distinct !DISubprogram(name: "__inline_isnand", scope: !61, file: !61, line: 217, type: !71, scopeLine: 217, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !28, retainedNodes: !46)
!71 = !DISubroutineType(types: !72)
!72 = !{!34, !32}
!73 = !DILocation(line: 217, column: 51, scope: !70, inlinedAt: !74)
!74 = distinct !DILocation(line: 152, column: 11, scope: !57)
!75 = !DILocation(line: 218, column: 12, scope: !70, inlinedAt: !74)
!76 = !DILocation(line: 218, column: 19, scope: !70, inlinedAt: !74)
!77 = !DILocation(line: 218, column: 16, scope: !70, inlinedAt: !74)
!78 = !DILocalVariable(name: "__x", arg: 1, scope: !79, file: !61, line: 220, type: !33)
!79 = distinct !DISubprogram(name: "__inline_isnanl", scope: !61, file: !61, line: 220, type: !80, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !28, retainedNodes: !46)
!80 = !DISubroutineType(types: !81)
!81 = !{!34, !33}
!82 = !DILocation(line: 220, column: 56, scope: !79, inlinedAt: !83)
!83 = distinct !DILocation(line: 152, column: 11, scope: !57)
!84 = !DILocation(line: 221, column: 12, scope: !79, inlinedAt: !83)
!85 = !DILocation(line: 221, column: 19, scope: !79, inlinedAt: !83)
!86 = !DILocation(line: 221, column: 16, scope: !79, inlinedAt: !83)
!87 = !DILocation(line: 152, column: 10, scope: !43)
!88 = !DILocation(line: 152, column: 24, scope: !57)
!89 = !DILocation(line: 214, column: 50, scope: !60, inlinedAt: !90)
!90 = distinct !DILocation(line: 152, column: 24, scope: !57)
!91 = !DILocation(line: 215, column: 12, scope: !60, inlinedAt: !90)
!92 = !DILocation(line: 215, column: 19, scope: !60, inlinedAt: !90)
!93 = !DILocation(line: 215, column: 16, scope: !60, inlinedAt: !90)
!94 = !DILocation(line: 217, column: 51, scope: !70, inlinedAt: !95)
!95 = distinct !DILocation(line: 152, column: 24, scope: !57)
!96 = !DILocation(line: 218, column: 12, scope: !70, inlinedAt: !95)
!97 = !DILocation(line: 218, column: 19, scope: !70, inlinedAt: !95)
!98 = !DILocation(line: 218, column: 16, scope: !70, inlinedAt: !95)
!99 = !DILocation(line: 220, column: 56, scope: !79, inlinedAt: !100)
!100 = distinct !DILocation(line: 152, column: 24, scope: !57)
!101 = !DILocation(line: 221, column: 12, scope: !79, inlinedAt: !100)
!102 = !DILocation(line: 221, column: 19, scope: !79, inlinedAt: !100)
!103 = !DILocation(line: 221, column: 16, scope: !79, inlinedAt: !100)
!104 = !DILocalVariable(name: "min", scope: !105, file: !2, line: 153, type: !32)
!105 = distinct !DILexicalBlock(scope: !57, file: !2, line: 152, column: 35)
!106 = !DILocation(line: 153, column: 17, scope: !105)
!107 = !DILocation(line: 153, column: 28, scope: !105)
!108 = !DILocation(line: 153, column: 31, scope: !105)
!109 = !DILocation(line: 153, column: 23, scope: !105)
!110 = !DILocalVariable(name: "max", scope: !105, file: !2, line: 154, type: !32)
!111 = !DILocation(line: 154, column: 17, scope: !105)
!112 = !DILocation(line: 154, column: 28, scope: !105)
!113 = !DILocation(line: 154, column: 31, scope: !105)
!114 = !DILocation(line: 154, column: 23, scope: !105)
!115 = !DILocation(line: 155, column: 10, scope: !105)
!116 = !DILocalVariable(name: "maxNegImpliesMinNeg", scope: !105, file: !2, line: 157, type: !34)
!117 = !DILocation(line: 157, column: 14, scope: !105)
!118 = !DILocation(line: 157, column: 50, scope: !105)
!119 = !DILocation(line: 157, column: 37, scope: !105)
!120 = !DILocalVariable(name: "__x", arg: 1, scope: !121, file: !61, line: 223, type: !31)
!121 = distinct !DISubprogram(name: "__inline_signbitf", scope: !61, file: !61, line: 223, type: !62, scopeLine: 223, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !28, retainedNodes: !46)
!122 = !DILocation(line: 223, column: 52, scope: !121, inlinedAt: !123)
!123 = distinct !DILocation(line: 157, column: 37, scope: !105)
!124 = !DILocalVariable(name: "__u", scope: !121, file: !61, line: 224, type: !125)
!125 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !121, file: !61, line: 224, size: 32, elements: !126)
!126 = !{!127, !128}
!127 = !DIDerivedType(tag: DW_TAG_member, name: "__f", scope: !125, file: !61, line: 224, baseType: !31, size: 32)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "__u", scope: !125, file: !61, line: 224, baseType: !129, size: 32)
!129 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!130 = !DILocation(line: 224, column: 44, scope: !121, inlinedAt: !123)
!131 = !DILocation(line: 225, column: 15, scope: !121, inlinedAt: !123)
!132 = !DILocation(line: 225, column: 13, scope: !121, inlinedAt: !123)
!133 = !DILocation(line: 226, column: 22, scope: !121, inlinedAt: !123)
!134 = !DILocation(line: 226, column: 26, scope: !121, inlinedAt: !123)
!135 = !DILocalVariable(name: "__x", arg: 1, scope: !136, file: !61, line: 228, type: !32)
!136 = distinct !DISubprogram(name: "__inline_signbitd", scope: !61, file: !61, line: 228, type: !71, scopeLine: 228, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !28, retainedNodes: !46)
!137 = !DILocation(line: 228, column: 53, scope: !136, inlinedAt: !138)
!138 = distinct !DILocation(line: 157, column: 37, scope: !105)
!139 = !DILocalVariable(name: "__u", scope: !136, file: !61, line: 229, type: !140)
!140 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !136, file: !61, line: 229, size: 64, elements: !141)
!141 = !{!142, !143}
!142 = !DIDerivedType(tag: DW_TAG_member, name: "__f", scope: !140, file: !61, line: 229, baseType: !32, size: 64)
!143 = !DIDerivedType(tag: DW_TAG_member, name: "__u", scope: !140, file: !61, line: 229, baseType: !144, size: 64)
!144 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!145 = !DILocation(line: 229, column: 51, scope: !136, inlinedAt: !138)
!146 = !DILocation(line: 230, column: 15, scope: !136, inlinedAt: !138)
!147 = !DILocation(line: 230, column: 13, scope: !136, inlinedAt: !138)
!148 = !DILocation(line: 231, column: 22, scope: !136, inlinedAt: !138)
!149 = !DILocation(line: 231, column: 26, scope: !136, inlinedAt: !138)
!150 = !DILocation(line: 231, column: 12, scope: !136, inlinedAt: !138)
!151 = !DILocalVariable(name: "__x", arg: 1, scope: !152, file: !61, line: 243, type: !33)
!152 = distinct !DISubprogram(name: "__inline_signbitl", scope: !61, file: !61, line: 243, type: !80, scopeLine: 243, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !28, retainedNodes: !46)
!153 = !DILocation(line: 243, column: 58, scope: !152, inlinedAt: !154)
!154 = distinct !DILocation(line: 157, column: 37, scope: !105)
!155 = !DILocalVariable(name: "__u", scope: !152, file: !61, line: 244, type: !156)
!156 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !152, file: !61, line: 244, size: 64, elements: !157)
!157 = !{!158, !159}
!158 = !DIDerivedType(tag: DW_TAG_member, name: "__f", scope: !156, file: !61, line: 244, baseType: !33, size: 64)
!159 = !DIDerivedType(tag: DW_TAG_member, name: "__u", scope: !156, file: !61, line: 244, baseType: !144, size: 64)
!160 = !DILocation(line: 244, column: 55, scope: !152, inlinedAt: !154)
!161 = !DILocation(line: 245, column: 15, scope: !152, inlinedAt: !154)
!162 = !DILocation(line: 245, column: 13, scope: !152, inlinedAt: !154)
!163 = !DILocation(line: 246, column: 22, scope: !152, inlinedAt: !154)
!164 = !DILocation(line: 246, column: 26, scope: !152, inlinedAt: !154)
!165 = !DILocation(line: 246, column: 12, scope: !152, inlinedAt: !154)
!166 = !DILocation(line: 157, column: 53, scope: !105)
!167 = !DILocation(line: 228, column: 53, scope: !136, inlinedAt: !168)
!168 = distinct !DILocation(line: 157, column: 53, scope: !105)
!169 = !DILocation(line: 229, column: 51, scope: !136, inlinedAt: !168)
!170 = !DILocation(line: 230, column: 15, scope: !136, inlinedAt: !168)
!171 = !DILocation(line: 230, column: 13, scope: !136, inlinedAt: !168)
!172 = !DILocation(line: 231, column: 22, scope: !136, inlinedAt: !168)
!173 = !DILocation(line: 231, column: 26, scope: !136, inlinedAt: !168)
!174 = !DILocation(line: 231, column: 12, scope: !136, inlinedAt: !168)
!175 = !DILocation(line: 158, column: 10, scope: !105)
!176 = !DILocation(line: 160, column: 14, scope: !105)
!177 = !DILocation(line: 162, column: 6, scope: !105)
!178 = !DILocation(line: 182, column: 5, scope: !43)
