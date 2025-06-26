; ModuleID = 'benchmarks/lkmm/rcu+ar-link0.c'
source_filename = "benchmarks/lkmm/rcu+ar-link0.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !47
@r_y = dso_local global i32 0, align 4, !dbg !51
@s = dso_local global i32 0, align 4, !dbg !53
@r_s = dso_local global i32 0, align 4, !dbg !65
@w = dso_local global i32 0, align 4, !dbg !55
@z = dso_local global i32 0, align 4, !dbg !57
@a = dso_local global i32 0, align 4, !dbg !59
@r_a = dso_local global i32 0, align 4, !dbg !67
@b = dso_local global i32 0, align 4, !dbg !61
@r_b = dso_local global i32 0, align 4, !dbg !69
@c = dso_local global i32 0, align 4, !dbg !63
@r_c = dso_local global i32 0, align 4, !dbg !71
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !30
@.str = private unnamed_addr constant [15 x i8] c"rcu+ar-link0.c\00", align 1, !dbg !37
@.str.1 = private unnamed_addr constant [60 x i8] c"!(r_y == 1 && r_s == 1 && r_a == 1 && r_b == 1 && r_c == 1)\00", align 1, !dbg !42
@r_x = dso_local global i32 0, align 4, !dbg !49

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P0(ptr noundef %0) #0 !dbg !81 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !85, !DIExpression(), !86)
  call void @__LKMM_fence(i32 noundef 6), !dbg !87
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !88
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 0), !dbg !89
  %4 = trunc i64 %3 to i32, !dbg !89
  store i32 %4, ptr @r_y, align 4, !dbg !90
  call void @__LKMM_fence(i32 noundef 7), !dbg !91
  ret ptr null, !dbg !92
}

