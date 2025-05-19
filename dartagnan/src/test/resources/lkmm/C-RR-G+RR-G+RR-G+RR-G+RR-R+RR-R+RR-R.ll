; ModuleID = 'benchmarks/lkmm/C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c'
source_filename = "benchmarks/lkmm/C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x0 = dso_local global i32 0, align 4, !dbg !0
@r1_1 = dso_local global i32 0, align 4, !dbg !60
@x1 = dso_local global i32 0, align 4, !dbg !48
@r2_1 = dso_local global i32 0, align 4, !dbg !62
@r1_2 = dso_local global i32 0, align 4, !dbg !64
@x2 = dso_local global i32 0, align 4, !dbg !50
@r2_2 = dso_local global i32 0, align 4, !dbg !66
@r1_3 = dso_local global i32 0, align 4, !dbg !68
@x3 = dso_local global i32 0, align 4, !dbg !52
@r2_3 = dso_local global i32 0, align 4, !dbg !70
@r1_4 = dso_local global i32 0, align 4, !dbg !72
@x4 = dso_local global i32 0, align 4, !dbg !54
@r2_4 = dso_local global i32 0, align 4, !dbg !74
@r1_5 = dso_local global i32 0, align 4, !dbg !76
@x5 = dso_local global i32 0, align 4, !dbg !56
@r2_5 = dso_local global i32 0, align 4, !dbg !78
@r1_6 = dso_local global i32 0, align 4, !dbg !80
@x6 = dso_local global i32 0, align 4, !dbg !58
@r2_6 = dso_local global i32 0, align 4, !dbg !82
@r1_7 = dso_local global i32 0, align 4, !dbg !84
@r2_7 = dso_local global i32 0, align 4, !dbg !86
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !31
@.str = private unnamed_addr constant [39 x i8] c"C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c\00", align 1, !dbg !38
@.str.1 = private unnamed_addr constant [184 x i8] c"!((r2_7 == 0 && r1_1 == 1 && r2_1 == 0 && r1_2 == 1 && r2_2 == 0 && r1_3 == 1 && r2_3 == 0 && r1_4 == 1 && r2_4 == 0 && r1_5 == 1 && r2_5 == 0 && r1_6 == 1 && r2_6 == 0 && r1_7 == 1))\00", align 1, !dbg !43

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !96 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !100, !DIExpression(), !101)
  %3 = call i64 @__LKMM_load(ptr noundef @x0, i64 noundef 4, i32 noundef 1), !dbg !102
  %4 = trunc i64 %3 to i32, !dbg !102
  store i32 %4, ptr @r1_1, align 4, !dbg !103
  call void @__LKMM_fence(i32 noundef 9), !dbg !104
  %5 = call i64 @__LKMM_load(ptr noundef @x1, i64 noundef 4, i32 noundef 1), !dbg !105
  %6 = trunc i64 %5 to i32, !dbg !105
  store i32 %6, ptr @r2_1, align 4, !dbg !106
  ret ptr null, !dbg !107
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_fence(i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !108 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !109, !DIExpression(), !110)
  %3 = call i64 @__LKMM_load(ptr noundef @x1, i64 noundef 4, i32 noundef 1), !dbg !111
  %4 = trunc i64 %3 to i32, !dbg !111
  store i32 %4, ptr @r1_2, align 4, !dbg !112
  call void @__LKMM_fence(i32 noundef 9), !dbg !113
  %5 = call i64 @__LKMM_load(ptr noundef @x2, i64 noundef 4, i32 noundef 1), !dbg !114
  %6 = trunc i64 %5 to i32, !dbg !114
  store i32 %6, ptr @r2_2, align 4, !dbg !115
  ret ptr null, !dbg !116
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_3(ptr noundef %0) #0 !dbg !117 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !118, !DIExpression(), !119)
  %3 = call i64 @__LKMM_load(ptr noundef @x2, i64 noundef 4, i32 noundef 1), !dbg !120
  %4 = trunc i64 %3 to i32, !dbg !120
  store i32 %4, ptr @r1_3, align 4, !dbg !121
  call void @__LKMM_fence(i32 noundef 9), !dbg !122
  %5 = call i64 @__LKMM_load(ptr noundef @x3, i64 noundef 4, i32 noundef 1), !dbg !123
  %6 = trunc i64 %5 to i32, !dbg !123
  store i32 %6, ptr @r2_3, align 4, !dbg !124
  ret ptr null, !dbg !125
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_4(ptr noundef %0) #0 !dbg !126 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !127, !DIExpression(), !128)
  %3 = call i64 @__LKMM_load(ptr noundef @x3, i64 noundef 4, i32 noundef 1), !dbg !129
  %4 = trunc i64 %3 to i32, !dbg !129
  store i32 %4, ptr @r1_4, align 4, !dbg !130
  call void @__LKMM_fence(i32 noundef 9), !dbg !131
  %5 = call i64 @__LKMM_load(ptr noundef @x4, i64 noundef 4, i32 noundef 1), !dbg !132
  %6 = trunc i64 %5 to i32, !dbg !132
  store i32 %6, ptr @r2_4, align 4, !dbg !133
  ret ptr null, !dbg !134
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_5(ptr noundef %0) #0 !dbg !135 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !136, !DIExpression(), !137)
  call void @__LKMM_fence(i32 noundef 7), !dbg !138
  %3 = call i64 @__LKMM_load(ptr noundef @x4, i64 noundef 4, i32 noundef 1), !dbg !139
  %4 = trunc i64 %3 to i32, !dbg !139
  store i32 %4, ptr @r1_5, align 4, !dbg !140
  %5 = call i64 @__LKMM_load(ptr noundef @x5, i64 noundef 4, i32 noundef 1), !dbg !141
  %6 = trunc i64 %5 to i32, !dbg !141
  store i32 %6, ptr @r2_5, align 4, !dbg !142
  call void @__LKMM_fence(i32 noundef 8), !dbg !143
  ret ptr null, !dbg !144
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_6(ptr noundef %0) #0 !dbg !145 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !146, !DIExpression(), !147)
  call void @__LKMM_fence(i32 noundef 7), !dbg !148
  %3 = call i64 @__LKMM_load(ptr noundef @x5, i64 noundef 4, i32 noundef 1), !dbg !149
  %4 = trunc i64 %3 to i32, !dbg !149
  store i32 %4, ptr @r1_6, align 4, !dbg !150
  %5 = call i64 @__LKMM_load(ptr noundef @x6, i64 noundef 4, i32 noundef 1), !dbg !151
  %6 = trunc i64 %5 to i32, !dbg !151
  store i32 %6, ptr @r2_6, align 4, !dbg !152
  call void @__LKMM_fence(i32 noundef 8), !dbg !153
  ret ptr null, !dbg !154
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_7(ptr noundef %0) #0 !dbg !155 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !156, !DIExpression(), !157)
  call void @__LKMM_fence(i32 noundef 7), !dbg !158
  %3 = call i64 @__LKMM_load(ptr noundef @x6, i64 noundef 4, i32 noundef 1), !dbg !159
  %4 = trunc i64 %3 to i32, !dbg !159
  store i32 %4, ptr @r1_7, align 4, !dbg !160
  %5 = call i64 @__LKMM_load(ptr noundef @x0, i64 noundef 4, i32 noundef 1), !dbg !161
  %6 = trunc i64 %5 to i32, !dbg !161
  store i32 %6, ptr @r2_7, align 4, !dbg !162
  call void @__LKMM_fence(i32 noundef 8), !dbg !163
  ret ptr null, !dbg !164
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_8(ptr noundef %0) #0 !dbg !165 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !166, !DIExpression(), !167)
  call void @__LKMM_store(ptr noundef @x0, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !168
  call void @__LKMM_store(ptr noundef @x1, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !169
  call void @__LKMM_store(ptr noundef @x2, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !170
  call void @__LKMM_store(ptr noundef @x3, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !171
  call void @__LKMM_store(ptr noundef @x4, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !172
  call void @__LKMM_store(ptr noundef @x5, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !173
  call void @__LKMM_store(ptr noundef @x6, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !174
  ret ptr null, !dbg !175
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !176 {
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
    #dbg_declare(ptr %2, !179, !DIExpression(), !202)
    #dbg_declare(ptr %3, !203, !DIExpression(), !204)
    #dbg_declare(ptr %4, !205, !DIExpression(), !206)
    #dbg_declare(ptr %5, !207, !DIExpression(), !208)
    #dbg_declare(ptr %6, !209, !DIExpression(), !210)
    #dbg_declare(ptr %7, !211, !DIExpression(), !212)
    #dbg_declare(ptr %8, !213, !DIExpression(), !214)
    #dbg_declare(ptr %9, !215, !DIExpression(), !216)
  %10 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !217
  %11 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !218
  %12 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @thread_3, ptr noundef null), !dbg !219
  %13 = call i32 @pthread_create(ptr noundef %5, ptr noundef null, ptr noundef @thread_4, ptr noundef null), !dbg !220
  %14 = call i32 @pthread_create(ptr noundef %6, ptr noundef null, ptr noundef @thread_5, ptr noundef null), !dbg !221
  %15 = call i32 @pthread_create(ptr noundef %7, ptr noundef null, ptr noundef @thread_6, ptr noundef null), !dbg !222
  %16 = call i32 @pthread_create(ptr noundef %8, ptr noundef null, ptr noundef @thread_7, ptr noundef null), !dbg !223
  %17 = call i32 @pthread_create(ptr noundef %9, ptr noundef null, ptr noundef @thread_8, ptr noundef null), !dbg !224
  %18 = load ptr, ptr %2, align 8, !dbg !225
  %19 = call i32 @_pthread_join(ptr noundef %18, ptr noundef null), !dbg !226
  %20 = load ptr, ptr %3, align 8, !dbg !227
  %21 = call i32 @_pthread_join(ptr noundef %20, ptr noundef null), !dbg !228
  %22 = load ptr, ptr %4, align 8, !dbg !229
  %23 = call i32 @_pthread_join(ptr noundef %22, ptr noundef null), !dbg !230
  %24 = load ptr, ptr %5, align 8, !dbg !231
  %25 = call i32 @_pthread_join(ptr noundef %24, ptr noundef null), !dbg !232
  %26 = load ptr, ptr %6, align 8, !dbg !233
  %27 = call i32 @_pthread_join(ptr noundef %26, ptr noundef null), !dbg !234
  %28 = load ptr, ptr %7, align 8, !dbg !235
  %29 = call i32 @_pthread_join(ptr noundef %28, ptr noundef null), !dbg !236
  %30 = load ptr, ptr %8, align 8, !dbg !237
  %31 = call i32 @_pthread_join(ptr noundef %30, ptr noundef null), !dbg !238
  %32 = load ptr, ptr %9, align 8, !dbg !239
  %33 = call i32 @_pthread_join(ptr noundef %32, ptr noundef null), !dbg !240
  %34 = load i32, ptr @r2_7, align 4, !dbg !241
  %35 = icmp eq i32 %34, 0, !dbg !241
  br i1 %35, label %36, label %75, !dbg !241

36:                                               ; preds = %0
  %37 = load i32, ptr @r1_1, align 4, !dbg !241
  %38 = icmp eq i32 %37, 1, !dbg !241
  br i1 %38, label %39, label %75, !dbg !241

39:                                               ; preds = %36
  %40 = load i32, ptr @r2_1, align 4, !dbg !241
  %41 = icmp eq i32 %40, 0, !dbg !241
  br i1 %41, label %42, label %75, !dbg !241

42:                                               ; preds = %39
  %43 = load i32, ptr @r1_2, align 4, !dbg !241
  %44 = icmp eq i32 %43, 1, !dbg !241
  br i1 %44, label %45, label %75, !dbg !241

45:                                               ; preds = %42
  %46 = load i32, ptr @r2_2, align 4, !dbg !241
  %47 = icmp eq i32 %46, 0, !dbg !241
  br i1 %47, label %48, label %75, !dbg !241

48:                                               ; preds = %45
  %49 = load i32, ptr @r1_3, align 4, !dbg !241
  %50 = icmp eq i32 %49, 1, !dbg !241
  br i1 %50, label %51, label %75, !dbg !241

51:                                               ; preds = %48
  %52 = load i32, ptr @r2_3, align 4, !dbg !241
  %53 = icmp eq i32 %52, 0, !dbg !241
  br i1 %53, label %54, label %75, !dbg !241

54:                                               ; preds = %51
  %55 = load i32, ptr @r1_4, align 4, !dbg !241
  %56 = icmp eq i32 %55, 1, !dbg !241
  br i1 %56, label %57, label %75, !dbg !241

57:                                               ; preds = %54
  %58 = load i32, ptr @r2_4, align 4, !dbg !241
  %59 = icmp eq i32 %58, 0, !dbg !241
  br i1 %59, label %60, label %75, !dbg !241

60:                                               ; preds = %57
  %61 = load i32, ptr @r1_5, align 4, !dbg !241
  %62 = icmp eq i32 %61, 1, !dbg !241
  br i1 %62, label %63, label %75, !dbg !241

63:                                               ; preds = %60
  %64 = load i32, ptr @r2_5, align 4, !dbg !241
  %65 = icmp eq i32 %64, 0, !dbg !241
  br i1 %65, label %66, label %75, !dbg !241

66:                                               ; preds = %63
  %67 = load i32, ptr @r1_6, align 4, !dbg !241
  %68 = icmp eq i32 %67, 1, !dbg !241
  br i1 %68, label %69, label %75, !dbg !241

69:                                               ; preds = %66
  %70 = load i32, ptr @r2_6, align 4, !dbg !241
  %71 = icmp eq i32 %70, 0, !dbg !241
  br i1 %71, label %72, label %75, !dbg !241

72:                                               ; preds = %69
  %73 = load i32, ptr @r1_7, align 4, !dbg !241
  %74 = icmp eq i32 %73, 1, !dbg !241
  br label %75

75:                                               ; preds = %72, %69, %66, %63, %60, %57, %54, %51, %48, %45, %42, %39, %36, %0
  %76 = phi i1 [ false, %69 ], [ false, %66 ], [ false, %63 ], [ false, %60 ], [ false, %57 ], [ false, %54 ], [ false, %51 ], [ false, %48 ], [ false, %45 ], [ false, %42 ], [ false, %39 ], [ false, %36 ], [ false, %0 ], [ %74, %72 ], !dbg !242
  %77 = xor i1 %76, true, !dbg !241
  %78 = xor i1 %77, true, !dbg !241
  %79 = zext i1 %78 to i32, !dbg !241
  %80 = sext i32 %79 to i64, !dbg !241
  %81 = icmp ne i64 %80, 0, !dbg !241
  br i1 %81, label %82, label %84, !dbg !241

82:                                               ; preds = %75
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 98, ptr noundef @.str.1) #3, !dbg !241
  unreachable, !dbg !241

83:                                               ; No predecessors!
  br label %85, !dbg !241

84:                                               ; preds = %75
  br label %85, !dbg !241

85:                                               ; preds = %84, %83
  ret i32 0, !dbg !243
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
!llvm.module.flags = !{!88, !89, !90, !91, !92, !93, !94}
!llvm.ident = !{!95}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x0", scope: !2, file: !3, line: 7, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !30, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "dbafb2cd139d33a606f4c8b7719d2341")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "09faa2df2f4b7a5b710a8844ff483434")
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
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !28, line: 32, baseType: !29)
!28 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!29 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!30 = !{!31, !38, !43, !0, !48, !50, !52, !54, !56, !58, !60, !62, !64, !66, !68, !70, !72, !74, !76, !78, !80, !82, !84, !86}
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 98, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 40, elements: !36)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !35)
!35 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!36 = !{!37}
!37 = !DISubrange(count: 5)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !3, line: 98, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 312, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 39)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !3, line: 98, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 1472, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 184)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "x1", scope: !2, file: !3, line: 7, type: !24, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "x2", scope: !2, file: !3, line: 7, type: !24, isLocal: false, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "x3", scope: !2, file: !3, line: 7, type: !24, isLocal: false, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "x4", scope: !2, file: !3, line: 7, type: !24, isLocal: false, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "x5", scope: !2, file: !3, line: 7, type: !24, isLocal: false, isDefinition: true)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "x6", scope: !2, file: !3, line: 7, type: !24, isLocal: false, isDefinition: true)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "r1_1", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "r2_1", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!64 = !DIGlobalVariableExpression(var: !65, expr: !DIExpression())
!65 = distinct !DIGlobalVariable(name: "r1_2", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(name: "r2_2", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(name: "r1_3", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(name: "r2_3", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!72 = !DIGlobalVariableExpression(var: !73, expr: !DIExpression())
!73 = distinct !DIGlobalVariable(name: "r1_4", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!74 = !DIGlobalVariableExpression(var: !75, expr: !DIExpression())
!75 = distinct !DIGlobalVariable(name: "r2_4", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!76 = !DIGlobalVariableExpression(var: !77, expr: !DIExpression())
!77 = distinct !DIGlobalVariable(name: "r1_5", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!78 = !DIGlobalVariableExpression(var: !79, expr: !DIExpression())
!79 = distinct !DIGlobalVariable(name: "r2_5", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!80 = !DIGlobalVariableExpression(var: !81, expr: !DIExpression())
!81 = distinct !DIGlobalVariable(name: "r1_6", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!82 = !DIGlobalVariableExpression(var: !83, expr: !DIExpression())
!83 = distinct !DIGlobalVariable(name: "r2_6", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!84 = !DIGlobalVariableExpression(var: !85, expr: !DIExpression())
!85 = distinct !DIGlobalVariable(name: "r1_7", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!86 = !DIGlobalVariableExpression(var: !87, expr: !DIExpression())
!87 = distinct !DIGlobalVariable(name: "r2_7", scope: !2, file: !3, line: 8, type: !24, isLocal: false, isDefinition: true)
!88 = !{i32 7, !"Dwarf Version", i32 5}
!89 = !{i32 2, !"Debug Info Version", i32 3}
!90 = !{i32 1, !"wchar_size", i32 4}
!91 = !{i32 8, !"PIC Level", i32 2}
!92 = !{i32 7, !"PIE Level", i32 2}
!93 = !{i32 7, !"uwtable", i32 2}
!94 = !{i32 7, !"frame-pointer", i32 2}
!95 = !{!"Homebrew clang version 19.1.7"}
!96 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 10, type: !97, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !99)
!97 = !DISubroutineType(types: !98)
!98 = !{!25, !25}
!99 = !{}
!100 = !DILocalVariable(name: "arg", arg: 1, scope: !96, file: !3, line: 10, type: !25)
!101 = !DILocation(line: 10, column: 22, scope: !96)
!102 = !DILocation(line: 11, column: 9, scope: !96)
!103 = !DILocation(line: 11, column: 7, scope: !96)
!104 = !DILocation(line: 12, column: 2, scope: !96)
!105 = !DILocation(line: 13, column: 9, scope: !96)
!106 = !DILocation(line: 13, column: 7, scope: !96)
!107 = !DILocation(line: 14, column: 2, scope: !96)
!108 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 17, type: !97, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !99)
!109 = !DILocalVariable(name: "arg", arg: 1, scope: !108, file: !3, line: 17, type: !25)
!110 = !DILocation(line: 17, column: 22, scope: !108)
!111 = !DILocation(line: 18, column: 9, scope: !108)
!112 = !DILocation(line: 18, column: 7, scope: !108)
!113 = !DILocation(line: 19, column: 2, scope: !108)
!114 = !DILocation(line: 20, column: 9, scope: !108)
!115 = !DILocation(line: 20, column: 7, scope: !108)
!116 = !DILocation(line: 21, column: 2, scope: !108)
!117 = distinct !DISubprogram(name: "thread_3", scope: !3, file: !3, line: 24, type: !97, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !99)
!118 = !DILocalVariable(name: "arg", arg: 1, scope: !117, file: !3, line: 24, type: !25)
!119 = !DILocation(line: 24, column: 22, scope: !117)
!120 = !DILocation(line: 25, column: 9, scope: !117)
!121 = !DILocation(line: 25, column: 7, scope: !117)
!122 = !DILocation(line: 26, column: 2, scope: !117)
!123 = !DILocation(line: 27, column: 9, scope: !117)
!124 = !DILocation(line: 27, column: 7, scope: !117)
!125 = !DILocation(line: 28, column: 2, scope: !117)
!126 = distinct !DISubprogram(name: "thread_4", scope: !3, file: !3, line: 31, type: !97, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !99)
!127 = !DILocalVariable(name: "arg", arg: 1, scope: !126, file: !3, line: 31, type: !25)
!128 = !DILocation(line: 31, column: 22, scope: !126)
!129 = !DILocation(line: 32, column: 9, scope: !126)
!130 = !DILocation(line: 32, column: 7, scope: !126)
!131 = !DILocation(line: 33, column: 2, scope: !126)
!132 = !DILocation(line: 34, column: 9, scope: !126)
!133 = !DILocation(line: 34, column: 7, scope: !126)
!134 = !DILocation(line: 35, column: 2, scope: !126)
!135 = distinct !DISubprogram(name: "thread_5", scope: !3, file: !3, line: 38, type: !97, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !99)
!136 = !DILocalVariable(name: "arg", arg: 1, scope: !135, file: !3, line: 38, type: !25)
!137 = !DILocation(line: 38, column: 22, scope: !135)
!138 = !DILocation(line: 39, column: 2, scope: !135)
!139 = !DILocation(line: 40, column: 9, scope: !135)
!140 = !DILocation(line: 40, column: 7, scope: !135)
!141 = !DILocation(line: 41, column: 9, scope: !135)
!142 = !DILocation(line: 41, column: 7, scope: !135)
!143 = !DILocation(line: 42, column: 2, scope: !135)
!144 = !DILocation(line: 43, column: 2, scope: !135)
!145 = distinct !DISubprogram(name: "thread_6", scope: !3, file: !3, line: 46, type: !97, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !99)
!146 = !DILocalVariable(name: "arg", arg: 1, scope: !145, file: !3, line: 46, type: !25)
!147 = !DILocation(line: 46, column: 22, scope: !145)
!148 = !DILocation(line: 47, column: 2, scope: !145)
!149 = !DILocation(line: 48, column: 9, scope: !145)
!150 = !DILocation(line: 48, column: 7, scope: !145)
!151 = !DILocation(line: 49, column: 9, scope: !145)
!152 = !DILocation(line: 49, column: 7, scope: !145)
!153 = !DILocation(line: 50, column: 2, scope: !145)
!154 = !DILocation(line: 51, column: 2, scope: !145)
!155 = distinct !DISubprogram(name: "thread_7", scope: !3, file: !3, line: 54, type: !97, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !99)
!156 = !DILocalVariable(name: "arg", arg: 1, scope: !155, file: !3, line: 54, type: !25)
!157 = !DILocation(line: 54, column: 22, scope: !155)
!158 = !DILocation(line: 55, column: 2, scope: !155)
!159 = !DILocation(line: 56, column: 9, scope: !155)
!160 = !DILocation(line: 56, column: 7, scope: !155)
!161 = !DILocation(line: 57, column: 9, scope: !155)
!162 = !DILocation(line: 57, column: 7, scope: !155)
!163 = !DILocation(line: 58, column: 2, scope: !155)
!164 = !DILocation(line: 59, column: 2, scope: !155)
!165 = distinct !DISubprogram(name: "thread_8", scope: !3, file: !3, line: 62, type: !97, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !99)
!166 = !DILocalVariable(name: "arg", arg: 1, scope: !165, file: !3, line: 62, type: !25)
!167 = !DILocation(line: 62, column: 22, scope: !165)
!168 = !DILocation(line: 63, column: 2, scope: !165)
!169 = !DILocation(line: 64, column: 2, scope: !165)
!170 = !DILocation(line: 65, column: 2, scope: !165)
!171 = !DILocation(line: 66, column: 2, scope: !165)
!172 = !DILocation(line: 67, column: 2, scope: !165)
!173 = !DILocation(line: 68, column: 2, scope: !165)
!174 = !DILocation(line: 69, column: 2, scope: !165)
!175 = !DILocation(line: 70, column: 2, scope: !165)
!176 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 73, type: !177, scopeLine: 74, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !99)
!177 = !DISubroutineType(types: !178)
!178 = !{!24}
!179 = !DILocalVariable(name: "t1", scope: !176, file: !3, line: 78, type: !180)
!180 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !181, line: 31, baseType: !182)
!181 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!182 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !183, line: 118, baseType: !184)
!183 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!184 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !185, size: 64)
!185 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !183, line: 103, size: 65536, elements: !186)
!186 = !{!187, !188, !198}
!187 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !185, file: !183, line: 104, baseType: !29, size: 64)
!188 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !185, file: !183, line: 105, baseType: !189, size: 64, offset: 64)
!189 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !190, size: 64)
!190 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !183, line: 57, size: 192, elements: !191)
!191 = !{!192, !196, !197}
!192 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !190, file: !183, line: 58, baseType: !193, size: 64)
!193 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !194, size: 64)
!194 = !DISubroutineType(types: !195)
!195 = !{null, !25}
!196 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !190, file: !183, line: 59, baseType: !25, size: 64, offset: 64)
!197 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !190, file: !183, line: 60, baseType: !189, size: 64, offset: 128)
!198 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !185, file: !183, line: 106, baseType: !199, size: 65408, offset: 128)
!199 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 65408, elements: !200)
!200 = !{!201}
!201 = !DISubrange(count: 8176)
!202 = !DILocation(line: 78, column: 15, scope: !176)
!203 = !DILocalVariable(name: "t2", scope: !176, file: !3, line: 78, type: !180)
!204 = !DILocation(line: 78, column: 19, scope: !176)
!205 = !DILocalVariable(name: "t3", scope: !176, file: !3, line: 78, type: !180)
!206 = !DILocation(line: 78, column: 23, scope: !176)
!207 = !DILocalVariable(name: "t4", scope: !176, file: !3, line: 78, type: !180)
!208 = !DILocation(line: 78, column: 27, scope: !176)
!209 = !DILocalVariable(name: "t5", scope: !176, file: !3, line: 78, type: !180)
!210 = !DILocation(line: 78, column: 31, scope: !176)
!211 = !DILocalVariable(name: "t6", scope: !176, file: !3, line: 78, type: !180)
!212 = !DILocation(line: 78, column: 35, scope: !176)
!213 = !DILocalVariable(name: "t7", scope: !176, file: !3, line: 78, type: !180)
!214 = !DILocation(line: 78, column: 39, scope: !176)
!215 = !DILocalVariable(name: "t8", scope: !176, file: !3, line: 78, type: !180)
!216 = !DILocation(line: 78, column: 43, scope: !176)
!217 = !DILocation(line: 80, column: 2, scope: !176)
!218 = !DILocation(line: 81, column: 2, scope: !176)
!219 = !DILocation(line: 82, column: 2, scope: !176)
!220 = !DILocation(line: 83, column: 2, scope: !176)
!221 = !DILocation(line: 84, column: 2, scope: !176)
!222 = !DILocation(line: 85, column: 2, scope: !176)
!223 = !DILocation(line: 86, column: 2, scope: !176)
!224 = !DILocation(line: 87, column: 2, scope: !176)
!225 = !DILocation(line: 89, column: 15, scope: !176)
!226 = !DILocation(line: 89, column: 2, scope: !176)
!227 = !DILocation(line: 90, column: 15, scope: !176)
!228 = !DILocation(line: 90, column: 2, scope: !176)
!229 = !DILocation(line: 91, column: 15, scope: !176)
!230 = !DILocation(line: 91, column: 2, scope: !176)
!231 = !DILocation(line: 92, column: 15, scope: !176)
!232 = !DILocation(line: 92, column: 2, scope: !176)
!233 = !DILocation(line: 93, column: 15, scope: !176)
!234 = !DILocation(line: 93, column: 2, scope: !176)
!235 = !DILocation(line: 94, column: 15, scope: !176)
!236 = !DILocation(line: 94, column: 2, scope: !176)
!237 = !DILocation(line: 95, column: 15, scope: !176)
!238 = !DILocation(line: 95, column: 2, scope: !176)
!239 = !DILocation(line: 96, column: 15, scope: !176)
!240 = !DILocation(line: 96, column: 2, scope: !176)
!241 = !DILocation(line: 98, column: 2, scope: !176)
!242 = !DILocation(line: 0, scope: !176)
!243 = !DILocation(line: 100, column: 2, scope: !176)
