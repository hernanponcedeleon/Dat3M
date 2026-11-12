; ModuleID = 'benchmarks/miscellaneous/ilp32-safe-malloc.c'
source_filename = "benchmarks/miscellaneous/ilp32-safe-malloc.c"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@g = dso_local global i32 7, align 4, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !7
@.str = private unnamed_addr constant [20 x i8] c"ilp32-safe-malloc.c\00", align 1, !dbg !14
@.str.1 = private unnamed_addr constant [29 x i8] c"big != NULL && small != NULL\00", align 1, !dbg !19
@.str.2 = private unnamed_addr constant [13 x i8] c"*small == 42\00", align 1, !dbg !24
@.str.3 = private unnamed_addr constant [7 x i8] c"g == 7\00", align 1, !dbg !29

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !43 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !47, !DIExpression(), !53)
  %5 = call i32 @__VERIFIER_nondet_uint(), !dbg !54
  store i32 %5, ptr %2, align 4, !dbg !53
    #dbg_declare(ptr %3, !55, !DIExpression(), !57)
  %6 = load i32, ptr %2, align 4, !dbg !58
  %7 = call ptr @malloc(i32 noundef %6) #4, !dbg !59
  store ptr %7, ptr %3, align 4, !dbg !57
    #dbg_declare(ptr %4, !60, !DIExpression(), !62)
  %8 = call ptr @malloc(i32 noundef 4) #4, !dbg !63
  store ptr %8, ptr %4, align 4, !dbg !62
  %9 = load ptr, ptr %3, align 4, !dbg !64
  %10 = icmp ne ptr %9, null, !dbg !65
  br i1 %10, label %11, label %14, !dbg !66

11:                                               ; preds = %0
  %12 = load ptr, ptr %4, align 4, !dbg !67
  %13 = icmp ne ptr %12, null, !dbg !68
  br label %14

14:                                               ; preds = %11, %0
  %15 = phi i1 [ false, %0 ], [ %13, %11 ], !dbg !69
  %16 = xor i1 %15, true, !dbg !70
  br i1 %16, label %17, label %19, !dbg !70

17:                                               ; preds = %14
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 19, ptr noundef @.str.1) #5, !dbg !70
  unreachable, !dbg !70

18:                                               ; No predecessors!
  br label %20, !dbg !70

19:                                               ; preds = %14
  br label %20, !dbg !70

20:                                               ; preds = %19, %18
  %21 = load ptr, ptr %4, align 4, !dbg !71
  store i32 42, ptr %21, align 4, !dbg !72
  %22 = load i32, ptr %2, align 4, !dbg !73
  %23 = icmp ugt i32 %22, 0, !dbg !75
  br i1 %23, label %24, label %31, !dbg !75

24:                                               ; preds = %20
  %25 = load ptr, ptr %3, align 4, !dbg !76
  %26 = getelementptr inbounds i8, ptr %25, i32 0, !dbg !76
  store i8 0, ptr %26, align 1, !dbg !78
  %27 = load ptr, ptr %3, align 4, !dbg !79
  %28 = load i32, ptr %2, align 4, !dbg !80
  %29 = sub i32 %28, 1, !dbg !81
  %30 = getelementptr inbounds nuw i8, ptr %27, i32 %29, !dbg !79
  store i8 0, ptr %30, align 1, !dbg !82
  br label %31, !dbg !83

31:                                               ; preds = %24, %20
  %32 = load ptr, ptr %4, align 4, !dbg !84
  %33 = load i32, ptr %32, align 4, !dbg !85
  %34 = icmp eq i32 %33, 42, !dbg !86
  %35 = xor i1 %34, true, !dbg !87
  br i1 %35, label %36, label %38, !dbg !87

36:                                               ; preds = %31
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 26, ptr noundef @.str.2) #5, !dbg !87
  unreachable, !dbg !87

37:                                               ; No predecessors!
  br label %39, !dbg !87

38:                                               ; preds = %31
  br label %39, !dbg !87

39:                                               ; preds = %38, %37
  %40 = load i32, ptr @g, align 4, !dbg !88
  %41 = icmp eq i32 %40, 7, !dbg !89
  %42 = xor i1 %41, true, !dbg !90
  br i1 %42, label %43, label %45, !dbg !90

43:                                               ; preds = %39
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 27, ptr noundef @.str.3) #5, !dbg !90
  unreachable, !dbg !90

44:                                               ; No predecessors!
  br label %46, !dbg !90

45:                                               ; preds = %39
  br label %46, !dbg !90

46:                                               ; preds = %45, %44
  ret i32 0, !dbg !91
}

declare i32 @__VERIFIER_nondet_uint() #1

