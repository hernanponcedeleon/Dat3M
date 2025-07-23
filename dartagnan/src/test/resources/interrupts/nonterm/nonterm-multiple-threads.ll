; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/termination/nonterm-multiple-threads.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/termination/nonterm-multiple-threads.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@y = global i32 0, align 4, !dbg !0
@x = global i32 0, align 4, !dbg !7

; Function Attrs: noinline nounwind ssp uwtable
define i8* @ih1(i8* noundef %0) #0 !dbg !23 {
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
  br label %4, !dbg !29, !llvm.loop !32

8:                                                ; preds = %4
  %9 = load i8*, i8** %2, align 8, !dbg !35
  ret i8* %9, !dbg !35
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i8* @ih2(i8* noundef %0) #0 !dbg !36 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !37, metadata !DIExpression()), !dbg !38
  br label %4, !dbg !39

4:                                                ; preds = %7, %1
  %5 = load volatile i32, i32* @x, align 4, !dbg !40
  %6 = icmp ne i32 %5, 1, !dbg !41
  br i1 %6, label %7, label %8, !dbg !39

7:                                                ; preds = %4
  br label %4, !dbg !39, !llvm.loop !42

8:                                                ; preds = %4
  %9 = load i8*, i8** %2, align 8, !dbg !44
  ret i8* %9, !dbg !44
}

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread1(i8* noundef %0) #0 !dbg !45 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca %struct._opaque_pthread_t*, align 8
  %5 = alloca %struct._opaque_pthread_t*, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !46, metadata !DIExpression()), !dbg !47
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %4, metadata !48, metadata !DIExpression()), !dbg !74
  call void @__VERIFIER_make_interrupt_handler(), !dbg !74
  %6 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %4, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @ih1, i8* noundef null), !dbg !74
  %7 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %4, align 8, !dbg !74
  store %struct._opaque_pthread_t* %7, %struct._opaque_pthread_t** %5, align 8, !dbg !74
  %8 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %5, align 8, !dbg !74
  store volatile i32 1, i32* @x, align 4, !dbg !75
  %9 = load i8*, i8** %2, align 8, !dbg !76
  ret i8* %9, !dbg !76
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread2(i8* noundef %0) #0 !dbg !77 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca %struct._opaque_pthread_t*, align 8
  %5 = alloca %struct._opaque_pthread_t*, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !78, metadata !DIExpression()), !dbg !79
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %4, metadata !80, metadata !DIExpression()), !dbg !82
  call void @__VERIFIER_make_interrupt_handler(), !dbg !82
  %6 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %4, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @ih2, i8* noundef null), !dbg !82
  %7 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %4, align 8, !dbg !82
  store %struct._opaque_pthread_t* %7, %struct._opaque_pthread_t** %5, align 8, !dbg !82
  %8 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %5, align 8, !dbg !82
  store volatile i32 1, i32* @y, align 4, !dbg !83
  %9 = load i8*, i8** %2, align 8, !dbg !84
  ret i8* %9, !dbg !84
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !85 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !88, metadata !DIExpression()), !dbg !89
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !90, metadata !DIExpression()), !dbg !91
  %4 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread1, i8* noundef null), !dbg !92
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread2, i8* noundef null), !dbg !93
  %6 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %2, align 8, !dbg !94
  %7 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %6, i8** noundef null), !dbg !95
  %8 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %3, align 8, !dbg !96
  %9 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %8, i8** noundef null), !dbg !97
  ret i32 0, !dbg !98
}

