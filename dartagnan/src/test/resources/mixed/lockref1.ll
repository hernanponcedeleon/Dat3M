; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/mixed/lockref1.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/mixed/lockref1.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct.lockref_t = type { %union.anon }
%union.anon = type { i64 }
%struct.spinlock_s = type { i32 }
%struct.anon = type { i32, i32 }
%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@my_lockref = global %struct.lockref_t zeroinitializer, align 8, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str = private unnamed_addr constant [11 x i8] c"lockref1.c\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"my_lockref.count == NTHREADS\00", align 1

; Function Attrs: noinline nounwind ssp uwtable
define void @await_for_lock(%struct.spinlock_s* noundef %0) #0 !dbg !52 {
  %2 = alloca %struct.spinlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.spinlock_s* %0, %struct.spinlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.spinlock_s** %2, metadata !63, metadata !DIExpression()), !dbg !64
  br label %4, !dbg !65

4:                                                ; preds = %10, %1
  %5 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8, !dbg !66
  %6 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %5, i32 0, i32 0, !dbg !67
  %7 = load atomic i32, i32* %6 monotonic, align 4, !dbg !68
  store i32 %7, i32* %3, align 4, !dbg !68
  %8 = load i32, i32* %3, align 4, !dbg !68
  %9 = icmp ne i32 %8, 0, !dbg !69
  br i1 %9, label %10, label %11, !dbg !65

10:                                               ; preds = %4
  br label %4, !dbg !65, !llvm.loop !70

11:                                               ; preds = %4
  ret void, !dbg !73
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i32 @try_get_lock(%struct.spinlock_s* noundef %0) #0 !dbg !74 {
  %2 = alloca %struct.spinlock_s*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store %struct.spinlock_s* %0, %struct.spinlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.spinlock_s** %2, metadata !77, metadata !DIExpression()), !dbg !78
  call void @llvm.dbg.declare(metadata i32* %3, metadata !79, metadata !DIExpression()), !dbg !80
  store i32 0, i32* %3, align 4, !dbg !80
  %6 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8, !dbg !81
  %7 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %6, i32 0, i32 0, !dbg !82
  store i32 1, i32* %4, align 4, !dbg !83
  %8 = load i32, i32* %3, align 4, !dbg !83
  %9 = load i32, i32* %4, align 4, !dbg !83
  %10 = cmpxchg i32* %7, i32 %8, i32 %9 acquire acquire, align 4, !dbg !83
  %11 = extractvalue { i32, i1 } %10, 0, !dbg !83
  %12 = extractvalue { i32, i1 } %10, 1, !dbg !83
  br i1 %12, label %14, label %13, !dbg !83

13:                                               ; preds = %1
  store i32 %11, i32* %3, align 4, !dbg !83
  br label %14, !dbg !83

14:                                               ; preds = %13, %1
  %15 = zext i1 %12 to i8, !dbg !83
  store i8 %15, i8* %5, align 1, !dbg !83
  %16 = load i8, i8* %5, align 1, !dbg !83
  %17 = trunc i8 %16 to i1, !dbg !83
  %18 = zext i1 %17 to i32, !dbg !83
  ret i32 %18, !dbg !84
}

; Function Attrs: noinline nounwind ssp uwtable
define void @spin_lock(%struct.spinlock_s* noundef %0) #0 !dbg !85 {
  %2 = alloca %struct.spinlock_s*, align 8
  store %struct.spinlock_s* %0, %struct.spinlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.spinlock_s** %2, metadata !86, metadata !DIExpression()), !dbg !87
  br label %3, !dbg !88

3:                                                ; preds = %5, %1
  %4 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8, !dbg !89
  call void @await_for_lock(%struct.spinlock_s* noundef %4), !dbg !91
  br label %5, !dbg !92

5:                                                ; preds = %3
  %6 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8, !dbg !93
  %7 = call i32 @try_get_lock(%struct.spinlock_s* noundef %6), !dbg !94
  %8 = icmp ne i32 %7, 0, !dbg !95
  %9 = xor i1 %8, true, !dbg !95
  br i1 %9, label %3, label %10, !dbg !92, !llvm.loop !96

10:                                               ; preds = %5
  ret void, !dbg !98
}

