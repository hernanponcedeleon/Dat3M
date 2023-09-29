; ModuleID = '/home/ponce/git/Dat3M/output/c11_with_barrier_dec_barrier.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/interrupts/c11_with_barrier_dec_barrier.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.A = type { i32, i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@cnt = dso_local global i32 0, align 4, !dbg !0
@as = dso_local global [10 x %struct.A] zeroinitializer, align 16, !dbg !10
@.str = private unnamed_addr constant [19 x i8] c"as[i].a == as[i].b\00", align 1
@.str.1 = private unnamed_addr constant [75 x i8] c"/home/ponce/git/Dat3M/benchmarks/interrupts/c11_with_barrier_dec_barrier.c\00", align 1
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
  %6 = call i32 (...) @__VERIFIER_make_cb(), !dbg !46
  %7 = sext i32 %4 to i64, !dbg !47
  %8 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %7, !dbg !47
  %9 = getelementptr inbounds %struct.A, %struct.A* %8, i32 0, i32 0, !dbg !48
  store volatile i32 %3, i32* %9, align 8, !dbg !49
  %10 = getelementptr inbounds %struct.A, %struct.A* %8, i32 0, i32 1, !dbg !50
  store volatile i32 %3, i32* %10, align 4, !dbg !51
  %11 = load volatile i32, i32* %9, align 8, !dbg !52
  %12 = load volatile i32, i32* %10, align 4, !dbg !52
  %13 = icmp eq i32 %11, %12, !dbg !52
  br i1 %13, label %15, label %14, !dbg !55

14:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([75 x i8], [75 x i8]* @.str.1, i64 0, i64 0), i32 noundef 23, i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @__PRETTY_FUNCTION__.handler, i64 0, i64 0)) #5, !dbg !52
  unreachable, !dbg !52

15:                                               ; preds = %1
  %16 = call i32 (...) @__VERIFIER_make_cb(), !dbg !56
  %17 = load i32, i32* @cnt, align 4, !dbg !57
  %18 = add nsw i32 %17, -1, !dbg !57
  store i32 %18, i32* @cnt, align 4, !dbg !57
  ret i8* null, !dbg !58
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @__VERIFIER_make_cb(...) #2

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @run(i8* noundef %0) #0 !dbg !59 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !60, metadata !DIExpression()), !dbg !61
  %2 = call i32 (...) @__VERIFIER_make_interrupt_handler(), !dbg !62
  %3 = call i32 @pthread_create(i64* noundef @h, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null) #6, !dbg !63
  %4 = ptrtoint i8* %0 to i64, !dbg !64
  %5 = trunc i64 %4 to i32, !dbg !65
  call void @llvm.dbg.value(metadata i32 %5, metadata !66, metadata !DIExpression()), !dbg !61
  %6 = load i32, i32* @cnt, align 4, !dbg !67
  %7 = add nsw i32 %6, 1, !dbg !67
  store i32 %7, i32* @cnt, align 4, !dbg !67
  call void @llvm.dbg.value(metadata i32 %6, metadata !68, metadata !DIExpression()), !dbg !61
  %8 = call i32 (...) @__VERIFIER_make_cb(), !dbg !69
  %9 = sext i32 %6 to i64, !dbg !70
  %10 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %9, !dbg !70
  %11 = getelementptr inbounds %struct.A, %struct.A* %10, i32 0, i32 0, !dbg !71
  store volatile i32 %5, i32* %11, align 8, !dbg !72
  %12 = getelementptr inbounds %struct.A, %struct.A* %10, i32 0, i32 1, !dbg !73
  store volatile i32 %5, i32* %12, align 4, !dbg !74
  %13 = load volatile i32, i32* %11, align 8, !dbg !75
  %14 = load volatile i32, i32* %12, align 4, !dbg !75
  %15 = icmp eq i32 %13, %14, !dbg !75
  br i1 %15, label %17, label %16, !dbg !78

16:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([75 x i8], [75 x i8]* @.str.1, i64 0, i64 0), i32 noundef 41, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !75
  unreachable, !dbg !75

17:                                               ; preds = %1
  %18 = call i32 (...) @__VERIFIER_make_cb(), !dbg !79
  %19 = load i32, i32* @cnt, align 4, !dbg !80
  %20 = add nsw i32 %19, -1, !dbg !80
  store i32 %20, i32* @cnt, align 4, !dbg !80
  %21 = load i64, i64* @h, align 8, !dbg !81
  %22 = call i32 @pthread_join(i64 noundef %21, i8** noundef null), !dbg !82
  ret i8* null, !dbg !83
}

