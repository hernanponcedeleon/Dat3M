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

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !38 {
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
  call void @llvm.dbg.declare(metadata ptr %16, metadata !42, metadata !DIExpression()), !dbg !43
  %22 = call float @__VERIFIER_nondet_float(), !dbg !44
  store float %22, ptr %16, align 4, !dbg !43
  call void @llvm.dbg.declare(metadata ptr %17, metadata !45, metadata !DIExpression()), !dbg !46
  %23 = call double @__VERIFIER_nondet_double(), !dbg !47
  store double %23, ptr %17, align 8, !dbg !46
  call void @llvm.dbg.declare(metadata ptr %18, metadata !48, metadata !DIExpression()), !dbg !49
  %24 = call double @__VERIFIER_nondet_double(), !dbg !50
  store double %24, ptr %18, align 8, !dbg !49
  br i1 false, label %25, label %33, !dbg !51

25:                                               ; preds = %0
  %26 = load double, ptr %17, align 8, !dbg !53
  %27 = fptrunc double %26 to float, !dbg !53
  store float %27, ptr %13, align 4
  call void @llvm.dbg.declare(metadata ptr %13, metadata !54, metadata !DIExpression()), !dbg !59
  %28 = load float, ptr %13, align 4, !dbg !61
  %29 = load float, ptr %13, align 4, !dbg !62
  %30 = fcmp une float %28, %29, !dbg !63
  %31 = zext i1 %30 to i32, !dbg !63
  %32 = icmp ne i32 %31, 0, !dbg !53
  br i1 %32, label %137, label %48, !dbg !53

33:                                               ; preds = %0
  br i1 true, label %34, label %41, !dbg !51

34:                                               ; preds = %33
  %35 = load double, ptr %17, align 8, !dbg !53
  store double %35, ptr %11, align 8
  call void @llvm.dbg.declare(metadata ptr %11, metadata !64, metadata !DIExpression()), !dbg !68
  %36 = load double, ptr %11, align 8, !dbg !70
  %37 = load double, ptr %11, align 8, !dbg !71
  %38 = fcmp une double %36, %37, !dbg !72
  %39 = zext i1 %38 to i32, !dbg !72
  %40 = icmp ne i32 %39, 0, !dbg !53
  br i1 %40, label %137, label %48, !dbg !53

41:                                               ; preds = %33
  %42 = load double, ptr %17, align 8, !dbg !53
  store double %42, ptr %9, align 8
  call void @llvm.dbg.declare(metadata ptr %9, metadata !73, metadata !DIExpression()), !dbg !77
  %43 = load double, ptr %9, align 8, !dbg !79
  %44 = load double, ptr %9, align 8, !dbg !80
  %45 = fcmp une double %43, %44, !dbg !81
  %46 = zext i1 %45 to i32, !dbg !81
  %47 = icmp ne i32 %46, 0, !dbg !53
  br i1 %47, label %137, label %48, !dbg !51

48:                                               ; preds = %41, %34, %25
  br i1 false, label %49, label %57, !dbg !82

49:                                               ; preds = %48
  %50 = load double, ptr %18, align 8, !dbg !83
  %51 = fptrunc double %50 to float, !dbg !83
  store float %51, ptr %14, align 4
  call void @llvm.dbg.declare(metadata ptr %14, metadata !54, metadata !DIExpression()), !dbg !84
  %52 = load float, ptr %14, align 4, !dbg !86
  %53 = load float, ptr %14, align 4, !dbg !87
  %54 = fcmp une float %52, %53, !dbg !88
  %55 = zext i1 %54 to i32, !dbg !88
  %56 = icmp ne i32 %55, 0, !dbg !83
  br i1 %56, label %137, label %72, !dbg !83

57:                                               ; preds = %48
  br i1 true, label %58, label %65, !dbg !82

58:                                               ; preds = %57
  %59 = load double, ptr %18, align 8, !dbg !83
  store double %59, ptr %12, align 8
  call void @llvm.dbg.declare(metadata ptr %12, metadata !64, metadata !DIExpression()), !dbg !89
  %60 = load double, ptr %12, align 8, !dbg !91
  %61 = load double, ptr %12, align 8, !dbg !92
  %62 = fcmp une double %60, %61, !dbg !93
  %63 = zext i1 %62 to i32, !dbg !93
  %64 = icmp ne i32 %63, 0, !dbg !83
  br i1 %64, label %137, label %72, !dbg !83

65:                                               ; preds = %57
  %66 = load double, ptr %18, align 8, !dbg !83
  store double %66, ptr %10, align 8
  call void @llvm.dbg.declare(metadata ptr %10, metadata !73, metadata !DIExpression()), !dbg !94
  %67 = load double, ptr %10, align 8, !dbg !96
  %68 = load double, ptr %10, align 8, !dbg !97
  %69 = fcmp une double %67, %68, !dbg !98
  %70 = zext i1 %69 to i32, !dbg !98
  %71 = icmp ne i32 %70, 0, !dbg !83
  br i1 %71, label %137, label %72, !dbg !82

72:                                               ; preds = %65, %58, %49
  call void @llvm.dbg.declare(metadata ptr %19, metadata !99, metadata !DIExpression()), !dbg !101
  %73 = load double, ptr %17, align 8, !dbg !102
  %74 = load double, ptr %18, align 8, !dbg !103
  %75 = call double @llvm.minnum.f64(double %73, double %74), !dbg !104
  store double %75, ptr %19, align 8, !dbg !101
  call void @llvm.dbg.declare(metadata ptr %20, metadata !105, metadata !DIExpression()), !dbg !106
  %76 = load double, ptr %17, align 8, !dbg !107
  %77 = load double, ptr %18, align 8, !dbg !108
  %78 = call double @llvm.maxnum.f64(double %76, double %77), !dbg !109
  store double %78, ptr %20, align 8, !dbg !106
  %79 = load double, ptr %19, align 8, !dbg !110
  %80 = load double, ptr %20, align 8, !dbg !110
  %81 = fcmp ole double %79, %80, !dbg !110
  %82 = xor i1 %81, true, !dbg !110
  %83 = zext i1 %82 to i32, !dbg !110
  %84 = sext i32 %83 to i64, !dbg !110
  %85 = icmp ne i64 %84, 0, !dbg !110
  br i1 %85, label %86, label %88, !dbg !110

86:                                               ; preds = %72
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 153, ptr noundef @.str.1) #4, !dbg !110
  unreachable, !dbg !110

