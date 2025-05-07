; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/thread_invalid_join_self.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/thread_invalid_join_self.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx15.0.0"

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread1(ptr noundef %0) #0 !dbg !11 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !16, metadata !DIExpression()), !dbg !17
  %3 = call ptr @pthread_self(), !dbg !18
  %4 = call i32 @"\01_pthread_join"(ptr noundef %3, ptr noundef null), !dbg !19
  ret ptr null, !dbg !20
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

declare ptr @pthread_self() #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !21 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !25, metadata !DIExpression()), !dbg !50
  %3 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread1, ptr noundef null), !dbg !51
  ret i32 0, !dbg !52
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!4, !5, !6, !7, !8, !9}
!llvm.ident = !{!10}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "Homebrew clang version 16.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!1 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/thread_invalid_join_self.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!2 = !{!3}
!3 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = !{i32 8, !"PIC Level", i32 2}
!8 = !{i32 7, !"uwtable", i32 1}
!9 = !{i32 7, !"frame-pointer", i32 1}
!10 = !{!"Homebrew clang version 16.0.6"}
!11 = distinct !DISubprogram(name: "thread1", scope: !12, file: !12, line: 11, type: !13, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!12 = !DIFile(filename: "benchmarks/miscellaneous/thread_invalid_join_self.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!13 = !DISubroutineType(types: !14)
!14 = !{!3, !3}
!15 = !{}
!16 = !DILocalVariable(name: "arg", arg: 1, scope: !11, file: !12, line: 11, type: !3)
!17 = !DILocation(line: 11, column: 21, scope: !11)
!18 = !DILocation(line: 13, column: 18, scope: !11)
!19 = !DILocation(line: 13, column: 5, scope: !11)
!20 = !DILocation(line: 14, column: 5, scope: !11)
!21 = distinct !DISubprogram(name: "main", scope: !12, file: !12, line: 17, type: !22, scopeLine: 18, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!22 = !DISubroutineType(types: !23)
!23 = !{!24}
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !DILocalVariable(name: "t1", scope: !21, file: !12, line: 19, type: !26)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !27, line: 31, baseType: !28)
!27 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !29, line: 118, baseType: !30)
!29 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !29, line: 103, size: 65536, elements: !32)
!32 = !{!33, !35, !45}
!33 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !31, file: !29, line: 104, baseType: !34, size: 64)
!34 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !31, file: !29, line: 105, baseType: !36, size: 64, offset: 64)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!37 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !29, line: 57, size: 192, elements: !38)
!38 = !{!39, !43, !44}
!39 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !37, file: !29, line: 58, baseType: !40, size: 64)
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64)
!41 = !DISubroutineType(types: !42)
!42 = !{null, !3}
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !37, file: !29, line: 59, baseType: !3, size: 64, offset: 64)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !37, file: !29, line: 60, baseType: !36, size: 64, offset: 128)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !31, file: !29, line: 106, baseType: !46, size: 65408, offset: 128)
!46 = !DICompositeType(tag: DW_TAG_array_type, baseType: !47, size: 65408, elements: !48)
!47 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!48 = !{!49}
!49 = !DISubrange(count: 8176)
!50 = !DILocation(line: 19, column: 15, scope: !21)
!51 = !DILocation(line: 20, column: 5, scope: !21)
!52 = !DILocation(line: 21, column: 5, scope: !21)
