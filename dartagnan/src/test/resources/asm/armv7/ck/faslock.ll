; ModuleID = 'benchmarks/ck/faslock.c'
source_filename = "benchmarks/ck/faslock.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv7-pc-linux-gnu"

%struct.ck_spinlock_fas = type { i32 }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !16
@lock = dso_local global %struct.ck_spinlock_fas zeroinitializer, align 4, !dbg !35
@.str = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !18
@.str.1 = private unnamed_addr constant [24 x i8] c"benchmarks/ck/faslock.c\00", align 1, !dbg !24
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc ptr @run(ptr noundef %0) #0 !dbg !50 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  %4 = alloca i8, align 1
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !54, !DIExpression(), !55)
    #dbg_declare(ptr %3, !56, !DIExpression(), !57)
  %5 = load ptr, ptr %2, align 4, !dbg !58
  %6 = ptrtoint ptr %5 to i32, !dbg !59
  store i32 %6, ptr %3, align 4, !dbg !57
  %7 = load i32, ptr %3, align 4, !dbg !60
  %8 = icmp eq i32 %7, 2, !dbg !62
  br i1 %8, label %9, label %15, !dbg !62

9:                                                ; preds = %1
    #dbg_declare(ptr %4, !63, !DIExpression(), !65)
  %10 = call arm_aapcscc zeroext i1 @ck_spinlock_fas_trylock(ptr noundef @lock), !dbg !66
  %11 = zext i1 %10 to i8, !dbg !65
  store i8 %11, ptr %4, align 1, !dbg !65
  %12 = load i8, ptr %4, align 1, !dbg !67
  %13 = trunc i8 %12 to i1, !dbg !67
  %14 = zext i1 %13 to i32, !dbg !67
  call arm_aapcscc void @__VERIFIER_assume(i32 noundef %14), !dbg !68
  br label %16, !dbg !69

15:                                               ; preds = %1
  call arm_aapcscc void @ck_spinlock_fas_lock(ptr noundef @lock), !dbg !70
  br label %16

16:                                               ; preds = %15, %9
  %17 = load i32, ptr @x, align 4, !dbg !72
  %18 = add nsw i32 %17, 1, !dbg !72
  store i32 %18, ptr @x, align 4, !dbg !72
  %19 = load i32, ptr @y, align 4, !dbg !73
  %20 = add nsw i32 %19, 1, !dbg !73
  store i32 %20, ptr @y, align 4, !dbg !73
  call arm_aapcscc void @ck_spinlock_fas_unlock(ptr noundef @lock), !dbg !74
  ret ptr null, !dbg !75
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc zeroext i1 @ck_spinlock_fas_trylock(ptr noundef %0) #0 !dbg !76 {
  %2 = alloca ptr, align 4
  %3 = alloca i8, align 1
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !80, !DIExpression(), !81)
    #dbg_declare(ptr %3, !82, !DIExpression(), !83)
  %4 = load ptr, ptr %2, align 4, !dbg !84
  %5 = getelementptr inbounds nuw %struct.ck_spinlock_fas, ptr %4, i32 0, i32 0, !dbg !85
  %6 = call arm_aapcscc i32 @ck_pr_fas_uint(ptr noundef %5, i32 noundef 1), !dbg !86
  %7 = icmp ne i32 %6, 0, !dbg !86
  %8 = zext i1 %7 to i8, !dbg !87
  store i8 %8, ptr %3, align 1, !dbg !87
  call arm_aapcscc void @ck_pr_fence_lock(), !dbg !88
  %9 = load i8, ptr %3, align 1, !dbg !89
  %10 = trunc i8 %9 to i1, !dbg !89
  %11 = xor i1 %10, true, !dbg !90
  ret i1 %11, !dbg !91
}

declare arm_aapcscc void @__VERIFIER_assume(i32 noundef) #1

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_fas_lock(ptr noundef %0) #0 !dbg !92 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !95, !DIExpression(), !96)
  br label %3, !dbg !97

3:                                                ; preds = %17, %1
  %4 = load ptr, ptr %2, align 4, !dbg !98
  %5 = getelementptr inbounds nuw %struct.ck_spinlock_fas, ptr %4, i32 0, i32 0, !dbg !99
  %6 = call arm_aapcscc i32 @ck_pr_fas_uint(ptr noundef %5, i32 noundef 1), !dbg !100
  %7 = icmp eq i32 %6, 1, !dbg !101
  %8 = xor i1 %7, true, !dbg !102
  %9 = xor i1 %8, true, !dbg !102
  br i1 %9, label %10, label %18, !dbg !97

