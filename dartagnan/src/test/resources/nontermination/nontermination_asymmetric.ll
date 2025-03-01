; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_asymmetric.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_asymmetric.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@x = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !7

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread(i8* noundef %0) #0 !dbg !25 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !29, metadata !DIExpression()), !dbg !30
  %3 = call i32 bitcast (i32 (...)* @__VERIFIER_loop_bound to i32 (i32)*)(i32 noundef 5), !dbg !31
  br label %4, !dbg !32

4:                                                ; preds = %7, %1
  %5 = load atomic i32, i32* @y seq_cst, align 4, !dbg !33
  %6 = icmp ne i32 %5, 1, !dbg !34
  br i1 %6, label %7, label %10, !dbg !32

7:                                                ; preds = %4
  %8 = load atomic i32, i32* @x seq_cst, align 4, !dbg !35
  %9 = sub nsw i32 1, %8, !dbg !37
  store atomic i32 %9, i32* @x seq_cst, align 4, !dbg !38
  br label %4, !dbg !32, !llvm.loop !39

10:                                               ; preds = %4
  ret i8* null, !dbg !42
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @__VERIFIER_loop_bound(...) #2

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread2(i8* noundef %0) #0 !dbg !43 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !44, metadata !DIExpression()), !dbg !45
  %3 = call i32 bitcast (i32 (...)* @__VERIFIER_loop_bound to i32 (i32)*)(i32 noundef 3), !dbg !46
  br label %4, !dbg !47

4:                                                ; preds = %1, %12
  %5 = load atomic i32, i32* @x seq_cst, align 4, !dbg !48
  %6 = icmp eq i32 %5, 0, !dbg !51
  br i1 %6, label %7, label %8, !dbg !52

7:                                                ; preds = %4
  br label %13, !dbg !53

8:                                                ; preds = %4
  %9 = load atomic i32, i32* @x seq_cst, align 4, !dbg !55
  %10 = icmp eq i32 %9, 1, !dbg !57
  br i1 %10, label %11, label %12, !dbg !58

11:                                               ; preds = %8
  br label %13, !dbg !59

12:                                               ; preds = %8
  store atomic i32 0, i32* @y seq_cst, align 4, !dbg !61
  br label %4, !dbg !47, !llvm.loop !62

