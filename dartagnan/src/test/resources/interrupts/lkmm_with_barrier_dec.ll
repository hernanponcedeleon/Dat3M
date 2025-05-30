; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_with_barrier_dec.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_with_barrier_dec.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx15.0.0"

%struct.A = type { i32, i32 }

@cnt = global i32 0, align 4, !dbg !0
@as = global [10 x %struct.A] zeroinitializer, align 4, !dbg !30
@h = global ptr null, align 8, !dbg !42

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !74 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !78, metadata !DIExpression()), !dbg !79
  call void @llvm.dbg.declare(metadata ptr %3, metadata !80, metadata !DIExpression()), !dbg !81
  %5 = load ptr, ptr %2, align 8, !dbg !82
  %6 = ptrtoint ptr %5 to i64, !dbg !83
  %7 = trunc i64 %6 to i32, !dbg !84
  store i32 %7, ptr %3, align 4, !dbg !81
  call void @llvm.dbg.declare(metadata ptr %4, metadata !85, metadata !DIExpression()), !dbg !86
  %8 = load i32, ptr @cnt, align 4, !dbg !87
  %9 = add nsw i32 %8, 1, !dbg !87
  store i32 %9, ptr @cnt, align 4, !dbg !87
  store i32 %8, ptr %4, align 4, !dbg !86
  call void @__LKMM_fence(i32 noundef 12), !dbg !88
  %10 = load i32, ptr %3, align 4, !dbg !89
  %11 = load i32, ptr %4, align 4, !dbg !90
  %12 = sext i32 %11 to i64, !dbg !91
  %13 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %12, !dbg !91
  %14 = getelementptr inbounds %struct.A, ptr %13, i32 0, i32 0, !dbg !92
  store volatile i32 %10, ptr %14, align 4, !dbg !93
  %15 = load i32, ptr %3, align 4, !dbg !94
  %16 = load i32, ptr %4, align 4, !dbg !95
  %17 = sext i32 %16 to i64, !dbg !96
  %18 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %17, !dbg !96
  %19 = getelementptr inbounds %struct.A, ptr %18, i32 0, i32 1, !dbg !97
  store volatile i32 %15, ptr %19, align 4, !dbg !98
  %20 = load i32, ptr %4, align 4, !dbg !99
  %21 = sext i32 %20 to i64, !dbg !100
  %22 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %21, !dbg !100
  %23 = getelementptr inbounds %struct.A, ptr %22, i32 0, i32 0, !dbg !101
  %24 = load volatile i32, ptr %23, align 4, !dbg !101
  %25 = load i32, ptr %4, align 4, !dbg !102
  %26 = sext i32 %25 to i64, !dbg !103
  %27 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %26, !dbg !103
  %28 = getelementptr inbounds %struct.A, ptr %27, i32 0, i32 1, !dbg !104
  %29 = load volatile i32, ptr %28, align 4, !dbg !104
  %30 = icmp eq i32 %24, %29, !dbg !105
  %31 = zext i1 %30 to i32, !dbg !105
  call void @__VERIFIER_assert(i32 noundef %31), !dbg !106
  %32 = load i32, ptr @cnt, align 4, !dbg !107
  %33 = add nsw i32 %32, -1, !dbg !107
  store i32 %33, ptr @cnt, align 4, !dbg !107
  ret ptr null, !dbg !108
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_fence(i32 noundef) #2

