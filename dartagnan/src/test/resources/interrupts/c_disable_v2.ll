; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/c_disable_v2.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/c_disable_v2.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct.A = type { i32, i32 }
%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@cnt = global i32 0, align 4, !dbg !0
@as = global [10 x %struct.A] zeroinitializer, align 4, !dbg !12
@h = global %struct._opaque_pthread_t* null, align 8, !dbg !24

; Function Attrs: noinline nounwind ssp uwtable
define i8* @handler(i8* noundef %0) #0 !dbg !60 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !64, metadata !DIExpression()), !dbg !65
  call void @llvm.dbg.declare(metadata i32* %3, metadata !66, metadata !DIExpression()), !dbg !67
  %5 = load i8*, i8** %2, align 8, !dbg !68
  %6 = ptrtoint i8* %5 to i64, !dbg !69
  %7 = trunc i64 %6 to i32, !dbg !70
  store i32 %7, i32* %3, align 4, !dbg !67
  call void @__VERIFIER_disable_irq(), !dbg !71
  call void @llvm.dbg.declare(metadata i32* %4, metadata !72, metadata !DIExpression()), !dbg !73
  %8 = load i32, i32* @cnt, align 4, !dbg !74
  %9 = add nsw i32 %8, 1, !dbg !74
  store i32 %9, i32* @cnt, align 4, !dbg !74
  store i32 %8, i32* %4, align 4, !dbg !73
  %10 = load i32, i32* %3, align 4, !dbg !75
  %11 = load i32, i32* %4, align 4, !dbg !76
  %12 = sext i32 %11 to i64, !dbg !77
  %13 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %12, !dbg !77
  %14 = getelementptr inbounds %struct.A, %struct.A* %13, i32 0, i32 0, !dbg !78
  store volatile i32 %10, i32* %14, align 4, !dbg !79
  %15 = load i32, i32* %3, align 4, !dbg !80
  %16 = load i32, i32* %4, align 4, !dbg !81
  %17 = sext i32 %16 to i64, !dbg !82
  %18 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %17, !dbg !82
  %19 = getelementptr inbounds %struct.A, %struct.A* %18, i32 0, i32 1, !dbg !83
  store volatile i32 %15, i32* %19, align 4, !dbg !84
  call void @__VERIFIER_enable_irq(), !dbg !85
  %20 = load i32, i32* %4, align 4, !dbg !86
  %21 = sext i32 %20 to i64, !dbg !87
  %22 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %21, !dbg !87
  %23 = getelementptr inbounds %struct.A, %struct.A* %22, i32 0, i32 0, !dbg !88
  %24 = load volatile i32, i32* %23, align 4, !dbg !88
  %25 = load i32, i32* %4, align 4, !dbg !89
  %26 = sext i32 %25 to i64, !dbg !90
  %27 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %26, !dbg !90
  %28 = getelementptr inbounds %struct.A, %struct.A* %27, i32 0, i32 1, !dbg !91
  %29 = load volatile i32, i32* %28, align 4, !dbg !91
  %30 = icmp eq i32 %24, %29, !dbg !92
  %31 = zext i1 %30 to i32, !dbg !92
  call void @__VERIFIER_assert(i32 noundef %31), !dbg !93
  ret i8* null, !dbg !94
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__VERIFIER_disable_irq() #2

declare void @__VERIFIER_enable_irq() #2

