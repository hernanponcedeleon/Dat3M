; ModuleID = '/home/ponce/git/Dat3M/output/singleton.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread/singleton.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [12 x i8] c"singleton.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@v = dso_local global i8* null, align 8, !dbg !0

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !16 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i64 0, i64 0), i32 noundef 3, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #6, !dbg !20
  unreachable, !dbg !20
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_assert(i32 noundef %0) #0 !dbg !23 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !27, metadata !DIExpression()), !dbg !28
  %.not = icmp eq i32 %0, 0, !dbg !29
  br i1 %.not, label %2, label %3, !dbg !31

2:                                                ; preds = %1
  call void @llvm.dbg.label(metadata !32), !dbg !34
  call void @reach_error(), !dbg !35
  call void @abort() #6, !dbg !37
  unreachable, !dbg !37

3:                                                ; preds = %1
  ret void, !dbg !38
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #2

; Function Attrs: nocallback noreturn nounwind
declare void @abort() #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread1(i8* noundef %0) #0 !dbg !39 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !43, metadata !DIExpression()), !dbg !44
  %2 = call noalias dereferenceable_or_null(1) i8* @malloc(i32 noundef 1) #7, !dbg !45
  store i8* %2, i8** @v, align 8, !dbg !46
  ret i8* null, !dbg !47
}

; Function Attrs: nocallback nounwind allocsize(0)
declare noalias i8* @malloc(i32 noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread2(i8* noundef %0) #0 !dbg !48 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !49, metadata !DIExpression()), !dbg !50
  call void @__VERIFIER_atomic_begin() #8, !dbg !51
  %2 = load i8*, i8** @v, align 8, !dbg !52
  store i8 88, i8* %2, align 1, !dbg !53
  call void @__VERIFIER_atomic_end() #8, !dbg !54
  ret i8* null, !dbg !55
}

declare void @__VERIFIER_atomic_begin() #4

