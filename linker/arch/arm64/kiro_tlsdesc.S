/*
 * Copyright (C) 2026 KiroOS
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <private/bionic_asm.h>

// KiroOS: resolver of R_AARCH64_TLSDESC descriptors (dynamic ELF TLS, see linker.cpp).
//
// Called by the code that reads a thread_local with x0 = the descriptor {resolver, arg}.
// Returns in x0 the variable's offset from the thread pointer (TPIDR_EL0). The TLSDESC call
// convention lets it clobber only x0 and the flags (and x30, the call itself), so every other
// register the C helper could touch is saved: x1-x18 and q0-q31.
ENTRY_PRIVATE(kiro_tlsdesc_resolver)
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    sub     sp, sp, #656
    stp     x1, x2, [sp, #0]
    stp     x3, x4, [sp, #16]
    stp     x5, x6, [sp, #32]
    stp     x7, x8, [sp, #48]
    stp     x9, x10, [sp, #64]
    stp     x11, x12, [sp, #80]
    stp     x13, x14, [sp, #96]
    stp     x15, x16, [sp, #112]
    stp     x17, x18, [sp, #128]
    stp     q0, q1, [sp, #144]
    stp     q2, q3, [sp, #176]
    stp     q4, q5, [sp, #208]
    stp     q6, q7, [sp, #240]
    stp     q8, q9, [sp, #272]
    stp     q10, q11, [sp, #304]
    stp     q12, q13, [sp, #336]
    stp     q14, q15, [sp, #368]
    stp     q16, q17, [sp, #400]
    stp     q18, q19, [sp, #432]
    stp     q20, q21, [sp, #464]
    stp     q22, q23, [sp, #496]
    stp     q24, q25, [sp, #528]
    stp     q26, q27, [sp, #560]
    stp     q28, q29, [sp, #592]
    stp     q30, q31, [sp, #624]

    ldr     x0, [x0, #8]            // the descriptor's KiroTlsArg
    bl      kiro_tls_get_addr       // address of the variable for this thread
    mrs     x1, tpidr_el0
    sub     x0, x0, x1

    ldp     q30, q31, [sp, #624]
    ldp     q28, q29, [sp, #592]
    ldp     q26, q27, [sp, #560]
    ldp     q24, q25, [sp, #528]
    ldp     q22, q23, [sp, #496]
    ldp     q20, q21, [sp, #464]
    ldp     q18, q19, [sp, #432]
    ldp     q16, q17, [sp, #400]
    ldp     q14, q15, [sp, #368]
    ldp     q12, q13, [sp, #336]
    ldp     q10, q11, [sp, #304]
    ldp     q8, q9, [sp, #272]
    ldp     q6, q7, [sp, #240]
    ldp     q4, q5, [sp, #208]
    ldp     q2, q3, [sp, #176]
    ldp     q0, q1, [sp, #144]
    ldp     x17, x18, [sp, #128]
    ldp     x15, x16, [sp, #112]
    ldp     x13, x14, [sp, #96]
    ldp     x11, x12, [sp, #80]
    ldp     x9, x10, [sp, #64]
    ldp     x7, x8, [sp, #48]
    ldp     x5, x6, [sp, #32]
    ldp     x3, x4, [sp, #16]
    ldp     x1, x2, [sp, #0]
    add     sp, sp, #656
    ldp     x29, x30, [sp], #16
    ret
END(kiro_tlsdesc_resolver)
