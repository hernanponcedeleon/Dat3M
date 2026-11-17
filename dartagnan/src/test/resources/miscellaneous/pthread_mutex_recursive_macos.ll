; ModuleID = 'pthread_mutex_recursive.c'
source_filename = "pthread_mutex_recursive.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

%struct._opaque_pthread_mutex_t = type { i64, [56 x i8] }
%struct._opaque_pthread_mutexattr_t = type { i64, [8 x i8] }

@mutex = global %struct._opaque_pthread_mutex_t zeroinitializer, align 8, !dbg !0
@__func__.worker = private unnamed_addr constant [7 x i8] c"worker\00", align 1, !dbg !7
@.str = private unnamed_addr constant [26 x i8] c"pthread_mutex_recursive.c\00", align 1, !dbg !14
@.str.1 = private unnamed_addr constant [32 x i8] c"pthread_mutex_lock(&mutex) == 0\00", align 1, !dbg !19
@counter = global i32 0, align 4, !dbg !66
@.str.2 = private unnamed_addr constant [34 x i8] c"pthread_mutex_unlock(&mutex) == 0\00", align 1, !dbg !24
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@.str.3 = private unnamed_addr constant [35 x i8] c"pthread_mutexattr_init(&attr) == 0\00", align 1, !dbg !34
@.str.4 = private unnamed_addr constant [63 x i8] c"pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE) == 0\00", align 1, !dbg !39
@.str.5 = private unnamed_addr constant [80 x i8] c"pthread_mutexattr_gettype(&attr, &type) == 0 && type == PTHREAD_MUTEX_RECURSIVE\00", align 1, !dbg !44
@.str.6 = private unnamed_addr constant [39 x i8] c"pthread_mutex_init(&mutex, &attr) == 0\00", align 1, !dbg !49
@.str.7 = private unnamed_addr constant [38 x i8] c"pthread_mutexattr_destroy(&attr) == 0\00", align 1, !dbg !54
@.str.8 = private unnamed_addr constant [35 x i8] c"pthread_mutex_trylock(&mutex) == 0\00", align 1, !dbg !59
@.str.9 = private unnamed_addr constant [13 x i8] c"counter == 4\00", align 1, !dbg !61

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @worker(ptr noundef %0) #0 !dbg !88 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !92, !DIExpression(), !93)
  %3 = call i32 @pthread_mutex_lock(ptr noundef @mutex), !dbg !94
  %4 = icmp eq i32 %3, 0, !dbg !95
  %5 = xor i1 %4, true, !dbg !96
  %6 = zext i1 %5 to i32, !dbg !96
  %7 = sext i32 %6 to i64, !dbg !96
  %8 = icmp ne i64 %7, 0, !dbg !96
  br i1 %8, label %9, label %11, !dbg !96

9:                                                ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.worker, ptr noundef @.str, i32 noundef 11, ptr noundef @.str.1) #3, !dbg !96
  unreachable, !dbg !96

10:                                               ; No predecessors!
  br label %12, !dbg !96

11:                                               ; preds = %1
  br label %12, !dbg !96

12:                                               ; preds = %11, %10
  %13 = call i32 @pthread_mutex_lock(ptr noundef @mutex), !dbg !97
  %14 = icmp eq i32 %13, 0, !dbg !98
  %15 = xor i1 %14, true, !dbg !99
  %16 = zext i1 %15 to i32, !dbg !99
  %17 = sext i32 %16 to i64, !dbg !99
  %18 = icmp ne i64 %17, 0, !dbg !99
  br i1 %18, label %19, label %21, !dbg !99

19:                                               ; preds = %12
  call void @__assert_rtn(ptr noundef @__func__.worker, ptr noundef @.str, i32 noundef 12, ptr noundef @.str.1) #3, !dbg !99
  unreachable, !dbg !99

20:                                               ; No predecessors!
  br label %22, !dbg !99

21:                                               ; preds = %12
  br label %22, !dbg !99

22:                                               ; preds = %21, %20
  %23 = load i32, ptr @counter, align 4, !dbg !100
  %24 = add nsw i32 %23, 1, !dbg !100
  store i32 %24, ptr @counter, align 4, !dbg !100
  %25 = call i32 @pthread_mutex_unlock(ptr noundef @mutex), !dbg !101
  %26 = icmp eq i32 %25, 0, !dbg !102
  %27 = xor i1 %26, true, !dbg !103
  %28 = zext i1 %27 to i32, !dbg !103
  %29 = sext i32 %28 to i64, !dbg !103
  %30 = icmp ne i64 %29, 0, !dbg !103
  br i1 %30, label %31, label %33, !dbg !103

