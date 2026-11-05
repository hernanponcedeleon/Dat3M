; ModuleID = 'benchmarks/exploration/create_nondet.c'
source_filename = "benchmarks/exploration/create_nondet.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

@counter = global i32 0, align 4, !dbg !0
@flag = global i32 0, align 4, !dbg !63
@self = global [2 x ptr] zeroinitializer, align 8, !dbg !68
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !43
@.str = private unnamed_addr constant [16 x i8] c"create_nondet.c\00", align 1, !dbg !49
@.str.1 = private unnamed_addr constant [16 x i8] c"ret == &self[i]\00", align 1, !dbg !54
@.str.2 = private unnamed_addr constant [16 x i8] c"self[i] == t[i]\00", align 1, !dbg !56
@.str.3 = private unnamed_addr constant [58 x i8] c"atomic_load_explicit(&counter, memory_order_relaxed) == n\00", align 1, !dbg !58

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @worker(ptr noundef %0) #0 !dbg !80 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !84, !DIExpression(), !85)
  store i32 1, ptr %3, align 4, !dbg !86
  %5 = load i32, ptr %3, align 4, !dbg !86
  %6 = atomicrmw add ptr @counter, i32 %5 monotonic, align 4, !dbg !86
  store i32 %6, ptr %4, align 4, !dbg !86
  %7 = load i32, ptr %4, align 4, !dbg !86
  %8 = call ptr @pthread_self(), !dbg !87
  %9 = load ptr, ptr %2, align 8, !dbg !88
  store ptr %8, ptr %9, align 8, !dbg !89
  %10 = load ptr, ptr %2, align 8, !dbg !90
  ret ptr %10, !dbg !91
}

declare ptr @pthread_self() #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @setter(ptr noundef %0) #0 !dbg !92 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !93, !DIExpression(), !94)
  store i32 1, ptr %3, align 4, !dbg !95
  %4 = load i32, ptr %3, align 4, !dbg !95
  store atomic i32 %4, ptr @flag monotonic, align 4, !dbg !95
  ret ptr null, !dbg !96
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 !dbg !97 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca [2 x ptr], align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !100, !DIExpression(), !101)
    #dbg_declare(ptr %3, !102, !DIExpression(), !103)
  %10 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @setter, ptr noundef null), !dbg !104
    #dbg_declare(ptr %4, !105, !DIExpression(), !106)
  %11 = load atomic i32, ptr @flag monotonic, align 4, !dbg !107
  store i32 %11, ptr %5, align 4, !dbg !107
  %12 = load i32, ptr %5, align 4, !dbg !107
  %13 = add nsw i32 1, %12, !dbg !108
  store i32 %13, ptr %4, align 4, !dbg !106
    #dbg_declare(ptr %6, !109, !DIExpression(), !111)
  store i32 0, ptr %6, align 4, !dbg !111
  br label %14, !dbg !112

14:                                               ; preds = %26, %0
  %15 = load i32, ptr %6, align 4, !dbg !113
  %16 = load i32, ptr %4, align 4, !dbg !115
  %17 = icmp slt i32 %15, %16, !dbg !116
  br i1 %17, label %18, label %29, !dbg !117

18:                                               ; preds = %14
  %19 = load i32, ptr %6, align 4, !dbg !118
  %20 = sext i32 %19 to i64, !dbg !120
  %21 = getelementptr inbounds [2 x ptr], ptr %3, i64 0, i64 %20, !dbg !120
  %22 = load i32, ptr %6, align 4, !dbg !121
  %23 = sext i32 %22 to i64, !dbg !122
  %24 = getelementptr inbounds [2 x ptr], ptr @self, i64 0, i64 %23, !dbg !122
  %25 = call i32 @pthread_create(ptr noundef %21, ptr noundef null, ptr noundef @worker, ptr noundef %24), !dbg !123
  br label %26, !dbg !124

26:                                               ; preds = %18
  %27 = load i32, ptr %6, align 4, !dbg !125
  %28 = add nsw i32 %27, 1, !dbg !125
  store i32 %28, ptr %6, align 4, !dbg !125
  br label %14, !dbg !126, !llvm.loop !127

29:                                               ; preds = %14
    #dbg_declare(ptr %7, !130, !DIExpression(), !132)
  store i32 0, ptr %7, align 4, !dbg !132
  br label %30, !dbg !133

30:                                               ; preds = %70, %29
  %31 = load i32, ptr %7, align 4, !dbg !134
  %32 = load i32, ptr %4, align 4, !dbg !136
  %33 = icmp slt i32 %31, %32, !dbg !137
  br i1 %33, label %34, label %73, !dbg !138

