; ModuleID = 'local/recursion.ll'
source_filename = "benchmarks/c/miscellaneous/recursion.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx13.0.0"

@x = global i32 0, align 4, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !18
@.str = private unnamed_addr constant [12 x i8] c"recursion.c\00", align 1, !dbg !25
@.str.1 = private unnamed_addr constant [12 x i8] c"result == 2\00", align 1, !dbg !30

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @fibonacci(i32 noundef %0) #0 !dbg !42 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !46, metadata !DIExpression()), !dbg !47
  %3 = load i32, ptr %2, align 4, !dbg !48
  %4 = icmp eq i32 %3, 0, !dbg !49
  br i1 %4, label %5, label %6, !dbg !48

5:                                                ; preds = %1
  br label %20, !dbg !48

6:                                                ; preds = %1
  %7 = load i32, ptr %2, align 4, !dbg !50
  %8 = icmp eq i32 %7, 1, !dbg !51
  br i1 %8, label %9, label %10, !dbg !50

9:                                                ; preds = %6
  br label %18, !dbg !50

10:                                               ; preds = %6
  %11 = load i32, ptr %2, align 4, !dbg !52
  %12 = sub nsw i32 %11, 1, !dbg !53
  %13 = call i32 @fib(i32 noundef %12), !dbg !54
  %14 = load i32, ptr %2, align 4, !dbg !55
  %15 = sub nsw i32 %14, 2, !dbg !56
  %16 = call i32 @fibonacci(i32 noundef %15), !dbg !57
  %17 = add nsw i32 %13, %16, !dbg !58
  br label %18, !dbg !50

18:                                               ; preds = %10, %9
  %19 = phi i32 [ 1, %9 ], [ %17, %10 ], !dbg !50
  br label %20, !dbg !48

20:                                               ; preds = %18, %5
  %21 = phi i32 [ 1, %5 ], [ %19, %18 ], !dbg !48
  ret i32 %21, !dbg !59
}

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @fib(i32 noundef %0) #0 !dbg !60 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !61, metadata !DIExpression()), !dbg !62
  %3 = load i32, ptr %2, align 4, !dbg !63
  %4 = call i32 @fibonacci(i32 noundef %3), !dbg !64
  ret i32 %4, !dbg !65
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @ackermann(i32 noundef %0, i32 noundef %1) #0 !dbg !66 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  call void @llvm.dbg.declare(metadata ptr %3, metadata !69, metadata !DIExpression()), !dbg !70
  store i32 %1, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !71, metadata !DIExpression()), !dbg !72
  %5 = load i32, ptr %3, align 4, !dbg !73
  %6 = icmp eq i32 %5, 0, !dbg !74
  br i1 %6, label %7, label %10, !dbg !73

7:                                                ; preds = %2
  %8 = load i32, ptr %4, align 4, !dbg !75
  %9 = add nsw i32 %8, 1, !dbg !76
  br label %27, !dbg !73

10:                                               ; preds = %2
  %11 = load i32, ptr %4, align 4, !dbg !77
  %12 = icmp eq i32 %11, 0, !dbg !78
  br i1 %12, label %13, label %17, !dbg !77

13:                                               ; preds = %10
  %14 = load i32, ptr %3, align 4, !dbg !79
  %15 = sub nsw i32 %14, 1, !dbg !80
  %16 = call i32 @ack(i32 noundef %15, i32 noundef 1), !dbg !81
  br label %25, !dbg !77

17:                                               ; preds = %10
  %18 = load i32, ptr %3, align 4, !dbg !82
  %19 = sub nsw i32 %18, 1, !dbg !83
  %20 = load i32, ptr %3, align 4, !dbg !84
  %21 = load i32, ptr %4, align 4, !dbg !85
  %22 = sub nsw i32 %21, 1, !dbg !86
  %23 = call i32 @ack(i32 noundef %20, i32 noundef %22), !dbg !87
  %24 = call i32 @ack(i32 noundef %19, i32 noundef %23), !dbg !88
  br label %25, !dbg !77

25:                                               ; preds = %17, %13
  %26 = phi i32 [ %16, %13 ], [ %24, %17 ], !dbg !77
  br label %27, !dbg !73

