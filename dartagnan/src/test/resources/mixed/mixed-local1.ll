; ModuleID = 'benchmarks/mixed/mixed-local1.c'
source_filename = "benchmarks/mixed/mixed-local1.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.anon = type { i32 }

@x = dso_local global %union.anon zeroinitializer, align 4, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !5
@.str = private unnamed_addr constant [15 x i8] c"mixed-local1.c\00", align 1, !dbg !12
@.str.1 = private unnamed_addr constant [20 x i8] c"x.as_int == 0x10000\00", align 1, !dbg !17

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !37 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  store volatile i32 123456, ptr @x, align 4, !dbg !40
  store volatile i16 0, ptr @x, align 4, !dbg !41
  %2 = load volatile i32, ptr @x, align 4, !dbg !42
  %3 = icmp eq i32 %2, 65536, !dbg !42
  %4 = xor i1 %3, true, !dbg !42
  %5 = zext i1 %4 to i32, !dbg !42
  %6 = sext i32 %5 to i64, !dbg !42
  %7 = icmp ne i64 %6, 0, !dbg !42
  br i1 %7, label %8, label %10, !dbg !42

8:                                                ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 13, ptr noundef @.str.1) #2, !dbg !42
  unreachable, !dbg !42

9:                                                ; No predecessors!
  br label %11, !dbg !42

10:                                               ; preds = %0
  br label %11, !dbg !42

11:                                               ; preds = %10, %9
  ret i32 0, !dbg !43
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!29, !30, !31, !32, !33, !34, !35}
!llvm.ident = !{!36}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !22, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/mixed/mixed-local1.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "ab0496daf8f76f6d8c8d3a268afaaeb4")
!4 = !{!5, !12, !17, !0}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !7, isLocal: true, isDefinition: true)
!7 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 40, elements: !10)
!8 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !9)
!9 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!10 = !{!11}
!11 = !DISubrange(count: 5)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 120, elements: !15)
!15 = !{!16}
!16 = !DISubrange(count: 15)
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !19, isLocal: true, isDefinition: true)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 160, elements: !20)
!20 = !{!21}
!21 = !DISubrange(count: 20)
!22 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !23)
!23 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !3, line: 6, size: 32, elements: !24)
!24 = !{!25, !27}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "as_int", scope: !23, file: !3, line: 6, baseType: !26, size: 32)
!26 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "as_short", scope: !23, file: !3, line: 6, baseType: !28, size: 16)
!28 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!29 = !{i32 7, !"Dwarf Version", i32 5}
!30 = !{i32 2, !"Debug Info Version", i32 3}
!31 = !{i32 1, !"wchar_size", i32 4}
!32 = !{i32 8, !"PIC Level", i32 2}
!33 = !{i32 7, !"PIE Level", i32 2}
!34 = !{i32 7, !"uwtable", i32 2}
!35 = !{i32 7, !"frame-pointer", i32 2}
!36 = !{!"Homebrew clang version 19.1.7"}
!37 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 8, type: !38, scopeLine: 9, spFlags: DISPFlagDefinition, unit: !2)
!38 = !DISubroutineType(types: !39)
!39 = !{!26}
!40 = !DILocation(line: 10, column: 14, scope: !37)
!41 = !DILocation(line: 11, column: 16, scope: !37)
!42 = !DILocation(line: 13, column: 5, scope: !37)
!43 = !DILocation(line: 21, column: 5, scope: !37)