declare void @__LKMM_fence(i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P1(ptr noundef %0) #0 !dbg !93 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !94, !DIExpression(), !95)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !96
  %4 = trunc i64 %3 to i32, !dbg !96
  %5 = icmp eq i32 %4, 1, !dbg !98
  br i1 %5, label %6, label %7, !dbg !99

6:                                                ; preds = %1
  call void @__LKMM_store(ptr noundef @s, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !100
  br label %7, !dbg !100

7:                                                ; preds = %6, %1
  ret ptr null, !dbg !101
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P2(ptr noundef %0) #0 !dbg !102 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !103, !DIExpression(), !104)
  %4 = call i64 @__LKMM_load(ptr noundef @s, i64 noundef 4, i32 noundef 0), !dbg !105
  %5 = trunc i64 %4 to i32, !dbg !105
  store i32 %5, ptr @r_s, align 4, !dbg !106
  call void @__LKMM_store(ptr noundef @w, i64 noundef 4, i64 noundef 1, i32 noundef 2), !dbg !107
    #dbg_declare(ptr %3, !108, !DIExpression(), !109)
  %6 = call i64 @__LKMM_load(ptr noundef @z, i64 noundef 4, i32 noundef 0), !dbg !110
  %7 = trunc i64 %6 to i32, !dbg !110
  store i32 %7, ptr %3, align 4, !dbg !109
  %8 = load i32, ptr %3, align 4, !dbg !111
  %9 = add nsw i32 %8, 1, !dbg !111
  %10 = sext i32 %9 to i64, !dbg !111
  call void @__LKMM_store(ptr noundef @a, i64 noundef 4, i64 noundef %10, i32 noundef 0), !dbg !111
  ret ptr null, !dbg !112
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P3(ptr noundef %0) #0 !dbg !113 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !114, !DIExpression(), !115)
  %3 = call i64 @__LKMM_load(ptr noundef @a, i64 noundef 4, i32 noundef 0), !dbg !116
  %4 = trunc i64 %3 to i32, !dbg !116
  store i32 %4, ptr @r_a, align 4, !dbg !117
  %5 = load i32, ptr @r_a, align 4, !dbg !118
  %6 = sext i32 %5 to i64, !dbg !118
  call void @__LKMM_store(ptr noundef @b, i64 noundef 4, i64 noundef %6, i32 noundef 0), !dbg !118
  ret ptr null, !dbg !119
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P4(ptr noundef %0) #0 !dbg !120 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !121, !DIExpression(), !122)
  %3 = call i64 @__LKMM_load(ptr noundef @b, i64 noundef 4, i32 noundef 0), !dbg !123
  %4 = trunc i64 %3 to i32, !dbg !123
  store i32 %4, ptr @r_b, align 4, !dbg !124
  call void @__LKMM_store(ptr noundef @c, i64 noundef 4, i64 noundef 1, i32 noundef 2), !dbg !125
  ret ptr null, !dbg !126
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P5(ptr noundef %0) #0 !dbg !127 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !128, !DIExpression(), !129)
  %3 = call i64 @__LKMM_load(ptr noundef @c, i64 noundef 4, i32 noundef 0), !dbg !130
  %4 = trunc i64 %3 to i32, !dbg !130
  store i32 %4, ptr @r_c, align 4, !dbg !131
  call void @__LKMM_fence(i32 noundef 8), !dbg !132
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !133
  ret ptr null, !dbg !134
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !135 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !138, !DIExpression(), !161)
    #dbg_declare(ptr %3, !162, !DIExpression(), !163)
    #dbg_declare(ptr %4, !164, !DIExpression(), !165)
    #dbg_declare(ptr %5, !166, !DIExpression(), !167)
    #dbg_declare(ptr %6, !168, !DIExpression(), !169)
    #dbg_declare(ptr %7, !170, !DIExpression(), !171)
  %8 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @P0, ptr noundef null), !dbg !172
  %9 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @P1, ptr noundef null), !dbg !173
  %10 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @P2, ptr noundef null), !dbg !174
  %11 = call i32 @pthread_create(ptr noundef %5, ptr noundef null, ptr noundef @P3, ptr noundef null), !dbg !175
  %12 = call i32 @pthread_create(ptr noundef %6, ptr noundef null, ptr noundef @P4, ptr noundef null), !dbg !176
  %13 = call i32 @pthread_create(ptr noundef %7, ptr noundef null, ptr noundef @P5, ptr noundef null), !dbg !177
  %14 = load ptr, ptr %2, align 8, !dbg !178
  %15 = call i32 @_pthread_join(ptr noundef %14, ptr noundef null), !dbg !179
  %16 = load ptr, ptr %3, align 8, !dbg !180
  %17 = call i32 @_pthread_join(ptr noundef %16, ptr noundef null), !dbg !181
  %18 = load ptr, ptr %4, align 8, !dbg !182
  %19 = call i32 @_pthread_join(ptr noundef %18, ptr noundef null), !dbg !183
  %20 = load ptr, ptr %5, align 8, !dbg !184
  %21 = call i32 @_pthread_join(ptr noundef %20, ptr noundef null), !dbg !185
  %22 = load ptr, ptr %6, align 8, !dbg !186
  %23 = call i32 @_pthread_join(ptr noundef %22, ptr noundef null), !dbg !187
  %24 = load ptr, ptr %7, align 8, !dbg !188
  %25 = call i32 @_pthread_join(ptr noundef %24, ptr noundef null), !dbg !189
  %26 = load i32, ptr @r_y, align 4, !dbg !190
  %27 = icmp eq i32 %26, 1, !dbg !190
  br i1 %27, label %28, label %40, !dbg !190

28:                                               ; preds = %0
  %29 = load i32, ptr @r_s, align 4, !dbg !190
  %30 = icmp eq i32 %29, 1, !dbg !190
  br i1 %30, label %31, label %40, !dbg !190

31:                                               ; preds = %28
  %32 = load i32, ptr @r_a, align 4, !dbg !190
  %33 = icmp eq i32 %32, 1, !dbg !190
  br i1 %33, label %34, label %40, !dbg !190

34:                                               ; preds = %31
  %35 = load i32, ptr @r_b, align 4, !dbg !190
  %36 = icmp eq i32 %35, 1, !dbg !190
  br i1 %36, label %37, label %40, !dbg !190

37:                                               ; preds = %34
  %38 = load i32, ptr @r_c, align 4, !dbg !190
  %39 = icmp eq i32 %38, 1, !dbg !190
  br label %40

40:                                               ; preds = %37, %34, %31, %28, %0
  %41 = phi i1 [ false, %34 ], [ false, %31 ], [ false, %28 ], [ false, %0 ], [ %39, %37 ], !dbg !191
  %42 = xor i1 %41, true, !dbg !190
  %43 = xor i1 %42, true, !dbg !190
  %44 = zext i1 %43 to i32, !dbg !190
  %45 = sext i32 %44 to i64, !dbg !190
  %46 = icmp ne i64 %45, 0, !dbg !190
  br i1 %46, label %47, label %49, !dbg !190