10:                                               ; preds = %3
  br label %11, !dbg !103

11:                                               ; preds = %12, %10
  call arm_aapcscc void @ck_pr_stall(), !dbg !105
  br label %12, !dbg !107

12:                                               ; preds = %11
  %13 = load ptr, ptr %2, align 4, !dbg !108
  %14 = getelementptr inbounds nuw %struct.ck_spinlock_fas, ptr %13, i32 0, i32 0, !dbg !109
  %15 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %14), !dbg !110
  %16 = icmp eq i32 %15, 1, !dbg !111
  br i1 %16, label %11, label %17, !dbg !107, !llvm.loop !112

17:                                               ; preds = %12
  br label %3, !dbg !97, !llvm.loop !115

18:                                               ; preds = %3
  call arm_aapcscc void @ck_pr_fence_lock(), !dbg !117
  ret void, !dbg !118
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_fas_unlock(ptr noundef %0) #0 !dbg !119 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !120, !DIExpression(), !121)
  call arm_aapcscc void @ck_pr_fence_unlock(), !dbg !122
  %3 = load ptr, ptr %2, align 4, !dbg !123
  %4 = getelementptr inbounds nuw %struct.ck_spinlock_fas, ptr %3, i32 0, i32 0, !dbg !124
  call arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %4, i32 noundef 0), !dbg !125
  ret void, !dbg !126
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc i32 @main() #0 !dbg !127 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 4
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !130, !DIExpression(), !136)
    #dbg_declare(ptr %3, !137, !DIExpression(), !138)
  call arm_aapcscc void @ck_spinlock_fas_init(ptr noundef @lock), !dbg !139
  store i32 0, ptr %3, align 4, !dbg !140
  br label %4, !dbg !142

4:                                                ; preds = %16, %0
  %5 = load i32, ptr %3, align 4, !dbg !143
  %6 = icmp slt i32 %5, 3, !dbg !145
  br i1 %6, label %7, label %19, !dbg !146

7:                                                ; preds = %4
  %8 = load i32, ptr %3, align 4, !dbg !147
  %9 = getelementptr inbounds [3 x ptr], ptr %2, i32 0, i32 %8, !dbg !150
  %10 = load i32, ptr %3, align 4, !dbg !151
  %11 = inttoptr i32 %10 to ptr, !dbg !152
  %12 = call arm_aapcscc i32 @pthread_create(ptr noundef %9, ptr noundef null, ptr noundef @run, ptr noundef %11), !dbg !153
  %13 = icmp ne i32 %12, 0, !dbg !154
  br i1 %13, label %14, label %15, !dbg !154

14:                                               ; preds = %7
  call arm_aapcscc void @exit(i32 noundef 1) #3, !dbg !155
  unreachable, !dbg !155

15:                                               ; preds = %7
  br label %16, !dbg !157

16:                                               ; preds = %15
  %17 = load i32, ptr %3, align 4, !dbg !158
  %18 = add nsw i32 %17, 1, !dbg !158
  store i32 %18, ptr %3, align 4, !dbg !158
  br label %4, !dbg !159, !llvm.loop !160

19:                                               ; preds = %4
  store i32 0, ptr %3, align 4, !dbg !162
  br label %20, !dbg !164

20:                                               ; preds = %31, %19
  %21 = load i32, ptr %3, align 4, !dbg !165
  %22 = icmp slt i32 %21, 3, !dbg !167
  br i1 %22, label %23, label %34, !dbg !168

23:                                               ; preds = %20
  %24 = load i32, ptr %3, align 4, !dbg !169
  %25 = getelementptr inbounds [3 x ptr], ptr %2, i32 0, i32 %24, !dbg !172
  %26 = load ptr, ptr %25, align 4, !dbg !172
  %27 = call arm_aapcscc i32 @pthread_join(ptr noundef %26, ptr noundef null), !dbg !173
  %28 = icmp ne i32 %27, 0, !dbg !174
  br i1 %28, label %29, label %30, !dbg !174

29:                                               ; preds = %23
  call arm_aapcscc void @exit(i32 noundef 1) #3, !dbg !175
  unreachable, !dbg !175

