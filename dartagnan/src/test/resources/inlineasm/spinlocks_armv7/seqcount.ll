; ModuleID = 'test/spinlock/seqcount.c'
source_filename = "test/spinlock/seqcount.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.vatomic32_s = type { i32 }

@g_seq_cnt = global %struct.vatomic32_s zeroinitializer, align 4
@g_cs_x = global i32 0, align 4
@g_cs_y = global i32 0, align 4
@__func__.reader_cs = private unnamed_addr constant [10 x i8] c"reader_cs\00", align 1
@.str = private unnamed_addr constant [11 x i8] c"seqcount.c\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"a == b\00", align 1
@.str.2 = private unnamed_addr constant [14 x i8] c"(s >> 1) == a\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @init() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @post() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @fini() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @check() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @writer_acquire(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  br label %3

3:                                                ; preds = %1
  br label %4

4:                                                ; preds = %3
  %5 = load i32, ptr %2, align 4
  br label %6

6:                                                ; preds = %4
  br label %7

7:                                                ; preds = %6
  br label %8

8:                                                ; preds = %7
  br label %9

9:                                                ; preds = %8
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @writer_release(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  br label %3

3:                                                ; preds = %1
  br label %4

4:                                                ; preds = %3
  %5 = load i32, ptr %2, align 4
  br label %6

6:                                                ; preds = %4
  br label %7

7:                                                ; preds = %6
  br label %8

8:                                                ; preds = %7
  br label %9

9:                                                ; preds = %8
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @reader_acquire(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  br label %3

3:                                                ; preds = %1
  br label %4

4:                                                ; preds = %3
  %5 = load i32, ptr %2, align 4
  br label %6

6:                                                ; preds = %4
  br label %7

7:                                                ; preds = %6
  br label %8

8:                                                ; preds = %7
  br label %9

9:                                                ; preds = %8
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @reader_release(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  br label %3

3:                                                ; preds = %1
  br label %4

4:                                                ; preds = %3
  %5 = load i32, ptr %2, align 4
  br label %6

6:                                                ; preds = %4
  br label %7

7:                                                ; preds = %6
  br label %8

8:                                                ; preds = %7
  br label %9

9:                                                ; preds = %8
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store i32 0, ptr %1, align 4
  call void @init()
  call void @verification_loop_bound(i32 noundef 2)
  store i64 0, ptr %3, align 8
  br label %6

6:                                                ; preds = %15, %0
  %7 = load i64, ptr %3, align 8
  %8 = icmp ult i64 %7, 1
  br i1 %8, label %9, label %18

9:                                                ; preds = %6
  %10 = load i64, ptr %3, align 8
  %11 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %10
  %12 = load i64, ptr %3, align 8
  %13 = inttoptr i64 %12 to ptr
  %14 = call i32 @pthread_create(ptr noundef %11, ptr noundef null, ptr noundef @writer, ptr noundef %13)
  br label %15

15:                                               ; preds = %9
  %16 = load i64, ptr %3, align 8
  %17 = add i64 %16, 1
  store i64 %17, ptr %3, align 8
  br label %6, !llvm.loop !6

18:                                               ; preds = %6
  call void @verification_loop_bound(i32 noundef 4)
  store i64 1, ptr %4, align 8
  br label %19

19:                                               ; preds = %28, %18
  %20 = load i64, ptr %4, align 8
  %21 = icmp ult i64 %20, 3
  br i1 %21, label %22, label %31

22:                                               ; preds = %19
  %23 = load i64, ptr %4, align 8
  %24 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %23
  %25 = load i64, ptr %4, align 8
  %26 = inttoptr i64 %25 to ptr
  %27 = call i32 @pthread_create(ptr noundef %24, ptr noundef null, ptr noundef @reader, ptr noundef %26)
  br label %28

28:                                               ; preds = %22
  %29 = load i64, ptr %4, align 8
  %30 = add i64 %29, 1
  store i64 %30, ptr %4, align 8
  br label %19, !llvm.loop !8

31:                                               ; preds = %19
  call void @post()
  call void @verification_loop_bound(i32 noundef 4)
  store i64 0, ptr %5, align 8
  br label %32

32:                                               ; preds = %40, %31
  %33 = load i64, ptr %5, align 8
  %34 = icmp ult i64 %33, 3
  br i1 %34, label %35, label %43

35:                                               ; preds = %32
  %36 = load i64, ptr %5, align 8
  %37 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %36
  %38 = load ptr, ptr %37, align 8
  %39 = call i32 @"\01_pthread_join"(ptr noundef %38, ptr noundef null)
  br label %40

40:                                               ; preds = %35
  %41 = load i64, ptr %5, align 8
  %42 = add i64 %41, 1
  store i64 %42, ptr %5, align 8
  br label %32, !llvm.loop !9

43:                                               ; preds = %32
  call void @check()
  call void @fini()
  ret i32 0
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @verification_loop_bound(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  ret void
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @writer(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = ptrtoint ptr %4 to i64
  %6 = trunc i64 %5 to i32
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  call void @writer_acquire(i32 noundef %7)
  %8 = load i32, ptr %3, align 4
  call void @writer_cs(i32 noundef %8)
  %9 = load i32, ptr %3, align 4
  call void @writer_release(i32 noundef %9)
  ret ptr null
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @reader(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = ptrtoint ptr %4 to i64
  %6 = trunc i64 %5 to i32
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  call void @reader_acquire(i32 noundef %7)
  %8 = load i32, ptr %3, align 4
  call void @reader_cs(i32 noundef %8)
  %9 = load i32, ptr %3, align 4
  call void @reader_release(i32 noundef %9)
  ret ptr null
}

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @writer_cs(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  br label %4

4:                                                ; preds = %1
  br label %5

5:                                                ; preds = %4
  %6 = load i32, ptr %2, align 4
  br label %7

7:                                                ; preds = %5
  br label %8

8:                                                ; preds = %7
  br label %9

9:                                                ; preds = %8
  br label %10

10:                                               ; preds = %9
  %11 = call i32 @seqcount_wbegin(ptr noundef @g_seq_cnt)
  store i32 %11, ptr %3, align 4
  %12 = load i32, ptr @g_cs_x, align 4
  %13 = add i32 %12, 1
  store i32 %13, ptr @g_cs_x, align 4
  %14 = load i32, ptr @g_cs_y, align 4
  %15 = add i32 %14, 1
  store i32 %15, ptr @g_cs_y, align 4
  %16 = load i32, ptr %3, align 4
  call void @seqcount_wend(ptr noundef @g_seq_cnt, i32 noundef %16)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @seqcount_wbegin(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = call i32 @vatomic32_read_rlx(ptr noundef %4)
  store i32 %5, ptr %3, align 4
  %6 = load ptr, ptr %2, align 8
  %7 = load i32, ptr %3, align 4
  %8 = add i32 %7, 1
  call void @vatomic32_write_rlx(ptr noundef %6, i32 noundef %8)
  call void @vatomic_fence_rel()
  %9 = load i32, ptr %3, align 4
  ret i32 %9
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @seqcount_wend(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load ptr, ptr %3, align 8
  %6 = load i32, ptr %4, align 4
  %7 = add i32 %6, 2
  call void @vatomic32_write_rel(ptr noundef %5, i32 noundef %7)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @reader_cs(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i8, align 1
  store i32 %0, ptr %2, align 4
  store i32 0, ptr %3, align 4
  store i32 0, ptr %4, align 4
  store i32 0, ptr %5, align 4
  br label %7

7:                                                ; preds = %1
  call void @verification_loop_begin()
  br label %8

8:                                                ; preds = %12, %7
  call void @verification_spin_start()
  %9 = call i32 @seqcount_rbegin(ptr noundef @g_seq_cnt)
  store i32 %9, ptr %5, align 4
  %10 = load i32, ptr @g_cs_x, align 4
  store i32 %10, ptr %3, align 4
  %11 = load i32, ptr @g_cs_y, align 4
  store i32 %11, ptr %4, align 4
  br label %12

12:                                               ; preds = %8
  %13 = load i32, ptr %5, align 4
  %14 = call zeroext i1 @seqcount_rend(ptr noundef @g_seq_cnt, i32 noundef %13)
  %15 = xor i1 %14, true
  %16 = zext i1 %15 to i8
  store i8 %16, ptr %6, align 1
  %17 = load i8, ptr %6, align 1
  %18 = trunc i8 %17 to i1
  %19 = xor i1 %18, true
  %20 = zext i1 %19 to i32
  call void @verification_spin_end(i32 noundef %20)
  %21 = load i8, ptr %6, align 1
  %22 = trunc i8 %21 to i1
  br i1 %22, label %8, label %23, !llvm.loop !10

23:                                               ; preds = %12
  br label %24

24:                                               ; preds = %23
  %25 = load i32, ptr %3, align 4
  %26 = load i32, ptr %4, align 4
  %27 = icmp eq i32 %25, %26
  %28 = xor i1 %27, true
  %29 = zext i1 %28 to i32
  %30 = sext i32 %29 to i64
  %31 = icmp ne i64 %30, 0
  br i1 %31, label %32, label %34

32:                                               ; preds = %24
  call void @__assert_rtn(ptr noundef @__func__.reader_cs, ptr noundef @.str, i32 noundef 40, ptr noundef @.str.1) #3
  unreachable

33:                                               ; No predecessors!
  br label %35

34:                                               ; preds = %24
  br label %35

35:                                               ; preds = %34, %33
  %36 = load i32, ptr %5, align 4
  %37 = lshr i32 %36, 1
  %38 = load i32, ptr %3, align 4
  %39 = icmp eq i32 %37, %38
  %40 = xor i1 %39, true
  %41 = zext i1 %40 to i32
  %42 = sext i32 %41 to i64
  %43 = icmp ne i64 %42, 0
  br i1 %43, label %44, label %46

44:                                               ; preds = %35
  call void @__assert_rtn(ptr noundef @__func__.reader_cs, ptr noundef @.str, i32 noundef 41, ptr noundef @.str.2) #3
  unreachable

45:                                               ; No predecessors!
  br label %47

46:                                               ; preds = %35
  br label %47

47:                                               ; preds = %46, %45
  br label %48

48:                                               ; preds = %47
  br label %49

49:                                               ; preds = %48
  %50 = load i32, ptr %3, align 4
  br label %51

51:                                               ; preds = %49
  %52 = load i32, ptr %4, align 4
  br label %53

53:                                               ; preds = %51
  %54 = load i32, ptr %2, align 4
  br label %55

55:                                               ; preds = %53
  br label %56

56:                                               ; preds = %55
  br label %57

57:                                               ; preds = %56
  br label %58

58:                                               ; preds = %57
  br label %59

59:                                               ; preds = %58
  br label %60

60:                                               ; preds = %59
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @verification_loop_begin() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @verification_spin_start() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @seqcount_rbegin(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = call i32 @vatomic32_read_acq(ptr noundef %4)
  %6 = and i32 %5, -2
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  ret i32 %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @seqcount_rend(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  call void @vatomic_fence_acq()
  %5 = load ptr, ptr %3, align 8
  %6 = call i32 @vatomic32_read_rlx(ptr noundef %5)
  %7 = load i32, ptr %4, align 4
  %8 = icmp eq i32 %6, %7
  ret i1 %8
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @verification_spin_end(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  ret void
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_read_rlx(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.vatomic32_s, ptr %4, i32 0, i32 0
  %6 = call i32 asm sideeffect "ldr $0, $1 \0A\0A", "=&r,*Q,~{memory}"(ptr elementtype(i32) %5) #4, !srcloc !11
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  ret i32 %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @vatomic32_write_rlx(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load i32, ptr %4, align 4
  %6 = load ptr, ptr %3, align 8
  %7 = getelementptr inbounds %struct.vatomic32_s, ptr %6, i32 0, i32 0
  call void asm sideeffect " \0Astr $0, $1\0A \0A", "r,*Q,~{memory}"(i32 %5, ptr elementtype(i32) %7) #4, !srcloc !12
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @vatomic_fence_rel() #0 {
  call void asm sideeffect "dmb ish", "~{memory}"() #4, !srcloc !13
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @vatomic32_write_rel(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load i32, ptr %4, align 4
  %6 = load ptr, ptr %3, align 8
  %7 = getelementptr inbounds %struct.vatomic32_s, ptr %6, i32 0, i32 0
  call void asm sideeffect "dmb ish \0Astr $0, $1\0A \0A", "r,*Q,~{memory}"(i32 %5, ptr elementtype(i32) %7) #4, !srcloc !14
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_read_acq(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.vatomic32_s, ptr %4, i32 0, i32 0
  %6 = call i32 asm sideeffect "ldr $0, $1 \0Admb ish\0A", "=&r,*Q,~{memory}"(ptr elementtype(i32) %5) #4, !srcloc !15
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  ret i32 %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @vatomic_fence_acq() #0 {
  call void asm sideeffect "dmb ish", "~{memory}"() #4, !srcloc !16
  ret void
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 0]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Homebrew clang version 19.1.7"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
!11 = !{i64 932851, i64 932880}
!12 = !{i64 937180, i64 937195, i64 937222}
!13 = !{i64 930800}
!14 = !{i64 936705, i64 936727, i64 936754}
!15 = !{i64 932358, i64 932387}
!16 = !{i64 931138}
