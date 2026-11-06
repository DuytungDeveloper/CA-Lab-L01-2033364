# ==============================================================================
# BÀI 1: KHAI BÁO MẢNG 5 PHẦN TỬ, KIỂM TRA CHIA HẾT CHO 4 VÀ LÀM TRÒN GẦN NHẤT
# (LAB 2: BRANCHES AND PROCEDURES - CÓ BẮT NGOẠI LỆ TOÀN DIỆN & TEST SUITE)
# ==============================================================================
#
# YÊU CẦU ĐỀ BÀI (LAB 2 - EXERCISE 1):
# 1. Khai báo một mảng số nguyên gồm 5 phần tử với dữ liệu nhập từ bàn phím.
# 2. Kiểm tra xem từng phần tử trong mảng có chia hết cho 4 hay không.
# 3. Nếu không chia hết cho 4, đổi phần tử đó thành số chia hết cho 4 gần nó nhất
#    (nếu cách đều hai bên thì ưu tiên làm tròn xuống).
#    Ví dụ:
#      - 35 -> 36 (gần 36 hơn 32 => chọn 36)
#      - 34 -> 32 (cách đều 32 và 36 => ưu tiên làm tròn xuống chọn 32)
#      - 33 -> 32 (gần 32 hơn 36 => chọn 32)
#      - 32 -> 32 (đã chia hết cho 4 => giữ nguyên)
# 4. In kết quả mảng sau khi xử lý ra màn hình terminal.
#
# ==============================================================================
# I. PHÂN TÍCH NGOẠI LỆ TOÀN DIỆN & CÁC TRƯỜNG HỢP BIÊN (EDGE CASES):
# ==============================================================================
# 1. Ngoại lệ phần tử là số âm (Negative Integers):
#    - Ví dụ: -33 -> -32; -34 -> -36; -35 -> -36.
#    - Lệnh chia `rem` trong MIPS cho phần dư cùng dấu với số bị chia (ví dụ: -34 % 4 = -2).
#    - Giải pháp: Chuẩn hóa phần dư bằng cách cộng thêm 4 (`addi $t2, $t2, 4` khi `rem < 0`),
#      đưa toàn bộ số dư về đoạn chuẩn [0, 3] của số học đồng dư.
#    - Khi đó quy tắc làm tròn xuống trên trục số thực được áp dụng đồng nhất:
#      -34 cách đều -36 và -32 cùng 2 đơn vị, ưu tiên làm tròn xuống (chọn số nhỏ hơn) => -36!
#
# 2. Trường hợp phần tử bằng 0 (Zero):
#    - 0 chia hết cho 4 (0 % 4 = 0). Thuật toán giữ nguyên giá trị 0.
#
# 3. Trường hợp tất cả các phần tử đều đã chia hết cho 4:
#    - Ví dụ: `[0, 4, 8, 12, 16]`. Mảng giữ nguyên không thay đổi giá trị nào.
#
# 4. Ngoại lệ tràn số cực đại 32-bit (INT_MAX Overflow):
#    - Giá trị lớn nhất của số nguyên 32-bit có dấu là INT_MAX = 2,147,483,647 (chia 4 dư 3).
#    - Khi làm tròn lên (cộng 1), giá trị trở thành 2,147,483,648 vượt quá giới hạn 32-bit có dấu,
#      gây ra lỗi phần cứng (Hardware Exception: Arithmetic Overflow).
#    - Giải pháp: Chặn trước bằng `bgt $t1, 2147483644, error_overflow` và báo lỗi an toàn.
#
# 5. Ngoại lệ nhập dữ liệu từ bàn phím:
#    - MARS Kernel quản lý `syscall 5` (`read_int`), tự động bắt lỗi nếu nhập chữ hoặc vượt 32-bit.
#
# ==============================================================================
# II. BẢNG BỘ TEST CASE KIỂM THỬ TOÀN DIỆN (TEST SUITE):
# ==============================================================================
# +-------+---------------------------+-----------------------------------+-----------------------------------+
# | STT   | Mục đích kiểm thử         | Dữ liệu đầu vào (5 phần tử)       | Kết quả mong đợi (Expected Output)|
# +-------+---------------------------+-----------------------------------+-----------------------------------+
# | TC01  | Ví dụ đề bài              | 35, 34, 33, 32, 36                | Modified array: 36 32 32 32 36    |
# | TC02  | Toàn bộ là bội số của 4   | 0, 4, 8, 12, 16                   | Modified array: 0 4 8 12 16       |
# | TC03  | Dải số âm & tròn xuống    | -35, -34, -33, -32, -4            | Modified array: -36 -36 -32 -32 -4|
# | TC04  | Hỗn hợp âm dương & số 0   | 1, 2, 3, -1, -2                   | Modified array: 0 0 4 0 -4        |
# | TC05  | Ngoại lệ tràn số INT_MAX  | 2147483647, 4, 8, 12, 16          | Error: Arithmetic overflow! Ele...|
# +-------+---------------------------+-----------------------------------+-----------------------------------+
#
# ==============================================================================
# III. CODE TƯƠNG ĐƯƠNG TRONG C:
# ==============================================================================
#   #include <stdio.h>
#   int main() {
#       int arr[5];
#       for (int i = 0; i < 5; i++) {
#           printf("Please input element %d: ", i);
#           scanf("%d", &arr[i]);
#       }
#       for (int i = 0; i < 5; i++) {
#           int r = arr[i] % 4;
#           if (r < 0) r += 4;      // Chuẩn hóa số dư về [0, 3] cho số âm
#           if (r == 1) arr[i] -= 1;
#           else if (r == 2) arr[i] -= 2;
#           else if (r == 3) arr[i] += 1;
#       }
#       printf("Modified array: ");
#       for (int i = 0; i < 5; i++) printf("%d ", arr[i]);
#       printf("\n");
#       return 0;
#   }
#
# ==============================================================================
# IV. QUY ƯỚC THANH GHI:
# ==============================================================================
#   - $s0 : Địa chỉ cơ sở của mảng `array` trong bộ nhớ RAM
#   - $s1 : Số lượng phần tử của mảng (hằng số N = 5)
#   - $s2 : Biến đếm vòng lặp i (chạy từ 0 đến 4)
#   - $t0 : Địa chỉ ô nhớ của phần tử hiện tại (&arr[i] = base + i * 4)
#   - $t1 : Giá trị của phần tử hiện tại arr[i]
#   - $t2 : Số dư r sau phép chia 4 (r = arr[i] % 4)
#   - $t3 : Thanh ghi tạm dùng để so sánh số dư
# ==============================================================================

