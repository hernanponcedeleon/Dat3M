; ModuleID = 'benchmarks/ck/caslock.c'
source_filename = "benchmarks/ck/caslock.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv8a-pc-linux-gnu"

%struct.ck_spinlock_cas = type { i32 }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !16
@lock = dso_local global %struct.ck_spinlock_cas zeroinitializer, align 4, !dbg !35
@.str = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !18
@.str.1 = private unnamed_addr constant [24 x i8] c"benchmarks/ck/caslock.c\00", align 1, !dbg !24
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
  %10 = call arm_aapcscc zeroext i1 @ck_spinlock_cas_trylock(ptr noundef @lock), !dbg !66
  %11 = zext i1 %10 to i8, !dbg !65
  store i8 %11, ptr %4, align 1, !dbg !65
  %12 = load i8, ptr %4, align 1, !dbg !67
  %13 = trunc i8 %12 to i1, !dbg !67
  %14 = zext i1 %13 to i32, !dbg !67
  call arm_aapcscc void @__VERIFIER_assume(i32 noundef %14), !dbg !68
  br label %16, !dbg !69

15:                                               ; preds = %1
  call arm_aapcscc void @ck_spinlock_cas_lock(ptr noundef @lock), !dbg !70
  br label %16

16:                                               ; preds = %15, %9
  %17 = load i32, ptr @x, align 4, !dbg !72
  %18 = add nsw i32 %17, 1, !dbg !72
  store i32 %18, ptr @x, align 4, !dbg !72
  %19 = load i32, ptr @y, align 4, !dbg !73
  %20 = add nsw i32 %19, 1, !dbg !73
  store i32 %20, ptr @y, align 4, !dbg !73
  call arm_aapcscc void @ck_spinlock_cas_unlock(ptr noundef @lock), !dbg !74
  ret ptr null, !dbg !75
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc zeroext i1 @ck_spinlock_cas_trylock(ptr noundef %0) #0 !dbg !76 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !80, !DIExpression(), !81)
    #dbg_declare(ptr %3, !82, !DIExpression(), !83)
  %4 = load ptr, ptr %2, align 4, !dbg !84
  %5 = getelementptr inbounds nuw %struct.ck_spinlock_cas, ptr %4, i32 0, i32 0, !dbg !85
  %6 = call arm_aapcscc i32 @ck_pr_fas_uint(ptr noundef %5, i32 noundef 1), !dbg !86
  store i32 %6, ptr %3, align 4, !dbg !87
  call arm_aapcscc void @ck_pr_fence_lock(), !dbg !88
  %7 = load i32, ptr %3, align 4, !dbg !89
  %8 = icmp ne i32 %7, 0, !dbg !90
  %9 = xor i1 %8, true, !dbg !90
  ret i1 %9, !dbg !91
}

declare arm_aapcscc void @__VERIFIER_assume(i32 noundef) #1

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_cas_lock(ptr noundef %0) #0 !dbg !92 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !95, !DIExpression(), !96)
  br label %3, !dbg !97

3:                                                ; preds = %16, %1
  %4 = load ptr, ptr %2, align 4, !dbg !98
  %5 = getelementptr inbounds nuw %struct.ck_spinlock_cas, ptr %4, i32 0, i32 0, !dbg !99
  %6 = call arm_aapcscc zeroext i1 @ck_pr_cas_uint(ptr noundef %5, i32 noundef 0, i32 noundef 1), !dbg !100
  %7 = zext i1 %6 to i32, !dbg !100
  %8 = icmp eq i32 %7, 0, !dbg !101
  br i1 %8, label %9, label %17, !dbg !97

9:                                                ; preds = %3
  br label %10, !dbg !102

10:                                               ; preds = %15, %9
  %11 = load ptr, ptr %2, align 4, !dbg !104
  %12 = getelementptr inbounds nuw %struct.ck_spinlock_cas, ptr %11, i32 0, i32 0, !dbg !105
  %13 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %12), !dbg !106
  %14 = icmp eq i32 %13, 1, !dbg !107
  br i1 %14, label %15, label %16, !dbg !102

