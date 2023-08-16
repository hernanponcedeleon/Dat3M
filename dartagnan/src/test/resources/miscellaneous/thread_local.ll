; ModuleID = '/home/ponce/git/Dat3M/output/thread_local.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/thread_local.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@val = dso_local thread_local global i32 5, align 4, !dbg !0
@data = dso_local thread_local global i32 0, align 4, !dbg !8
@.str = private unnamed_addr constant [14 x i8] c"data == value\00", align 1
@.str.1 = private unnamed_addr constant [64 x i8] c"/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/thread_local.c\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [16 x i8] c"void check(int)\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"val == 5\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @check(i32 noundef %0) #0 !dbg !22 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !26, metadata !DIExpression()), !dbg !27
  %2 = load atomic i32, i32* @data seq_cst, align 4, !dbg !28
  %3 = icmp eq i32 %2, %0, !dbg !28
  br i1 %3, label %5, label %4, !dbg !31

4:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([64 x i8], [64 x i8]* @.str.1, i64 0, i64 0), i32 noundef 16, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !28
  unreachable, !dbg !28

5:                                                ; preds = %1
  %6 = load i32, i32* @val, align 4, !dbg !32
  %7 = icmp eq i32 %6, 5, !dbg !32
  br i1 %7, label %9, label %8, !dbg !35

8:                                                ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([64 x i8], [64 x i8]* @.str.1, i64 0, i64 0), i32 noundef 17, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !32
  unreachable, !dbg !32

