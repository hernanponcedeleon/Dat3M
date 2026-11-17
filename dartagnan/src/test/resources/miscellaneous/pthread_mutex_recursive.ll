; ModuleID = 'pthread_mutex_recursive.c'
source_filename = "pthread_mutex_recursive.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%union.pthread_mutexattr_t = type { i32 }

@mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !0
@.str = private unnamed_addr constant [32 x i8] c"pthread_mutex_lock(&mutex) == 0\00", align 1, !dbg !20
@.str.1 = private unnamed_addr constant [26 x i8] c"pthread_mutex_recursive.c\00", align 1, !dbg !26
@__PRETTY_FUNCTION__.worker = private unnamed_addr constant [21 x i8] c"void *worker(void *)\00", align 1, !dbg !31
@counter = dso_local global i32 0, align 4, !dbg !79
@.str.2 = private unnamed_addr constant [34 x i8] c"pthread_mutex_unlock(&mutex) == 0\00", align 1, !dbg !37
@.str.3 = private unnamed_addr constant [35 x i8] c"pthread_mutexattr_init(&attr) == 0\00", align 1, !dbg !42
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1, !dbg !47
@.str.4 = private unnamed_addr constant [63 x i8] c"pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE) == 0\00", align 1, !dbg !52
@.str.5 = private unnamed_addr constant [80 x i8] c"pthread_mutexattr_gettype(&attr, &type) == 0 && type == PTHREAD_MUTEX_RECURSIVE\00", align 1, !dbg !57
@.str.6 = private unnamed_addr constant [39 x i8] c"pthread_mutex_init(&mutex, &attr) == 0\00", align 1, !dbg !62
@.str.7 = private unnamed_addr constant [38 x i8] c"pthread_mutexattr_destroy(&attr) == 0\00", align 1, !dbg !67
@.str.8 = private unnamed_addr constant [35 x i8] c"pthread_mutex_trylock(&mutex) == 0\00", align 1, !dbg !72
@.str.9 = private unnamed_addr constant [13 x i8] c"counter == 4\00", align 1, !dbg !74

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @worker(ptr noundef %0) #0 !dbg !120 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !124, !DIExpression(), !125)
  %3 = call i32 @pthread_mutex_lock(ptr noundef @mutex) #4, !dbg !126
  %4 = icmp eq i32 %3, 0, !dbg !126
  br i1 %4, label %5, label %6, !dbg !126

5:                                                ; preds = %1
  br label %7, !dbg !126

6:                                                ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 11, ptr noundef @__PRETTY_FUNCTION__.worker) #5, !dbg !126
  unreachable, !dbg !126

7:                                                ; preds = %5
  %8 = call i32 @pthread_mutex_lock(ptr noundef @mutex) #4, !dbg !129
  %9 = icmp eq i32 %8, 0, !dbg !129
  br i1 %9, label %10, label %11, !dbg !129

10:                                               ; preds = %7
  br label %12, !dbg !129

11:                                               ; preds = %7
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 12, ptr noundef @__PRETTY_FUNCTION__.worker) #5, !dbg !129
  unreachable, !dbg !129

12:                                               ; preds = %10
  %13 = load i32, ptr @counter, align 4, !dbg !132
  %14 = add nsw i32 %13, 1, !dbg !132
  store i32 %14, ptr @counter, align 4, !dbg !132
  %15 = call i32 @pthread_mutex_unlock(ptr noundef @mutex) #4, !dbg !133
  %16 = icmp eq i32 %15, 0, !dbg !133
  br i1 %16, label %17, label %18, !dbg !133

17:                                               ; preds = %12
  br label %19, !dbg !133

18:                                               ; preds = %12
  call void @__assert_fail(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 14, ptr noundef @__PRETTY_FUNCTION__.worker) #5, !dbg !133
  unreachable, !dbg !133

19:                                               ; preds = %17
  %20 = load i32, ptr @counter, align 4, !dbg !136
  %21 = add nsw i32 %20, 1, !dbg !136
  store i32 %21, ptr @counter, align 4, !dbg !136
  %22 = call i32 @pthread_mutex_unlock(ptr noundef @mutex) #4, !dbg !137
  %23 = icmp eq i32 %22, 0, !dbg !137
  br i1 %23, label %24, label %25, !dbg !137

24:                                               ; preds = %19
  br label %26, !dbg !137

25:                                               ; preds = %19
  call void @__assert_fail(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 16, ptr noundef @__PRETTY_FUNCTION__.worker) #5, !dbg !137
  unreachable, !dbg !137

