; ModuleID = '/Users/r/git/dat3m/z_out/lockref2.ll'
source_filename = "/Users/r/git/dat3m/benchmarks/mixed/lockref2.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx14.0.0"

%struct.lockref = type { %union.anon }
%union.anon = type { i64 }
%struct.spinlock_s = type { i32 }
%struct.anon = type { %struct.spinlock_s, i32 }

@my_lockref = global %struct.lockref zeroinitializer, align 8, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !25
@.str = private unnamed_addr constant [11 x i8] c"lockref2.c\00", align 1, !dbg !33
@.str.1 = private unnamed_addr constant [29 x i8] c"my_lockref.count == NTHREADS\00", align 1, !dbg !38

; Function Attrs: noinline nounwind ssp uwtable
define void @await_for_lock(ptr noundef %0) #0 !dbg !70 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !75, metadata !DIExpression()), !dbg !76
  br label %4, !dbg !77

4:                                                ; preds = %10, %1
  %5 = load ptr, ptr %2, align 8, !dbg !78
  %6 = getelementptr inbounds %struct.spinlock_s, ptr %5, i32 0, i32 0, !dbg !79
  %7 = load atomic i32, ptr %6 monotonic, align 4, !dbg !80
  store i32 %7, ptr %3, align 4, !dbg !80
  %8 = load i32, ptr %3, align 4, !dbg !80
  %9 = icmp ne i32 %8, 0, !dbg !81
  br i1 %9, label %10, label %11, !dbg !77

10:                                               ; preds = %4
  br label %4, !dbg !77, !llvm.loop !82

11:                                               ; preds = %4
  ret void, !dbg !85
}

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i32 @try_get_lock(ptr noundef %0) #0 !dbg !86 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !89, metadata !DIExpression()), !dbg !90
  call void @llvm.dbg.declare(metadata ptr %3, metadata !91, metadata !DIExpression()), !dbg !92
  store i32 0, ptr %3, align 4, !dbg !92
  %6 = load ptr, ptr %2, align 8, !dbg !93
  %7 = getelementptr inbounds %struct.spinlock_s, ptr %6, i32 0, i32 0, !dbg !94
  store i32 1, ptr %4, align 4, !dbg !95
  %8 = load i32, ptr %3, align 4, !dbg !95
  %9 = load i32, ptr %4, align 4, !dbg !95
  %10 = cmpxchg ptr %7, i32 %8, i32 %9 acquire acquire, align 4, !dbg !95
  %11 = extractvalue { i32, i1 } %10, 0, !dbg !95
  %12 = extractvalue { i32, i1 } %10, 1, !dbg !95
  br i1 %12, label %14, label %13, !dbg !95

13:                                               ; preds = %1
  store i32 %11, ptr %3, align 4, !dbg !95
  br label %14, !dbg !95

14:                                               ; preds = %13, %1
  %15 = zext i1 %12 to i8, !dbg !95
  store i8 %15, ptr %5, align 1, !dbg !95
  %16 = load i8, ptr %5, align 1, !dbg !95
  %17 = trunc i8 %16 to i1, !dbg !95
  %18 = zext i1 %17 to i32, !dbg !95
  ret i32 %18, !dbg !96
}

; Function Attrs: noinline nounwind ssp uwtable
define void @spin_lock(ptr noundef %0) #0 !dbg !97 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !98, metadata !DIExpression()), !dbg !99
  br label %3, !dbg !100

3:                                                ; preds = %5, %1
  %4 = load ptr, ptr %2, align 8, !dbg !101
  call void @await_for_lock(ptr noundef %4), !dbg !103
  br label %5, !dbg !104

5:                                                ; preds = %3
  %6 = load ptr, ptr %2, align 8, !dbg !105
  %7 = call i32 @try_get_lock(ptr noundef %6), !dbg !106
  %8 = icmp ne i32 %7, 0, !dbg !107
  %9 = xor i1 %8, true, !dbg !107
  br i1 %9, label %3, label %10, !dbg !104, !llvm.loop !108

10:                                               ; preds = %5
  ret void, !dbg !110
}

