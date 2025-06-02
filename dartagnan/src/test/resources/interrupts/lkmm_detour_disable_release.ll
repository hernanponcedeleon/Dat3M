; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_detour_disable_release.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_detour_disable_release.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx15.0.0"

@y = global i32 0, align 4, !dbg !0
@h = global ptr null, align 8, !dbg !37
@x = global i32 0, align 4, !dbg !30
@a = global i32 0, align 4, !dbg !33
@b = global i32 0, align 4, !dbg !35

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !69 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !73, metadata !DIExpression()), !dbg !74
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 3, i32 noundef 0), !dbg !75
  ret ptr null, !dbg !76
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_1(ptr noundef %0) #0 !dbg !77 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !78, metadata !DIExpression()), !dbg !79
  call void @__VERIFIER_make_interrupt_handler(), !dbg !80
  %3 = call i32 @pthread_create(ptr noundef @h, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !81
  call void @__VERIFIER_disable_irq(), !dbg !82
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 2), !dbg !83
  %4 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 0), !dbg !84
  %5 = trunc i64 %4 to i32, !dbg !84
  store i32 %5, ptr @a, align 4, !dbg !85
  call void @__VERIFIER_enable_irq(), !dbg !86
  %6 = load ptr, ptr @h, align 8, !dbg !87
  %7 = call i32 @"\01_pthread_join"(ptr noundef %6, ptr noundef null), !dbg !88
  ret ptr null, !dbg !89
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare void @__VERIFIER_disable_irq() #2

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #2

declare void @__VERIFIER_enable_irq() #2

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_2(ptr noundef %0) #0 !dbg !90 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !91, metadata !DIExpression()), !dbg !92
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !93
  %4 = trunc i64 %3 to i32, !dbg !93
  store i32 %4, ptr @b, align 4, !dbg !94
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 2, i32 noundef 2), !dbg !95
  ret ptr null, !dbg !96
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !97 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !100, metadata !DIExpression()), !dbg !101
  call void @llvm.dbg.declare(metadata ptr %3, metadata !102, metadata !DIExpression()), !dbg !103
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !104
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !105
  %6 = load ptr, ptr %2, align 8, !dbg !106
  %7 = call i32 @"\01_pthread_join"(ptr noundef %6, ptr noundef null), !dbg !107
  %8 = load ptr, ptr %3, align 8, !dbg !108
  %9 = call i32 @"\01_pthread_join"(ptr noundef %8, ptr noundef null), !dbg !109
  %10 = load i32, ptr @b, align 4, !dbg !110
  %11 = icmp eq i32 %10, 1, !dbg !111
  br i1 %11, label %12, label %18, !dbg !112

12:                                               ; preds = %0
  %13 = load i32, ptr @a, align 4, !dbg !113
  %14 = icmp eq i32 %13, 3, !dbg !114
  br i1 %14, label %15, label %18, !dbg !115

15:                                               ; preds = %12
  %16 = load i32, ptr @y, align 4, !dbg !116
  %17 = icmp eq i32 %16, 3, !dbg !117
  br label %18

18:                                               ; preds = %15, %12, %0
  %19 = phi i1 [ false, %12 ], [ false, %0 ], [ %17, %15 ], !dbg !118
  %20 = xor i1 %19, true, !dbg !119
  %21 = zext i1 %20 to i32, !dbg !119
  call void @__VERIFIER_assert(i32 noundef %21), !dbg !120
  ret i32 0, !dbg !121
}