27:                                               ; preds = %25, %7
  %28 = phi i32 [ %9, %7 ], [ %26, %25 ], !dbg !73
  ret i32 %28, !dbg !89
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @ack(i32 noundef %0, i32 noundef %1) #0 !dbg !90 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  call void @llvm.dbg.declare(metadata ptr %3, metadata !91, metadata !DIExpression()), !dbg !92
  store i32 %1, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !93, metadata !DIExpression()), !dbg !94
  %5 = load i32, ptr %3, align 4, !dbg !95
  %6 = load i32, ptr %4, align 4, !dbg !96
  %7 = call i32 @ackermann(i32 noundef %5, i32 noundef %6), !dbg !97
  ret i32 %7, !dbg !98
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @fun(i32 noundef %0) #0 !dbg !99 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !100, metadata !DIExpression()), !dbg !101
  %3 = load i32, ptr %2, align 4, !dbg !102
  %4 = call i32 @fibonacci(i32 noundef %3), !dbg !103
  ret i32 %4, !dbg !104
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define ptr @worker(ptr noundef %0) #0 !dbg !105 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !108, metadata !DIExpression()), !dbg !109
  %7 = load ptr, ptr %2, align 8, !dbg !110
  call void @llvm.dbg.declare(metadata ptr %3, metadata !111, metadata !DIExpression()), !dbg !112
  %8 = load atomic i32, ptr @x monotonic, align 4, !dbg !113
  store i32 %8, ptr %4, align 4, !dbg !113
  %9 = load i32, ptr %4, align 4, !dbg !113
  store i32 %9, ptr %3, align 4, !dbg !112
  call void @llvm.dbg.declare(metadata ptr %5, metadata !114, metadata !DIExpression()), !dbg !115
  %10 = load i32, ptr %3, align 4, !dbg !116
  %11 = call i32 @fun(i32 noundef %10), !dbg !117
  store i32 %11, ptr %5, align 4, !dbg !115
  %12 = load i32, ptr %5, align 4, !dbg !118
  store i32 %12, ptr %6, align 4, !dbg !119
  %13 = load i32, ptr %6, align 4, !dbg !119
  store atomic i32 %13, ptr @x monotonic, align 4, !dbg !119
  ret ptr null, !dbg !120
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @main() #0 !dbg !121 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !124, metadata !DIExpression()), !dbg !148
  store i32 2, ptr @x, align 4, !dbg !149
  %9 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @worker, ptr noundef null), !dbg !150
  call void @llvm.dbg.declare(metadata ptr %3, metadata !151, metadata !DIExpression()), !dbg !152
  %10 = load atomic i32, ptr @x monotonic, align 4, !dbg !153
  store i32 %10, ptr %4, align 4, !dbg !153
  %11 = load i32, ptr %4, align 4, !dbg !153
  store i32 %11, ptr %3, align 4, !dbg !152
  call void @llvm.dbg.declare(metadata ptr %5, metadata !154, metadata !DIExpression()), !dbg !155
  %12 = load i32, ptr %3, align 4, !dbg !156
  %13 = call i32 @fun(i32 noundef %12), !dbg !157
  store i32 %13, ptr %5, align 4, !dbg !155
  %14 = load i32, ptr %5, align 4, !dbg !158
  store i32 %14, ptr %6, align 4, !dbg !159
  %15 = load i32, ptr %6, align 4, !dbg !159
  store atomic i32 %15, ptr @x monotonic, align 4, !dbg !159
  call void @llvm.dbg.declare(metadata ptr %7, metadata !160, metadata !DIExpression()), !dbg !161
  %16 = load atomic i32, ptr @x monotonic, align 4, !dbg !162
  store i32 %16, ptr %8, align 4, !dbg !162
  %17 = load i32, ptr %8, align 4, !dbg !162
  store i32 %17, ptr %7, align 4, !dbg !161
  %18 = load ptr, ptr %2, align 8, !dbg !163
  %19 = call i32 @"\01_pthread_join"(ptr noundef %18, ptr noundef null), !dbg !164
  %20 = load i32, ptr %7, align 4, !dbg !165
  %21 = icmp eq i32 %20, 2, !dbg !165
  %22 = xor i1 %21, true, !dbg !165
  %23 = zext i1 %22 to i32, !dbg !165
  %24 = sext i32 %23 to i64, !dbg !165
  %25 = icmp ne i64 %24, 0, !dbg !165
  br i1 %25, label %26, label %28, !dbg !165

26:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 66, ptr noundef @.str.1) #4, !dbg !165
  unreachable, !dbg !165

27:                                               ; No predecessors!
  br label %29, !dbg !165

28:                                               ; preds = %0
  br label %29, !dbg !165

29:                                               ; preds = %28, %27
  ret i32 0, !dbg !166
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

