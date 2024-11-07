; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_xchg.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_xchg.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@lock = global i32 0, align 4, !dbg !0

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread(i8* noundef %0) #0 !dbg !23 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !27, metadata !DIExpression()), !dbg !28
  br label %5, !dbg !29

5:                                                ; preds = %10, %1
  store i32 1, i32* %3, align 4, !dbg !30
  %6 = load i32, i32* %3, align 4, !dbg !30
  %7 = atomicrmw xchg i32* @lock, i32 %6 seq_cst, align 4, !dbg !30
  store i32 %7, i32* %4, align 4, !dbg !30
  %8 = load i32, i32* %4, align 4, !dbg !30
  %9 = icmp ne i32 %8, 0, !dbg !31
  br i1 %9, label %10, label %11, !dbg !29

10:                                               ; preds = %5
  br label %5, !dbg !29, !llvm.loop !32

11:                                               ; preds = %5
  ret i8* null, !dbg !35
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread2(i8* noundef %0) #0 !dbg !36 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !37, metadata !DIExpression()), !dbg !38
  store i32 1, i32* %3, align 4, !dbg !39
  %5 = load i32, i32* %3, align 4, !dbg !39
  %6 = atomicrmw xchg i32* @lock, i32 %5 seq_cst, align 4, !dbg !39
  store i32 %6, i32* %4, align 4, !dbg !39
  %7 = load i32, i32* %4, align 4, !dbg !39
  ret i8* null, !dbg !40
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !41 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !44, metadata !DIExpression()), !dbg !69
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !70, metadata !DIExpression()), !dbg !71
  %4 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef null), !dbg !72
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread2, i8* noundef null), !dbg !73
  ret i32 0, !dbg !74
}

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!12, !13, !14, !15, !16, !17, !18, !19, !20, !21}
!llvm.ident = !{!22}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !7, line: 9, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_xchg.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0}
!7 = !DIFile(filename: "benchmarks/nontermination/nontermination_xchg.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
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
!29 = !DILocation(line: 13, column: 5, scope: !23)
!30 = !DILocation(line: 13, column: 12, scope: !23)
!31 = !DILocation(line: 13, column: 38, scope: !23)
!32 = distinct !{!32, !29, !33, !34}
!33 = !DILocation(line: 13, column: 43, scope: !23)
!34 = !{!"llvm.loop.mustprogress"}
!35 = !DILocation(line: 14, column: 5, scope: !23)
!36 = distinct !DISubprogram(name: "thread2", scope: !7, file: !7, line: 17, type: !24, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!37 = !DILocalVariable(name: "unused", arg: 1, scope: !36, file: !7, line: 17, type: !5)
!38 = !DILocation(line: 17, column: 21, scope: !36)
!39 = !DILocation(line: 18, column: 5, scope: !36)
!40 = !DILocation(line: 19, column: 5, scope: !36)
!41 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 22, type: !42, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!42 = !DISubroutineType(types: !43)
!43 = !{!11}
!44 = !DILocalVariable(name: "t1", scope: !41, file: !7, line: 24, type: !45)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !46, line: 31, baseType: !47)
!46 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!47 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !48, line: 118, baseType: !49)
!48 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!50 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !48, line: 103, size: 65536, elements: !51)
!51 = !{!52, !54, !64}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !50, file: !48, line: 104, baseType: !53, size: 64)
!53 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !50, file: !48, line: 105, baseType: !55, size: 64, offset: 64)
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!56 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !48, line: 57, size: 192, elements: !57)
!57 = !{!58, !62, !63}
!58 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !56, file: !48, line: 58, baseType: !59, size: 64)
!59 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!60 = !DISubroutineType(types: !61)
!61 = !{null, !5}
!62 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !56, file: !48, line: 59, baseType: !5, size: 64, offset: 64)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !56, file: !48, line: 60, baseType: !55, size: 64, offset: 128)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !50, file: !48, line: 106, baseType: !65, size: 65408, offset: 128)
!65 = !DICompositeType(tag: DW_TAG_array_type, baseType: !66, size: 65408, elements: !67)
!66 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!67 = !{!68}
!68 = !DISubrange(count: 8176)
!69 = !DILocation(line: 24, column: 15, scope: !41)
!70 = !DILocalVariable(name: "t2", scope: !41, file: !7, line: 24, type: !45)
!71 = !DILocation(line: 24, column: 19, scope: !41)
!72 = !DILocation(line: 26, column: 5, scope: !41)
!73 = !DILocation(line: 27, column: 5, scope: !41)
!74 = !DILocation(line: 29, column: 5, scope: !41)
