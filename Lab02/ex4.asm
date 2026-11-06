# ==============================================================================
# BÀI 4: TÍNH GIAI THỪA BẰNG THỦ TỤC ĐỆ QUY (RECURSIVE FACTORIAL)
# (LAB 2: BRANCHES AND PROCEDURES - CÓ BẮT NGOẠI LỆ TOÀN DIỆN & TEST SUITE)
# ==============================================================================
#
# YÊU CẦU ĐỀ BÀI (LAB 2 - EXERCISE 4):
# - Nhận vào một số nguyên không âm N từ người dùng (N >= 0).
# - Bắt buộc kiểm tra tính hợp lệ của số nhập vào (bắt ngoại lệ số âm N < 0).
# - Tính và in ra giá trị giai thừa (N!) của số đó vào màn hình terminal.
# - Định dạng kết quả mẫu:
#     + Nếu người dùng nhập 5  -> Đầu ra là: 120
#     + Nếu người dùng nhập -2 -> Đầu ra là: A factorial for your number can not be found.
#
# ==============================================================================
# I. PHÂN TÍCH NGOẠI LỆ TOÀN DIỆN & CÁC TRƯỜNG HỢP BIÊN (EDGE CASES):
# ==============================================================================
# 1. Ngoại lệ người dùng nhập số âm (N < 0):
#    - Đề bài quy định cụ thể: "If the user input -2, the output should be A factorial
#      for your number can not be found."
#    - Giải pháp: Dùng `bltz $s0, error_neg` để rẽ nhánh ngay sau khi nhập và in thông báo lỗi.
#
# 2. Ngoại lệ tràn số nguyên 32-bit có dấu khi N > 12:
#    - 12! = 479,001,600 <= 2^31 - 1 (2,147,483,647 - giới hạn dương 32-bit).
#    - 13! = 6,227,020,800 > 2^31 - 1 => Gây tràn số có dấu (Signed Integer Overflow).
#    - Giải pháp: Dùng `bgt $s0, 12, error_ovf` để chặn trước khi gọi đệ quy, in cảnh báo tràn số.
#
# 3. Các trường hợp biên cơ sở (Base Cases):
#    - N = 0: Theo toán học 0! = 1.
#    - N = 1: 1! = 1.
#    - Cả 2 trường hợp đều được xử lý chuẩn xác qua điều kiện dừng `ble $a0, 1, fact_base`.
#
# ==============================================================================
# II. BẢNG BỘ TEST CASE KIỂM THỬ TOÀN DIỆN (TEST SUITE):
# ==============================================================================
# +-------+---------------------------+---------------+-------------------------------------------------------------+
# | STT   | Mục đích kiểm thử         | Dữ liệu vào N | Kết quả mong đợi (Expected Output)                          |
# +-------+---------------------------+---------------+-------------------------------------------------------------+
# | TC01  | Ví dụ đề bài (số dương)   | 5             | 120                                                         |
# | TC02  | Ví dụ đề bài (ngoại lệ âm)| -2            | A factorial for your number can not be found.               |
# | TC03  | Biên cơ sở 0!             | 0             | 1                                                           |
# | TC04  | Biên cơ sở 1!             | 1             | 1                                                           |
# | TC05  | Biên cực đại 32-bit (12!) | 12            | 479001600                                                   |
# | TC06  | Ngoại lệ tràn số (N = 13) | 13            | Error: Input exceeds 32-bit signed integer limit...         |
# +-------+---------------------------+---------------+-------------------------------------------------------------+
#
# ==============================================================================
# III. CODE TƯƠNG ĐƯƠNG TRONG C:
# ==============================================================================
#   #include <stdio.h>
#
#   int factorial(int n) {
#       if (n <= 1) return 1;
#       return n * factorial(n - 1);
#   }
#
#   int main() {
#       int n;
#       printf("Please enter a non-negative integer: ");
#       scanf("%d", &n);
#
#       // Bắt ngoại lệ số âm
#       if (n < 0) {
#           printf("A factorial for your number can not be found.\n");
#           return 1;
#       }
#
#       // Bắt ngoại lệ tràn số 32-bit (N > 12)
#       if (n > 12) {
#           printf("Error: Input exceeds 32-bit limit (N <= 12)!\n");
#           return 1;
#       }
#
#       printf("%d\n", factorial(n));
#       return 0;
#   }
#
# ==============================================================================
# IV. QUY ƯỚC THANH GHI:
# ==============================================================================
#   - $s0 : Lưu số nguyên N người dùng nhập từ bàn phím
#   - $s1 : Lưu kết quả giai thừa N! nhận được từ hàm
#   - $a0 : Tham số truyền vào hàm đệ quy factorial (giá trị n)
#   - $v0 : Kết quả trả về từ hàm đệ quy factorial (n!)
#   - $sp : Con trỏ ngăn xếp Stack Pointer (dùng để lưu trữ $ra và $a0)
#   - $ra : Địa chỉ trở về Return Address
# ==============================================================================

