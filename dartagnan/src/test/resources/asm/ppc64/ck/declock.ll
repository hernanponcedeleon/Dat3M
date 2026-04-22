; ModuleID = 'benchmarks/ck/declock.c'
source_filename = "benchmarks/ck/declock.c"
target datalayout = "E-m:e-Fi64-i64:64-i128:128-n32:64-S128-v256:256:256-v512:512:512"
target triple = "ppc64-pc-linux-gnu"

%struct.ck_spinlock_dec = type { i32 }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !21
@lock = dso_local global %struct.ck_spinlock_dec zeroinitializer, align 4, !dbg !40
@.str = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !23
@.str.1 = private unnamed_addr constant [24 x i8] c"benchmarks/ck/declock.c\00", align 1, !dbg !29
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !34
@nodes = dso_local global ptr null, align 8, !dbg !47

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @run(ptr noundef %0) #0 !dbg !58 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !62, !DIExpression(), !63)
    #dbg_declare(ptr %3, !64, !DIExpression(), !65)
  %5 = load ptr, ptr %2, align 8, !dbg !66
  %6 = ptrtoint ptr %5 to i64, !dbg !67
  store i64 %6, ptr %3, align 8, !dbg !65
  %7 = load i64, ptr %3, align 8, !dbg !68
  %8 = icmp eq i64 %7, 1, !dbg !70
  br i1 %8, label %9, label %15, !dbg !70

9:                                                ; preds = %1
    #dbg_declare(ptr %4, !71, !DIExpression(), !73)
  %10 = call zeroext i1 @ck_spinlock_dec_trylock(ptr noundef @lock), !dbg !74
  %11 = zext i1 %10 to i8, !dbg !73
  store i8 %11, ptr %4, align 1, !dbg !73
  %12 = load i8, ptr %4, align 1, !dbg !75
  %13 = trunc i8 %12 to i1, !dbg !75
  %14 = zext i1 %13 to i32, !dbg !75
  call void @__VERIFIER_assume(i32 noundef signext %14), !dbg !76
  br label %16, !dbg !77

15:                                               ; preds = %1
  call void @ck_spinlock_dec_lock(ptr noundef @lock), !dbg !78
  br label %16

16:                                               ; preds = %15, %9
  %17 = load i32, ptr @x, align 4, !dbg !80
  %18 = add nsw i32 %17, 1, !dbg !80
  store i32 %18, ptr @x, align 4, !dbg !80
  %19 = load i32, ptr @y, align 4, !dbg !81
  %20 = add nsw i32 %19, 1, !dbg !81
  store i32 %20, ptr @y, align 4, !dbg !81
  call void @ck_spinlock_dec_unlock(ptr noundef @lock), !dbg !82
  ret ptr null, !dbg !83
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i1 @ck_spinlock_dec_trylock(ptr noundef %0) #0 !dbg !84 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !88, !DIExpression(), !89)
    #dbg_declare(ptr %3, !90, !DIExpression(), !91)
  %4 = load ptr, ptr %2, align 8, !dbg !92
  %5 = getelementptr inbounds nuw %struct.ck_spinlock_dec, ptr %4, i32 0, i32 0, !dbg !93
  %6 = call zeroext i32 @ck_pr_fas_uint(ptr noundef %5, i32 noundef zeroext 0), !dbg !94
  store i32 %6, ptr %3, align 4, !dbg !95
  call void @ck_pr_fence_lock(), !dbg !96
  %7 = load i32, ptr %3, align 4, !dbg !97
  %8 = icmp eq i32 %7, 1, !dbg !98
  ret i1 %8, !dbg !99
}

declare void @__VERIFIER_assume(i32 noundef signext) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_dec_lock(ptr noundef %0) #0 !dbg !100 {
  %2 = alloca ptr, align 8
  %3 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !103, !DIExpression(), !104)
    #dbg_declare(ptr %3, !105, !DIExpression(), !106)
  br label %4, !dbg !107

4:                                                ; preds = %19, %1
  %5 = load ptr, ptr %2, align 8, !dbg !108
  %6 = getelementptr inbounds nuw %struct.ck_spinlock_dec, ptr %5, i32 0, i32 0, !dbg !112
  call void @ck_pr_dec_uint_zero(ptr noundef %6, ptr noundef %3), !dbg !113
  %7 = load i8, ptr %3, align 1, !dbg !114
  %8 = trunc i8 %7 to i1, !dbg !114
  %9 = zext i1 %8 to i32, !dbg !114
  %10 = icmp eq i32 %9, 1, !dbg !116
  br i1 %10, label %11, label %12, !dbg !116

