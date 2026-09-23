; ModuleID = 'pthread_barrier_blocked.c'
source_filename = "pthread_barrier_blocked.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_barrier_t = type { i64, [24 x i8] }

@barrier = dso_local global %union.pthread_barrier_t zeroinitializer, align 8, !dbg !0
@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1, !dbg !5
@.str.1 = private unnamed_addr constant [26 x i8] c"pthread_barrier_blocked.c\00", align 1, !dbg !11
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1, !dbg !16

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !40 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %2 = call i32 @pthread_barrier_init(ptr noundef @barrier, ptr noundef null, i32 noundef 2) #3, !dbg !44
  %3 = call i32 @pthread_barrier_wait(ptr noundef @barrier) #3, !dbg !45
  %4 = call i32 @pthread_barrier_wait(ptr noundef @barrier) #3, !dbg !46
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 13, ptr noundef @__PRETTY_FUNCTION__.main) #4, !dbg !47
  unreachable, !dbg !47
}

; Function Attrs: nounwind
declare i32 @pthread_barrier_init(ptr noundef, ptr noundef, i32 noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_barrier_wait(ptr noundef) #1

; Function Attrs: cold noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }
attributes #4 = { cold noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!32, !33, !34, !35, !36, !37, !38}
!llvm.ident = !{!39}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "barrier", scope: !2, file: !3, line: 6, type: !22, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_barrier_blocked.c", directory: "/tmp/ll", checksumkind: CSK_MD5, checksum: "4fe03c83544ce8f875edd0be72da285f")
!4 = !{!5, !11, !16, !0}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !7, isLocal: true, isDefinition: true)
!7 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 16, elements: !9)
!8 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!9 = !{!10}
!10 = !DISubrange(count: 2)
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !13, isLocal: true, isDefinition: true)
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 208, elements: !14)
!14 = !{!15}
!15 = !DISubrange(count: 26)
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !18, isLocal: true, isDefinition: true)
!18 = !DICompositeType(tag: DW_TAG_array_type, baseType: !19, size: 88, elements: !20)
!19 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !8)
!20 = !{!21}
!21 = !DISubrange(count: 11)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_barrier_t", file: !23, line: 112, baseType: !24)
!23 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "cbf5435bd7bfed052b1a09633f314dde")
!24 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !23, line: 108, size: 256, elements: !25)
!25 = !{!26, !30}
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !24, file: !23, line: 110, baseType: !27, size: 256)
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 256, elements: !28)
!28 = !{!29}
!29 = !DISubrange(count: 32)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !24, file: !23, line: 111, baseType: !31, size: 64)
!31 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!32 = !{i32 7, !"Dwarf Version", i32 5}
!33 = !{i32 2, !"Debug Info Version", i32 3}
!34 = !{i32 1, !"wchar_size", i32 4}
!35 = !{i32 8, !"PIC Level", i32 2}
!36 = !{i32 7, !"PIE Level", i32 2}
!37 = !{i32 7, !"uwtable", i32 2}
!38 = !{i32 7, !"frame-pointer", i32 2}
!39 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!40 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 8, type: !41, scopeLine: 9, spFlags: DISPFlagDefinition, unit: !2)
!41 = !DISubroutineType(types: !42)
!42 = !{!43}
!43 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!44 = !DILocation(line: 10, column: 5, scope: !40)
!45 = !DILocation(line: 11, column: 5, scope: !40)
!46 = !DILocation(line: 12, column: 5, scope: !40)
!47 = !DILocation(line: 13, column: 5, scope: !48)
!48 = distinct !DILexicalBlock(scope: !49, file: !3, line: 13, column: 5)
!49 = distinct !DILexicalBlock(scope: !40, file: !3, line: 13, column: 5)