31:                                               ; preds = %22
  call void @__assert_rtn(ptr noundef @__func__.worker, ptr noundef @.str, i32 noundef 14, ptr noundef @.str.2) #3, !dbg !103
  unreachable, !dbg !103

32:                                               ; No predecessors!
  br label %34, !dbg !103

33:                                               ; preds = %22
  br label %34, !dbg !103

34:                                               ; preds = %33, %32
  %35 = load i32, ptr @counter, align 4, !dbg !104
  %36 = add nsw i32 %35, 1, !dbg !104
  store i32 %36, ptr @counter, align 4, !dbg !104
  %37 = call i32 @pthread_mutex_unlock(ptr noundef @mutex), !dbg !105
  %38 = icmp eq i32 %37, 0, !dbg !106
  %39 = xor i1 %38, true, !dbg !107
  %40 = zext i1 %39 to i32, !dbg !107
  %41 = sext i32 %40 to i64, !dbg !107
  %42 = icmp ne i64 %41, 0, !dbg !107
  br i1 %42, label %43, label %45, !dbg !107

43:                                               ; preds = %34
  call void @__assert_rtn(ptr noundef @__func__.worker, ptr noundef @.str, i32 noundef 16, ptr noundef @.str.2) #3, !dbg !107
  unreachable, !dbg !107

44:                                               ; No predecessors!
  br label %46, !dbg !107

45:                                               ; preds = %34
  br label %46, !dbg !107

46:                                               ; preds = %45, %44
  ret ptr null, !dbg !108
}

declare i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

declare i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 !dbg !109 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_mutexattr_t, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !112, !DIExpression(), !123)
    #dbg_declare(ptr %3, !124, !DIExpression(), !125)
  %6 = call i32 @pthread_mutexattr_init(ptr noundef %2), !dbg !126
  %7 = icmp eq i32 %6, 0, !dbg !127
  %8 = xor i1 %7, true, !dbg !128
  %9 = zext i1 %8 to i32, !dbg !128
  %10 = sext i32 %9 to i64, !dbg !128
  %11 = icmp ne i64 %10, 0, !dbg !128
  br i1 %11, label %12, label %14, !dbg !128

12:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 24, ptr noundef @.str.3) #3, !dbg !128
  unreachable, !dbg !128

13:                                               ; No predecessors!
  br label %15, !dbg !128

14:                                               ; preds = %0
  br label %15, !dbg !128

15:                                               ; preds = %14, %13
  %16 = call i32 @pthread_mutexattr_settype(ptr noundef %2, i32 noundef 2), !dbg !129
  %17 = icmp eq i32 %16, 0, !dbg !130
  %18 = xor i1 %17, true, !dbg !131
  %19 = zext i1 %18 to i32, !dbg !131
  %20 = sext i32 %19 to i64, !dbg !131
  %21 = icmp ne i64 %20, 0, !dbg !131
  br i1 %21, label %22, label %24, !dbg !131

22:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 25, ptr noundef @.str.4) #3, !dbg !131
  unreachable, !dbg !131

23:                                               ; No predecessors!
  br label %25, !dbg !131

24:                                               ; preds = %15
  br label %25, !dbg !131

25:                                               ; preds = %24, %23
  %26 = call i32 @pthread_mutexattr_gettype(ptr noundef %2, ptr noundef %3), !dbg !132
  %27 = icmp eq i32 %26, 0, !dbg !133
  br i1 %27, label %28, label %31, !dbg !134

28:                                               ; preds = %25
  %29 = load i32, ptr %3, align 4, !dbg !135
  %30 = icmp eq i32 %29, 2, !dbg !136
  br label %31

31:                                               ; preds = %28, %25
  %32 = phi i1 [ false, %25 ], [ %30, %28 ], !dbg !137
  %33 = xor i1 %32, true, !dbg !138
  %34 = zext i1 %33 to i32, !dbg !138
  %35 = sext i32 %34 to i64, !dbg !138
  %36 = icmp ne i64 %35, 0, !dbg !138
  br i1 %36, label %37, label %39, !dbg !138

