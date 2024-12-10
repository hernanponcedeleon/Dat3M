; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_weak.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_weak.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@x = global i32 0, align 4, !dbg !0
@signal = global i32 0, align 4, !dbg !18
@success = global i32 0, align 4, !dbg !24
@sendAgain = global i32 0, align 4, !dbg !26

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread(i8* noundef %0) #0 !dbg !40 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !44, metadata !DIExpression()), !dbg !45
  br label %4, !dbg !46

4:                                                ; preds = %1, %24
  store volatile i32 1, i32* @x, align 4, !dbg !47
  store i32 1, i32* %3, align 4, !dbg !49
  %5 = load i32, i32* %3, align 4, !dbg !49
  store atomic i32 %5, i32* @signal monotonic, align 4, !dbg !49
  br label %6, !dbg !50

6:                                                ; preds = %15, %4
  %7 = load atomic i32, i32* @sendAgain seq_cst, align 4, !dbg !51
  %8 = icmp ne i32 %7, 0, !dbg !51
  br i1 %8, label %13, label %9, !dbg !52

9:                                                ; preds = %6
  %10 = load atomic i32, i32* @success seq_cst, align 4, !dbg !53
  %11 = icmp ne i32 %10, 0, !dbg !54
  %12 = xor i1 %11, true, !dbg !54
  br label %13

13:                                               ; preds = %9, %6
  %14 = phi i1 [ false, %6 ], [ %12, %9 ], !dbg !55
  br i1 %14, label %15, label %16, !dbg !50

15:                                               ; preds = %13
  br label %6, !dbg !50, !llvm.loop !56

16:                                               ; preds = %13
  %17 = load atomic i32, i32* @sendAgain seq_cst, align 4, !dbg !59
  %18 = icmp ne i32 %17, 0, !dbg !59
  br i1 %18, label %19, label %20, !dbg !61

19:                                               ; preds = %16
  store volatile i32 0, i32* @x, align 4, !dbg !62
  store atomic i32 0, i32* @sendAgain seq_cst, align 4, !dbg !64
  br label %20, !dbg !65

20:                                               ; preds = %19, %16
  %21 = load atomic i32, i32* @success seq_cst, align 4, !dbg !66
  %22 = icmp ne i32 %21, 0, !dbg !66
  br i1 %22, label %23, label %24, !dbg !68

23:                                               ; preds = %20
  br label %25, !dbg !69

24:                                               ; preds = %20
  br label %4, !dbg !46, !llvm.loop !70

25:                                               ; preds = %23
  ret i8* null, !dbg !72
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread2(i8* noundef %0) #0 !dbg !73 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !74, metadata !DIExpression()), !dbg !75
  br label %4, !dbg !76

4:                                                ; preds = %13, %1
  %5 = load atomic i32, i32* @signal monotonic, align 4, !dbg !77
  store i32 %5, i32* %3, align 4, !dbg !77
  %6 = load i32, i32* %3, align 4, !dbg !77
  %7 = icmp eq i32 %6, 1, !dbg !78
  br i1 %7, label %8, label %11, !dbg !79

8:                                                ; preds = %4
  %9 = load volatile i32, i32* @x, align 4, !dbg !80
  %10 = icmp eq i32 %9, 0, !dbg !81
  br label %11

11:                                               ; preds = %8, %4
  %12 = phi i1 [ false, %4 ], [ %10, %8 ], !dbg !82
  br i1 %12, label %13, label %14, !dbg !76

13:                                               ; preds = %11
  store atomic i32 0, i32* @signal seq_cst, align 4, !dbg !83
  store atomic i32 1, i32* @sendAgain seq_cst, align 4, !dbg !85
  br label %4, !dbg !76, !llvm.loop !86