; Function Attrs: noinline nounwind ssp uwtable
define void @spin_unlock(%struct.spinlock_s* noundef %0) #0 !dbg !99 {
  %2 = alloca %struct.spinlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.spinlock_s* %0, %struct.spinlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.spinlock_s** %2, metadata !100, metadata !DIExpression()), !dbg !101
  %4 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8, !dbg !102
  %5 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %4, i32 0, i32 0, !dbg !103
  store i32 0, i32* %3, align 4, !dbg !104
  %6 = load i32, i32* %3, align 4, !dbg !104
  store atomic i32 %6, i32* %5 release, align 4, !dbg !104
  ret void, !dbg !105
}

; Function Attrs: noinline nounwind ssp uwtable
define void @lockref_get(%struct.lockref_t* noundef %0) #0 !dbg !106 {
  %2 = alloca %struct.lockref_t*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8, align 1
  store %struct.lockref_t* %0, %struct.lockref_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.lockref_t** %2, metadata !109, metadata !DIExpression()), !dbg !110
  call void @llvm.dbg.declare(metadata i64* %3, metadata !111, metadata !DIExpression()), !dbg !112
  %8 = load %struct.lockref_t*, %struct.lockref_t** %2, align 8, !dbg !113
  %9 = getelementptr inbounds %struct.lockref_t, %struct.lockref_t* %8, i32 0, i32 0, !dbg !114
  %10 = bitcast %union.anon* %9 to i64*, !dbg !114
  %11 = load atomic i64, i64* %10 monotonic, align 8, !dbg !115
  store i64 %11, i64* %4, align 8, !dbg !115
  %12 = load i64, i64* %4, align 8, !dbg !115
  store i64 %12, i64* %3, align 8, !dbg !112
  br label %13, !dbg !116

13:                                               ; preds = %43, %1
  %14 = bitcast i64* %3 to %struct.lockref_t*, !dbg !117
  %15 = getelementptr inbounds %struct.lockref_t, %struct.lockref_t* %14, i32 0, i32 0, !dbg !117
  %16 = bitcast %union.anon* %15 to %struct.anon*, !dbg !117
  %17 = getelementptr inbounds %struct.anon, %struct.anon* %16, i32 0, i32 0, !dbg !117
  %18 = load atomic i32, i32* %17 seq_cst, align 4, !dbg !117
  %19 = icmp eq i32 %18, 0, !dbg !118
  br i1 %19, label %20, label %44, !dbg !116

20:                                               ; preds = %13
  call void @llvm.dbg.declare(metadata i64* %5, metadata !119, metadata !DIExpression()), !dbg !121
  %21 = load i64, i64* %3, align 8, !dbg !122
  store i64 %21, i64* %5, align 8, !dbg !121
  %22 = bitcast i64* %5 to %struct.lockref_t*, !dbg !123
  %23 = getelementptr inbounds %struct.lockref_t, %struct.lockref_t* %22, i32 0, i32 0, !dbg !123
  %24 = bitcast %union.anon* %23 to %struct.anon*, !dbg !123
  %25 = getelementptr inbounds %struct.anon, %struct.anon* %24, i32 0, i32 1, !dbg !123
  %26 = load i32, i32* %25, align 4, !dbg !124
  %27 = add nsw i32 %26, 1, !dbg !124
  store i32 %27, i32* %25, align 4, !dbg !124
  %28 = load %struct.lockref_t*, %struct.lockref_t** %2, align 8, !dbg !125
  %29 = getelementptr inbounds %struct.lockref_t, %struct.lockref_t* %28, i32 0, i32 0, !dbg !127
  %30 = bitcast %union.anon* %29 to i64*, !dbg !127
  %31 = load i64, i64* %5, align 8, !dbg !128
  store i64 %31, i64* %6, align 8, !dbg !129
  %32 = load i64, i64* %3, align 8, !dbg !129
  %33 = load i64, i64* %6, align 8, !dbg !129
  %34 = cmpxchg i64* %30, i64 %32, i64 %33 monotonic monotonic, align 8, !dbg !129
  %35 = extractvalue { i64, i1 } %34, 0, !dbg !129
  %36 = extractvalue { i64, i1 } %34, 1, !dbg !129
  br i1 %36, label %38, label %37, !dbg !129

