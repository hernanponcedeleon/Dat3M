; ModuleID = '/home/ponce/git/Dat3M/output/linuxrwlock.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/linuxrwlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.rwlock_t = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4, !dbg !0
@mylock = dso_local global %union.rwlock_t zeroinitializer, align 4, !dbg !18
@shareddata = dso_local global i32 0, align 4, !dbg !29
@.str = private unnamed_addr constant [16 x i8] c"r == shareddata\00", align 1
@.str.1 = private unnamed_addr constant [53 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/linuxrwlock.c\00", align 1
@__PRETTY_FUNCTION__.threadR = private unnamed_addr constant [22 x i8] c"void *threadR(void *)\00", align 1
@.str.2 = private unnamed_addr constant [17 x i8] c"42 == shareddata\00", align 1
@__PRETTY_FUNCTION__.threadW = private unnamed_addr constant [22 x i8] c"void *threadW(void *)\00", align 1
@__PRETTY_FUNCTION__.threadRW = private unnamed_addr constant [23 x i8] c"void *threadRW(void *)\00", align 1
@.str.3 = private unnamed_addr constant [29 x i8] c"sum == NWTHREADS + NWTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @threadR(i8* noundef %0) #0 !dbg !40 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !44, metadata !DIExpression()), !dbg !45
  call void @read_lock(%union.rwlock_t* noundef @mylock), !dbg !46
  %2 = load volatile i32, i32* @shareddata, align 4, !dbg !47
  call void @llvm.dbg.value(metadata i32 %2, metadata !48, metadata !DIExpression()), !dbg !45
  %3 = load volatile i32, i32* @shareddata, align 4, !dbg !49
  %4 = icmp eq i32 %2, %3, !dbg !49
  br i1 %4, label %6, label %5, !dbg !52

5:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([53 x i8], [53 x i8]* @.str.1, i64 0, i64 0), i32 noundef 26, i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @__PRETTY_FUNCTION__.threadR, i64 0, i64 0)) #5, !dbg !49
  unreachable, !dbg !49

6:                                                ; preds = %1
  call void @read_unlock(%union.rwlock_t* noundef @mylock), !dbg !53
  ret i8* null, !dbg !54
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @read_lock(%union.rwlock_t* noundef %0) #0 !dbg !55 {
  call void @llvm.dbg.value(metadata %union.rwlock_t* %0, metadata !59, metadata !DIExpression()), !dbg !60
  %2 = bitcast %union.rwlock_t* %0 to i32*, !dbg !61
  %3 = atomicrmw sub i32* %2, i32 1 acquire, align 4, !dbg !62
  call void @llvm.dbg.value(metadata i32 %3, metadata !63, metadata !DIExpression()), !dbg !60
  br label %4, !dbg !64

4:                                                ; preds = %11, %1
  %.0 = phi i32 [ %3, %1 ], [ %12, %11 ], !dbg !60
  call void @llvm.dbg.value(metadata i32 %.0, metadata !63, metadata !DIExpression()), !dbg !60
  %5 = icmp sle i32 %.0, 0, !dbg !65
  br i1 %5, label %6, label %13, !dbg !64

6:                                                ; preds = %4
  %7 = atomicrmw add i32* %2, i32 1 monotonic, align 4, !dbg !66
  br label %8, !dbg !68

8:                                                ; preds = %8, %6
  %9 = load atomic i32, i32* %2 monotonic, align 4, !dbg !69
  %10 = icmp sle i32 %9, 0, !dbg !70
  br i1 %10, label %8, label %11, !dbg !68, !llvm.loop !71

11:                                               ; preds = %8
  %12 = atomicrmw sub i32* %2, i32 1 acquire, align 4, !dbg !74
  call void @llvm.dbg.value(metadata i32 %12, metadata !63, metadata !DIExpression()), !dbg !60
  br label %4, !dbg !64, !llvm.loop !75

