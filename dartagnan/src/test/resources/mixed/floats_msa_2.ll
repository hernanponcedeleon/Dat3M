; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/mixed/floats_msa.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/mixed/floats_msa.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx15.0.0"

%union.anon = type { float }
%union.float_int = type { float }
%struct.anon = type { i16, i16 }

@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !0
@.str = private unnamed_addr constant [13 x i8] c"floats_msa.c\00", align 1, !dbg !8
@.str.1 = private unnamed_addr constant [33 x i8] c"s.f == -5.000000476837158203125f\00", align 1, !dbg !13
@.str.2 = private unnamed_addr constant [8 x i8] c"s.i < 0\00", align 1, !dbg !18
@.str.3 = private unnamed_addr constant [11 x i8] c"s.high > 0\00", align 1, !dbg !23
@.str.4 = private unnamed_addr constant [14 x i8] c"!signbit(s.f)\00", align 1, !dbg !28

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !46 {
  %1 = alloca float, align 4
  %2 = alloca %union.anon, align 4
  %3 = alloca i32, align 4
  %4 = alloca %union.float_int, align 4
  store i32 0, ptr %3, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !50, metadata !DIExpression()), !dbg !62
  store float 5.000000e+00, ptr %4, align 4, !dbg !63
  %5 = getelementptr inbounds %struct.anon, ptr %4, i32 0, i32 0, !dbg !64
  %6 = load i16, ptr %5, align 4, !dbg !64
  %7 = sext i16 %6 to i32, !dbg !65
  %8 = or i32 %7, 1, !dbg !66
  %9 = trunc i32 %8 to i16, !dbg !65
  %10 = getelementptr inbounds %struct.anon, ptr %4, i32 0, i32 0, !dbg !67
  store i16 %9, ptr %10, align 4, !dbg !68
  %11 = getelementptr inbounds %struct.anon, ptr %4, i32 0, i32 1, !dbg !69
  %12 = load i16, ptr %11, align 2, !dbg !69
  %13 = sext i16 %12 to i32, !dbg !70
  %14 = or i32 %13, 32768, !dbg !71
  %15 = trunc i32 %14 to i16, !dbg !70
  %16 = getelementptr inbounds %struct.anon, ptr %4, i32 0, i32 1, !dbg !72
  store i16 %15, ptr %16, align 2, !dbg !73
  %17 = load float, ptr %4, align 4, !dbg !74
  %18 = fcmp oeq float %17, 0xC014000020000000, !dbg !74
  %19 = xor i1 %18, true, !dbg !74
  %20 = zext i1 %19 to i32, !dbg !74
  %21 = sext i32 %20 to i64, !dbg !74
  %22 = icmp ne i64 %21, 0, !dbg !74
  br i1 %22, label %23, label %25, !dbg !74

23:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 30, ptr noundef @.str.1) #3, !dbg !74
  unreachable, !dbg !74

24:                                               ; No predecessors!
  br label %26, !dbg !74

25:                                               ; preds = %0
  br label %26, !dbg !74

26:                                               ; preds = %25, %24
  %27 = load i32, ptr %4, align 4, !dbg !75
  %28 = icmp slt i32 %27, 0, !dbg !75
  %29 = xor i1 %28, true, !dbg !75
  %30 = zext i1 %29 to i32, !dbg !75
  %31 = sext i32 %30 to i64, !dbg !75
  %32 = icmp ne i64 %31, 0, !dbg !75
  br i1 %32, label %33, label %35, !dbg !75

33:                                               ; preds = %26
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 31, ptr noundef @.str.2) #3, !dbg !75
  unreachable, !dbg !75

34:                                               ; No predecessors!
  br label %36, !dbg !75

35:                                               ; preds = %26
  br label %36, !dbg !75

