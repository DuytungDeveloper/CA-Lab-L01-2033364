# ==============================================================================
# BÀI 2: TÌM ƯỚC CHUNG LỚN NHẤT (GCD) VÀ BỘI CHUNG NHỎ NHẤT (LCM) BẰNG VÒNG LẶP
# (LAB 2: BRANCHES AND PROCEDURES - CÓ BẮT NGOẠI LỆ TOÀN DIỆN & TEST SUITE)
# ==============================================================================
#
# YÊU CẦU ĐỀ BÀI (LAB 2 - EXERCISE 2):
# - Nhập 2 số nguyên dương a và b từ bàn phím.
# - Bắt buộc kiểm tra điều kiện xem a và b có phải là số dương hay không (a > 0, b > 0).
# - Tính và in ra Ước số chung lớn nhất (GCD) và Bội số chung nhỏ nhất (LCM).
# - Câu nhắc nhập dữ liệu: "a = " và "b = ".
# - Định dạng kết quả mẫu: Nếu a = 6, b = 45 -> "GCD=3, LCM=90".
#
# - Phương pháp giải quyết: Sử dụng thuật toán Euclid dạng vòng lặp (Iterative Euclidean
#   Algorithm) dưới dạng thủ tục lá (Leaf Procedure), tối ưu tốc độ và bộ nhớ.
#
# ==============================================================================
# I. PHÂN TÍCH NGOẠI LỆ TOÀN DIỆN & CÁC TRƯỜNG HỢP BIÊN (EDGE CASES):
# ==============================================================================
# 1. Ngoại lệ a <= 0 hoặc b <= 0 (Đề bài yêu cầu bắt buộc kiểm tra):
#    - Người dùng nhập số 0: GCD(0, 0) không xác định và gây lỗi chia cho 0 khi tính LCM.
#    - Người dùng nhập số âm (ví dụ: a = -6 hoặc b = -45): Không thỏa tính chất số nguyên dương.
#    - Giải pháp: Dùng `blez $s0, error_input` và `blez $s1, error_input` để chặn ngay sau khi nhập.
#      In thông báo: "Error: Both a and b must be positive integers (> 0)!\n" và dừng an toàn.
#
# 2. Trường hợp hai số nguyên tố cùng nhau (Co-prime numbers):
#    - Ví dụ: a = 7, b = 13 => GCD = 1, LCM = 7 * 13 = 91. Dừng tại b = 0, trả về GCD = 1.
#
# 3. Trường hợp a chia hết cho b hoặc b chia hết cho a:
#    - Ví dụ: a = 20, b = 5 => GCD = 5, LCM = 20.
#
# 4. Trường hợp a == b:
#    - Ví dụ: a = 15, b = 15 => GCD = 15, LCM = 15.
#
# 5. Trường hợp a = 1 hoặc b = 1:
#    - Ví dụ: a = 1, b = 100 => GCD = 1, LCM = 100.
#
# 6. Tránh & Bắt ngoại lệ tràn số 32-bit khi tính LCM:
#    - Công thức chuẩn: LCM = (a / GCD) * b (chia trước rồi nhân để tránh tích a * b vượt 32-bit).
#    - Ngoại lệ: Nếu (a / GCD) * b > 2^31 - 1 (ví dụ: a = 100000, b = 99999, GCD = 1 -> LCM ~ 10^10),
#      lệnh `mult` sinh ra phần cao tại thanh ghi HI khác 0 hoặc làm lật bit dấu LO sang âm.
#    - Giải pháp: Dùng `mult $t0, $s1`, kiểm tra `bnez $t5, error_lcm_ovf` và `bltz $s3, error_lcm_ovf`.
#      Báo lỗi: "Error: Arithmetic overflow! LCM value exceeds 32-bit signed integer limit.\n"
#
# ==============================================================================
# II. BẢNG BỘ TEST CASE KIỂM THỬ TOÀN DIỆN (TEST SUITE):
# ==============================================================================
# +-------+---------------------------+-------------------+---------------------------------------------------+
# | STT   | Mục đích kiểm thử         | Dữ liệu vào (a, b)| Kết quả mong đợi (Expected Output)                |
# +-------+---------------------------+-------------------+---------------------------------------------------+
# | TC01  | Ví dụ đề bài              | a = 6, b = 45     | GCD=3, LCM=90                                     |
# | TC02  | a chia hết cho b          | a = 20, b = 5     | GCD=5, LCM=20                                     |
# | TC03  | Hai số nguyên tố cùng nhau| a = 7, b = 13     | GCD=1, LCM=91                                     |
# | TC04  | Hai số bằng nhau          | a = 15, b = 15    | GCD=15, LCM=15                                    |
# | TC05  | Biên có số 1              | a = 1, b = 100    | GCD=1, LCM=100                                    |
# | TC06  | Ngoại lệ a <= 0           | a = 0, b = 10     | Error: Both a and b must be positive integers...  |
# | TC07  | Ngoại lệ b <= 0           | a = 10, b = -5    | Error: Both a and b must be positive integers...  |
# | TC08  | Ngoại lệ tràn số LCM      | a=100000, b=99999 | Error: Arithmetic overflow! LCM value exceeds...  |
# +-------+---------------------------+-------------------+---------------------------------------------------+
#
# ==============================================================================
# III. CODE TƯƠNG ĐƯƠNG TRONG C:
# ==============================================================================
#   #include <stdio.h>
#
#   int gcd(int a, int b) {
#       while (b != 0) {
#           int r = a % b;
#           a = b;
#           b = r;
#       }
#       return a;
#   }
#
#   int main() {
#       int a, b;
#       printf("a = "); scanf("%d", &a);
#       printf("b = "); scanf("%d", &b);
#
#       // Bắt ngoại lệ nếu a <= 0 hoặc b <= 0
#       if (a <= 0 || b <= 0) {
#           printf("Error: Both a and b must be positive integers (> 0)!\n");
#           return 1;
#       }
#
#       int g = gcd(a, b);
#       // Bắt ngoại lệ tràn số khi tính LCM
#       long long l = (long long)(a / g) * b;
#       if (l > 2147483647) {
#           printf("Error: Arithmetic overflow! LCM value exceeds 32-bit signed integer limit.\n");
#           return 1;
#       }
#
#       printf("GCD=%d, LCM=%d\n", g, (int)l);
#       return 0;
#   }
#
# ==============================================================================
# IV. QUY ƯỚC THANH GHI:
# ==============================================================================
#   - $s0 : Lưu số nguyên dương a người dùng nhập
#   - $s1 : Lưu số nguyên dương b người dùng nhập
#   - $s2 : Lưu kết quả Ước chung lớn nhất GCD(a, b)
#   - $s3 : Lưu kết quả Bội chung nhỏ nhất LCM(a, b)
#   - $a0, $a1 : Hai tham số truyền vào thủ tục gcd (lần lượt là a và b)
#   - $v0 : Giá trị kết quả trả về từ thủ tục gcd
# ==============================================================================

