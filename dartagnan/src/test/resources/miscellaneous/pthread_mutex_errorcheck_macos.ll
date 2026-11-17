; ModuleID = 'pthread_mutex_errorcheck.c'
source_filename = "pthread_mutex_errorcheck.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

%struct._opaque_pthread_mutex_t = type { i64, [56 x i8] }
%struct._opaque_pthread_mutexattr_t = type { i64, [8 x i8] }

@initialized = global %struct._opaque_pthread_mutex_t { i64 850045857, [56 x i8] zeroinitializer }, align 8, !dbg !0
@__func__.check = private unnamed_addr constant [6 x i8] c"check\00", align 1, !dbg !5
@.str = private unnamed_addr constant [27 x i8] c"pthread_mutex_errorcheck.c\00", align 1, !dbg !12
@.str.1 = private unnamed_addr constant [31 x i8] c"pthread_mutex_lock(mutex) == 0\00", align 1, !dbg !17
@.str.2 = private unnamed_addr constant [37 x i8] c"pthread_mutex_lock(mutex) == EDEADLK\00", align 1, !dbg !22
@.str.3 = private unnamed_addr constant [38 x i8] c"pthread_mutex_trylock(mutex) == EBUSY\00", align 1, !dbg !27
@.str.4 = private unnamed_addr constant [33 x i8] c"pthread_mutex_unlock(mutex) == 0\00", align 1, !dbg !32
@.str.5 = private unnamed_addr constant [34 x i8] c"pthread_mutex_trylock(mutex) == 0\00", align 1, !dbg !37

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @check(ptr noundef %0) #0 !dbg !61 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !66, !DIExpression(), !67)
  %3 = load ptr, ptr %2, align 8, !dbg !68
  %4 = call i32 @pthread_mutex_lock(ptr noundef %3), !dbg !69
  %5 = icmp eq i32 %4, 0, !dbg !70
  %6 = xor i1 %5, true, !dbg !71
  %7 = zext i1 %6 to i32, !dbg !71
  %8 = sext i32 %7 to i64, !dbg !71
  %9 = icmp ne i64 %8, 0, !dbg !71
  br i1 %9, label %10, label %12, !dbg !71

10:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.check, ptr noundef @.str, i32 noundef 16, ptr noundef @.str.1) #3, !dbg !71
  unreachable, !dbg !71

11:                                               ; No predecessors!
  br label %13, !dbg !71

12:                                               ; preds = %1
  br label %13, !dbg !71

13:                                               ; preds = %12, %11
  %14 = load ptr, ptr %2, align 8, !dbg !72
  %15 = call i32 @pthread_mutex_lock(ptr noundef %14), !dbg !73
  %16 = icmp eq i32 %15, 11, !dbg !74
  %17 = xor i1 %16, true, !dbg !75
  %18 = zext i1 %17 to i32, !dbg !75
  %19 = sext i32 %18 to i64, !dbg !75
  %20 = icmp ne i64 %19, 0, !dbg !75
  br i1 %20, label %21, label %23, !dbg !75

21:                                               ; preds = %13
  call void @__assert_rtn(ptr noundef @__func__.check, ptr noundef @.str, i32 noundef 17, ptr noundef @.str.2) #3, !dbg !75
  unreachable, !dbg !75

22:                                               ; No predecessors!
  br label %24, !dbg !75

23:                                               ; preds = %13
  br label %24, !dbg !75

24:                                               ; preds = %23, %22
  %25 = load ptr, ptr %2, align 8, !dbg !76
  %26 = call i32 @pthread_mutex_trylock(ptr noundef %25), !dbg !77
  %27 = icmp eq i32 %26, 16, !dbg !78
  %28 = xor i1 %27, true, !dbg !79
  %29 = zext i1 %28 to i32, !dbg !79
  %30 = sext i32 %29 to i64, !dbg !79
  %31 = icmp ne i64 %30, 0, !dbg !79
  br i1 %31, label %32, label %34, !dbg !79

32:                                               ; preds = %24
  call void @__assert_rtn(ptr noundef @__func__.check, ptr noundef @.str, i32 noundef 18, ptr noundef @.str.3) #3, !dbg !79
  unreachable, !dbg !79

33:                                               ; No predecessors!
  br label %35, !dbg !79

34:                                               ; preds = %24
  br label %35, !dbg !79

35:                                               ; preds = %34, %33
  %36 = load ptr, ptr %2, align 8, !dbg !80
  %37 = call i32 @pthread_mutex_unlock(ptr noundef %36), !dbg !81
  %38 = icmp eq i32 %37, 0, !dbg !82
  %39 = xor i1 %38, true, !dbg !83
  %40 = zext i1 %39 to i32, !dbg !83
  %41 = sext i32 %40 to i64, !dbg !83
  %42 = icmp ne i64 %41, 0, !dbg !83
  br i1 %42, label %43, label %45, !dbg !83

