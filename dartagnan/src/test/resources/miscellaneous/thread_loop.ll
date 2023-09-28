; ModuleID = '/home/ponce/git/Dat3M/output/thread_loop.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/thread_loop.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@data = dso_local global i32 0, align 4, !dbg !0
@.str = private unnamed_addr constant [14 x i8] c"data != N - 1\00", align 1
@.str.1 = private unnamed_addr constant [63 x i8] c"/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/thread_loop.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @worker(i8* noundef %0) #0 !dbg !20 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !24, metadata !DIExpression()), !dbg !25
  %2 = atomicrmw add i32* @data, i32 1 seq_cst, align 4, !dbg !26
  ret i8* null, !dbg !27
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !28 {
  %1 = alloca [5 x i64], align 16
  call void @llvm.dbg.declare(metadata [5 x i64]* %1, metadata !31, metadata !DIExpression()), !dbg !38
  %2 = call i32 @__VERIFIER_nondet_int() #5, !dbg !39
  call void @llvm.dbg.value(metadata i32 %2, metadata !40, metadata !DIExpression()), !dbg !41
  %3 = icmp ult i32 %2, 5, !dbg !42
  %4 = zext i1 %3 to i32, !dbg !42
  call void @__VERIFIER_assume(i32 noundef %4) #5, !dbg !43
  call void @__VERIFIER_loop_bound(i32 noundef 6) #5, !dbg !44
  call void @llvm.dbg.value(metadata i32 0, metadata !45, metadata !DIExpression()), !dbg !47
  %smax = call i32 @llvm.smax.i32(i32 %2, i32 0), !dbg !48
  %wide.trip.count = zext i32 %smax to i64, !dbg !49
  br label %5, !dbg !48

5:                                                ; preds = %6, %0
  %indvars.iv = phi i64 [ %indvars.iv.next, %6 ], [ 0, %0 ], !dbg !47
  call void @llvm.dbg.value(metadata i64 %indvars.iv, metadata !45, metadata !DIExpression()), !dbg !47
  %exitcond.not = icmp eq i64 %indvars.iv, %wide.trip.count, !dbg !49
  br i1 %exitcond.not, label %9, label %6, !dbg !51

6:                                                ; preds = %5
  %7 = getelementptr inbounds [5 x i64], [5 x i64]* %1, i64 0, i64 %indvars.iv, !dbg !52
  %8 = call i32 @pthread_create(i64* noundef nonnull %7, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @worker, i8* noundef null) #5, !dbg !54
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !55
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next, metadata !45, metadata !DIExpression()), !dbg !47
  br label %5, !dbg !56, !llvm.loop !57

9:                                                ; preds = %5
  %10 = load atomic i32, i32* @data seq_cst, align 4, !dbg !60
  %.not = icmp eq i32 %10, 4, !dbg !60
  br i1 %.not, label %11, label %12, !dbg !63

11:                                               ; preds = %9
  call void @__assert_fail(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.1, i64 0, i64 0), i32 noundef 34, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !60
  unreachable, !dbg !60

12:                                               ; preds = %9
  ret i32 0, !dbg !64
}

declare i32 @__VERIFIER_nondet_int() #2

declare void @__VERIFIER_assume(i32 noundef) #2

declare void @__VERIFIER_loop_bound(i32 noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare i32 @llvm.smax.i32(i32, i32) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!12, !13, !14, !15, !16, !17, !18}
!llvm.ident = !{!19}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !7, line: 15, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/thread_loop.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "fea2e412a35969402f7d7664bb0ef391")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0}
!7 = !DIFile(filename: "benchmarks/c/miscellaneous/thread_loop.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "fea2e412a35969402f7d7664bb0ef391")
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
!20 = distinct !DISubprogram(name: "worker", scope: !7, file: !7, line: 17, type: !21, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!21 = !DISubroutineType(types: !22)
!22 = !{!5, !5}
!23 = !{}
!24 = !DILocalVariable(name: "arg", arg: 1, scope: !20, file: !7, line: 17, type: !5)
!25 = !DILocation(line: 0, scope: !20)
!26 = !DILocation(line: 19, column: 4, scope: !20)
!27 = !DILocation(line: 20, column: 4, scope: !20)
!28 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 23, type: !29, scopeLine: 24, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!29 = !DISubroutineType(types: !30)
!30 = !{!11}
!31 = !DILocalVariable(name: "t", scope: !28, file: !7, line: 25, type: !32)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 320, elements: !36)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !34, line: 27, baseType: !35)
!34 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!35 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!36 = !{!37}
!37 = !DISubrange(count: 5)
!38 = !DILocation(line: 25, column: 15, scope: !28)
!39 = !DILocation(line: 26, column: 17, scope: !28)
!40 = !DILocalVariable(name: "bound", scope: !28, file: !7, line: 26, type: !11)
!41 = !DILocation(line: 0, scope: !28)
!42 = !DILocation(line: 27, column: 34, scope: !28)
!43 = !DILocation(line: 27, column: 5, scope: !28)
!44 = !DILocation(line: 29, column: 5, scope: !28)
!45 = !DILocalVariable(name: "i", scope: !46, file: !7, line: 30, type: !11)
!46 = distinct !DILexicalBlock(scope: !28, file: !7, line: 30, column: 5)
!47 = !DILocation(line: 0, scope: !46)
!48 = !DILocation(line: 30, column: 10, scope: !46)
!49 = !DILocation(line: 30, column: 23, scope: !50)
!50 = distinct !DILexicalBlock(scope: !46, file: !7, line: 30, column: 5)
!51 = !DILocation(line: 30, column: 5, scope: !46)
!52 = !DILocation(line: 31, column: 25, scope: !53)
!53 = distinct !DILexicalBlock(scope: !50, file: !7, line: 30, column: 37)
!54 = !DILocation(line: 31, column: 9, scope: !53)
!55 = !DILocation(line: 30, column: 33, scope: !50)
!56 = !DILocation(line: 30, column: 5, scope: !50)
!57 = distinct !{!57, !51, !58, !59}
!58 = !DILocation(line: 32, column: 5, scope: !46)
!59 = !{!"llvm.loop.mustprogress"}
!60 = !DILocation(line: 34, column: 5, scope: !61)
!61 = distinct !DILexicalBlock(scope: !62, file: !7, line: 34, column: 5)
!62 = distinct !DILexicalBlock(scope: !28, file: !7, line: 34, column: 5)
!63 = !DILocation(line: 34, column: 5, scope: !62)
!64 = !DILocation(line: 35, column: 1, scope: !28)