.data
    .align 2
    array:          .space 20               # Cấp phát 20 bytes trong RAM cho 5 số nguyên (5 * 4 bytes)
    prompt_elem:    .asciiz "Please input element "
    colon_space:    .asciiz ": "
    msg_result:     .asciiz "Modified array: "
    space:          .asciiz " "
    newline:        .asciiz "\n"
    err_ovf:        .asciiz "Error: Arithmetic overflow! Element exceeds 32-bit signed integer limit when rounding up.\n"

.text
.globl main

main:
    # --------------------------------------------------------------------------
    # BƯỚC 1: Khởi tạo các thanh ghi ban đầu
    # --------------------------------------------------------------------------
    la   $s0, array             # Nạp địa chỉ bắt đầu của mảng array vào thanh ghi $s0
    li   $s1, 5                 # Nạp số lượng phần tử N = 5 vào thanh ghi $s1
    li   $s2, 0                 # Khởi tạo biến đếm vòng lặp i = 0 vào thanh ghi $s2

    # --------------------------------------------------------------------------
    # BƯỚC 2: Vòng lặp nhập 5 phần tử từ bàn phím
    # --------------------------------------------------------------------------
input_loop:
    bge  $s2, $s1, process_start# Nếu i >= 5 (đã nhập đủ 5 phần tử) thì nhảy sang bước xử lý

    # In câu nhắc: "Please input element "
    li   $v0, 4                 # Syscall 4: Chức năng in chuỗi ký tự (print_string)
    la   $a0, prompt_elem       # Nạp địa chỉ chuỗi prompt_elem vào $a0
    syscall                     # Thực hiện syscall in chuỗi

    # In chỉ số i hiện tại
    li   $v0, 1                 # Syscall 1: Chức năng in số nguyên (print_int)
    move $a0, $s2               # Sao chép giá trị chỉ số i ($s2) vào $a0 để in
    syscall                     # Thực hiện syscall in số nguyên

    # In dấu hai chấm và khoảng cách: ": "
    li   $v0, 4                 # Syscall 4: Chức năng in chuỗi ký tự (print_string)
    la   $a0, colon_space       # Nạp địa chỉ chuỗi colon_space vào $a0
    syscall                     # Thực hiện syscall in chuỗi

    # Đọc số nguyên do người dùng nhập từ bàn phím
    li   $v0, 5                 # Syscall 5: Chức năng đọc số nguyên từ bàn phím (read_int)
    syscall                     # Chờ người dùng nhập số và nhấn Enter, giá trị lưu vào $v0
    move $t1, $v0               # Chuyển số vừa nhập từ $v0 sang thanh ghi tạm $t1

    # Tính toán địa chỉ bộ nhớ và lưu phần tử vào mảng: arr[i] = $t1
    sll  $t0, $s2, 2            # $t0 = i * 4 (dịch trái 2 bit tương đương nhân 4 vì mỗi int = 4 bytes)
    add  $t0, $s0, $t0          # $t0 = địa chỉ cơ sở ($s0) + độ dời (i * 4) = &arr[i]
    sw   $t1, 0($t0)            # Ghi giá trị trong $t1 vào ô nhớ RAM tại địa chỉ $t0

    # Tăng biến đếm vòng lặp và quay lại đầu vòng lặp nhập
    addi $s2, $s2, 1            # i = i + 1 (tăng biến đếm lên 1)
    j    input_loop             # Nhảy không điều kiện quay lại nhãn input_loop để nhập số tiếp theo

    # --------------------------------------------------------------------------
    # BƯỚC 3: Vòng lặp kiểm tra và làm tròn từng phần tử theo quy tắc
    # --------------------------------------------------------------------------
