; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_with_disable_enable_as_barrier.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_with_disable_enable_as_barrier.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx15.0.0"

%struct.A = type { i32, i32 }

@cnt = global i32 0, align 4, !dbg !0
@as = global [10 x %struct.A] zeroinitializer, align 4, !dbg !12
@h = global ptr null, align 8, !dbg !24

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !56 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !60, metadata !DIExpression()), !dbg !61
  call void @llvm.dbg.declare(metadata ptr %3, metadata !62, metadata !DIExpression()), !dbg !63
  %5 = load ptr, ptr %2, align 8, !dbg !64
  %6 = ptrtoint ptr %5 to i64, !dbg !65
  %7 = trunc i64 %6 to i32, !dbg !66
  store i32 %7, ptr %3, align 4, !dbg !63
  call void @llvm.dbg.declare(metadata ptr %4, metadata !67, metadata !DIExpression()), !dbg !68
  %8 = load i32, ptr @cnt, align 4, !dbg !69
  %9 = add nsw i32 %8, 1, !dbg !69
  store i32 %9, ptr @cnt, align 4, !dbg !69
  store i32 %8, ptr %4, align 4, !dbg !68
  call void @__VERIFIER_disable_irq(), !dbg !70
  call void @__VERIFIER_enable_irq(), !dbg !71
  %10 = load i32, ptr %3, align 4, !dbg !72
  %11 = load i32, ptr %4, align 4, !dbg !73
  %12 = sext i32 %11 to i64, !dbg !74
  %13 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %12, !dbg !74
  %14 = getelementptr inbounds %struct.A, ptr %13, i32 0, i32 0, !dbg !75
  store volatile i32 %10, ptr %14, align 4, !dbg !76
  %15 = load i32, ptr %3, align 4, !dbg !77
  %16 = load i32, ptr %4, align 4, !dbg !78
  %17 = sext i32 %16 to i64, !dbg !79
  %18 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %17, !dbg !79
  %19 = getelementptr inbounds %struct.A, ptr %18, i32 0, i32 1, !dbg !80
  store volatile i32 %15, ptr %19, align 4, !dbg !81
  %20 = load i32, ptr %4, align 4, !dbg !82
  %21 = sext i32 %20 to i64, !dbg !83
  %22 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %21, !dbg !83
  %23 = getelementptr inbounds %struct.A, ptr %22, i32 0, i32 0, !dbg !84
  %24 = load volatile i32, ptr %23, align 4, !dbg !84
  %25 = load i32, ptr %4, align 4, !dbg !85
  %26 = sext i32 %25 to i64, !dbg !86
  %27 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %26, !dbg !86
  %28 = getelementptr inbounds %struct.A, ptr %27, i32 0, i32 1, !dbg !87
  %29 = load volatile i32, ptr %28, align 4, !dbg !87
  %30 = icmp eq i32 %24, %29, !dbg !88
  %31 = zext i1 %30 to i32, !dbg !88
  call void @__VERIFIER_assert(i32 noundef %31), !dbg !89
  ret ptr null, !dbg !90
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__VERIFIER_disable_irq() #2

declare void @__VERIFIER_enable_irq() #2

