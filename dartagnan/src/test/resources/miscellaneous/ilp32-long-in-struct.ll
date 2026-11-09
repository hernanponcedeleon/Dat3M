; ModuleID = 'benchmarks/miscellaneous/ilp32-long.c'
source_filename = "benchmarks/miscellaneous/ilp32-long.c"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

%struct.S = type { i32, i64 }

@s = dso_local global %struct.S zeroinitializer, align 4, !dbg !0
@.str = private unnamed_addr constant [10 x i8] c"s.b == 42\00", align 1, !dbg !5
@.str.1 = private unnamed_addr constant [38 x i8] c"benchmarks/miscellaneous/ilp32-long.c\00", align 1, !dbg !11
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !16

; Function Attrs: noinline nounwind uwtable
define dso_local void @set(ptr noundef %0, i64 noundef %1) #0 !dbg !37 {
  %3 = alloca ptr, align 4
  %4 = alloca i64, align 8
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !42, !DIExpression(), !43)
  store i64 %1, ptr %4, align 8
    #dbg_declare(ptr %4, !44, !DIExpression(), !45)
  %5 = load i64, ptr %4, align 8, !dbg !46
  %6 = load ptr, ptr %3, align 4, !dbg !47
  %7 = getelementptr inbounds nuw %struct.S, ptr %6, i32 0, i32 1, !dbg !48
  store i64 %5, ptr %7, align 4, !dbg !49
  ret void, !dbg !50
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !51 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @set(ptr noundef @s, i64 noundef 42), !dbg !54
  %2 = load i64, ptr getelementptr inbounds nuw (%struct.S, ptr @s, i32 0, i32 1), align 4, !dbg !55
  %3 = icmp eq i64 %2, 42, !dbg !58
  br i1 %3, label %5, label %4, !dbg !59

4:                                                ; preds = %0
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 22, ptr noundef @__func__.main), !dbg !59
  br label %5, !dbg !59

5:                                                ; preds = %4, %0
  ret i32 0, !dbg !60
}

declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!28, !29, !30, !31, !32, !33, !34, !35}
!llvm.ident = !{!36}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !3, line: 12, type: !22, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/miscellaneous/ilp32-long.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "9e86caa5bf109e76ecc1621e69f0a1e7")
!4 = !{!5, !11, !16, !0}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(scope: null, file: !3, line: 22, type: !7, isLocal: true, isDefinition: true)
!7 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 80, elements: !9)
!8 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!9 = !{!10}
!10 = !DISubrange(count: 10)
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(scope: null, file: !3, line: 22, type: !13, isLocal: true, isDefinition: true)
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 304, elements: !14)
!14 = !{!15}
!15 = !DISubrange(count: 38)
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(scope: null, file: !3, line: 22, type: !18, isLocal: true, isDefinition: true)
!18 = !DICompositeType(tag: DW_TAG_array_type, baseType: !19, size: 40, elements: !20)
!19 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !8)
!20 = !{!21}
!21 = !DISubrange(count: 5)
!22 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "S", file: !3, line: 7, size: 96, elements: !23)
!23 = !{!24, !26}
!24 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !22, file: !3, line: 8, baseType: !25, size: 32)
!25 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !22, file: !3, line: 9, baseType: !27, size: 64, offset: 32)
!27 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!28 = !{i32 1, !"NumRegisterParameters", i32 0}
!29 = !{i32 7, !"Dwarf Version", i32 5}
!30 = !{i32 2, !"Debug Info Version", i32 3}
!31 = !{i32 1, !"wchar_size", i32 4}
!32 = !{i32 8, !"PIC Level", i32 2}
!33 = !{i32 7, !"PIE Level", i32 2}
!34 = !{i32 7, !"uwtable", i32 2}
!35 = !{i32 7, !"frame-pointer", i32 2}
!36 = !{!"Homebrew clang version 22.1.8"}
!37 = distinct !DISubprogram(name: "set", scope: !3, file: !3, line: 15, type: !38, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !41)
!38 = !DISubroutineType(types: !39)
!39 = !{null, !40, !27}
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 32)
!41 = !{}
!42 = !DILocalVariable(name: "p", arg: 1, scope: !37, file: !3, line: 15, type: !40)
!43 = !DILocation(line: 15, column: 20, scope: !37)
!44 = !DILocalVariable(name: "v", arg: 2, scope: !37, file: !3, line: 15, type: !27)
!45 = !DILocation(line: 15, column: 33, scope: !37)
!46 = !DILocation(line: 16, column: 12, scope: !37)
!47 = !DILocation(line: 16, column: 5, scope: !37)
!48 = !DILocation(line: 16, column: 8, scope: !37)
!49 = !DILocation(line: 16, column: 10, scope: !37)
!50 = !DILocation(line: 17, column: 1, scope: !37)
!51 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 19, type: !52, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2)
!52 = !DISubroutineType(types: !53)
!53 = !{!25}
!54 = !DILocation(line: 21, column: 5, scope: !51)
!55 = !DILocation(line: 22, column: 14, scope: !56)
!56 = distinct !DILexicalBlock(scope: !57, file: !3, line: 22, column: 5)
!57 = distinct !DILexicalBlock(scope: !51, file: !3, line: 22, column: 5)
!58 = !DILocation(line: 22, column: 16, scope: !56)
!59 = !DILocation(line: 22, column: 5, scope: !56)
!60 = !DILocation(line: 23, column: 5, scope: !51)
