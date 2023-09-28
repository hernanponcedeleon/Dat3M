; ModuleID = '/home/ponce/git/Dat3M/output/chase-lev.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lfds/chase-lev.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Deque = type { i32, i32, [10 x i32] }
%union.pthread_attr_t = type { i64, [48 x i8] }

@deq = dso_local global %struct.Deque zeroinitializer, align 4, !dbg !0
@.str = private unnamed_addr constant [14 x i8] c"data == count\00", align 1
@.str.1 = private unnamed_addr constant [50 x i8] c"/home/ponce/git/Dat3M/benchmarks/lfds/chase-lev.c\00", align 1
@__PRETTY_FUNCTION__.owner = private unnamed_addr constant [20 x i8] c"void *owner(void *)\00", align 1
@thiefs = dso_local global [4 x i64] zeroinitializer, align 16, !dbg !18
@.str.2 = private unnamed_addr constant [31 x i8] c"try_pop(&deq, NUM, &data) >= 0\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @try_push(%struct.Deque* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !47 {
  call void @llvm.dbg.value(metadata %struct.Deque* %0, metadata !52, metadata !DIExpression()), !dbg !53
  call void @llvm.dbg.value(metadata i32 %1, metadata !54, metadata !DIExpression()), !dbg !53
  call void @llvm.dbg.value(metadata i32 %2, metadata !55, metadata !DIExpression()), !dbg !53
  %4 = getelementptr inbounds %struct.Deque, %struct.Deque* %0, i32 0, i32 0, !dbg !56
  %5 = load atomic i32, i32* %4 monotonic, align 4, !dbg !57
  call void @llvm.dbg.value(metadata i32 %5, metadata !58, metadata !DIExpression()), !dbg !53
  %6 = getelementptr inbounds %struct.Deque, %struct.Deque* %0, i32 0, i32 1, !dbg !59
  %7 = load atomic i32, i32* %6 acquire, align 4, !dbg !60
  call void @llvm.dbg.value(metadata i32 %7, metadata !61, metadata !DIExpression()), !dbg !53
  %8 = sub nsw i32 %5, %7, !dbg !62
  %9 = icmp sge i32 %8, %1, !dbg !64
  br i1 %9, label %16, label %10, !dbg !65

10:                                               ; preds = %3
  %11 = getelementptr inbounds %struct.Deque, %struct.Deque* %0, i32 0, i32 2, !dbg !66
  %12 = srem i32 %5, %1, !dbg !67
  %13 = sext i32 %12 to i64, !dbg !68
  %14 = getelementptr inbounds [10 x i32], [10 x i32]* %11, i64 0, i64 %13, !dbg !68
  store i32 %2, i32* %14, align 4, !dbg !69
  %15 = add nsw i32 %5, 1, !dbg !70
  store atomic i32 %15, i32* %4 release, align 4, !dbg !71
  br label %16, !dbg !72

16:                                               ; preds = %3, %10
  %.0 = phi i32 [ 0, %10 ], [ -1, %3 ], !dbg !53
  ret i32 %.0, !dbg !73
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @try_pop(%struct.Deque* noundef %0, i32 noundef %1, i32* noundef %2) #0 !dbg !74 {
  call void @llvm.dbg.value(metadata %struct.Deque* %0, metadata !78, metadata !DIExpression()), !dbg !79
  call void @llvm.dbg.value(metadata i32 %1, metadata !80, metadata !DIExpression()), !dbg !79
  call void @llvm.dbg.value(metadata i32* %2, metadata !81, metadata !DIExpression()), !dbg !79
  %4 = getelementptr inbounds %struct.Deque, %struct.Deque* %0, i32 0, i32 0, !dbg !82
  %5 = load atomic i32, i32* %4 monotonic, align 4, !dbg !83
  call void @llvm.dbg.value(metadata i32 %5, metadata !84, metadata !DIExpression()), !dbg !79
  %6 = sub nsw i32 %5, 1, !dbg !85
  store atomic i32 %6, i32* %4 monotonic, align 4, !dbg !86
  fence seq_cst, !dbg !87
  %7 = getelementptr inbounds %struct.Deque, %struct.Deque* %0, i32 0, i32 1, !dbg !88
  %8 = load atomic i32, i32* %7 monotonic, align 4, !dbg !89
  call void @llvm.dbg.value(metadata i32 %8, metadata !90, metadata !DIExpression()), !dbg !79
  %9 = sub nsw i32 %5, %8, !dbg !91
  %10 = icmp sle i32 %9, 0, !dbg !93
  br i1 %10, label %11, label %12, !dbg !94