36:                                               ; preds = %35, %34
  %37 = load float, ptr %4, align 4, !dbg !76
  %38 = fmul float %37, -1.000000e+00, !dbg !76
  store float %38, ptr %4, align 4, !dbg !76
  %39 = getelementptr inbounds %struct.anon, ptr %4, i32 0, i32 1, !dbg !77
  %40 = load i16, ptr %39, align 2, !dbg !77
  %41 = sext i16 %40 to i32, !dbg !77
  %42 = icmp sgt i32 %41, 0, !dbg !77
  %43 = xor i1 %42, true, !dbg !77
  %44 = zext i1 %43 to i32, !dbg !77
  %45 = sext i32 %44 to i64, !dbg !77
  %46 = icmp ne i64 %45, 0, !dbg !77
  br i1 %46, label %47, label %49, !dbg !77

47:                                               ; preds = %36
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 34, ptr noundef @.str.3) #3, !dbg !77
  unreachable, !dbg !77

48:                                               ; No predecessors!
  br label %50, !dbg !77

49:                                               ; preds = %36
  br label %50, !dbg !77

50:                                               ; preds = %49, %48
  %51 = load float, ptr %4, align 4, !dbg !78
  store float %51, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %1, metadata !79, metadata !DIExpression()), !dbg !84
  call void @llvm.dbg.declare(metadata ptr %2, metadata !86, metadata !DIExpression()), !dbg !92
  %52 = load float, ptr %1, align 4, !dbg !93
  store float %52, ptr %2, align 4, !dbg !94
  %53 = load i32, ptr %2, align 4, !dbg !95
  %54 = lshr i32 %53, 31, !dbg !96
  %55 = icmp ne i32 %54, 0, !dbg !78
  %56 = xor i1 %55, true, !dbg !78
  %57 = xor i1 %56, true, !dbg !78
  %58 = zext i1 %57 to i32, !dbg !78
  %59 = sext i32 %58 to i64, !dbg !78
  %60 = icmp ne i64 %59, 0, !dbg !78
  br i1 %60, label %61, label %63, !dbg !78

61:                                               ; preds = %50
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 35, ptr noundef @.str.4) #3, !dbg !78
  unreachable, !dbg !78

62:                                               ; No predecessors!
  br label %64, !dbg !78

63:                                               ; preds = %50
  br label %64, !dbg !78

