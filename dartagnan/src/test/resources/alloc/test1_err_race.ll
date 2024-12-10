; ModuleID = 'benchmarks/alloc/test1_err_race.c'
source_filename = "benchmarks/alloc/test1_err_race.c"
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
  %7 = bitcast i32* %6 to i8*, !dbg !24
  call void @free(i8* noundef %7) #4, !dbg !25
  ret i8* null, !dbg !26
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare void @free(i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !27 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i32*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i64* %2, metadata !30, metadata !DIExpression()), !dbg !34
  call void @llvm.dbg.declare(metadata i32** %3, metadata !35, metadata !DIExpression()), !dbg !36
  %4 = load i32*, i32** %3, align 8, !dbg !37
  %5 = bitcast i32* %4 to i8*, !dbg !38
  %6 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_1, i8* noundef %5) #4, !dbg !39
  %7 = call noalias i8* @malloc(i64 noundef 8) #4, !dbg !40
  %8 = bitcast i8* %7 to i32*, !dbg !40
  store i32* %8, i32** %3, align 8, !dbg !41
  %9 = load i64, i64* %2, align 8, !dbg !42
  %10 = call i32 @pthread_join(i64 noundef %9, i8** noundef null), !dbg !43
  %11 = load i32*, i32** %3, align 8, !dbg !44
  %12 = bitcast i32* %11 to i8*, !dbg !44
  call void @free(i8* noundef %12) #4, !dbg !45
  ret i32 0, !dbg !46
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!6, !7, !8, !9, !10, !11, !12}
!llvm.ident = !{!13}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "benchmarks/alloc/test1_err_race.c", directory: "/home/ubuntu/Desktop/code/temp2/Dat3M", checksumkind: CSK_MD5, checksum: "0c175e83c7b7bcb8fa51479a3fec40a3")
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
!24 = !DILocation(line: 9, column: 10, scope: !14)
!25 = !DILocation(line: 9, column: 5, scope: !14)
!26 = !DILocation(line: 11, column: 2, scope: !14)
!27 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 14, type: !28, scopeLine: 15, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!28 = !DISubroutineType(types: !29)
!29 = !{!4}
!30 = !DILocalVariable(name: "t1", scope: !27, file: !1, line: 16, type: !31)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !32, line: 27, baseType: !33)
!32 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!33 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!34 = !DILocation(line: 16, column: 15, scope: !27)
!35 = !DILocalVariable(name: "arr", scope: !27, file: !1, line: 17, type: !3)
!36 = !DILocation(line: 17, column: 10, scope: !27)
!37 = !DILocation(line: 19, column: 48, scope: !27)
!38 = !DILocation(line: 19, column: 41, scope: !27)
!39 = !DILocation(line: 19, column: 5, scope: !27)
!40 = !DILocation(line: 20, column: 11, scope: !27)
!41 = !DILocation(line: 20, column: 9, scope: !27)
!42 = !DILocation(line: 21, column: 18, scope: !27)
!43 = !DILocation(line: 21, column: 5, scope: !27)
!44 = !DILocation(line: 23, column: 10, scope: !27)
!45 = !DILocation(line: 23, column: 5, scope: !27)
!46 = !DILocation(line: 25, column: 2, scope: !27)
