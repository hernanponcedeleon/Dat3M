; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_unstructured_spin.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_unstructured_spin.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@x = global i32 0, align 4, !dbg !0

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread(i8* noundef %0) #0 !dbg !23 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !27, metadata !DIExpression()), !dbg !28
  br label %3, !dbg !29

3:                                                ; preds = %1
  call void @llvm.dbg.label(metadata !30), !dbg !31
  %4 = load atomic i32, i32* @x seq_cst, align 4, !dbg !32
  %5 = icmp ne i32 %4, 0, !dbg !34
  br i1 %5, label %6, label %7, !dbg !35

6:                                                ; preds = %3
  br label %8, !dbg !36

7:                                                ; preds = %3
  br label %13, !dbg !37

8:                                                ; preds = %17, %12, %6
  call void @llvm.dbg.label(metadata !38), !dbg !39
  %9 = load atomic i32, i32* @x seq_cst, align 4, !dbg !40
  %10 = icmp ne i32 %9, 0, !dbg !42
  br i1 %10, label %11, label %12, !dbg !43

11:                                               ; preds = %8
  br label %13, !dbg !44

12:                                               ; preds = %8
  br label %8, !dbg !45

13:                                               ; preds = %11, %7
  call void @llvm.dbg.label(metadata !46), !dbg !47
  %14 = load atomic i32, i32* @x seq_cst, align 4, !dbg !48
  %15 = icmp ne i32 %14, 0, !dbg !50
  br i1 %15, label %16, label %17, !dbg !51

16:                                               ; preds = %13
  br label %18, !dbg !52

17:                                               ; preds = %13
  br label %8, !dbg !53