13:                                               ; preds = %4
  ret void, !dbg !77
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal void @read_unlock(%union.rwlock_t* noundef %0) #0 !dbg !78 {
  call void @llvm.dbg.value(metadata %union.rwlock_t* %0, metadata !79, metadata !DIExpression()), !dbg !80
  %2 = bitcast %union.rwlock_t* %0 to i32*, !dbg !81
  %3 = atomicrmw add i32* %2, i32 1 release, align 4, !dbg !82
  ret void, !dbg !83
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @threadW(i8* noundef %0) #0 !dbg !84 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !85, metadata !DIExpression()), !dbg !86
  call void @write_lock(%union.rwlock_t* noundef @mylock), !dbg !87
  store volatile i32 42, i32* @shareddata, align 4, !dbg !88
  %2 = load volatile i32, i32* @shareddata, align 4, !dbg !89
  %3 = icmp eq i32 42, %2, !dbg !89
  br i1 %3, label %5, label %4, !dbg !92

4:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([53 x i8], [53 x i8]* @.str.1, i64 0, i64 0), i32 noundef 36, i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @__PRETTY_FUNCTION__.threadW, i64 0, i64 0)) #5, !dbg !89
  unreachable, !dbg !89

5:                                                ; preds = %1
  %6 = load i32, i32* @sum, align 4, !dbg !93
  %7 = add nsw i32 %6, 1, !dbg !93
  store i32 %7, i32* @sum, align 4, !dbg !93
  call void @write_unlock(%union.rwlock_t* noundef @mylock), !dbg !94
  ret i8* null, !dbg !95
}

; Function Attrs: noinline nounwind uwtable
define internal void @write_lock(%union.rwlock_t* noundef %0) #0 !dbg !96 {
  call void @llvm.dbg.value(metadata %union.rwlock_t* %0, metadata !97, metadata !DIExpression()), !dbg !98
  %2 = bitcast %union.rwlock_t* %0 to i32*, !dbg !99
  %3 = atomicrmw sub i32* %2, i32 1048576 acquire, align 4, !dbg !100
  call void @llvm.dbg.value(metadata i32 %3, metadata !101, metadata !DIExpression()), !dbg !98
  br label %4, !dbg !102

4:                                                ; preds = %11, %1
  %.0 = phi i32 [ %3, %1 ], [ %12, %11 ], !dbg !98
  call void @llvm.dbg.value(metadata i32 %.0, metadata !101, metadata !DIExpression()), !dbg !98
  %5 = icmp ne i32 %.0, 1048576, !dbg !103
  br i1 %5, label %6, label %13, !dbg !102

6:                                                ; preds = %4
  %7 = atomicrmw add i32* %2, i32 1048576 monotonic, align 4, !dbg !104
  br label %8, !dbg !106

8:                                                ; preds = %8, %6
  %9 = load atomic i32, i32* %2 monotonic, align 4, !dbg !107
  %10 = icmp ne i32 %9, 1048576, !dbg !108
  br i1 %10, label %8, label %11, !dbg !106, !llvm.loop !109

11:                                               ; preds = %8
  %12 = atomicrmw sub i32* %2, i32 1048576 acquire, align 4, !dbg !111
  call void @llvm.dbg.value(metadata i32 %12, metadata !101, metadata !DIExpression()), !dbg !98
  br label %4, !dbg !102, !llvm.loop !112

13:                                               ; preds = %4
  ret void, !dbg !114
}

; Function Attrs: noinline nounwind uwtable
define internal void @write_unlock(%union.rwlock_t* noundef %0) #0 !dbg !115 {
  call void @llvm.dbg.value(metadata %union.rwlock_t* %0, metadata !116, metadata !DIExpression()), !dbg !117
  %2 = bitcast %union.rwlock_t* %0 to i32*, !dbg !118
  %3 = atomicrmw add i32* %2, i32 1048576 monotonic, align 4, !dbg !119
  ret void, !dbg !120
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @threadRW(i8* noundef %0) #0 !dbg !121 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !122, metadata !DIExpression()), !dbg !123
  call void @read_lock(%union.rwlock_t* noundef @mylock), !dbg !124
  %2 = load volatile i32, i32* @shareddata, align 4, !dbg !125
  call void @llvm.dbg.value(metadata i32 %2, metadata !126, metadata !DIExpression()), !dbg !123
  %3 = load volatile i32, i32* @shareddata, align 4, !dbg !127
  %4 = icmp eq i32 %2, %3, !dbg !127
  br i1 %4, label %6, label %5, !dbg !130

5:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([53 x i8], [53 x i8]* @.str.1, i64 0, i64 0), i32 noundef 47, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.threadRW, i64 0, i64 0)) #5, !dbg !127
  unreachable, !dbg !127

6:                                                ; preds = %1
  call void @read_unlock(%union.rwlock_t* noundef @mylock), !dbg !131
  call void @write_lock(%union.rwlock_t* noundef @mylock), !dbg !132
  store volatile i32 42, i32* @shareddata, align 4, !dbg !133
  %7 = load volatile i32, i32* @shareddata, align 4, !dbg !134
  %8 = icmp eq i32 42, %7, !dbg !134
  br i1 %8, label %10, label %9, !dbg !137

9:                                                ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([53 x i8], [53 x i8]* @.str.1, i64 0, i64 0), i32 noundef 52, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.threadRW, i64 0, i64 0)) #5, !dbg !134
  unreachable, !dbg !134

10:                                               ; preds = %6
  %11 = load i32, i32* @sum, align 4, !dbg !138
  %12 = add nsw i32 %11, 1, !dbg !138
  store i32 %12, i32* @sum, align 4, !dbg !138
  call void @write_unlock(%union.rwlock_t* noundef @mylock), !dbg !139
  ret i8* null, !dbg !140
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !141 {
  %1 = alloca [1 x i64], align 8
  %2 = alloca [1 x i64], align 8
  %3 = alloca [1 x i64], align 8
  call void @llvm.dbg.declare(metadata [1 x i64]* %1, metadata !144, metadata !DIExpression()), !dbg !151
  call void @llvm.dbg.declare(metadata [1 x i64]* %2, metadata !152, metadata !DIExpression()), !dbg !153
  call void @llvm.dbg.declare(metadata [1 x i64]* %3, metadata !154, metadata !DIExpression()), !dbg !155
  store i32 1048576, i32* getelementptr inbounds (%union.rwlock_t, %union.rwlock_t* @mylock, i32 0, i32 0), align 4, !dbg !156
  call void @llvm.dbg.value(metadata i32 0, metadata !157, metadata !DIExpression()), !dbg !159
  call void @llvm.dbg.value(metadata i64 0, metadata !157, metadata !DIExpression()), !dbg !159
  %4 = getelementptr inbounds [1 x i64], [1 x i64]* %1, i64 0, i64 0, !dbg !160
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @threadR, i8* noundef null) #6, !dbg !162
  call void @llvm.dbg.value(metadata i64 1, metadata !157, metadata !DIExpression()), !dbg !159
  call void @llvm.dbg.value(metadata i64 1, metadata !157, metadata !DIExpression()), !dbg !159
  call void @llvm.dbg.value(metadata i32 0, metadata !163, metadata !DIExpression()), !dbg !165
  call void @llvm.dbg.value(metadata i64 0, metadata !163, metadata !DIExpression()), !dbg !165
  %6 = getelementptr inbounds [1 x i64], [1 x i64]* %2, i64 0, i64 0, !dbg !166
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @threadW, i8* noundef null) #6, !dbg !168
  call void @llvm.dbg.value(metadata i64 1, metadata !163, metadata !DIExpression()), !dbg !165
  call void @llvm.dbg.value(metadata i64 1, metadata !163, metadata !DIExpression()), !dbg !165
  call void @llvm.dbg.value(metadata i32 0, metadata !169, metadata !DIExpression()), !dbg !171
  call void @llvm.dbg.value(metadata i64 0, metadata !169, metadata !DIExpression()), !dbg !171
  %8 = getelementptr inbounds [1 x i64], [1 x i64]* %3, i64 0, i64 0, !dbg !172
  %9 = call i32 @pthread_create(i64* noundef %8, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @threadRW, i8* noundef null) #6, !dbg !174
  call void @llvm.dbg.value(metadata i64 1, metadata !169, metadata !DIExpression()), !dbg !171
  call void @llvm.dbg.value(metadata i64 1, metadata !169, metadata !DIExpression()), !dbg !171
  call void @llvm.dbg.value(metadata i32 0, metadata !175, metadata !DIExpression()), !dbg !177
  call void @llvm.dbg.value(metadata i64 0, metadata !175, metadata !DIExpression()), !dbg !177
  %10 = load i64, i64* %4, align 8, !dbg !178
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !180
  call void @llvm.dbg.value(metadata i64 1, metadata !175, metadata !DIExpression()), !dbg !177
  call void @llvm.dbg.value(metadata i64 1, metadata !175, metadata !DIExpression()), !dbg !177
  call void @llvm.dbg.value(metadata i32 0, metadata !181, metadata !DIExpression()), !dbg !183
  call void @llvm.dbg.value(metadata i64 0, metadata !181, metadata !DIExpression()), !dbg !183
  %12 = load i64, i64* %6, align 8, !dbg !184
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !186
  call void @llvm.dbg.value(metadata i64 1, metadata !181, metadata !DIExpression()), !dbg !183
  call void @llvm.dbg.value(metadata i64 1, metadata !181, metadata !DIExpression()), !dbg !183
  call void @llvm.dbg.value(metadata i32 0, metadata !187, metadata !DIExpression()), !dbg !189
  call void @llvm.dbg.value(metadata i64 0, metadata !187, metadata !DIExpression()), !dbg !189
  %14 = load i64, i64* %8, align 8, !dbg !190
  %15 = call i32 @pthread_join(i64 noundef %14, i8** noundef null), !dbg !192
  call void @llvm.dbg.value(metadata i64 1, metadata !187, metadata !DIExpression()), !dbg !189
  call void @llvm.dbg.value(metadata i64 1, metadata !187, metadata !DIExpression()), !dbg !189
  %16 = load i32, i32* @sum, align 4, !dbg !193
  %17 = icmp eq i32 %16, 2, !dbg !193
  br i1 %17, label %19, label %18, !dbg !196

18:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([53 x i8], [53 x i8]* @.str.1, i64 0, i64 0), i32 noundef 82, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !193
  unreachable, !dbg !193

19:                                               ; preds = %0
  ret i32 0, !dbg !197
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

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
!llvm.module.flags = !{!32, !33, !34, !35, !36, !37, !38}
!llvm.ident = !{!39}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !20, line: 20, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/linuxrwlock.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "82bde948e91e2195f082ea6f49ac075d")
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
!17 = !{!0, !18, !29}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "mylock", scope: !2, file: !20, line: 17, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/locks/linuxrwlock.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "82bde948e91e2195f082ea6f49ac075d")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "rwlock_t", file: !22, line: 18, baseType: !23)
!22 = !DIFile(filename: "benchmarks/locks/linuxrwlock.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "1f16d6841e8abb6de3ad57078215b0e5")
!23 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !22, line: 16, size: 32, elements: !24)
!24 = !{!25}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !23, file: !22, line: 17, baseType: !26, size: 32)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !27)
!27 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !28)
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(name: "shareddata", scope: !2, file: !20, line: 19, type: !31, isLocal: false, isDefinition: true)
!31 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !28)
!32 = !{i32 7, !"Dwarf Version", i32 5}
!33 = !{i32 2, !"Debug Info Version", i32 3}
!34 = !{i32 1, !"wchar_size", i32 4}
!35 = !{i32 7, !"PIC Level", i32 2}
!36 = !{i32 7, !"PIE Level", i32 2}
!37 = !{i32 7, !"uwtable", i32 1}
!38 = !{i32 7, !"frame-pointer", i32 2}
!39 = !{!"Ubuntu clang version 14.0.6"}
!40 = distinct !DISubprogram(name: "threadR", scope: !20, file: !20, line: 22, type: !41, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!41 = !DISubroutineType(types: !42)
!42 = !{!16, !16}
!43 = !{}
!44 = !DILocalVariable(name: "arg", arg: 1, scope: !40, file: !20, line: 22, type: !16)
!45 = !DILocation(line: 0, scope: !40)
!46 = !DILocation(line: 24, column: 5, scope: !40)
!47 = !DILocation(line: 25, column: 13, scope: !40)
!48 = !DILocalVariable(name: "r", scope: !40, file: !20, line: 25, type: !28)
!49 = !DILocation(line: 26, column: 5, scope: !50)
!50 = distinct !DILexicalBlock(scope: !51, file: !20, line: 26, column: 5)
!51 = distinct !DILexicalBlock(scope: !40, file: !20, line: 26, column: 5)
!52 = !DILocation(line: 26, column: 5, scope: !51)
!53 = !DILocation(line: 27, column: 5, scope: !40)
!54 = !DILocation(line: 29, column: 5, scope: !40)
!55 = distinct !DISubprogram(name: "read_lock", scope: !22, file: !22, line: 30, type: !56, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !43)
!56 = !DISubroutineType(types: !57)
!57 = !{null, !58}
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!59 = !DILocalVariable(name: "rw", arg: 1, scope: !55, file: !22, line: 30, type: !58)
!60 = !DILocation(line: 0, scope: !55)
!61 = !DILocation(line: 32, column: 53, scope: !55)
!62 = !DILocation(line: 32, column: 22, scope: !55)
!63 = !DILocalVariable(name: "priorvalue", scope: !55, file: !22, line: 32, type: !28)
!64 = !DILocation(line: 33, column: 5, scope: !55)
!65 = !DILocation(line: 33, column: 23, scope: !55)
!66 = !DILocation(line: 34, column: 9, scope: !67)
!67 = distinct !DILexicalBlock(scope: !55, file: !22, line: 33, column: 29)
!68 = !DILocation(line: 35, column: 9, scope: !67)
!69 = !DILocation(line: 35, column: 16, scope: !67)
!70 = !DILocation(line: 35, column: 70, scope: !67)
!71 = distinct !{!71, !68, !72, !73}
!72 = !DILocation(line: 35, column: 75, scope: !67)
!73 = !{!"llvm.loop.mustprogress"}
!74 = !DILocation(line: 36, column: 22, scope: !67)
!75 = distinct !{!75, !64, !76, !73}
!76 = !DILocation(line: 37, column: 5, scope: !55)
!77 = !DILocation(line: 38, column: 1, scope: !55)
!78 = distinct !DISubprogram(name: "read_unlock", scope: !22, file: !22, line: 70, type: !56, scopeLine: 71, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !43)
!79 = !DILocalVariable(name: "rw", arg: 1, scope: !78, file: !22, line: 70, type: !58)
!80 = !DILocation(line: 0, scope: !78)
!81 = !DILocation(line: 72, column: 36, scope: !78)
!82 = !DILocation(line: 72, column: 5, scope: !78)
!83 = !DILocation(line: 73, column: 1, scope: !78)
!84 = distinct !DISubprogram(name: "threadW", scope: !20, file: !20, line: 32, type: !41, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!85 = !DILocalVariable(name: "arg", arg: 1, scope: !84, file: !20, line: 32, type: !16)
!86 = !DILocation(line: 0, scope: !84)
!87 = !DILocation(line: 34, column: 5, scope: !84)
!88 = !DILocation(line: 35, column: 16, scope: !84)
!89 = !DILocation(line: 36, column: 5, scope: !90)
!90 = distinct !DILexicalBlock(scope: !91, file: !20, line: 36, column: 5)
!91 = distinct !DILexicalBlock(scope: !84, file: !20, line: 36, column: 5)
!92 = !DILocation(line: 36, column: 5, scope: !91)
!93 = !DILocation(line: 37, column: 8, scope: !84)
!94 = !DILocation(line: 38, column: 5, scope: !84)
!95 = !DILocation(line: 40, column: 5, scope: !84)
!96 = distinct !DISubprogram(name: "write_lock", scope: !22, file: !22, line: 40, type: !56, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !43)
!97 = !DILocalVariable(name: "rw", arg: 1, scope: !96, file: !22, line: 40, type: !58)
!98 = !DILocation(line: 0, scope: !96)
!99 = !DILocation(line: 42, column: 53, scope: !96)
!100 = !DILocation(line: 42, column: 22, scope: !96)
!101 = !DILocalVariable(name: "priorvalue", scope: !96, file: !22, line: 42, type: !28)
!102 = !DILocation(line: 43, column: 5, scope: !96)
!103 = !DILocation(line: 43, column: 23, scope: !96)
!104 = !DILocation(line: 44, column: 9, scope: !105)
!105 = distinct !DILexicalBlock(scope: !96, file: !22, line: 43, column: 40)
!106 = !DILocation(line: 45, column: 9, scope: !105)
!107 = !DILocation(line: 45, column: 16, scope: !105)
!108 = !DILocation(line: 45, column: 70, scope: !105)
!109 = distinct !{!109, !106, !110, !73}
!110 = !DILocation(line: 45, column: 86, scope: !105)
!111 = !DILocation(line: 46, column: 22, scope: !105)
!112 = distinct !{!112, !102, !113, !73}
!113 = !DILocation(line: 47, column: 5, scope: !96)
!114 = !DILocation(line: 48, column: 1, scope: !96)
!115 = distinct !DISubprogram(name: "write_unlock", scope: !22, file: !22, line: 75, type: !56, scopeLine: 76, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !43)
!116 = !DILocalVariable(name: "rw", arg: 1, scope: !115, file: !22, line: 75, type: !58)
!117 = !DILocation(line: 0, scope: !115)
!118 = !DILocation(line: 77, column: 36, scope: !115)
!119 = !DILocation(line: 77, column: 5, scope: !115)
!120 = !DILocation(line: 78, column: 1, scope: !115)
!121 = distinct !DISubprogram(name: "threadRW", scope: !20, file: !20, line: 43, type: !41, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!122 = !DILocalVariable(name: "arg", arg: 1, scope: !121, file: !20, line: 43, type: !16)
!123 = !DILocation(line: 0, scope: !121)
!124 = !DILocation(line: 45, column: 5, scope: !121)
!125 = !DILocation(line: 46, column: 13, scope: !121)
!126 = !DILocalVariable(name: "r", scope: !121, file: !20, line: 46, type: !28)
!127 = !DILocation(line: 47, column: 5, scope: !128)
!128 = distinct !DILexicalBlock(scope: !129, file: !20, line: 47, column: 5)
!129 = distinct !DILexicalBlock(scope: !121, file: !20, line: 47, column: 5)
!130 = !DILocation(line: 47, column: 5, scope: !129)
!131 = !DILocation(line: 48, column: 5, scope: !121)
!132 = !DILocation(line: 50, column: 5, scope: !121)
!133 = !DILocation(line: 51, column: 16, scope: !121)
!134 = !DILocation(line: 52, column: 5, scope: !135)
!135 = distinct !DILexicalBlock(scope: !136, file: !20, line: 52, column: 5)
!136 = distinct !DILexicalBlock(scope: !121, file: !20, line: 52, column: 5)
!137 = !DILocation(line: 52, column: 5, scope: !136)
!138 = !DILocation(line: 53, column: 8, scope: !121)
!139 = !DILocation(line: 54, column: 5, scope: !121)
!140 = !DILocation(line: 56, column: 5, scope: !121)
!141 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 59, type: !142, scopeLine: 60, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!142 = !DISubroutineType(types: !143)
!143 = !{!28}
!144 = !DILocalVariable(name: "r", scope: !141, file: !20, line: 61, type: !145)
!145 = !DICompositeType(tag: DW_TAG_array_type, baseType: !146, size: 64, elements: !149)
!146 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !147, line: 27, baseType: !148)
!147 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!148 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!149 = !{!150}
!150 = !DISubrange(count: 1)
!151 = !DILocation(line: 61, column: 15, scope: !141)
!152 = !DILocalVariable(name: "w", scope: !141, file: !20, line: 62, type: !145)
!153 = !DILocation(line: 62, column: 15, scope: !141)
!154 = !DILocalVariable(name: "rw", scope: !141, file: !20, line: 63, type: !145)
!155 = !DILocation(line: 63, column: 15, scope: !141)
!156 = !DILocation(line: 65, column: 5, scope: !141)
!157 = !DILocalVariable(name: "i", scope: !158, file: !20, line: 67, type: !28)
!158 = distinct !DILexicalBlock(scope: !141, file: !20, line: 67, column: 5)
!159 = !DILocation(line: 0, scope: !158)
!160 = !DILocation(line: 68, column: 25, scope: !161)
!161 = distinct !DILexicalBlock(scope: !158, file: !20, line: 67, column: 5)
!162 = !DILocation(line: 68, column: 9, scope: !161)
!163 = !DILocalVariable(name: "i", scope: !164, file: !20, line: 69, type: !28)
!164 = distinct !DILexicalBlock(scope: !141, file: !20, line: 69, column: 5)
!165 = !DILocation(line: 0, scope: !164)
!166 = !DILocation(line: 70, column: 25, scope: !167)
!167 = distinct !DILexicalBlock(scope: !164, file: !20, line: 69, column: 5)
!168 = !DILocation(line: 70, column: 9, scope: !167)
!169 = !DILocalVariable(name: "i", scope: !170, file: !20, line: 71, type: !28)
!170 = distinct !DILexicalBlock(scope: !141, file: !20, line: 71, column: 5)
!171 = !DILocation(line: 0, scope: !170)
!172 = !DILocation(line: 72, column: 25, scope: !173)
!173 = distinct !DILexicalBlock(scope: !170, file: !20, line: 71, column: 5)
!174 = !DILocation(line: 72, column: 9, scope: !173)
!175 = !DILocalVariable(name: "i", scope: !176, file: !20, line: 74, type: !28)
!176 = distinct !DILexicalBlock(scope: !141, file: !20, line: 74, column: 5)
!177 = !DILocation(line: 0, scope: !176)
!178 = !DILocation(line: 75, column: 22, scope: !179)
!179 = distinct !DILexicalBlock(scope: !176, file: !20, line: 74, column: 5)
!180 = !DILocation(line: 75, column: 9, scope: !179)
!181 = !DILocalVariable(name: "i", scope: !182, file: !20, line: 76, type: !28)
!182 = distinct !DILexicalBlock(scope: !141, file: !20, line: 76, column: 5)
!183 = !DILocation(line: 0, scope: !182)
!184 = !DILocation(line: 77, column: 22, scope: !185)
!185 = distinct !DILexicalBlock(scope: !182, file: !20, line: 76, column: 5)
!186 = !DILocation(line: 77, column: 9, scope: !185)
!187 = !DILocalVariable(name: "i", scope: !188, file: !20, line: 78, type: !28)
!188 = distinct !DILexicalBlock(scope: !141, file: !20, line: 78, column: 5)
!189 = !DILocation(line: 0, scope: !188)
!190 = !DILocation(line: 79, column: 22, scope: !191)
!191 = distinct !DILexicalBlock(scope: !188, file: !20, line: 78, column: 5)
!192 = !DILocation(line: 79, column: 9, scope: !191)
!193 = !DILocation(line: 82, column: 5, scope: !194)
!194 = distinct !DILexicalBlock(scope: !195, file: !20, line: 82, column: 5)
!195 = distinct !DILexicalBlock(scope: !141, file: !20, line: 82, column: 5)
!196 = !DILocation(line: 82, column: 5, scope: !195)
!197 = !DILocation(line: 84, column: 5, scope: !141)