26:                                               ; preds = %24
  ret ptr null, !dbg !140
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: cold noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !141 {
  %1 = alloca i32, align 4
  %2 = alloca %union.pthread_mutexattr_t, align 4
  %3 = alloca i32, align 4
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !144, !DIExpression(), !153)
    #dbg_declare(ptr %3, !154, !DIExpression(), !155)
  %6 = call i32 @pthread_mutexattr_init(ptr noundef %2) #4, !dbg !156
  %7 = icmp eq i32 %6, 0, !dbg !156
  br i1 %7, label %8, label %9, !dbg !156

8:                                                ; preds = %0
  br label %10, !dbg !156

9:                                                ; preds = %0
  call void @__assert_fail(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 24, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !156
  unreachable, !dbg !156

10:                                               ; preds = %8
  %11 = call i32 @pthread_mutexattr_settype(ptr noundef %2, i32 noundef 1) #4, !dbg !159
  %12 = icmp eq i32 %11, 0, !dbg !159
  br i1 %12, label %13, label %14, !dbg !159

13:                                               ; preds = %10
  br label %15, !dbg !159

14:                                               ; preds = %10
  call void @__assert_fail(ptr noundef @.str.4, ptr noundef @.str.1, i32 noundef 25, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !159
  unreachable, !dbg !159

15:                                               ; preds = %13
  %16 = call i32 @pthread_mutexattr_gettype(ptr noundef %2, ptr noundef %3) #4, !dbg !162
  %17 = icmp eq i32 %16, 0, !dbg !162
  br i1 %17, label %18, label %22, !dbg !162

18:                                               ; preds = %15
  %19 = load i32, ptr %3, align 4, !dbg !162
  %20 = icmp eq i32 %19, 1, !dbg !162
  br i1 %20, label %21, label %22, !dbg !162

21:                                               ; preds = %18
  br label %23, !dbg !162

22:                                               ; preds = %18, %15
  call void @__assert_fail(ptr noundef @.str.5, ptr noundef @.str.1, i32 noundef 26, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !162
  unreachable, !dbg !162

23:                                               ; preds = %21
  %24 = call i32 @pthread_mutex_init(ptr noundef @mutex, ptr noundef %2) #4, !dbg !165
  %25 = icmp eq i32 %24, 0, !dbg !165
  br i1 %25, label %26, label %27, !dbg !165

26:                                               ; preds = %23
  br label %28, !dbg !165

27:                                               ; preds = %23
  call void @__assert_fail(ptr noundef @.str.6, ptr noundef @.str.1, i32 noundef 27, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !165
  unreachable, !dbg !165

28:                                               ; preds = %26
  %29 = call i32 @pthread_mutexattr_destroy(ptr noundef %2) #4, !dbg !168
  %30 = icmp eq i32 %29, 0, !dbg !168
  br i1 %30, label %31, label %32, !dbg !168

31:                                               ; preds = %28
  br label %33, !dbg !168

32:                                               ; preds = %28
  call void @__assert_fail(ptr noundef @.str.7, ptr noundef @.str.1, i32 noundef 28, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !168
  unreachable, !dbg !168

33:                                               ; preds = %31
  %34 = call i32 @pthread_mutex_lock(ptr noundef @mutex) #4, !dbg !171
  %35 = icmp eq i32 %34, 0, !dbg !171
  br i1 %35, label %36, label %37, !dbg !171

36:                                               ; preds = %33
  br label %38, !dbg !171

37:                                               ; preds = %33
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 30, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !171
  unreachable, !dbg !171

38:                                               ; preds = %36
  %39 = call i32 @pthread_mutex_trylock(ptr noundef @mutex) #4, !dbg !174
  %40 = icmp eq i32 %39, 0, !dbg !174
  br i1 %40, label %41, label %42, !dbg !174

41:                                               ; preds = %38
  br label %43, !dbg !174

42:                                               ; preds = %38
  call void @__assert_fail(ptr noundef @.str.8, ptr noundef @.str.1, i32 noundef 31, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !174
  unreachable, !dbg !174

43:                                               ; preds = %41
  %44 = call i32 @pthread_mutex_unlock(ptr noundef @mutex) #4, !dbg !177
  %45 = icmp eq i32 %44, 0, !dbg !177
  br i1 %45, label %46, label %47, !dbg !177

46:                                               ; preds = %43
  br label %48, !dbg !177

47:                                               ; preds = %43
  call void @__assert_fail(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 32, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !177
  unreachable, !dbg !177

48:                                               ; preds = %46
  %49 = call i32 @pthread_mutex_unlock(ptr noundef @mutex) #4, !dbg !180
  %50 = icmp eq i32 %49, 0, !dbg !180
  br i1 %50, label %51, label %52, !dbg !180

51:                                               ; preds = %48
  br label %53, !dbg !180

52:                                               ; preds = %48
  call void @__assert_fail(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 33, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !180
  unreachable, !dbg !180

53:                                               ; preds = %51
    #dbg_declare(ptr %4, !183, !DIExpression(), !186)
    #dbg_declare(ptr %5, !187, !DIExpression(), !188)
  %54 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @worker, ptr noundef null) #4, !dbg !189
  %55 = call i32 @pthread_create(ptr noundef %5, ptr noundef null, ptr noundef @worker, ptr noundef null) #4, !dbg !190
  %56 = load i64, ptr %4, align 8, !dbg !191
  %57 = call i32 @pthread_join(i64 noundef %56, ptr noundef null), !dbg !192
  %58 = load i64, ptr %5, align 8, !dbg !193
  %59 = call i32 @pthread_join(i64 noundef %58, ptr noundef null), !dbg !194
  %60 = load i32, ptr @counter, align 4, !dbg !195
  %61 = icmp eq i32 %60, 4, !dbg !195
  br i1 %61, label %62, label %63, !dbg !195

62:                                               ; preds = %53
  br label %64, !dbg !195

63:                                               ; preds = %53
  call void @__assert_fail(ptr noundef @.str.9, ptr noundef @.str.1, i32 noundef 40, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !195
  unreachable, !dbg !195

64:                                               ; preds = %62
  ret i32 0, !dbg !198
}

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_init(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_settype(ptr noundef, i32 noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_gettype(ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_destroy(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_trylock(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @pthread_join(i64 noundef, ptr noundef) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { cold noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!112, !113, !114, !115, !116, !117, !118}
!llvm.ident = !{!119}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !3, line: 6, type: !82, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !17, globals: !19, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_mutex_recursive.c", directory: "/tmp/rm", checksumkind: CSK_MD5, checksum: "2e91dcdfdb9b7369b2ec1fbb49516156")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 47, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "c665ae672368d86b0545524d35407e96")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16}
!9 = !DIEnumerator(name: "PTHREAD_MUTEX_TIMED_NP", value: 0)
!10 = !DIEnumerator(name: "PTHREAD_MUTEX_RECURSIVE_NP", value: 1)
!11 = !DIEnumerator(name: "PTHREAD_MUTEX_ERRORCHECK_NP", value: 2)
!12 = !DIEnumerator(name: "PTHREAD_MUTEX_ADAPTIVE_NP", value: 3)
!13 = !DIEnumerator(name: "PTHREAD_MUTEX_NORMAL", value: 0)
!14 = !DIEnumerator(name: "PTHREAD_MUTEX_RECURSIVE", value: 1)
!15 = !DIEnumerator(name: "PTHREAD_MUTEX_ERRORCHECK", value: 2)
!16 = !DIEnumerator(name: "PTHREAD_MUTEX_DEFAULT", value: 0)
!17 = !{!18}
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!19 = !{!20, !26, !31, !37, !42, !47, !52, !57, !62, !67, !72, !74, !0, !79}
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(scope: null, file: !3, line: 11, type: !22, isLocal: true, isDefinition: true)
!22 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 256, elements: !24)
!23 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!24 = !{!25}
!25 = !DISubrange(count: 32)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(scope: null, file: !3, line: 11, type: !28, isLocal: true, isDefinition: true)
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 208, elements: !29)
!29 = !{!30}
!30 = !DISubrange(count: 26)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 11, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 168, elements: !35)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !23)
!35 = !{!36}
!36 = !DISubrange(count: 21)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 14, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 272, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 34)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 280, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 35)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !49, isLocal: true, isDefinition: true)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 88, elements: !50)
!50 = !{!51}
!51 = !DISubrange(count: 11)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(scope: null, file: !3, line: 25, type: !54, isLocal: true, isDefinition: true)
!54 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 504, elements: !55)
!55 = !{!56}
!56 = !DISubrange(count: 63)
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !59, isLocal: true, isDefinition: true)
!59 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 640, elements: !60)
!60 = !{!61}
!61 = !DISubrange(count: 80)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(scope: null, file: !3, line: 27, type: !64, isLocal: true, isDefinition: true)
!64 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 312, elements: !65)
!65 = !{!66}
!66 = !DISubrange(count: 39)
!67 = !DIGlobalVariableExpression(var: !68, expr: !DIExpression())
!68 = distinct !DIGlobalVariable(scope: null, file: !3, line: 28, type: !69, isLocal: true, isDefinition: true)
!69 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 304, elements: !70)
!70 = !{!71}
!71 = !DISubrange(count: 38)
!72 = !DIGlobalVariableExpression(var: !73, expr: !DIExpression())
!73 = distinct !DIGlobalVariable(scope: null, file: !3, line: 31, type: !44, isLocal: true, isDefinition: true)
!74 = !DIGlobalVariableExpression(var: !75, expr: !DIExpression())
!75 = distinct !DIGlobalVariable(scope: null, file: !3, line: 40, type: !76, isLocal: true, isDefinition: true)
!76 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 104, elements: !77)
!77 = !{!78}
!78 = !DISubrange(count: 13)
!79 = !DIGlobalVariableExpression(var: !80, expr: !DIExpression())
!80 = distinct !DIGlobalVariable(name: "counter", scope: !2, file: !3, line: 7, type: !81, isLocal: false, isDefinition: true)
!81 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!82 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !83, line: 72, baseType: !84)
!83 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "cbf5435bd7bfed052b1a09633f314dde")
!84 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !83, line: 67, size: 320, elements: !85)
!85 = !{!86, !106, !110}
!86 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !84, file: !83, line: 69, baseType: !87, size: 320)
!87 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !88, line: 22, size: 320, elements: !89)
!88 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "c204e8f2bbee82104b0bc5a7e66bac71")
!89 = !{!90, !91, !92, !93, !94, !95, !97, !98}
!90 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !87, file: !88, line: 24, baseType: !81, size: 32)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !87, file: !88, line: 25, baseType: !7, size: 32, offset: 32)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !87, file: !88, line: 26, baseType: !81, size: 32, offset: 64)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !87, file: !88, line: 28, baseType: !7, size: 32, offset: 96)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !87, file: !88, line: 32, baseType: !81, size: 32, offset: 128)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !87, file: !88, line: 34, baseType: !96, size: 16, offset: 160)
!96 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "__unused", scope: !87, file: !88, line: 35, baseType: !96, size: 16, offset: 176)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !87, file: !88, line: 36, baseType: !99, size: 128, offset: 192)
!99 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !100, line: 55, baseType: !101)
!100 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "52a54ef04a6aeb244335b0bf6e6e1933")
!101 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !100, line: 51, size: 128, elements: !102)
!102 = !{!103, !105}
!103 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !101, file: !100, line: 53, baseType: !104, size: 64)
!104 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !101, size: 64)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !101, file: !100, line: 54, baseType: !104, size: 64, offset: 64)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !84, file: !83, line: 70, baseType: !107, size: 320)
!107 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 320, elements: !108)
!108 = !{!109}
!109 = !DISubrange(count: 40)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !84, file: !83, line: 71, baseType: !111, size: 64)
!111 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!112 = !{i32 7, !"Dwarf Version", i32 5}
!113 = !{i32 2, !"Debug Info Version", i32 3}
!114 = !{i32 1, !"wchar_size", i32 4}
!115 = !{i32 8, !"PIC Level", i32 2}
!116 = !{i32 7, !"PIE Level", i32 2}
!117 = !{i32 7, !"uwtable", i32 2}
!118 = !{i32 7, !"frame-pointer", i32 2}
!119 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!120 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 9, type: !121, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !123)
!121 = !DISubroutineType(types: !122)
!122 = !{!18, !18}
!123 = !{}
!124 = !DILocalVariable(name: "arg", arg: 1, scope: !120, file: !3, line: 9, type: !18)
!125 = !DILocation(line: 9, column: 20, scope: !120)
!126 = !DILocation(line: 11, column: 5, scope: !127)
!127 = distinct !DILexicalBlock(scope: !128, file: !3, line: 11, column: 5)
!128 = distinct !DILexicalBlock(scope: !120, file: !3, line: 11, column: 5)
!129 = !DILocation(line: 12, column: 5, scope: !130)
!130 = distinct !DILexicalBlock(scope: !131, file: !3, line: 12, column: 5)
!131 = distinct !DILexicalBlock(scope: !120, file: !3, line: 12, column: 5)
!132 = !DILocation(line: 13, column: 12, scope: !120)
!133 = !DILocation(line: 14, column: 5, scope: !134)
!134 = distinct !DILexicalBlock(scope: !135, file: !3, line: 14, column: 5)
!135 = distinct !DILexicalBlock(scope: !120, file: !3, line: 14, column: 5)
!136 = !DILocation(line: 15, column: 12, scope: !120)
!137 = !DILocation(line: 16, column: 5, scope: !138)
!138 = distinct !DILexicalBlock(scope: !139, file: !3, line: 16, column: 5)
!139 = distinct !DILexicalBlock(scope: !120, file: !3, line: 16, column: 5)
!140 = !DILocation(line: 17, column: 5, scope: !120)
!141 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 20, type: !142, scopeLine: 21, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !123)
!142 = !DISubroutineType(types: !143)
!143 = !{!81}
!144 = !DILocalVariable(name: "attr", scope: !141, file: !3, line: 22, type: !145)
!145 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !83, line: 36, baseType: !146)
!146 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !83, line: 32, size: 32, elements: !147)
!147 = !{!148, !152}
!148 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !146, file: !83, line: 34, baseType: !149, size: 32)
!149 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 32, elements: !150)
!150 = !{!151}
!151 = !DISubrange(count: 4)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !146, file: !83, line: 35, baseType: !81, size: 32)
!153 = !DILocation(line: 22, column: 25, scope: !141)
!154 = !DILocalVariable(name: "type", scope: !141, file: !3, line: 23, type: !81)
!155 = !DILocation(line: 23, column: 9, scope: !141)
!156 = !DILocation(line: 24, column: 5, scope: !157)
!157 = distinct !DILexicalBlock(scope: !158, file: !3, line: 24, column: 5)
!158 = distinct !DILexicalBlock(scope: !141, file: !3, line: 24, column: 5)
!159 = !DILocation(line: 25, column: 5, scope: !160)
!160 = distinct !DILexicalBlock(scope: !161, file: !3, line: 25, column: 5)
!161 = distinct !DILexicalBlock(scope: !141, file: !3, line: 25, column: 5)
!162 = !DILocation(line: 26, column: 5, scope: !163)
!163 = distinct !DILexicalBlock(scope: !164, file: !3, line: 26, column: 5)
!164 = distinct !DILexicalBlock(scope: !141, file: !3, line: 26, column: 5)
!165 = !DILocation(line: 27, column: 5, scope: !166)
!166 = distinct !DILexicalBlock(scope: !167, file: !3, line: 27, column: 5)
!167 = distinct !DILexicalBlock(scope: !141, file: !3, line: 27, column: 5)
!168 = !DILocation(line: 28, column: 5, scope: !169)
!169 = distinct !DILexicalBlock(scope: !170, file: !3, line: 28, column: 5)
!170 = distinct !DILexicalBlock(scope: !141, file: !3, line: 28, column: 5)
!171 = !DILocation(line: 30, column: 5, scope: !172)
!172 = distinct !DILexicalBlock(scope: !173, file: !3, line: 30, column: 5)
!173 = distinct !DILexicalBlock(scope: !141, file: !3, line: 30, column: 5)
!174 = !DILocation(line: 31, column: 5, scope: !175)
!175 = distinct !DILexicalBlock(scope: !176, file: !3, line: 31, column: 5)
!176 = distinct !DILexicalBlock(scope: !141, file: !3, line: 31, column: 5)
!177 = !DILocation(line: 32, column: 5, scope: !178)
!178 = distinct !DILexicalBlock(scope: !179, file: !3, line: 32, column: 5)
!179 = distinct !DILexicalBlock(scope: !141, file: !3, line: 32, column: 5)
!180 = !DILocation(line: 33, column: 5, scope: !181)
!181 = distinct !DILexicalBlock(scope: !182, file: !3, line: 33, column: 5)
!182 = distinct !DILexicalBlock(scope: !141, file: !3, line: 33, column: 5)
!183 = !DILocalVariable(name: "t0", scope: !141, file: !3, line: 35, type: !184)
!184 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !83, line: 27, baseType: !185)
!185 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!186 = !DILocation(line: 35, column: 15, scope: !141)
!187 = !DILocalVariable(name: "t1", scope: !141, file: !3, line: 35, type: !184)
!188 = !DILocation(line: 35, column: 19, scope: !141)
!189 = !DILocation(line: 36, column: 5, scope: !141)
!190 = !DILocation(line: 37, column: 5, scope: !141)
!191 = !DILocation(line: 38, column: 18, scope: !141)
!192 = !DILocation(line: 38, column: 5, scope: !141)
!193 = !DILocation(line: 39, column: 18, scope: !141)
!194 = !DILocation(line: 39, column: 5, scope: !141)
!195 = !DILocation(line: 40, column: 5, scope: !196)
!196 = distinct !DILexicalBlock(scope: !197, file: !3, line: 40, column: 5)
!197 = distinct !DILexicalBlock(scope: !141, file: !3, line: 40, column: 5)
!198 = !DILocation(line: 41, column: 5, scope: !141)
