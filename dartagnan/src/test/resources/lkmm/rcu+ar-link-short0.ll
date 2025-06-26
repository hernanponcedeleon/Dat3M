; ModuleID = 'benchmarks/lkmm/rcu+ar-link-short0.c'
source_filename = "benchmarks/lkmm/rcu+ar-link-short0.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@w = dso_local global [2 x i32] [i32 0, i32 1], align 4, !dbg !0
@x = dso_local global i32 0, align 4, !dbg !47
@y = dso_local global i32 0, align 4, !dbg !49
@s = dso_local global i32 0, align 4, !dbg !55
@r_s = dso_local global i32 0, align 4, !dbg !57
@r_w = dso_local global i32 0, align 4, !dbg !59
@r_y = dso_local global i32 0, align 4, !dbg !53
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !30
@.str = private unnamed_addr constant [21 x i8] c"rcu+ar-link-short0.c\00", align 1, !dbg !37
@.str.1 = private unnamed_addr constant [36 x i8] c"!(r_y == 0 && r_s == 1 && r_w == 1)\00", align 1, !dbg !42
@r_x = dso_local global i32 0, align 4, !dbg !51

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P0(ptr noundef %0) #0 !dbg !72 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !76, !DIExpression(), !77)
  call void @__LKMM_fence(i32 noundef 6), !dbg !78
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !79
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !80
  call void @__LKMM_fence(i32 noundef 7), !dbg !81
  ret ptr null, !dbg !82
}

declare void @__LKMM_fence(i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P1(ptr noundef %0) #0 !dbg !83 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !84, !DIExpression(), !85)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !86
  %4 = trunc i64 %3 to i32, !dbg !86
  %5 = icmp eq i32 %4, 1, !dbg !88
  br i1 %5, label %6, label %7, !dbg !89

6:                                                ; preds = %1
  call void @__LKMM_store(ptr noundef @s, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !90
  br label %7, !dbg !90

7:                                                ; preds = %6, %1
  ret ptr null, !dbg !91
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P2(ptr noundef %0) #0 !dbg !92 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !93, !DIExpression(), !94)
  %3 = call i64 @__LKMM_load(ptr noundef @s, i64 noundef 4, i32 noundef 0), !dbg !95
  %4 = trunc i64 %3 to i32, !dbg !95
  store i32 %4, ptr @r_s, align 4, !dbg !96
  %5 = load i32, ptr @r_s, align 4, !dbg !97
  %6 = sext i32 %5 to i64, !dbg !97
  %7 = getelementptr inbounds [2 x i32], ptr @w, i64 0, i64 %6, !dbg !97
  %8 = call i64 @__LKMM_load(ptr noundef %7, i64 noundef 4, i32 noundef 0), !dbg !97
  %9 = trunc i64 %8 to i32, !dbg !97
  store i32 %9, ptr @r_w, align 4, !dbg !98
  ret ptr null, !dbg !99
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P3(ptr noundef %0) #0 !dbg !100 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !101, !DIExpression(), !102)
  call void @__LKMM_store(ptr noundef getelementptr inbounds ([2 x i32], ptr @w, i64 0, i64 1), i64 noundef 4, i64 noundef 2, i32 noundef 0), !dbg !103
  call void @__LKMM_fence(i32 noundef 8), !dbg !104
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 0), !dbg !105
  %4 = trunc i64 %3 to i32, !dbg !105
  store i32 %4, ptr @r_y, align 4, !dbg !106
  ret ptr null, !dbg !107
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !108 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !111, !DIExpression(), !134)
    #dbg_declare(ptr %3, !135, !DIExpression(), !136)
    #dbg_declare(ptr %4, !137, !DIExpression(), !138)
    #dbg_declare(ptr %5, !139, !DIExpression(), !140)
  %6 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @P0, ptr noundef null), !dbg !141
  %7 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @P1, ptr noundef null), !dbg !142
  %8 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @P2, ptr noundef null), !dbg !143
  %9 = call i32 @pthread_create(ptr noundef %5, ptr noundef null, ptr noundef @P3, ptr noundef null), !dbg !144
  %10 = load ptr, ptr %2, align 8, !dbg !145
  %11 = call i32 @_pthread_join(ptr noundef %10, ptr noundef null), !dbg !146
  %12 = load ptr, ptr %3, align 8, !dbg !147
  %13 = call i32 @_pthread_join(ptr noundef %12, ptr noundef null), !dbg !148
  %14 = load ptr, ptr %4, align 8, !dbg !149
  %15 = call i32 @_pthread_join(ptr noundef %14, ptr noundef null), !dbg !150
  %16 = load ptr, ptr %5, align 8, !dbg !151
  %17 = call i32 @_pthread_join(ptr noundef %16, ptr noundef null), !dbg !152
  %18 = load i32, ptr @r_y, align 4, !dbg !153
  %19 = icmp eq i32 %18, 0, !dbg !153
  br i1 %19, label %20, label %26, !dbg !153