process_start:
    li   $s2, 0                 # Đặt lại biến đếm i = 0 để bắt đầu duyệt mảng từ đầu

process_loop:
    bge  $s2, $s1, print_start  # Nếu i >= 5 (đã duyệt hết 5 phần tử) thì nhảy sang bước in kết quả

    # Đọc giá trị phần tử arr[i] từ bộ nhớ RAM ra thanh ghi
    sll  $t0, $s2, 2            # $t0 = i * 4 (tính độ dời byte của phần tử thứ i)
    add  $t0, $s0, $t0          # $t0 = &arr[i] (địa chỉ chính xác của ô nhớ trong RAM)
    lw   $t1, 0($t0)            # Đọc 1 từ nhớ (word 32-bit) từ địa chỉ $t0 nạp vào $t1

    # Tính phần dư khi chia cho 4: r = arr[i] % 4
    rem  $t2, $t1, 4            # Lấy phần dư của $t1 chia cho 4, kết quả lưu vào $t2

    # Chuẩn hóa số dư nếu r âm (áp dụng an toàn cho cả trường hợp số nguyên âm)
    bgez $t2, check_rules       # Nếu r >= 0 thì nhảy thẳng đến kiểm tra quy tắc làm tròn
    addi $t2, $t2, 4            # Nếu r < 0 thì r = r + 4 để đưa về dải chuẩn [0, 3]

check_rules:
    # Trường hợp 1: r == 0 (Số đã chia hết cho 4)
    beqz $t2, next_element      # Nếu r == 0 thì giữ nguyên giá trị, nhảy sang phần tử tiếp theo

    # Trường hợp 2: r == 1 (Khoảng cách tới bội dưới là 1, tới bội trên là 3 => chọn bội dưới)
    li   $t3, 1                 # Nạp hằng số 1 vào thanh ghi tạm $t3 để so sánh
    beq  $t2, $t3, case_sub_1   # Nếu r == 1 thì nhảy tới nhãn case_sub_1 để trừ đi 1

    # Trường hợp 3: r == 2 (Cách đều cả 2 bên 2 đơn vị => ưu tiên làm tròn xuống)
    li   $t3, 2                 # Nạp hằng số 2 vào thanh ghi tạm $t3 để so sánh
    beq  $t2, $t3, case_sub_2   # Nếu r == 2 thì nhảy tới nhãn case_sub_2 để trừ đi 2

    # Trường hợp 4: r == 3 (Khoảng cách tới bội trên là 1, tới bội dưới là 3 => chọn bội trên)
    li   $t3, 2147483644
    bgt  $t1, $t3, error_overflow # Nếu $t1 > 2,147,483,644 (tức 2,147,483,647) làm tròn lên sẽ tràn 32-bit!
    addi $t1, $t1, 1            # Làm tròn lên bội số trên: $t1 = $t1 + 1
    j    save_and_next          # Nhảy đến bước lưu giá trị mới vào mảng

