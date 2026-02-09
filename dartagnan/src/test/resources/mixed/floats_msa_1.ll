; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/mixed/floats_msa.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/mixed/floats_msa.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx15.0.0"

%union.float_int = type { float }
%union.anon = type { float }
%struct.anon = type { i16, i16 }

@s = global %union.float_int zeroinitializer, align 4, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !8
@.str = private unnamed_addr constant [13 x i8] c"floats_msa.c\00", align 1, !dbg !16
@.str.1 = private unnamed_addr constant [33 x i8] c"s.f == -5.000000476837158203125f\00", align 1, !dbg !21
@.str.2 = private unnamed_addr constant [8 x i8] c"s.i < 0\00", align 1, !dbg !26
@.str.3 = private unnamed_addr constant [11 x i8] c"s.high > 0\00", align 1, !dbg !31
@.str.4 = private unnamed_addr constant [14 x i8] c"!signbit(s.f)\00", align 1, !dbg !36

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !59 {
  %1 = alloca float, align 4
  %2 = alloca %union.anon, align 4
  %3 = alloca i32, align 4
  store i32 0, ptr %3, align 4
  store float 5.000000e+00, ptr @s, align 4, !dbg !63
  %4 = load i16, ptr @s, align 4, !dbg !64
  %5 = sext i16 %4 to i32, !dbg !65
  %6 = or i32 %5, 1, !dbg !66
  %7 = trunc i32 %6 to i16, !dbg !65
  store i16 %7, ptr @s, align 4, !dbg !67
  %8 = load i16, ptr getelementptr inbounds (%struct.anon, ptr @s, i32 0, i32 1), align 2, !dbg !68
  %9 = sext i16 %8 to i32, !dbg !69
  %10 = or i32 %9, 32768, !dbg !70
  %11 = trunc i32 %10 to i16, !dbg !69
  store i16 %11, ptr getelementptr inbounds (%struct.anon, ptr @s, i32 0, i32 1), align 2, !dbg !71
  %12 = load float, ptr @s, align 4, !dbg !72
  %13 = fcmp oeq float %12, 0xC014000020000000, !dbg !72
  %14 = xor i1 %13, true, !dbg !72
  %15 = zext i1 %14 to i32, !dbg !72
  %16 = sext i32 %15 to i64, !dbg !72
  %17 = icmp ne i64 %16, 0, !dbg !72
  br i1 %17, label %18, label %20, !dbg !72

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 30, ptr noundef @.str.1) #3, !dbg !72
  unreachable, !dbg !72

19:                                               ; No predecessors!
  br label %21, !dbg !72

20:                                               ; preds = %0
  br label %21, !dbg !72

21:                                               ; preds = %20, %19
  %22 = load i32, ptr @s, align 4, !dbg !73
  %23 = icmp slt i32 %22, 0, !dbg !73
  %24 = xor i1 %23, true, !dbg !73
  %25 = zext i1 %24 to i32, !dbg !73
  %26 = sext i32 %25 to i64, !dbg !73
  %27 = icmp ne i64 %26, 0, !dbg !73
  br i1 %27, label %28, label %30, !dbg !73

28:                                               ; preds = %21
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 31, ptr noundef @.str.2) #3, !dbg !73
  unreachable, !dbg !73

29:                                               ; No predecessors!
  br label %31, !dbg !73

30:                                               ; preds = %21
  br label %31, !dbg !73

31:                                               ; preds = %30, %29
  %32 = load float, ptr @s, align 4, !dbg !74
  %33 = fmul float %32, -1.000000e+00, !dbg !74
  store float %33, ptr @s, align 4, !dbg !74
  %34 = load i16, ptr getelementptr inbounds (%struct.anon, ptr @s, i32 0, i32 1), align 2, !dbg !75
  %35 = sext i16 %34 to i32, !dbg !75
  %36 = icmp sgt i32 %35, 0, !dbg !75
  %37 = xor i1 %36, true, !dbg !75
  %38 = zext i1 %37 to i32, !dbg !75
  %39 = sext i32 %38 to i64, !dbg !75
  %40 = icmp ne i64 %39, 0, !dbg !75
  br i1 %40, label %41, label %43, !dbg !75

41:                                               ; preds = %31
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 34, ptr noundef @.str.3) #3, !dbg !75
  unreachable, !dbg !75

42:                                               ; No predecessors!
  br label %44, !dbg !75

43:                                               ; preds = %31
  br label %44, !dbg !75

44:                                               ; preds = %43, %42
  %45 = load float, ptr @s, align 4, !dbg !76
  store float %45, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %1, metadata !77, metadata !DIExpression()), !dbg !82
  call void @llvm.dbg.declare(metadata ptr %2, metadata !84, metadata !DIExpression()), !dbg !90
  %46 = load float, ptr %1, align 4, !dbg !91
  store float %46, ptr %2, align 4, !dbg !92
  %47 = load i32, ptr %2, align 4, !dbg !93
  %48 = lshr i32 %47, 31, !dbg !94
  %49 = icmp ne i32 %48, 0, !dbg !76
  %50 = xor i1 %49, true, !dbg !76
  %51 = xor i1 %50, true, !dbg !76
  %52 = zext i1 %51 to i32, !dbg !76
  %53 = sext i32 %52 to i64, !dbg !76
  %54 = icmp ne i64 %53, 0, !dbg !76
  br i1 %54, label %55, label %57, !dbg !76

55:                                               ; preds = %44
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 35, ptr noundef @.str.4) #3, !dbg !76
  unreachable, !dbg !76