.data
    prompt_a:       .asciiz "a = "
    prompt_b:       .asciiz "b = "
    msg_gcd:        .asciiz "GCD="
    msg_comma_lcm:  .asciiz ", LCM="
    newline:        .asciiz "\n"
    err_msg:        .asciiz "Error: Both a and b must be positive integers (> 0)!\n"
    err_ovf:        .asciiz "Error: Arithmetic overflow! LCM value exceeds 32-bit signed integer limit.\n"

.text
.globl main

main:
    # --------------------------------------------------------------------------
    # BƯỚC 1: In câu nhắc và nhập số nguyên a từ bàn phím
    # --------------------------------------------------------------------------
    li   $v0, 4                 # Syscall 4: Chức năng in chuỗi ký tự (print_string)
    la   $a0, prompt_a          # Nạp địa chỉ của chuỗi "a = " vào $a0
    syscall                     # Gọi hệ điều hành thực hiện in chuỗi "a = "

    li   $v0, 5                 # Syscall 5: Chức năng đọc số nguyên từ bàn phím (read_int)
    syscall                     # Chờ người dùng nhập số a và nhấn Enter, kết quả lưu vào $v0
    move $s0, $v0               # Sao chép giá trị số a từ $v0 vào thanh ghi an toàn $s0

    # --------------------------------------------------------------------------
    # BƯỚC 2: In câu nhắc và nhập số nguyên b từ bàn phím
    # --------------------------------------------------------------------------
    li   $v0, 4                 # Syscall 4: Chức năng in chuỗi ký tự (print_string)
    la   $a0, prompt_b          # Nạp địa chỉ của chuỗi "b = " vào $a0
    syscall                     # Gọi hệ điều hành thực hiện in chuỗi "b = "

    li   $v0, 5                 # Syscall 5: Chức năng đọc số nguyên từ bàn phím (read_int)
    syscall                     # Chờ người dùng nhập số b và nhấn Enter, kết quả lưu vào $v0
    move $s1, $v0               # Sao chép giá trị số b từ $v0 vào thanh ghi an toàn $s1

    # --------------------------------------------------------------------------
    # BƯỚC 3: BẮT NGOẠI LỆ - Kiểm tra điều kiện số nguyên dương (a > 0 và b > 0)
    # --------------------------------------------------------------------------
    blez $s0, error_input       # Nếu a <= 0 thì rẽ nhánh tới nhãn error_input báo lỗi
    blez $s1, error_input       # Nếu b <= 0 thì rẽ nhánh tới nhãn error_input báo lỗi

    # --------------------------------------------------------------------------
    # BƯỚC 4: Chuẩn bị đối số và gọi thủ tục tính GCD(a, b) bằng vòng lặp
    # --------------------------------------------------------------------------
    move $a0, $s0               # Nạp đối số thứ nhất cho hàm: $a0 = a
    move $a1, $s1               # Nạp đối số thứ hai cho hàm:  $a1 = b
    jal  gcd                    # Gọi thủ tục gcd (Jump and Link, lưu địa chỉ vào $ra)
    move $s2, $v0               # Lưu kết quả GCD trả về từ $v0 vào thanh ghi an toàn $s2

    # --------------------------------------------------------------------------
    # BƯỚC 5: Tính Bội chung nhỏ nhất LCM = (a / GCD) * b & Kiểm tra tràn số 32-bit
    # --------------------------------------------------------------------------
    div  $s0, $s2               # Thực hiện phép chia số học: a chia cho GCD ($s0 / $s2)
    mflo $t0                    # Lấy phần thương (quotient = a / GCD) từ thanh ghi LO lưu vào $t0
    mult $t0, $s1               # Nhân thương với b: LO = 32-bit thấp, HI = 32-bit cao
    mfhi $t5                    # Nạp 32-bit cao vào $t5
    mflo $s3                    # Nạp 32-bit thấp vào $s3 (giá trị LCM dự kiến)
    bnez $t5, error_lcm_ovf     # Nếu 32-bit cao khác 0 -> Tràn số dương 32-bit!
    bltz $s3, error_lcm_ovf     # Nếu bit dấu bị lật âm -> Tràn số 32-bit có dấu!

    # --------------------------------------------------------------------------
    # BƯỚC 6: In kết quả theo đúng định dạng mẫu: "GCD=3, LCM=90"
    # --------------------------------------------------------------------------
    # In chuỗi "GCD="
    li   $v0, 4                 # Syscall 4: Chức năng in chuỗi ký tự (print_string)
    la   $a0, msg_gcd           # Nạp địa chỉ chuỗi "GCD=" vào $a0
    syscall                     # Thực hiện syscall in chuỗi

    # In giá trị GCD tính được
    li   $v0, 1                 # Syscall 1: Chức năng in số nguyên (print_int)
    move $a0, $s2               # Chuyển giá trị GCD ($s2) vào $a0 để in
    syscall                     # Thực hiện syscall in số nguyên

    # In chuỗi ", LCM="
    li   $v0, 4                 # Syscall 4: Chức năng in chuỗi ký tự (print_string)
    la   $a0, msg_comma_lcm     # Nạp địa chỉ chuỗi ", LCM=" vào $a0
    syscall                     # Thực hiện syscall in chuỗi

    # In giá trị LCM tính được
    li   $v0, 1                 # Syscall 1: Chức năng in số nguyên (print_int)
    move $a0, $s3               # Chuyển giá trị LCM ($s3) vào $a0 để in
    syscall                     # Thực hiện syscall in số nguyên

    # In ký tự xuống dòng "\n"
    li   $v0, 4                 # Syscall 4: Chức năng in chuỗi ký tự (print_string)
    la   $a0, newline           # Nạp địa chỉ chuỗi "\n" vào $a0
    syscall                     # Thực hiện syscall in ký tự xuống dòng

    # Kết thúc chương trình bình thường
    li   $v0, 10                # Syscall 10: Thoát chương trình (exit)
    syscall                     # Gọi hệ điều hành dừng thực thi an toàn