; Function Attrs: allocsize(0)
declare ptr @malloc(i32 noundef) #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { allocsize(0) }
attributes #5 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!35, !36, !37, !38, !39, !40, !41}
!llvm.ident = !{!42}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g", scope: !2, file: !3, line: 13, type: !34, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/miscellaneous/ilp32-safe-malloc.c", directory: ".", checksumkind: CSK_MD5, checksum: "7ec2c684671b59380b078456a1c1dfa1")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!6 = !{!0, !7, !14, !19, !24, !29}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !3, line: 19, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 40, elements: !12)
!10 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!11 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!12 = !{!13}
!13 = !DISubrange(count: 5)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(scope: null, file: !3, line: 19, type: !16, isLocal: true, isDefinition: true)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 160, elements: !17)
!17 = !{!18}
!18 = !DISubrange(count: 20)
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(scope: null, file: !3, line: 19, type: !21, isLocal: true, isDefinition: true)
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 232, elements: !22)
!22 = !{!23}
!23 = !DISubrange(count: 29)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !26, isLocal: true, isDefinition: true)
!26 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 104, elements: !27)
!27 = !{!28}
!28 = !DISubrange(count: 13)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 27, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 56, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: 7)
!34 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!35 = !{i32 1, !"NumRegisterParameters", i32 0}
!36 = !{i32 7, !"Dwarf Version", i32 5}
!37 = !{i32 2, !"Debug Info Version", i32 3}
!38 = !{i32 8, !"PIC Level", i32 2}
!39 = !{i32 7, !"PIE Level", i32 2}
!40 = !{i32 7, !"uwtable", i32 2}
!41 = !{i32 7, !"frame-pointer", i32 2}
!42 = !{!"Homebrew clang version 23.1.3"}
!43 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 15, type: !44, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !46)
!44 = !DISubroutineType(types: !45)
!45 = !{!34}
!46 = !{}
!47 = !DILocalVariable(name: "size", scope: !43, file: !3, line: 16, type: !48)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !49, line: 50, baseType: !50)
!49 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_types/_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "f7981334d28e0c246f35cd24042aa2a4")
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_size_t", file: !51, line: 111, baseType: !52)
!51 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/i386/_types.h", directory: "", checksumkind: CSK_MD5, checksum: "eb9e401b3b97107c79f668bcc91916e5")
!52 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!53 = !DILocation(line: 16, column: 12, scope: !43)
!54 = !DILocation(line: 16, column: 19, scope: !43)
!55 = !DILocalVariable(name: "big", scope: !43, file: !3, line: 17, type: !56)
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 32)
!57 = !DILocation(line: 17, column: 11, scope: !43)
!58 = !DILocation(line: 17, column: 24, scope: !43)
!59 = !DILocation(line: 17, column: 17, scope: !43)
!60 = !DILocalVariable(name: "small", scope: !43, file: !3, line: 18, type: !61)
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 32)
!62 = !DILocation(line: 18, column: 10, scope: !43)
!63 = !DILocation(line: 18, column: 18, scope: !43)
!64 = !DILocation(line: 19, column: 12, scope: !43)
!65 = !DILocation(line: 19, column: 16, scope: !43)
!66 = !DILocation(line: 19, column: 24, scope: !43)
!67 = !DILocation(line: 19, column: 27, scope: !43)
!68 = !DILocation(line: 19, column: 33, scope: !43)
!69 = !DILocation(line: 0, scope: !43)
!70 = !DILocation(line: 19, column: 5, scope: !43)
!71 = !DILocation(line: 21, column: 6, scope: !43)
!72 = !DILocation(line: 21, column: 12, scope: !43)
!73 = !DILocation(line: 22, column: 9, scope: !74)
!74 = distinct !DILexicalBlock(scope: !43, file: !3, line: 22, column: 9)
!75 = !DILocation(line: 22, column: 14, scope: !74)
!76 = !DILocation(line: 23, column: 9, scope: !77)
!77 = distinct !DILexicalBlock(scope: !74, file: !3, line: 22, column: 19)
!78 = !DILocation(line: 23, column: 16, scope: !77)
!79 = !DILocation(line: 24, column: 9, scope: !77)
!80 = !DILocation(line: 24, column: 13, scope: !77)
!81 = !DILocation(line: 24, column: 18, scope: !77)
!82 = !DILocation(line: 24, column: 23, scope: !77)
!83 = !DILocation(line: 25, column: 5, scope: !77)
!84 = !DILocation(line: 26, column: 13, scope: !43)
!85 = !DILocation(line: 26, column: 12, scope: !43)
!86 = !DILocation(line: 26, column: 19, scope: !43)
!87 = !DILocation(line: 26, column: 5, scope: !43)
!88 = !DILocation(line: 27, column: 12, scope: !43)
!89 = !DILocation(line: 27, column: 14, scope: !43)
!90 = !DILocation(line: 27, column: 5, scope: !43)
!91 = !DILocation(line: 28, column: 5, scope: !43)
