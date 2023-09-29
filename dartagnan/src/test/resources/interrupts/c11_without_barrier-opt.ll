; ModuleID = '/home/ponce/git/Dat3M/output/c11_without_barrier.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/interrupts/c11_without_barrier.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.A = type { i32, i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@cnt = dso_local global i32 0, align 4, !dbg !0
@as = dso_local global [10 x %struct.A] zeroinitializer, align 16, !dbg !10
@.str = private unnamed_addr constant [19 x i8] c"as[i].a == as[i].b\00", align 1
@.str.1 = private unnamed_addr constant [66 x i8] c"/home/ponce/git/Dat3M/benchmarks/interrupts/c11_without_barrier.c\00", align 1
@__PRETTY_FUNCTION__.handler = private unnamed_addr constant [22 x i8] c"void *handler(void *)\00", align 1
@h = dso_local global i64 0, align 8, !dbg !22
@__PRETTY_FUNCTION__.run = private unnamed_addr constant [18 x i8] c"void *run(void *)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @handler(i8* noundef %0) #0 !dbg !35 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !39, metadata !DIExpression()), !dbg !40
  %2 = ptrtoint i8* %0 to i64, !dbg !41
  %3 = trunc i64 %2 to i32, !dbg !42
  call void @llvm.dbg.value(metadata i32 %3, metadata !43, metadata !DIExpression()), !dbg !40
  %4 = load i32, i32* @cnt, align 4, !dbg !44
  %5 = add nsw i32 %4, 1, !dbg !44
  store i32 %5, i32* @cnt, align 4, !dbg !44
  call void @llvm.dbg.value(metadata i32 %4, metadata !45, metadata !DIExpression()), !dbg !40
  %6 = sext i32 %4 to i64, !dbg !46
  %7 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %6, !dbg !46
  %8 = getelementptr inbounds %struct.A, %struct.A* %7, i32 0, i32 0, !dbg !47
  store volatile i32 %3, i32* %8, align 8, !dbg !48
  %9 = getelementptr inbounds %struct.A, %struct.A* %7, i32 0, i32 1, !dbg !49
  store volatile i32 %3, i32* %9, align 4, !dbg !50
  %10 = load volatile i32, i32* %8, align 8, !dbg !51
  %11 = load volatile i32, i32* %9, align 4, !dbg !51
  %12 = icmp eq i32 %10, %11, !dbg !51
  br i1 %12, label %14, label %13, !dbg !54

13:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @.str.1, i64 0, i64 0), i32 noundef 22, i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @__PRETTY_FUNCTION__.handler, i64 0, i64 0)) #5, !dbg !51
  unreachable, !dbg !51

14:                                               ; preds = %1
  ret i8* null, !dbg !55
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @run(i8* noundef %0) #0 !dbg !56 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !57, metadata !DIExpression()), !dbg !58
  %2 = call i32 (...) @__VERIFIER_make_interrupt_handler(), !dbg !59
  %3 = call i32 @pthread_create(i64* noundef @h, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null) #6, !dbg !60
  %4 = ptrtoint i8* %0 to i64, !dbg !61
  %5 = trunc i64 %4 to i32, !dbg !62
  call void @llvm.dbg.value(metadata i32 %5, metadata !63, metadata !DIExpression()), !dbg !58
  %6 = load i32, i32* @cnt, align 4, !dbg !64
  %7 = add nsw i32 %6, 1, !dbg !64
  store i32 %7, i32* @cnt, align 4, !dbg !64
  call void @llvm.dbg.value(metadata i32 %6, metadata !65, metadata !DIExpression()), !dbg !58
  %8 = sext i32 %6 to i64, !dbg !66
  %9 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %8, !dbg !66
  %10 = getelementptr inbounds %struct.A, %struct.A* %9, i32 0, i32 0, !dbg !67
  store volatile i32 %5, i32* %10, align 8, !dbg !68
  %11 = getelementptr inbounds %struct.A, %struct.A* %9, i32 0, i32 1, !dbg !69
  store volatile i32 %5, i32* %11, align 4, !dbg !70
  %12 = load volatile i32, i32* %10, align 8, !dbg !71
  %13 = load volatile i32, i32* %11, align 4, !dbg !71
  %14 = icmp eq i32 %12, %13, !dbg !71
  br i1 %14, label %16, label %15, !dbg !74

15:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @.str.1, i64 0, i64 0), i32 noundef 36, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !71
  unreachable, !dbg !71

16:                                               ; preds = %1
  %17 = load i64, i64* @h, align 8, !dbg !75
  %18 = call i32 @pthread_join(i64 noundef %17, i8** noundef null), !dbg !76
  ret i8* null, !dbg !77
}

