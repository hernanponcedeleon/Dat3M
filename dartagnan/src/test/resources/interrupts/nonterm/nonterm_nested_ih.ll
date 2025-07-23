; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/termination/nonterm_nested_ih.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/termination/nonterm_nested_ih.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@x = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !7
@z = global i32 0, align 4, !dbg !12

; Function Attrs: noinline nounwind ssp uwtable
define i8* @handler2(i8* noundef %0) #0 !dbg !25 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !29, metadata !DIExpression()), !dbg !30
  %3 = load volatile i32, i32* @x, align 4, !dbg !31
  %4 = icmp eq i32 %3, 0, !dbg !33
  br i1 %4, label %5, label %16, !dbg !34

5:                                                ; preds = %1
  br label %6, !dbg !35

6:                                                ; preds = %14, %5
  %7 = load volatile i32, i32* @y, align 4, !dbg !37
  %8 = icmp eq i32 %7, 1, !dbg !38
  br i1 %8, label %9, label %12, !dbg !39

9:                                                ; preds = %6
  %10 = load volatile i32, i32* @z, align 4, !dbg !40
  %11 = icmp eq i32 %10, 1, !dbg !41
  br label %12

12:                                               ; preds = %9, %6
  %13 = phi i1 [ false, %6 ], [ %11, %9 ], !dbg !42
  br i1 %13, label %14, label %15, !dbg !35

14:                                               ; preds = %12
  br label %6, !dbg !35, !llvm.loop !43

15:                                               ; preds = %12
  br label %16, !dbg !46

16:                                               ; preds = %15, %1
  ret i8* null, !dbg !47
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i8* @handler(i8* noundef %0) #0 !dbg !48 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  %4 = alloca %struct._opaque_pthread_t*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !49, metadata !DIExpression()), !dbg !50
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !51, metadata !DIExpression()), !dbg !77
  call void @__VERIFIER_make_interrupt_handler(), !dbg !77
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @handler2, i8* noundef null), !dbg !77
  %6 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %3, align 8, !dbg !77
  store %struct._opaque_pthread_t* %6, %struct._opaque_pthread_t** %4, align 8, !dbg !77
  %7 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %4, align 8, !dbg !77
  store volatile i32 1, i32* @x, align 4, !dbg !78
  store volatile i32 1, i32* @z, align 4, !dbg !79
  ret i8* null, !dbg !80
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !81 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !84, metadata !DIExpression()), !dbg !86
  call void @__VERIFIER_make_interrupt_handler(), !dbg !86
  %4 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null), !dbg !86
  %5 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %2, align 8, !dbg !86
  store %struct._opaque_pthread_t* %5, %struct._opaque_pthread_t** %3, align 8, !dbg !86
  %6 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %3, align 8, !dbg !86
  store volatile i32 1, i32* @x, align 4, !dbg !87
  store volatile i32 1, i32* @y, align 4, !dbg !88
  ret i32 0, !dbg !89
}

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!14, !15, !16, !17, !18, !19, !20, !21, !22, !23}
!llvm.ident = !{!24}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !9, line: 10, type: !10, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/termination/nonterm_nested_ih.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !12}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !9, line: 10, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "benchmarks/interrupts/termination/nonterm_nested_ih.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
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
!25 = distinct !DISubprogram(name: "handler2", scope: !9, file: !9, line: 12, type: !26, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!26 = !DISubroutineType(types: !27)
!27 = !{!5, !5}
!28 = !{}
!29 = !DILocalVariable(name: "arg", arg: 1, scope: !25, file: !9, line: 12, type: !5)
!30 = !DILocation(line: 12, column: 22, scope: !25)
!31 = !DILocation(line: 14, column: 9, scope: !32)
!32 = distinct !DILexicalBlock(scope: !25, file: !9, line: 14, column: 9)
!33 = !DILocation(line: 14, column: 11, scope: !32)
!34 = !DILocation(line: 14, column: 9, scope: !25)
!35 = !DILocation(line: 15, column: 9, scope: !36)
!36 = distinct !DILexicalBlock(scope: !32, file: !9, line: 14, column: 17)
!37 = !DILocation(line: 15, column: 16, scope: !36)
!38 = !DILocation(line: 15, column: 18, scope: !36)
!39 = !DILocation(line: 15, column: 23, scope: !36)
!40 = !DILocation(line: 15, column: 26, scope: !36)
!41 = !DILocation(line: 15, column: 28, scope: !36)
!42 = !DILocation(line: 0, scope: !36)
!43 = distinct !{!43, !35, !44, !45}
!44 = !DILocation(line: 15, column: 35, scope: !36)
!45 = !{!"llvm.loop.mustprogress"}
!46 = !DILocation(line: 16, column: 5, scope: !36)
!47 = !DILocation(line: 18, column: 5, scope: !25)
!48 = distinct !DISubprogram(name: "handler", scope: !9, file: !9, line: 21, type: !26, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!49 = !DILocalVariable(name: "arg", arg: 1, scope: !48, file: !9, line: 21, type: !5)
!50 = !DILocation(line: 21, column: 21, scope: !48)
!51 = !DILocalVariable(name: "h", scope: !52, file: !9, line: 23, type: !53)
!52 = distinct !DILexicalBlock(scope: !48, file: !9, line: 23, column: 5)
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
!77 = !DILocation(line: 23, column: 5, scope: !52)
!78 = !DILocation(line: 24, column: 7, scope: !48)
!79 = !DILocation(line: 26, column: 7, scope: !48)
!80 = !DILocation(line: 28, column: 5, scope: !48)
!81 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 31, type: !82, scopeLine: 32, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!82 = !DISubroutineType(types: !83)
!83 = !{!11}
!84 = !DILocalVariable(name: "h", scope: !85, file: !9, line: 33, type: !53)
!85 = distinct !DILexicalBlock(scope: !81, file: !9, line: 33, column: 5)
!86 = !DILocation(line: 33, column: 5, scope: !85)
!87 = !DILocation(line: 34, column: 7, scope: !81)
!88 = !DILocation(line: 36, column: 7, scope: !81)
!89 = !DILocation(line: 38, column: 5, scope: !81)
