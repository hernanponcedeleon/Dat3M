; ModuleID = 'benchmarks/lkmm/CoRW+poonce+Once.c'
source_filename = "benchmarks/lkmm/CoRW+poonce+Once.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0
@r0 = dso_local global i32 0, align 4, !dbg !47
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !30
@.str = private unnamed_addr constant [19 x i8] c"CoRW+poonce+Once.c\00", align 1, !dbg !37
@.str.1 = private unnamed_addr constant [32 x i8] c"!(READ_ONCE(x) == 2 && r0 == 2)\00", align 1, !dbg !42

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !57 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !61, !DIExpression(), !62)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !63
  %4 = trunc i64 %3 to i32, !dbg !63
  store i32 %4, ptr @r0, align 4, !dbg !64
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !65
  ret ptr null, !dbg !66
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !67 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !68, !DIExpression(), !69)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 2, i32 noundef 0), !dbg !70
  ret ptr null, !dbg !71
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !72 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !75, !DIExpression(), !98)
    #dbg_declare(ptr %3, !99, !DIExpression(), !100)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !101
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !102
  %6 = load ptr, ptr %2, align 8, !dbg !103
  %7 = call i32 @_pthread_join(ptr noundef %6, ptr noundef null), !dbg !104
  %8 = load ptr, ptr %3, align 8, !dbg !105
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !106
  %10 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !107
  %11 = trunc i64 %10 to i32, !dbg !107
  %12 = icmp eq i32 %11, 2, !dbg !107
  br i1 %12, label %13, label %16, !dbg !107

13:                                               ; preds = %0
  %14 = load i32, ptr @r0, align 4, !dbg !107
  %15 = icmp eq i32 %14, 2, !dbg !107
  br label %16

16:                                               ; preds = %13, %0
  %17 = phi i1 [ false, %0 ], [ %15, %13 ], !dbg !108
  %18 = xor i1 %17, true, !dbg !107
  %19 = xor i1 %18, true, !dbg !107
  %20 = zext i1 %19 to i32, !dbg !107
  %21 = sext i32 %20 to i64, !dbg !107
  %22 = icmp ne i64 %21, 0, !dbg !107
  br i1 %22, label %23, label %25, !dbg !107

23:                                               ; preds = %16
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 32, ptr noundef @.str.1) #3, !dbg !107
  unreachable, !dbg !107

24:                                               ; No predecessors!
  br label %26, !dbg !107

25:                                               ; preds = %16
  br label %26, !dbg !107

26:                                               ; preds = %25, %24
  ret i32 0, !dbg !109
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
!llvm.module.flags = !{!49, !50, !51, !52, !53, !54, !55}
!llvm.ident = !{!56}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !23, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !22, globals: !29, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/CoRW+poonce+Once.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "7ba65203ffa8596e0a368dd8dfc16793")
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
!22 = !{!23, !24, !28}
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 27, baseType: !25)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !26, line: 32, baseType: !27)
!26 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!27 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!29 = !{!30, !37, !42, !0, !47}
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 32, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 40, elements: !35)
!33 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!34 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!35 = !{!36}
!36 = !DISubrange(count: 5)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 32, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 152, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 19)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 32, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 256, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 32)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !3, line: 7, type: !23, isLocal: false, isDefinition: true)
!49 = !{i32 7, !"Dwarf Version", i32 5}
!50 = !{i32 2, !"Debug Info Version", i32 3}
!51 = !{i32 1, !"wchar_size", i32 4}
!52 = !{i32 8, !"PIC Level", i32 2}
!53 = !{i32 7, !"PIE Level", i32 2}
!54 = !{i32 7, !"uwtable", i32 2}
!55 = !{i32 7, !"frame-pointer", i32 2}
!56 = !{!"Homebrew clang version 19.1.7"}
!57 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 9, type: !58, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!58 = !DISubroutineType(types: !59)
!59 = !{!28, !28}
!60 = !{}
!61 = !DILocalVariable(name: "unused", arg: 1, scope: !57, file: !3, line: 9, type: !28)
!62 = !DILocation(line: 9, column: 22, scope: !57)
!63 = !DILocation(line: 11, column: 7, scope: !57)
!64 = !DILocation(line: 11, column: 5, scope: !57)
!65 = !DILocation(line: 12, column: 2, scope: !57)
!66 = !DILocation(line: 13, column: 2, scope: !57)
!67 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 16, type: !58, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!68 = !DILocalVariable(name: "unused", arg: 1, scope: !67, file: !3, line: 16, type: !28)
!69 = !DILocation(line: 16, column: 22, scope: !67)
!70 = !DILocation(line: 18, column: 2, scope: !67)
!71 = !DILocation(line: 19, column: 2, scope: !67)
!72 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 22, type: !73, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!73 = !DISubroutineType(types: !74)
!74 = !{!23}
!75 = !DILocalVariable(name: "t1", scope: !72, file: !3, line: 24, type: !76)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !77, line: 31, baseType: !78)
!77 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!78 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !79, line: 118, baseType: !80)
!79 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!81 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !79, line: 103, size: 65536, elements: !82)
!82 = !{!83, !84, !94}
!83 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !81, file: !79, line: 104, baseType: !27, size: 64)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !81, file: !79, line: 105, baseType: !85, size: 64, offset: 64)
!85 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !86, size: 64)
!86 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !79, line: 57, size: 192, elements: !87)
!87 = !{!88, !92, !93}
!88 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !86, file: !79, line: 58, baseType: !89, size: 64)
!89 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !90, size: 64)
!90 = !DISubroutineType(types: !91)
!91 = !{null, !28}
!92 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !86, file: !79, line: 59, baseType: !28, size: 64, offset: 64)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !86, file: !79, line: 60, baseType: !85, size: 64, offset: 128)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !81, file: !79, line: 106, baseType: !95, size: 65408, offset: 128)
!95 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 65408, elements: !96)
!96 = !{!97}
!97 = !DISubrange(count: 8176)
!98 = !DILocation(line: 24, column: 12, scope: !72)
!99 = !DILocalVariable(name: "t2", scope: !72, file: !3, line: 24, type: !76)
!100 = !DILocation(line: 24, column: 16, scope: !72)
!101 = !DILocation(line: 26, column: 2, scope: !72)
!102 = !DILocation(line: 27, column: 2, scope: !72)
!103 = !DILocation(line: 29, column: 15, scope: !72)
!104 = !DILocation(line: 29, column: 2, scope: !72)
!105 = !DILocation(line: 30, column: 15, scope: !72)
!106 = !DILocation(line: 30, column: 2, scope: !72)
!107 = !DILocation(line: 32, column: 2, scope: !72)
!108 = !DILocation(line: 0, scope: !72)
!109 = !DILocation(line: 34, column: 2, scope: !72)
