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
define i8* @thread(i8* noundef %0) #0 !dbg !25 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !29, metadata !DIExpression()), !dbg !30
  br label %3, !dbg !31

3:                                                ; preds = %6, %1
  %4 = load atomic i32, i32* @y seq_cst, align 4, !dbg !32
  %5 = icmp ne i32 %4, 1, !dbg !33
  br i1 %5, label %6, label %7, !dbg !31

6:                                                ; preds = %3
  store atomic i32 1, i32* @x seq_cst, align 4, !dbg !34
  store atomic i32 2, i32* @x seq_cst, align 4, !dbg !36
  br label %3, !dbg !31, !llvm.loop !37

7:                                                ; preds = %3
  ret i8* null, !dbg !40
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread2(i8* noundef %0) #0 !dbg !41 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !42, metadata !DIExpression()), !dbg !43
  br label %3, !dbg !44

3:                                                ; preds = %6, %1
  %4 = load atomic i32, i32* @x seq_cst, align 4, !dbg !45
  %5 = icmp ne i32 %4, 2, !dbg !46
  br i1 %5, label %6, label %7, !dbg !44

6:                                                ; preds = %3
  br label %3, !dbg !44, !llvm.loop !47

7:                                                ; preds = %3
  store atomic i32 1, i32* @y seq_cst, align 4, !dbg !49
  ret i8* null, !dbg !50
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !51 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !54, metadata !DIExpression()), !dbg !79
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !80, metadata !DIExpression()), !dbg !81
  %4 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef null), !dbg !82
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread2, i8* noundef null), !dbg !83
  ret i32 0, !dbg !84
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
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !9, line: 10, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "benchmarks/nontermination/nontermination.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
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
!25 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 12, type: !26, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!26 = !DISubroutineType(types: !27)
!27 = !{!5, !5}
!28 = !{}
!29 = !DILocalVariable(name: "unused", arg: 1, scope: !25, file: !9, line: 12, type: !5)
!30 = !DILocation(line: 12, column: 20, scope: !25)
!31 = !DILocation(line: 14, column: 5, scope: !25)
!32 = !DILocation(line: 14, column: 11, scope: !25)
!33 = !DILocation(line: 14, column: 13, scope: !25)
!34 = !DILocation(line: 15, column: 11, scope: !35)
!35 = distinct !DILexicalBlock(scope: !25, file: !9, line: 14, column: 19)
!36 = !DILocation(line: 16, column: 11, scope: !35)
!37 = distinct !{!37, !31, !38, !39}
!38 = !DILocation(line: 17, column: 5, scope: !25)
!39 = !{!"llvm.loop.mustprogress"}
!40 = !DILocation(line: 18, column: 5, scope: !25)
!41 = distinct !DISubprogram(name: "thread2", scope: !9, file: !9, line: 21, type: !26, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!42 = !DILocalVariable(name: "unused", arg: 1, scope: !41, file: !9, line: 21, type: !5)
!43 = !DILocation(line: 21, column: 21, scope: !41)
!44 = !DILocation(line: 22, column: 5, scope: !41)
!45 = !DILocation(line: 22, column: 12, scope: !41)
!46 = !DILocation(line: 22, column: 14, scope: !41)
!47 = distinct !{!47, !44, !48, !39}
!48 = !DILocation(line: 22, column: 22, scope: !41)
!49 = !DILocation(line: 23, column: 7, scope: !41)
!50 = !DILocation(line: 24, column: 5, scope: !41)
!51 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 27, type: !52, scopeLine: 28, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!52 = !DISubroutineType(types: !53)
!53 = !{!13}
!54 = !DILocalVariable(name: "t1", scope: !51, file: !9, line: 29, type: !55)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !56, line: 31, baseType: !57)
!56 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !58, line: 118, baseType: !59)
!58 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!59 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!60 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !58, line: 103, size: 65536, elements: !61)
!61 = !{!62, !64, !74}
!62 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !60, file: !58, line: 104, baseType: !63, size: 64)
!63 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !60, file: !58, line: 105, baseType: !65, size: 64, offset: 64)
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!66 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !58, line: 57, size: 192, elements: !67)
!67 = !{!68, !72, !73}
!68 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !66, file: !58, line: 58, baseType: !69, size: 64)
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 64)
!70 = !DISubroutineType(types: !71)
!71 = !{null, !5}
!72 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !66, file: !58, line: 59, baseType: !5, size: 64, offset: 64)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !66, file: !58, line: 60, baseType: !65, size: 64, offset: 128)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !60, file: !58, line: 106, baseType: !75, size: 65408, offset: 128)
!75 = !DICompositeType(tag: DW_TAG_array_type, baseType: !76, size: 65408, elements: !77)
!76 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!77 = !{!78}
!78 = !DISubrange(count: 8176)
!79 = !DILocation(line: 29, column: 15, scope: !51)
!80 = !DILocalVariable(name: "t2", scope: !51, file: !9, line: 29, type: !55)
!81 = !DILocation(line: 29, column: 19, scope: !51)
!82 = !DILocation(line: 30, column: 5, scope: !51)
!83 = !DILocation(line: 31, column: 5, scope: !51)
!84 = !DILocation(line: 33, column: 5, scope: !51)
