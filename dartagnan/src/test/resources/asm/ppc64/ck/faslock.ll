; ModuleID = 'benchmarks/ck/faslock.c'
source_filename = "benchmarks/ck/faslock.c"
target datalayout = "E-m:e-Fi64-i64:64-i128:128-n32:64-S128-v256:256:256-v512:512:512"
target triple = "ppc64-pc-linux-gnu"

%struct.ck_spinlock_fas = type { i32 }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !21
@lock = dso_local global %struct.ck_spinlock_fas zeroinitializer, align 4, !dbg !40
@.str = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !23
@.str.1 = private unnamed_addr constant [24 x i8] c"benchmarks/ck/faslock.c\00", align 1, !dbg !29
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
  %10 = call zeroext i1 @ck_spinlock_fas_trylock(ptr noundef @lock), !dbg !71
  %11 = zext i1 %10 to i8, !dbg !70
  store i8 %11, ptr %4, align 1, !dbg !70
  %12 = load i8, ptr %4, align 1, !dbg !72
  %13 = trunc i8 %12 to i1, !dbg !72
  %14 = zext i1 %13 to i32, !dbg !72
  call void @__VERIFIER_assume(i32 noundef signext %14), !dbg !73
  br label %16, !dbg !74

15:                                               ; preds = %1
  call void @ck_spinlock_fas_lock(ptr noundef @lock), !dbg !75
  br label %16

16:                                               ; preds = %15, %9
  %17 = load i32, ptr @x, align 4, !dbg !77
  %18 = add nsw i32 %17, 1, !dbg !77
  store i32 %18, ptr @x, align 4, !dbg !77
  %19 = load i32, ptr @y, align 4, !dbg !78
  %20 = add nsw i32 %19, 1, !dbg !78
  store i32 %20, ptr @y, align 4, !dbg !78
  call void @ck_spinlock_fas_unlock(ptr noundef @lock), !dbg !79
  ret ptr null, !dbg !80
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i1 @ck_spinlock_fas_trylock(ptr noundef %0) #0 !dbg !81 {
  %2 = alloca ptr, align 8
  %3 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !85, !DIExpression(), !86)
    #dbg_declare(ptr %3, !87, !DIExpression(), !88)
  %4 = load ptr, ptr %2, align 8, !dbg !89
  %5 = getelementptr inbounds nuw %struct.ck_spinlock_fas, ptr %4, i32 0, i32 0, !dbg !90
  %6 = call zeroext i32 @ck_pr_fas_uint(ptr noundef %5, i32 noundef zeroext 1), !dbg !91
  %7 = icmp ne i32 %6, 0, !dbg !91
  %8 = zext i1 %7 to i8, !dbg !92
  store i8 %8, ptr %3, align 1, !dbg !92
  call void @ck_pr_fence_lock(), !dbg !93
  %9 = load i8, ptr %3, align 1, !dbg !94
  %10 = trunc i8 %9 to i1, !dbg !94
  %11 = xor i1 %10, true, !dbg !95
  ret i1 %11, !dbg !96
}

declare void @__VERIFIER_assume(i32 noundef signext) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_fas_lock(ptr noundef %0) #0 !dbg !97 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !100, !DIExpression(), !101)
  br label %3, !dbg !102

3:                                                ; preds = %20, %1
  %4 = load ptr, ptr %2, align 8, !dbg !103
  %5 = getelementptr inbounds nuw %struct.ck_spinlock_fas, ptr %4, i32 0, i32 0, !dbg !104
  %6 = call zeroext i32 @ck_pr_fas_uint(ptr noundef %5, i32 noundef zeroext 1), !dbg !105
  %7 = icmp eq i32 %6, 1, !dbg !106
  %8 = xor i1 %7, true, !dbg !107
  %9 = xor i1 %8, true, !dbg !107
  %10 = zext i1 %9 to i32, !dbg !107
  %11 = sext i32 %10 to i64, !dbg !107
  %12 = icmp ne i64 %11, 0, !dbg !102
  br i1 %12, label %13, label %21, !dbg !102