15:                                               ; preds = %10
  call arm_aapcscc void @ck_pr_stall(), !dbg !108
  br label %10, !dbg !102, !llvm.loop !109

16:                                               ; preds = %10
  br label %3, !dbg !97, !llvm.loop !112

17:                                               ; preds = %3
  call arm_aapcscc void @ck_pr_fence_lock(), !dbg !114
  ret void, !dbg !115
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_cas_unlock(ptr noundef %0) #0 !dbg !116 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !117, !DIExpression(), !118)
  call arm_aapcscc void @ck_pr_fence_unlock(), !dbg !119
  %3 = load ptr, ptr %2, align 4, !dbg !120
  %4 = getelementptr inbounds nuw %struct.ck_spinlock_cas, ptr %3, i32 0, i32 0, !dbg !121
  call arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %4, i32 noundef 0), !dbg !122
  ret void, !dbg !123
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc i32 @main() #0 !dbg !124 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 4
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !127, !DIExpression(), !133)
    #dbg_declare(ptr %3, !134, !DIExpression(), !135)
  call arm_aapcscc void @ck_spinlock_cas_init(ptr noundef @lock), !dbg !136
  store i32 0, ptr %3, align 4, !dbg !137
  br label %4, !dbg !139

4:                                                ; preds = %16, %0
  %5 = load i32, ptr %3, align 4, !dbg !140
  %6 = icmp slt i32 %5, 3, !dbg !142
  br i1 %6, label %7, label %19, !dbg !143

7:                                                ; preds = %4
  %8 = load i32, ptr %3, align 4, !dbg !144
  %9 = getelementptr inbounds [3 x ptr], ptr %2, i32 0, i32 %8, !dbg !147
  %10 = load i32, ptr %3, align 4, !dbg !148
  %11 = inttoptr i32 %10 to ptr, !dbg !149
  %12 = call arm_aapcscc i32 @pthread_create(ptr noundef %9, ptr noundef null, ptr noundef @run, ptr noundef %11), !dbg !150
  %13 = icmp ne i32 %12, 0, !dbg !151
  br i1 %13, label %14, label %15, !dbg !151

14:                                               ; preds = %7
  call arm_aapcscc void @exit(i32 noundef 1) #3, !dbg !152
  unreachable, !dbg !152

15:                                               ; preds = %7
  br label %16, !dbg !154

16:                                               ; preds = %15
  %17 = load i32, ptr %3, align 4, !dbg !155
  %18 = add nsw i32 %17, 1, !dbg !155
  store i32 %18, ptr %3, align 4, !dbg !155
  br label %4, !dbg !156, !llvm.loop !157

19:                                               ; preds = %4
  store i32 0, ptr %3, align 4, !dbg !159
  br label %20, !dbg !161

20:                                               ; preds = %31, %19
  %21 = load i32, ptr %3, align 4, !dbg !162
  %22 = icmp slt i32 %21, 3, !dbg !164
  br i1 %22, label %23, label %34, !dbg !165

23:                                               ; preds = %20
  %24 = load i32, ptr %3, align 4, !dbg !166
  %25 = getelementptr inbounds [3 x ptr], ptr %2, i32 0, i32 %24, !dbg !169
  %26 = load ptr, ptr %25, align 4, !dbg !169
  %27 = call arm_aapcscc i32 @pthread_join(ptr noundef %26, ptr noundef null), !dbg !170
  %28 = icmp ne i32 %27, 0, !dbg !171
  br i1 %28, label %29, label %30, !dbg !171

29:                                               ; preds = %23
  call arm_aapcscc void @exit(i32 noundef 1) #3, !dbg !172
  unreachable, !dbg !172

