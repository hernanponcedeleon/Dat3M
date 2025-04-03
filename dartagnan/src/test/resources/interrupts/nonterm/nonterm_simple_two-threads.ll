; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/termination/nonterm_simple_two-threads.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/termination/nonterm_simple_two-threads.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@x = global i32 0, align 4, !dbg !0
@z = global i32 0, align 4, !dbg !12
@y = global i32 0, align 4, !dbg !7

; Function Attrs: noinline nounwind ssp uwtable
define i8* @handler(i8* noundef %0) #0 !dbg !25 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !29, metadata !DIExpression()), !dbg !30
  %3 = load volatile i32, i32* @x, align 4, !dbg !31
  %4 = icmp eq i32 %3, 1, !dbg !33
  br i1 %4, label %5, label %11, !dbg !34

5:                                                ; preds = %1
  br label %6, !dbg !35

6:                                                ; preds = %9, %5
  %7 = load volatile i32, i32* @z, align 4, !dbg !37
  %8 = icmp eq i32 %7, 0, !dbg !38
  br i1 %8, label %9, label %10, !dbg !35

9:                                                ; preds = %6
  br label %6, !dbg !35, !llvm.loop !39

10:                                               ; preds = %6
  br label %11, !dbg !42

11:                                               ; preds = %10, %1
  ret i8* null, !dbg !43
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread(i8* noundef %0) #0 !dbg !44 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !45, metadata !DIExpression()), !dbg !46
  br label %4, !dbg !47

4:                                                ; preds = %7, %1
  %5 = load volatile i32, i32* @y, align 4, !dbg !48
  %6 = icmp eq i32 %5, 0, !dbg !49
  br i1 %6, label %7, label %8, !dbg !47

7:                                                ; preds = %4
  br label %4, !dbg !47, !llvm.loop !50

8:                                                ; preds = %4
  store volatile i32 1, i32* @z, align 4, !dbg !52
  %9 = load i8*, i8** %2, align 8, !dbg !53
  ret i8* %9, !dbg !53
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !54 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  %4 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !57, metadata !DIExpression()), !dbg !83
  call void @__VERIFIER_make_interrupt_handler(), !dbg !83
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null), !dbg !83
  %6 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %2, align 8, !dbg !83
  store %struct._opaque_pthread_t* %6, %struct._opaque_pthread_t** %3, align 8, !dbg !83
  %7 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %3, align 8, !dbg !83
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %4, metadata !84, metadata !DIExpression()), !dbg !85
  %8 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %4, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef null), !dbg !86
  store volatile i32 1, i32* @x, align 4, !dbg !87
  store volatile i32 1, i32* @y, align 4, !dbg !88
  ret i32 0, !dbg !89
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!14, !15, !16, !17, !18, !19, !20, !21, !22, !23}
!llvm.ident = !{!24}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !9, line: 10, type: !10, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/termination/nonterm_simple_two-threads.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !12}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !9, line: 10, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "benchmarks/interrupts/termination/nonterm_simple_two-threads.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!10 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !11)
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !9, line: 10, type: !10, isLocal: false, isDefinition: true)
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
!25 = distinct !DISubprogram(name: "handler", scope: !9, file: !9, line: 12, type: !26, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!26 = !DISubroutineType(types: !27)
!27 = !{!5, !5}
!28 = !{}
!29 = !DILocalVariable(name: "arg", arg: 1, scope: !25, file: !9, line: 12, type: !5)
!30 = !DILocation(line: 12, column: 21, scope: !25)
!31 = !DILocation(line: 14, column: 9, scope: !32)
!32 = distinct !DILexicalBlock(scope: !25, file: !9, line: 14, column: 9)
!33 = !DILocation(line: 14, column: 11, scope: !32)
!34 = !DILocation(line: 14, column: 9, scope: !25)
!35 = !DILocation(line: 15, column: 9, scope: !36)
!36 = distinct !DILexicalBlock(scope: !32, file: !9, line: 14, column: 17)
!37 = !DILocation(line: 15, column: 16, scope: !36)
!38 = !DILocation(line: 15, column: 18, scope: !36)
!39 = distinct !{!39, !35, !40, !41}
!40 = !DILocation(line: 15, column: 27, scope: !36)
!41 = !{!"llvm.loop.mustprogress"}
!42 = !DILocation(line: 16, column: 5, scope: !36)
!43 = !DILocation(line: 18, column: 5, scope: !25)
!44 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 21, type: !26, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!45 = !DILocalVariable(name: "arg", arg: 1, scope: !44, file: !9, line: 21, type: !5)
!46 = !DILocation(line: 21, column: 20, scope: !44)
!47 = !DILocation(line: 22, column: 5, scope: !44)
!48 = !DILocation(line: 22, column: 12, scope: !44)
!49 = !DILocation(line: 22, column: 14, scope: !44)
!50 = distinct !{!50, !47, !51, !41}
!51 = !DILocation(line: 22, column: 22, scope: !44)
!52 = !DILocation(line: 23, column: 7, scope: !44)
!53 = !DILocation(line: 24, column: 1, scope: !44)
!54 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 26, type: !55, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!55 = !DISubroutineType(types: !56)
!56 = !{!11}
!57 = !DILocalVariable(name: "h", scope: !58, file: !9, line: 28, type: !59)
!58 = distinct !DILexicalBlock(scope: !54, file: !9, line: 28, column: 5)
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !60, line: 31, baseType: !61)
!60 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !62, line: 118, baseType: !63)
!62 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!63 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !64, size: 64)
!64 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !62, line: 103, size: 65536, elements: !65)
!65 = !{!66, !68, !78}
!66 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !64, file: !62, line: 104, baseType: !67, size: 64)
!67 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !64, file: !62, line: 105, baseType: !69, size: 64, offset: 64)
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 64)
!70 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !62, line: 57, size: 192, elements: !71)
!71 = !{!72, !76, !77}
!72 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !70, file: !62, line: 58, baseType: !73, size: 64)
!73 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !74, size: 64)
!74 = !DISubroutineType(types: !75)
!75 = !{null, !5}
!76 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !70, file: !62, line: 59, baseType: !5, size: 64, offset: 64)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !70, file: !62, line: 60, baseType: !69, size: 64, offset: 128)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !64, file: !62, line: 106, baseType: !79, size: 65408, offset: 128)
!79 = !DICompositeType(tag: DW_TAG_array_type, baseType: !80, size: 65408, elements: !81)
!80 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!81 = !{!82}
!82 = !DISubrange(count: 8176)
!83 = !DILocation(line: 28, column: 5, scope: !58)
!84 = !DILocalVariable(name: "t", scope: !54, file: !9, line: 30, type: !59)
!85 = !DILocation(line: 30, column: 15, scope: !54)
!86 = !DILocation(line: 31, column: 5, scope: !54)
!87 = !DILocation(line: 33, column: 7, scope: !54)
!88 = !DILocation(line: 35, column: 7, scope: !54)
!89 = !DILocation(line: 37, column: 5, scope: !54)
