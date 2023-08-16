; ModuleID = '/home/ponce/git/Dat3M/output/thread_chaining.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/thread_chaining.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@data = dso_local global i32 0, align 4, !dbg !0
@.str = private unnamed_addr constant [11 x i8] c"data == 42\00", align 1
@.str.1 = private unnamed_addr constant [67 x i8] c"/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/thread_chaining.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread2(i8* noundef %0) #0 !dbg !20 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !24, metadata !DIExpression()), !dbg !25
  %2 = ptrtoint i8* %0 to i64, !dbg !26
  %3 = trunc i64 %2 to i32, !dbg !26
  store atomic i32 %3, i32* @data seq_cst, align 4, !dbg !27
  ret i8* null, !dbg !28
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread1(i8* noundef %0) #0 !dbg !29 {
  %2 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i8* %0, metadata !30, metadata !DIExpression()), !dbg !31
  call void @llvm.dbg.value(metadata i64* %2, metadata !32, metadata !DIExpression(DW_OP_deref)), !dbg !31
  %3 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread2, i8* noundef %0) #5, !dbg !36
  %4 = load i64, i64* %2, align 8, !dbg !37
  call void @llvm.dbg.value(metadata i64 %4, metadata !32, metadata !DIExpression()), !dbg !31
  %5 = call i32 @pthread_join(i64 noundef %4, i8** noundef null) #5, !dbg !38
  ret i8* null, !dbg !39
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !40 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !43, metadata !DIExpression(DW_OP_deref)), !dbg !44
  %2 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread1, i8* noundef nonnull inttoptr (i64 42 to i8*)) #5, !dbg !45
  %3 = load i64, i64* %1, align 8, !dbg !46
  call void @llvm.dbg.value(metadata i64 %3, metadata !43, metadata !DIExpression()), !dbg !44
  %4 = call i32 @pthread_join(i64 noundef %3, i8** noundef null) #5, !dbg !47
  %5 = load atomic i32, i32* @data seq_cst, align 4, !dbg !48
  %6 = icmp eq i32 %5, 42, !dbg !48
  br i1 %6, label %8, label %7, !dbg !51

7:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([67 x i8], [67 x i8]* @.str.1, i64 0, i64 0), i32 noundef 33, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !48
  unreachable, !dbg !48

8:                                                ; preds = %0
  ret i32 0, !dbg !52
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
!1 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !8, line: 11, type: !9, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !7, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/thread_chaining.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "6161236985e319720e02181c2ac86678")
!4 = !{!5, !6}
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !{!0}
!8 = !DIFile(filename: "benchmarks/c/miscellaneous/thread_chaining.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "6161236985e319720e02181c2ac86678")
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !10, line: 92, baseType: !11)
!10 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "de5d66a1ef2f5448cc1919ff39db92bc")
!11 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !5)
!12 = !{i32 7, !"Dwarf Version", i32 5}
!13 = !{i32 2, !"Debug Info Version", i32 3}
!14 = !{i32 1, !"wchar_size", i32 4}
!15 = !{i32 7, !"PIC Level", i32 2}
!16 = !{i32 7, !"PIE Level", i32 2}
!17 = !{i32 7, !"uwtable", i32 1}
!18 = !{i32 7, !"frame-pointer", i32 2}
!19 = !{!"Ubuntu clang version 14.0.6"}
!20 = distinct !DISubprogram(name: "thread2", scope: !8, file: !8, line: 13, type: !21, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!21 = !DISubroutineType(types: !22)
!22 = !{!6, !6}
!23 = !{}
!24 = !DILocalVariable(name: "arg", arg: 1, scope: !20, file: !8, line: 13, type: !6)
!25 = !DILocation(line: 0, scope: !20)
!26 = !DILocation(line: 15, column: 12, scope: !20)
!27 = !DILocation(line: 15, column: 10, scope: !20)
!28 = !DILocation(line: 16, column: 5, scope: !20)
!29 = distinct !DISubprogram(name: "thread1", scope: !8, file: !8, line: 19, type: !21, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!30 = !DILocalVariable(name: "arg", arg: 1, scope: !29, file: !8, line: 19, type: !6)
!31 = !DILocation(line: 0, scope: !29)
!32 = !DILocalVariable(name: "t2", scope: !29, file: !8, line: 21, type: !33)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !34, line: 27, baseType: !35)
!34 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!35 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!36 = !DILocation(line: 22, column: 5, scope: !29)
!37 = !DILocation(line: 23, column: 18, scope: !29)
!38 = !DILocation(line: 23, column: 5, scope: !29)
!39 = !DILocation(line: 24, column: 5, scope: !29)
!40 = distinct !DISubprogram(name: "main", scope: !8, file: !8, line: 27, type: !41, scopeLine: 28, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!41 = !DISubroutineType(types: !42)
!42 = !{!5}
!43 = !DILocalVariable(name: "t1", scope: !40, file: !8, line: 29, type: !33)
!44 = !DILocation(line: 0, scope: !40)
!45 = !DILocation(line: 30, column: 5, scope: !40)
!46 = !DILocation(line: 31, column: 18, scope: !40)
!47 = !DILocation(line: 31, column: 5, scope: !40)
!48 = !DILocation(line: 33, column: 5, scope: !49)
!49 = distinct !DILexicalBlock(scope: !50, file: !8, line: 33, column: 5)
!50 = distinct !DILexicalBlock(scope: !40, file: !8, line: 33, column: 5)
!51 = !DILocation(line: 33, column: 5, scope: !50)
!52 = !DILocation(line: 34, column: 1, scope: !40)