30:                                               ; preds = %23
  br label %31, !dbg !177

31:                                               ; preds = %30
  %32 = load i32, ptr %3, align 4, !dbg !178
  %33 = add nsw i32 %32, 1, !dbg !178
  store i32 %33, ptr %3, align 4, !dbg !178
  br label %20, !dbg !179, !llvm.loop !180

34:                                               ; preds = %20
  %35 = load i32, ptr @x, align 4, !dbg !182
  %36 = icmp eq i32 %35, 3, !dbg !185
  br i1 %36, label %37, label %40, !dbg !186

37:                                               ; preds = %34
  %38 = load i32, ptr @y, align 4, !dbg !187
  %39 = icmp eq i32 %38, 3, !dbg !188
  br i1 %39, label %41, label %40, !dbg !189

40:                                               ; preds = %37, %34
  call arm_aapcscc void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 52, ptr noundef @__func__.main), !dbg !189
  br label %41, !dbg !189

41:                                               ; preds = %40, %37
  ret i32 0, !dbg !190
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_fas_init(ptr noundef %0) #0 !dbg !191 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !192, !DIExpression(), !193)
  %3 = load ptr, ptr %2, align 4, !dbg !194
  %4 = getelementptr inbounds nuw %struct.ck_spinlock_fas, ptr %3, i32 0, i32 0, !dbg !195
  store i32 0, ptr %4, align 4, !dbg !196
  call arm_aapcscc void @ck_pr_barrier(), !dbg !197
  ret void, !dbg !198
}

declare arm_aapcscc i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noreturn
declare arm_aapcscc void @exit(i32 noundef) #2

declare arm_aapcscc i32 @pthread_join(ptr noundef, ptr noundef) #1

