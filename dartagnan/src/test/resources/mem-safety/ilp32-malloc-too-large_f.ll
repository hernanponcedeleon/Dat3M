; ModuleID = 'benchmarks/mem-safety/ilp32-malloc-too-large.c'
source_filename = "benchmarks/mem-safety/ilp32-malloc-too-large.c"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@g = dso_local global i32 7, align 4, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !7
@.str = private unnamed_addr constant [25 x i8] c"ilp32-malloc-too-large.c\00", align 1, !dbg !14
@.str.1 = private unnamed_addr constant [13 x i8] c"huge != NULL\00", align 1, !dbg !19
@.str.2 = private unnamed_addr constant [23 x i8] c"*small == 42 && g == 7\00", align 1, !dbg !24

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !38 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 4
  %3 = alloca ptr, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !42, !DIExpression(), !44)
  %4 = call ptr @malloc(i32 noundef 4) #3, !dbg !45
  store ptr %4, ptr %2, align 4, !dbg !44
    #dbg_declare(ptr %3, !46, !DIExpression(), !48)
  %5 = call ptr @malloc(i32 noundef -16) #3, !dbg !49
  store ptr %5, ptr %3, align 4, !dbg !48
  %6 = load ptr, ptr %3, align 4, !dbg !50
  %7 = icmp ne ptr %6, null, !dbg !51
  %8 = xor i1 %7, true, !dbg !52
  br i1 %8, label %9, label %11, !dbg !52

9:                                                ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 23, ptr noundef @.str.1) #4, !dbg !52
  unreachable, !dbg !52

10:                                               ; No predecessors!
  br label %12, !dbg !52

11:                                               ; preds = %0
  br label %12, !dbg !52

12:                                               ; preds = %11, %10
  %13 = load ptr, ptr %2, align 4, !dbg !53
  store i32 42, ptr %13, align 4, !dbg !54
  %14 = load ptr, ptr %2, align 4, !dbg !55
  %15 = load i32, ptr %14, align 4, !dbg !56
  %16 = icmp eq i32 %15, 42, !dbg !57
  br i1 %16, label %17, label %20, !dbg !58

17:                                               ; preds = %12
  %18 = load i32, ptr @g, align 4, !dbg !59
  %19 = icmp eq i32 %18, 7, !dbg !60
  br label %20

20:                                               ; preds = %17, %12
  %21 = phi i1 [ false, %12 ], [ %19, %17 ], !dbg !61
  %22 = xor i1 %21, true, !dbg !62
  br i1 %22, label %23, label %25, !dbg !62

23:                                               ; preds = %20
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 26, ptr noundef @.str.2) #4, !dbg !62
  unreachable, !dbg !62

24:                                               ; No predecessors!
  br label %26, !dbg !62

25:                                               ; preds = %20
  br label %26, !dbg !62

26:                                               ; preds = %25, %24
  ret i32 0, !dbg !63
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
!llvm.module.flags = !{!30, !31, !32, !33, !34, !35, !36}
!llvm.ident = !{!37}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g", scope: !2, file: !3, line: 17, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/mem-safety/ilp32-malloc-too-large.c", directory: ".", checksumkind: CSK_MD5, checksum: "2fcdcb0a9f45d1cab36a94eadaf94d20")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!6 = !{!0, !7, !14, !19, !24}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !3, line: 23, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 40, elements: !12)
!10 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!11 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!12 = !{!13}
!13 = !DISubrange(count: 5)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(scope: null, file: !3, line: 23, type: !16, isLocal: true, isDefinition: true)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 200, elements: !17)
!17 = !{!18}
!18 = !DISubrange(count: 25)
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(scope: null, file: !3, line: 23, type: !21, isLocal: true, isDefinition: true)
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 104, elements: !22)
!22 = !{!23}
!23 = !DISubrange(count: 13)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !26, isLocal: true, isDefinition: true)
!26 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 184, elements: !27)
!27 = !{!28}
!28 = !DISubrange(count: 23)
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !{i32 1, !"NumRegisterParameters", i32 0}
!31 = !{i32 7, !"Dwarf Version", i32 5}
!32 = !{i32 2, !"Debug Info Version", i32 3}
!33 = !{i32 8, !"PIC Level", i32 2}
!34 = !{i32 7, !"PIE Level", i32 2}
!35 = !{i32 7, !"uwtable", i32 2}
!36 = !{i32 7, !"frame-pointer", i32 2}
!37 = !{!"Homebrew clang version 23.1.3"}
!38 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 19, type: !39, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !41)
!39 = !DISubroutineType(types: !40)
!40 = !{!29}
!41 = !{}
!42 = !DILocalVariable(name: "small", scope: !38, file: !3, line: 20, type: !43)
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 32)
!44 = !DILocation(line: 20, column: 10, scope: !38)
!45 = !DILocation(line: 20, column: 18, scope: !38)
!46 = !DILocalVariable(name: "huge", scope: !38, file: !3, line: 21, type: !47)
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 32)
!48 = !DILocation(line: 21, column: 11, scope: !38)
!49 = !DILocation(line: 21, column: 18, scope: !38)
!50 = !DILocation(line: 23, column: 12, scope: !38)
!51 = !DILocation(line: 23, column: 17, scope: !38)
!52 = !DILocation(line: 23, column: 5, scope: !38)
!53 = !DILocation(line: 25, column: 6, scope: !38)
!54 = !DILocation(line: 25, column: 12, scope: !38)
!55 = !DILocation(line: 26, column: 13, scope: !38)
!56 = !DILocation(line: 26, column: 12, scope: !38)
!57 = !DILocation(line: 26, column: 19, scope: !38)
!58 = !DILocation(line: 26, column: 25, scope: !38)
!59 = !DILocation(line: 26, column: 28, scope: !38)
!60 = !DILocation(line: 26, column: 30, scope: !38)
!61 = !DILocation(line: 0, scope: !38)
!62 = !DILocation(line: 26, column: 5, scope: !38)
!63 = !DILocation(line: 27, column: 5, scope: !38)