declare i32 @__VERIFIER_make_interrupt_handler(...) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #4

declare i32 @pthread_join(i64 noundef, i8** noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !84 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !87, metadata !DIExpression()), !dbg !88
  %2 = call i32 @pthread_create(i64* noundef %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !89
  ret i32 0, !dbg !90
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!27, !28, !29, !30, !31, !32, !33}
!llvm.ident = !{!34}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "cnt", scope: !2, file: !12, line: 13, type: !18, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !9, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/interrupts/c11_with_barrier_dec_barrier.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "a2014d668aaa00b05294ce9d614a1cd0")
!4 = !{!5, !8}
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !6, line: 87, baseType: !7)
!6 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!7 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!9 = !{!0, !10, !22}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "as", scope: !2, file: !12, line: 12, type: !13, isLocal: false, isDefinition: true)
!12 = !DIFile(filename: "benchmarks/interrupts/c11_with_barrier_dec_barrier.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "a2014d668aaa00b05294ce9d614a1cd0")
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
!47 = !DILocation(line: 21, column: 5, scope: !35)
!48 = !DILocation(line: 21, column: 11, scope: !35)
!49 = !DILocation(line: 21, column: 13, scope: !35)
!50 = !DILocation(line: 22, column: 11, scope: !35)
!51 = !DILocation(line: 22, column: 13, scope: !35)
!52 = !DILocation(line: 23, column: 5, scope: !53)
!53 = distinct !DILexicalBlock(scope: !54, file: !12, line: 23, column: 5)
!54 = distinct !DILexicalBlock(scope: !35, file: !12, line: 23, column: 5)
!55 = !DILocation(line: 23, column: 5, scope: !54)
!56 = !DILocation(line: 25, column: 5, scope: !35)
!57 = !DILocation(line: 26, column: 8, scope: !35)
!58 = !DILocation(line: 28, column: 5, scope: !35)
!59 = distinct !DISubprogram(name: "run", scope: !12, file: !12, line: 31, type: !36, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !38)
!60 = !DILocalVariable(name: "arg", arg: 1, scope: !59, file: !12, line: 31, type: !8)
!61 = !DILocation(line: 0, scope: !59)
!62 = !DILocation(line: 33, column: 5, scope: !59)
!63 = !DILocation(line: 34, column: 5, scope: !59)
!64 = !DILocation(line: 36, column: 19, scope: !59)
!65 = !DILocation(line: 36, column: 18, scope: !59)
!66 = !DILocalVariable(name: "tindex", scope: !59, file: !12, line: 36, type: !18)
!67 = !DILocation(line: 37, column: 16, scope: !59)
!68 = !DILocalVariable(name: "i", scope: !59, file: !12, line: 37, type: !18)
!69 = !DILocation(line: 38, column: 5, scope: !59)
!70 = !DILocation(line: 39, column: 5, scope: !59)
!71 = !DILocation(line: 39, column: 11, scope: !59)
!72 = !DILocation(line: 39, column: 13, scope: !59)
!73 = !DILocation(line: 40, column: 11, scope: !59)
!74 = !DILocation(line: 40, column: 13, scope: !59)
!75 = !DILocation(line: 41, column: 5, scope: !76)
!76 = distinct !DILexicalBlock(scope: !77, file: !12, line: 41, column: 5)
!77 = distinct !DILexicalBlock(scope: !59, file: !12, line: 41, column: 5)
!78 = !DILocation(line: 41, column: 5, scope: !77)
!79 = !DILocation(line: 43, column: 5, scope: !59)
!80 = !DILocation(line: 44, column: 8, scope: !59)
!81 = !DILocation(line: 46, column: 18, scope: !59)
!82 = !DILocation(line: 46, column: 5, scope: !59)
!83 = !DILocation(line: 48, column: 5, scope: !59)
!84 = distinct !DISubprogram(name: "main", scope: !12, file: !12, line: 51, type: !85, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !38)
!85 = !DISubroutineType(types: !86)
!86 = !{!18}
!87 = !DILocalVariable(name: "t", scope: !84, file: !12, line: 53, type: !24)
!88 = !DILocation(line: 53, column: 15, scope: !84)
!89 = !DILocation(line: 54, column: 5, scope: !84)
!90 = !DILocation(line: 56, column: 5, scope: !84)