87:                                               ; No predecessors!
  br label %89, !dbg !110

88:                                               ; preds = %72
  br label %89, !dbg !110

89:                                               ; preds = %88, %87
  call void @llvm.dbg.declare(metadata ptr %21, metadata !111, metadata !DIExpression()), !dbg !112
  br i1 false, label %90, label %97, !dbg !113

90:                                               ; preds = %89
  %91 = load double, ptr %20, align 8, !dbg !114
  %92 = fptrunc double %91 to float, !dbg !114
  store float %92, ptr %7, align 4
  call void @llvm.dbg.declare(metadata ptr %7, metadata !115, metadata !DIExpression()), !dbg !117
  call void @llvm.dbg.declare(metadata ptr %8, metadata !119, metadata !DIExpression()), !dbg !125
  %93 = load float, ptr %7, align 4, !dbg !126
  store float %93, ptr %8, align 4, !dbg !127
  %94 = load i32, ptr %8, align 4, !dbg !128
  %95 = lshr i32 %94, 31, !dbg !129
  %96 = icmp ne i32 %95, 0, !dbg !114
  br i1 %96, label %112, label %119, !dbg !114

97:                                               ; preds = %89
  br i1 true, label %98, label %105, !dbg !113

98:                                               ; preds = %97
  %99 = load double, ptr %20, align 8, !dbg !114
  store double %99, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !130, metadata !DIExpression()), !dbg !132
  call void @llvm.dbg.declare(metadata ptr %4, metadata !134, metadata !DIExpression()), !dbg !140
  %100 = load double, ptr %3, align 8, !dbg !141
  store double %100, ptr %4, align 8, !dbg !142
  %101 = load i64, ptr %4, align 8, !dbg !143
  %102 = lshr i64 %101, 63, !dbg !144
  %103 = trunc i64 %102 to i32, !dbg !145
  %104 = icmp ne i32 %103, 0, !dbg !114
  br i1 %104, label %112, label %119, !dbg !114

