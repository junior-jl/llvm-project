; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 3
; RUN: llc -mtriple=i686-windows-msvc < %s | FileCheck %s

@type_info = external global ptr

; FIXME: This is a miscompile.
define void @pr66984(ptr %arg) personality ptr @__CxxFrameHandler3 {
; CHECK-LABEL: pr66984:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    pushl %ebp
; CHECK-NEXT:    movl %esp, %ebp
; CHECK-NEXT:    pushl %ebx
; CHECK-NEXT:    pushl %edi
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    subl $20, %esp
; CHECK-NEXT:    movl %esp, -28(%ebp)
; CHECK-NEXT:    movl $-1, -16(%ebp)
; CHECK-NEXT:    leal -24(%ebp), %eax
; CHECK-NEXT:    movl $___ehhandler$pr66984, -20(%ebp)
; CHECK-NEXT:    movl %fs:0, %ecx
; CHECK-NEXT:    movl %ecx, -24(%ebp)
; CHECK-NEXT:    movl %eax, %fs:0
; CHECK-NEXT:    movl $1, -16(%ebp)
; CHECK-NEXT:    calll _throw
; CHECK-NEXT:  # %bb.1: # %bb14
; CHECK-NEXT:  LBB0_3: # Block address taken
; CHECK-NEXT:    # %bb17
; CHECK-NEXT:    addl $12, %ebp
; CHECK-NEXT:    jmp LBB0_4
; CHECK-NEXT:  LBB0_4: # %exit
; CHECK-NEXT:  $ehgcr_0_4:
; CHECK-NEXT:    movl -24(%ebp), %eax
; CHECK-NEXT:    movl %eax, %fs:0
; CHECK-NEXT:    addl $20, %esp
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    popl %edi
; CHECK-NEXT:    popl %ebx
; CHECK-NEXT:    popl %ebp
; CHECK-NEXT:    retl
; CHECK-NEXT:    .def "?catch$2@?0?pr66984@4HA";
; CHECK-NEXT:    .scl 3;
; CHECK-NEXT:    .type 32;
; CHECK-NEXT:    .endef
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  "?catch$2@?0?pr66984@4HA":
; CHECK-NEXT:  LBB0_2: # %bb17
; CHECK-NEXT:    pushl %ebp
; CHECK-NEXT:    addl $12, %ebp
; CHECK-NEXT:    movl %esp, -28(%ebp)
; CHECK-NEXT:    movl -32(%ebp), %ecx
; CHECK-NEXT:    movl $2, -16(%ebp)
; CHECK-NEXT:    calll _cleanup
; CHECK-NEXT:    movl $LBB0_3, %eax
; CHECK-NEXT:    popl %ebp
; CHECK-NEXT:    retl # CATCHRET
; CHECK-NEXT:    .def "?dtor$5@?0?pr66984@4HA";
; CHECK-NEXT:    .scl 3;
; CHECK-NEXT:    .type 32;
; CHECK-NEXT:    .endef
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  "?dtor$5@?0?pr66984@4HA":
; CHECK-NEXT:  LBB0_5: # %bb8
; CHECK-NEXT:    pushl %ebp
; CHECK-NEXT:    addl $12, %ebp
; CHECK-NEXT:    movl 8(%ebp), %eax
; CHECK-NEXT:    movl %eax, -32(%ebp)
; CHECK-NEXT:    leal -32(%ebp), %ecx
; CHECK-NEXT:    calll _foo
; CHECK-NEXT:    popl %ebp
; CHECK-NEXT:    retl # CLEANUPRET
; CHECK-NEXT:  Lfunc_end0:
bb:
  %a1 = alloca ptr, align 4
  %a2 = alloca ptr, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %a2)
  invoke void @throw()
          to label %bb14 unwind label %bb8

bb8:                                              ; preds = %bb7
  %i9 = cleanuppad within none []
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %a1)
  store ptr %arg, ptr %a1, align 4
  call fastcc void @foo(ptr %a1) [ "funclet"(token %i9) ]
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %a1)
  cleanupret from %i9 unwind label %bb15

bb14:                                             ; preds = %bb7
  unreachable

bb15:                                             ; preds = %bb13, %bb5
  %cs = catchswitch within none [label %bb17] unwind to caller

bb17:                                             ; preds = %bb15
  %cp = catchpad within %cs [ptr @type_info, i32 8, ptr %a2]
  %p = load ptr, ptr %a2, align 4
  call fastcc void @cleanup(ptr %p) [ "funclet"(token %cp) ]
  catchret from %cp to label %exit

exit:
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %a2)
  ret void
}

declare i32 @__CxxFrameHandler3(...)
declare void @throw()
declare void @cleanup(ptr)
declare void @foo(ptr)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture)