11:                                               ; preds = %4
  br label %20, !dbg !117

12:                                               ; preds = %4
  br label %13, !dbg !118

13:                                               ; preds = %18, %12
  %14 = load ptr, ptr %2, align 8, !dbg !119
  %15 = getelementptr inbounds nuw %struct.ck_spinlock_dec, ptr %14, i32 0, i32 0, !dbg !120
  %16 = call zeroext i32 @ck_pr_md_load_uint(ptr noundef %15), !dbg !121
  %17 = icmp ne i32 %16, 1, !dbg !122
  br i1 %17, label %18, label %19, !dbg !118

18:                                               ; preds = %13
  call void @ck_pr_stall(), !dbg !123
  br label %13, !dbg !118, !llvm.loop !124

19:                                               ; preds = %13
  br label %4, !dbg !127, !llvm.loop !128

20:                                               ; preds = %11
  call void @ck_pr_fence_lock(), !dbg !131
  ret void, !dbg !132
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_dec_unlock(ptr noundef %0) #0 !dbg !133 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !134, !DIExpression(), !135)
  call void @ck_pr_fence_unlock(), !dbg !136
  %3 = load ptr, ptr %2, align 8, !dbg !137
  %4 = getelementptr inbounds nuw %struct.ck_spinlock_dec, ptr %3, i32 0, i32 0, !dbg !138
  call void @ck_pr_md_store_uint(ptr noundef %4, i32 noundef zeroext 1), !dbg !139
  ret void, !dbg !140
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local signext i32 @main() #0 !dbg !141 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x ptr], align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !144, !DIExpression(), !150)
    #dbg_declare(ptr %3, !151, !DIExpression(), !152)
  call void @ck_spinlock_dec_init(ptr noundef @lock), !dbg !153
  store i32 0, ptr %3, align 4, !dbg !154
  br label %4, !dbg !156

4:                                                ; preds = %18, %0
  %5 = load i32, ptr %3, align 4, !dbg !157
  %6 = icmp slt i32 %5, 2, !dbg !159
  br i1 %6, label %7, label %21, !dbg !160

7:                                                ; preds = %4
  %8 = load i32, ptr %3, align 4, !dbg !161
  %9 = sext i32 %8 to i64, !dbg !164
  %10 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %9, !dbg !164
  %11 = load i32, ptr %3, align 4, !dbg !165
  %12 = sext i32 %11 to i64, !dbg !166
  %13 = inttoptr i64 %12 to ptr, !dbg !167
  %14 = call signext i32 @pthread_create(ptr noundef %10, ptr noundef null, ptr noundef @run, ptr noundef %13), !dbg !168
  %15 = icmp ne i32 %14, 0, !dbg !169
  br i1 %15, label %16, label %17, !dbg !169

16:                                               ; preds = %7
  call void @exit(i32 noundef signext 1) #3, !dbg !170
  unreachable, !dbg !170

17:                                               ; preds = %7
  br label %18, !dbg !172

18:                                               ; preds = %17
  %19 = load i32, ptr %3, align 4, !dbg !173
  %20 = add nsw i32 %19, 1, !dbg !173
  store i32 %20, ptr %3, align 4, !dbg !173
  br label %4, !dbg !174, !llvm.loop !175

21:                                               ; preds = %4
  store i32 0, ptr %3, align 4, !dbg !177
  br label %22, !dbg !179

22:                                               ; preds = %34, %21
  %23 = load i32, ptr %3, align 4, !dbg !180
  %24 = icmp slt i32 %23, 2, !dbg !182
  br i1 %24, label %25, label %37, !dbg !183

25:                                               ; preds = %22
  %26 = load i32, ptr %3, align 4, !dbg !184
  %27 = sext i32 %26 to i64, !dbg !187
  %28 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %27, !dbg !187
  %29 = load ptr, ptr %28, align 8, !dbg !187
  %30 = call signext i32 @pthread_join(ptr noundef %29, ptr noundef null), !dbg !188
  %31 = icmp ne i32 %30, 0, !dbg !189
  br i1 %31, label %32, label %33, !dbg !189

32:                                               ; preds = %25
  call void @exit(i32 noundef signext 1) #3, !dbg !190
  unreachable, !dbg !190

33:                                               ; preds = %25
  br label %34, !dbg !192