; Function Attrs: noinline nounwind ssp uwtable
define void @spin_unlock(ptr noundef %0) #0 !dbg !111 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !112, metadata !DIExpression()), !dbg !113
  %4 = load ptr, ptr %2, align 8, !dbg !114
  %5 = getelementptr inbounds %struct.spinlock_s, ptr %4, i32 0, i32 0, !dbg !115
  store i32 0, ptr %3, align 4, !dbg !116
  %6 = load i32, ptr %3, align 4, !dbg !116
  store atomic i32 %6, ptr %5 release, align 4, !dbg !116
  ret void, !dbg !117
}

; Function Attrs: noinline nounwind ssp uwtable
define void @lockref_get(ptr noundef %0) #0 !dbg !118 {
  %2 = alloca ptr, align 8
  %3 = alloca %struct.lockref, align 8
  %4 = alloca i64, align 8
  %5 = alloca %struct.lockref, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !122, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.declare(metadata ptr %3, metadata !124, metadata !DIExpression()), !dbg !125
  %8 = load ptr, ptr %2, align 8, !dbg !126
  %9 = getelementptr inbounds %struct.lockref, ptr %8, i32 0, i32 0, !dbg !127
  %10 = load atomic i64, ptr %9 monotonic, align 8, !dbg !128
  store i64 %10, ptr %4, align 8, !dbg !128
  %11 = load i64, ptr %4, align 8, !dbg !128
  %12 = getelementptr inbounds %struct.lockref, ptr %3, i32 0, i32 0, !dbg !129
  store atomic i64 %11, ptr %12 seq_cst, align 8, !dbg !130
  br label %13, !dbg !131

13:                                               ; preds = %39, %1
  %14 = getelementptr inbounds %struct.lockref, ptr %3, i32 0, i32 0, !dbg !132
  %15 = getelementptr inbounds %struct.anon, ptr %14, i32 0, i32 0, !dbg !132
  %16 = getelementptr inbounds %struct.spinlock_s, ptr %15, i32 0, i32 0, !dbg !133
  %17 = load atomic i32, ptr %16 seq_cst, align 4, !dbg !133
  %18 = icmp eq i32 %17, 0, !dbg !134
  br i1 %18, label %19, label %40, !dbg !131

19:                                               ; preds = %13
  call void @llvm.dbg.declare(metadata ptr %5, metadata !135, metadata !DIExpression()), !dbg !137
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %5, ptr align 8 %3, i64 8, i1 false), !dbg !138
  %20 = getelementptr inbounds %struct.lockref, ptr %5, i32 0, i32 0, !dbg !139
  %21 = getelementptr inbounds %struct.anon, ptr %20, i32 0, i32 1, !dbg !139
  %22 = atomicrmw add ptr %21, i32 1 seq_cst, align 4, !dbg !140
  %23 = load ptr, ptr %2, align 8, !dbg !141
  %24 = getelementptr inbounds %struct.lockref, ptr %23, i32 0, i32 0, !dbg !143
  %25 = getelementptr inbounds %struct.lockref, ptr %3, i32 0, i32 0, !dbg !144
  %26 = getelementptr inbounds %struct.lockref, ptr %5, i32 0, i32 0, !dbg !145
  %27 = load atomic i64, ptr %26 seq_cst, align 8, !dbg !145
  store i64 %27, ptr %6, align 8, !dbg !146
  %28 = load i64, ptr %25, align 8, !dbg !146
  %29 = load i64, ptr %6, align 8, !dbg !146
  %30 = cmpxchg ptr %24, i64 %28, i64 %29 monotonic monotonic, align 8, !dbg !146
  %31 = extractvalue { i64, i1 } %30, 0, !dbg !146
  %32 = extractvalue { i64, i1 } %30, 1, !dbg !146
  br i1 %32, label %34, label %33, !dbg !146

33:                                               ; preds = %19
  store i64 %31, ptr %25, align 8, !dbg !146
  br label %34, !dbg !146

