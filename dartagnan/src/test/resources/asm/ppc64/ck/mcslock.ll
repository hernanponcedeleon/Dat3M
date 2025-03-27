; ModuleID = 'tests/mcslock.c'
source_filename = "tests/mcslock.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_spinlock_mcs = type { i32, ptr }

@lock = global ptr null, align 8, !dbg !0
@x = global i32 0, align 4, !dbg !33
@y = global i32 0, align 4, !dbg !36
@nodes = global ptr null, align 8, !dbg !55
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !38
@.str = private unnamed_addr constant [10 x i8] c"mcslock.c\00", align 1, !dbg !45
@.str.1 = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !50

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 !dbg !65 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %5 = load ptr, ptr %2, align 8, !dbg !73
  %6 = ptrtoint ptr %5 to i64, !dbg !74
  store i64 %6, ptr %3, align 8, !dbg !72
  %7 = load ptr, ptr @nodes, align 8, !dbg !77
  %8 = load i64, ptr %3, align 8, !dbg !78
  %9 = getelementptr inbounds %struct.ck_spinlock_mcs, ptr %7, i64 %8, !dbg !77
  store ptr %9, ptr %4, align 8, !dbg !76
  %10 = load ptr, ptr %4, align 8, !dbg !79
  call void @ck_spinlock_mcs_lock(ptr noundef @lock, ptr noundef %10), !dbg !80
  %11 = load i32, ptr @x, align 4, !dbg !81
  %12 = add nsw i32 %11, 1, !dbg !81
  store i32 %12, ptr @x, align 4, !dbg !81
  %13 = load i32, ptr @y, align 4, !dbg !82
  %14 = add nsw i32 %13, 1, !dbg !82
  store i32 %14, ptr @y, align 4, !dbg !82
  %15 = load ptr, ptr %4, align 8, !dbg !83
  call void @ck_spinlock_mcs_unlock(ptr noundef @lock, ptr noundef %15), !dbg !84
  ret ptr null, !dbg !85
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_mcs_lock(ptr noundef %0, ptr noundef %1) #0 !dbg !86 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = load ptr, ptr %4, align 8, !dbg !96
  %7 = getelementptr inbounds %struct.ck_spinlock_mcs, ptr %6, i32 0, i32 0, !dbg !97
  store i32 1, ptr %7, align 8, !dbg !98
  %8 = load ptr, ptr %4, align 8, !dbg !99
  %9 = getelementptr inbounds %struct.ck_spinlock_mcs, ptr %8, i32 0, i32 1, !dbg !100
  store ptr null, ptr %9, align 8, !dbg !101
  call void @ck_pr_fence_store_atomic(), !dbg !102
  %10 = load ptr, ptr %3, align 8, !dbg !103
  %11 = load ptr, ptr %4, align 8, !dbg !104
  %12 = call ptr @ck_pr_fas_ptr(ptr noundef %10, ptr noundef %11), !dbg !105
  store ptr %12, ptr %5, align 8, !dbg !106
  %13 = load ptr, ptr %5, align 8, !dbg !107
  %14 = icmp ne ptr %13, null, !dbg !109
  br i1 %14, label %15, label %26, !dbg !110

15:                                               ; preds = %2
  %16 = load ptr, ptr %5, align 8, !dbg !111
  %17 = getelementptr inbounds %struct.ck_spinlock_mcs, ptr %16, i32 0, i32 1, !dbg !111
  %18 = load ptr, ptr %4, align 8, !dbg !111
  call void @ck_pr_md_store_ptr(ptr noundef %17, ptr noundef %18), !dbg !111
  br label %19, !dbg !113

19:                                               ; preds = %24, %15
  %20 = load ptr, ptr %4, align 8, !dbg !114
  %21 = getelementptr inbounds %struct.ck_spinlock_mcs, ptr %20, i32 0, i32 0, !dbg !114
  %22 = call i32 @ck_pr_md_load_uint(ptr noundef %21), !dbg !114
  %23 = icmp eq i32 %22, 1, !dbg !115
  br i1 %23, label %24, label %25, !dbg !113

24:                                               ; preds = %19
  call void @ck_pr_stall(), !dbg !116
  br label %19, !dbg !113, !llvm.loop !117

25:                                               ; preds = %19
  br label %26, !dbg !120

26:                                               ; preds = %25, %2
  call void @ck_pr_fence_lock(), !dbg !121
  ret void, !dbg !122
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_mcs_unlock(ptr noundef %0, ptr noundef %1) #0 !dbg !123 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  call void @ck_pr_fence_unlock(), !dbg !130
  %6 = load ptr, ptr %4, align 8, !dbg !131
  %7 = getelementptr inbounds %struct.ck_spinlock_mcs, ptr %6, i32 0, i32 1, !dbg !131
  %8 = call ptr @ck_pr_md_load_ptr(ptr noundef %7), !dbg !131
  store ptr %8, ptr %5, align 8, !dbg !132
  %9 = load ptr, ptr %5, align 8, !dbg !133
  %10 = icmp eq ptr %9, null, !dbg !135
  br i1 %10, label %11, label %33, !dbg !136

