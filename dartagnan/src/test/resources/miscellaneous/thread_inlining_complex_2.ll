; ModuleID = '/home/ponce/git/Dat3M/output/thread_inlining_complex_2.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/thread_inlining_complex_2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@data = dso_local global i32 0, align 4, !dbg !0
@.str = private unnamed_addr constant [11 x i8] c"data == 42\00", align 1
@.str.1 = private unnamed_addr constant [77 x i8] c"/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/thread_inlining_complex_2.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread2(i8* noundef %0) #0 !dbg !20 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !24, metadata !DIExpression()), !dbg !25
  store atomic i32 42, i32* @data seq_cst, align 4, !dbg !26
  ret i8* null, !dbg !27
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i64 @threadCreator() #0 !dbg !28 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !34, metadata !DIExpression(DW_OP_deref)), !dbg !35
  %2 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread2, i8* noundef null) #5, !dbg !36
  %3 = load i64, i64* %1, align 8, !dbg !37
  call void @llvm.dbg.value(metadata i64 %3, metadata !34, metadata !DIExpression()), !dbg !35
  ret i64 %3, !dbg !38
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @threadJoiner(i64 noundef %0) #0 !dbg !39 {
  call void @llvm.dbg.value(metadata i64 %0, metadata !42, metadata !DIExpression()), !dbg !43
  %2 = call i32 @pthread_join(i64 noundef %0, i8** noundef null) #5, !dbg !44
  ret void, !dbg !45
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread1(i8* noundef %0) #0 !dbg !46 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !47, metadata !DIExpression()), !dbg !48
  %2 = call i64 @threadCreator(), !dbg !49
  call void @threadJoiner(i64 noundef %2), !dbg !50
  ret i8* null, !dbg !51
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !52 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !55, metadata !DIExpression(DW_OP_deref)), !dbg !56
  %2 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread1, i8* noundef null) #5, !dbg !57
  %3 = load i64, i64* %1, align 8, !dbg !58
  call void @llvm.dbg.value(metadata i64 %3, metadata !55, metadata !DIExpression()), !dbg !56
  %4 = call i32 @pthread_join(i64 noundef %3, i8** noundef null) #5, !dbg !59
  %5 = load atomic i32, i32* @data seq_cst, align 4, !dbg !60
  %6 = icmp eq i32 %5, 42, !dbg !60
  br i1 %6, label %8, label %7, !dbg !63

7:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([77 x i8], [77 x i8]* @.str.1, i64 0, i64 0), i32 noundef 40, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !60
  unreachable, !dbg !60

8:                                                ; preds = %0
  ret i32 0, !dbg !64
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!12, !13, !14, !15, !16, !17, !18}
!llvm.ident = !{!19}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !7, line: 10, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/thread_inlining_complex_2.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "2cf7ccbc70d519ae91b3b71395ab636d")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0}
!7 = !DIFile(filename: "benchmarks/c/miscellaneous/thread_inlining_complex_2.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "2cf7ccbc70d519ae91b3b71395ab636d")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !9, line: 92, baseType: !10)
!9 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "de5d66a1ef2f5448cc1919ff39db92bc")
!10 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !11)
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !{i32 7, !"Dwarf Version", i32 5}
!13 = !{i32 2, !"Debug Info Version", i32 3}
!14 = !{i32 1, !"wchar_size", i32 4}
!15 = !{i32 7, !"PIC Level", i32 2}
!16 = !{i32 7, !"PIE Level", i32 2}
!17 = !{i32 7, !"uwtable", i32 1}
!18 = !{i32 7, !"frame-pointer", i32 2}
!19 = !{!"Ubuntu clang version 14.0.6"}
!20 = distinct !DISubprogram(name: "thread2", scope: !7, file: !7, line: 12, type: !21, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!21 = !DISubroutineType(types: !22)
!22 = !{!5, !5}
!23 = !{}
!24 = !DILocalVariable(name: "arg", arg: 1, scope: !20, file: !7, line: 12, type: !5)
!25 = !DILocation(line: 0, scope: !20)
!26 = !DILocation(line: 14, column: 10, scope: !20)
!27 = !DILocation(line: 15, column: 5, scope: !20)
!28 = distinct !DISubprogram(name: "threadCreator", scope: !7, file: !7, line: 18, type: !29, scopeLine: 18, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!29 = !DISubroutineType(types: !30)
!30 = !{!31}
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !32, line: 27, baseType: !33)
!32 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!33 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!34 = !DILocalVariable(name: "t", scope: !28, file: !7, line: 19, type: !31)
!35 = !DILocation(line: 0, scope: !28)
!36 = !DILocation(line: 20, column: 5, scope: !28)
!37 = !DILocation(line: 21, column: 12, scope: !28)
!38 = !DILocation(line: 21, column: 5, scope: !28)
!39 = distinct !DISubprogram(name: "threadJoiner", scope: !7, file: !7, line: 24, type: !40, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!40 = !DISubroutineType(types: !41)
!41 = !{null, !31}
!42 = !DILocalVariable(name: "t", arg: 1, scope: !39, file: !7, line: 24, type: !31)
!43 = !DILocation(line: 0, scope: !39)
!44 = !DILocation(line: 25, column: 5, scope: !39)
!45 = !DILocation(line: 26, column: 1, scope: !39)
!46 = distinct !DISubprogram(name: "thread1", scope: !7, file: !7, line: 28, type: !21, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!47 = !DILocalVariable(name: "arg", arg: 1, scope: !46, file: !7, line: 28, type: !5)
!48 = !DILocation(line: 0, scope: !46)
!49 = !DILocation(line: 30, column: 18, scope: !46)
!50 = !DILocation(line: 30, column: 5, scope: !46)
!51 = !DILocation(line: 31, column: 5, scope: !46)
!52 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 34, type: !53, scopeLine: 35, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!53 = !DISubroutineType(types: !54)
!54 = !{!11}
!55 = !DILocalVariable(name: "t1", scope: !52, file: !7, line: 36, type: !31)
!56 = !DILocation(line: 0, scope: !52)
!57 = !DILocation(line: 37, column: 5, scope: !52)
!58 = !DILocation(line: 38, column: 18, scope: !52)
!59 = !DILocation(line: 38, column: 5, scope: !52)
!60 = !DILocation(line: 40, column: 5, scope: !61)
!61 = distinct !DILexicalBlock(scope: !62, file: !7, line: 40, column: 5)
!62 = distinct !DILexicalBlock(scope: !52, file: !7, line: 40, column: 5)
!63 = !DILocation(line: 40, column: 5, scope: !62)
!64 = !DILocation(line: 41, column: 1, scope: !52)
