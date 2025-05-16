; ModuleID = 'benchmarks/lkmm/rcu-gp20.c'
source_filename = "benchmarks/lkmm/rcu-gp20.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0
@r_x = dso_local global i32 0, align 4, !dbg !48
@y = dso_local global i32 0, align 4, !dbg !46
@r_y = dso_local global i32 0, align 4, !dbg !50
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@.str = private unnamed_addr constant [11 x i8] c"rcu-gp20.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [24 x i8] c"!(r_x == 0 && r_y == 1)\00", align 1, !dbg !41

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P0(ptr noundef %0) #0 !dbg !60 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !64, !DIExpression(), !65)
  call void @__LKMM_fence(i32 noundef 7), !dbg !66
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !67
  %4 = trunc i64 %3 to i32, !dbg !67
  store i32 %4, ptr @r_x, align 4, !dbg !68
  %5 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !69
  %6 = trunc i64 %5 to i32, !dbg !69
  store i32 %6, ptr @r_y, align 4, !dbg !70
  call void @__LKMM_fence(i32 noundef 8), !dbg !71
  ret ptr null, !dbg !72
}

declare void @__LKMM_fence(i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P1(ptr noundef %0) #0 !dbg !73 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !74, !DIExpression(), !75)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !76
  call void @__LKMM_fence(i32 noundef 9), !dbg !77
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !78
  ret ptr null, !dbg !79
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !80 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !83, !DIExpression(), !107)
    #dbg_declare(ptr %3, !108, !DIExpression(), !109)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @P0, ptr noundef null), !dbg !110
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @P1, ptr noundef null), !dbg !111
  %6 = load ptr, ptr %2, align 8, !dbg !112
  %7 = call i32 @_pthread_join(ptr noundef %6, ptr noundef null), !dbg !113
  %8 = load ptr, ptr %3, align 8, !dbg !114
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !115
  %10 = load i32, ptr @r_x, align 4, !dbg !116
  %11 = icmp eq i32 %10, 0, !dbg !116
  br i1 %11, label %12, label %15, !dbg !116

12:                                               ; preds = %0
  %13 = load i32, ptr @r_y, align 4, !dbg !116
  %14 = icmp eq i32 %13, 1, !dbg !116
  br label %15

15:                                               ; preds = %12, %0
  %16 = phi i1 [ false, %0 ], [ %14, %12 ], !dbg !117
  %17 = xor i1 %16, true, !dbg !116
  %18 = xor i1 %17, true, !dbg !116
  %19 = zext i1 %18 to i32, !dbg !116
  %20 = sext i32 %19 to i64, !dbg !116
  %21 = icmp ne i64 %20, 0, !dbg !116
  br i1 %21, label %22, label %24, !dbg !116

22:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 43, ptr noundef @.str.1) #3, !dbg !116
  unreachable, !dbg !116

23:                                               ; No predecessors!
  br label %25, !dbg !116

24:                                               ; preds = %15
  br label %25, !dbg !116