11:                                               ; preds = %2
  %12 = load ptr, ptr %3, align 8, !dbg !137
  %13 = call ptr @ck_pr_md_load_ptr(ptr noundef %12), !dbg !137
  %14 = load ptr, ptr %4, align 8, !dbg !140
  %15 = icmp eq ptr %13, %14, !dbg !141
  br i1 %15, label %16, label %23, !dbg !142

16:                                               ; preds = %11
  %17 = load ptr, ptr %3, align 8, !dbg !143
  %18 = load ptr, ptr %4, align 8, !dbg !144
  %19 = call zeroext i1 @ck_pr_cas_ptr(ptr noundef %17, ptr noundef %18, ptr noundef null), !dbg !145
  %20 = zext i1 %19 to i32, !dbg !145
  %21 = icmp eq i32 %20, 1, !dbg !146
  br i1 %21, label %22, label %23, !dbg !147

22:                                               ; preds = %16
  br label %36, !dbg !148

23:                                               ; preds = %16, %11
  br label %24, !dbg !150

24:                                               ; preds = %31, %23
  %25 = load ptr, ptr %4, align 8, !dbg !151
  %26 = getelementptr inbounds %struct.ck_spinlock_mcs, ptr %25, i32 0, i32 1, !dbg !151
  %27 = call ptr @ck_pr_md_load_ptr(ptr noundef %26), !dbg !151
  store ptr %27, ptr %5, align 8, !dbg !155
  %28 = load ptr, ptr %5, align 8, !dbg !156
  %29 = icmp ne ptr %28, null, !dbg !158
  br i1 %29, label %30, label %31, !dbg !159

30:                                               ; preds = %24
  br label %32, !dbg !160

31:                                               ; preds = %24
  call void @ck_pr_stall(), !dbg !161
  br label %24, !dbg !162, !llvm.loop !163

32:                                               ; preds = %30
  br label %33, !dbg !166

33:                                               ; preds = %32, %2
  %34 = load ptr, ptr %5, align 8, !dbg !167
  %35 = getelementptr inbounds %struct.ck_spinlock_mcs, ptr %34, i32 0, i32 0, !dbg !167
  call void @ck_pr_md_store_uint(ptr noundef %35, i32 noundef 0), !dbg !167
  br label %36, !dbg !168

36:                                               ; preds = %33, %22
  ret void, !dbg !169
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 !dbg !170 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x ptr], align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %4 = call ptr @malloc(i64 noundef 16) #5, !dbg !202
  store ptr %4, ptr @nodes, align 8, !dbg !203
  %5 = load ptr, ptr @nodes, align 8, !dbg !204
  %6 = icmp eq ptr %5, null, !dbg !206
  br i1 %6, label %7, label %8, !dbg !207

7:                                                ; preds = %0
  call void @exit(i32 noundef 1) #6, !dbg !208
  unreachable, !dbg !208

8:                                                ; preds = %0
  store ptr null, ptr @lock, align 8, !dbg !210
  store i32 0, ptr %3, align 4, !dbg !211
  br label %9, !dbg !213

9:                                                ; preds = %24, %8
  %10 = load i32, ptr %3, align 4, !dbg !214
  %11 = icmp slt i32 %10, 2, !dbg !216
  br i1 %11, label %12, label %27, !dbg !217

12:                                               ; preds = %9
  %13 = load i32, ptr %3, align 4, !dbg !218
  %14 = sext i32 %13 to i64, !dbg !221
  %15 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %14, !dbg !221
  %16 = load i32, ptr %3, align 4, !dbg !222
  %17 = sext i32 %16 to i64, !dbg !223
  %18 = inttoptr i64 %17 to ptr, !dbg !224
  %19 = call i32 @pthread_create(ptr noundef %15, ptr noundef null, ptr noundef @run, ptr noundef %18), !dbg !225
  %20 = icmp ne i32 %19, 0, !dbg !226
  br i1 %20, label %21, label %23, !dbg !227

21:                                               ; preds = %12
  %22 = load ptr, ptr @nodes, align 8, !dbg !228
  call void @free(ptr noundef %22), !dbg !230
  call void @exit(i32 noundef 1) #6, !dbg !231
  unreachable, !dbg !231

23:                                               ; preds = %12
  br label %24, !dbg !232

24:                                               ; preds = %23
  %25 = load i32, ptr %3, align 4, !dbg !233
  %26 = add nsw i32 %25, 1, !dbg !233
  store i32 %26, ptr %3, align 4, !dbg !233
  br label %9, !dbg !234, !llvm.loop !235

27:                                               ; preds = %9
  store i32 0, ptr %3, align 4, !dbg !237
  br label %28, !dbg !239

28:                                               ; preds = %41, %27
  %29 = load i32, ptr %3, align 4, !dbg !240
  %30 = icmp slt i32 %29, 2, !dbg !242
  br i1 %30, label %31, label %44, !dbg !243

