; ModuleID = 'benchmarks/lkmm/rcu+ar-link0.c'
source_filename = "benchmarks/lkmm/rcu+ar-link0.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !48
@r_y = dso_local global i32 0, align 4, !dbg !52
@s = dso_local global i32 0, align 4, !dbg !54
@r_s = dso_local global i32 0, align 4, !dbg !66
@w = dso_local global i32 0, align 4, !dbg !56
@z = dso_local global i32 0, align 4, !dbg !58
@a = dso_local global i32 0, align 4, !dbg !60
@r_a = dso_local global i32 0, align 4, !dbg !68
@b = dso_local global i32 0, align 4, !dbg !62
@r_b = dso_local global i32 0, align 4, !dbg !70
@c = dso_local global i32 0, align 4, !dbg !64
@r_c = dso_local global i32 0, align 4, !dbg !72
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !31
@.str = private unnamed_addr constant [15 x i8] c"rcu+ar-link0.c\00", align 1, !dbg !38
@.str.1 = private unnamed_addr constant [60 x i8] c"!(r_y == 1 && r_s == 1 && r_a == 1 && r_b == 1 && r_c == 1)\00", align 1, !dbg !43
@r_x = dso_local global i32 0, align 4, !dbg !50

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P0(ptr noundef %0) #0 !dbg !82 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !86, !DIExpression(), !87)
  call void @__LKMM_fence(i32 noundef 7), !dbg !88
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !89
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !90
  %4 = trunc i64 %3 to i32, !dbg !90
  store i32 %4, ptr @r_y, align 4, !dbg !91
  call void @__LKMM_fence(i32 noundef 8), !dbg !92
  ret ptr null, !dbg !93
}