declare i32 @__VERIFIER_make_interrupt_handler(...) #3

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #4

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !78 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !81, metadata !DIExpression()), !dbg !82
  %2 = call i32 @pthread_create(i64* noundef %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !83
  ret i32 0, !dbg !84
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!27, !28, !29, !30, !31, !32, !33}
!llvm.ident = !{!34}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "cnt", scope: !2, file: !12, line: 13, type: !18, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !9, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/interrupts/c11_without_barrier.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "c90a0005011740e971ddcb6dbe05268e")
!4 = !{!5, !8}
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !6, line: 87, baseType: !7)
!6 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!7 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!9 = !{!0, !10, !22}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "as", scope: !2, file: !12, line: 12, type: !13, isLocal: false, isDefinition: true)
!12 = !DIFile(filename: "benchmarks/interrupts/c11_without_barrier.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "c90a0005011740e971ddcb6dbe05268e")
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 640, elements: !20)
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "A", file: !12, line: 11, size: 64, elements: !15)
!15 = !{!16, !19}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !14, file: !12, line: 11, baseType: !17, size: 32)
!17 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !18)
!18 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !14, file: !12, line: 11, baseType: !17, size: 32, offset: 32)
!20 = !{!21}
!21 = !DISubrange(count: 10)
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !12, line: 15, type: !24, isLocal: false, isDefinition: true)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !25, line: 27, baseType: !26)
!25 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!26 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!27 = !{i32 7, !"Dwarf Version", i32 5}
!28 = !{i32 2, !"Debug Info Version", i32 3}
!29 = !{i32 1, !"wchar_size", i32 4}
!30 = !{i32 7, !"PIC Level", i32 2}
!31 = !{i32 7, !"PIE Level", i32 2}
!32 = !{i32 7, !"uwtable", i32 1}
!33 = !{i32 7, !"frame-pointer", i32 2}
!34 = !{!"Ubuntu clang version 14.0.6"}
!35 = distinct !DISubprogram(name: "handler", scope: !12, file: !12, line: 16, type: !36, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !38)
!36 = !DISubroutineType(types: !37)
!37 = !{!8, !8}
!38 = !{}
!39 = !DILocalVariable(name: "arg", arg: 1, scope: !35, file: !12, line: 16, type: !8)
!40 = !DILocation(line: 0, scope: !35)
!41 = !DILocation(line: 18, column: 19, scope: !35)
!42 = !DILocation(line: 18, column: 18, scope: !35)
!43 = !DILocalVariable(name: "tindex", scope: !35, file: !12, line: 18, type: !18)
!44 = !DILocation(line: 19, column: 16, scope: !35)
!45 = !DILocalVariable(name: "i", scope: !35, file: !12, line: 19, type: !18)
!46 = !DILocation(line: 20, column: 5, scope: !35)
!47 = !DILocation(line: 20, column: 11, scope: !35)
!48 = !DILocation(line: 20, column: 13, scope: !35)
!49 = !DILocation(line: 21, column: 11, scope: !35)
!50 = !DILocation(line: 21, column: 13, scope: !35)
!51 = !DILocation(line: 22, column: 5, scope: !52)
!52 = distinct !DILexicalBlock(scope: !53, file: !12, line: 22, column: 5)
!53 = distinct !DILexicalBlock(scope: !35, file: !12, line: 22, column: 5)
!54 = !DILocation(line: 22, column: 5, scope: !53)
!55 = !DILocation(line: 24, column: 5, scope: !35)
!56 = distinct !DISubprogram(name: "run", scope: !12, file: !12, line: 27, type: !36, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !38)
!57 = !DILocalVariable(name: "arg", arg: 1, scope: !56, file: !12, line: 27, type: !8)
!58 = !DILocation(line: 0, scope: !56)
!59 = !DILocation(line: 29, column: 5, scope: !56)
!60 = !DILocation(line: 30, column: 5, scope: !56)
!61 = !DILocation(line: 32, column: 19, scope: !56)
!62 = !DILocation(line: 32, column: 18, scope: !56)
!63 = !DILocalVariable(name: "tindex", scope: !56, file: !12, line: 32, type: !18)
!64 = !DILocation(line: 33, column: 16, scope: !56)
!65 = !DILocalVariable(name: "i", scope: !56, file: !12, line: 33, type: !18)
!66 = !DILocation(line: 34, column: 5, scope: !56)
!67 = !DILocation(line: 34, column: 11, scope: !56)
!68 = !DILocation(line: 34, column: 13, scope: !56)
!69 = !DILocation(line: 35, column: 11, scope: !56)
!70 = !DILocation(line: 35, column: 13, scope: !56)
!71 = !DILocation(line: 36, column: 5, scope: !72)
!72 = distinct !DILexicalBlock(scope: !73, file: !12, line: 36, column: 5)
!73 = distinct !DILexicalBlock(scope: !56, file: !12, line: 36, column: 5)
!74 = !DILocation(line: 36, column: 5, scope: !73)
!75 = !DILocation(line: 38, column: 18, scope: !56)
!76 = !DILocation(line: 38, column: 5, scope: !56)
!77 = !DILocation(line: 40, column: 5, scope: !56)
!78 = distinct !DISubprogram(name: "main", scope: !12, file: !12, line: 43, type: !79, scopeLine: 44, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !38)
!79 = !DISubroutineType(types: !80)
!80 = !{!18}
!81 = !DILocalVariable(name: "t", scope: !78, file: !12, line: 45, type: !24)
!82 = !DILocation(line: 45, column: 15, scope: !78)
!83 = !DILocation(line: 46, column: 5, scope: !78)
!84 = !DILocation(line: 48, column: 5, scope: !78)
