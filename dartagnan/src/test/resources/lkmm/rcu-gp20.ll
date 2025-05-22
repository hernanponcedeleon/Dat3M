; ModuleID = 'benchmarks/lkmm/rcu-gp20.c'
source_filename = "benchmarks/lkmm/rcu-gp20.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0
@r_x = dso_local global i32 0, align 4, !dbg !49
@y = dso_local global i32 0, align 4, !dbg !47
@r_y = dso_local global i32 0, align 4, !dbg !51
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !30
@.str = private unnamed_addr constant [11 x i8] c"rcu-gp20.c\00", align 1, !dbg !37
@.str.1 = private unnamed_addr constant [24 x i8] c"!(r_x == 0 && r_y == 1)\00", align 1, !dbg !42

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P0(ptr noundef %0) #0 !dbg !61 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !65, !DIExpression(), !66)
  call void @__LKMM_fence(i32 noundef 6), !dbg !67
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !68
  %4 = trunc i64 %3 to i32, !dbg !68
  store i32 %4, ptr @r_x, align 4, !dbg !69
  %5 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 0), !dbg !70
  %6 = trunc i64 %5 to i32, !dbg !70
  store i32 %6, ptr @r_y, align 4, !dbg !71
  call void @__LKMM_fence(i32 noundef 7), !dbg !72
  ret ptr null, !dbg !73
}

declare void @__LKMM_fence(i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P1(ptr noundef %0) #0 !dbg !74 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !75, !DIExpression(), !76)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !77
  call void @__LKMM_fence(i32 noundef 8), !dbg !78
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !79
  ret ptr null, !dbg !80
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !81 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !84, !DIExpression(), !107)
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
!llvm.module.flags = !{!53, !54, !55, !56, !57, !58, !59}
!llvm.ident = !{!60}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 7, type: !23, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !22, globals: !29, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/rcu-gp20.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "b0caa70c4bd139823f22290f84c5437c")
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
!22 = !{!23, !24, !25}
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 27, baseType: !26)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !27, line: 32, baseType: !28)
!27 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!28 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!29 = !{!30, !37, !42, !0, !47, !49, !51}
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 43, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 40, elements: !35)
!33 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!34 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!35 = !{!36}
!36 = !DISubrange(count: 5)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 43, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 88, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 11)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 43, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 192, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 24)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 8, type: !23, isLocal: false, isDefinition: true)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(name: "r_x", scope: !2, file: !3, line: 10, type: !23, isLocal: false, isDefinition: true)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(name: "r_y", scope: !2, file: !3, line: 11, type: !23, isLocal: false, isDefinition: true)
!53 = !{i32 7, !"Dwarf Version", i32 5}
!54 = !{i32 2, !"Debug Info Version", i32 3}
!55 = !{i32 1, !"wchar_size", i32 4}
!56 = !{i32 8, !"PIC Level", i32 2}
!57 = !{i32 7, !"PIE Level", i32 2}
!58 = !{i32 7, !"uwtable", i32 2}
!59 = !{i32 7, !"frame-pointer", i32 2}
!60 = !{!"Homebrew clang version 19.1.7"}
!61 = distinct !DISubprogram(name: "P0", scope: !3, file: !3, line: 13, type: !62, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!62 = !DISubroutineType(types: !63)
!63 = !{!24, !24}
!64 = !{}
!65 = !DILocalVariable(name: "unused", arg: 1, scope: !61, file: !3, line: 13, type: !24)
!66 = !DILocation(line: 13, column: 16, scope: !61)
!67 = !DILocation(line: 15, column: 2, scope: !61)
!68 = !DILocation(line: 16, column: 8, scope: !61)
!69 = !DILocation(line: 16, column: 6, scope: !61)
!70 = !DILocation(line: 17, column: 8, scope: !61)
!71 = !DILocation(line: 17, column: 6, scope: !61)
!72 = !DILocation(line: 18, column: 2, scope: !61)
!73 = !DILocation(line: 19, column: 2, scope: !61)
!74 = distinct !DISubprogram(name: "P1", scope: !3, file: !3, line: 22, type: !62, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!75 = !DILocalVariable(name: "unused", arg: 1, scope: !74, file: !3, line: 22, type: !24)
!76 = !DILocation(line: 22, column: 16, scope: !74)
!77 = !DILocation(line: 24, column: 2, scope: !74)
!78 = !DILocation(line: 25, column: 2, scope: !74)
!79 = !DILocation(line: 26, column: 2, scope: !74)
!80 = !DILocation(line: 27, column: 2, scope: !74)
!81 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 30, type: !82, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!82 = !DISubroutineType(types: !83)
!83 = !{!23}
!84 = !DILocalVariable(name: "t1", scope: !81, file: !3, line: 35, type: !85)
!85 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !86, line: 31, baseType: !87)
!86 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !88, line: 118, baseType: !89)
!88 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!89 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !90, size: 64)
!90 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !88, line: 103, size: 65536, elements: !91)
!91 = !{!92, !93, !103}
!92 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !90, file: !88, line: 104, baseType: !28, size: 64)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !90, file: !88, line: 105, baseType: !94, size: 64, offset: 64)
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !95, size: 64)
!95 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !88, line: 57, size: 192, elements: !96)
!96 = !{!97, !101, !102}
!97 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !95, file: !88, line: 58, baseType: !98, size: 64)
!98 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64)
!99 = !DISubroutineType(types: !100)
!100 = !{null, !24}
!101 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !95, file: !88, line: 59, baseType: !24, size: 64, offset: 64)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !95, file: !88, line: 60, baseType: !94, size: 64, offset: 128)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !90, file: !88, line: 106, baseType: !104, size: 65408, offset: 128)
!104 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 65408, elements: !105)
!105 = !{!106}
!106 = !DISubrange(count: 8176)
!107 = !DILocation(line: 35, column: 12, scope: !81)
!108 = !DILocalVariable(name: "t2", scope: !81, file: !3, line: 35, type: !85)
!109 = !DILocation(line: 35, column: 16, scope: !81)
!110 = !DILocation(line: 37, column: 2, scope: !81)
!111 = !DILocation(line: 38, column: 2, scope: !81)
!112 = !DILocation(line: 40, column: 15, scope: !81)
!113 = !DILocation(line: 40, column: 2, scope: !81)
!114 = !DILocation(line: 41, column: 15, scope: !81)
!115 = !DILocation(line: 41, column: 2, scope: !81)
!116 = !DILocation(line: 43, column: 2, scope: !81)
!117 = !DILocation(line: 0, scope: !81)
!118 = !DILocation(line: 45, column: 2, scope: !81)
