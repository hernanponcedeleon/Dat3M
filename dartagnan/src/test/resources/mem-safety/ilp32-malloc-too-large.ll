; ModuleID = 'benchmarks/mem-safety/ilp32-malloc-too-large.c'
source_filename = "benchmarks/mem-safety/ilp32-malloc-too-large.c"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@g = dso_local global i32 7, align 4, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !5
@.str = private unnamed_addr constant [25 x i8] c"ilp32-malloc-too-large.c\00", align 1, !dbg !12
@.str.1 = private unnamed_addr constant [23 x i8] c"*small == 42 && g == 7\00", align 1, !dbg !17

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !31 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 4
  %3 = alloca ptr, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !35, !DIExpression(), !37)
  %4 = call ptr @malloc(i32 noundef 4) #3, !dbg !38
  store ptr %4, ptr %2, align 4, !dbg !37
    #dbg_declare(ptr %3, !39, !DIExpression(), !41)
  %5 = call ptr @malloc(i32 noundef -16) #3, !dbg !42
  store ptr %5, ptr %3, align 4, !dbg !41
  %6 = load ptr, ptr %2, align 4, !dbg !43
  store i32 42, ptr %6, align 4, !dbg !44
  %7 = load ptr, ptr %2, align 4, !dbg !45
  %8 = load i32, ptr %7, align 4, !dbg !46
  %9 = icmp eq i32 %8, 42, !dbg !47
  br i1 %9, label %10, label %13, !dbg !48

10:                                               ; preds = %0
  %11 = load i32, ptr @g, align 4, !dbg !49
  %12 = icmp eq i32 %11, 7, !dbg !50
  br label %13

13:                                               ; preds = %10, %0
  %14 = phi i1 [ false, %0 ], [ %12, %10 ], !dbg !51
  %15 = xor i1 %14, true, !dbg !52
  br i1 %15, label %16, label %18, !dbg !52

16:                                               ; preds = %13
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 26, ptr noundef @.str.1) #4, !dbg !52
  unreachable, !dbg !52

17:                                               ; No predecessors!
  br label %19, !dbg !52

18:                                               ; preds = %13
  br label %19, !dbg !52

19:                                               ; preds = %18, %17
  ret i32 0, !dbg !53
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
!llvm.module.flags = !{!23, !24, !25, !26, !27, !28, !29}
!llvm.ident = !{!30}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g", scope: !2, file: !3, line: 17, type: !22, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/mem-safety/ilp32-malloc-too-large.c", directory: ".", checksumkind: CSK_MD5, checksum: "2fcdcb0a9f45d1cab36a94eadaf94d20")
!4 = !{!0, !5, !12, !17}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !7, isLocal: true, isDefinition: true)
!7 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 40, elements: !10)
!8 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !9)
!9 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!10 = !{!11}
!11 = !DISubrange(count: 5)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 200, elements: !15)
!15 = !{!16}
!16 = !DISubrange(count: 25)
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !19, isLocal: true, isDefinition: true)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 184, elements: !20)
!20 = !{!21}
!21 = !DISubrange(count: 23)
!22 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!23 = !{i32 1, !"NumRegisterParameters", i32 0}
!24 = !{i32 7, !"Dwarf Version", i32 5}
!25 = !{i32 2, !"Debug Info Version", i32 3}
!26 = !{i32 8, !"PIC Level", i32 2}
!27 = !{i32 7, !"PIE Level", i32 2}
!28 = !{i32 7, !"uwtable", i32 2}
!29 = !{i32 7, !"frame-pointer", i32 2}
!30 = !{!"Homebrew clang version 23.1.3"}
!31 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 19, type: !32, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!32 = !DISubroutineType(types: !33)
!33 = !{!22}
!34 = !{}
!35 = !DILocalVariable(name: "small", scope: !31, file: !3, line: 20, type: !36)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 32)
!37 = !DILocation(line: 20, column: 10, scope: !31)
!38 = !DILocation(line: 20, column: 18, scope: !31)
!39 = !DILocalVariable(name: "huge", scope: !31, file: !3, line: 21, type: !40)
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 32)
!41 = !DILocation(line: 21, column: 11, scope: !31)
!42 = !DILocation(line: 21, column: 18, scope: !31)
!43 = !DILocation(line: 25, column: 6, scope: !31)
!44 = !DILocation(line: 25, column: 12, scope: !31)
!45 = !DILocation(line: 26, column: 13, scope: !31)
!46 = !DILocation(line: 26, column: 12, scope: !31)
!47 = !DILocation(line: 26, column: 19, scope: !31)
!48 = !DILocation(line: 26, column: 25, scope: !31)
!49 = !DILocation(line: 26, column: 28, scope: !31)
!50 = !DILocation(line: 26, column: 30, scope: !31)
!51 = !DILocation(line: 0, scope: !31)
!52 = !DILocation(line: 26, column: 5, scope: !31)
!53 = !DILocation(line: 27, column: 5, scope: !31)
