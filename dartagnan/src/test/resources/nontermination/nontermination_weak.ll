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

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread(i8* noundef %0) #0 !dbg !38 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !42, metadata !DIExpression()), !dbg !43
  br label %4, !dbg !44

4:                                                ; preds = %8, %1
  %5 = load atomic i32, i32* @success seq_cst, align 4, !dbg !45
  %6 = icmp ne i32 %5, 0, !dbg !46
  %7 = xor i1 %6, true, !dbg !46
  br i1 %7, label %8, label %10, !dbg !44

8:                                                ; preds = %4
  store volatile i32 1, i32* @x, align 4, !dbg !47
  store i32 1, i32* %3, align 4, !dbg !49
  %9 = load i32, i32* %3, align 4, !dbg !49
  store atomic i32 %9, i32* @signal monotonic, align 4, !dbg !49
  br label %4, !dbg !44, !llvm.loop !50

10:                                               ; preds = %4
  ret i8* null, !dbg !53
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread2(i8* noundef %0) #0 !dbg !54 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !55, metadata !DIExpression()), !dbg !56
  br label %4, !dbg !57

4:                                                ; preds = %13, %1
  %5 = load atomic i32, i32* @signal monotonic, align 4, !dbg !58
  store i32 %5, i32* %3, align 4, !dbg !58
  %6 = load i32, i32* %3, align 4, !dbg !58
  %7 = icmp eq i32 %6, 1, !dbg !59
  br i1 %7, label %8, label %11, !dbg !60

8:                                                ; preds = %4
  %9 = load volatile i32, i32* @x, align 4, !dbg !61
  %10 = icmp eq i32 %9, 0, !dbg !62
  br label %11

11:                                               ; preds = %8, %4
  %12 = phi i1 [ false, %4 ], [ %10, %8 ], !dbg !63
  br i1 %12, label %13, label %14, !dbg !57

13:                                               ; preds = %11
  store volatile i32 0, i32* @x, align 4, !dbg !64
  store atomic i32 0, i32* @signal seq_cst, align 4, !dbg !66
  br label %4, !dbg !57, !llvm.loop !67

