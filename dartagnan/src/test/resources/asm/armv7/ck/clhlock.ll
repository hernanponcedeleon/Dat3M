; ModuleID = 'benchmarks/ck/clhlock.c'
source_filename = "benchmarks/ck/clhlock.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv7-pc-linux-gnu"

%struct.ck_spinlock_clh = type { i32, ptr }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !24
@nodes = dso_local global ptr null, align 4, !dbg !45
@lock = dso_local global ptr null, align 4, !dbg !43
@.str = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !26
@.str.1 = private unnamed_addr constant [24 x i8] c"benchmarks/ck/clhlock.c\00", align 1, !dbg !32
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !37

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc ptr @run(ptr noundef %0) #0 !dbg !55 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !59, !DIExpression(), !60)
    #dbg_declare(ptr %3, !61, !DIExpression(), !62)
  %5 = load ptr, ptr %2, align 4, !dbg !63
  %6 = ptrtoint ptr %5 to i32, !dbg !64
  store i32 %6, ptr %3, align 4, !dbg !62
    #dbg_declare(ptr %4, !65, !DIExpression(), !66)
  %7 = load ptr, ptr @nodes, align 4, !dbg !67
  %8 = load i32, ptr %3, align 4, !dbg !68
  %9 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %7, i32 %8, !dbg !67
  store ptr %9, ptr %4, align 4, !dbg !66
  %10 = load ptr, ptr %4, align 4, !dbg !69
  call arm_aapcscc void @ck_spinlock_clh_lock(ptr noundef @lock, ptr noundef %10), !dbg !70
  %11 = load i32, ptr @x, align 4, !dbg !71
  %12 = add nsw i32 %11, 1, !dbg !71
  store i32 %12, ptr @x, align 4, !dbg !71
  %13 = load i32, ptr @y, align 4, !dbg !72
  %14 = add nsw i32 %13, 1, !dbg !72
  store i32 %14, ptr @y, align 4, !dbg !72
  call arm_aapcscc void @ck_spinlock_clh_unlock(ptr noundef %4), !dbg !73
  ret ptr null, !dbg !74
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_clh_lock(ptr noundef %0, ptr noundef %1) #0 !dbg !75 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !79, !DIExpression(), !80)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !81, !DIExpression(), !82)
    #dbg_declare(ptr %5, !83, !DIExpression(), !84)
  %6 = load ptr, ptr %4, align 4, !dbg !85
  %7 = getelementptr inbounds nuw %struct.ck_spinlock_clh, ptr %6, i32 0, i32 0, !dbg !86
  store i32 1, ptr %7, align 4, !dbg !87
  call arm_aapcscc void @ck_pr_fence_store_atomic(), !dbg !88
  %8 = load ptr, ptr %3, align 4, !dbg !89
  %9 = load ptr, ptr %4, align 4, !dbg !90
  %10 = call arm_aapcscc ptr @ck_pr_fas_ptr(ptr noundef %8, ptr noundef %9), !dbg !91
  store ptr %10, ptr %5, align 4, !dbg !92
  %11 = load ptr, ptr %5, align 4, !dbg !93
  %12 = load ptr, ptr %4, align 4, !dbg !94
  %13 = getelementptr inbounds nuw %struct.ck_spinlock_clh, ptr %12, i32 0, i32 1, !dbg !95
  store ptr %11, ptr %13, align 4, !dbg !96
  call arm_aapcscc void @ck_pr_fence_load(), !dbg !97
  br label %14, !dbg !98

14:                                               ; preds = %19, %2
  %15 = load ptr, ptr %5, align 4, !dbg !99
  %16 = getelementptr inbounds nuw %struct.ck_spinlock_clh, ptr %15, i32 0, i32 0, !dbg !100
  %17 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %16), !dbg !101
  %18 = icmp eq i32 %17, 1, !dbg !102
  br i1 %18, label %19, label %20, !dbg !98

19:                                               ; preds = %14
  call arm_aapcscc void @ck_pr_stall(), !dbg !103
  br label %14, !dbg !98, !llvm.loop !104