43:                                               ; preds = %35
  call void @__assert_rtn(ptr noundef @__func__.check, ptr noundef @.str, i32 noundef 19, ptr noundef @.str.4) #3, !dbg !83
  unreachable, !dbg !83

44:                                               ; No predecessors!
  br label %46, !dbg !83

45:                                               ; preds = %35
  br label %46, !dbg !83

46:                                               ; preds = %45, %44
  %47 = load ptr, ptr %2, align 8, !dbg !84
  %48 = call i32 @pthread_mutex_trylock(ptr noundef %47), !dbg !85
  %49 = icmp eq i32 %48, 0, !dbg !86
  %50 = xor i1 %49, true, !dbg !87
  %51 = zext i1 %50 to i32, !dbg !87
  %52 = sext i32 %51 to i64, !dbg !87
  %53 = icmp ne i64 %52, 0, !dbg !87
  br i1 %53, label %54, label %56, !dbg !87

54:                                               ; preds = %46
  call void @__assert_rtn(ptr noundef @__func__.check, ptr noundef @.str, i32 noundef 20, ptr noundef @.str.5) #3, !dbg !87
  unreachable, !dbg !87

55:                                               ; No predecessors!
  br label %57, !dbg !87

56:                                               ; preds = %46
  br label %57, !dbg !87

57:                                               ; preds = %56, %55
  %58 = load ptr, ptr %2, align 8, !dbg !88
  %59 = call i32 @pthread_mutex_unlock(ptr noundef %58), !dbg !89
  %60 = icmp eq i32 %59, 0, !dbg !90
  %61 = xor i1 %60, true, !dbg !91
  %62 = zext i1 %61 to i32, !dbg !91
  %63 = sext i32 %62 to i64, !dbg !91
  %64 = icmp ne i64 %63, 0, !dbg !91
  br i1 %64, label %65, label %67, !dbg !91

65:                                               ; preds = %57
  call void @__assert_rtn(ptr noundef @__func__.check, ptr noundef @.str, i32 noundef 21, ptr noundef @.str.4) #3, !dbg !91
  unreachable, !dbg !91

66:                                               ; No predecessors!
  br label %68, !dbg !91

67:                                               ; preds = %57
  br label %68, !dbg !91

68:                                               ; preds = %67, %66
  ret void, !dbg !92
}

declare i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

declare i32 @pthread_mutex_trylock(ptr noundef) #1

declare i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 !dbg !93 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_mutex_t, align 8
  %3 = alloca %struct._opaque_pthread_mutexattr_t, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !97, !DIExpression(), !98)
    #dbg_declare(ptr %3, !99, !DIExpression(), !110)
  %4 = call i32 @pthread_mutexattr_init(ptr noundef %3), !dbg !111
  %5 = call i32 @pthread_mutexattr_settype(ptr noundef %3, i32 noundef 1), !dbg !112
  %6 = call i32 @pthread_mutex_init(ptr noundef %2, ptr noundef %3), !dbg !113
  call void @check(ptr noundef %2), !dbg !114
  call void @check(ptr noundef @initialized), !dbg !115
  ret i32 0, !dbg !116
}

declare i32 @pthread_mutexattr_init(ptr noundef) #1

declare i32 @pthread_mutexattr_settype(ptr noundef, i32 noundef) #1

declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #3 = { cold noreturn }