30:                                               ; preds = %23
  br label %31, !dbg !174

31:                                               ; preds = %30
  %32 = load i32, ptr %3, align 4, !dbg !175
  %33 = add nsw i32 %32, 1, !dbg !175
  store i32 %33, ptr %3, align 4, !dbg !175
  br label %20, !dbg !176, !llvm.loop !177

34:                                               ; preds = %20
  %35 = load i32, ptr @x, align 4, !dbg !179
  %36 = icmp eq i32 %35, 3, !dbg !182
  br i1 %36, label %37, label %40, !dbg !183

37:                                               ; preds = %34
  %38 = load i32, ptr @y, align 4, !dbg !184
  %39 = icmp eq i32 %38, 3, !dbg !185
  br i1 %39, label %41, label %40, !dbg !186

40:                                               ; preds = %37, %34
  call arm_aapcscc void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 59, ptr noundef @__func__.main), !dbg !186
  br label %41, !dbg !186

41:                                               ; preds = %40, %37
  ret i32 0, !dbg !187
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_cas_init(ptr noundef %0) #0 !dbg !188 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !189, !DIExpression(), !190)
  %3 = load ptr, ptr %2, align 4, !dbg !191
  %4 = getelementptr inbounds nuw %struct.ck_spinlock_cas, ptr %3, i32 0, i32 0, !dbg !192
  store i32 0, ptr %4, align 4, !dbg !193
  call arm_aapcscc void @ck_pr_barrier(), !dbg !194
  ret void, !dbg !195
}

declare arm_aapcscc i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noreturn
declare arm_aapcscc void @exit(i32 noundef) #2

declare arm_aapcscc i32 @pthread_join(ptr noundef, ptr noundef) #1

