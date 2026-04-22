; ModuleID = 'benchmarks/ck/mcslock.c'
source_filename = "benchmarks/ck/mcslock.c"
target datalayout = "E-m:e-Fi64-i64:64-i128:128-n32:64-S128-v256:256:256-v512:512:512"
target triple = "ppc64-pc-linux-gnu"

%struct.ck_spinlock_mcs = type { i32, ptr }

@lock = dso_local global ptr null, align 8, !dbg !0
@x = dso_local global i32 0, align 4, !dbg !32
@y = dso_local global i32 0, align 4, !dbg !34
@nodes = dso_local global ptr null, align 8, !dbg !53
@.str = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [24 x i8] c"benchmarks/ck/mcslock.c\00", align 1, !dbg !42
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !47

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @run(ptr noundef %0) #0 !dbg !63 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !67, !DIExpression(), !68)
    #dbg_declare(ptr %3, !69, !DIExpression(), !70)
  %5 = load ptr, ptr %2, align 8, !dbg !71
  %6 = ptrtoint ptr %5 to i64, !dbg !72
  store i64 %6, ptr %3, align 8, !dbg !70
    #dbg_declare(ptr %4, !73, !DIExpression(), !74)
  %7 = load ptr, ptr @nodes, align 8, !dbg !75
  %8 = load i64, ptr %3, align 8, !dbg !76
  %9 = getelementptr inbounds %struct.ck_spinlock_mcs, ptr %7, i64 %8, !dbg !75
  store ptr %9, ptr %4, align 8, !dbg !74
  %10 = load ptr, ptr %4, align 8, !dbg !77
  call void @ck_spinlock_mcs_lock(ptr noundef @lock, ptr noundef %10), !dbg !78
  %11 = load i32, ptr @x, align 4, !dbg !79
  %12 = add nsw i32 %11, 1, !dbg !79
  store i32 %12, ptr @x, align 4, !dbg !79
  %13 = load i32, ptr @y, align 4, !dbg !80
  %14 = add nsw i32 %13, 1, !dbg !80
  store i32 %14, ptr @y, align 4, !dbg !80
  %15 = load ptr, ptr %4, align 8, !dbg !81
  call void @ck_spinlock_mcs_unlock(ptr noundef @lock, ptr noundef %15), !dbg !82
  ret ptr null, !dbg !83
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_mcs_lock(ptr noundef %0, ptr noundef %1) #0 !dbg !84 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !88, !DIExpression(), !89)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !90, !DIExpression(), !91)
    #dbg_declare(ptr %5, !92, !DIExpression(), !93)
  %6 = load ptr, ptr %4, align 8, !dbg !94
  %7 = getelementptr inbounds nuw %struct.ck_spinlock_mcs, ptr %6, i32 0, i32 0, !dbg !95
  store i32 1, ptr %7, align 8, !dbg !96
  %8 = load ptr, ptr %4, align 8, !dbg !97
  %9 = getelementptr inbounds nuw %struct.ck_spinlock_mcs, ptr %8, i32 0, i32 1, !dbg !98
  store ptr null, ptr %9, align 8, !dbg !99
  call void @ck_pr_fence_store_atomic(), !dbg !100
  %10 = load ptr, ptr %3, align 8, !dbg !101
  %11 = load ptr, ptr %4, align 8, !dbg !102
  %12 = call ptr @ck_pr_fas_ptr(ptr noundef %10, ptr noundef %11), !dbg !103
  store ptr %12, ptr %5, align 8, !dbg !104
  %13 = load ptr, ptr %5, align 8, !dbg !105
  %14 = icmp ne ptr %13, null, !dbg !107
  br i1 %14, label %15, label %26, !dbg !107

15:                                               ; preds = %2
  %16 = load ptr, ptr %5, align 8, !dbg !108
  %17 = getelementptr inbounds nuw %struct.ck_spinlock_mcs, ptr %16, i32 0, i32 1, !dbg !110
  %18 = load ptr, ptr %4, align 8, !dbg !111
  call void @ck_pr_md_store_ptr(ptr noundef %17, ptr noundef %18), !dbg !112
  br label %19, !dbg !113

19:                                               ; preds = %24, %15
  %20 = load ptr, ptr %4, align 8, !dbg !114
  %21 = getelementptr inbounds nuw %struct.ck_spinlock_mcs, ptr %20, i32 0, i32 0, !dbg !115
  %22 = call zeroext i32 @ck_pr_md_load_uint(ptr noundef %21), !dbg !116
  %23 = icmp eq i32 %22, 1, !dbg !117
  br i1 %23, label %24, label %25, !dbg !113

24:                                               ; preds = %19
  call void @ck_pr_stall(), !dbg !118
  br label %19, !dbg !113, !llvm.loop !119

25:                                               ; preds = %19
  br label %26, !dbg !122

