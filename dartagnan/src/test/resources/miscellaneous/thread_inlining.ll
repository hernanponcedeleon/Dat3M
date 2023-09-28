; ModuleID = '/home/ponce/git/Dat3M/output/thread_inlining.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/thread_inlining.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@data = dso_local global i32 0, align 4, !dbg !0
@.str = private unnamed_addr constant [11 x i8] c"data == 42\00", align 1
@.str.1 = private unnamed_addr constant [67 x i8] c"/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/thread_inlining.c\00", align 1
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
define dso_local void @threadCreator(i64* noundef %0) #0 !dbg !28 {
  call void @llvm.dbg.value(metadata i64* %0, metadata !35, metadata !DIExpression()), !dbg !36
  %2 = call i32 @pthread_create(i64* noundef %0, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread2, i8* noundef null) #5, !dbg !37
  ret void, !dbg !38
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread1(i8* noundef %0) #0 !dbg !39 {
  %2 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i8* %0, metadata !40, metadata !DIExpression()), !dbg !41
  call void @llvm.dbg.value(metadata i64* %2, metadata !42, metadata !DIExpression(DW_OP_deref)), !dbg !41
  call void @threadCreator(i64* noundef nonnull %2), !dbg !43
  %3 = load i64, i64* %2, align 8, !dbg !44
  call void @llvm.dbg.value(metadata i64 %3, metadata !42, metadata !DIExpression()), !dbg !41
  %4 = call i32 @pthread_join(i64 noundef %3, i8** noundef null) #5, !dbg !45
  ret i8* null, !dbg !46
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !47 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !50, metadata !DIExpression(DW_OP_deref)), !dbg !51
  %2 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread1, i8* noundef null) #5, !dbg !52
  %3 = load i64, i64* %1, align 8, !dbg !53
  call void @llvm.dbg.value(metadata i64 %3, metadata !50, metadata !DIExpression()), !dbg !51
  %4 = call i32 @pthread_join(i64 noundef %3, i8** noundef null) #5, !dbg !54
  %5 = load atomic i32, i32* @data seq_cst, align 4, !dbg !55
  %6 = icmp eq i32 %5, 42, !dbg !55
  br i1 %6, label %8, label %7, !dbg !58

7:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([67 x i8], [67 x i8]* @.str.1, i64 0, i64 0), i32 noundef 36, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !55
  unreachable, !dbg !55

8:                                                ; preds = %0
  ret i32 0, !dbg !59
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
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/thread_inlining.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "486df55ec57b612fd5a61a8726fafa04")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0}
!7 = !DIFile(filename: "benchmarks/c/miscellaneous/thread_inlining.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "486df55ec57b612fd5a61a8726fafa04")
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
!28 = distinct !DISubprogram(name: "threadCreator", scope: !7, file: !7, line: 18, type: !29, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!29 = !DISubroutineType(types: !30)
!30 = !{null, !31}
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !33, line: 27, baseType: !34)
!33 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!34 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!35 = !DILocalVariable(name: "t", arg: 1, scope: !28, file: !7, line: 18, type: !31)
!36 = !DILocation(line: 0, scope: !28)
!37 = !DILocation(line: 19, column: 5, scope: !28)
!38 = !DILocation(line: 20, column: 1, scope: !28)
!39 = distinct !DISubprogram(name: "thread1", scope: !7, file: !7, line: 22, type: !21, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!40 = !DILocalVariable(name: "arg", arg: 1, scope: !39, file: !7, line: 22, type: !5)
!41 = !DILocation(line: 0, scope: !39)
!42 = !DILocalVariable(name: "t", scope: !39, file: !7, line: 24, type: !32)
!43 = !DILocation(line: 25, column: 5, scope: !39)
!44 = !DILocation(line: 26, column: 18, scope: !39)
!45 = !DILocation(line: 26, column: 5, scope: !39)
!46 = !DILocation(line: 27, column: 5, scope: !39)
!47 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 30, type: !48, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!48 = !DISubroutineType(types: !49)
!49 = !{!11}
!50 = !DILocalVariable(name: "t1", scope: !47, file: !7, line: 32, type: !32)
!51 = !DILocation(line: 0, scope: !47)
!52 = !DILocation(line: 33, column: 5, scope: !47)
!53 = !DILocation(line: 34, column: 18, scope: !47)
!54 = !DILocation(line: 34, column: 5, scope: !47)
!55 = !DILocation(line: 36, column: 5, scope: !56)
!56 = distinct !DILexicalBlock(scope: !57, file: !7, line: 36, column: 5)
!57 = distinct !DILexicalBlock(scope: !47, file: !7, line: 36, column: 5)
!58 = !DILocation(line: 36, column: 5, scope: !57)
!59 = !DILocation(line: 37, column: 1, scope: !47)