11:                                               ; preds = %3
  store atomic i32 %5, i32* %4 monotonic, align 4, !dbg !95
  br label %25, !dbg !97

12:                                               ; preds = %3
  %13 = getelementptr inbounds %struct.Deque, %struct.Deque* %0, i32 0, i32 2, !dbg !98
  %14 = srem i32 %6, %1, !dbg !99
  %15 = sext i32 %14 to i64, !dbg !100
  %16 = getelementptr inbounds [10 x i32], [10 x i32]* %13, i64 0, i64 %15, !dbg !100
  %17 = load i32, i32* %16, align 4, !dbg !100
  store i32 %17, i32* %2, align 4, !dbg !101
  %18 = icmp sgt i32 %9, 1, !dbg !102
  br i1 %18, label %25, label %19, !dbg !104

19:                                               ; preds = %12
  %20 = add nsw i32 %8, 1, !dbg !105
  %21 = cmpxchg i32* %7, i32 %8, i32 %20 monotonic monotonic, align 4, !dbg !106
  %22 = extractvalue { i32, i1 } %21, 1, !dbg !106
  %23 = zext i1 %22 to i8, !dbg !106
  call void @llvm.dbg.value(metadata i8 %23, metadata !107, metadata !DIExpression()), !dbg !79
  store atomic i32 %5, i32* %4 monotonic, align 4, !dbg !109
  %24 = select i1 %22, i32 0, i32 -2, !dbg !110
  br label %25, !dbg !111

25:                                               ; preds = %12, %19, %11
  %.0 = phi i32 [ -1, %11 ], [ %24, %19 ], [ 0, %12 ], !dbg !79
  ret i32 %.0, !dbg !112
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @try_steal(%struct.Deque* noundef %0, i32 noundef %1, i32* noundef %2) #0 !dbg !113 {
  call void @llvm.dbg.value(metadata %struct.Deque* %0, metadata !114, metadata !DIExpression()), !dbg !115
  call void @llvm.dbg.value(metadata i32 %1, metadata !116, metadata !DIExpression()), !dbg !115
  call void @llvm.dbg.value(metadata i32* %2, metadata !117, metadata !DIExpression()), !dbg !115
  %4 = getelementptr inbounds %struct.Deque, %struct.Deque* %0, i32 0, i32 1, !dbg !118
  %5 = load atomic i32, i32* %4 monotonic, align 4, !dbg !119
  call void @llvm.dbg.value(metadata i32 %5, metadata !120, metadata !DIExpression()), !dbg !115
  fence seq_cst, !dbg !121
  %6 = getelementptr inbounds %struct.Deque, %struct.Deque* %0, i32 0, i32 0, !dbg !122
  %7 = load atomic i32, i32* %6 monotonic, align 4, !dbg !123
  call void @llvm.dbg.value(metadata i32 %7, metadata !124, metadata !DIExpression()), !dbg !115
  %8 = sub nsw i32 %7, %5, !dbg !125
  %9 = icmp sle i32 %8, 0, !dbg !127
  br i1 %9, label %21, label %10, !dbg !128