25:                                               ; preds = %24, %23
  ret i32 0, !dbg !118
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
!llvm.module.flags = !{!52, !53, !54, !55, !56, !57, !58}
!llvm.ident = !{!59}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 7, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/rcu-gp20.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "b0caa70c4bd139823f22290f84c5437c")
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
!23 = !{!24, !25, !26}
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !27)
!27 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!28 = !{!29, !36, !41, !0, !46, !48, !50}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 43, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 40, elements: !34)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!33 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!34 = !{!35}
!35 = !DISubrange(count: 5)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 43, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 88, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 11)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !3, line: 43, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 192, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 24)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "r_x", scope: !2, file: !3, line: 10, type: !24, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "r_y", scope: !2, file: !3, line: 11, type: !24, isLocal: false, isDefinition: true)
!52 = !{i32 7, !"Dwarf Version", i32 5}
!53 = !{i32 2, !"Debug Info Version", i32 3}
!54 = !{i32 1, !"wchar_size", i32 4}
!55 = !{i32 8, !"PIC Level", i32 2}
!56 = !{i32 7, !"PIE Level", i32 2}
!57 = !{i32 7, !"uwtable", i32 2}
!58 = !{i32 7, !"frame-pointer", i32 2}
!59 = !{!"Homebrew clang version 19.1.7"}
!60 = distinct !DISubprogram(name: "P0", scope: !3, file: !3, line: 13, type: !61, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!61 = !DISubroutineType(types: !62)
!62 = !{!25, !25}
!63 = !{}
!64 = !DILocalVariable(name: "unused", arg: 1, scope: !60, file: !3, line: 13, type: !25)
!65 = !DILocation(line: 13, column: 16, scope: !60)
!66 = !DILocation(line: 15, column: 2, scope: !60)
!67 = !DILocation(line: 16, column: 8, scope: !60)
!68 = !DILocation(line: 16, column: 6, scope: !60)
!69 = !DILocation(line: 17, column: 8, scope: !60)
!70 = !DILocation(line: 17, column: 6, scope: !60)
!71 = !DILocation(line: 18, column: 2, scope: !60)
!72 = !DILocation(line: 19, column: 2, scope: !60)
!73 = distinct !DISubprogram(name: "P1", scope: !3, file: !3, line: 22, type: !61, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!74 = !DILocalVariable(name: "unused", arg: 1, scope: !73, file: !3, line: 22, type: !25)
!75 = !DILocation(line: 22, column: 16, scope: !73)
!76 = !DILocation(line: 24, column: 2, scope: !73)
!77 = !DILocation(line: 25, column: 2, scope: !73)
!78 = !DILocation(line: 26, column: 2, scope: !73)
!79 = !DILocation(line: 27, column: 2, scope: !73)
!80 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 30, type: !81, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!81 = !DISubroutineType(types: !82)
!82 = !{!24}
!83 = !DILocalVariable(name: "t1", scope: !80, file: !3, line: 35, type: !84)
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !85, line: 31, baseType: !86)
!85 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !87, line: 118, baseType: !88)
!87 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!88 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !89, size: 64)
!89 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !87, line: 103, size: 65536, elements: !90)
!90 = !{!91, !93, !103}
!91 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !89, file: !87, line: 104, baseType: !92, size: 64)
!92 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !89, file: !87, line: 105, baseType: !94, size: 64, offset: 64)
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !95, size: 64)
!95 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !87, line: 57, size: 192, elements: !96)
!96 = !{!97, !101, !102}
!97 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !95, file: !87, line: 58, baseType: !98, size: 64)
!98 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64)
!99 = !DISubroutineType(types: !100)
!100 = !{null, !25}
!101 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !95, file: !87, line: 59, baseType: !25, size: 64, offset: 64)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !95, file: !87, line: 60, baseType: !94, size: 64, offset: 128)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !89, file: !87, line: 106, baseType: !104, size: 65408, offset: 128)
!104 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !105)
!105 = !{!106}
!106 = !DISubrange(count: 8176)
!107 = !DILocation(line: 35, column: 12, scope: !80)
!108 = !DILocalVariable(name: "t2", scope: !80, file: !3, line: 35, type: !84)
!109 = !DILocation(line: 35, column: 16, scope: !80)
!110 = !DILocation(line: 37, column: 2, scope: !80)
!111 = !DILocation(line: 38, column: 2, scope: !80)
!112 = !DILocation(line: 40, column: 15, scope: !80)
!113 = !DILocation(line: 40, column: 2, scope: !80)
!114 = !DILocation(line: 41, column: 15, scope: !80)
!115 = !DILocation(line: 41, column: 2, scope: !80)
!116 = !DILocation(line: 43, column: 2, scope: !80)
!117 = !DILocation(line: 0, scope: !80)
!118 = !DILocation(line: 45, column: 2, scope: !80)