20:                                               ; preds = %0
  %21 = load i32, ptr @r_s, align 4, !dbg !153
  %22 = icmp eq i32 %21, 1, !dbg !153
  br i1 %22, label %23, label %26, !dbg !153

23:                                               ; preds = %20
  %24 = load i32, ptr @r_w, align 4, !dbg !153
  %25 = icmp eq i32 %24, 1, !dbg !153
  br label %26

26:                                               ; preds = %23, %20, %0
  %27 = phi i1 [ false, %20 ], [ false, %0 ], [ %25, %23 ], !dbg !154
  %28 = xor i1 %27, true, !dbg !153
  %29 = xor i1 %28, true, !dbg !153
  %30 = zext i1 %29 to i32, !dbg !153
  %31 = sext i32 %30 to i64, !dbg !153
  %32 = icmp ne i64 %31, 0, !dbg !153
  br i1 %32, label %33, label %35, !dbg !153

33:                                               ; preds = %26
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 82, ptr noundef @.str.1) #3, !dbg !153
  unreachable, !dbg !153

34:                                               ; No predecessors!
  br label %36, !dbg !153

35:                                               ; preds = %26
  br label %36, !dbg !153

36:                                               ; preds = %35, %34
  ret i32 0, !dbg !155
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
!llvm.module.flags = !{!64, !65, !66, !67, !68, !69, !70}
!llvm.ident = !{!71}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "w", scope: !2, file: !3, line: 29, type: !61, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !22, globals: !29, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/rcu+ar-link-short0.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "75fba3f93246ceba8ebd1225e5ca1dff")
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
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !{!0, !30, !37, !42, !47, !49, !51, !53, !55, !57, !59}
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 82, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 40, elements: !35)
!33 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!34 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!35 = !{!36}
!36 = !DISubrange(count: 5)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 82, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 168, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 21)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 82, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 288, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 36)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 21, type: !28, isLocal: false, isDefinition: true)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 22, type: !28, isLocal: false, isDefinition: true)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(name: "r_x", scope: !2, file: !3, line: 24, type: !28, isLocal: false, isDefinition: true)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "r_y", scope: !2, file: !3, line: 25, type: !28, isLocal: false, isDefinition: true)
!55 = !DIGlobalVariableExpression(var: !56, expr: !DIExpression())
!56 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !3, line: 28, type: !28, isLocal: false, isDefinition: true)
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(name: "r_s", scope: !2, file: !3, line: 31, type: !28, isLocal: false, isDefinition: true)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "r_w", scope: !2, file: !3, line: 32, type: !28, isLocal: false, isDefinition: true)
!61 = !DICompositeType(tag: DW_TAG_array_type, baseType: !28, size: 64, elements: !62)
!62 = !{!63}
!63 = !DISubrange(count: 2)
!64 = !{i32 7, !"Dwarf Version", i32 5}
!65 = !{i32 2, !"Debug Info Version", i32 3}
!66 = !{i32 1, !"wchar_size", i32 4}
!67 = !{i32 8, !"PIC Level", i32 2}
!68 = !{i32 7, !"PIE Level", i32 2}
!69 = !{i32 7, !"uwtable", i32 2}
!70 = !{i32 7, !"frame-pointer", i32 2}
!71 = !{!"Homebrew clang version 19.1.7"}
!72 = distinct !DISubprogram(name: "P0", scope: !3, file: !3, line: 34, type: !73, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !75)
!73 = !DISubroutineType(types: !74)
!74 = !{!27, !27}
!75 = !{}
!76 = !DILocalVariable(name: "unused", arg: 1, scope: !72, file: !3, line: 34, type: !27)
!77 = !DILocation(line: 34, column: 16, scope: !72)
!78 = !DILocation(line: 36, column: 2, scope: !72)
!79 = !DILocation(line: 37, column: 2, scope: !72)
!80 = !DILocation(line: 38, column: 2, scope: !72)
!81 = !DILocation(line: 39, column: 2, scope: !72)
!82 = !DILocation(line: 40, column: 2, scope: !72)
!83 = distinct !DISubprogram(name: "P1", scope: !3, file: !3, line: 43, type: !73, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !75)
!84 = !DILocalVariable(name: "unused", arg: 1, scope: !83, file: !3, line: 43, type: !27)
!85 = !DILocation(line: 43, column: 16, scope: !83)
!86 = !DILocation(line: 45, column: 6, scope: !87)
!87 = distinct !DILexicalBlock(scope: !83, file: !3, line: 45, column: 6)
!88 = !DILocation(line: 45, column: 19, scope: !87)
!89 = !DILocation(line: 45, column: 6, scope: !83)
!90 = !DILocation(line: 46, column: 3, scope: !87)
!91 = !DILocation(line: 47, column: 2, scope: !83)
!92 = distinct !DISubprogram(name: "P2", scope: !3, file: !3, line: 50, type: !73, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !75)
!93 = !DILocalVariable(name: "unused", arg: 1, scope: !92, file: !3, line: 50, type: !27)
!94 = !DILocation(line: 50, column: 16, scope: !92)
!95 = !DILocation(line: 52, column: 8, scope: !92)
!96 = !DILocation(line: 52, column: 6, scope: !92)
!97 = !DILocation(line: 53, column: 8, scope: !92)
!98 = !DILocation(line: 53, column: 6, scope: !92)
!99 = !DILocation(line: 54, column: 2, scope: !92)
!100 = distinct !DISubprogram(name: "P3", scope: !3, file: !3, line: 57, type: !73, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !75)
!101 = !DILocalVariable(name: "unused", arg: 1, scope: !100, file: !3, line: 57, type: !27)
!102 = !DILocation(line: 57, column: 16, scope: !100)
!103 = !DILocation(line: 59, column: 2, scope: !100)
!104 = !DILocation(line: 60, column: 2, scope: !100)
!105 = !DILocation(line: 61, column: 8, scope: !100)
!106 = !DILocation(line: 61, column: 6, scope: !100)
!107 = !DILocation(line: 62, column: 2, scope: !100)
!108 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 65, type: !109, scopeLine: 66, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !75)
!109 = !DISubroutineType(types: !110)
!110 = !{!28}
!111 = !DILocalVariable(name: "t0", scope: !108, file: !3, line: 70, type: !112)
!112 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !113, line: 31, baseType: !114)
!113 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!114 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !115, line: 118, baseType: !116)
!115 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !117, size: 64)
!117 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !115, line: 103, size: 65536, elements: !118)
!118 = !{!119, !120, !130}
!119 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !117, file: !115, line: 104, baseType: !26, size: 64)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !117, file: !115, line: 105, baseType: !121, size: 64, offset: 64)
!121 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !122, size: 64)
!122 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !115, line: 57, size: 192, elements: !123)
!123 = !{!124, !128, !129}
!124 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !122, file: !115, line: 58, baseType: !125, size: 64)
!125 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !126, size: 64)
!126 = !DISubroutineType(types: !127)
!127 = !{null, !27}
!128 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !122, file: !115, line: 59, baseType: !27, size: 64, offset: 64)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !122, file: !115, line: 60, baseType: !121, size: 64, offset: 128)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !117, file: !115, line: 106, baseType: !131, size: 65408, offset: 128)
!131 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 65408, elements: !132)
!132 = !{!133}
!133 = !DISubrange(count: 8176)
!134 = !DILocation(line: 70, column: 12, scope: !108)
!135 = !DILocalVariable(name: "t1", scope: !108, file: !3, line: 70, type: !112)
!136 = !DILocation(line: 70, column: 16, scope: !108)
!137 = !DILocalVariable(name: "t2", scope: !108, file: !3, line: 70, type: !112)
!138 = !DILocation(line: 70, column: 20, scope: !108)
!139 = !DILocalVariable(name: "t3", scope: !108, file: !3, line: 70, type: !112)
!140 = !DILocation(line: 70, column: 24, scope: !108)
!141 = !DILocation(line: 72, column: 2, scope: !108)
!142 = !DILocation(line: 73, column: 2, scope: !108)
!143 = !DILocation(line: 74, column: 2, scope: !108)
!144 = !DILocation(line: 75, column: 2, scope: !108)
!145 = !DILocation(line: 77, column: 15, scope: !108)
!146 = !DILocation(line: 77, column: 2, scope: !108)
!147 = !DILocation(line: 78, column: 15, scope: !108)
!148 = !DILocation(line: 78, column: 2, scope: !108)
!149 = !DILocation(line: 79, column: 15, scope: !108)
!150 = !DILocation(line: 79, column: 2, scope: !108)
!151 = !DILocation(line: 80, column: 15, scope: !108)
!152 = !DILocation(line: 80, column: 2, scope: !108)
!153 = !DILocation(line: 82, column: 2, scope: !108)
!154 = !DILocation(line: 0, scope: !108)
!155 = !DILocation(line: 84, column: 2, scope: !108)