34:                                               ; preds = %33, %19
  %35 = zext i1 %32 to i8, !dbg !146
  store i8 %35, ptr %7, align 1, !dbg !146
  %36 = load i8, ptr %7, align 1, !dbg !146
  %37 = trunc i8 %36 to i1, !dbg !146
  br i1 %37, label %38, label %39, !dbg !147

38:                                               ; preds = %34
  br label %51, !dbg !148

39:                                               ; preds = %34
  br label %13, !dbg !131, !llvm.loop !150

40:                                               ; preds = %13
  %41 = load ptr, ptr %2, align 8, !dbg !152
  %42 = getelementptr inbounds %struct.lockref, ptr %41, i32 0, i32 0, !dbg !153
  %43 = getelementptr inbounds %struct.anon, ptr %42, i32 0, i32 0, !dbg !153
  call void @spin_lock(ptr noundef %43), !dbg !154
  %44 = load ptr, ptr %2, align 8, !dbg !155
  %45 = getelementptr inbounds %struct.lockref, ptr %44, i32 0, i32 0, !dbg !156
  %46 = getelementptr inbounds %struct.anon, ptr %45, i32 0, i32 1, !dbg !156
  %47 = atomicrmw add ptr %46, i32 1 seq_cst, align 4, !dbg !157
  %48 = load ptr, ptr %2, align 8, !dbg !158
  %49 = getelementptr inbounds %struct.lockref, ptr %48, i32 0, i32 0, !dbg !159
  %50 = getelementptr inbounds %struct.anon, ptr %49, i32 0, i32 0, !dbg !159
  call void @spin_unlock(ptr noundef %50), !dbg !160
  br label %51, !dbg !161

51:                                               ; preds = %40, %38
  ret void, !dbg !161
}

; Function Attrs: argmemonly nocallback nofree nounwind willreturn
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: noinline nounwind ssp uwtable
define ptr @thread_n(ptr noundef %0) #0 !dbg !162 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !165, metadata !DIExpression()), !dbg !166
  call void @lockref_get(ptr noundef @my_lockref), !dbg !167
  ret ptr null, !dbg !168
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !169 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 16
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !172, metadata !DIExpression()), !dbg !199
  store i64 0, ptr %3, align 8, !dbg !200
  %6 = load i64, ptr %3, align 8, !dbg !200
  store atomic i64 %6, ptr @my_lockref seq_cst, align 8, !dbg !200
  call void @llvm.dbg.declare(metadata ptr %4, metadata !201, metadata !DIExpression()), !dbg !203
  store i32 0, ptr %4, align 4, !dbg !203
  br label %7, !dbg !204

7:                                                ; preds = %18, %0
  %8 = load i32, ptr %4, align 4, !dbg !205
  %9 = icmp slt i32 %8, 3, !dbg !207
  br i1 %9, label %10, label %21, !dbg !208

10:                                               ; preds = %7
  %11 = load i32, ptr %4, align 4, !dbg !209
  %12 = sext i32 %11 to i64, !dbg !210
  %13 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %12, !dbg !210
  %14 = load i32, ptr %4, align 4, !dbg !211
  %15 = sext i32 %14 to i64, !dbg !212
  %16 = inttoptr i64 %15 to ptr, !dbg !213
  %17 = call i32 @pthread_create(ptr noundef %13, ptr noundef null, ptr noundef @thread_n, ptr noundef %16), !dbg !214
  br label %18, !dbg !214

18:                                               ; preds = %10
  %19 = load i32, ptr %4, align 4, !dbg !215
  %20 = add nsw i32 %19, 1, !dbg !215
  store i32 %20, ptr %4, align 4, !dbg !215
  br label %7, !dbg !216, !llvm.loop !217

21:                                               ; preds = %7
  call void @llvm.dbg.declare(metadata ptr %5, metadata !219, metadata !DIExpression()), !dbg !221
  store i32 0, ptr %5, align 4, !dbg !221
  br label %22, !dbg !222

22:                                               ; preds = %31, %21
  %23 = load i32, ptr %5, align 4, !dbg !223
  %24 = icmp slt i32 %23, 3, !dbg !225
  br i1 %24, label %25, label %34, !dbg !226