declare void @__VERIFIER_atomic_end() #4

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread3(i8* noundef %0) #0 !dbg !56 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !57, metadata !DIExpression()), !dbg !58
  call void @__VERIFIER_atomic_begin() #8, !dbg !59
  %2 = load i8*, i8** @v, align 8, !dbg !60
  store i8 89, i8* %2, align 1, !dbg !61
  call void @__VERIFIER_atomic_end() #8, !dbg !62
  ret i8* null, !dbg !63
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread0(i8* noundef %0) #0 !dbg !64 {
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i8* %0, metadata !65, metadata !DIExpression()), !dbg !66
  call void @llvm.dbg.value(metadata i64* %2, metadata !67, metadata !DIExpression(DW_OP_deref)), !dbg !66
  %7 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread1, i8* noundef null) #8, !dbg !70
  %8 = load i64, i64* %2, align 8, !dbg !71
  call void @llvm.dbg.value(metadata i64 %8, metadata !67, metadata !DIExpression()), !dbg !66
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null) #8, !dbg !72
  call void @llvm.dbg.value(metadata i64* %3, metadata !73, metadata !DIExpression(DW_OP_deref)), !dbg !66
  %10 = call i32 @pthread_create(i64* noundef nonnull %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread2, i8* noundef null) #8, !dbg !74
  call void @llvm.dbg.value(metadata i64* %4, metadata !75, metadata !DIExpression(DW_OP_deref)), !dbg !66
  %11 = call i32 @pthread_create(i64* noundef nonnull %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread3, i8* noundef null) #8, !dbg !76
  call void @llvm.dbg.value(metadata i64* %5, metadata !77, metadata !DIExpression(DW_OP_deref)), !dbg !66
  %12 = call i32 @pthread_create(i64* noundef nonnull %5, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread2, i8* noundef null) #8, !dbg !78
  call void @llvm.dbg.value(metadata i64* %6, metadata !79, metadata !DIExpression(DW_OP_deref)), !dbg !66
  %13 = call i32 @pthread_create(i64* noundef nonnull %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread2, i8* noundef null) #8, !dbg !80
  %14 = load i64, i64* %3, align 8, !dbg !81
  call void @llvm.dbg.value(metadata i64 %14, metadata !73, metadata !DIExpression()), !dbg !66
  %15 = call i32 @pthread_join(i64 noundef %14, i8** noundef null) #8, !dbg !82
  %16 = load i64, i64* %4, align 8, !dbg !83
  call void @llvm.dbg.value(metadata i64 %16, metadata !75, metadata !DIExpression()), !dbg !66
  %17 = call i32 @pthread_join(i64 noundef %16, i8** noundef null) #8, !dbg !84
  %18 = load i64, i64* %5, align 8, !dbg !85
  call void @llvm.dbg.value(metadata i64 %18, metadata !77, metadata !DIExpression()), !dbg !66
  %19 = call i32 @pthread_join(i64 noundef %18, i8** noundef null) #8, !dbg !86
  %20 = load i64, i64* %6, align 8, !dbg !87
  call void @llvm.dbg.value(metadata i64 %20, metadata !79, metadata !DIExpression()), !dbg !66
  %21 = call i32 @pthread_join(i64 noundef %20, i8** noundef null) #8, !dbg !88
  ret i8* null, !dbg !89
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #5

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !90 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !93, metadata !DIExpression(DW_OP_deref)), !dbg !94
  %2 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread0, i8* noundef null) #8, !dbg !95
  %3 = load i64, i64* %1, align 8, !dbg !96
  call void @llvm.dbg.value(metadata i64 %3, metadata !93, metadata !DIExpression()), !dbg !94
  %4 = call i32 @pthread_join(i64 noundef %3, i8** noundef null) #8, !dbg !97
  %5 = load i8*, i8** @v, align 8, !dbg !98
  %6 = load i8, i8* %5, align 1, !dbg !98
  %7 = icmp eq i8 %6, 88, !dbg !99
  %8 = zext i1 %7 to i32, !dbg !99
  call void @__VERIFIER_assert(i32 noundef %8), !dbg !100
  ret i32 0, !dbg !101
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nocallback nounwind allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nocallback noreturn nounwind }
attributes #7 = { nocallback nounwind allocsize(0) }
attributes #8 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!8, !9, !10, !11, !12, !13, !14}
!llvm.ident = !{!15}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "v", scope: !2, file: !5, line: 1124, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread/singleton.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "030d31aeb732a8a77a9a40c46cd22337")
!4 = !{!0}
!5 = !DIFile(filename: "../sv-benchmarks/c/pthread/singleton.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "030d31aeb732a8a77a9a40c46cd22337")
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!8 = !{i32 7, !"Dwarf Version", i32 5}
!9 = !{i32 2, !"Debug Info Version", i32 3}
!10 = !{i32 1, !"wchar_size", i32 4}
!11 = !{i32 7, !"PIC Level", i32 2}
!12 = !{i32 7, !"PIE Level", i32 2}
!13 = !{i32 7, !"uwtable", i32 1}
!14 = !{i32 7, !"frame-pointer", i32 2}
!15 = !{!"Ubuntu clang version 14.0.6"}
!16 = distinct !DISubprogram(name: "reach_error", scope: !5, file: !5, line: 20, type: !17, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !19)
!17 = !DISubroutineType(types: !18)
!18 = !{null}
!19 = !{}
!20 = !DILocation(line: 20, column: 83, scope: !21)
!21 = distinct !DILexicalBlock(scope: !22, file: !5, line: 20, column: 73)
!22 = distinct !DILexicalBlock(scope: !16, file: !5, line: 20, column: 67)
!23 = distinct !DISubprogram(name: "__VERIFIER_assert", scope: !5, file: !5, line: 1123, type: !24, scopeLine: 1123, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !19)
!24 = !DISubroutineType(types: !25)
!25 = !{null, !26}
!26 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!27 = !DILocalVariable(name: "expression", arg: 1, scope: !23, file: !5, line: 1123, type: !26)
!28 = !DILocation(line: 0, scope: !23)
!29 = !DILocation(line: 1123, column: 47, scope: !30)
!30 = distinct !DILexicalBlock(scope: !23, file: !5, line: 1123, column: 46)
!31 = !DILocation(line: 1123, column: 46, scope: !23)
!32 = !DILabel(scope: !33, name: "ERROR", file: !5, line: 1123)
!33 = distinct !DILexicalBlock(scope: !30, file: !5, line: 1123, column: 59)
!34 = !DILocation(line: 1123, column: 61, scope: !33)
!35 = !DILocation(line: 1123, column: 69, scope: !36)
!36 = distinct !DILexicalBlock(scope: !33, file: !5, line: 1123, column: 68)
!37 = !DILocation(line: 1123, column: 83, scope: !36)
!38 = !DILocation(line: 1123, column: 95, scope: !23)
!39 = distinct !DISubprogram(name: "thread1", scope: !5, file: !5, line: 1125, type: !40, scopeLine: 1126, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !19)
!40 = !DISubroutineType(types: !41)
!41 = !{!42, !42}
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!43 = !DILocalVariable(name: "arg", arg: 1, scope: !39, file: !5, line: 1125, type: !42)
!44 = !DILocation(line: 0, scope: !39)
!45 = !DILocation(line: 1127, column: 7, scope: !39)
!46 = !DILocation(line: 1127, column: 5, scope: !39)
!47 = !DILocation(line: 1128, column: 3, scope: !39)
!48 = distinct !DISubprogram(name: "thread2", scope: !5, file: !5, line: 1130, type: !40, scopeLine: 1131, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !19)
!49 = !DILocalVariable(name: "arg", arg: 1, scope: !48, file: !5, line: 1130, type: !42)
!50 = !DILocation(line: 0, scope: !48)
!51 = !DILocation(line: 1132, column: 3, scope: !48)
!52 = !DILocation(line: 1133, column: 3, scope: !48)
!53 = !DILocation(line: 1133, column: 8, scope: !48)
!54 = !DILocation(line: 1134, column: 3, scope: !48)
!55 = !DILocation(line: 1135, column: 3, scope: !48)
!56 = distinct !DISubprogram(name: "thread3", scope: !5, file: !5, line: 1137, type: !40, scopeLine: 1138, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !19)
!57 = !DILocalVariable(name: "arg", arg: 1, scope: !56, file: !5, line: 1137, type: !42)
!58 = !DILocation(line: 0, scope: !56)
!59 = !DILocation(line: 1139, column: 3, scope: !56)
!60 = !DILocation(line: 1140, column: 3, scope: !56)
!61 = !DILocation(line: 1140, column: 8, scope: !56)
!62 = !DILocation(line: 1141, column: 3, scope: !56)
!63 = !DILocation(line: 1142, column: 3, scope: !56)
!64 = distinct !DISubprogram(name: "thread0", scope: !5, file: !5, line: 1144, type: !40, scopeLine: 1145, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !19)
!65 = !DILocalVariable(name: "arg", arg: 1, scope: !64, file: !5, line: 1144, type: !42)
!66 = !DILocation(line: 0, scope: !64)
!67 = !DILocalVariable(name: "t1", scope: !64, file: !5, line: 1146, type: !68)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !5, line: 314, baseType: !69)
!69 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!70 = !DILocation(line: 1147, column: 3, scope: !64)
!71 = !DILocation(line: 1148, column: 16, scope: !64)
!72 = !DILocation(line: 1148, column: 3, scope: !64)
!73 = !DILocalVariable(name: "t2", scope: !64, file: !5, line: 1146, type: !68)
!74 = !DILocation(line: 1149, column: 3, scope: !64)
!75 = !DILocalVariable(name: "t3", scope: !64, file: !5, line: 1146, type: !68)
!76 = !DILocation(line: 1150, column: 3, scope: !64)
!77 = !DILocalVariable(name: "t4", scope: !64, file: !5, line: 1146, type: !68)
!78 = !DILocation(line: 1151, column: 3, scope: !64)
!79 = !DILocalVariable(name: "t5", scope: !64, file: !5, line: 1146, type: !68)
!80 = !DILocation(line: 1152, column: 3, scope: !64)
!81 = !DILocation(line: 1153, column: 16, scope: !64)
!82 = !DILocation(line: 1153, column: 3, scope: !64)
!83 = !DILocation(line: 1154, column: 16, scope: !64)
!84 = !DILocation(line: 1154, column: 3, scope: !64)
!85 = !DILocation(line: 1155, column: 16, scope: !64)
!86 = !DILocation(line: 1155, column: 3, scope: !64)
!87 = !DILocation(line: 1156, column: 16, scope: !64)
!88 = !DILocation(line: 1156, column: 3, scope: !64)
!89 = !DILocation(line: 1157, column: 3, scope: !64)
!90 = distinct !DISubprogram(name: "main", scope: !5, file: !5, line: 1159, type: !91, scopeLine: 1160, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !19)
!91 = !DISubroutineType(types: !92)
!92 = !{!26}
!93 = !DILocalVariable(name: "t", scope: !90, file: !5, line: 1161, type: !68)
!94 = !DILocation(line: 0, scope: !90)
!95 = !DILocation(line: 1162, column: 3, scope: !90)
!96 = !DILocation(line: 1163, column: 16, scope: !90)
!97 = !DILocation(line: 1163, column: 3, scope: !90)
!98 = !DILocation(line: 1164, column: 21, scope: !90)
!99 = !DILocation(line: 1164, column: 26, scope: !90)
!100 = !DILocation(line: 1164, column: 3, scope: !90)
!101 = !DILocation(line: 1165, column: 3, scope: !90)
