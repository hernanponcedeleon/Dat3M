; ModuleID = 'benchmarks/ck/caslock.c'
source_filename = "benchmarks/ck/caslock.c"
target datalayout = "E-m:e-Fi64-i64:64-i128:128-n32:64-S128-v256:256:256-v512:512:512"
target triple = "ppc64-pc-linux-gnu"

%struct.ck_spinlock_cas = type { i32 }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !21
@lock = dso_local global %struct.ck_spinlock_cas zeroinitializer, align 4, !dbg !40
@.str = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !23
@.str.1 = private unnamed_addr constant [24 x i8] c"benchmarks/ck/caslock.c\00", align 1, !dbg !29
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !34

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @run(ptr noundef %0) #0 !dbg !55 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !59, !DIExpression(), !60)
    #dbg_declare(ptr %3, !61, !DIExpression(), !62)
  %5 = load ptr, ptr %2, align 8, !dbg !63
  %6 = ptrtoint ptr %5 to i64, !dbg !64
  store i64 %6, ptr %3, align 8, !dbg !62
  %7 = load i64, ptr %3, align 8, !dbg !65
  %8 = icmp eq i64 %7, 2, !dbg !67
  br i1 %8, label %9, label %15, !dbg !67

9:                                                ; preds = %1
    #dbg_declare(ptr %4, !68, !DIExpression(), !70)
  %10 = call zeroext i1 @ck_spinlock_cas_trylock(ptr noundef @lock), !dbg !71
  %11 = zext i1 %10 to i8, !dbg !70
  store i8 %11, ptr %4, align 1, !dbg !70
  %12 = load i8, ptr %4, align 1, !dbg !72
  %13 = trunc i8 %12 to i1, !dbg !72
  %14 = zext i1 %13 to i32, !dbg !72
  call void @__VERIFIER_assume(i32 noundef signext %14), !dbg !73
  br label %16, !dbg !74

15:                                               ; preds = %1
  call void @ck_spinlock_cas_lock(ptr noundef @lock), !dbg !75
  br label %16

16:                                               ; preds = %15, %9
  %17 = load i32, ptr @x, align 4, !dbg !77
  %18 = add nsw i32 %17, 1, !dbg !77
  store i32 %18, ptr @x, align 4, !dbg !77
  %19 = load i32, ptr @y, align 4, !dbg !78
  %20 = add nsw i32 %19, 1, !dbg !78
  store i32 %20, ptr @y, align 4, !dbg !78
  call void @ck_spinlock_cas_unlock(ptr noundef @lock), !dbg !79
  ret ptr null, !dbg !80
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i1 @ck_spinlock_cas_trylock(ptr noundef %0) #0 !dbg !81 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !85, !DIExpression(), !86)
    #dbg_declare(ptr %3, !87, !DIExpression(), !88)
  %4 = load ptr, ptr %2, align 8, !dbg !89
  %5 = getelementptr inbounds nuw %struct.ck_spinlock_cas, ptr %4, i32 0, i32 0, !dbg !90
  %6 = call zeroext i32 @ck_pr_fas_uint(ptr noundef %5, i32 noundef zeroext 1), !dbg !91
  store i32 %6, ptr %3, align 4, !dbg !92
  call void @ck_pr_fence_lock(), !dbg !93
  %7 = load i32, ptr %3, align 4, !dbg !94
  %8 = icmp ne i32 %7, 0, !dbg !95
  %9 = xor i1 %8, true, !dbg !95
  ret i1 %9, !dbg !96
}

declare void @__VERIFIER_assume(i32 noundef signext) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_cas_lock(ptr noundef %0) #0 !dbg !97 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !100, !DIExpression(), !101)
  br label %3, !dbg !102