declare void @__VERIFIER_assert(i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 !dbg !109 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !110, metadata !DIExpression()), !dbg !111
  call void @__VERIFIER_make_interrupt_handler(), !dbg !112
  %5 = call i32 @pthread_create(ptr noundef @h, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !113
  call void @llvm.dbg.declare(metadata ptr %3, metadata !114, metadata !DIExpression()), !dbg !115
  %6 = load ptr, ptr %2, align 8, !dbg !116
  %7 = ptrtoint ptr %6 to i64, !dbg !117
  %8 = trunc i64 %7 to i32, !dbg !118
  store i32 %8, ptr %3, align 4, !dbg !115
  call void @llvm.dbg.declare(metadata ptr %4, metadata !119, metadata !DIExpression()), !dbg !120
  %9 = load i32, ptr @cnt, align 4, !dbg !121
  %10 = add nsw i32 %9, 1, !dbg !121
  store i32 %10, ptr @cnt, align 4, !dbg !121
  store i32 %9, ptr %4, align 4, !dbg !120
  call void @__LKMM_fence(i32 noundef 12), !dbg !122
  %11 = load i32, ptr %3, align 4, !dbg !123
  %12 = load i32, ptr %4, align 4, !dbg !124
  %13 = sext i32 %12 to i64, !dbg !125
  %14 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %13, !dbg !125
  %15 = getelementptr inbounds %struct.A, ptr %14, i32 0, i32 0, !dbg !126
  store volatile i32 %11, ptr %15, align 4, !dbg !127
  %16 = load i32, ptr %3, align 4, !dbg !128
  %17 = load i32, ptr %4, align 4, !dbg !129
  %18 = sext i32 %17 to i64, !dbg !130
  %19 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %18, !dbg !130
  %20 = getelementptr inbounds %struct.A, ptr %19, i32 0, i32 1, !dbg !131
  store volatile i32 %16, ptr %20, align 4, !dbg !132
  %21 = load i32, ptr %4, align 4, !dbg !133
  %22 = sext i32 %21 to i64, !dbg !134
  %23 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %22, !dbg !134
  %24 = getelementptr inbounds %struct.A, ptr %23, i32 0, i32 0, !dbg !135
  %25 = load volatile i32, ptr %24, align 4, !dbg !135
  %26 = load i32, ptr %4, align 4, !dbg !136
  %27 = sext i32 %26 to i64, !dbg !137
  %28 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %27, !dbg !137
  %29 = getelementptr inbounds %struct.A, ptr %28, i32 0, i32 1, !dbg !138
  %30 = load volatile i32, ptr %29, align 4, !dbg !138
  %31 = icmp eq i32 %25, %30, !dbg !139
  %32 = zext i1 %31 to i32, !dbg !139
  call void @__VERIFIER_assert(i32 noundef %32), !dbg !140
  %33 = load i32, ptr @cnt, align 4, !dbg !141
  %34 = add nsw i32 %33, -1, !dbg !141
  store i32 %34, ptr @cnt, align 4, !dbg !141
  %35 = load ptr, ptr @h, align 8, !dbg !142
  %36 = call i32 @"\01_pthread_join"(ptr noundef %35, ptr noundef null), !dbg !143
  ret ptr null, !dbg !144
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !145 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !148, metadata !DIExpression()), !dbg !149
  %3 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @run, ptr noundef inttoptr (i64 1 to ptr)), !dbg !150
  ret i32 0, !dbg !151
}

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!67, !68, !69, !70, !71, !72}
!llvm.ident = !{!73}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "cnt", scope: !2, file: !32, line: 14, type: !38, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 16.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !22, globals: !29, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_with_barrier_dec.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
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
!22 = !{!23, !28}
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !24, line: 32, baseType: !25)
!24 = !DIFile(filename: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/_types/_intptr_t.h", directory: "")
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_intptr_t", file: !26, line: 40, baseType: !27)
!26 = !DIFile(filename: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/arm/_types.h", directory: "")
!27 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!29 = !{!0, !30, !42}
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "as", scope: !2, file: !32, line: 13, type: !33, isLocal: false, isDefinition: true)
!32 = !DIFile(filename: "benchmarks/interrupts/lkmm_with_barrier_dec.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 640, elements: !40)
!34 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "A", file: !32, line: 12, size: 64, elements: !35)
!35 = !{!36, !39}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !34, file: !32, line: 12, baseType: !37, size: 32)
!37 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !38)
!38 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !34, file: !32, line: 12, baseType: !37, size: 32, offset: 32)
!40 = !{!41}
!41 = !DISubrange(count: 10)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !32, line: 16, type: !44, isLocal: false, isDefinition: true)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !45, line: 31, baseType: !46)
!45 = !DIFile(filename: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !47, line: 118, baseType: !48)
!47 = !DIFile(filename: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!48 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !49, size: 64)
!49 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !47, line: 103, size: 65536, elements: !50)
!50 = !{!51, !52, !62}
!51 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !49, file: !47, line: 104, baseType: !27, size: 64)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !49, file: !47, line: 105, baseType: !53, size: 64, offset: 64)
!53 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !54, size: 64)
!54 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !47, line: 57, size: 192, elements: !55)
!55 = !{!56, !60, !61}
!56 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !54, file: !47, line: 58, baseType: !57, size: 64)
!57 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !58, size: 64)
!58 = !DISubroutineType(types: !59)
!59 = !{null, !28}
!60 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !54, file: !47, line: 59, baseType: !28, size: 64, offset: 64)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !54, file: !47, line: 60, baseType: !53, size: 64, offset: 128)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !49, file: !47, line: 106, baseType: !63, size: 65408, offset: 128)
!63 = !DICompositeType(tag: DW_TAG_array_type, baseType: !64, size: 65408, elements: !65)
!64 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!65 = !{!66}
!66 = !DISubrange(count: 8176)
!67 = !{i32 7, !"Dwarf Version", i32 4}
!68 = !{i32 2, !"Debug Info Version", i32 3}
!69 = !{i32 1, !"wchar_size", i32 4}
!70 = !{i32 8, !"PIC Level", i32 2}
!71 = !{i32 7, !"uwtable", i32 1}
!72 = !{i32 7, !"frame-pointer", i32 1}
!73 = !{!"Homebrew clang version 16.0.6"}
!74 = distinct !DISubprogram(name: "handler", scope: !32, file: !32, line: 17, type: !75, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !77)
!75 = !DISubroutineType(types: !76)
!76 = !{!28, !28}
!77 = !{}
!78 = !DILocalVariable(name: "arg", arg: 1, scope: !74, file: !32, line: 17, type: !28)
!79 = !DILocation(line: 17, column: 21, scope: !74)
!80 = !DILocalVariable(name: "tindex", scope: !74, file: !32, line: 19, type: !38)
!81 = !DILocation(line: 19, column: 9, scope: !74)
!82 = !DILocation(line: 19, column: 30, scope: !74)
!83 = !DILocation(line: 19, column: 19, scope: !74)
!84 = !DILocation(line: 19, column: 18, scope: !74)
!85 = !DILocalVariable(name: "i", scope: !74, file: !32, line: 20, type: !38)
!86 = !DILocation(line: 20, column: 9, scope: !74)
!87 = !DILocation(line: 20, column: 16, scope: !74)
!88 = !DILocation(line: 21, column: 5, scope: !74)
!89 = !DILocation(line: 22, column: 15, scope: !74)
!90 = !DILocation(line: 22, column: 8, scope: !74)
!91 = !DILocation(line: 22, column: 5, scope: !74)
!92 = !DILocation(line: 22, column: 11, scope: !74)
!93 = !DILocation(line: 22, column: 13, scope: !74)
!94 = !DILocation(line: 23, column: 15, scope: !74)
!95 = !DILocation(line: 23, column: 8, scope: !74)
!96 = !DILocation(line: 23, column: 5, scope: !74)
!97 = !DILocation(line: 23, column: 11, scope: !74)
!98 = !DILocation(line: 23, column: 13, scope: !74)
!99 = !DILocation(line: 24, column: 26, scope: !74)
!100 = !DILocation(line: 24, column: 23, scope: !74)
!101 = !DILocation(line: 24, column: 29, scope: !74)
!102 = !DILocation(line: 24, column: 37, scope: !74)
!103 = !DILocation(line: 24, column: 34, scope: !74)
!104 = !DILocation(line: 24, column: 40, scope: !74)
!105 = !DILocation(line: 24, column: 31, scope: !74)
!106 = !DILocation(line: 24, column: 5, scope: !74)
!107 = !DILocation(line: 26, column: 8, scope: !74)
!108 = !DILocation(line: 28, column: 5, scope: !74)
!109 = distinct !DISubprogram(name: "run", scope: !32, file: !32, line: 31, type: !75, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !77)
!110 = !DILocalVariable(name: "arg", arg: 1, scope: !109, file: !32, line: 31, type: !28)
!111 = !DILocation(line: 31, column: 17, scope: !109)
!112 = !DILocation(line: 33, column: 5, scope: !109)
!113 = !DILocation(line: 34, column: 5, scope: !109)
!114 = !DILocalVariable(name: "tindex", scope: !109, file: !32, line: 36, type: !38)
!115 = !DILocation(line: 36, column: 9, scope: !109)
!116 = !DILocation(line: 36, column: 30, scope: !109)
!117 = !DILocation(line: 36, column: 19, scope: !109)
!118 = !DILocation(line: 36, column: 18, scope: !109)
!119 = !DILocalVariable(name: "i", scope: !109, file: !32, line: 37, type: !38)
!120 = !DILocation(line: 37, column: 9, scope: !109)
!121 = !DILocation(line: 37, column: 16, scope: !109)
!122 = !DILocation(line: 38, column: 5, scope: !109)
!123 = !DILocation(line: 39, column: 15, scope: !109)
!124 = !DILocation(line: 39, column: 8, scope: !109)
!125 = !DILocation(line: 39, column: 5, scope: !109)
!126 = !DILocation(line: 39, column: 11, scope: !109)
!127 = !DILocation(line: 39, column: 13, scope: !109)
!128 = !DILocation(line: 40, column: 15, scope: !109)
!129 = !DILocation(line: 40, column: 8, scope: !109)
!130 = !DILocation(line: 40, column: 5, scope: !109)
!131 = !DILocation(line: 40, column: 11, scope: !109)
!132 = !DILocation(line: 40, column: 13, scope: !109)
!133 = !DILocation(line: 41, column: 26, scope: !109)
!134 = !DILocation(line: 41, column: 23, scope: !109)
!135 = !DILocation(line: 41, column: 29, scope: !109)
!136 = !DILocation(line: 41, column: 37, scope: !109)
!137 = !DILocation(line: 41, column: 34, scope: !109)
!138 = !DILocation(line: 41, column: 40, scope: !109)
!139 = !DILocation(line: 41, column: 31, scope: !109)
!140 = !DILocation(line: 41, column: 5, scope: !109)
!141 = !DILocation(line: 43, column: 8, scope: !109)
!142 = !DILocation(line: 45, column: 18, scope: !109)
!143 = !DILocation(line: 45, column: 5, scope: !109)
!144 = !DILocation(line: 47, column: 5, scope: !109)
!145 = distinct !DISubprogram(name: "main", scope: !32, file: !32, line: 50, type: !146, scopeLine: 51, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !77)
!146 = !DISubroutineType(types: !147)
!147 = !{!38}
!148 = !DILocalVariable(name: "t", scope: !145, file: !32, line: 52, type: !44)
!149 = !DILocation(line: 52, column: 15, scope: !145)
!150 = !DILocation(line: 53, column: 5, scope: !145)
!151 = !DILocation(line: 55, column: 5, scope: !145)
