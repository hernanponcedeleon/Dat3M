; ModuleID = '/home/ponce/git/Dat3M/output/pthread_mutex.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/pthread_mutex.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !0
@x = dso_local global i32 0, align 4, !dbg !8
@.str = private unnamed_addr constant [7 x i8] c"x == 2\00", align 1
@.str.1 = private unnamed_addr constant [55 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/pthread_mutex.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread(i8* %0) #0 !dbg !48 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !51, metadata !DIExpression()), !dbg !52
  %3 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* @mutex) #5, !dbg !53
  %4 = load i32, i32* @x, align 4, !dbg !54
  %5 = add nsw i32 %4, 1, !dbg !54
  store i32 %5, i32* @x, align 4, !dbg !54
  %6 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* @mutex) #5, !dbg !55
  ret i8* null, !dbg !56
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare dso_local i32 @pthread_mutex_lock(%union.pthread_mutex_t*) #2

; Function Attrs: nounwind
declare dso_local i32 @pthread_mutex_unlock(%union.pthread_mutex_t*) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !57 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i64* %2, metadata !60, metadata !DIExpression()), !dbg !63
  call void @llvm.dbg.declare(metadata i64* %3, metadata !64, metadata !DIExpression()), !dbg !65
  %4 = call i32 @pthread_create(i64* %2, %union.pthread_attr_t* null, i8* (i8*)* @thread, i8* null) #5, !dbg !66
  %5 = call i32 @pthread_create(i64* %3, %union.pthread_attr_t* null, i8* (i8*)* @thread, i8* null) #5, !dbg !67
  %6 = load i64, i64* %2, align 8, !dbg !68
  %7 = call i32 @pthread_join(i64 %6, i8** null), !dbg !69
  %8 = load i64, i64* %3, align 8, !dbg !70
  %9 = call i32 @pthread_join(i64 %8, i8** null), !dbg !71
  %10 = load i32, i32* @x, align 4, !dbg !72
  %11 = icmp eq i32 %10, 2, !dbg !72
  br i1 %11, label %12, label %13, !dbg !75

12:                                               ; preds = %0
  br label %14, !dbg !75

13:                                               ; preds = %0
  call void @__assert_fail(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([55 x i8], [55 x i8]* @.str.1, i64 0, i64 0), i32 25, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !72
  unreachable, !dbg !72

14:                                               ; preds = %12
  ret i32 0, !dbg !76
}

; Function Attrs: nounwind
declare dso_local i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*) #2

declare dso_local i32 @pthread_join(i64, i8**) #3

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #4

attributes #0 = { noinline nounwind uwtable "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn nounwind "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!44, !45, !46}
!llvm.ident = !{!47}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !10, line: 4, type: !12, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 12.0.0-3ubuntu1~20.04.5", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !7, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/pthread_mutex.c", directory: "/home/ponce/git/Dat3M")
!4 = !{}
!5 = !{!6}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !{!0, !8}
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !10, line: 5, type: !11, isLocal: false, isDefinition: true)
!10 = !DIFile(filename: "benchmarks/locks/pthread_mutex.c", directory: "/home/ponce/git/Dat3M")
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !13, line: 72, baseType: !14)
!13 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "")
!14 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !13, line: 67, size: 320, elements: !15)
!15 = !{!16, !37, !42}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !14, file: !13, line: 69, baseType: !17, size: 320)
!17 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !18, line: 22, size: 320, elements: !19)
!18 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "")
!19 = !{!20, !21, !23, !24, !25, !26, !28, !29}
!20 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !17, file: !18, line: 24, baseType: !11, size: 32)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !17, file: !18, line: 25, baseType: !22, size: 32, offset: 32)
!22 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !17, file: !18, line: 26, baseType: !11, size: 32, offset: 64)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !17, file: !18, line: 28, baseType: !22, size: 32, offset: 96)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !17, file: !18, line: 32, baseType: !11, size: 32, offset: 128)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !17, file: !18, line: 34, baseType: !27, size: 16, offset: 160)
!27 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !17, file: !18, line: 35, baseType: !27, size: 16, offset: 176)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !17, file: !18, line: 36, baseType: !30, size: 128, offset: 192)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !31, line: 53, baseType: !32)
!31 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "")
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !31, line: 49, size: 128, elements: !33)
!33 = !{!34, !36}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !32, file: !31, line: 51, baseType: !35, size: 64)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !32, file: !31, line: 52, baseType: !35, size: 64, offset: 64)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !14, file: !13, line: 70, baseType: !38, size: 320)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 320, elements: !40)
!39 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!40 = !{!41}
!41 = !DISubrange(count: 40)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !14, file: !13, line: 71, baseType: !43, size: 64)
!43 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!44 = !{i32 7, !"Dwarf Version", i32 4}
!45 = !{i32 2, !"Debug Info Version", i32 3}
!46 = !{i32 1, !"wchar_size", i32 4}
!47 = !{!"Ubuntu clang version 12.0.0-3ubuntu1~20.04.5"}
!48 = distinct !DISubprogram(name: "thread", scope: !10, file: !10, line: 7, type: !49, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!49 = !DISubroutineType(types: !50)
!50 = !{!6, !6}
!51 = !DILocalVariable(name: "unused", arg: 1, scope: !48, file: !10, line: 7, type: !6)
!52 = !DILocation(line: 7, column: 20, scope: !48)
!53 = !DILocation(line: 9, column: 5, scope: !48)
!54 = !DILocation(line: 10, column: 6, scope: !48)
!55 = !DILocation(line: 11, column: 5, scope: !48)
!56 = !DILocation(line: 12, column: 5, scope: !48)
!57 = distinct !DISubprogram(name: "main", scope: !10, file: !10, line: 15, type: !58, scopeLine: 16, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!58 = !DISubroutineType(types: !59)
!59 = !{!11}
!60 = !DILocalVariable(name: "t1", scope: !57, file: !10, line: 17, type: !61)
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !13, line: 27, baseType: !62)
!62 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!63 = !DILocation(line: 17, column: 15, scope: !57)
!64 = !DILocalVariable(name: "t2", scope: !57, file: !10, line: 17, type: !61)
!65 = !DILocation(line: 17, column: 19, scope: !57)
!66 = !DILocation(line: 19, column: 5, scope: !57)
!67 = !DILocation(line: 20, column: 5, scope: !57)
!68 = !DILocation(line: 22, column: 18, scope: !57)
!69 = !DILocation(line: 22, column: 5, scope: !57)
!70 = !DILocation(line: 23, column: 18, scope: !57)
!71 = !DILocation(line: 23, column: 5, scope: !57)
!72 = !DILocation(line: 25, column: 5, scope: !73)
!73 = distinct !DILexicalBlock(scope: !74, file: !10, line: 25, column: 5)
!74 = distinct !DILexicalBlock(scope: !57, file: !10, line: 25, column: 5)
!75 = !DILocation(line: 25, column: 5, scope: !74)
!76 = !DILocation(line: 27, column: 5, scope: !57)
