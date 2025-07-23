; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/c11_with_barrier_inc_split.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/c11_with_barrier_inc_split.c"
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
  call void @__VERIFIER_make_cb(), !dbg !74
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
  %20 = load i32, i32* %4, align 4, !dbg !85
  %21 = sext i32 %20 to i64, !dbg !86
  %22 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %21, !dbg !86
  %23 = getelementptr inbounds %struct.A, %struct.A* %22, i32 0, i32 0, !dbg !87
  %24 = load volatile i32, i32* %23, align 4, !dbg !87
  %25 = load i32, i32* %4, align 4, !dbg !88
  %26 = sext i32 %25 to i64, !dbg !89
  %27 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %26, !dbg !89
  %28 = getelementptr inbounds %struct.A, %struct.A* %27, i32 0, i32 1, !dbg !90
  %29 = load volatile i32, i32* %28, align 4, !dbg !90
  %30 = icmp eq i32 %24, %29, !dbg !91
  %31 = zext i1 %30 to i32, !dbg !91
  call void @__VERIFIER_assert(i32 noundef %31), !dbg !92
  ret i8* null, !dbg !93
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__VERIFIER_make_cb() #2

declare void @__VERIFIER_assert(i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i8* @run(i8* noundef %0) #0 !dbg !94 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !95, metadata !DIExpression()), !dbg !96
  call void @__VERIFIER_make_interrupt_handler(), !dbg !97
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef @h, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null), !dbg !98
  call void @llvm.dbg.declare(metadata i32* %3, metadata !99, metadata !DIExpression()), !dbg !100
  %6 = load i8*, i8** %2, align 8, !dbg !101
  %7 = ptrtoint i8* %6 to i64, !dbg !102
  %8 = trunc i64 %7 to i32, !dbg !103
  store i32 %8, i32* %3, align 4, !dbg !100
  call void @llvm.dbg.declare(metadata i32* %4, metadata !104, metadata !DIExpression()), !dbg !105
  %9 = load i32, i32* @cnt, align 4, !dbg !106
  store i32 %9, i32* %4, align 4, !dbg !105
  call void @__VERIFIER_make_cb(), !dbg !107
  %10 = load i32, i32* %4, align 4, !dbg !108
  %11 = add nsw i32 %10, 1, !dbg !109
  store i32 %11, i32* @cnt, align 4, !dbg !110
  %12 = load i32, i32* %3, align 4, !dbg !111
  %13 = load i32, i32* %4, align 4, !dbg !112
  %14 = sext i32 %13 to i64, !dbg !113
  %15 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %14, !dbg !113
  %16 = getelementptr inbounds %struct.A, %struct.A* %15, i32 0, i32 0, !dbg !114
  store volatile i32 %12, i32* %16, align 4, !dbg !115
  %17 = load i32, i32* %3, align 4, !dbg !116
  %18 = load i32, i32* %4, align 4, !dbg !117
  %19 = sext i32 %18 to i64, !dbg !118
  %20 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %19, !dbg !118
  %21 = getelementptr inbounds %struct.A, %struct.A* %20, i32 0, i32 1, !dbg !119
  store volatile i32 %17, i32* %21, align 4, !dbg !120
  %22 = load i32, i32* %4, align 4, !dbg !121
  %23 = sext i32 %22 to i64, !dbg !122
  %24 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %23, !dbg !122
  %25 = getelementptr inbounds %struct.A, %struct.A* %24, i32 0, i32 0, !dbg !123
  %26 = load volatile i32, i32* %25, align 4, !dbg !123
  %27 = load i32, i32* %4, align 4, !dbg !124
  %28 = sext i32 %27 to i64, !dbg !125
  %29 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %28, !dbg !125
  %30 = getelementptr inbounds %struct.A, %struct.A* %29, i32 0, i32 1, !dbg !126
  %31 = load volatile i32, i32* %30, align 4, !dbg !126
  %32 = icmp eq i32 %26, %31, !dbg !127
  %33 = zext i1 %32 to i32, !dbg !127
  call void @__VERIFIER_assert(i32 noundef %33), !dbg !128
  %34 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** @h, align 8, !dbg !129
  %35 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %34, i8** noundef null), !dbg !130
  ret i8* null, !dbg !131
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef, i8** noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !132 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !135, metadata !DIExpression()), !dbg !136
  %3 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 1 to i8*)), !dbg !137
  ret i32 0, !dbg !138
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
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/c11_with_barrier_inc_split.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
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
!14 = !DIFile(filename: "benchmarks/interrupts/c11_with_barrier_inc_split.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
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
!74 = !DILocation(line: 20, column: 5, scope: !60)
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
!85 = !DILocation(line: 23, column: 26, scope: !60)
!86 = !DILocation(line: 23, column: 23, scope: !60)
!87 = !DILocation(line: 23, column: 29, scope: !60)
!88 = !DILocation(line: 23, column: 37, scope: !60)
!89 = !DILocation(line: 23, column: 34, scope: !60)
!90 = !DILocation(line: 23, column: 40, scope: !60)
!91 = !DILocation(line: 23, column: 31, scope: !60)
!92 = !DILocation(line: 23, column: 5, scope: !60)
!93 = !DILocation(line: 25, column: 5, scope: !60)
!94 = distinct !DISubprogram(name: "run", scope: !14, file: !14, line: 28, type: !61, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!95 = !DILocalVariable(name: "arg", arg: 1, scope: !94, file: !14, line: 28, type: !10)
!96 = !DILocation(line: 28, column: 17, scope: !94)
!97 = !DILocation(line: 30, column: 5, scope: !94)
!98 = !DILocation(line: 31, column: 5, scope: !94)
!99 = !DILocalVariable(name: "tindex", scope: !94, file: !14, line: 33, type: !20)
!100 = !DILocation(line: 33, column: 9, scope: !94)
!101 = !DILocation(line: 33, column: 30, scope: !94)
!102 = !DILocation(line: 33, column: 19, scope: !94)
!103 = !DILocation(line: 33, column: 18, scope: !94)
!104 = !DILocalVariable(name: "i", scope: !94, file: !14, line: 34, type: !20)
!105 = !DILocation(line: 34, column: 9, scope: !94)
!106 = !DILocation(line: 34, column: 13, scope: !94)
!107 = !DILocation(line: 35, column: 5, scope: !94)
!108 = !DILocation(line: 36, column: 11, scope: !94)
!109 = !DILocation(line: 36, column: 12, scope: !94)
!110 = !DILocation(line: 36, column: 9, scope: !94)
!111 = !DILocation(line: 37, column: 15, scope: !94)
!112 = !DILocation(line: 37, column: 8, scope: !94)
!113 = !DILocation(line: 37, column: 5, scope: !94)
!114 = !DILocation(line: 37, column: 11, scope: !94)
!115 = !DILocation(line: 37, column: 13, scope: !94)
!116 = !DILocation(line: 38, column: 15, scope: !94)
!117 = !DILocation(line: 38, column: 8, scope: !94)
!118 = !DILocation(line: 38, column: 5, scope: !94)
!119 = !DILocation(line: 38, column: 11, scope: !94)
!120 = !DILocation(line: 38, column: 13, scope: !94)
!121 = !DILocation(line: 39, column: 26, scope: !94)
!122 = !DILocation(line: 39, column: 23, scope: !94)
!123 = !DILocation(line: 39, column: 29, scope: !94)
!124 = !DILocation(line: 39, column: 37, scope: !94)
!125 = !DILocation(line: 39, column: 34, scope: !94)
!126 = !DILocation(line: 39, column: 40, scope: !94)
!127 = !DILocation(line: 39, column: 31, scope: !94)
!128 = !DILocation(line: 39, column: 5, scope: !94)
!129 = !DILocation(line: 41, column: 18, scope: !94)
!130 = !DILocation(line: 41, column: 5, scope: !94)
!131 = !DILocation(line: 43, column: 5, scope: !94)
!132 = distinct !DISubprogram(name: "main", scope: !14, file: !14, line: 46, type: !133, scopeLine: 47, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!133 = !DISubroutineType(types: !134)
!134 = !{!20}
!135 = !DILocalVariable(name: "t", scope: !132, file: !14, line: 48, type: !26)
!136 = !DILocation(line: 48, column: 15, scope: !132)
!137 = !DILocation(line: 49, column: 5, scope: !132)
!138 = !DILocation(line: 51, column: 5, scope: !132)