25:                                               ; preds = %22
  %26 = load i32, ptr %5, align 4, !dbg !227
  %27 = sext i32 %26 to i64, !dbg !228
  %28 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %27, !dbg !228
  %29 = load ptr, ptr %28, align 8, !dbg !228
  %30 = call i32 @"\01_pthread_join"(ptr noundef %29, ptr noundef null), !dbg !229
  br label %31, !dbg !229

31:                                               ; preds = %25
  %32 = load i32, ptr %5, align 4, !dbg !230
  %33 = add nsw i32 %32, 1, !dbg !230
  store i32 %33, ptr %5, align 4, !dbg !230
  br label %22, !dbg !231, !llvm.loop !232

34:                                               ; preds = %22
  %35 = load atomic i32, ptr getelementptr inbounds (%struct.anon, ptr @my_lockref, i32 0, i32 1) seq_cst, align 4, !dbg !234
  %36 = icmp eq i32 %35, 3, !dbg !234
  %37 = xor i1 %36, true, !dbg !234
  %38 = zext i1 %37 to i32, !dbg !234
  %39 = sext i32 %38 to i64, !dbg !234
  %40 = icmp ne i64 %39, 0, !dbg !234
  br i1 %40, label %41, label %43, !dbg !234

41:                                               ; preds = %34
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 99, ptr noundef @.str.1) #5, !dbg !234
  unreachable, !dbg !234

42:                                               ; No predecessors!
  br label %44, !dbg !234

43:                                               ; preds = %34
  br label %44, !dbg !234