20:                                               ; preds = %14
  call arm_aapcscc void @ck_pr_fence_lock(), !dbg !107
  ret void, !dbg !108
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_clh_unlock(ptr noundef %0) #0 !dbg !109 {
  %2 = alloca ptr, align 4
  %3 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !112, !DIExpression(), !113)
    #dbg_declare(ptr %3, !114, !DIExpression(), !115)
  %4 = load ptr, ptr %2, align 4, !dbg !116
  %5 = getelementptr inbounds ptr, ptr %4, i32 0, !dbg !116
  %6 = load ptr, ptr %5, align 4, !dbg !116
  %7 = getelementptr inbounds nuw %struct.ck_spinlock_clh, ptr %6, i32 0, i32 1, !dbg !117
  %8 = load ptr, ptr %7, align 4, !dbg !117
  store ptr %8, ptr %3, align 4, !dbg !118
  call arm_aapcscc void @ck_pr_fence_unlock(), !dbg !119
  %9 = load ptr, ptr %2, align 4, !dbg !120
  %10 = load ptr, ptr %9, align 4, !dbg !121
  %11 = getelementptr inbounds nuw %struct.ck_spinlock_clh, ptr %10, i32 0, i32 0, !dbg !122
  call arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %11, i32 noundef 0), !dbg !123
  %12 = load ptr, ptr %3, align 4, !dbg !124
  %13 = load ptr, ptr %2, align 4, !dbg !125
  store ptr %12, ptr %13, align 4, !dbg !126
  ret void, !dbg !127
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc i32 @main() #0 !dbg !128 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 4
  %3 = alloca i32, align 4
  %4 = alloca %struct.ck_spinlock_clh, align 4
  %5 = alloca ptr, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !131, !DIExpression(), !137)
    #dbg_declare(ptr %3, !138, !DIExpression(), !139)
    #dbg_declare(ptr %4, !140, !DIExpression(), !141)
  call arm_aapcscc void @ck_spinlock_clh_init(ptr noundef @lock, ptr noundef %4), !dbg !142
  %6 = call arm_aapcscc ptr @malloc(i32 noundef 24) #4, !dbg !143
  store ptr %6, ptr @nodes, align 4, !dbg !144
  store i32 0, ptr %3, align 4, !dbg !145
  br label %7, !dbg !147

7:                                                ; preds = %14, %0
  %8 = load i32, ptr %3, align 4, !dbg !148
  %9 = icmp slt i32 %8, 3, !dbg !150
  br i1 %9, label %10, label %17, !dbg !151

10:                                               ; preds = %7
    #dbg_declare(ptr %5, !152, !DIExpression(), !154)
  %11 = load ptr, ptr @nodes, align 4, !dbg !155
  %12 = load i32, ptr %3, align 4, !dbg !156
  %13 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %11, i32 %12, !dbg !155
  call arm_aapcscc void @ck_spinlock_clh_init(ptr noundef %5, ptr noundef %13), !dbg !157
  br label %14, !dbg !158

14:                                               ; preds = %10
  %15 = load i32, ptr %3, align 4, !dbg !159
  %16 = add nsw i32 %15, 1, !dbg !159
  store i32 %16, ptr %3, align 4, !dbg !159
  br label %7, !dbg !160, !llvm.loop !161

17:                                               ; preds = %7
  store i32 0, ptr %3, align 4, !dbg !163
  br label %18, !dbg !165

18:                                               ; preds = %30, %17
  %19 = load i32, ptr %3, align 4, !dbg !166
  %20 = icmp slt i32 %19, 3, !dbg !168
  br i1 %20, label %21, label %33, !dbg !169

21:                                               ; preds = %18
  %22 = load i32, ptr %3, align 4, !dbg !170
  %23 = getelementptr inbounds [3 x ptr], ptr %2, i32 0, i32 %22, !dbg !173
  %24 = load i32, ptr %3, align 4, !dbg !174
  %25 = inttoptr i32 %24 to ptr, !dbg !175
  %26 = call arm_aapcscc i32 @pthread_create(ptr noundef %23, ptr noundef null, ptr noundef @run, ptr noundef %25), !dbg !176
  %27 = icmp ne i32 %26, 0, !dbg !177
  br i1 %27, label %28, label %29, !dbg !177

28:                                               ; preds = %21
  call arm_aapcscc void @exit(i32 noundef 1) #5, !dbg !178
  unreachable, !dbg !178

29:                                               ; preds = %21
  br label %30, !dbg !180

30:                                               ; preds = %29
  %31 = load i32, ptr %3, align 4, !dbg !181
  %32 = add nsw i32 %31, 1, !dbg !181
  store i32 %32, ptr %3, align 4, !dbg !181
  br label %18, !dbg !182, !llvm.loop !183

33:                                               ; preds = %18
  store i32 0, ptr %3, align 4, !dbg !185
  br label %34, !dbg !187

34:                                               ; preds = %45, %33
  %35 = load i32, ptr %3, align 4, !dbg !188
  %36 = icmp slt i32 %35, 3, !dbg !190
  br i1 %36, label %37, label %48, !dbg !191

