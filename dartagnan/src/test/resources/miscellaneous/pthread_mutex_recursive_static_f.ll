; ModuleID = 'pthread_mutex_recursive_static_f.c'
source_filename = "pthread_mutex_recursive_static_f.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }

@recursive = dso_local global %union.pthread_mutex_t { %struct.__pthread_mutex_s { i32 0, i32 0, i32 0, i32 0, i32 1, i16 0, i16 0, %struct.__pthread_internal_list zeroinitializer } }, align 8, !dbg !0
@normal = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !7
@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1, !dbg !42
@.str.1 = private unnamed_addr constant [35 x i8] c"pthread_mutex_recursive_static_f.c\00", align 1, !dbg !47
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1, !dbg !52

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !66 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %2 = call i32 @pthread_mutex_lock(ptr noundef @normal) #3, !dbg !69
  %3 = call i32 @pthread_mutex_unlock(ptr noundef @normal) #3, !dbg !70
  %4 = call i32 @pthread_mutex_lock(ptr noundef @recursive) #3, !dbg !71
  %5 = call i32 @pthread_mutex_lock(ptr noundef @recursive) #3, !dbg !72
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 20, ptr noundef @__PRETTY_FUNCTION__.main) #4, !dbg !73
  unreachable, !dbg !73
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: cold noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }
attributes #4 = { cold noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!58, !59, !60, !61, !62, !63, !64}
!llvm.ident = !{!65}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "recursive", scope: !2, file: !3, line: 8, type: !9, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_mutex_recursive_static_f.c", directory: "/tmp/rm", checksumkind: CSK_MD5, checksum: "60a6255faa3e5e6c9e7ca87a05293011")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !42, !47, !52}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "normal", scope: !2, file: !3, line: 12, type: !9, isLocal: false, isDefinition: true)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !10, line: 72, baseType: !11)
!10 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "cbf5435bd7bfed052b1a09633f314dde")
!11 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !10, line: 67, size: 320, elements: !12)
!12 = !{!13, !35, !40}
!13 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !11, file: !10, line: 69, baseType: !14, size: 320)
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !15, line: 22, size: 320, elements: !16)
!15 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "c204e8f2bbee82104b0bc5a7e66bac71")
!16 = !{!17, !19, !21, !22, !23, !24, !26, !27}
!17 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !14, file: !15, line: 24, baseType: !18, size: 32)
!18 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !14, file: !15, line: 25, baseType: !20, size: 32, offset: 32)
!20 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !14, file: !15, line: 26, baseType: !18, size: 32, offset: 64)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !14, file: !15, line: 28, baseType: !20, size: 32, offset: 96)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !14, file: !15, line: 32, baseType: !18, size: 32, offset: 128)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !14, file: !15, line: 34, baseType: !25, size: 16, offset: 160)
!25 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__unused", scope: !14, file: !15, line: 35, baseType: !25, size: 16, offset: 176)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !14, file: !15, line: 36, baseType: !28, size: 128, offset: 192)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !29, line: 55, baseType: !30)
!29 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "52a54ef04a6aeb244335b0bf6e6e1933")
!30 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !29, line: 51, size: 128, elements: !31)
!31 = !{!32, !34}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !30, file: !29, line: 53, baseType: !33, size: 64)
!33 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !30, file: !29, line: 54, baseType: !33, size: 64, offset: 64)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !11, file: !10, line: 70, baseType: !36, size: 320)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !37, size: 320, elements: !38)
!37 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!38 = !{!39}
!39 = !DISubrange(count: 40)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !11, file: !10, line: 71, baseType: !41, size: 64)
!41 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 20, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !37, size: 16, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 2)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(scope: null, file: !3, line: 20, type: !49, isLocal: true, isDefinition: true)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !37, size: 280, elements: !50)
!50 = !{!51}
!51 = !DISubrange(count: 35)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(scope: null, file: !3, line: 20, type: !54, isLocal: true, isDefinition: true)
!54 = !DICompositeType(tag: DW_TAG_array_type, baseType: !55, size: 88, elements: !56)
!55 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !37)
!56 = !{!57}
!57 = !DISubrange(count: 11)
!58 = !{i32 7, !"Dwarf Version", i32 5}
!59 = !{i32 2, !"Debug Info Version", i32 3}
!60 = !{i32 1, !"wchar_size", i32 4}
!61 = !{i32 8, !"PIC Level", i32 2}
!62 = !{i32 7, !"PIE Level", i32 2}
!63 = !{i32 7, !"uwtable", i32 2}
!64 = !{i32 7, !"frame-pointer", i32 2}
!65 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!66 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 14, type: !67, scopeLine: 15, spFlags: DISPFlagDefinition, unit: !2)
!67 = !DISubroutineType(types: !68)
!68 = !{!18}
!69 = !DILocation(line: 16, column: 5, scope: !66)
!70 = !DILocation(line: 17, column: 5, scope: !66)
!71 = !DILocation(line: 18, column: 5, scope: !66)
!72 = !DILocation(line: 19, column: 5, scope: !66)
!73 = !DILocation(line: 20, column: 5, scope: !74)
!74 = distinct !DILexicalBlock(scope: !75, file: !3, line: 20, column: 5)
!75 = distinct !DILexicalBlock(scope: !66, file: !3, line: 20, column: 5)