37:                                               ; preds = %20
  store i64 %35, i64* %3, align 8, !dbg !129
  br label %38, !dbg !129

38:                                               ; preds = %37, %20
  %39 = zext i1 %36 to i8, !dbg !129
  store i8 %39, i8* %7, align 1, !dbg !129
  %40 = load i8, i8* %7, align 1, !dbg !129
  %41 = trunc i8 %40 to i1, !dbg !129
  br i1 %41, label %42, label %43, !dbg !130

42:                                               ; preds = %38
  br label %61, !dbg !131

43:                                               ; preds = %38
  br label %13, !dbg !116, !llvm.loop !133

44:                                               ; preds = %13
  %45 = load %struct.lockref_t*, %struct.lockref_t** %2, align 8, !dbg !135
  %46 = getelementptr inbounds %struct.lockref_t, %struct.lockref_t* %45, i32 0, i32 0, !dbg !136
  %47 = bitcast %union.anon* %46 to %struct.anon*, !dbg !136
  %48 = getelementptr inbounds %struct.anon, %struct.anon* %47, i32 0, i32 0, !dbg !136
  %49 = bitcast i32* %48 to %struct.spinlock_s*, !dbg !137
  call void @spin_lock(%struct.spinlock_s* noundef %49), !dbg !138
  %50 = load %struct.lockref_t*, %struct.lockref_t** %2, align 8, !dbg !139
  %51 = getelementptr inbounds %struct.lockref_t, %struct.lockref_t* %50, i32 0, i32 0, !dbg !140
  %52 = bitcast %union.anon* %51 to %struct.anon*, !dbg !140
  %53 = getelementptr inbounds %struct.anon, %struct.anon* %52, i32 0, i32 1, !dbg !140
  %54 = load i32, i32* %53, align 4, !dbg !141
  %55 = add nsw i32 %54, 1, !dbg !141
  store i32 %55, i32* %53, align 4, !dbg !141
  %56 = load %struct.lockref_t*, %struct.lockref_t** %2, align 8, !dbg !142
  %57 = getelementptr inbounds %struct.lockref_t, %struct.lockref_t* %56, i32 0, i32 0, !dbg !143
  %58 = bitcast %union.anon* %57 to %struct.anon*, !dbg !143
  %59 = getelementptr inbounds %struct.anon, %struct.anon* %58, i32 0, i32 0, !dbg !143
  %60 = bitcast i32* %59 to %struct.spinlock_s*, !dbg !144
  call void @spin_unlock(%struct.spinlock_s* noundef %60), !dbg !145
  br label %61, !dbg !146

61:                                               ; preds = %44, %42
  ret void, !dbg !146
}

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread_n(i8* noundef %0) #0 !dbg !147 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !150, metadata !DIExpression()), !dbg !151
  call void @lockref_get(%struct.lockref_t* noundef @my_lockref), !dbg !152
  ret i8* null, !dbg !153
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !154 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x %struct._opaque_pthread_t*], align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x %struct._opaque_pthread_t*]* %2, metadata !157, metadata !DIExpression()), !dbg !184
  store i64 0, i64* %3, align 8, !dbg !185
  %6 = load i64, i64* %3, align 8, !dbg !185
  store atomic i64 %6, i64* getelementptr inbounds (%struct.lockref_t, %struct.lockref_t* @my_lockref, i32 0, i32 0, i32 0) seq_cst, align 8, !dbg !185
  call void @llvm.dbg.declare(metadata i32* %4, metadata !186, metadata !DIExpression()), !dbg !188
  store i32 0, i32* %4, align 4, !dbg !188
  br label %7, !dbg !189

7:                                                ; preds = %18, %0
  %8 = load i32, i32* %4, align 4, !dbg !190
  %9 = icmp slt i32 %8, 3, !dbg !192
  br i1 %9, label %10, label %21, !dbg !193