31:                                               ; preds = %28
  %32 = load i32, ptr %3, align 4, !dbg !244
  %33 = sext i32 %32 to i64, !dbg !247
  %34 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %33, !dbg !247
  %35 = load ptr, ptr %34, align 8, !dbg !247
  %36 = call i32 @"\01_pthread_join"(ptr noundef %35, ptr noundef null), !dbg !248
  %37 = icmp ne i32 %36, 0, !dbg !249
  br i1 %37, label %38, label %40, !dbg !250

38:                                               ; preds = %31
  %39 = load ptr, ptr @nodes, align 8, !dbg !251
  call void @free(ptr noundef %39), !dbg !253
  call void @exit(i32 noundef 1) #6, !dbg !254
  unreachable, !dbg !254

40:                                               ; preds = %31
  br label %41, !dbg !255

41:                                               ; preds = %40
  %42 = load i32, ptr %3, align 4, !dbg !256
  %43 = add nsw i32 %42, 1, !dbg !256
  store i32 %43, ptr %3, align 4, !dbg !256
  br label %28, !dbg !257, !llvm.loop !258

44:                                               ; preds = %28
  %45 = load i32, ptr @x, align 4, !dbg !260
  %46 = icmp eq i32 %45, 2, !dbg !260
  br i1 %46, label %47, label %50, !dbg !260

47:                                               ; preds = %44
  %48 = load i32, ptr @y, align 4, !dbg !260
  %49 = icmp eq i32 %48, 2, !dbg !260
  br label %50

50:                                               ; preds = %47, %44
  %51 = phi i1 [ false, %44 ], [ %49, %47 ], !dbg !261
  %52 = xor i1 %51, true, !dbg !260
  %53 = zext i1 %52 to i32, !dbg !260
  %54 = sext i32 %53 to i64, !dbg !260
  %55 = icmp ne i64 %54, 0, !dbg !260
  br i1 %55, label %56, label %58, !dbg !260

56:                                               ; preds = %50
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 63, ptr noundef @.str.1) #7, !dbg !260
  unreachable, !dbg !260

57:                                               ; No predecessors!
  br label %59, !dbg !260

58:                                               ; preds = %50
  br label %59, !dbg !260

