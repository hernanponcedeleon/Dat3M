; ModuleID = '/home/ponce/git/Dat3M/benchmarks/locks/spinlock.c'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/spinlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.spinlock_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4, !dbg !0
@lock = dso_local global %struct.spinlock_s zeroinitializer, align 4, !dbg !25
@shared = dso_local global i32 0, align 4, !dbg !21
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [50 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/spinlock.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !42 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !46, metadata !DIExpression()), !dbg !47
  call void @llvm.dbg.declare(metadata i64* %3, metadata !48, metadata !DIExpression()), !dbg !49
  %5 = load i8*, i8** %2, align 8, !dbg !50
  %6 = ptrtoint i8* %5 to i64, !dbg !51
  store i64 %6, i64* %3, align 8, !dbg !49
  call void @spinlock_acquire(%struct.spinlock_s* noundef @lock), !dbg !52
  %7 = load i64, i64* %3, align 8, !dbg !53
  %8 = trunc i64 %7 to i32, !dbg !53
  store i32 %8, i32* @shared, align 4, !dbg !54
  call void @llvm.dbg.declare(metadata i32* %4, metadata !55, metadata !DIExpression()), !dbg !56
  %9 = load i32, i32* @shared, align 4, !dbg !57
  store i32 %9, i32* %4, align 4, !dbg !56
  %10 = load i32, i32* %4, align 4, !dbg !58
  %11 = sext i32 %10 to i64, !dbg !58
  %12 = load i64, i64* %3, align 8, !dbg !58
  %13 = icmp eq i64 %11, %12, !dbg !58
  br i1 %13, label %14, label %15, !dbg !61

14:                                               ; preds = %1
  br label %16, !dbg !61

15:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #5, !dbg !58
  unreachable, !dbg !58

16:                                               ; preds = %14
  %17 = load i32, i32* @sum, align 4, !dbg !62
  %18 = add nsw i32 %17, 1, !dbg !62
  store i32 %18, i32* @sum, align 4, !dbg !62
  call void @spinlock_release(%struct.spinlock_s* noundef @lock), !dbg !63
  ret i8* null, !dbg !64
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @spinlock_acquire(%struct.spinlock_s* noundef %0) #0 !dbg !65 {
  %2 = alloca %struct.spinlock_s*, align 8
  store %struct.spinlock_s* %0, %struct.spinlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.spinlock_s** %2, metadata !69, metadata !DIExpression()), !dbg !70
  br label %3, !dbg !71

3:                                                ; preds = %5, %1
  %4 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8, !dbg !72
  call void @await_for_lock(%struct.spinlock_s* noundef %4), !dbg !74
  br label %5, !dbg !75

5:                                                ; preds = %3
  %6 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8, !dbg !76
  %7 = call i32 @try_get_lock(%struct.spinlock_s* noundef %6), !dbg !77
  %8 = icmp ne i32 %7, 0, !dbg !78
  %9 = xor i1 %8, true, !dbg !78
  br i1 %9, label %3, label %10, !dbg !75, !llvm.loop !79

10:                                               ; preds = %5
  ret void, !dbg !82
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal void @spinlock_release(%struct.spinlock_s* noundef %0) #0 !dbg !83 {
  %2 = alloca %struct.spinlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.spinlock_s* %0, %struct.spinlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.spinlock_s** %2, metadata !84, metadata !DIExpression()), !dbg !85
  %4 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8, !dbg !86
  %5 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %4, i32 0, i32 0, !dbg !87
  store i32 0, i32* %3, align 4, !dbg !88
  %6 = load i32, i32* %3, align 4, !dbg !88
  store atomic i32 %6, i32* %5 release, align 4, !dbg !88
  ret void, !dbg !89
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !90 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i64]* %2, metadata !93, metadata !DIExpression()), !dbg !100
  call void @spinlock_init(%struct.spinlock_s* noundef @lock), !dbg !101
  call void @llvm.dbg.declare(metadata i32* %3, metadata !102, metadata !DIExpression()), !dbg !104
  store i32 0, i32* %3, align 4, !dbg !104
  br label %5, !dbg !105