37:                                               ; preds = %34
  %38 = load i32, ptr %3, align 4, !dbg !192
  %39 = getelementptr inbounds [3 x ptr], ptr %2, i32 0, i32 %38, !dbg !195
  %40 = load ptr, ptr %39, align 4, !dbg !195
  %41 = call arm_aapcscc i32 @pthread_join(ptr noundef %40, ptr noundef null), !dbg !196
  %42 = icmp ne i32 %41, 0, !dbg !197
  br i1 %42, label %43, label %44, !dbg !197

43:                                               ; preds = %37
  call arm_aapcscc void @exit(i32 noundef 1) #5, !dbg !198
  unreachable, !dbg !198

44:                                               ; preds = %37
  br label %45, !dbg !200

45:                                               ; preds = %44
  %46 = load i32, ptr %3, align 4, !dbg !201
  %47 = add nsw i32 %46, 1, !dbg !201
  store i32 %47, ptr %3, align 4, !dbg !201
  br label %34, !dbg !202, !llvm.loop !203

48:                                               ; preds = %34
  %49 = load i32, ptr @x, align 4, !dbg !205
  %50 = icmp eq i32 %49, 3, !dbg !208
  br i1 %50, label %51, label %54, !dbg !209

51:                                               ; preds = %48
  %52 = load i32, ptr @y, align 4, !dbg !210
  %53 = icmp eq i32 %52, 3, !dbg !211
  br i1 %53, label %55, label %54, !dbg !212

54:                                               ; preds = %51, %48
  call arm_aapcscc void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 61, ptr noundef @__func__.main), !dbg !212
  br label %55, !dbg !212

55:                                               ; preds = %54, %51
  %56 = load ptr, ptr @nodes, align 4, !dbg !213
  call arm_aapcscc void @free(ptr noundef %56), !dbg !214
  ret i32 0, !dbg !215
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_clh_init(ptr noundef %0, ptr noundef %1) #0 !dbg !216 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !217, !DIExpression(), !218)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !219, !DIExpression(), !220)
  %5 = load ptr, ptr %4, align 4, !dbg !221
  %6 = getelementptr inbounds nuw %struct.ck_spinlock_clh, ptr %5, i32 0, i32 1, !dbg !222
  store ptr null, ptr %6, align 4, !dbg !223
  %7 = load ptr, ptr %4, align 4, !dbg !224
  %8 = getelementptr inbounds nuw %struct.ck_spinlock_clh, ptr %7, i32 0, i32 0, !dbg !225
  store i32 0, ptr %8, align 4, !dbg !226
  %9 = load ptr, ptr %4, align 4, !dbg !227
  %10 = load ptr, ptr %3, align 4, !dbg !228
  store ptr %9, ptr %10, align 4, !dbg !229
  call arm_aapcscc void @ck_pr_barrier(), !dbg !230
  ret void, !dbg !231
}

; Function Attrs: allocsize(0)
declare arm_aapcscc ptr @malloc(i32 noundef) #1

declare arm_aapcscc i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noreturn
declare arm_aapcscc void @exit(i32 noundef) #3

declare arm_aapcscc i32 @pthread_join(ptr noundef, ptr noundef) #2

declare arm_aapcscc void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