10:                                               ; preds = %3
  %11 = getelementptr inbounds %struct.Deque, %struct.Deque* %0, i32 0, i32 2, !dbg !129
  %12 = srem i32 %5, %1, !dbg !130
  %13 = sext i32 %12 to i64, !dbg !131
  %14 = getelementptr inbounds [10 x i32], [10 x i32]* %11, i64 0, i64 %13, !dbg !131
  %15 = load i32, i32* %14, align 4, !dbg !131
  store i32 %15, i32* %2, align 4, !dbg !132
  %16 = add nsw i32 %5, 1, !dbg !133
  %17 = cmpxchg i32* %4, i32 %5, i32 %16 monotonic monotonic, align 4, !dbg !134
  %18 = extractvalue { i32, i1 } %17, 1, !dbg !134
  %19 = zext i1 %18 to i8, !dbg !134
  call void @llvm.dbg.value(metadata i8 %19, metadata !135, metadata !DIExpression()), !dbg !115
  %20 = select i1 %18, i32 0, i32 -2, !dbg !136
  br label %21, !dbg !137

21:                                               ; preds = %3, %10
  %.0 = phi i32 [ %20, %10 ], [ -1, %3 ], !dbg !115
  ret i32 %.0, !dbg !138
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thief(i8* noundef %0) #0 !dbg !139 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata i8* %0, metadata !142, metadata !DIExpression()), !dbg !143
  call void @llvm.dbg.declare(metadata i32* %2, metadata !144, metadata !DIExpression()), !dbg !145
  %3 = call i32 @try_steal(%struct.Deque* noundef @deq, i32 noundef 10, i32* noundef %2), !dbg !146
  ret i8* null, !dbg !147
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @owner(i8* noundef %0) #0 !dbg !148 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata i8* %0, metadata !149, metadata !DIExpression()), !dbg !150
  call void @llvm.dbg.value(metadata i32 0, metadata !151, metadata !DIExpression()), !dbg !150
  call void @llvm.dbg.declare(metadata i32* %2, metadata !152, metadata !DIExpression()), !dbg !153
  call void @llvm.dbg.value(metadata i32 1, metadata !151, metadata !DIExpression()), !dbg !150
  %3 = call i32 @try_push(%struct.Deque* noundef @deq, i32 noundef 10, i32 noundef 1), !dbg !154
  %4 = call i32 @try_pop(%struct.Deque* noundef @deq, i32 noundef 10, i32* noundef %2), !dbg !155
  %5 = load i32, i32* %2, align 4, !dbg !156
  %6 = icmp eq i32 %5, 1, !dbg !156
  br i1 %6, label %8, label %7, !dbg !159

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @.str.1, i64 0, i64 0), i32 noundef 37, i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @__PRETTY_FUNCTION__.owner, i64 0, i64 0)) #4, !dbg !156
  unreachable, !dbg !156

