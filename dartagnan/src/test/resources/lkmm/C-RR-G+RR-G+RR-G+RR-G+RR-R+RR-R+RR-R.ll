; ModuleID = 'benchmarks/lkmm/C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c'
source_filename = "benchmarks/lkmm/C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x0 = dso_local global i32 0, align 4, !dbg !0
@r1_1 = dso_local global i32 0, align 4, !dbg !59
@x1 = dso_local global i32 0, align 4, !dbg !47
@r2_1 = dso_local global i32 0, align 4, !dbg !61
@r1_2 = dso_local global i32 0, align 4, !dbg !63
@x2 = dso_local global i32 0, align 4, !dbg !49
@r2_2 = dso_local global i32 0, align 4, !dbg !65
@r1_3 = dso_local global i32 0, align 4, !dbg !67
@x3 = dso_local global i32 0, align 4, !dbg !51
@r2_3 = dso_local global i32 0, align 4, !dbg !69
@r1_4 = dso_local global i32 0, align 4, !dbg !71
@x4 = dso_local global i32 0, align 4, !dbg !53
@r2_4 = dso_local global i32 0, align 4, !dbg !73
@r1_5 = dso_local global i32 0, align 4, !dbg !75
@x5 = dso_local global i32 0, align 4, !dbg !55
@r2_5 = dso_local global i32 0, align 4, !dbg !77
@r1_6 = dso_local global i32 0, align 4, !dbg !79
@x6 = dso_local global i32 0, align 4, !dbg !57
@r2_6 = dso_local global i32 0, align 4, !dbg !81
@r1_7 = dso_local global i32 0, align 4, !dbg !83
@r2_7 = dso_local global i32 0, align 4, !dbg !85
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !30
@.str = private unnamed_addr constant [39 x i8] c"C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c\00", align 1, !dbg !37
@.str.1 = private unnamed_addr constant [184 x i8] c"!((r2_7 == 0 && r1_1 == 1 && r2_1 == 0 && r1_2 == 1 && r2_2 == 0 && r1_3 == 1 && r2_3 == 0 && r1_4 == 1 && r2_4 == 0 && r1_5 == 1 && r2_5 == 0 && r1_6 == 1 && r2_6 == 0 && r1_7 == 1))\00", align 1, !dbg !42

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !95 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !99, !DIExpression(), !100)
  %3 = call i64 @__LKMM_load(ptr noundef @x0, i64 noundef 4, i32 noundef 0), !dbg !101
  %4 = trunc i64 %3 to i32, !dbg !101
  store i32 %4, ptr @r1_1, align 4, !dbg !102
  call void @__LKMM_fence(i32 noundef 8), !dbg !103
  %5 = call i64 @__LKMM_load(ptr noundef @x1, i64 noundef 4, i32 noundef 0), !dbg !104
  %6 = trunc i64 %5 to i32, !dbg !104
  store i32 %6, ptr @r2_1, align 4, !dbg !105
  ret ptr null, !dbg !106
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_fence(i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !107 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !108, !DIExpression(), !109)
  %3 = call i64 @__LKMM_load(ptr noundef @x1, i64 noundef 4, i32 noundef 0), !dbg !110
  %4 = trunc i64 %3 to i32, !dbg !110
  store i32 %4, ptr @r1_2, align 4, !dbg !111
  call void @__LKMM_fence(i32 noundef 8), !dbg !112
  %5 = call i64 @__LKMM_load(ptr noundef @x2, i64 noundef 4, i32 noundef 0), !dbg !113
  %6 = trunc i64 %5 to i32, !dbg !113
  store i32 %6, ptr @r2_2, align 4, !dbg !114
  ret ptr null, !dbg !115
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_3(ptr noundef %0) #0 !dbg !116 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !117, !DIExpression(), !118)
  %3 = call i64 @__LKMM_load(ptr noundef @x2, i64 noundef 4, i32 noundef 0), !dbg !119
  %4 = trunc i64 %3 to i32, !dbg !119
  store i32 %4, ptr @r1_3, align 4, !dbg !120
  call void @__LKMM_fence(i32 noundef 8), !dbg !121
  %5 = call i64 @__LKMM_load(ptr noundef @x3, i64 noundef 4, i32 noundef 0), !dbg !122
  %6 = trunc i64 %5 to i32, !dbg !122
  store i32 %6, ptr @r2_3, align 4, !dbg !123
  ret ptr null, !dbg !124
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_4(ptr noundef %0) #0 !dbg !125 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !126, !DIExpression(), !127)
  %3 = call i64 @__LKMM_load(ptr noundef @x3, i64 noundef 4, i32 noundef 0), !dbg !128
  %4 = trunc i64 %3 to i32, !dbg !128
  store i32 %4, ptr @r1_4, align 4, !dbg !129
  call void @__LKMM_fence(i32 noundef 8), !dbg !130
  %5 = call i64 @__LKMM_load(ptr noundef @x4, i64 noundef 4, i32 noundef 0), !dbg !131
  %6 = trunc i64 %5 to i32, !dbg !131
  store i32 %6, ptr @r2_4, align 4, !dbg !132
  ret ptr null, !dbg !133
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_5(ptr noundef %0) #0 !dbg !134 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !135, !DIExpression(), !136)
  call void @__LKMM_fence(i32 noundef 6), !dbg !137
  %3 = call i64 @__LKMM_load(ptr noundef @x4, i64 noundef 4, i32 noundef 0), !dbg !138
  %4 = trunc i64 %3 to i32, !dbg !138
  store i32 %4, ptr @r1_5, align 4, !dbg !139
  %5 = call i64 @__LKMM_load(ptr noundef @x5, i64 noundef 4, i32 noundef 0), !dbg !140
  %6 = trunc i64 %5 to i32, !dbg !140
  store i32 %6, ptr @r2_5, align 4, !dbg !141
  call void @__LKMM_fence(i32 noundef 7), !dbg !142
  ret ptr null, !dbg !143
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_6(ptr noundef %0) #0 !dbg !144 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !145, !DIExpression(), !146)
  call void @__LKMM_fence(i32 noundef 6), !dbg !147
  %3 = call i64 @__LKMM_load(ptr noundef @x5, i64 noundef 4, i32 noundef 0), !dbg !148
  %4 = trunc i64 %3 to i32, !dbg !148
  store i32 %4, ptr @r1_6, align 4, !dbg !149
  %5 = call i64 @__LKMM_load(ptr noundef @x6, i64 noundef 4, i32 noundef 0), !dbg !150
  %6 = trunc i64 %5 to i32, !dbg !150
  store i32 %6, ptr @r2_6, align 4, !dbg !151
  call void @__LKMM_fence(i32 noundef 7), !dbg !152
  ret ptr null, !dbg !153
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_7(ptr noundef %0) #0 !dbg !154 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !155, !DIExpression(), !156)
  call void @__LKMM_fence(i32 noundef 6), !dbg !157
  %3 = call i64 @__LKMM_load(ptr noundef @x6, i64 noundef 4, i32 noundef 0), !dbg !158
  %4 = trunc i64 %3 to i32, !dbg !158
  store i32 %4, ptr @r1_7, align 4, !dbg !159
  %5 = call i64 @__LKMM_load(ptr noundef @x0, i64 noundef 4, i32 noundef 0), !dbg !160
  %6 = trunc i64 %5 to i32, !dbg !160
  store i32 %6, ptr @r2_7, align 4, !dbg !161
  call void @__LKMM_fence(i32 noundef 7), !dbg !162
  ret ptr null, !dbg !163
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_8(ptr noundef %0) #0 !dbg !164 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !165, !DIExpression(), !166)
  call void @__LKMM_store(ptr noundef @x0, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !167
  call void @__LKMM_store(ptr noundef @x1, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !168
  call void @__LKMM_store(ptr noundef @x2, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !169
  call void @__LKMM_store(ptr noundef @x3, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !170
  call void @__LKMM_store(ptr noundef @x4, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !171
  call void @__LKMM_store(ptr noundef @x5, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !172
  call void @__LKMM_store(ptr noundef @x6, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !173
  ret ptr null, !dbg !174
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !175 {
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
    #dbg_declare(ptr %2, !178, !DIExpression(), !201)
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
!llvm.module.flags = !{!87, !88, !89, !90, !91, !92, !93}
!llvm.ident = !{!94}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x0", scope: !2, file: !3, line: 7, type: !23, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !22, globals: !29, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "dbafb2cd139d33a606f4c8b7719d2341")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "26457005f8f39b3952d279119fb45118")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21}
!9 = !DIEnumerator(name: "__LKMM_once", value: 0)
!10 = !DIEnumerator(name: "__LKMM_acquire", value: 1)
!11 = !DIEnumerator(name: "__LKMM_release", value: 2)
!12 = !DIEnumerator(name: "__LKMM_mb", value: 3)
!13 = !DIEnumerator(name: "__LKMM_wmb", value: 4)
!14 = !DIEnumerator(name: "__LKMM_rmb", value: 5)
!15 = !DIEnumerator(name: "__LKMM_rcu_lock", value: 6)
!16 = !DIEnumerator(name: "__LKMM_rcu_unlock", value: 7)
!17 = !DIEnumerator(name: "__LKMM_rcu_sync", value: 8)
!18 = !DIEnumerator(name: "__LKMM_before_atomic", value: 9)
!19 = !DIEnumerator(name: "__LKMM_after_atomic", value: 10)
!20 = !DIEnumerator(name: "__LKMM_after_spinlock", value: 11)
!21 = !DIEnumerator(name: "__LKMM_barrier", value: 12)
!22 = !{!23, !24, !25}
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 27, baseType: !26)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !27, line: 32, baseType: !28)
!27 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!28 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!29 = !{!30, !37, !42, !0, !47, !49, !51, !53, !55, !57, !59, !61, !63, !65, !67, !69, !71, !73, !75, !77, !79, !81, !83, !85}
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 98, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 40, elements: !35)
!33 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!34 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!35 = !{!36}
!36 = !DISubrange(count: 5)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 98, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 312, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 39)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 98, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 1472, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 184)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "x1", scope: !2, file: !3, line: 7, type: !23, isLocal: false, isDefinition: true)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(name: "x2", scope: !2, file: !3, line: 7, type: !23, isLocal: false, isDefinition: true)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(name: "x3", scope: !2, file: !3, line: 7, type: !23, isLocal: false, isDefinition: true)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "x4", scope: !2, file: !3, line: 7, type: !23, isLocal: false, isDefinition: true)
!55 = !DIGlobalVariableExpression(var: !56, expr: !DIExpression())
!56 = distinct !DIGlobalVariable(name: "x5", scope: !2, file: !3, line: 7, type: !23, isLocal: false, isDefinition: true)
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(name: "x6", scope: !2, file: !3, line: 7, type: !23, isLocal: false, isDefinition: true)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "r1_1", scope: !2, file: !3, line: 8, type: !23, isLocal: false, isDefinition: true)
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(name: "r2_1", scope: !2, file: !3, line: 8, type: !23, isLocal: false, isDefinition: true)
!63 = !DIGlobalVariableExpression(var: !64, expr: !DIExpression())
!64 = distinct !DIGlobalVariable(name: "r1_2", scope: !2, file: !3, line: 8, type: !23, isLocal: false, isDefinition: true)
!65 = !DIGlobalVariableExpression(var: !66, expr: !DIExpression())
!66 = distinct !DIGlobalVariable(name: "r2_2", scope: !2, file: !3, line: 8, type: !23, isLocal: false, isDefinition: true)
!67 = !DIGlobalVariableExpression(var: !68, expr: !DIExpression())
!68 = distinct !DIGlobalVariable(name: "r1_3", scope: !2, file: !3, line: 8, type: !23, isLocal: false, isDefinition: true)
!69 = !DIGlobalVariableExpression(var: !70, expr: !DIExpression())
!70 = distinct !DIGlobalVariable(name: "r2_3", scope: !2, file: !3, line: 8, type: !23, isLocal: false, isDefinition: true)
!71 = !DIGlobalVariableExpression(var: !72, expr: !DIExpression())
!72 = distinct !DIGlobalVariable(name: "r1_4", scope: !2, file: !3, line: 8, type: !23, isLocal: false, isDefinition: true)
!73 = !DIGlobalVariableExpression(var: !74, expr: !DIExpression())
!74 = distinct !DIGlobalVariable(name: "r2_4", scope: !2, file: !3, line: 8, type: !23, isLocal: false, isDefinition: true)
!75 = !DIGlobalVariableExpression(var: !76, expr: !DIExpression())
!76 = distinct !DIGlobalVariable(name: "r1_5", scope: !2, file: !3, line: 8, type: !23, isLocal: false, isDefinition: true)
!77 = !DIGlobalVariableExpression(var: !78, expr: !DIExpression())
!78 = distinct !DIGlobalVariable(name: "r2_5", scope: !2, file: !3, line: 8, type: !23, isLocal: false, isDefinition: true)
!79 = !DIGlobalVariableExpression(var: !80, expr: !DIExpression())
!80 = distinct !DIGlobalVariable(name: "r1_6", scope: !2, file: !3, line: 8, type: !23, isLocal: false, isDefinition: true)
!81 = !DIGlobalVariableExpression(var: !82, expr: !DIExpression())
!82 = distinct !DIGlobalVariable(name: "r2_6", scope: !2, file: !3, line: 8, type: !23, isLocal: false, isDefinition: true)
!83 = !DIGlobalVariableExpression(var: !84, expr: !DIExpression())
!84 = distinct !DIGlobalVariable(name: "r1_7", scope: !2, file: !3, line: 8, type: !23, isLocal: false, isDefinition: true)
!85 = !DIGlobalVariableExpression(var: !86, expr: !DIExpression())
!86 = distinct !DIGlobalVariable(name: "r2_7", scope: !2, file: !3, line: 8, type: !23, isLocal: false, isDefinition: true)
!87 = !{i32 7, !"Dwarf Version", i32 5}
!88 = !{i32 2, !"Debug Info Version", i32 3}
!89 = !{i32 1, !"wchar_size", i32 4}
!90 = !{i32 8, !"PIC Level", i32 2}
!91 = !{i32 7, !"PIE Level", i32 2}
!92 = !{i32 7, !"uwtable", i32 2}
!93 = !{i32 7, !"frame-pointer", i32 2}
!94 = !{!"Homebrew clang version 19.1.7"}
!95 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 10, type: !96, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !98)
!96 = !DISubroutineType(types: !97)
!97 = !{!24, !24}
!98 = !{}
!99 = !DILocalVariable(name: "arg", arg: 1, scope: !95, file: !3, line: 10, type: !24)
!100 = !DILocation(line: 10, column: 22, scope: !95)
!101 = !DILocation(line: 11, column: 9, scope: !95)
!102 = !DILocation(line: 11, column: 7, scope: !95)
!103 = !DILocation(line: 12, column: 2, scope: !95)
!104 = !DILocation(line: 13, column: 9, scope: !95)
!105 = !DILocation(line: 13, column: 7, scope: !95)
!106 = !DILocation(line: 14, column: 2, scope: !95)
!107 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 17, type: !96, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !98)
!108 = !DILocalVariable(name: "arg", arg: 1, scope: !107, file: !3, line: 17, type: !24)
!109 = !DILocation(line: 17, column: 22, scope: !107)
!110 = !DILocation(line: 18, column: 9, scope: !107)
!111 = !DILocation(line: 18, column: 7, scope: !107)
!112 = !DILocation(line: 19, column: 2, scope: !107)
!113 = !DILocation(line: 20, column: 9, scope: !107)
!114 = !DILocation(line: 20, column: 7, scope: !107)
!115 = !DILocation(line: 21, column: 2, scope: !107)
!116 = distinct !DISubprogram(name: "thread_3", scope: !3, file: !3, line: 24, type: !96, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !98)
!117 = !DILocalVariable(name: "arg", arg: 1, scope: !116, file: !3, line: 24, type: !24)
!118 = !DILocation(line: 24, column: 22, scope: !116)
!119 = !DILocation(line: 25, column: 9, scope: !116)
!120 = !DILocation(line: 25, column: 7, scope: !116)
!121 = !DILocation(line: 26, column: 2, scope: !116)
!122 = !DILocation(line: 27, column: 9, scope: !116)
!123 = !DILocation(line: 27, column: 7, scope: !116)
!124 = !DILocation(line: 28, column: 2, scope: !116)
!125 = distinct !DISubprogram(name: "thread_4", scope: !3, file: !3, line: 31, type: !96, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !98)
!126 = !DILocalVariable(name: "arg", arg: 1, scope: !125, file: !3, line: 31, type: !24)
!127 = !DILocation(line: 31, column: 22, scope: !125)
!128 = !DILocation(line: 32, column: 9, scope: !125)
!129 = !DILocation(line: 32, column: 7, scope: !125)
!130 = !DILocation(line: 33, column: 2, scope: !125)
!131 = !DILocation(line: 34, column: 9, scope: !125)
!132 = !DILocation(line: 34, column: 7, scope: !125)
!133 = !DILocation(line: 35, column: 2, scope: !125)
!134 = distinct !DISubprogram(name: "thread_5", scope: !3, file: !3, line: 38, type: !96, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !98)
!135 = !DILocalVariable(name: "arg", arg: 1, scope: !134, file: !3, line: 38, type: !24)
!136 = !DILocation(line: 38, column: 22, scope: !134)
!137 = !DILocation(line: 39, column: 2, scope: !134)
!138 = !DILocation(line: 40, column: 9, scope: !134)
!139 = !DILocation(line: 40, column: 7, scope: !134)
!140 = !DILocation(line: 41, column: 9, scope: !134)
!141 = !DILocation(line: 41, column: 7, scope: !134)
!142 = !DILocation(line: 42, column: 2, scope: !134)
!143 = !DILocation(line: 43, column: 2, scope: !134)
!144 = distinct !DISubprogram(name: "thread_6", scope: !3, file: !3, line: 46, type: !96, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !98)
!145 = !DILocalVariable(name: "arg", arg: 1, scope: !144, file: !3, line: 46, type: !24)
!146 = !DILocation(line: 46, column: 22, scope: !144)
!147 = !DILocation(line: 47, column: 2, scope: !144)
!148 = !DILocation(line: 48, column: 9, scope: !144)
!149 = !DILocation(line: 48, column: 7, scope: !144)
!150 = !DILocation(line: 49, column: 9, scope: !144)
!151 = !DILocation(line: 49, column: 7, scope: !144)
!152 = !DILocation(line: 50, column: 2, scope: !144)
!153 = !DILocation(line: 51, column: 2, scope: !144)
!154 = distinct !DISubprogram(name: "thread_7", scope: !3, file: !3, line: 54, type: !96, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !98)
!155 = !DILocalVariable(name: "arg", arg: 1, scope: !154, file: !3, line: 54, type: !24)
!156 = !DILocation(line: 54, column: 22, scope: !154)
!157 = !DILocation(line: 55, column: 2, scope: !154)
!158 = !DILocation(line: 56, column: 9, scope: !154)
!159 = !DILocation(line: 56, column: 7, scope: !154)
!160 = !DILocation(line: 57, column: 9, scope: !154)
!161 = !DILocation(line: 57, column: 7, scope: !154)
!162 = !DILocation(line: 58, column: 2, scope: !154)
!163 = !DILocation(line: 59, column: 2, scope: !154)
!164 = distinct !DISubprogram(name: "thread_8", scope: !3, file: !3, line: 62, type: !96, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !98)
!165 = !DILocalVariable(name: "arg", arg: 1, scope: !164, file: !3, line: 62, type: !24)
!166 = !DILocation(line: 62, column: 22, scope: !164)
!167 = !DILocation(line: 63, column: 2, scope: !164)
!168 = !DILocation(line: 64, column: 2, scope: !164)
!169 = !DILocation(line: 65, column: 2, scope: !164)
!170 = !DILocation(line: 66, column: 2, scope: !164)
!171 = !DILocation(line: 67, column: 2, scope: !164)
!172 = !DILocation(line: 68, column: 2, scope: !164)
!173 = !DILocation(line: 69, column: 2, scope: !164)
!174 = !DILocation(line: 70, column: 2, scope: !164)
!175 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 73, type: !176, scopeLine: 74, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !98)
!176 = !DISubroutineType(types: !177)
!177 = !{!23}
!178 = !DILocalVariable(name: "t1", scope: !175, file: !3, line: 78, type: !179)
!179 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !180, line: 31, baseType: !181)
!180 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!181 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !182, line: 118, baseType: !183)
!182 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!183 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !184, size: 64)
!184 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !182, line: 103, size: 65536, elements: !185)
!185 = !{!186, !187, !197}
!186 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !184, file: !182, line: 104, baseType: !28, size: 64)
!187 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !184, file: !182, line: 105, baseType: !188, size: 64, offset: 64)
!188 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !189, size: 64)
!189 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !182, line: 57, size: 192, elements: !190)
!190 = !{!191, !195, !196}
!191 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !189, file: !182, line: 58, baseType: !192, size: 64)
!192 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !193, size: 64)
!193 = !DISubroutineType(types: !194)
!194 = !{null, !24}
!195 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !189, file: !182, line: 59, baseType: !24, size: 64, offset: 64)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !189, file: !182, line: 60, baseType: !188, size: 64, offset: 128)
!197 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !184, file: !182, line: 106, baseType: !198, size: 65408, offset: 128)
!198 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 65408, elements: !199)
!199 = !{!200}
!200 = !DISubrange(count: 8176)
!201 = !DILocation(line: 78, column: 15, scope: !175)
!202 = !DILocalVariable(name: "t2", scope: !175, file: !3, line: 78, type: !179)
!203 = !DILocation(line: 78, column: 19, scope: !175)
!204 = !DILocalVariable(name: "t3", scope: !175, file: !3, line: 78, type: !179)
!205 = !DILocation(line: 78, column: 23, scope: !175)
!206 = !DILocalVariable(name: "t4", scope: !175, file: !3, line: 78, type: !179)
!207 = !DILocation(line: 78, column: 27, scope: !175)
!208 = !DILocalVariable(name: "t5", scope: !175, file: !3, line: 78, type: !179)
!209 = !DILocation(line: 78, column: 31, scope: !175)
!210 = !DILocalVariable(name: "t6", scope: !175, file: !3, line: 78, type: !179)
!211 = !DILocation(line: 78, column: 35, scope: !175)
!212 = !DILocalVariable(name: "t7", scope: !175, file: !3, line: 78, type: !179)
!213 = !DILocation(line: 78, column: 39, scope: !175)
!214 = !DILocalVariable(name: "t8", scope: !175, file: !3, line: 78, type: !179)
!215 = !DILocation(line: 78, column: 43, scope: !175)
!216 = !DILocation(line: 80, column: 2, scope: !175)
!217 = !DILocation(line: 81, column: 2, scope: !175)
!218 = !DILocation(line: 82, column: 2, scope: !175)
!219 = !DILocation(line: 83, column: 2, scope: !175)
!220 = !DILocation(line: 84, column: 2, scope: !175)
!221 = !DILocation(line: 85, column: 2, scope: !175)
!222 = !DILocation(line: 86, column: 2, scope: !175)
!223 = !DILocation(line: 87, column: 2, scope: !175)
!224 = !DILocation(line: 89, column: 15, scope: !175)
!225 = !DILocation(line: 89, column: 2, scope: !175)
!226 = !DILocation(line: 90, column: 15, scope: !175)
!227 = !DILocation(line: 90, column: 2, scope: !175)
!228 = !DILocation(line: 91, column: 15, scope: !175)
!229 = !DILocation(line: 91, column: 2, scope: !175)
!230 = !DILocation(line: 92, column: 15, scope: !175)
!231 = !DILocation(line: 92, column: 2, scope: !175)
!232 = !DILocation(line: 93, column: 15, scope: !175)
!233 = !DILocation(line: 93, column: 2, scope: !175)
!234 = !DILocation(line: 94, column: 15, scope: !175)
!235 = !DILocation(line: 94, column: 2, scope: !175)
!236 = !DILocation(line: 95, column: 15, scope: !175)
!237 = !DILocation(line: 95, column: 2, scope: !175)
!238 = !DILocation(line: 96, column: 15, scope: !175)
!239 = !DILocation(line: 96, column: 2, scope: !175)
!240 = !DILocation(line: 98, column: 2, scope: !175)
!241 = !DILocation(line: 0, scope: !175)
!242 = !DILocation(line: 100, column: 2, scope: !175)
