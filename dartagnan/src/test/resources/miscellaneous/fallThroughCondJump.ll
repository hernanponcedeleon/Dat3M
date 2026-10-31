; ModuleID = 'benchmarks/miscellaneous/fallThroughCondJump.c'
source_filename = "benchmarks/miscellaneous/fallThroughCondJump.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !0
@.str = private unnamed_addr constant [22 x i8] c"fallThroughCondJump.c\00", align 1, !dbg !8
@.str.1 = private unnamed_addr constant [12 x i8] c"c || y == 1\00", align 1, !dbg !13

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !27 {
  %1 = alloca i32, align 4
  %2 = alloca i8, align 1
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !32, !DIExpression(), !34)
  %5 = call zeroext i1 @__VERIFIER_nondet_bool(), !dbg !35
  %6 = zext i1 %5 to i8, !dbg !34
  store i8 %6, ptr %2, align 1, !dbg !34
    #dbg_declare(ptr %3, !36, !DIExpression(), !37)
  store i32 0, ptr %3, align 4, !dbg !37
    #dbg_declare(ptr %4, !38, !DIExpression(), !39)
  store i32 0, ptr %4, align 4, !dbg !39
  %7 = load i8, ptr %2, align 1, !dbg !40
  %8 = icmp ne i8 %7, 0, !dbg !40
  br i1 %8, label %9, label %10, !dbg !40

9:                                                ; preds = %0
  br label %11, !dbg !42

10:                                               ; preds = %0
  store i32 5, ptr %3, align 4, !dbg !43
  br label %11, !dbg !44

11:                                               ; preds = %10, %9
    #dbg_label(!45, !46)
  br label %12, !dbg !47

12:                                               ; preds = %11
  %13 = load i8, ptr %2, align 1, !dbg !48
  %14 = icmp ne i8 %13, 0, !dbg !48
  %15 = xor i1 %14, true, !dbg !49
  br i1 %15, label %16, label %17, !dbg !47

16:                                               ; preds = %12
  store i32 1, ptr %4, align 4, !dbg !50
  br label %17, !dbg !52

17:                                               ; preds = %16, %12
  %18 = load i8, ptr %2, align 1, !dbg !53
  %19 = icmp ne i8 %18, 0, !dbg !53
  br i1 %19, label %23, label %20, !dbg !54

20:                                               ; preds = %17
  %21 = load i32, ptr %4, align 4, !dbg !55
  %22 = icmp eq i32 %21, 1, !dbg !56
  br label %23, !dbg !54

23:                                               ; preds = %20, %17
  %24 = phi i1 [ true, %17 ], [ %22, %20 ]
  %25 = xor i1 %24, true, !dbg !57
  %26 = zext i1 %25 to i32, !dbg !57
  %27 = sext i32 %26 to i64, !dbg !57
  %28 = icmp ne i64 %27, 0, !dbg !57
  br i1 %28, label %29, label %31, !dbg !57

29:                                               ; preds = %23
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 25, ptr noundef @.str.1) #3, !dbg !57
  unreachable, !dbg !57

30:                                               ; No predecessors!
  br label %32, !dbg !57

31:                                               ; preds = %23
  br label %32, !dbg !57

32:                                               ; preds = %31, %30
  ret i32 0, !dbg !58
}

declare zeroext i1 @__VERIFIER_nondet_bool() #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #3 = { cold noreturn }

!llvm.module.flags = !{!18, !19, !20, !21, !22, !23}
!llvm.dbg.cu = !{!24}
!llvm.ident = !{!26}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 25, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "benchmarks/miscellaneous/fallThroughCondJump.c", directory: "/Users/hponcedeleon/git/Dat3M", checksumkind: CSK_MD5, checksum: "7162e4e67b59cb9451bbee6378ff3d32")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 40, elements: !6)
!4 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !5)
!5 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!6 = !{!7}
!7 = !DISubrange(count: 5)
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(scope: null, file: !2, line: 25, type: !10, isLocal: true, isDefinition: true)
!10 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 176, elements: !11)
!11 = !{!12}
!12 = !DISubrange(count: 22)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(scope: null, file: !2, line: 25, type: !15, isLocal: true, isDefinition: true)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 96, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 12)
!18 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 5]}
!19 = !{i32 7, !"Dwarf Version", i32 5}
!20 = !{i32 2, !"Debug Info Version", i32 3}
!21 = !{i32 8, !"PIC Level", i32 2}
!22 = !{i32 7, !"uwtable", i32 1}
!23 = !{i32 7, !"frame-pointer", i32 4}
!24 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Homebrew clang version 23.1.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !25, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk", sdk: "MacOSX26.sdk")
!25 = !{!0, !8, !13}
!26 = !{!"Homebrew clang version 23.1.0"}
!27 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 13, type: !28, scopeLine: 14, spFlags: DISPFlagDefinition, unit: !24, retainedNodes: !31)
!28 = !DISubroutineType(types: !29)
!29 = !{!30}
!30 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!31 = !{}
!32 = !DILocalVariable(name: "c", scope: !27, file: !2, line: 15, type: !33)
!33 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!34 = !DILocation(line: 15, column: 10, scope: !27)
!35 = !DILocation(line: 15, column: 14, scope: !27)
!36 = !DILocalVariable(name: "dead_if_c", scope: !27, file: !2, line: 16, type: !30)
!37 = !DILocation(line: 16, column: 9, scope: !27)
!38 = !DILocalVariable(name: "y", scope: !27, file: !2, line: 16, type: !30)
!39 = !DILocation(line: 16, column: 19, scope: !27)
!40 = !DILocation(line: 17, column: 9, scope: !41)
!41 = distinct !DILexicalBlock(scope: !27, file: !2, line: 17, column: 9)
!42 = !DILocation(line: 18, column: 9, scope: !41)
!43 = !DILocation(line: 19, column: 10, scope: !27)
!44 = !DILocation(line: 19, column: 5, scope: !27)
!45 = !DILabel(scope: !27, name: "L", file: !2, line: 20, column: 1)
!46 = !DILocation(line: 20, column: 1, scope: !27)
!47 = !DILocation(line: 21, column: 5, scope: !27)
!48 = !DILocation(line: 21, column: 13, scope: !27)
!49 = !DILocation(line: 21, column: 12, scope: !27)
!50 = !DILocation(line: 22, column: 11, scope: !51)
!51 = distinct !DILexicalBlock(scope: !27, file: !2, line: 21, column: 16)
!52 = !DILocation(line: 23, column: 9, scope: !51)
!53 = !DILocation(line: 25, column: 12, scope: !27)
!54 = !DILocation(line: 25, column: 14, scope: !27)
!55 = !DILocation(line: 25, column: 17, scope: !27)
!56 = !DILocation(line: 25, column: 19, scope: !27)
!57 = !DILocation(line: 25, column: 5, scope: !27)
!58 = !DILocation(line: 26, column: 5, scope: !27)
