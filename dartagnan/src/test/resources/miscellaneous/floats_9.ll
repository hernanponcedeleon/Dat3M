; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/floats.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/floats.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx15.0.0"

@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !0
@.str = private unnamed_addr constant [9 x i8] c"floats.c\00", align 1, !dbg !8
@.str.1 = private unnamed_addr constant [20 x i8] c"fmin(d, 1.0) == 1.0\00", align 1, !dbg !13
@.str.2 = private unnamed_addr constant [20 x i8] c"fmax(d, 1.0) == 1.0\00", align 1, !dbg !18

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !34 {
  %1 = alloca double, align 8
  %2 = alloca double, align 8
  %3 = alloca float, align 4
  %4 = alloca i32, align 4
  %5 = alloca float, align 4
  %6 = alloca double, align 8
  store i32 0, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %5, metadata !39, metadata !DIExpression()), !dbg !40
  %7 = call float @__VERIFIER_nondet_float(), !dbg !41
  store float %7, ptr %5, align 4, !dbg !40
  call void @llvm.dbg.declare(metadata ptr %6, metadata !42, metadata !DIExpression()), !dbg !43
  %8 = call double @__VERIFIER_nondet_double(), !dbg !44
  store double %8, ptr %6, align 8, !dbg !43
  br i1 false, label %9, label %17, !dbg !45

9:                                                ; preds = %0
  %10 = load double, ptr %6, align 8, !dbg !46
  %11 = fptrunc double %10 to float, !dbg !46
  store float %11, ptr %3, align 4
  call void @llvm.dbg.declare(metadata ptr %3, metadata !48, metadata !DIExpression()), !dbg !53
  %12 = load float, ptr %3, align 4, !dbg !55
  %13 = load float, ptr %3, align 4, !dbg !56
  %14 = fcmp une float %12, %13, !dbg !57
  %15 = zext i1 %14 to i32, !dbg !57
  %16 = icmp ne i32 %15, 0, !dbg !46
  br i1 %16, label %32, label %55, !dbg !46

17:                                               ; preds = %0
  br i1 true, label %18, label %25, !dbg !45

18:                                               ; preds = %17
  %19 = load double, ptr %6, align 8, !dbg !46
  store double %19, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !58, metadata !DIExpression()), !dbg !62
  %20 = load double, ptr %2, align 8, !dbg !64
  %21 = load double, ptr %2, align 8, !dbg !65
  %22 = fcmp une double %20, %21, !dbg !66
  %23 = zext i1 %22 to i32, !dbg !66
  %24 = icmp ne i32 %23, 0, !dbg !46
  br i1 %24, label %32, label %55, !dbg !46

25:                                               ; preds = %17
  %26 = load double, ptr %6, align 8, !dbg !46
  store double %26, ptr %1, align 8
  call void @llvm.dbg.declare(metadata ptr %1, metadata !67, metadata !DIExpression()), !dbg !71
  %27 = load double, ptr %1, align 8, !dbg !73
  %28 = load double, ptr %1, align 8, !dbg !74
  %29 = fcmp une double %27, %28, !dbg !75
  %30 = zext i1 %29 to i32, !dbg !75
  %31 = icmp ne i32 %30, 0, !dbg !46
  br i1 %31, label %32, label %55, !dbg !45

32:                                               ; preds = %25, %18, %9
  %33 = load double, ptr %6, align 8, !dbg !76
  %34 = call double @llvm.minnum.f64(double %33, double 1.000000e+00), !dbg !76
  %35 = fcmp oeq double %34, 1.000000e+00, !dbg !76
  %36 = xor i1 %35, true, !dbg !76
  %37 = zext i1 %36 to i32, !dbg !76
  %38 = sext i32 %37 to i64, !dbg !76
  %39 = icmp ne i64 %38, 0, !dbg !76
  br i1 %39, label %40, label %42, !dbg !76

40:                                               ; preds = %32
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 95, ptr noundef @.str.1) #4, !dbg !76
  unreachable, !dbg !76

41:                                               ; No predecessors!
  br label %43, !dbg !76

42:                                               ; preds = %32
  br label %43, !dbg !76

43:                                               ; preds = %42, %41
  %44 = load double, ptr %6, align 8, !dbg !78
  %45 = call double @llvm.maxnum.f64(double %44, double 1.000000e+00), !dbg !78
  %46 = fcmp oeq double %45, 1.000000e+00, !dbg !78
  %47 = xor i1 %46, true, !dbg !78
  %48 = zext i1 %47 to i32, !dbg !78
  %49 = sext i32 %48 to i64, !dbg !78
  %50 = icmp ne i64 %49, 0, !dbg !78
  br i1 %50, label %51, label %53, !dbg !78

51:                                               ; preds = %43
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 96, ptr noundef @.str.2) #4, !dbg !78
  unreachable, !dbg !78

52:                                               ; No predecessors!
  br label %54, !dbg !78

53:                                               ; preds = %43
  br label %54, !dbg !78

54:                                               ; preds = %53, %52
  br label %55, !dbg !79

55:                                               ; preds = %54, %25, %18, %9
  ret i32 0, !dbg !80
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare float @__VERIFIER_nondet_float() #2

declare double @__VERIFIER_nondet_double() #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.minnum.f64(double, double) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.maxnum.f64(double, double) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #4 = { cold noreturn }