attributes #0 = { noinline nounwind optnone ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #4 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!35, !36, !37, !38, !39, !40}
!llvm.ident = !{!41}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 31, type: !32, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 15.0.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "benchmarks/c/miscellaneous/recursion.c", directory: "/Users/r/Desktop/Dat3M")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 57, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/opt/homebrew/Cellar/llvm@15/15.0.7/lib/clang/15.0.7/include/stdatomic.h", directory: "")
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
!17 = !{!18, !25, !30, !0}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !3, line: 66, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 40, elements: !23)
!21 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !22)
!22 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!23 = !{!24}
!24 = !DISubrange(count: 5)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(scope: null, file: !3, line: 66, type: !27, isLocal: true, isDefinition: true)
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 96, elements: !28)
!28 = !{!29}
!29 = !DISubrange(count: 12)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 66, type: !27, isLocal: true, isDefinition: true)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 93, baseType: !33)
!33 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !34)
!34 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!35 = !{i32 7, !"Dwarf Version", i32 4}
!36 = !{i32 2, !"Debug Info Version", i32 3}
!37 = !{i32 1, !"wchar_size", i32 4}
!38 = !{i32 7, !"PIC Level", i32 2}
!39 = !{i32 7, !"uwtable", i32 2}
!40 = !{i32 7, !"frame-pointer", i32 1}
!41 = !{!"Homebrew clang version 15.0.7"}
!42 = distinct !DISubprogram(name: "fibonacci", scope: !3, file: !3, line: 5, type: !43, scopeLine: 6, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!43 = !DISubroutineType(types: !44)
!44 = !{!34, !34}
!45 = !{}
!46 = !DILocalVariable(name: "n", arg: 1, scope: !42, file: !3, line: 5, type: !34)
!47 = !DILocation(line: 5, column: 19, scope: !42)
!48 = !DILocation(line: 7, column: 12, scope: !42)
!49 = !DILocation(line: 7, column: 14, scope: !42)
!50 = !DILocation(line: 7, column: 25, scope: !42)
!51 = !DILocation(line: 7, column: 27, scope: !42)
!52 = !DILocation(line: 7, column: 42, scope: !42)
!53 = !DILocation(line: 7, column: 44, scope: !42)
!54 = !DILocation(line: 7, column: 38, scope: !42)
!55 = !DILocation(line: 7, column: 61, scope: !42)
!56 = !DILocation(line: 7, column: 63, scope: !42)
!57 = !DILocation(line: 7, column: 51, scope: !42)
!58 = !DILocation(line: 7, column: 49, scope: !42)
!59 = !DILocation(line: 7, column: 5, scope: !42)
!60 = distinct !DISubprogram(name: "fib", scope: !3, file: !3, line: 9, type: !43, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!61 = !DILocalVariable(name: "n", arg: 1, scope: !60, file: !3, line: 9, type: !34)
!62 = !DILocation(line: 9, column: 13, scope: !60)
!63 = !DILocation(line: 11, column: 22, scope: !60)
!64 = !DILocation(line: 11, column: 12, scope: !60)
!65 = !DILocation(line: 11, column: 5, scope: !60)
!66 = distinct !DISubprogram(name: "ackermann", scope: !3, file: !3, line: 15, type: !67, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!67 = !DISubroutineType(types: !68)
!68 = !{!34, !34, !34}
!69 = !DILocalVariable(name: "m", arg: 1, scope: !66, file: !3, line: 15, type: !34)
!70 = !DILocation(line: 15, column: 19, scope: !66)
!71 = !DILocalVariable(name: "n", arg: 2, scope: !66, file: !3, line: 15, type: !34)
!72 = !DILocation(line: 15, column: 26, scope: !66)
!73 = !DILocation(line: 17, column: 12, scope: !66)
!74 = !DILocation(line: 17, column: 14, scope: !66)
!75 = !DILocation(line: 17, column: 21, scope: !66)
!76 = !DILocation(line: 17, column: 23, scope: !66)
!77 = !DILocation(line: 17, column: 29, scope: !66)
!78 = !DILocation(line: 17, column: 31, scope: !66)
!79 = !DILocation(line: 17, column: 42, scope: !66)
!80 = !DILocation(line: 17, column: 44, scope: !66)
!81 = !DILocation(line: 17, column: 38, scope: !66)
!82 = !DILocation(line: 17, column: 58, scope: !66)
!83 = !DILocation(line: 17, column: 60, scope: !66)
!84 = !DILocation(line: 17, column: 69, scope: !66)
!85 = !DILocation(line: 17, column: 72, scope: !66)
!86 = !DILocation(line: 17, column: 74, scope: !66)
!87 = !DILocation(line: 17, column: 65, scope: !66)
!88 = !DILocation(line: 17, column: 54, scope: !66)
!89 = !DILocation(line: 17, column: 5, scope: !66)
!90 = distinct !DISubprogram(name: "ack", scope: !3, file: !3, line: 19, type: !67, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!91 = !DILocalVariable(name: "m", arg: 1, scope: !90, file: !3, line: 19, type: !34)
!92 = !DILocation(line: 19, column: 13, scope: !90)
!93 = !DILocalVariable(name: "n", arg: 2, scope: !90, file: !3, line: 19, type: !34)
!94 = !DILocation(line: 19, column: 20, scope: !90)
!95 = !DILocation(line: 21, column: 22, scope: !90)
!96 = !DILocation(line: 21, column: 25, scope: !90)
!97 = !DILocation(line: 21, column: 12, scope: !90)
!98 = !DILocation(line: 21, column: 5, scope: !90)
!99 = distinct !DISubprogram(name: "fun", scope: !3, file: !3, line: 23, type: !43, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!100 = !DILocalVariable(name: "n", arg: 1, scope: !99, file: !3, line: 23, type: !34)
!101 = !DILocation(line: 23, column: 13, scope: !99)
!102 = !DILocation(line: 28, column: 22, scope: !99)
!103 = !DILocation(line: 28, column: 12, scope: !99)
!104 = !DILocation(line: 28, column: 5, scope: !99)
!105 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 32, type: !106, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!106 = !DISubroutineType(types: !107)
!107 = !{!16, !16}
!108 = !DILocalVariable(name: "p", arg: 1, scope: !105, file: !3, line: 32, type: !16)
!109 = !DILocation(line: 32, column: 20, scope: !105)
!110 = !DILocation(line: 34, column: 12, scope: !105)
!111 = !DILocalVariable(name: "n", scope: !105, file: !3, line: 35, type: !34)
!112 = !DILocation(line: 35, column: 9, scope: !105)
!113 = !DILocation(line: 35, column: 13, scope: !105)
!114 = !DILocalVariable(name: "a", scope: !105, file: !3, line: 36, type: !34)
!115 = !DILocation(line: 36, column: 9, scope: !105)
!116 = !DILocation(line: 36, column: 17, scope: !105)
!117 = !DILocation(line: 36, column: 13, scope: !105)
!118 = !DILocation(line: 37, column: 31, scope: !105)
!119 = !DILocation(line: 37, column: 5, scope: !105)
!120 = !DILocation(line: 38, column: 5, scope: !105)
!121 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 40, type: !122, scopeLine: 41, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!122 = !DISubroutineType(types: !123)
!123 = !{!34}
!124 = !DILocalVariable(name: "t0", scope: !121, file: !3, line: 42, type: !125)
!125 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !126, line: 31, baseType: !127)
!126 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!127 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !128, line: 118, baseType: !129)
!128 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!129 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !130, size: 64)
!130 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !128, line: 103, size: 65536, elements: !131)
!131 = !{!132, !134, !144}
!132 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !130, file: !128, line: 104, baseType: !133, size: 64)
!133 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !130, file: !128, line: 105, baseType: !135, size: 64, offset: 64)
!135 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !136, size: 64)
!136 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !128, line: 57, size: 192, elements: !137)
!137 = !{!138, !142, !143}
!138 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !136, file: !128, line: 58, baseType: !139, size: 64)
!139 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !140, size: 64)
!140 = !DISubroutineType(types: !141)
!141 = !{null, !16}
!142 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !136, file: !128, line: 59, baseType: !16, size: 64, offset: 64)
!143 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !136, file: !128, line: 60, baseType: !135, size: 64, offset: 128)
!144 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !130, file: !128, line: 106, baseType: !145, size: 65408, offset: 128)
!145 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 65408, elements: !146)
!146 = !{!147}
!147 = !DISubrange(count: 8176)
!148 = !DILocation(line: 42, column: 15, scope: !121)
!149 = !DILocation(line: 49, column: 5, scope: !121)
!150 = !DILocation(line: 52, column: 5, scope: !121)
!151 = !DILocalVariable(name: "n", scope: !121, file: !3, line: 53, type: !34)
!152 = !DILocation(line: 53, column: 9, scope: !121)
!153 = !DILocation(line: 53, column: 13, scope: !121)
!154 = !DILocalVariable(name: "a", scope: !121, file: !3, line: 54, type: !34)
!155 = !DILocation(line: 54, column: 9, scope: !121)
!156 = !DILocation(line: 54, column: 17, scope: !121)
!157 = !DILocation(line: 54, column: 13, scope: !121)
!158 = !DILocation(line: 55, column: 31, scope: !121)
!159 = !DILocation(line: 55, column: 5, scope: !121)
!160 = !DILocalVariable(name: "result", scope: !121, file: !3, line: 56, type: !34)
!161 = !DILocation(line: 56, column: 9, scope: !121)
!162 = !DILocation(line: 56, column: 18, scope: !121)
!163 = !DILocation(line: 57, column: 18, scope: !121)
!164 = !DILocation(line: 57, column: 5, scope: !121)
!165 = !DILocation(line: 66, column: 5, scope: !121)
!166 = !DILocation(line: 69, column: 5, scope: !121)