56:                                               ; No predecessors!
  br label %58, !dbg !76

57:                                               ; preds = %44
  br label %58, !dbg !76

58:                                               ; preds = %57, %56
  ret i32 0, !dbg !95
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!52, !53, !54, !55, !56, !57}
!llvm.ident = !{!58}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !10, line: 19, type: !41, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 16.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !7, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/mixed/floats_msa.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5, !6}
!5 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !{!8, !16, !21, !26, !31, !36, !0}
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(scope: null, file: !10, line: 30, type: !11, isLocal: true, isDefinition: true)
!10 = !DIFile(filename: "benchmarks/mixed/floats_msa.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!11 = !DICompositeType(tag: DW_TAG_array_type, baseType: !12, size: 40, elements: !14)
!12 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !13)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !{!15}
!15 = !DISubrange(count: 5)
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(scope: null, file: !10, line: 30, type: !18, isLocal: true, isDefinition: true)
!18 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 104, elements: !19)
!19 = !{!20}
!20 = !DISubrange(count: 13)
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(scope: null, file: !10, line: 30, type: !23, isLocal: true, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 264, elements: !24)
!24 = !{!25}
!25 = !DISubrange(count: 33)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(scope: null, file: !10, line: 31, type: !28, isLocal: true, isDefinition: true)
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 64, elements: !29)
!29 = !{!30}
!30 = !DISubrange(count: 8)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !10, line: 34, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 88, elements: !34)
!34 = !{!35}
!35 = !DISubrange(count: 11)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !10, line: 35, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 112, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 14)
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_int", file: !10, line: 16, baseType: !42)
!42 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !10, line: 8, size: 32, elements: !43)
!43 = !{!44, !45, !46}
!44 = !DIDerivedType(tag: DW_TAG_member, name: "f", scope: !42, file: !10, line: 9, baseType: !5, size: 32)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "i", scope: !42, file: !10, line: 10, baseType: !6, size: 32)
!46 = !DIDerivedType(tag: DW_TAG_member, scope: !42, file: !10, line: 11, baseType: !47, size: 32)
!47 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !42, file: !10, line: 11, size: 32, elements: !48)
!48 = !{!49, !51}
!49 = !DIDerivedType(tag: DW_TAG_member, name: "low", scope: !47, file: !10, line: 13, baseType: !50, size: 16)
!50 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "high", scope: !47, file: !10, line: 14, baseType: !50, size: 16, offset: 16)
!52 = !{i32 7, !"Dwarf Version", i32 4}
!53 = !{i32 2, !"Debug Info Version", i32 3}
!54 = !{i32 1, !"wchar_size", i32 4}
!55 = !{i32 8, !"PIC Level", i32 2}
!56 = !{i32 7, !"uwtable", i32 1}
!57 = !{i32 7, !"frame-pointer", i32 1}
!58 = !{!"Homebrew clang version 16.0.6"}
!59 = distinct !DISubprogram(name: "main", scope: !10, file: !10, line: 22, type: !60, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!60 = !DISubroutineType(types: !61)
!61 = !{!6}
!62 = !{}
!63 = !DILocation(line: 27, column: 9, scope: !59)
!64 = !DILocation(line: 28, column: 15, scope: !59)
!65 = !DILocation(line: 28, column: 13, scope: !59)
!66 = !DILocation(line: 28, column: 19, scope: !59)
!67 = !DILocation(line: 28, column: 11, scope: !59)
!68 = !DILocation(line: 29, column: 16, scope: !59)
!69 = !DILocation(line: 29, column: 14, scope: !59)
!70 = !DILocation(line: 29, column: 21, scope: !59)
!71 = !DILocation(line: 29, column: 12, scope: !59)
!72 = !DILocation(line: 30, column: 5, scope: !59)
!73 = !DILocation(line: 31, column: 5, scope: !59)
!74 = !DILocation(line: 33, column: 9, scope: !59)
!75 = !DILocation(line: 34, column: 5, scope: !59)
!76 = !DILocation(line: 35, column: 5, scope: !59)
!77 = !DILocalVariable(name: "__x", arg: 1, scope: !78, file: !79, line: 223, type: !5)
!78 = distinct !DISubprogram(name: "__inline_signbitf", scope: !79, file: !79, line: 223, type: !80, scopeLine: 223, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!79 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/math.h", directory: "")
!80 = !DISubroutineType(types: !81)
!81 = !{!6, !5}
!82 = !DILocation(line: 223, column: 52, scope: !78, inlinedAt: !83)
!83 = distinct !DILocation(line: 35, column: 5, scope: !59)
!84 = !DILocalVariable(name: "__u", scope: !78, file: !79, line: 224, type: !85)
!85 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !78, file: !79, line: 224, size: 32, elements: !86)
!86 = !{!87, !88}
!87 = !DIDerivedType(tag: DW_TAG_member, name: "__f", scope: !85, file: !79, line: 224, baseType: !5, size: 32)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "__u", scope: !85, file: !79, line: 224, baseType: !89, size: 32)
!89 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!90 = !DILocation(line: 224, column: 44, scope: !78, inlinedAt: !83)
!91 = !DILocation(line: 225, column: 15, scope: !78, inlinedAt: !83)
!92 = !DILocation(line: 225, column: 13, scope: !78, inlinedAt: !83)
!93 = !DILocation(line: 226, column: 22, scope: !78, inlinedAt: !83)
!94 = !DILocation(line: 226, column: 26, scope: !78, inlinedAt: !83)
!95 = !DILocation(line: 37, column: 5, scope: !59)