!llvm.module.flags = !{!54, !55, !56, !57, !58, !59}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!60}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "initialized", scope: !2, file: !3, line: 11, type: !42, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk", sdk: "MacOSX26.sdk")
!3 = !DIFile(filename: "pthread_mutex_errorcheck.c", directory: "/Users/hponcedeleon/git/Dat3M/benchmarks/miscellaneous", checksumkind: CSK_MD5, checksum: "8a54720aa4f93fb0b1f5dc2a39286995")
!4 = !{!0, !5, !12, !17, !22, !27, !32, !37}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(scope: null, file: !3, line: 16, type: !7, isLocal: true, isDefinition: true)
!7 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 48, elements: !10)
!8 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !9)
!9 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!10 = !{!11}
!11 = !DISubrange(count: 6)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !3, line: 16, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 216, elements: !15)
!15 = !{!16}
!16 = !DISubrange(count: 27)
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(scope: null, file: !3, line: 16, type: !19, isLocal: true, isDefinition: true)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 248, elements: !20)
!20 = !{!21}
!21 = !DISubrange(count: 31)
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(scope: null, file: !3, line: 17, type: !24, isLocal: true, isDefinition: true)
!24 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 296, elements: !25)
!25 = !{!26}
!26 = !DISubrange(count: 37)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(scope: null, file: !3, line: 18, type: !29, isLocal: true, isDefinition: true)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 304, elements: !30)
!30 = !{!31}
!31 = !DISubrange(count: 38)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(scope: null, file: !3, line: 19, type: !34, isLocal: true, isDefinition: true)
!34 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 264, elements: !35)
!35 = !{!36}
!36 = !DISubrange(count: 33)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 20, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 272, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 34)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !43, line: 31, baseType: !44)
!43 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_mutex_t.h", directory: "", checksumkind: CSK_MD5, checksum: "583a89b25a16f85ebbdf32f8d9f237ec")
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutex_t", file: !45, line: 113, baseType: !46)
!45 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!46 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutex_t", file: !45, line: 78, size: 512, elements: !47)
!47 = !{!48, !50}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !46, file: !45, line: 79, baseType: !49, size: 64)
!49 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !46, file: !45, line: 80, baseType: !51, size: 448, offset: 64)
!51 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 448, elements: !52)
!52 = !{!53}
!53 = !DISubrange(count: 56)
!54 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 5]}
!55 = !{i32 7, !"Dwarf Version", i32 5}
!56 = !{i32 2, !"Debug Info Version", i32 3}
!57 = !{i32 8, !"PIC Level", i32 2}
!58 = !{i32 7, !"uwtable", i32 1}
!59 = !{i32 7, !"frame-pointer", i32 4}
!60 = !{!"Homebrew clang version 23.1.0"}
!61 = distinct !DISubprogram(name: "check", scope: !3, file: !3, line: 14, type: !62, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!62 = !DISubroutineType(types: !63)
!63 = !{null, !64}
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!65 = !{}
!66 = !DILocalVariable(name: "mutex", arg: 1, scope: !61, file: !3, line: 14, type: !64)
!67 = !DILocation(line: 14, column: 29, scope: !61)
!68 = !DILocation(line: 16, column: 31, scope: !61)
!69 = !DILocation(line: 16, column: 12, scope: !61)
!70 = !DILocation(line: 16, column: 38, scope: !61)
!71 = !DILocation(line: 16, column: 5, scope: !61)
!72 = !DILocation(line: 17, column: 31, scope: !61)
!73 = !DILocation(line: 17, column: 12, scope: !61)
!74 = !DILocation(line: 17, column: 38, scope: !61)
!75 = !DILocation(line: 17, column: 5, scope: !61)
!76 = !DILocation(line: 18, column: 34, scope: !61)
!77 = !DILocation(line: 18, column: 12, scope: !61)
!78 = !DILocation(line: 18, column: 41, scope: !61)
!79 = !DILocation(line: 18, column: 5, scope: !61)
!80 = !DILocation(line: 19, column: 33, scope: !61)
!81 = !DILocation(line: 19, column: 12, scope: !61)
!82 = !DILocation(line: 19, column: 40, scope: !61)
!83 = !DILocation(line: 19, column: 5, scope: !61)
!84 = !DILocation(line: 20, column: 34, scope: !61)
!85 = !DILocation(line: 20, column: 12, scope: !61)
!86 = !DILocation(line: 20, column: 41, scope: !61)
!87 = !DILocation(line: 20, column: 5, scope: !61)
!88 = !DILocation(line: 21, column: 33, scope: !61)
!89 = !DILocation(line: 21, column: 12, scope: !61)
!90 = !DILocation(line: 21, column: 40, scope: !61)
!91 = !DILocation(line: 21, column: 5, scope: !61)
!92 = !DILocation(line: 22, column: 1, scope: !61)
!93 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 24, type: !94, scopeLine: 25, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!94 = !DISubroutineType(types: !95)
!95 = !{!96}
!96 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!97 = !DILocalVariable(name: "mutex", scope: !93, file: !3, line: 26, type: !42)
!98 = !DILocation(line: 26, column: 21, scope: !93)
!99 = !DILocalVariable(name: "attr", scope: !93, file: !3, line: 27, type: !100)
!100 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !101, line: 31, baseType: !102)
!101 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_mutexattr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "785eb3f812f7ebee764058667d4b4693")
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutexattr_t", file: !45, line: 114, baseType: !103)
!103 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutexattr_t", file: !45, line: 83, size: 128, elements: !104)
!104 = !{!105, !106}
!105 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !103, file: !45, line: 84, baseType: !49, size: 64)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !103, file: !45, line: 85, baseType: !107, size: 64, offset: 64)
!107 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 64, elements: !108)
!108 = !{!109}
!109 = !DISubrange(count: 8)
!110 = !DILocation(line: 27, column: 25, scope: !93)
!111 = !DILocation(line: 28, column: 5, scope: !93)
!112 = !DILocation(line: 29, column: 5, scope: !93)
!113 = !DILocation(line: 30, column: 5, scope: !93)
!114 = !DILocation(line: 31, column: 5, scope: !93)
!115 = !DILocation(line: 32, column: 5, scope: !93)
!116 = !DILocation(line: 33, column: 5, scope: !93)