59:                                               ; preds = %58, %57
  %60 = load ptr, ptr @nodes, align 8, !dbg !262
  call void @free(ptr noundef %60), !dbg !263
  ret i32 0, !dbg !264
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef) #2

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare void @free(ptr noundef) #3

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #3

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #4

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_store_atomic() #0 !dbg !265 {
  call void @ck_pr_fence_strict_store_atomic(), !dbg !269
  ret void, !dbg !269
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_pr_fas_ptr(ptr noundef %0, ptr noundef %1) #0 !dbg !270 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = load ptr, ptr %3, align 8, !dbg !275
  %7 = load ptr, ptr %4, align 8, !dbg !275
  %8 = call ptr asm sideeffect "1:;ldarx $0, 0, $1;stdcx. $2, 0, $1;bne- 1b;", "=&r,r,r,~{memory},~{cc}"(ptr %6, ptr %7) #8, !dbg !275, !srcloc !278
  store ptr %8, ptr %5, align 8, !dbg !275
  %9 = load ptr, ptr %5, align 8, !dbg !275
  ret ptr %9, !dbg !275
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_md_store_ptr(ptr noundef %0, ptr noundef %1) #0 !dbg !279 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %3, align 8, !dbg !285
  %6 = load ptr, ptr %4, align 8, !dbg !285
  call void asm sideeffect "std $1, $0", "=*m,r,~{memory}"(ptr elementtype(i64) %5, ptr %6) #8, !dbg !285, !srcloc !287
  ret void, !dbg !285
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !288 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !292
  %5 = call i32 asm sideeffect "lwz $0, $1", "=r,*m,~{memory}"(ptr elementtype(i32) %4) #8, !dbg !292, !srcloc !294
  store i32 %5, ptr %3, align 4, !dbg !292
  %6 = load i32, ptr %3, align 4, !dbg !292
  ret i32 %6, !dbg !292
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_stall() #0 !dbg !295 {
  call void asm sideeffect "or 1, 1, 1;or 2, 2, 2;", "~{memory}"() #8, !dbg !296, !srcloc !297
  ret void, !dbg !298
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_lock() #0 !dbg !299 {
  call void @ck_pr_fence_strict_lock(), !dbg !300
  ret void, !dbg !300
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_store_atomic() #0 !dbg !301 {
  call void asm sideeffect "lwsync", "~{memory}"() #8, !dbg !302, !srcloc !303
  ret void, !dbg !302
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_lock() #0 !dbg !304 {
  call void asm sideeffect "lwsync", "~{memory}"() #8, !dbg !305, !srcloc !306
  ret void, !dbg !305
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_unlock() #0 !dbg !307 {
  call void @ck_pr_fence_strict_unlock(), !dbg !308
  ret void, !dbg !308
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_pr_md_load_ptr(ptr noundef %0) #0 !dbg !309 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !313
  %5 = call ptr asm sideeffect "ld $0, $1", "=r,*m,~{memory}"(ptr elementtype(i64) %4) #8, !dbg !313, !srcloc !315
  store ptr %5, ptr %3, align 8, !dbg !313
  %6 = load ptr, ptr %3, align 8, !dbg !313
  ret ptr %6, !dbg !313
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_pr_cas_ptr(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 !dbg !316 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store ptr %2, ptr %6, align 8
  %8 = load ptr, ptr %4, align 8, !dbg !328
  %9 = load ptr, ptr %6, align 8, !dbg !329
  %10 = load ptr, ptr %5, align 8, !dbg !330
  %11 = call ptr asm sideeffect "1:;ldarx $0, 0, $1;cmpd  0, $0, $3;bne-  2f;stdcx. $2, 0, $1;bne-  1b;2:", "=&r,r,r,r,~{memory},~{cc}"(ptr %8, ptr %9, ptr %10) #8, !dbg !331, !srcloc !332
  store ptr %11, ptr %7, align 8, !dbg !331
  %12 = load ptr, ptr %7, align 8, !dbg !333
  %13 = load ptr, ptr %5, align 8, !dbg !334
  %14 = icmp eq ptr %12, %13, !dbg !335
  ret i1 %14, !dbg !336
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !337 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load ptr, ptr %3, align 8, !dbg !341
  %6 = load i32, ptr %4, align 4, !dbg !341
  call void asm sideeffect "stw $1, $0", "=*m,r,~{memory}"(ptr elementtype(i32) %5, i32 %6) #8, !dbg !341, !srcloc !343
  ret void, !dbg !341
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_unlock() #0 !dbg !344 {
  call void asm sideeffect "lwsync", "~{memory}"() #8, !dbg !345, !srcloc !346
  ret void, !dbg !345
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #4 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #5 = { allocsize(0) }
attributes #6 = { noreturn }
attributes #7 = { cold noreturn }
attributes #8 = { nounwind }

!llvm.module.flags = !{!57, !58, !59, !60, !61, !62, !63}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!64}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 10, type: !11, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !32, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!3 = !DIFile(filename: "tests/mcslock.c", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "4d52312d3fd6710159db4cbd2182b2bc")
!4 = !{!5, !6, !11, !19, !23, !27, !13, !29, !31}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !7, line: 32, baseType: !8)
!7 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_types/_intptr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e478ba47270923b1cca6659f19f02db1")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_intptr_t", file: !9, line: 40, baseType: !10)
!9 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/arm/_types.h", directory: "", checksumkind: CSK_MD5, checksum: "b270144f57ae258d0ce80b8f87be068c")
!10 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_mcs_t", file: !12, line: 42, baseType: !13)
!12 = !DIFile(filename: "include/spinlock/mcs.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "027f57d568cbbfbb353298638ea153e7")
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_mcs", file: !12, line: 38, size: 128, elements: !15)
!15 = !{!16, !18}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "locked", scope: !14, file: !12, line: 39, baseType: !17, size: 32)
!17 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !14, file: !12, line: 40, baseType: !13, size: 64, offset: 64)
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !20, line: 50, baseType: !21)
!20 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_types/_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "f7981334d28e0c246f35cd24042aa2a4")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_size_t", file: !9, line: 87, baseType: !22)
!22 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !25, line: 31, baseType: !26)
!25 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/_types/_uint64_t.h", directory: "", checksumkind: CSK_MD5, checksum: "77fc5e91653260959605f129691cf9b1")
!26 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!28 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !17)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!30 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!32 = !{!0, !33, !36, !38, !45, !50, !55}
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 13, type: !35, isLocal: false, isDefinition: true)
!35 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 13, type: !35, isLocal: false, isDefinition: true)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 40, elements: !43)
!41 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !42)
!42 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!43 = !{!44}
!44 = !DISubrange(count: 5)
!45 = !DIGlobalVariableExpression(var: !46, expr: !DIExpression())
!46 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !47, isLocal: true, isDefinition: true)
!47 = !DICompositeType(tag: DW_TAG_array_type, baseType: !42, size: 80, elements: !48)
!48 = !{!49}
!49 = !DISubrange(count: 10)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !52, isLocal: true, isDefinition: true)
!52 = !DICompositeType(tag: DW_TAG_array_type, baseType: !42, size: 248, elements: !53)
!53 = !{!54}
!54 = !DISubrange(count: 31)
!55 = !DIGlobalVariableExpression(var: !56, expr: !DIExpression())
!56 = distinct !DIGlobalVariable(name: "nodes", scope: !2, file: !3, line: 11, type: !11, isLocal: false, isDefinition: true)
!57 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 0]}
!58 = !{i32 7, !"Dwarf Version", i32 5}
!59 = !{i32 2, !"Debug Info Version", i32 3}
!60 = !{i32 1, !"wchar_size", i32 4}
!61 = !{i32 8, !"PIC Level", i32 2}
!62 = !{i32 7, !"uwtable", i32 1}
!63 = !{i32 7, !"frame-pointer", i32 1}
!64 = !{!"Homebrew clang version 19.1.7"}
!65 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 15, type: !66, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!66 = !DISubroutineType(types: !67)
!67 = !{!5, !5}
!68 = !{}
!69 = !DILocalVariable(name: "arg", arg: 1, scope: !65, file: !3, line: 15, type: !5)
!70 = !DILocation(line: 15, column: 17, scope: !65)
!71 = !DILocalVariable(name: "tid", scope: !65, file: !3, line: 18, type: !6)
!72 = !DILocation(line: 18, column: 14, scope: !65)
!73 = !DILocation(line: 18, column: 31, scope: !65)
!74 = !DILocation(line: 18, column: 21, scope: !65)
!75 = !DILocalVariable(name: "thread_node", scope: !65, file: !3, line: 20, type: !11)
!76 = !DILocation(line: 20, column: 23, scope: !65)
!77 = !DILocation(line: 20, column: 38, scope: !65)
!78 = !DILocation(line: 20, column: 44, scope: !65)
!79 = !DILocation(line: 22, column: 33, scope: !65)
!80 = !DILocation(line: 22, column: 5, scope: !65)
!81 = !DILocation(line: 24, column: 6, scope: !65)
!82 = !DILocation(line: 25, column: 6, scope: !65)
!83 = !DILocation(line: 27, column: 35, scope: !65)
!84 = !DILocation(line: 27, column: 5, scope: !65)
!85 = !DILocation(line: 29, column: 5, scope: !65)
!86 = distinct !DISubprogram(name: "ck_spinlock_mcs_lock", scope: !12, file: !12, line: 82, type: !87, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!87 = !DISubroutineType(types: !88)
!88 = !{null, !89, !13}
!89 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!90 = !DILocalVariable(name: "queue", arg: 1, scope: !86, file: !12, line: 82, type: !89)
!91 = !DILocation(line: 82, column: 47, scope: !86)
!92 = !DILocalVariable(name: "node", arg: 2, scope: !86, file: !12, line: 83, type: !13)
!93 = !DILocation(line: 83, column: 29, scope: !86)
!94 = !DILocalVariable(name: "previous", scope: !86, file: !12, line: 85, type: !13)
!95 = !DILocation(line: 85, column: 26, scope: !86)
!96 = !DILocation(line: 91, column: 2, scope: !86)
!97 = !DILocation(line: 91, column: 8, scope: !86)
!98 = !DILocation(line: 91, column: 15, scope: !86)
!99 = !DILocation(line: 92, column: 2, scope: !86)
!100 = !DILocation(line: 92, column: 8, scope: !86)
!101 = !DILocation(line: 92, column: 13, scope: !86)
!102 = !DILocation(line: 93, column: 2, scope: !86)
!103 = !DILocation(line: 100, column: 27, scope: !86)
!104 = !DILocation(line: 100, column: 34, scope: !86)
!105 = !DILocation(line: 100, column: 13, scope: !86)
!106 = !DILocation(line: 100, column: 11, scope: !86)
!107 = !DILocation(line: 101, column: 6, scope: !108)
!108 = distinct !DILexicalBlock(scope: !86, file: !12, line: 101, column: 6)
!109 = !DILocation(line: 101, column: 15, scope: !108)
!110 = !DILocation(line: 101, column: 6, scope: !86)
!111 = !DILocation(line: 106, column: 3, scope: !112)
!112 = distinct !DILexicalBlock(scope: !108, file: !12, line: 101, column: 24)
!113 = !DILocation(line: 107, column: 3, scope: !112)
!114 = !DILocation(line: 107, column: 10, scope: !112)
!115 = !DILocation(line: 107, column: 41, scope: !112)
!116 = !DILocation(line: 108, column: 4, scope: !112)
!117 = distinct !{!117, !113, !118, !119}
!118 = !DILocation(line: 108, column: 16, scope: !112)
!119 = !{!"llvm.loop.mustprogress"}
!120 = !DILocation(line: 109, column: 2, scope: !112)
!121 = !DILocation(line: 111, column: 2, scope: !86)
!122 = !DILocation(line: 112, column: 2, scope: !86)
!123 = distinct !DISubprogram(name: "ck_spinlock_mcs_unlock", scope: !12, file: !12, line: 116, type: !87, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!124 = !DILocalVariable(name: "queue", arg: 1, scope: !123, file: !12, line: 116, type: !89)
!125 = !DILocation(line: 116, column: 49, scope: !123)
!126 = !DILocalVariable(name: "node", arg: 2, scope: !123, file: !12, line: 117, type: !13)
!127 = !DILocation(line: 117, column: 29, scope: !123)
!128 = !DILocalVariable(name: "next", scope: !123, file: !12, line: 119, type: !13)
!129 = !DILocation(line: 119, column: 26, scope: !123)
!130 = !DILocation(line: 121, column: 2, scope: !123)
!131 = !DILocation(line: 123, column: 9, scope: !123)
!132 = !DILocation(line: 123, column: 7, scope: !123)
!133 = !DILocation(line: 124, column: 6, scope: !134)
!134 = distinct !DILexicalBlock(scope: !123, file: !12, line: 124, column: 6)
!135 = !DILocation(line: 124, column: 11, scope: !134)
!136 = !DILocation(line: 124, column: 6, scope: !123)
!137 = !DILocation(line: 130, column: 7, scope: !138)
!138 = distinct !DILexicalBlock(scope: !139, file: !12, line: 130, column: 7)
!139 = distinct !DILexicalBlock(scope: !134, file: !12, line: 124, column: 20)
!140 = !DILocation(line: 130, column: 32, scope: !138)
!141 = !DILocation(line: 130, column: 29, scope: !138)
!142 = !DILocation(line: 130, column: 37, scope: !138)
!143 = !DILocation(line: 131, column: 21, scope: !138)
!144 = !DILocation(line: 131, column: 28, scope: !138)
!145 = !DILocation(line: 131, column: 7, scope: !138)
!146 = !DILocation(line: 131, column: 40, scope: !138)
!147 = !DILocation(line: 130, column: 7, scope: !139)
!148 = !DILocation(line: 132, column: 4, scope: !149)
!149 = distinct !DILexicalBlock(scope: !138, file: !12, line: 131, column: 49)
!150 = !DILocation(line: 141, column: 3, scope: !139)
!151 = !DILocation(line: 142, column: 11, scope: !152)
!152 = distinct !DILexicalBlock(scope: !153, file: !12, line: 141, column: 12)
!153 = distinct !DILexicalBlock(scope: !154, file: !12, line: 141, column: 3)
!154 = distinct !DILexicalBlock(scope: !139, file: !12, line: 141, column: 3)
!155 = !DILocation(line: 142, column: 9, scope: !152)
!156 = !DILocation(line: 143, column: 8, scope: !157)
!157 = distinct !DILexicalBlock(scope: !152, file: !12, line: 143, column: 8)
!158 = !DILocation(line: 143, column: 13, scope: !157)
!159 = !DILocation(line: 143, column: 8, scope: !152)
!160 = !DILocation(line: 144, column: 5, scope: !157)
!161 = !DILocation(line: 146, column: 4, scope: !152)
!162 = !DILocation(line: 141, column: 3, scope: !153)
!163 = distinct !{!163, !164, !165}
!164 = !DILocation(line: 141, column: 3, scope: !154)
!165 = !DILocation(line: 147, column: 3, scope: !154)
!166 = !DILocation(line: 148, column: 2, scope: !139)
!167 = !DILocation(line: 151, column: 2, scope: !123)
!168 = !DILocation(line: 152, column: 2, scope: !123)
!169 = !DILocation(line: 153, column: 1, scope: !123)
!170 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 32, type: !171, scopeLine: 33, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!171 = !DISubroutineType(types: !172)
!172 = !{!35}
!173 = !DILocalVariable(name: "threads", scope: !170, file: !3, line: 34, type: !174)
!174 = !DICompositeType(tag: DW_TAG_array_type, baseType: !175, size: 128, elements: !197)
!175 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !176, line: 31, baseType: !177)
!176 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!177 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !178, line: 118, baseType: !179)
!178 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!179 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !180, size: 64)
!180 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !178, line: 103, size: 65536, elements: !181)
!181 = !{!182, !183, !193}
!182 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !180, file: !178, line: 104, baseType: !10, size: 64)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !180, file: !178, line: 105, baseType: !184, size: 64, offset: 64)
!184 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !185, size: 64)
!185 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !178, line: 57, size: 192, elements: !186)
!186 = !{!187, !191, !192}
!187 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !185, file: !178, line: 58, baseType: !188, size: 64)
!188 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !189, size: 64)
!189 = !DISubroutineType(types: !190)
!190 = !{null, !5}
!191 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !185, file: !178, line: 59, baseType: !5, size: 64, offset: 64)
!192 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !185, file: !178, line: 60, baseType: !184, size: 64, offset: 128)
!193 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !180, file: !178, line: 106, baseType: !194, size: 65408, offset: 128)
!194 = !DICompositeType(tag: DW_TAG_array_type, baseType: !42, size: 65408, elements: !195)
!195 = !{!196}
!196 = !DISubrange(count: 8176)
!197 = !{!198}
!198 = !DISubrange(count: 2)
!199 = !DILocation(line: 34, column: 15, scope: !170)
!200 = !DILocalVariable(name: "i", scope: !170, file: !3, line: 35, type: !35)
!201 = !DILocation(line: 35, column: 9, scope: !170)
!202 = !DILocation(line: 37, column: 32, scope: !170)
!203 = !DILocation(line: 37, column: 11, scope: !170)
!204 = !DILocation(line: 38, column: 9, scope: !205)
!205 = distinct !DILexicalBlock(scope: !170, file: !3, line: 38, column: 9)
!206 = !DILocation(line: 38, column: 15, scope: !205)
!207 = !DILocation(line: 38, column: 9, scope: !170)
!208 = !DILocation(line: 40, column: 9, scope: !209)
!209 = distinct !DILexicalBlock(scope: !205, file: !3, line: 39, column: 5)
!210 = !DILocation(line: 43, column: 10, scope: !170)
!211 = !DILocation(line: 45, column: 12, scope: !212)
!212 = distinct !DILexicalBlock(scope: !170, file: !3, line: 45, column: 5)
!213 = !DILocation(line: 45, column: 10, scope: !212)
!214 = !DILocation(line: 45, column: 17, scope: !215)
!215 = distinct !DILexicalBlock(scope: !212, file: !3, line: 45, column: 5)
!216 = !DILocation(line: 45, column: 19, scope: !215)
!217 = !DILocation(line: 45, column: 5, scope: !212)
!218 = !DILocation(line: 47, column: 37, scope: !219)
!219 = distinct !DILexicalBlock(scope: !220, file: !3, line: 47, column: 13)
!220 = distinct !DILexicalBlock(scope: !215, file: !3, line: 46, column: 5)
!221 = !DILocation(line: 47, column: 29, scope: !219)
!222 = !DILocation(line: 47, column: 68, scope: !219)
!223 = !DILocation(line: 47, column: 60, scope: !219)
!224 = !DILocation(line: 47, column: 52, scope: !219)
!225 = !DILocation(line: 47, column: 13, scope: !219)
!226 = !DILocation(line: 47, column: 71, scope: !219)
!227 = !DILocation(line: 47, column: 13, scope: !220)
!228 = !DILocation(line: 49, column: 18, scope: !229)
!229 = distinct !DILexicalBlock(scope: !219, file: !3, line: 48, column: 9)
!230 = !DILocation(line: 49, column: 13, scope: !229)
!231 = !DILocation(line: 50, column: 13, scope: !229)
!232 = !DILocation(line: 52, column: 5, scope: !220)
!233 = !DILocation(line: 45, column: 32, scope: !215)
!234 = !DILocation(line: 45, column: 5, scope: !215)
!235 = distinct !{!235, !217, !236, !119}
!236 = !DILocation(line: 52, column: 5, scope: !212)
!237 = !DILocation(line: 54, column: 12, scope: !238)
!238 = distinct !DILexicalBlock(scope: !170, file: !3, line: 54, column: 5)
!239 = !DILocation(line: 54, column: 10, scope: !238)
!240 = !DILocation(line: 54, column: 17, scope: !241)
!241 = distinct !DILexicalBlock(scope: !238, file: !3, line: 54, column: 5)
!242 = !DILocation(line: 54, column: 19, scope: !241)
!243 = !DILocation(line: 54, column: 5, scope: !238)
!244 = !DILocation(line: 56, column: 34, scope: !245)
!245 = distinct !DILexicalBlock(scope: !246, file: !3, line: 56, column: 13)
!246 = distinct !DILexicalBlock(scope: !241, file: !3, line: 55, column: 5)
!247 = !DILocation(line: 56, column: 26, scope: !245)
!248 = !DILocation(line: 56, column: 13, scope: !245)
!249 = !DILocation(line: 56, column: 44, scope: !245)
!250 = !DILocation(line: 56, column: 13, scope: !246)
!251 = !DILocation(line: 58, column: 18, scope: !252)
!252 = distinct !DILexicalBlock(scope: !245, file: !3, line: 57, column: 9)
!253 = !DILocation(line: 58, column: 13, scope: !252)
!254 = !DILocation(line: 59, column: 13, scope: !252)
!255 = !DILocation(line: 61, column: 5, scope: !246)
!256 = !DILocation(line: 54, column: 32, scope: !241)
!257 = !DILocation(line: 54, column: 5, scope: !241)
!258 = distinct !{!258, !243, !259, !119}
!259 = !DILocation(line: 61, column: 5, scope: !238)
!260 = !DILocation(line: 63, column: 5, scope: !170)
!261 = !DILocation(line: 0, scope: !170)
!262 = !DILocation(line: 65, column: 10, scope: !170)
!263 = !DILocation(line: 65, column: 5, scope: !170)
!264 = !DILocation(line: 67, column: 5, scope: !170)
!265 = distinct !DISubprogram(name: "ck_pr_fence_store_atomic", scope: !266, file: !266, line: 108, type: !267, scopeLine: 108, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!266 = !DIFile(filename: "include/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "cffbc3bc631aa31cdde49d8ca6470a32")
!267 = !DISubroutineType(types: !268)
!268 = !{null}
!269 = !DILocation(line: 108, column: 1, scope: !265)
!270 = distinct !DISubprogram(name: "ck_pr_fas_ptr", scope: !271, file: !271, line: 306, type: !272, scopeLine: 306, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!271 = !DIFile(filename: "include/gcc/ppc64/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "1c5aecf7376064f28c732d8a93471464")
!272 = !DISubroutineType(types: !273)
!273 = !{!5, !5, !5}
!274 = !DILocalVariable(name: "target", arg: 1, scope: !270, file: !271, line: 306, type: !5)
!275 = !DILocation(line: 306, column: 1, scope: !270)
!276 = !DILocalVariable(name: "v", arg: 2, scope: !270, file: !271, line: 306, type: !5)
!277 = !DILocalVariable(name: "previous", scope: !270, file: !271, line: 306, type: !5)
!278 = !{i64 2147776029}
!279 = distinct !DISubprogram(name: "ck_pr_md_store_ptr", scope: !271, file: !271, line: 135, type: !280, scopeLine: 135, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!280 = !DISubroutineType(types: !281)
!281 = !{null, !5, !282}
!282 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !283, size: 64)
!283 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!284 = !DILocalVariable(name: "target", arg: 1, scope: !279, file: !271, line: 135, type: !5)
!285 = !DILocation(line: 135, column: 1, scope: !279)
!286 = !DILocalVariable(name: "v", arg: 2, scope: !279, file: !271, line: 135, type: !282)
!287 = !{i64 2147767454}
!288 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !271, file: !271, line: 113, type: !289, scopeLine: 113, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!289 = !DISubroutineType(types: !290)
!290 = !{!17, !27}
!291 = !DILocalVariable(name: "target", arg: 1, scope: !288, file: !271, line: 113, type: !27)
!292 = !DILocation(line: 113, column: 1, scope: !288)
!293 = !DILocalVariable(name: "r", scope: !288, file: !271, line: 113, type: !17)
!294 = !{i64 2147765628}
!295 = distinct !DISubprogram(name: "ck_pr_stall", scope: !271, file: !271, line: 56, type: !267, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!296 = !DILocation(line: 59, column: 2, scope: !295)
!297 = !{i64 264661}
!298 = !DILocation(line: 61, column: 2, scope: !295)
!299 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !266, file: !266, line: 118, type: !267, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!300 = !DILocation(line: 118, column: 1, scope: !299)
!301 = distinct !DISubprogram(name: "ck_pr_fence_strict_store_atomic", scope: !271, file: !271, line: 78, type: !267, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!302 = !DILocation(line: 78, column: 1, scope: !301)
!303 = !{i64 2147761079}
!304 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !271, file: !271, line: 88, type: !267, scopeLine: 88, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!305 = !DILocation(line: 88, column: 1, scope: !304)
!306 = !{i64 2147763093}
!307 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !266, file: !266, line: 119, type: !267, scopeLine: 119, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!308 = !DILocation(line: 119, column: 1, scope: !307)
!309 = distinct !DISubprogram(name: "ck_pr_md_load_ptr", scope: !271, file: !271, line: 105, type: !310, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!310 = !DISubroutineType(types: !311)
!311 = !{!5, !282}
!312 = !DILocalVariable(name: "target", arg: 1, scope: !309, file: !271, line: 105, type: !282)
!313 = !DILocation(line: 105, column: 1, scope: !309)
!314 = !DILocalVariable(name: "r", scope: !309, file: !271, line: 105, type: !5)
!315 = !{i64 2147763622}
!316 = distinct !DISubprogram(name: "ck_pr_cas_ptr", scope: !271, file: !271, line: 220, type: !317, scopeLine: 221, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!317 = !DISubroutineType(types: !318)
!318 = !{!319, !5, !5, !5}
!319 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!320 = !DILocalVariable(name: "target", arg: 1, scope: !316, file: !271, line: 220, type: !5)
!321 = !DILocation(line: 220, column: 21, scope: !316)
!322 = !DILocalVariable(name: "compare", arg: 2, scope: !316, file: !271, line: 220, type: !5)
!323 = !DILocation(line: 220, column: 35, scope: !316)
!324 = !DILocalVariable(name: "set", arg: 3, scope: !316, file: !271, line: 220, type: !5)
!325 = !DILocation(line: 220, column: 50, scope: !316)
!326 = !DILocalVariable(name: "previous", scope: !316, file: !271, line: 222, type: !5)
!327 = !DILocation(line: 222, column: 8, scope: !316)
!328 = !DILocation(line: 232, column: 42, scope: !316)
!329 = !DILocation(line: 233, column: 14, scope: !316)
!330 = !DILocation(line: 234, column: 42, scope: !316)
!331 = !DILocation(line: 224, column: 9, scope: !316)
!332 = !{i64 268855}
!333 = !DILocation(line: 237, column: 17, scope: !316)
!334 = !DILocation(line: 237, column: 29, scope: !316)
!335 = !DILocation(line: 237, column: 26, scope: !316)
!336 = !DILocation(line: 237, column: 9, scope: !316)
!337 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !271, file: !271, line: 143, type: !338, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!338 = !DISubroutineType(types: !339)
!339 = !{null, !31, !17}
!340 = !DILocalVariable(name: "target", arg: 1, scope: !337, file: !271, line: 143, type: !31)
!341 = !DILocation(line: 143, column: 1, scope: !337)
!342 = !DILocalVariable(name: "v", arg: 2, scope: !337, file: !271, line: 143, type: !17)
!343 = !{i64 2147769275}
!344 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !271, file: !271, line: 89, type: !267, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!345 = !DILocation(line: 89, column: 1, scope: !344)
!346 = !{i64 2147763290}
