; ModuleID = 'benchmarks/mixed/mixed-local2.c'
source_filename = "benchmarks/mixed/mixed-local2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.anon = type { i16, i16, i16 }

@x = dso_local global %struct.anon zeroinitializer, align 2, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !12
@.str = private unnamed_addr constant [15 x i8] c"mixed-local2.c\00", align 1, !dbg !18
@.str.1 = private unnamed_addr constant [93 x i8] c"*(int volatile*)(&x) != 0x22221111 || *(int volatile*)(((char volatile*)(&x))+1) != 0x222211\00", align 1, !dbg !23

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !43 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  store volatile i16 4369, ptr @x, align 2, !dbg !46
  store volatile i16 8738, ptr getelementptr inbounds (%struct.anon, ptr @x, i32 0, i32 1), align 2, !dbg !47
  store volatile i16 0, ptr getelementptr inbounds (%struct.anon, ptr @x, i32 0, i32 2), align 2, !dbg !48
  %2 = load volatile i32, ptr @x, align 2, !dbg !49
  %3 = icmp ne i32 %2, 572657937, !dbg !49
  br i1 %3, label %7, label %4, !dbg !49

4:                                                ; preds = %0
  %5 = load volatile i32, ptr getelementptr inbounds (i8, ptr @x, i64 1), align 4, !dbg !49
  %6 = icmp ne i32 %5, 2236945, !dbg !49
  br label %7, !dbg !49

7:                                                ; preds = %4, %0
  %8 = phi i1 [ true, %0 ], [ %6, %4 ]
  %9 = xor i1 %8, true, !dbg !49
  %10 = zext i1 %9 to i32, !dbg !49
  %11 = sext i32 %10 to i64, !dbg !49
  %12 = icmp ne i64 %11, 0, !dbg !49
  br i1 %12, label %13, label %15, !dbg !49

13:                                               ; preds = %7
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 14, ptr noundef @.str.1) #2, !dbg !49
  unreachable, !dbg !49

14:                                               ; No predecessors!
  br label %16, !dbg !49

15:                                               ; preds = %7
  br label %16, !dbg !49

16:                                               ; preds = %15, %14
  ret i32 0, !dbg !50
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!35, !36, !37, !38, !39, !40, !41}
!llvm.ident = !{!42}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !11, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/mixed/mixed-local2.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "01a256ea1ff12b1c63da212ce86d4188")
!4 = !{!5, !8}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !7)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !10)
!10 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!11 = !{!12, !18, !23, !0}
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !3, line: 14, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 40, elements: !16)
!15 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !10)
!16 = !{!17}
!17 = !DISubrange(count: 5)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !3, line: 14, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 120, elements: !21)
!21 = !{!22}
!22 = !DISubrange(count: 15)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(scope: null, file: !3, line: 14, type: !25, isLocal: true, isDefinition: true)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 744, elements: !26)
!26 = !{!27}
!27 = !DISubrange(count: 93)
!28 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !29)
!29 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 6, size: 48, elements: !30)
!30 = !{!31, !33, !34}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "i00", scope: !29, file: !3, line: 6, baseType: !32, size: 16)
!32 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "i01", scope: !29, file: !3, line: 6, baseType: !32, size: 16, offset: 16)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "i02", scope: !29, file: !3, line: 6, baseType: !32, size: 16, offset: 32)
!35 = !{i32 7, !"Dwarf Version", i32 5}
!36 = !{i32 2, !"Debug Info Version", i32 3}
!37 = !{i32 1, !"wchar_size", i32 4}
!38 = !{i32 8, !"PIC Level", i32 2}
!39 = !{i32 7, !"PIE Level", i32 2}
!40 = !{i32 7, !"uwtable", i32 2}
!41 = !{i32 7, !"frame-pointer", i32 2}
!42 = !{!"Homebrew clang version 19.1.7"}
!43 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 8, type: !44, scopeLine: 9, spFlags: DISPFlagDefinition, unit: !2)
!44 = !DISubroutineType(types: !45)
!45 = !{!7}
!46 = !DILocation(line: 10, column: 11, scope: !43)
!47 = !DILocation(line: 11, column: 11, scope: !43)
!48 = !DILocation(line: 12, column: 11, scope: !43)
!49 = !DILocation(line: 14, column: 5, scope: !43)
!50 = !DILocation(line: 22, column: 5, scope: !43)