.data
    prompt:         .asciiz "Please enter a non-negative integer: "
    err_negative:   .asciiz "A factorial for your number can not be found.\n"
    err_overflow:   .asciiz "Error: Input exceeds 32-bit signed integer limit (Max N = 12; 12! = 479,001,600)!\n"
    newline:        .asciiz "\n"

.text
.globl main

main:
    # --------------------------------------------------------------------------
    # BƯỚC 1: In câu nhắc và đọc số nguyên N từ bàn phím
    # --------------------------------------------------------------------------
    li   $v0, 4                 # Syscall 4: Chức năng in chuỗi ký tự (print_string)
    la   $a0, prompt            # Nạp địa chỉ của chuỗi prompt vào $a0
    syscall                     # Gọi hệ điều hành thực hiện in câu nhắc nhập số

    li   $v0, 5                 # Syscall 5: Chức năng đọc số nguyên từ bàn phím (read_int)
    syscall                     # Chờ người dùng nhập số N và nhấn Enter, kết quả lưu vào $v0
    move $s0, $v0               # Sao chép số N vừa nhập từ $v0 sang thanh ghi an toàn $s0

    # --------------------------------------------------------------------------
    # BƯỚC 2: BẮT NGOẠI LỆ
    # --------------------------------------------------------------------------
    # Ngoại lệ 1: Kiểm tra xem N có phải là số âm hay không (N < 0)
    bltz $s0, error_neg         # Nếu N < 0 thì rẽ nhánh tới nhãn error_neg xử lý lỗi

    # Ngoại lệ 2: Kiểm tra tràn số 32-bit có dấu khi N > 12 (vì 13! vượt quá 2^31 - 1)
    li   $t9, 12                # Nạp cận trên số nguyên 32-bit an toàn (12) vào $t9
    bgt  $s0, $t9, error_ovf    # Nếu N > 12 thì rẽ nhánh tới nhãn error_ovf báo lỗi

    # --------------------------------------------------------------------------
    # BƯỚC 3: Gọi thủ tục đệ quy tính giai thừa N!
    # --------------------------------------------------------------------------
    move $a0, $s0               # Nạp đối số cho hàm đệ quy: $a0 = N
    jal  factorial              # Gọi hàm đệ quy factorial (Jump and Link, lưu địa chỉ vào $ra)
    move $s1, $v0               # Sao chép kết quả giai thừa tính được từ $v0 sang $s1

    # --------------------------------------------------------------------------
    # BƯỚC 4: In kết quả giai thừa ra màn hình terminal
    # --------------------------------------------------------------------------
    li   $v0, 1                 # Syscall 1: Chức năng in số nguyên (print_int)
    move $a0, $s1               # Nạp kết quả giai thừa ($s1) vào $a0 để in
    syscall                     # Thực hiện syscall in kết quả

    # In ký tự xuống dòng "\n"
    li   $v0, 4                 # Syscall 4: Chức năng in chuỗi ký tự (print_string)
    la   $a0, newline           # Nạp địa chỉ chuỗi newline vào $a0
    syscall                     # Thực hiện syscall in ký tự xuống dòng

    # Kết thúc chương trình bình thường
    li   $v0, 10                # Syscall 10: Chức năng kết thúc chương trình (exit)
    syscall                     # Gọi hệ điều hành dừng thực thi an toàn