5:                                                ; preds = %16, %0
  %6 = load i32, i32* %3, align 4, !dbg !106
  %7 = icmp slt i32 %6, 3, !dbg !108
  br i1 %7, label %8, label %19, !dbg !109

8:                                                ; preds = %5
  %9 = load i32, i32* %3, align 4, !dbg !110
  %10 = sext i32 %9 to i64, !dbg !111
  %11 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %10, !dbg !111
  %12 = load i32, i32* %3, align 4, !dbg !112
  %13 = sext i32 %12 to i64, !dbg !113
  %14 = inttoptr i64 %13 to i8*, !dbg !113
  %15 = call i32 @pthread_create(i64* noundef %11, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef %14) #6, !dbg !114
  br label %16, !dbg !114

16:                                               ; preds = %8
  %17 = load i32, i32* %3, align 4, !dbg !115
  %18 = add nsw i32 %17, 1, !dbg !115
  store i32 %18, i32* %3, align 4, !dbg !115
  br label %5, !dbg !116, !llvm.loop !117

19:                                               ; preds = %5
  call void @llvm.dbg.declare(metadata i32* %4, metadata !119, metadata !DIExpression()), !dbg !121
  store i32 0, i32* %4, align 4, !dbg !121
  br label %20, !dbg !122

20:                                               ; preds = %29, %19
  %21 = load i32, i32* %4, align 4, !dbg !123
  %22 = icmp slt i32 %21, 3, !dbg !125
  br i1 %22, label %23, label %32, !dbg !126

23:                                               ; preds = %20
  %24 = load i32, i32* %4, align 4, !dbg !127
  %25 = sext i32 %24 to i64, !dbg !128
  %26 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %25, !dbg !128
  %27 = load i64, i64* %26, align 8, !dbg !128
  %28 = call i32 @pthread_join(i64 noundef %27, i8** noundef null), !dbg !129
  br label %29, !dbg !129

29:                                               ; preds = %23
  %30 = load i32, i32* %4, align 4, !dbg !130
  %31 = add nsw i32 %30, 1, !dbg !130
  store i32 %31, i32* %4, align 4, !dbg !130
  br label %20, !dbg !131, !llvm.loop !132

32:                                               ; preds = %20
  %33 = load i32, i32* @sum, align 4, !dbg !134
  %34 = icmp eq i32 %33, 3, !dbg !134
  br i1 %34, label %35, label %36, !dbg !137

35:                                               ; preds = %32
  br label %37, !dbg !137

36:                                               ; preds = %32
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !134
  unreachable, !dbg !134

37:                                               ; preds = %35
  ret i32 0, !dbg !138
}

; Function Attrs: noinline nounwind uwtable
define internal void @spinlock_init(%struct.spinlock_s* noundef %0) #0 !dbg !139 {
  %2 = alloca %struct.spinlock_s*, align 8
  store %struct.spinlock_s* %0, %struct.spinlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.spinlock_s** %2, metadata !140, metadata !DIExpression()), !dbg !141
  %3 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8, !dbg !142
  %4 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %3, i32 0, i32 0, !dbg !143
  store i32 0, i32* %4, align 4, !dbg !144
  ret void, !dbg !145
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @await_for_lock(%struct.spinlock_s* noundef %0) #0 !dbg !146 {
  %2 = alloca %struct.spinlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.spinlock_s* %0, %struct.spinlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.spinlock_s** %2, metadata !147, metadata !DIExpression()), !dbg !148
  br label %4, !dbg !149

4:                                                ; preds = %10, %1
  %5 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8, !dbg !150
  %6 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %5, i32 0, i32 0, !dbg !151
  %7 = load atomic i32, i32* %6 monotonic, align 4, !dbg !152
  store i32 %7, i32* %3, align 4, !dbg !152
  %8 = load i32, i32* %3, align 4, !dbg !152
  %9 = icmp ne i32 %8, 0, !dbg !153
  br i1 %9, label %10, label %11, !dbg !149

10:                                               ; preds = %4
  br label %4, !dbg !149, !llvm.loop !154