44:                                               ; preds = %43, %42
  ret i32 0, !dbg !235
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #3

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #4

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nocallback nofree nounwind willreturn }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #4 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #5 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!63, !64, !65, !66, !67, !68}
!llvm.ident = !{!69}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "my_lockref", scope: !2, file: !27, line: 78, type: !43, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 15.0.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !24, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk", sdk: "MacOSX14.sdk")
!3 = !DIFile(filename: "/Users/r/git/dat3m/benchmarks/mixed/lockref2.c", directory: "/Users/r/git/dat3m")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 57, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: ".local/universal/llvm-15.0.7/lib/clang/15.0.7/include/stdatomic.h", directory: "/Users/r")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16, !20, !21}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !18, line: 30, baseType: !19)
!18 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/sys/_types/_int64_t.h", directory: "")
!19 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !22, line: 46, baseType: !23)
!22 = !DIFile(filename: ".local/universal/llvm-15.0.7/lib/clang/15.0.7/include/stddef.h", directory: "/Users/r")
!23 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!24 = !{!25, !33, !38, !0}
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(scope: null, file: !27, line: 99, type: !28, isLocal: true, isDefinition: true)
!27 = !DIFile(filename: "benchmarks/mixed/lockref2.c", directory: "/Users/r/git/dat3m")
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !29, size: 40, elements: !31)
!29 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !30)
!30 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!31 = !{!32}
!32 = !DISubrange(count: 5)
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(scope: null, file: !27, line: 99, type: !35, isLocal: true, isDefinition: true)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 88, elements: !36)
!36 = !{!37}
!37 = !DISubrange(count: 11)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !27, line: 99, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 232, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 29)
!43 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "lockref", file: !27, line: 47, size: 64, elements: !44)
!44 = !{!45}
!45 = !DIDerivedType(tag: DW_TAG_member, scope: !43, file: !27, line: 48, baseType: !46, size: 64)
!46 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !43, file: !27, line: 48, size: 64, elements: !47)
!47 = !{!48, !50}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "lock_count", scope: !46, file: !27, line: 49, baseType: !49, size: 64)
!49 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !17)
!50 = !DIDerivedType(tag: DW_TAG_member, scope: !46, file: !27, line: 50, baseType: !51, size: 64)
!51 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !46, file: !27, line: 50, size: 64, elements: !52)
!52 = !{!53, !62}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !51, file: !27, line: 51, baseType: !54, size: 32)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "spinlock_t", file: !27, line: 16, baseType: !55)
!55 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "spinlock_s", file: !27, line: 13, size: 32, elements: !56)
!56 = !{!57}
!57 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !55, file: !27, line: 14, baseType: !58, size: 32)
!58 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !59)
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !60, line: 30, baseType: !61)
!60 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/sys/_types/_int32_t.h", directory: "")
!61 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !51, file: !27, line: 52, baseType: !58, size: 32, offset: 32)
!63 = !{i32 7, !"Dwarf Version", i32 4}
!64 = !{i32 2, !"Debug Info Version", i32 3}
!65 = !{i32 1, !"wchar_size", i32 4}
!66 = !{i32 7, !"PIC Level", i32 2}
!67 = !{i32 7, !"uwtable", i32 2}
!68 = !{i32 7, !"frame-pointer", i32 2}
!69 = !{!"Homebrew clang version 15.0.7"}
!70 = distinct !DISubprogram(name: "await_for_lock", scope: !27, file: !27, line: 18, type: !71, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!71 = !DISubroutineType(types: !72)
!72 = !{null, !73}
!73 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !55, size: 64)
!74 = !{}
!75 = !DILocalVariable(name: "l", arg: 1, scope: !70, file: !27, line: 18, type: !73)
!76 = !DILocation(line: 18, column: 40, scope: !70)
!77 = !DILocation(line: 20, column: 5, scope: !70)
!78 = !DILocation(line: 20, column: 34, scope: !70)
!79 = !DILocation(line: 20, column: 37, scope: !70)
!80 = !DILocation(line: 20, column: 12, scope: !70)
!81 = !DILocation(line: 20, column: 65, scope: !70)
!82 = distinct !{!82, !77, !83, !84}
!83 = !DILocation(line: 20, column: 70, scope: !70)
!84 = !{!"llvm.loop.mustprogress"}
!85 = !DILocation(line: 21, column: 5, scope: !70)
!86 = distinct !DISubprogram(name: "try_get_lock", scope: !27, file: !27, line: 24, type: !87, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!87 = !DISubroutineType(types: !88)
!88 = !{!61, !73}
!89 = !DILocalVariable(name: "l", arg: 1, scope: !86, file: !27, line: 24, type: !73)
!90 = !DILocation(line: 24, column: 37, scope: !86)
!91 = !DILocalVariable(name: "val", scope: !86, file: !27, line: 26, type: !61)
!92 = !DILocation(line: 26, column: 9, scope: !86)
!93 = !DILocation(line: 27, column: 53, scope: !86)
!94 = !DILocation(line: 27, column: 56, scope: !86)
!95 = !DILocation(line: 27, column: 12, scope: !86)
!96 = !DILocation(line: 27, column: 5, scope: !86)
!97 = distinct !DISubprogram(name: "spin_lock", scope: !27, file: !27, line: 30, type: !71, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!98 = !DILocalVariable(name: "l", arg: 1, scope: !97, file: !27, line: 30, type: !73)
!99 = !DILocation(line: 30, column: 35, scope: !97)
!100 = !DILocation(line: 32, column: 5, scope: !97)
!101 = !DILocation(line: 33, column: 24, scope: !102)
!102 = distinct !DILexicalBlock(scope: !97, file: !27, line: 32, column: 8)
!103 = !DILocation(line: 33, column: 9, scope: !102)
!104 = !DILocation(line: 34, column: 5, scope: !102)
!105 = !DILocation(line: 34, column: 27, scope: !97)
!106 = !DILocation(line: 34, column: 14, scope: !97)
!107 = !DILocation(line: 34, column: 13, scope: !97)
!108 = distinct !{!108, !100, !109, !84}
!109 = !DILocation(line: 34, column: 29, scope: !97)
!110 = !DILocation(line: 35, column: 5, scope: !97)
!111 = distinct !DISubprogram(name: "spin_unlock", scope: !27, file: !27, line: 38, type: !71, scopeLine: 39, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!112 = !DILocalVariable(name: "l", arg: 1, scope: !111, file: !27, line: 38, type: !73)
!113 = !DILocation(line: 38, column: 37, scope: !111)
!114 = !DILocation(line: 40, column: 28, scope: !111)
!115 = !DILocation(line: 40, column: 31, scope: !111)
!116 = !DILocation(line: 40, column: 5, scope: !111)
!117 = !DILocation(line: 41, column: 1, scope: !111)
!118 = distinct !DISubprogram(name: "lockref_get", scope: !27, file: !27, line: 57, type: !119, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!119 = !DISubroutineType(types: !120)
!120 = !{null, !121}
!121 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!122 = !DILocalVariable(name: "lockref", arg: 1, scope: !118, file: !27, line: 57, type: !121)
!123 = !DILocation(line: 57, column: 34, scope: !118)
!124 = !DILocalVariable(name: "old", scope: !118, file: !27, line: 58, type: !43)
!125 = !DILocation(line: 58, column: 20, scope: !118)
!126 = !DILocation(line: 60, column: 44, scope: !118)
!127 = !DILocation(line: 60, column: 53, scope: !118)
!128 = !DILocation(line: 60, column: 22, scope: !118)
!129 = !DILocation(line: 60, column: 9, scope: !118)
!130 = !DILocation(line: 60, column: 20, scope: !118)
!131 = !DILocation(line: 61, column: 5, scope: !118)
!132 = !DILocation(line: 61, column: 16, scope: !118)
!133 = !DILocation(line: 61, column: 21, scope: !118)
!134 = !DILocation(line: 61, column: 26, scope: !118)
!135 = !DILocalVariable(name: "new", scope: !136, file: !27, line: 62, type: !43)
!136 = distinct !DILexicalBlock(scope: !118, file: !27, line: 61, column: 32)
!137 = !DILocation(line: 62, column: 24, scope: !136)
!138 = !DILocation(line: 62, column: 30, scope: !136)
!139 = !DILocation(line: 63, column: 13, scope: !136)
!140 = !DILocation(line: 63, column: 18, scope: !136)
!141 = !DILocation(line: 64, column: 54, scope: !142)
!142 = distinct !DILexicalBlock(scope: !136, file: !27, line: 64, column: 13)
!143 = !DILocation(line: 64, column: 63, scope: !142)
!144 = !DILocation(line: 64, column: 92, scope: !142)
!145 = !DILocation(line: 64, column: 108, scope: !142)
!146 = !DILocation(line: 64, column: 13, scope: !142)
!147 = !DILocation(line: 64, column: 13, scope: !136)
!148 = !DILocation(line: 65, column: 13, scope: !149)
!149 = distinct !DILexicalBlock(scope: !142, file: !27, line: 64, column: 165)
!150 = distinct !{!150, !131, !151, !84}
!151 = !DILocation(line: 67, column: 5, scope: !118)
!152 = !DILocation(line: 69, column: 16, scope: !118)
!153 = !DILocation(line: 69, column: 25, scope: !118)
!154 = !DILocation(line: 69, column: 5, scope: !118)
!155 = !DILocation(line: 70, column: 5, scope: !118)
!156 = !DILocation(line: 70, column: 14, scope: !118)
!157 = !DILocation(line: 70, column: 19, scope: !118)
!158 = !DILocation(line: 71, column: 18, scope: !118)
!159 = !DILocation(line: 71, column: 27, scope: !118)
!160 = !DILocation(line: 71, column: 5, scope: !118)
!161 = !DILocation(line: 72, column: 1, scope: !118)
!162 = distinct !DISubprogram(name: "thread_n", scope: !27, file: !27, line: 80, type: !163, scopeLine: 80, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!163 = !DISubroutineType(types: !164)
!164 = !{!20, !20}
!165 = !DILocalVariable(name: "unsued", arg: 1, scope: !162, file: !27, line: 80, type: !20)
!166 = !DILocation(line: 80, column: 22, scope: !162)
!167 = !DILocation(line: 82, column: 5, scope: !162)
!168 = !DILocation(line: 84, column: 5, scope: !162)
!169 = distinct !DISubprogram(name: "main", scope: !27, file: !27, line: 87, type: !170, scopeLine: 87, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!170 = !DISubroutineType(types: !171)
!171 = !{!61}
!172 = !DILocalVariable(name: "t", scope: !169, file: !27, line: 89, type: !173)
!173 = !DICompositeType(tag: DW_TAG_array_type, baseType: !174, size: 192, elements: !197)
!174 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !175, line: 31, baseType: !176)
!175 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!176 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !177, line: 118, baseType: !178)
!177 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!178 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !179, size: 64)
!179 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !177, line: 103, size: 65536, elements: !180)
!180 = !{!181, !183, !193}
!181 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !179, file: !177, line: 104, baseType: !182, size: 64)
!182 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !179, file: !177, line: 105, baseType: !184, size: 64, offset: 64)
!184 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !185, size: 64)
!185 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !177, line: 57, size: 192, elements: !186)
!186 = !{!187, !191, !192}
!187 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !185, file: !177, line: 58, baseType: !188, size: 64)
!188 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !189, size: 64)
!189 = !DISubroutineType(types: !190)
!190 = !{null, !20}
!191 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !185, file: !177, line: 59, baseType: !20, size: 64, offset: 64)
!192 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !185, file: !177, line: 60, baseType: !184, size: 64, offset: 128)
!193 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !179, file: !177, line: 106, baseType: !194, size: 65408, offset: 128)
!194 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 65408, elements: !195)
!195 = !{!196}
!196 = !DISubrange(count: 8176)
!197 = !{!198}
!198 = !DISubrange(count: 3)
!199 = !DILocation(line: 89, column: 15, scope: !169)
!200 = !DILocation(line: 91, column: 5, scope: !169)
!201 = !DILocalVariable(name: "i", scope: !202, file: !27, line: 93, type: !61)
!202 = distinct !DILexicalBlock(scope: !169, file: !27, line: 93, column: 5)
!203 = !DILocation(line: 93, column: 14, scope: !202)
!204 = !DILocation(line: 93, column: 10, scope: !202)
!205 = !DILocation(line: 93, column: 21, scope: !206)
!206 = distinct !DILexicalBlock(scope: !202, file: !27, line: 93, column: 5)
!207 = !DILocation(line: 93, column: 23, scope: !206)
!208 = !DILocation(line: 93, column: 5, scope: !202)
!209 = !DILocation(line: 94, column: 27, scope: !206)
!210 = !DILocation(line: 94, column: 25, scope: !206)
!211 = !DILocation(line: 94, column: 60, scope: !206)
!212 = !DILocation(line: 94, column: 52, scope: !206)
!213 = !DILocation(line: 94, column: 44, scope: !206)
!214 = !DILocation(line: 94, column: 9, scope: !206)
!215 = !DILocation(line: 93, column: 36, scope: !206)
!216 = !DILocation(line: 93, column: 5, scope: !206)
!217 = distinct !{!217, !208, !218, !84}
!218 = !DILocation(line: 94, column: 61, scope: !202)
!219 = !DILocalVariable(name: "i", scope: !220, file: !27, line: 96, type: !61)
!220 = distinct !DILexicalBlock(scope: !169, file: !27, line: 96, column: 5)
!221 = !DILocation(line: 96, column: 14, scope: !220)
!222 = !DILocation(line: 96, column: 10, scope: !220)
!223 = !DILocation(line: 96, column: 21, scope: !224)
!224 = distinct !DILexicalBlock(scope: !220, file: !27, line: 96, column: 5)
!225 = !DILocation(line: 96, column: 23, scope: !224)
!226 = !DILocation(line: 96, column: 5, scope: !220)
!227 = !DILocation(line: 97, column: 24, scope: !224)
!228 = !DILocation(line: 97, column: 22, scope: !224)
!229 = !DILocation(line: 97, column: 9, scope: !224)
!230 = !DILocation(line: 96, column: 36, scope: !224)
!231 = !DILocation(line: 96, column: 5, scope: !224)
!232 = distinct !{!232, !226, !233, !84}
!233 = !DILocation(line: 97, column: 29, scope: !220)
!234 = !DILocation(line: 99, column: 5, scope: !169)
!235 = !DILocation(line: 100, column: 5, scope: !169)