26:                                               ; preds = %25, %2
  call void @ck_pr_fence_lock(), !dbg !123
  ret void, !dbg !124
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_mcs_unlock(ptr noundef %0, ptr noundef %1) #0 !dbg !125 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !126, !DIExpression(), !127)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !128, !DIExpression(), !129)
    #dbg_declare(ptr %5, !130, !DIExpression(), !131)
  call void @ck_pr_fence_unlock(), !dbg !132
  %6 = load ptr, ptr %4, align 8, !dbg !133
  %7 = getelementptr inbounds nuw %struct.ck_spinlock_mcs, ptr %6, i32 0, i32 1, !dbg !134
  %8 = call ptr @ck_pr_md_load_ptr(ptr noundef %7), !dbg !135
  store ptr %8, ptr %5, align 8, !dbg !136
  %9 = load ptr, ptr %5, align 8, !dbg !137
  %10 = icmp eq ptr %9, null, !dbg !139
  br i1 %10, label %11, label %33, !dbg !139

11:                                               ; preds = %2
  %12 = load ptr, ptr %3, align 8, !dbg !140
  %13 = call ptr @ck_pr_md_load_ptr(ptr noundef %12), !dbg !143
  %14 = load ptr, ptr %4, align 8, !dbg !144
  %15 = icmp eq ptr %13, %14, !dbg !145
  br i1 %15, label %16, label %23, !dbg !146

16:                                               ; preds = %11
  %17 = load ptr, ptr %3, align 8, !dbg !147
  %18 = load ptr, ptr %4, align 8, !dbg !148
  %19 = call zeroext i1 @ck_pr_cas_ptr(ptr noundef %17, ptr noundef %18, ptr noundef null), !dbg !149
  %20 = zext i1 %19 to i32, !dbg !149
  %21 = icmp eq i32 %20, 1, !dbg !150
  br i1 %21, label %22, label %23, !dbg !146

22:                                               ; preds = %16
  br label %36, !dbg !151

23:                                               ; preds = %16, %11
  br label %24, !dbg !153

24:                                               ; preds = %31, %23
  %25 = load ptr, ptr %4, align 8, !dbg !154
  %26 = getelementptr inbounds nuw %struct.ck_spinlock_mcs, ptr %25, i32 0, i32 1, !dbg !158
  %27 = call ptr @ck_pr_md_load_ptr(ptr noundef %26), !dbg !159
  store ptr %27, ptr %5, align 8, !dbg !160
  %28 = load ptr, ptr %5, align 8, !dbg !161
  %29 = icmp ne ptr %28, null, !dbg !163
  br i1 %29, label %30, label %31, !dbg !163

30:                                               ; preds = %24
  br label %32, !dbg !164

31:                                               ; preds = %24
  call void @ck_pr_stall(), !dbg !165
  br label %24, !dbg !166, !llvm.loop !167

32:                                               ; preds = %30
  br label %33, !dbg !170

33:                                               ; preds = %32, %2
  %34 = load ptr, ptr %5, align 8, !dbg !171
  %35 = getelementptr inbounds nuw %struct.ck_spinlock_mcs, ptr %34, i32 0, i32 0, !dbg !172
  call void @ck_pr_md_store_uint(ptr noundef %35, i32 noundef zeroext 0), !dbg !173
  br label %36, !dbg !174

36:                                               ; preds = %33, %22
  ret void, !dbg !175
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local signext i32 @main() #0 !dbg !176 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x ptr], align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !179, !DIExpression(), !185)
    #dbg_declare(ptr %3, !186, !DIExpression(), !187)
  %4 = call ptr @malloc(i64 noundef 16) #4, !dbg !188
  store ptr %4, ptr @nodes, align 8, !dbg !189
  %5 = load ptr, ptr @nodes, align 8, !dbg !190
  %6 = icmp eq ptr %5, null, !dbg !192
  br i1 %6, label %7, label %8, !dbg !192

7:                                                ; preds = %0
  call void @exit(i32 noundef signext 1) #5, !dbg !193
  unreachable, !dbg !193

8:                                                ; preds = %0
  store ptr null, ptr @lock, align 8, !dbg !195
  store i32 0, ptr %3, align 4, !dbg !196
  br label %9, !dbg !198

9:                                                ; preds = %24, %8
  %10 = load i32, ptr %3, align 4, !dbg !199
  %11 = icmp slt i32 %10, 2, !dbg !201
  br i1 %11, label %12, label %27, !dbg !202

12:                                               ; preds = %9
  %13 = load i32, ptr %3, align 4, !dbg !203
  %14 = sext i32 %13 to i64, !dbg !206
  %15 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %14, !dbg !206
  %16 = load i32, ptr %3, align 4, !dbg !207
  %17 = sext i32 %16 to i64, !dbg !208
  %18 = inttoptr i64 %17 to ptr, !dbg !209
  %19 = call signext i32 @pthread_create(ptr noundef %15, ptr noundef null, ptr noundef @run, ptr noundef %18), !dbg !210
  %20 = icmp ne i32 %19, 0, !dbg !211
  br i1 %20, label %21, label %23, !dbg !211

21:                                               ; preds = %12
  %22 = load ptr, ptr @nodes, align 8, !dbg !212
  call void @free(ptr noundef %22), !dbg !214
  call void @exit(i32 noundef signext 1) #5, !dbg !215
  unreachable, !dbg !215