3:                                                ; preds = %16, %1
  %4 = load ptr, ptr %2, align 8, !dbg !103
  %5 = getelementptr inbounds nuw %struct.ck_spinlock_cas, ptr %4, i32 0, i32 0, !dbg !104
  %6 = call zeroext i1 @ck_pr_cas_uint(ptr noundef %5, i32 noundef zeroext 0, i32 noundef zeroext 1), !dbg !105
  %7 = zext i1 %6 to i32, !dbg !105
  %8 = icmp eq i32 %7, 0, !dbg !106
  br i1 %8, label %9, label %17, !dbg !102

9:                                                ; preds = %3
  br label %10, !dbg !107

10:                                               ; preds = %15, %9
  %11 = load ptr, ptr %2, align 8, !dbg !109
  %12 = getelementptr inbounds nuw %struct.ck_spinlock_cas, ptr %11, i32 0, i32 0, !dbg !110
  %13 = call zeroext i32 @ck_pr_md_load_uint(ptr noundef %12), !dbg !111
  %14 = icmp eq i32 %13, 1, !dbg !112
  br i1 %14, label %15, label %16, !dbg !107

15:                                               ; preds = %10
  call void @ck_pr_stall(), !dbg !113
  br label %10, !dbg !107, !llvm.loop !114

16:                                               ; preds = %10
  br label %3, !dbg !102, !llvm.loop !117

17:                                               ; preds = %3
  call void @ck_pr_fence_lock(), !dbg !119
  ret void, !dbg !120
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_cas_unlock(ptr noundef %0) #0 !dbg !121 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !122, !DIExpression(), !123)
  call void @ck_pr_fence_unlock(), !dbg !124
  %3 = load ptr, ptr %2, align 8, !dbg !125
  %4 = getelementptr inbounds nuw %struct.ck_spinlock_cas, ptr %3, i32 0, i32 0, !dbg !126
  call void @ck_pr_md_store_uint(ptr noundef %4, i32 noundef zeroext 0), !dbg !127
  ret void, !dbg !128
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local signext i32 @main() #0 !dbg !129 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !132, !DIExpression(), !138)
    #dbg_declare(ptr %3, !139, !DIExpression(), !140)
  call void @ck_spinlock_cas_init(ptr noundef @lock), !dbg !141
  store i32 0, ptr %3, align 4, !dbg !142
  br label %4, !dbg !144

4:                                                ; preds = %18, %0
  %5 = load i32, ptr %3, align 4, !dbg !145
  %6 = icmp slt i32 %5, 3, !dbg !147
  br i1 %6, label %7, label %21, !dbg !148

7:                                                ; preds = %4
  %8 = load i32, ptr %3, align 4, !dbg !149
  %9 = sext i32 %8 to i64, !dbg !152
  %10 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %9, !dbg !152
  %11 = load i32, ptr %3, align 4, !dbg !153
  %12 = sext i32 %11 to i64, !dbg !154
  %13 = inttoptr i64 %12 to ptr, !dbg !155
  %14 = call signext i32 @pthread_create(ptr noundef %10, ptr noundef null, ptr noundef @run, ptr noundef %13), !dbg !156
  %15 = icmp ne i32 %14, 0, !dbg !157
  br i1 %15, label %16, label %17, !dbg !157

16:                                               ; preds = %7
  call void @exit(i32 noundef signext 1) #3, !dbg !158
  unreachable, !dbg !158

17:                                               ; preds = %7
  br label %18, !dbg !160

18:                                               ; preds = %17
  %19 = load i32, ptr %3, align 4, !dbg !161
  %20 = add nsw i32 %19, 1, !dbg !161
  store i32 %20, ptr %3, align 4, !dbg !161
  br label %4, !dbg !162, !llvm.loop !163

21:                                               ; preds = %4
  store i32 0, ptr %3, align 4, !dbg !165
  br label %22, !dbg !167

22:                                               ; preds = %34, %21
  %23 = load i32, ptr %3, align 4, !dbg !168
  %24 = icmp slt i32 %23, 3, !dbg !170
  br i1 %24, label %25, label %37, !dbg !171