64:                                               ; preds = %63, %62
  ret i32 0, !dbg !97
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!33}
!llvm.module.flags = !{!39, !40, !41, !42, !43, !44}
!llvm.ident = !{!45}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 30, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "benchmarks/mixed/floats_msa.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 40, elements: !6)
!4 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !5)
!5 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!6 = !{!7}
!7 = !DISubrange(count: 5)
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(scope: null, file: !2, line: 30, type: !10, isLocal: true, isDefinition: true)
!10 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 104, elements: !11)
!11 = !{!12}
!12 = !DISubrange(count: 13)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(scope: null, file: !2, line: 30, type: !15, isLocal: true, isDefinition: true)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 264, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 33)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !2, line: 31, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 64, elements: !21)
!21 = !{!22}
!22 = !DISubrange(count: 8)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(scope: null, file: !2, line: 34, type: !25, isLocal: true, isDefinition: true)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 88, elements: !26)
!26 = !{!27}
!27 = !DISubrange(count: 11)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(scope: null, file: !2, line: 35, type: !30, isLocal: true, isDefinition: true)
!30 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 112, elements: !31)
!31 = !{!32}
!32 = !DISubrange(count: 14)
!33 = distinct !DICompileUnit(language: DW_LANG_C11, file: !34, producer: "Homebrew clang version 16.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !35, globals: !38, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!34 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/mixed/floats_msa.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!35 = !{!36, !37}
!36 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!37 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!38 = !{!0, !8, !13, !18, !23, !28}
!39 = !{i32 7, !"Dwarf Version", i32 4}
!40 = !{i32 2, !"Debug Info Version", i32 3}
!41 = !{i32 1, !"wchar_size", i32 4}
!42 = !{i32 8, !"PIC Level", i32 2}
!43 = !{i32 7, !"uwtable", i32 1}
!44 = !{i32 7, !"frame-pointer", i32 1}
!45 = !{!"Homebrew clang version 16.0.6"}
!46 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 22, type: !47, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !33, retainedNodes: !49)
!47 = !DISubroutineType(types: !48)
!48 = !{!37}
!49 = !{}
!50 = !DILocalVariable(name: "s", scope: !46, file: !2, line: 24, type: !51)
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_int", file: !2, line: 16, baseType: !52)
!52 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !2, line: 8, size: 32, elements: !53)
!53 = !{!54, !55, !56}
!54 = !DIDerivedType(tag: DW_TAG_member, name: "f", scope: !52, file: !2, line: 9, baseType: !36, size: 32)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "i", scope: !52, file: !2, line: 10, baseType: !37, size: 32)
!56 = !DIDerivedType(tag: DW_TAG_member, scope: !52, file: !2, line: 11, baseType: !57, size: 32)
!57 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !52, file: !2, line: 11, size: 32, elements: !58)
!58 = !{!59, !61}
!59 = !DIDerivedType(tag: DW_TAG_member, name: "low", scope: !57, file: !2, line: 13, baseType: !60, size: 16)
!60 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "high", scope: !57, file: !2, line: 14, baseType: !60, size: 16, offset: 16)
!62 = !DILocation(line: 24, column: 15, scope: !46)
!63 = !DILocation(line: 27, column: 9, scope: !46)
!64 = !DILocation(line: 28, column: 15, scope: !46)
!65 = !DILocation(line: 28, column: 13, scope: !46)
!66 = !DILocation(line: 28, column: 19, scope: !46)
!67 = !DILocation(line: 28, column: 7, scope: !46)
!68 = !DILocation(line: 28, column: 11, scope: !46)
!69 = !DILocation(line: 29, column: 16, scope: !46)
!70 = !DILocation(line: 29, column: 14, scope: !46)
!71 = !DILocation(line: 29, column: 21, scope: !46)
!72 = !DILocation(line: 29, column: 7, scope: !46)
!73 = !DILocation(line: 29, column: 12, scope: !46)
!74 = !DILocation(line: 30, column: 5, scope: !46)
!75 = !DILocation(line: 31, column: 5, scope: !46)
!76 = !DILocation(line: 33, column: 9, scope: !46)
!77 = !DILocation(line: 34, column: 5, scope: !46)
!78 = !DILocation(line: 35, column: 5, scope: !46)
!79 = !DILocalVariable(name: "__x", arg: 1, scope: !80, file: !81, line: 223, type: !36)
!80 = distinct !DISubprogram(name: "__inline_signbitf", scope: !81, file: !81, line: 223, type: !82, scopeLine: 223, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !33, retainedNodes: !49)
!81 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/math.h", directory: "")
!82 = !DISubroutineType(types: !83)
!83 = !{!37, !36}
!84 = !DILocation(line: 223, column: 52, scope: !80, inlinedAt: !85)
!85 = distinct !DILocation(line: 35, column: 5, scope: !46)
!86 = !DILocalVariable(name: "__u", scope: !80, file: !81, line: 224, type: !87)
!87 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !80, file: !81, line: 224, size: 32, elements: !88)
!88 = !{!89, !90}
!89 = !DIDerivedType(tag: DW_TAG_member, name: "__f", scope: !87, file: !81, line: 224, baseType: !36, size: 32)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "__u", scope: !87, file: !81, line: 224, baseType: !91, size: 32)
!91 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!92 = !DILocation(line: 224, column: 44, scope: !80, inlinedAt: !85)
!93 = !DILocation(line: 225, column: 15, scope: !80, inlinedAt: !85)
!94 = !DILocation(line: 225, column: 13, scope: !80, inlinedAt: !85)
!95 = !DILocation(line: 226, column: 22, scope: !80, inlinedAt: !85)
!96 = !DILocation(line: 226, column: 26, scope: !80, inlinedAt: !85)
!97 = !DILocation(line: 37, column: 5, scope: !46)
