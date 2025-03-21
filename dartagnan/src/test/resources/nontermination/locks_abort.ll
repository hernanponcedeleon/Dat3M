; ModuleID = '/home/ponce/git/Dat3M/output/locks_abort.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/nontermination/locks_abort.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@m = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !0

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread(i8* %0) #0 !dbg !46 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !49, metadata !DIExpression()), !dbg !50
  %3 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* @m) #5, !dbg !51
  %4 = call zeroext i1 @__VERIFIER_nondet_bool(), !dbg !52
  br i1 %4, label %5, label %6, !dbg !54

5:                                                ; preds = %1
  call void @abort() #6, !dbg !55
  unreachable, !dbg !55

6:                                                ; preds = %1
  %7 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* @m) #5, !dbg !57
  ret i8* null, !dbg !58
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare dso_local i32 @pthread_mutex_lock(%union.pthread_mutex_t*) #2

declare dso_local zeroext i1 @__VERIFIER_nondet_bool() #3

; Function Attrs: noreturn
declare dso_local void @abort() #4

; Function Attrs: nounwind
declare dso_local i32 @pthread_mutex_unlock(%union.pthread_mutex_t*) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !59 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i64* %2, metadata !62, metadata !DIExpression()), !dbg !65
  call void @llvm.dbg.declare(metadata i64* %3, metadata !66, metadata !DIExpression()), !dbg !67
  %4 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* @m, %union.pthread_mutexattr_t* null) #5, !dbg !68
  %5 = call i32 @pthread_create(i64* %2, %union.pthread_attr_t* null, i8* (i8*)* @thread, i8* null) #5, !dbg !69
  %6 = call i32 @pthread_create(i64* %3, %union.pthread_attr_t* null, i8* (i8*)* @thread, i8* null) #5, !dbg !70
  ret i32 0, !dbg !71
}

; Function Attrs: nounwind
declare dso_local i32 @pthread_mutex_init(%union.pthread_mutex_t*, %union.pthread_mutexattr_t*) #2

; Function Attrs: nounwind
declare dso_local i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*) #2

attributes #0 = { noinline nounwind uwtable "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }
attributes #6 = { noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!42, !43, !44}
!llvm.ident = !{!45}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "m", scope: !2, file: !8, line: 5, type: !9, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 12.0.0-3ubuntu1~20.04.5", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !7, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/nontermination/locks_abort.c", directory: "/home/ponce/git/Dat3M")
!4 = !{}
!5 = !{!6}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !{!0}
!8 = !DIFile(filename: "benchmarks/nontermination/locks_abort.c", directory: "/home/ponce/git/Dat3M")
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !10, line: 72, baseType: !11)
!10 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "")
!11 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !10, line: 67, size: 320, elements: !12)
!12 = !{!13, !35, !40}
!13 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !11, file: !10, line: 69, baseType: !14, size: 320)
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !15, line: 22, size: 320, elements: !16)
!15 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "")
!16 = !{!17, !19, !21, !22, !23, !24, !26, !27}
!17 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !14, file: !15, line: 24, baseType: !18, size: 32)
!18 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !14, file: !15, line: 25, baseType: !20, size: 32, offset: 32)
!20 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !14, file: !15, line: 26, baseType: !18, size: 32, offset: 64)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !14, file: !15, line: 28, baseType: !20, size: 32, offset: 96)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !14, file: !15, line: 32, baseType: !18, size: 32, offset: 128)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !14, file: !15, line: 34, baseType: !25, size: 16, offset: 160)
!25 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !14, file: !15, line: 35, baseType: !25, size: 16, offset: 176)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !14, file: !15, line: 36, baseType: !28, size: 128, offset: 192)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !29, line: 53, baseType: !30)
!29 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "")
!30 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !29, line: 49, size: 128, elements: !31)
!31 = !{!32, !34}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !30, file: !29, line: 51, baseType: !33, size: 64)
!33 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !30, file: !29, line: 52, baseType: !33, size: 64, offset: 64)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !11, file: !10, line: 70, baseType: !36, size: 320)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !37, size: 320, elements: !38)
!37 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!38 = !{!39}
!39 = !DISubrange(count: 40)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !11, file: !10, line: 71, baseType: !41, size: 64)
!41 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!42 = !{i32 7, !"Dwarf Version", i32 4}
!43 = !{i32 2, !"Debug Info Version", i32 3}
!44 = !{i32 1, !"wchar_size", i32 4}
!45 = !{!"Ubuntu clang version 12.0.0-3ubuntu1~20.04.5"}
!46 = distinct !DISubprogram(name: "thread", scope: !8, file: !8, line: 7, type: !47, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!47 = !DISubroutineType(types: !48)
!48 = !{!6, !6}
!49 = !DILocalVariable(name: "unused", arg: 1, scope: !46, file: !8, line: 7, type: !6)
!50 = !DILocation(line: 7, column: 20, scope: !46)
!51 = !DILocation(line: 9, column: 5, scope: !46)
!52 = !DILocation(line: 10, column: 8, scope: !53)
!53 = distinct !DILexicalBlock(scope: !46, file: !8, line: 10, column: 8)
!54 = !DILocation(line: 10, column: 8, scope: !46)
!55 = !DILocation(line: 11, column: 9, scope: !56)
!56 = distinct !DILexicalBlock(scope: !53, file: !8, line: 10, column: 34)
!57 = !DILocation(line: 13, column: 5, scope: !46)
!58 = !DILocation(line: 14, column: 5, scope: !46)
!59 = distinct !DISubprogram(name: "main", scope: !8, file: !8, line: 17, type: !60, scopeLine: 18, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!60 = !DISubroutineType(types: !61)
!61 = !{!18}
!62 = !DILocalVariable(name: "t1", scope: !59, file: !8, line: 19, type: !63)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !10, line: 27, baseType: !64)
!64 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!65 = !DILocation(line: 19, column: 15, scope: !59)
!66 = !DILocalVariable(name: "t2", scope: !59, file: !8, line: 19, type: !63)
!67 = !DILocation(line: 19, column: 19, scope: !59)
!68 = !DILocation(line: 20, column: 5, scope: !59)
!69 = !DILocation(line: 21, column: 5, scope: !59)
!70 = !DILocation(line: 22, column: 5, scope: !59)
!71 = !DILocation(line: 24, column: 5, scope: !59)