105:                                              ; preds = %97
  %106 = load double, ptr %20, align 8, !dbg !114
  store double %106, ptr %1, align 8
  call void @llvm.dbg.declare(metadata ptr %1, metadata !146, metadata !DIExpression()), !dbg !148
  call void @llvm.dbg.declare(metadata ptr %2, metadata !150, metadata !DIExpression()), !dbg !155
  %107 = load double, ptr %1, align 8, !dbg !156
  store double %107, ptr %2, align 8, !dbg !157
  %108 = load i64, ptr %2, align 8, !dbg !158
  %109 = lshr i64 %108, 63, !dbg !159
  %110 = trunc i64 %109 to i32, !dbg !160
  %111 = icmp ne i32 %110, 0, !dbg !114
  br i1 %111, label %112, label %119, !dbg !113

112:                                              ; preds = %105, %98, %90
  %113 = load double, ptr %19, align 8, !dbg !161
  store double %113, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !130, metadata !DIExpression()), !dbg !162
  call void @llvm.dbg.declare(metadata ptr %6, metadata !134, metadata !DIExpression()), !dbg !164
  %114 = load double, ptr %5, align 8, !dbg !165
  store double %114, ptr %6, align 8, !dbg !166
  %115 = load i64, ptr %6, align 8, !dbg !167
  %116 = lshr i64 %115, 63, !dbg !168
  %117 = trunc i64 %116 to i32, !dbg !169
  %118 = icmp ne i32 %117, 0, !dbg !113
  br label %119, !dbg !113

119:                                              ; preds = %112, %105, %98, %90
  %120 = phi i1 [ true, %105 ], [ true, %98 ], [ true, %90 ], [ %118, %112 ]
  %121 = zext i1 %120 to i32, !dbg !113
  store i32 %121, ptr %21, align 4, !dbg !112
  %122 = load double, ptr %19, align 8, !dbg !170
  %123 = fcmp oeq double %122, 0.000000e+00, !dbg !170
  br i1 %123, label %127, label %124, !dbg !170

124:                                              ; preds = %119
  %125 = load i32, ptr %21, align 4, !dbg !170
  %126 = icmp ne i32 %125, 0, !dbg !170
  br label %127, !dbg !170

127:                                              ; preds = %124, %119
  %128 = phi i1 [ true, %119 ], [ %126, %124 ]
  %129 = xor i1 %128, true, !dbg !170
  %130 = zext i1 %129 to i32, !dbg !170
  %131 = sext i32 %130 to i64, !dbg !170
  %132 = icmp ne i64 %131, 0, !dbg !170
  br i1 %132, label %133, label %135, !dbg !170

133:                                              ; preds = %127
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 156, ptr noundef @.str.2) #4, !dbg !170
  unreachable, !dbg !170

134:                                              ; No predecessors!
  br label %136, !dbg !170

135:                                              ; preds = %127
  br label %136, !dbg !170

136:                                              ; preds = %135, %134
  br label %137, !dbg !171

137:                                              ; preds = %136, %65, %58, %49, %41, %34, %25
  ret i32 0, !dbg !172
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

