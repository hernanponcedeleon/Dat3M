; ModuleID = '/home/ponce/git/Dat3M/output/pthread_mutex.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/pthread_mutex.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@m = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !0
@sum = dso_local global i32 0, align 4, !dbg !7
@.str = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@.str.1 = private unnamed_addr constant [55 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/pthread_mutex.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @run(i8* noundef %0) #0 !dbg !51 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !55, metadata !DIExpression()), !dbg !56
  %2 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef @m) #5, !dbg !57
  %3 = load i32, i32* @sum, align 4, !dbg !58
  %4 = add nsw i32 %3, 1, !dbg !58
  store i32 %4, i32* @sum, align 4, !dbg !58
  %5 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef @m) #5, !dbg !59
  ret i8* null, !dbg !60
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !61 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !64, metadata !DIExpression()), !dbg !70
  %2 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef @m, %union.pthread_mutexattr_t* noundef null) #5, !dbg !71
  call void @llvm.dbg.value(metadata i32 0, metadata !72, metadata !DIExpression()), !dbg !74
  call void @llvm.dbg.value(metadata i64 0, metadata !72, metadata !DIExpression()), !dbg !74
  %3 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !75
  %4 = call i32 @pthread_create(i64* noundef %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef null) #5, !dbg !77
  call void @llvm.dbg.value(metadata i64 1, metadata !72, metadata !DIExpression()), !dbg !74
  call void @llvm.dbg.value(metadata i64 1, metadata !72, metadata !DIExpression()), !dbg !74
  %5 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !75
  %6 = call i32 @pthread_create(i64* noundef %5, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 1 to i8*)) #5, !dbg !77
  call void @llvm.dbg.value(metadata i64 2, metadata !72, metadata !DIExpression()), !dbg !74
  call void @llvm.dbg.value(metadata i64 2, metadata !72, metadata !DIExpression()), !dbg !74
  %7 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !75
  %8 = call i32 @pthread_create(i64* noundef %7, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 2 to i8*)) #5, !dbg !77
  call void @llvm.dbg.value(metadata i64 3, metadata !72, metadata !DIExpression()), !dbg !74
  call void @llvm.dbg.value(metadata i64 3, metadata !72, metadata !DIExpression()), !dbg !74
  call void @llvm.dbg.value(metadata i32 0, metadata !78, metadata !DIExpression()), !dbg !80
  call void @llvm.dbg.value(metadata i64 0, metadata !78, metadata !DIExpression()), !dbg !80
  %9 = load i64, i64* %3, align 8, !dbg !81
  %10 = call i32 @pthread_join(i64 noundef %9, i8** noundef null), !dbg !83
  call void @llvm.dbg.value(metadata i64 1, metadata !78, metadata !DIExpression()), !dbg !80
  call void @llvm.dbg.value(metadata i64 1, metadata !78, metadata !DIExpression()), !dbg !80
  %11 = load i64, i64* %5, align 8, !dbg !81
  %12 = call i32 @pthread_join(i64 noundef %11, i8** noundef null), !dbg !83
  call void @llvm.dbg.value(metadata i64 2, metadata !78, metadata !DIExpression()), !dbg !80
  call void @llvm.dbg.value(metadata i64 2, metadata !78, metadata !DIExpression()), !dbg !80
  %13 = load i64, i64* %7, align 8, !dbg !81
  %14 = call i32 @pthread_join(i64 noundef %13, i8** noundef null), !dbg !83
  call void @llvm.dbg.value(metadata i64 3, metadata !78, metadata !DIExpression()), !dbg !80
  call void @llvm.dbg.value(metadata i64 3, metadata !78, metadata !DIExpression()), !dbg !80
  %15 = load i32, i32* @sum, align 4, !dbg !84
  %16 = icmp eq i32 %15, 3, !dbg !84
  br i1 %16, label %18, label %17, !dbg !87

17:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @.str.1, i64 0, i64 0), i32 noundef 33, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !84
  unreachable, !dbg !84