case_sub_1:
    addi $t1, $t1, -1           # Làm tròn xuống bội số dưới: $t1 = $t1 - 1
    j    save_and_next          # Nhảy đến bước lưu giá trị mới vào mảng

case_sub_2:
    addi $t1, $t1, -2           # Làm tròn xuống bội số dưới: $t1 = $t1 - 2 (ưu tiên làm tròn xuống)

save_and_next:
    # Ghi đè giá trị mới đã được làm tròn vào đúng vị trí ô nhớ arr[i] trong RAM
    sw   $t1, 0($t0)            # Lưu giá trị mới trong $t1 vào ô nhớ RAM tại địa chỉ $t0

next_element:
    addi $s2, $s2, 1            # i = i + 1 (chuyển sang phần tử tiếp theo)
    j    process_loop           # Lặp lại quá trình kiểm tra cho phần tử kế tiếp

    # --------------------------------------------------------------------------
    # BƯỚC 4: In mảng kết quả sau khi làm tròn ra màn hình terminal
    # --------------------------------------------------------------------------
print_start:
    # In chuỗi tiêu đề kết quả: "Modified array: "
    li   $v0, 4                 # Syscall 4: Chức năng in chuỗi ký tự (print_string)
    la   $a0, msg_result        # Nạp địa chỉ chuỗi msg_result vào $a0
    syscall                     # Thực hiện syscall in chuỗi

    li   $s2, 0                 # Đặt lại biến đếm i = 0 để duyệt mảng in từng số

print_loop:
    bge  $s2, $s1, program_exit # Nếu i >= 5 (đã in đủ 5 số) thì nhảy đến kết thúc chương trình

    # Đọc giá trị arr[i] từ RAM để in ra
    sll  $t0, $s2, 2            # $t0 = i * 4 (tính độ dời byte)
    add  $t0, $s0, $t0          # $t0 = &arr[i] (địa chỉ ô nhớ)
    lw   $a0, 0($t0)            # Nạp giá trị arr[i] từ RAM vào $a0 làm tham số cho syscall

    # In giá trị số nguyên arr[i]
    li   $v0, 1                 # Syscall 1: Chức năng in số nguyên (print_int)
    syscall                     # Thực hiện syscall in số nguyên

    # In khoảng trắng phân cách giữa các số
    li   $v0, 4                 # Syscall 4: Chức năng in chuỗi ký tự (print_string)
    la   $a0, space             # Nạp địa chỉ chuỗi dấu cách " " vào $a0
    syscall                     # Thực hiện syscall in dấu cách

    addi $s2, $s2, 1            # i = i + 1 (tăng biến đếm để in số tiếp theo)
    j    print_loop             # Lặp lại bước in cho phần tử kế tiếp

    # --------------------------------------------------------------------------
    # BƯỚC 5: Xuống dòng và kết thúc chương trình an toàn
    # --------------------------------------------------------------------------
program_exit:
    li   $v0, 4                 # Syscall 4: Chức năng in chuỗi ký tự (print_string)
    la   $a0, newline           # Nạp địa chỉ chuỗi xuống dòng "\n" vào $a0
    syscall                     # Thực hiện syscall in ký tự xuống dòng

    li   $v0, 10                # Syscall 10: Chức năng kết thúc chương trình (exit)
    syscall                     # Gọi hệ điều hành kết thúc thực thi chương trình an toàn

# ------------------------------------------------------------------------------
# XỬ LÝ NGOẠI LỆ: Khi phần tử vượt giới hạn 32-bit có dấu khi làm tròn lên
# ------------------------------------------------------------------------------
error_overflow:
    li   $v0, 4                 # Syscall 4: In chuỗi ký tự
    la   $a0, err_ovf           # Nạp chuỗi thông báo lỗi tràn số
    syscall                     # Thực hiện in thông báo lỗi

    li   $v0, 10                # Syscall 10: Thoát chương trình
    syscall                     # Dừng chương trình ngay lập tức