declare arm_aapcscc void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc i32 @ck_pr_fas_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !199 {
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !204, !DIExpression(), !205)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !206, !DIExpression(), !205)
    #dbg_declare(ptr %5, !207, !DIExpression(), !205)
  store i32 0, ptr %5, align 4, !dbg !205
    #dbg_declare(ptr %6, !208, !DIExpression(), !205)
  store i32 0, ptr %6, align 4, !dbg !205
  %7 = load i32, ptr %5, align 4, !dbg !205
  %8 = load i32, ptr %6, align 4, !dbg !205
  %9 = load ptr, ptr %3, align 4, !dbg !205
  %10 = load i32, ptr %4, align 4, !dbg !205
  %11 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];strex $1, $3, [$2];cmp $1, #0;bne 1b;", "=&r,=&r,r,r,0,1,~{memory},~{cc}"(ptr %9, i32 %10, i32 %7, i32 %8) #4, !dbg !205, !srcloc !209
  %12 = extractvalue { i32, i32 } %11, 0, !dbg !205
  %13 = extractvalue { i32, i32 } %11, 1, !dbg !205
  store i32 %12, ptr %5, align 4, !dbg !205
  store i32 %13, ptr %6, align 4, !dbg !205
  %14 = load i32, ptr %5, align 4, !dbg !205
  ret i32 %14, !dbg !205
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_lock() #0 !dbg !210 {
  call arm_aapcscc void @ck_pr_fence_strict_lock(), !dbg !214
  ret void, !dbg !214
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_lock() #0 !dbg !215 {
  call void asm sideeffect "dmb", "r,~{memory}"(i32 0) #4, !dbg !216, !srcloc !217
  ret void, !dbg !218
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_stall() #0 !dbg !219 {
  call void asm sideeffect "", "~{memory}"() #4, !dbg !220, !srcloc !221
  ret void, !dbg !222
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !223 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !228, !DIExpression(), !229)
    #dbg_declare(ptr %3, !230, !DIExpression(), !229)
  store i32 0, ptr %3, align 4, !dbg !229
  %4 = load ptr, ptr %2, align 4, !dbg !229
  %5 = call i32 asm sideeffect "ldr $0, [$1];", "=r,r,~{memory}"(ptr %4) #4, !dbg !229, !srcloc !232
  store i32 %5, ptr %3, align 4, !dbg !229
  %6 = load i32, ptr %3, align 4, !dbg !229
  ret i32 %6, !dbg !229
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_unlock() #0 !dbg !233 {
  call arm_aapcscc void @ck_pr_fence_strict_unlock(), !dbg !234
  ret void, !dbg !234
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !235 {
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !238, !DIExpression(), !239)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !240, !DIExpression(), !239)
  %5 = load ptr, ptr %3, align 4, !dbg !239
  %6 = load i32, ptr %4, align 4, !dbg !239
  call void asm sideeffect "str $1, [$0]", "r,r,~{memory}"(ptr %5, i32 %6) #4, !dbg !239, !srcloc !241
  ret void, !dbg !239
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_unlock() #0 !dbg !242 {
  call void asm sideeffect "dmb", "r,~{memory}"(i32 0) #4, !dbg !243, !srcloc !244
  ret void, !dbg !245
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_barrier() #0 !dbg !246 {
  call void asm sideeffect "", "~{memory}"() #4, !dbg !248, !srcloc !249
  ret void, !dbg !250
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv7-a,+dsp,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv7-a,+dsp,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv7-a,+dsp,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #3 = { noreturn }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!42, !43, !44, !45, !46, !47, !48}
!llvm.ident = !{!49}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 11, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !15, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/faslock.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "631d1763b6f5a5e61a5ce6b886c7a8af")
!4 = !{!5, !8, !9, !7, !12, !11}
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !6, line: 17, baseType: !7)
!6 = !DIFile(filename: "include/libc/stdint.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "027aa838071dee39e5261b0fdecb37d3")
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !10, line: 3, baseType: !11)
!10 = !DIFile(filename: "include/libc/_size_t.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "dc11ce4c8eb4c64bece0363f758637cd")
!11 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "bool", file: !13, line: 4, baseType: !14)
!13 = !DIFile(filename: "include/libc/stdbool.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6e643322591bab80343344357c642cba")
!14 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!15 = !{!0, !16, !18, !24, !29, !35}
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 11, type: !7, isLocal: false, isDefinition: true)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !3, line: 52, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 248, elements: !22)
!21 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!22 = !{!23}
!23 = !DISubrange(count: 31)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(scope: null, file: !3, line: 52, type: !26, isLocal: true, isDefinition: true)
!26 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 192, elements: !27)
!27 = !{!28}
!28 = !DISubrange(count: 24)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 52, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 40, elements: !33)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !21)
!33 = !{!34}
!34 = !DISubrange(count: 5)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 12, type: !37, isLocal: false, isDefinition: true)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_fas_t", file: !38, line: 42, baseType: !39)
!38 = !DIFile(filename: "../ck/include/spinlock/fas.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "999805093e3ea65ae15690fa7c76e04b")
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_fas", file: !38, line: 39, size: 32, elements: !40)
!40 = !{!41}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !39, file: !38, line: 40, baseType: !11, size: 32)
!42 = !{i32 7, !"Dwarf Version", i32 5}
!43 = !{i32 2, !"Debug Info Version", i32 3}
!44 = !{i32 1, !"wchar_size", i32 4}
!45 = !{i32 1, !"min_enum_size", i32 4}
!46 = !{i32 8, !"PIC Level", i32 2}
!47 = !{i32 7, !"PIE Level", i32 2}
!48 = !{i32 7, !"frame-pointer", i32 2}
!49 = !{!"Homebrew clang version 22.1.8"}
!50 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 14, type: !51, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!51 = !DISubroutineType(types: !52)
!52 = !{!8, !8}
!53 = !{}
!54 = !DILocalVariable(name: "arg", arg: 1, scope: !50, file: !3, line: 14, type: !8)
!55 = !DILocation(line: 14, column: 17, scope: !50)
!56 = !DILocalVariable(name: "tid", scope: !50, file: !3, line: 16, type: !5)
!57 = !DILocation(line: 16, column: 14, scope: !50)
!58 = !DILocation(line: 16, column: 32, scope: !50)
!59 = !DILocation(line: 16, column: 21, scope: !50)
!60 = !DILocation(line: 18, column: 9, scope: !61)
!61 = distinct !DILexicalBlock(scope: !50, file: !3, line: 18, column: 9)
!62 = !DILocation(line: 18, column: 13, scope: !61)
!63 = !DILocalVariable(name: "acquired", scope: !64, file: !3, line: 20, type: !12)
!64 = distinct !DILexicalBlock(scope: !61, file: !3, line: 19, column: 5)
!65 = !DILocation(line: 20, column: 14, scope: !64)
!66 = !DILocation(line: 20, column: 25, scope: !64)
!67 = !DILocation(line: 21, column: 27, scope: !64)
!68 = !DILocation(line: 21, column: 9, scope: !64)
!69 = !DILocation(line: 22, column: 5, scope: !64)
!70 = !DILocation(line: 25, column: 9, scope: !71)
!71 = distinct !DILexicalBlock(scope: !61, file: !3, line: 24, column: 5)
!72 = !DILocation(line: 27, column: 6, scope: !50)
!73 = !DILocation(line: 28, column: 6, scope: !50)
!74 = !DILocation(line: 29, column: 5, scope: !50)
!75 = !DILocation(line: 30, column: 5, scope: !50)
!76 = distinct !DISubprogram(name: "ck_spinlock_fas_trylock", scope: !38, file: !38, line: 56, type: !77, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!77 = !DISubroutineType(types: !78)
!78 = !{!12, !79}
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 32)
!80 = !DILocalVariable(name: "lock", arg: 1, scope: !76, file: !38, line: 56, type: !79)
!81 = !DILocation(line: 56, column: 49, scope: !76)
!82 = !DILocalVariable(name: "value", scope: !76, file: !38, line: 58, type: !12)
!83 = !DILocation(line: 58, column: 7, scope: !76)
!84 = !DILocation(line: 60, column: 26, scope: !76)
!85 = !DILocation(line: 60, column: 32, scope: !76)
!86 = !DILocation(line: 60, column: 10, scope: !76)
!87 = !DILocation(line: 60, column: 8, scope: !76)
!88 = !DILocation(line: 61, column: 2, scope: !76)
!89 = !DILocation(line: 63, column: 10, scope: !76)
!90 = !DILocation(line: 63, column: 9, scope: !76)
!91 = !DILocation(line: 63, column: 2, scope: !76)
!92 = distinct !DISubprogram(name: "ck_spinlock_fas_lock", scope: !38, file: !38, line: 77, type: !93, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!93 = !DISubroutineType(types: !94)
!94 = !{null, !79}
!95 = !DILocalVariable(name: "lock", arg: 1, scope: !92, file: !38, line: 77, type: !79)
!96 = !DILocation(line: 77, column: 46, scope: !92)
!97 = !DILocation(line: 80, column: 9, scope: !92)
!98 = !DILocation(line: 80, column: 47, scope: !92)
!99 = !DILocation(line: 80, column: 53, scope: !92)
!100 = !DILocation(line: 80, column: 31, scope: !92)
!101 = !DILocation(line: 80, column: 66, scope: !92)
!102 = !DILocation(line: 80, column: 16, scope: !92)
!103 = !DILocation(line: 81, column: 17, scope: !104)
!104 = distinct !DILexicalBlock(scope: !92, file: !38, line: 80, column: 76)
!105 = !DILocation(line: 82, column: 25, scope: !106)
!106 = distinct !DILexicalBlock(scope: !104, file: !38, line: 81, column: 20)
!107 = !DILocation(line: 83, column: 17, scope: !106)
!108 = !DILocation(line: 83, column: 43, scope: !104)
!109 = !DILocation(line: 83, column: 49, scope: !104)
!110 = !DILocation(line: 83, column: 26, scope: !104)
!111 = !DILocation(line: 83, column: 56, scope: !104)
!112 = distinct !{!112, !103, !113, !114}
!113 = !DILocation(line: 83, column: 63, scope: !104)
!114 = !{!"llvm.loop.mustprogress"}
!115 = distinct !{!115, !97, !116, !114}
!116 = !DILocation(line: 84, column: 9, scope: !92)
!117 = !DILocation(line: 86, column: 2, scope: !92)
!118 = !DILocation(line: 87, column: 2, scope: !92)
!119 = distinct !DISubprogram(name: "ck_spinlock_fas_unlock", scope: !38, file: !38, line: 103, type: !93, scopeLine: 104, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!120 = !DILocalVariable(name: "lock", arg: 1, scope: !119, file: !38, line: 103, type: !79)
!121 = !DILocation(line: 103, column: 48, scope: !119)
!122 = !DILocation(line: 106, column: 2, scope: !119)
!123 = !DILocation(line: 107, column: 20, scope: !119)
!124 = !DILocation(line: 107, column: 26, scope: !119)
!125 = !DILocation(line: 107, column: 2, scope: !119)
!126 = !DILocation(line: 108, column: 2, scope: !119)
!127 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 33, type: !128, scopeLine: 34, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!128 = !DISubroutineType(types: !129)
!129 = !{!7}
!130 = !DILocalVariable(name: "threads", scope: !127, file: !3, line: 35, type: !131)
!131 = !DICompositeType(tag: DW_TAG_array_type, baseType: !132, size: 96, elements: !134)
!132 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !133, line: 2, baseType: !8)
!133 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!134 = !{!135}
!135 = !DISubrange(count: 3)
!136 = !DILocation(line: 35, column: 15, scope: !127)
!137 = !DILocalVariable(name: "i", scope: !127, file: !3, line: 36, type: !7)
!138 = !DILocation(line: 36, column: 9, scope: !127)
!139 = !DILocation(line: 37, column: 5, scope: !127)
!140 = !DILocation(line: 38, column: 12, scope: !141)
!141 = distinct !DILexicalBlock(scope: !127, file: !3, line: 38, column: 5)
!142 = !DILocation(line: 38, column: 10, scope: !141)
!143 = !DILocation(line: 38, column: 17, scope: !144)
!144 = distinct !DILexicalBlock(scope: !141, file: !3, line: 38, column: 5)
!145 = !DILocation(line: 38, column: 19, scope: !144)
!146 = !DILocation(line: 38, column: 5, scope: !141)
!147 = !DILocation(line: 40, column: 37, scope: !148)
!148 = distinct !DILexicalBlock(scope: !149, file: !3, line: 40, column: 13)
!149 = distinct !DILexicalBlock(scope: !144, file: !3, line: 39, column: 5)
!150 = !DILocation(line: 40, column: 29, scope: !148)
!151 = !DILocation(line: 40, column: 68, scope: !148)
!152 = !DILocation(line: 40, column: 52, scope: !148)
!153 = !DILocation(line: 40, column: 13, scope: !148)
!154 = !DILocation(line: 40, column: 71, scope: !148)
!155 = !DILocation(line: 42, column: 13, scope: !156)
!156 = distinct !DILexicalBlock(scope: !148, file: !3, line: 41, column: 9)
!157 = !DILocation(line: 44, column: 5, scope: !149)
!158 = !DILocation(line: 38, column: 32, scope: !144)
!159 = !DILocation(line: 38, column: 5, scope: !144)
!160 = distinct !{!160, !146, !161, !114}
!161 = !DILocation(line: 44, column: 5, scope: !141)
!162 = !DILocation(line: 45, column: 12, scope: !163)
!163 = distinct !DILexicalBlock(scope: !127, file: !3, line: 45, column: 5)
!164 = !DILocation(line: 45, column: 10, scope: !163)
!165 = !DILocation(line: 45, column: 17, scope: !166)
!166 = distinct !DILexicalBlock(scope: !163, file: !3, line: 45, column: 5)
!167 = !DILocation(line: 45, column: 19, scope: !166)
!168 = !DILocation(line: 45, column: 5, scope: !163)
!169 = !DILocation(line: 47, column: 34, scope: !170)
!170 = distinct !DILexicalBlock(scope: !171, file: !3, line: 47, column: 13)
!171 = distinct !DILexicalBlock(scope: !166, file: !3, line: 46, column: 5)
!172 = !DILocation(line: 47, column: 26, scope: !170)
!173 = !DILocation(line: 47, column: 13, scope: !170)
!174 = !DILocation(line: 47, column: 44, scope: !170)
!175 = !DILocation(line: 49, column: 13, scope: !176)
!176 = distinct !DILexicalBlock(scope: !170, file: !3, line: 48, column: 9)
!177 = !DILocation(line: 51, column: 5, scope: !171)
!178 = !DILocation(line: 45, column: 32, scope: !166)
!179 = !DILocation(line: 45, column: 5, scope: !166)
!180 = distinct !{!180, !168, !181, !114}
!181 = !DILocation(line: 51, column: 5, scope: !163)
!182 = !DILocation(line: 52, column: 12, scope: !183)
!183 = distinct !DILexicalBlock(scope: !184, file: !3, line: 52, column: 5)
!184 = distinct !DILexicalBlock(scope: !127, file: !3, line: 52, column: 5)
!185 = !DILocation(line: 52, column: 14, scope: !183)
!186 = !DILocation(line: 52, column: 26, scope: !183)
!187 = !DILocation(line: 52, column: 29, scope: !183)
!188 = !DILocation(line: 52, column: 31, scope: !183)
!189 = !DILocation(line: 52, column: 5, scope: !183)
!190 = !DILocation(line: 53, column: 5, scope: !127)
!191 = distinct !DISubprogram(name: "ck_spinlock_fas_init", scope: !38, file: !38, line: 47, type: !93, scopeLine: 48, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!192 = !DILocalVariable(name: "lock", arg: 1, scope: !191, file: !38, line: 47, type: !79)
!193 = !DILocation(line: 47, column: 46, scope: !191)
!194 = !DILocation(line: 50, column: 2, scope: !191)
!195 = !DILocation(line: 50, column: 8, scope: !191)
!196 = !DILocation(line: 50, column: 14, scope: !191)
!197 = !DILocation(line: 51, column: 2, scope: !191)
!198 = !DILocation(line: 52, column: 2, scope: !191)
!199 = distinct !DISubprogram(name: "ck_pr_fas_uint", scope: !200, file: !200, line: 417, type: !201, scopeLine: 417, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!200 = !DIFile(filename: "../ck/include/gcc/arm/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "f3f9fb174933d4f9d5af6678feea8d14")
!201 = !DISubroutineType(types: !202)
!202 = !{!11, !203, !11}
!203 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 32)
!204 = !DILocalVariable(name: "target", arg: 1, scope: !199, file: !200, line: 417, type: !203)
!205 = !DILocation(line: 417, column: 1, scope: !199)
!206 = !DILocalVariable(name: "v", arg: 2, scope: !199, file: !200, line: 417, type: !11)
!207 = !DILocalVariable(name: "previous", scope: !199, file: !200, line: 417, type: !11)
!208 = !DILocalVariable(name: "tmp", scope: !199, file: !200, line: 417, type: !11)
!209 = !{i64 2147606200}
!210 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !211, file: !211, line: 122, type: !212, scopeLine: 122, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!211 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!212 = !DISubroutineType(types: !213)
!213 = !{null}
!214 = !DILocation(line: 122, column: 1, scope: !210)
!215 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !200, file: !200, line: 98, type: !212, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!216 = !DILocation(line: 98, column: 19, scope: !215)
!217 = !{i64 2147583806}
!218 = !DILocation(line: 98, column: 1, scope: !215)
!219 = distinct !DISubprogram(name: "ck_pr_stall", scope: !200, file: !200, line: 50, type: !212, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!220 = !DILocation(line: 53, column: 2, scope: !219)
!221 = !{i64 78844}
!222 = !DILocation(line: 54, column: 2, scope: !219)
!223 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !200, file: !200, line: 127, type: !224, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!224 = !DISubroutineType(types: !225)
!225 = !{!11, !226}
!226 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !227, size: 32)
!227 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!228 = !DILocalVariable(name: "target", arg: 1, scope: !223, file: !200, line: 127, type: !226)
!229 = !DILocation(line: 127, column: 1, scope: !223)
!230 = !DILocalVariable(name: "r", scope: !223, file: !200, line: 127, type: !231)
!231 = !DIBasicType(name: "long", size: 32, encoding: DW_ATE_signed)
!232 = !{i64 2147585940}
!233 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !211, file: !211, line: 123, type: !212, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!234 = !DILocation(line: 123, column: 1, scope: !233)
!235 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !200, file: !200, line: 176, type: !236, scopeLine: 176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!236 = !DISubroutineType(types: !237)
!237 = !{null, !203, !11}
!238 = !DILocalVariable(name: "target", arg: 1, scope: !235, file: !200, line: 176, type: !203)
!239 = !DILocation(line: 176, column: 1, scope: !235)
!240 = !DILocalVariable(name: "v", arg: 2, scope: !235, file: !200, line: 176, type: !11)
!241 = !{i64 2147589463}
!242 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !200, file: !200, line: 99, type: !212, scopeLine: 99, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!243 = !DILocation(line: 99, column: 21, scope: !242)
!244 = !{i64 2147584055}
!245 = !DILocation(line: 99, column: 1, scope: !242)
!246 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !247, file: !247, line: 37, type: !212, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!247 = !DIFile(filename: "../ck/include/gcc/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!248 = !DILocation(line: 40, column: 2, scope: !246)
!249 = !{i64 178319}
!250 = !DILocation(line: 41, column: 2, scope: !246)