declare void @__VERIFIER_assert(i32 noundef) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!62, !63, !64, !65, !66, !67}
!llvm.ident = !{!68}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !32, line: 9, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 16.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !22, globals: !29, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_detour_disable_release.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
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
!25 = !DIFile(filename: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/_types/_intmax_t.h", directory: "")
!26 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !{!30, !0, !33, !35, !37}
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !32, line: 9, type: !28, isLocal: false, isDefinition: true)
!32 = !DIFile(filename: "benchmarks/interrupts/lkmm_detour_disable_release.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !32, line: 9, type: !28, isLocal: false, isDefinition: true)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !32, line: 9, type: !28, isLocal: false, isDefinition: true)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !32, line: 11, type: !39, isLocal: false, isDefinition: true)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !40, line: 31, baseType: !41)
!40 = !DIFile(filename: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !42, line: 118, baseType: !43)
!42 = !DIFile(filename: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!44 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !42, line: 103, size: 65536, elements: !45)
!45 = !{!46, !47, !57}
!46 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !44, file: !42, line: 104, baseType: !26, size: 64)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !44, file: !42, line: 105, baseType: !48, size: 64, offset: 64)
!48 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !49, size: 64)
!49 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !42, line: 57, size: 192, elements: !50)
!50 = !{!51, !55, !56}
!51 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !49, file: !42, line: 58, baseType: !52, size: 64)
!52 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !53, size: 64)
!53 = !DISubroutineType(types: !54)
!54 = !{null, !27}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !49, file: !42, line: 59, baseType: !27, size: 64, offset: 64)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !49, file: !42, line: 60, baseType: !48, size: 64, offset: 128)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !44, file: !42, line: 106, baseType: !58, size: 65408, offset: 128)
!58 = !DICompositeType(tag: DW_TAG_array_type, baseType: !59, size: 65408, elements: !60)
!59 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!60 = !{!61}
!61 = !DISubrange(count: 8176)
!62 = !{i32 7, !"Dwarf Version", i32 4}
!63 = !{i32 2, !"Debug Info Version", i32 3}
!64 = !{i32 1, !"wchar_size", i32 4}
!65 = !{i32 8, !"PIC Level", i32 2}
!66 = !{i32 7, !"uwtable", i32 1}
!67 = !{i32 7, !"frame-pointer", i32 1}
!68 = !{!"Homebrew clang version 16.0.6"}
!69 = distinct !DISubprogram(name: "handler", scope: !32, file: !32, line: 12, type: !70, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!70 = !DISubroutineType(types: !71)
!71 = !{!27, !27}
!72 = !{}
!73 = !DILocalVariable(name: "arg", arg: 1, scope: !69, file: !32, line: 12, type: !27)
!74 = !DILocation(line: 12, column: 21, scope: !69)
!75 = !DILocation(line: 14, column: 5, scope: !69)
!76 = !DILocation(line: 15, column: 5, scope: !69)
!77 = distinct !DISubprogram(name: "thread_1", scope: !32, file: !32, line: 18, type: !70, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!78 = !DILocalVariable(name: "arg", arg: 1, scope: !77, file: !32, line: 18, type: !27)
!79 = !DILocation(line: 18, column: 22, scope: !77)
!80 = !DILocation(line: 20, column: 5, scope: !77)
!81 = !DILocation(line: 21, column: 5, scope: !77)
!82 = !DILocation(line: 23, column: 5, scope: !77)
!83 = !DILocation(line: 24, column: 5, scope: !77)
!84 = !DILocation(line: 25, column: 9, scope: !77)
!85 = !DILocation(line: 25, column: 7, scope: !77)
!86 = !DILocation(line: 26, column: 5, scope: !77)
!87 = !DILocation(line: 28, column: 18, scope: !77)
!88 = !DILocation(line: 28, column: 5, scope: !77)
!89 = !DILocation(line: 30, column: 5, scope: !77)
!90 = distinct !DISubprogram(name: "thread_2", scope: !32, file: !32, line: 33, type: !70, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!91 = !DILocalVariable(name: "arg", arg: 1, scope: !90, file: !32, line: 33, type: !27)
!92 = !DILocation(line: 33, column: 22, scope: !90)
!93 = !DILocation(line: 35, column: 9, scope: !90)
!94 = !DILocation(line: 35, column: 7, scope: !90)
!95 = !DILocation(line: 36, column: 5, scope: !90)
!96 = !DILocation(line: 37, column: 5, scope: !90)
!97 = distinct !DISubprogram(name: "main", scope: !32, file: !32, line: 40, type: !98, scopeLine: 41, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!98 = !DISubroutineType(types: !99)
!99 = !{!28}
!100 = !DILocalVariable(name: "t1", scope: !97, file: !32, line: 42, type: !39)
!101 = !DILocation(line: 42, column: 15, scope: !97)
!102 = !DILocalVariable(name: "t2", scope: !97, file: !32, line: 42, type: !39)
!103 = !DILocation(line: 42, column: 19, scope: !97)
!104 = !DILocation(line: 44, column: 5, scope: !97)
!105 = !DILocation(line: 45, column: 5, scope: !97)
!106 = !DILocation(line: 46, column: 18, scope: !97)
!107 = !DILocation(line: 46, column: 5, scope: !97)
!108 = !DILocation(line: 47, column: 18, scope: !97)
!109 = !DILocation(line: 47, column: 5, scope: !97)
!110 = !DILocation(line: 49, column: 25, scope: !97)
!111 = !DILocation(line: 49, column: 27, scope: !97)
!112 = !DILocation(line: 49, column: 32, scope: !97)
!113 = !DILocation(line: 49, column: 35, scope: !97)
!114 = !DILocation(line: 49, column: 37, scope: !97)
!115 = !DILocation(line: 49, column: 42, scope: !97)
!116 = !DILocation(line: 49, column: 45, scope: !97)
!117 = !DILocation(line: 49, column: 47, scope: !97)
!118 = !DILocation(line: 0, scope: !97)
!119 = !DILocation(line: 49, column: 23, scope: !97)
!120 = !DILocation(line: 49, column: 5, scope: !97)
!121 = !DILocation(line: 51, column: 5, scope: !97)
