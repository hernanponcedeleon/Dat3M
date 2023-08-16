; ModuleID = '/home/ponce/git/Dat3M/output/propagatableSideEffects.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/propagatableSideEffects.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@bound = dso_local global i32 2, align 4, !dbg !0
@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [75 x i8] c"/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/propagatableSideEffects.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !16 {
  call void @llvm.dbg.value(metadata i32 0, metadata !20, metadata !DIExpression()), !dbg !21
  call void @__VERIFIER_loop_bound(i32 noundef 3) #4, !dbg !22
  br label %1, !dbg !23

1:                                                ; preds = %1, %0
  %.0 = phi i32 [ 0, %0 ], [ %2, %1 ], !dbg !21
  call void @llvm.dbg.value(metadata i32 %.0, metadata !20, metadata !DIExpression()), !dbg !21
  %2 = add nuw nsw i32 %.0, 1, !dbg !24
  call void @llvm.dbg.value(metadata i32 %2, metadata !20, metadata !DIExpression()), !dbg !21
  %3 = load volatile i32, i32* @bound, align 4, !dbg !25
  %4 = icmp slt i32 %.0, %3, !dbg !26
  br i1 %4, label %1, label %5, !dbg !23, !llvm.loop !27

5:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([75 x i8], [75 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !30
  unreachable, !dbg !30
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__VERIFIER_loop_bound(i32 noundef) #2

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!8, !9, !10, !11, !12, !13, !14}
!llvm.ident = !{!15}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "bound", scope: !2, file: !5, line: 13, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/propagatableSideEffects.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "82a2a3c4256feee6c43427e8ee573738")
!4 = !{!0}
!5 = !DIFile(filename: "benchmarks/c/miscellaneous/propagatableSideEffects.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "82a2a3c4256feee6c43427e8ee573738")
!6 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !7)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !{i32 7, !"Dwarf Version", i32 5}
!9 = !{i32 2, !"Debug Info Version", i32 3}
!10 = !{i32 1, !"wchar_size", i32 4}
!11 = !{i32 7, !"PIC Level", i32 2}
!12 = !{i32 7, !"PIE Level", i32 2}
!13 = !{i32 7, !"uwtable", i32 1}
!14 = !{i32 7, !"frame-pointer", i32 2}
!15 = !{!"Ubuntu clang version 14.0.6"}
!16 = distinct !DISubprogram(name: "main", scope: !5, file: !5, line: 15, type: !17, scopeLine: 16, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !19)
!17 = !DISubroutineType(types: !18)
!18 = !{!7}
!19 = !{}
!20 = !DILocalVariable(name: "cnt", scope: !16, file: !5, line: 17, type: !7)
!21 = !DILocation(line: 0, scope: !16)
!22 = !DILocation(line: 18, column: 2, scope: !16)
!23 = !DILocation(line: 19, column: 2, scope: !16)
!24 = !DILocation(line: 19, column: 12, scope: !16)
!25 = !DILocation(line: 19, column: 17, scope: !16)
!26 = !DILocation(line: 19, column: 15, scope: !16)
!27 = distinct !{!27, !23, !28, !29}
!28 = !DILocation(line: 19, column: 26, scope: !16)
!29 = !{!"llvm.loop.mustprogress"}
!30 = !DILocation(line: 20, column: 2, scope: !31)
!31 = distinct !DILexicalBlock(scope: !32, file: !5, line: 20, column: 2)
!32 = distinct !DILexicalBlock(scope: !16, file: !5, line: 20, column: 2)
