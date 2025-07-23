; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/assert_assume_race_v2.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/assert_assume_race_v2.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@__func__.handler = private unnamed_addr constant [8 x i8] c"handler\00", align 1
@.str = private unnamed_addr constant [24 x i8] c"assert_assume_race_v2.c\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"0\00", align 1

; Function Attrs: noinline nounwind ssp uwtable
define i8* @handler(i8* noundef %0) #0 !dbg !15 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !20, metadata !DIExpression()), !dbg !21
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @__func__.handler, i64 0, i64 0), i8* noundef getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i32 noundef 12, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !22
  unreachable, !dbg !22
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !23 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !27, metadata !DIExpression()), !dbg !53
  call void @__VERIFIER_make_interrupt_handler(), !dbg !53
  %4 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null), !dbg !53
  %5 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %2, align 8, !dbg !53
  store %struct._opaque_pthread_t* %5, %struct._opaque_pthread_t** %3, align 8, !dbg !53
  %6 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %3, align 8, !dbg !53
  call void @__VERIFIER_assume(i32 noundef 0), !dbg !54
  ret i32 0, !dbg !55
}

declare void @__VERIFIER_make_interrupt_handler() #3

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare void @__VERIFIER_assume(i32 noundef) #3

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #3 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #4 = { cold noreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!4, !5, !6, !7, !8, !9, !10, !11, !12, !13}
!llvm.ident = !{!14}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!1 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/assert_assume_race_v2.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!2 = !{!3}
!3 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = !{i32 1, !"branch-target-enforcement", i32 0}
!8 = !{i32 1, !"sign-return-address", i32 0}
!9 = !{i32 1, !"sign-return-address-all", i32 0}
!10 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!11 = !{i32 7, !"PIC Level", i32 2}
!12 = !{i32 7, !"uwtable", i32 1}
!13 = !{i32 7, !"frame-pointer", i32 1}
!14 = !{!"Homebrew clang version 14.0.6"}
!15 = distinct !DISubprogram(name: "handler", scope: !16, file: !16, line: 10, type: !17, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !19)
!16 = !DIFile(filename: "benchmarks/interrupts/assert_assume_race_v2.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!17 = !DISubroutineType(types: !18)
!18 = !{!3, !3}
!19 = !{}
!20 = !DILocalVariable(name: "arg", arg: 1, scope: !15, file: !16, line: 10, type: !3)
!21 = !DILocation(line: 10, column: 21, scope: !15)
!22 = !DILocation(line: 12, column: 5, scope: !15)
!23 = distinct !DISubprogram(name: "main", scope: !16, file: !16, line: 17, type: !24, scopeLine: 18, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !19)
!24 = !DISubroutineType(types: !25)
!25 = !{!26}
!26 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!27 = !DILocalVariable(name: "h", scope: !28, file: !16, line: 19, type: !29)
!28 = distinct !DILexicalBlock(scope: !23, file: !16, line: 19, column: 5)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !30, line: 31, baseType: !31)
!30 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !32, line: 118, baseType: !33)
!32 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!33 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!34 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !32, line: 103, size: 65536, elements: !35)
!35 = !{!36, !38, !48}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !34, file: !32, line: 104, baseType: !37, size: 64)
!37 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !34, file: !32, line: 105, baseType: !39, size: 64, offset: 64)
!39 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !32, line: 57, size: 192, elements: !41)
!41 = !{!42, !46, !47}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !40, file: !32, line: 58, baseType: !43, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!44 = !DISubroutineType(types: !45)
!45 = !{null, !3}
!46 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !40, file: !32, line: 59, baseType: !3, size: 64, offset: 64)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !40, file: !32, line: 60, baseType: !39, size: 64, offset: 128)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !34, file: !32, line: 106, baseType: !49, size: 65408, offset: 128)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 65408, elements: !51)
!50 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!51 = !{!52}
!52 = !DISubrange(count: 8176)
!53 = !DILocation(line: 19, column: 5, scope: !28)
!54 = !DILocation(line: 21, column: 5, scope: !23)
!55 = !DILocation(line: 23, column: 5, scope: !23)
