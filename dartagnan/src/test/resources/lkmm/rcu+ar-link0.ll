; ModuleID = 'benchmarks/lkmm/rcu+ar-link0.c'
source_filename = "benchmarks/lkmm/rcu+ar-link0.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !46
@r_y = dso_local global i32 0, align 4, !dbg !50
@s = dso_local global i32 0, align 4, !dbg !52
@r_s = dso_local global i32 0, align 4, !dbg !64
@w = dso_local global i32 0, align 4, !dbg !54
@z = dso_local global i32 0, align 4, !dbg !56
@a = dso_local global i32 0, align 4, !dbg !58
@r_a = dso_local global i32 0, align 4, !dbg !66
@b = dso_local global i32 0, align 4, !dbg !60
@r_b = dso_local global i32 0, align 4, !dbg !68
@c = dso_local global i32 0, align 4, !dbg !62
@r_c = dso_local global i32 0, align 4, !dbg !70
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@.str = private unnamed_addr constant [15 x i8] c"rcu+ar-link0.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [60 x i8] c"!(r_y == 1 && r_s == 1 && r_a == 1 && r_b == 1 && r_c == 1)\00", align 1, !dbg !41
@r_x = dso_local global i32 0, align 4, !dbg !48

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P0(ptr noundef %0) #0 !dbg !80 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !84, !DIExpression(), !85)
  call void @__LKMM_fence(i32 noundef 7), !dbg !86
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !87
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !88
  %4 = trunc i64 %3 to i32, !dbg !88
  store i32 %4, ptr @r_y, align 4, !dbg !89
  call void @__LKMM_fence(i32 noundef 8), !dbg !90
  ret ptr null, !dbg !91
}