18:                                               ; preds = %16
  call void @llvm.dbg.label(metadata !54), !dbg !55
  ret i8* null, !dbg !56
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread2(i8* noundef %0) #0 !dbg !57 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !58, metadata !DIExpression()), !dbg !59
  store atomic i32 1, i32* @x seq_cst, align 4, !dbg !60
  %4 = load i8*, i8** %2, align 8, !dbg !61
  ret i8* %4, !dbg !61
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !62 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !65, metadata !DIExpression()), !dbg !90
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !91, metadata !DIExpression()), !dbg !92
  %4 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef null), !dbg !93
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread2, i8* noundef null), !dbg !94
  ret i32 0, !dbg !95
}

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!12, !13, !14, !15, !16, !17, !18, !19, !20, !21}
!llvm.ident = !{!22}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !7, line: 9, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_unstructured_spin.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0}
!7 = !DIFile(filename: "benchmarks/nontermination/nontermination_unstructured_spin.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !9, line: 92, baseType: !10)
!9 = !DIFile(filename: "/opt/homebrew/Cellar/llvm@14/14.0.6/lib/clang/14.0.6/include/stdatomic.h", directory: "")
!10 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !11)
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !{i32 7, !"Dwarf Version", i32 4}
!13 = !{i32 2, !"Debug Info Version", i32 3}
!14 = !{i32 1, !"wchar_size", i32 4}
!15 = !{i32 1, !"branch-target-enforcement", i32 0}
!16 = !{i32 1, !"sign-return-address", i32 0}
!17 = !{i32 1, !"sign-return-address-all", i32 0}
!18 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!19 = !{i32 7, !"PIC Level", i32 2}
!20 = !{i32 7, !"uwtable", i32 1}
!21 = !{i32 7, !"frame-pointer", i32 1}
!22 = !{!"Homebrew clang version 14.0.6"}
!23 = distinct !DISubprogram(name: "thread", scope: !7, file: !7, line: 11, type: !24, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!24 = !DISubroutineType(types: !25)
!25 = !{!5, !5}
!26 = !{}
!27 = !DILocalVariable(name: "unused", arg: 1, scope: !23, file: !7, line: 11, type: !5)
!28 = !DILocation(line: 11, column: 20, scope: !23)
!29 = !DILocation(line: 12, column: 1, scope: !23)
!30 = !DILabel(scope: !23, name: "LC00", file: !7, line: 13)
!31 = !DILocation(line: 13, column: 5, scope: !23)
!32 = !DILocation(line: 14, column: 9, scope: !33)
!33 = distinct !DILexicalBlock(scope: !23, file: !7, line: 14, column: 9)
!34 = !DILocation(line: 14, column: 11, scope: !33)
!35 = !DILocation(line: 14, column: 9, scope: !23)
!36 = !DILocation(line: 14, column: 17, scope: !33)
!37 = !DILocation(line: 15, column: 5, scope: !23)
!38 = !DILabel(scope: !23, name: "LC01", file: !7, line: 16)
!39 = !DILocation(line: 16, column: 5, scope: !23)
!40 = !DILocation(line: 17, column: 9, scope: !41)
!41 = distinct !DILexicalBlock(scope: !23, file: !7, line: 17, column: 9)
!42 = !DILocation(line: 17, column: 11, scope: !41)
!43 = !DILocation(line: 17, column: 9, scope: !23)
!44 = !DILocation(line: 17, column: 17, scope: !41)
!45 = !DILocation(line: 18, column: 5, scope: !23)
!46 = !DILabel(scope: !23, name: "LC02", file: !7, line: 19)
!47 = !DILocation(line: 19, column: 5, scope: !23)
!48 = !DILocation(line: 20, column: 9, scope: !49)
!49 = distinct !DILexicalBlock(scope: !23, file: !7, line: 20, column: 9)
!50 = !DILocation(line: 20, column: 11, scope: !49)
!51 = !DILocation(line: 20, column: 9, scope: !23)
!52 = !DILocation(line: 20, column: 17, scope: !49)
!53 = !DILocation(line: 21, column: 5, scope: !23)
!54 = !DILabel(scope: !23, name: "LC03", file: !7, line: 22)
!55 = !DILocation(line: 22, column: 5, scope: !23)
!56 = !DILocation(line: 23, column: 5, scope: !23)
!57 = distinct !DISubprogram(name: "thread2", scope: !7, file: !7, line: 26, type: !24, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!58 = !DILocalVariable(name: "unused", arg: 1, scope: !57, file: !7, line: 26, type: !5)
!59 = !DILocation(line: 26, column: 21, scope: !57)
!60 = !DILocation(line: 27, column: 7, scope: !57)
!61 = !DILocation(line: 28, column: 1, scope: !57)
!62 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 30, type: !63, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!63 = !DISubroutineType(types: !64)
!64 = !{!11}
!65 = !DILocalVariable(name: "t1", scope: !62, file: !7, line: 32, type: !66)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !67, line: 31, baseType: !68)
!67 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !69, line: 118, baseType: !70)
!69 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!70 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !71, size: 64)
!71 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !69, line: 103, size: 65536, elements: !72)
!72 = !{!73, !75, !85}
!73 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !71, file: !69, line: 104, baseType: !74, size: 64)
!74 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !71, file: !69, line: 105, baseType: !76, size: 64, offset: 64)
!76 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !77, size: 64)
!77 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !69, line: 57, size: 192, elements: !78)
!78 = !{!79, !83, !84}
!79 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !77, file: !69, line: 58, baseType: !80, size: 64)
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!81 = !DISubroutineType(types: !82)
!82 = !{null, !5}
!83 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !77, file: !69, line: 59, baseType: !5, size: 64, offset: 64)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !77, file: !69, line: 60, baseType: !76, size: 64, offset: 128)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !71, file: !69, line: 106, baseType: !86, size: 65408, offset: 128)
!86 = !DICompositeType(tag: DW_TAG_array_type, baseType: !87, size: 65408, elements: !88)
!87 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!88 = !{!89}
!89 = !DISubrange(count: 8176)
!90 = !DILocation(line: 32, column: 15, scope: !62)
!91 = !DILocalVariable(name: "t2", scope: !62, file: !7, line: 32, type: !66)
!92 = !DILocation(line: 32, column: 19, scope: !62)
!93 = !DILocation(line: 33, column: 5, scope: !62)
!94 = !DILocation(line: 34, column: 5, scope: !62)
!95 = !DILocation(line: 36, column: 5, scope: !62)
