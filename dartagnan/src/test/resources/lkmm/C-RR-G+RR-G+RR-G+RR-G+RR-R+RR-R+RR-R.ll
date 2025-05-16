; ModuleID = 'benchmarks/lkmm/C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c'
source_filename = "benchmarks/lkmm/C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x0 = dso_local global i32 0, align 4, !dbg !0
@r1_1 = dso_local global i32 0, align 4, !dbg !58
@x1 = dso_local global i32 0, align 4, !dbg !46
@r2_1 = dso_local global i32 0, align 4, !dbg !60
@r1_2 = dso_local global i32 0, align 4, !dbg !62
@x2 = dso_local global i32 0, align 4, !dbg !48
@r2_2 = dso_local global i32 0, align 4, !dbg !64
@r1_3 = dso_local global i32 0, align 4, !dbg !66
@x3 = dso_local global i32 0, align 4, !dbg !50
@r2_3 = dso_local global i32 0, align 4, !dbg !68
@r1_4 = dso_local global i32 0, align 4, !dbg !70
@x4 = dso_local global i32 0, align 4, !dbg !52
@r2_4 = dso_local global i32 0, align 4, !dbg !72
@r1_5 = dso_local global i32 0, align 4, !dbg !74
@x5 = dso_local global i32 0, align 4, !dbg !54
@r2_5 = dso_local global i32 0, align 4, !dbg !76
@r1_6 = dso_local global i32 0, align 4, !dbg !78
@x6 = dso_local global i32 0, align 4, !dbg !56
@r2_6 = dso_local global i32 0, align 4, !dbg !80
@r1_7 = dso_local global i32 0, align 4, !dbg !82
@r2_7 = dso_local global i32 0, align 4, !dbg !84
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@.str = private unnamed_addr constant [39 x i8] c"C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [184 x i8] c"!((r2_7 == 0 && r1_1 == 1 && r2_1 == 0 && r1_2 == 1 && r2_2 == 0 && r1_3 == 1 && r2_3 == 0 && r1_4 == 1 && r2_4 == 0 && r1_5 == 1 && r2_5 == 0 && r1_6 == 1 && r2_6 == 0 && r1_7 == 1))\00", align 1, !dbg !41

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !94 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !98, !DIExpression(), !99)
  %3 = call i64 @__LKMM_load(ptr noundef @x0, i64 noundef 4, i32 noundef 1), !dbg !100
  %4 = trunc i64 %3 to i32, !dbg !100
  store i32 %4, ptr @r1_1, align 4, !dbg !101
  call void @__LKMM_fence(i32 noundef 9), !dbg !102
  %5 = call i64 @__LKMM_load(ptr noundef @x1, i64 noundef 4, i32 noundef 1), !dbg !103
  %6 = trunc i64 %5 to i32, !dbg !103
  store i32 %6, ptr @r2_1, align 4, !dbg !104
  ret ptr null, !dbg !105
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_fence(i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !106 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !107, !DIExpression(), !108)
  %3 = call i64 @__LKMM_load(ptr noundef @x1, i64 noundef 4, i32 noundef 1), !dbg !109
  %4 = trunc i64 %3 to i32, !dbg !109
  store i32 %4, ptr @r1_2, align 4, !dbg !110
  call void @__LKMM_fence(i32 noundef 9), !dbg !111
  %5 = call i64 @__LKMM_load(ptr noundef @x2, i64 noundef 4, i32 noundef 1), !dbg !112
  %6 = trunc i64 %5 to i32, !dbg !112
  store i32 %6, ptr @r2_2, align 4, !dbg !113
  ret ptr null, !dbg !114
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_3(ptr noundef %0) #0 !dbg !115 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !116, !DIExpression(), !117)
  %3 = call i64 @__LKMM_load(ptr noundef @x2, i64 noundef 4, i32 noundef 1), !dbg !118
  %4 = trunc i64 %3 to i32, !dbg !118
  store i32 %4, ptr @r1_3, align 4, !dbg !119
  call void @__LKMM_fence(i32 noundef 9), !dbg !120
  %5 = call i64 @__LKMM_load(ptr noundef @x3, i64 noundef 4, i32 noundef 1), !dbg !121
  %6 = trunc i64 %5 to i32, !dbg !121
  store i32 %6, ptr @r2_3, align 4, !dbg !122
  ret ptr null, !dbg !123
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_4(ptr noundef %0) #0 !dbg !124 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !125, !DIExpression(), !126)
  %3 = call i64 @__LKMM_load(ptr noundef @x3, i64 noundef 4, i32 noundef 1), !dbg !127
  %4 = trunc i64 %3 to i32, !dbg !127
  store i32 %4, ptr @r1_4, align 4, !dbg !128
  call void @__LKMM_fence(i32 noundef 9), !dbg !129
  %5 = call i64 @__LKMM_load(ptr noundef @x4, i64 noundef 4, i32 noundef 1), !dbg !130
  %6 = trunc i64 %5 to i32, !dbg !130
  store i32 %6, ptr @r2_4, align 4, !dbg !131
  ret ptr null, !dbg !132
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_5(ptr noundef %0) #0 !dbg !133 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !134, !DIExpression(), !135)
  call void @__LKMM_fence(i32 noundef 7), !dbg !136
  %3 = call i64 @__LKMM_load(ptr noundef @x4, i64 noundef 4, i32 noundef 1), !dbg !137
  %4 = trunc i64 %3 to i32, !dbg !137
  store i32 %4, ptr @r1_5, align 4, !dbg !138
  %5 = call i64 @__LKMM_load(ptr noundef @x5, i64 noundef 4, i32 noundef 1), !dbg !139
  %6 = trunc i64 %5 to i32, !dbg !139
  store i32 %6, ptr @r2_5, align 4, !dbg !140
  call void @__LKMM_fence(i32 noundef 8), !dbg !141
  ret ptr null, !dbg !142
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_6(ptr noundef %0) #0 !dbg !143 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !144, !DIExpression(), !145)
  call void @__LKMM_fence(i32 noundef 7), !dbg !146
  %3 = call i64 @__LKMM_load(ptr noundef @x5, i64 noundef 4, i32 noundef 1), !dbg !147
  %4 = trunc i64 %3 to i32, !dbg !147
  store i32 %4, ptr @r1_6, align 4, !dbg !148
  %5 = call i64 @__LKMM_load(ptr noundef @x6, i64 noundef 4, i32 noundef 1), !dbg !149
  %6 = trunc i64 %5 to i32, !dbg !149
  store i32 %6, ptr @r2_6, align 4, !dbg !150
  call void @__LKMM_fence(i32 noundef 8), !dbg !151
  ret ptr null, !dbg !152
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_7(ptr noundef %0) #0 !dbg !153 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !154, !DIExpression(), !155)
  call void @__LKMM_fence(i32 noundef 7), !dbg !156
  %3 = call i64 @__LKMM_load(ptr noundef @x6, i64 noundef 4, i32 noundef 1), !dbg !157
  %4 = trunc i64 %3 to i32, !dbg !157
  store i32 %4, ptr @r1_7, align 4, !dbg !158
  %5 = call i64 @__LKMM_load(ptr noundef @x0, i64 noundef 4, i32 noundef 1), !dbg !159
  %6 = trunc i64 %5 to i32, !dbg !159
  store i32 %6, ptr @r2_7, align 4, !dbg !160
  call void @__LKMM_fence(i32 noundef 8), !dbg !161
  ret ptr null, !dbg !162
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_8(ptr noundef %0) #0 !dbg !163 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !164, !DIExpression(), !165)
  call void @__LKMM_store(ptr noundef @x0, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !166
  call void @__LKMM_store(ptr noundef @x1, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !167
  call void @__LKMM_store(ptr noundef @x2, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !168
  call void @__LKMM_store(ptr noundef @x3, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !169
  call void @__LKMM_store(ptr noundef @x4, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !170
  call void @__LKMM_store(ptr noundef @x5, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !171
  call void @__LKMM_store(ptr noundef @x6, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !172
  ret ptr null, !dbg !173
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !174 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !177, !DIExpression(), !201)
    #dbg_declare(ptr %3, !202, !DIExpression(), !203)
    #dbg_declare(ptr %4, !204, !DIExpression(), !205)
    #dbg_declare(ptr %5, !206, !DIExpression(), !207)
    #dbg_declare(ptr %6, !208, !DIExpression(), !209)
    #dbg_declare(ptr %7, !210, !DIExpression(), !211)
    #dbg_declare(ptr %8, !212, !DIExpression(), !213)
    #dbg_declare(ptr %9, !214, !DIExpression(), !215)
  %10 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !216
  %11 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !217
  %12 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @thread_3, ptr noundef null), !dbg !218
  %13 = call i32 @pthread_create(ptr noundef %5, ptr noundef null, ptr noundef @thread_4, ptr noundef null), !dbg !219
  %14 = call i32 @pthread_create(ptr noundef %6, ptr noundef null, ptr noundef @thread_5, ptr noundef null), !dbg !220
  %15 = call i32 @pthread_create(ptr noundef %7, ptr noundef null, ptr noundef @thread_6, ptr noundef null), !dbg !221
  %16 = call i32 @pthread_create(ptr noundef %8, ptr noundef null, ptr noundef @thread_7, ptr noundef null), !dbg !222
  %17 = call i32 @pthread_create(ptr noundef %9, ptr noundef null, ptr noundef @thread_8, ptr noundef null), !dbg !223
  %18 = load ptr, ptr %2, align 8, !dbg !224
  %19 = call i32 @_pthread_join(ptr noundef %18, ptr noundef null), !dbg !225
  %20 = load ptr, ptr %3, align 8, !dbg !226
  %21 = call i32 @_pthread_join(ptr noundef %20, ptr noundef null), !dbg !227
  %22 = load ptr, ptr %4, align 8, !dbg !228
  %23 = call i32 @_pthread_join(ptr noundef %22, ptr noundef null), !dbg !229
  %24 = load ptr, ptr %5, align 8, !dbg !230
  %25 = call i32 @_pthread_join(ptr noundef %24, ptr noundef null), !dbg !231
  %26 = load ptr, ptr %6, align 8, !dbg !232
  %27 = call i32 @_pthread_join(ptr noundef %26, ptr noundef null), !dbg !233
  %28 = load ptr, ptr %7, align 8, !dbg !234
  %29 = call i32 @_pthread_join(ptr noundef %28, ptr noundef null), !dbg !235
  %30 = load ptr, ptr %8, align 8, !dbg !236
  %31 = call i32 @_pthread_join(ptr noundef %30, ptr noundef null), !dbg !237
  %32 = load ptr, ptr %9, align 8, !dbg !238
  %33 = call i32 @_pthread_join(ptr noundef %32, ptr noundef null), !dbg !239
  %34 = load i32, ptr @r2_7, align 4, !dbg !240
  %35 = icmp eq i32 %34, 0, !dbg !240
  br i1 %35, label %36, label %75, !dbg !240

36:                                               ; preds = %0
  %37 = load i32, ptr @r1_1, align 4, !dbg !240
  %38 = icmp eq i32 %37, 1, !dbg !240
  br i1 %38, label %39, label %75, !dbg !240

39:                                               ; preds = %36
  %40 = load i32, ptr @r2_1, align 4, !dbg !240
  %41 = icmp eq i32 %40, 0, !dbg !240
  br i1 %41, label %42, label %75, !dbg !240

42:                                               ; preds = %39
  %43 = load i32, ptr @r1_2, align 4, !dbg !240
  %44 = icmp eq i32 %43, 1, !dbg !240
  br i1 %44, label %45, label %75, !dbg !240

45:                                               ; preds = %42
  %46 = load i32, ptr @r2_2, align 4, !dbg !240
  %47 = icmp eq i32 %46, 0, !dbg !240
  br i1 %47, label %48, label %75, !dbg !240

48:                                               ; preds = %45
  %49 = load i32, ptr @r1_3, align 4, !dbg !240
  %50 = icmp eq i32 %49, 1, !dbg !240
  br i1 %50, label %51, label %75, !dbg !240

51:                                               ; preds = %48
  %52 = load i32, ptr @r2_3, align 4, !dbg !240
  %53 = icmp eq i32 %52, 0, !dbg !240
  br i1 %53, label %54, label %75, !dbg !240

54:                                               ; preds = %51
  %55 = load i32, ptr @r1_4, align 4, !dbg !240
  %56 = icmp eq i32 %55, 1, !dbg !240
  br i1 %56, label %57, label %75, !dbg !240

57:                                               ; preds = %54
  %58 = load i32, ptr @r2_4, align 4, !dbg !240
  %59 = icmp eq i32 %58, 0, !dbg !240
  br i1 %59, label %60, label %75, !dbg !240

60:                                               ; preds = %57
  %61 = load i32, ptr @r1_5, align 4, !dbg !240
  %62 = icmp eq i32 %61, 1, !dbg !240
  br i1 %62, label %63, label %75, !dbg !240

63:                                               ; preds = %60
  %64 = load i32, ptr @r2_5, align 4, !dbg !240
  %65 = icmp eq i32 %64, 0, !dbg !240
  br i1 %65, label %66, label %75, !dbg !240

66:                                               ; preds = %63
  %67 = load i32, ptr @r1_6, align 4, !dbg !240
  %68 = icmp eq i32 %67, 1, !dbg !240
  br i1 %68, label %69, label %75, !dbg !240

69:                                               ; preds = %66
  %70 = load i32, ptr @r2_6, align 4, !dbg !240
  %71 = icmp eq i32 %70, 0, !dbg !240
  br i1 %71, label %72, label %75, !dbg !240

72:                                               ; preds = %69
  %73 = load i32, ptr @r1_7, align 4, !dbg !240
  %74 = icmp eq i32 %73, 1, !dbg !240
  br label %75

75:                                               ; preds = %72, %69, %66, %63, %60, %57, %54, %51, %48, %45, %42, %39, %36, %0
  %76 = phi i1 [ false, %69 ], [ false, %66 ], [ false, %63 ], [ false, %60 ], [ false, %57 ], [ false, %54 ], [ false, %51 ], [ false, %48 ], [ false, %45 ], [ false, %42 ], [ false, %39 ], [ false, %36 ], [ false, %0 ], [ %74, %72 ], !dbg !241
  %77 = xor i1 %76, true, !dbg !240
  %78 = xor i1 %77, true, !dbg !240
  %79 = zext i1 %78 to i32, !dbg !240
  %80 = sext i32 %79 to i64, !dbg !240
  %81 = icmp ne i64 %80, 0, !dbg !240
  br i1 %81, label %82, label %84, !dbg !240

82:                                               ; preds = %75
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 98, ptr noundef @.str.1) #3, !dbg !240
  unreachable, !dbg !240

83:                                               ; No predecessors!
  br label %85, !dbg !240

84:                                               ; preds = %75
  br label %85, !dbg !240

85:                                               ; preds = %84, %83
  ret i32 0, !dbg !242
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @_pthread_join(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!86, !87, !88, !89, !90, !91, !92}
!llvm.ident = !{!93}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x0", scope: !2, file: !3, line: 7, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "dbafb2cd139d33a606f4c8b7719d2341")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "27b8121cb2c90fe5c99c4b3e89c9755e")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22}
!9 = !DIEnumerator(name: "__LKMM_relaxed", value: 0)
!10 = !DIEnumerator(name: "__LKMM_once", value: 1)
!11 = !DIEnumerator(name: "__LKMM_acquire", value: 2)
!12 = !DIEnumerator(name: "__LKMM_release", value: 3)
!13 = !DIEnumerator(name: "__LKMM_mb", value: 4)
!14 = !DIEnumerator(name: "__LKMM_wmb", value: 5)
!15 = !DIEnumerator(name: "__LKMM_rmb", value: 6)
!16 = !DIEnumerator(name: "__LKMM_rcu_lock", value: 7)
!17 = !DIEnumerator(name: "__LKMM_rcu_unlock", value: 8)
!18 = !DIEnumerator(name: "__LKMM_rcu_sync", value: 9)
!19 = !DIEnumerator(name: "__LKMM_before_atomic", value: 10)
!20 = !DIEnumerator(name: "__LKMM_after_atomic", value: 11)
!21 = !DIEnumerator(name: "__LKMM_after_spinlock", value: 12)
!22 = !DIEnumerator(name: "__LKMM_barrier", value: 13)
!23 = !{!24, !25, !26}
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !27)
!27 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!28 = !{!29, !36, !41, !0, !46, !48, !50, !52, !54, !56, !58, !60, !62, !64, !66, !68, !70, !72, !74, !76, !78, !80, !82, !84}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 98, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 40, elements: !34)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!33 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!34 = !{!35}
!35 = !DISubrange(count: 5)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 98, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 312, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 39)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !3, line: 98, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 1472, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 184)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "x1", scope: !2, file: !3, line: 7, type: !24, isLocal: false, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "x2", scope: !2, file: !3, line: 7, type: !24, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "x3", scope: !2, file: !3, line: 7, type: !24, isLocal: false, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "x4", scope: !2, file: !3, line: 7, type: !24, isLocal: false, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "x5", scope: !2, file: !3, line: 7, type: !24, isLocal: false, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "x6", scope: !2, file: !3, line: 7, type: !24, isLocal: false, isDefinition: true)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "r1_1", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "r2_1", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "r1_2", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!64 = !DIGlobalVariableExpression(var: !65, expr: !DIExpression())
!65 = distinct !DIGlobalVariable(name: "r2_2", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(name: "r1_3", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(name: "r2_3", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(name: "r1_4", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!72 = !DIGlobalVariableExpression(var: !73, expr: !DIExpression())
!73 = distinct !DIGlobalVariable(name: "r2_4", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!74 = !DIGlobalVariableExpression(var: !75, expr: !DIExpression())
!75 = distinct !DIGlobalVariable(name: "r1_5", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!76 = !DIGlobalVariableExpression(var: !77, expr: !DIExpression())
!77 = distinct !DIGlobalVariable(name: "r2_5", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!78 = !DIGlobalVariableExpression(var: !79, expr: !DIExpression())
!79 = distinct !DIGlobalVariable(name: "r1_6", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!80 = !DIGlobalVariableExpression(var: !81, expr: !DIExpression())
!81 = distinct !DIGlobalVariable(name: "r2_6", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!82 = !DIGlobalVariableExpression(var: !83, expr: !DIExpression())
!83 = distinct !DIGlobalVariable(name: "r1_7", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!84 = !DIGlobalVariableExpression(var: !85, expr: !DIExpression())
!85 = distinct !DIGlobalVariable(name: "r2_7", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!86 = !{i32 7, !"Dwarf Version", i32 5}
!87 = !{i32 2, !"Debug Info Version", i32 3}
!88 = !{i32 1, !"wchar_size", i32 4}
!89 = !{i32 8, !"PIC Level", i32 2}
!90 = !{i32 7, !"PIE Level", i32 2}
!91 = !{i32 7, !"uwtable", i32 2}
!92 = !{i32 7, !"frame-pointer", i32 2}
!93 = !{!"Homebrew clang version 19.1.7"}
!94 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 10, type: !95, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !97)
!95 = !DISubroutineType(types: !96)
!96 = !{!25, !25}
!97 = !{}
!98 = !DILocalVariable(name: "arg", arg: 1, scope: !94, file: !3, line: 10, type: !25)
!99 = !DILocation(line: 10, column: 22, scope: !94)
!100 = !DILocation(line: 11, column: 9, scope: !94)
!101 = !DILocation(line: 11, column: 7, scope: !94)
!102 = !DILocation(line: 12, column: 2, scope: !94)
!103 = !DILocation(line: 13, column: 9, scope: !94)
!104 = !DILocation(line: 13, column: 7, scope: !94)
!105 = !DILocation(line: 14, column: 2, scope: !94)
!106 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 17, type: !95, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !97)
!107 = !DILocalVariable(name: "arg", arg: 1, scope: !106, file: !3, line: 17, type: !25)
!108 = !DILocation(line: 17, column: 22, scope: !106)
!109 = !DILocation(line: 18, column: 9, scope: !106)
!110 = !DILocation(line: 18, column: 7, scope: !106)
!111 = !DILocation(line: 19, column: 2, scope: !106)
!112 = !DILocation(line: 20, column: 9, scope: !106)
!113 = !DILocation(line: 20, column: 7, scope: !106)
!114 = !DILocation(line: 21, column: 2, scope: !106)
!115 = distinct !DISubprogram(name: "thread_3", scope: !3, file: !3, line: 24, type: !95, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !97)
!116 = !DILocalVariable(name: "arg", arg: 1, scope: !115, file: !3, line: 24, type: !25)
!117 = !DILocation(line: 24, column: 22, scope: !115)
!118 = !DILocation(line: 25, column: 9, scope: !115)
!119 = !DILocation(line: 25, column: 7, scope: !115)
!120 = !DILocation(line: 26, column: 2, scope: !115)
!121 = !DILocation(line: 27, column: 9, scope: !115)
!122 = !DILocation(line: 27, column: 7, scope: !115)
!123 = !DILocation(line: 28, column: 2, scope: !115)
!124 = distinct !DISubprogram(name: "thread_4", scope: !3, file: !3, line: 31, type: !95, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !97)
!125 = !DILocalVariable(name: "arg", arg: 1, scope: !124, file: !3, line: 31, type: !25)
!126 = !DILocation(line: 31, column: 22, scope: !124)
!127 = !DILocation(line: 32, column: 9, scope: !124)
!128 = !DILocation(line: 32, column: 7, scope: !124)
!129 = !DILocation(line: 33, column: 2, scope: !124)
!130 = !DILocation(line: 34, column: 9, scope: !124)
!131 = !DILocation(line: 34, column: 7, scope: !124)
!132 = !DILocation(line: 35, column: 2, scope: !124)
!133 = distinct !DISubprogram(name: "thread_5", scope: !3, file: !3, line: 38, type: !95, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !97)
!134 = !DILocalVariable(name: "arg", arg: 1, scope: !133, file: !3, line: 38, type: !25)
!135 = !DILocation(line: 38, column: 22, scope: !133)
!136 = !DILocation(line: 39, column: 2, scope: !133)
!137 = !DILocation(line: 40, column: 9, scope: !133)
!138 = !DILocation(line: 40, column: 7, scope: !133)
!139 = !DILocation(line: 41, column: 9, scope: !133)
!140 = !DILocation(line: 41, column: 7, scope: !133)
!141 = !DILocation(line: 42, column: 2, scope: !133)
!142 = !DILocation(line: 43, column: 2, scope: !133)
!143 = distinct !DISubprogram(name: "thread_6", scope: !3, file: !3, line: 46, type: !95, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !97)
!144 = !DILocalVariable(name: "arg", arg: 1, scope: !143, file: !3, line: 46, type: !25)
!145 = !DILocation(line: 46, column: 22, scope: !143)
!146 = !DILocation(line: 47, column: 2, scope: !143)
!147 = !DILocation(line: 48, column: 9, scope: !143)
!148 = !DILocation(line: 48, column: 7, scope: !143)
!149 = !DILocation(line: 49, column: 9, scope: !143)
!150 = !DILocation(line: 49, column: 7, scope: !143)
!151 = !DILocation(line: 50, column: 2, scope: !143)
!152 = !DILocation(line: 51, column: 2, scope: !143)
!153 = distinct !DISubprogram(name: "thread_7", scope: !3, file: !3, line: 54, type: !95, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !97)
!154 = !DILocalVariable(name: "arg", arg: 1, scope: !153, file: !3, line: 54, type: !25)
!155 = !DILocation(line: 54, column: 22, scope: !153)
!156 = !DILocation(line: 55, column: 2, scope: !153)
!157 = !DILocation(line: 56, column: 9, scope: !153)
!158 = !DILocation(line: 56, column: 7, scope: !153)
!159 = !DILocation(line: 57, column: 9, scope: !153)
!160 = !DILocation(line: 57, column: 7, scope: !153)
!161 = !DILocation(line: 58, column: 2, scope: !153)
!162 = !DILocation(line: 59, column: 2, scope: !153)
!163 = distinct !DISubprogram(name: "thread_8", scope: !3, file: !3, line: 62, type: !95, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !97)
!164 = !DILocalVariable(name: "arg", arg: 1, scope: !163, file: !3, line: 62, type: !25)
!165 = !DILocation(line: 62, column: 22, scope: !163)
!166 = !DILocation(line: 63, column: 2, scope: !163)
!167 = !DILocation(line: 64, column: 2, scope: !163)
!168 = !DILocation(line: 65, column: 2, scope: !163)
!169 = !DILocation(line: 66, column: 2, scope: !163)
!170 = !DILocation(line: 67, column: 2, scope: !163)
!171 = !DILocation(line: 68, column: 2, scope: !163)
!172 = !DILocation(line: 69, column: 2, scope: !163)
!173 = !DILocation(line: 70, column: 2, scope: !163)
!174 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 73, type: !175, scopeLine: 74, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !97)
!175 = !DISubroutineType(types: !176)
!176 = !{!24}
!177 = !DILocalVariable(name: "t1", scope: !174, file: !3, line: 78, type: !178)
!178 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !179, line: 31, baseType: !180)
!179 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!180 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !181, line: 118, baseType: !182)
!181 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!182 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !183, size: 64)
!183 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !181, line: 103, size: 65536, elements: !184)
!184 = !{!185, !187, !197}
!185 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !183, file: !181, line: 104, baseType: !186, size: 64)
!186 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!187 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !183, file: !181, line: 105, baseType: !188, size: 64, offset: 64)
!188 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !189, size: 64)
!189 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !181, line: 57, size: 192, elements: !190)
!190 = !{!191, !195, !196}
!191 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !189, file: !181, line: 58, baseType: !192, size: 64)
!192 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !193, size: 64)
!193 = !DISubroutineType(types: !194)
!194 = !{null, !25}
!195 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !189, file: !181, line: 59, baseType: !25, size: 64, offset: 64)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !189, file: !181, line: 60, baseType: !188, size: 64, offset: 128)
!197 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !183, file: !181, line: 106, baseType: !198, size: 65408, offset: 128)
!198 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !199)
!199 = !{!200}
!200 = !DISubrange(count: 8176)
!201 = !DILocation(line: 78, column: 15, scope: !174)
!202 = !DILocalVariable(name: "t2", scope: !174, file: !3, line: 78, type: !178)
!203 = !DILocation(line: 78, column: 19, scope: !174)
!204 = !DILocalVariable(name: "t3", scope: !174, file: !3, line: 78, type: !178)
!205 = !DILocation(line: 78, column: 23, scope: !174)
!206 = !DILocalVariable(name: "t4", scope: !174, file: !3, line: 78, type: !178)
!207 = !DILocation(line: 78, column: 27, scope: !174)
!208 = !DILocalVariable(name: "t5", scope: !174, file: !3, line: 78, type: !178)
!209 = !DILocation(line: 78, column: 31, scope: !174)
!210 = !DILocalVariable(name: "t6", scope: !174, file: !3, line: 78, type: !178)
!211 = !DILocation(line: 78, column: 35, scope: !174)
!212 = !DILocalVariable(name: "t7", scope: !174, file: !3, line: 78, type: !178)
!213 = !DILocation(line: 78, column: 39, scope: !174)
!214 = !DILocalVariable(name: "t8", scope: !174, file: !3, line: 78, type: !178)
!215 = !DILocation(line: 78, column: 43, scope: !174)
!216 = !DILocation(line: 80, column: 2, scope: !174)
!217 = !DILocation(line: 81, column: 2, scope: !174)
!218 = !DILocation(line: 82, column: 2, scope: !174)
!219 = !DILocation(line: 83, column: 2, scope: !174)
!220 = !DILocation(line: 84, column: 2, scope: !174)
!221 = !DILocation(line: 85, column: 2, scope: !174)
!222 = !DILocation(line: 86, column: 2, scope: !174)
!223 = !DILocation(line: 87, column: 2, scope: !174)
!224 = !DILocation(line: 89, column: 15, scope: !174)
!225 = !DILocation(line: 89, column: 2, scope: !174)
!226 = !DILocation(line: 90, column: 15, scope: !174)
!227 = !DILocation(line: 90, column: 2, scope: !174)
!228 = !DILocation(line: 91, column: 15, scope: !174)
!229 = !DILocation(line: 91, column: 2, scope: !174)
!230 = !DILocation(line: 92, column: 15, scope: !174)
!231 = !DILocation(line: 92, column: 2, scope: !174)
!232 = !DILocation(line: 93, column: 15, scope: !174)
!233 = !DILocation(line: 93, column: 2, scope: !174)
!234 = !DILocation(line: 94, column: 15, scope: !174)
!235 = !DILocation(line: 94, column: 2, scope: !174)
!236 = !DILocation(line: 95, column: 15, scope: !174)
!237 = !DILocation(line: 95, column: 2, scope: !174)
!238 = !DILocation(line: 96, column: 15, scope: !174)
!239 = !DILocation(line: 96, column: 2, scope: !174)
!240 = !DILocation(line: 98, column: 2, scope: !174)
!241 = !DILocation(line: 0, scope: !174)
!242 = !DILocation(line: 100, column: 2, scope: !174)