8:                                                ; preds = %1
  call void @llvm.dbg.value(metadata i32 0, metadata !160, metadata !DIExpression()), !dbg !162
  call void @llvm.dbg.value(metadata i32 0, metadata !160, metadata !DIExpression()), !dbg !162
  %9 = call i32 @try_push(%struct.Deque* noundef @deq, i32 noundef 10, i32 noundef 1), !dbg !163
  call void @llvm.dbg.value(metadata i32 1, metadata !160, metadata !DIExpression()), !dbg !162
  call void @llvm.dbg.value(metadata i32 1, metadata !160, metadata !DIExpression()), !dbg !162
  %10 = call i32 @try_push(%struct.Deque* noundef @deq, i32 noundef 10, i32 noundef 1), !dbg !163
  call void @llvm.dbg.value(metadata i32 2, metadata !160, metadata !DIExpression()), !dbg !162
  call void @llvm.dbg.value(metadata i32 2, metadata !160, metadata !DIExpression()), !dbg !162
  %11 = call i32 @try_push(%struct.Deque* noundef @deq, i32 noundef 10, i32 noundef 1), !dbg !163
  call void @llvm.dbg.value(metadata i32 3, metadata !160, metadata !DIExpression()), !dbg !162
  call void @llvm.dbg.value(metadata i32 3, metadata !160, metadata !DIExpression()), !dbg !162
  %12 = call i32 @try_push(%struct.Deque* noundef @deq, i32 noundef 10, i32 noundef 1), !dbg !163
  call void @llvm.dbg.value(metadata i32 4, metadata !160, metadata !DIExpression()), !dbg !162
  call void @llvm.dbg.value(metadata i32 4, metadata !160, metadata !DIExpression()), !dbg !162
  %13 = call i32 @try_push(%struct.Deque* noundef @deq, i32 noundef 10, i32 noundef 1), !dbg !163
  call void @llvm.dbg.value(metadata i32 5, metadata !160, metadata !DIExpression()), !dbg !162
  call void @llvm.dbg.value(metadata i32 5, metadata !160, metadata !DIExpression()), !dbg !162
  call void @llvm.dbg.value(metadata i32 0, metadata !165, metadata !DIExpression()), !dbg !167
  call void @llvm.dbg.value(metadata i64 0, metadata !165, metadata !DIExpression()), !dbg !167
  %14 = call i32 @pthread_create(i64* noundef getelementptr inbounds ([4 x i64], [4 x i64]* @thiefs, i64 0, i64 0), %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thief, i8* noundef null) #5, !dbg !168
  call void @llvm.dbg.value(metadata i64 1, metadata !165, metadata !DIExpression()), !dbg !167
  call void @llvm.dbg.value(metadata i64 1, metadata !165, metadata !DIExpression()), !dbg !167
  %15 = call i32 @pthread_create(i64* noundef getelementptr inbounds ([4 x i64], [4 x i64]* @thiefs, i64 0, i64 1), %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thief, i8* noundef null) #5, !dbg !168
  call void @llvm.dbg.value(metadata i64 2, metadata !165, metadata !DIExpression()), !dbg !167
  call void @llvm.dbg.value(metadata i64 2, metadata !165, metadata !DIExpression()), !dbg !167
  %16 = call i32 @pthread_create(i64* noundef getelementptr inbounds ([4 x i64], [4 x i64]* @thiefs, i64 0, i64 2), %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thief, i8* noundef null) #5, !dbg !168
  call void @llvm.dbg.value(metadata i64 3, metadata !165, metadata !DIExpression()), !dbg !167
  call void @llvm.dbg.value(metadata i64 3, metadata !165, metadata !DIExpression()), !dbg !167
  %17 = call i32 @pthread_create(i64* noundef getelementptr inbounds ([4 x i64], [4 x i64]* @thiefs, i64 0, i64 3), %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thief, i8* noundef null) #5, !dbg !168
  call void @llvm.dbg.value(metadata i64 4, metadata !165, metadata !DIExpression()), !dbg !167
  call void @llvm.dbg.value(metadata i64 4, metadata !165, metadata !DIExpression()), !dbg !167
  %18 = call i32 @try_pop(%struct.Deque* noundef @deq, i32 noundef 10, i32* noundef %2), !dbg !170
  %19 = icmp sge i32 %18, 0, !dbg !170
  br i1 %19, label %21, label %20, !dbg !173

20:                                               ; preds = %8
  call void @__assert_fail(i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @.str.1, i64 0, i64 0), i32 noundef 46, i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @__PRETTY_FUNCTION__.owner, i64 0, i64 0)) #4, !dbg !170
  unreachable, !dbg !170