11:                                               ; preds = %4
  ret void, !dbg !156
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @try_get_lock(%struct.spinlock_s* noundef %0) #0 !dbg !157 {
  %2 = alloca %struct.spinlock_s*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store %struct.spinlock_s* %0, %struct.spinlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.spinlock_s** %2, metadata !160, metadata !DIExpression()), !dbg !161
  call void @llvm.dbg.declare(metadata i32* %3, metadata !162, metadata !DIExpression()), !dbg !163
  store i32 0, i32* %3, align 4, !dbg !163
  %6 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8, !dbg !164
  %7 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %6, i32 0, i32 0, !dbg !165
  store i32 1, i32* %4, align 4, !dbg !166
  %8 = load i32, i32* %3, align 4, !dbg !166
  %9 = load i32, i32* %4, align 4, !dbg !166
  %10 = cmpxchg i32* %7, i32 %8, i32 %9 acquire acquire, align 4, !dbg !166
  %11 = extractvalue { i32, i1 } %10, 0, !dbg !166
  %12 = extractvalue { i32, i1 } %10, 1, !dbg !166
  br i1 %12, label %14, label %13, !dbg !166

13:                                               ; preds = %1
  store i32 %11, i32* %3, align 4, !dbg !166
  br label %14, !dbg !166

14:                                               ; preds = %13, %1
  %15 = zext i1 %12 to i8, !dbg !166
  store i8 %15, i8* %5, align 1, !dbg !166
  %16 = load i8, i8* %5, align 1, !dbg !166
  %17 = trunc i8 %16 to i1, !dbg !166
  %18 = zext i1 %17 to i32, !dbg !166
  ret i32 %18, !dbg !167
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!34, !35, !36, !37, !38, !39, !40}
!llvm.ident = !{!41}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !23, line: 11, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !20, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/spinlock.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "ffa77402b1b5b5f477e9ff7f4e14b40d")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 56, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "de5d66a1ef2f5448cc1919ff39db92bc")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16, !19}
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !17, line: 87, baseType: !18)
!17 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!18 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!20 = !{!0, !21, !25}
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "shared", scope: !2, file: !23, line: 9, type: !24, isLocal: false, isDefinition: true)
!23 = !DIFile(filename: "benchmarks/locks/spinlock.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "ffa77402b1b5b5f477e9ff7f4e14b40d")
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !23, line: 10, type: !27, isLocal: false, isDefinition: true)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "spinlock_t", file: !28, line: 18, baseType: !29)
!28 = !DIFile(filename: "benchmarks/locks/spinlock.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "6a0cf149af91d1c9faaa85e0d115268c")
!29 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "spinlock_s", file: !28, line: 14, size: 32, elements: !30)
!30 = !{!31}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !29, file: !28, line: 15, baseType: !32, size: 32)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !33)
!33 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !24)
!34 = !{i32 7, !"Dwarf Version", i32 5}
!35 = !{i32 2, !"Debug Info Version", i32 3}
!36 = !{i32 1, !"wchar_size", i32 4}
!37 = !{i32 7, !"PIC Level", i32 2}
!38 = !{i32 7, !"PIE Level", i32 2}
!39 = !{i32 7, !"uwtable", i32 1}
!40 = !{i32 7, !"frame-pointer", i32 2}
!41 = !{!"Ubuntu clang version 14.0.6"}
!42 = distinct !DISubprogram(name: "thread_n", scope: !23, file: !23, line: 13, type: !43, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!43 = !DISubroutineType(types: !44)
!44 = !{!19, !19}
!45 = !{}
!46 = !DILocalVariable(name: "arg", arg: 1, scope: !42, file: !23, line: 13, type: !19)
!47 = !DILocation(line: 13, column: 22, scope: !42)
!48 = !DILocalVariable(name: "index", scope: !42, file: !23, line: 15, type: !16)
!49 = !DILocation(line: 15, column: 14, scope: !42)
!50 = !DILocation(line: 15, column: 34, scope: !42)
!51 = !DILocation(line: 15, column: 23, scope: !42)
!52 = !DILocation(line: 17, column: 5, scope: !42)
!53 = !DILocation(line: 18, column: 14, scope: !42)
!54 = !DILocation(line: 18, column: 12, scope: !42)
!55 = !DILocalVariable(name: "r", scope: !42, file: !23, line: 19, type: !24)
!56 = !DILocation(line: 19, column: 9, scope: !42)
!57 = !DILocation(line: 19, column: 13, scope: !42)
!58 = !DILocation(line: 20, column: 5, scope: !59)
!59 = distinct !DILexicalBlock(scope: !60, file: !23, line: 20, column: 5)
!60 = distinct !DILexicalBlock(scope: !42, file: !23, line: 20, column: 5)
!61 = !DILocation(line: 20, column: 5, scope: !60)
!62 = !DILocation(line: 21, column: 8, scope: !42)
!63 = !DILocation(line: 22, column: 5, scope: !42)
!64 = !DILocation(line: 23, column: 5, scope: !42)
!65 = distinct !DISubprogram(name: "spinlock_acquire", scope: !28, file: !28, line: 40, type: !66, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!66 = !DISubroutineType(types: !67)
!67 = !{null, !68}
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!69 = !DILocalVariable(name: "l", arg: 1, scope: !65, file: !28, line: 40, type: !68)
!70 = !DILocation(line: 40, column: 56, scope: !65)
!71 = !DILocation(line: 42, column: 5, scope: !65)
!72 = !DILocation(line: 43, column: 24, scope: !73)
!73 = distinct !DILexicalBlock(scope: !65, file: !28, line: 42, column: 8)
!74 = !DILocation(line: 43, column: 9, scope: !73)
!75 = !DILocation(line: 44, column: 5, scope: !73)
!76 = !DILocation(line: 44, column: 27, scope: !65)
!77 = !DILocation(line: 44, column: 14, scope: !65)
!78 = !DILocation(line: 44, column: 13, scope: !65)
!79 = distinct !{!79, !71, !80, !81}
!80 = !DILocation(line: 44, column: 29, scope: !65)
!81 = !{!"llvm.loop.mustprogress"}
!82 = !DILocation(line: 45, column: 5, scope: !65)
!83 = distinct !DISubprogram(name: "spinlock_release", scope: !28, file: !28, line: 53, type: !66, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!84 = !DILocalVariable(name: "l", arg: 1, scope: !83, file: !28, line: 53, type: !68)
!85 = !DILocation(line: 53, column: 56, scope: !83)
!86 = !DILocation(line: 55, column: 28, scope: !83)
!87 = !DILocation(line: 55, column: 31, scope: !83)
!88 = !DILocation(line: 55, column: 5, scope: !83)
!89 = !DILocation(line: 56, column: 1, scope: !83)
!90 = distinct !DISubprogram(name: "main", scope: !23, file: !23, line: 26, type: !91, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!91 = !DISubroutineType(types: !92)
!92 = !{!24}
!93 = !DILocalVariable(name: "t", scope: !90, file: !23, line: 28, type: !94)
!94 = !DICompositeType(tag: DW_TAG_array_type, baseType: !95, size: 192, elements: !98)
!95 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !96, line: 27, baseType: !97)
!96 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!97 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!98 = !{!99}
!99 = !DISubrange(count: 3)
!100 = !DILocation(line: 28, column: 15, scope: !90)
!101 = !DILocation(line: 30, column: 5, scope: !90)
!102 = !DILocalVariable(name: "i", scope: !103, file: !23, line: 32, type: !24)
!103 = distinct !DILexicalBlock(scope: !90, file: !23, line: 32, column: 5)
!104 = !DILocation(line: 32, column: 14, scope: !103)
!105 = !DILocation(line: 32, column: 10, scope: !103)
!106 = !DILocation(line: 32, column: 21, scope: !107)
!107 = distinct !DILexicalBlock(scope: !103, file: !23, line: 32, column: 5)
!108 = !DILocation(line: 32, column: 23, scope: !107)
!109 = !DILocation(line: 32, column: 5, scope: !103)
!110 = !DILocation(line: 33, column: 27, scope: !107)
!111 = !DILocation(line: 33, column: 25, scope: !107)
!112 = !DILocation(line: 33, column: 52, scope: !107)
!113 = !DILocation(line: 33, column: 44, scope: !107)
!114 = !DILocation(line: 33, column: 9, scope: !107)
!115 = !DILocation(line: 32, column: 36, scope: !107)
!116 = !DILocation(line: 32, column: 5, scope: !107)
!117 = distinct !{!117, !109, !118, !81}
!118 = !DILocation(line: 33, column: 53, scope: !103)
!119 = !DILocalVariable(name: "i", scope: !120, file: !23, line: 35, type: !24)
!120 = distinct !DILexicalBlock(scope: !90, file: !23, line: 35, column: 5)
!121 = !DILocation(line: 35, column: 14, scope: !120)
!122 = !DILocation(line: 35, column: 10, scope: !120)
!123 = !DILocation(line: 35, column: 21, scope: !124)
!124 = distinct !DILexicalBlock(scope: !120, file: !23, line: 35, column: 5)
!125 = !DILocation(line: 35, column: 23, scope: !124)
!126 = !DILocation(line: 35, column: 5, scope: !120)
!127 = !DILocation(line: 36, column: 24, scope: !124)
!128 = !DILocation(line: 36, column: 22, scope: !124)
!129 = !DILocation(line: 36, column: 9, scope: !124)
!130 = !DILocation(line: 35, column: 36, scope: !124)
!131 = !DILocation(line: 35, column: 5, scope: !124)
!132 = distinct !{!132, !126, !133, !81}
!133 = !DILocation(line: 36, column: 29, scope: !120)
!134 = !DILocation(line: 38, column: 5, scope: !135)
!135 = distinct !DILexicalBlock(scope: !136, file: !23, line: 38, column: 5)
!136 = distinct !DILexicalBlock(scope: !90, file: !23, line: 38, column: 5)
!137 = !DILocation(line: 38, column: 5, scope: !136)
!138 = !DILocation(line: 40, column: 5, scope: !90)
!139 = distinct !DISubprogram(name: "spinlock_init", scope: !28, file: !28, line: 20, type: !66, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!140 = !DILocalVariable(name: "l", arg: 1, scope: !139, file: !28, line: 20, type: !68)
!141 = !DILocation(line: 20, column: 53, scope: !139)
!142 = !DILocation(line: 22, column: 18, scope: !139)
!143 = !DILocation(line: 22, column: 21, scope: !139)
!144 = !DILocation(line: 22, column: 5, scope: !139)
!145 = !DILocation(line: 23, column: 1, scope: !139)
!146 = distinct !DISubprogram(name: "await_for_lock", scope: !28, file: !28, line: 25, type: !66, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!147 = !DILocalVariable(name: "l", arg: 1, scope: !146, file: !28, line: 25, type: !68)
!148 = !DILocation(line: 25, column: 54, scope: !146)
!149 = !DILocation(line: 27, column: 5, scope: !146)
!150 = !DILocation(line: 27, column: 34, scope: !146)
!151 = !DILocation(line: 27, column: 37, scope: !146)
!152 = !DILocation(line: 27, column: 12, scope: !146)
!153 = !DILocation(line: 27, column: 65, scope: !146)
!154 = distinct !{!154, !149, !155, !81}
!155 = !DILocation(line: 28, column: 9, scope: !146)
!156 = !DILocation(line: 29, column: 5, scope: !146)
!157 = distinct !DISubprogram(name: "try_get_lock", scope: !28, file: !28, line: 32, type: !158, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!158 = !DISubroutineType(types: !159)
!159 = !{!24, !68}
!160 = !DILocalVariable(name: "l", arg: 1, scope: !157, file: !28, line: 32, type: !68)
!161 = !DILocation(line: 32, column: 51, scope: !157)
!162 = !DILocalVariable(name: "val", scope: !157, file: !28, line: 34, type: !24)
!163 = !DILocation(line: 34, column: 9, scope: !157)
!164 = !DILocation(line: 35, column: 53, scope: !157)
!165 = !DILocation(line: 35, column: 56, scope: !157)
!166 = !DILocation(line: 35, column: 12, scope: !157)
!167 = !DILocation(line: 35, column: 5, scope: !157)