!llvm.dbg.cu = !{!20}
!llvm.module.flags = !{!27, !28, !29, !30, !31, !32}
!llvm.ident = !{!33}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 95, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "benchmarks/miscellaneous/floats.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 40, elements: !6)
!4 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !5)
!5 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!6 = !{!7}
!7 = !DISubrange(count: 5)
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(scope: null, file: !2, line: 95, type: !10, isLocal: true, isDefinition: true)
!10 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 72, elements: !11)
!11 = !{!12}
!12 = !DISubrange(count: 9)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(scope: null, file: !2, line: 95, type: !15, isLocal: true, isDefinition: true)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 160, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 20)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !2, line: 96, type: !15, isLocal: true, isDefinition: true)
!20 = distinct !DICompileUnit(language: DW_LANG_C11, file: !21, producer: "Homebrew clang version 16.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !22, globals: !26, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!21 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/floats.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!22 = !{!23, !24, !25}
!23 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!24 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!25 = !DIBasicType(name: "long double", size: 64, encoding: DW_ATE_float)
!26 = !{!0, !8, !13, !18}
!27 = !{i32 7, !"Dwarf Version", i32 4}
!28 = !{i32 2, !"Debug Info Version", i32 3}
!29 = !{i32 1, !"wchar_size", i32 4}
!30 = !{i32 8, !"PIC Level", i32 2}
!31 = !{i32 7, !"uwtable", i32 1}
!32 = !{i32 7, !"frame-pointer", i32 1}
!33 = !{!"Homebrew clang version 16.0.6"}
!34 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 11, type: !35, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !20, retainedNodes: !38)
!35 = !DISubroutineType(types: !36)
!36 = !{!37}
!37 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!38 = !{}
!39 = !DILocalVariable(name: "f", scope: !34, file: !2, line: 12, type: !23)
!40 = !DILocation(line: 12, column: 12, scope: !34)
!41 = !DILocation(line: 12, column: 16, scope: !34)
!42 = !DILocalVariable(name: "d", scope: !34, file: !2, line: 13, type: !24)
!43 = !DILocation(line: 13, column: 12, scope: !34)
!44 = !DILocation(line: 13, column: 16, scope: !34)
!45 = !DILocation(line: 94, column: 9, scope: !34)
!46 = !DILocation(line: 94, column: 9, scope: !47)
!47 = distinct !DILexicalBlock(scope: !34, file: !2, line: 94, column: 9)
!48 = !DILocalVariable(name: "__x", arg: 1, scope: !49, file: !50, line: 214, type: !23)
!49 = distinct !DISubprogram(name: "__inline_isnanf", scope: !50, file: !50, line: 214, type: !51, scopeLine: 214, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !20, retainedNodes: !38)
!50 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/math.h", directory: "")
!51 = !DISubroutineType(types: !52)
!52 = !{!37, !23}
!53 = !DILocation(line: 214, column: 50, scope: !49, inlinedAt: !54)
!54 = distinct !DILocation(line: 94, column: 9, scope: !47)
!55 = !DILocation(line: 215, column: 12, scope: !49, inlinedAt: !54)
!56 = !DILocation(line: 215, column: 19, scope: !49, inlinedAt: !54)
!57 = !DILocation(line: 215, column: 16, scope: !49, inlinedAt: !54)
!58 = !DILocalVariable(name: "__x", arg: 1, scope: !59, file: !50, line: 217, type: !24)
!59 = distinct !DISubprogram(name: "__inline_isnand", scope: !50, file: !50, line: 217, type: !60, scopeLine: 217, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !20, retainedNodes: !38)
!60 = !DISubroutineType(types: !61)
!61 = !{!37, !24}
!62 = !DILocation(line: 217, column: 51, scope: !59, inlinedAt: !63)
!63 = distinct !DILocation(line: 94, column: 9, scope: !47)
!64 = !DILocation(line: 218, column: 12, scope: !59, inlinedAt: !63)
!65 = !DILocation(line: 218, column: 19, scope: !59, inlinedAt: !63)
!66 = !DILocation(line: 218, column: 16, scope: !59, inlinedAt: !63)
!67 = !DILocalVariable(name: "__x", arg: 1, scope: !68, file: !50, line: 220, type: !25)
!68 = distinct !DISubprogram(name: "__inline_isnanl", scope: !50, file: !50, line: 220, type: !69, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !20, retainedNodes: !38)
!69 = !DISubroutineType(types: !70)
!70 = !{!37, !25}
!71 = !DILocation(line: 220, column: 56, scope: !68, inlinedAt: !72)
!72 = distinct !DILocation(line: 94, column: 9, scope: !47)
!73 = !DILocation(line: 221, column: 12, scope: !68, inlinedAt: !72)
!74 = !DILocation(line: 221, column: 19, scope: !68, inlinedAt: !72)
!75 = !DILocation(line: 221, column: 16, scope: !68, inlinedAt: !72)
!76 = !DILocation(line: 95, column: 9, scope: !77)
!77 = distinct !DILexicalBlock(scope: !47, file: !2, line: 94, column: 19)
!78 = !DILocation(line: 96, column: 9, scope: !77)
!79 = !DILocation(line: 97, column: 5, scope: !77)
!80 = !DILocation(line: 180, column: 5, scope: !34)
