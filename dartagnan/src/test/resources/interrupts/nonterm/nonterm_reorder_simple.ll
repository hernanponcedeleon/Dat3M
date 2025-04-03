; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/termination/nonterm_reorder_simple.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/termination/nonterm_reorder_simple.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@y = global i32 0, align 4, !dbg !0
@x = global i32 0, align 4, !dbg !7

; Function Attrs: noinline nounwind ssp uwtable
define i8* @handler(i8* noundef %0) #0 !dbg !23 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !27, metadata !DIExpression()), !dbg !28
  %3 = load volatile i32, i32* @y, align 4, !dbg !29
  %4 = icmp eq i32 %3, 1, !dbg !31
  br i1 %4, label %5, label %10, !dbg !32

5:                                                ; preds = %1
  %6 = load volatile i32, i32* @x, align 4, !dbg !33
  %7 = icmp eq i32 %6, 0, !dbg !34
  br i1 %7, label %8, label %10, !dbg !35

8:                                                ; preds = %5
  br label %9, !dbg !36

9:                                                ; preds = %8, %9
  br label %9, !dbg !36, !llvm.loop !38

10:                                               ; preds = %5, %1
  ret i8* null, !dbg !40
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !41 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !44, metadata !DIExpression()), !dbg !70
  call void @__VERIFIER_make_interrupt_handler(), !dbg !70
  %4 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null), !dbg !70
  %5 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %2, align 8, !dbg !70
  store %struct._opaque_pthread_t* %5, %struct._opaque_pthread_t** %3, align 8, !dbg !70
  %6 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %3, align 8, !dbg !70
  store volatile i32 1, i32* @x, align 4, !dbg !71
  store volatile i32 1, i32* @y, align 4, !dbg !72
  ret i32 0, !dbg !73
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!12, !13, !14, !15, !16, !17, !18, !19, !20, !21}
!llvm.ident = !{!22}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !9, line: 10, type: !10, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/termination/nonterm_reorder_simple.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !0}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !9, line: 10, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "benchmarks/interrupts/termination/nonterm_reorder_simple.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
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
!23 = distinct !DISubprogram(name: "handler", scope: !9, file: !9, line: 12, type: !24, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!24 = !DISubroutineType(types: !25)
!25 = !{!5, !5}
!26 = !{}
!27 = !DILocalVariable(name: "arg", arg: 1, scope: !23, file: !9, line: 12, type: !5)
!28 = !DILocation(line: 12, column: 21, scope: !23)
!29 = !DILocation(line: 14, column: 9, scope: !30)
!30 = distinct !DILexicalBlock(scope: !23, file: !9, line: 14, column: 9)
!31 = !DILocation(line: 14, column: 11, scope: !30)
!32 = !DILocation(line: 14, column: 16, scope: !30)
!33 = !DILocation(line: 14, column: 19, scope: !30)
!34 = !DILocation(line: 14, column: 21, scope: !30)
!35 = !DILocation(line: 14, column: 9, scope: !23)
!36 = !DILocation(line: 15, column: 9, scope: !37)
!37 = distinct !DILexicalBlock(scope: !30, file: !9, line: 14, column: 27)
!38 = distinct !{!38, !36, !39}
!39 = !DILocation(line: 15, column: 22, scope: !37)
!40 = !DILocation(line: 18, column: 5, scope: !23)
!41 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 21, type: !42, scopeLine: 22, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!42 = !DISubroutineType(types: !43)
!43 = !{!11}
!44 = !DILocalVariable(name: "h", scope: !45, file: !9, line: 23, type: !46)
!45 = distinct !DILexicalBlock(scope: !41, file: !9, line: 23, column: 5)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !47, line: 31, baseType: !48)
!47 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !49, line: 118, baseType: !50)
!49 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!51 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !49, line: 103, size: 65536, elements: !52)
!52 = !{!53, !55, !65}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !51, file: !49, line: 104, baseType: !54, size: 64)
!54 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !51, file: !49, line: 105, baseType: !56, size: 64, offset: 64)
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !57, size: 64)
!57 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !49, line: 57, size: 192, elements: !58)
!58 = !{!59, !63, !64}
!59 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !57, file: !49, line: 58, baseType: !60, size: 64)
!60 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!61 = !DISubroutineType(types: !62)
!62 = !{null, !5}
!63 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !57, file: !49, line: 59, baseType: !5, size: 64, offset: 64)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !57, file: !49, line: 60, baseType: !56, size: 64, offset: 128)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !51, file: !49, line: 106, baseType: !66, size: 65408, offset: 128)
!66 = !DICompositeType(tag: DW_TAG_array_type, baseType: !67, size: 65408, elements: !68)
!67 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!68 = !{!69}
!69 = !DISubrange(count: 8176)
!70 = !DILocation(line: 23, column: 5, scope: !45)
!71 = !DILocation(line: 26, column: 7, scope: !41)
!72 = !DILocation(line: 28, column: 7, scope: !41)
!73 = !DILocation(line: 30, column: 5, scope: !41)
