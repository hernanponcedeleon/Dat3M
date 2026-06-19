; ModuleID = 'benchmarks/miscellaneous/alias-shrinkToBounds.c'
source_filename = "benchmarks/miscellaneous/alias-shrinkToBounds.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.cache = type { [17 x i32], [2 x %struct.pthread_mutex_t] }
%struct.pthread_mutex_t = type { i64 }
%struct.pthread_t = type { i64 }

@c = dso_local global %struct.cache zeroinitializer, align 8, !dbg !0
@x = dso_local global i32 0, align 4, !dbg !24
@.str = private unnamed_addr constant [7 x i8] c"x == 2\00", align 1, !dbg !7
@.str.1 = private unnamed_addr constant [48 x i8] c"benchmarks/miscellaneous/alias-shrinkToBounds.c\00", align 1, !dbg !13
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !18

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @id(i32 noundef %0) #0 !dbg !52 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
    #dbg_declare(ptr %2, !56, !DIExpression(), !57)
    #dbg_declare(ptr %3, !58, !DIExpression(), !59)
  %4 = call i32 @__VERIFIER_nondet_int(), !dbg !60
  store i32 %4, ptr %3, align 4, !dbg !59
  %5 = load i32, ptr %3, align 4, !dbg !61
  %6 = load i32, ptr %2, align 4, !dbg !62
  %7 = icmp eq i32 %5, %6, !dbg !63
  %8 = zext i1 %7 to i32, !dbg !63
  call void @__VERIFIER_assume(i32 noundef %8), !dbg !64
  %9 = load i32, ptr %3, align 4, !dbg !65
  ret i32 %9, !dbg !66
}

declare i32 @__VERIFIER_nondet_int() #1

declare void @__VERIFIER_assume(i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @increment(i32 noundef %0) #0 !dbg !67 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
    #dbg_declare(ptr %2, !70, !DIExpression(), !71)
  %3 = load i32, ptr %2, align 4, !dbg !72
  %4 = sext i32 %3 to i64, !dbg !73
  %5 = getelementptr inbounds [2 x %struct.pthread_mutex_t], ptr getelementptr inbounds (%struct.cache, ptr @c, i32 0, i32 1), i64 0, i64 %4, !dbg !73
  %6 = call i32 @pthread_mutex_lock(ptr noundef %5), !dbg !74
  %7 = load volatile i32, ptr @x, align 4, !dbg !75
  %8 = add nsw i32 %7, 1, !dbg !75
  store volatile i32 %8, ptr @x, align 4, !dbg !75
  %9 = load i32, ptr %2, align 4, !dbg !76
  %10 = sext i32 %9 to i64, !dbg !77
  %11 = getelementptr inbounds [2 x %struct.pthread_mutex_t], ptr getelementptr inbounds (%struct.cache, ptr @c, i32 0, i32 1), i64 0, i64 %10, !dbg !77
  %12 = call i32 @pthread_mutex_unlock(ptr noundef %11), !dbg !78
  ret void, !dbg !79
}

declare i32 @pthread_mutex_lock(ptr noundef) #1

declare i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @t_fun(ptr noundef %0) #0 !dbg !80 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !83, !DIExpression(), !84)
  %3 = call i32 @id(i32 noundef 1), !dbg !85
  call void @increment(i32 noundef %3), !dbg !86
  ret ptr null, !dbg !87
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !88 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca %struct.pthread_t, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !91, !DIExpression(), !93)
  store i32 0, ptr %2, align 4, !dbg !93
  br label %4, !dbg !94

4:                                                ; preds = %12, %0
  %5 = load i32, ptr %2, align 4, !dbg !95
  %6 = icmp slt i32 %5, 2, !dbg !97
  br i1 %6, label %7, label %15, !dbg !98

7:                                                ; preds = %4
  %8 = load i32, ptr %2, align 4, !dbg !99
  %9 = sext i32 %8 to i64, !dbg !100
  %10 = getelementptr inbounds [2 x %struct.pthread_mutex_t], ptr getelementptr inbounds (%struct.cache, ptr @c, i32 0, i32 1), i64 0, i64 %9, !dbg !100
  %11 = call i32 @pthread_mutex_init(ptr noundef %10, ptr noundef null), !dbg !101
  br label %12, !dbg !101

