; ModuleID = 'benchmarks/alloc/test1_err_no_alloc_1.c'
source_filename = "benchmarks/alloc/test1_err_no_alloc_1.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !15 {
  %2 = alloca i8*, align 8
  %3 = alloca i32*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !19, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata i32** %3, metadata !21, metadata !DIExpression()), !dbg !22
  %4 = load i8*, i8** %2, align 8, !dbg !23
  %5 = bitcast i8* %4 to i32**, !dbg !24
  %6 = load i32*, i32** %5, align 8, !dbg !25
  store i32* %6, i32** %3, align 8, !dbg !22
  %7 = load i32*, i32** %3, align 8, !dbg !26
  %8 = bitcast i32* %7 to i8*, !dbg !26
  call void @free(i8* noundef %8) #4, !dbg !27
  ret i8* null, !dbg !28
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare void @free(i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !29 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i32*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i64* %2, metadata !32, metadata !DIExpression()), !dbg !36
  call void @llvm.dbg.declare(metadata i32** %3, metadata !37, metadata !DIExpression()), !dbg !38
  %4 = bitcast i32** %3 to i8*, !dbg !39
  %5 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_1, i8* noundef %4) #4, !dbg !40
  %6 = load i64, i64* %2, align 8, !dbg !41
  %7 = call i32 @pthread_join(i64 noundef %6, i8** noundef null), !dbg !42
  ret i32 0, !dbg !43
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!7, !8, !9, !10, !11, !12, !13}
!llvm.ident = !{!14}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "benchmarks/alloc/test1_err_no_alloc_1.c", directory: "", checksumkind: CSK_MD5, checksum: "14a6148e31a552c09a9972943a522fc6")
!2 = !{!3, !6}
!3 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!4 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !{i32 7, !"Dwarf Version", i32 5}
!8 = !{i32 2, !"Debug Info Version", i32 3}
!9 = !{i32 1, !"wchar_size", i32 4}
!10 = !{i32 7, !"PIC Level", i32 2}
!11 = !{i32 7, !"PIE Level", i32 2}
!12 = !{i32 7, !"uwtable", i32 1}
!13 = !{i32 7, !"frame-pointer", i32 2}
!14 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!15 = distinct !DISubprogram(name: "thread_1", scope: !1, file: !1, line: 6, type: !16, scopeLine: 7, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !18)
!16 = !DISubroutineType(types: !17)
!17 = !{!6, !6}
!18 = !{}
!19 = !DILocalVariable(name: "arg", arg: 1, scope: !15, file: !1, line: 6, type: !6)
!20 = !DILocation(line: 6, column: 22, scope: !15)
!21 = !DILocalVariable(name: "arr", scope: !15, file: !1, line: 8, type: !4)
!22 = !DILocation(line: 8, column: 10, scope: !15)
!23 = !DILocation(line: 8, column: 25, scope: !15)
!24 = !DILocation(line: 8, column: 18, scope: !15)
!25 = !DILocation(line: 8, column: 16, scope: !15)
!26 = !DILocation(line: 9, column: 10, scope: !15)
!27 = !DILocation(line: 9, column: 5, scope: !15)
!28 = !DILocation(line: 11, column: 2, scope: !15)
!29 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 14, type: !30, scopeLine: 15, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !18)
!30 = !DISubroutineType(types: !31)
!31 = !{!5}
!32 = !DILocalVariable(name: "t1", scope: !29, file: !1, line: 16, type: !33)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !34, line: 27, baseType: !35)
!34 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!35 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!36 = !DILocation(line: 16, column: 15, scope: !29)
!37 = !DILocalVariable(name: "arr", scope: !29, file: !1, line: 17, type: !4)
!38 = !DILocation(line: 17, column: 10, scope: !29)
!39 = !DILocation(line: 19, column: 41, scope: !29)
!40 = !DILocation(line: 19, column: 5, scope: !29)
!41 = !DILocation(line: 20, column: 18, scope: !29)
!42 = !DILocation(line: 20, column: 5, scope: !29)
!43 = !DILocation(line: 22, column: 2, scope: !29)
