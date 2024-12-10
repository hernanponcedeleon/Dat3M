; ModuleID = 'benchmarks/alloc/test1_err_double_free_1.c'
source_filename = "benchmarks/alloc/test1_err_double_free_1.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !14 {
  %2 = alloca i8*, align 8
  %3 = alloca i32*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32** %3, metadata !20, metadata !DIExpression()), !dbg !21
  %4 = load i8*, i8** %2, align 8, !dbg !22
  %5 = bitcast i8* %4 to i32*, !dbg !23
  store i32* %5, i32** %3, align 8, !dbg !21
  %6 = load i32*, i32** %3, align 8, !dbg !24
  %7 = getelementptr inbounds i32, i32* %6, i64 0, !dbg !24
  store i32 0, i32* %7, align 4, !dbg !25
  %8 = load i32*, i32** %3, align 8, !dbg !26
  %9 = getelementptr inbounds i32, i32* %8, i64 1, !dbg !26
  store i32 1, i32* %9, align 4, !dbg !27
  ret i8* null, !dbg !28
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !29 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i32*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i64* %2, metadata !32, metadata !DIExpression()), !dbg !36
  call void @llvm.dbg.declare(metadata i32** %3, metadata !37, metadata !DIExpression()), !dbg !38
  %4 = call noalias i8* @malloc(i64 noundef 8) #4, !dbg !39
  %5 = bitcast i8* %4 to i32*, !dbg !39
  store i32* %5, i32** %3, align 8, !dbg !38
  %6 = load i32*, i32** %3, align 8, !dbg !40
  %7 = bitcast i32* %6 to i8*, !dbg !41
  %8 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_1, i8* noundef %7) #4, !dbg !42
  %9 = load i64, i64* %2, align 8, !dbg !43
  %10 = call i32 @pthread_join(i64 noundef %9, i8** noundef null), !dbg !44
  %11 = load i32*, i32** %3, align 8, !dbg !45
  %12 = bitcast i32* %11 to i8*, !dbg !45
  call void @free(i8* noundef %12) #4, !dbg !46
  %13 = load i32*, i32** %3, align 8, !dbg !47
  %14 = bitcast i32* %13 to i8*, !dbg !47
  call void @free(i8* noundef %14) #4, !dbg !48
  ret i32 0, !dbg !49
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: nounwind
declare void @free(i8* noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!6, !7, !8, !9, !10, !11, !12}
!llvm.ident = !{!13}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "benchmarks/alloc/test1_err_double_free_1.c", directory: "/home/ubuntu/Desktop/code/temp2/Dat3M", checksumkind: CSK_MD5, checksum: "d1a66eb11b37ac16370db18220b39a39")
!2 = !{!3, !5}
!3 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!4 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{i32 7, !"Dwarf Version", i32 5}
!7 = !{i32 2, !"Debug Info Version", i32 3}
!8 = !{i32 1, !"wchar_size", i32 4}
!9 = !{i32 7, !"PIC Level", i32 2}
!10 = !{i32 7, !"PIE Level", i32 2}
!11 = !{i32 7, !"uwtable", i32 1}
!12 = !{i32 7, !"frame-pointer", i32 2}
!13 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!14 = distinct !DISubprogram(name: "thread_1", scope: !1, file: !1, line: 6, type: !15, scopeLine: 7, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!15 = !DISubroutineType(types: !16)
!16 = !{!5, !5}
!17 = !{}
!18 = !DILocalVariable(name: "arg", arg: 1, scope: !14, file: !1, line: 6, type: !5)
!19 = !DILocation(line: 6, column: 22, scope: !14)
!20 = !DILocalVariable(name: "arr", scope: !14, file: !1, line: 8, type: !3)
!21 = !DILocation(line: 8, column: 10, scope: !14)
!22 = !DILocation(line: 8, column: 22, scope: !14)
!23 = !DILocation(line: 8, column: 16, scope: !14)
!24 = !DILocation(line: 9, column: 5, scope: !14)
!25 = !DILocation(line: 9, column: 12, scope: !14)
!26 = !DILocation(line: 10, column: 5, scope: !14)
!27 = !DILocation(line: 10, column: 12, scope: !14)
!28 = !DILocation(line: 12, column: 2, scope: !14)
!29 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 15, type: !30, scopeLine: 16, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!30 = !DISubroutineType(types: !31)
!31 = !{!4}
!32 = !DILocalVariable(name: "t1", scope: !29, file: !1, line: 17, type: !33)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !34, line: 27, baseType: !35)
!34 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!35 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!36 = !DILocation(line: 17, column: 15, scope: !29)
!37 = !DILocalVariable(name: "arr", scope: !29, file: !1, line: 18, type: !3)
!38 = !DILocation(line: 18, column: 10, scope: !29)
!39 = !DILocation(line: 18, column: 16, scope: !29)
!40 = !DILocation(line: 20, column: 48, scope: !29)
!41 = !DILocation(line: 20, column: 41, scope: !29)
!42 = !DILocation(line: 20, column: 5, scope: !29)
!43 = !DILocation(line: 21, column: 18, scope: !29)
!44 = !DILocation(line: 21, column: 5, scope: !29)
!45 = !DILocation(line: 23, column: 10, scope: !29)
!46 = !DILocation(line: 23, column: 5, scope: !29)
!47 = !DILocation(line: 24, column: 10, scope: !29)
!48 = !DILocation(line: 24, column: 5, scope: !29)
!49 = !DILocation(line: 26, column: 2, scope: !29)