34:                                               ; preds = %30
    #dbg_declare(ptr %8, !139, !DIExpression(), !141)
  %35 = load i32, ptr %7, align 4, !dbg !142
  %36 = sext i32 %35 to i64, !dbg !143
  %37 = getelementptr inbounds [2 x ptr], ptr %3, i64 0, i64 %36, !dbg !143
  %38 = load ptr, ptr %37, align 8, !dbg !143
  %39 = call i32 @"\01_pthread_join"(ptr noundef %38, ptr noundef %8), !dbg !144
  %40 = load ptr, ptr %8, align 8, !dbg !145
  %41 = load i32, ptr %7, align 4, !dbg !146
  %42 = sext i32 %41 to i64, !dbg !147
  %43 = getelementptr inbounds [2 x ptr], ptr @self, i64 0, i64 %42, !dbg !147
  %44 = icmp eq ptr %40, %43, !dbg !148
  %45 = xor i1 %44, true, !dbg !149
  %46 = zext i1 %45 to i32, !dbg !149
  %47 = sext i32 %46 to i64, !dbg !149
  %48 = icmp ne i64 %47, 0, !dbg !149
  br i1 %48, label %49, label %51, !dbg !149

49:                                               ; preds = %34
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 33, ptr noundef @.str.1) #3, !dbg !149
  unreachable, !dbg !149

50:                                               ; No predecessors!
  br label %52, !dbg !149

51:                                               ; preds = %34
  br label %52, !dbg !149

52:                                               ; preds = %51, %50
  %53 = load i32, ptr %7, align 4, !dbg !150
  %54 = sext i32 %53 to i64, !dbg !151
  %55 = getelementptr inbounds [2 x ptr], ptr @self, i64 0, i64 %54, !dbg !151
  %56 = load ptr, ptr %55, align 8, !dbg !151
  %57 = load i32, ptr %7, align 4, !dbg !152
  %58 = sext i32 %57 to i64, !dbg !153
  %59 = getelementptr inbounds [2 x ptr], ptr %3, i64 0, i64 %58, !dbg !153
  %60 = load ptr, ptr %59, align 8, !dbg !153
  %61 = icmp eq ptr %56, %60, !dbg !154
  %62 = xor i1 %61, true, !dbg !155
  %63 = zext i1 %62 to i32, !dbg !155
  %64 = sext i32 %63 to i64, !dbg !155
  %65 = icmp ne i64 %64, 0, !dbg !155
  br i1 %65, label %66, label %68, !dbg !155

66:                                               ; preds = %52
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 34, ptr noundef @.str.2) #3, !dbg !155
  unreachable, !dbg !155

67:                                               ; No predecessors!
  br label %69, !dbg !155

68:                                               ; preds = %52
  br label %69, !dbg !155

69:                                               ; preds = %68, %67
  br label %70, !dbg !156

70:                                               ; preds = %69
  %71 = load i32, ptr %7, align 4, !dbg !157
  %72 = add nsw i32 %71, 1, !dbg !157
  store i32 %72, ptr %7, align 4, !dbg !157
  br label %30, !dbg !158, !llvm.loop !159

73:                                               ; preds = %30
  %74 = load ptr, ptr %2, align 8, !dbg !161
  %75 = call i32 @"\01_pthread_join"(ptr noundef %74, ptr noundef null), !dbg !162
  %76 = load atomic i32, ptr @counter monotonic, align 4, !dbg !163
  store i32 %76, ptr %9, align 4, !dbg !163
  %77 = load i32, ptr %9, align 4, !dbg !163
  %78 = load i32, ptr %4, align 4, !dbg !164
  %79 = icmp eq i32 %77, %78, !dbg !165
  %80 = xor i1 %79, true, !dbg !166
  %81 = zext i1 %80 to i32, !dbg !166
  %82 = sext i32 %81 to i64, !dbg !166
  %83 = icmp ne i64 %82, 0, !dbg !166
  br i1 %83, label %84, label %86, !dbg !166

84:                                               ; preds = %73
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 37, ptr noundef @.str.3) #3, !dbg !166
  unreachable, !dbg !166

85:                                               ; No predecessors!
  br label %87, !dbg !166

86:                                               ; preds = %73
  br label %87, !dbg !166

87:                                               ; preds = %86, %85
  ret i32 0, !dbg !167
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #3 = { cold noreturn }