10:                                               ; preds = %7
  %11 = load i32, i32* %4, align 4, !dbg !194
  %12 = sext i32 %11 to i64, !dbg !195
  %13 = getelementptr inbounds [3 x %struct._opaque_pthread_t*], [3 x %struct._opaque_pthread_t*]* %2, i64 0, i64 %12, !dbg !195
  %14 = load i32, i32* %4, align 4, !dbg !196
  %15 = sext i32 %14 to i64, !dbg !197
  %16 = inttoptr i64 %15 to i8*, !dbg !198
  %17 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %13, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef %16), !dbg !199
  br label %18, !dbg !199

18:                                               ; preds = %10
  %19 = load i32, i32* %4, align 4, !dbg !200
  %20 = add nsw i32 %19, 1, !dbg !200
  store i32 %20, i32* %4, align 4, !dbg !200
  br label %7, !dbg !201, !llvm.loop !202

21:                                               ; preds = %7
  call void @llvm.dbg.declare(metadata i32* %5, metadata !204, metadata !DIExpression()), !dbg !206
  store i32 0, i32* %5, align 4, !dbg !206
  br label %22, !dbg !207

22:                                               ; preds = %31, %21
  %23 = load i32, i32* %5, align 4, !dbg !208
  %24 = icmp slt i32 %23, 3, !dbg !210
  br i1 %24, label %25, label %34, !dbg !211

25:                                               ; preds = %22
  %26 = load i32, i32* %5, align 4, !dbg !212
  %27 = sext i32 %26 to i64, !dbg !213
  %28 = getelementptr inbounds [3 x %struct._opaque_pthread_t*], [3 x %struct._opaque_pthread_t*]* %2, i64 0, i64 %27, !dbg !213
  %29 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %28, align 8, !dbg !213
  %30 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %29, i8** noundef null), !dbg !214
  br label %31, !dbg !214

31:                                               ; preds = %25
  %32 = load i32, i32* %5, align 4, !dbg !215
  %33 = add nsw i32 %32, 1, !dbg !215
  store i32 %33, i32* %5, align 4, !dbg !215
  br label %22, !dbg !216, !llvm.loop !217

34:                                               ; preds = %22
  %35 = load i32, i32* getelementptr inbounds (%struct.anon, %struct.anon* bitcast (%struct.lockref_t* @my_lockref to %struct.anon*), i32 0, i32 1), align 4, !dbg !219
  %36 = icmp eq i32 %35, 3, !dbg !219
  %37 = xor i1 %36, true, !dbg !219
  %38 = zext i1 %37 to i32, !dbg !219
  %39 = sext i32 %38 to i64, !dbg !219
  %40 = icmp ne i64 %39, 0, !dbg !219
  br i1 %40, label %41, label %43, !dbg !219

41:                                               ; preds = %34
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i32 noundef 101, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !219
  unreachable, !dbg !219

42:                                               ; No predecessors!
  br label %44, !dbg !219

43:                                               ; preds = %34
  br label %44, !dbg !219