13:                                               ; preds = %3
  br label %14, !dbg !108

14:                                               ; preds = %15, %13
  call void @ck_pr_stall(), !dbg !110
  br label %15, !dbg !112

15:                                               ; preds = %14
  %16 = load ptr, ptr %2, align 8, !dbg !113
  %17 = getelementptr inbounds nuw %struct.ck_spinlock_fas, ptr %16, i32 0, i32 0, !dbg !114
  %18 = call zeroext i32 @ck_pr_md_load_uint(ptr noundef %17), !dbg !115
  %19 = icmp eq i32 %18, 1, !dbg !116
  br i1 %19, label %14, label %20, !dbg !112, !llvm.loop !117

20:                                               ; preds = %15
  br label %3, !dbg !102, !llvm.loop !120

21:                                               ; preds = %3
  call void @ck_pr_fence_lock(), !dbg !122
  ret void, !dbg !123
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_fas_unlock(ptr noundef %0) #0 !dbg !124 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !125, !DIExpression(), !126)
  call void @ck_pr_fence_unlock(), !dbg !127
  %3 = load ptr, ptr %2, align 8, !dbg !128
  %4 = getelementptr inbounds nuw %struct.ck_spinlock_fas, ptr %3, i32 0, i32 0, !dbg !129
  call void @ck_pr_md_store_uint(ptr noundef %4, i32 noundef zeroext 0), !dbg !130
  ret void, !dbg !131
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local signext i32 @main() #0 !dbg !132 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !135, !DIExpression(), !141)
    #dbg_declare(ptr %3, !142, !DIExpression(), !143)
  call void @ck_spinlock_fas_init(ptr noundef @lock), !dbg !144
  store i32 0, ptr %3, align 4, !dbg !145
  br label %4, !dbg !147

4:                                                ; preds = %18, %0
  %5 = load i32, ptr %3, align 4, !dbg !148
  %6 = icmp slt i32 %5, 3, !dbg !150
  br i1 %6, label %7, label %21, !dbg !151

7:                                                ; preds = %4
  %8 = load i32, ptr %3, align 4, !dbg !152
  %9 = sext i32 %8 to i64, !dbg !155
  %10 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %9, !dbg !155
  %11 = load i32, ptr %3, align 4, !dbg !156
  %12 = sext i32 %11 to i64, !dbg !157
  %13 = inttoptr i64 %12 to ptr, !dbg !158
  %14 = call signext i32 @pthread_create(ptr noundef %10, ptr noundef null, ptr noundef @run, ptr noundef %13), !dbg !159
  %15 = icmp ne i32 %14, 0, !dbg !160
  br i1 %15, label %16, label %17, !dbg !160

16:                                               ; preds = %7
  call void @exit(i32 noundef signext 1) #3, !dbg !161
  unreachable, !dbg !161

17:                                               ; preds = %7
  br label %18, !dbg !163

18:                                               ; preds = %17
  %19 = load i32, ptr %3, align 4, !dbg !164
  %20 = add nsw i32 %19, 1, !dbg !164
  store i32 %20, ptr %3, align 4, !dbg !164
  br label %4, !dbg !165, !llvm.loop !166

21:                                               ; preds = %4
  store i32 0, ptr %3, align 4, !dbg !168
  br label %22, !dbg !170

22:                                               ; preds = %34, %21
  %23 = load i32, ptr %3, align 4, !dbg !171
  %24 = icmp slt i32 %23, 3, !dbg !173
  br i1 %24, label %25, label %37, !dbg !174

25:                                               ; preds = %22
  %26 = load i32, ptr %3, align 4, !dbg !175
  %27 = sext i32 %26 to i64, !dbg !178
  %28 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %27, !dbg !178
  %29 = load ptr, ptr %28, align 8, !dbg !178
  %30 = call signext i32 @pthread_join(ptr noundef %29, ptr noundef null), !dbg !179
  %31 = icmp ne i32 %30, 0, !dbg !180
  br i1 %31, label %32, label %33, !dbg !180