18:                                               ; preds = %0
  ret i32 0, !dbg !88
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

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
!llvm.module.flags = !{!43, !44, !45, !46, !47, !48, !49}
!llvm.ident = !{!50}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "m", scope: !2, file: !9, line: 7, type: !11, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/pthread_mutex.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "70888e8e826c3ef3a7105532af531b10")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !0}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !9, line: 6, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "benchmarks/locks/pthread_mutex.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "70888e8e826c3ef3a7105532af531b10")
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !12, line: 72, baseType: !13)
!12 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!13 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !12, line: 67, size: 320, elements: !14)
!14 = !{!15, !36, !41}
!15 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !13, file: !12, line: 69, baseType: !16, size: 320)
!16 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !17, line: 22, size: 320, elements: !18)
!17 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "3a896f588055d599ccb9e3fe6eaee3e3")
!18 = !{!19, !20, !22, !23, !24, !25, !27, !28}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !16, file: !17, line: 24, baseType: !10, size: 32)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !16, file: !17, line: 25, baseType: !21, size: 32, offset: 32)
!21 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !16, file: !17, line: 26, baseType: !10, size: 32, offset: 64)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !16, file: !17, line: 28, baseType: !21, size: 32, offset: 96)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !16, file: !17, line: 32, baseType: !10, size: 32, offset: 128)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !16, file: !17, line: 34, baseType: !26, size: 16, offset: 160)
!26 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !16, file: !17, line: 35, baseType: !26, size: 16, offset: 176)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !16, file: !17, line: 36, baseType: !29, size: 128, offset: 192)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !30, line: 53, baseType: !31)
!30 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "4b8899127613e00869e96fcefd314d61")
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !30, line: 49, size: 128, elements: !32)
!32 = !{!33, !35}
!33 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !31, file: !30, line: 51, baseType: !34, size: 64)
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !31, file: !30, line: 52, baseType: !34, size: 64, offset: 64)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !13, file: !12, line: 70, baseType: !37, size: 320)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 320, elements: !39)
!38 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!39 = !{!40}
!40 = !DISubrange(count: 40)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !13, file: !12, line: 71, baseType: !42, size: 64)
!42 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!43 = !{i32 7, !"Dwarf Version", i32 5}
!44 = !{i32 2, !"Debug Info Version", i32 3}
!45 = !{i32 1, !"wchar_size", i32 4}
!46 = !{i32 7, !"PIC Level", i32 2}
!47 = !{i32 7, !"PIE Level", i32 2}
!48 = !{i32 7, !"uwtable", i32 1}
!49 = !{i32 7, !"frame-pointer", i32 2}
!50 = !{!"Ubuntu clang version 14.0.6"}
!51 = distinct !DISubprogram(name: "run", scope: !9, file: !9, line: 13, type: !52, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!52 = !DISubroutineType(types: !53)
!53 = !{!5, !5}
!54 = !{}
!55 = !DILocalVariable(name: "unused", arg: 1, scope: !51, file: !9, line: 13, type: !5)
!56 = !DILocation(line: 0, scope: !51)
!57 = !DILocation(line: 15, column: 5, scope: !51)
!58 = !DILocation(line: 16, column: 8, scope: !51)
!59 = !DILocation(line: 17, column: 5, scope: !51)
!60 = !DILocation(line: 18, column: 5, scope: !51)
!61 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 21, type: !62, scopeLine: 22, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!62 = !DISubroutineType(types: !63)
!63 = !{!10}
!64 = !DILocalVariable(name: "t", scope: !61, file: !9, line: 23, type: !65)
!65 = !DICompositeType(tag: DW_TAG_array_type, baseType: !66, size: 192, elements: !68)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !12, line: 27, baseType: !67)
!67 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!68 = !{!69}
!69 = !DISubrange(count: 3)
!70 = !DILocation(line: 23, column: 15, scope: !61)
!71 = !DILocation(line: 25, column: 5, scope: !61)
!72 = !DILocalVariable(name: "i", scope: !73, file: !9, line: 27, type: !10)
!73 = distinct !DILexicalBlock(scope: !61, file: !9, line: 27, column: 5)
!74 = !DILocation(line: 0, scope: !73)
!75 = !DILocation(line: 28, column: 25, scope: !76)
!76 = distinct !DILexicalBlock(scope: !73, file: !9, line: 27, column: 5)
!77 = !DILocation(line: 28, column: 9, scope: !76)
!78 = !DILocalVariable(name: "i", scope: !79, file: !9, line: 30, type: !10)
!79 = distinct !DILexicalBlock(scope: !61, file: !9, line: 30, column: 5)
!80 = !DILocation(line: 0, scope: !79)
!81 = !DILocation(line: 31, column: 22, scope: !82)
!82 = distinct !DILexicalBlock(scope: !79, file: !9, line: 30, column: 5)
!83 = !DILocation(line: 31, column: 9, scope: !82)
!84 = !DILocation(line: 33, column: 5, scope: !85)
!85 = distinct !DILexicalBlock(scope: !86, file: !9, line: 33, column: 5)
!86 = distinct !DILexicalBlock(scope: !61, file: !9, line: 33, column: 5)
!87 = !DILocation(line: 33, column: 5, scope: !86)
!88 = !DILocation(line: 35, column: 5, scope: !61)