34:                                               ; preds = %33
  %35 = load i32, ptr %3, align 4, !dbg !193
  %36 = add nsw i32 %35, 1, !dbg !193
  store i32 %36, ptr %3, align 4, !dbg !193
  br label %22, !dbg !194, !llvm.loop !195

37:                                               ; preds = %22
  %38 = load i32, ptr @x, align 4, !dbg !197
  %39 = icmp eq i32 %38, 2, !dbg !200
  br i1 %39, label %40, label %43, !dbg !201

40:                                               ; preds = %37
  %41 = load i32, ptr @y, align 4, !dbg !202
  %42 = icmp eq i32 %41, 2, !dbg !203
  br i1 %42, label %44, label %43, !dbg !204

43:                                               ; preds = %40, %37
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef signext 59, ptr noundef @__func__.main), !dbg !204
  br label %44, !dbg !204

44:                                               ; preds = %43, %40
  ret i32 0, !dbg !205
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_dec_init(ptr noundef %0) #0 !dbg !206 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !207, !DIExpression(), !208)
  %3 = load ptr, ptr %2, align 8, !dbg !209
  %4 = getelementptr inbounds nuw %struct.ck_spinlock_dec, ptr %3, i32 0, i32 0, !dbg !210
  store i32 1, ptr %4, align 4, !dbg !211
  call void @ck_pr_barrier(), !dbg !212
  ret void, !dbg !213
}

declare signext i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef signext) #2

declare signext i32 @pthread_join(ptr noundef, ptr noundef) #1

declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef signext, ptr noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i32 @ck_pr_fas_uint(ptr noundef %0, i32 noundef zeroext %1) #0 !dbg !214 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !218, !DIExpression(), !219)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !220, !DIExpression(), !219)
    #dbg_declare(ptr %5, !221, !DIExpression(), !219)
  %6 = load ptr, ptr %3, align 8, !dbg !219
  %7 = load i32, ptr %4, align 4, !dbg !219
  %8 = call i32 asm sideeffect "1:lwarx $0, 0, $1;stwcx. $2, 0, $1;bne- 1b;", "=&r,r,r,~{memory},~{cc}"(ptr %6, i32 %7) #4, !dbg !219, !srcloc !222
  store i32 %8, ptr %5, align 4, !dbg !219
  %9 = load i32, ptr %5, align 4, !dbg !219
  ret i32 %9, !dbg !219
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_lock() #0 !dbg !223 {
  call void @ck_pr_fence_strict_lock(), !dbg !227
  ret void, !dbg !227
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_lock() #0 !dbg !228 {
  call void asm sideeffect "lwsync", "~{memory}"() #4, !dbg !229, !srcloc !230
  ret void, !dbg !229
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_dec_uint_zero(ptr noundef %0, ptr noundef %1) #0 !dbg !231 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !235, !DIExpression(), !236)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !237, !DIExpression(), !236)
  %5 = load ptr, ptr %3, align 8, !dbg !236
  %6 = call zeroext i1 @ck_pr_dec_uint_is_zero(ptr noundef %5), !dbg !236
  %7 = load ptr, ptr %4, align 8, !dbg !236
  %8 = zext i1 %6 to i8, !dbg !236
  store i8 %8, ptr %7, align 1, !dbg !236
  ret void, !dbg !236
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !238 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !241, !DIExpression(), !242)
    #dbg_declare(ptr %3, !243, !DIExpression(), !242)
  %4 = load ptr, ptr %2, align 8, !dbg !242
  %5 = call i32 asm sideeffect "lwz${1:U}${1:X} $0, $1", "=r,*m,~{memory}"(ptr elementtype(i32) %4) #4, !dbg !242, !srcloc !244
  store i32 %5, ptr %3, align 4, !dbg !242
  %6 = load i32, ptr %3, align 4, !dbg !242
  ret i32 %6, !dbg !242
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_stall() #0 !dbg !245 {
  call void asm sideeffect "or 1, 1, 1;or 2, 2, 2;", "~{memory}"() #4, !dbg !246, !srcloc !247
  ret void, !dbg !248
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i1 @ck_pr_dec_uint_is_zero(ptr noundef %0) #0 !dbg !249 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !252, !DIExpression(), !253)
    #dbg_declare(ptr %3, !254, !DIExpression(), !253)
    #dbg_declare(ptr %4, !255, !DIExpression(), !253)
  %5 = load ptr, ptr %2, align 8, !dbg !253
  %6 = call zeroext i32 @ck_pr_md_load_uint(ptr noundef %5), !dbg !253
  store i32 %6, ptr %4, align 4, !dbg !253
  %7 = load i32, ptr %4, align 4, !dbg !253
  store i32 %7, ptr %3, align 4, !dbg !253
  br label %8, !dbg !253