declare void @__VERIFIER_assert(i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i8* @run(i8* noundef %0) #0 !dbg !95 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !96, metadata !DIExpression()), !dbg !97
  call void @__VERIFIER_make_interrupt_handler(), !dbg !98
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef @h, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null), !dbg !99
  call void @llvm.dbg.declare(metadata i32* %3, metadata !100, metadata !DIExpression()), !dbg !101
  %6 = load i8*, i8** %2, align 8, !dbg !102
  %7 = ptrtoint i8* %6 to i64, !dbg !103
  %8 = trunc i64 %7 to i32, !dbg !104
  store i32 %8, i32* %3, align 4, !dbg !101
  call void @__VERIFIER_disable_irq(), !dbg !105
  call void @llvm.dbg.declare(metadata i32* %4, metadata !106, metadata !DIExpression()), !dbg !107
  %9 = load i32, i32* @cnt, align 4, !dbg !108
  %10 = add nsw i32 %9, 1, !dbg !108
  store i32 %10, i32* @cnt, align 4, !dbg !108
  store i32 %9, i32* %4, align 4, !dbg !107
  %11 = load i32, i32* %3, align 4, !dbg !109
  %12 = load i32, i32* %4, align 4, !dbg !110
  %13 = sext i32 %12 to i64, !dbg !111
  %14 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %13, !dbg !111
  %15 = getelementptr inbounds %struct.A, %struct.A* %14, i32 0, i32 0, !dbg !112
  store volatile i32 %11, i32* %15, align 4, !dbg !113
  %16 = load i32, i32* %3, align 4, !dbg !114
  %17 = load i32, i32* %4, align 4, !dbg !115
  %18 = sext i32 %17 to i64, !dbg !116
  %19 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %18, !dbg !116
  %20 = getelementptr inbounds %struct.A, %struct.A* %19, i32 0, i32 1, !dbg !117
  store volatile i32 %16, i32* %20, align 4, !dbg !118
  call void @__VERIFIER_enable_irq(), !dbg !119
  %21 = load i32, i32* %4, align 4, !dbg !120
  %22 = sext i32 %21 to i64, !dbg !121
  %23 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %22, !dbg !121
  %24 = getelementptr inbounds %struct.A, %struct.A* %23, i32 0, i32 0, !dbg !122
  %25 = load volatile i32, i32* %24, align 4, !dbg !122
  %26 = load i32, i32* %4, align 4, !dbg !123
  %27 = sext i32 %26 to i64, !dbg !124
  %28 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %27, !dbg !124
  %29 = getelementptr inbounds %struct.A, %struct.A* %28, i32 0, i32 1, !dbg !125
  %30 = load volatile i32, i32* %29, align 4, !dbg !125
  %31 = icmp eq i32 %25, %30, !dbg !126
  %32 = zext i1 %31 to i32, !dbg !126
  call void @__VERIFIER_assert(i32 noundef %32), !dbg !127
  %33 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** @h, align 8, !dbg !128
  %34 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %33, i8** noundef null), !dbg !129
  ret i8* null, !dbg !130
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef, i8** noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !131 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !134, metadata !DIExpression()), !dbg !135
  %3 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 1 to i8*)), !dbg !136
  ret i32 0, !dbg !137
}

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!49, !50, !51, !52, !53, !54, !55, !56, !57, !58}
!llvm.ident = !{!59}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "cnt", scope: !2, file: !14, line: 13, type: !20, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !11, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/c_disable_v2.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5, !10}
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !6, line: 32, baseType: !7)
!6 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_types/_intptr_t.h", directory: "")
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_intptr_t", file: !8, line: 27, baseType: !9)
!8 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/arm/_types.h", directory: "")
!9 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!11 = !{!0, !12, !24}
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "as", scope: !2, file: !14, line: 12, type: !15, isLocal: false, isDefinition: true)
!14 = !DIFile(filename: "benchmarks/interrupts/c_disable_v2.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !16, size: 640, elements: !22)
!16 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "A", file: !14, line: 11, size: 64, elements: !17)
!17 = !{!18, !21}
!18 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !16, file: !14, line: 11, baseType: !19, size: 32)
!19 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !20)
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !16, file: !14, line: 11, baseType: !19, size: 32, offset: 32)
!22 = !{!23}
!23 = !DISubrange(count: 10)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !14, line: 15, type: !26, isLocal: false, isDefinition: true)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !27, line: 31, baseType: !28)
!27 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !29, line: 118, baseType: !30)
!29 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
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
!52 = !{i32 1, !"branch-target-enforcement", i32 0}
!53 = !{i32 1, !"sign-return-address", i32 0}
!54 = !{i32 1, !"sign-return-address-all", i32 0}
!55 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!56 = !{i32 7, !"PIC Level", i32 2}
!57 = !{i32 7, !"uwtable", i32 1}
!58 = !{i32 7, !"frame-pointer", i32 1}
!59 = !{!"Homebrew clang version 14.0.6"}
!60 = distinct !DISubprogram(name: "handler", scope: !14, file: !14, line: 16, type: !61, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!61 = !DISubroutineType(types: !62)
!62 = !{!10, !10}
!63 = !{}
!64 = !DILocalVariable(name: "arg", arg: 1, scope: !60, file: !14, line: 16, type: !10)
!65 = !DILocation(line: 16, column: 21, scope: !60)
!66 = !DILocalVariable(name: "tindex", scope: !60, file: !14, line: 18, type: !20)
!67 = !DILocation(line: 18, column: 9, scope: !60)
!68 = !DILocation(line: 18, column: 30, scope: !60)
!69 = !DILocation(line: 18, column: 19, scope: !60)
!70 = !DILocation(line: 18, column: 18, scope: !60)
!71 = !DILocation(line: 19, column: 5, scope: !60)
!72 = !DILocalVariable(name: "i", scope: !60, file: !14, line: 20, type: !20)
!73 = !DILocation(line: 20, column: 9, scope: !60)
!74 = !DILocation(line: 20, column: 16, scope: !60)
!75 = !DILocation(line: 21, column: 15, scope: !60)
!76 = !DILocation(line: 21, column: 8, scope: !60)
!77 = !DILocation(line: 21, column: 5, scope: !60)
!78 = !DILocation(line: 21, column: 11, scope: !60)
!79 = !DILocation(line: 21, column: 13, scope: !60)
!80 = !DILocation(line: 22, column: 15, scope: !60)
!81 = !DILocation(line: 22, column: 8, scope: !60)
!82 = !DILocation(line: 22, column: 5, scope: !60)
!83 = !DILocation(line: 22, column: 11, scope: !60)
!84 = !DILocation(line: 22, column: 13, scope: !60)
!85 = !DILocation(line: 23, column: 5, scope: !60)
!86 = !DILocation(line: 24, column: 26, scope: !60)
!87 = !DILocation(line: 24, column: 23, scope: !60)
!88 = !DILocation(line: 24, column: 29, scope: !60)
!89 = !DILocation(line: 24, column: 37, scope: !60)
!90 = !DILocation(line: 24, column: 34, scope: !60)
!91 = !DILocation(line: 24, column: 40, scope: !60)
!92 = !DILocation(line: 24, column: 31, scope: !60)
!93 = !DILocation(line: 24, column: 5, scope: !60)
!94 = !DILocation(line: 26, column: 5, scope: !60)
!95 = distinct !DISubprogram(name: "run", scope: !14, file: !14, line: 29, type: !61, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!96 = !DILocalVariable(name: "arg", arg: 1, scope: !95, file: !14, line: 29, type: !10)
!97 = !DILocation(line: 29, column: 17, scope: !95)
!98 = !DILocation(line: 31, column: 5, scope: !95)
!99 = !DILocation(line: 32, column: 5, scope: !95)
!100 = !DILocalVariable(name: "tindex", scope: !95, file: !14, line: 34, type: !20)
!101 = !DILocation(line: 34, column: 9, scope: !95)
!102 = !DILocation(line: 34, column: 30, scope: !95)
!103 = !DILocation(line: 34, column: 19, scope: !95)
!104 = !DILocation(line: 34, column: 18, scope: !95)
!105 = !DILocation(line: 35, column: 5, scope: !95)
!106 = !DILocalVariable(name: "i", scope: !95, file: !14, line: 36, type: !20)
!107 = !DILocation(line: 36, column: 9, scope: !95)
!108 = !DILocation(line: 36, column: 16, scope: !95)
!109 = !DILocation(line: 37, column: 15, scope: !95)
!110 = !DILocation(line: 37, column: 8, scope: !95)
!111 = !DILocation(line: 37, column: 5, scope: !95)
!112 = !DILocation(line: 37, column: 11, scope: !95)
!113 = !DILocation(line: 37, column: 13, scope: !95)
!114 = !DILocation(line: 38, column: 15, scope: !95)
!115 = !DILocation(line: 38, column: 8, scope: !95)
!116 = !DILocation(line: 38, column: 5, scope: !95)
!117 = !DILocation(line: 38, column: 11, scope: !95)
!118 = !DILocation(line: 38, column: 13, scope: !95)
!119 = !DILocation(line: 39, column: 5, scope: !95)
!120 = !DILocation(line: 40, column: 26, scope: !95)
!121 = !DILocation(line: 40, column: 23, scope: !95)
!122 = !DILocation(line: 40, column: 29, scope: !95)
!123 = !DILocation(line: 40, column: 37, scope: !95)
!124 = !DILocation(line: 40, column: 34, scope: !95)
!125 = !DILocation(line: 40, column: 40, scope: !95)
!126 = !DILocation(line: 40, column: 31, scope: !95)
!127 = !DILocation(line: 40, column: 5, scope: !95)
!128 = !DILocation(line: 42, column: 18, scope: !95)
!129 = !DILocation(line: 42, column: 5, scope: !95)
!130 = !DILocation(line: 44, column: 5, scope: !95)
!131 = distinct !DISubprogram(name: "main", scope: !14, file: !14, line: 47, type: !132, scopeLine: 48, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!132 = !DISubroutineType(types: !133)
!133 = !{!20}
!134 = !DILocalVariable(name: "t", scope: !131, file: !14, line: 49, type: !26)
!135 = !DILocation(line: 49, column: 15, scope: !131)
!136 = !DILocation(line: 50, column: 5, scope: !131)
!137 = !DILocation(line: 52, column: 5, scope: !131)