!llvm.dbg.cu = !{!23}
!llvm.module.flags = !{!31, !32, !33, !34, !35, !36}
!llvm.ident = !{!37}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 153, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "benchmarks/miscellaneous/floats.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 40, elements: !6)
!4 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !5)
!5 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!6 = !{!7}
!7 = !DISubrange(count: 5)
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(scope: null, file: !2, line: 153, type: !10, isLocal: true, isDefinition: true)
!10 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 72, elements: !11)
!11 = !{!12}
!12 = !DISubrange(count: 9)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(scope: null, file: !2, line: 153, type: !15, isLocal: true, isDefinition: true)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 88, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 11)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !2, line: 156, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 256, elements: !21)
!21 = !{!22}
!22 = !DISubrange(count: 32)
!23 = distinct !DICompileUnit(language: DW_LANG_C11, file: !24, producer: "Homebrew clang version 16.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !25, globals: !30, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!24 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/floats.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!25 = !{!26, !27, !28, !29}
!26 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!27 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!28 = !DIBasicType(name: "long double", size: 64, encoding: DW_ATE_float)
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !{!0, !8, !13, !18}
!31 = !{i32 7, !"Dwarf Version", i32 4}
!32 = !{i32 2, !"Debug Info Version", i32 3}
!33 = !{i32 1, !"wchar_size", i32 4}
!34 = !{i32 8, !"PIC Level", i32 2}
!35 = !{i32 7, !"uwtable", i32 1}
!36 = !{i32 7, !"frame-pointer", i32 1}
!37 = !{!"Homebrew clang version 16.0.6"}
!38 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 11, type: !39, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !23, retainedNodes: !41)
!39 = !DISubroutineType(types: !40)
!40 = !{!29}
!41 = !{}
!42 = !DILocalVariable(name: "f", scope: !38, file: !2, line: 12, type: !26)
!43 = !DILocation(line: 12, column: 12, scope: !38)
!44 = !DILocation(line: 12, column: 16, scope: !38)
!45 = !DILocalVariable(name: "d", scope: !38, file: !2, line: 13, type: !27)
!46 = !DILocation(line: 13, column: 12, scope: !38)
!47 = !DILocation(line: 13, column: 16, scope: !38)
!48 = !DILocalVariable(name: "d2", scope: !38, file: !2, line: 149, type: !27)
!49 = !DILocation(line: 149, column: 13, scope: !38)
!50 = !DILocation(line: 149, column: 18, scope: !38)
!51 = !DILocation(line: 150, column: 20, scope: !52)
!52 = distinct !DILexicalBlock(scope: !38, file: !2, line: 150, column: 10)
!53 = !DILocation(line: 150, column: 11, scope: !52)
!54 = !DILocalVariable(name: "__x", arg: 1, scope: !55, file: !56, line: 214, type: !26)
!55 = distinct !DISubprogram(name: "__inline_isnanf", scope: !56, file: !56, line: 214, type: !57, scopeLine: 214, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !23, retainedNodes: !41)
!56 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/math.h", directory: "")
!57 = !DISubroutineType(types: !58)
!58 = !{!29, !26}
!59 = !DILocation(line: 214, column: 50, scope: !55, inlinedAt: !60)
!60 = distinct !DILocation(line: 150, column: 11, scope: !52)
!61 = !DILocation(line: 215, column: 12, scope: !55, inlinedAt: !60)
!62 = !DILocation(line: 215, column: 19, scope: !55, inlinedAt: !60)
!63 = !DILocation(line: 215, column: 16, scope: !55, inlinedAt: !60)
!64 = !DILocalVariable(name: "__x", arg: 1, scope: !65, file: !56, line: 217, type: !27)
!65 = distinct !DISubprogram(name: "__inline_isnand", scope: !56, file: !56, line: 217, type: !66, scopeLine: 217, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !23, retainedNodes: !41)
!66 = !DISubroutineType(types: !67)
!67 = !{!29, !27}
!68 = !DILocation(line: 217, column: 51, scope: !65, inlinedAt: !69)
!69 = distinct !DILocation(line: 150, column: 11, scope: !52)
!70 = !DILocation(line: 218, column: 12, scope: !65, inlinedAt: !69)
!71 = !DILocation(line: 218, column: 19, scope: !65, inlinedAt: !69)
!72 = !DILocation(line: 218, column: 16, scope: !65, inlinedAt: !69)
!73 = !DILocalVariable(name: "__x", arg: 1, scope: !74, file: !56, line: 220, type: !28)
!74 = distinct !DISubprogram(name: "__inline_isnanl", scope: !56, file: !56, line: 220, type: !75, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !23, retainedNodes: !41)
!75 = !DISubroutineType(types: !76)
!76 = !{!29, !28}
!77 = !DILocation(line: 220, column: 56, scope: !74, inlinedAt: !78)
!78 = distinct !DILocation(line: 150, column: 11, scope: !52)
!79 = !DILocation(line: 221, column: 12, scope: !74, inlinedAt: !78)
!80 = !DILocation(line: 221, column: 19, scope: !74, inlinedAt: !78)
!81 = !DILocation(line: 221, column: 16, scope: !74, inlinedAt: !78)
!82 = !DILocation(line: 150, column: 10, scope: !38)
!83 = !DILocation(line: 150, column: 24, scope: !52)
!84 = !DILocation(line: 214, column: 50, scope: !55, inlinedAt: !85)
!85 = distinct !DILocation(line: 150, column: 24, scope: !52)
!86 = !DILocation(line: 215, column: 12, scope: !55, inlinedAt: !85)
!87 = !DILocation(line: 215, column: 19, scope: !55, inlinedAt: !85)
!88 = !DILocation(line: 215, column: 16, scope: !55, inlinedAt: !85)
!89 = !DILocation(line: 217, column: 51, scope: !65, inlinedAt: !90)
!90 = distinct !DILocation(line: 150, column: 24, scope: !52)
!91 = !DILocation(line: 218, column: 12, scope: !65, inlinedAt: !90)
!92 = !DILocation(line: 218, column: 19, scope: !65, inlinedAt: !90)
!93 = !DILocation(line: 218, column: 16, scope: !65, inlinedAt: !90)
!94 = !DILocation(line: 220, column: 56, scope: !74, inlinedAt: !95)
!95 = distinct !DILocation(line: 150, column: 24, scope: !52)
!96 = !DILocation(line: 221, column: 12, scope: !74, inlinedAt: !95)
!97 = !DILocation(line: 221, column: 19, scope: !74, inlinedAt: !95)
!98 = !DILocation(line: 221, column: 16, scope: !74, inlinedAt: !95)
!99 = !DILocalVariable(name: "min", scope: !100, file: !2, line: 151, type: !27)
!100 = distinct !DILexicalBlock(scope: !52, file: !2, line: 150, column: 35)
!101 = !DILocation(line: 151, column: 17, scope: !100)
!102 = !DILocation(line: 151, column: 28, scope: !100)
!103 = !DILocation(line: 151, column: 31, scope: !100)
!104 = !DILocation(line: 151, column: 23, scope: !100)
!105 = !DILocalVariable(name: "max", scope: !100, file: !2, line: 152, type: !27)
!106 = !DILocation(line: 152, column: 17, scope: !100)
!107 = !DILocation(line: 152, column: 28, scope: !100)
!108 = !DILocation(line: 152, column: 31, scope: !100)
!109 = !DILocation(line: 152, column: 23, scope: !100)
!110 = !DILocation(line: 153, column: 10, scope: !100)
!111 = !DILocalVariable(name: "maxNegImpliesMinNeg", scope: !100, file: !2, line: 155, type: !29)
!112 = !DILocation(line: 155, column: 14, scope: !100)
!113 = !DILocation(line: 155, column: 50, scope: !100)
!114 = !DILocation(line: 155, column: 37, scope: !100)
!115 = !DILocalVariable(name: "__x", arg: 1, scope: !116, file: !56, line: 223, type: !26)
!116 = distinct !DISubprogram(name: "__inline_signbitf", scope: !56, file: !56, line: 223, type: !57, scopeLine: 223, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !23, retainedNodes: !41)
!117 = !DILocation(line: 223, column: 52, scope: !116, inlinedAt: !118)
!118 = distinct !DILocation(line: 155, column: 37, scope: !100)
!119 = !DILocalVariable(name: "__u", scope: !116, file: !56, line: 224, type: !120)
!120 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !116, file: !56, line: 224, size: 32, elements: !121)
!121 = !{!122, !123}
!122 = !DIDerivedType(tag: DW_TAG_member, name: "__f", scope: !120, file: !56, line: 224, baseType: !26, size: 32)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "__u", scope: !120, file: !56, line: 224, baseType: !124, size: 32)
!124 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!125 = !DILocation(line: 224, column: 44, scope: !116, inlinedAt: !118)
!126 = !DILocation(line: 225, column: 15, scope: !116, inlinedAt: !118)
!127 = !DILocation(line: 225, column: 13, scope: !116, inlinedAt: !118)
!128 = !DILocation(line: 226, column: 22, scope: !116, inlinedAt: !118)
!129 = !DILocation(line: 226, column: 26, scope: !116, inlinedAt: !118)
!130 = !DILocalVariable(name: "__x", arg: 1, scope: !131, file: !56, line: 228, type: !27)
!131 = distinct !DISubprogram(name: "__inline_signbitd", scope: !56, file: !56, line: 228, type: !66, scopeLine: 228, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !23, retainedNodes: !41)
!132 = !DILocation(line: 228, column: 53, scope: !131, inlinedAt: !133)
!133 = distinct !DILocation(line: 155, column: 37, scope: !100)
!134 = !DILocalVariable(name: "__u", scope: !131, file: !56, line: 229, type: !135)
!135 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !131, file: !56, line: 229, size: 64, elements: !136)
!136 = !{!137, !138}
!137 = !DIDerivedType(tag: DW_TAG_member, name: "__f", scope: !135, file: !56, line: 229, baseType: !27, size: 64)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "__u", scope: !135, file: !56, line: 229, baseType: !139, size: 64)
!139 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!140 = !DILocation(line: 229, column: 51, scope: !131, inlinedAt: !133)
!141 = !DILocation(line: 230, column: 15, scope: !131, inlinedAt: !133)
!142 = !DILocation(line: 230, column: 13, scope: !131, inlinedAt: !133)
!143 = !DILocation(line: 231, column: 22, scope: !131, inlinedAt: !133)
!144 = !DILocation(line: 231, column: 26, scope: !131, inlinedAt: !133)
!145 = !DILocation(line: 231, column: 12, scope: !131, inlinedAt: !133)
!146 = !DILocalVariable(name: "__x", arg: 1, scope: !147, file: !56, line: 243, type: !28)
!147 = distinct !DISubprogram(name: "__inline_signbitl", scope: !56, file: !56, line: 243, type: !75, scopeLine: 243, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !23, retainedNodes: !41)
!148 = !DILocation(line: 243, column: 58, scope: !147, inlinedAt: !149)
!149 = distinct !DILocation(line: 155, column: 37, scope: !100)
!150 = !DILocalVariable(name: "__u", scope: !147, file: !56, line: 244, type: !151)
!151 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !147, file: !56, line: 244, size: 64, elements: !152)
!152 = !{!153, !154}
!153 = !DIDerivedType(tag: DW_TAG_member, name: "__f", scope: !151, file: !56, line: 244, baseType: !28, size: 64)
!154 = !DIDerivedType(tag: DW_TAG_member, name: "__u", scope: !151, file: !56, line: 244, baseType: !139, size: 64)
!155 = !DILocation(line: 244, column: 55, scope: !147, inlinedAt: !149)
!156 = !DILocation(line: 245, column: 15, scope: !147, inlinedAt: !149)
!157 = !DILocation(line: 245, column: 13, scope: !147, inlinedAt: !149)
!158 = !DILocation(line: 246, column: 22, scope: !147, inlinedAt: !149)
!159 = !DILocation(line: 246, column: 26, scope: !147, inlinedAt: !149)
!160 = !DILocation(line: 246, column: 12, scope: !147, inlinedAt: !149)
!161 = !DILocation(line: 155, column: 53, scope: !100)
!162 = !DILocation(line: 228, column: 53, scope: !131, inlinedAt: !163)
!163 = distinct !DILocation(line: 155, column: 53, scope: !100)
!164 = !DILocation(line: 229, column: 51, scope: !131, inlinedAt: !163)
!165 = !DILocation(line: 230, column: 15, scope: !131, inlinedAt: !163)
!166 = !DILocation(line: 230, column: 13, scope: !131, inlinedAt: !163)
!167 = !DILocation(line: 231, column: 22, scope: !131, inlinedAt: !163)
!168 = !DILocation(line: 231, column: 26, scope: !131, inlinedAt: !163)
!169 = !DILocation(line: 231, column: 12, scope: !131, inlinedAt: !163)
!170 = !DILocation(line: 156, column: 10, scope: !100)
!171 = !DILocation(line: 160, column: 6, scope: !100)
!172 = !DILocation(line: 180, column: 5, scope: !38)
