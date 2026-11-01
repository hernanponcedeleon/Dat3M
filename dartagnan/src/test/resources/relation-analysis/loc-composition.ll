; ModuleID = 'benchmarks/miscellaneous/loc-composition.c'
source_filename = "benchmarks/miscellaneous/loc-composition.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

@y = global i32 0, align 4
@x = global i32 0, align 4
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str = private unnamed_addr constant [18 x i8] c"loc-composition.c\00", align 1
@.str.1 = private unnamed_addr constant [17 x i8] c"r == 1 || r == 0\00", align 1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @worker(ptr noundef %arg) #0 {
entry:
  %arg.addr = alloca ptr, align 8
  store ptr %arg, ptr %arg.addr, align 8
  store i32 3, ptr @y, align 4
  ret ptr null
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %t = alloca ptr, align 8
  %p = alloca ptr, align 8
  %r = alloca i32, align 4
  store i32 0, ptr %retval, align 4
  %call = call i32 @pthread_create(ptr noundef %t, ptr noundef null, ptr noundef @worker, ptr noundef null)
  %call1 = call i32 @__VERIFIER_nondet_int()
  %tobool = icmp ne i32 %call1, 0
  %0 = zext i1 %tobool to i64
  %cond = select i1 %tobool, ptr @x, ptr @y
  store ptr %cond, ptr %p, align 8
  %1 = load ptr, ptr %p, align 8
  store i32 1, ptr %1, align 4
  %2 = load i32, ptr @x, align 4
  store i32 %2, ptr %r, align 4
  store i32 2, ptr @y, align 4
  %3 = load ptr, ptr %t, align 8
  %call2 = call i32 @"\01_pthread_join"(ptr noundef %3, ptr noundef null)
  %4 = load i32, ptr %r, align 4
  %cmp = icmp eq i32 %4, 1
  br i1 %cmp, label %lor.end, label %lor.rhs

lor.rhs:                                          ; preds = %entry
  %5 = load i32, ptr %r, align 4
  %cmp3 = icmp eq i32 %5, 0
  br label %lor.end

lor.end:                                          ; preds = %lor.rhs, %entry
  %6 = phi i1 [ true, %entry ], [ %cmp3, %lor.rhs ]
  %lnot = xor i1 %6, true
  %lnot.ext = zext i1 %lnot to i32
  %conv = sext i32 %lnot.ext to i64
  %tobool4 = icmp ne i64 %conv, 0
  br i1 %tobool4, label %cond.true, label %cond.false

cond.true:                                        ; preds = %lor.end
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 27, ptr noundef @.str.1) #3
  unreachable

7:                                                ; No predecessors!
  br label %cond.end

cond.false:                                       ; preds = %lor.end
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %7
  ret i32 0
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @__VERIFIER_nondet_int() #1

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #3 = { cold noreturn }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 5]}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 1}
!3 = !{i32 7, !"frame-pointer", i32 4}
!4 = !{!"Homebrew clang version 23.1.0"}