9:                                                ; preds = %5
  ret void, !dbg !36
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread2(i8* noundef %0) #0 !dbg !37 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !40, metadata !DIExpression()), !dbg !41
  %2 = ptrtoint i8* %0 to i64, !dbg !42
  %3 = trunc i64 %2 to i32, !dbg !42
  store atomic i32 %3, i32* @data seq_cst, align 4, !dbg !43
  call void @check(i32 noundef 2), !dbg !44
  ret i8* null, !dbg !45
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread1(i8* noundef %0) #0 !dbg !46 {
  %2 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i8* %0, metadata !47, metadata !DIExpression()), !dbg !48
  %3 = ptrtoint i8* %0 to i64, !dbg !49
  %4 = trunc i64 %3 to i32, !dbg !49
  store atomic i32 %4, i32* @data seq_cst, align 4, !dbg !50
  call void @llvm.dbg.value(metadata i64* %2, metadata !51, metadata !DIExpression(DW_OP_deref)), !dbg !48
  %5 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread2, i8* noundef nonnull inttoptr (i64 2 to i8*)) #6, !dbg !55
  %6 = load i64, i64* %2, align 8, !dbg !56
  call void @llvm.dbg.value(metadata i64 %6, metadata !51, metadata !DIExpression()), !dbg !48
  %7 = call i32 @pthread_join(i64 noundef %6, i8** noundef null) #6, !dbg !57
  call void @check(i32 noundef 1), !dbg !58
  ret i8* null, !dbg !59
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !60 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !63, metadata !DIExpression(DW_OP_deref)), !dbg !64
  %2 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread1, i8* noundef nonnull inttoptr (i64 1 to i8*)) #6, !dbg !65
  %3 = load i64, i64* %1, align 8, !dbg !66
  call void @llvm.dbg.value(metadata i64 %3, metadata !63, metadata !DIExpression()), !dbg !64
  %4 = call i32 @pthread_join(i64 noundef %3, i8** noundef null) #6, !dbg !67
  call void @check(i32 noundef 0), !dbg !68
  ret i32 0, !dbg !69
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!14, !15, !16, !17, !18, !19, !20}
!llvm.ident = !{!21}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "val", scope: !2, file: !10, line: 11, type: !5, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !7, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/thread_local.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "569899f0b028af48139959a5d817a4aa")
!4 = !{!5, !6}
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !{!0, !8}
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !10, line: 10, type: !11, isLocal: false, isDefinition: true)
!10 = !DIFile(filename: "benchmarks/c/miscellaneous/thread_local.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "569899f0b028af48139959a5d817a4aa")
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !12, line: 92, baseType: !13)
!12 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "de5d66a1ef2f5448cc1919ff39db92bc")
!13 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !5)
!14 = !{i32 7, !"Dwarf Version", i32 5}
!15 = !{i32 2, !"Debug Info Version", i32 3}
!16 = !{i32 1, !"wchar_size", i32 4}
!17 = !{i32 7, !"PIC Level", i32 2}
!18 = !{i32 7, !"PIE Level", i32 2}
!19 = !{i32 7, !"uwtable", i32 1}
!20 = !{i32 7, !"frame-pointer", i32 2}
!21 = !{!"Ubuntu clang version 14.0.6"}
!22 = distinct !DISubprogram(name: "check", scope: !10, file: !10, line: 13, type: !23, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!23 = !DISubroutineType(types: !24)
!24 = !{null, !5}
!25 = !{}
!26 = !DILocalVariable(name: "value", arg: 1, scope: !22, file: !10, line: 13, type: !5)
!27 = !DILocation(line: 0, scope: !22)
!28 = !DILocation(line: 16, column: 4, scope: !29)
!29 = distinct !DILexicalBlock(scope: !30, file: !10, line: 16, column: 4)
!30 = distinct !DILexicalBlock(scope: !22, file: !10, line: 16, column: 4)
!31 = !DILocation(line: 16, column: 4, scope: !30)
!32 = !DILocation(line: 17, column: 4, scope: !33)
!33 = distinct !DILexicalBlock(scope: !34, file: !10, line: 17, column: 4)
!34 = distinct !DILexicalBlock(scope: !22, file: !10, line: 17, column: 4)
!35 = !DILocation(line: 17, column: 4, scope: !34)
!36 = !DILocation(line: 18, column: 1, scope: !22)
!37 = distinct !DISubprogram(name: "thread2", scope: !10, file: !10, line: 20, type: !38, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!38 = !DISubroutineType(types: !39)
!39 = !{!6, !6}
!40 = !DILocalVariable(name: "arg", arg: 1, scope: !37, file: !10, line: 20, type: !6)
!41 = !DILocation(line: 0, scope: !37)
!42 = !DILocation(line: 22, column: 12, scope: !37)
!43 = !DILocation(line: 22, column: 10, scope: !37)
!44 = !DILocation(line: 23, column: 5, scope: !37)
!45 = !DILocation(line: 24, column: 5, scope: !37)
!46 = distinct !DISubprogram(name: "thread1", scope: !10, file: !10, line: 27, type: !38, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!47 = !DILocalVariable(name: "arg", arg: 1, scope: !46, file: !10, line: 27, type: !6)
!48 = !DILocation(line: 0, scope: !46)
!49 = !DILocation(line: 29, column: 12, scope: !46)
!50 = !DILocation(line: 29, column: 10, scope: !46)
!51 = !DILocalVariable(name: "t2", scope: !46, file: !10, line: 31, type: !52)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !53, line: 27, baseType: !54)
!53 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!54 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!55 = !DILocation(line: 32, column: 5, scope: !46)
!56 = !DILocation(line: 33, column: 18, scope: !46)
!57 = !DILocation(line: 33, column: 5, scope: !46)
!58 = !DILocation(line: 35, column: 5, scope: !46)
!59 = !DILocation(line: 36, column: 5, scope: !46)
!60 = distinct !DISubprogram(name: "main", scope: !10, file: !10, line: 39, type: !61, scopeLine: 40, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!61 = !DISubroutineType(types: !62)
!62 = !{!5}
!63 = !DILocalVariable(name: "t1", scope: !60, file: !10, line: 41, type: !52)
!64 = !DILocation(line: 0, scope: !60)
!65 = !DILocation(line: 42, column: 5, scope: !60)
!66 = !DILocation(line: 43, column: 18, scope: !60)
!67 = !DILocation(line: 43, column: 5, scope: !60)
!68 = !DILocation(line: 45, column: 5, scope: !60)
!69 = !DILocation(line: 46, column: 1, scope: !60)