# ------------------------------------------------------------------------------
# XỬ LÝ NGOẠI LỆ 1: Khi a hoặc b không phải là số dương (a <= 0 hoặc b <= 0)
# ------------------------------------------------------------------------------
error_input:
    li   $v0, 4                 # Syscall 4: Chức năng in chuỗi ký tự (print_string)
    la   $a0, err_msg           # Nạp địa chỉ thông báo lỗi vào $a0
    syscall                     # Thực hiện syscall in thông báo lỗi

    li   $v0, 10                # Syscall 10: Thoát chương trình (exit)
    syscall                     # Dừng chương trình ngay lập tức

# ------------------------------------------------------------------------------
# XỬ LÝ NGOẠI LỆ 2: Khi tích LCM vượt quá giới hạn 32-bit có dấu
# ------------------------------------------------------------------------------
error_lcm_ovf:
    li   $v0, 4                 # Syscall 4: In chuỗi ký tự
    la   $a0, err_ovf           # Nạp thông báo lỗi tràn số LCM
    syscall                     # Thực hiện syscall in thông báo

    li   $v0, 10                # Syscall 10: Thoát chương trình
    syscall                     # Dừng chương trình ngay lập tức

# ==============================================================================
# THỦ TỤC TÍNH GCD BẰNG VÒNG LẶP (ITERATIVE PROCEDURE - LEAF PROCEDURE): gcd
# - Đầu vào: $a0 = a, $a1 = b
# - Đầu ra:  $v0 = GCD(a, b)
# - Thuật toán Euclid dạng lặp:
#     while (b != 0) {
#         int r = a % b;
#         a = b;
#         b = r;
#     }
#     return a;
# - Ưu điểm: Là thủ tục lá (Leaf Procedure), không gọi hàm khác bên trong nên
#   KHÔNG CẦN dùng Stack, không tốn chi phí bộ nhớ, code cực kỳ gọn nhẹ và an toàn.
# ==============================================================================
gcd:
gcd_loop:
    beqz $a1, gcd_done          # Nếu b == 0 thì kết thúc vòng lặp, kết quả là a
    rem  $t0, $a0, $a1          # $t0 = a % b
    move $a0, $a1               # a mới = b
    move $a1, $t0               # b mới = a % b
    j    gcd_loop               # Lặp lại bước chia lấy dư

gcd_done:
    move $v0, $a0               # Trả về kết quả GCD = a trong thanh ghi $v0
    jr   $ra                    # Quay về hàm gọi main