8:                                                ; preds = %16, %1
  %9 = load ptr, ptr %2, align 8, !dbg !253
  %10 = load i32, ptr %3, align 4, !dbg !253
  %11 = load i32, ptr %3, align 4, !dbg !253
  %12 = sub i32 %11, 1, !dbg !256
  %13 = call zeroext i1 @ck_pr_cas_uint_value(ptr noundef %9, i32 noundef zeroext %10, i32 noundef zeroext %12, ptr noundef %3), !dbg !253
  %14 = zext i1 %13 to i32, !dbg !253
  %15 = icmp eq i32 %14, 0, !dbg !253
  br i1 %15, label %16, label %17, !dbg !253

16:                                               ; preds = %8
  call void @ck_pr_stall(), !dbg !253
  br label %8, !dbg !253, !llvm.loop !257

17:                                               ; preds = %8
  %18 = load i32, ptr %3, align 4, !dbg !253
  %19 = icmp eq i32 %18, 1, !dbg !253
  ret i1 %19, !dbg !253
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i1 @ck_pr_cas_uint_value(ptr noundef %0, i32 noundef zeroext %1, i32 noundef zeroext %2, ptr noundef %3) #0 !dbg !258 {
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
    #dbg_declare(ptr %5, !261, !DIExpression(), !262)
  store i32 %1, ptr %6, align 4
    #dbg_declare(ptr %6, !263, !DIExpression(), !262)
  store i32 %2, ptr %7, align 4
    #dbg_declare(ptr %7, !264, !DIExpression(), !262)
  store ptr %3, ptr %8, align 8
    #dbg_declare(ptr %8, !265, !DIExpression(), !262)
    #dbg_declare(ptr %9, !266, !DIExpression(), !262)
  %10 = load ptr, ptr %5, align 8, !dbg !262
  %11 = load i32, ptr %7, align 4, !dbg !262
  %12 = load i32, ptr %6, align 4, !dbg !262
  %13 = call i32 asm sideeffect "1:lwarx $0, 0, $1;cmpw  0, $0, $3;bne-  2f;stwcx. $2, 0, $1;bne-  1b;2:", "=&r,r,r,r,~{memory},~{cc}"(ptr %10, i32 %11, i32 %12) #4, !dbg !262, !srcloc !267
  store i32 %13, ptr %9, align 4, !dbg !262
  %14 = load i32, ptr %9, align 4, !dbg !262
  %15 = load ptr, ptr %8, align 8, !dbg !262
  store i32 %14, ptr %15, align 4, !dbg !262
  %16 = load i32, ptr %9, align 4, !dbg !262
  %17 = load i32, ptr %6, align 4, !dbg !262
  %18 = icmp eq i32 %16, %17, !dbg !262
  ret i1 %18, !dbg !262
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_unlock() #0 !dbg !268 {
  call void @ck_pr_fence_strict_unlock(), !dbg !269
  ret void, !dbg !269
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef zeroext %1) #0 !dbg !270 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !273, !DIExpression(), !274)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !275, !DIExpression(), !274)
  %5 = load ptr, ptr %3, align 8, !dbg !274
  %6 = load i32, ptr %4, align 4, !dbg !274
  call void asm sideeffect "stw${0:U}${0:X} $1, $0", "=*m,r,~{memory}"(ptr elementtype(i32) %5, i32 %6) #4, !dbg !274, !srcloc !276
  ret void, !dbg !274
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_unlock() #0 !dbg !277 {
  call void asm sideeffect "lwsync", "~{memory}"() #4, !dbg !278, !srcloc !279
  ret void, !dbg !278
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_barrier() #0 !dbg !280 {
  call void asm sideeffect "", "~{memory}"() #4, !dbg !282, !srcloc !283
  ret void, !dbg !284
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #3 = { noreturn }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!50, !51, !52, !53, !54, !55, !56}
!llvm.ident = !{!57}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 12, type: !12, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !20, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/declock.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "30fa24ff6bfc9964c8665f42f6017fd2")
!4 = !{!5, !8, !9, !12, !13, !16, !17, !19}
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
!16 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!18 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !16)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!20 = !{!0, !21, !23, !29, !34, !40, !47}
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 12, type: !12, isLocal: false, isDefinition: true)
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
!41 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 13, type: !42, isLocal: false, isDefinition: true)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_dec_t", file: !43, line: 46, baseType: !44)
!43 = !DIFile(filename: "../ck/include/spinlock/dec.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "ebf75fdec979dfc7f06fb0ef6eee88f9")
!44 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_dec", file: !43, line: 43, size: 32, elements: !45)
!45 = !{!46}
!46 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !44, file: !43, line: 44, baseType: !16, size: 32)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "nodes", scope: !2, file: !3, line: 14, type: !49, isLocal: false, isDefinition: true)
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!50 = !{i32 7, !"Dwarf Version", i32 5}
!51 = !{i32 2, !"Debug Info Version", i32 3}
!52 = !{i32 1, !"wchar_size", i32 4}
!53 = !{i32 8, !"PIC Level", i32 2}
!54 = !{i32 7, !"PIE Level", i32 2}
!55 = !{i32 7, !"uwtable", i32 2}
!56 = !{i32 7, !"frame-pointer", i32 2}
!57 = !{!"Homebrew clang version 22.1.8"}
!58 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 16, type: !59, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !61)
!59 = !DISubroutineType(types: !60)
!60 = !{!8, !8}
!61 = !{}
!62 = !DILocalVariable(name: "arg", arg: 1, scope: !58, file: !3, line: 16, type: !8)
!63 = !DILocation(line: 16, column: 17, scope: !58)
!64 = !DILocalVariable(name: "tid", scope: !58, file: !3, line: 18, type: !5)
!65 = !DILocation(line: 18, column: 14, scope: !58)
!66 = !DILocation(line: 18, column: 31, scope: !58)
!67 = !DILocation(line: 18, column: 21, scope: !58)
!68 = !DILocation(line: 20, column: 9, scope: !69)
!69 = distinct !DILexicalBlock(scope: !58, file: !3, line: 20, column: 9)
!70 = !DILocation(line: 20, column: 13, scope: !69)
!71 = !DILocalVariable(name: "acquired", scope: !72, file: !3, line: 22, type: !13)
!72 = distinct !DILexicalBlock(scope: !69, file: !3, line: 21, column: 5)
!73 = !DILocation(line: 22, column: 14, scope: !72)
!74 = !DILocation(line: 22, column: 25, scope: !72)
!75 = !DILocation(line: 23, column: 27, scope: !72)
!76 = !DILocation(line: 23, column: 9, scope: !72)
!77 = !DILocation(line: 24, column: 5, scope: !72)
!78 = !DILocation(line: 27, column: 9, scope: !79)
!79 = distinct !DILexicalBlock(scope: !69, file: !3, line: 26, column: 5)
!80 = !DILocation(line: 29, column: 6, scope: !58)
!81 = !DILocation(line: 30, column: 6, scope: !58)
!82 = !DILocation(line: 31, column: 5, scope: !58)
!83 = !DILocation(line: 33, column: 5, scope: !58)
!84 = distinct !DISubprogram(name: "ck_spinlock_dec_trylock", scope: !43, file: !43, line: 60, type: !85, scopeLine: 61, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!85 = !DISubroutineType(types: !86)
!86 = !{!13, !87}
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!88 = !DILocalVariable(name: "lock", arg: 1, scope: !84, file: !43, line: 60, type: !87)
!89 = !DILocation(line: 60, column: 49, scope: !84)
!90 = !DILocalVariable(name: "value", scope: !84, file: !43, line: 62, type: !16)
!91 = !DILocation(line: 62, column: 15, scope: !84)
!92 = !DILocation(line: 64, column: 26, scope: !84)
!93 = !DILocation(line: 64, column: 32, scope: !84)
!94 = !DILocation(line: 64, column: 10, scope: !84)
!95 = !DILocation(line: 64, column: 8, scope: !84)
!96 = !DILocation(line: 65, column: 2, scope: !84)
!97 = !DILocation(line: 66, column: 9, scope: !84)
!98 = !DILocation(line: 66, column: 15, scope: !84)
!99 = !DILocation(line: 66, column: 2, scope: !84)
!100 = distinct !DISubprogram(name: "ck_spinlock_dec_lock", scope: !43, file: !43, line: 80, type: !101, scopeLine: 81, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!101 = !DISubroutineType(types: !102)
!102 = !{null, !87}
!103 = !DILocalVariable(name: "lock", arg: 1, scope: !100, file: !43, line: 80, type: !87)
!104 = !DILocation(line: 80, column: 46, scope: !100)
!105 = !DILocalVariable(name: "r", scope: !100, file: !43, line: 82, type: !13)
!106 = !DILocation(line: 82, column: 7, scope: !100)
!107 = !DILocation(line: 84, column: 2, scope: !100)
!108 = !DILocation(line: 90, column: 24, scope: !109)
!109 = distinct !DILexicalBlock(scope: !110, file: !43, line: 84, column: 11)
!110 = distinct !DILexicalBlock(scope: !111, file: !43, line: 84, column: 2)
!111 = distinct !DILexicalBlock(scope: !100, file: !43, line: 84, column: 2)
!112 = !DILocation(line: 90, column: 30, scope: !109)
!113 = !DILocation(line: 90, column: 3, scope: !109)
!114 = !DILocation(line: 91, column: 7, scope: !115)
!115 = distinct !DILexicalBlock(scope: !109, file: !43, line: 91, column: 7)
!116 = !DILocation(line: 91, column: 9, scope: !115)
!117 = !DILocation(line: 92, column: 4, scope: !115)
!118 = !DILocation(line: 95, column: 3, scope: !109)
!119 = !DILocation(line: 95, column: 27, scope: !109)
!120 = !DILocation(line: 95, column: 33, scope: !109)
!121 = !DILocation(line: 95, column: 10, scope: !109)
!122 = !DILocation(line: 95, column: 40, scope: !109)
!123 = !DILocation(line: 96, column: 4, scope: !109)
!124 = distinct !{!124, !118, !125, !126}
!125 = !DILocation(line: 96, column: 16, scope: !109)
!126 = !{!"llvm.loop.mustprogress"}
!127 = !DILocation(line: 84, column: 2, scope: !110)
!128 = distinct !{!128, !129, !130}
!129 = !DILocation(line: 84, column: 2, scope: !111)
!130 = !DILocation(line: 97, column: 2, scope: !111)
!131 = !DILocation(line: 99, column: 2, scope: !100)
!132 = !DILocation(line: 100, column: 2, scope: !100)
!133 = distinct !DISubprogram(name: "ck_spinlock_dec_unlock", scope: !43, file: !43, line: 123, type: !101, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!134 = !DILocalVariable(name: "lock", arg: 1, scope: !133, file: !43, line: 123, type: !87)
!135 = !DILocation(line: 123, column: 48, scope: !133)
!136 = !DILocation(line: 126, column: 2, scope: !133)
!137 = !DILocation(line: 132, column: 20, scope: !133)
!138 = !DILocation(line: 132, column: 26, scope: !133)
!139 = !DILocation(line: 132, column: 2, scope: !133)
!140 = !DILocation(line: 133, column: 2, scope: !133)
!141 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 36, type: !142, scopeLine: 37, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !61)
!142 = !DISubroutineType(types: !143)
!143 = !{!12}
!144 = !DILocalVariable(name: "threads", scope: !141, file: !3, line: 38, type: !145)
!145 = !DICompositeType(tag: DW_TAG_array_type, baseType: !146, size: 128, elements: !148)
!146 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !147, line: 2, baseType: !8)
!147 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!148 = !{!149}
!149 = !DISubrange(count: 2)
!150 = !DILocation(line: 38, column: 15, scope: !141)
!151 = !DILocalVariable(name: "i", scope: !141, file: !3, line: 39, type: !12)
!152 = !DILocation(line: 39, column: 9, scope: !141)
!153 = !DILocation(line: 41, column: 5, scope: !141)
!154 = !DILocation(line: 43, column: 12, scope: !155)
!155 = distinct !DILexicalBlock(scope: !141, file: !3, line: 43, column: 5)
!156 = !DILocation(line: 43, column: 10, scope: !155)
!157 = !DILocation(line: 43, column: 17, scope: !158)
!158 = distinct !DILexicalBlock(scope: !155, file: !3, line: 43, column: 5)
!159 = !DILocation(line: 43, column: 19, scope: !158)
!160 = !DILocation(line: 43, column: 5, scope: !155)
!161 = !DILocation(line: 45, column: 37, scope: !162)
!162 = distinct !DILexicalBlock(scope: !163, file: !3, line: 45, column: 13)
!163 = distinct !DILexicalBlock(scope: !158, file: !3, line: 44, column: 5)
!164 = !DILocation(line: 45, column: 29, scope: !162)
!165 = !DILocation(line: 45, column: 68, scope: !162)
!166 = !DILocation(line: 45, column: 60, scope: !162)
!167 = !DILocation(line: 45, column: 52, scope: !162)
!168 = !DILocation(line: 45, column: 13, scope: !162)
!169 = !DILocation(line: 45, column: 71, scope: !162)
!170 = !DILocation(line: 47, column: 13, scope: !171)
!171 = distinct !DILexicalBlock(scope: !162, file: !3, line: 46, column: 9)
!172 = !DILocation(line: 49, column: 5, scope: !163)
!173 = !DILocation(line: 43, column: 32, scope: !158)
!174 = !DILocation(line: 43, column: 5, scope: !158)
!175 = distinct !{!175, !160, !176, !126}
!176 = !DILocation(line: 49, column: 5, scope: !155)
!177 = !DILocation(line: 51, column: 12, scope: !178)
!178 = distinct !DILexicalBlock(scope: !141, file: !3, line: 51, column: 5)
!179 = !DILocation(line: 51, column: 10, scope: !178)
!180 = !DILocation(line: 51, column: 17, scope: !181)
!181 = distinct !DILexicalBlock(scope: !178, file: !3, line: 51, column: 5)
!182 = !DILocation(line: 51, column: 19, scope: !181)
!183 = !DILocation(line: 51, column: 5, scope: !178)
!184 = !DILocation(line: 53, column: 34, scope: !185)
!185 = distinct !DILexicalBlock(scope: !186, file: !3, line: 53, column: 13)
!186 = distinct !DILexicalBlock(scope: !181, file: !3, line: 52, column: 5)
!187 = !DILocation(line: 53, column: 26, scope: !185)
!188 = !DILocation(line: 53, column: 13, scope: !185)
!189 = !DILocation(line: 53, column: 44, scope: !185)
!190 = !DILocation(line: 55, column: 13, scope: !191)
!191 = distinct !DILexicalBlock(scope: !185, file: !3, line: 54, column: 9)
!192 = !DILocation(line: 57, column: 5, scope: !186)
!193 = !DILocation(line: 51, column: 32, scope: !181)
!194 = !DILocation(line: 51, column: 5, scope: !181)
!195 = distinct !{!195, !183, !196, !126}
!196 = !DILocation(line: 57, column: 5, scope: !178)
!197 = !DILocation(line: 59, column: 12, scope: !198)
!198 = distinct !DILexicalBlock(scope: !199, file: !3, line: 59, column: 5)
!199 = distinct !DILexicalBlock(scope: !141, file: !3, line: 59, column: 5)
!200 = !DILocation(line: 59, column: 14, scope: !198)
!201 = !DILocation(line: 59, column: 26, scope: !198)
!202 = !DILocation(line: 59, column: 29, scope: !198)
!203 = !DILocation(line: 59, column: 31, scope: !198)
!204 = !DILocation(line: 59, column: 5, scope: !198)
!205 = !DILocation(line: 61, column: 5, scope: !141)
!206 = distinct !DISubprogram(name: "ck_spinlock_dec_init", scope: !43, file: !43, line: 51, type: !101, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!207 = !DILocalVariable(name: "lock", arg: 1, scope: !206, file: !43, line: 51, type: !87)
!208 = !DILocation(line: 51, column: 46, scope: !206)
!209 = !DILocation(line: 54, column: 2, scope: !206)
!210 = !DILocation(line: 54, column: 8, scope: !206)
!211 = !DILocation(line: 54, column: 14, scope: !206)
!212 = !DILocation(line: 55, column: 2, scope: !206)
!213 = !DILocation(line: 56, column: 2, scope: !206)
!214 = distinct !DISubprogram(name: "ck_pr_fas_uint", scope: !215, file: !215, line: 306, type: !216, scopeLine: 306, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!215 = !DIFile(filename: "../ck/include/gcc/ppc64/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "8952bb109540f13c2aa63ce3890cafa9")
!216 = !DISubroutineType(types: !217)
!217 = !{!16, !19, !16}
!218 = !DILocalVariable(name: "target", arg: 1, scope: !214, file: !215, line: 306, type: !19)
!219 = !DILocation(line: 306, column: 1, scope: !214)
!220 = !DILocalVariable(name: "v", arg: 2, scope: !214, file: !215, line: 306, type: !16)
!221 = !DILocalVariable(name: "previous", scope: !214, file: !215, line: 306, type: !16)
!222 = !{i64 2147597697}
!223 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !224, file: !224, line: 122, type: !225, scopeLine: 122, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!224 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!225 = !DISubroutineType(types: !226)
!226 = !{null}
!227 = !DILocation(line: 122, column: 1, scope: !223)
!228 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !215, file: !215, line: 86, type: !225, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!229 = !DILocation(line: 86, column: 1, scope: !228)
!230 = !{i64 2147583850}
!231 = distinct !DISubprogram(name: "ck_pr_dec_uint_zero", scope: !224, file: !224, line: 753, type: !232, scopeLine: 753, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!232 = !DISubroutineType(types: !233)
!233 = !{null, !19, !234}
!234 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!235 = !DILocalVariable(name: "target", arg: 1, scope: !231, file: !224, line: 753, type: !19)
!236 = !DILocation(line: 753, column: 1, scope: !231)
!237 = !DILocalVariable(name: "zero", arg: 2, scope: !231, file: !224, line: 753, type: !234)
!238 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !215, file: !215, line: 111, type: !239, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!239 = !DISubroutineType(types: !240)
!240 = !{!16, !17}
!241 = !DILocalVariable(name: "target", arg: 1, scope: !238, file: !215, line: 111, type: !17)
!242 = !DILocation(line: 111, column: 1, scope: !238)
!243 = !DILocalVariable(name: "r", scope: !238, file: !215, line: 111, type: !16)
!244 = !{i64 2147586421}
!245 = distinct !DISubprogram(name: "ck_pr_stall", scope: !215, file: !215, line: 54, type: !225, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!246 = !DILocation(line: 57, column: 2, scope: !245)
!247 = !{i64 85417}
!248 = !DILocation(line: 59, column: 2, scope: !245)
!249 = distinct !DISubprogram(name: "ck_pr_dec_uint_is_zero", scope: !224, file: !224, line: 753, type: !250, scopeLine: 753, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!250 = !DISubroutineType(types: !251)
!251 = !{!13, !19}
!252 = !DILocalVariable(name: "target", arg: 1, scope: !249, file: !224, line: 753, type: !19)
!253 = !DILocation(line: 753, column: 1, scope: !249)
!254 = !DILocalVariable(name: "previous", scope: !249, file: !224, line: 753, type: !16)
!255 = !DILocalVariable(name: "punt", scope: !249, file: !224, line: 753, type: !16)
!256 = !DILocation(line: 753, column: 42, scope: !249)
!257 = distinct !{!257, !253, !253, !126}
!258 = distinct !DISubprogram(name: "ck_pr_cas_uint_value", scope: !215, file: !215, line: 278, type: !259, scopeLine: 278, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!259 = !DISubroutineType(types: !260)
!260 = !{!13, !19, !16, !16, !19}
!261 = !DILocalVariable(name: "target", arg: 1, scope: !258, file: !215, line: 278, type: !19)
!262 = !DILocation(line: 278, column: 1, scope: !258)
!263 = !DILocalVariable(name: "compare", arg: 2, scope: !258, file: !215, line: 278, type: !16)
!264 = !DILocalVariable(name: "set", arg: 3, scope: !258, file: !215, line: 278, type: !16)
!265 = !DILocalVariable(name: "value", arg: 4, scope: !258, file: !215, line: 278, type: !19)
!266 = !DILocalVariable(name: "previous", scope: !258, file: !215, line: 278, type: !16)
!267 = !{i64 2147593124}
!268 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !224, file: !224, line: 123, type: !225, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!269 = !DILocation(line: 123, column: 1, scope: !268)
!270 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !215, file: !215, line: 141, type: !271, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!271 = !DISubroutineType(types: !272)
!272 = !{null, !19, !16}
!273 = !DILocalVariable(name: "target", arg: 1, scope: !270, file: !215, line: 141, type: !19)
!274 = !DILocation(line: 141, column: 1, scope: !270)
!275 = !DILocalVariable(name: "v", arg: 2, scope: !270, file: !215, line: 141, type: !16)
!276 = !{i64 2147590128}
!277 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !215, file: !215, line: 87, type: !225, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!278 = !DILocation(line: 87, column: 1, scope: !277)
!279 = !{i64 2147584047}
!280 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !281, file: !281, line: 37, type: !225, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!281 = !DIFile(filename: "../ck/include/gcc/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!282 = !DILocation(line: 40, column: 2, scope: !280)
!283 = !{i64 141118}
!284 = !DILocation(line: 41, column: 2, scope: !280)
