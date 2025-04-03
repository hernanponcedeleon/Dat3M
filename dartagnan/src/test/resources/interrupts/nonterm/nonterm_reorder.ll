; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/termination/nonterm_reorder.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/termination/nonterm_reorder.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@z = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !12
@x = global i32 0, align 4, !dbg !7

; Function Attrs: noinline nounwind ssp uwtable
define i8* @handler(i8* noundef %0) #0 !dbg !28 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !32, metadata !DIExpression()), !dbg !33
  store atomic i32 1, i32* @z seq_cst, align 4, !dbg !34
  %3 = load volatile i32, i32* @y, align 4, !dbg !35
  %4 = icmp eq i32 %3, 1, !dbg !37
  br i1 %4, label %5, label %11, !dbg !38

5:                                                ; preds = %1
  br label %6, !dbg !39

6:                                                ; preds = %9, %5
  %7 = load volatile i32, i32* @y, align 4, !dbg !41
  %8 = icmp eq i32 %7, 0, !dbg !42
  br i1 %8, label %9, label %10, !dbg !39

9:                                                ; preds = %6
  br label %6, !dbg !39, !llvm.loop !43

10:                                               ; preds = %6
  br label %11, !dbg !46

11:                                               ; preds = %10, %1
  ret i8* null, !dbg !47
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread(i8* noundef %0) #0 !dbg !48 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !49, metadata !DIExpression()), !dbg !50
  %4 = load atomic i32, i32* @z seq_cst, align 4, !dbg !51
  %5 = icmp eq i32 %4, 1, !dbg !53
  br i1 %5, label %6, label %10, !dbg !54

6:                                                ; preds = %1
  %7 = load volatile i32, i32* @x, align 4, !dbg !55
  %8 = icmp eq i32 %7, 0, !dbg !56
  br i1 %8, label %9, label %10, !dbg !57

9:                                                ; preds = %6
  store volatile i32 0, i32* @y, align 4, !dbg !58
  br label %10, !dbg !60