37:                                               ; preds = %31
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 26, ptr noundef @.str.5) #3, !dbg !138
  unreachable, !dbg !138

38:                                               ; No predecessors!
  br label %40, !dbg !138

39:                                               ; preds = %31
  br label %40, !dbg !138

40:                                               ; preds = %39, %38
  %41 = call i32 @pthread_mutex_init(ptr noundef @mutex, ptr noundef %2), !dbg !139
  %42 = icmp eq i32 %41, 0, !dbg !140
  %43 = xor i1 %42, true, !dbg !141
  %44 = zext i1 %43 to i32, !dbg !141
  %45 = sext i32 %44 to i64, !dbg !141
  %46 = icmp ne i64 %45, 0, !dbg !141
  br i1 %46, label %47, label %49, !dbg !141

47:                                               ; preds = %40
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 27, ptr noundef @.str.6) #3, !dbg !141
  unreachable, !dbg !141

48:                                               ; No predecessors!
  br label %50, !dbg !141

49:                                               ; preds = %40
  br label %50, !dbg !141

50:                                               ; preds = %49, %48
  %51 = call i32 @"\01_pthread_mutexattr_destroy"(ptr noundef %2), !dbg !142
  %52 = icmp eq i32 %51, 0, !dbg !143
  %53 = xor i1 %52, true, !dbg !144
  %54 = zext i1 %53 to i32, !dbg !144
  %55 = sext i32 %54 to i64, !dbg !144
  %56 = icmp ne i64 %55, 0, !dbg !144
  br i1 %56, label %57, label %59, !dbg !144

57:                                               ; preds = %50
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 28, ptr noundef @.str.7) #3, !dbg !144
  unreachable, !dbg !144

58:                                               ; No predecessors!
  br label %60, !dbg !144

59:                                               ; preds = %50
  br label %60, !dbg !144

60:                                               ; preds = %59, %58
  %61 = call i32 @pthread_mutex_lock(ptr noundef @mutex), !dbg !145
  %62 = icmp eq i32 %61, 0, !dbg !146
  %63 = xor i1 %62, true, !dbg !147
  %64 = zext i1 %63 to i32, !dbg !147
  %65 = sext i32 %64 to i64, !dbg !147
  %66 = icmp ne i64 %65, 0, !dbg !147
  br i1 %66, label %67, label %69, !dbg !147

67:                                               ; preds = %60
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 30, ptr noundef @.str.1) #3, !dbg !147
  unreachable, !dbg !147

68:                                               ; No predecessors!
  br label %70, !dbg !147

69:                                               ; preds = %60
  br label %70, !dbg !147

70:                                               ; preds = %69, %68
  %71 = call i32 @pthread_mutex_trylock(ptr noundef @mutex), !dbg !148
  %72 = icmp eq i32 %71, 0, !dbg !149
  %73 = xor i1 %72, true, !dbg !150
  %74 = zext i1 %73 to i32, !dbg !150
  %75 = sext i32 %74 to i64, !dbg !150
  %76 = icmp ne i64 %75, 0, !dbg !150
  br i1 %76, label %77, label %79, !dbg !150

77:                                               ; preds = %70
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 31, ptr noundef @.str.8) #3, !dbg !150
  unreachable, !dbg !150

78:                                               ; No predecessors!
  br label %80, !dbg !150

79:                                               ; preds = %70
  br label %80, !dbg !150

80:                                               ; preds = %79, %78
  %81 = call i32 @pthread_mutex_unlock(ptr noundef @mutex), !dbg !151
  %82 = icmp eq i32 %81, 0, !dbg !152
  %83 = xor i1 %82, true, !dbg !153
  %84 = zext i1 %83 to i32, !dbg !153
  %85 = sext i32 %84 to i64, !dbg !153
  %86 = icmp ne i64 %85, 0, !dbg !153
  br i1 %86, label %87, label %89, !dbg !153

87:                                               ; preds = %80
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 32, ptr noundef @.str.2) #3, !dbg !153
  unreachable, !dbg !153

88:                                               ; No predecessors!
  br label %90, !dbg !153

89:                                               ; preds = %80
  br label %90, !dbg !153

