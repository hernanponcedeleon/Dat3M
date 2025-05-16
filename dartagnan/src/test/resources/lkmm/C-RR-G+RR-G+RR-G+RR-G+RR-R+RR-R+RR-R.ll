; ModuleID = 'benchmarks/lkmm/C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c'
source_filename = "benchmarks/lkmm/C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@x0 = global i32 0, align 4, !dbg !0
@r1_1 = global i32 0, align 4, !dbg !58
@x1 = global i32 0, align 4, !dbg !46
@r2_1 = global i32 0, align 4, !dbg !60
@r1_2 = global i32 0, align 4, !dbg !62
@x2 = global i32 0, align 4, !dbg !48
@r2_2 = global i32 0, align 4, !dbg !64
@r1_3 = global i32 0, align 4, !dbg !66
@x3 = global i32 0, align 4, !dbg !50
@r2_3 = global i32 0, align 4, !dbg !68
@r1_4 = global i32 0, align 4, !dbg !70
@x4 = global i32 0, align 4, !dbg !52
@r2_4 = global i32 0, align 4, !dbg !72
@r1_5 = global i32 0, align 4, !dbg !74
@x5 = global i32 0, align 4, !dbg !54
@r2_5 = global i32 0, align 4, !dbg !76
@r1_6 = global i32 0, align 4, !dbg !78
@x6 = global i32 0, align 4, !dbg !56
@r2_6 = global i32 0, align 4, !dbg !80
@r1_7 = global i32 0, align 4, !dbg !82
@r2_7 = global i32 0, align 4, !dbg !84
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@.str = private unnamed_addr constant [39 x i8] c"C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [184 x i8] c"!((r2_7 == 0 && r1_1 == 1 && r2_1 == 0 && r1_2 == 1 && r2_2 == 0 && r1_3 == 1 && r2_3 == 0 && r1_4 == 1 && r2_4 == 0 && r1_5 == 1 && r2_5 == 0 && r1_6 == 1 && r2_6 == 0 && r1_7 == 1))\00", align 1, !dbg !41

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_1(ptr noundef %0) #0 !dbg !93 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !97, !DIExpression(), !98)
  %3 = call i64 @__LKMM_load(ptr noundef @x0, i64 noundef 4, i32 noundef 1), !dbg !99
  %4 = trunc i64 %3 to i32, !dbg !99
  store i32 %4, ptr @r1_1, align 4, !dbg !100
  call void @__LKMM_fence(i32 noundef 9), !dbg !101
  %5 = call i64 @__LKMM_load(ptr noundef @x1, i64 noundef 4, i32 noundef 1), !dbg !102
  %6 = trunc i64 %5 to i32, !dbg !102
  store i32 %6, ptr @r2_1, align 4, !dbg !103
  ret ptr null, !dbg !104
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_fence(i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_2(ptr noundef %0) #0 !dbg !105 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !106, !DIExpression(), !107)
  %3 = call i64 @__LKMM_load(ptr noundef @x1, i64 noundef 4, i32 noundef 1), !dbg !108
  %4 = trunc i64 %3 to i32, !dbg !108
  store i32 %4, ptr @r1_2, align 4, !dbg !109
  call void @__LKMM_fence(i32 noundef 9), !dbg !110
  %5 = call i64 @__LKMM_load(ptr noundef @x2, i64 noundef 4, i32 noundef 1), !dbg !111
  %6 = trunc i64 %5 to i32, !dbg !111
  store i32 %6, ptr @r2_2, align 4, !dbg !112
  ret ptr null, !dbg !113
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_3(ptr noundef %0) #0 !dbg !114 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !115, !DIExpression(), !116)
  %3 = call i64 @__LKMM_load(ptr noundef @x2, i64 noundef 4, i32 noundef 1), !dbg !117
  %4 = trunc i64 %3 to i32, !dbg !117
  store i32 %4, ptr @r1_3, align 4, !dbg !118
  call void @__LKMM_fence(i32 noundef 9), !dbg !119
  %5 = call i64 @__LKMM_load(ptr noundef @x3, i64 noundef 4, i32 noundef 1), !dbg !120
  %6 = trunc i64 %5 to i32, !dbg !120
  store i32 %6, ptr @r2_3, align 4, !dbg !121
  ret ptr null, !dbg !122
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_4(ptr noundef %0) #0 !dbg !123 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !124, !DIExpression(), !125)
  %3 = call i64 @__LKMM_load(ptr noundef @x3, i64 noundef 4, i32 noundef 1), !dbg !126
  %4 = trunc i64 %3 to i32, !dbg !126
  store i32 %4, ptr @r1_4, align 4, !dbg !127
  call void @__LKMM_fence(i32 noundef 9), !dbg !128
  %5 = call i64 @__LKMM_load(ptr noundef @x4, i64 noundef 4, i32 noundef 1), !dbg !129
  %6 = trunc i64 %5 to i32, !dbg !129
  store i32 %6, ptr @r2_4, align 4, !dbg !130
  ret ptr null, !dbg !131
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_5(ptr noundef %0) #0 !dbg !132 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !133, !DIExpression(), !134)
  call void @__LKMM_fence(i32 noundef 7), !dbg !135
  %3 = call i64 @__LKMM_load(ptr noundef @x4, i64 noundef 4, i32 noundef 1), !dbg !136
  %4 = trunc i64 %3 to i32, !dbg !136
  store i32 %4, ptr @r1_5, align 4, !dbg !137
  %5 = call i64 @__LKMM_load(ptr noundef @x5, i64 noundef 4, i32 noundef 1), !dbg !138
  %6 = trunc i64 %5 to i32, !dbg !138
  store i32 %6, ptr @r2_5, align 4, !dbg !139
  call void @__LKMM_fence(i32 noundef 8), !dbg !140
  ret ptr null, !dbg !141
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_6(ptr noundef %0) #0 !dbg !142 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !143, !DIExpression(), !144)
  call void @__LKMM_fence(i32 noundef 7), !dbg !145
  %3 = call i64 @__LKMM_load(ptr noundef @x5, i64 noundef 4, i32 noundef 1), !dbg !146
  %4 = trunc i64 %3 to i32, !dbg !146
  store i32 %4, ptr @r1_6, align 4, !dbg !147
  %5 = call i64 @__LKMM_load(ptr noundef @x6, i64 noundef 4, i32 noundef 1), !dbg !148
  %6 = trunc i64 %5 to i32, !dbg !148
  store i32 %6, ptr @r2_6, align 4, !dbg !149
  call void @__LKMM_fence(i32 noundef 8), !dbg !150
  ret ptr null, !dbg !151
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_7(ptr noundef %0) #0 !dbg !152 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !153, !DIExpression(), !154)
  call void @__LKMM_fence(i32 noundef 7), !dbg !155
  %3 = call i64 @__LKMM_load(ptr noundef @x6, i64 noundef 4, i32 noundef 1), !dbg !156
  %4 = trunc i64 %3 to i32, !dbg !156
  store i32 %4, ptr @r1_7, align 4, !dbg !157
  %5 = call i64 @__LKMM_load(ptr noundef @x0, i64 noundef 4, i32 noundef 1), !dbg !158
  %6 = trunc i64 %5 to i32, !dbg !158
  store i32 %6, ptr @r2_7, align 4, !dbg !159
  call void @__LKMM_fence(i32 noundef 8), !dbg !160
  ret ptr null, !dbg !161
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_8(ptr noundef %0) #0 !dbg !162 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !163, !DIExpression(), !164)
  call void @__LKMM_store(ptr noundef @x0, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !165
  call void @__LKMM_store(ptr noundef @x1, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !166
  call void @__LKMM_store(ptr noundef @x2, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !167
  call void @__LKMM_store(ptr noundef @x3, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !168
  call void @__LKMM_store(ptr noundef @x4, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !169
  call void @__LKMM_store(ptr noundef @x5, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !170
  call void @__LKMM_store(ptr noundef @x6, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !171
  ret ptr null, !dbg !172
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !173 {
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
    #dbg_declare(ptr %2, !176, !DIExpression(), !200)
    #dbg_declare(ptr %3, !201, !DIExpression(), !202)
    #dbg_declare(ptr %4, !203, !DIExpression(), !204)
    #dbg_declare(ptr %5, !205, !DIExpression(), !206)
    #dbg_declare(ptr %6, !207, !DIExpression(), !208)
    #dbg_declare(ptr %7, !209, !DIExpression(), !210)
    #dbg_declare(ptr %8, !211, !DIExpression(), !212)
    #dbg_declare(ptr %9, !213, !DIExpression(), !214)
  %10 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !215
  %11 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !216
  %12 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @thread_3, ptr noundef null), !dbg !217
  %13 = call i32 @pthread_create(ptr noundef %5, ptr noundef null, ptr noundef @thread_4, ptr noundef null), !dbg !218
  %14 = call i32 @pthread_create(ptr noundef %6, ptr noundef null, ptr noundef @thread_5, ptr noundef null), !dbg !219
  %15 = call i32 @pthread_create(ptr noundef %7, ptr noundef null, ptr noundef @thread_6, ptr noundef null), !dbg !220
  %16 = call i32 @pthread_create(ptr noundef %8, ptr noundef null, ptr noundef @thread_7, ptr noundef null), !dbg !221
  %17 = call i32 @pthread_create(ptr noundef %9, ptr noundef null, ptr noundef @thread_8, ptr noundef null), !dbg !222
  %18 = load ptr, ptr %2, align 8, !dbg !223
  %19 = call i32 @"\01_pthread_join"(ptr noundef %18, ptr noundef null), !dbg !224
  %20 = load ptr, ptr %3, align 8, !dbg !225
  %21 = call i32 @"\01_pthread_join"(ptr noundef %20, ptr noundef null), !dbg !226
  %22 = load ptr, ptr %4, align 8, !dbg !227
  %23 = call i32 @"\01_pthread_join"(ptr noundef %22, ptr noundef null), !dbg !228
  %24 = load ptr, ptr %5, align 8, !dbg !229
  %25 = call i32 @"\01_pthread_join"(ptr noundef %24, ptr noundef null), !dbg !230
  %26 = load ptr, ptr %6, align 8, !dbg !231
  %27 = call i32 @"\01_pthread_join"(ptr noundef %26, ptr noundef null), !dbg !232
  %28 = load ptr, ptr %7, align 8, !dbg !233
  %29 = call i32 @"\01_pthread_join"(ptr noundef %28, ptr noundef null), !dbg !234
  %30 = load ptr, ptr %8, align 8, !dbg !235
  %31 = call i32 @"\01_pthread_join"(ptr noundef %30, ptr noundef null), !dbg !236
  %32 = load ptr, ptr %9, align 8, !dbg !237
  %33 = call i32 @"\01_pthread_join"(ptr noundef %32, ptr noundef null), !dbg !238
  %34 = load i32, ptr @r2_7, align 4, !dbg !239
  %35 = icmp eq i32 %34, 0, !dbg !239
  br i1 %35, label %36, label %75, !dbg !239

36:                                               ; preds = %0
  %37 = load i32, ptr @r1_1, align 4, !dbg !239
  %38 = icmp eq i32 %37, 1, !dbg !239
  br i1 %38, label %39, label %75, !dbg !239

39:                                               ; preds = %36
  %40 = load i32, ptr @r2_1, align 4, !dbg !239
  %41 = icmp eq i32 %40, 0, !dbg !239
  br i1 %41, label %42, label %75, !dbg !239

42:                                               ; preds = %39
  %43 = load i32, ptr @r1_2, align 4, !dbg !239
  %44 = icmp eq i32 %43, 1, !dbg !239
  br i1 %44, label %45, label %75, !dbg !239

45:                                               ; preds = %42
  %46 = load i32, ptr @r2_2, align 4, !dbg !239
  %47 = icmp eq i32 %46, 0, !dbg !239
  br i1 %47, label %48, label %75, !dbg !239

48:                                               ; preds = %45
  %49 = load i32, ptr @r1_3, align 4, !dbg !239
  %50 = icmp eq i32 %49, 1, !dbg !239
  br i1 %50, label %51, label %75, !dbg !239

51:                                               ; preds = %48
  %52 = load i32, ptr @r2_3, align 4, !dbg !239
  %53 = icmp eq i32 %52, 0, !dbg !239
  br i1 %53, label %54, label %75, !dbg !239

54:                                               ; preds = %51
  %55 = load i32, ptr @r1_4, align 4, !dbg !239
  %56 = icmp eq i32 %55, 1, !dbg !239
  br i1 %56, label %57, label %75, !dbg !239

57:                                               ; preds = %54
  %58 = load i32, ptr @r2_4, align 4, !dbg !239
  %59 = icmp eq i32 %58, 0, !dbg !239
  br i1 %59, label %60, label %75, !dbg !239

60:                                               ; preds = %57
  %61 = load i32, ptr @r1_5, align 4, !dbg !239
  %62 = icmp eq i32 %61, 1, !dbg !239
  br i1 %62, label %63, label %75, !dbg !239

63:                                               ; preds = %60
  %64 = load i32, ptr @r2_5, align 4, !dbg !239
  %65 = icmp eq i32 %64, 0, !dbg !239
  br i1 %65, label %66, label %75, !dbg !239

66:                                               ; preds = %63
  %67 = load i32, ptr @r1_6, align 4, !dbg !239
  %68 = icmp eq i32 %67, 1, !dbg !239
  br i1 %68, label %69, label %75, !dbg !239

69:                                               ; preds = %66
  %70 = load i32, ptr @r2_6, align 4, !dbg !239
  %71 = icmp eq i32 %70, 0, !dbg !239
  br i1 %71, label %72, label %75, !dbg !239

72:                                               ; preds = %69
  %73 = load i32, ptr @r1_7, align 4, !dbg !239
  %74 = icmp eq i32 %73, 1, !dbg !239
  br label %75

75:                                               ; preds = %72, %69, %66, %63, %60, %57, %54, %51, %48, %45, %42, %39, %36, %0
  %76 = phi i1 [ false, %69 ], [ false, %66 ], [ false, %63 ], [ false, %60 ], [ false, %57 ], [ false, %54 ], [ false, %51 ], [ false, %48 ], [ false, %45 ], [ false, %42 ], [ false, %39 ], [ false, %36 ], [ false, %0 ], [ %74, %72 ], !dbg !240
  %77 = xor i1 %76, true, !dbg !239
  %78 = xor i1 %77, true, !dbg !239
  %79 = zext i1 %78 to i32, !dbg !239
  %80 = sext i32 %79 to i64, !dbg !239
  %81 = icmp ne i64 %80, 0, !dbg !239
  br i1 %81, label %82, label %84, !dbg !239

82:                                               ; preds = %75
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 98, ptr noundef @.str.1) #3, !dbg !239
  unreachable, !dbg !239

83:                                               ; No predecessors!
  br label %85, !dbg !239

84:                                               ; preds = %75
  br label %85, !dbg !239

85:                                               ; preds = %84, %83
  ret i32 0, !dbg !241
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!86, !87, !88, !89, !90, !91}
!llvm.ident = !{!92}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x0", scope: !2, file: !3, line: 7, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
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
!90 = !{i32 7, !"uwtable", i32 1}
!91 = !{i32 7, !"frame-pointer", i32 1}
!92 = !{!"Homebrew clang version 19.1.7"}
!93 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 10, type: !94, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !96)
!94 = !DISubroutineType(types: !95)
!95 = !{!25, !25}
!96 = !{}
!97 = !DILocalVariable(name: "arg", arg: 1, scope: !93, file: !3, line: 10, type: !25)
!98 = !DILocation(line: 10, column: 22, scope: !93)
!99 = !DILocation(line: 11, column: 9, scope: !93)
!100 = !DILocation(line: 11, column: 7, scope: !93)
!101 = !DILocation(line: 12, column: 2, scope: !93)
!102 = !DILocation(line: 13, column: 9, scope: !93)
!103 = !DILocation(line: 13, column: 7, scope: !93)
!104 = !DILocation(line: 14, column: 2, scope: !93)
!105 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 17, type: !94, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !96)
!106 = !DILocalVariable(name: "arg", arg: 1, scope: !105, file: !3, line: 17, type: !25)
!107 = !DILocation(line: 17, column: 22, scope: !105)
!108 = !DILocation(line: 18, column: 9, scope: !105)
!109 = !DILocation(line: 18, column: 7, scope: !105)
!110 = !DILocation(line: 19, column: 2, scope: !105)
!111 = !DILocation(line: 20, column: 9, scope: !105)
!112 = !DILocation(line: 20, column: 7, scope: !105)
!113 = !DILocation(line: 21, column: 2, scope: !105)
!114 = distinct !DISubprogram(name: "thread_3", scope: !3, file: !3, line: 24, type: !94, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !96)
!115 = !DILocalVariable(name: "arg", arg: 1, scope: !114, file: !3, line: 24, type: !25)
!116 = !DILocation(line: 24, column: 22, scope: !114)
!117 = !DILocation(line: 25, column: 9, scope: !114)
!118 = !DILocation(line: 25, column: 7, scope: !114)
!119 = !DILocation(line: 26, column: 2, scope: !114)
!120 = !DILocation(line: 27, column: 9, scope: !114)
!121 = !DILocation(line: 27, column: 7, scope: !114)
!122 = !DILocation(line: 28, column: 2, scope: !114)
!123 = distinct !DISubprogram(name: "thread_4", scope: !3, file: !3, line: 31, type: !94, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !96)
!124 = !DILocalVariable(name: "arg", arg: 1, scope: !123, file: !3, line: 31, type: !25)
!125 = !DILocation(line: 31, column: 22, scope: !123)
!126 = !DILocation(line: 32, column: 9, scope: !123)
!127 = !DILocation(line: 32, column: 7, scope: !123)
!128 = !DILocation(line: 33, column: 2, scope: !123)
!129 = !DILocation(line: 34, column: 9, scope: !123)
!130 = !DILocation(line: 34, column: 7, scope: !123)
!131 = !DILocation(line: 35, column: 2, scope: !123)
!132 = distinct !DISubprogram(name: "thread_5", scope: !3, file: !3, line: 38, type: !94, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !96)
!133 = !DILocalVariable(name: "arg", arg: 1, scope: !132, file: !3, line: 38, type: !25)
!134 = !DILocation(line: 38, column: 22, scope: !132)
!135 = !DILocation(line: 39, column: 2, scope: !132)
!136 = !DILocation(line: 40, column: 9, scope: !132)
!137 = !DILocation(line: 40, column: 7, scope: !132)
!138 = !DILocation(line: 41, column: 9, scope: !132)
!139 = !DILocation(line: 41, column: 7, scope: !132)
!140 = !DILocation(line: 42, column: 2, scope: !132)
!141 = !DILocation(line: 43, column: 2, scope: !132)
!142 = distinct !DISubprogram(name: "thread_6", scope: !3, file: !3, line: 46, type: !94, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !96)
!143 = !DILocalVariable(name: "arg", arg: 1, scope: !142, file: !3, line: 46, type: !25)
!144 = !DILocation(line: 46, column: 22, scope: !142)
!145 = !DILocation(line: 47, column: 2, scope: !142)
!146 = !DILocation(line: 48, column: 9, scope: !142)
!147 = !DILocation(line: 48, column: 7, scope: !142)
!148 = !DILocation(line: 49, column: 9, scope: !142)
!149 = !DILocation(line: 49, column: 7, scope: !142)
!150 = !DILocation(line: 50, column: 2, scope: !142)
!151 = !DILocation(line: 51, column: 2, scope: !142)
!152 = distinct !DISubprogram(name: "thread_7", scope: !3, file: !3, line: 54, type: !94, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !96)
!153 = !DILocalVariable(name: "arg", arg: 1, scope: !152, file: !3, line: 54, type: !25)
!154 = !DILocation(line: 54, column: 22, scope: !152)
!155 = !DILocation(line: 55, column: 2, scope: !152)
!156 = !DILocation(line: 56, column: 9, scope: !152)
!157 = !DILocation(line: 56, column: 7, scope: !152)
!158 = !DILocation(line: 57, column: 9, scope: !152)
!159 = !DILocation(line: 57, column: 7, scope: !152)
!160 = !DILocation(line: 58, column: 2, scope: !152)
!161 = !DILocation(line: 59, column: 2, scope: !152)
!162 = distinct !DISubprogram(name: "thread_8", scope: !3, file: !3, line: 62, type: !94, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !96)
!163 = !DILocalVariable(name: "arg", arg: 1, scope: !162, file: !3, line: 62, type: !25)
!164 = !DILocation(line: 62, column: 22, scope: !162)
!165 = !DILocation(line: 63, column: 2, scope: !162)
!166 = !DILocation(line: 64, column: 2, scope: !162)
!167 = !DILocation(line: 65, column: 2, scope: !162)
!168 = !DILocation(line: 66, column: 2, scope: !162)
!169 = !DILocation(line: 67, column: 2, scope: !162)
!170 = !DILocation(line: 68, column: 2, scope: !162)
!171 = !DILocation(line: 69, column: 2, scope: !162)
!172 = !DILocation(line: 70, column: 2, scope: !162)
!173 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 73, type: !174, scopeLine: 74, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !96)
!174 = !DISubroutineType(types: !175)
!175 = !{!24}
!176 = !DILocalVariable(name: "t1", scope: !173, file: !3, line: 78, type: !177)
!177 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !178, line: 31, baseType: !179)
!178 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!179 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !180, line: 118, baseType: !181)
!180 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!181 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !182, size: 64)
!182 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !180, line: 103, size: 65536, elements: !183)
!183 = !{!184, !186, !196}
!184 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !182, file: !180, line: 104, baseType: !185, size: 64)
!185 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!186 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !182, file: !180, line: 105, baseType: !187, size: 64, offset: 64)
!187 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !188, size: 64)
!188 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !180, line: 57, size: 192, elements: !189)
!189 = !{!190, !194, !195}
!190 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !188, file: !180, line: 58, baseType: !191, size: 64)
!191 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !192, size: 64)
!192 = !DISubroutineType(types: !193)
!193 = !{null, !25}
!194 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !188, file: !180, line: 59, baseType: !25, size: 64, offset: 64)
!195 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !188, file: !180, line: 60, baseType: !187, size: 64, offset: 128)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !182, file: !180, line: 106, baseType: !197, size: 65408, offset: 128)
!197 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !198)
!198 = !{!199}
!199 = !DISubrange(count: 8176)
!200 = !DILocation(line: 78, column: 15, scope: !173)
!201 = !DILocalVariable(name: "t2", scope: !173, file: !3, line: 78, type: !177)
!202 = !DILocation(line: 78, column: 19, scope: !173)
!203 = !DILocalVariable(name: "t3", scope: !173, file: !3, line: 78, type: !177)
!204 = !DILocation(line: 78, column: 23, scope: !173)
!205 = !DILocalVariable(name: "t4", scope: !173, file: !3, line: 78, type: !177)
!206 = !DILocation(line: 78, column: 27, scope: !173)
!207 = !DILocalVariable(name: "t5", scope: !173, file: !3, line: 78, type: !177)
!208 = !DILocation(line: 78, column: 31, scope: !173)
!209 = !DILocalVariable(name: "t6", scope: !173, file: !3, line: 78, type: !177)
!210 = !DILocation(line: 78, column: 35, scope: !173)
!211 = !DILocalVariable(name: "t7", scope: !173, file: !3, line: 78, type: !177)
!212 = !DILocation(line: 78, column: 39, scope: !173)
!213 = !DILocalVariable(name: "t8", scope: !173, file: !3, line: 78, type: !177)
!214 = !DILocation(line: 78, column: 43, scope: !173)
!215 = !DILocation(line: 80, column: 2, scope: !173)
!216 = !DILocation(line: 81, column: 2, scope: !173)
!217 = !DILocation(line: 82, column: 2, scope: !173)
!218 = !DILocation(line: 83, column: 2, scope: !173)
!219 = !DILocation(line: 84, column: 2, scope: !173)
!220 = !DILocation(line: 85, column: 2, scope: !173)
!221 = !DILocation(line: 86, column: 2, scope: !173)
!222 = !DILocation(line: 87, column: 2, scope: !173)
!223 = !DILocation(line: 89, column: 15, scope: !173)
!224 = !DILocation(line: 89, column: 2, scope: !173)
!225 = !DILocation(line: 90, column: 15, scope: !173)
!226 = !DILocation(line: 90, column: 2, scope: !173)
!227 = !DILocation(line: 91, column: 15, scope: !173)
!228 = !DILocation(line: 91, column: 2, scope: !173)
!229 = !DILocation(line: 92, column: 15, scope: !173)
!230 = !DILocation(line: 92, column: 2, scope: !173)
!231 = !DILocation(line: 93, column: 15, scope: !173)
!232 = !DILocation(line: 93, column: 2, scope: !173)
!233 = !DILocation(line: 94, column: 15, scope: !173)
!234 = !DILocation(line: 94, column: 2, scope: !173)
!235 = !DILocation(line: 95, column: 15, scope: !173)
!236 = !DILocation(line: 95, column: 2, scope: !173)
!237 = !DILocation(line: 96, column: 15, scope: !173)
!238 = !DILocation(line: 96, column: 2, scope: !173)
!239 = !DILocation(line: 98, column: 2, scope: !173)
!240 = !DILocation(line: 0, scope: !173)
!241 = !DILocation(line: 100, column: 2, scope: !173)