# ------------------------------------------------------------------------------
# XỬ LÝ NGOẠI LỆ 1: Khi người dùng nhập số âm (N < 0)
# ------------------------------------------------------------------------------
error_neg:
    li   $v0, 4                 # Syscall 4: In chuỗi ký tự
    la   $a0, err_negative      # Nạp chuỗi: "A factorial for your number can not be found."
    syscall                     # Thực hiện in thông báo lỗi

    li   $v0, 10                # Syscall 10: Thoát chương trình
    syscall                     # Dừng chương trình ngay lập tức

# ------------------------------------------------------------------------------
# XỬ LÝ NGOẠI LỆ 2: Khi N > 12 gây tràn số 32-bit có dấu
# ------------------------------------------------------------------------------
error_ovf:
    li   $v0, 4                 # Syscall 4: In chuỗi ký tự
    la   $a0, err_overflow      # Nạp chuỗi thông báo lỗi tràn số
    syscall                     # Thực hiện in thông báo lỗi

    li   $v0, 10                # Syscall 10: Thoát chương trình
    syscall                     # Dừng chương trình ngay lập tức

# ==============================================================================
# THỦ TỤC ĐỆ QUY (RECURSIVE PROCEDURE): factorial
# - Đầu vào: $a0 = n
# - Đầu ra:  $v0 = n!
# - Thuật toán:
#     if (n <= 1) return 1;
#     else return n * factorial(n - 1);
# ==============================================================================
factorial:
    # 1. Điều kiện dừng (Base Case): Nếu n <= 1 (tức n = 0 hoặc n = 1) thì trả về 1
    ble  $a0, 1, fact_base      # Nếu n <= 1 thì nhảy tới nhãn fact_base

    # 2. Cất giữ thanh ghi vào ngăn xếp Stack trước khi gọi đệ quy lồng nhau
    addi $sp, $sp, -8           # Cấp phát 8 bytes trên đỉnh ngăn xếp Stack
    sw   $ra, 4($sp)            # Lưu địa chỉ trở về $ra vào ô nhớ 4($sp)
    sw   $a0, 0($sp)            # Lưu giá trị đối số n ($a0) hiện tại vào ô nhớ 0($sp)

    # 3. Chuẩn bị đối số n - 1 và thực hiện lời gọi đệ quy
    addi $a0, $a0, -1           # Giảm n đi 1 đơn vị ($a0 = n - 1)
    jal  factorial              # Gọi đệ quy factorial(n - 1), kết quả (n - 1)! lưu trong $v0

    # 4. Phục hồi lại các giá trị đã lưu từ ngăn xếp Stack
    lw   $a0, 0($sp)            # Rút lại giá trị n ban đầu từ ô nhớ 0($sp) vào $a0
    lw   $ra, 4($sp)            # Rút lại địa chỉ trở về ban đầu từ ô nhớ 4($sp) vào $ra
    addi $sp, $sp, 8            # Giải phóng 8 bytes bộ nhớ ngăn xếp Stack

    # 5. Thực hiện phép nhân kết quả: n! = n * (n - 1)!
    mul  $v0, $a0, $v0          # $v0 = n * (n - 1)! = n!
    jr   $ra                    # Nhảy về địa chỉ trong $ra để quay lại hàm cha

fact_base:
    li   $v0, 1                 # Với n <= 1, kết quả giai thừa bằng 1 ($v0 = 1)
    jr   $ra                    # Trả về kết quả ngay lập tức cho hàm gọi
