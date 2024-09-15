; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/output/progressOBE-HSA.ll'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/progress/progressOBE-HSA.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@x = global i32 0, align 4, !dbg !0

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread_1(i8* noundef %0) #0 !dbg !23 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !27, metadata !DIExpression()), !dbg !28
  br label %2, !dbg !29

2:                                                ; preds = %2, %1
  %3 = load atomic i32, i32* @x seq_cst, align 4, !dbg !30
  %4 = icmp ne i32 %3, 0, !dbg !31
  br i1 %4, label %2, label %5, !dbg !29, !llvm.loop !32

5:                                                ; preds = %2
  ret i8* null, !dbg !35
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !36 {
  %1 = alloca %struct._opaque_pthread_t*, align 8
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %1, metadata !39, metadata !DIExpression()), !dbg !64
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** undef, metadata !65, metadata !DIExpression()), !dbg !66
  %2 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %1, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_1, i8* noundef null), !dbg !67
  store atomic i32 1, i32* @x seq_cst, align 4, !dbg !68
  store atomic i32 0, i32* @x seq_cst, align 4, !dbg !69
  ret i32 0, !dbg !70
}

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!12, !13, !14, !15, !16, !17, !18, !19, !20, !21}
!llvm.ident = !{!22}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !7, line: 8, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/progress/progressOBE-HSA.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0}
!7 = !DIFile(filename: "benchmarks/progress/progressOBE-HSA.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
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
!23 = distinct !DISubprogram(name: "thread_1", scope: !7, file: !7, line: 10, type: !24, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!24 = !DISubroutineType(types: !25)
!25 = !{!5, !5}
!26 = !{}
!27 = !DILocalVariable(name: "unused", arg: 1, scope: !23, file: !7, line: 10, type: !5)
!28 = !DILocation(line: 0, scope: !23)
!29 = !DILocation(line: 12, column: 5, scope: !23)
!30 = !DILocation(line: 12, column: 12, scope: !23)
!31 = !DILocation(line: 12, column: 14, scope: !23)
!32 = distinct !{!32, !29, !33, !34}
!33 = !DILocation(line: 12, column: 19, scope: !23)
!34 = !{!"llvm.loop.mustprogress"}
!35 = !DILocation(line: 13, column: 5, scope: !23)
!36 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 16, type: !37, scopeLine: 17, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!37 = !DISubroutineType(types: !38)
!38 = !{!11}
!39 = !DILocalVariable(name: "t1", scope: !36, file: !7, line: 18, type: !40)
!40 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !41, line: 31, baseType: !42)
!41 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !43, line: 118, baseType: !44)
!43 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!45 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !43, line: 103, size: 65536, elements: !46)
!46 = !{!47, !49, !59}
!47 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !45, file: !43, line: 104, baseType: !48, size: 64)
!48 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !45, file: !43, line: 105, baseType: !50, size: 64, offset: 64)
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!51 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !43, line: 57, size: 192, elements: !52)
!52 = !{!53, !57, !58}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !51, file: !43, line: 58, baseType: !54, size: 64)
!54 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !55, size: 64)
!55 = !DISubroutineType(types: !56)
!56 = !{null, !5}
!57 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !51, file: !43, line: 59, baseType: !5, size: 64, offset: 64)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !51, file: !43, line: 60, baseType: !50, size: 64, offset: 128)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !45, file: !43, line: 106, baseType: !60, size: 65408, offset: 128)
!60 = !DICompositeType(tag: DW_TAG_array_type, baseType: !61, size: 65408, elements: !62)
!61 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!62 = !{!63}
!63 = !DISubrange(count: 8176)
!64 = !DILocation(line: 18, column: 15, scope: !36)
!65 = !DILocalVariable(name: "t2", scope: !36, file: !7, line: 18, type: !40)
!66 = !DILocation(line: 18, column: 19, scope: !36)
!67 = !DILocation(line: 19, column: 5, scope: !36)
!68 = !DILocation(line: 20, column: 7, scope: !36)
!69 = !DILocation(line: 22, column: 7, scope: !36)
!70 = !DILocation(line: 23, column: 5, scope: !36)