declare arm_aapcscc void @free(ptr noundef) #2

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_store_atomic() #0 !dbg !232 {
  call arm_aapcscc void @ck_pr_fence_strict_store_atomic(), !dbg !236
  ret void, !dbg !236
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc ptr @ck_pr_fas_ptr(ptr noundef %0, ptr noundef %1) #0 !dbg !237 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  %6 = alloca ptr, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !241, !DIExpression(), !242)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !243, !DIExpression(), !242)
    #dbg_declare(ptr %5, !244, !DIExpression(), !242)
  store ptr null, ptr %5, align 4, !dbg !242
    #dbg_declare(ptr %6, !245, !DIExpression(), !242)
  store ptr null, ptr %6, align 4, !dbg !242
  %7 = load ptr, ptr %5, align 4, !dbg !242
  %8 = load ptr, ptr %6, align 4, !dbg !242
  %9 = load ptr, ptr %3, align 4, !dbg !242
  %10 = load ptr, ptr %4, align 4, !dbg !242
  %11 = call { ptr, ptr } asm sideeffect "1:ldrex $0, [$2];strex $1, $3, [$2];cmp $1, #0;bne 1b;", "=&r,=&r,r,r,0,1,~{memory},~{cc}"(ptr %9, ptr %10, ptr %7, ptr %8) #6, !dbg !242, !srcloc !246
  %12 = extractvalue { ptr, ptr } %11, 0, !dbg !242
  %13 = extractvalue { ptr, ptr } %11, 1, !dbg !242
  store ptr %12, ptr %5, align 4, !dbg !242
  store ptr %13, ptr %6, align 4, !dbg !242
  %14 = load ptr, ptr %5, align 4, !dbg !242
  ret ptr %14, !dbg !242
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_load() #0 !dbg !247 {
  call arm_aapcscc void @ck_pr_fence_strict_load(), !dbg !248
  ret void, !dbg !248
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !249 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !254, !DIExpression(), !255)
    #dbg_declare(ptr %3, !256, !DIExpression(), !255)
  store i32 0, ptr %3, align 4, !dbg !255
  %4 = load ptr, ptr %2, align 4, !dbg !255
  %5 = call i32 asm sideeffect "ldr $0, [$1];", "=r,r,~{memory}"(ptr %4) #6, !dbg !255, !srcloc !258
  store i32 %5, ptr %3, align 4, !dbg !255
  %6 = load i32, ptr %3, align 4, !dbg !255
  ret i32 %6, !dbg !255
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_stall() #0 !dbg !259 {
  call void asm sideeffect "", "~{memory}"() #6, !dbg !260, !srcloc !261
  ret void, !dbg !262
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_lock() #0 !dbg !263 {
  call arm_aapcscc void @ck_pr_fence_strict_lock(), !dbg !264
  ret void, !dbg !264
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_store_atomic() #0 !dbg !265 {
  call void asm sideeffect "dmb st", "r,~{memory}"(i32 0) #6, !dbg !266, !srcloc !267
  ret void, !dbg !268
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_load() #0 !dbg !269 {
  call void asm sideeffect "dmb", "r,~{memory}"(i32 0) #6, !dbg !270, !srcloc !271
  ret void, !dbg !272
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_lock() #0 !dbg !273 {
  call void asm sideeffect "dmb", "r,~{memory}"(i32 0) #6, !dbg !274, !srcloc !275
  ret void, !dbg !276
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_unlock() #0 !dbg !277 {
  call arm_aapcscc void @ck_pr_fence_strict_unlock(), !dbg !278
  ret void, !dbg !278
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !279 {
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !283, !DIExpression(), !284)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !285, !DIExpression(), !284)
  %5 = load ptr, ptr %3, align 4, !dbg !284
  %6 = load i32, ptr %4, align 4, !dbg !284
  call void asm sideeffect "str $1, [$0]", "r,r,~{memory}"(ptr %5, i32 %6) #6, !dbg !284, !srcloc !286
  ret void, !dbg !284
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_unlock() #0 !dbg !287 {
  call void asm sideeffect "dmb", "r,~{memory}"(i32 0) #6, !dbg !288, !srcloc !289
  ret void, !dbg !290
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_barrier() #0 !dbg !291 {
  call void asm sideeffect "", "~{memory}"() #6, !dbg !293, !srcloc !294
  ret void, !dbg !295
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv7-a,+dsp,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #1 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv7-a,+dsp,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv7-a,+dsp,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #3 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv7-a,+dsp,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #4 = { allocsize(0) }
attributes #5 = { noreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!47, !48, !49, !50, !51, !52, !53}
!llvm.ident = !{!54}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 10, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !23, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/clhlock.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "0af09b1974609271dca9b2d2cb44f584")
!4 = !{!5, !8, !9, !18, !7, !20, !15}
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !6, line: 17, baseType: !7)
!6 = !DIFile(filename: "include/libc/stdint.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "027aa838071dee39e5261b0fdecb37d3")
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 32)
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_clh_t", file: !11, line: 43, baseType: !12)
!11 = !DIFile(filename: "../ck/include/spinlock/clh.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "322aa46b9b9d14e37fa2ad3ef8618ff8")
!12 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_clh", file: !11, line: 39, size: 64, elements: !13)
!13 = !{!14, !16}
!14 = !DIDerivedType(tag: DW_TAG_member, name: "wait", scope: !12, file: !11, line: 40, baseType: !15, size: 32)
!15 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "previous", scope: !12, file: !11, line: 41, baseType: !17, size: 32, offset: 32)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 32)
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !19, line: 3, baseType: !15)
!19 = !DIFile(filename: "include/libc/_size_t.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "dc11ce4c8eb4c64bece0363f758637cd")
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "bool", file: !21, line: 4, baseType: !22)
!21 = !DIFile(filename: "include/libc/stdbool.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6e643322591bab80343344357c642cba")
!22 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!23 = !{!0, !24, !26, !32, !37, !43, !45}
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 10, type: !7, isLocal: false, isDefinition: true)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(scope: null, file: !3, line: 61, type: !28, isLocal: true, isDefinition: true)
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !29, size: 248, elements: !30)
!29 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!30 = !{!31}
!31 = !DISubrange(count: 31)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(scope: null, file: !3, line: 61, type: !34, isLocal: true, isDefinition: true)
!34 = !DICompositeType(tag: DW_TAG_array_type, baseType: !29, size: 192, elements: !35)
!35 = !{!36}
!36 = !DISubrange(count: 24)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 61, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 40, elements: !41)
!40 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !29)
!41 = !{!42}
!42 = !DISubrange(count: 5)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 11, type: !9, isLocal: false, isDefinition: true)
!45 = !DIGlobalVariableExpression(var: !46, expr: !DIExpression())
!46 = distinct !DIGlobalVariable(name: "nodes", scope: !2, file: !3, line: 12, type: !9, isLocal: false, isDefinition: true)
!47 = !{i32 7, !"Dwarf Version", i32 5}
!48 = !{i32 2, !"Debug Info Version", i32 3}
!49 = !{i32 1, !"wchar_size", i32 4}
!50 = !{i32 1, !"min_enum_size", i32 4}
!51 = !{i32 8, !"PIC Level", i32 2}
!52 = !{i32 7, !"PIE Level", i32 2}
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
!65 = !DILocalVariable(name: "thread_node", scope: !55, file: !3, line: 18, type: !9)
!66 = !DILocation(line: 18, column: 24, scope: !55)
!67 = !DILocation(line: 18, column: 39, scope: !55)
!68 = !DILocation(line: 18, column: 45, scope: !55)
!69 = !DILocation(line: 20, column: 33, scope: !55)
!70 = !DILocation(line: 20, column: 5, scope: !55)
!71 = !DILocation(line: 22, column: 6, scope: !55)
!72 = !DILocation(line: 23, column: 6, scope: !55)
!73 = !DILocation(line: 25, column: 5, scope: !55)
!74 = !DILocation(line: 27, column: 5, scope: !55)
!75 = distinct !DISubprogram(name: "ck_spinlock_clh_lock", scope: !11, file: !11, line: 69, type: !76, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!76 = !DISubroutineType(types: !77)
!77 = !{null, !78, !17}
!78 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 32)
!79 = !DILocalVariable(name: "queue", arg: 1, scope: !75, file: !11, line: 69, type: !78)
!80 = !DILocation(line: 69, column: 47, scope: !75)
!81 = !DILocalVariable(name: "thread", arg: 2, scope: !75, file: !11, line: 69, type: !17)
!82 = !DILocation(line: 69, column: 78, scope: !75)
!83 = !DILocalVariable(name: "previous", scope: !75, file: !11, line: 71, type: !17)
!84 = !DILocation(line: 71, column: 26, scope: !75)
!85 = !DILocation(line: 74, column: 2, scope: !75)
!86 = !DILocation(line: 74, column: 10, scope: !75)
!87 = !DILocation(line: 74, column: 15, scope: !75)
!88 = !DILocation(line: 75, column: 2, scope: !75)
!89 = !DILocation(line: 81, column: 27, scope: !75)
!90 = !DILocation(line: 81, column: 34, scope: !75)
!91 = !DILocation(line: 81, column: 13, scope: !75)
!92 = !DILocation(line: 81, column: 11, scope: !75)
!93 = !DILocation(line: 82, column: 21, scope: !75)
!94 = !DILocation(line: 82, column: 2, scope: !75)
!95 = !DILocation(line: 82, column: 10, scope: !75)
!96 = !DILocation(line: 82, column: 19, scope: !75)
!97 = !DILocation(line: 85, column: 2, scope: !75)
!98 = !DILocation(line: 86, column: 2, scope: !75)
!99 = !DILocation(line: 86, column: 26, scope: !75)
!100 = !DILocation(line: 86, column: 36, scope: !75)
!101 = !DILocation(line: 86, column: 9, scope: !75)
!102 = !DILocation(line: 86, column: 42, scope: !75)
!103 = !DILocation(line: 87, column: 3, scope: !75)
!104 = distinct !{!104, !98, !105, !106}
!105 = !DILocation(line: 87, column: 15, scope: !75)
!106 = !{!"llvm.loop.mustprogress"}
!107 = !DILocation(line: 89, column: 2, scope: !75)
!108 = !DILocation(line: 90, column: 2, scope: !75)
!109 = distinct !DISubprogram(name: "ck_spinlock_clh_unlock", scope: !11, file: !11, line: 94, type: !110, scopeLine: 95, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!110 = !DISubroutineType(types: !111)
!111 = !{null, !78}
!112 = !DILocalVariable(name: "thread", arg: 1, scope: !109, file: !11, line: 94, type: !78)
!113 = !DILocation(line: 94, column: 49, scope: !109)
!114 = !DILocalVariable(name: "previous", scope: !109, file: !11, line: 96, type: !17)
!115 = !DILocation(line: 96, column: 26, scope: !109)
!116 = !DILocation(line: 105, column: 13, scope: !109)
!117 = !DILocation(line: 105, column: 24, scope: !109)
!118 = !DILocation(line: 105, column: 11, scope: !109)
!119 = !DILocation(line: 110, column: 2, scope: !109)
!120 = !DILocation(line: 111, column: 22, scope: !109)
!121 = !DILocation(line: 111, column: 21, scope: !109)
!122 = !DILocation(line: 111, column: 31, scope: !109)
!123 = !DILocation(line: 111, column: 2, scope: !109)
!124 = !DILocation(line: 118, column: 12, scope: !109)
!125 = !DILocation(line: 118, column: 3, scope: !109)
!126 = !DILocation(line: 118, column: 10, scope: !109)
!127 = !DILocation(line: 119, column: 2, scope: !109)
!128 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 30, type: !129, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!129 = !DISubroutineType(types: !130)
!130 = !{!7}
!131 = !DILocalVariable(name: "threads", scope: !128, file: !3, line: 32, type: !132)
!132 = !DICompositeType(tag: DW_TAG_array_type, baseType: !133, size: 96, elements: !135)
!133 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !134, line: 2, baseType: !8)
!134 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!135 = !{!136}
!136 = !DISubrange(count: 3)
!137 = !DILocation(line: 32, column: 15, scope: !128)
!138 = !DILocalVariable(name: "i", scope: !128, file: !3, line: 33, type: !7)
!139 = !DILocation(line: 33, column: 9, scope: !128)
!140 = !DILocalVariable(name: "unowned", scope: !128, file: !3, line: 35, type: !10)
!141 = !DILocation(line: 35, column: 23, scope: !128)
!142 = !DILocation(line: 36, column: 5, scope: !128)
!143 = !DILocation(line: 38, column: 34, scope: !128)
!144 = !DILocation(line: 38, column: 11, scope: !128)
!145 = !DILocation(line: 39, column: 12, scope: !146)
!146 = distinct !DILexicalBlock(scope: !128, file: !3, line: 39, column: 5)
!147 = !DILocation(line: 39, column: 10, scope: !146)
!148 = !DILocation(line: 39, column: 17, scope: !149)
!149 = distinct !DILexicalBlock(scope: !146, file: !3, line: 39, column: 5)
!150 = !DILocation(line: 39, column: 19, scope: !149)
!151 = !DILocation(line: 39, column: 5, scope: !146)
!152 = !DILocalVariable(name: "ptr", scope: !153, file: !3, line: 41, type: !9)
!153 = distinct !DILexicalBlock(scope: !149, file: !3, line: 40, column: 5)
!154 = !DILocation(line: 41, column: 28, scope: !153)
!155 = !DILocation(line: 42, column: 37, scope: !153)
!156 = !DILocation(line: 42, column: 43, scope: !153)
!157 = !DILocation(line: 42, column: 9, scope: !153)
!158 = !DILocation(line: 43, column: 5, scope: !153)
!159 = !DILocation(line: 39, column: 32, scope: !149)
!160 = !DILocation(line: 39, column: 5, scope: !149)
!161 = distinct !{!161, !151, !162, !106}
!162 = !DILocation(line: 43, column: 5, scope: !146)
!163 = !DILocation(line: 45, column: 12, scope: !164)
!164 = distinct !DILexicalBlock(scope: !128, file: !3, line: 45, column: 5)
!165 = !DILocation(line: 45, column: 10, scope: !164)
!166 = !DILocation(line: 45, column: 17, scope: !167)
!167 = distinct !DILexicalBlock(scope: !164, file: !3, line: 45, column: 5)
!168 = !DILocation(line: 45, column: 19, scope: !167)
!169 = !DILocation(line: 45, column: 5, scope: !164)
!170 = !DILocation(line: 47, column: 37, scope: !171)
!171 = distinct !DILexicalBlock(scope: !172, file: !3, line: 47, column: 13)
!172 = distinct !DILexicalBlock(scope: !167, file: !3, line: 46, column: 5)
!173 = !DILocation(line: 47, column: 29, scope: !171)
!174 = !DILocation(line: 47, column: 69, scope: !171)
!175 = !DILocation(line: 47, column: 52, scope: !171)
!176 = !DILocation(line: 47, column: 13, scope: !171)
!177 = !DILocation(line: 47, column: 72, scope: !171)
!178 = !DILocation(line: 49, column: 13, scope: !179)
!179 = distinct !DILexicalBlock(scope: !171, file: !3, line: 48, column: 9)
!180 = !DILocation(line: 51, column: 5, scope: !172)
!181 = !DILocation(line: 45, column: 32, scope: !167)
!182 = !DILocation(line: 45, column: 5, scope: !167)
!183 = distinct !{!183, !169, !184, !106}
!184 = !DILocation(line: 51, column: 5, scope: !164)
!185 = !DILocation(line: 53, column: 12, scope: !186)
!186 = distinct !DILexicalBlock(scope: !128, file: !3, line: 53, column: 5)
!187 = !DILocation(line: 53, column: 10, scope: !186)
!188 = !DILocation(line: 53, column: 17, scope: !189)
!189 = distinct !DILexicalBlock(scope: !186, file: !3, line: 53, column: 5)
!190 = !DILocation(line: 53, column: 19, scope: !189)
!191 = !DILocation(line: 53, column: 5, scope: !186)
!192 = !DILocation(line: 55, column: 34, scope: !193)
!193 = distinct !DILexicalBlock(scope: !194, file: !3, line: 55, column: 13)
!194 = distinct !DILexicalBlock(scope: !189, file: !3, line: 54, column: 5)
!195 = !DILocation(line: 55, column: 26, scope: !193)
!196 = !DILocation(line: 55, column: 13, scope: !193)
!197 = !DILocation(line: 55, column: 44, scope: !193)
!198 = !DILocation(line: 57, column: 13, scope: !199)
!199 = distinct !DILexicalBlock(scope: !193, file: !3, line: 56, column: 9)
!200 = !DILocation(line: 59, column: 5, scope: !194)
!201 = !DILocation(line: 53, column: 32, scope: !189)
!202 = !DILocation(line: 53, column: 5, scope: !189)
!203 = distinct !{!203, !191, !204, !106}
!204 = !DILocation(line: 59, column: 5, scope: !186)
!205 = !DILocation(line: 61, column: 12, scope: !206)
!206 = distinct !DILexicalBlock(scope: !207, file: !3, line: 61, column: 5)
!207 = distinct !DILexicalBlock(scope: !128, file: !3, line: 61, column: 5)
!208 = !DILocation(line: 61, column: 14, scope: !206)
!209 = !DILocation(line: 61, column: 26, scope: !206)
!210 = !DILocation(line: 61, column: 29, scope: !206)
!211 = !DILocation(line: 61, column: 31, scope: !206)
!212 = !DILocation(line: 61, column: 5, scope: !206)
!213 = !DILocation(line: 63, column: 10, scope: !128)
!214 = !DILocation(line: 63, column: 5, scope: !128)
!215 = !DILocation(line: 65, column: 5, scope: !128)
!216 = distinct !DISubprogram(name: "ck_spinlock_clh_init", scope: !11, file: !11, line: 46, type: !76, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!217 = !DILocalVariable(name: "lock", arg: 1, scope: !216, file: !11, line: 46, type: !78)
!218 = !DILocation(line: 46, column: 47, scope: !216)
!219 = !DILocalVariable(name: "unowned", arg: 2, scope: !216, file: !11, line: 46, type: !17)
!220 = !DILocation(line: 46, column: 77, scope: !216)
!221 = !DILocation(line: 49, column: 2, scope: !216)
!222 = !DILocation(line: 49, column: 11, scope: !216)
!223 = !DILocation(line: 49, column: 20, scope: !216)
!224 = !DILocation(line: 50, column: 2, scope: !216)
!225 = !DILocation(line: 50, column: 11, scope: !216)
!226 = !DILocation(line: 50, column: 16, scope: !216)
!227 = !DILocation(line: 51, column: 10, scope: !216)
!228 = !DILocation(line: 51, column: 3, scope: !216)
!229 = !DILocation(line: 51, column: 8, scope: !216)
!230 = !DILocation(line: 52, column: 2, scope: !216)
!231 = !DILocation(line: 53, column: 2, scope: !216)
!232 = distinct !DISubprogram(name: "ck_pr_fence_store_atomic", scope: !233, file: !233, line: 112, type: !234, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!233 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!234 = !DISubroutineType(types: !235)
!235 = !{null}
!236 = !DILocation(line: 112, column: 1, scope: !232)
!237 = distinct !DISubprogram(name: "ck_pr_fas_ptr", scope: !238, file: !238, line: 415, type: !239, scopeLine: 415, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!238 = !DIFile(filename: "../ck/include/gcc/arm/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "f3f9fb174933d4f9d5af6678feea8d14")
!239 = !DISubroutineType(types: !240)
!240 = !{!8, !8, !8}
!241 = !DILocalVariable(name: "target", arg: 1, scope: !237, file: !238, line: 415, type: !8)
!242 = !DILocation(line: 415, column: 1, scope: !237)
!243 = !DILocalVariable(name: "v", arg: 2, scope: !237, file: !238, line: 415, type: !8)
!244 = !DILocalVariable(name: "previous", scope: !237, file: !238, line: 415, type: !8)
!245 = !DILocalVariable(name: "tmp", scope: !237, file: !238, line: 415, type: !8)
!246 = !{i64 2147605360}
!247 = distinct !DISubprogram(name: "ck_pr_fence_load", scope: !233, file: !233, line: 116, type: !234, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!248 = !DILocation(line: 116, column: 1, scope: !247)
!249 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !238, file: !238, line: 127, type: !250, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!250 = !DISubroutineType(types: !251)
!251 = !{!15, !252}
!252 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !253, size: 32)
!253 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!254 = !DILocalVariable(name: "target", arg: 1, scope: !249, file: !238, line: 127, type: !252)
!255 = !DILocation(line: 127, column: 1, scope: !249)
!256 = !DILocalVariable(name: "r", scope: !249, file: !238, line: 127, type: !257)
!257 = !DIBasicType(name: "long", size: 32, encoding: DW_ATE_signed)
!258 = !{i64 2147586133}
!259 = distinct !DISubprogram(name: "ck_pr_stall", scope: !238, file: !238, line: 50, type: !234, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!260 = !DILocation(line: 53, column: 2, scope: !259)
!261 = !{i64 79037}
!262 = !DILocation(line: 54, column: 2, scope: !259)
!263 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !233, file: !233, line: 122, type: !234, scopeLine: 122, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!264 = !DILocation(line: 122, column: 1, scope: !263)
!265 = distinct !DISubprogram(name: "ck_pr_fence_strict_store_atomic", scope: !238, file: !238, line: 88, type: !234, scopeLine: 88, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!266 = !DILocation(line: 88, column: 27, scope: !265)
!267 = !{i64 2147581452}
!268 = !DILocation(line: 88, column: 1, scope: !265)
!269 = distinct !DISubprogram(name: "ck_pr_fence_strict_load", scope: !238, file: !238, line: 92, type: !234, scopeLine: 92, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!270 = !DILocation(line: 92, column: 19, scope: !269)
!271 = !{i64 2147582485}
!272 = !DILocation(line: 92, column: 1, scope: !269)
!273 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !238, file: !238, line: 98, type: !234, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!274 = !DILocation(line: 98, column: 19, scope: !273)
!275 = !{i64 2147583999}
!276 = !DILocation(line: 98, column: 1, scope: !273)
!277 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !233, file: !233, line: 123, type: !234, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!278 = !DILocation(line: 123, column: 1, scope: !277)
!279 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !238, file: !238, line: 176, type: !280, scopeLine: 176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!280 = !DISubroutineType(types: !281)
!281 = !{null, !282, !15}
!282 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 32)
!283 = !DILocalVariable(name: "target", arg: 1, scope: !279, file: !238, line: 176, type: !282)
!284 = !DILocation(line: 176, column: 1, scope: !279)
!285 = !DILocalVariable(name: "v", arg: 2, scope: !279, file: !238, line: 176, type: !15)
!286 = !{i64 2147589656}
!287 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !238, file: !238, line: 99, type: !234, scopeLine: 99, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!288 = !DILocation(line: 99, column: 21, scope: !287)
!289 = !{i64 2147584248}
!290 = !DILocation(line: 99, column: 1, scope: !287)
!291 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !292, file: !292, line: 37, type: !234, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!292 = !DIFile(filename: "../ck/include/gcc/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!293 = !DILocation(line: 40, column: 2, scope: !291)
!294 = !{i64 178512}
!295 = !DILocation(line: 41, column: 2, scope: !291)