!llvm.module.flags = !{!73, !74, !75, !76, !77, !78}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!79}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "counter", scope: !2, file: !3, line: 9, type: !65, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !42, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk", sdk: "MacOSX26.sdk")
!3 = !DIFile(filename: "benchmarks/exploration/create_nondet.c", directory: "/Users/hponcedeleon/git/agent-4/Dat3M", checksumkind: CSK_MD5, checksum: "bef990ca930b168fc62f8188bc40f717")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 68, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/opt/homebrew/Cellar/llvm/23.1.0/lib/clang/23/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "f17199a988fe91afffaf0f943ef87096")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16, !34}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !18, line: 31, baseType: !19)
!18 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !20, line: 118, baseType: !21)
!20 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!21 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!22 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !20, line: 103, size: 65536, elements: !23)
!23 = !{!24, !26, !37}
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !22, file: !20, line: 104, baseType: !25, size: 64)
!25 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !22, file: !20, line: 105, baseType: !27, size: 64, offset: 64)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!28 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !20, line: 57, size: 192, elements: !29)
!29 = !{!30, !35, !36}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !28, file: !20, line: 58, baseType: !31, size: 64)
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!32 = !DISubroutineType(types: !33)
!33 = !{null, !34}
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !28, file: !20, line: 59, baseType: !34, size: 64, offset: 64)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !28, file: !20, line: 60, baseType: !27, size: 64, offset: 128)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !22, file: !20, line: 106, baseType: !38, size: 65408, offset: 128)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 65408, elements: !40)
!39 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!40 = !{!41}
!41 = !DISubrange(count: 8176)
!42 = !{!43, !49, !54, !56, !58, !63, !0, !68}
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !3, line: 33, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 40, elements: !47)
!46 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !39)
!47 = !{!48}
!48 = !DISubrange(count: 5)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(scope: null, file: !3, line: 33, type: !51, isLocal: true, isDefinition: true)
!51 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 128, elements: !52)
!52 = !{!53}
!53 = !DISubrange(count: 16)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(scope: null, file: !3, line: 33, type: !51, isLocal: true, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(scope: null, file: !3, line: 34, type: !51, isLocal: true, isDefinition: true)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(scope: null, file: !3, line: 37, type: !60, isLocal: true, isDefinition: true)
!60 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 464, elements: !61)
!61 = !{!62}
!62 = !DISubrange(count: 58)
!63 = !DIGlobalVariableExpression(var: !64, expr: !DIExpression())
!64 = distinct !DIGlobalVariable(name: "flag", scope: !2, file: !3, line: 8, type: !65, isLocal: false, isDefinition: true)
!65 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 104, baseType: !66)
!66 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !67)
!67 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(name: "self", scope: !2, file: !3, line: 10, type: !70, isLocal: false, isDefinition: true)
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 128, elements: !71)
!71 = !{!72}
!72 = !DISubrange(count: 2)
!73 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 5]}
!74 = !{i32 7, !"Dwarf Version", i32 5}
!75 = !{i32 2, !"Debug Info Version", i32 3}
!76 = !{i32 8, !"PIC Level", i32 2}
!77 = !{i32 7, !"uwtable", i32 1}
!78 = !{i32 7, !"frame-pointer", i32 4}
!79 = !{!"Homebrew clang version 23.1.0"}
!80 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 12, type: !81, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!81 = !DISubroutineType(types: !82)
!82 = !{!34, !34}
!83 = !{}
!84 = !DILocalVariable(name: "arg", arg: 1, scope: !80, file: !3, line: 12, type: !34)
!85 = !DILocation(line: 12, column: 20, scope: !80)
!86 = !DILocation(line: 13, column: 5, scope: !80)
!87 = !DILocation(line: 14, column: 26, scope: !80)
!88 = !DILocation(line: 14, column: 20, scope: !80)
!89 = !DILocation(line: 14, column: 24, scope: !80)
!90 = !DILocation(line: 15, column: 12, scope: !80)
!91 = !DILocation(line: 15, column: 5, scope: !80)
!92 = distinct !DISubprogram(name: "setter", scope: !3, file: !3, line: 18, type: !81, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!93 = !DILocalVariable(name: "arg", arg: 1, scope: !92, file: !3, line: 18, type: !34)
!94 = !DILocation(line: 18, column: 20, scope: !92)
!95 = !DILocation(line: 19, column: 5, scope: !92)
!96 = !DILocation(line: 20, column: 5, scope: !92)
!97 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 23, type: !98, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !83)
!98 = !DISubroutineType(types: !99)
!99 = !{!67}
!100 = !DILocalVariable(name: "s", scope: !97, file: !3, line: 24, type: !17)
!101 = !DILocation(line: 24, column: 15, scope: !97)
!102 = !DILocalVariable(name: "t", scope: !97, file: !3, line: 24, type: !70)
!103 = !DILocation(line: 24, column: 18, scope: !97)
!104 = !DILocation(line: 25, column: 5, scope: !97)
!105 = !DILocalVariable(name: "n", scope: !97, file: !3, line: 26, type: !67)
!106 = !DILocation(line: 26, column: 9, scope: !97)
!107 = !DILocation(line: 26, column: 17, scope: !97)
!108 = !DILocation(line: 26, column: 15, scope: !97)
!109 = !DILocalVariable(name: "i", scope: !110, file: !3, line: 27, type: !67)
!110 = distinct !DILexicalBlock(scope: !97, file: !3, line: 27, column: 5)
!111 = !DILocation(line: 27, column: 14, scope: !110)
!112 = !DILocation(line: 27, column: 10, scope: !110)
!113 = !DILocation(line: 27, column: 21, scope: !114)
!114 = distinct !DILexicalBlock(scope: !110, file: !3, line: 27, column: 5)
!115 = !DILocation(line: 27, column: 25, scope: !114)
!116 = !DILocation(line: 27, column: 23, scope: !114)
!117 = !DILocation(line: 27, column: 5, scope: !110)
!118 = !DILocation(line: 28, column: 27, scope: !119)
!119 = distinct !DILexicalBlock(scope: !114, file: !3, line: 27, column: 33)
!120 = !DILocation(line: 28, column: 25, scope: !119)
!121 = !DILocation(line: 28, column: 51, scope: !119)
!122 = !DILocation(line: 28, column: 46, scope: !119)
!123 = !DILocation(line: 28, column: 9, scope: !119)
!124 = !DILocation(line: 29, column: 5, scope: !119)
!125 = !DILocation(line: 27, column: 29, scope: !114)
!126 = !DILocation(line: 27, column: 5, scope: !114)
!127 = distinct !{!127, !117, !128, !129}
!128 = !DILocation(line: 29, column: 5, scope: !110)
!129 = !{!"llvm.loop.mustprogress"}
!130 = !DILocalVariable(name: "i", scope: !131, file: !3, line: 30, type: !67)
!131 = distinct !DILexicalBlock(scope: !97, file: !3, line: 30, column: 5)
!132 = !DILocation(line: 30, column: 14, scope: !131)
!133 = !DILocation(line: 30, column: 10, scope: !131)
!134 = !DILocation(line: 30, column: 21, scope: !135)
!135 = distinct !DILexicalBlock(scope: !131, file: !3, line: 30, column: 5)
!136 = !DILocation(line: 30, column: 25, scope: !135)
!137 = !DILocation(line: 30, column: 23, scope: !135)
!138 = !DILocation(line: 30, column: 5, scope: !131)
!139 = !DILocalVariable(name: "ret", scope: !140, file: !3, line: 31, type: !34)
!140 = distinct !DILexicalBlock(scope: !135, file: !3, line: 30, column: 33)
!141 = !DILocation(line: 31, column: 15, scope: !140)
!142 = !DILocation(line: 32, column: 24, scope: !140)
!143 = !DILocation(line: 32, column: 22, scope: !140)
!144 = !DILocation(line: 32, column: 9, scope: !140)
!145 = !DILocation(line: 33, column: 16, scope: !140)
!146 = !DILocation(line: 33, column: 29, scope: !140)
!147 = !DILocation(line: 33, column: 24, scope: !140)
!148 = !DILocation(line: 33, column: 20, scope: !140)
!149 = !DILocation(line: 33, column: 9, scope: !140)
!150 = !DILocation(line: 34, column: 21, scope: !140)
!151 = !DILocation(line: 34, column: 16, scope: !140)
!152 = !DILocation(line: 34, column: 29, scope: !140)
!153 = !DILocation(line: 34, column: 27, scope: !140)
!154 = !DILocation(line: 34, column: 24, scope: !140)
!155 = !DILocation(line: 34, column: 9, scope: !140)
!156 = !DILocation(line: 35, column: 5, scope: !140)
!157 = !DILocation(line: 30, column: 29, scope: !135)
!158 = !DILocation(line: 30, column: 5, scope: !135)
!159 = distinct !{!159, !138, !160, !129}
!160 = !DILocation(line: 35, column: 5, scope: !131)
!161 = !DILocation(line: 36, column: 18, scope: !97)
!162 = !DILocation(line: 36, column: 5, scope: !97)
!163 = !DILocation(line: 37, column: 12, scope: !97)
!164 = !DILocation(line: 37, column: 68, scope: !97)
!165 = !DILocation(line: 37, column: 65, scope: !97)
!166 = !DILocation(line: 37, column: 5, scope: !97)
!167 = !DILocation(line: 38, column: 5, scope: !97)
