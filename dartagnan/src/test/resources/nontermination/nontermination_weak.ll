; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_weak.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_weak.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@x = global i32 0, align 4, !dbg !0
@signal = global i32 0, align 4, !dbg !7
@success = global i32 0, align 4, !dbg !12

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread(i8* noundef %0) #0 !dbg !25 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !29, metadata !DIExpression()), !dbg !30
  br label %4, !dbg !31

4:                                                ; preds = %8, %1
  %5 = load volatile i32, i32* @success, align 4, !dbg !32
  %6 = icmp ne i32 %5, 0, !dbg !33
  %7 = xor i1 %6, true, !dbg !33
  br i1 %7, label %8, label %9, !dbg !31

8:                                                ; preds = %4
  store volatile i32 1, i32* @x, align 4, !dbg !34
  store volatile i32 1, i32* @signal, align 4, !dbg !36
  br label %4, !dbg !31, !llvm.loop !37

9:                                                ; preds = %4
  %10 = load i8*, i8** %2, align 8, !dbg !40
  ret i8* %10, !dbg !40
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread2(i8* noundef %0) #0 !dbg !41 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !42, metadata !DIExpression()), !dbg !43
  br label %4, !dbg !44

4:                                                ; preds = %12, %1
  %5 = load volatile i32, i32* @signal, align 4, !dbg !45
  %6 = icmp eq i32 %5, 1, !dbg !46
  br i1 %6, label %7, label %10, !dbg !47

7:                                                ; preds = %4
  %8 = load volatile i32, i32* @x, align 4, !dbg !48
  %9 = icmp eq i32 %8, 0, !dbg !49
  br label %10

10:                                               ; preds = %7, %4
  %11 = phi i1 [ false, %4 ], [ %9, %7 ], !dbg !50
  br i1 %11, label %12, label %13, !dbg !44

12:                                               ; preds = %10
  store volatile i32 0, i32* @x, align 4, !dbg !51
  store volatile i32 0, i32* @signal, align 4, !dbg !53
  br label %4, !dbg !44, !llvm.loop !54

13:                                               ; preds = %10
  store volatile i32 1, i32* @success, align 4, !dbg !56
  %14 = load i8*, i8** %2, align 8, !dbg !57
  ret i8* %14, !dbg !57
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !58 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !61, metadata !DIExpression()), !dbg !86
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !87, metadata !DIExpression()), !dbg !88
  %4 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef null), !dbg !89
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread2, i8* noundef null), !dbg !90
  ret i32 0, !dbg !91
}

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!14, !15, !16, !17, !18, !19, !20, !21, !22, !23}
!llvm.ident = !{!24}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !9, line: 9, type: !10, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_weak.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !12}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "signal", scope: !2, file: !9, line: 10, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "benchmarks/nontermination/nontermination_weak.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!10 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !11)
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "success", scope: !2, file: !9, line: 11, type: !10, isLocal: false, isDefinition: true)
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
!25 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 13, type: !26, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!26 = !DISubroutineType(types: !27)
!27 = !{!5, !5}
!28 = !{}
!29 = !DILocalVariable(name: "unused", arg: 1, scope: !25, file: !9, line: 13, type: !5)
!30 = !DILocation(line: 13, column: 20, scope: !25)
!31 = !DILocation(line: 15, column: 5, scope: !25)
!32 = !DILocation(line: 15, column: 12, scope: !25)
!33 = !DILocation(line: 15, column: 11, scope: !25)
!34 = !DILocation(line: 16, column: 11, scope: !35)
!35 = distinct !DILexicalBlock(scope: !25, file: !9, line: 15, column: 21)
!36 = !DILocation(line: 17, column: 16, scope: !35)
!37 = distinct !{!37, !31, !38, !39}
!38 = !DILocation(line: 18, column: 5, scope: !25)
!39 = !{!"llvm.loop.mustprogress"}
!40 = !DILocation(line: 19, column: 1, scope: !25)
!41 = distinct !DISubprogram(name: "thread2", scope: !9, file: !9, line: 21, type: !26, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!42 = !DILocalVariable(name: "unused", arg: 1, scope: !41, file: !9, line: 21, type: !5)
!43 = !DILocation(line: 21, column: 21, scope: !41)
!44 = !DILocation(line: 22, column: 5, scope: !41)
!45 = !DILocation(line: 22, column: 12, scope: !41)
!46 = !DILocation(line: 22, column: 19, scope: !41)
!47 = !DILocation(line: 22, column: 24, scope: !41)
!48 = !DILocation(line: 22, column: 27, scope: !41)
!49 = !DILocation(line: 22, column: 29, scope: !41)
!50 = !DILocation(line: 0, scope: !41)
!51 = !DILocation(line: 24, column: 11, scope: !52)
!52 = distinct !DILexicalBlock(scope: !41, file: !9, line: 22, column: 35)
!53 = !DILocation(line: 25, column: 16, scope: !52)
!54 = distinct !{!54, !44, !55, !39}
!55 = !DILocation(line: 26, column: 5, scope: !41)
!56 = !DILocation(line: 27, column: 13, scope: !41)
!57 = !DILocation(line: 28, column: 1, scope: !41)
!58 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 30, type: !59, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!59 = !DISubroutineType(types: !60)
!60 = !{!11}
!61 = !DILocalVariable(name: "t1", scope: !58, file: !9, line: 32, type: !62)
!62 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !63, line: 31, baseType: !64)
!63 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!64 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !65, line: 118, baseType: !66)
!65 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!67 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !65, line: 103, size: 65536, elements: !68)
!68 = !{!69, !71, !81}
!69 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !67, file: !65, line: 104, baseType: !70, size: 64)
!70 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !67, file: !65, line: 105, baseType: !72, size: 64, offset: 64)
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !73, size: 64)
!73 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !65, line: 57, size: 192, elements: !74)
!74 = !{!75, !79, !80}
!75 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !73, file: !65, line: 58, baseType: !76, size: 64)
!76 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !77, size: 64)
!77 = !DISubroutineType(types: !78)
!78 = !{null, !5}
!79 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !73, file: !65, line: 59, baseType: !5, size: 64, offset: 64)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !73, file: !65, line: 60, baseType: !72, size: 64, offset: 128)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !67, file: !65, line: 106, baseType: !82, size: 65408, offset: 128)
!82 = !DICompositeType(tag: DW_TAG_array_type, baseType: !83, size: 65408, elements: !84)
!83 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!84 = !{!85}
!85 = !DISubrange(count: 8176)
!86 = !DILocation(line: 32, column: 15, scope: !58)
!87 = !DILocalVariable(name: "t2", scope: !58, file: !9, line: 32, type: !62)
!88 = !DILocation(line: 32, column: 19, scope: !58)
!89 = !DILocation(line: 33, column: 5, scope: !58)
!90 = !DILocation(line: 34, column: 5, scope: !58)
!91 = !DILocation(line: 36, column: 5, scope: !58)