declare i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef, i8** noundef) #2

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!12, !13, !14, !15, !16, !17, !18, !19, !20, !21}
!llvm.ident = !{!22}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !9, line: 15, type: !10, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/termination/nonterm-multiple-threads.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !0}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !9, line: 15, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "benchmarks/interrupts/termination/nonterm-multiple-threads.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
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
!23 = distinct !DISubprogram(name: "ih1", scope: !9, file: !9, line: 17, type: !24, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!24 = !DISubroutineType(types: !25)
!25 = !{!5, !5}
!26 = !{}
!27 = !DILocalVariable(name: "arg", arg: 1, scope: !23, file: !9, line: 17, type: !5)
!28 = !DILocation(line: 17, column: 17, scope: !23)
!29 = !DILocation(line: 18, column: 5, scope: !23)
!30 = !DILocation(line: 18, column: 12, scope: !23)
!31 = !DILocation(line: 18, column: 14, scope: !23)
!32 = distinct !{!32, !29, !33, !34}
!33 = !DILocation(line: 18, column: 19, scope: !23)
!34 = !{!"llvm.loop.mustprogress"}
!35 = !DILocation(line: 19, column: 1, scope: !23)
!36 = distinct !DISubprogram(name: "ih2", scope: !9, file: !9, line: 21, type: !24, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!37 = !DILocalVariable(name: "arg", arg: 1, scope: !36, file: !9, line: 21, type: !5)
!38 = !DILocation(line: 21, column: 17, scope: !36)
!39 = !DILocation(line: 22, column: 5, scope: !36)
!40 = !DILocation(line: 22, column: 12, scope: !36)
!41 = !DILocation(line: 22, column: 14, scope: !36)
!42 = distinct !{!42, !39, !43, !34}
!43 = !DILocation(line: 22, column: 19, scope: !36)
!44 = !DILocation(line: 23, column: 1, scope: !36)
!45 = distinct !DISubprogram(name: "thread1", scope: !9, file: !9, line: 25, type: !24, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!46 = !DILocalVariable(name: "arg", arg: 1, scope: !45, file: !9, line: 25, type: !5)
!47 = !DILocation(line: 25, column: 21, scope: !45)
!48 = !DILocalVariable(name: "h", scope: !49, file: !9, line: 26, type: !50)
!49 = distinct !DILexicalBlock(scope: !45, file: !9, line: 26, column: 5)
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !51, line: 31, baseType: !52)
!51 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !53, line: 118, baseType: !54)
!53 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!54 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !55, size: 64)
!55 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !53, line: 103, size: 65536, elements: !56)
!56 = !{!57, !59, !69}
!57 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !55, file: !53, line: 104, baseType: !58, size: 64)
!58 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !55, file: !53, line: 105, baseType: !60, size: 64, offset: 64)
!60 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!61 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !53, line: 57, size: 192, elements: !62)
!62 = !{!63, !67, !68}
!63 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !61, file: !53, line: 58, baseType: !64, size: 64)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 64)
!65 = !DISubroutineType(types: !66)
!66 = !{null, !5}
!67 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !61, file: !53, line: 59, baseType: !5, size: 64, offset: 64)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !61, file: !53, line: 60, baseType: !60, size: 64, offset: 128)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !55, file: !53, line: 106, baseType: !70, size: 65408, offset: 128)
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !71, size: 65408, elements: !72)
!71 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!72 = !{!73}
!73 = !DISubrange(count: 8176)
!74 = !DILocation(line: 26, column: 5, scope: !49)
!75 = !DILocation(line: 28, column: 7, scope: !45)
!76 = !DILocation(line: 29, column: 1, scope: !45)
!77 = distinct !DISubprogram(name: "thread2", scope: !9, file: !9, line: 31, type: !24, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!78 = !DILocalVariable(name: "arg", arg: 1, scope: !77, file: !9, line: 31, type: !5)
!79 = !DILocation(line: 31, column: 21, scope: !77)
!80 = !DILocalVariable(name: "h", scope: !81, file: !9, line: 32, type: !50)
!81 = distinct !DILexicalBlock(scope: !77, file: !9, line: 32, column: 5)
!82 = !DILocation(line: 32, column: 5, scope: !81)
!83 = !DILocation(line: 34, column: 7, scope: !77)
!84 = !DILocation(line: 35, column: 1, scope: !77)
!85 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 37, type: !86, scopeLine: 38, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!86 = !DISubroutineType(types: !87)
!87 = !{!11}
!88 = !DILocalVariable(name: "t1", scope: !85, file: !9, line: 39, type: !50)
!89 = !DILocation(line: 39, column: 15, scope: !85)
!90 = !DILocalVariable(name: "t2", scope: !85, file: !9, line: 39, type: !50)
!91 = !DILocation(line: 39, column: 19, scope: !85)
!92 = !DILocation(line: 41, column: 5, scope: !85)
!93 = !DILocation(line: 42, column: 5, scope: !85)
!94 = !DILocation(line: 44, column: 18, scope: !85)
!95 = !DILocation(line: 44, column: 5, scope: !85)
!96 = !DILocation(line: 45, column: 18, scope: !85)
!97 = !DILocation(line: 45, column: 5, scope: !85)
!98 = !DILocation(line: 47, column: 5, scope: !85)