12:                                               ; preds = %7
  %13 = load i32, ptr %2, align 4, !dbg !102
  %14 = add nsw i32 %13, 1, !dbg !102
  store i32 %14, ptr %2, align 4, !dbg !102
  br label %4, !dbg !103, !llvm.loop !104

15:                                               ; preds = %4
    #dbg_declare(ptr %3, !107, !DIExpression(), !112)
  %16 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @t_fun, ptr noundef null), !dbg !113
  %17 = call i32 @id(i32 noundef 0), !dbg !114
  call void @increment(i32 noundef %17), !dbg !115
  %18 = getelementptr inbounds %struct.pthread_t, ptr %3, i32 0, i32 0, !dbg !116
  %19 = load i64, ptr %18, align 8, !dbg !116
  %20 = call i32 @pthread_join(i64 %19, ptr noundef null), !dbg !116
  %21 = load volatile i32, ptr @x, align 4, !dbg !117
  %22 = icmp eq i32 %21, 2, !dbg !117
  br i1 %22, label %24, label %23, !dbg !120

23:                                               ; preds = %15
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 48, ptr noundef @__func__.main), !dbg !117
  br label %24, !dbg !117

24:                                               ; preds = %23, %15
  ret i32 0, !dbg !121
}

declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #1

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @pthread_join(i64, ptr noundef) #1

declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!44, !45, !46, !47, !48, !49, !50}
!llvm.ident = !{!51}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 17, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/miscellaneous/alias-shrinkToBounds.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6df5b474def14ea3c0918fafac3e9c9e")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !13, !18, !0, !24}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !3, line: 48, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 56, elements: !11)
!10 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!11 = !{!12}
!12 = !DISubrange(count: 7)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(scope: null, file: !3, line: 48, type: !15, isLocal: true, isDefinition: true)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 384, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 48)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !3, line: 48, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 40, elements: !22)
!21 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !10)
!22 = !{!23}
!23 = !DISubrange(count: 5)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 19, type: !26, isLocal: false, isDefinition: true)
!26 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !27)
!27 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!28 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "cache", file: !3, line: 11, size: 704, elements: !29)
!29 = !{!30, !34}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "garbage", scope: !28, file: !3, line: 15, baseType: !31, size: 544)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 544, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: 17)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "mutex", scope: !28, file: !3, line: 16, baseType: !35, size: 128, offset: 576)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !36, size: 128, elements: !42)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !37, line: 4, baseType: !38)
!37 = !DIFile(filename: "include/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "bf224a2dbfad8872b8146be186536b46")
!38 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !37, line: 4, size: 64, elements: !39)
!39 = !{!40}
!40 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !38, file: !37, line: 4, baseType: !41, size: 64)
!41 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!42 = !{!43}
!43 = !DISubrange(count: 2)
!44 = !{i32 7, !"Dwarf Version", i32 5}
!45 = !{i32 2, !"Debug Info Version", i32 3}
!46 = !{i32 1, !"wchar_size", i32 4}
!47 = !{i32 8, !"PIC Level", i32 2}
!48 = !{i32 7, !"PIE Level", i32 2}
!49 = !{i32 7, !"uwtable", i32 2}
!50 = !{i32 7, !"frame-pointer", i32 2}
!51 = !{!"Homebrew clang version 19.1.7"}
!52 = distinct !DISubprogram(name: "id", scope: !3, file: !3, line: 23, type: !53, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!53 = !DISubroutineType(types: !54)
!54 = !{!27, !27}
!55 = !{}
!56 = !DILocalVariable(name: "x", arg: 1, scope: !52, file: !3, line: 23, type: !27)
!57 = !DILocation(line: 23, column: 12, scope: !52)
!58 = !DILocalVariable(name: "i", scope: !52, file: !3, line: 24, type: !27)
!59 = !DILocation(line: 24, column: 7, scope: !52)
!60 = !DILocation(line: 24, column: 11, scope: !52)
!61 = !DILocation(line: 25, column: 21, scope: !52)
!62 = !DILocation(line: 25, column: 26, scope: !52)
!63 = !DILocation(line: 25, column: 23, scope: !52)
!64 = !DILocation(line: 25, column: 3, scope: !52)
!65 = !DILocation(line: 26, column: 10, scope: !52)
!66 = !DILocation(line: 26, column: 3, scope: !52)
!67 = distinct !DISubprogram(name: "increment", scope: !3, file: !3, line: 30, type: !68, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!68 = !DISubroutineType(types: !69)
!69 = !{null, !27}
!70 = !DILocalVariable(name: "i", arg: 1, scope: !67, file: !3, line: 30, type: !27)
!71 = !DILocation(line: 30, column: 20, scope: !67)
!72 = !DILocation(line: 31, column: 31, scope: !67)
!73 = !DILocation(line: 31, column: 23, scope: !67)
!74 = !DILocation(line: 31, column: 3, scope: !67)
!75 = !DILocation(line: 32, column: 4, scope: !67)
!76 = !DILocation(line: 33, column: 33, scope: !67)
!77 = !DILocation(line: 33, column: 25, scope: !67)
!78 = !DILocation(line: 33, column: 3, scope: !67)
!79 = !DILocation(line: 34, column: 1, scope: !67)
!80 = distinct !DISubprogram(name: "t_fun", scope: !3, file: !3, line: 36, type: !81, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!81 = !DISubroutineType(types: !82)
!82 = !{!5, !5}
!83 = !DILocalVariable(name: "arg", arg: 1, scope: !80, file: !3, line: 36, type: !5)
!84 = !DILocation(line: 36, column: 19, scope: !80)
!85 = !DILocation(line: 37, column: 13, scope: !80)
!86 = !DILocation(line: 37, column: 3, scope: !80)
!87 = !DILocation(line: 38, column: 3, scope: !80)
!88 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 41, type: !89, scopeLine: 41, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!89 = !DISubroutineType(types: !90)
!90 = !{!27}
!91 = !DILocalVariable(name: "i", scope: !92, file: !3, line: 42, type: !27)
!92 = distinct !DILexicalBlock(scope: !88, file: !3, line: 42, column: 3)
!93 = !DILocation(line: 42, column: 12, scope: !92)
!94 = !DILocation(line: 42, column: 8, scope: !92)
!95 = !DILocation(line: 42, column: 19, scope: !96)
!96 = distinct !DILexicalBlock(scope: !92, file: !3, line: 42, column: 3)
!97 = !DILocation(line: 42, column: 21, scope: !96)
!98 = !DILocation(line: 42, column: 3, scope: !92)
!99 = !DILocation(line: 43, column: 33, scope: !96)
!100 = !DILocation(line: 43, column: 25, scope: !96)
!101 = !DILocation(line: 43, column: 5, scope: !96)
!102 = !DILocation(line: 42, column: 35, scope: !96)
!103 = !DILocation(line: 42, column: 3, scope: !96)
!104 = distinct !{!104, !98, !105, !106}
!105 = !DILocation(line: 43, column: 41, scope: !92)
!106 = !{!"llvm.loop.mustprogress"}
!107 = !DILocalVariable(name: "t1", scope: !88, file: !3, line: 44, type: !108)
!108 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !37, line: 6, baseType: !109)
!109 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !37, line: 6, size: 64, elements: !110)
!110 = !{!111}
!111 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !109, file: !37, line: 6, baseType: !41, size: 64)
!112 = !DILocation(line: 44, column: 13, scope: !88)
!113 = !DILocation(line: 45, column: 3, scope: !88)
!114 = !DILocation(line: 46, column: 13, scope: !88)
!115 = !DILocation(line: 46, column: 3, scope: !88)
!116 = !DILocation(line: 47, column: 3, scope: !88)
!117 = !DILocation(line: 48, column: 3, scope: !118)
!118 = distinct !DILexicalBlock(scope: !119, file: !3, line: 48, column: 3)
!119 = distinct !DILexicalBlock(scope: !88, file: !3, line: 48, column: 3)
!120 = !DILocation(line: 48, column: 3, scope: !119)
!121 = !DILocation(line: 49, column: 3, scope: !88)