10:                                               ; preds = %9, %6, %1
  %11 = load i8*, i8** %2, align 8, !dbg !61
  ret i8* %11, !dbg !61
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !62 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  %4 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !65, metadata !DIExpression()), !dbg !91
  call void @__VERIFIER_make_interrupt_handler(), !dbg !91
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null), !dbg !91
  %6 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %2, align 8, !dbg !91
  store %struct._opaque_pthread_t* %6, %struct._opaque_pthread_t** %3, align 8, !dbg !91
  %7 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %3, align 8, !dbg !91
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %4, metadata !92, metadata !DIExpression()), !dbg !93
  %8 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %4, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef null), !dbg !94
  store volatile i32 1, i32* @x, align 4, !dbg !95
  store volatile i32 1, i32* @y, align 4, !dbg !96
  ret i32 0, !dbg !97
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!17, !18, !19, !20, !21, !22, !23, !24, !25, !26}
!llvm.ident = !{!27}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !9, line: 11, type: !14, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/termination/nonterm_reorder.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !12, !0}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !9, line: 10, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "benchmarks/interrupts/termination/nonterm_reorder.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!10 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !11)
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !9, line: 10, type: !10, isLocal: false, isDefinition: true)
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !15, line: 92, baseType: !16)
!15 = !DIFile(filename: "/opt/homebrew/Cellar/llvm@14/14.0.6/lib/clang/14.0.6/include/stdatomic.h", directory: "")
!16 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !11)
!17 = !{i32 7, !"Dwarf Version", i32 4}
!18 = !{i32 2, !"Debug Info Version", i32 3}
!19 = !{i32 1, !"wchar_size", i32 4}
!20 = !{i32 1, !"branch-target-enforcement", i32 0}
!21 = !{i32 1, !"sign-return-address", i32 0}
!22 = !{i32 1, !"sign-return-address-all", i32 0}
!23 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!24 = !{i32 7, !"PIC Level", i32 2}
!25 = !{i32 7, !"uwtable", i32 1}
!26 = !{i32 7, !"frame-pointer", i32 1}
!27 = !{!"Homebrew clang version 14.0.6"}
!28 = distinct !DISubprogram(name: "handler", scope: !9, file: !9, line: 13, type: !29, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !31)
!29 = !DISubroutineType(types: !30)
!30 = !{!5, !5}
!31 = !{}
!32 = !DILocalVariable(name: "arg", arg: 1, scope: !28, file: !9, line: 13, type: !5)
!33 = !DILocation(line: 13, column: 21, scope: !28)
!34 = !DILocation(line: 15, column: 7, scope: !28)
!35 = !DILocation(line: 16, column: 9, scope: !36)
!36 = distinct !DILexicalBlock(scope: !28, file: !9, line: 16, column: 9)
!37 = !DILocation(line: 16, column: 11, scope: !36)
!38 = !DILocation(line: 16, column: 9, scope: !28)
!39 = !DILocation(line: 17, column: 9, scope: !40)
!40 = distinct !DILexicalBlock(scope: !36, file: !9, line: 16, column: 17)
!41 = !DILocation(line: 17, column: 16, scope: !40)
!42 = !DILocation(line: 17, column: 18, scope: !40)
!43 = distinct !{!43, !39, !44, !45}
!44 = !DILocation(line: 17, column: 27, scope: !40)
!45 = !{!"llvm.loop.mustprogress"}
!46 = !DILocation(line: 18, column: 5, scope: !40)
!47 = !DILocation(line: 20, column: 5, scope: !28)
!48 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 23, type: !29, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !31)
!49 = !DILocalVariable(name: "arg", arg: 1, scope: !48, file: !9, line: 23, type: !5)
!50 = !DILocation(line: 23, column: 20, scope: !48)
!51 = !DILocation(line: 24, column: 9, scope: !52)
!52 = distinct !DILexicalBlock(scope: !48, file: !9, line: 24, column: 9)
!53 = !DILocation(line: 24, column: 11, scope: !52)
!54 = !DILocation(line: 24, column: 16, scope: !52)
!55 = !DILocation(line: 24, column: 19, scope: !52)
!56 = !DILocation(line: 24, column: 21, scope: !52)
!57 = !DILocation(line: 24, column: 9, scope: !48)
!58 = !DILocation(line: 25, column: 11, scope: !59)
!59 = distinct !DILexicalBlock(scope: !52, file: !9, line: 24, column: 27)
!60 = !DILocation(line: 26, column: 5, scope: !59)
!61 = !DILocation(line: 27, column: 1, scope: !48)
!62 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 29, type: !63, scopeLine: 30, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !31)
!63 = !DISubroutineType(types: !64)
!64 = !{!11}
!65 = !DILocalVariable(name: "h", scope: !66, file: !9, line: 31, type: !67)
!66 = distinct !DILexicalBlock(scope: !62, file: !9, line: 31, column: 5)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !68, line: 31, baseType: !69)
!68 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!69 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !70, line: 118, baseType: !71)
!70 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !72, size: 64)
!72 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !70, line: 103, size: 65536, elements: !73)
!73 = !{!74, !76, !86}
!74 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !72, file: !70, line: 104, baseType: !75, size: 64)
!75 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !72, file: !70, line: 105, baseType: !77, size: 64, offset: 64)
!77 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !78, size: 64)
!78 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !70, line: 57, size: 192, elements: !79)
!79 = !{!80, !84, !85}
!80 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !78, file: !70, line: 58, baseType: !81, size: 64)
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !82, size: 64)
!82 = !DISubroutineType(types: !83)
!83 = !{null, !5}
!84 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !78, file: !70, line: 59, baseType: !5, size: 64, offset: 64)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !78, file: !70, line: 60, baseType: !77, size: 64, offset: 128)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !72, file: !70, line: 106, baseType: !87, size: 65408, offset: 128)
!87 = !DICompositeType(tag: DW_TAG_array_type, baseType: !88, size: 65408, elements: !89)
!88 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!89 = !{!90}
!90 = !DISubrange(count: 8176)
!91 = !DILocation(line: 31, column: 5, scope: !66)
!92 = !DILocalVariable(name: "t", scope: !62, file: !9, line: 32, type: !67)
!93 = !DILocation(line: 32, column: 15, scope: !62)
!94 = !DILocation(line: 33, column: 5, scope: !62)
!95 = !DILocation(line: 36, column: 7, scope: !62)
!96 = !DILocation(line: 38, column: 7, scope: !62)
!97 = !DILocation(line: 40, column: 5, scope: !62)
