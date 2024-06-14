; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/c/miscellaneous/offsetof.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/c/miscellaneous/offsetof.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx13.0.0"

%struct.myStruct_t = type { i32, %struct.anon, i32 }
%struct.anon = type { i64, i8 }

@myStruct = dso_local global %struct.myStruct_t zeroinitializer, align 8, !dbg !0

; Function Attrs: noinline nounwind ssp uwtable
define dso_local i32 @main() #0 !dbg !32 {
  %1 = alloca %struct.myStruct_t*, align 8
  %2 = alloca i32*, align 8
  %3 = alloca %struct.myStruct_t*, align 8
  call void @__VERIFIER_assert(i32 1), !dbg !35
  call void @__VERIFIER_assert(i32 1), !dbg !36
  call void @llvm.dbg.declare(metadata %struct.myStruct_t** %1, metadata !37, metadata !DIExpression()), !dbg !38
  call void @llvm.dbg.declare(metadata i32** %2, metadata !39, metadata !DIExpression()), !dbg !43
  store i32* getelementptr inbounds (%struct.myStruct_t, %struct.myStruct_t* @myStruct, i32 0, i32 2), i32** %2, align 8, !dbg !43
  %4 = load i32*, i32** %2, align 8, !dbg !43
  %5 = bitcast i32* %4 to i8*, !dbg !43
  %6 = getelementptr inbounds i8, i8* %5, i64 -24, !dbg !43
  %7 = bitcast i8* %6 to %struct.myStruct_t*, !dbg !43
  store %struct.myStruct_t* %7, %struct.myStruct_t** %3, align 8, !dbg !43
  %8 = load %struct.myStruct_t*, %struct.myStruct_t** %3, align 8, !dbg !43
  store %struct.myStruct_t* %8, %struct.myStruct_t** %1, align 8, !dbg !38
  %9 = load %struct.myStruct_t*, %struct.myStruct_t** %1, align 8, !dbg !44
  %10 = icmp eq %struct.myStruct_t* %9, @myStruct, !dbg !45
  %11 = zext i1 %10 to i32, !dbg !45
  call void @__VERIFIER_assert(i32 %11), !dbg !46
  ret i32 0, !dbg !47
}

declare void @__VERIFIER_assert(i32) #1

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

attributes #0 = { noinline nounwind ssp uwtable "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-a12" "target-features"="+aes,+crc,+crypto,+fp-armv8,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.3a,+zcm,+zcz" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-a12" "target-features"="+aes,+crc,+crypto,+fp-armv8,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.3a,+zcm,+zcz" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!23, !24, !25, !26, !27, !28, !29, !30}
!llvm.ident = !{!31}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "myStruct", scope: !2, file: !8, line: 17, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 12.0.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !22, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/c/miscellaneous/offsetof.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{}
!5 = !{!6, !21}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "myStruct_t", file: !8, line: 15, baseType: !9)
!8 = !DIFile(filename: "benchmarks/c/miscellaneous/offsetof.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!9 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !8, line: 8, size: 256, elements: !10)
!10 = !{!11, !13, !20}
!11 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !9, file: !8, line: 9, baseType: !12, size: 32)
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DIDerivedType(tag: DW_TAG_member, scope: !9, file: !8, line: 10, baseType: !14, size: 128, offset: 64)
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !9, file: !8, line: 10, size: 128, elements: !15)
!15 = !{!16, !18}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !14, file: !8, line: 11, baseType: !17, size: 64)
!17 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !14, file: !8, line: 12, baseType: !19, size: 8, offset: 64)
!19 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !9, file: !8, line: 14, baseType: !12, size: 32, offset: 192)
!21 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!22 = !{!0}
!23 = !{i32 7, !"Dwarf Version", i32 4}
!24 = !{i32 2, !"Debug Info Version", i32 3}
!25 = !{i32 1, !"wchar_size", i32 4}
!26 = !{i32 1, !"branch-target-enforcement", i32 0}
!27 = !{i32 1, !"sign-return-address", i32 0}
!28 = !{i32 1, !"sign-return-address-all", i32 0}
!29 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!30 = !{i32 7, !"PIC Level", i32 2}
!31 = !{!"Homebrew clang version 12.0.1"}
!32 = distinct !DISubprogram(name: "main", scope: !8, file: !8, line: 19, type: !33, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!33 = !DISubroutineType(types: !34)
!34 = !{!12}
!35 = !DILocation(line: 22, column: 5, scope: !32)
!36 = !DILocation(line: 23, column: 5, scope: !32)
!37 = !DILocalVariable(name: "container", scope: !32, file: !8, line: 26, type: !6)
!38 = !DILocation(line: 26, column: 17, scope: !32)
!39 = !DILocalVariable(name: "__mptr", scope: !40, file: !8, line: 26, type: !41)
!40 = distinct !DILexicalBlock(scope: !32, file: !8, line: 26, column: 29)
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!42 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !12)
!43 = !DILocation(line: 26, column: 29, scope: !40)
!44 = !DILocation(line: 27, column: 23, scope: !32)
!45 = !DILocation(line: 27, column: 33, scope: !32)
!46 = !DILocation(line: 27, column: 5, scope: !32)
!47 = !DILocation(line: 28, column: 1, scope: !32)