32:                                               ; preds = %25
  call void @exit(i32 noundef signext 1) #3, !dbg !181
  unreachable, !dbg !181

33:                                               ; preds = %25
  br label %34, !dbg !183

34:                                               ; preds = %33
  %35 = load i32, ptr %3, align 4, !dbg !184
  %36 = add nsw i32 %35, 1, !dbg !184
  store i32 %36, ptr %3, align 4, !dbg !184
  br label %22, !dbg !185, !llvm.loop !186

37:                                               ; preds = %22
  %38 = load i32, ptr @x, align 4, !dbg !188
  %39 = icmp eq i32 %38, 3, !dbg !191
  br i1 %39, label %40, label %43, !dbg !192

40:                                               ; preds = %37
  %41 = load i32, ptr @y, align 4, !dbg !193
  %42 = icmp eq i32 %41, 3, !dbg !194
  br i1 %42, label %44, label %43, !dbg !195

43:                                               ; preds = %40, %37
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef signext 52, ptr noundef @__func__.main), !dbg !195
  br label %44, !dbg !195

44:                                               ; preds = %43, %40
  ret i32 0, !dbg !196
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_fas_init(ptr noundef %0) #0 !dbg !197 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !198, !DIExpression(), !199)
  %3 = load ptr, ptr %2, align 8, !dbg !200
  %4 = getelementptr inbounds nuw %struct.ck_spinlock_fas, ptr %3, i32 0, i32 0, !dbg !201
  store i32 0, ptr %4, align 4, !dbg !202
  call void @ck_pr_barrier(), !dbg !203
  ret void, !dbg !204
}

declare signext i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef signext) #2

declare signext i32 @pthread_join(ptr noundef, ptr noundef) #1

declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef signext, ptr noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i32 @ck_pr_fas_uint(ptr noundef %0, i32 noundef zeroext %1) #0 !dbg !205 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !209, !DIExpression(), !210)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !211, !DIExpression(), !210)
    #dbg_declare(ptr %5, !212, !DIExpression(), !210)
  %6 = load ptr, ptr %3, align 8, !dbg !210
  %7 = load i32, ptr %4, align 4, !dbg !210
  %8 = call i32 asm sideeffect "1:lwarx $0, 0, $1;stwcx. $2, 0, $1;bne- 1b;", "=&r,r,r,~{memory},~{cc}"(ptr %6, i32 %7) #4, !dbg !210, !srcloc !213
  store i32 %8, ptr %5, align 4, !dbg !210
  %9 = load i32, ptr %5, align 4, !dbg !210
  ret i32 %9, !dbg !210
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_lock() #0 !dbg !214 {
  call void @ck_pr_fence_strict_lock(), !dbg !218
  ret void, !dbg !218
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_lock() #0 !dbg !219 {
  call void asm sideeffect "lwsync", "~{memory}"() #4, !dbg !220, !srcloc !221
  ret void, !dbg !220
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_stall() #0 !dbg !222 {
  call void asm sideeffect "or 1, 1, 1;or 2, 2, 2;", "~{memory}"() #4, !dbg !223, !srcloc !224
  ret void, !dbg !225
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !226 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !229, !DIExpression(), !230)
    #dbg_declare(ptr %3, !231, !DIExpression(), !230)
  %4 = load ptr, ptr %2, align 8, !dbg !230
  %5 = call i32 asm sideeffect "lwz${1:U}${1:X} $0, $1", "=r,*m,~{memory}"(ptr elementtype(i32) %4) #4, !dbg !230, !srcloc !232
  store i32 %5, ptr %3, align 4, !dbg !230
  %6 = load i32, ptr %3, align 4, !dbg !230
  ret i32 %6, !dbg !230
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_unlock() #0 !dbg !233 {
  call void @ck_pr_fence_strict_unlock(), !dbg !234
  ret void, !dbg !234
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef zeroext %1) #0 !dbg !235 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !238, !DIExpression(), !239)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !240, !DIExpression(), !239)
  %5 = load ptr, ptr %3, align 8, !dbg !239
  %6 = load i32, ptr %4, align 4, !dbg !239
  call void asm sideeffect "stw${0:U}${0:X} $1, $0", "=*m,r,~{memory}"(ptr elementtype(i32) %5, i32 %6) #4, !dbg !239, !srcloc !241
  ret void, !dbg !239
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_unlock() #0 !dbg !242 {
  call void asm sideeffect "lwsync", "~{memory}"() #4, !dbg !243, !srcloc !244
  ret void, !dbg !243
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_barrier() #0 !dbg !245 {
  call void asm sideeffect "", "~{memory}"() #4, !dbg !247, !srcloc !248
  ret void, !dbg !249
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
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 11, type: !12, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !20, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/faslock.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "631d1763b6f5a5e61a5ce6b886c7a8af")
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
!22 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 11, type: !12, isLocal: false, isDefinition: true)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(scope: null, file: !3, line: 52, type: !25, isLocal: true, isDefinition: true)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 248, elements: !27)
!26 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!27 = !{!28}
!28 = !DISubrange(count: 31)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 52, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 192, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: 24)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(scope: null, file: !3, line: 52, type: !36, isLocal: true, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !37, size: 40, elements: !38)
!37 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !26)
!38 = !{!39}
!39 = !DISubrange(count: 5)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 12, type: !42, isLocal: false, isDefinition: true)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_fas_t", file: !43, line: 42, baseType: !44)
!43 = !DIFile(filename: "../ck/include/spinlock/fas.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "999805093e3ea65ae15690fa7c76e04b")
!44 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_fas", file: !43, line: 39, size: 32, elements: !45)
!45 = !{!46}
!46 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !44, file: !43, line: 40, baseType: !18, size: 32)
!47 = !{i32 7, !"Dwarf Version", i32 5}
!48 = !{i32 2, !"Debug Info Version", i32 3}
!49 = !{i32 1, !"wchar_size", i32 4}
!50 = !{i32 8, !"PIC Level", i32 2}
!51 = !{i32 7, !"PIE Level", i32 2}
!52 = !{i32 7, !"uwtable", i32 2}
!53 = !{i32 7, !"frame-pointer", i32 2}
!54 = !{!"Homebrew clang version 22.1.8"}
!55 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 14, type: !56, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!56 = !DISubroutineType(types: !57)
!57 = !{!8, !8}
!58 = !{}
!59 = !DILocalVariable(name: "arg", arg: 1, scope: !55, file: !3, line: 14, type: !8)
!60 = !DILocation(line: 14, column: 17, scope: !55)
!61 = !DILocalVariable(name: "tid", scope: !55, file: !3, line: 16, type: !5)
!62 = !DILocation(line: 16, column: 14, scope: !55)
!63 = !DILocation(line: 16, column: 32, scope: !55)
!64 = !DILocation(line: 16, column: 21, scope: !55)
!65 = !DILocation(line: 18, column: 9, scope: !66)
!66 = distinct !DILexicalBlock(scope: !55, file: !3, line: 18, column: 9)
!67 = !DILocation(line: 18, column: 13, scope: !66)
!68 = !DILocalVariable(name: "acquired", scope: !69, file: !3, line: 20, type: !13)
!69 = distinct !DILexicalBlock(scope: !66, file: !3, line: 19, column: 5)
!70 = !DILocation(line: 20, column: 14, scope: !69)
!71 = !DILocation(line: 20, column: 25, scope: !69)
!72 = !DILocation(line: 21, column: 27, scope: !69)
!73 = !DILocation(line: 21, column: 9, scope: !69)
!74 = !DILocation(line: 22, column: 5, scope: !69)
!75 = !DILocation(line: 25, column: 9, scope: !76)
!76 = distinct !DILexicalBlock(scope: !66, file: !3, line: 24, column: 5)
!77 = !DILocation(line: 27, column: 6, scope: !55)
!78 = !DILocation(line: 28, column: 6, scope: !55)
!79 = !DILocation(line: 29, column: 5, scope: !55)
!80 = !DILocation(line: 30, column: 5, scope: !55)
!81 = distinct !DISubprogram(name: "ck_spinlock_fas_trylock", scope: !43, file: !43, line: 56, type: !82, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!82 = !DISubroutineType(types: !83)
!83 = !{!13, !84}
!84 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!85 = !DILocalVariable(name: "lock", arg: 1, scope: !81, file: !43, line: 56, type: !84)
!86 = !DILocation(line: 56, column: 49, scope: !81)
!87 = !DILocalVariable(name: "value", scope: !81, file: !43, line: 58, type: !13)
!88 = !DILocation(line: 58, column: 7, scope: !81)
!89 = !DILocation(line: 60, column: 26, scope: !81)
!90 = !DILocation(line: 60, column: 32, scope: !81)
!91 = !DILocation(line: 60, column: 10, scope: !81)
!92 = !DILocation(line: 60, column: 8, scope: !81)
!93 = !DILocation(line: 61, column: 2, scope: !81)
!94 = !DILocation(line: 63, column: 10, scope: !81)
!95 = !DILocation(line: 63, column: 9, scope: !81)
!96 = !DILocation(line: 63, column: 2, scope: !81)
!97 = distinct !DISubprogram(name: "ck_spinlock_fas_lock", scope: !43, file: !43, line: 77, type: !98, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!98 = !DISubroutineType(types: !99)
!99 = !{null, !84}
!100 = !DILocalVariable(name: "lock", arg: 1, scope: !97, file: !43, line: 77, type: !84)
!101 = !DILocation(line: 77, column: 46, scope: !97)
!102 = !DILocation(line: 80, column: 9, scope: !97)
!103 = !DILocation(line: 80, column: 47, scope: !97)
!104 = !DILocation(line: 80, column: 53, scope: !97)
!105 = !DILocation(line: 80, column: 31, scope: !97)
!106 = !DILocation(line: 80, column: 66, scope: !97)
!107 = !DILocation(line: 80, column: 16, scope: !97)
!108 = !DILocation(line: 81, column: 17, scope: !109)
!109 = distinct !DILexicalBlock(scope: !97, file: !43, line: 80, column: 76)
!110 = !DILocation(line: 82, column: 25, scope: !111)
!111 = distinct !DILexicalBlock(scope: !109, file: !43, line: 81, column: 20)
!112 = !DILocation(line: 83, column: 17, scope: !111)
!113 = !DILocation(line: 83, column: 43, scope: !109)
!114 = !DILocation(line: 83, column: 49, scope: !109)
!115 = !DILocation(line: 83, column: 26, scope: !109)
!116 = !DILocation(line: 83, column: 56, scope: !109)
!117 = distinct !{!117, !108, !118, !119}
!118 = !DILocation(line: 83, column: 63, scope: !109)
!119 = !{!"llvm.loop.mustprogress"}
!120 = distinct !{!120, !102, !121, !119}
!121 = !DILocation(line: 84, column: 9, scope: !97)
!122 = !DILocation(line: 86, column: 2, scope: !97)
!123 = !DILocation(line: 87, column: 2, scope: !97)
!124 = distinct !DISubprogram(name: "ck_spinlock_fas_unlock", scope: !43, file: !43, line: 103, type: !98, scopeLine: 104, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!125 = !DILocalVariable(name: "lock", arg: 1, scope: !124, file: !43, line: 103, type: !84)
!126 = !DILocation(line: 103, column: 48, scope: !124)
!127 = !DILocation(line: 106, column: 2, scope: !124)
!128 = !DILocation(line: 107, column: 20, scope: !124)
!129 = !DILocation(line: 107, column: 26, scope: !124)
!130 = !DILocation(line: 107, column: 2, scope: !124)
!131 = !DILocation(line: 108, column: 2, scope: !124)
!132 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 33, type: !133, scopeLine: 34, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!133 = !DISubroutineType(types: !134)
!134 = !{!12}
!135 = !DILocalVariable(name: "threads", scope: !132, file: !3, line: 35, type: !136)
!136 = !DICompositeType(tag: DW_TAG_array_type, baseType: !137, size: 192, elements: !139)
!137 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !138, line: 2, baseType: !8)
!138 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!139 = !{!140}
!140 = !DISubrange(count: 3)
!141 = !DILocation(line: 35, column: 15, scope: !132)
!142 = !DILocalVariable(name: "i", scope: !132, file: !3, line: 36, type: !12)
!143 = !DILocation(line: 36, column: 9, scope: !132)
!144 = !DILocation(line: 37, column: 5, scope: !132)
!145 = !DILocation(line: 38, column: 12, scope: !146)
!146 = distinct !DILexicalBlock(scope: !132, file: !3, line: 38, column: 5)
!147 = !DILocation(line: 38, column: 10, scope: !146)
!148 = !DILocation(line: 38, column: 17, scope: !149)
!149 = distinct !DILexicalBlock(scope: !146, file: !3, line: 38, column: 5)
!150 = !DILocation(line: 38, column: 19, scope: !149)
!151 = !DILocation(line: 38, column: 5, scope: !146)
!152 = !DILocation(line: 40, column: 37, scope: !153)
!153 = distinct !DILexicalBlock(scope: !154, file: !3, line: 40, column: 13)
!154 = distinct !DILexicalBlock(scope: !149, file: !3, line: 39, column: 5)
!155 = !DILocation(line: 40, column: 29, scope: !153)
!156 = !DILocation(line: 40, column: 68, scope: !153)
!157 = !DILocation(line: 40, column: 60, scope: !153)
!158 = !DILocation(line: 40, column: 52, scope: !153)
!159 = !DILocation(line: 40, column: 13, scope: !153)
!160 = !DILocation(line: 40, column: 71, scope: !153)
!161 = !DILocation(line: 42, column: 13, scope: !162)
!162 = distinct !DILexicalBlock(scope: !153, file: !3, line: 41, column: 9)
!163 = !DILocation(line: 44, column: 5, scope: !154)
!164 = !DILocation(line: 38, column: 32, scope: !149)
!165 = !DILocation(line: 38, column: 5, scope: !149)
!166 = distinct !{!166, !151, !167, !119}
!167 = !DILocation(line: 44, column: 5, scope: !146)
!168 = !DILocation(line: 45, column: 12, scope: !169)
!169 = distinct !DILexicalBlock(scope: !132, file: !3, line: 45, column: 5)
!170 = !DILocation(line: 45, column: 10, scope: !169)
!171 = !DILocation(line: 45, column: 17, scope: !172)
!172 = distinct !DILexicalBlock(scope: !169, file: !3, line: 45, column: 5)
!173 = !DILocation(line: 45, column: 19, scope: !172)
!174 = !DILocation(line: 45, column: 5, scope: !169)
!175 = !DILocation(line: 47, column: 34, scope: !176)
!176 = distinct !DILexicalBlock(scope: !177, file: !3, line: 47, column: 13)
!177 = distinct !DILexicalBlock(scope: !172, file: !3, line: 46, column: 5)
!178 = !DILocation(line: 47, column: 26, scope: !176)
!179 = !DILocation(line: 47, column: 13, scope: !176)
!180 = !DILocation(line: 47, column: 44, scope: !176)
!181 = !DILocation(line: 49, column: 13, scope: !182)
!182 = distinct !DILexicalBlock(scope: !176, file: !3, line: 48, column: 9)
!183 = !DILocation(line: 51, column: 5, scope: !177)
!184 = !DILocation(line: 45, column: 32, scope: !172)
!185 = !DILocation(line: 45, column: 5, scope: !172)
!186 = distinct !{!186, !174, !187, !119}
!187 = !DILocation(line: 51, column: 5, scope: !169)
!188 = !DILocation(line: 52, column: 12, scope: !189)
!189 = distinct !DILexicalBlock(scope: !190, file: !3, line: 52, column: 5)
!190 = distinct !DILexicalBlock(scope: !132, file: !3, line: 52, column: 5)
!191 = !DILocation(line: 52, column: 14, scope: !189)
!192 = !DILocation(line: 52, column: 26, scope: !189)
!193 = !DILocation(line: 52, column: 29, scope: !189)
!194 = !DILocation(line: 52, column: 31, scope: !189)
!195 = !DILocation(line: 52, column: 5, scope: !189)
!196 = !DILocation(line: 53, column: 5, scope: !132)
!197 = distinct !DISubprogram(name: "ck_spinlock_fas_init", scope: !43, file: !43, line: 47, type: !98, scopeLine: 48, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!198 = !DILocalVariable(name: "lock", arg: 1, scope: !197, file: !43, line: 47, type: !84)
!199 = !DILocation(line: 47, column: 46, scope: !197)
!200 = !DILocation(line: 50, column: 2, scope: !197)
!201 = !DILocation(line: 50, column: 8, scope: !197)
!202 = !DILocation(line: 50, column: 14, scope: !197)
!203 = !DILocation(line: 51, column: 2, scope: !197)
!204 = !DILocation(line: 52, column: 2, scope: !197)
!205 = distinct !DISubprogram(name: "ck_pr_fas_uint", scope: !206, file: !206, line: 306, type: !207, scopeLine: 306, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!206 = !DIFile(filename: "../ck/include/gcc/ppc64/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "8952bb109540f13c2aa63ce3890cafa9")
!207 = !DISubroutineType(types: !208)
!208 = !{!18, !19, !18}
!209 = !DILocalVariable(name: "target", arg: 1, scope: !205, file: !206, line: 306, type: !19)
!210 = !DILocation(line: 306, column: 1, scope: !205)
!211 = !DILocalVariable(name: "v", arg: 2, scope: !205, file: !206, line: 306, type: !18)
!212 = !DILocalVariable(name: "previous", scope: !205, file: !206, line: 306, type: !18)
!213 = !{i64 2147597646}
!214 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !215, file: !215, line: 122, type: !216, scopeLine: 122, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!215 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!216 = !DISubroutineType(types: !217)
!217 = !{null}
!218 = !DILocation(line: 122, column: 1, scope: !214)
!219 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !206, file: !206, line: 86, type: !216, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!220 = !DILocation(line: 86, column: 1, scope: !219)
!221 = !{i64 2147583799}
!222 = distinct !DISubprogram(name: "ck_pr_stall", scope: !206, file: !206, line: 54, type: !216, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!223 = !DILocation(line: 57, column: 2, scope: !222)
!224 = !{i64 85366}
!225 = !DILocation(line: 59, column: 2, scope: !222)
!226 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !206, file: !206, line: 111, type: !227, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!227 = !DISubroutineType(types: !228)
!228 = !{!18, !16}
!229 = !DILocalVariable(name: "target", arg: 1, scope: !226, file: !206, line: 111, type: !16)
!230 = !DILocation(line: 111, column: 1, scope: !226)
!231 = !DILocalVariable(name: "r", scope: !226, file: !206, line: 111, type: !18)
!232 = !{i64 2147586370}
!233 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !215, file: !215, line: 123, type: !216, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!234 = !DILocation(line: 123, column: 1, scope: !233)
!235 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !206, file: !206, line: 141, type: !236, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!236 = !DISubroutineType(types: !237)
!237 = !{null, !19, !18}
!238 = !DILocalVariable(name: "target", arg: 1, scope: !235, file: !206, line: 141, type: !19)
!239 = !DILocation(line: 141, column: 1, scope: !235)
!240 = !DILocalVariable(name: "v", arg: 2, scope: !235, file: !206, line: 141, type: !18)
!241 = !{i64 2147590077}
!242 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !206, file: !206, line: 87, type: !216, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!243 = !DILocation(line: 87, column: 1, scope: !242)
!244 = !{i64 2147583996}
!245 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !246, file: !246, line: 37, type: !216, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!246 = !DIFile(filename: "../ck/include/gcc/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!247 = !DILocation(line: 40, column: 2, scope: !245)
!248 = !{i64 141067}
!249 = !DILocation(line: 41, column: 2, scope: !245)