25:                                               ; preds = %22
  %26 = load i32, ptr %3, align 4, !dbg !172
  %27 = sext i32 %26 to i64, !dbg !175
  %28 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %27, !dbg !175
  %29 = load ptr, ptr %28, align 8, !dbg !175
  %30 = call signext i32 @pthread_join(ptr noundef %29, ptr noundef null), !dbg !176
  %31 = icmp ne i32 %30, 0, !dbg !177
  br i1 %31, label %32, label %33, !dbg !177

32:                                               ; preds = %25
  call void @exit(i32 noundef signext 1) #3, !dbg !178
  unreachable, !dbg !178

33:                                               ; preds = %25
  br label %34, !dbg !180

34:                                               ; preds = %33
  %35 = load i32, ptr %3, align 4, !dbg !181
  %36 = add nsw i32 %35, 1, !dbg !181
  store i32 %36, ptr %3, align 4, !dbg !181
  br label %22, !dbg !182, !llvm.loop !183

37:                                               ; preds = %22
  %38 = load i32, ptr @x, align 4, !dbg !185
  %39 = icmp eq i32 %38, 3, !dbg !188
  br i1 %39, label %40, label %43, !dbg !189

40:                                               ; preds = %37
  %41 = load i32, ptr @y, align 4, !dbg !190
  %42 = icmp eq i32 %41, 3, !dbg !191
  br i1 %42, label %44, label %43, !dbg !192

43:                                               ; preds = %40, %37
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef signext 59, ptr noundef @__func__.main), !dbg !192
  br label %44, !dbg !192

44:                                               ; preds = %43, %40
  ret i32 0, !dbg !193
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_cas_init(ptr noundef %0) #0 !dbg !194 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !195, !DIExpression(), !196)
  %3 = load ptr, ptr %2, align 8, !dbg !197
  %4 = getelementptr inbounds nuw %struct.ck_spinlock_cas, ptr %3, i32 0, i32 0, !dbg !198
  store i32 0, ptr %4, align 4, !dbg !199
  call void @ck_pr_barrier(), !dbg !200
  ret void, !dbg !201
}

declare signext i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef signext) #2

declare signext i32 @pthread_join(ptr noundef, ptr noundef) #1

declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef signext, ptr noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i32 @ck_pr_fas_uint(ptr noundef %0, i32 noundef zeroext %1) #0 !dbg !202 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !206, !DIExpression(), !207)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !208, !DIExpression(), !207)
    #dbg_declare(ptr %5, !209, !DIExpression(), !207)
  %6 = load ptr, ptr %3, align 8, !dbg !207
  %7 = load i32, ptr %4, align 4, !dbg !207
  %8 = call i32 asm sideeffect "1:lwarx $0, 0, $1;stwcx. $2, 0, $1;bne- 1b;", "=&r,r,r,~{memory},~{cc}"(ptr %6, i32 %7) #4, !dbg !207, !srcloc !210
  store i32 %8, ptr %5, align 4, !dbg !207
  %9 = load i32, ptr %5, align 4, !dbg !207
  ret i32 %9, !dbg !207
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_lock() #0 !dbg !211 {
  call void @ck_pr_fence_strict_lock(), !dbg !215
  ret void, !dbg !215
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_lock() #0 !dbg !216 {
  call void asm sideeffect "lwsync", "~{memory}"() #4, !dbg !217, !srcloc !218
  ret void, !dbg !217
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i1 @ck_pr_cas_uint(ptr noundef %0, i32 noundef zeroext %1, i32 noundef zeroext %2) #0 !dbg !219 {
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !222, !DIExpression(), !223)
  store i32 %1, ptr %5, align 4
    #dbg_declare(ptr %5, !224, !DIExpression(), !223)
  store i32 %2, ptr %6, align 4
    #dbg_declare(ptr %6, !225, !DIExpression(), !223)
    #dbg_declare(ptr %7, !226, !DIExpression(), !223)
  %8 = load ptr, ptr %4, align 8, !dbg !223
  %9 = load i32, ptr %6, align 4, !dbg !223
  %10 = load i32, ptr %5, align 4, !dbg !223
  %11 = call i32 asm sideeffect "1:lwarx $0, 0, $1;cmpw  0, $0, $3;bne-  2f;stwcx. $2, 0, $1;bne-  1b;2:", "=&r,r,r,r,~{memory},~{cc}"(ptr %8, i32 %9, i32 %10) #4, !dbg !223, !srcloc !227
  store i32 %11, ptr %7, align 4, !dbg !223
  %12 = load i32, ptr %7, align 4, !dbg !223
  %13 = load i32, ptr %5, align 4, !dbg !223
  %14 = icmp eq i32 %12, %13, !dbg !223
  ret i1 %14, !dbg !223
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !228 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !231, !DIExpression(), !232)
    #dbg_declare(ptr %3, !233, !DIExpression(), !232)
  %4 = load ptr, ptr %2, align 8, !dbg !232
  %5 = call i32 asm sideeffect "lwz${1:U}${1:X} $0, $1", "=r,*m,~{memory}"(ptr elementtype(i32) %4) #4, !dbg !232, !srcloc !234
  store i32 %5, ptr %3, align 4, !dbg !232
  %6 = load i32, ptr %3, align 4, !dbg !232
  ret i32 %6, !dbg !232
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_stall() #0 !dbg !235 {
  call void asm sideeffect "or 1, 1, 1;or 2, 2, 2;", "~{memory}"() #4, !dbg !236, !srcloc !237
  ret void, !dbg !238
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_unlock() #0 !dbg !239 {
  call void @ck_pr_fence_strict_unlock(), !dbg !240
  ret void, !dbg !240
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef zeroext %1) #0 !dbg !241 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !244, !DIExpression(), !245)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !246, !DIExpression(), !245)
  %5 = load ptr, ptr %3, align 8, !dbg !245
  %6 = load i32, ptr %4, align 4, !dbg !245
  call void asm sideeffect "stw${0:U}${0:X} $1, $0", "=*m,r,~{memory}"(ptr elementtype(i32) %5, i32 %6) #4, !dbg !245, !srcloc !247
  ret void, !dbg !245
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_unlock() #0 !dbg !248 {
  call void asm sideeffect "lwsync", "~{memory}"() #4, !dbg !249, !srcloc !250
  ret void, !dbg !249
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_barrier() #0 !dbg !251 {
  call void asm sideeffect "", "~{memory}"() #4, !dbg !253, !srcloc !254
  ret void, !dbg !255
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #3 = { noreturn }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!47, !48, !49, !50, !51, !52, !53}
!llvm.ident = !{!54}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 15, type: !12, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !20, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/caslock.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "eaf093b9cc44413a628cfc72d3a4aa19")
!4 = !{!5, !8, !9, !12, !13, !16, !19}
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !6, line: 23, baseType: !7)
!6 = !DIFile(filename: "include/libc/stdint.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "027aa838071dee39e5261b0fdecb37d3")
!7 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !10, line: 5, baseType: !11)
!10 = !DIFile(filename: "include/libc/_size_t.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "dc11ce4c8eb4c64bece0363f758637cd")
!11 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "bool", file: !14, line: 4, baseType: !15)
!14 = !DIFile(filename: "include/libc/stdbool.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6e643322591bab80343344357c642cba")
!15 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !18)
!18 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!20 = !{!0, !21, !23, !29, !34, !40}
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 15, type: !12, isLocal: false, isDefinition: true)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(scope: null, file: !3, line: 59, type: !25, isLocal: true, isDefinition: true)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 248, elements: !27)
!26 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!27 = !{!28}
!28 = !DISubrange(count: 31)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 59, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 192, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: 24)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(scope: null, file: !3, line: 59, type: !36, isLocal: true, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !37, size: 40, elements: !38)
!37 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !26)
!38 = !{!39}
!39 = !DISubrange(count: 5)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 14, type: !42, isLocal: false, isDefinition: true)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_cas_t", file: !43, line: 44, baseType: !44)
!43 = !DIFile(filename: "../ck/include/spinlock/cas.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "ce076f374c67b364c8434ea638760107")
!44 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_cas", file: !43, line: 41, size: 32, elements: !45)
!45 = !{!46}
!46 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !44, file: !43, line: 42, baseType: !18, size: 32)
!47 = !{i32 7, !"Dwarf Version", i32 5}
!48 = !{i32 2, !"Debug Info Version", i32 3}
!49 = !{i32 1, !"wchar_size", i32 4}
!50 = !{i32 8, !"PIC Level", i32 2}
!51 = !{i32 7, !"PIE Level", i32 2}
!52 = !{i32 7, !"uwtable", i32 2}
!53 = !{i32 7, !"frame-pointer", i32 2}
!54 = !{!"Homebrew clang version 22.1.8"}
!55 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 17, type: !56, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!56 = !DISubroutineType(types: !57)
!57 = !{!8, !8}
!58 = !{}
!59 = !DILocalVariable(name: "arg", arg: 1, scope: !55, file: !3, line: 17, type: !8)
!60 = !DILocation(line: 17, column: 17, scope: !55)
!61 = !DILocalVariable(name: "tid", scope: !55, file: !3, line: 20, type: !5)
!62 = !DILocation(line: 20, column: 14, scope: !55)
!63 = !DILocation(line: 20, column: 32, scope: !55)
!64 = !DILocation(line: 20, column: 21, scope: !55)
!65 = !DILocation(line: 24, column: 9, scope: !66)
!66 = distinct !DILexicalBlock(scope: !55, file: !3, line: 24, column: 9)
!67 = !DILocation(line: 24, column: 13, scope: !66)
!68 = !DILocalVariable(name: "acquired", scope: !69, file: !3, line: 26, type: !13)
!69 = distinct !DILexicalBlock(scope: !66, file: !3, line: 25, column: 5)
!70 = !DILocation(line: 26, column: 14, scope: !69)
!71 = !DILocation(line: 26, column: 25, scope: !69)
!72 = !DILocation(line: 27, column: 27, scope: !69)
!73 = !DILocation(line: 27, column: 9, scope: !69)
!74 = !DILocation(line: 28, column: 5, scope: !69)
!75 = !DILocation(line: 31, column: 9, scope: !76)
!76 = distinct !DILexicalBlock(scope: !66, file: !3, line: 30, column: 5)
!77 = !DILocation(line: 34, column: 6, scope: !55)
!78 = !DILocation(line: 35, column: 6, scope: !55)
!79 = !DILocation(line: 36, column: 5, scope: !55)
!80 = !DILocation(line: 37, column: 5, scope: !55)
!81 = distinct !DISubprogram(name: "ck_spinlock_cas_trylock", scope: !43, file: !43, line: 58, type: !82, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!82 = !DISubroutineType(types: !83)
!83 = !{!13, !84}
!84 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!85 = !DILocalVariable(name: "lock", arg: 1, scope: !81, file: !43, line: 58, type: !84)
!86 = !DILocation(line: 58, column: 49, scope: !81)
!87 = !DILocalVariable(name: "value", scope: !81, file: !43, line: 60, type: !18)
!88 = !DILocation(line: 60, column: 15, scope: !81)
!89 = !DILocation(line: 62, column: 26, scope: !81)
!90 = !DILocation(line: 62, column: 32, scope: !81)
!91 = !DILocation(line: 62, column: 10, scope: !81)
!92 = !DILocation(line: 62, column: 8, scope: !81)
!93 = !DILocation(line: 63, column: 2, scope: !81)
!94 = !DILocation(line: 64, column: 10, scope: !81)
!95 = !DILocation(line: 64, column: 9, scope: !81)
!96 = !DILocation(line: 64, column: 2, scope: !81)
!97 = distinct !DISubprogram(name: "ck_spinlock_cas_lock", scope: !43, file: !43, line: 77, type: !98, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!98 = !DISubroutineType(types: !99)
!99 = !{null, !84}
!100 = !DILocalVariable(name: "lock", arg: 1, scope: !97, file: !43, line: 77, type: !84)
!101 = !DILocation(line: 77, column: 46, scope: !97)
!102 = !DILocation(line: 80, column: 2, scope: !97)
!103 = !DILocation(line: 80, column: 25, scope: !97)
!104 = !DILocation(line: 80, column: 31, scope: !97)
!105 = !DILocation(line: 80, column: 9, scope: !97)
!106 = !DILocation(line: 80, column: 51, scope: !97)
!107 = !DILocation(line: 81, column: 3, scope: !108)
!108 = distinct !DILexicalBlock(scope: !97, file: !43, line: 80, column: 61)
!109 = !DILocation(line: 81, column: 27, scope: !108)
!110 = !DILocation(line: 81, column: 33, scope: !108)
!111 = !DILocation(line: 81, column: 10, scope: !108)
!112 = !DILocation(line: 81, column: 40, scope: !108)
!113 = !DILocation(line: 82, column: 4, scope: !108)
!114 = distinct !{!114, !107, !115, !116}
!115 = !DILocation(line: 82, column: 16, scope: !108)
!116 = !{!"llvm.loop.mustprogress"}
!117 = distinct !{!117, !102, !118, !116}
!118 = !DILocation(line: 83, column: 2, scope: !97)
!119 = !DILocation(line: 85, column: 2, scope: !97)
!120 = !DILocation(line: 86, column: 2, scope: !97)
!121 = distinct !DISubprogram(name: "ck_spinlock_cas_unlock", scope: !43, file: !43, line: 102, type: !98, scopeLine: 103, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!122 = !DILocalVariable(name: "lock", arg: 1, scope: !121, file: !43, line: 102, type: !84)
!123 = !DILocation(line: 102, column: 48, scope: !121)
!124 = !DILocation(line: 106, column: 2, scope: !121)
!125 = !DILocation(line: 107, column: 20, scope: !121)
!126 = !DILocation(line: 107, column: 26, scope: !121)
!127 = !DILocation(line: 107, column: 2, scope: !121)
!128 = !DILocation(line: 108, column: 2, scope: !121)
!129 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 40, type: !130, scopeLine: 41, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!130 = !DISubroutineType(types: !131)
!131 = !{!12}
!132 = !DILocalVariable(name: "threads", scope: !129, file: !3, line: 42, type: !133)
!133 = !DICompositeType(tag: DW_TAG_array_type, baseType: !134, size: 192, elements: !136)
!134 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !135, line: 2, baseType: !8)
!135 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!136 = !{!137}
!137 = !DISubrange(count: 3)
!138 = !DILocation(line: 42, column: 15, scope: !129)
!139 = !DILocalVariable(name: "i", scope: !129, file: !3, line: 43, type: !12)
!140 = !DILocation(line: 43, column: 9, scope: !129)
!141 = !DILocation(line: 44, column: 5, scope: !129)
!142 = !DILocation(line: 45, column: 12, scope: !143)
!143 = distinct !DILexicalBlock(scope: !129, file: !3, line: 45, column: 5)
!144 = !DILocation(line: 45, column: 10, scope: !143)
!145 = !DILocation(line: 45, column: 17, scope: !146)
!146 = distinct !DILexicalBlock(scope: !143, file: !3, line: 45, column: 5)
!147 = !DILocation(line: 45, column: 19, scope: !146)
!148 = !DILocation(line: 45, column: 5, scope: !143)
!149 = !DILocation(line: 47, column: 37, scope: !150)
!150 = distinct !DILexicalBlock(scope: !151, file: !3, line: 47, column: 13)
!151 = distinct !DILexicalBlock(scope: !146, file: !3, line: 46, column: 5)
!152 = !DILocation(line: 47, column: 29, scope: !150)
!153 = !DILocation(line: 47, column: 69, scope: !150)
!154 = !DILocation(line: 47, column: 60, scope: !150)
!155 = !DILocation(line: 47, column: 52, scope: !150)
!156 = !DILocation(line: 47, column: 13, scope: !150)
!157 = !DILocation(line: 47, column: 72, scope: !150)
!158 = !DILocation(line: 49, column: 13, scope: !159)
!159 = distinct !DILexicalBlock(scope: !150, file: !3, line: 48, column: 9)
!160 = !DILocation(line: 51, column: 5, scope: !151)
!161 = !DILocation(line: 45, column: 32, scope: !146)
!162 = !DILocation(line: 45, column: 5, scope: !146)
!163 = distinct !{!163, !148, !164, !116}
!164 = !DILocation(line: 51, column: 5, scope: !143)
!165 = !DILocation(line: 52, column: 12, scope: !166)
!166 = distinct !DILexicalBlock(scope: !129, file: !3, line: 52, column: 5)
!167 = !DILocation(line: 52, column: 10, scope: !166)
!168 = !DILocation(line: 52, column: 17, scope: !169)
!169 = distinct !DILexicalBlock(scope: !166, file: !3, line: 52, column: 5)
!170 = !DILocation(line: 52, column: 19, scope: !169)
!171 = !DILocation(line: 52, column: 5, scope: !166)
!172 = !DILocation(line: 54, column: 34, scope: !173)
!173 = distinct !DILexicalBlock(scope: !174, file: !3, line: 54, column: 13)
!174 = distinct !DILexicalBlock(scope: !169, file: !3, line: 53, column: 5)
!175 = !DILocation(line: 54, column: 26, scope: !173)
!176 = !DILocation(line: 54, column: 13, scope: !173)
!177 = !DILocation(line: 54, column: 44, scope: !173)
!178 = !DILocation(line: 56, column: 13, scope: !179)
!179 = distinct !DILexicalBlock(scope: !173, file: !3, line: 55, column: 9)
!180 = !DILocation(line: 58, column: 5, scope: !174)
!181 = !DILocation(line: 52, column: 32, scope: !169)
!182 = !DILocation(line: 52, column: 5, scope: !169)
!183 = distinct !{!183, !171, !184, !116}
!184 = !DILocation(line: 58, column: 5, scope: !166)
!185 = !DILocation(line: 59, column: 12, scope: !186)
!186 = distinct !DILexicalBlock(scope: !187, file: !3, line: 59, column: 5)
!187 = distinct !DILexicalBlock(scope: !129, file: !3, line: 59, column: 5)
!188 = !DILocation(line: 59, column: 14, scope: !186)
!189 = !DILocation(line: 59, column: 26, scope: !186)
!190 = !DILocation(line: 59, column: 29, scope: !186)
!191 = !DILocation(line: 59, column: 31, scope: !186)
!192 = !DILocation(line: 59, column: 5, scope: !186)
!193 = !DILocation(line: 60, column: 5, scope: !129)
!194 = distinct !DISubprogram(name: "ck_spinlock_cas_init", scope: !43, file: !43, line: 49, type: !98, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!195 = !DILocalVariable(name: "lock", arg: 1, scope: !194, file: !43, line: 49, type: !84)
!196 = !DILocation(line: 49, column: 46, scope: !194)
!197 = !DILocation(line: 52, column: 2, scope: !194)
!198 = !DILocation(line: 52, column: 8, scope: !194)
!199 = !DILocation(line: 52, column: 14, scope: !194)
!200 = !DILocation(line: 53, column: 2, scope: !194)
!201 = !DILocation(line: 54, column: 2, scope: !194)
!202 = distinct !DISubprogram(name: "ck_pr_fas_uint", scope: !203, file: !203, line: 306, type: !204, scopeLine: 306, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!203 = !DIFile(filename: "../ck/include/gcc/ppc64/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "8952bb109540f13c2aa63ce3890cafa9")
!204 = !DISubroutineType(types: !205)
!205 = !{!18, !19, !18}
!206 = !DILocalVariable(name: "target", arg: 1, scope: !202, file: !203, line: 306, type: !19)
!207 = !DILocation(line: 306, column: 1, scope: !202)
!208 = !DILocalVariable(name: "v", arg: 2, scope: !202, file: !203, line: 306, type: !18)
!209 = !DILocalVariable(name: "previous", scope: !202, file: !203, line: 306, type: !18)
!210 = !{i64 2147597853}
!211 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !212, file: !212, line: 122, type: !213, scopeLine: 122, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!212 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!213 = !DISubroutineType(types: !214)
!214 = !{null}
!215 = !DILocation(line: 122, column: 1, scope: !211)
!216 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !203, file: !203, line: 86, type: !213, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!217 = !DILocation(line: 86, column: 1, scope: !216)
!218 = !{i64 2147584006}
!219 = distinct !DISubprogram(name: "ck_pr_cas_uint", scope: !203, file: !203, line: 278, type: !220, scopeLine: 278, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!220 = !DISubroutineType(types: !221)
!221 = !{!13, !19, !18, !18}
!222 = !DILocalVariable(name: "target", arg: 1, scope: !219, file: !203, line: 278, type: !19)
!223 = !DILocation(line: 278, column: 1, scope: !219)
!224 = !DILocalVariable(name: "compare", arg: 2, scope: !219, file: !203, line: 278, type: !18)
!225 = !DILocalVariable(name: "set", arg: 3, scope: !219, file: !203, line: 278, type: !18)
!226 = !DILocalVariable(name: "previous", scope: !219, file: !203, line: 278, type: !18)
!227 = !{i64 2147593798}
!228 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !203, file: !203, line: 111, type: !229, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!229 = !DISubroutineType(types: !230)
!230 = !{!18, !16}
!231 = !DILocalVariable(name: "target", arg: 1, scope: !228, file: !203, line: 111, type: !16)
!232 = !DILocation(line: 111, column: 1, scope: !228)
!233 = !DILocalVariable(name: "r", scope: !228, file: !203, line: 111, type: !18)
!234 = !{i64 2147586577}
!235 = distinct !DISubprogram(name: "ck_pr_stall", scope: !203, file: !203, line: 54, type: !213, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!236 = !DILocation(line: 57, column: 2, scope: !235)
!237 = !{i64 85573}
!238 = !DILocation(line: 59, column: 2, scope: !235)
!239 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !212, file: !212, line: 123, type: !213, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!240 = !DILocation(line: 123, column: 1, scope: !239)
!241 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !203, file: !203, line: 141, type: !242, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!242 = !DISubroutineType(types: !243)
!243 = !{null, !19, !18}
!244 = !DILocalVariable(name: "target", arg: 1, scope: !241, file: !203, line: 141, type: !19)
!245 = !DILocation(line: 141, column: 1, scope: !241)
!246 = !DILocalVariable(name: "v", arg: 2, scope: !241, file: !203, line: 141, type: !18)
!247 = !{i64 2147590284}
!248 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !203, file: !203, line: 87, type: !213, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!249 = !DILocation(line: 87, column: 1, scope: !248)
!250 = !{i64 2147584203}
!251 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !252, file: !252, line: 37, type: !213, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!252 = !DIFile(filename: "../ck/include/gcc/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!253 = !DILocation(line: 40, column: 2, scope: !251)
!254 = !{i64 141274}
!255 = !DILocation(line: 41, column: 2, scope: !251)