declare void @__VERIFIER_assert(i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 !dbg !91 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !92, metadata !DIExpression()), !dbg !93
  call void @__VERIFIER_make_interrupt_handler(), !dbg !94
  %5 = call i32 @pthread_create(ptr noundef @h, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !95
  call void @llvm.dbg.declare(metadata ptr %3, metadata !96, metadata !DIExpression()), !dbg !97
  %6 = load ptr, ptr %2, align 8, !dbg !98
  %7 = ptrtoint ptr %6 to i64, !dbg !99
  %8 = trunc i64 %7 to i32, !dbg !100
  store i32 %8, ptr %3, align 4, !dbg !97
  call void @llvm.dbg.declare(metadata ptr %4, metadata !101, metadata !DIExpression()), !dbg !102
  %9 = load i32, ptr @cnt, align 4, !dbg !103
  %10 = add nsw i32 %9, 1, !dbg !103
  store i32 %10, ptr @cnt, align 4, !dbg !103
  store i32 %9, ptr %4, align 4, !dbg !102
  call void @__VERIFIER_disable_irq(), !dbg !104
  call void @__VERIFIER_enable_irq(), !dbg !105
  %11 = load i32, ptr %3, align 4, !dbg !106
  %12 = load i32, ptr %4, align 4, !dbg !107
  %13 = sext i32 %12 to i64, !dbg !108
  %14 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %13, !dbg !108
  %15 = getelementptr inbounds %struct.A, ptr %14, i32 0, i32 0, !dbg !109
  store volatile i32 %11, ptr %15, align 4, !dbg !110
  %16 = load i32, ptr %3, align 4, !dbg !111
  %17 = load i32, ptr %4, align 4, !dbg !112
  %18 = sext i32 %17 to i64, !dbg !113
  %19 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %18, !dbg !113
  %20 = getelementptr inbounds %struct.A, ptr %19, i32 0, i32 1, !dbg !114
  store volatile i32 %16, ptr %20, align 4, !dbg !115
  %21 = load i32, ptr %4, align 4, !dbg !116
  %22 = sext i32 %21 to i64, !dbg !117
  %23 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %22, !dbg !117
  %24 = getelementptr inbounds %struct.A, ptr %23, i32 0, i32 0, !dbg !118
  %25 = load volatile i32, ptr %24, align 4, !dbg !118
  %26 = load i32, ptr %4, align 4, !dbg !119
  %27 = sext i32 %26 to i64, !dbg !120
  %28 = getelementptr inbounds [10 x %struct.A], ptr @as, i64 0, i64 %27, !dbg !120
  %29 = getelementptr inbounds %struct.A, ptr %28, i32 0, i32 1, !dbg !121
  %30 = load volatile i32, ptr %29, align 4, !dbg !121
  %31 = icmp eq i32 %25, %30, !dbg !122
  %32 = zext i1 %31 to i32, !dbg !122
  call void @__VERIFIER_assert(i32 noundef %32), !dbg !123
  %33 = load ptr, ptr @h, align 8, !dbg !124
  %34 = call i32 @"\01_pthread_join"(ptr noundef %33, ptr noundef null), !dbg !125
  ret ptr null, !dbg !126
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !127 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !130, metadata !DIExpression()), !dbg !131
  %3 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @run, ptr noundef inttoptr (i64 1 to ptr)), !dbg !132
  ret i32 0, !dbg !133
}

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!49, !50, !51, !52, !53, !54}
!llvm.ident = !{!55}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "cnt", scope: !2, file: !14, line: 14, type: !20, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 16.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !11, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_with_disable_enable_as_barrier.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5, !10}
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !6, line: 32, baseType: !7)
!6 = !DIFile(filename: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/_types/_intptr_t.h", directory: "")
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_intptr_t", file: !8, line: 40, baseType: !9)
!8 = !DIFile(filename: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/arm/_types.h", directory: "")
!9 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!11 = !{!0, !12, !24}
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "as", scope: !2, file: !14, line: 13, type: !15, isLocal: false, isDefinition: true)
!14 = !DIFile(filename: "benchmarks/interrupts/lkmm_with_disable_enable_as_barrier.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !16, size: 640, elements: !22)
!16 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "A", file: !14, line: 12, size: 64, elements: !17)
!17 = !{!18, !21}
!18 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !16, file: !14, line: 12, baseType: !19, size: 32)
!19 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !20)
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !16, file: !14, line: 12, baseType: !19, size: 32, offset: 32)
!22 = !{!23}
!23 = !DISubrange(count: 10)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !14, line: 16, type: !26, isLocal: false, isDefinition: true)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !27, line: 31, baseType: !28)
!27 = !DIFile(filename: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !29, line: 118, baseType: !30)
!29 = !DIFile(filename: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !29, line: 103, size: 65536, elements: !32)
!32 = !{!33, !34, !44}
!33 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !31, file: !29, line: 104, baseType: !9, size: 64)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !31, file: !29, line: 105, baseType: !35, size: 64, offset: 64)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !36, size: 64)
!36 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !29, line: 57, size: 192, elements: !37)
!37 = !{!38, !42, !43}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !36, file: !29, line: 58, baseType: !39, size: 64)
!39 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!40 = !DISubroutineType(types: !41)
!41 = !{null, !10}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !36, file: !29, line: 59, baseType: !10, size: 64, offset: 64)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !36, file: !29, line: 60, baseType: !35, size: 64, offset: 128)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !31, file: !29, line: 106, baseType: !45, size: 65408, offset: 128)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 65408, elements: !47)
!46 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!47 = !{!48}
!48 = !DISubrange(count: 8176)
!49 = !{i32 7, !"Dwarf Version", i32 4}
!50 = !{i32 2, !"Debug Info Version", i32 3}
!51 = !{i32 1, !"wchar_size", i32 4}
!52 = !{i32 8, !"PIC Level", i32 2}
!53 = !{i32 7, !"uwtable", i32 1}
!54 = !{i32 7, !"frame-pointer", i32 1}
!55 = !{!"Homebrew clang version 16.0.6"}
!56 = distinct !DISubprogram(name: "handler", scope: !14, file: !14, line: 17, type: !57, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !59)
!57 = !DISubroutineType(types: !58)
!58 = !{!10, !10}
!59 = !{}
!60 = !DILocalVariable(name: "arg", arg: 1, scope: !56, file: !14, line: 17, type: !10)
!61 = !DILocation(line: 17, column: 21, scope: !56)
!62 = !DILocalVariable(name: "tindex", scope: !56, file: !14, line: 19, type: !20)
!63 = !DILocation(line: 19, column: 9, scope: !56)
!64 = !DILocation(line: 19, column: 30, scope: !56)
!65 = !DILocation(line: 19, column: 19, scope: !56)
!66 = !DILocation(line: 19, column: 18, scope: !56)
!67 = !DILocalVariable(name: "i", scope: !56, file: !14, line: 20, type: !20)
!68 = !DILocation(line: 20, column: 9, scope: !56)
!69 = !DILocation(line: 20, column: 16, scope: !56)
!70 = !DILocation(line: 21, column: 5, scope: !56)
!71 = !DILocation(line: 22, column: 5, scope: !56)
!72 = !DILocation(line: 23, column: 15, scope: !56)
!73 = !DILocation(line: 23, column: 8, scope: !56)
!74 = !DILocation(line: 23, column: 5, scope: !56)
!75 = !DILocation(line: 23, column: 11, scope: !56)
!76 = !DILocation(line: 23, column: 13, scope: !56)
!77 = !DILocation(line: 24, column: 15, scope: !56)
!78 = !DILocation(line: 24, column: 8, scope: !56)
!79 = !DILocation(line: 24, column: 5, scope: !56)
!80 = !DILocation(line: 24, column: 11, scope: !56)
!81 = !DILocation(line: 24, column: 13, scope: !56)
!82 = !DILocation(line: 25, column: 26, scope: !56)
!83 = !DILocation(line: 25, column: 23, scope: !56)
!84 = !DILocation(line: 25, column: 29, scope: !56)
!85 = !DILocation(line: 25, column: 37, scope: !56)
!86 = !DILocation(line: 25, column: 34, scope: !56)
!87 = !DILocation(line: 25, column: 40, scope: !56)
!88 = !DILocation(line: 25, column: 31, scope: !56)
!89 = !DILocation(line: 25, column: 5, scope: !56)
!90 = !DILocation(line: 27, column: 5, scope: !56)
!91 = distinct !DISubprogram(name: "run", scope: !14, file: !14, line: 30, type: !57, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !59)
!92 = !DILocalVariable(name: "arg", arg: 1, scope: !91, file: !14, line: 30, type: !10)
!93 = !DILocation(line: 30, column: 17, scope: !91)
!94 = !DILocation(line: 32, column: 5, scope: !91)
!95 = !DILocation(line: 33, column: 5, scope: !91)
!96 = !DILocalVariable(name: "tindex", scope: !91, file: !14, line: 35, type: !20)
!97 = !DILocation(line: 35, column: 9, scope: !91)
!98 = !DILocation(line: 35, column: 30, scope: !91)
!99 = !DILocation(line: 35, column: 19, scope: !91)
!100 = !DILocation(line: 35, column: 18, scope: !91)
!101 = !DILocalVariable(name: "i", scope: !91, file: !14, line: 36, type: !20)
!102 = !DILocation(line: 36, column: 9, scope: !91)
!103 = !DILocation(line: 36, column: 16, scope: !91)
!104 = !DILocation(line: 37, column: 5, scope: !91)
!105 = !DILocation(line: 38, column: 5, scope: !91)
!106 = !DILocation(line: 39, column: 15, scope: !91)
!107 = !DILocation(line: 39, column: 8, scope: !91)
!108 = !DILocation(line: 39, column: 5, scope: !91)
!109 = !DILocation(line: 39, column: 11, scope: !91)
!110 = !DILocation(line: 39, column: 13, scope: !91)
!111 = !DILocation(line: 40, column: 15, scope: !91)
!112 = !DILocation(line: 40, column: 8, scope: !91)
!113 = !DILocation(line: 40, column: 5, scope: !91)
!114 = !DILocation(line: 40, column: 11, scope: !91)
!115 = !DILocation(line: 40, column: 13, scope: !91)
!116 = !DILocation(line: 41, column: 26, scope: !91)
!117 = !DILocation(line: 41, column: 23, scope: !91)
!118 = !DILocation(line: 41, column: 29, scope: !91)
!119 = !DILocation(line: 41, column: 37, scope: !91)
!120 = !DILocation(line: 41, column: 34, scope: !91)
!121 = !DILocation(line: 41, column: 40, scope: !91)
!122 = !DILocation(line: 41, column: 31, scope: !91)
!123 = !DILocation(line: 41, column: 5, scope: !91)
!124 = !DILocation(line: 43, column: 18, scope: !91)
!125 = !DILocation(line: 43, column: 5, scope: !91)
!126 = !DILocation(line: 45, column: 5, scope: !91)
!127 = distinct !DISubprogram(name: "main", scope: !14, file: !14, line: 48, type: !128, scopeLine: 49, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !59)
!128 = !DISubroutineType(types: !129)
!129 = !{!20}
!130 = !DILocalVariable(name: "t", scope: !127, file: !14, line: 50, type: !26)
!131 = !DILocation(line: 50, column: 15, scope: !127)
!132 = !DILocation(line: 51, column: 5, scope: !127)
!133 = !DILocation(line: 53, column: 5, scope: !127)