declare void @__LKMM_fence(i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P1(ptr noundef %0) #0 !dbg !92 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !93, !DIExpression(), !94)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !95
  %4 = trunc i64 %3 to i32, !dbg !95
  %5 = icmp eq i32 %4, 1, !dbg !97
  br i1 %5, label %6, label %7, !dbg !98

6:                                                ; preds = %1
  call void @__LKMM_store(ptr noundef @s, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !99
  br label %7, !dbg !99

7:                                                ; preds = %6, %1
  ret ptr null, !dbg !100
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P2(ptr noundef %0) #0 !dbg !101 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !102, !DIExpression(), !103)
  %4 = call i64 @__LKMM_load(ptr noundef @s, i64 noundef 4, i32 noundef 1), !dbg !104
  %5 = trunc i64 %4 to i32, !dbg !104
  store i32 %5, ptr @r_s, align 4, !dbg !105
  call void @__LKMM_store(ptr noundef @w, i64 noundef 4, i64 noundef 1, i32 noundef 3), !dbg !106
    #dbg_declare(ptr %3, !107, !DIExpression(), !108)
  %6 = call i64 @__LKMM_load(ptr noundef @z, i64 noundef 4, i32 noundef 1), !dbg !109
  %7 = trunc i64 %6 to i32, !dbg !109
  store i32 %7, ptr %3, align 4, !dbg !108
  %8 = load i32, ptr %3, align 4, !dbg !110
  %9 = add nsw i32 %8, 1, !dbg !110
  %10 = sext i32 %9 to i64, !dbg !110
  call void @__LKMM_store(ptr noundef @a, i64 noundef 4, i64 noundef %10, i32 noundef 1), !dbg !110
  ret ptr null, !dbg !111
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P3(ptr noundef %0) #0 !dbg !112 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !113, !DIExpression(), !114)
  %3 = call i64 @__LKMM_load(ptr noundef @a, i64 noundef 4, i32 noundef 1), !dbg !115
  %4 = trunc i64 %3 to i32, !dbg !115
  store i32 %4, ptr @r_a, align 4, !dbg !116
  %5 = load i32, ptr @r_a, align 4, !dbg !117
  %6 = sext i32 %5 to i64, !dbg !117
  call void @__LKMM_store(ptr noundef @b, i64 noundef 4, i64 noundef %6, i32 noundef 1), !dbg !117
  ret ptr null, !dbg !118
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P4(ptr noundef %0) #0 !dbg !119 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !120, !DIExpression(), !121)
  %3 = call i64 @__LKMM_load(ptr noundef @b, i64 noundef 4, i32 noundef 1), !dbg !122
  %4 = trunc i64 %3 to i32, !dbg !122
  store i32 %4, ptr @r_b, align 4, !dbg !123
  call void @__LKMM_store(ptr noundef @c, i64 noundef 4, i64 noundef 1, i32 noundef 3), !dbg !124
  ret ptr null, !dbg !125
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P5(ptr noundef %0) #0 !dbg !126 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !127, !DIExpression(), !128)
  %3 = call i64 @__LKMM_load(ptr noundef @c, i64 noundef 4, i32 noundef 1), !dbg !129
  %4 = trunc i64 %3 to i32, !dbg !129
  store i32 %4, ptr @r_c, align 4, !dbg !130
  call void @__LKMM_fence(i32 noundef 9), !dbg !131
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !132
  ret ptr null, !dbg !133
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !134 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !137, !DIExpression(), !161)
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
!llvm.module.flags = !{!72, !73, !74, !75, !76, !77, !78}
!llvm.ident = !{!79}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 16, type: !26, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/rcu+ar-link0.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6b13efe8b5bb64ba02860a374c43853f")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "27b8121cb2c90fe5c99c4b3e89c9755e")
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
!23 = !{!24, !26, !27}
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !25)
!25 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!26 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!28 = !{!29, !36, !41, !0, !46, !48, !50, !52, !54, !56, !58, !60, !62, !64, !66, !68, !70}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 105, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 40, elements: !34)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!33 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!34 = !{!35}
!35 = !DISubrange(count: 5)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 105, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 120, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 15)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !3, line: 105, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 480, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 60)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 17, type: !26, isLocal: false, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "r_x", scope: !2, file: !3, line: 19, type: !26, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "r_y", scope: !2, file: !3, line: 20, type: !26, isLocal: false, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !3, line: 23, type: !26, isLocal: false, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "w", scope: !2, file: !3, line: 24, type: !26, isLocal: false, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !3, line: 25, type: !26, isLocal: false, isDefinition: true)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 27, type: !26, isLocal: false, isDefinition: true)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !3, line: 28, type: !26, isLocal: false, isDefinition: true)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 29, type: !26, isLocal: false, isDefinition: true)
!64 = !DIGlobalVariableExpression(var: !65, expr: !DIExpression())
!65 = distinct !DIGlobalVariable(name: "r_s", scope: !2, file: !3, line: 31, type: !26, isLocal: false, isDefinition: true)
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(name: "r_a", scope: !2, file: !3, line: 32, type: !26, isLocal: false, isDefinition: true)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(name: "r_b", scope: !2, file: !3, line: 33, type: !26, isLocal: false, isDefinition: true)
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(name: "r_c", scope: !2, file: !3, line: 34, type: !26, isLocal: false, isDefinition: true)
!72 = !{i32 7, !"Dwarf Version", i32 5}
!73 = !{i32 2, !"Debug Info Version", i32 3}
!74 = !{i32 1, !"wchar_size", i32 4}
!75 = !{i32 8, !"PIC Level", i32 2}
!76 = !{i32 7, !"PIE Level", i32 2}
!77 = !{i32 7, !"uwtable", i32 2}
!78 = !{i32 7, !"frame-pointer", i32 2}
!79 = !{!"Homebrew clang version 19.1.7"}
!80 = distinct !DISubprogram(name: "P0", scope: !3, file: !3, line: 36, type: !81, scopeLine: 37, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!81 = !DISubroutineType(types: !82)
!82 = !{!27, !27}
!83 = !{}
!84 = !DILocalVariable(name: "unused", arg: 1, scope: !80, file: !3, line: 36, type: !27)
!85 = !DILocation(line: 36, column: 16, scope: !80)
!86 = !DILocation(line: 38, column: 2, scope: !80)
!87 = !DILocation(line: 39, column: 2, scope: !80)
!88 = !DILocation(line: 40, column: 8, scope: !80)
!89 = !DILocation(line: 40, column: 6, scope: !80)
!90 = !DILocation(line: 41, column: 2, scope: !80)
!91 = !DILocation(line: 42, column: 2, scope: !80)
!92 = distinct !DISubprogram(name: "P1", scope: !3, file: !3, line: 45, type: !81, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!93 = !DILocalVariable(name: "unused", arg: 1, scope: !92, file: !3, line: 45, type: !27)
!94 = !DILocation(line: 45, column: 16, scope: !92)
!95 = !DILocation(line: 47, column: 6, scope: !96)
!96 = distinct !DILexicalBlock(scope: !92, file: !3, line: 47, column: 6)
!97 = !DILocation(line: 47, column: 19, scope: !96)
!98 = !DILocation(line: 47, column: 6, scope: !92)
!99 = !DILocation(line: 48, column: 3, scope: !96)
!100 = !DILocation(line: 49, column: 2, scope: !92)
!101 = distinct !DISubprogram(name: "P2", scope: !3, file: !3, line: 52, type: !81, scopeLine: 53, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!102 = !DILocalVariable(name: "unused", arg: 1, scope: !101, file: !3, line: 52, type: !27)
!103 = !DILocation(line: 52, column: 16, scope: !101)
!104 = !DILocation(line: 54, column: 8, scope: !101)
!105 = !DILocation(line: 54, column: 6, scope: !101)
!106 = !DILocation(line: 55, column: 2, scope: !101)
!107 = !DILocalVariable(name: "r", scope: !101, file: !3, line: 57, type: !26)
!108 = !DILocation(line: 57, column: 6, scope: !101)
!109 = !DILocation(line: 57, column: 10, scope: !101)
!110 = !DILocation(line: 58, column: 2, scope: !101)
!111 = !DILocation(line: 59, column: 2, scope: !101)
!112 = distinct !DISubprogram(name: "P3", scope: !3, file: !3, line: 62, type: !81, scopeLine: 63, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!113 = !DILocalVariable(name: "unused", arg: 1, scope: !112, file: !3, line: 62, type: !27)
!114 = !DILocation(line: 62, column: 16, scope: !112)
!115 = !DILocation(line: 64, column: 8, scope: !112)
!116 = !DILocation(line: 64, column: 6, scope: !112)
!117 = !DILocation(line: 65, column: 2, scope: !112)
!118 = !DILocation(line: 66, column: 2, scope: !112)
!119 = distinct !DISubprogram(name: "P4", scope: !3, file: !3, line: 69, type: !81, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!120 = !DILocalVariable(name: "unused", arg: 1, scope: !119, file: !3, line: 69, type: !27)
!121 = !DILocation(line: 69, column: 16, scope: !119)
!122 = !DILocation(line: 71, column: 8, scope: !119)
!123 = !DILocation(line: 71, column: 6, scope: !119)
!124 = !DILocation(line: 72, column: 2, scope: !119)
!125 = !DILocation(line: 73, column: 2, scope: !119)
!126 = distinct !DISubprogram(name: "P5", scope: !3, file: !3, line: 76, type: !81, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!127 = !DILocalVariable(name: "unused", arg: 1, scope: !126, file: !3, line: 76, type: !27)
!128 = !DILocation(line: 76, column: 16, scope: !126)
!129 = !DILocation(line: 78, column: 8, scope: !126)
!130 = !DILocation(line: 78, column: 6, scope: !126)
!131 = !DILocation(line: 79, column: 2, scope: !126)
!132 = !DILocation(line: 80, column: 2, scope: !126)
!133 = !DILocation(line: 81, column: 2, scope: !126)
!134 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 84, type: !135, scopeLine: 85, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!135 = !DISubroutineType(types: !136)
!136 = !{!26}
!137 = !DILocalVariable(name: "t0", scope: !134, file: !3, line: 89, type: !138)
!138 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !139, line: 31, baseType: !140)
!139 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!140 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !141, line: 118, baseType: !142)
!141 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!142 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !143, size: 64)
!143 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !141, line: 103, size: 65536, elements: !144)
!144 = !{!145, !147, !157}
!145 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !143, file: !141, line: 104, baseType: !146, size: 64)
!146 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !143, file: !141, line: 105, baseType: !148, size: 64, offset: 64)
!148 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !149, size: 64)
!149 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !141, line: 57, size: 192, elements: !150)
!150 = !{!151, !155, !156}
!151 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !149, file: !141, line: 58, baseType: !152, size: 64)
!152 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !153, size: 64)
!153 = !DISubroutineType(types: !154)
!154 = !{null, !27}
!155 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !149, file: !141, line: 59, baseType: !27, size: 64, offset: 64)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !149, file: !141, line: 60, baseType: !148, size: 64, offset: 128)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !143, file: !141, line: 106, baseType: !158, size: 65408, offset: 128)
!158 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !159)
!159 = !{!160}
!160 = !DISubrange(count: 8176)
!161 = !DILocation(line: 89, column: 12, scope: !134)
!162 = !DILocalVariable(name: "t1", scope: !134, file: !3, line: 89, type: !138)
!163 = !DILocation(line: 89, column: 16, scope: !134)
!164 = !DILocalVariable(name: "t2", scope: !134, file: !3, line: 89, type: !138)
!165 = !DILocation(line: 89, column: 20, scope: !134)
!166 = !DILocalVariable(name: "t3", scope: !134, file: !3, line: 89, type: !138)
!167 = !DILocation(line: 89, column: 24, scope: !134)
!168 = !DILocalVariable(name: "t4", scope: !134, file: !3, line: 89, type: !138)
!169 = !DILocation(line: 89, column: 28, scope: !134)
!170 = !DILocalVariable(name: "t5", scope: !134, file: !3, line: 89, type: !138)
!171 = !DILocation(line: 89, column: 32, scope: !134)
!172 = !DILocation(line: 91, column: 2, scope: !134)
!173 = !DILocation(line: 92, column: 2, scope: !134)
!174 = !DILocation(line: 93, column: 2, scope: !134)
!175 = !DILocation(line: 94, column: 2, scope: !134)
!176 = !DILocation(line: 95, column: 2, scope: !134)
!177 = !DILocation(line: 96, column: 2, scope: !134)
!178 = !DILocation(line: 98, column: 15, scope: !134)
!179 = !DILocation(line: 98, column: 2, scope: !134)
!180 = !DILocation(line: 99, column: 15, scope: !134)
!181 = !DILocation(line: 99, column: 2, scope: !134)
!182 = !DILocation(line: 100, column: 15, scope: !134)
!183 = !DILocation(line: 100, column: 2, scope: !134)
!184 = !DILocation(line: 101, column: 15, scope: !134)
!185 = !DILocation(line: 101, column: 2, scope: !134)
!186 = !DILocation(line: 102, column: 15, scope: !134)
!187 = !DILocation(line: 102, column: 2, scope: !134)
!188 = !DILocation(line: 103, column: 15, scope: !134)
!189 = !DILocation(line: 103, column: 2, scope: !134)
!190 = !DILocation(line: 105, column: 2, scope: !134)
!191 = !DILocation(line: 0, scope: !134)
!192 = !DILocation(line: 107, column: 2, scope: !134)
