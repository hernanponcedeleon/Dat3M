; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/output/verifierAssertNoDeps.ll'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/c/miscellaneous/verifierAssertNoDeps.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx13.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !18

; Function Attrs: noinline nounwind ssp uwtable
define dso_local i8* @thread_1(i8* %0) #0 !dbg !33 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !37, metadata !DIExpression()), !dbg !38
  %2 = load atomic i32, i32* @x monotonic, align 4, !dbg !39
  call void @llvm.dbg.value(metadata i32 %2, metadata !40, metadata !DIExpression()), !dbg !38
  %3 = icmp eq i32 %2, 0, !dbg !41
  %4 = zext i1 %3 to i32, !dbg !41
  call void @__VERIFIER_assert(i32 %4), !dbg !42
  store atomic i32 1, i32* @y monotonic, align 4, !dbg !43
  ret i8* null, !dbg !44
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__VERIFIER_assert(i32) #2

; Function Attrs: noinline nounwind ssp uwtable
define dso_local i8* @thread_2(i8* %0) #0 !dbg !45 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !46, metadata !DIExpression()), !dbg !47
  %2 = load atomic i32, i32* @y monotonic, align 4, !dbg !48
  call void @llvm.dbg.value(metadata i32 %2, metadata !49, metadata !DIExpression()), !dbg !47
  %3 = icmp eq i32 %2, 1, !dbg !50
  br i1 %3, label %4, label %5, !dbg !52

4:                                                ; preds = %1
  store atomic i32 1, i32* @x monotonic, align 4, !dbg !53
  br label %5, !dbg !55

5:                                                ; preds = %4, %1
  ret i8* null, !dbg !56
}

; Function Attrs: noinline nounwind ssp uwtable
define dso_local i32 @main() #0 !dbg !57 {
  %1 = alloca %struct._opaque_pthread_t*, align 8
  %2 = alloca %struct._opaque_pthread_t*, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %1, metadata !60, metadata !DIExpression()), !dbg !85
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !86, metadata !DIExpression()), !dbg !87
  %3 = call i32 @pthread_create(%struct._opaque_pthread_t** %1, %struct._opaque_pthread_attr_t* null, i8* (i8*)* @thread_1, i8* null), !dbg !88
  %4 = call i32 @pthread_create(%struct._opaque_pthread_t** %2, %struct._opaque_pthread_attr_t* null, i8* (i8*)* @thread_2, i8* null), !dbg !89
  %5 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %1, align 8, !dbg !90
  %6 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* %5, i8** null), !dbg !91
  %7 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %2, align 8, !dbg !92
  %8 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* %7, i8** null), !dbg !93
  ret i32 0, !dbg !94
}

declare i32 @pthread_create(%struct._opaque_pthread_t**, %struct._opaque_pthread_attr_t*, i8* (i8*)*, i8*) #2