13:                                               ; preds = %11, %7
  store atomic i32 1, i32* @y seq_cst, align 4, !dbg !64
  ret i8* null, !dbg !65
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !66 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !69, metadata !DIExpression()), !dbg !94
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !95, metadata !DIExpression()), !dbg !96
  %4 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef null), !dbg !97
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread2, i8* noundef null), !dbg !98
  ret i32 0, !dbg !99
}

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!14, !15, !16, !17, !18, !19, !20, !21, !22, !23}
!llvm.ident = !{!24}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !9, line: 11, type: !10, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_asymmetric.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !9, line: 12, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "benchmarks/nontermination/nontermination_asymmetric.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !11, line: 92, baseType: !12)
!11 = !DIFile(filename: "/opt/homebrew/Cellar/llvm@14/14.0.6/lib/clang/14.0.6/include/stdatomic.h", directory: "")
!12 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !13)
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !{i32 7, !"Dwarf Version", i32 4}
!15 = !{i32 2, !"Debug Info Version", i32 3}
!16 = !{i32 1, !"wchar_size", i32 4}
!17 = !{i32 1, !"branch-target-enforcement", i32 0}
!18 = !{i32 1, !"sign-return-address", i32 0}
!19 = !{i32 1, !"sign-return-address-all", i32 0}
!20 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!21 = !{i32 7, !"PIC Level", i32 2}
!22 = !{i32 7, !"uwtable", i32 1}
!23 = !{i32 7, !"frame-pointer", i32 1}
!24 = !{!"Homebrew clang version 14.0.6"}
!25 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 14, type: !26, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!26 = !DISubroutineType(types: !27)
!27 = !{!5, !5}
!28 = !{}
!29 = !DILocalVariable(name: "unused", arg: 1, scope: !25, file: !9, line: 14, type: !5)
!30 = !DILocation(line: 14, column: 20, scope: !25)
!31 = !DILocation(line: 16, column: 5, scope: !25)
!32 = !DILocation(line: 17, column: 5, scope: !25)
!33 = !DILocation(line: 17, column: 11, scope: !25)
!34 = !DILocation(line: 17, column: 13, scope: !25)
!35 = !DILocation(line: 18, column: 17, scope: !36)
!36 = distinct !DILexicalBlock(scope: !25, file: !9, line: 17, column: 19)
!37 = !DILocation(line: 18, column: 15, scope: !36)
!38 = !DILocation(line: 18, column: 11, scope: !36)
!39 = distinct !{!39, !32, !40, !41}
!40 = !DILocation(line: 19, column: 5, scope: !25)
!41 = !{!"llvm.loop.mustprogress"}
!42 = !DILocation(line: 20, column: 5, scope: !25)
!43 = distinct !DISubprogram(name: "thread2", scope: !9, file: !9, line: 23, type: !26, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!44 = !DILocalVariable(name: "unused", arg: 1, scope: !43, file: !9, line: 23, type: !5)
!45 = !DILocation(line: 23, column: 21, scope: !43)
!46 = !DILocation(line: 24, column: 5, scope: !43)
!47 = !DILocation(line: 25, column: 5, scope: !43)
!48 = !DILocation(line: 26, column: 13, scope: !49)
!49 = distinct !DILexicalBlock(scope: !50, file: !9, line: 26, column: 13)
!50 = distinct !DILexicalBlock(scope: !43, file: !9, line: 25, column: 15)
!51 = !DILocation(line: 26, column: 15, scope: !49)
!52 = !DILocation(line: 26, column: 13, scope: !50)
!53 = !DILocation(line: 27, column: 13, scope: !54)
!54 = distinct !DILexicalBlock(scope: !49, file: !9, line: 26, column: 21)
!55 = !DILocation(line: 29, column: 13, scope: !56)
!56 = distinct !DILexicalBlock(scope: !50, file: !9, line: 29, column: 13)
!57 = !DILocation(line: 29, column: 15, scope: !56)
!58 = !DILocation(line: 29, column: 13, scope: !50)
!59 = !DILocation(line: 30, column: 13, scope: !60)
!60 = distinct !DILexicalBlock(scope: !56, file: !9, line: 29, column: 21)
!61 = !DILocation(line: 32, column: 11, scope: !50)
!62 = distinct !{!62, !47, !63}
!63 = !DILocation(line: 33, column: 5, scope: !43)
!64 = !DILocation(line: 34, column: 7, scope: !43)
!65 = !DILocation(line: 35, column: 5, scope: !43)
!66 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 38, type: !67, scopeLine: 39, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!67 = !DISubroutineType(types: !68)
!68 = !{!13}
!69 = !DILocalVariable(name: "t1", scope: !66, file: !9, line: 40, type: !70)
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !71, line: 31, baseType: !72)
!71 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!72 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !73, line: 118, baseType: !74)
!73 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!74 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !75, size: 64)
!75 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !73, line: 103, size: 65536, elements: !76)
!76 = !{!77, !79, !89}
!77 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !75, file: !73, line: 104, baseType: !78, size: 64)
!78 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !75, file: !73, line: 105, baseType: !80, size: 64, offset: 64)
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!81 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !73, line: 57, size: 192, elements: !82)
!82 = !{!83, !87, !88}
!83 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !81, file: !73, line: 58, baseType: !84, size: 64)
!84 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !85, size: 64)
!85 = !DISubroutineType(types: !86)
!86 = !{null, !5}
!87 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !81, file: !73, line: 59, baseType: !5, size: 64, offset: 64)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !81, file: !73, line: 60, baseType: !80, size: 64, offset: 128)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !75, file: !73, line: 106, baseType: !90, size: 65408, offset: 128)
!90 = !DICompositeType(tag: DW_TAG_array_type, baseType: !91, size: 65408, elements: !92)
!91 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!92 = !{!93}
!93 = !DISubrange(count: 8176)
!94 = !DILocation(line: 40, column: 15, scope: !66)
!95 = !DILocalVariable(name: "t2", scope: !66, file: !9, line: 40, type: !70)
!96 = !DILocation(line: 40, column: 19, scope: !66)
!97 = !DILocation(line: 41, column: 5, scope: !66)
!98 = !DILocation(line: 42, column: 5, scope: !66)
!99 = !DILocation(line: 44, column: 5, scope: !66)