14:                                               ; preds = %11
  store atomic i32 1, i32* @success seq_cst, align 4, !dbg !88
  ret i8* null, !dbg !89
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !90 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !93, metadata !DIExpression()), !dbg !118
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !119, metadata !DIExpression()), !dbg !120
  %4 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef null), !dbg !121
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread2, i8* noundef null), !dbg !122
  ret i32 0, !dbg !123
}

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!29, !30, !31, !32, !33, !34, !35, !36, !37, !38}
!llvm.ident = !{!39}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !20, line: 9, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_weak.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 56, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/opt/homebrew/Cellar/llvm@14/14.0.6/lib/clang/14.0.6/include/stdatomic.h", directory: "")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !{!0, !18, !24, !26}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "signal", scope: !2, file: !20, line: 10, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/nontermination/nontermination_weak.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "success", scope: !2, file: !20, line: 11, type: !21, isLocal: false, isDefinition: true)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "sendAgain", scope: !2, file: !20, line: 12, type: !21, isLocal: false, isDefinition: true)
!28 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !23)
!29 = !{i32 7, !"Dwarf Version", i32 4}
!30 = !{i32 2, !"Debug Info Version", i32 3}
!31 = !{i32 1, !"wchar_size", i32 4}
!32 = !{i32 1, !"branch-target-enforcement", i32 0}
!33 = !{i32 1, !"sign-return-address", i32 0}
!34 = !{i32 1, !"sign-return-address-all", i32 0}
!35 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!36 = !{i32 7, !"PIC Level", i32 2}
!37 = !{i32 7, !"uwtable", i32 1}
!38 = !{i32 7, !"frame-pointer", i32 1}
!39 = !{!"Homebrew clang version 14.0.6"}
!40 = distinct !DISubprogram(name: "thread", scope: !20, file: !20, line: 14, type: !41, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!41 = !DISubroutineType(types: !42)
!42 = !{!16, !16}
!43 = !{}
!44 = !DILocalVariable(name: "unused", arg: 1, scope: !40, file: !20, line: 14, type: !16)
!45 = !DILocation(line: 14, column: 20, scope: !40)
!46 = !DILocation(line: 16, column: 5, scope: !40)
!47 = !DILocation(line: 17, column: 11, scope: !48)
!48 = distinct !DILexicalBlock(scope: !40, file: !20, line: 16, column: 14)
!49 = !DILocation(line: 18, column: 9, scope: !48)
!50 = !DILocation(line: 20, column: 9, scope: !48)
!51 = !DILocation(line: 20, column: 17, scope: !48)
!52 = !DILocation(line: 20, column: 27, scope: !48)
!53 = !DILocation(line: 20, column: 31, scope: !48)
!54 = !DILocation(line: 20, column: 30, scope: !48)
!55 = !DILocation(line: 0, scope: !48)
!56 = distinct !{!56, !50, !57, !58}
!57 = !DILocation(line: 20, column: 42, scope: !48)
!58 = !{!"llvm.loop.mustprogress"}
!59 = !DILocation(line: 21, column: 13, scope: !60)
!60 = distinct !DILexicalBlock(scope: !48, file: !20, line: 21, column: 13)
!61 = !DILocation(line: 21, column: 13, scope: !48)
!62 = !DILocation(line: 23, column: 15, scope: !63)
!63 = distinct !DILexicalBlock(scope: !60, file: !20, line: 21, column: 24)
!64 = !DILocation(line: 24, column: 23, scope: !63)
!65 = !DILocation(line: 25, column: 9, scope: !63)
!66 = !DILocation(line: 26, column: 13, scope: !67)
!67 = distinct !DILexicalBlock(scope: !48, file: !20, line: 26, column: 13)
!68 = !DILocation(line: 26, column: 13, scope: !48)
!69 = !DILocation(line: 26, column: 22, scope: !67)
!70 = distinct !{!70, !46, !71}
!71 = !DILocation(line: 27, column: 5, scope: !40)
!72 = !DILocation(line: 28, column: 5, scope: !40)
!73 = distinct !DISubprogram(name: "thread2", scope: !20, file: !20, line: 31, type: !41, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!74 = !DILocalVariable(name: "unused", arg: 1, scope: !73, file: !20, line: 31, type: !16)
!75 = !DILocation(line: 31, column: 21, scope: !73)
!76 = !DILocation(line: 32, column: 5, scope: !73)
!77 = !DILocation(line: 32, column: 12, scope: !73)
!78 = !DILocation(line: 32, column: 64, scope: !73)
!79 = !DILocation(line: 32, column: 69, scope: !73)
!80 = !DILocation(line: 32, column: 72, scope: !73)
!81 = !DILocation(line: 32, column: 74, scope: !73)
!82 = !DILocation(line: 0, scope: !73)
!83 = !DILocation(line: 34, column: 16, scope: !84)
!84 = distinct !DILexicalBlock(scope: !73, file: !20, line: 32, column: 80)
!85 = !DILocation(line: 35, column: 19, scope: !84)
!86 = distinct !{!86, !76, !87, !58}
!87 = !DILocation(line: 36, column: 5, scope: !73)
!88 = !DILocation(line: 37, column: 13, scope: !73)
!89 = !DILocation(line: 38, column: 5, scope: !73)
!90 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 41, type: !91, scopeLine: 42, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!91 = !DISubroutineType(types: !92)
!92 = !{!23}
!93 = !DILocalVariable(name: "t1", scope: !90, file: !20, line: 43, type: !94)
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !95, line: 31, baseType: !96)
!95 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !97, line: 118, baseType: !98)
!97 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!98 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64)
!99 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !97, line: 103, size: 65536, elements: !100)
!100 = !{!101, !103, !113}
!101 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !99, file: !97, line: 104, baseType: !102, size: 64)
!102 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !99, file: !97, line: 105, baseType: !104, size: 64, offset: 64)
!104 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !105, size: 64)
!105 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !97, line: 57, size: 192, elements: !106)
!106 = !{!107, !111, !112}
!107 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !105, file: !97, line: 58, baseType: !108, size: 64)
!108 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !109, size: 64)
!109 = !DISubroutineType(types: !110)
!110 = !{null, !16}
!111 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !105, file: !97, line: 59, baseType: !16, size: 64, offset: 64)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !105, file: !97, line: 60, baseType: !104, size: 64, offset: 128)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !99, file: !97, line: 106, baseType: !114, size: 65408, offset: 128)
!114 = !DICompositeType(tag: DW_TAG_array_type, baseType: !115, size: 65408, elements: !116)
!115 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!116 = !{!117}
!117 = !DISubrange(count: 8176)
!118 = !DILocation(line: 43, column: 15, scope: !90)
!119 = !DILocalVariable(name: "t2", scope: !90, file: !20, line: 43, type: !94)
!120 = !DILocation(line: 43, column: 19, scope: !90)
!121 = !DILocation(line: 44, column: 5, scope: !90)
!122 = !DILocation(line: 45, column: 5, scope: !90)
!123 = !DILocation(line: 47, column: 5, scope: !90)
