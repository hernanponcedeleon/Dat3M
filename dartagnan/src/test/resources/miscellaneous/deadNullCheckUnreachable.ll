; ModuleID = 'benchmarks/miscellaneous/deadNullCheckUnreachable.c'
source_filename = "benchmarks/miscellaneous/deadNullCheckUnreachable.c"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@g = dso_local global i32 7, align 4, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !7
@.str = private unnamed_addr constant [27 x i8] c"deadNullCheckUnreachable.c\00", align 1, !dbg !14
@.str.1 = private unnamed_addr constant [7 x i8] c"g == 7\00", align 1, !dbg !19

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !33 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 4
  %3 = alloca ptr, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !37, !DIExpression(), !39)
  %4 = call ptr @malloc(i32 noundef 4) #3, !dbg !40
  store ptr %4, ptr %2, align 4, !dbg !39
    #dbg_declare(ptr %3, !41, !DIExpression(), !43)
  %5 = call ptr @malloc(i32 noundef -16) #3, !dbg !44
  store ptr %5, ptr %3, align 4, !dbg !43
  %6 = load ptr, ptr %3, align 4, !dbg !45
  %7 = icmp ne ptr %6, null, !dbg !47
  br i1 %7, label %8, label %9, !dbg !47

8:                                                ; preds = %0
  store i32 0, ptr %1, align 4, !dbg !48
  br label %18, !dbg !48

9:                                                ; preds = %0
  %10 = load ptr, ptr %2, align 4, !dbg !50
  store i32 42, ptr %10, align 4, !dbg !51
  %11 = load i32, ptr @g, align 4, !dbg !52
  %12 = icmp eq i32 %11, 7, !dbg !53
  %13 = xor i1 %12, true, !dbg !54
  br i1 %13, label %14, label %16, !dbg !54

14:                                               ; preds = %9
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 10, ptr noundef @.str.1) #4, !dbg !54
  unreachable, !dbg !54

15:                                               ; No predecessors!
  br label %17, !dbg !54

16:                                               ; preds = %9
  br label %17, !dbg !54

17:                                               ; preds = %16, %15
  store i32 0, ptr %1, align 4, !dbg !55
  br label %18, !dbg !55

18:                                               ; preds = %17, %8
  %19 = load i32, ptr %1, align 4, !dbg !56
  ret i32 %19, !dbg !56
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i32 noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { allocsize(0) }
attributes #4 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!25, !26, !27, !28, !29, !30, !31}
!llvm.ident = !{!32}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g", scope: !2, file: !3, line: 4, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/miscellaneous/deadNullCheckUnreachable.c", directory: ".", checksumkind: CSK_MD5, checksum: "5eabc0448be84011ea3edcea57ed8cf5")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!6 = !{!0, !7, !14, !19}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !3, line: 10, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 40, elements: !12)
!10 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!11 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!12 = !{!13}
!13 = !DISubrange(count: 5)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(scope: null, file: !3, line: 10, type: !16, isLocal: true, isDefinition: true)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 216, elements: !17)
!17 = !{!18}
!18 = !DISubrange(count: 27)
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(scope: null, file: !3, line: 10, type: !21, isLocal: true, isDefinition: true)
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 56, elements: !22)
!22 = !{!23}
!23 = !DISubrange(count: 7)
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !{i32 1, !"NumRegisterParameters", i32 0}
!26 = !{i32 7, !"Dwarf Version", i32 5}
!27 = !{i32 2, !"Debug Info Version", i32 3}
!28 = !{i32 8, !"PIC Level", i32 2}
!29 = !{i32 7, !"PIE Level", i32 2}
!30 = !{i32 7, !"uwtable", i32 2}
!31 = !{i32 7, !"frame-pointer", i32 2}
!32 = !{!"Homebrew clang version 23.1.3"}
!33 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 5, type: !34, scopeLine: 5, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !36)
!34 = !DISubroutineType(types: !35)
!35 = !{!24}
!36 = !{}
!37 = !DILocalVariable(name: "small", scope: !33, file: !3, line: 6, type: !38)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 32)
!39 = !DILocation(line: 6, column: 10, scope: !33)
!40 = !DILocation(line: 6, column: 18, scope: !33)
!41 = !DILocalVariable(name: "huge", scope: !33, file: !3, line: 7, type: !42)
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 32)
!43 = !DILocation(line: 7, column: 11, scope: !33)
!44 = !DILocation(line: 7, column: 18, scope: !33)
!45 = !DILocation(line: 8, column: 9, scope: !46)
!46 = distinct !DILexicalBlock(scope: !33, file: !3, line: 8, column: 9)
!47 = !DILocation(line: 8, column: 14, scope: !46)
!48 = !DILocation(line: 8, column: 25, scope: !49)
!49 = distinct !DILexicalBlock(scope: !46, file: !3, line: 8, column: 23)
!50 = !DILocation(line: 9, column: 6, scope: !33)
!51 = !DILocation(line: 9, column: 12, scope: !33)
!52 = !DILocation(line: 10, column: 12, scope: !33)
!53 = !DILocation(line: 10, column: 14, scope: !33)
!54 = !DILocation(line: 10, column: 5, scope: !33)
!55 = !DILocation(line: 11, column: 5, scope: !33)
!56 = !DILocation(line: 12, column: 1, scope: !33)