declare arm_aapcscc void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc i32 @ck_pr_fas_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !196 {
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !201, !DIExpression(), !202)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !203, !DIExpression(), !202)
    #dbg_declare(ptr %5, !204, !DIExpression(), !202)
  store i32 0, ptr %5, align 4, !dbg !202
    #dbg_declare(ptr %6, !205, !DIExpression(), !202)
  store i32 0, ptr %6, align 4, !dbg !202
  %7 = load i32, ptr %5, align 4, !dbg !202
  %8 = load i32, ptr %6, align 4, !dbg !202
  %9 = load ptr, ptr %3, align 4, !dbg !202
  %10 = load i32, ptr %4, align 4, !dbg !202
  %11 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];strex $1, $3, [$2];cmp $1, #0;bne 1b;", "=&r,=&r,r,r,0,1,~{memory},~{cc}"(ptr %9, i32 %10, i32 %7, i32 %8) #4, !dbg !202, !srcloc !206
  %12 = extractvalue { i32, i32 } %11, 0, !dbg !202
  %13 = extractvalue { i32, i32 } %11, 1, !dbg !202
  store i32 %12, ptr %5, align 4, !dbg !202
  store i32 %13, ptr %6, align 4, !dbg !202
  %14 = load i32, ptr %5, align 4, !dbg !202
  ret i32 %14, !dbg !202
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_lock() #0 !dbg !207 {
  call arm_aapcscc void @ck_pr_fence_strict_lock(), !dbg !211
  ret void, !dbg !211
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_lock() #0 !dbg !212 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #4, !dbg !213, !srcloc !214
  ret void, !dbg !215
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc zeroext i1 @ck_pr_cas_uint(ptr noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !216 {
  %4 = alloca ptr, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 4
    #dbg_declare(ptr %4, !219, !DIExpression(), !220)
  store i32 %1, ptr %5, align 4
    #dbg_declare(ptr %5, !221, !DIExpression(), !220)
  store i32 %2, ptr %6, align 4
    #dbg_declare(ptr %6, !222, !DIExpression(), !220)
    #dbg_declare(ptr %7, !223, !DIExpression(), !220)
  store i32 0, ptr %7, align 4, !dbg !220
    #dbg_declare(ptr %8, !224, !DIExpression(), !220)
  store i32 0, ptr %8, align 4, !dbg !220
  %9 = load i32, ptr %7, align 4, !dbg !220
  %10 = load i32, ptr %8, align 4, !dbg !220
  %11 = load ptr, ptr %4, align 4, !dbg !220
  %12 = load i32, ptr %6, align 4, !dbg !220
  %13 = load i32, ptr %5, align 4, !dbg !220
  %14 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];cmp   $0, $4;itt eq;strexeq $1, $3, [$2];cmpeq   $1, #1;beq   1b;", "=&r,=&r,r,r,r,0,1,~{memory},~{cc}"(ptr %11, i32 %12, i32 %13, i32 %9, i32 %10) #4, !dbg !220, !srcloc !225
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !220
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !220
  store i32 %15, ptr %7, align 4, !dbg !220
  store i32 %16, ptr %8, align 4, !dbg !220
  %17 = load i32, ptr %7, align 4, !dbg !220
  %18 = load i32, ptr %5, align 4, !dbg !220
  %19 = icmp eq i32 %17, %18, !dbg !220
  ret i1 %19, !dbg !220
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !226 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !231, !DIExpression(), !232)
    #dbg_declare(ptr %3, !233, !DIExpression(), !232)
  store i32 0, ptr %3, align 4, !dbg !232
  %4 = load ptr, ptr %2, align 4, !dbg !232
  %5 = call i32 asm sideeffect "ldr $0, [$1];", "=r,r,~{memory}"(ptr %4) #4, !dbg !232, !srcloc !235
  store i32 %5, ptr %3, align 4, !dbg !232
  %6 = load i32, ptr %3, align 4, !dbg !232
  ret i32 %6, !dbg !232
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_stall() #0 !dbg !236 {
  call void asm sideeffect "", "~{memory}"() #4, !dbg !237, !srcloc !238
  ret void, !dbg !239
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_unlock() #0 !dbg !240 {
  call arm_aapcscc void @ck_pr_fence_strict_unlock(), !dbg !241
  ret void, !dbg !241
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !242 {
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !245, !DIExpression(), !246)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !247, !DIExpression(), !246)
  %5 = load ptr, ptr %3, align 4, !dbg !246
  %6 = load i32, ptr %4, align 4, !dbg !246
  call void asm sideeffect "str $1, [$0]", "r,r,~{memory}"(ptr %5, i32 %6) #4, !dbg !246, !srcloc !248
  ret void, !dbg !246
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_unlock() #0 !dbg !249 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #4, !dbg !250, !srcloc !251
  ret void, !dbg !252
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_barrier() #0 !dbg !253 {
  call void asm sideeffect "", "~{memory}"() #4, !dbg !255, !srcloc !256
  ret void, !dbg !257
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #3 = { noreturn }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!42, !43, !44, !45, !46, !47, !48}
!llvm.ident = !{!49}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 15, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !15, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/caslock.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "eaf093b9cc44413a628cfc72d3a4aa19")
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
!17 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 15, type: !7, isLocal: false, isDefinition: true)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !3, line: 59, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 248, elements: !22)
!21 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!22 = !{!23}
!23 = !DISubrange(count: 31)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(scope: null, file: !3, line: 59, type: !26, isLocal: true, isDefinition: true)
!26 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 192, elements: !27)
!27 = !{!28}
!28 = !DISubrange(count: 24)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 59, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 40, elements: !33)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !21)
!33 = !{!34}
!34 = !DISubrange(count: 5)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 14, type: !37, isLocal: false, isDefinition: true)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_cas_t", file: !38, line: 44, baseType: !39)
!38 = !DIFile(filename: "../ck/include/spinlock/cas.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "ce076f374c67b364c8434ea638760107")
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_cas", file: !38, line: 41, size: 32, elements: !40)
!40 = !{!41}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !39, file: !38, line: 42, baseType: !11, size: 32)
!42 = !{i32 7, !"Dwarf Version", i32 5}
!43 = !{i32 2, !"Debug Info Version", i32 3}
!44 = !{i32 1, !"wchar_size", i32 4}
!45 = !{i32 1, !"min_enum_size", i32 4}
!46 = !{i32 8, !"PIC Level", i32 2}
!47 = !{i32 7, !"PIE Level", i32 2}
!48 = !{i32 7, !"frame-pointer", i32 2}
!49 = !{!"Homebrew clang version 22.1.8"}
!50 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 17, type: !51, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!51 = !DISubroutineType(types: !52)
!52 = !{!8, !8}
!53 = !{}
!54 = !DILocalVariable(name: "arg", arg: 1, scope: !50, file: !3, line: 17, type: !8)
!55 = !DILocation(line: 17, column: 17, scope: !50)
!56 = !DILocalVariable(name: "tid", scope: !50, file: !3, line: 20, type: !5)
!57 = !DILocation(line: 20, column: 14, scope: !50)
!58 = !DILocation(line: 20, column: 32, scope: !50)
!59 = !DILocation(line: 20, column: 21, scope: !50)
!60 = !DILocation(line: 24, column: 9, scope: !61)
!61 = distinct !DILexicalBlock(scope: !50, file: !3, line: 24, column: 9)
!62 = !DILocation(line: 24, column: 13, scope: !61)
!63 = !DILocalVariable(name: "acquired", scope: !64, file: !3, line: 26, type: !12)
!64 = distinct !DILexicalBlock(scope: !61, file: !3, line: 25, column: 5)
!65 = !DILocation(line: 26, column: 14, scope: !64)
!66 = !DILocation(line: 26, column: 25, scope: !64)
!67 = !DILocation(line: 27, column: 27, scope: !64)
!68 = !DILocation(line: 27, column: 9, scope: !64)
!69 = !DILocation(line: 28, column: 5, scope: !64)
!70 = !DILocation(line: 31, column: 9, scope: !71)
!71 = distinct !DILexicalBlock(scope: !61, file: !3, line: 30, column: 5)
!72 = !DILocation(line: 34, column: 6, scope: !50)
!73 = !DILocation(line: 35, column: 6, scope: !50)
!74 = !DILocation(line: 36, column: 5, scope: !50)
!75 = !DILocation(line: 37, column: 5, scope: !50)
!76 = distinct !DISubprogram(name: "ck_spinlock_cas_trylock", scope: !38, file: !38, line: 58, type: !77, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!77 = !DISubroutineType(types: !78)
!78 = !{!12, !79}
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 32)
!80 = !DILocalVariable(name: "lock", arg: 1, scope: !76, file: !38, line: 58, type: !79)
!81 = !DILocation(line: 58, column: 49, scope: !76)
!82 = !DILocalVariable(name: "value", scope: !76, file: !38, line: 60, type: !11)
!83 = !DILocation(line: 60, column: 15, scope: !76)
!84 = !DILocation(line: 62, column: 26, scope: !76)
!85 = !DILocation(line: 62, column: 32, scope: !76)
!86 = !DILocation(line: 62, column: 10, scope: !76)
!87 = !DILocation(line: 62, column: 8, scope: !76)
!88 = !DILocation(line: 63, column: 2, scope: !76)
!89 = !DILocation(line: 64, column: 10, scope: !76)
!90 = !DILocation(line: 64, column: 9, scope: !76)
!91 = !DILocation(line: 64, column: 2, scope: !76)
!92 = distinct !DISubprogram(name: "ck_spinlock_cas_lock", scope: !38, file: !38, line: 77, type: !93, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!93 = !DISubroutineType(types: !94)
!94 = !{null, !79}
!95 = !DILocalVariable(name: "lock", arg: 1, scope: !92, file: !38, line: 77, type: !79)
!96 = !DILocation(line: 77, column: 46, scope: !92)
!97 = !DILocation(line: 80, column: 2, scope: !92)
!98 = !DILocation(line: 80, column: 25, scope: !92)
!99 = !DILocation(line: 80, column: 31, scope: !92)
!100 = !DILocation(line: 80, column: 9, scope: !92)
!101 = !DILocation(line: 80, column: 51, scope: !92)
!102 = !DILocation(line: 81, column: 3, scope: !103)
!103 = distinct !DILexicalBlock(scope: !92, file: !38, line: 80, column: 61)
!104 = !DILocation(line: 81, column: 27, scope: !103)
!105 = !DILocation(line: 81, column: 33, scope: !103)
!106 = !DILocation(line: 81, column: 10, scope: !103)
!107 = !DILocation(line: 81, column: 40, scope: !103)
!108 = !DILocation(line: 82, column: 4, scope: !103)
!109 = distinct !{!109, !102, !110, !111}
!110 = !DILocation(line: 82, column: 16, scope: !103)
!111 = !{!"llvm.loop.mustprogress"}
!112 = distinct !{!112, !97, !113, !111}
!113 = !DILocation(line: 83, column: 2, scope: !92)
!114 = !DILocation(line: 85, column: 2, scope: !92)
!115 = !DILocation(line: 86, column: 2, scope: !92)
!116 = distinct !DISubprogram(name: "ck_spinlock_cas_unlock", scope: !38, file: !38, line: 102, type: !93, scopeLine: 103, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!117 = !DILocalVariable(name: "lock", arg: 1, scope: !116, file: !38, line: 102, type: !79)
!118 = !DILocation(line: 102, column: 48, scope: !116)
!119 = !DILocation(line: 106, column: 2, scope: !116)
!120 = !DILocation(line: 107, column: 20, scope: !116)
!121 = !DILocation(line: 107, column: 26, scope: !116)
!122 = !DILocation(line: 107, column: 2, scope: !116)
!123 = !DILocation(line: 108, column: 2, scope: !116)
!124 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 40, type: !125, scopeLine: 41, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!125 = !DISubroutineType(types: !126)
!126 = !{!7}
!127 = !DILocalVariable(name: "threads", scope: !124, file: !3, line: 42, type: !128)
!128 = !DICompositeType(tag: DW_TAG_array_type, baseType: !129, size: 96, elements: !131)
!129 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !130, line: 2, baseType: !8)
!130 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!131 = !{!132}
!132 = !DISubrange(count: 3)
!133 = !DILocation(line: 42, column: 15, scope: !124)
!134 = !DILocalVariable(name: "i", scope: !124, file: !3, line: 43, type: !7)
!135 = !DILocation(line: 43, column: 9, scope: !124)
!136 = !DILocation(line: 44, column: 5, scope: !124)
!137 = !DILocation(line: 45, column: 12, scope: !138)
!138 = distinct !DILexicalBlock(scope: !124, file: !3, line: 45, column: 5)
!139 = !DILocation(line: 45, column: 10, scope: !138)
!140 = !DILocation(line: 45, column: 17, scope: !141)
!141 = distinct !DILexicalBlock(scope: !138, file: !3, line: 45, column: 5)
!142 = !DILocation(line: 45, column: 19, scope: !141)
!143 = !DILocation(line: 45, column: 5, scope: !138)
!144 = !DILocation(line: 47, column: 37, scope: !145)
!145 = distinct !DILexicalBlock(scope: !146, file: !3, line: 47, column: 13)
!146 = distinct !DILexicalBlock(scope: !141, file: !3, line: 46, column: 5)
!147 = !DILocation(line: 47, column: 29, scope: !145)
!148 = !DILocation(line: 47, column: 69, scope: !145)
!149 = !DILocation(line: 47, column: 52, scope: !145)
!150 = !DILocation(line: 47, column: 13, scope: !145)
!151 = !DILocation(line: 47, column: 72, scope: !145)
!152 = !DILocation(line: 49, column: 13, scope: !153)
!153 = distinct !DILexicalBlock(scope: !145, file: !3, line: 48, column: 9)
!154 = !DILocation(line: 51, column: 5, scope: !146)
!155 = !DILocation(line: 45, column: 32, scope: !141)
!156 = !DILocation(line: 45, column: 5, scope: !141)
!157 = distinct !{!157, !143, !158, !111}
!158 = !DILocation(line: 51, column: 5, scope: !138)
!159 = !DILocation(line: 52, column: 12, scope: !160)
!160 = distinct !DILexicalBlock(scope: !124, file: !3, line: 52, column: 5)
!161 = !DILocation(line: 52, column: 10, scope: !160)
!162 = !DILocation(line: 52, column: 17, scope: !163)
!163 = distinct !DILexicalBlock(scope: !160, file: !3, line: 52, column: 5)
!164 = !DILocation(line: 52, column: 19, scope: !163)
!165 = !DILocation(line: 52, column: 5, scope: !160)
!166 = !DILocation(line: 54, column: 34, scope: !167)
!167 = distinct !DILexicalBlock(scope: !168, file: !3, line: 54, column: 13)
!168 = distinct !DILexicalBlock(scope: !163, file: !3, line: 53, column: 5)
!169 = !DILocation(line: 54, column: 26, scope: !167)
!170 = !DILocation(line: 54, column: 13, scope: !167)
!171 = !DILocation(line: 54, column: 44, scope: !167)
!172 = !DILocation(line: 56, column: 13, scope: !173)
!173 = distinct !DILexicalBlock(scope: !167, file: !3, line: 55, column: 9)
!174 = !DILocation(line: 58, column: 5, scope: !168)
!175 = !DILocation(line: 52, column: 32, scope: !163)
!176 = !DILocation(line: 52, column: 5, scope: !163)
!177 = distinct !{!177, !165, !178, !111}
!178 = !DILocation(line: 58, column: 5, scope: !160)
!179 = !DILocation(line: 59, column: 12, scope: !180)
!180 = distinct !DILexicalBlock(scope: !181, file: !3, line: 59, column: 5)
!181 = distinct !DILexicalBlock(scope: !124, file: !3, line: 59, column: 5)
!182 = !DILocation(line: 59, column: 14, scope: !180)
!183 = !DILocation(line: 59, column: 26, scope: !180)
!184 = !DILocation(line: 59, column: 29, scope: !180)
!185 = !DILocation(line: 59, column: 31, scope: !180)
!186 = !DILocation(line: 59, column: 5, scope: !180)
!187 = !DILocation(line: 60, column: 5, scope: !124)
!188 = distinct !DISubprogram(name: "ck_spinlock_cas_init", scope: !38, file: !38, line: 49, type: !93, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!189 = !DILocalVariable(name: "lock", arg: 1, scope: !188, file: !38, line: 49, type: !79)
!190 = !DILocation(line: 49, column: 46, scope: !188)
!191 = !DILocation(line: 52, column: 2, scope: !188)
!192 = !DILocation(line: 52, column: 8, scope: !188)
!193 = !DILocation(line: 52, column: 14, scope: !188)
!194 = !DILocation(line: 53, column: 2, scope: !188)
!195 = !DILocation(line: 54, column: 2, scope: !188)
!196 = distinct !DISubprogram(name: "ck_pr_fas_uint", scope: !197, file: !197, line: 417, type: !198, scopeLine: 417, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!197 = !DIFile(filename: "../ck/include/gcc/arm/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "f3f9fb174933d4f9d5af6678feea8d14")
!198 = !DISubroutineType(types: !199)
!199 = !{!11, !200, !11}
!200 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 32)
!201 = !DILocalVariable(name: "target", arg: 1, scope: !196, file: !197, line: 417, type: !200)
!202 = !DILocation(line: 417, column: 1, scope: !196)
!203 = !DILocalVariable(name: "v", arg: 2, scope: !196, file: !197, line: 417, type: !11)
!204 = !DILocalVariable(name: "previous", scope: !196, file: !197, line: 417, type: !11)
!205 = !DILocalVariable(name: "tmp", scope: !196, file: !197, line: 417, type: !11)
!206 = !{i64 2147602817}
!207 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !208, file: !208, line: 122, type: !209, scopeLine: 122, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!208 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!209 = !DISubroutineType(types: !210)
!210 = !{null}
!211 = !DILocation(line: 122, column: 1, scope: !207)
!212 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !197, file: !197, line: 98, type: !209, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!213 = !DILocation(line: 98, column: 19, scope: !212)
!214 = !{i64 2147584788}
!215 = !DILocation(line: 98, column: 1, scope: !212)
!216 = distinct !DISubprogram(name: "ck_pr_cas_uint", scope: !197, file: !197, line: 385, type: !217, scopeLine: 385, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!217 = !DISubroutineType(types: !218)
!218 = !{!12, !200, !11, !11}
!219 = !DILocalVariable(name: "target", arg: 1, scope: !216, file: !197, line: 385, type: !200)
!220 = !DILocation(line: 385, column: 1, scope: !216)
!221 = !DILocalVariable(name: "compare", arg: 2, scope: !216, file: !197, line: 385, type: !11)
!222 = !DILocalVariable(name: "set", arg: 3, scope: !216, file: !197, line: 385, type: !11)
!223 = !DILocalVariable(name: "previous", scope: !216, file: !197, line: 385, type: !11)
!224 = !DILocalVariable(name: "tmp", scope: !216, file: !197, line: 385, type: !11)
!225 = !{i64 2147593330}
!226 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !197, file: !197, line: 127, type: !227, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!227 = !DISubroutineType(types: !228)
!228 = !{!11, !229}
!229 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !230, size: 32)
!230 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!231 = !DILocalVariable(name: "target", arg: 1, scope: !226, file: !197, line: 127, type: !229)
!232 = !DILocation(line: 127, column: 1, scope: !226)
!233 = !DILocalVariable(name: "r", scope: !226, file: !197, line: 127, type: !234)
!234 = !DIBasicType(name: "long", size: 32, encoding: DW_ATE_signed)
!235 = !{i64 2147586991}
!236 = distinct !DISubprogram(name: "ck_pr_stall", scope: !197, file: !197, line: 50, type: !209, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!237 = !DILocation(line: 53, column: 2, scope: !236)
!238 = !{i64 79200}
!239 = !DILocation(line: 54, column: 2, scope: !236)
!240 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !208, file: !208, line: 123, type: !209, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!241 = !DILocation(line: 123, column: 1, scope: !240)
!242 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !197, file: !197, line: 176, type: !243, scopeLine: 176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !53)
!243 = !DISubroutineType(types: !244)
!244 = !{null, !200, !11}
!245 = !DILocalVariable(name: "target", arg: 1, scope: !242, file: !197, line: 176, type: !200)
!246 = !DILocation(line: 176, column: 1, scope: !242)
!247 = !DILocalVariable(name: "v", arg: 2, scope: !242, file: !197, line: 176, type: !11)
!248 = !{i64 2147589860}
!249 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !197, file: !197, line: 99, type: !209, scopeLine: 99, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!250 = !DILocation(line: 99, column: 21, scope: !249)
!251 = !{i64 2147585083}
!252 = !DILocation(line: 99, column: 1, scope: !249)
!253 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !254, file: !254, line: 37, type: !209, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!254 = !DIFile(filename: "../ck/include/gcc/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!255 = !DILocation(line: 40, column: 2, scope: !253)
!256 = !{i64 174936}
!257 = !DILocation(line: 41, column: 2, scope: !253)