declare i32 @"\01_pthread_join"(%struct._opaque_pthread_t*, i8**) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind ssp uwtable "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-a12" "target-features"="+aes,+crc,+crypto,+fp-armv8,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.3a,+zcm,+zcz" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-a12" "target-features"="+aes,+crc,+crypto,+fp-armv8,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.3a,+zcm,+zcz" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!24, !25, !26, !27, !28, !29, !30, !31}
!llvm.ident = !{!32}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !20, line: 11, type: !21, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 12.0.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/c/miscellaneous/verifierAssertNoDeps.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 47, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/opt/homebrew/Cellar/llvm@12/12.0.1_1/lib/clang/12.0.1/include/stdatomic.h", directory: "")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2, isUnsigned: true)
!12 = !DIEnumerator(name: "memory_order_release", value: 3, isUnsigned: true)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4, isUnsigned: true)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5, isUnsigned: true)
!15 = !{!16}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !{!0, !18}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !20, line: 11, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/c/miscellaneous/verifierAssertNoDeps.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 83, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !{i32 7, !"Dwarf Version", i32 4}
!25 = !{i32 2, !"Debug Info Version", i32 3}
!26 = !{i32 1, !"wchar_size", i32 4}
!27 = !{i32 1, !"branch-target-enforcement", i32 0}
!28 = !{i32 1, !"sign-return-address", i32 0}
!29 = !{i32 1, !"sign-return-address-all", i32 0}
!30 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!31 = !{i32 7, !"PIC Level", i32 2}
!32 = !{!"Homebrew clang version 12.0.1"}
!33 = distinct !DISubprogram(name: "thread_1", scope: !20, file: !20, line: 13, type: !34, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !36)
!34 = !DISubroutineType(types: !35)
!35 = !{!16, !16}
!36 = !{}
!37 = !DILocalVariable(name: "unused", arg: 1, scope: !33, file: !20, line: 13, type: !16)
!38 = !DILocation(line: 0, scope: !33)
!39 = !DILocation(line: 15, column: 13, scope: !33)
!40 = !DILocalVariable(name: "r", scope: !33, file: !20, line: 15, type: !23)
!41 = !DILocation(line: 16, column: 25, scope: !33)
!42 = !DILocation(line: 16, column: 5, scope: !33)
!43 = !DILocation(line: 17, column: 5, scope: !33)
!44 = !DILocation(line: 18, column: 5, scope: !33)
!45 = distinct !DISubprogram(name: "thread_2", scope: !20, file: !20, line: 21, type: !34, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !36)
!46 = !DILocalVariable(name: "unused", arg: 1, scope: !45, file: !20, line: 21, type: !16)
!47 = !DILocation(line: 0, scope: !45)
!48 = !DILocation(line: 24, column: 13, scope: !45)
!49 = !DILocalVariable(name: "r", scope: !45, file: !20, line: 24, type: !23)
!50 = !DILocation(line: 25, column: 11, scope: !51)
!51 = distinct !DILexicalBlock(scope: !45, file: !20, line: 25, column: 9)
!52 = !DILocation(line: 25, column: 9, scope: !45)
!53 = !DILocation(line: 26, column: 9, scope: !54)
!54 = distinct !DILexicalBlock(scope: !51, file: !20, line: 25, column: 17)
!55 = !DILocation(line: 27, column: 5, scope: !54)
!56 = !DILocation(line: 28, column: 5, scope: !45)
!57 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 31, type: !58, scopeLine: 32, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !36)
!58 = !DISubroutineType(types: !59)
!59 = !{!23}
!60 = !DILocalVariable(name: "t1", scope: !57, file: !20, line: 33, type: !61)
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !62, line: 31, baseType: !63)
!62 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !64, line: 118, baseType: !65)
!64 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!66 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !64, line: 103, size: 65536, elements: !67)
!67 = !{!68, !70, !80}
!68 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !66, file: !64, line: 104, baseType: !69, size: 64)
!69 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !66, file: !64, line: 105, baseType: !71, size: 64, offset: 64)
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !72, size: 64)
!72 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !64, line: 57, size: 192, elements: !73)
!73 = !{!74, !78, !79}
!74 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !72, file: !64, line: 58, baseType: !75, size: 64)
!75 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 64)
!76 = !DISubroutineType(types: !77)
!77 = !{null, !16}
!78 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !72, file: !64, line: 59, baseType: !16, size: 64, offset: 64)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !72, file: !64, line: 60, baseType: !71, size: 64, offset: 128)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !66, file: !64, line: 106, baseType: !81, size: 65408, offset: 128)
!81 = !DICompositeType(tag: DW_TAG_array_type, baseType: !82, size: 65408, elements: !83)
!82 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!83 = !{!84}
!84 = !DISubrange(count: 8176)
!85 = !DILocation(line: 33, column: 15, scope: !57)
!86 = !DILocalVariable(name: "t2", scope: !57, file: !20, line: 33, type: !61)
!87 = !DILocation(line: 33, column: 19, scope: !57)
!88 = !DILocation(line: 35, column: 5, scope: !57)
!89 = !DILocation(line: 36, column: 5, scope: !57)
!90 = !DILocation(line: 38, column: 18, scope: !57)
!91 = !DILocation(line: 38, column: 5, scope: !57)
!92 = !DILocation(line: 39, column: 18, scope: !57)
!93 = !DILocation(line: 39, column: 5, scope: !57)
!94 = !DILocation(line: 41, column: 5, scope: !57)