44:                                               ; preds = %43, %42
  ret i32 0, !dbg !220
}

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef, i8** noundef) #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #4 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!41, !42, !43, !44, !45, !46, !47, !48, !49, !50}
!llvm.ident = !{!51}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "my_lockref", scope: !2, file: !18, line: 80, type: !17, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !40, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/mixed/lockref1.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 56, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/opt/homebrew/Cellar/llvm@14/14.0.6/lib/clang/14.0.6/include/stdatomic.h", directory: "")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16, !36, !37}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "lockref_t", file: !18, line: 56, baseType: !19)
!18 = !DIFile(filename: "benchmarks/mixed/lockref1.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!19 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !18, line: 48, size: 64, elements: !20)
!20 = !{!21}
!21 = !DIDerivedType(tag: DW_TAG_member, scope: !19, file: !18, line: 49, baseType: !22, size: 64)
!22 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !19, file: !18, line: 49, size: 64, elements: !23)
!23 = !{!24, !32}
!24 = !DIDerivedType(tag: DW_TAG_member, scope: !22, file: !18, line: 50, baseType: !25, size: 64)
!25 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !22, file: !18, line: 50, size: 64, elements: !26)
!26 = !{!27, !31}
!27 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !25, file: !18, line: 51, baseType: !28, size: 32)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !29)
!29 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !30)
!30 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !25, file: !18, line: 52, baseType: !30, size: 32, offset: 32)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "lock_count", scope: !22, file: !18, line: 54, baseType: !33, size: 64)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_long", file: !6, line: 94, baseType: !34)
!34 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !35)
!35 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !38, line: 46, baseType: !39)
!38 = !DIFile(filename: "/opt/homebrew/Cellar/llvm@14/14.0.6/lib/clang/14.0.6/include/stddef.h", directory: "")
!39 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!40 = !{!0}
!41 = !{i32 7, !"Dwarf Version", i32 4}
!42 = !{i32 2, !"Debug Info Version", i32 3}
!43 = !{i32 1, !"wchar_size", i32 4}
!44 = !{i32 1, !"branch-target-enforcement", i32 0}
!45 = !{i32 1, !"sign-return-address", i32 0}
!46 = !{i32 1, !"sign-return-address-all", i32 0}
!47 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!48 = !{i32 7, !"PIC Level", i32 2}
!49 = !{i32 7, !"uwtable", i32 1}
!50 = !{i32 7, !"frame-pointer", i32 1}
!51 = !{!"Homebrew clang version 14.0.6"}
!52 = distinct !DISubprogram(name: "await_for_lock", scope: !18, file: !18, line: 19, type: !53, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!53 = !DISubroutineType(types: !54)
!54 = !{null, !55}
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!56 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "spinlock_s", file: !18, line: 14, size: 32, elements: !57)
!57 = !{!58}
!58 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !56, file: !18, line: 15, baseType: !59, size: 32)
!59 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !60)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !61, line: 30, baseType: !30)
!61 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_types/_int32_t.h", directory: "")
!62 = !{}
!63 = !DILocalVariable(name: "l", arg: 1, scope: !52, file: !18, line: 19, type: !55)
!64 = !DILocation(line: 19, column: 40, scope: !52)
!65 = !DILocation(line: 21, column: 5, scope: !52)
!66 = !DILocation(line: 21, column: 34, scope: !52)
!67 = !DILocation(line: 21, column: 37, scope: !52)
!68 = !DILocation(line: 21, column: 12, scope: !52)
!69 = !DILocation(line: 21, column: 65, scope: !52)
!70 = distinct !{!70, !65, !71, !72}
!71 = !DILocation(line: 21, column: 70, scope: !52)
!72 = !{!"llvm.loop.mustprogress"}
!73 = !DILocation(line: 22, column: 5, scope: !52)
!74 = distinct !DISubprogram(name: "try_get_lock", scope: !18, file: !18, line: 25, type: !75, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!75 = !DISubroutineType(types: !76)
!76 = !{!30, !55}
!77 = !DILocalVariable(name: "l", arg: 1, scope: !74, file: !18, line: 25, type: !55)
!78 = !DILocation(line: 25, column: 37, scope: !74)
!79 = !DILocalVariable(name: "val", scope: !74, file: !18, line: 27, type: !30)
!80 = !DILocation(line: 27, column: 9, scope: !74)
!81 = !DILocation(line: 28, column: 53, scope: !74)
!82 = !DILocation(line: 28, column: 56, scope: !74)
!83 = !DILocation(line: 28, column: 12, scope: !74)
!84 = !DILocation(line: 28, column: 5, scope: !74)
!85 = distinct !DISubprogram(name: "spin_lock", scope: !18, file: !18, line: 31, type: !53, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!86 = !DILocalVariable(name: "l", arg: 1, scope: !85, file: !18, line: 31, type: !55)
!87 = !DILocation(line: 31, column: 35, scope: !85)
!88 = !DILocation(line: 33, column: 5, scope: !85)
!89 = !DILocation(line: 34, column: 24, scope: !90)
!90 = distinct !DILexicalBlock(scope: !85, file: !18, line: 33, column: 8)
!91 = !DILocation(line: 34, column: 9, scope: !90)
!92 = !DILocation(line: 35, column: 5, scope: !90)
!93 = !DILocation(line: 35, column: 27, scope: !85)
!94 = !DILocation(line: 35, column: 14, scope: !85)
!95 = !DILocation(line: 35, column: 13, scope: !85)
!96 = distinct !{!96, !88, !97, !72}
!97 = !DILocation(line: 35, column: 29, scope: !85)
!98 = !DILocation(line: 36, column: 5, scope: !85)
!99 = distinct !DISubprogram(name: "spin_unlock", scope: !18, file: !18, line: 39, type: !53, scopeLine: 40, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!100 = !DILocalVariable(name: "l", arg: 1, scope: !99, file: !18, line: 39, type: !55)
!101 = !DILocation(line: 39, column: 37, scope: !99)
!102 = !DILocation(line: 41, column: 28, scope: !99)
!103 = !DILocation(line: 41, column: 31, scope: !99)
!104 = !DILocation(line: 41, column: 5, scope: !99)
!105 = !DILocation(line: 42, column: 1, scope: !99)
!106 = distinct !DISubprogram(name: "lockref_get", scope: !18, file: !18, line: 58, type: !107, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!107 = !DISubroutineType(types: !108)
!108 = !{null, !16}
!109 = !DILocalVariable(name: "lockref", arg: 1, scope: !106, file: !18, line: 58, type: !16)
!110 = !DILocation(line: 58, column: 29, scope: !106)
!111 = !DILocalVariable(name: "old_val", scope: !106, file: !18, line: 59, type: !35)
!112 = !DILocation(line: 59, column: 10, scope: !106)
!113 = !DILocation(line: 59, column: 42, scope: !106)
!114 = !DILocation(line: 59, column: 51, scope: !106)
!115 = !DILocation(line: 59, column: 20, scope: !106)
!116 = !DILocation(line: 61, column: 5, scope: !106)
!117 = !DILocation(line: 61, column: 37, scope: !106)
!118 = !DILocation(line: 61, column: 42, scope: !106)
!119 = !DILocalVariable(name: "new_val", scope: !120, file: !18, line: 62, type: !35)
!120 = distinct !DILexicalBlock(scope: !106, file: !18, line: 61, column: 48)
!121 = !DILocation(line: 62, column: 14, scope: !120)
!122 = !DILocation(line: 62, column: 24, scope: !120)
!123 = !DILocation(line: 63, column: 34, scope: !120)
!124 = !DILocation(line: 63, column: 39, scope: !120)
!125 = !DILocation(line: 65, column: 18, scope: !126)
!126 = distinct !DILexicalBlock(scope: !120, file: !18, line: 64, column: 13)
!127 = !DILocation(line: 65, column: 27, scope: !126)
!128 = !DILocation(line: 65, column: 49, scope: !126)
!129 = !DILocation(line: 64, column: 13, scope: !126)
!130 = !DILocation(line: 64, column: 13, scope: !120)
!131 = !DILocation(line: 67, column: 13, scope: !132)
!132 = distinct !DILexicalBlock(scope: !126, file: !18, line: 66, column: 62)
!133 = distinct !{!133, !116, !134, !72}
!134 = !DILocation(line: 69, column: 5, scope: !106)
!135 = !DILocation(line: 71, column: 16, scope: !106)
!136 = !DILocation(line: 71, column: 25, scope: !106)
!137 = !DILocation(line: 71, column: 15, scope: !106)
!138 = !DILocation(line: 71, column: 5, scope: !106)
!139 = !DILocation(line: 72, column: 5, scope: !106)
!140 = !DILocation(line: 72, column: 14, scope: !106)
!141 = !DILocation(line: 72, column: 19, scope: !106)
!142 = !DILocation(line: 73, column: 18, scope: !106)
!143 = !DILocation(line: 73, column: 27, scope: !106)
!144 = !DILocation(line: 73, column: 17, scope: !106)
!145 = !DILocation(line: 73, column: 5, scope: !106)
!146 = !DILocation(line: 74, column: 1, scope: !106)
!147 = distinct !DISubprogram(name: "thread_n", scope: !18, file: !18, line: 82, type: !148, scopeLine: 82, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!148 = !DISubroutineType(types: !149)
!149 = !{!36, !36}
!150 = !DILocalVariable(name: "unsued", arg: 1, scope: !147, file: !18, line: 82, type: !36)
!151 = !DILocation(line: 82, column: 22, scope: !147)
!152 = !DILocation(line: 84, column: 5, scope: !147)
!153 = !DILocation(line: 86, column: 5, scope: !147)
!154 = distinct !DISubprogram(name: "main", scope: !18, file: !18, line: 89, type: !155, scopeLine: 89, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!155 = !DISubroutineType(types: !156)
!156 = !{!30}
!157 = !DILocalVariable(name: "t", scope: !154, file: !18, line: 91, type: !158)
!158 = !DICompositeType(tag: DW_TAG_array_type, baseType: !159, size: 192, elements: !182)
!159 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !160, line: 31, baseType: !161)
!160 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!161 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !162, line: 118, baseType: !163)
!162 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!163 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !164, size: 64)
!164 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !162, line: 103, size: 65536, elements: !165)
!165 = !{!166, !167, !177}
!166 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !164, file: !162, line: 104, baseType: !35, size: 64)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !164, file: !162, line: 105, baseType: !168, size: 64, offset: 64)
!168 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !169, size: 64)
!169 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !162, line: 57, size: 192, elements: !170)
!170 = !{!171, !175, !176}
!171 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !169, file: !162, line: 58, baseType: !172, size: 64)
!172 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !173, size: 64)
!173 = !DISubroutineType(types: !174)
!174 = !{null, !36}
!175 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !169, file: !162, line: 59, baseType: !36, size: 64, offset: 64)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !169, file: !162, line: 60, baseType: !168, size: 64, offset: 128)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !164, file: !162, line: 106, baseType: !178, size: 65408, offset: 128)
!178 = !DICompositeType(tag: DW_TAG_array_type, baseType: !179, size: 65408, elements: !180)
!179 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!180 = !{!181}
!181 = !DISubrange(count: 8176)
!182 = !{!183}
!183 = !DISubrange(count: 3)
!184 = !DILocation(line: 91, column: 15, scope: !154)
!185 = !DILocation(line: 93, column: 5, scope: !154)
!186 = !DILocalVariable(name: "i", scope: !187, file: !18, line: 95, type: !30)
!187 = distinct !DILexicalBlock(scope: !154, file: !18, line: 95, column: 5)
!188 = !DILocation(line: 95, column: 14, scope: !187)
!189 = !DILocation(line: 95, column: 10, scope: !187)
!190 = !DILocation(line: 95, column: 21, scope: !191)
!191 = distinct !DILexicalBlock(scope: !187, file: !18, line: 95, column: 5)
!192 = !DILocation(line: 95, column: 23, scope: !191)
!193 = !DILocation(line: 95, column: 5, scope: !187)
!194 = !DILocation(line: 96, column: 27, scope: !191)
!195 = !DILocation(line: 96, column: 25, scope: !191)
!196 = !DILocation(line: 96, column: 60, scope: !191)
!197 = !DILocation(line: 96, column: 52, scope: !191)
!198 = !DILocation(line: 96, column: 44, scope: !191)
!199 = !DILocation(line: 96, column: 9, scope: !191)
!200 = !DILocation(line: 95, column: 36, scope: !191)
!201 = !DILocation(line: 95, column: 5, scope: !191)
!202 = distinct !{!202, !193, !203, !72}
!203 = !DILocation(line: 96, column: 61, scope: !187)
!204 = !DILocalVariable(name: "i", scope: !205, file: !18, line: 98, type: !30)
!205 = distinct !DILexicalBlock(scope: !154, file: !18, line: 98, column: 5)
!206 = !DILocation(line: 98, column: 14, scope: !205)
!207 = !DILocation(line: 98, column: 10, scope: !205)
!208 = !DILocation(line: 98, column: 21, scope: !209)
!209 = distinct !DILexicalBlock(scope: !205, file: !18, line: 98, column: 5)
!210 = !DILocation(line: 98, column: 23, scope: !209)
!211 = !DILocation(line: 98, column: 5, scope: !205)
!212 = !DILocation(line: 99, column: 24, scope: !209)
!213 = !DILocation(line: 99, column: 22, scope: !209)
!214 = !DILocation(line: 99, column: 9, scope: !209)
!215 = !DILocation(line: 98, column: 36, scope: !209)
!216 = !DILocation(line: 98, column: 5, scope: !209)
!217 = distinct !{!217, !211, !218, !72}
!218 = !DILocation(line: 99, column: 29, scope: !205)
!219 = !DILocation(line: 101, column: 5, scope: !154)
!220 = !DILocation(line: 102, column: 5, scope: !154)
