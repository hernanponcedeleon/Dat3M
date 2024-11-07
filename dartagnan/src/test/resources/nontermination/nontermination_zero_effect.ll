; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_zero_effect.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_zero_effect.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@lock = global i32 0, align 4, !dbg !0

; Function Attrs: noinline nounwind ssp uwtable
define void @acquireLock() #0 !dbg !23 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  br label %5, !dbg !27

5:                                                ; preds = %0, %11
  store i32 1, i32* %1, align 4, !dbg !28
  %6 = load i32, i32* %1, align 4, !dbg !28
  %7 = atomicrmw add i32* @lock, i32 %6 seq_cst, align 4, !dbg !28
  store i32 %7, i32* %2, align 4, !dbg !28
  %8 = load i32, i32* %2, align 4, !dbg !28
  %9 = icmp eq i32 %8, 0, !dbg !31
  br i1 %9, label %10, label %11, !dbg !32

10:                                               ; preds = %5
  br label %15, !dbg !33

11:                                               ; preds = %5
  store i32 -1, i32* %3, align 4, !dbg !35
  %12 = load i32, i32* %3, align 4, !dbg !35
  %13 = atomicrmw add i32* @lock, i32 %12 seq_cst, align 4, !dbg !35
  store i32 %13, i32* %4, align 4, !dbg !35
  %14 = load i32, i32* %4, align 4, !dbg !35
  br label %5, !dbg !27, !llvm.loop !36

15:                                               ; preds = %10
  ret void, !dbg !38
}

; Function Attrs: noinline nounwind ssp uwtable
define void @releaseLock() #0 !dbg !39 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 -1, i32* %1, align 4, !dbg !40
  %3 = load i32, i32* %1, align 4, !dbg !40
  %4 = atomicrmw add i32* @lock, i32 %3 seq_cst, align 4, !dbg !40
  store i32 %4, i32* %2, align 4, !dbg !40
  %5 = load i32, i32* %2, align 4, !dbg !40
  ret void, !dbg !41
}

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread(i8* noundef %0) #0 !dbg !42 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !45, metadata !DIExpression()), !dbg !46
  call void @acquireLock(), !dbg !47
  call void @releaseLock(), !dbg !48
  %4 = load i8*, i8** %2, align 8, !dbg !49
  ret i8* %4, !dbg !49
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !50 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  %4 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !53, metadata !DIExpression()), !dbg !78
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !79, metadata !DIExpression()), !dbg !80
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %4, metadata !81, metadata !DIExpression()), !dbg !82
  call void @acquireLock(), !dbg !83
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef null), !dbg !84
  %6 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef null), !dbg !85
  %7 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %4, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef null), !dbg !86
  ret i32 0, !dbg !87
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
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_zero_effect.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0}
!7 = !DIFile(filename: "benchmarks/nontermination/nontermination_zero_effect.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
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
!23 = distinct !DISubprogram(name: "acquireLock", scope: !7, file: !7, line: 11, type: !24, scopeLine: 11, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!24 = !DISubroutineType(types: !25)
!25 = !{null}
!26 = !{}
!27 = !DILocation(line: 12, column: 5, scope: !23)
!28 = !DILocation(line: 13, column: 13, scope: !29)
!29 = distinct !DILexicalBlock(scope: !30, file: !7, line: 13, column: 13)
!30 = distinct !DILexicalBlock(scope: !23, file: !7, line: 12, column: 15)
!31 = !DILocation(line: 13, column: 40, scope: !29)
!32 = !DILocation(line: 13, column: 13, scope: !30)
!33 = !DILocation(line: 14, column: 13, scope: !34)
!34 = distinct !DILexicalBlock(scope: !29, file: !7, line: 13, column: 46)
!35 = !DILocation(line: 16, column: 9, scope: !30)
!36 = distinct !{!36, !27, !37}
!37 = !DILocation(line: 17, column: 5, scope: !23)
!38 = !DILocation(line: 18, column: 1, scope: !23)
!39 = distinct !DISubprogram(name: "releaseLock", scope: !7, file: !7, line: 20, type: !24, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!40 = !DILocation(line: 21, column: 5, scope: !39)
!41 = !DILocation(line: 22, column: 1, scope: !39)
!42 = distinct !DISubprogram(name: "thread", scope: !7, file: !7, line: 24, type: !43, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!43 = !DISubroutineType(types: !44)
!44 = !{!5, !5}
!45 = !DILocalVariable(name: "unused", arg: 1, scope: !42, file: !7, line: 24, type: !5)
!46 = !DILocation(line: 24, column: 20, scope: !42)
!47 = !DILocation(line: 26, column: 5, scope: !42)
!48 = !DILocation(line: 27, column: 5, scope: !42)
!49 = !DILocation(line: 28, column: 1, scope: !42)
!50 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 30, type: !51, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!51 = !DISubroutineType(types: !52)
!52 = !{!11}
!53 = !DILocalVariable(name: "t1", scope: !50, file: !7, line: 32, type: !54)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !55, line: 31, baseType: !56)
!55 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !57, line: 118, baseType: !58)
!57 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64)
!59 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !57, line: 103, size: 65536, elements: !60)
!60 = !{!61, !63, !73}
!61 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !59, file: !57, line: 104, baseType: !62, size: 64)
!62 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !59, file: !57, line: 105, baseType: !64, size: 64, offset: 64)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 64)
!65 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !57, line: 57, size: 192, elements: !66)
!66 = !{!67, !71, !72}
!67 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !65, file: !57, line: 58, baseType: !68, size: 64)
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !69, size: 64)
!69 = !DISubroutineType(types: !70)
!70 = !{null, !5}
!71 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !65, file: !57, line: 59, baseType: !5, size: 64, offset: 64)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !65, file: !57, line: 60, baseType: !64, size: 64, offset: 128)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !59, file: !57, line: 106, baseType: !74, size: 65408, offset: 128)
!74 = !DICompositeType(tag: DW_TAG_array_type, baseType: !75, size: 65408, elements: !76)
!75 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!76 = !{!77}
!77 = !DISubrange(count: 8176)
!78 = !DILocation(line: 32, column: 15, scope: !50)
!79 = !DILocalVariable(name: "t2", scope: !50, file: !7, line: 32, type: !54)
!80 = !DILocation(line: 32, column: 19, scope: !50)
!81 = !DILocalVariable(name: "t3", scope: !50, file: !7, line: 32, type: !54)
!82 = !DILocation(line: 32, column: 23, scope: !50)
!83 = !DILocation(line: 34, column: 5, scope: !50)
!84 = !DILocation(line: 36, column: 5, scope: !50)
!85 = !DILocation(line: 37, column: 5, scope: !50)
!86 = !DILocation(line: 38, column: 5, scope: !50)
!87 = !DILocation(line: 39, column: 5, scope: !50)