47:                                               ; preds = %40
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 105, ptr noundef @.str.1) #3, !dbg !190
  unreachable, !dbg !190

48:                                               ; No predecessors!
  br label %50, !dbg !190

49:                                               ; preds = %40
  br label %50, !dbg !190

50:                                               ; preds = %49, %48
  ret i32 0, !dbg !192
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @_pthread_join(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!73, !74, !75, !76, !77, !78, !79}
!llvm.ident = !{!80}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 16, type: !27, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !22, globals: !29, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/rcu+ar-link0.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6b13efe8b5bb64ba02860a374c43853f")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "26457005f8f39b3952d279119fb45118")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21}
!9 = !DIEnumerator(name: "__LKMM_once", value: 0)
!10 = !DIEnumerator(name: "__LKMM_acquire", value: 1)
!11 = !DIEnumerator(name: "__LKMM_release", value: 2)
!12 = !DIEnumerator(name: "__LKMM_mb", value: 3)
!13 = !DIEnumerator(name: "__LKMM_wmb", value: 4)
!14 = !DIEnumerator(name: "__LKMM_rmb", value: 5)
!15 = !DIEnumerator(name: "__LKMM_rcu_lock", value: 6)
!16 = !DIEnumerator(name: "__LKMM_rcu_unlock", value: 7)
!17 = !DIEnumerator(name: "__LKMM_rcu_sync", value: 8)
!18 = !DIEnumerator(name: "__LKMM_before_atomic", value: 9)
!19 = !DIEnumerator(name: "__LKMM_after_atomic", value: 10)
!20 = !DIEnumerator(name: "__LKMM_after_spinlock", value: 11)
!21 = !DIEnumerator(name: "__LKMM_barrier", value: 12)
!22 = !{!23, !27, !28}
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 27, baseType: !24)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !25, line: 32, baseType: !26)
!25 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!26 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!27 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!29 = !{!30, !37, !42, !0, !47, !49, !51, !53, !55, !57, !59, !61, !63, !65, !67, !69, !71}
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 105, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 40, elements: !35)
!33 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!34 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!35 = !{!36}
!36 = !DISubrange(count: 5)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 105, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 120, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 15)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 105, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 480, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 60)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 17, type: !27, isLocal: false, isDefinition: true)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(name: "r_x", scope: !2, file: !3, line: 19, type: !27, isLocal: false, isDefinition: true)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(name: "r_y", scope: !2, file: !3, line: 20, type: !27, isLocal: false, isDefinition: true)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !3, line: 23, type: !27, isLocal: false, isDefinition: true)
!55 = !DIGlobalVariableExpression(var: !56, expr: !DIExpression())
!56 = distinct !DIGlobalVariable(name: "w", scope: !2, file: !3, line: 24, type: !27, isLocal: false, isDefinition: true)
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !3, line: 25, type: !27, isLocal: false, isDefinition: true)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 27, type: !27, isLocal: false, isDefinition: true)
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !3, line: 28, type: !27, isLocal: false, isDefinition: true)
!63 = !DIGlobalVariableExpression(var: !64, expr: !DIExpression())
!64 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 29, type: !27, isLocal: false, isDefinition: true)
!65 = !DIGlobalVariableExpression(var: !66, expr: !DIExpression())
!66 = distinct !DIGlobalVariable(name: "r_s", scope: !2, file: !3, line: 31, type: !27, isLocal: false, isDefinition: true)
!67 = !DIGlobalVariableExpression(var: !68, expr: !DIExpression())
!68 = distinct !DIGlobalVariable(name: "r_a", scope: !2, file: !3, line: 32, type: !27, isLocal: false, isDefinition: true)
!69 = !DIGlobalVariableExpression(var: !70, expr: !DIExpression())
!70 = distinct !DIGlobalVariable(name: "r_b", scope: !2, file: !3, line: 33, type: !27, isLocal: false, isDefinition: true)
!71 = !DIGlobalVariableExpression(var: !72, expr: !DIExpression())
!72 = distinct !DIGlobalVariable(name: "r_c", scope: !2, file: !3, line: 34, type: !27, isLocal: false, isDefinition: true)
!73 = !{i32 7, !"Dwarf Version", i32 5}
!74 = !{i32 2, !"Debug Info Version", i32 3}
!75 = !{i32 1, !"wchar_size", i32 4}
!76 = !{i32 8, !"PIC Level", i32 2}
!77 = !{i32 7, !"PIE Level", i32 2}
!78 = !{i32 7, !"uwtable", i32 2}
!79 = !{i32 7, !"frame-pointer", i32 2}
!80 = !{!"Homebrew clang version 19.1.7"}
!81 = distinct !DISubprogram(name: "P0", scope: !3, file: !3, line: 36, type: !82, scopeLine: 37, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !84)
!82 = !DISubroutineType(types: !83)
!83 = !{!28, !28}
!84 = !{}
!85 = !DILocalVariable(name: "unused", arg: 1, scope: !81, file: !3, line: 36, type: !28)
!86 = !DILocation(line: 36, column: 16, scope: !81)
!87 = !DILocation(line: 38, column: 2, scope: !81)
!88 = !DILocation(line: 39, column: 2, scope: !81)
!89 = !DILocation(line: 40, column: 8, scope: !81)
!90 = !DILocation(line: 40, column: 6, scope: !81)
!91 = !DILocation(line: 41, column: 2, scope: !81)
!92 = !DILocation(line: 42, column: 2, scope: !81)
!93 = distinct !DISubprogram(name: "P1", scope: !3, file: !3, line: 45, type: !82, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !84)
!94 = !DILocalVariable(name: "unused", arg: 1, scope: !93, file: !3, line: 45, type: !28)
!95 = !DILocation(line: 45, column: 16, scope: !93)
!96 = !DILocation(line: 47, column: 6, scope: !97)
!97 = distinct !DILexicalBlock(scope: !93, file: !3, line: 47, column: 6)
!98 = !DILocation(line: 47, column: 19, scope: !97)
!99 = !DILocation(line: 47, column: 6, scope: !93)
!100 = !DILocation(line: 48, column: 3, scope: !97)
!101 = !DILocation(line: 49, column: 2, scope: !93)
!102 = distinct !DISubprogram(name: "P2", scope: !3, file: !3, line: 52, type: !82, scopeLine: 53, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !84)
!103 = !DILocalVariable(name: "unused", arg: 1, scope: !102, file: !3, line: 52, type: !28)
!104 = !DILocation(line: 52, column: 16, scope: !102)
!105 = !DILocation(line: 54, column: 8, scope: !102)
!106 = !DILocation(line: 54, column: 6, scope: !102)
!107 = !DILocation(line: 55, column: 2, scope: !102)
!108 = !DILocalVariable(name: "r", scope: !102, file: !3, line: 57, type: !27)
!109 = !DILocation(line: 57, column: 6, scope: !102)
!110 = !DILocation(line: 57, column: 10, scope: !102)
!111 = !DILocation(line: 58, column: 2, scope: !102)
!112 = !DILocation(line: 59, column: 2, scope: !102)
!113 = distinct !DISubprogram(name: "P3", scope: !3, file: !3, line: 62, type: !82, scopeLine: 63, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !84)
!114 = !DILocalVariable(name: "unused", arg: 1, scope: !113, file: !3, line: 62, type: !28)
!115 = !DILocation(line: 62, column: 16, scope: !113)
!116 = !DILocation(line: 64, column: 8, scope: !113)
!117 = !DILocation(line: 64, column: 6, scope: !113)
!118 = !DILocation(line: 65, column: 2, scope: !113)
!119 = !DILocation(line: 66, column: 2, scope: !113)
!120 = distinct !DISubprogram(name: "P4", scope: !3, file: !3, line: 69, type: !82, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !84)
!121 = !DILocalVariable(name: "unused", arg: 1, scope: !120, file: !3, line: 69, type: !28)
!122 = !DILocation(line: 69, column: 16, scope: !120)
!123 = !DILocation(line: 71, column: 8, scope: !120)
!124 = !DILocation(line: 71, column: 6, scope: !120)
!125 = !DILocation(line: 72, column: 2, scope: !120)
!126 = !DILocation(line: 73, column: 2, scope: !120)
!127 = distinct !DISubprogram(name: "P5", scope: !3, file: !3, line: 76, type: !82, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !84)
!128 = !DILocalVariable(name: "unused", arg: 1, scope: !127, file: !3, line: 76, type: !28)
!129 = !DILocation(line: 76, column: 16, scope: !127)
!130 = !DILocation(line: 78, column: 8, scope: !127)
!131 = !DILocation(line: 78, column: 6, scope: !127)
!132 = !DILocation(line: 79, column: 2, scope: !127)
!133 = !DILocation(line: 80, column: 2, scope: !127)
!134 = !DILocation(line: 81, column: 2, scope: !127)
!135 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 84, type: !136, scopeLine: 85, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !84)
!136 = !DISubroutineType(types: !137)
!137 = !{!27}
!138 = !DILocalVariable(name: "t0", scope: !135, file: !3, line: 89, type: !139)
!139 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !140, line: 31, baseType: !141)
!140 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!141 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !142, line: 118, baseType: !143)
!142 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!143 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !144, size: 64)
!144 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !142, line: 103, size: 65536, elements: !145)
!145 = !{!146, !147, !157}
!146 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !144, file: !142, line: 104, baseType: !26, size: 64)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !144, file: !142, line: 105, baseType: !148, size: 64, offset: 64)
!148 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !149, size: 64)
!149 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !142, line: 57, size: 192, elements: !150)
!150 = !{!151, !155, !156}
!151 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !149, file: !142, line: 58, baseType: !152, size: 64)
!152 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !153, size: 64)
!153 = !DISubroutineType(types: !154)
!154 = !{null, !28}
!155 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !149, file: !142, line: 59, baseType: !28, size: 64, offset: 64)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !149, file: !142, line: 60, baseType: !148, size: 64, offset: 128)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !144, file: !142, line: 106, baseType: !158, size: 65408, offset: 128)
!158 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 65408, elements: !159)
!159 = !{!160}
!160 = !DISubrange(count: 8176)
!161 = !DILocation(line: 89, column: 12, scope: !135)
!162 = !DILocalVariable(name: "t1", scope: !135, file: !3, line: 89, type: !139)
!163 = !DILocation(line: 89, column: 16, scope: !135)
!164 = !DILocalVariable(name: "t2", scope: !135, file: !3, line: 89, type: !139)
!165 = !DILocation(line: 89, column: 20, scope: !135)
!166 = !DILocalVariable(name: "t3", scope: !135, file: !3, line: 89, type: !139)
!167 = !DILocation(line: 89, column: 24, scope: !135)
!168 = !DILocalVariable(name: "t4", scope: !135, file: !3, line: 89, type: !139)
!169 = !DILocation(line: 89, column: 28, scope: !135)
!170 = !DILocalVariable(name: "t5", scope: !135, file: !3, line: 89, type: !139)
!171 = !DILocation(line: 89, column: 32, scope: !135)
!172 = !DILocation(line: 91, column: 2, scope: !135)
!173 = !DILocation(line: 92, column: 2, scope: !135)
!174 = !DILocation(line: 93, column: 2, scope: !135)
!175 = !DILocation(line: 94, column: 2, scope: !135)
!176 = !DILocation(line: 95, column: 2, scope: !135)
!177 = !DILocation(line: 96, column: 2, scope: !135)
!178 = !DILocation(line: 98, column: 15, scope: !135)
!179 = !DILocation(line: 98, column: 2, scope: !135)
!180 = !DILocation(line: 99, column: 15, scope: !135)
!181 = !DILocation(line: 99, column: 2, scope: !135)
!182 = !DILocation(line: 100, column: 15, scope: !135)
!183 = !DILocation(line: 100, column: 2, scope: !135)
!184 = !DILocation(line: 101, column: 15, scope: !135)
!185 = !DILocation(line: 101, column: 2, scope: !135)
!186 = !DILocation(line: 102, column: 15, scope: !135)
!187 = !DILocation(line: 102, column: 2, scope: !135)
!188 = !DILocation(line: 103, column: 15, scope: !135)
!189 = !DILocation(line: 103, column: 2, scope: !135)
!190 = !DILocation(line: 105, column: 2, scope: !135)
!191 = !DILocation(line: 0, scope: !135)
!192 = !DILocation(line: 107, column: 2, scope: !135)