23:                                               ; preds = %12
  br label %24, !dbg !216

24:                                               ; preds = %23
  %25 = load i32, ptr %3, align 4, !dbg !217
  %26 = add nsw i32 %25, 1, !dbg !217
  store i32 %26, ptr %3, align 4, !dbg !217
  br label %9, !dbg !218, !llvm.loop !219

27:                                               ; preds = %9
  store i32 0, ptr %3, align 4, !dbg !221
  br label %28, !dbg !223

28:                                               ; preds = %41, %27
  %29 = load i32, ptr %3, align 4, !dbg !224
  %30 = icmp slt i32 %29, 2, !dbg !226
  br i1 %30, label %31, label %44, !dbg !227

31:                                               ; preds = %28
  %32 = load i32, ptr %3, align 4, !dbg !228
  %33 = sext i32 %32 to i64, !dbg !231
  %34 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %33, !dbg !231
  %35 = load ptr, ptr %34, align 8, !dbg !231
  %36 = call signext i32 @pthread_join(ptr noundef %35, ptr noundef null), !dbg !232
  %37 = icmp ne i32 %36, 0, !dbg !233
  br i1 %37, label %38, label %40, !dbg !233

38:                                               ; preds = %31
  %39 = load ptr, ptr @nodes, align 8, !dbg !234
  call void @free(ptr noundef %39), !dbg !236
  call void @exit(i32 noundef signext 1) #5, !dbg !237
  unreachable, !dbg !237

40:                                               ; preds = %31
  br label %41, !dbg !238

41:                                               ; preds = %40
  %42 = load i32, ptr %3, align 4, !dbg !239
  %43 = add nsw i32 %42, 1, !dbg !239
  store i32 %43, ptr %3, align 4, !dbg !239
  br label %28, !dbg !240, !llvm.loop !241

44:                                               ; preds = %28
  %45 = load i32, ptr @x, align 4, !dbg !243
  %46 = icmp eq i32 %45, 2, !dbg !246
  br i1 %46, label %47, label %50, !dbg !247

47:                                               ; preds = %44
  %48 = load i32, ptr @y, align 4, !dbg !248
  %49 = icmp eq i32 %48, 2, !dbg !249
  br i1 %49, label %51, label %50, !dbg !250

50:                                               ; preds = %47, %44
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef signext 63, ptr noundef @__func__.main), !dbg !250
  br label %51, !dbg !250

51:                                               ; preds = %50, %47
  %52 = load ptr, ptr @nodes, align 8, !dbg !251
  call void @free(ptr noundef %52), !dbg !252
  ret i32 0, !dbg !253
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef signext) #2

declare signext i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare void @free(ptr noundef) #3

declare signext i32 @pthread_join(ptr noundef, ptr noundef) #3

declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef signext, ptr noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_store_atomic() #0 !dbg !254 {
  call void @ck_pr_fence_strict_store_atomic(), !dbg !258
  ret void, !dbg !258
}

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @ck_pr_fas_ptr(ptr noundef %0, ptr noundef %1) #0 !dbg !259 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !263, !DIExpression(), !264)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !265, !DIExpression(), !264)
    #dbg_declare(ptr %5, !266, !DIExpression(), !264)
  %6 = load ptr, ptr %3, align 8, !dbg !264
  %7 = load ptr, ptr %4, align 8, !dbg !264
  %8 = call ptr asm sideeffect "1:ldarx $0, 0, $1;stdcx. $2, 0, $1;bne- 1b;", "=&r,r,r,~{memory},~{cc}"(ptr %6, ptr %7) #6, !dbg !264, !srcloc !267
  store ptr %8, ptr %5, align 8, !dbg !264
  %9 = load ptr, ptr %5, align 8, !dbg !264
  ret ptr %9, !dbg !264
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_md_store_ptr(ptr noundef %0, ptr noundef %1) #0 !dbg !268 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !273, !DIExpression(), !274)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !275, !DIExpression(), !274)
  %5 = load ptr, ptr %3, align 8, !dbg !274
  %6 = load ptr, ptr %4, align 8, !dbg !274
  call void asm sideeffect "std${0:U}${0:X} $1, $0", "=*m,r,~{memory}"(ptr elementtype(i64) %5, ptr %6) #6, !dbg !274, !srcloc !276
  ret void, !dbg !274
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !277 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !280, !DIExpression(), !281)
    #dbg_declare(ptr %3, !282, !DIExpression(), !281)
  %4 = load ptr, ptr %2, align 8, !dbg !281
  %5 = call i32 asm sideeffect "lwz${1:U}${1:X} $0, $1", "=r,*m,~{memory}"(ptr elementtype(i32) %4) #6, !dbg !281, !srcloc !283
  store i32 %5, ptr %3, align 4, !dbg !281
  %6 = load i32, ptr %3, align 4, !dbg !281
  ret i32 %6, !dbg !281
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_stall() #0 !dbg !284 {
  call void asm sideeffect "or 1, 1, 1;or 2, 2, 2;", "~{memory}"() #6, !dbg !285, !srcloc !286
  ret void, !dbg !287
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_lock() #0 !dbg !288 {
  call void @ck_pr_fence_strict_lock(), !dbg !289
  ret void, !dbg !289
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_store_atomic() #0 !dbg !290 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !291, !srcloc !292
  ret void, !dbg !291
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_lock() #0 !dbg !293 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !294, !srcloc !295
  ret void, !dbg !294
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_unlock() #0 !dbg !296 {
  call void @ck_pr_fence_strict_unlock(), !dbg !297
  ret void, !dbg !297
}

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @ck_pr_md_load_ptr(ptr noundef %0) #0 !dbg !298 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !301, !DIExpression(), !302)
    #dbg_declare(ptr %3, !303, !DIExpression(), !302)
  %4 = load ptr, ptr %2, align 8, !dbg !302
  %5 = call ptr asm sideeffect "ld${1:U}${1:X} $0, $1", "=r,*m,~{memory}"(ptr elementtype(i64) %4) #6, !dbg !302, !srcloc !304
  store ptr %5, ptr %3, align 8, !dbg !302
  %6 = load ptr, ptr %3, align 8, !dbg !302
  ret ptr %6, !dbg !302
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i1 @ck_pr_cas_ptr(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 !dbg !305 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !308, !DIExpression(), !309)
  store ptr %1, ptr %5, align 8
    #dbg_declare(ptr %5, !310, !DIExpression(), !311)
  store ptr %2, ptr %6, align 8
    #dbg_declare(ptr %6, !312, !DIExpression(), !313)
    #dbg_declare(ptr %7, !314, !DIExpression(), !315)
  %8 = load ptr, ptr %4, align 8, !dbg !316
  %9 = load ptr, ptr %6, align 8, !dbg !317
  %10 = load ptr, ptr %5, align 8, !dbg !318
  %11 = call ptr asm sideeffect "1:ldarx $0, 0, $1;cmpd  0, $0, $3;bne-  2f;stdcx. $2, 0, $1;bne-  1b;2:", "=&r,r,r,r,~{memory},~{cc}"(ptr %8, ptr %9, ptr %10) #6, !dbg !319, !srcloc !320
  store ptr %11, ptr %7, align 8, !dbg !319
  %12 = load ptr, ptr %7, align 8, !dbg !321
  %13 = load ptr, ptr %5, align 8, !dbg !322
  %14 = icmp eq ptr %12, %13, !dbg !323
  ret i1 %14, !dbg !324
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef zeroext %1) #0 !dbg !325 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !328, !DIExpression(), !329)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !330, !DIExpression(), !329)
  %5 = load ptr, ptr %3, align 8, !dbg !329
  %6 = load i32, ptr %4, align 4, !dbg !329
  call void asm sideeffect "stw${0:U}${0:X} $1, $0", "=*m,r,~{memory}"(ptr elementtype(i32) %5, i32 %6) #6, !dbg !329, !srcloc !331
  ret void, !dbg !329
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_unlock() #0 !dbg !332 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !333, !srcloc !334
  ret void, !dbg !333
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #1 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #4 = { allocsize(0) }
attributes #5 = { noreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!55, !56, !57, !58, !59, !60, !61}
!llvm.ident = !{!62}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 10, type: !9, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !31, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/mcslock.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "4d52312d3fd6710159db4cbd2182b2bc")
!4 = !{!5, !6, !9, !17, !18, !21, !24, !26, !11, !28, !30}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !7, line: 23, baseType: !8)
!7 = !DIFile(filename: "include/libc/stdint.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "027aa838071dee39e5261b0fdecb37d3")
!8 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_mcs_t", file: !10, line: 42, baseType: !11)
!10 = !DIFile(filename: "../ck/include/spinlock/mcs.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "027f57d568cbbfbb353298638ea153e7")
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_mcs", file: !10, line: 38, size: 128, elements: !13)
!13 = !{!14, !16}
!14 = !DIDerivedType(tag: DW_TAG_member, name: "locked", scope: !12, file: !10, line: 39, baseType: !15, size: 32)
!15 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !12, file: !10, line: 40, baseType: !11, size: 64, offset: 64)
!17 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !19, line: 5, baseType: !20)
!19 = !DIFile(filename: "include/libc/_size_t.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "dc11ce4c8eb4c64bece0363f758637cd")
!20 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "bool", file: !22, line: 4, baseType: !23)
!22 = !DIFile(filename: "include/libc/stdbool.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6e643322591bab80343344357c642cba")
!23 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !7, line: 24, baseType: !20)
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !27, size: 64)
!27 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!29 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !25)
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!31 = !{!0, !32, !34, !36, !42, !47, !53}
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 13, type: !17, isLocal: false, isDefinition: true)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 13, type: !17, isLocal: false, isDefinition: true)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 248, elements: !40)
!39 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!40 = !{!41}
!41 = !DISubrange(count: 31)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 192, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 24)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !49, isLocal: true, isDefinition: true)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 40, elements: !51)
!50 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !39)
!51 = !{!52}
!52 = !DISubrange(count: 5)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "nodes", scope: !2, file: !3, line: 11, type: !9, isLocal: false, isDefinition: true)
!55 = !{i32 7, !"Dwarf Version", i32 5}
!56 = !{i32 2, !"Debug Info Version", i32 3}
!57 = !{i32 1, !"wchar_size", i32 4}
!58 = !{i32 8, !"PIC Level", i32 2}
!59 = !{i32 7, !"PIE Level", i32 2}
!60 = !{i32 7, !"uwtable", i32 2}
!61 = !{i32 7, !"frame-pointer", i32 2}
!62 = !{!"Homebrew clang version 22.1.8"}
!63 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 15, type: !64, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !66)
!64 = !DISubroutineType(types: !65)
!65 = !{!5, !5}
!66 = !{}
!67 = !DILocalVariable(name: "arg", arg: 1, scope: !63, file: !3, line: 15, type: !5)
!68 = !DILocation(line: 15, column: 17, scope: !63)
!69 = !DILocalVariable(name: "tid", scope: !63, file: !3, line: 18, type: !6)
!70 = !DILocation(line: 18, column: 14, scope: !63)
!71 = !DILocation(line: 18, column: 31, scope: !63)
!72 = !DILocation(line: 18, column: 21, scope: !63)
!73 = !DILocalVariable(name: "thread_node", scope: !63, file: !3, line: 20, type: !9)
!74 = !DILocation(line: 20, column: 23, scope: !63)
!75 = !DILocation(line: 20, column: 38, scope: !63)
!76 = !DILocation(line: 20, column: 44, scope: !63)
!77 = !DILocation(line: 22, column: 33, scope: !63)
!78 = !DILocation(line: 22, column: 5, scope: !63)
!79 = !DILocation(line: 24, column: 6, scope: !63)
!80 = !DILocation(line: 25, column: 6, scope: !63)
!81 = !DILocation(line: 27, column: 35, scope: !63)
!82 = !DILocation(line: 27, column: 5, scope: !63)
!83 = !DILocation(line: 29, column: 5, scope: !63)
!84 = distinct !DISubprogram(name: "ck_spinlock_mcs_lock", scope: !10, file: !10, line: 82, type: !85, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!85 = !DISubroutineType(types: !86)
!86 = !{null, !87, !11}
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!88 = !DILocalVariable(name: "queue", arg: 1, scope: !84, file: !10, line: 82, type: !87)
!89 = !DILocation(line: 82, column: 47, scope: !84)
!90 = !DILocalVariable(name: "node", arg: 2, scope: !84, file: !10, line: 83, type: !11)
!91 = !DILocation(line: 83, column: 29, scope: !84)
!92 = !DILocalVariable(name: "previous", scope: !84, file: !10, line: 85, type: !11)
!93 = !DILocation(line: 85, column: 26, scope: !84)
!94 = !DILocation(line: 91, column: 2, scope: !84)
!95 = !DILocation(line: 91, column: 8, scope: !84)
!96 = !DILocation(line: 91, column: 15, scope: !84)
!97 = !DILocation(line: 92, column: 2, scope: !84)
!98 = !DILocation(line: 92, column: 8, scope: !84)
!99 = !DILocation(line: 92, column: 13, scope: !84)
!100 = !DILocation(line: 93, column: 2, scope: !84)
!101 = !DILocation(line: 100, column: 27, scope: !84)
!102 = !DILocation(line: 100, column: 34, scope: !84)
!103 = !DILocation(line: 100, column: 13, scope: !84)
!104 = !DILocation(line: 100, column: 11, scope: !84)
!105 = !DILocation(line: 101, column: 6, scope: !106)
!106 = distinct !DILexicalBlock(scope: !84, file: !10, line: 101, column: 6)
!107 = !DILocation(line: 101, column: 15, scope: !106)
!108 = !DILocation(line: 106, column: 20, scope: !109)
!109 = distinct !DILexicalBlock(scope: !106, file: !10, line: 101, column: 24)
!110 = !DILocation(line: 106, column: 30, scope: !109)
!111 = !DILocation(line: 106, column: 36, scope: !109)
!112 = !DILocation(line: 106, column: 3, scope: !109)
!113 = !DILocation(line: 107, column: 3, scope: !109)
!114 = !DILocation(line: 107, column: 27, scope: !109)
!115 = !DILocation(line: 107, column: 33, scope: !109)
!116 = !DILocation(line: 107, column: 10, scope: !109)
!117 = !DILocation(line: 107, column: 41, scope: !109)
!118 = !DILocation(line: 108, column: 4, scope: !109)
!119 = distinct !{!119, !113, !120, !121}
!120 = !DILocation(line: 108, column: 16, scope: !109)
!121 = !{!"llvm.loop.mustprogress"}
!122 = !DILocation(line: 109, column: 2, scope: !109)
!123 = !DILocation(line: 111, column: 2, scope: !84)
!124 = !DILocation(line: 112, column: 2, scope: !84)
!125 = distinct !DISubprogram(name: "ck_spinlock_mcs_unlock", scope: !10, file: !10, line: 116, type: !85, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!126 = !DILocalVariable(name: "queue", arg: 1, scope: !125, file: !10, line: 116, type: !87)
!127 = !DILocation(line: 116, column: 49, scope: !125)
!128 = !DILocalVariable(name: "node", arg: 2, scope: !125, file: !10, line: 117, type: !11)
!129 = !DILocation(line: 117, column: 29, scope: !125)
!130 = !DILocalVariable(name: "next", scope: !125, file: !10, line: 119, type: !11)
!131 = !DILocation(line: 119, column: 26, scope: !125)
!132 = !DILocation(line: 121, column: 2, scope: !125)
!133 = !DILocation(line: 123, column: 25, scope: !125)
!134 = !DILocation(line: 123, column: 31, scope: !125)
!135 = !DILocation(line: 123, column: 9, scope: !125)
!136 = !DILocation(line: 123, column: 7, scope: !125)
!137 = !DILocation(line: 124, column: 6, scope: !138)
!138 = distinct !DILexicalBlock(scope: !125, file: !10, line: 124, column: 6)
!139 = !DILocation(line: 124, column: 11, scope: !138)
!140 = !DILocation(line: 130, column: 22, scope: !141)
!141 = distinct !DILexicalBlock(scope: !142, file: !10, line: 130, column: 7)
!142 = distinct !DILexicalBlock(scope: !138, file: !10, line: 124, column: 20)
!143 = !DILocation(line: 130, column: 7, scope: !141)
!144 = !DILocation(line: 130, column: 32, scope: !141)
!145 = !DILocation(line: 130, column: 29, scope: !141)
!146 = !DILocation(line: 130, column: 37, scope: !141)
!147 = !DILocation(line: 131, column: 21, scope: !141)
!148 = !DILocation(line: 131, column: 28, scope: !141)
!149 = !DILocation(line: 131, column: 7, scope: !141)
!150 = !DILocation(line: 131, column: 40, scope: !141)
!151 = !DILocation(line: 132, column: 4, scope: !152)
!152 = distinct !DILexicalBlock(scope: !141, file: !10, line: 131, column: 49)
!153 = !DILocation(line: 141, column: 3, scope: !142)
!154 = !DILocation(line: 142, column: 27, scope: !155)
!155 = distinct !DILexicalBlock(scope: !156, file: !10, line: 141, column: 12)
!156 = distinct !DILexicalBlock(scope: !157, file: !10, line: 141, column: 3)
!157 = distinct !DILexicalBlock(scope: !142, file: !10, line: 141, column: 3)
!158 = !DILocation(line: 142, column: 33, scope: !155)
!159 = !DILocation(line: 142, column: 11, scope: !155)
!160 = !DILocation(line: 142, column: 9, scope: !155)
!161 = !DILocation(line: 143, column: 8, scope: !162)
!162 = distinct !DILexicalBlock(scope: !155, file: !10, line: 143, column: 8)
!163 = !DILocation(line: 143, column: 13, scope: !162)
!164 = !DILocation(line: 144, column: 5, scope: !162)
!165 = !DILocation(line: 146, column: 4, scope: !155)
!166 = !DILocation(line: 141, column: 3, scope: !156)
!167 = distinct !{!167, !168, !169}
!168 = !DILocation(line: 141, column: 3, scope: !157)
!169 = !DILocation(line: 147, column: 3, scope: !157)
!170 = !DILocation(line: 148, column: 2, scope: !142)
!171 = !DILocation(line: 151, column: 20, scope: !125)
!172 = !DILocation(line: 151, column: 26, scope: !125)
!173 = !DILocation(line: 151, column: 2, scope: !125)
!174 = !DILocation(line: 152, column: 2, scope: !125)
!175 = !DILocation(line: 153, column: 1, scope: !125)
!176 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 32, type: !177, scopeLine: 33, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !66)
!177 = !DISubroutineType(types: !178)
!178 = !{!17}
!179 = !DILocalVariable(name: "threads", scope: !176, file: !3, line: 34, type: !180)
!180 = !DICompositeType(tag: DW_TAG_array_type, baseType: !181, size: 128, elements: !183)
!181 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !182, line: 2, baseType: !5)
!182 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!183 = !{!184}
!184 = !DISubrange(count: 2)
!185 = !DILocation(line: 34, column: 15, scope: !176)
!186 = !DILocalVariable(name: "i", scope: !176, file: !3, line: 35, type: !17)
!187 = !DILocation(line: 35, column: 9, scope: !176)
!188 = !DILocation(line: 37, column: 32, scope: !176)
!189 = !DILocation(line: 37, column: 11, scope: !176)
!190 = !DILocation(line: 38, column: 9, scope: !191)
!191 = distinct !DILexicalBlock(scope: !176, file: !3, line: 38, column: 9)
!192 = !DILocation(line: 38, column: 15, scope: !191)
!193 = !DILocation(line: 40, column: 9, scope: !194)
!194 = distinct !DILexicalBlock(scope: !191, file: !3, line: 39, column: 5)
!195 = !DILocation(line: 43, column: 10, scope: !176)
!196 = !DILocation(line: 45, column: 12, scope: !197)
!197 = distinct !DILexicalBlock(scope: !176, file: !3, line: 45, column: 5)
!198 = !DILocation(line: 45, column: 10, scope: !197)
!199 = !DILocation(line: 45, column: 17, scope: !200)
!200 = distinct !DILexicalBlock(scope: !197, file: !3, line: 45, column: 5)
!201 = !DILocation(line: 45, column: 19, scope: !200)
!202 = !DILocation(line: 45, column: 5, scope: !197)
!203 = !DILocation(line: 47, column: 37, scope: !204)
!204 = distinct !DILexicalBlock(scope: !205, file: !3, line: 47, column: 13)
!205 = distinct !DILexicalBlock(scope: !200, file: !3, line: 46, column: 5)
!206 = !DILocation(line: 47, column: 29, scope: !204)
!207 = !DILocation(line: 47, column: 68, scope: !204)
!208 = !DILocation(line: 47, column: 60, scope: !204)
!209 = !DILocation(line: 47, column: 52, scope: !204)
!210 = !DILocation(line: 47, column: 13, scope: !204)
!211 = !DILocation(line: 47, column: 71, scope: !204)
!212 = !DILocation(line: 49, column: 18, scope: !213)
!213 = distinct !DILexicalBlock(scope: !204, file: !3, line: 48, column: 9)
!214 = !DILocation(line: 49, column: 13, scope: !213)
!215 = !DILocation(line: 50, column: 13, scope: !213)
!216 = !DILocation(line: 52, column: 5, scope: !205)
!217 = !DILocation(line: 45, column: 32, scope: !200)
!218 = !DILocation(line: 45, column: 5, scope: !200)
!219 = distinct !{!219, !202, !220, !121}
!220 = !DILocation(line: 52, column: 5, scope: !197)
!221 = !DILocation(line: 54, column: 12, scope: !222)
!222 = distinct !DILexicalBlock(scope: !176, file: !3, line: 54, column: 5)
!223 = !DILocation(line: 54, column: 10, scope: !222)
!224 = !DILocation(line: 54, column: 17, scope: !225)
!225 = distinct !DILexicalBlock(scope: !222, file: !3, line: 54, column: 5)
!226 = !DILocation(line: 54, column: 19, scope: !225)
!227 = !DILocation(line: 54, column: 5, scope: !222)
!228 = !DILocation(line: 56, column: 34, scope: !229)
!229 = distinct !DILexicalBlock(scope: !230, file: !3, line: 56, column: 13)
!230 = distinct !DILexicalBlock(scope: !225, file: !3, line: 55, column: 5)
!231 = !DILocation(line: 56, column: 26, scope: !229)
!232 = !DILocation(line: 56, column: 13, scope: !229)
!233 = !DILocation(line: 56, column: 44, scope: !229)
!234 = !DILocation(line: 58, column: 18, scope: !235)
!235 = distinct !DILexicalBlock(scope: !229, file: !3, line: 57, column: 9)
!236 = !DILocation(line: 58, column: 13, scope: !235)
!237 = !DILocation(line: 59, column: 13, scope: !235)
!238 = !DILocation(line: 61, column: 5, scope: !230)
!239 = !DILocation(line: 54, column: 32, scope: !225)
!240 = !DILocation(line: 54, column: 5, scope: !225)
!241 = distinct !{!241, !227, !242, !121}
!242 = !DILocation(line: 61, column: 5, scope: !222)
!243 = !DILocation(line: 63, column: 12, scope: !244)
!244 = distinct !DILexicalBlock(scope: !245, file: !3, line: 63, column: 5)
!245 = distinct !DILexicalBlock(scope: !176, file: !3, line: 63, column: 5)
!246 = !DILocation(line: 63, column: 14, scope: !244)
!247 = !DILocation(line: 63, column: 26, scope: !244)
!248 = !DILocation(line: 63, column: 29, scope: !244)
!249 = !DILocation(line: 63, column: 31, scope: !244)
!250 = !DILocation(line: 63, column: 5, scope: !244)
!251 = !DILocation(line: 65, column: 10, scope: !176)
!252 = !DILocation(line: 65, column: 5, scope: !176)
!253 = !DILocation(line: 67, column: 5, scope: !176)
!254 = distinct !DISubprogram(name: "ck_pr_fence_store_atomic", scope: !255, file: !255, line: 112, type: !256, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!255 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!256 = !DISubroutineType(types: !257)
!257 = !{null}
!258 = !DILocation(line: 112, column: 1, scope: !254)
!259 = distinct !DISubprogram(name: "ck_pr_fas_ptr", scope: !260, file: !260, line: 304, type: !261, scopeLine: 304, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!260 = !DIFile(filename: "../ck/include/gcc/ppc64/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "8952bb109540f13c2aa63ce3890cafa9")
!261 = !DISubroutineType(types: !262)
!262 = !{!5, !5, !5}
!263 = !DILocalVariable(name: "target", arg: 1, scope: !259, file: !260, line: 304, type: !5)
!264 = !DILocation(line: 304, column: 1, scope: !259)
!265 = !DILocalVariable(name: "v", arg: 2, scope: !259, file: !260, line: 304, type: !5)
!266 = !DILocalVariable(name: "previous", scope: !259, file: !260, line: 304, type: !5)
!267 = !{i64 2147596917}
!268 = distinct !DISubprogram(name: "ck_pr_md_store_ptr", scope: !260, file: !260, line: 133, type: !269, scopeLine: 133, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!269 = !DISubroutineType(types: !270)
!270 = !{null, !5, !271}
!271 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !272, size: 64)
!272 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!273 = !DILocalVariable(name: "target", arg: 1, scope: !268, file: !260, line: 133, type: !5)
!274 = !DILocation(line: 133, column: 1, scope: !268)
!275 = !DILocalVariable(name: "v", arg: 2, scope: !268, file: !260, line: 133, type: !271)
!276 = !{i64 2147588357}
!277 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !260, file: !260, line: 111, type: !278, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!278 = !DISubroutineType(types: !279)
!279 = !{!15, !26}
!280 = !DILocalVariable(name: "target", arg: 1, scope: !277, file: !260, line: 111, type: !26)
!281 = !DILocation(line: 111, column: 1, scope: !277)
!282 = !DILocalVariable(name: "r", scope: !277, file: !260, line: 111, type: !15)
!283 = !{i64 2147586501}
!284 = distinct !DISubprogram(name: "ck_pr_stall", scope: !260, file: !260, line: 54, type: !256, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!285 = !DILocation(line: 57, column: 2, scope: !284)
!286 = !{i64 85497}
!287 = !DILocation(line: 59, column: 2, scope: !284)
!288 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !255, file: !255, line: 122, type: !256, scopeLine: 122, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!289 = !DILocation(line: 122, column: 1, scope: !288)
!290 = distinct !DISubprogram(name: "ck_pr_fence_strict_store_atomic", scope: !260, file: !260, line: 76, type: !256, scopeLine: 76, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!291 = !DILocation(line: 76, column: 1, scope: !290)
!292 = !{i64 2147581916}
!293 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !260, file: !260, line: 86, type: !256, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!294 = !DILocation(line: 86, column: 1, scope: !293)
!295 = !{i64 2147583930}
!296 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !255, file: !255, line: 123, type: !256, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!297 = !DILocation(line: 123, column: 1, scope: !296)
!298 = distinct !DISubprogram(name: "ck_pr_md_load_ptr", scope: !260, file: !260, line: 103, type: !299, scopeLine: 103, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!299 = !DISubroutineType(types: !300)
!300 = !{!5, !271}
!301 = !DILocalVariable(name: "target", arg: 1, scope: !298, file: !260, line: 103, type: !271)
!302 = !DILocation(line: 103, column: 1, scope: !298)
!303 = !DILocalVariable(name: "r", scope: !298, file: !260, line: 103, type: !5)
!304 = !{i64 2147584465}
!305 = distinct !DISubprogram(name: "ck_pr_cas_ptr", scope: !260, file: !260, line: 218, type: !306, scopeLine: 219, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!306 = !DISubroutineType(types: !307)
!307 = !{!21, !5, !5, !5}
!308 = !DILocalVariable(name: "target", arg: 1, scope: !305, file: !260, line: 218, type: !5)
!309 = !DILocation(line: 218, column: 21, scope: !305)
!310 = !DILocalVariable(name: "compare", arg: 2, scope: !305, file: !260, line: 218, type: !5)
!311 = !DILocation(line: 218, column: 35, scope: !305)
!312 = !DILocalVariable(name: "set", arg: 3, scope: !305, file: !260, line: 218, type: !5)
!313 = !DILocation(line: 218, column: 50, scope: !305)
!314 = !DILocalVariable(name: "previous", scope: !305, file: !260, line: 220, type: !5)
!315 = !DILocation(line: 220, column: 8, scope: !305)
!316 = !DILocation(line: 230, column: 42, scope: !305)
!317 = !DILocation(line: 231, column: 14, scope: !305)
!318 = !DILocation(line: 232, column: 42, scope: !305)
!319 = !DILocation(line: 222, column: 9, scope: !305)
!320 = !{i64 89700}
!321 = !DILocation(line: 235, column: 17, scope: !305)
!322 = !DILocation(line: 235, column: 29, scope: !305)
!323 = !DILocation(line: 235, column: 26, scope: !305)
!324 = !DILocation(line: 235, column: 9, scope: !305)
!325 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !260, file: !260, line: 141, type: !326, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!326 = !DISubroutineType(types: !327)
!327 = !{null, !30, !15}
!328 = !DILocalVariable(name: "target", arg: 1, scope: !325, file: !260, line: 141, type: !30)
!329 = !DILocation(line: 141, column: 1, scope: !325)
!330 = !DILocalVariable(name: "v", arg: 2, scope: !325, file: !260, line: 141, type: !15)
!331 = !{i64 2147590208}
!332 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !260, file: !260, line: 87, type: !256, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!333 = !DILocation(line: 87, column: 1, scope: !332)
!334 = !{i64 2147584127}