14:                                               ; preds = %11
  store atomic i32 1, i32* @success seq_cst, align 4, !dbg !69
  ret i8* null, !dbg !70
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !71 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !74, metadata !DIExpression()), !dbg !99
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !100, metadata !DIExpression()), !dbg !101
  %4 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef null), !dbg !102
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread2, i8* noundef null), !dbg !103
  ret i32 0, !dbg !104
}

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!27, !28, !29, !30, !31, !32, !33, !34, !35, !36}
!llvm.ident = !{!37}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !20, line: 9, type: !26, isLocal: false, isDefinition: true)
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
!17 = !{!0, !18, !24}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "signal", scope: !2, file: !20, line: 10, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/nontermination/nontermination_weak.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "success", scope: !2, file: !20, line: 11, type: !21, isLocal: false, isDefinition: true)
!26 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !23)
!27 = !{i32 7, !"Dwarf Version", i32 4}
!28 = !{i32 2, !"Debug Info Version", i32 3}
!29 = !{i32 1, !"wchar_size", i32 4}
!30 = !{i32 1, !"branch-target-enforcement", i32 0}
!31 = !{i32 1, !"sign-return-address", i32 0}
!32 = !{i32 1, !"sign-return-address-all", i32 0}
!33 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!34 = !{i32 7, !"PIC Level", i32 2}
!35 = !{i32 7, !"uwtable", i32 1}
!36 = !{i32 7, !"frame-pointer", i32 1}
!37 = !{!"Homebrew clang version 14.0.6"}
!38 = distinct !DISubprogram(name: "thread", scope: !20, file: !20, line: 13, type: !39, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !41)
!39 = !DISubroutineType(types: !40)
!40 = !{!16, !16}
!41 = !{}
!42 = !DILocalVariable(name: "unused", arg: 1, scope: !38, file: !20, line: 13, type: !16)
!43 = !DILocation(line: 13, column: 20, scope: !38)
!44 = !DILocation(line: 15, column: 5, scope: !38)
!45 = !DILocation(line: 15, column: 12, scope: !38)
!46 = !DILocation(line: 15, column: 11, scope: !38)
!47 = !DILocation(line: 16, column: 11, scope: !48)
!48 = distinct !DILexicalBlock(scope: !38, file: !20, line: 15, column: 21)
!49 = !DILocation(line: 17, column: 9, scope: !48)
!50 = distinct !{!50, !44, !51, !52}
!51 = !DILocation(line: 18, column: 5, scope: !38)
!52 = !{!"llvm.loop.mustprogress"}
!53 = !DILocation(line: 19, column: 5, scope: !38)
!54 = distinct !DISubprogram(name: "thread2", scope: !20, file: !20, line: 22, type: !39, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !41)
!55 = !DILocalVariable(name: "unused", arg: 1, scope: !54, file: !20, line: 22, type: !16)
!56 = !DILocation(line: 22, column: 21, scope: !54)
!57 = !DILocation(line: 23, column: 5, scope: !54)
!58 = !DILocation(line: 23, column: 12, scope: !54)
!59 = !DILocation(line: 23, column: 64, scope: !54)
!60 = !DILocation(line: 23, column: 69, scope: !54)
!61 = !DILocation(line: 23, column: 72, scope: !54)
!62 = !DILocation(line: 23, column: 74, scope: !54)
!63 = !DILocation(line: 0, scope: !54)
!64 = !DILocation(line: 25, column: 11, scope: !65)
!65 = distinct !DILexicalBlock(scope: !54, file: !20, line: 23, column: 80)
!66 = !DILocation(line: 26, column: 16, scope: !65)
!67 = distinct !{!67, !57, !68, !52}
!68 = !DILocation(line: 27, column: 5, scope: !54)
!69 = !DILocation(line: 28, column: 13, scope: !54)
!70 = !DILocation(line: 29, column: 5, scope: !54)
!71 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 32, type: !72, scopeLine: 33, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !41)
!72 = !DISubroutineType(types: !73)
!73 = !{!23}
!74 = !DILocalVariable(name: "t1", scope: !71, file: !20, line: 34, type: !75)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !76, line: 31, baseType: !77)
!76 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !78, line: 118, baseType: !79)
!78 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!80 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !78, line: 103, size: 65536, elements: !81)
!81 = !{!82, !84, !94}
!82 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !80, file: !78, line: 104, baseType: !83, size: 64)
!83 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !80, file: !78, line: 105, baseType: !85, size: 64, offset: 64)
!85 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !86, size: 64)
!86 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !78, line: 57, size: 192, elements: !87)
!87 = !{!88, !92, !93}
!88 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !86, file: !78, line: 58, baseType: !89, size: 64)
!89 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !90, size: 64)
!90 = !DISubroutineType(types: !91)
!91 = !{null, !16}
!92 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !86, file: !78, line: 59, baseType: !16, size: 64, offset: 64)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !86, file: !78, line: 60, baseType: !85, size: 64, offset: 128)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !80, file: !78, line: 106, baseType: !95, size: 65408, offset: 128)
!95 = !DICompositeType(tag: DW_TAG_array_type, baseType: !96, size: 65408, elements: !97)
!96 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!97 = !{!98}
!98 = !DISubrange(count: 8176)
!99 = !DILocation(line: 34, column: 15, scope: !71)
!100 = !DILocalVariable(name: "t2", scope: !71, file: !20, line: 34, type: !75)
!101 = !DILocation(line: 34, column: 19, scope: !71)
!102 = !DILocation(line: 35, column: 5, scope: !71)
!103 = !DILocation(line: 36, column: 5, scope: !71)
!104 = !DILocation(line: 38, column: 5, scope: !71)
