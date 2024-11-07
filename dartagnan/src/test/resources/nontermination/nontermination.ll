; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@x = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !7

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread(i8* noundef %0) #0 !dbg !23 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !27, metadata !DIExpression()), !dbg !28
  br label %4, !dbg !29

4:                                                ; preds = %7, %1
  %5 = load volatile i32, i32* @y, align 4, !dbg !30
  %6 = icmp ne i32 %5, 1, !dbg !31
  br i1 %6, label %7, label %8, !dbg !29

7:                                                ; preds = %4
  store volatile i32 1, i32* @x, align 4, !dbg !32
  store volatile i32 2, i32* @x, align 4, !dbg !34
  br label %4, !dbg !29, !llvm.loop !35

8:                                                ; preds = %4
  %9 = load i8*, i8** %2, align 8, !dbg !38
  ret i8* %9, !dbg !38
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread2(i8* noundef %0) #0 !dbg !39 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !40, metadata !DIExpression()), !dbg !41
  br label %4, !dbg !42

4:                                                ; preds = %7, %1
  %5 = load volatile i32, i32* @x, align 4, !dbg !43
  %6 = icmp ne i32 %5, 2, !dbg !44
  br i1 %6, label %7, label %8, !dbg !42

7:                                                ; preds = %4
  br label %4, !dbg !42, !llvm.loop !45

8:                                                ; preds = %4
  store volatile i32 1, i32* @y, align 4, !dbg !47
  %9 = load i8*, i8** %2, align 8, !dbg !48
  ret i8* %9, !dbg !48
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !49 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !52, metadata !DIExpression()), !dbg !77
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !78, metadata !DIExpression()), !dbg !79
  %4 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef null), !dbg !80
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread2, i8* noundef null), !dbg !81
  ret i32 0, !dbg !82
}

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!12, !13, !14, !15, !16, !17, !18, !19, !20, !21}
!llvm.ident = !{!22}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !9, line: 8, type: !10, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !9, line: 9, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "benchmarks/nontermination/nontermination.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!10 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !11)
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
!23 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 11, type: !24, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!24 = !DISubroutineType(types: !25)
!25 = !{!5, !5}
!26 = !{}
!27 = !DILocalVariable(name: "unused", arg: 1, scope: !23, file: !9, line: 11, type: !5)
!28 = !DILocation(line: 11, column: 20, scope: !23)
!29 = !DILocation(line: 13, column: 5, scope: !23)
!30 = !DILocation(line: 13, column: 11, scope: !23)
!31 = !DILocation(line: 13, column: 13, scope: !23)
!32 = !DILocation(line: 14, column: 11, scope: !33)
!33 = distinct !DILexicalBlock(scope: !23, file: !9, line: 13, column: 19)
!34 = !DILocation(line: 15, column: 11, scope: !33)
!35 = distinct !{!35, !29, !36, !37}
!36 = !DILocation(line: 16, column: 5, scope: !23)
!37 = !{!"llvm.loop.mustprogress"}
!38 = !DILocation(line: 17, column: 1, scope: !23)
!39 = distinct !DISubprogram(name: "thread2", scope: !9, file: !9, line: 19, type: !24, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!40 = !DILocalVariable(name: "unused", arg: 1, scope: !39, file: !9, line: 19, type: !5)
!41 = !DILocation(line: 19, column: 21, scope: !39)
!42 = !DILocation(line: 20, column: 5, scope: !39)
!43 = !DILocation(line: 20, column: 12, scope: !39)
!44 = !DILocation(line: 20, column: 14, scope: !39)
!45 = distinct !{!45, !42, !46, !37}
!46 = !DILocation(line: 20, column: 22, scope: !39)
!47 = !DILocation(line: 21, column: 7, scope: !39)
!48 = !DILocation(line: 22, column: 1, scope: !39)
!49 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 24, type: !50, scopeLine: 25, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!50 = !DISubroutineType(types: !51)
!51 = !{!11}
!52 = !DILocalVariable(name: "t1", scope: !49, file: !9, line: 26, type: !53)
!53 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !54, line: 31, baseType: !55)
!54 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !56, line: 118, baseType: !57)
!56 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!57 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !58, size: 64)
!58 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !56, line: 103, size: 65536, elements: !59)
!59 = !{!60, !62, !72}
!60 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !58, file: !56, line: 104, baseType: !61, size: 64)
!61 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !58, file: !56, line: 105, baseType: !63, size: 64, offset: 64)
!63 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !64, size: 64)
!64 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !56, line: 57, size: 192, elements: !65)
!65 = !{!66, !70, !71}
!66 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !64, file: !56, line: 58, baseType: !67, size: 64)
!67 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !68, size: 64)
!68 = !DISubroutineType(types: !69)
!69 = !{null, !5}
!70 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !64, file: !56, line: 59, baseType: !5, size: 64, offset: 64)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !64, file: !56, line: 60, baseType: !63, size: 64, offset: 128)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !58, file: !56, line: 106, baseType: !73, size: 65408, offset: 128)
!73 = !DICompositeType(tag: DW_TAG_array_type, baseType: !74, size: 65408, elements: !75)
!74 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!75 = !{!76}
!76 = !DISubrange(count: 8176)
!77 = !DILocation(line: 26, column: 15, scope: !49)
!78 = !DILocalVariable(name: "t2", scope: !49, file: !9, line: 26, type: !53)
!79 = !DILocation(line: 26, column: 19, scope: !49)
!80 = !DILocation(line: 27, column: 5, scope: !49)
!81 = !DILocation(line: 28, column: 5, scope: !49)
!82 = !DILocation(line: 30, column: 5, scope: !49)