90:                                               ; preds = %89, %88
  %91 = call i32 @pthread_mutex_unlock(ptr noundef @mutex), !dbg !154
  %92 = icmp eq i32 %91, 0, !dbg !155
  %93 = xor i1 %92, true, !dbg !156
  %94 = zext i1 %93 to i32, !dbg !156
  %95 = sext i32 %94 to i64, !dbg !156
  %96 = icmp ne i64 %95, 0, !dbg !156
  br i1 %96, label %97, label %99, !dbg !156

97:                                               ; preds = %90
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 33, ptr noundef @.str.2) #3, !dbg !156
  unreachable, !dbg !156

98:                                               ; No predecessors!
  br label %100, !dbg !156

99:                                               ; preds = %90
  br label %100, !dbg !156

100:                                              ; preds = %99, %98
    #dbg_declare(ptr %4, !157, !DIExpression(), !179)
    #dbg_declare(ptr %5, !180, !DIExpression(), !181)
  %101 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @worker, ptr noundef null), !dbg !182
  %102 = call i32 @pthread_create(ptr noundef %5, ptr noundef null, ptr noundef @worker, ptr noundef null), !dbg !183
  %103 = load ptr, ptr %4, align 8, !dbg !184
  %104 = call i32 @"\01_pthread_join"(ptr noundef %103, ptr noundef null), !dbg !185
  %105 = load ptr, ptr %5, align 8, !dbg !186
  %106 = call i32 @"\01_pthread_join"(ptr noundef %105, ptr noundef null), !dbg !187
  %107 = load i32, ptr @counter, align 4, !dbg !188
  %108 = icmp eq i32 %107, 4, !dbg !189
  %109 = xor i1 %108, true, !dbg !190
  %110 = zext i1 %109 to i32, !dbg !190
  %111 = sext i32 %110 to i64, !dbg !190
  %112 = icmp ne i64 %111, 0, !dbg !190
  br i1 %112, label %113, label %115, !dbg !190

113:                                              ; preds = %100
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 40, ptr noundef @.str.9) #3, !dbg !190
  unreachable, !dbg !190

114:                                              ; No predecessors!
  br label %116, !dbg !190

115:                                              ; preds = %100
  br label %116, !dbg !190

116:                                              ; preds = %115, %114
  ret i32 0, !dbg !191
}

declare i32 @pthread_mutexattr_init(ptr noundef) #1

declare i32 @pthread_mutexattr_settype(ptr noundef, i32 noundef) #1

declare i32 @pthread_mutexattr_gettype(ptr noundef, ptr noundef) #1

declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #1

declare i32 @"\01_pthread_mutexattr_destroy"(ptr noundef) #1

declare i32 @pthread_mutex_trylock(ptr noundef) #1

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #3 = { cold noreturn }

