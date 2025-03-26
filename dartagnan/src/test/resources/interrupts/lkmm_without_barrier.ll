; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_without_barrier.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_without_barrier.c"
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
  call void @llvm.dbg.declare(metadata i32* %4, metadata !71, metadata !DIExpression()), !dbg !72
  %8 = load i32, i32* @cnt, align 4, !dbg !73
  %9 = add nsw i32 %8, 1, !dbg !73
  store i32 %9, i32* @cnt, align 4, !dbg !73
  store i32 %8, i32* %4, align 4, !dbg !72
  %10 = load i32, i32* %3, align 4, !dbg !74
  %11 = load i32, i32* %4, align 4, !dbg !75
  %12 = sext i32 %11 to i64, !dbg !76
  %13 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %12, !dbg !76
  %14 = getelementptr inbounds %struct.A, %struct.A* %13, i32 0, i32 0, !dbg !77
  store volatile i32 %10, i32* %14, align 4, !dbg !78
  %15 = load i32, i32* %3, align 4, !dbg !79
  %16 = load i32, i32* %4, align 4, !dbg !80
  %17 = sext i32 %16 to i64, !dbg !81
  %18 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %17, !dbg !81
  %19 = getelementptr inbounds %struct.A, %struct.A* %18, i32 0, i32 1, !dbg !82
  store volatile i32 %15, i32* %19, align 4, !dbg !83
  %20 = load i32, i32* %4, align 4, !dbg !84
  %21 = sext i32 %20 to i64, !dbg !85
  %22 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %21, !dbg !85
  %23 = getelementptr inbounds %struct.A, %struct.A* %22, i32 0, i32 0, !dbg !86
  %24 = load volatile i32, i32* %23, align 4, !dbg !86
  %25 = load i32, i32* %4, align 4, !dbg !87
  %26 = sext i32 %25 to i64, !dbg !88
  %27 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %26, !dbg !88
  %28 = getelementptr inbounds %struct.A, %struct.A* %27, i32 0, i32 1, !dbg !89
  %29 = load volatile i32, i32* %28, align 4, !dbg !89
  %30 = icmp eq i32 %24, %29, !dbg !90
  %31 = zext i1 %30 to i32, !dbg !90
  call void @__VERIFIER_assert(i32 noundef %31), !dbg !91
  ret i8* null, !dbg !92
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__VERIFIER_assert(i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i8* @run(i8* noundef %0) #0 !dbg !93 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !94, metadata !DIExpression()), !dbg !95
  call void @__VERIFIER_make_interrupt_handler(), !dbg !96
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef @h, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null), !dbg !97
  call void @llvm.dbg.declare(metadata i32* %3, metadata !98, metadata !DIExpression()), !dbg !99
  %6 = load i8*, i8** %2, align 8, !dbg !100
  %7 = ptrtoint i8* %6 to i64, !dbg !101
  %8 = trunc i64 %7 to i32, !dbg !102
  store i32 %8, i32* %3, align 4, !dbg !99
  call void @llvm.dbg.declare(metadata i32* %4, metadata !103, metadata !DIExpression()), !dbg !104
  %9 = load i32, i32* @cnt, align 4, !dbg !105
  %10 = add nsw i32 %9, 1, !dbg !105
  store i32 %10, i32* @cnt, align 4, !dbg !105
  store i32 %9, i32* %4, align 4, !dbg !104
  %11 = load i32, i32* %3, align 4, !dbg !106
  %12 = load i32, i32* %4, align 4, !dbg !107
  %13 = sext i32 %12 to i64, !dbg !108
  %14 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %13, !dbg !108
  %15 = getelementptr inbounds %struct.A, %struct.A* %14, i32 0, i32 0, !dbg !109
  store volatile i32 %11, i32* %15, align 4, !dbg !110
  %16 = load i32, i32* %3, align 4, !dbg !111
  %17 = load i32, i32* %4, align 4, !dbg !112
  %18 = sext i32 %17 to i64, !dbg !113
  %19 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %18, !dbg !113
  %20 = getelementptr inbounds %struct.A, %struct.A* %19, i32 0, i32 1, !dbg !114
  store volatile i32 %16, i32* %20, align 4, !dbg !115
  %21 = load i32, i32* %4, align 4, !dbg !116
  %22 = sext i32 %21 to i64, !dbg !117
  %23 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %22, !dbg !117
  %24 = getelementptr inbounds %struct.A, %struct.A* %23, i32 0, i32 0, !dbg !118
  %25 = load volatile i32, i32* %24, align 4, !dbg !118
  %26 = load i32, i32* %4, align 4, !dbg !119
  %27 = sext i32 %26 to i64, !dbg !120
  %28 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %27, !dbg !120
  %29 = getelementptr inbounds %struct.A, %struct.A* %28, i32 0, i32 1, !dbg !121
  %30 = load volatile i32, i32* %29, align 4, !dbg !121
  %31 = icmp eq i32 %25, %30, !dbg !122
  %32 = zext i1 %31 to i32, !dbg !122
  call void @__VERIFIER_assert(i32 noundef %32), !dbg !123
  %33 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** @h, align 8, !dbg !124
  %34 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %33, i8** noundef null), !dbg !125
  ret i8* null, !dbg !126
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef, i8** noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !127 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !130, metadata !DIExpression()), !dbg !131
  %3 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 1 to i8*)), !dbg !132
  ret i32 0, !dbg !133
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
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_without_barrier.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
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
!14 = !DIFile(filename: "benchmarks/interrupts/lkmm_without_barrier.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
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
!71 = !DILocalVariable(name: "i", scope: !60, file: !14, line: 19, type: !20)
!72 = !DILocation(line: 19, column: 9, scope: !60)
!73 = !DILocation(line: 19, column: 16, scope: !60)
!74 = !DILocation(line: 20, column: 15, scope: !60)
!75 = !DILocation(line: 20, column: 8, scope: !60)
!76 = !DILocation(line: 20, column: 5, scope: !60)
!77 = !DILocation(line: 20, column: 11, scope: !60)
!78 = !DILocation(line: 20, column: 13, scope: !60)
!79 = !DILocation(line: 21, column: 15, scope: !60)
!80 = !DILocation(line: 21, column: 8, scope: !60)
!81 = !DILocation(line: 21, column: 5, scope: !60)
!82 = !DILocation(line: 21, column: 11, scope: !60)
!83 = !DILocation(line: 21, column: 13, scope: !60)
!84 = !DILocation(line: 22, column: 26, scope: !60)
!85 = !DILocation(line: 22, column: 23, scope: !60)
!86 = !DILocation(line: 22, column: 29, scope: !60)
!87 = !DILocation(line: 22, column: 37, scope: !60)
!88 = !DILocation(line: 22, column: 34, scope: !60)
!89 = !DILocation(line: 22, column: 40, scope: !60)
!90 = !DILocation(line: 22, column: 31, scope: !60)
!91 = !DILocation(line: 22, column: 5, scope: !60)
!92 = !DILocation(line: 24, column: 5, scope: !60)
!93 = distinct !DISubprogram(name: "run", scope: !14, file: !14, line: 27, type: !61, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!94 = !DILocalVariable(name: "arg", arg: 1, scope: !93, file: !14, line: 27, type: !10)
!95 = !DILocation(line: 27, column: 17, scope: !93)
!96 = !DILocation(line: 29, column: 5, scope: !93)
!97 = !DILocation(line: 30, column: 5, scope: !93)
!98 = !DILocalVariable(name: "tindex", scope: !93, file: !14, line: 32, type: !20)
!99 = !DILocation(line: 32, column: 9, scope: !93)
!100 = !DILocation(line: 32, column: 30, scope: !93)
!101 = !DILocation(line: 32, column: 19, scope: !93)
!102 = !DILocation(line: 32, column: 18, scope: !93)
!103 = !DILocalVariable(name: "i", scope: !93, file: !14, line: 33, type: !20)
!104 = !DILocation(line: 33, column: 9, scope: !93)
!105 = !DILocation(line: 33, column: 16, scope: !93)
!106 = !DILocation(line: 34, column: 15, scope: !93)
!107 = !DILocation(line: 34, column: 8, scope: !93)
!108 = !DILocation(line: 34, column: 5, scope: !93)
!109 = !DILocation(line: 34, column: 11, scope: !93)
!110 = !DILocation(line: 34, column: 13, scope: !93)
!111 = !DILocation(line: 35, column: 15, scope: !93)
!112 = !DILocation(line: 35, column: 8, scope: !93)
!113 = !DILocation(line: 35, column: 5, scope: !93)
!114 = !DILocation(line: 35, column: 11, scope: !93)
!115 = !DILocation(line: 35, column: 13, scope: !93)
!116 = !DILocation(line: 36, column: 26, scope: !93)
!117 = !DILocation(line: 36, column: 23, scope: !93)
!118 = !DILocation(line: 36, column: 29, scope: !93)
!119 = !DILocation(line: 36, column: 37, scope: !93)
!120 = !DILocation(line: 36, column: 34, scope: !93)
!121 = !DILocation(line: 36, column: 40, scope: !93)
!122 = !DILocation(line: 36, column: 31, scope: !93)
!123 = !DILocation(line: 36, column: 5, scope: !93)
!124 = !DILocation(line: 38, column: 18, scope: !93)
!125 = !DILocation(line: 38, column: 5, scope: !93)
!126 = !DILocation(line: 40, column: 5, scope: !93)
!127 = distinct !DISubprogram(name: "main", scope: !14, file: !14, line: 43, type: !128, scopeLine: 44, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!128 = !DISubroutineType(types: !129)
!129 = !{!20}
!130 = !DILocalVariable(name: "t", scope: !127, file: !14, line: 45, type: !26)
!131 = !DILocation(line: 45, column: 15, scope: !127)
!132 = !DILocation(line: 46, column: 5, scope: !127)
!133 = !DILocation(line: 48, column: 5, scope: !127)