21:                                               ; preds = %8
  ret i8* null, !dbg !174
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !175 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !178, metadata !DIExpression()), !dbg !179
  %2 = call i32 @pthread_create(i64* noundef %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @owner, i8* noundef null) #5, !dbg !180
  ret i32 0, !dbg !181
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!39, !40, !41, !42, !43, !44, !45}
!llvm.ident = !{!46}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "deq", scope: !2, file: !20, line: 13, type: !27, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lfds/chase-lev.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "39eb93d755f2fce004e0a6c6e9172c73")
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
!15 = !{!16}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !{!0, !18}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "thiefs", scope: !2, file: !20, line: 14, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/lfds/chase-lev.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "39eb93d755f2fce004e0a6c6e9172c73")
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 256, elements: !25)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !23, line: 27, baseType: !24)
!23 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!24 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!25 = !{!26}
!26 = !DISubrange(count: 4)
!27 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Deque", file: !28, line: 8, size: 384, elements: !29)
!28 = !DIFile(filename: "benchmarks/lfds/chase-lev.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "33b78c7cd214df37c2bba4bcdd5cab37")
!29 = !{!30, !34, !35}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "bottom", scope: !27, file: !28, line: 9, baseType: !31, size: 32)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !32)
!32 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !33)
!33 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "top", scope: !27, file: !28, line: 10, baseType: !31, size: 32, offset: 32)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "buffer", scope: !27, file: !28, line: 11, baseType: !36, size: 320, offset: 64)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 320, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: 10)
!39 = !{i32 7, !"Dwarf Version", i32 5}
!40 = !{i32 2, !"Debug Info Version", i32 3}
!41 = !{i32 1, !"wchar_size", i32 4}
!42 = !{i32 7, !"PIC Level", i32 2}
!43 = !{i32 7, !"PIE Level", i32 2}
!44 = !{i32 7, !"uwtable", i32 1}
!45 = !{i32 7, !"frame-pointer", i32 2}
!46 = !{!"Ubuntu clang version 14.0.6"}
!47 = distinct !DISubprogram(name: "try_push", scope: !28, file: !28, line: 16, type: !48, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!48 = !DISubroutineType(types: !49)
!49 = !{!33, !50, !33, !33}
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !27, size: 64)
!51 = !{}
!52 = !DILocalVariable(name: "deq", arg: 1, scope: !47, file: !28, line: 16, type: !50)
!53 = !DILocation(line: 0, scope: !47)
!54 = !DILocalVariable(name: "N", arg: 2, scope: !47, file: !28, line: 16, type: !33)
!55 = !DILocalVariable(name: "data", arg: 3, scope: !47, file: !28, line: 16, type: !33)
!56 = !DILocation(line: 18, column: 40, scope: !47)
!57 = !DILocation(line: 18, column: 13, scope: !47)
!58 = !DILocalVariable(name: "b", scope: !47, file: !28, line: 18, type: !33)
!59 = !DILocation(line: 19, column: 40, scope: !47)
!60 = !DILocation(line: 19, column: 13, scope: !47)
!61 = !DILocalVariable(name: "t", scope: !47, file: !28, line: 19, type: !33)
!62 = !DILocation(line: 21, column: 12, scope: !63)
!63 = distinct !DILexicalBlock(scope: !47, file: !28, line: 21, column: 9)
!64 = !DILocation(line: 21, column: 17, scope: !63)
!65 = !DILocation(line: 21, column: 9, scope: !47)
!66 = !DILocation(line: 25, column: 10, scope: !47)
!67 = !DILocation(line: 25, column: 19, scope: !47)
!68 = !DILocation(line: 25, column: 5, scope: !47)
!69 = !DILocation(line: 25, column: 24, scope: !47)
!70 = !DILocation(line: 26, column: 43, scope: !47)
!71 = !DILocation(line: 26, column: 5, scope: !47)
!72 = !DILocation(line: 27, column: 5, scope: !47)
!73 = !DILocation(line: 28, column: 1, scope: !47)
!74 = distinct !DISubprogram(name: "try_pop", scope: !28, file: !28, line: 30, type: !75, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!75 = !DISubroutineType(types: !76)
!76 = !{!33, !50, !33, !77}
!77 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!78 = !DILocalVariable(name: "deq", arg: 1, scope: !74, file: !28, line: 30, type: !50)
!79 = !DILocation(line: 0, scope: !74)
!80 = !DILocalVariable(name: "N", arg: 2, scope: !74, file: !28, line: 30, type: !33)
!81 = !DILocalVariable(name: "data", arg: 3, scope: !74, file: !28, line: 30, type: !77)
!82 = !DILocation(line: 32, column: 40, scope: !74)
!83 = !DILocation(line: 32, column: 13, scope: !74)
!84 = !DILocalVariable(name: "b", scope: !74, file: !28, line: 32, type: !33)
!85 = !DILocation(line: 33, column: 43, scope: !74)
!86 = !DILocation(line: 33, column: 5, scope: !74)
!87 = !DILocation(line: 35, column: 5, scope: !74)
!88 = !DILocation(line: 37, column: 40, scope: !74)
!89 = !DILocation(line: 37, column: 13, scope: !74)
!90 = !DILocalVariable(name: "t", scope: !74, file: !28, line: 37, type: !33)
!91 = !DILocation(line: 39, column: 12, scope: !92)
!92 = distinct !DILexicalBlock(scope: !74, file: !28, line: 39, column: 9)
!93 = !DILocation(line: 39, column: 17, scope: !92)
!94 = !DILocation(line: 39, column: 9, scope: !74)
!95 = !DILocation(line: 40, column: 9, scope: !96)
!96 = distinct !DILexicalBlock(scope: !92, file: !28, line: 39, column: 23)
!97 = !DILocation(line: 41, column: 9, scope: !96)
!98 = !DILocation(line: 44, column: 18, scope: !74)
!99 = !DILocation(line: 44, column: 33, scope: !74)
!100 = !DILocation(line: 44, column: 13, scope: !74)
!101 = !DILocation(line: 44, column: 11, scope: !74)
!102 = !DILocation(line: 46, column: 17, scope: !103)
!103 = distinct !DILexicalBlock(scope: !74, file: !28, line: 46, column: 9)
!104 = !DILocation(line: 46, column: 9, scope: !74)
!105 = !DILocation(line: 51, column: 83, scope: !74)
!106 = !DILocation(line: 51, column: 26, scope: !74)
!107 = !DILocalVariable(name: "is_successful", scope: !74, file: !28, line: 51, type: !108)
!108 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!109 = !DILocation(line: 54, column: 5, scope: !74)
!110 = !DILocation(line: 55, column: 13, scope: !74)
!111 = !DILocation(line: 55, column: 5, scope: !74)
!112 = !DILocation(line: 56, column: 1, scope: !74)
!113 = distinct !DISubprogram(name: "try_steal", scope: !28, file: !28, line: 58, type: !75, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!114 = !DILocalVariable(name: "deq", arg: 1, scope: !113, file: !28, line: 58, type: !50)
!115 = !DILocation(line: 0, scope: !113)
!116 = !DILocalVariable(name: "N", arg: 2, scope: !113, file: !28, line: 58, type: !33)
!117 = !DILocalVariable(name: "data", arg: 3, scope: !113, file: !28, line: 58, type: !77)
!118 = !DILocation(line: 60, column: 40, scope: !113)
!119 = !DILocation(line: 60, column: 13, scope: !113)
!120 = !DILocalVariable(name: "t", scope: !113, file: !28, line: 60, type: !33)
!121 = !DILocation(line: 61, column: 5, scope: !113)
!122 = !DILocation(line: 62, column: 40, scope: !113)
!123 = !DILocation(line: 62, column: 13, scope: !113)
!124 = !DILocalVariable(name: "b", scope: !113, file: !28, line: 62, type: !33)
!125 = !DILocation(line: 64, column: 12, scope: !126)
!126 = distinct !DILexicalBlock(scope: !113, file: !28, line: 64, column: 9)
!127 = !DILocation(line: 64, column: 17, scope: !126)
!128 = !DILocation(line: 64, column: 9, scope: !113)
!129 = !DILocation(line: 68, column: 18, scope: !113)
!130 = !DILocation(line: 68, column: 27, scope: !113)
!131 = !DILocation(line: 68, column: 13, scope: !113)
!132 = !DILocation(line: 68, column: 11, scope: !113)
!133 = !DILocation(line: 70, column: 83, scope: !113)
!134 = !DILocation(line: 70, column: 26, scope: !113)
!135 = !DILocalVariable(name: "is_successful", scope: !113, file: !28, line: 70, type: !108)
!136 = !DILocation(line: 73, column: 13, scope: !113)
!137 = !DILocation(line: 73, column: 5, scope: !113)
!138 = !DILocation(line: 74, column: 1, scope: !113)
!139 = distinct !DISubprogram(name: "thief", scope: !20, file: !20, line: 16, type: !140, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!140 = !DISubroutineType(types: !141)
!141 = !{!16, !16}
!142 = !DILocalVariable(name: "unused", arg: 1, scope: !139, file: !20, line: 16, type: !16)
!143 = !DILocation(line: 0, scope: !139)
!144 = !DILocalVariable(name: "data", scope: !139, file: !20, line: 18, type: !33)
!145 = !DILocation(line: 18, column: 9, scope: !139)
!146 = !DILocation(line: 19, column: 5, scope: !139)
!147 = !DILocation(line: 20, column: 5, scope: !139)
!148 = distinct !DISubprogram(name: "owner", scope: !20, file: !20, line: 23, type: !140, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!149 = !DILocalVariable(name: "unused", arg: 1, scope: !148, file: !20, line: 23, type: !16)
!150 = !DILocation(line: 0, scope: !148)
!151 = !DILocalVariable(name: "count", scope: !148, file: !20, line: 25, type: !33)
!152 = !DILocalVariable(name: "data", scope: !148, file: !20, line: 26, type: !33)
!153 = !DILocation(line: 26, column: 9, scope: !148)
!154 = !DILocation(line: 29, column: 5, scope: !148)
!155 = !DILocation(line: 36, column: 5, scope: !148)
!156 = !DILocation(line: 37, column: 5, scope: !157)
!157 = distinct !DILexicalBlock(scope: !158, file: !20, line: 37, column: 5)
!158 = distinct !DILexicalBlock(scope: !148, file: !20, line: 37, column: 5)
!159 = !DILocation(line: 37, column: 5, scope: !158)
!160 = !DILocalVariable(name: "i", scope: !161, file: !20, line: 39, type: !33)
!161 = distinct !DILexicalBlock(scope: !148, file: !20, line: 39, column: 5)
!162 = !DILocation(line: 0, scope: !161)
!163 = !DILocation(line: 40, column: 9, scope: !164)
!164 = distinct !DILexicalBlock(scope: !161, file: !20, line: 39, column: 5)
!165 = !DILocalVariable(name: "i", scope: !166, file: !20, line: 42, type: !33)
!166 = distinct !DILexicalBlock(scope: !148, file: !20, line: 42, column: 5)
!167 = !DILocation(line: 0, scope: !166)
!168 = !DILocation(line: 43, column: 9, scope: !169)
!169 = distinct !DILexicalBlock(scope: !166, file: !20, line: 42, column: 5)
!170 = !DILocation(line: 46, column: 5, scope: !171)
!171 = distinct !DILexicalBlock(scope: !172, file: !20, line: 46, column: 5)
!172 = distinct !DILexicalBlock(scope: !148, file: !20, line: 46, column: 5)
!173 = !DILocation(line: 46, column: 5, scope: !172)
!174 = !DILocation(line: 48, column: 5, scope: !148)
!175 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 51, type: !176, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!176 = !DISubroutineType(types: !177)
!177 = !{!33}
!178 = !DILocalVariable(name: "t0", scope: !175, file: !20, line: 53, type: !22)
!179 = !DILocation(line: 53, column: 12, scope: !175)
!180 = !DILocation(line: 55, column: 2, scope: !175)
!181 = !DILocation(line: 56, column: 5, scope: !175)