declare void @__LKMM_fence(i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P1(ptr noundef %0) #0 !dbg !94 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !95, !DIExpression(), !96)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !97
  %4 = trunc i64 %3 to i32, !dbg !97
  %5 = icmp eq i32 %4, 1, !dbg !99
  br i1 %5, label %6, label %7, !dbg !100

6:                                                ; preds = %1
  call void @__LKMM_store(ptr noundef @s, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !101
  br label %7, !dbg !101

7:                                                ; preds = %6, %1
  ret ptr null, !dbg !102
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P2(ptr noundef %0) #0 !dbg !103 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !104, !DIExpression(), !105)
  %4 = call i64 @__LKMM_load(ptr noundef @s, i64 noundef 4, i32 noundef 1), !dbg !106
  %5 = trunc i64 %4 to i32, !dbg !106
  store i32 %5, ptr @r_s, align 4, !dbg !107
  call void @__LKMM_store(ptr noundef @w, i64 noundef 4, i64 noundef 1, i32 noundef 3), !dbg !108
    #dbg_declare(ptr %3, !109, !DIExpression(), !110)
  %6 = call i64 @__LKMM_load(ptr noundef @z, i64 noundef 4, i32 noundef 1), !dbg !111
  %7 = trunc i64 %6 to i32, !dbg !111
  store i32 %7, ptr %3, align 4, !dbg !110
  %8 = load i32, ptr %3, align 4, !dbg !112
  %9 = add nsw i32 %8, 1, !dbg !112
  %10 = sext i32 %9 to i64, !dbg !112
  call void @__LKMM_store(ptr noundef @a, i64 noundef 4, i64 noundef %10, i32 noundef 1), !dbg !112
  ret ptr null, !dbg !113
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P3(ptr noundef %0) #0 !dbg !114 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !115, !DIExpression(), !116)
  %3 = call i64 @__LKMM_load(ptr noundef @a, i64 noundef 4, i32 noundef 1), !dbg !117
  %4 = trunc i64 %3 to i32, !dbg !117
  store i32 %4, ptr @r_a, align 4, !dbg !118
  %5 = load i32, ptr @r_a, align 4, !dbg !119
  %6 = sext i32 %5 to i64, !dbg !119
  call void @__LKMM_store(ptr noundef @b, i64 noundef 4, i64 noundef %6, i32 noundef 1), !dbg !119
  ret ptr null, !dbg !120
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P4(ptr noundef %0) #0 !dbg !121 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !122, !DIExpression(), !123)
  %3 = call i64 @__LKMM_load(ptr noundef @b, i64 noundef 4, i32 noundef 1), !dbg !124
  %4 = trunc i64 %3 to i32, !dbg !124
  store i32 %4, ptr @r_b, align 4, !dbg !125
  call void @__LKMM_store(ptr noundef @c, i64 noundef 4, i64 noundef 1, i32 noundef 3), !dbg !126
  ret ptr null, !dbg !127
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P5(ptr noundef %0) #0 !dbg !128 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !129, !DIExpression(), !130)
  %3 = call i64 @__LKMM_load(ptr noundef @c, i64 noundef 4, i32 noundef 1), !dbg !131
  %4 = trunc i64 %3 to i32, !dbg !131
  store i32 %4, ptr @r_c, align 4, !dbg !132
  call void @__LKMM_fence(i32 noundef 9), !dbg !133
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !134
  ret ptr null, !dbg !135
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !136 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !139, !DIExpression(), !162)
    #dbg_declare(ptr %3, !163, !DIExpression(), !164)
    #dbg_declare(ptr %4, !165, !DIExpression(), !166)
    #dbg_declare(ptr %5, !167, !DIExpression(), !168)
    #dbg_declare(ptr %6, !169, !DIExpression(), !170)
    #dbg_declare(ptr %7, !171, !DIExpression(), !172)
  %8 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @P0, ptr noundef null), !dbg !173
  %9 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @P1, ptr noundef null), !dbg !174
  %10 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @P2, ptr noundef null), !dbg !175
  %11 = call i32 @pthread_create(ptr noundef %5, ptr noundef null, ptr noundef @P3, ptr noundef null), !dbg !176
  %12 = call i32 @pthread_create(ptr noundef %6, ptr noundef null, ptr noundef @P4, ptr noundef null), !dbg !177
  %13 = call i32 @pthread_create(ptr noundef %7, ptr noundef null, ptr noundef @P5, ptr noundef null), !dbg !178
  %14 = load ptr, ptr %2, align 8, !dbg !179
  %15 = call i32 @_pthread_join(ptr noundef %14, ptr noundef null), !dbg !180
  %16 = load ptr, ptr %3, align 8, !dbg !181
  %17 = call i32 @_pthread_join(ptr noundef %16, ptr noundef null), !dbg !182
  %18 = load ptr, ptr %4, align 8, !dbg !183
  %19 = call i32 @_pthread_join(ptr noundef %18, ptr noundef null), !dbg !184
  %20 = load ptr, ptr %5, align 8, !dbg !185
  %21 = call i32 @_pthread_join(ptr noundef %20, ptr noundef null), !dbg !186
  %22 = load ptr, ptr %6, align 8, !dbg !187
  %23 = call i32 @_pthread_join(ptr noundef %22, ptr noundef null), !dbg !188
  %24 = load ptr, ptr %7, align 8, !dbg !189
  %25 = call i32 @_pthread_join(ptr noundef %24, ptr noundef null), !dbg !190
  %26 = load i32, ptr @r_y, align 4, !dbg !191
  %27 = icmp eq i32 %26, 1, !dbg !191
  br i1 %27, label %28, label %40, !dbg !191

28:                                               ; preds = %0
  %29 = load i32, ptr @r_s, align 4, !dbg !191
  %30 = icmp eq i32 %29, 1, !dbg !191
  br i1 %30, label %31, label %40, !dbg !191

31:                                               ; preds = %28
  %32 = load i32, ptr @r_a, align 4, !dbg !191
  %33 = icmp eq i32 %32, 1, !dbg !191
  br i1 %33, label %34, label %40, !dbg !191

34:                                               ; preds = %31
  %35 = load i32, ptr @r_b, align 4, !dbg !191
  %36 = icmp eq i32 %35, 1, !dbg !191
  br i1 %36, label %37, label %40, !dbg !191

37:                                               ; preds = %34
  %38 = load i32, ptr @r_c, align 4, !dbg !191
  %39 = icmp eq i32 %38, 1, !dbg !191
  br label %40

