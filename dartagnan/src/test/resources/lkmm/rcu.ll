; ModuleID = 'benchmarks/lkmm/rcu.c'
source_filename = "benchmarks/lkmm/rcu.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@x = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !46
@r_x = global i32 0, align 4, !dbg !48
@r_y = global i32 0, align 4, !dbg !50
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@.str = private unnamed_addr constant [6 x i8] c"rcu.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [24 x i8] c"!(r_x == 1 && r_y == 0)\00", align 1, !dbg !41

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @P0(ptr noundef %0) #0 !dbg !59 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !63, !DIExpression(), !64)
  call void @__LKMM_fence(i32 noundef 7), !dbg !65
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !66
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !67
  call void @__LKMM_fence(i32 noundef 8), !dbg !68
  ret ptr null, !dbg !69
}

declare void @__LKMM_fence(i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @P1(ptr noundef %0) #0 !dbg !70 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !71, !DIExpression(), !72)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !73
  %4 = trunc i64 %3 to i32, !dbg !73
  store i32 %4, ptr @r_x, align 4, !dbg !74
  call void @__LKMM_fence(i32 noundef 9), !dbg !75
  %5 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !76
  %6 = trunc i64 %5 to i32, !dbg !76
  store i32 %6, ptr @r_y, align 4, !dbg !77
  ret ptr null, !dbg !78
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !79 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !82, !DIExpression(), !106)
    #dbg_declare(ptr %3, !107, !DIExpression(), !108)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @P0, ptr noundef null), !dbg !109
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @P1, ptr noundef null), !dbg !110
  %6 = load ptr, ptr %2, align 8, !dbg !111
  %7 = call i32 @"\01_pthread_join"(ptr noundef %6, ptr noundef null), !dbg !112
  %8 = load ptr, ptr %3, align 8, !dbg !113
  %9 = call i32 @"\01_pthread_join"(ptr noundef %8, ptr noundef null), !dbg !114
  %10 = load i32, ptr @r_x, align 4, !dbg !115
  %11 = icmp eq i32 %10, 1, !dbg !115
  br i1 %11, label %12, label %15, !dbg !115

12:                                               ; preds = %0
  %13 = load i32, ptr @r_y, align 4, !dbg !115
  %14 = icmp eq i32 %13, 0, !dbg !115
  br label %15

15:                                               ; preds = %12, %0
  %16 = phi i1 [ false, %0 ], [ %14, %12 ], !dbg !116
  %17 = xor i1 %16, true, !dbg !115
  %18 = xor i1 %17, true, !dbg !115
  %19 = zext i1 %18 to i32, !dbg !115
  %20 = sext i32 %19 to i64, !dbg !115
  %21 = icmp ne i64 %20, 0, !dbg !115
  br i1 %21, label %22, label %24, !dbg !115

22:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 43, ptr noundef @.str.1) #3, !dbg !115
  unreachable, !dbg !115

23:                                               ; No predecessors!
  br label %25, !dbg !115

24:                                               ; preds = %15
  br label %25, !dbg !115

25:                                               ; preds = %24, %23
  ret i32 0, !dbg !117
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!52, !53, !54, !55, !56, !57}
!llvm.ident = !{!58}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 7, type: !27, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/lkmm/rcu.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "dad53a6fc905d03af1a936e703cc6339")
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
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!27 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
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
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 48, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 6)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !3, line: 43, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 192, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 24)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 8, type: !27, isLocal: false, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "r_x", scope: !2, file: !3, line: 10, type: !27, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "r_y", scope: !2, file: !3, line: 11, type: !27, isLocal: false, isDefinition: true)
!52 = !{i32 7, !"Dwarf Version", i32 5}
!53 = !{i32 2, !"Debug Info Version", i32 3}
!54 = !{i32 1, !"wchar_size", i32 4}
!55 = !{i32 8, !"PIC Level", i32 2}
!56 = !{i32 7, !"uwtable", i32 1}
!57 = !{i32 7, !"frame-pointer", i32 1}
!58 = !{!"Homebrew clang version 19.1.7"}
!59 = distinct !DISubprogram(name: "P0", scope: !3, file: !3, line: 13, type: !60, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!60 = !DISubroutineType(types: !61)
!61 = !{!26, !26}
!62 = !{}
!63 = !DILocalVariable(name: "unused", arg: 1, scope: !59, file: !3, line: 13, type: !26)
!64 = !DILocation(line: 13, column: 16, scope: !59)
!65 = !DILocation(line: 15, column: 2, scope: !59)
!66 = !DILocation(line: 16, column: 2, scope: !59)
!67 = !DILocation(line: 17, column: 2, scope: !59)
!68 = !DILocation(line: 18, column: 2, scope: !59)
!69 = !DILocation(line: 19, column: 2, scope: !59)
!70 = distinct !DISubprogram(name: "P1", scope: !3, file: !3, line: 22, type: !60, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!71 = !DILocalVariable(name: "unused", arg: 1, scope: !70, file: !3, line: 22, type: !26)
!72 = !DILocation(line: 22, column: 16, scope: !70)
!73 = !DILocation(line: 24, column: 8, scope: !70)
!74 = !DILocation(line: 24, column: 6, scope: !70)
!75 = !DILocation(line: 25, column: 2, scope: !70)
!76 = !DILocation(line: 26, column: 8, scope: !70)
!77 = !DILocation(line: 26, column: 6, scope: !70)
!78 = !DILocation(line: 27, column: 2, scope: !70)
!79 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 30, type: !80, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!80 = !DISubroutineType(types: !81)
!81 = !{!27}
!82 = !DILocalVariable(name: "t1", scope: !79, file: !3, line: 35, type: !83)
!83 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !84, line: 31, baseType: !85)
!84 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!85 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !86, line: 118, baseType: !87)
!86 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !86, line: 103, size: 65536, elements: !89)
!89 = !{!90, !92, !102}
!90 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !88, file: !86, line: 104, baseType: !91, size: 64)
!91 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !88, file: !86, line: 105, baseType: !93, size: 64, offset: 64)
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!94 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !86, line: 57, size: 192, elements: !95)
!95 = !{!96, !100, !101}
!96 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !94, file: !86, line: 58, baseType: !97, size: 64)
!97 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!98 = !DISubroutineType(types: !99)
!99 = !{null, !26}
!100 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !94, file: !86, line: 59, baseType: !26, size: 64, offset: 64)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !94, file: !86, line: 60, baseType: !93, size: 64, offset: 128)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !88, file: !86, line: 106, baseType: !103, size: 65408, offset: 128)
!103 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !104)
!104 = !{!105}
!105 = !DISubrange(count: 8176)
!106 = !DILocation(line: 35, column: 15, scope: !79)
!107 = !DILocalVariable(name: "t2", scope: !79, file: !3, line: 35, type: !83)
!108 = !DILocation(line: 35, column: 19, scope: !79)
!109 = !DILocation(line: 37, column: 2, scope: !79)
!110 = !DILocation(line: 38, column: 2, scope: !79)
!111 = !DILocation(line: 40, column: 15, scope: !79)
!112 = !DILocation(line: 40, column: 2, scope: !79)
!113 = !DILocation(line: 41, column: 15, scope: !79)
!114 = !DILocation(line: 41, column: 2, scope: !79)
!115 = !DILocation(line: 43, column: 2, scope: !79)
!116 = !DILocation(line: 0, scope: !79)
!117 = !DILocation(line: 45, column: 2, scope: !79)
