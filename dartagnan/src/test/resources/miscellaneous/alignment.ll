; ModuleID = '/home/drc/git/Dat3M/output/alignment.ll'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/alignment.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.A = type { i32, [124 x i8] }

@.str = private unnamed_addr constant [10 x i8] c"&a >= 128\00", align 1
@.str.1 = private unnamed_addr constant [57 x i8] c"/home/drc/git/Dat3M/benchmarks/miscellaneous/alignment.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !10 {
  %1 = alloca i32, align 4
  %2 = alloca %struct.A, align 128
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct.A* %2, metadata !16, metadata !DIExpression()), !dbg !21
  %3 = icmp uge %struct.A* %2, inttoptr (i64 128 to %struct.A*), !dbg !22
  br i1 %3, label %4, label %5, !dbg !25

4:                                                ; preds = %0
  br label %6, !dbg !25

5:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.1, i64 0, i64 0), i32 noundef 11, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #3, !dbg !22
  unreachable, !dbg !22

6:                                                ; preds = %4
  ret i32 0, !dbg !26
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/drc/git/Dat3M/benchmarks/miscellaneous/alignment.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "41f18fedbb14c9ab59073f977d1fe118")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!10 = distinct !DISubprogram(name: "main", scope: !11, file: !11, line: 8, type: !12, scopeLine: 9, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!11 = !DIFile(filename: "benchmarks/miscellaneous/alignment.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "41f18fedbb14c9ab59073f977d1fe118")
!12 = !DISubroutineType(types: !13)
!13 = !{!14}
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !{}
!16 = !DILocalVariable(name: "a", scope: !10, file: !11, line: 10, type: !17)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "A", file: !11, line: 6, baseType: !18)
!18 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !11, line: 4, size: 1024, align: 1024, elements: !19)
!19 = !{!20}
!20 = !DIDerivedType(tag: DW_TAG_member, name: "__a", scope: !18, file: !11, line: 5, baseType: !14, size: 32)
!21 = !DILocation(line: 10, column: 7, scope: !10)
!22 = !DILocation(line: 11, column: 2, scope: !23)
!23 = distinct !DILexicalBlock(scope: !24, file: !11, line: 11, column: 2)
!24 = distinct !DILexicalBlock(scope: !10, file: !11, line: 11, column: 2)
!25 = !DILocation(line: 11, column: 2, scope: !24)
!26 = !DILocation(line: 13, column: 2, scope: !10)