40:                                               ; preds = %37, %34, %31, %28, %0
  %41 = phi i1 [ false, %34 ], [ false, %31 ], [ false, %28 ], [ false, %0 ], [ %39, %37 ], !dbg !192
  %42 = xor i1 %41, true, !dbg !191
  %43 = xor i1 %42, true, !dbg !191
  %44 = zext i1 %43 to i32, !dbg !191
  %45 = sext i32 %44 to i64, !dbg !191
  %46 = icmp ne i64 %45, 0, !dbg !191
  br i1 %46, label %47, label %49, !dbg !191

47:                                               ; preds = %40
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 105, ptr noundef @.str.1) #3, !dbg !191
  unreachable, !dbg !191

48:                                               ; No predecessors!
  br label %50, !dbg !191

49:                                               ; preds = %40
  br label %50, !dbg !191

50:                                               ; preds = %49, %48
  ret i32 0, !dbg !193
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
!llvm.module.flags = !{!74, !75, !76, !77, !78, !79, !80}
!llvm.ident = !{!81}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 16, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !30, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/rcu+ar-link0.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6b13efe8b5bb64ba02860a374c43853f")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "09faa2df2f4b7a5b710a8844ff483434")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22}
!9 = !DIEnumerator(name: "__LKMM_relaxed", value: 0)
!10 = !DIEnumerator(name: "__LKMM_once", value: 1)
!11 = !DIEnumerator(name: "__LKMM_acquire", value: 2)
!12 = !DIEnumerator(name: "__LKMM_release", value: 3)
!13 = !DIEnumerator(name: "__LKMM_mb", value: 4)
!14 = !DIEnumerator(name: "__LKMM_wmb", value: 5)
!15 = !DIEnumerator(name: "__LKMM_rmb", value: 6)
!16 = !DIEnumerator(name: "__LKMM_rcu_lock", value: 7)
!17 = !DIEnumerator(name: "__LKMM_rcu_unlock", value: 8)
!18 = !DIEnumerator(name: "__LKMM_rcu_sync", value: 9)
!19 = !DIEnumerator(name: "__LKMM_before_atomic", value: 10)
!20 = !DIEnumerator(name: "__LKMM_after_atomic", value: 11)
!21 = !DIEnumerator(name: "__LKMM_after_spinlock", value: 12)
!22 = !DIEnumerator(name: "__LKMM_barrier", value: 13)
!23 = !{!24, !28, !29}
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !25)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !26, line: 32, baseType: !27)
!26 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!27 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!30 = !{!31, !38, !43, !0, !48, !50, !52, !54, !56, !58, !60, !62, !64, !66, !68, !70, !72}
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 105, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 40, elements: !36)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !35)
!35 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!36 = !{!37}
!37 = !DISubrange(count: 5)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !3, line: 105, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 120, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 15)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !3, line: 105, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 480, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 60)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 17, type: !28, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "r_x", scope: !2, file: !3, line: 19, type: !28, isLocal: false, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "r_y", scope: !2, file: !3, line: 20, type: !28, isLocal: false, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !3, line: 23, type: !28, isLocal: false, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "w", scope: !2, file: !3, line: 24, type: !28, isLocal: false, isDefinition: true)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !3, line: 25, type: !28, isLocal: false, isDefinition: true)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 27, type: !28, isLocal: false, isDefinition: true)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !3, line: 28, type: !28, isLocal: false, isDefinition: true)
!64 = !DIGlobalVariableExpression(var: !65, expr: !DIExpression())
!65 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 29, type: !28, isLocal: false, isDefinition: true)
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(name: "r_s", scope: !2, file: !3, line: 31, type: !28, isLocal: false, isDefinition: true)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(name: "r_a", scope: !2, file: !3, line: 32, type: !28, isLocal: false, isDefinition: true)
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(name: "r_b", scope: !2, file: !3, line: 33, type: !28, isLocal: false, isDefinition: true)
!72 = !DIGlobalVariableExpression(var: !73, expr: !DIExpression())
!73 = distinct !DIGlobalVariable(name: "r_c", scope: !2, file: !3, line: 34, type: !28, isLocal: false, isDefinition: true)
!74 = !{i32 7, !"Dwarf Version", i32 5}
!75 = !{i32 2, !"Debug Info Version", i32 3}
!76 = !{i32 1, !"wchar_size", i32 4}
!77 = !{i32 8, !"PIC Level", i32 2}
!78 = !{i32 7, !"PIE Level", i32 2}
!79 = !{i32 7, !"uwtable", i32 2}
!80 = !{i32 7, !"frame-pointer", i32 2}
!81 = !{!"Homebrew clang version 19.1.7"}
!82 = distinct !DISubprogram(name: "P0", scope: !3, file: !3, line: 36, type: !83, scopeLine: 37, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !85)
!83 = !DISubroutineType(types: !84)
!84 = !{!29, !29}
!85 = !{}
!86 = !DILocalVariable(name: "unused", arg: 1, scope: !82, file: !3, line: 36, type: !29)
!87 = !DILocation(line: 36, column: 16, scope: !82)
!88 = !DILocation(line: 38, column: 2, scope: !82)
!89 = !DILocation(line: 39, column: 2, scope: !82)
!90 = !DILocation(line: 40, column: 8, scope: !82)
!91 = !DILocation(line: 40, column: 6, scope: !82)
!92 = !DILocation(line: 41, column: 2, scope: !82)
!93 = !DILocation(line: 42, column: 2, scope: !82)
!94 = distinct !DISubprogram(name: "P1", scope: !3, file: !3, line: 45, type: !83, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !85)
!95 = !DILocalVariable(name: "unused", arg: 1, scope: !94, file: !3, line: 45, type: !29)
!96 = !DILocation(line: 45, column: 16, scope: !94)
!97 = !DILocation(line: 47, column: 6, scope: !98)
!98 = distinct !DILexicalBlock(scope: !94, file: !3, line: 47, column: 6)
!99 = !DILocation(line: 47, column: 19, scope: !98)
!100 = !DILocation(line: 47, column: 6, scope: !94)
!101 = !DILocation(line: 48, column: 3, scope: !98)
!102 = !DILocation(line: 49, column: 2, scope: !94)
!103 = distinct !DISubprogram(name: "P2", scope: !3, file: !3, line: 52, type: !83, scopeLine: 53, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !85)
!104 = !DILocalVariable(name: "unused", arg: 1, scope: !103, file: !3, line: 52, type: !29)
!105 = !DILocation(line: 52, column: 16, scope: !103)
!106 = !DILocation(line: 54, column: 8, scope: !103)
!107 = !DILocation(line: 54, column: 6, scope: !103)
!108 = !DILocation(line: 55, column: 2, scope: !103)
!109 = !DILocalVariable(name: "r", scope: !103, file: !3, line: 57, type: !28)
!110 = !DILocation(line: 57, column: 6, scope: !103)
!111 = !DILocation(line: 57, column: 10, scope: !103)
!112 = !DILocation(line: 58, column: 2, scope: !103)
!113 = !DILocation(line: 59, column: 2, scope: !103)
!114 = distinct !DISubprogram(name: "P3", scope: !3, file: !3, line: 62, type: !83, scopeLine: 63, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !85)
!115 = !DILocalVariable(name: "unused", arg: 1, scope: !114, file: !3, line: 62, type: !29)
!116 = !DILocation(line: 62, column: 16, scope: !114)
!117 = !DILocation(line: 64, column: 8, scope: !114)
!118 = !DILocation(line: 64, column: 6, scope: !114)
!119 = !DILocation(line: 65, column: 2, scope: !114)
!120 = !DILocation(line: 66, column: 2, scope: !114)
!121 = distinct !DISubprogram(name: "P4", scope: !3, file: !3, line: 69, type: !83, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !85)
!122 = !DILocalVariable(name: "unused", arg: 1, scope: !121, file: !3, line: 69, type: !29)
!123 = !DILocation(line: 69, column: 16, scope: !121)
!124 = !DILocation(line: 71, column: 8, scope: !121)
!125 = !DILocation(line: 71, column: 6, scope: !121)
!126 = !DILocation(line: 72, column: 2, scope: !121)
!127 = !DILocation(line: 73, column: 2, scope: !121)
!128 = distinct !DISubprogram(name: "P5", scope: !3, file: !3, line: 76, type: !83, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !85)
!129 = !DILocalVariable(name: "unused", arg: 1, scope: !128, file: !3, line: 76, type: !29)
!130 = !DILocation(line: 76, column: 16, scope: !128)
!131 = !DILocation(line: 78, column: 8, scope: !128)
!132 = !DILocation(line: 78, column: 6, scope: !128)
!133 = !DILocation(line: 79, column: 2, scope: !128)
!134 = !DILocation(line: 80, column: 2, scope: !128)
!135 = !DILocation(line: 81, column: 2, scope: !128)
!136 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 84, type: !137, scopeLine: 85, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !85)
!137 = !DISubroutineType(types: !138)
!138 = !{!28}
!139 = !DILocalVariable(name: "t0", scope: !136, file: !3, line: 89, type: !140)
!140 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !141, line: 31, baseType: !142)
!141 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!142 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !143, line: 118, baseType: !144)
!143 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!144 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !145, size: 64)
!145 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !143, line: 103, size: 65536, elements: !146)
!146 = !{!147, !148, !158}
!147 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !145, file: !143, line: 104, baseType: !27, size: 64)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !145, file: !143, line: 105, baseType: !149, size: 64, offset: 64)
!149 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !150, size: 64)
!150 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !143, line: 57, size: 192, elements: !151)
!151 = !{!152, !156, !157}
!152 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !150, file: !143, line: 58, baseType: !153, size: 64)
!153 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !154, size: 64)
!154 = !DISubroutineType(types: !155)
!155 = !{null, !29}
!156 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !150, file: !143, line: 59, baseType: !29, size: 64, offset: 64)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !150, file: !143, line: 60, baseType: !149, size: 64, offset: 128)
!158 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !145, file: !143, line: 106, baseType: !159, size: 65408, offset: 128)
!159 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 65408, elements: !160)
!160 = !{!161}
!161 = !DISubrange(count: 8176)
!162 = !DILocation(line: 89, column: 12, scope: !136)
!163 = !DILocalVariable(name: "t1", scope: !136, file: !3, line: 89, type: !140)
!164 = !DILocation(line: 89, column: 16, scope: !136)
!165 = !DILocalVariable(name: "t2", scope: !136, file: !3, line: 89, type: !140)
!166 = !DILocation(line: 89, column: 20, scope: !136)
!167 = !DILocalVariable(name: "t3", scope: !136, file: !3, line: 89, type: !140)
!168 = !DILocation(line: 89, column: 24, scope: !136)
!169 = !DILocalVariable(name: "t4", scope: !136, file: !3, line: 89, type: !140)
!170 = !DILocation(line: 89, column: 28, scope: !136)
!171 = !DILocalVariable(name: "t5", scope: !136, file: !3, line: 89, type: !140)
!172 = !DILocation(line: 89, column: 32, scope: !136)
!173 = !DILocation(line: 91, column: 2, scope: !136)
!174 = !DILocation(line: 92, column: 2, scope: !136)
!175 = !DILocation(line: 93, column: 2, scope: !136)
!176 = !DILocation(line: 94, column: 2, scope: !136)
!177 = !DILocation(line: 95, column: 2, scope: !136)
!178 = !DILocation(line: 96, column: 2, scope: !136)
!179 = !DILocation(line: 98, column: 15, scope: !136)
!180 = !DILocation(line: 98, column: 2, scope: !136)
!181 = !DILocation(line: 99, column: 15, scope: !136)
!182 = !DILocation(line: 99, column: 2, scope: !136)
!183 = !DILocation(line: 100, column: 15, scope: !136)
!184 = !DILocation(line: 100, column: 2, scope: !136)
!185 = !DILocation(line: 101, column: 15, scope: !136)
!186 = !DILocation(line: 101, column: 2, scope: !136)
!187 = !DILocation(line: 102, column: 15, scope: !136)
!188 = !DILocation(line: 102, column: 2, scope: !136)
!189 = !DILocation(line: 103, column: 15, scope: !136)
!190 = !DILocation(line: 103, column: 2, scope: !136)
!191 = !DILocation(line: 105, column: 2, scope: !136)
!192 = !DILocation(line: 0, scope: !136)
!193 = !DILocation(line: 107, column: 2, scope: !136)