!llvm.module.flags = !{!81, !82, !83, !84, !85, !86}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!87}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !3, line: 6, type: !69, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk", sdk: "MacOSX26.sdk")
!3 = !DIFile(filename: "pthread_mutex_recursive.c", directory: "/Users/hponcedeleon/git/Dat3M/benchmarks/miscellaneous", checksumkind: CSK_MD5, checksum: "2e91dcdfdb9b7369b2ec1fbb49516156")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !14, !19, !24, !29, !34, !39, !44, !49, !54, !59, !61, !0, !66}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !3, line: 11, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 56, elements: !12)
!10 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!11 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!12 = !{!13}
!13 = !DISubrange(count: 7)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(scope: null, file: !3, line: 11, type: !16, isLocal: true, isDefinition: true)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 208, elements: !17)
!17 = !{!18}
!18 = !DISubrange(count: 26)
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(scope: null, file: !3, line: 11, type: !21, isLocal: true, isDefinition: true)
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 256, elements: !22)
!22 = !{!23}
!23 = !DISubrange(count: 32)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(scope: null, file: !3, line: 14, type: !26, isLocal: true, isDefinition: true)
!26 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 272, elements: !27)
!27 = !{!28}
!28 = !DISubrange(count: 34)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 40, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: 5)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !36, isLocal: true, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 280, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: 35)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(scope: null, file: !3, line: 25, type: !41, isLocal: true, isDefinition: true)
!41 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 504, elements: !42)
!42 = !{!43}
!43 = !DISubrange(count: 63)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !46, isLocal: true, isDefinition: true)
!46 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 640, elements: !47)
!47 = !{!48}
!48 = !DISubrange(count: 80)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(scope: null, file: !3, line: 27, type: !51, isLocal: true, isDefinition: true)
!51 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 312, elements: !52)
!52 = !{!53}
!53 = !DISubrange(count: 39)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(scope: null, file: !3, line: 28, type: !56, isLocal: true, isDefinition: true)
!56 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 304, elements: !57)
!57 = !{!58}
!58 = !DISubrange(count: 38)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(scope: null, file: !3, line: 31, type: !36, isLocal: true, isDefinition: true)
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(scope: null, file: !3, line: 40, type: !63, isLocal: true, isDefinition: true)
!63 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 104, elements: !64)
!64 = !{!65}
!65 = !DISubrange(count: 13)
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(name: "counter", scope: !2, file: !3, line: 7, type: !68, isLocal: false, isDefinition: true)
!68 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!69 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !70, line: 31, baseType: !71)
!70 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_mutex_t.h", directory: "", checksumkind: CSK_MD5, checksum: "583a89b25a16f85ebbdf32f8d9f237ec")
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutex_t", file: !72, line: 113, baseType: !73)
!72 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!73 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutex_t", file: !72, line: 78, size: 512, elements: !74)
!74 = !{!75, !77}
!75 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !73, file: !72, line: 79, baseType: !76, size: 64)
!76 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !73, file: !72, line: 80, baseType: !78, size: 448, offset: 64)
!78 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 448, elements: !79)
!79 = !{!80}
!80 = !DISubrange(count: 56)
!81 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 5]}
!82 = !{i32 7, !"Dwarf Version", i32 5}
!83 = !{i32 2, !"Debug Info Version", i32 3}
!84 = !{i32 8, !"PIC Level", i32 2}
!85 = !{i32 7, !"uwtable", i32 1}
!86 = !{i32 7, !"frame-pointer", i32 4}
!87 = !{!"Homebrew clang version 23.1.0"}
!88 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 9, type: !89, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !91)
!89 = !DISubroutineType(types: !90)
!90 = !{!5, !5}
!91 = !{}
!92 = !DILocalVariable(name: "arg", arg: 1, scope: !88, file: !3, line: 9, type: !5)
!93 = !DILocation(line: 9, column: 20, scope: !88)
!94 = !DILocation(line: 11, column: 12, scope: !88)
!95 = !DILocation(line: 11, column: 39, scope: !88)
!96 = !DILocation(line: 11, column: 5, scope: !88)
!97 = !DILocation(line: 12, column: 12, scope: !88)
!98 = !DILocation(line: 12, column: 39, scope: !88)
!99 = !DILocation(line: 12, column: 5, scope: !88)
!100 = !DILocation(line: 13, column: 12, scope: !88)
!101 = !DILocation(line: 14, column: 12, scope: !88)
!102 = !DILocation(line: 14, column: 41, scope: !88)
!103 = !DILocation(line: 14, column: 5, scope: !88)
!104 = !DILocation(line: 15, column: 12, scope: !88)
!105 = !DILocation(line: 16, column: 12, scope: !88)
!106 = !DILocation(line: 16, column: 41, scope: !88)
!107 = !DILocation(line: 16, column: 5, scope: !88)
!108 = !DILocation(line: 17, column: 5, scope: !88)
!109 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 20, type: !110, scopeLine: 21, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !91)
!110 = !DISubroutineType(types: !111)
!111 = !{!68}
!112 = !DILocalVariable(name: "attr", scope: !109, file: !3, line: 22, type: !113)
!113 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !114, line: 31, baseType: !115)
!114 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_mutexattr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "785eb3f812f7ebee764058667d4b4693")
!115 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutexattr_t", file: !72, line: 114, baseType: !116)
!116 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutexattr_t", file: !72, line: 83, size: 128, elements: !117)
!117 = !{!118, !119}
!118 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !116, file: !72, line: 84, baseType: !76, size: 64)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !116, file: !72, line: 85, baseType: !120, size: 64, offset: 64)
!120 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 64, elements: !121)
!121 = !{!122}
!122 = !DISubrange(count: 8)
!123 = !DILocation(line: 22, column: 25, scope: !109)
!124 = !DILocalVariable(name: "type", scope: !109, file: !3, line: 23, type: !68)
!125 = !DILocation(line: 23, column: 9, scope: !109)
!126 = !DILocation(line: 24, column: 12, scope: !109)
!127 = !DILocation(line: 24, column: 42, scope: !109)
!128 = !DILocation(line: 24, column: 5, scope: !109)
!129 = !DILocation(line: 25, column: 12, scope: !109)
!130 = !DILocation(line: 25, column: 70, scope: !109)
!131 = !DILocation(line: 25, column: 5, scope: !109)
!132 = !DILocation(line: 26, column: 12, scope: !109)
!133 = !DILocation(line: 26, column: 52, scope: !109)
!134 = !DILocation(line: 26, column: 57, scope: !109)
!135 = !DILocation(line: 26, column: 60, scope: !109)
!136 = !DILocation(line: 26, column: 65, scope: !109)
!137 = !DILocation(line: 0, scope: !109)
!138 = !DILocation(line: 26, column: 5, scope: !109)
!139 = !DILocation(line: 27, column: 12, scope: !109)
!140 = !DILocation(line: 27, column: 46, scope: !109)
!141 = !DILocation(line: 27, column: 5, scope: !109)
!142 = !DILocation(line: 28, column: 12, scope: !109)
!143 = !DILocation(line: 28, column: 45, scope: !109)
!144 = !DILocation(line: 28, column: 5, scope: !109)
!145 = !DILocation(line: 30, column: 12, scope: !109)
!146 = !DILocation(line: 30, column: 39, scope: !109)
!147 = !DILocation(line: 30, column: 5, scope: !109)
!148 = !DILocation(line: 31, column: 12, scope: !109)
!149 = !DILocation(line: 31, column: 42, scope: !109)
!150 = !DILocation(line: 31, column: 5, scope: !109)
!151 = !DILocation(line: 32, column: 12, scope: !109)
!152 = !DILocation(line: 32, column: 41, scope: !109)
!153 = !DILocation(line: 32, column: 5, scope: !109)
!154 = !DILocation(line: 33, column: 12, scope: !109)
!155 = !DILocation(line: 33, column: 41, scope: !109)
!156 = !DILocation(line: 33, column: 5, scope: !109)
!157 = !DILocalVariable(name: "t0", scope: !109, file: !3, line: 35, type: !158)
!158 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !159, line: 31, baseType: !160)
!159 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!160 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !72, line: 118, baseType: !161)
!161 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !162, size: 64)
!162 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !72, line: 103, size: 65536, elements: !163)
!163 = !{!164, !165, !175}
!164 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !162, file: !72, line: 104, baseType: !76, size: 64)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !162, file: !72, line: 105, baseType: !166, size: 64, offset: 64)
!166 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !167, size: 64)
!167 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !72, line: 57, size: 192, elements: !168)
!168 = !{!169, !173, !174}
!169 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !167, file: !72, line: 58, baseType: !170, size: 64)
!170 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !171, size: 64)
!171 = !DISubroutineType(types: !172)
!172 = !{null, !5}
!173 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !167, file: !72, line: 59, baseType: !5, size: 64, offset: 64)
!174 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !167, file: !72, line: 60, baseType: !166, size: 64, offset: 128)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !162, file: !72, line: 106, baseType: !176, size: 65408, offset: 128)
!176 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 65408, elements: !177)
!177 = !{!178}
!178 = !DISubrange(count: 8176)
!179 = !DILocation(line: 35, column: 15, scope: !109)
!180 = !DILocalVariable(name: "t1", scope: !109, file: !3, line: 35, type: !158)
!181 = !DILocation(line: 35, column: 19, scope: !109)
!182 = !DILocation(line: 36, column: 5, scope: !109)
!183 = !DILocation(line: 37, column: 5, scope: !109)
!184 = !DILocation(line: 38, column: 18, scope: !109)
!185 = !DILocation(line: 38, column: 5, scope: !109)
!186 = !DILocation(line: 39, column: 18, scope: !109)
!187 = !DILocation(line: 39, column: 5, scope: !109)
!188 = !DILocation(line: 40, column: 12, scope: !109)
!189 = !DILocation(line: 40, column: 20, scope: !109)
!190 = !DILocation(line: 40, column: 5, scope: !109)
!191 = !DILocation(line: 41, column: 5, scope: !109)
